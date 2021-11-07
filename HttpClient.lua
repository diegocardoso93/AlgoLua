local HttpClient = {}

local function _catch_response(on_success, on_error)
	return function(_, _, http_response)
		if (http_response.status == 200) then
			local _, response = pcall(json.decode, http_response.response or "null")
			if (response and on_success) then
				on_success(response or nil)
			end
		elseif (on_error) then
			on_error({
				code = http_response.status,
				status = http_response.status,
				error_code = 1123,
				error = "service_unavailable",
				error_message = "Could not deserialize response from server: " .. tostring(http_response.response)
			})
		end
	end
end

function HttpClient.request(method, full_url, body, headers, on_success, on_error)
	if method ~= "GET" then
		local ok, request_json = pcall(json.encode, body)
		if not ok then
			error(request_json or "Request could not be converted to json")
		end
	end

	local request_headers = {
		["Content-Type"] = "application/json"
	}
	for k, v in pairs(headers) do request_headers[k] = v end

	http.request(
		full_url,
		method,
		_catch_response(on_success, on_error),
		request_headers,
		request_json,
		{} -- options
	)
end

function HttpClient.get(full_url, headers, on_success, on_error)
	HttpClient.request("GET", full_url, nil, headers, on_success, on_error)
end

function HttpClient.post(full_url, body, headers, on_success, on_error)
	HttpClient.request("POST", full_url, body, headers, on_success, on_error)
end

function HttpClient.delete(full_url, headers, on_success, on_error)
	HttpClient.request("DELETE", full_url, nil, headers, on_success, on_error)
end

return HttpClient
