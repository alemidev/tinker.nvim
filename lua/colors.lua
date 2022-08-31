--[[
                                                                                                    
                                      BBB                     ██████╗ ███████╗ █████╗ ██╗  ██╗      
                                    B#BGG                     ██╔══██╗██╔════╝██╔══██╗██║ ██╔╝      
                                   GB&BG !   G                ██████╔╝█████╗  ███████║█████╔╝       
                                ##GGB&&BGGBG! B               ██╔═══╝ ██╔══╝  ██╔══██║██╔═██╗       
                              B&&&@@@@&###G  ~!~              ██║     ███████╗██║  ██║██║  ██╗      
                           GB&#@@@@&@B #&#G ~^                ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      
                         B&@@@@@@@&     GG ~:! ^  ^                 neovim color scheme             
                      G#&@&@@&@&G                ~                                                  
                   GB&&@@&G@B GG            ~     # ^           * a warm colorscheme with           
                 #&@@@@@@#G   .  GG         #G  ##  ^ !            blue and red tones, to           
            B B&&&&@@&&#  !   ^  ## G  GB&&#GG# B  G~.             keep you cozy at night           
          GGB G@@#&&#G       ~ . B  GBB###&@@B G       ^                                            
        GGG      B&#B G .:!  !  @B  B#GB###GB !          ^      * by alemidev <me@alemi.dev>        
      GG !    GB@&BB      :  !.G#GG B#&&#G  G      G . .^.:                                         
     GB  . GG#@@@&##     :  !. # G B&@@#B      : GBG    . .:                               !^G      
B######   ^^&@@@&BG  G     .     B##BGBB   B     #B   &&  .  !G                        .:B GB##B    
   &##B BBG!^&@&#B     ^  :.    ##GGG GG B       #G  G &B~    ^                  .:!G#&&!    #BB#   
BGB&&&&&##G   &###B# G .    ~   B#&&&BBG#&B    GGGBB    GB   !! BG    :G  GG   GG  G#&#&.   :@@@&&  
BG#&##&#G   :G@@BG !    #  ::B#! &&#G          GB#G     &@@@@@@@@@& # GGGG   GGG   B&&#:^ B@@@&@@@  
BBG#B     .~ @@B   .~    G   B#G GB       &  GBBG      !G&#&&&&&&&&&&     : : G   G&&#:  &&@@@&&&@@ 
#BGGG     .!&#B   ~!:       . GG    #BGBGB####      ~   ~ &BGGGB#&B !  !~ ^.:~GG B&&&!  !&&&&&&  GG&
~        G  @&&G  !!!G       BGG   B&&B    G   ^      !  . @&@&&&&B ^ ::###B&&GGGB!    @@@@@  BG  ~#
       GGG #@#B          BGG#BB##G###B         ~.!          &&&#B## : #&@&#B#B G  BB#&&@@@@@&  B~ ~ 
     BGG GB#             G G     B#&G          :..       :     GGB G  &&&B GG        GG#BBB  G  : G 
 BG GBBBG  GGG   BGBGGGGB#B      B##            :  G G  ! :  &B##G   &@&#GGBG    G G             G&&
]]--

--- utility function to define nested color table in one line
-- first three arguments are (dark, normal, bright) strings, in form #ACACAC
-- last three arguments are (dark, normal, bright) numbers from x11 color table
local function COLOR(dark, normal, bright, code_d, code_n, code_b)
	return {
		dark   = {gui = dark,   term = code_d},
		normal = {gui = normal, term = code_n},
		bright = {gui = bright, term = code_b},
	}
end

--- utility function to define highlight table from palette colors
-- All params can be nil, will define an empty highlight colors
local function HIGHLIGHT(fg, bg, attrs)
	local result = {}
	if attrs ~= nil then
		for k, v in pairs(attrs) do
			if result.cterm == nil then
				result.cterm = {}
			end
			if k == "bold" or k == "italic" or k == "underline" then
				result.cterm[k] = v
			end
			result[k] = v
		end
	end
	if fg ~= nil then
		result.ctermfg = fg.term
		result.fg = fg.gui
	end
	if bg ~= nil then
		result.ctermbg = bg.term
		result.bg = bg.gui
	end
	return result
end

