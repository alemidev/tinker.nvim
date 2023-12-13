local nvim_jdtls = require("jdtls")
nvim_jdtls.start_or_attach({
	cmd = { 'jdtls' },
	root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
})
require('keybinds'):set_lsp_keys({buffer = 0})

-- Allow decompiling classes coming from the language server too
-- TODO should probably move elsewhere
vim.api.nvim_create_user_command(
	'Javap',
	function(args)
		local fname = vim.api.nvim_buf_get_name(0)
		if vim.startswith(fname, "jdt://") then
			local _, _, classpath_raw, classname_raw = string.find(fname, "jdt://.+?=%a+/(.+).jar=/.+,test=/(.+)%.class.*")
			local classpath = classpath_raw:gsub("%%5C", "") .. '.jar'
			local classname = classname_raw:gsub("%%3C", ""):gsub("%(", ".")
			vim.fn.jobstart(
				{'javap', '-p', '-c', '--class-path', classpath, classname},
				{
					width = 1024,
					stdout_buffered = true,
					on_stdout = function(_, data, _)
						local buf = vim.api.nvim_create_buf(false, true)
						vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, data)
						vim.api.nvim_buf_set_option(buf, 'ft', 'asm')
						if args.bang then
							local width = vim.fn.winwidth(0)
							local height = vim.fn.winheight(0)
							vim.api.nvim_open_win(buf, true, {
								relative='win',
								row = 5,
								col = 10,
								width=width - 20,
								height=height - 10,
								border="single",
								zindex=100, -- TODO hardcoded?
							})
						else
							vim.api.nvim_win_set_buf(0, buf)
						end
					end
				}
			)
		else
			require('jdtls').javap()
		end
	end,
	{ bang=true }
)
