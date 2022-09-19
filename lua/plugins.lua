--[[
                       &&&                                                                                                
                    &##&                                                         █████╗ ██╗     ███████╗███╗   ███╗██╗    
                  &##&                                                          ██╔══██╗██║     ██╔════╝████╗ ████║██║    
                 BB&                                                            ███████║██║     █████╗  ██╔████╔██║██║    
               &GB                                     &                        ██╔══██║██║     ██╔══╝  ██║╚██╔╝██║██║    
              &GB                                     &BGBBBBBBBB###&           ██║  ██║███████╗███████╗██║ ╚═╝ ██║██║    
              GG                                       &GGGGGGGGGGGGGB#&        ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝    
             #P#                                        &&#BGGGGGGGGGGG#                     nvim plugins                 
             BP&                                           &GGGGGGGGGB#                                                   
         &#BGPP&                                         &#BGGGGGGGB#              * tldr: managed with packer.nvim       
     &#BGGGGGPP&                                     &&#BGGGGGGB##&                  - lsp: integrated + nvim-lspconfig   
  &#GPPPGGGGGBPB                                &&##BGGGGGBB#&&                      - completion: nvim-cmp + LuaSnip     
 #PPPPPPPGGPG BP&                        &&##BBGGGGGGBB#&&                           - syntax: nvim-treesitter            
 PPPPPPPPPPPPGBPG&&&       &&&&&&###BBBGGGGGGGBB##&&                                 - pickers: telescope.nvim            
 &BGPPPPPPPPPPPPPPGGGGGGGGGGGGGGGGGGGBBB##&&&                                        - files: nvim-tree.lua               
    &&##BBBBGGGGGGGPGBBBBBB####&&&&                                                  - git: vim-fugitive + gitsigns.nvim  
                  &#B#&                                                              - extra: hexmode, vim-combo,         
               &&    ###&                                                                     rust-tools, nvim-colorizer  
              &G#      &&#&&&                                                                                             
                             &&&                                                                                          
]]--

