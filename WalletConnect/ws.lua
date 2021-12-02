local json = require("AlgoLua.Libs.json")

local ws = {
	connection = nil,
	_on_connect_callback = function() end,
	_on_message_callback = function() end
}

if websocket then -- Defold

	local function websocket_callback(self, conn, data)
		pprint("socket message: ", data, conn)
		ws.connection = conn
		if data.event == websocket.EVENT_DISCONNECTED then
			pprint("Disconnected")
			ws.connection = nil
		elseif data.event == websocket.EVENT_CONNECTED then
			pprint("Connected")
			ws._on_connect_callback(conn, data)
		elseif data.event == websocket.EVENT_ERROR then
			pprint("Error: '" .. data.message .. "'")
		elseif data.event == websocket.EVENT_MESSAGE then
			pprint("Receiving: '" .. data.message .. "'")
			ws._on_message_callback(conn, data.message)
		end
	end

	function ws.init()
		ws.url = "wss://c.bridge.walletconnect.org/?env=browser&host=localhost%3A3000&protocol=wc&version=1";
		local params = {
			timeout = 300000
		}
		ws.connection = websocket.connect(ws.url, params, websocket_callback)
	end

	function ws.finalize()
		if ws.connection ~= nil then
			websocket.disconnect(connection)
		end
	end

	function ws.on_connect(callback)
		ws._on_connect_callback = callback
	end

	function ws.on_message(callback)
		ws._on_message_callback = callback
	end

	function ws.send(data)
		websocket.send(ws.connection, data)
	end

else -- Solar2D

	function ws.init()
		ws.url = "wss://c.bridge.walletconnect.org/?env=browser&host=localhost%3A3000&protocol=wc&version=1";

		local WebSockets = require("plugin.websockets")

		ws.connection = WebSockets.new()
		local wsock = ws.connection

		local function ws_handler(event)
			local etype = event.type

			if etype == wsock.ONOPEN then
				ws._on_connect_callback()
			elseif etype == wsock.ONMESSAGE then
				local msg = event.data
				print('message', msg)
				ws._on_message_callback(nil, event.data)
			elseif etype == wsock.ONCLOSE then
				pprint("Disconnected")
				wsock = nil
			elseif etype == wsock.ONERROR then
				pprint("Error", event.code, event.reason)
			end
		end

		wsock:addEventListener(wsock.WSEVENT, ws_handler)
		wsock:connect(ws.url)
	end

	function ws.on_connect(callback)
		ws._on_connect_callback = callback
	end

	function ws.on_message(callback)
		ws._on_message_callback = callback
	end

	function ws.send(data)
		ws.connection:send(data)
	end

end

return ws