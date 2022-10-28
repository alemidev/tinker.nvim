--[[
                       &&&                                                                                                
                    &##&                                                         █████╗ ██╗     ███████╗███╗   ███╗██╗    
                  &##&                                                          ██╔══██╗██║     ██╔════╝████╗ ████║██║    
                 BB&                                                            ███████║██║     █████╗  ██╔████╔██║██║    
               &GB                                     &                        ██╔══██║██║     ██╔══╝  ██║╚██╔╝██║██║    
              &GB                                     &BGBBBBBBBB###&           ██║  ██║███████╗███████╗██║ ╚═╝ ██║██║    
              GG                                       &GGGGGGGGGGGGGB#&        ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝    
             #P#                                        &&#BGGGGGGGGGGG#                  nvim configuration              
             BP&                                           &GGGGGGGGGB#                                                   
         &#BGPP&                                         &#BGGGGGGGB#                                                     
     &#BGGGGGPP&                                     &&#BGGGGGGB##&                                                       
  &#GPPPGGGGGBPB                                &&##BGGGGGBB#&&                                                           
 #PPPPPPPGGPG BP&                        &&##BBGGGGGGBB#&&                                                                
 PPPPPPPPPPPPGBPG&&&       &&&&&&###BBBGGGGGGGBB##&&                                                                      
 &BGPPPPPPPPPPPPPPGGGGGGGGGGGGGGGGGGGBBB##&&&                                                                             
    &&##BBBBGGGGGGGPGBBBBBB####&&&&                                                                                       
                  &#B#&                                                                                                   
               &&    ###&                                                                                                 
              &G#      &&#&&&                                                                                             
                             &&&                                                                                          
]]--

--|| CORE
vim.opt.mouse = 'a'            -- mouse can be handy
vim.opt.number = true          -- show line number
vim.opt.cursorline = true      -- highlight current line, with theme only visible in number bar
vim.opt.tabstop = 4            -- default to tab of size 4
vim.opt.shiftwidth = 4         -- default to autoindent by 4
vim.opt.expandtab = false      -- default to hard tabs
vim.opt.wrap = false           -- default to no wrap
vim.opt.showmode = false       -- my statusline handles this
vim.opt.showcmd = true
vim.opt.wildmode = 'longest,list,full' -- don't accept partial completions until we tab a lot
vim.opt.hls = false
vim.opt.sessionoptions = "buffers,curdir,localoptions,tabpages,winsize"
vim.opt.foldlevelstart = 50
vim.opt.termguicolors = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
-- vim.opt.signcolumn = "yes"
vim.opt.switchbuf = "usetab"
vim.g.mapleader = "\\"

vim.opt.list = true            -- always show whitespace chars
vim.opt.listchars = "tab:│ ,space:·,trail:•,nbsp:▭,precedes:◀,extends:▶"

vim.opt.winheight = 3
vim.opt.winminheight = 3
vim.opt.winwidth = 12
vim.opt.winminwidth = 12


-- Tabline
-- TODO customize structure to make selected tab use same hi as mode, maybe
--   check https://gist.github.com/kanterov/1517990 ?
vim.opt.showtabline = 1  -- set to 2 to always show tabline

-- Statusline
STATUSLINE = require('statusline')
vim.opt.laststatus = 3  -- show one global statusline
vim.opt.statusline = "%!v:lua.STATUSLINE.display()"


-- Netrw settings
vim.g.netrw_liststyle = 3
-- vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 2
vim.g.netrw_winsize = 12

-- Neovide settings
vim.g.neovide_transparency = 0.9
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.g.neovide_refresh_rate = 120
vim.opt.guifont = { "Fira Code", ":h10" }

-- Wiki.vim settings
vim.g.wiki_root = "~/Documents/wiki"

-- vim.opt.timeoutlen = 500       -- set shorter timeout for keys
-- vim.opt.ttimeoutlen = 10       -- set even shorter timeout for ESC


--|| NUMBERS
-- relativenumbers are very handy for navigation, but absolute are useful in general 
--   and better looking. Keep numbers relative only on active buffer and if in Normal mode.
vim.opt.relativenumber = true
local number_mode_group = vim.api.nvim_create_augroup("NumberModeGroup", {clear=true})
vim.api.nvim_create_autocmd(
	{ "InsertLeave", "BufEnter", "FocusGained", "WinEnter" },
	{
		callback = function() if vim.wo.number then vim.wo.relativenumber = true end end,
		group = number_mode_group
	}
)
vim.api.nvim_create_autocmd(
	{ "InsertEnter", "BufLeave", "FocusLost", "WinLeave" },
	{
		callback=function() if vim.wo.number then vim.opt.relativenumber = false end end,
		group=number_mode_group
	}
)


--|| STATE MANAGEMENT
VIMDIR = vim.fn.stdpath('data') .. '/site/'

-- add command :SaveSession which wraps around ':mksession! .session.vim'
--   when vim in started without args, try to load .session.vim in cwd
require("state")

-- keep track of undos across sessions
local undo_path = VIMDIR .. "undo/"
if not vim.fn.isdirectory(undo_path) then
	vim.fn.mkdir(undo_path, "p")
end
vim.opt.undofile = true
vim.opt.undodir = undo_path


--|| KEYBINDS
KEYBINDS = require('keybinds')
KEYBINDS:set_global_keys({})
KEYBINDS:set_navigation_keys({})
-- Telescope and nvim-lsp will set more keybinds if loaded


--|| PLUGINS
local install_path = VIMDIR..'/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	local packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

PLUGINS = require('plugins')


--|| THEME
vim.cmd("colorscheme peak") -- TODO can I do it in lua?


--|| UTILITY
function P(something) print(vim.inspect(something)) end

function HL()
	local id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
	local id_trans = vim.fn.synIDtrans(id)
	local name = vim.fn.synIDattr(id_trans, 'name')
	print(string.format("Highlight #%d -> %s", id, id_trans))
	P(name)
end

local function shell_cmd(str)
	local stdout = vim.fn.system(str)
	local output, _ = stdout:sub(0, #stdout-1):gsub("\t", "    ")
	print(output)
	return vim.v.shell_error == 0
end

vim.api.nvim_create_user_command(
	'UpdateConfig',
	function(args)
		local cfg_path = vim.fn.stdpath('config')
		if args.bang then
			if not shell_cmd(string.format("git -C %s reset --hard", cfg_path)) then return end
		end
		if #args.args > 0 then
			if not shell_cmd(string.format("git -C %s checkout %s", cfg_path, args.args)) then return end
		end
		shell_cmd(string.format("git -C %s pull", cfg_path))
	end,
	{bang=true, nargs='?'}
)

-- since builtin :retab! will expand also alignment spaces,
--  I made this simple command to use 'unexpand'/'expand'
vim.api.nvim_create_user_command(
	'Retab',
	function(args)
		local tablen = 4
		local cmd = "unexpand"
		local opt = "--first-only"
		if #args.args > 0 then
			tablen = args.args
		end
		if args.bang then
			cmd = "expand"
			opt = "--initial"
		end
		vim.cmd(string.format("%%!%s -t %d %s", cmd, tablen, opt))
	end,
	{bang=true, nargs='?'}
)
