local Util = {}

function Util.format_coin(str1, sep, decimals)
	if str1 == '0' then
		return '0'
	end

	local pos = #str1 - decimals
	return str1:sub(1,pos) .. sep .. str1:sub(pos+1)
end

return Util
