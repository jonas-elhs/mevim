local colors = {
  -- Basics
  accent = "#00ffff",
  foreground = "#ffffff",
  background = "#4e4e4e",

  -- Modes
  normal = "#00ffff", -- highlight
  visual = "#0000ff",
  insert = "#00ff00",
  replace = "#ff0000",
  command = "#ffff00",
  terminal = "#ff00ff",
  inactive = "#7f7f7f",

  -- State
  error = "#ff0000",
  warn = "#ffa500",
  success = "#00ff00",
  info = "#00ffff",
  hint = "#0000ff",

  -- Syntax
  fun = "#92d3d3",
  type = "#347f7f",
  string = "#5c945c",
  comment = "#7f7f7f", -- inactive
  literal = "#2c6d6d",
  keyword = "#43a3a3",
  variable = "#b7e1e1",
  parameter = "#5b4bfb",
  identifier = "#4fb8b8",
  punctuation = "#ffbbbb", -- foreground?

  -- special1
  -- special2
  -- special3
}

-- Transparent Background
for group, value in pairs(vim.api.nvim_get_hl(0, {})) do
  value.bg = "NONE"
  vim.api.nvim_set_hl(0, group, value)
end

-- Mode highlights
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("JonasCurrentModeHighlight", { clear = true }),
  callback = function()
    local mode_color = colors[Utils.get_current_mode_type()]

    vim.api.nvim_set_hl(0, "JonasCurrentMode", {
      fg = colors.background,
      bg = mode_color,
    })
    vim.api.nvim_set_hl(0, "JonasCurrentModeBold", {
      fg = colors.background,
      bg = mode_color,
      bold = true,
    })

    vim.api.nvim_set_hl(0, "JonasCurrentModeReverse", {
      fg = mode_color,
      bg = "NONE",
    })
    vim.api.nvim_set_hl(0, "JonasCurrentModeBoldReverse", {
      fg = mode_color,
      bg = "NONE",
      bold = true,
    })
  end,
})
for color_name, color in pairs(colors) do
  vim.api.nvim_set_hl(0, "Jonas" .. color_name:gsub("^%l", string.upper), {
    fg = colors.background,
    bg = color,
  })
  vim.api.nvim_set_hl(0, "Jonas" .. color_name:gsub("^%l", string.upper) .. "Reverse", {
    fg = color,
    bg = "NONE",
  })
end

