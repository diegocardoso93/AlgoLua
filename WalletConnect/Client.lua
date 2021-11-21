local Array = require("AlgoLua.Libs.lockbox.util.array")
local Stream = require("AlgoLua.Libs.lockbox.util.stream")
local CBCMode = require("AlgoLua.Libs.lockbox.cipher.mode.cbc")
local PKCS7Padding = require("AlgoLua.Libs.lockbox.padding.pkcs7")
local ZeroPadding = require("AlgoLua.Libs.lockbox.padding.zero")
local AES256Cipher = require("AlgoLua.Libs.lockbox.cipher.aes256")
local UUID = require("AlgoLua.Libs.uuid4")
local HMAC = require("AlgoLua.Libs.lockbox.mac.hmac")
local SHA2_256 = require("AlgoLua.Libs.lockbox.digest.sha2_256")
local json = require("AlgoLua.Libs.json")

local QRCode = require("AlgoLua.WalletConnect.QRCode")
local ws = require("AlgoLua.WalletConnect.ws")
local http_client = require("AlgoLua.Api.HttpClient")

local Client = {
	connected = false,
	key = nil,
	app = {},
	session_topic = nil,
	encrypt = function() end,
	decript = function() end,
	session_request = function() end,
	network = 'testnet', -- testnet | mainnet,

	connection = nil,
	qrcode = nil,
	account = nil
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
		.update(Stream.fromArray(v.iv))
		.update(Stream.fromArray(data))
		.finish()
		.asHex();

	local jsonString = Client.remove_padding(Array.toString(Array.fromHex(plainOutput)))

	return json.decode(jsonString)
end

function Client.remove_padding(jsonString)
	return string.gsub(jsonString, "[%z\1-\16]*", "")
end

function Client.connect(app, on_connect_callback, on_message_callback)
	Client.app = {
		name = app.name,
		description = app.description,
		url = app.url,
		icon = app.icon
	}

	ws.init()

	ws.on_connect(function (conn, data)
		Client.connected = true

		if on_connect_callback then
			on_connect_callback(message)
		end
	end)

	ws.on_message(function (conn, message)
		local message = json.decode(message)

		if Client.session_topic == message.topic then
			local payload = json.decode(message.payload)
			local decrypted = Client.decrypt(Array.fromHex(payload.data), Array.fromHex(Client.key), Array.fromHex(payload.iv))

			local result = decrypted.result
			if result.approved and result.chainId == 4160 then -- Algorand
				Client.draw_state = 'draw_connected'
				Client.connection = result
				msg.post("WalletConnect#interface", "draw_connected")

				Client.get_account(
					result.accounts[1],
					function(account)
						Client.draw_state = 'draw_balance'
						msg.post("WalletConnect#interface", "draw_balance")
					end)
			else
				pprint('canceled')
			end
		end

		if on_message_callback then
			on_message_callback(message)
		end
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

	Client.key = key

	local wcLink = "wc:" .. pub_topic .. "@1?bridge=https%3A%2F%2Fc.bridge.walletconnect.org&key=" .. key
	pprint('wcLink', wcLink)

	Client.qrcode = QRCode.draw(wcLink)
	Client.draw_state = 'draw_qrcode'
	msg.post("WalletConnect#interface", "draw_qrcode")

	local app = Client.app

	local encrypted = Client.encrypt(
		json.encode({
			id = Client.payload_id(),
			jsonrpc = '2.0',
			method = 'wc_sessionRequest',
			params = {{
				peerId = sub_topic,
				peerMeta = {
					name = app.name,
					description = app.description,
					url = app.url,
					icon = app.icon
				},
				chainId = nil
			}}
		}),
		Array.fromHex(key),
		Array.fromHex(iv)
	)

	local sessionPublish = json.encode({
		topic = pub_topic,
		type = 'pub',
		payload = json.encode({
			data = encrypted.data,
			hmac = encrypted.hmac,
			iv = encrypted.iv
		}),
		silent = true
	})

	ws.send(sessionPublish)

	local sessionSubscribe = json.encode({
		topic = sub_topic,
		type = 'sub',
		payload = '',
		silent = true
	})

	Client.session_topic = sub_topic

	ws.send(sessionSubscribe)
end

function Client.get_account(address, callback)
	network_url_part = (Client.network == 'testnet' and Client.network..'.' or '')

	local on_success = function(account)
		Client.account = account
		local balance = {}
		Client.account.balance = balance

		balance[#balance+1] = {
			['name'] = 'Algorand',
			['unit-name'] = 'ALGO',
			['decimals'] = 6,
			['amount'] = account['amount']
		}

		if #account.assets == 0 then
			callback(Client.account)
		else
			local count_assets = 1
			local on_success_asset_detail = function(asset)
				local params = asset.params

				for idx,acc_asset in pairs(account.assets) do
					if asset.index == acc_asset['asset-id'] then
						balance[#balance+1] = {
							['name'] = params['name'],
							['unit-name'] = params['unit-name'],
							['decimals'] = params['decimals'],
							['amount'] = account.assets[idx]['amount']
						}
					end
				end

				if count_assets >= #account.assets and callback then
					callback(Client.account)
				end
				count_assets = count_assets + 1
			end

			for _,asset in pairs(account.assets) do
				http_client.get('https://' .. network_url_part .. 'algoexplorerapi.io/v2/assets/' .. asset['asset-id'], {}, on_success_asset_detail, on_error)
			end
		end
	end

	http_client.get('https://' .. network_url_part .. 'algoexplorerapi.io/v2/accounts/' .. address, {}, on_success, on_error)
end

return Client