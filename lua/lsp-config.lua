return {
	{ name = 'intelephense' },
	{ name = 'bashls' },
	{ name = 'pylsp', config = { settings = { pylsp = { plugins = { pycodestyle = { enabled = false } } } } } },
	{ name = 'clangd' },
	{ name = 'ltex', config = { debounce_text_changes = 300, settings = { ltex = { language = "it-IT" } } } },
	{ name = 'buf_ls' },
	{ name = 'ts_ls' },
	{ name = 'html' },
	{ name = 'ruby_lsp' },
	{ name = 'elixirls', config = { cmd= {"/usr/bin/elixir-ls" } } },
	{ name = 'gopls' },
	{ name = 'golangci_lint_ls' },
	{ name = 'dartls' },
	-- { name = 'rust_analyzer', config = { settings = { ['rust-analyzer'] = { checkOnSave = { command = "clippy" } } } } },
	-- { name = 'java_language_server', config = { cmd = { '/home/alemi/dev/software/java-language-server/dist/lang_server_linux.sh' } } },
	-- { name = 'kotlin_language_server' },
	-- {
	-- 	name = "jdtls",
	-- 	config = {
	-- 		settings = {
	-- 			java = {
	-- 				compile = {
	-- 					nullAnalysis = {
	-- 						nonnull = 'javax.annotation.Nonnull',
	-- 						nullable = 'javax.annotation.Nullable',
	-- 						mode = "interactive"
	-- 					}
	-- 				}
	-- 			}
	-- 		}
	-- 	}
	-- },
	{
		name = 'lua_ls',
		config = {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath('config')
						and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using (most
						-- likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
						-- Tell the language server how to find Lua modules same way as Neovim
						-- (see `:h lua-module-load`)
						path = {
							'lua/?.lua',
							'lua/?/init.lua',
						},
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths
							-- here.
							-- '${3rd}/luv/library',
							-- '${3rd}/busted/library',
							},
							-- Or pull in all of 'runtimepath'.
							-- NOTE: this is a lot slower and will cause issues when working on
							-- your own configuration.
							-- See https://github.com/neovim/nvim-lspconfig/issues/3189
							-- library = {
							--   vim.api.nvim_get_runtime_file('', true),
							-- },
						},
				})
			end,
			settings = {
				Lua = { telemetry = { enable = false } }
			},
		},
	},
}
