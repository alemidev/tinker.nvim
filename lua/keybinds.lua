--[[
                       &&&                                                                                                
                    &##&                                                         █████╗ ██╗     ███████╗███╗   ███╗██╗    
                  &##&                                                          ██╔══██╗██║     ██╔════╝████╗ ████║██║    
                 BB&                                                            ███████║██║     █████╗  ██╔████╔██║██║    
               &GB                                     &                        ██╔══██║██║     ██╔══╝  ██║╚██╔╝██║██║    
              &GB                                     &BGBBBBBBBB###&           ██║  ██║███████╗███████╗██║ ╚═╝ ██║██║    
              GG                                       &GGGGGGGGGGGGGB#&        ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝    
             #P#                                        &&#BGGGGGGGGGGG#                     nvim keybinds                
             BP&                                           &GGGGGGGGGB#                                                   
         &#BGPP&                                         &#BGGGGGGGB#           * keybinds are scoped in methods and      
     &#BGGGGGPP&                                     &&#BGGGGGGB##&                only enabled if the relevant plugin    
  &#GPPPGGGGGBPB                                &&##BGGGGGBB#&&                    is loaded                              
 #PPPPPPPGGPG BP&                        &&##BBGGGGGGBB#&&                      * binds are kinda arbitrary, if you       
 PPPPPPPPPPPPGBPG&&&       &&&&&&###BBBGGGGGGGBB##&&                               have good suggestions tell me          
 &BGPPPPPPPPPPPPPPGGGGGGGGGGGGGGGGGGGBBB##&&&                                      about it <me@alemi.dev>                
    &&##BBBBGGGGGGGPGBBBBBB####&&&&                                                                                       
                  &#B#&                                                                                                   
               &&    ###&                                                                                                 
              &G#      &&#&&&                                                                                             
                             &&&                                                                                          
]]--

local KEYBINDS = {
	foldcolumn = false,
}

--|| GLOBAL KEYBINDS
function KEYBINDS:set_global_keys(opts)
	-- Quick settings
	vim.keymap.set('n', '<F10>', ':set hls!<CR>', opts)
	vim.keymap.set('n', '<F9>',  ':set wrap!<CR>', opts)
	vim.keymap.set('n', '<F8>',  ':set list!<CR>', opts)
	vim.keymap.set('n', '<F7>',  ':set spell!<CR>', opts)
	vim.keymap.set('n', '<F6>',  ':Hexmode<CR>', opts)
	vim.keymap.set('n', '<F5>',  ':Telescope oldfiles<CR>', opts)
	-- Files navigation
	vim.keymap.set('n', '<C-S-t>', ':tabnew<CR>', opts)
	vim.keymap.set('n', '<M-t>', ':tabnew<CR>', opts) -- fallback for windows
	vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>', {noremap=true})
	-- Esc goes back to normal mode in terminal
	vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', opts)

	vim.keymap.set('n', 'zi', function()
		if self.foldcolumn then
			vim.opt.foldcolumn = '0'
		else
			vim.opt.foldcolumn = '2'
		end
		self.foldcolumn = not self.foldcolumn
	end)
end

function KEYBINDS:set_navigation_keys(opts)
	-- lazy arrow scrolling
	vim.keymap.set('n', '<S-Up>', '<C-u>', opts)
	vim.keymap.set('n', '<S-Down>', '<C-d>', opts)
	vim.keymap.set('n', '<C-Up>', '<C-y>', opts)
	vim.keymap.set('n', '<C-Down>', '<C-e>', opts)
	vim.keymap.set('n', '<M-Up>', ':resize +1<CR>', opts)
	vim.keymap.set('n', '<M-Down>', ':resize -1<CR>', opts)
	vim.keymap.set('n', '<M-Right>', ':vertical resize +1<CR>', opts)
	vim.keymap.set('n', '<M-Left>', ':vertical resize -1<CR>', opts)
end

function KEYBINDS:set_lsp_keys(opts)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(opts.buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- Enable Lsp tagfunc
	vim.api.nvim_buf_set_option(opts.buffer, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<C-Space>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<C-x>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<M-a>', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<M-f>', vim.lsp.buf.formatting, opts)
	vim.keymap.set('n', '<C-DEL>', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<M-x>', vim.diagnostic.open_float, opts) -- fallback for windows
	-- It's not really a keybind but whatever
	vim.api.nvim_create_user_command('Format', ':lua vim.lsp.buf.formatting()<CR>', {}) -- TODO if function is passed directly, it doesn't work!
end

function KEYBINDS:set_telescope_keys(opts)
	-- File navigation
	vim.keymap.set('n', '<C-f>', ':Telescope find_files<CR>', opts)
	vim.keymap.set('n', 'F', ':Telescope find_files<CR>', opts) -- fallback for windows
	vim.keymap.set('n', '<C-,>', ':Telescope live_grep<CR>', opts)
	vim.keymap.set('n', '<M-,>', ':Telescope live_grep<CR>', opts) -- fallback for windows
	vim.keymap.set('n', '<C-[>', ':Telescope lsp_references<CR>', opts)
	vim.keymap.set('n', '<C-;>', ':Telescope git_bcommits<CR>', opts)
	vim.keymap.set('n', '<M-;>', ':Telescope git_bcommits<CR>', opts) -- fallback for windows
	-- Marks and buffers with telescope
	vim.keymap.set('n', '<C-End>', ':Telescope buffers<CR>', opts)
	vim.keymap.set('n', '<C-\'>', ':Telescope marks<CR>', opts)
	vim.keymap.set('n', '<M-\'>', ':Telescope marks<CR>', opts) -- fallback for windows
	vim.keymap.set('n', '<C-/>', ':Telescope current_buffer_fuzzy_find<CR>', opts)
	vim.keymap.set('n', '<M-/>', ':Telescope current_buffer_fuzzy_find<CR>', opts) -- fallback for windows
	-- Symbols with telescope
	vim.keymap.set('n', '<C-\\>', ':Telescope lsp_document_symbols<CR>', opts)
	vim.keymap.set('n', '<C-CR>', ':Telescope lsp_workspace_symbols<CR>', opts)
	vim.keymap.set('n', '<NL>', ':Telescope lsp_workspace_symbols<CR>', opts) -- fallback for windows
	-- Error list with telescope
	vim.keymap.set('n', '<C-PageUp>', ':Telescope diagnostics<CR>', opts)
	vim.keymap.set('n', '<C-PageDown>', ':Telescope diagnostics bufnr=0<CR>', opts)
end

return KEYBINDS
