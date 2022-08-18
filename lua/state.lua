--[[
                                                                                                                  
                   ...::....:~77~^~^~~~:.                  ██████╗██████╗ ██╗   ██╗███╗   ███╗██████╗ ███████╗    
                .~!777!!~!7!~^75J^~^^~~~!~^::::..         ██╔════╝██╔══██╗██║   ██║████╗ ████║██╔══██╗██╔════╝    
             ..^?YJ7^.^.:::^:!~^?J:..^^:..~JJ5J~~~:.      ██║     ██████╔╝██║   ██║██╔████╔██║██████╔╝███████╗    
       .:^~~!!77~^7!J!...:....:^~77... .....!JY^:::^^:    ██║     ██╔══██╗██║   ██║██║╚██╔╝██║██╔══██╗╚════██║    
     .~!~!~^^^~~~!!^7JJ....... .:!J:....... .~Y~.....:^   ╚██████╗██║  ██║╚██████╔╝██║ ╚═╝ ██║██████╔╝███████║    
   .!7~:^^^^:^^^::.:^!J?. ... .. .7:  .   .  .~: .... ::   ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═════╝ ╚══════╝    
 .~!~^^:..::...:..  ..:?^ ....... ..  . .   . ...     :^                                                          
 :?~::....  ..... . .. .:.........  . ... . .    ..:^~^        * pick up where you left                           
 ^^:~^...  .  ....................  .  .. ...:^^^~~^:          * wraps around vim sessions: an hidden file        
 .~:~::^^:..:.............  .  ......::^~~~~~~^:                  named .session.vim can be created with a        
  .~~^^^::^^::....:..::::^:^^~!!!7~!~^                            command. if nvim is started without args,       
   .:^!7!~~77!~7!!77?7?777!~::                                    this file is loaded if present.                 
        ..::::^::::...                                         * by alemidev <me@alemi.dev>                       
                                                               * https://vim.fandom.com/wiki/Go_away_and_come_back
]]--

--|| CORE FUNCTIONS

local sep = vim.fn.has('win32') ~= 0 and '\\' or '/'

-- Creates a session
function SaveSession(sess_name)
	local session_file = vim.fn.getcwd() .. sep .. (sess_name or ".session.vim")
	vim.cmd("mksession! " .. session_file)
	print("[+] saved session: " .. session_file)
end

-- Loads a session if it exists
function LoadSession(sess_name)
	local session_file = vim.fn.getcwd() .. sep .. (sess_name or ".session.vim")
	if vim.fn.filereadable(session_file) ~= 0 then
		vim.cmd("source " .. session_file)
		vim.cmd("edit %")
		print("[*] loaded session: " .. session_file)
	end
end

function ClearSession(sess_name)
	local session_file = vim.fn.getcwd() .. sep .. (sess_name or ".session.vim")
	if vim.fn.filereadable(session_file) ~= 0 then
		vim.fn.system("rm ".. session_file)
		print("[-] cleared session: " .. session_file)
	end
end

-- INTERNAL HANDLERS

local function local_changes_pending()
	local buffers = vim.fn.getbufinfo()
	for n, buf in pairs(buffers) do
		if buf ~= nil and buf.changed == 1 then
			print(string.format("[!] buffer #%d has local changes", n))
			return n
		end
	end
	return nil
end

vim.api.nvim_create_user_command(
	'SaveSession',
	function(args)
		local sess_name = nil
		if #args.args > 0 then
			sess_name = args.args
		end
		if args.bang then
			ClearSession(sess_name)
		else

		end
		SaveSession(sess_name)
	end,
	{bang=true, nargs='?'}
)

vim.api.nvim_create_user_command(
	'ClearSession',
	function(_) ClearSession() end,
	{}
)

vim.api.nvim_create_user_command(
	'LoadSession',
	function(args)
		if not args.bang and local_changes_pending() then
			return
		end
		local sess_name = nil
		if #args.args > 0 then
			sess_name = args.args
		end
		LoadSession(sess_name)
	end,
	{bang=true, nargs='?'}
)

vim.api.nvim_create_user_command(
	'QuitSaving',
	function(args)
		if not args.bang and local_changes_pending() then
			return
		end
		local sess_name = nil
		if #args.args > 0 then
			sess_name = args.args
		end
		SaveSession(sess_name)
		vim.cmd("qa") -- TODO can I do this from nvim api?
	end,
	{bang=true, nargs='?'}
)

local session_management_group = vim.api.nvim_create_augroup("SessionManagementGroup", {clear=true})
vim.api.nvim_create_autocmd(
	{ "VimEnter" },
	{
		callback=function()
			if vim.fn.argc() == 0 then
				LoadSession(nil)
				-- TODO why do these get reset???
				vim.opt.winheight = 3
				vim.opt.winminheight = 3
				vim.opt.winwidth = 12
				vim.opt.winminwidth = 12
			end
		end,
		nested=true,
		group=session_management_group
	}
)