local init_fn = function(use)
	use 'wbthomason/packer.nvim'        -- packer can manage itself

	-- trying this thing out
	use 'lervag/wiki.vim'               -- utilities for managing my wiki
	use 'lervag/wiki-ft.vim'            -- wiki format syntax
	-- really idk about it, need to use it for a while

	use 'fidian/hexmode'                -- convert buffers into hex view with xxd
	use 'alemidev/vim-combo'            -- track code combos
	use 'editorconfig/editorconfig-vim' -- respect editorconfig

	use "ellisonleao/glow.nvim"         -- markdown previewer with glow

	use 'tpope/vim-fugitive'            -- better git commands

	use 'neovim/nvim-lspconfig'         -- import LSP configurations
	use 'simrat39/rust-tools.nvim'      -- extra LSP defaults for rust

	use 'L3MON4D3/LuaSnip'              -- snippet engine

	use {
		'mfussenegger/nvim-dap',        -- debugger adapter protocol
		requires = {
			'rcarriga/nvim-dap-ui',     --batteries-included debugger ui
		},
		config = function()
			local dap = require('dap')
			dap.adapters.python = {
				type = 'executable',
				command = (vim.fn.environ()["VIRTUAL_ENV"] or "") .. "/bin/python",
				args = { '-m', 'debugpy.adapter' },
			}
			dap.configurations.python = {
				{
					name = "Launch file",
					type = "python",
					request = "launch",
					program = vim.fn.expand('%'),
					cwd = '${workspaceFolder}',
				},
			}
			dap.adapters.lldb = {
				type = 'executable',
				command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
				name = 'lldb'
			}
			dap.configurations.cpp = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						local program = ""
						for i in string.gmatch(vim.fn.getcwd(), "([^/]+)") do
							program = i
						end
						return vim.fn.getcwd() .. "/target/debug/" .. program -- TODO can I put startup file somewhere?
					end,
					cwd = '${workspaceFolder}',
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
			require('keybinds'):set_dap_keys({})
			require('dapui').setup()
		end,
	}

	use {
		'hrsh7th/nvim-cmp',             -- completion engine core
		requires = {
			'hrsh7th/cmp-nvim-lsp',                 -- complete with LSP
			'hrsh7th/cmp-nvim-lsp-signature-help',  -- complete function signatures
			'hrsh7th/cmp-nvim-lsp-document-symbol', -- complete document symbols
			'hrsh7th/cmp-path',                     -- complete paths
			'hrsh7th/cmp-buffer',                   -- complete based on buffer
			'rcarriga/cmp-dap',                     -- complete in debugger
			'saadparwaiz1/cmp_luasnip',             -- complete with snippets
			'onsails/lspkind.nvim',                 -- fancy icons and formatting
		},
	}

	use {
		'norcalli/nvim-colorizer.lua',
		config = function () require('colorizer').setup() end
	}

	use "stevearc/dressing.nvim"          -- better vim.fn.input() and vim.fn.select()

	use {
		'nvim-telescope/telescope.nvim',  -- fuzzy finder, GUI component
		requires = {
			{'nvim-lua/plenary.nvim'},    -- some utilities made for telescope
			{'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }, -- fzf algorithm implemented in C for faster searches
		},
		config = function()
			require('telescope').load_extension('fzf')
			require('keybinds'):set_telescope_keys({})
		end
	}

	use {
		'lewis6991/gitsigns.nvim',        -- show diff signs in gutter
		config = function()
			require('gitsigns').setup {   -- configure symbols and colors
				signs = {
					add          = {hl = 'GitSignsChange', text = '╎'},
					change       = {hl = 'GitSignsChange', text = '│'},
					delete       = {hl = 'GitSignsDelete', text = '_'},
					topdelete    = {hl = 'GitSignsDelete', text = '‾'},
					changedelete = {hl = 'GitSignsDelete', text = '~'},
				},
			}
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				highlight = { enable = true },
				incremental_selection = { enable = true },
				textobjects = { enable = true }
			}
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		end
	}

	use {
		'kyazdani42/nvim-tree.lua',     -- tree file explorer, alternative to nerdtree in lua
		requires = { 'kyazdani42/nvim-web-devicons' }, -- optional, for file icons
		config = function()
			require('nvim-tree').setup({
				view={
					adaptive_size = false,
					mappings={
						list={
							{ key = "<C-t>", action = "close" },
							{ key = "t", action = "tabnew" },
							{ key = "s", action = "split" },
							{ key = "<C-s>", action = "vsplit" },
						}
					}
				}
			})
		end
	}

	-- TODO this part is messy, can I make it cleaner?
	-- TODO can I put these setup steps inside their respective config callback?
	-- TODO can I make them also load their highlight groups?
	-- TODO can I make nvim-cmp configuration smaller?

	local cmp = require('cmp')
	cmp.setup({
		formatting = {
			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({ mode = "symbol" })(entry, vim_item)
				kind.kind = " " .. kind.kind .. " "
				return kind
			end,
		},
		snippet = {
			expand = function(args) require('luasnip').lsp_expand(args.body) end,
		},
		mapping = cmp.mapping.preset.insert({ ['<Tab>'] = cmp.mapping.confirm({ select = true }) }),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp_signature_help', max_item_count = 1 },
			{ name = 'luasnip' },
			{ name = 'nvim_lsp' },
			{ name = 'path', max_item_count = 3 },
			{ name = 'buffer', keyword_length = 3, max_item_count = 3 },
		}),
	})
	cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
		formatting = {
			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({ mode = "symbol" })(entry, vim_item)
				kind.kind = " " .. kind.kind .. " "
				return kind
			end,
		},
		mapping = cmp.mapping.preset.insert({ ['<Tab>'] = cmp.mapping.confirm({ select = true }) }),
		sources = {
			{ name = 'dap' },
		},
	})
	-- cmp.setup.cmdline('/', {
	-- 	formatting = {
	-- 		format = function(entry, vim_item)
	-- 			local kind = require("lspkind").cmp_format({ mode = "symbol" })(entry, vim_item)
	-- 			kind.kind = " " .. kind.kind .. " "
	-- 			return kind
	-- 		end,
	-- 	},
	-- 	mapping = cmp.mapping.preset.cmdline(),
	-- 	sources = cmp.config.sources({
	-- 		{ name = 'nvim_lsp_document_symbol' },
	-- 		{ name = 'buffer', keyword_length = 3 },
	-- 	})
	-- })

	-- Setup lspconfig.
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
	local lspconfig = require("lspconfig")

	local function set_lsp_binds(_, bufnr)
		require('keybinds'):set_lsp_keys({buffer=bufnr})
	end

	local rust_tools = require("rust-tools")
	rust_tools.setup({
		tools = {
			inlay_hints = { auto = true, highlight = "InlayHint" },
			hover_actions = { border = "none" },
		},
		server = {
			capabilities = capabilities,
			on_attach = set_lsp_binds,
		},
		dap = { adapter = require('dap').adapters.lldb },
	})
	rust_tools.inlay_hints.enable()

	lspconfig.bashls.setup({capabilities=capabilities, on_attach=set_lsp_binds})
	lspconfig.pylsp.setup({capabilites = capabilities, on_attach = set_lsp_binds, settings = { pylsp = { plugins = { pycodestyle = { enabled = false } } } } })
	lspconfig.clangd.setup({capabilities=capabilities, on_attach=set_lsp_binds})
	lspconfig.marksman.setup({capabilities=capabilities, on_attach=set_lsp_binds})

	local jdtls_bin_path = os.getenv("JDTLS_BIN_PATH") or "jdtls"
	local home_path = os.getenv("HOME") -- TODO this is not windows friendly
	lspconfig.jdtls.setup({
		capabilities=capabilities,
		on_attach=set_lsp_binds,
		cmd = {jdtls_bin_path, "-configuration", home_path .. "/.cache/jdtls/config", "-data", home_path .. "/.cache/jdtls/workspace" },
		workspace = home_path .. "/.cache/jdtls/workspace",
		-- root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
	})
	lspconfig.sumneko_lua.setup({
		capabilites=capabilities,
		on_attach=set_lsp_binds,
		settings = {
			Lua = {
				runtime = { version = 'LuaJIT' },
				diagnostics = { globals = {'vim'} },
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				telemetry = { enable = false },
			}
		}
	})

	-- lspconfig.jedi_language_server.setup({capabilites=capabilites})
end

return require('packer').startup(init_fn)

