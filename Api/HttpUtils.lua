local HttpUtils = {}

local function stringify(params, sep, eq)
	if not sep then sep = '&' end
	if not eq then eq = '=' end
	if type(params) == "table" then
		local fields = {}
		for key,value in pairs(params) do
			local keyString = tostring(key) .. eq
			if type(value) == "table" then
				for _, v in ipairs(value) do
					table.insert(fields, keyString .. tostring(v))
				end
			else
				table.insert(fields, keyString .. tostring(value))
			end
		end
		return table.concat(fields, sep)
	end
	return ''
end

function HttpUtils.query_string(params)
	return stringify(params)
end

return HttpUtils
