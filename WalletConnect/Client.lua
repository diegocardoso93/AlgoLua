local Array = require("AlgoLua.Libs.lockbox.util.array")
local Stream = require("AlgoLua.Libs.lockbox.util.stream")
local CBCMode = require("AlgoLua.Libs.lockbox.cipher.mode.cbc")
local PKCS7Padding = require("AlgoLua.Libs.lockbox.padding.pkcs7")
local ZeroPadding = require("AlgoLua.Libs.lockbox.padding.zero")
local AES256Cipher = require("AlgoLua.Libs.lockbox.cipher.aes256")
local UUID = require("AlgoLua.Libs.uuid4")
local HMAC = require("AlgoLua.Libs.lockbox.mac.hmac")
local SHA2_256 = require("AlgoLua.Libs.lockbox.digest.sha2_256")

local QRCode = require("AlgoLua.WalletConnect.QRCode")
local ws = require("AlgoLua.WalletConnect.ws")

local Client = {
	connected = false,
	encrypt = function() end,
	decript = function() end,
	session_request = function() end,
	app = {},
}

function Client.encrypt(data, key, iv)
	local v = {
		cipher = CBCMode.Cipher,
		decipher = CBCMode.Decipher,
		key = key,
		iv = iv,
		plaintext = Array.fromString(data),
		padding = PKCS7Padding,
		hmac = HMAC
	}

	local cipher = v.cipher()
		.setKey(v.key)
		.setBlockCipher(AES256Cipher)
		.setPadding(v.padding);

	local cipherText = cipher
		.init()
		.update(Stream.fromArray(v.iv))
		.update(Stream.fromArray(v.plaintext))
		.finish()
		.asHex();

	local unsigned = Array.concat(Array.fromHex(cipherText), v.iv)

	local hmac = v.hmac()
		.setKey(key)
		.setDigest(SHA2_256)
		.init()
		.update(Stream.fromArray(unsigned))
		.finish()
		.asHex();

	return {
		data = cipherText,
		hmac = hmac,
		iv = Array.toHex(v.iv)
	}
end

function Client.decrypt(data, key, iv)
	local v = {
		cipher = CBCMode.Cipher,
		decipher = CBCMode.Decipher,
		key = key,
		iv = iv,
		padding = ZeroPadding
	}

	local decipher = v.decipher()
		.setKey(v.key)
		.setBlockCipher(AES256Cipher)
		.setPadding(v.padding);

	local plainOutput = decipher
		.init()
		.update(Stream.fromHex(v.iv))
		.update(Stream.fromHex(data))
		.finish()
		.asHex();

	pprint("plainOutput", Array.toString(Array.fromHex(plainOutput)))
end

function Client.connect(callback, app)
	Client.app = {
		name = app.name,
		description = app.description,
		url = app.url,
		icon = app.icon
	}

	ws.init()

	ws.on_connect(function (conn, data)
		pprint('connected', conn, data)

		Client.connected = true

		callback(data)
	end)
end

function Client.random_hex(length)
	local res = ""
	for i = 1, length do
		local char = math.random(48, 62)
		res = res .. string.char(char < 58 and char or char+40)
	end
	return res
end

function Client.payload_id()
	local date = os.time(os.date("!*t")) * math.pow(10, 3)
	local extra = math.floor(math.random() * math.pow(10, 3))
	return date + extra
end

function Client.session_request()
	local pub_topic = UUID.getUUID():lower()
	local sub_topic = UUID.getUUID():lower()
	local key = Client.random_hex(64)
	local iv = Client.random_hex(32)

	QRCode.draw("wc:" .. pub_topic .. "@1?bridge=https%3A%2F%2Fc.bridge.walletconnect.org&key=" .. key)

	local app = Client.app

	local encrypted = Client.encrypt(
	'{"id":' .. Client.payload_id() .. ',"jsonrpc":"2.0","method":"wc_sessionRequest","params":[{"peerId":"' .. sub_topic .. '","peerMeta":{"description":"' .. app.description .. '","url":"' .. app.url .. '","icons":["' .. app.icon .. '"],"name":"' .. app.name .. '"},"chainId":null}]}',
		Array.fromHex(key),
		Array.fromHex(iv)
	)

	local req = [[{"topic":"]] .. pub_topic .. [[","type":"pub","payload":"{\"data\":\"]] .. encrypted.data .. [[\",\"hmac\":\"]] .. encrypted.hmac .. [[\",\"iv\":\"]] .. encrypted.iv .. [[\"}","silent":true}]]
	pprint('wallet_connect_request()', req)
	ws.send(req)

	ws.send('{"topic":"' .. sub_topic .. '","type":"sub","payload":"","silent":true}')
end

return Client