-- stylua: ignore
-- Highlight Groups (https://neovim.io/doc/user/syntax.html#_13.-highlight-command)
local highlights = {
  -- EDITOR
  -- ColorColumn            |   cterm=reverse guibg=NvimDarkGrey4                                  |   Used for the columns set with 'colorcolumn'.
  ColorColumn = {},
  -- Conceal                |   guifg=NvimDarkGrey4                                                |   Placeholder characters substituted for concealed text (see 'conceallevel').
    Conceal = { link = "Normal" },
  -- CurSearch              |   ctermfg=0 ctermbg=11 guifg=NvimDarkGrey1 guibg=NvimLightYellow   |   Current match for the last search pattern (see 'hlsearch').
  CurSearch = { fg = colors.background, bg = colors.accent, italic = true },
  -- Cursor                 |   guifg=bg guibg=fg                                                    |   Character under the cursor.
  -- lCursor                |   guifg=bg guibg=fg                                                    |   Character under the cursor when language-mapping is used (see 'guicursor').
  -- CursorIM               |   links to Cursor                                                      |   Like Cursor, but used when in IME mode.
  -- CursorColumn           |   guibg=NvimDarkGrey3                                                |   Screen-column at the cursor, when 'cursorcolumn' is set.
  CursorColumn = {},
  -- CursorLine             |   guibg=NvimDarkGrey3                                                |   Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
  CursorLine = {},
  -- Directory              |   ctermfg=14 guifg=NvimLightCyan                                     |   Directory names (and other special names in listings).
  Directory = { fg = colors.accent },
  -- DiffAdd                |   ctermfg=0 ctermbg=10 guifg=NvimLightGrey1 guibg=NvimDarkGreen    |   Diff mode: Added line. diff.txt
    DiffAdd = { link = "Normal" },
  -- DiffChange             |   guifg=NvimLightGrey1 guibg=NvimDarkGrey4                         |   Diff mode: Changed line. diff.txt
    DiffChange = { link = "Normal" },
  -- DiffDelete             |   cterm=bold ctermfg=9 gui=bold guifg=NvimLightRed                   |   Diff mode: Deleted line. diff.txt
    DiffDelete = { link = "Normal" },
  -- DiffText               |   ctermfg=0 ctermbg=14 guifg=NvimLightGrey1 guibg=NvimDarkCyan     |   Diff mode: Changed text within a changed line. diff.txt
    DiffText = { link = "Normal" },
  -- DiffTextAdd            |   links to DiffText                                                    |   Diff mode: Added text within a changed line. Linked to hl-DiffText by default. diff.txt
  -- EndOfBuffer            |   links to NonText                                                     |   Filler lines (~) after the last line in the buffer. By default, this is highlighted like hl-NonText.
  -- TermCursor             |   cterm=reverse gui=reverse                                            |   Cursor in a focused terminal.
    TermCursor = { link = "Normal" },
  -- OkMsg                  |   ctermfg=10 guifg=NvimLightGreen                                    |   Success messages.
  OkMsg = { fg = colors.success },
  -- WarningMsg             |   ctermfg=11 guifg=NvimLightYellow                                   |   Warning messages.
  WarningMsg = { fg = colors.warn },
  -- ErrorMsg               |   ctermfg=9 guifg=NvimLightRed                                       |   Error messages.
  ErrorMsg = { fg = colors.error },
  -- StderrMsg              |   links to ErrorMsg                                                    |   Messages in stderr from shell commands.
  -- StdoutMsg              |   cleared                                                              |   Messages in stdout from shell commands.
  -- WinSeparator           |   links to Normal                                                      |   Separators between window splits.
  -- WinSeparator = { fg = colors.inactive },
  -- Folded                 |   guifg=NvimLightGrey4 guibg=NvimDarkGrey1                         |   Line used for closed folds.
  Folded = { bg = colors.inactive },
  -- FoldColumn             |   links to SignColumn                                                  |   'foldcolumn'
  -- SignColumn             |   guifg=NvimDarkGrey4                                                |   Column where signs are displayed.
  SignColumn = {},
  -- IncSearch              |   links to CurSearch                                                   |   'incsearch' highlighting; also used for the text replaced with ":s///c".
  -- Substitute             |   links to Search                                                      |   :substitute replacement text highlighting.
  -- LineNr                 |   guifg=NvimDarkGrey4                                                |   Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  LineNr = { fg = colors.dark },
  -- LineNrAbove            |   links to LineNr                                                      |   Line number for when the 'relativenumber' option is set, above the cursor line.
  -- LineNrBelow            |   links to LineNr                                                      |   Line number for when the 'relativenumber' option is set, below the cursor line.
  -- CursorLineNr           |   cterm=bold gui=bold                                                  |   Like LineNr when 'cursorline' is set and 'cursorlineopt' contains "number" or is "both", for the cursor line.
  CursorLineNr = { link = "JonasCurrentModeBoldReverse" },
  -- CursorLineFold         |   links to FoldColumn                                                  |   Like FoldColumn when 'cursorline' is set for the cursor line.
  -- CursorLineSign         |   links to SignColumn                                                  |   Like SignColumn when 'cursorline' is set for the cursor line.
  -- MatchParen             |   cterm=bold,underline gui=bold guibg=NvimDarkGrey4                  |   Character under the cursor or just before it, if it is a paired bracket, and its match. pi_paren.txt
  MatchParen = { bold = true },
  -- ModeMsg                |   ctermfg=10 guifg=NvimLightGreen                                    |   'showmode' message (e.g., "-- INSERT --").
  ModeMsg = {},
  -- MsgArea                |   cleared                                                              |   Area for messages and command-line, see also 'cmdheight'.
  -- MsgSeparator           |   links to StatusLine                                                  |   Separator for scrolled messages msgsep.
  -- MoreMsg                |   ctermfg=14 guifg=NvimLightCyan                                     |   more-prompt
  MoreMsg = { fg = colors.accent },
  -- NonText                |   guifg=NvimDarkGrey4                                                |   '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also hl-EndOfBuffer.
  NonText = { fg = colors.dark, italic = true },
  -- Normal                 |   guifg=#e0e2ea                                                      |   Normal text.
  Normal = { fg = colors.foreground },
  -- NormalFloat            |   guibg=NvimDarkGrey1                                                |   Normal text in floating windows.
  NormalFloat = { link = "Normal" },
  -- FloatBorder            |   links to NormalFloat                                                 |   Border of floating windows.
  -- FloatShadow            |   ctermbg=0 guibg=NvimDarkGrey4 blend=80                             |   Blended areas when border is "shadow".
  FloatShadow = {},
  -- FloatShadowThrough     |   ctermbg=0 guibg=NvimDarkGrey4 blend=100                            |   Shadow corners when border is "shadow".
  FloatShadowThrough = {},
  -- FloatTitle             |   links to Title                                                       |   Title of floating windows.
  -- FloatFooter            |   links to FloatTitle                                                  |   Footer of floating windows.
  -- NormalNC               |   cleared                                                              |   Normal text in non-current windows.
  -- Pmenu                  |   cterm=reverse guibg=NvimDarkGrey3                                  |   Popup menu: Normal item.
  Pmenu = { link = "Normal" },
  -- PmenuSel               |   cterm=underline,reverse gui=reverse blend=0                          |   Popup menu: Selected item. Combined with hl-Pmenu.
  PmenuSel = { reverse = true, italic = true },
  -- PmenuKind              |   links to Pmenu                                                       |   Popup menu: Normal item "kind".
  -- PmenuKindSel           |   links to PmenuSel                                                    |   Popup menu: Selected item "kind".
  -- PmenuExtra             |   links to Pmenu                                                       |   Popup menu: Normal item "extra text".
  -- PmenuExtraSel          |   links to PmenuSel                                                    |   Popup menu: Selected item "extra text".
  -- PmenuSbar              |   links to Pmenu                                                       |   Popup menu: Scrollbar.
  -- PmenuThumb             |   guibg=NvimDarkGrey4                                                |   Popup menu: Thumb of the scrollbar.
  PmenuThumb = { bg = colors.foreground },
  -- PmenuMatch             |   cterm=bold gui=bold                                                  |   Popup menu: Matched text in normal item. Combined with hl-Pmenu.
  PmenuMatch = { fg = colors.accent, italic = true },
  -- PmenuMatchSel          |   cterm=bold gui=bold                                                  |   Popup menu: Matched text in selected item. Combined with hl-PmenuMatch and hl-PmenuSel.
  PmenuMatchSel = { link = "PmenuMatch" },
  -- PmenuBorder            |   links to Pmenu                                                       |   Popup menu: border of popup menu.
  -- PmenuShadow            |   ctermbg=0 guibg=NvimDarkGrey4 blend=100                            |   Popup menu: blended areas when 'pumborder' is "shadow".
  PmenuShadow = {},
  -- PmenuShadowThrough     |   links to FloatShadowThrough                                          |   Popup menu: shadow corners when 'pumborder' is "shadow".
  -- ComplMatchIns          |   cleared                                                              |   Matched text of the currently inserted completion.
  -- PreInsert              |   links to Added                                                       |   Text inserted when "preinsert" is in 'completeopt'.
  -- ComplHint              |   links to NonText                                                     |   Virtual text of the currently selected completion.
  -- ComplHintMore          |   links to MoreMsg                                                     |   The additional information of the virtual text.
  -- Question               |   ctermfg=14 guifg=NvimLightCyan                                     |   hit-enter prompt and yes/no questions.
    Question = { link = "Normal" },
  -- QuickFixLine           |   ctermfg=14 guifg=NvimLightCyan                                     |   Current quickfix item in the quickfix window. Combined with hl-CursorLine when the cursor is there.
    QuickFixLine = { link = "Normal" },
  -- Search                 |   ctermfg=0 ctermbg=11 guifg=NvimLightGrey1 guibg=NvimDarkYellow   |   Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
  Search = { fg = colors.accent, italic = true },
  -- SnippetTabstop         |   links to Visual                                                      |   Tabstops in snippets. vim.snippet
  -- SnippetTabstopActive   |   links to SnippetTabstop                                              |   The currently active tabstop. vim.snippet
  -- SpecialKey             |   guifg=NvimDarkGrey4                                                |   Unprintable characters: Text displayed differently from what it really is. But not 'listchars' whitespace. hl-Whitespace
    SpecialKey = { link = "Normal" },
  -- SpellBad               |   cterm=undercurl gui=undercurl guisp=NvimLightRed                   |   Word that is not recognized by the spellchecker. spell Combined with the highlighting used otherwise.
    SpellBad = { link = "Normal" },
  -- SpellCap               |   cterm=undercurl gui=undercurl guisp=NvimLightYellow                |   Word that should start with a capital. spell Combined with the highlighting used otherwise.
    SpellCap = { link = "Normal" },
  -- SpellLocal             |   cterm=undercurl gui=undercurl guisp=NvimLightGreen                 |   Word that is recognized by the spellchecker as one that is used in another region. spell Combined with the highlighting used otherwise.
    SpellLocal = { link = "Normal" },
  -- SpellRare              |   cterm=undercurl gui=undercurl guisp=NvimLightCyan                  |   Word that is recognized by the spellchecker as one that is hardly ever used. spell Combined with the highlighting used otherwise.
    SpellRare = { link = "Normal" },
  -- StatusLine             |   cterm=reverse guifg=NvimDarkGrey3 guibg=NvimLightGrey3           |   Status line of current window.
  StatusLine = {},
  -- StatusLineNC           |   cterm=bold,underline guifg=NvimLightGrey2 guibg=NvimDarkGrey4    |   Status lines of not-current windows.
  StatusLineNC = {},
  -- StatusLineTerm         |   links to StatusLine                                                  |   Status line of terminal window.
  -- StatusLineTermNC       |   links to StatusLineNC                                                |   Status line of non-current terminal windows.
  -- TabLine                |   links to StatusLineNC                                                |   Tab pages line, not active tab page label.
  -- TabLineFill            |   links to TabLine                                                     |   Tab pages line, where there are no labels.
  -- TabLineSel             |   gui=bold                                                             |   Tab pages line, active tab page label.
  -- Title                  |   cterm=bold gui=bold guifg=NvimLightGrey2                           |   Titles for output from ":set all", ":autocmd" etc.
  Title = { fg = colors.accent },
  -- Visual                 |   ctermfg=0 ctermbg=15 guibg=NvimDarkGrey4                           |   Visual mode selection.
  Visual = { fg = colors.background, bg = colors.foreground },
  -- VisualNOS              |   links to Visual                                                      |   Visual mode selection when vim is "Not Owning the Selection".
  -- Whitespace             |   links to NonText                                                     |   "nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'.
  -- WildMenu               |   links to PmenuSel                                                    |   Current match in 'wildmenu' completion.
  -- WinBar                 |   cterm=bold gui=bold guifg=NvimLightGrey4 guibg=NvimDarkGrey1     |   Window bar of current window.
  WinBar = {},
  -- WinBarNC               |   cterm=bold guifg=NvimLightGrey4 guibg=NvimDarkGrey1              |   Window bar of not-current windows.
  WinBarNC = {},

  -- SYNTAX
  -- Comment          |   guifg=NvimLightGrey4                                           |   any comment
  Comment = { fg = colors.comment },
  -- Constant         |   guifg=NvimLightGrey2                                           |   any constant
  Constant = { fg = colors.literal },
  -- String           |   ctermfg=10 guifg=NvimLightGreen                                |   a string constant: "this is a string"
  String = { fg = colors.string },
  -- Character        |   links to Constant                                                |   a character constant: 'c', '\n'
  Character = { link = "String" },
  -- Number           |   links to Constant                                                |   a number constant: 234, 0xff
  -- Boolean          |   links to Constant                                                |   a boolean constant: TRUE, false
  -- Float            |   links to Number                                                  |   a floating point constant: 2.3e10
  -- Identifier       |   ctermfg=12 guifg=NvimLightBlue                                 |   any variable name
  Identifier = { fg = colors.identifier },
  -- Function         |   ctermfg=14 guifg=NvimLightCyan                                 |   function name (also: methods for classes)
  Function = { fg = colors.fun },
  -- Statement        |   cterm=bold gui=bold guifg=NvimLightGrey2                       |   any statement
  Statement = { fg = colors.keyword },
  -- Conditional      |   links to Statement                                               |   if, then, else, endif, switch, etc.
  -- Repeat           |   links to Statement                                               |   for, do, while, etc.
  -- Label            |   links to Statement                                               |   case, default, etc.
  -- Operator         |   guifg=NvimLightGrey2                                           |   "sizeof", "+", "*", etc.
  Operator = { fg = colors.foreground },
  -- Keyword          |   links to Statement                                               |   any other keyword
  -- Exception        |   links to Statement                                               |   try, catch, throw
  -- PreProc          |   guifg=NvimLightGrey2                                           |   generic Preprocessor
  PreProc = { fg = colors.preprocessor},
  -- Include          |   links to PreProc                                                 |   preprocessor #include
  -- Define           |   links to PreProc                                                 |   preprocessor #define
  -- Macro            |   links to PreProc                                                 |   same as Define
  -- PreCondit        |   links to PreProc                                                 |   preprocessor #if, #else, #endif, etc.
  -- Type             |   guifg=NvimLightGrey2                                           |   int, long, char, etc.
  Type = { fg = colors.type },
  -- StorageClass     |   links to Type                                                    |   static, register, volatile, etc.
  -- Structure        |   links to Type                                                    |   struct, union, enum, etc.
  -- Typedef          |   links to Type                                                    |   a typedef
  -- Special          |   ctermfg=14 guifg=NvimLightCyan                                 |   any special symbol
  Special = { fg = colors.special1 },
  -- SpecialChar      |   links to Special                                                 |   special character in a constant
  -- Tag              |   links to Special                                                 |   you can use CTRL-] on this
  -- Delimiter        |   guifg=NvimLightGrey2                                           |   character that needs attention
  Delimiter = { fg = colors.foreground },
  -- SpecialComment   |   links to Special                                                 |   special things inside a comment
  -- Debug            |   links to Special                                                 |   debugging statements
  -- Underlined       |   cterm=underline gui=underline                                    |   text that stands out, HTML links
  -- Ignore           |   links to Normal                                                  |   left blank, hidden
  -- Error            |   ctermfg=0 ctermbg=9 guifg=NvimLightGrey1 guibg=NvimDarkRed   |   any erroneous construct
    Error = { link = "Normal" },
  -- Todo             |   cterm=bold gui=bold guifg=NvimLightGrey2                       |   anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Todo = { link = "Normal" },
  -- Added            |   ctermfg=10 guifg=NvimLightGreen                                |   added line in a diff
  Added = { fg = colors.success },
  -- Changed          |   ctermfg=14 guifg=NvimLightCyan                                 |   changed line in a diff
  Changed = { fg = colors.info },
  -- Removed          |   ctermfg=9 guifg=NvimLightRed                                   |   removed line in a diff
  Removed = { fg = colors.error },

  -- DIAGNOSTIC
  -- DiagnosticError   |   ctermfg=9 guifg=NvimLightRed       |   Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticError = { fg = colors.error },
  -- DiagnosticWarn    |   ctermfg=11 guifg=NvimLightYellow   |   Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticWarn = { fg = colors.warn },
  -- DiagnosticInfo    |   ctermfg=14 guifg=NvimLightCyan     |   Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticInfo = { fg = colors.info },
  -- DiagnosticHint    |   ctermfg=12 guifg=NvimLightBlue     |   Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticHint = { fg = colors.hint },
  -- DiagnosticOk      |   ctermfg=10 guifg=NvimLightGreen    |   Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticOk = { fg = colors.success },
  --
  -- DiagnosticVirtualTextError   |   links to DiagnosticError   |   Used for "Error" diagnostic virtual text.
  -- DiagnosticVirtualTextWarn    |   links to DiagnosticWarn    |   Used for "Warn" diagnostic virtual text.
  -- DiagnosticVirtualTextInfo    |   links to DiagnosticInfo    |   Used for "Info" diagnostic virtual text.
  -- DiagnosticVirtualTextHint    |   links to DiagnosticHint    |   Used for "Hint" diagnostic virtual text.
  -- DiagnosticVirtualTextOk      |   links to DiagnosticOk      |   Used for "Ok" diagnostic virtual text.
  --
  -- DiagnosticVirtualLinesError   |   links to DiagnosticError   |   Used for "Error" diagnostic virtual lines.
  -- DiagnosticVirtualLinesWarn    |   links to DiagnosticWarn    |   Used for "Warn" diagnostic virtual lines.
  -- DiagnosticVirtualLinesInfo    |   links to DiagnosticInfo    |   Used for "Info" diagnostic virtual lines.
  -- DiagnosticVirtualLinesHint    |   links to DiagnosticHint    |   Used for "Hint" diagnostic virtual lines.
  -- DiagnosticVirtualLinesOk      |   links to DiagnosticOk      |   Used for "Ok" diagnostic virtual lines.
  --
  -- DiagnosticUnderlineError   |   cterm=underline gui=underline guisp=NvimLightRed      |   Used to underline "Error" diagnostics.
  -- DiagnosticUnderlineWarn    |   cterm=underline gui=underline guisp=NvimLightYellow   |   Used to underline "Warn" diagnostics.
  -- DiagnosticUnderlineInfo    |   cterm=underline gui=underline guisp=NvimLightCyan     |   Used to underline "Info" diagnostics.
  -- DiagnosticUnderlineHint    |   cterm=underline gui=underline guisp=NvimLightBlue     |   Used to underline "Hint" diagnostics.
  -- DiagnosticUnderlineOk      |   cterm=underline gui=underline guisp=NvimLightGreen    |   Used to underline "Ok" diagnostics.
  --
  -- DiagnosticFloatingError   |   links to DiagnosticError   |   Used to color "Error" diagnostic messages in diagnostics float. See vim.diagnostic.open_float()
  -- DiagnosticFloatingWarn    |   links to DiagnosticWarn    |   Used to color "Warn" diagnostic messages in diagnostics float.
  -- DiagnosticFloatingInfo    |   links to DiagnosticInfo    |   Used to color "Info" diagnostic messages in diagnostics float.
  -- DiagnosticFloatingHint    |   links to DiagnosticHint    |   Used to color "Hint" diagnostic messages in diagnostics float.
  -- DiagnosticFloatingOk      |   links to DiagnosticOk      |   Used to color "Ok" diagnostic messages in diagnostics float.
  --
  -- DiagnosticSignError   |   links to DiagnosticError   |   Used for "Error" signs in sign column.
  -- DiagnosticSignWarn    |   links to DiagnosticWarn    |   Used for "Warn" signs in sign column.
  -- DiagnosticSignInfo    |   links to DiagnosticInfo    |   Used for "Info" signs in sign column.
  -- DiagnosticSignHint    |   links to DiagnosticHint    |   Used for "Hint" signs in sign column.
  -- DiagnosticSignOk      |   links to DiagnosticOk      |   Used for "Ok" signs in sign column.
  --
  -- DiagnosticDeprecated    |   cterm=strikethrough gui=strikethrough guisp=NvimLightRed   |   Used for deprecated or obsolete code.
  -- DiagnosticUnnecessary   |   links to Comment                                             |   Used for unnecessary or unused code.

  -- TREESITTER
  -- @variable                     |   guifg=NvimLightGrey2   |   various variable names
  ["@variable"] = { fg = colors.variable },
  -- @variable.builtin             |   links to Special         |   built-in variable names (e.g. this, self)
  -- @variable.parameter           |   links to Special         |   parameters of a function
  ["@variable.parameter"] = { fg = colors.parameter },
  -- @variable.parameter.builtin   |                            |   special parameters (e.g. _, it)
  -- @variable.member              |                            |   object and struct fields
  -- @constant                     |   links to Constant        |   constant identifiers
  -- @constant.builtin             |   links to Special         |   built-in constant values
  -- @constant.macro               |                            |   constants defined by the preprocessor
  --
  -- @module           |   links to Structure   |   modules or namespaces
  -- @module.builtin   |   links to Special     |   built-in modules or namespaces
  --
  -- @label                   |   links to Label             |   GOTO and other labels (e.g. label: in C), including heredoc labels
  -- @string                  |   links to String            |   string literals
  -- @string.documentation    |                              |   string documenting code (e.g. Python docstrings)
  -- @string.regexp           |   links to @string.special   |   regular expressions
  -- @string.escape           |   links to @string.special   |   escape sequences
  -- @string.special          |   links to SpecialChar       |   other special strings (e.g. dates)
  -- @string.special.symbol   |                              |   symbols or atoms
  -- @string.special.path     |                              |   filenames
  -- @string.special.url      |   links to Underlined        |   URIs (e.g. hyperlinks)
  -- @character               |   links to Character         |   character literals
  -- @character.special       |   links to Character         |   special characters (e.g. wildcards)
  --
  -- @boolean        |   links to Boolean   |   boolean literals
  -- @number         |   links to Number    |   numeric literals
  -- @number.float   |   links to Float     |   floating-point number literals
  --
  -- @type              |   links to Type      |   type or class definitions and annotations
  -- @type.builtin      |   links to Special   |   built-in types
  -- @type.definition   |                      |   identifiers in type definitions (e.g. typedef <type> <identifier> in C)
  --
  -- @attribute           |   links to Macro        |   attribute annotations (e.g. Python decorators, Rust lifetimes)
  ["@attribute"] = { link = "Constant" },
  -- @attribute.builtin   |   links to Special      |   builtin annotations (e.g. Python)
  -- @property            |   links to Identifier   |   the key in key/value pairs
  --
  -- @function               |   links to Function   |   function definitions
  -- @function.builtin       |   links to Special    |   built-in functions
  -- @function.call          |                       |   function calls
  -- @function.macro         |                       |   preprocessor macros
  -- @function.method        |                       |   method definitions
  -- @function.method.call   |                       |   method calls
  -- @constructor            |   links to Special    |   constructor calls and definitions
  ["@constructor.lua"] = { fg = colors.foreground },
  --
  -- @operator                     |   links to Operator   |   symbolic operators (e.g. +, *)
  -- @keyword                      |   links to Keyword    |   keywords not fitting into specific categories
  -- @keyword.coroutine            |                       |   keywords related to coroutines (e.g. go in Go, async/await in Python)
  -- @keyword.function             |                       |   keywords that define a function (e.g. func in Go, def in Python)
  -- @keyword.operator             |                       |   operators that are English words (e.g. and, or)
  -- @keyword.import               |                       |   keywords for including or exporting modules (e.g. import, from in Python)
  -- @keyword.type                 |                       |   keywords describing namespaces and composite types (e.g. struct, enum)
  -- @keyword.modifier             |                       |   keywords modifying other constructs (e.g. const, static, public)
  -- @keyword.repeat               |                       |   keywords related to loops (e.g. for, while)
  -- @keyword.return               |                       |   keywords like return and yield
  -- @keyword.debug                |                       |   keywords related to debugging
  -- @keyword.exception            |                       |   keywords related to exceptions (e.g. throw, catch)
  -- @keyword.conditional          |                       |   keywords related to conditionals (e.g. if, else)
  -- @keyword.conditional.ternary  |                       |   ternary operator (e.g. ?, :)
  -- @keyword.directive            |                       |   various preprocessor directives and shebangs
  -- @keyword.directive.define     |                       |   preprocessor definition directives
  --
  -- @punctuation.delimiter   |   links to Delimiter   |   delimiters (e.g. ;, ., ,)
  -- @punctuation.bracket     |                        |   brackets (e.g. (), {}, [])
  ["@punctuation.bracket"] = { fg = colors.foreground },
  -- @punctuation.special     |   links to Special     |   special symbols (e.g. {} in string interpolation)
  --
  -- @comment                 |   links to Comment           |   line and block comments
  -- @comment.documentation   |                              |   comments documenting code
  -- @comment.error           |   links to DiagnosticError   |   error-type comments (e.g. ERROR, FIXME, DEPRECATED)
  -- @comment.warning         |   links to DiagnosticWarn    |   warning-type comments (e.g. WARNING, FIX, HACK)
  -- @comment.todo            |   links to Todo              |   todo-type comments (e.g. TODO, WIP)
  -- @comment.note            |   links to DiagnosticInfo    |   note-type comments (e.g. NOTE, INFO, XXX)
  --
  -- @markup                  |   links to Special                        |
  -- @markup.strong           |   cterm=bold gui=bold                     |   bold text
  -- @markup.italic           |   cterm=italic gui=italic                 |   italic text
  -- @markup.strikethrough    |   cterm=strikethrough gui=strikethrough   |   struck-through text
  -- @markup.underline        |   cterm=underline gui=underline           |   underlined text (only for literal underline markup!)
  -- @markup.heading          |   links to Title                          |   headings, titles (including markers)
  -- @markup.heading.1        |                                           |   top-level heading
  -- @markup.heading.2        |                                           |   section heading
  -- @markup.heading.3        |                                           |   subsection heading
  -- @markup.heading.4        |                                           |   and so on
  -- @markup.heading.5        |                                           |   and so forth
  -- @markup.heading.6        |                                           |   six levels ought to be enough for anybody
  -- @markup.quote            |                                           |   block quotes
  -- @markup.math             |                                           |   math environments (e.g. $ ... $ in LaTeX)
  -- @markup.link             |   links to Underlined                     |   text references, footnotes, citations, etc.
  -- @markup.link.label       |                                           |   link, reference descriptions
  -- @markup.link.url         |                                           |   URL-style links
  -- @markup.raw              |                                           |   literal or verbatim text (e.g. inline code)
  -- @markup.raw.block        |                                           |   literal or verbatim text as a stand-alone block
  -- @markup.list             |                                           |   list markers
  -- @markup.list.checked     |                                           |   checked todo-style list markers
  -- @markup.list.unchecked   |                                           |   unchecked todo-style list markers
  --
  -- @diff         |   cleared            |
  -- @diff.plus    |   links to Added     |   added text (for diff files)
  -- @diff.minus   |   links to Removed   |   deleted text (for diff files)
  -- @diff.delta   |   links to Changed   |   changed text (for diff files)
  --
  -- @tag             |   links to Tag       |   XML-style tag names (e.g. in XML, HTML, etc.)
  -- @tag.builtin     |   links to Special   |   builtin tag names (e.g. HTML5 tags)
  -- @tag.attribute   |                      |   XML-style tag attributes
  -- @tag.delimiter   |                      |   XML-style tag delimiters

  -- LSP
  -- @lsp                      |   cleared                        |
  -- @lsp.type.class           |   links to @type                 |   Identifiers that declare or reference a class type
  -- @lsp.type.comment         |   links to @comment              |   Tokens that represent a comment
  -- @lsp.type.decorator       |   links to @attribute            |   Identifiers that declare or reference decorators and annotations
  -- @lsp.type.enum            |   links to @type                 |   Identifiers that declare or reference an enumeration type
  -- @lsp.type.enumMember      |   links to @constant             |   Identifiers that declare or reference an enumeration property, constant, or member
  -- @lsp.type.event           |   links to @type                 |   Identifiers that declare an event property
  -- @lsp.type.function        |   links to @function             |   Identifiers that declare a function
  -- @lsp.type.interface       |   links to @type                 |   Identifiers that declare or reference an interface type
  -- @lsp.type.keyword         |   links to @keyword              |   Tokens that represent a language keyword
  -- @lsp.type.macro           |   links to @constant.macro       |   Identifiers that declare a macro
  -- @lsp.type.method          |   links to @function.method      |   Identifiers that declare a member function or method
  -- @lsp.type.modifier        |   links to @type.qualifier       |   Tokens that represent a modifier
  -- @lsp.type.namespace       |   links to @module               |   Identifiers that declare or reference a namespace, module, or package
  -- @lsp.type.number          |   links to @number               |   Tokens that represent a number literal
  -- @lsp.type.operator        |   links to @operator             |   Tokens that represent an operator
  -- @lsp.type.parameter       |   links to @variable.parameter   |   Identifiers that declare or reference a function or method parameters
  -- @lsp.type.property        |   links to @property             |   Identifiers that declare or reference a member property, member field, or member variable
  -- @lsp.type.regexp          |   links to @string.regexp        |   Tokens that represent a regular expression literal
  -- @lsp.type.string          |   links to @string               |   Tokens that represent a string literal
  -- @lsp.type.struct          |   links to @type                 |   Identifiers that declare or reference a struct type
  -- @lsp.type.type            |   links to @type                 |   Identifiers that declare or reference a type that is not covered above
  -- @lsp.type.typeParameter   |   links to @type.definition      |   Identifiers that declare or reference a type parameter
  -- @lsp.type.variable        |   links to @variable             |   Identifiers that declare or reference a local or global variable
  --
  -- @lsp.mod.abstract         |                                   |   Types and member functions that are abstract
  -- @lsp.mod.async            |                                   |   Functions that are marked async
  -- @lsp.mod.declaration      |                                   |   Declarations of symbols
  -- @lsp.mod.defaultLibrary   |                                   |   Symbols that are part of the standard library
  -- @lsp.mod.definition       |                                   |   Definitions of symbols, for example, in header files
  -- @lsp.mod.deprecated       |   links to DiagnosticDeprecated   |   Symbols that should no longer be used
  -- @lsp.mod.documentation    |                                   |   Occurrences of symbols in documentation
  -- @lsp.mod.modification     |                                   |   Variable references where the variable is assigned to
  -- @lsp.mod.readonly         |                                   |   Readonly variables and member fields (constants)
  -- @lsp.mod.static           |                                   |   Class members (static members)

  -- PLUGINS
  -- Blink Cmp
  -- Blink Pairs
  -- Gitsigns
  -- Leap
  -- Colorful Winsep
  -- Noice
  -- Snacks Dashboard
  -- Snacks Indent
  -- Snacks Notifier
}

for highlight, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, highlight, spec)
end

-- MISSING
-- VertSplit      xxx links to WinSeparator
-- VisualNC       xxx cleared
-- RedrawDebugNormal xxx cterm=reverse gui=reverse
-- Normal         xxx guifg=NvimLightGrey2 guibg=NvimDarkGrey2
-- Italic         xxx cleared
-- Bold           xxx cleared
-- None           xxx cleared
--
-- @spell         xxx cleared
-- @namespace     xxx cleared
-- @nospell       xxx cleared
--
-- LspCodeLens    xxx links to NonText
-- LspCodeLensSeparator xxx links to LspCodeLens
-- LspInlayHint   xxx links to NonText
-- LspReferenceRead xxx links to LspReferenceText
-- LspReferenceText xxx links to Visual
-- LspReferenceWrite xxx links to LspReferenceText
-- LspReferenceTarget xxx links to LspReferenceText
-- LspSignatureActiveParameter xxx links to Visual
