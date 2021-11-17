local Array = require("AlgoLua.Libs.lockbox.util.array")
local Stream = require("AlgoLua.Libs.lockbox.util.stream")
local CBCMode = require("AlgoLua.Libs.lockbox.cipher.mode.cbc")
local ZeroPadding = require("AlgoLua.Libs.lockbox.padding.zero")
local AES256Cipher = require("AlgoLua.Libs.lockbox.cipher.aes256")
local uuid = require("AlgoLua.Libs.uuid4")

local QRCode = require("AlgoLua.WalletConnect.QRCode")
local ws = require("AlgoLua.WalletConnect.ws")

local Client = {
	connected = false,
	encrypt = function() end,
	decript = function() end,
	session_request = function() end,
}

function Client.encrypt(data, key, iv)

	local v = {
		cipher = CBCMode.Cipher,
		decipher = CBCMode.Decipher,
		key = key,
		iv = iv,
		plaintext = Array.fromString(data),
		padding = ZeroPadding
	}

	local cipher = v.cipher()
		.setKey(v.key)
		.setBlockCipher(AES256Cipher)
		.setPadding(v.padding);

	local cipherOutput = cipher
		.init()
		.update(Stream.fromArray(v.iv))
		.update(Stream.fromArray(v.plaintext))
		.finish()
		.asHex();

	pprint("cipher", cipher.plaintext)
	pprint("cipherOutput", cipherOutput)

	local decipher = v.decipher()
		.setKey(v.key)
		.setBlockCipher(AES256Cipher)
		.setPadding(v.padding);

	local plainOutput = decipher
		.init()
		.update(Stream.fromArray(v.iv))
		.update(Stream.fromHex(cipherOutput))
		.finish()
		.asHex();

	pprint("plainOutput", plainOutput, Array.toString(Array.fromHex(plainOutput)))

	return {
		topic = "4d42e6c0-7ad8-480d-9e10-e008760c6fa9",
		data = cipherOutput,
		hmac = "343c040f569d03c2090643acd34efd5aa4f6c0b61c92d857b1ab44234d5834a3",
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

function Client.connect(callback)
	ws.init()

	ws.on_connect(function (conn, data)
		pprint('connected', conn, data)

		Client.connected = true

		callback(data)
	end)
end

function Client.session_request()
	pprint(uuid.getUUID())

	QRCode.draw("wc:4d42e6c0-7ad8-480d-9e10-e008760c6fa9@1?bridge=https%3A%2F%2Fa.bridge.walletconnect.org&key=2d0d25ec40fb96b79d467ac69fbaf439e18b0c12bfd2be717f75d43ca8fe7ce4")

	local encrypted = Client.encrypt(
		'{"id":1637087444670564,"jsonrpc":"2.0","method":"wc_sessionRequest","params":[{"peerId":"50b146a8-2a23-4416-be58-80cf8568ade5","peerMeta":{"description":"","url":"http://localhost:3000","icons":["http://localhost:3000/favicon.ico"],"name":"My Little Test"},"chainId":4160}]}',
		{45,13,37,236,64,251,150,183,157,70,122,198,159,186,244,57,225,139,12,18,191,210,190,113,127,117,212,60,168,254,124,228}, -- 2d0d25ec40fb96b79d467ac69fbaf439e18b0c12bfd2be717f75d43ca8fe7ce4
		{211,158,249,156,16,181,15,195,189,216,207,52,109,37,46,191} -- 9cca65374fae4a4681a6ec610888b8c5
	)

	local req = [[{"topic":"]] .. encrypted.topic .. [[","type":"pub","payload":"{\"data\":\"]] .. encrypted.data .. [[\",\"hmac\":\"]] .. encrypted.hmac .. [[\",\"iv\":\"]] .. encrypted.iv .. [[\"}","silent":true}]]
	pprint('wallet_connect_request()', req)
	ws.send(req)

	ws.send('{"topic":"50b146a8-2a23-4416-be58-80cf8568ade5","type":"sub","payload":"","silent":true}')
end

return Client