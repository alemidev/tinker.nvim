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
	vim.keymap.set('n', '<leader><Tab>', ':tabnew<CR>', opts)
	vim.keymap.set('n', '<M-t>', ':tabnew<CR>', opts) -- fallback for windows
	vim.keymap.set('n', '<C-t>', ':Neotree toggle<CR>', {noremap=true})
	vim.keymap.set('n', '<C-S-t>', ':Neotree toggle source=symbolmap right<CR>', {noremap=true})
	vim.keymap.set('n', '<M-S-t>', ':Neotree toggle source=symbolmap right<CR>', {noremap=true})
	vim.keymap.set('n', '<C-PageUp>', ':Neotree toggle source=diagnostics bottom<CR>', opts)
	-- vim.keymap.set('n', '<C-h>', vim.cmd.UndotreeToggle, {noremap=true})
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

	-- macos keys, goddammit apple...
	for _, mode in ipairs({ "n", "i", "v", "x" }) do
		vim.keymap.set(mode, '<D-d>', '<C-d>', opts)
		vim.keymap.set(mode, '<D-u>', '<C-u>', opts)
		vim.keymap.set(mode, '<D-r>', '<C-r>', opts)
		vim.keymap.set(mode, '<D-v>', '<c-v>', opts)
		vim.keymap.set(mode, '<D-o>', '<c-o>', opts)
		vim.keymap.set(mode, '<D-i>', '<c-i>', opts)
		vim.keymap.set(mode, '<D-]>', '<c-]>', opts)
		vim.keymap.set(mode, '<D-[>', '<c-[>', opts)
		vim.keymap.set(mode, '<D-w>', '<C-w>', opts)
		vim.keymap.set(mode, '<D-PageUp>', ':Neotree toggle source=diagnostics bottom<CR>', opts)
	end
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
	-- macos keys, goddammit apple...
	vim.keymap.set('n', '<D-Up>', '<C-y>', opts)
	vim.keymap.set('n', '<D-Down>', '<C-e>', opts)
end

local function toggle_inlay_hints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	print("[*] inlay hints " .. (vim.lsp.inlay_hint.is_enabled() and "ON" or "OFF"))
end

function KEYBINDS:set_lsp_keys(opts)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(opts.buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- Enable Lsp tagfunc
	vim.api.nvim_buf_set_option(opts.buffer, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', '<leader>y', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<leader>R', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>f', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<M-q>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<M-q>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<C-Space>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<C-x>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>H', toggle_inlay_hints)
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<M-a>', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader><Del>', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<C-Del>', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<C-BS> ', vim.diagnostic.open_float, opts) -- fallback for windows
	-- It's not really a keybind but whatever
	vim.api.nvim_create_user_command(
		'Format',
		function(args)
			if args.range == 0 then
				vim.lsp.buf.format({ async = args.bang })
			else
				local range = {}
				range['start'] = { args.line1, 0 }
				range['end']   = { args.line2, 0 }
				vim.lsp.buf.format({async=not args.bang, range=range})
			end
		end,
		{bang=true, range=2}
	)
	vim.keymap.set('n', '<M-p>', ':ClangdSwitchSourceHeader<CR>', {})
	vim.keymap.set('n', '<D-a>', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<D-Space>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<D-x>', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<D-Del>', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<D-BS>', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<D-h>', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
end

function KEYBINDS:set_telescope_keys(opts)
	local telescope = require('telescope.builtin')
	local theme = require('telescope.themes')

	vim.keymap.set('n', '<leader>p', telescope.find_files, opts)
	vim.keymap.set('n', '<leader>s', wrap(telescope.lsp_dynamic_workspace_symbols, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<leader>/', wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<leader>]', wrap(telescope.lsp_references, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<leader>r', wrap(telescope.lsp_references, {layout_strategy = 'vertical'}), opts) -- overrule lsp bind
	vim.keymap.set('n', '<leader>;', telescope.git_bcommits, opts)

	if not vim.g.disable_legacy_keybinds then
		-- File navigation
		vim.keymap.set('n', '<leader>|', wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts)
		vim.keymap.set('n', '<C-ESC>', wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts)
		vim.keymap.set('n', '<M-!>',   wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts) -- fallback for windows... even <M-Esc> is used

		vim.keymap.set('n', '<C-f>',   telescope.find_files, opts)
		vim.keymap.set('n', '<M-f>',   telescope.find_files, opts) -- fallback for windows

		vim.keymap.set('n', '<C-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts)
		vim.keymap.set('n', '<M-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts) -- fallback for windows

		vim.keymap.set('n', '<M-]>',   wrap(telescope.lsp_references, theme.get_dropdown()), opts)

		vim.keymap.set('n', '<M-[>',   wrap(telescope.jumplist, theme.get_dropdown()), opts)
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
		vim.keymap.set('n', '<leader>/',  telescope.lsp_document_symbols, opts)
		vim.keymap.set('n', '<leader>s',   wrap(telescope.lsp_dynamic_workspace_symbols, {layout_strategy = 'vertical'}), opts)
		vim.keymap.set('n', '<C-|>',   wrap(telescope.lsp_dynamic_workspace_symbols, {layout_strategy = 'vertical'}), opts)
		vim.keymap.set('n', '<M-|>',   wrap(telescope.lsp_dynamic_workspace_symbols, {layout_strategy = 'vertical'}), opts)
		-- Resule last
		vim.keymap.set('n', '<C-CR>',  telescope.resume, opts)
		vim.keymap.set('n', '<M-CR>',  telescope.resume, opts)
		-- Error list with telescope
		vim.keymap.set('n', '<C-PageDown>', wrap(telescope.diagnostics, theme.get_ivy({bufnr=0})), opts)
	end
	-- macos keys, goddammit apple...
	vim.keymap.set('n', '<D-ESC>', wrap(telescope.oldfiles, {layout_strategy = 'vertical' }), opts)
	vim.keymap.set('n', '<D-f>',   telescope.find_files, opts)
	vim.keymap.set('n', '<D-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<D-,>',   wrap(telescope.live_grep, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<D-;>',   telescope.git_bcommits, opts)
	vim.keymap.set('n', '<D-End>', telescope.buffers, opts)
	vim.keymap.set('n', '<D-\'>',  wrap(telescope.marks, theme.get_dropdown()), opts)
	vim.keymap.set('n', '<D-/>',   wrap(telescope.current_buffer_fuzzy_find, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<D-\\>',  telescope.lsp_document_symbols, opts)
	vim.keymap.set('n', '<D-|>',   wrap(telescope.lsp_dynamic_workspace_symbols, {layout_strategy = 'vertical'}), opts)
	vim.keymap.set('n', '<D-CR>',  telescope.resume, opts)
	vim.keymap.set('n', '<D-PageDown>', wrap(telescope.diagnostics, theme.get_ivy({bufnr=0})), opts)
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
