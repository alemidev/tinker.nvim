--[[
                                                                                   
           GJ5GPP#           ####              ██████╗ ██╗██╗  ██╗███████╗         
           5:. !5          #^!??7B             ██╔══██╗██║██║ ██╔╝██╔════╝         
              !Y ###########7^                 ██████╔╝██║█████╔╝ █████╗           
              G ~J?JJJJJJJJJJ^?                ██╔══██╗██║██╔═██╗ ██╔══╝           
             #^!:#           G 5               ██████╔╝██║██║  ██╗███████╗         
    #G5JJ?JJ5:?@J:         #?7J.JJ?JJYPB       ╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝         
  #?!JPBB##G.~77B!!      #J~!7??.B##BGY7!P                                         
 P:Y#      ^?  P:J:Y    5~J~J#  ?7      B~!     * simple statusbar for             
B.G       ~7    #.Y.G G!?#~?     ~Y       ~7       when you'd rather               
J:       7.YYY55G:!?.7!B #.B     #~B      P.       use something you               
P.#      BBGGPPPY 7Y7P    :Y       #      7^       can fix yourself                
 ?^B           #~7        G:5            J:B                                       
  P~7P##    #P?~5          B!!YB#    #BY~7#     * by alemidev <me@alemi.dev>       
    GJ?7???7?JG              BY?7???77?5#                                          
        ###                      ####           * inspired by airline, but         
                                                   straight and simpler            
]]--

--- global statusline object
local STATUSLINE = {
	mode_string = {
		['n' ] = 'NORMAL',
		['no'] = 'NORMAL op',
		['v' ] = 'VISUAL',
		['V' ] = 'V LINE',
		[''] = 'V BLOCK',
		['s' ] = 'SELECT',
		['S' ] = 'S LINE',
		[''] = 'S BLOCK',
		['i' ] = 'INSERT',
		['R' ] = 'REPLACE',
		['Rv'] = 'V REPLACE',
		['c' ] = 'CMD',
		['cv'] = 'VIM EX',
		['ce'] = 'EX',
		['r' ] = 'PROMPT',
		['rm'] = 'MORE',
		['r?'] = 'CONFIRM',
		['!' ] = 'SHELL',
		['t' ] = 'TERMINAL',
	},
	mode_highlight = {
		['n' ] = '%#NormalMode#',
		['no'] = '%#NormalMode#',
		['v' ] = '%#VisualMode#',
		['V' ] = '%#VisualMode#',
		[''] = '%#VisualMode#',
		['s' ] = '%#VisualMode#',
		['S' ] = '%#VisualMode#',
		[''] = '%#VisualMode#',
		['i' ] = '%#InsertMode#',
		['R' ] = '%#InsertMode#',
		['Rv'] = '%#InsertMode#',
		['c' ] = '%#SpecialMode#',
		['cv'] = '%#SpecialMode#',
		['ce'] = '%#SpecialMode#',
		['r' ] = '%#SpecialMode#',
		['rm'] = '%#SpecialMode#',
		['r?'] = '%#SpecialMode#',
		['!' ] = '%#SpecialMode#',
		['t' ] = '%#SpecialMode#'
	},
}

function STATUSLINE:linter()
	local n_warns = 0
	local warns = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	if warns ~= nil then n_warns = #warns end

	local n_errors = 0
	local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	if errors ~= nil then n_errors = #errors end

	if n_warns == 0 and n_errors == 0 then
		return 'OK'
	else
		return string.format("%dE %dW", n_errors, n_warns)
	end
end

function STATUSLINE:combo()
	if vim.g.combo ~= nil then
		return vim.g.combo
	end
	return ""
end

function STATUSLINE:git()
	if vim.fn['fugitive#Head']() ~= nil then
		return vim.fn['fugitive#Head']()
	else
		return ""
	end
end

function STATUSLINE:lsp()
	local clients = vim.lsp.buf_get_clients(0)
	if #clients > 0 then
		local client_names = {}
		for _, client in pairs(clients) do
			client_names[#client_names+1] = client.name
		end
		return "[" .. table.concat(client_names, ",") .. "]"
	else
		return ""
	end
end

function STATUSLINE:display()
	local mode = vim.fn.mode()
	local line = {
		self.mode_highlight[mode] .. " " .. self.mode_string[mode],
		"%#StatusLineBlock# %Y",
		"%{v:lua.statusline.combo()}",
		"%{v:lua.statusline.linter()}",
		"%#StatusLine#",
		"%{v:lua.statusline.git()}",
		"%r%h%w%m %<%F ",
		"%=", -- change alignment
		"%{v:lua.statusline.lsp()}",
		"%{&fileencoding?&fileencoding:&encoding}",
		"%{&fileformat}",
		"%#StatusLineBlock# %3l:%-3c %3p%%",
		self.mode_highlight[mode] .. " %n " .. "%0*"
	}
	return table.concat(line, " ")
end

return STATUSLINE
