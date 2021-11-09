
function HttpClientAdapter(full_url, method, callback, request_headers, request_json, options)

	-- Defold
	if http and http.request then
		http.request(
			full_url,
			method,
			callback,
			request_headers,
			request_json,
			{} -- options
		)
	else
	-- Löve
		local _,ltn12 = pcall(require, "ltn12")
		local _,http = pcall(require, "socket.http")
		if http then
			local res = {}
			r, c, h, s = http.request {
				method = method,
				url = full_url,
				headers = request_headers,
				sink = ltn12.sink.table(res)
			}
			local response = {
				status = c,
				response = table.concat(res)
			}
			callback(nil, nil, response)
		end
	end
end

return HttpClientAdapter