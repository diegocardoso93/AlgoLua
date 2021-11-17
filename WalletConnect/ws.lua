local ws = {
	connection = null,
	_on_connect_callback = function() end
}

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
	end
end

function ws.init()
	ws.url = "wss://a.bridge.walletconnect.org/?env=browser&host=localhost%3A3000&protocol=wc&version=1";
	local params = {
		timeout = 300000,
		headers = "Sec-WebSocket-Protocol: chat\r\nOrigin: mydomain.com\r\n"
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

function ws.send(data)
	websocket.send(ws.connection, data)
end

return ws