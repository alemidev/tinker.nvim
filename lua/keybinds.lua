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

local function wrap(func, ...)
	local args = {...}
	return function()
		func(unpack(args))
	end
end

local KEYBINDS = {
	foldcolumn = false,
}

--|| GLOBAL KEYBINDS
function KEYBINDS:set_global_keys(opts)
	-- Quick settings
	vim.keymap.set('n', '<M-h>', ':set hls!<CR>', opts)
	vim.keymap.set('n', '<M-w>', ':set wrap!<CR>', opts)
	vim.keymap.set('n', '<M-l>', ':set list!<CR>', opts)
	vim.keymap.set('n', '<M-s>', ':set spell!<CR>', opts)
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
	vim.keymap.set('n', '<M-p>', ':ClangdSwitchSourceHeader<CR>', {})
end

function KEYBINDS:set_telescope_keys(opts)
	local telescope = require('telescope.builtin')
	local theme = require('telescope.themes')
	-- File navigation
	vim.keymap.set('n', '<C-ESC>', wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts)
	vim.keymap.set('n', '<M-!>',   wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts) -- fallback for windows... even <M-Esc> is used
	vim.keymap.set('n', '<C-f>',   telescope.find_files, opts)
	vim.keymap.set('n', '<M-f>',   telescope.find_files, opts) -- fallback for windows
	vim.keymap.set('n', '<C-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<M-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts) -- fallback for windows
	vim.keymap.set('n', '<C-[>',   wrap(telescope.lsp_references, theme.get_cursor()), opts)
	vim.keymap.set('n', '<M-[>',   wrap(telescope.lsp_references, theme.get_cursor()), opts) -- fallback for windows
	vim.keymap.set('n', '<C-;>',   telescope.git_bcommits, opts)
	vim.keymap.set('n', '<M-;>',   telescope.git_bcommits, opts) -- fallback for windows
	vim.keymap.set('n', '<M-=>',   wrap(telescope.registers, theme.get_dropdown()), opts) -- fallback for windows
	-- Marks and buffers with telescope
	vim.keymap.set('n', '<C-End>', telescope.buffers, opts)
	vim.keymap.set('n', '<C-\'>',  wrap(telescope.marks, theme.get_dropdown()), opts)
	vim.keymap.set('n', '<M-\'>',  wrap(telescope.marks, theme.get_dropdown()), opts) -- fallback for windows
	vim.keymap.set('n', '<C-/>',   wrap(telescope.current_buffer_fuzzy_find, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<M-/>',   wrap(telescope.current_buffer_fuzzy_find, {layout_strategy = 'vertical'}), opts) -- fallback for windows
	-- Symbols with telescope
	vim.keymap.set('n', '<C-\\>',  telescope.lsp_document_symbols, opts)
	vim.keymap.set('n', '<C-CR>',  wrap(telescope.lsp_workspace_symbols, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<NL>',    wrap(telescope.lsp_workspace_symbols, {layout_strategy = 'vertical'}), opts) -- fallback for windows
	-- Error list with telescope
	vim.keymap.set('n', '<C-PageUp>', wrap(telescope.diagnostics, theme.get_ivy()), opts)
	vim.keymap.set('n', '<C-PageDown>', wrap(telescope.diagnostics, theme.get_ivy({bufnr=0})), opts)
end

function KEYBINDS:set_dap_keys(opts)
	-- dapui
	local dap = require('dap')
	local dapui = require('dapui')
	vim.keymap.set('n', '<F2>' , function() dapui.toggle({}) end, {})
	vim.keymap.set('n', '<F3>' , function() dap.toggle_breakpoint() end, {})
	vim.keymap.set('n', '<F5>' , function() dap.continue() end, {})
	vim.keymap.set('n', '<F10>', function() dap.step_over() end, {})
	vim.keymap.set('n', '<F11>', function() dap.step_into() end, {})
	vim.keymap.set('n', '<F12>', function() dap.step_out() end, {})
end

return KEYBINDS