--- Color palette object, containing colors and setter methods
-- @field set_colors function to easily apply color scheme
local PALETTE = {
	--||             DARK       NORMAL     BRIGHT    ( x11 codes ) -- TODO map dark variants
	black  =  COLOR("#19161A", "#252A2B", "#333333", nil, 235, 238),
	gray   =  COLOR("#444444", "#808080", "#A8A499", nil, 244, nil),
	white  =  COLOR("#ADA9A1", "#D4D2CF", "#E8E1D3", nil, 252, 15 ),
	azure  =  COLOR("#5D748C", "#81A1C1", "#A6B4C2", nil, nil, nil),
	blue   =  COLOR("#323F61", "#48589C", "#5B6EA3", nil, 67,  4  ),
	purple =  COLOR("#433B6B", "#574C85", "#7468B0", nil, 60,  6  ),
	pink   =  COLOR("#63296E", "#84508C", "#AC7EA8", nil, nil, nil),
	red    =  COLOR("#824E53", "#BF616A", "#D1888E", nil, 1,   9  ),
	orange =  COLOR("#735F4C", "#AF875F", "#D69C63", nil, 137, nil),
	yellow =  COLOR("#A8956D", "#EBCB8B", "#EBD4A7", nil, 11,  nil),
	green  =  COLOR("#32664A", "#2E8757", "#55886C", nil, 2,   10 ),
	cyan   =  COLOR("#116E70", "#05979A", "#4AD9D9", nil, 6,   nil),
	none   =  COLOR( nil,       nil,       nil,      nil, 0,   0  ),
}

--|| THEME DEFINITIONS

