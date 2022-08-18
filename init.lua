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
-- vim.opt.signcolumn = "yes"
vim.opt.switchbuf = "usetab"

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
vim.g.netrw_liststyle = 4
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 2
vim.g.netrw_winsize = 12

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
	{ callback=function() vim.opt.relativenumber = true end, group=number_mode_group }
)
vim.api.nvim_create_autocmd(
	{ "InsertEnter", "BufLeave", "FocusLost", "WinLeave" },
	{ callback=function() vim.opt.relativenumber = false end, group=number_mode_group }
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
PALETTE = require('colors')
PALETTE:set_colors()


--|| UTILITY
function P(something) print(vim.inspect(something)) end

vim.api.nvim_create_user_command(
	'UpdateConfig',
	function(args)
		local stdout = vim.fn.system(string.format("git -C %s pull", vim.fn.stdpath('config')))
		print(stdout:sub(0, #stdout-1)) -- strip tailing newline
	end,
	{}
)