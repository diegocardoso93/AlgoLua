qrencode = require("AlgoLua.Libs.qrcode.qrencode")

local QRCode = {}

local function matrix_to_string(tab, padding,padding_char,white_pixel, black_pixel)
	local padding_string
	local str_tab = {} -- hold each row of the qr code in a cell

	-- Add (padding) blank columns at the left of the matrix
	-- (left of each row string), inserting an extra (padding)
	-- rows at the top and bottom
	padding_string = string.rep(padding_char,padding)
	for i=1,#tab + 2*padding do
		str_tab[i] = padding_string
	end

	for x=1,#tab do
		for y=1,#tab do
			if tab[x][y] > 0 then
				-- using y + padding because we added (padding) blank columns at the left for each string in str_tab array
				str_tab[y + padding] = str_tab[y + padding] .. black_pixel
			elseif tab[x][y] < 0 then
				str_tab[y + padding] = str_tab[y + padding] .. white_pixel
			else
				str_tab[y + padding] = str_tab[y + padding] .. " X"
			end
		end
	end

	padding_string = string.rep(padding_char,#tab)
	for i=1,padding do
		-- fills in padding rows at top of matrix
		str_tab[i] =  str_tab[i] .. padding_string
		-- fills in padding rows at bottom of matrix
		str_tab[#tab + padding + i] =  str_tab[#tab + padding + i] .. padding_string
	end

	-- Add (padding) blank columns to right of matrix (to the end of each row string)
	padding_string = string.rep(padding_char,padding)
	for i=1,#tab + 2*padding do
		str_tab[i] = str_tab[i] .. padding_string
	end

	return str_tab
end

function draw(uri)
	local ok, tab = qrencode.qrcode(uri)

	if not ok then
		print(ok, tab)
	else
		local rows
		rows = matrix_to_string(tab,1,"#","#"," ")
		for i=0,#rows do
			msg.post("#qrcode", "draw_square", {data = rows[#rows-i], x = 0, y = i*10})
		end
	end
end

QRCode.draw = draw

return QRCode