function PALETTE:set_syntax_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "Whitespace",               HIGHLIGHT(self.black.normal,     nil,                    nil)) -- set color for whitespace
	vim.api.nvim_set_hl(0, "Comment",                  HIGHLIGHT(self.gray.normal,      nil,                    nil))
	vim.api.nvim_set_hl(0, "Constant",                 HIGHLIGHT(self.purple.bright,    nil,                    nil))
	vim.api.nvim_set_hl(0, "String",                   HIGHLIGHT(self.purple.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "Boolean",                  HIGHLIGHT(self.purple.dark,      nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "Function",                 HIGHLIGHT(self.azure.normal,     nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "Identifier",               HIGHLIGHT(self.blue.normal,      nil,                    nil))
	vim.api.nvim_set_hl(0, "Statement",                HIGHLIGHT(self.red.bright,       nil,                    nil))
	vim.api.nvim_set_hl(0, "PreProc",                  HIGHLIGHT(self.pink.bright,      nil,                    nil))
	vim.api.nvim_set_hl(0, "Include",                  HIGHLIGHT(self.cyan.normal,      nil,                    nil))
	vim.api.nvim_set_hl(0, "Type",                     HIGHLIGHT(self.orange.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "Special",                  HIGHLIGHT(self.yellow.bright,    nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "Delimiter",                HIGHLIGHT(self.gray.bright,      nil,                    nil))
end

function PALETTE:set_treesitter_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "TSText",                   HIGHLIGHT(self.white.bright,     nil,                    nil))
	-- comment
	vim.api.nvim_set_hl(0, "TSComment",                HIGHLIGHT(self.gray.normal,      nil,                    nil))
	-- constant
	vim.api.nvim_set_hl(0, "TSConstant",               HIGHLIGHT(self.purple.bright,    nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSFloat",                  HIGHLIGHT(self.purple.bright,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSNumber",                 HIGHLIGHT(self.purple.bright,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSCharacter",              HIGHLIGHT(self.purple.bright,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSLiteral",                HIGHLIGHT(self.purple.dark,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSConstBuiltin",           HIGHLIGHT(self.purple.normal,    nil,                    {bold=true}))
	-- string
	vim.api.nvim_set_hl(0, "TSString",                 HIGHLIGHT(self.purple.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSStringRegex",            HIGHLIGHT(self.orange.dark,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSStringEscape",           HIGHLIGHT(self.gray.normal,      nil,                    nil))
	-- boolean
	vim.api.nvim_set_hl(0, "TSBoolean",                HIGHLIGHT(self.purple.dark,      nil,                    {bold=true}))
	-- function
	vim.api.nvim_set_hl(0, "TSFunction",               HIGHLIGHT(self.azure.normal,     nil,                    nil))
	vim.api.nvim_set_hl(0, "TSFuncBuiltin",            HIGHLIGHT(self.azure.normal,     nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSMethod",                 HIGHLIGHT(self.azure.dark,       nil,                    nil))
	-- identifier
	vim.api.nvim_set_hl(0, "TSParameter",              HIGHLIGHT(self.azure.bright,     nil,                    nil))
	vim.api.nvim_set_hl(0, "TSParameterReference",     HIGHLIGHT(self.azure.bright,     nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSAttribute",              HIGHLIGHT(self.blue.normal,      nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSField",                  HIGHLIGHT(self.blue.bright,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSProperty",               HIGHLIGHT(self.blue.bright,      nil,                    {bold=true}))
	-- statement
	vim.api.nvim_set_hl(0, "TSConditional",            HIGHLIGHT(self.red.normal,       nil,                    nil))
	vim.api.nvim_set_hl(0, "TSKeyword",                HIGHLIGHT(self.red.bright,       nil,                    nil))
	vim.api.nvim_set_hl(0, "TSKeywordFunction",        HIGHLIGHT(self.red.bright,       nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSKeywordOperator",        HIGHLIGHT(self.red.dark,         nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSOperator",               HIGHLIGHT(self.red.dark,         nil,                    nil))
	-- preproc
	vim.api.nvim_set_hl(0, "TSAnnotation",             HIGHLIGHT(self.pink.normal,      nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSConstMacro",             HIGHLIGHT(self.pink.dark,        nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSFuncMacro",              HIGHLIGHT(self.pink.normal,      nil,                    nil))
	-- include
	vim.api.nvim_set_hl(0, "TSInclude",                HIGHLIGHT(self.cyan.dark,        nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSNamespace",              HIGHLIGHT(self.cyan.dark,        nil,                    nil))
	vim.api.nvim_set_hl(0, "TSCurrentScope",           HIGHLIGHT(self.cyan.normal,      nil,                    nil))
	-- type
	vim.api.nvim_set_hl(0, "TSType",                   HIGHLIGHT(self.orange.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSTypeBuiltin",            HIGHLIGHT(self.orange.dark,      nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSConstructor",            HIGHLIGHT(self.orange.normal,    nil,                    {bold=true}))
	-- special
	vim.api.nvim_set_hl(0, "TSLabel",                  HIGHLIGHT(self.yellow.bright,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSTag",                    HIGHLIGHT(self.yellow.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "TSTagDelimiter",           HIGHLIGHT(self.yellow.dark,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSVariableBuiltin",        HIGHLIGHT(self.yellow.bright,    nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "TSURI",                    HIGHLIGHT(self.blue.normal,      nil,                    {underline=true}))
	-- delimiter
	vim.api.nvim_set_hl(0, "TSPunctDelimiter",         HIGHLIGHT(self.gray.bright,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSPunctBracket",           HIGHLIGHT(self.gray.bright,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSPunctSpecial",           HIGHLIGHT(self.gray.bright,      nil,                    nil))
	-- ???
	vim.api.nvim_set_hl(0, "TSSymbol",                 HIGHLIGHT(self.gray.bright,      nil,                    nil))
	vim.api.nvim_set_hl(0, "TSVariable",               HIGHLIGHT(self.white.normal,     nil,                    nil))
	-- vim.api.nvim_set_hl(0, "TSError",                  highlight(nil,                   self.red.dark,          {underline=true}))
	-- vim.api.nvim_set_hl(0, "TSException",              highlight(nil,                   self.red.normal,        {underline=true, bold=true}))
	-- vim.api.nvim_set_hl(0, "TSRepeat",                 highlight(self.black.bright,     nil,                    nil))
	-- vim.api.nvim_set_hl(0, "TSTitle",                  highlight(self.white.bright,     nil,                    {bold=true}))
	-- vim.api.nvim_set_hl(0, "TSStrong",                 highlight(nil,                   nil,                    {bold=true}))
	-- vim.api.nvim_set_hl(0, "TSEmphasis",               highlight(self.red.bright,       nil,                    {bold=true}))
	-- vim.api.nvim_set_hl(0, "TSUnderline",              highlight(nil,                   nil,                    {underline=true}))
	-- vim.api.nvim_set_hl(0, "TSStrike",                 highlight(nil,                   nil,                    {strikethrough=true}))
	-- vim.api.nvim_set_hl(0, "TreesitterContext",        highlight(self.black.bright,     nil,                    {bold=true}))
end

function PALETTE:set_ui_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "NonText",                  HIGHLIGHT(self.black.normal,     nil,                    nil))
	vim.api.nvim_set_hl(0, "Visual",                   HIGHLIGHT(nil,                   self.black.bright,      nil))
	vim.api.nvim_set_hl(0, "Search",                   HIGHLIGHT(self.yellow.bright,    self.gray.dark,         {bold=true}))
	vim.api.nvim_set_hl(0, "Folded",                   HIGHLIGHT(self.cyan.normal,      self.black.normal,      nil))
	vim.api.nvim_set_hl(0, "FoldColumn",               HIGHLIGHT(self.cyan.normal,      nil,                    nil))
	vim.api.nvim_set_hl(0, "VertSplit",                HIGHLIGHT(self.black.normal,     self.black.normal,      nil)) -- Split divider color
	vim.api.nvim_set_hl(0, "SignColumn",               HIGHLIGHT(nil,                   nil,                    nil)) -- Gutter color
	vim.api.nvim_set_hl(0, "CursorLine",               HIGHLIGHT(nil,                   nil,                    nil)) -- Line number color
	vim.api.nvim_set_hl(0, "CursorLineSign",           HIGHLIGHT(nil,                   self.black.normal,      nil)) -- CursorLine color (in sign column)
	vim.api.nvim_set_hl(0, "CursorLineNr",             HIGHLIGHT(self.yellow.normal,    self.black.normal,      {bold=true})) -- CursorLine color (in number column)
	vim.api.nvim_set_hl(0, "LineNr",                   HIGHLIGHT(self.black.bright,     nil,                    nil)) -- Number column color

	vim.api.nvim_set_hl(0, "Pmenu",                    HIGHLIGHT(nil,                   self.black.normal,      nil)) -- Balloon color
	vim.api.nvim_set_hl(0, "PmenuSel",                 HIGHLIGHT(nil,                   self.gray.dark,         nil)) -- Balloon color
	-- vim.api.nvim_set_hl(0, "PmenuSbar",                HIGHLIGHT(nil,                   self.black.normal,      nil)) -- Balloon color
	-- vim.api.nvim_set_hl(0, "PmenuThumb",               HIGHLIGHT(nil,                   self.black.normal,      nil)) -- Balloon color
	vim.api.nvim_set_hl(0, "FloatBorder",              HIGHLIGHT(self.black.bright,     nil,                    nil)) -- Used mostly for replace popup
	vim.api.nvim_set_hl(0, "FloatTitle",               HIGHLIGHT(self.white.dark,       self.gray.dark,         nil)) -- custom definition of dessing.nvim

	vim.api.nvim_set_hl(0, "Question",                 HIGHLIGHT(self.cyan.normal,      nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "MoreMsg",                  HIGHLIGHT(self.black.bright,     nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "Error",                    HIGHLIGHT(self.red.normal,       nil,                    {underline=true}))
	vim.api.nvim_set_hl(0, "ErrorMsg",                 HIGHLIGHT(self.white.normal,     self.red.normal,        nil))
	vim.api.nvim_set_hl(0, "Todo"    ,                 HIGHLIGHT(self.black.normal,     self.orange.bright,     {bold=true}))
	vim.api.nvim_set_hl(0, "WarningMsg",               HIGHLIGHT(self.black.normal,     self.yellow.normal,     nil))
	vim.api.nvim_set_hl(0, "Title",                    HIGHLIGHT(self.red.bright,       nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "WildMenu",                 HIGHLIGHT(self.gray.bright,      self.orange.dark,       nil))
	vim.api.nvim_set_hl(0, "ColorColumn",              HIGHLIGHT(nil,                   self.black.dark,        nil))

	vim.api.nvim_set_hl(0, "DiagnosticWarn",           HIGHLIGHT(self.orange.normal,    nil,                    nil));
	vim.api.nvim_set_hl(0, "DiagnosticError",          HIGHLIGHT(self.red.normal,       nil,                    nil));
	vim.api.nvim_set_hl(0, "DiagnosticInfo",           HIGHLIGHT(self.cyan.normal,      nil,                    nil));
	vim.api.nvim_set_hl(0, "DiagnosticHint",           HIGHLIGHT(self.gray.normal,      nil,                    nil));
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  HIGHLIGHT(nil,                   nil,                    {underdash=true, sp=self.orange.normal.gui}));
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", HIGHLIGHT(nil,                   nil,                    {underline=true, sp=self.red.normal.gui}));
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  HIGHLIGHT(nil,                   nil,                    {sp=self.cyan.normal.gui}));
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  HIGHLIGHT(nil,                   nil,                    {sp=self.gray.normal.gui}));
end

function PALETTE:set_diff_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "DiffAdd",                  HIGHLIGHT(nil,                   self.black.normal,      nil))
	vim.api.nvim_set_hl(0, "DiffChange",               HIGHLIGHT(nil,                   self.black.dark,        nil))
	vim.api.nvim_set_hl(0, "DiffDelete",               HIGHLIGHT(self.black.normal,     self.black.dark,        nil))
	vim.api.nvim_set_hl(0, "DiffText",                 HIGHLIGHT(nil,                   self.black.normal,      nil))
end

function PALETTE:set_spell_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "SpellBad",                 HIGHLIGHT(nil,                   nil,                    {underline=true}))
	vim.api.nvim_set_hl(0, "SpellCap",                 HIGHLIGHT(nil,                   nil,                    {underline=true}))
	vim.api.nvim_set_hl(0, "SpellLocal",               HIGHLIGHT(nil,                   nil,                    {underline=true}))
	vim.api.nvim_set_hl(0, "SpellRare",                HIGHLIGHT(nil,                   nil,                    {bold=true}))
end

function PALETTE:set_tab_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "TabLineFill",              HIGHLIGHT(self.yellow.normal,    self.black.normal,      nil))
	vim.api.nvim_set_hl(0, "TabLineSel",               HIGHLIGHT(self.black.normal,     self.gray.normal,       {bold=true}))
	vim.api.nvim_set_hl(0, "TabLine",                  HIGHLIGHT(self.gray.normal,      self.black.normal,      nil))
end

function PALETTE:set_statusline_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "StatusLine",               HIGHLIGHT(self.gray.normal,      self.black.normal,      nil))
	vim.api.nvim_set_hl(0, "StatusLineBlock",          HIGHLIGHT(self.gray.normal,      self.gray.dark,         {bold=true}))
	vim.api.nvim_set_hl(0, "NormalMode",               HIGHLIGHT(self.black.normal,     self.red.normal,        {bold=true}))
	vim.api.nvim_set_hl(0, "InsertMode",               HIGHLIGHT(self.black.normal,     self.orange.bright,     {bold=true}))
	vim.api.nvim_set_hl(0, "VisualMode",               HIGHLIGHT(self.black.normal,     self.azure.normal,      {bold=true}))
	vim.api.nvim_set_hl(0, "SpecialMode",              HIGHLIGHT(self.black.normal,     self.pink.normal,       {bold=true}))
end

function PALETTE:set_gitsigns_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "GitSignsChange",           HIGHLIGHT(self.yellow.normal,    nil,                    nil))
	vim.api.nvim_set_hl(0, "GitSignsDelete",           HIGHLIGHT(self.red.bright,       nil,                    nil))
end

function PALETTE:set_cmp_colors()
	--                                                           FG                     BG                      ATTR
	-- vim.api.nvim_set_hl(0, "CmpItemMenu",              HIGHLIGHT(nil,                   self.black.bright,      nil))
	vim.api.nvim_set_hl(0, "CmpItemAbbr",              HIGHLIGHT(self.white.dark,       nil,                    nil))
	vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",    HIGHLIGHT(self.white.dark,       nil,                    {strikethrough=true}))
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",         HIGHLIGHT(self.white.normal,     nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",    HIGHLIGHT(self.white.normal,     nil,                    nil))
	vim.api.nvim_set_hl(0, "CmpItemKind",              HIGHLIGHT(self.white.bright,     self.gray.normal,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindVariable",      HIGHLIGHT(self.white.bright,     self.pink.normal,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindInterface",     HIGHLIGHT(self.white.bright,     self.pink.bright,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindText",          HIGHLIGHT(self.white.bright,     self.gray.dark,         nil))
	vim.api.nvim_set_hl(0, "CmpItemKindFunction",      HIGHLIGHT(self.white.bright,     self.azure.normal,      nil))
	vim.api.nvim_set_hl(0, "CmpItemKindMethod",        HIGHLIGHT(self.white.bright,     self.azure.dark,        nil))
	vim.api.nvim_set_hl(0, "CmpItemKindKeyword",       HIGHLIGHT(self.white.bright,     self.red.dark,          nil))
	vim.api.nvim_set_hl(0, "CmpItemKindProperty",      HIGHLIGHT(self.white.bright,     self.blue.dark,         nil))
	vim.api.nvim_set_hl(0, "CmpItemKindField",         HIGHLIGHT(self.white.bright,     self.blue.normal,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindModule",        HIGHLIGHT(self.white.bright,     self.cyan.normal,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindClass",         HIGHLIGHT(self.white.bright,     self.orange.dark,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindStruct",        HIGHLIGHT(self.white.bright,     self.orange.normal,     nil))
	vim.api.nvim_set_hl(0, "CmpItemKindEnum",          HIGHLIGHT(self.white.bright,     self.orange.bright,     nil))
	vim.api.nvim_set_hl(0, "CmpItemKindEnumMember",    HIGHLIGHT(self.white.bright,     self.purple.normal,     nil))
	vim.api.nvim_set_hl(0, "CmpItemKindConstant",      HIGHLIGHT(self.white.bright,     self.purple.dark,       nil))
	vim.api.nvim_set_hl(0, "CmpItemKindValue",         HIGHLIGHT(self.white.bright,     self.green.normal,      nil))
end

function PALETTE:set_telescope_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "TelescopeBorder",          HIGHLIGHT(self.black.bright,     nil,                    nil));
	-- vim.api.nvim_set_hl(0, "TelescopePromptBorder",    highlight(self.black.bright,     nil,                    nil))
	-- vim.api.nvim_set_hl(0, "TelescopePromptNormal",    highlight());
	-- vim.api.nvim_set_hl(0, "TelescopePromptPrefix",    highlight());
	-- vim.api.nvim_set_hl(0, "TelescopeNormal",          highlight());
	-- vim.api.nvim_set_hl(0, "TelescopePreviewTitle",    highlight());
	-- vim.api.nvim_set_hl(0, "TelescopePromptTitle",     highlight());
	-- vim.api.nvim_set_hl(0, "TelescopeResultsTitle",    highlight());
	-- vim.api.nvim_set_hl(0, "TelescopeSelection",       highlight());
	-- vim.api.nvim_set_hl(0, "TelescopePreviewLine",     highlight());
end

function PALETTE:set_dap_colors()
	--                                                           FG                     BG                      ATTR
	vim.api.nvim_set_hl(0, "DapMarks",                 HIGHLIGHT(self.purple.normal,    nil,                    {bold=true}))
	vim.api.nvim_set_hl(0, "DapStep",                  HIGHLIGHT(nil,                   self.black.normal,      nil))
	vim.api.nvim_set_hl(0, "DapStepNr",                HIGHLIGHT(self.purple.normal,    self.black.normal,      {bold=true}))
	-- DapUIVariable  xxx links to Normal
	-- DapUIScope     xxx guifg=#00F1F5
	-- DapUIType      xxx guifg=#D484FF
	-- DapUIValue     xxx links to Normal
	-- DapUIModifiedValue xxx gui=bold guifg=#00F1F5
	-- DapUIDecoration xxx guifg=#00F1F5
	-- DapUIThread    xxx guifg=#A9FF68
	-- DapUIStoppedThread xxx guifg=#00f1f5
	-- DapUIFrameName xxx links to Normal
	-- DapUISource    xxx guifg=#D484FF
	-- DapUILineNumber xxx guifg=#00f1f5
	-- DapUIFloatBorder xxx guifg=#00F1F5
	-- DapUIWatchesEmpty xxx guifg=#F70067
	-- DapUIWatchesValue xxx guifg=#A9FF68
	-- DapUIWatchesError xxx guifg=#F70067
	-- DapUIBreakpointsPath xxx guifg=#00F1F5
	-- DapUIBreakpointsInfo xxx guifg=#A9FF68
	-- DapUIBreakpointsCurrentLine xxx gui=bold guifg=#A9FF68
	-- DapUIBreakpointsLine xxx links to DapUILineNumber
	-- DapUIBreakpointsDisabledLine xxx guifg=#424242
	vim.fn.sign_define('DapBreakpoint',          {text='⬤', texthl='DapMarks', linehl='', numhl=''})
	vim.fn.sign_define('DapBreakpointCondition', {text='◯', texthl='DapMarks', linehl='', numhl=''})
	vim.fn.sign_define('DapBreakpointRejected',  {text='⦻', texthl='DapMarks', linehl='', numhl=''})
	vim.fn.sign_define('DapLogPoint',            {text='□', texthl='DapMarks', linehl='', numhl=''})
	vim.fn.sign_define('DapStopped',             {text='➤', texthl='DapStepNr', linehl='DapStep', numhl='DapStepNr'})
end

--- set all theme highlight groups
function PALETTE:set_colors()
	-- core
	self:set_syntax_colors()
	self:set_ui_colors()
	self:set_diff_colors()
	self:set_spell_colors()
	self:set_tab_colors()
	self:set_statusline_colors()
	-- addons
	self:set_treesitter_colors()
	self:set_gitsigns_colors()
	self:set_telescope_colors()
	self:set_cmp_colors()
	self:set_dap_colors()
end

return PALETTE
