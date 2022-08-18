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

	use 'tpope/vim-fugitive'            -- better git commands

	use 'neovim/nvim-lspconfig'         -- import LSP configurations
	use 'simrat39/rust-tools.nvim'      -- extra LSP defaults for rust

	use 'hrsh7th/nvim-cmp'              -- completion engine core
	use 'hrsh7th/cmp-nvim-lsp'          -- completions based on LSP
	use 'hrsh7th/cmp-path'              -- completions based on paths
	use 'hrsh7th/cmp-buffer'            -- completions based on buffer

	use 'L3MON4D3/LuaSnip'              -- snippet engine
	use 'saadparwaiz1/cmp_luasnip'      -- incorporate with completions

	use {
		'norcalli/nvim-colorizer.lua',
		config = function () require('colorizer').setup() end
	}

	use {
		'nvim-telescope/telescope.nvim',  -- fuzzy finder, GUI component
		requires = {
			{'nvim-lua/plenary.nvim'},    -- some utilities made for telescope
			{'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }, -- fzf algorithm implemented in C for faster searches
			{'nvim-telescope/telescope-ui-select.nvim'},
		},
		config = function()
			require('telescope').load_extension('fzf')
			require("telescope").load_extension("ui-select")
			require('keybinds').set_telescope_keys({})
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

	local cmp = require('cmp')
	cmp.setup({
		snippet = {
			expand = function(args) require('luasnip').lsp_expand(args.body) end,
		},
		mapping = cmp.mapping.preset.insert({
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<C-Tab>'] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
			['<Tab>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
		}, {
			{ name = 'path' },
		}, {
			{ name = 'buffer' },
		})
	})

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
			inlay_hints = { auto = true },
			hover_actions = { border = "none" },
		},
		server = {
			capabilities = capabilities,
			on_attach = set_lsp_binds,
		}
	})
	rust_tools.inlay_hints.enable()

	lspconfig.bashls.setup({capabilities=capabilities, on_attach=set_lsp_binds})
	lspconfig.pyright.setup({capabilites=capabilities, on_attach=set_lsp_binds})
	lspconfig.clangd.setup({capabilities=capabilities, on_attach=set_lsp_binds})

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


