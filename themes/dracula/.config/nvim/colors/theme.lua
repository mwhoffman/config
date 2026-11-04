-- The highlight groups are those of dracula.nvim
-- (https://github.com/Mofiqul/dracula.nvim), which has this license:
--
-- MIT License
--
-- Copyright (c) 2021 Mofiqul Islam
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- The theme's colors.
local colors = {
  black = "#21222c",
  red = "#ff5555",
  green = "#50fa7b",
  yellow = "#f1fa8c",
  blue = "#bd93f9",
  magenta = "#ff79c6",
  cyan = "#8be9fd",
  white = "#f8f8f2",
  bright_black = "#6272a4",
  bright_red = "#ff6e6e",
  bright_green = "#69ff94",
  bright_yellow = "#ffffa5",
  bright_blue = "#d6acff",
  bright_magenta = "#ff92df",
  bright_cyan = "#a4ffff",
  bright_white = "#ffffff",
  accent1 = "#ffb86c",
  bg_hard = "#21222c",
  bg0 = "#282a36",
  bg1 = "#343746",
  bg2 = "#424450",
  bg3 = "#44475a",
  fg0 = "#f8f8f2",
  fg2 = "#afb0b0",
}
local ui = {
  background = "#282a36",
  panel = "#343746",
  text = "#f8f8f2",
  selection_bg = "#44475a",
  current_bg = "#424450",
  border = "#424450",
  current_fg = "#f8f8f2",
}
local search = {
  match = "#ffffa5",
  current = "#ffb86c",
  text = "#21222c",
}
local file = {
  directory = "#bd93f9",
}
local git = {
  added = "#69ff94",
  modified = "#f1fa8c",
  deleted = "#ff6e6e",
  untracked = "#ff5555",
}
local diff = {
  added = "#34684b",
  changed = "#554a70",
  deleted = "#68373f",
}
local diagnostics = {
  error = "#ff6e6e",
  warning = "#ffffa5",
  info = "#d6acff",
  hint = "#a4ffff",
  ok = "#69ff94",
}
local picker = {
  match = "#ffb86c",
}

-- dracula.nvim's options, as they are by default.
local config = {
  italic_comment = false,
  show_end_of_buffer = false,
}

if vim.g.colors_name then
  vim.cmd.hi("clear")
end
vim.g.colors_name = "theme"
vim.o.termguicolors = true
vim.o.background = "dark"

-- The colors of nvim's terminal: the 16 ANSI colors.
vim.g.terminal_color_0 = colors.black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.bright_black
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white

-- dracula.nvim's colors that its groups use, by its names. Those beyond
-- Dracula's spec (menu, visual, nontext, and its grey white and darkest black)
-- are the theme's nearest.
local c = {
  bg = colors.bg0,
  fg = colors.fg0,
  selection = colors.bg3,
  comment = colors.bright_black,
  red = colors.red,
  orange = colors.accent1,
  yellow = colors.yellow,
  green = colors.green,
  purple = colors.blue,
  cyan = colors.cyan,
  pink = colors.magenta,
  bright_red = colors.bright_red,
  bright_green = colors.bright_green,
  bright_blue = colors.bright_blue,
  bright_magenta = colors.bright_magenta,
  bright_cyan = colors.bright_cyan,
  bright_white = colors.bright_white,
  menu = colors.bg_hard,
  visual = colors.bg2,
  nontext = colors.bg2,
  white = colors.fg2,
  black = colors.bg_hard,
}

local endOfBuffer = {
  fg = config.show_end_of_buffer and c.visual or c.bg,
}

-- dracula.nvim's highlight groups.

local groups = {
  Normal = { fg = c.fg, bg = c.bg, },
  NormalFloat = { fg = c.fg, bg = c.bg, },
  Comment = { fg = c.comment, italic = config.italic_comment, },
  Constant = { fg = c.yellow, },
  String = { fg = c.yellow, },
  Character = { fg = c.green, },
  Number = { fg = c.orange, },
  Boolean = { fg = c.cyan, },
  Float = { fg = c.orange, },
  FloatBorder = { fg = c.white, },
  Operator = { fg = c.purple, },
  Keyword = { fg = c.cyan, },
  Keywords = { fg = c.cyan, },
  Identifier = { fg = c.cyan, },
  Function = { fg = c.yellow, },
  Statement = { fg = c.purple, },
  Conditional = { fg = c.pink, },
  Repeat = { fg = c.pink, },
  Label = { fg = c.cyan, },
  Exception = { fg = c.purple, },
  PreProc = { fg = c.yellow, },
  Include = { fg = c.purple, },
  Define = { fg = c.purple, },
  Title = { fg = c.cyan, },
  Macro = { fg = c.purple, },
  PreCondit = { fg = c.cyan, },
  Type = { fg = c.cyan, },
  StorageClass = { fg = c.pink, },
  Structure = { fg = c.yellow, },
  TypeDef = { fg = c.yellow, },
  Special = { fg = c.green, italic = true },
  SpecialComment = { fg = c.comment, italic = true, },
  Error = { fg = c.bright_red, },
  Todo = { fg = c.purple, bold = true, italic = true, },
  Underlined = { fg = c.cyan, underline = true, },

  Cursor = { reverse = true, },
  CursorLineNr = { fg = c.fg, bold = true, },

  SignColumn = { bg = c.bg, },

  Conceal = { fg = c.comment, },
  CursorColumn = { bg = c.black, },
  CursorLine = { bg = c.selection, },
  ColorColumn = { bg = c.selection, },

  StatusLine = { fg = c.white, bg = c.selection, },
  StatusLineNC = { fg = c.comment, },
  StatusLineTerm = { fg = c.white, bg = c.black, },
  StatusLineTermNC = { fg = c.comment, },

  Directory = { fg = c.cyan, },
  DiffAdd = { fg = c.bg, bg = c.green, },
  DiffChange = { fg = c.orange, },
  DiffDelete = { fg = c.red, },
  DiffText = { fg = c.comment, },

  ErrorMsg = { fg = c.bright_red, },
  VertSplit = { fg = c.black, },
  WinSeparator = { fg = c.black, },
  Folded = { fg = c.comment, },
  FoldColumn = {},
  Search = { fg = c.black, bg = c.orange, },
  IncSearch = { fg = c.orange, bg = c.comment, },
  LineNr = { fg = c.comment, },
  MatchParen = { fg = c.fg, underline = true, },
  NonText = { fg = c.nontext, },
  Pmenu = { fg = c.white, bg = c.menu, },
  PmenuSel = { fg = c.white, bg = c.selection, },
  PmenuSbar = { bg = c.bg, },
  PmenuThumb = { bg = c.selection, },

  Question = { fg = c.purple, },
  QuickFixLine = { fg = c.black, bg = c.yellow, },
  SpecialKey = { fg = c.nontext, },

  SpellBad = { fg = c.bright_red, underline = true, },
  SpellCap = { fg = c.yellow, },
  SpellLocal = { fg = c.yellow, },
  SpellRare = { fg = c.yellow, },

  TabLine = { fg = c.comment, },
  TabLineSel = { fg = c.white, },
  TabLineFill = { bg = c.bg, },
  Terminal = { fg = c.white, bg = c.black, },
  Visual = { bg = c.visual, },
  VisualNOS = { fg = c.visual, },
  WarningMsg = { fg = c.yellow, },
  WildMenu = { fg = c.black, bg = c.white, },

  EndOfBuffer = endOfBuffer,

  -- TreeSitter
  ['@error'] = { fg = c.bright_red, },
  ['@punctuation.delimiter'] = { fg = c.fg, },
  ['@punctuation.bracket'] = { fg = c.fg, },
  ['@markup.list'] = { fg = c.cyan, },

  ['@constant'] = { fg = c.purple, },
  ['@constant.builtin'] = { fg = c.purple, },
  ['@markup.link.label.symbol'] = { fg = c.purple, },

  ['@constant.macro'] = { fg = c.cyan, },
  ['@string.regexp'] = { fg = c.red, },
  ['@string'] = { fg = c.yellow, },
  ['@string.escape'] = { fg = c.cyan, },
  ['@string.special.symbol'] = { fg = c.purple, },
  ['@character'] = { fg = c.green, },
  ['@number'] = { fg = c.purple, },
  ['@boolean'] = { fg = c.purple, },
  ['@number.float'] = { fg = c.green, },
  ['@annotation'] = { fg = c.yellow, },
  ['@attribute'] = { fg = c.cyan, },
  ['@module'] = { fg = c.orange, },

  ['@function.builtin'] = { fg = c.cyan, },
  ['@function'] = { fg = c.green, },
  ['@function.macro'] = { fg = c.green, },
  ['@variable.parameter'] = { fg = c.orange, },
  ['@variable.parameter.reference'] = { fg = c.orange, },
  ['@function.method'] = { fg = c.green, },
  ['@variable.member'] = { fg = c.orange, },
  ['@property'] = { fg = c.purple, },
  ['@constructor'] = { fg = c.cyan, },

  ['@keyword.conditional'] = { fg = c.pink, },
  ['@keyword.repeat'] = { fg = c.pink, },
  ['@label'] = { fg = c.cyan, },

  ['@keyword'] = { fg = c.pink, },
  ['@keyword.function'] = { fg = c.cyan, },
  ['@keyword.function.ruby'] = { fg = c.pink, },
  ['@keyword.operator'] = { fg = c.pink, },
  ['@operator'] = { fg = c.pink, },
  ['@keyword.exception'] = { fg = c.purple, },
  ['@type'] = { fg = c.bright_cyan, },
  ['@type.builtin'] = { fg = c.cyan, italic = true, },
  ['@type.qualifier'] = { fg = c.pink, },
  ['@structure'] = { fg = c.purple, },
  ['@keyword.include'] = { fg = c.pink, },

  ['@variable'] = { fg = c.fg, },
  ['@variable.builtin'] = { fg = c.purple, },

  ['@markup'] = { fg = c.orange, },
  ['@markup.strong'] = { fg = c.orange, bold = true, },     -- bold
  ['@markup.emphasis'] = { fg = c.yellow, italic = true, }, -- italic
  ['@markup.underline'] = { fg = c.orange, },
  ['@markup.heading'] = { fg = c.pink, bold = true, },        -- title
  ['@markup.raw'] = { fg = c.yellow, },                 -- inline code
  ['@markup.link.url'] = { fg = c.yellow, italic = true, },      -- urls
  ['@markup.link'] = { fg = c.orange, bold = true, },

  ['@tag'] = { fg = c.cyan, },
  ['@tag.attribute'] = { fg = c.green, },
  ['@tag.delimiter'] = { fg = c.cyan, },

  -- Semantic
  ['@class'] = { fg = c.cyan },
  ['@struct'] = { fg = c.cyan },
  ['@enum'] = { fg = c.cyan },
  ['@enumMember'] = { fg = c.purple },
  ['@event'] = { fg = c.cyan },
  ['@interface'] = { fg = c.cyan },
  ['@modifier'] = { fg = c.cyan },
  ['@regexp'] = { fg = c.yellow },
  ['@typeParameter'] = { fg = c.cyan },
  ['@decorator'] = { fg = c.cyan },

  -- LSP Semantic (0.9+)
  ['@lsp.type.class'] = { fg = c.cyan },
  ['@lsp.type.enum'] = { fg = c.cyan },
  ['@lsp.type.decorator'] = { fg = c.green },
  ['@lsp.type.enumMember'] = { fg = c.purple },
  ['@lsp.type.function'] = { fg = c.green, },
  ['@lsp.type.interface'] = { fg = c.cyan },
  ['@lsp.type.macro'] = { fg = c.cyan },
  ['@lsp.type.method'] = { fg = c.green, },
  ['@lsp.type.namespace'] = { fg = c.orange, },
  ['@lsp.type.parameter'] = { fg = c.orange, },
  ['@lsp.type.property'] = { fg = c.purple, },
  ['@lsp.type.struct'] = { fg = c.cyan },
  ['@lsp.type.type'] = { fg = c.bright_cyan, },
  ['@lsp.type.variable'] = { fg = c.fg, },

  -- HTML
  htmlArg = { fg = c.green, },
  htmlBold = { fg = c.yellow, bold = true, },
  htmlEndTag = { fg = c.cyan, },
  htmlH1 = { fg = c.pink, },
  htmlH2 = { fg = c.pink, },
  htmlH3 = { fg = c.pink, },
  htmlH4 = { fg = c.pink, },
  htmlH5 = { fg = c.pink, },
  htmlH6 = { fg = c.pink, },
  htmlItalic = { fg = c.purple, italic = true, },
  htmlLink = { fg = c.purple, underline = true, },
  htmlSpecialChar = { fg = c.yellow, },
  htmlSpecialTagName = { fg = c.cyan, },
  htmlTag = { fg = c.cyan, },
  htmlTagN = { fg = c.cyan, },
  htmlTagName = { fg = c.cyan, },
  htmlTitle = { fg = c.white, },

  -- Markdown
  markdownBlockquote = { fg = c.yellow, italic = true, },
  markdownBold = { fg = c.orange, bold = true, },
  markdownCode = { fg = c.green, },
  markdownCodeBlock = { fg = c.orange, },
  markdownCodeDelimiter = { fg = c.red, },
  markdownH2 = { link = "rainbow2" },
  markdownH1 = { link = "rainbow1" },
  markdownH3 = { link = "rainbow3" },
  markdownH4 = { link = "rainbow4" },
  markdownH5 = { link = "rainbow5" },
  markdownH6 = { link = "rainbow6" },
  markdownHeadingDelimiter = { fg = c.red, },
  markdownHeadingRule = { fg = c.comment, },
  markdownId = { fg = c.purple, },
  markdownIdDeclaration = { fg = c.cyan, },
  markdownIdDelimiter = { fg = c.purple, },
  markdownItalic = { fg = c.yellow, italic = true, },
  markdownLinkDelimiter = { fg = c.purple, },
  markdownLinkText = { fg = c.pink, },
  markdownListMarker = { fg = c.cyan, },
  markdownOrderedListMarker = { fg = c.red, },
  markdownRule = { fg = c.comment, },
  ['@markup.heading.1.markdown'] = { link = 'rainbowcol1' },
  ['@markup.heading.2.markdown'] = { link = 'rainbowcol2' },
  ['@markup.heading.3.markdown'] = { link = 'rainbowcol3' },
  ['@markup.heading.4.markdown'] = { link = 'rainbowcol4' },
  ['@markup.heading.5.markdown'] = { link = 'rainbowcol5' },
  ['@markup.heading.6.markdown'] = { link = 'rainbowcol6' },

  --  Diff
  diffAdded = { fg = c.green, },
  diffRemoved = { fg = c.red, },
  diffFileId = { fg = c.yellow, bold = true, reverse = true, },
  diffFile = { fg = c.nontext, },
  diffNewFile = { fg = c.green, },
  diffOldFile = { fg = c.red, },

  debugPc = { bg = c.menu, },
  debugBreakpoint = { fg = c.red, reverse = true, },

  -- Git Signs
  GitSignsAdd = { fg = c.bright_green, },
  GitSignsChange = { fg = c.cyan, },
  GitSignsDelete = { fg = c.bright_red, },
  GitSignsAddLn = { fg = c.black, bg = c.bright_green, },
  GitSignsChangeLn = { fg = c.black, bg = c.cyan, },
  GitSignsDeleteLn = { fg = c.black, bg = c.bright_red, },
  GitSignsCurrentLineBlame = { fg = c.white, },

  -- Telescope
  TelescopePromptBorder = { fg = c.comment, },
  TelescopeResultsBorder = { fg = c.comment, },
  TelescopePreviewBorder = { fg = c.comment, },
  TelescopeSelection = { fg = c.white, bg = c.selection, },
  TelescopeMultiSelection = { fg = c.purple, bg = c.selection, },
  TelescopeNormal = { fg = c.fg, bg = c.bg, },
  TelescopeMatching = { fg = c.green, },
  TelescopePromptPrefix = { fg = c.purple, },
  TelescopeResultsDiffDelete = { fg = c.red },
  TelescopeResultsDiffChange = { fg = c.cyan },
  TelescopeResultsDiffAdd = { fg = c.green },

  -- Flash
  FlashLabel =  { bg = c.red, fg = c.bright_white },

  -- NvimTree
  NvimTreeNormal = { fg = c.fg, bg = c.menu, },
  NvimTreeVertSplit = { fg = c.bg, bg = c.bg, },
  NvimTreeRootFolder = { fg = c.fg, bold = true, },
  NvimTreeGitDirty = { fg = c.yellow, },
  NvimTreeGitNew = { fg = c.bright_green, },
  NvimTreeImageFile = { fg = c.pink, },
  NvimTreeFolderIcon = { fg = c.purple, },
  NvimTreeIndentMarker = { fg = c.nontext, },
  NvimTreeEmptyFolderName = { fg = c.comment, },
  NvimTreeFolderName = { fg = c.fg, },
  NvimTreeSpecialFile = { fg = c.pink, underline = true, },
  NvimTreeOpenedFolderName = { fg = c.fg, },
  NvimTreeCursorLine = { bg = c.selection, },
  NvimTreeIn = { bg = c.selection, },

  NvimTreeEndOfBuffer = endOfBuffer,

  -- NeoTree
  NeoTreeNormal = { fg = c.fg, bg = c.menu, },
  NeoTreeNormalNC = { fg = c.fg, bg = c.menu, },
  NeoTreeDirectoryName = { fg = c.fg },
  NeoTreeGitUnstaged = { fg = c.bright_magenta },
  NeoTreeGitModified = { fg = c.bright_magenta },
  NeoTreeGitUntracked = { fg = c.bright_green },
  NeoTreeDirectoryIcon = { fg = c.purple },
  NeoTreeIndentMarker = { fg = c.nontext },
  NeoTreeDotfile = { fg = c.comment },

  -- Bufferline
  BufferLineIndicatorSelected = { fg = c.purple, },
  BufferLineFill = { bg = c.black, },
  BufferLineBufferSelected = { bg = c.bg, },
  BufferLineSeparator = { fg = c.black },

  -- LSP
  DiagnosticError = { fg = c.red, },
  DiagnosticWarn = { fg = c.yellow, },
  DiagnosticInfo = { fg = c.cyan, },
  DiagnosticHint = { fg = c.cyan, },
  DiagnosticUnderlineError = { undercurl = true, sp = c.red, },
  DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow, },
  DiagnosticUnderlineInfo = { undercurl = true, sp = c.cyan, },
  DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan, },
  DiagnosticSignError = { fg = c.red, },
  DiagnosticSignWarn = { fg = c.yellow, },
  DiagnosticSignInfo = { fg = c.cyan, },
  DiagnosticSignHint = { fg = c.cyan, },
  DiagnosticFloatingError = { fg = c.red, },
  DiagnosticFloatingWarn = { fg = c.yellow, },
  DiagnosticFloatingInfo = { fg = c.cyan, },
  DiagnosticFloatingHint = { fg = c.cyan, },
  DiagnosticVirtualTextError = { fg = c.red, },
  DiagnosticVirtualTextWarn = { fg = c.yellow, },
  DiagnosticVirtualTextInfo = { fg = c.cyan, },
  DiagnosticVirtualTextHint = { fg = c.cyan, },

  LspDiagnosticsDefaultError = { fg = c.red, },
  LspDiagnosticsDefaultWarning = { fg = c.yellow, },
  LspDiagnosticsDefaultInformation = { fg = c.cyan, },
  LspDiagnosticsDefaultHint = { fg = c.cyan, },
  LspDiagnosticsUnderlineError = { fg = c.red, undercurl = true, },
  LspDiagnosticsUnderlineWarning = { fg = c.yellow, undercurl = true, },
  LspDiagnosticsUnderlineInformation = { fg = c.cyan, undercurl = true, },
  LspDiagnosticsUnderlineHint = { fg = c.cyan, undercurl = true, },
  LspReferenceText = { fg = c.orange, },
  LspReferenceRead = { fg = c.orange, },
  LspReferenceWrite = { fg = c.orange, },
  LspCodeLens = { fg = c.cyan, },
  LspInlayHint = { fg = "#969696", bg = "#2f3146" },

  --LSP Saga
  LspFloatWinNormal = { fg = c.fg, },
  LspFloatWinBorder = { fg = c.comment, },
  LspSagaHoverBorder = { fg = c.comment, },
  LspSagaSignatureHelpBorder = { fg = c.comment, },
  LspSagaCodeActionBorder = { fg = c.comment, },
  LspSagaDefPreviewBorder = { fg = c.comment, },
  LspLinesDiagBorder = { fg = c.comment, },
  LspSagaRenameBorder = { fg = c.comment, },
  LspSagaBorderTitle = { fg = c.menu, },
  LSPSagaDiagnosticTruncateLine = { fg = c.comment, },
  LspSagaDiagnosticBorder = { fg = c.comment, },
  LspSagaShTruncateLine = { fg = c.comment, },
  LspSagaDocTruncateLine = { fg = c.comment, },
  LspSagaLspFinderBorder = { fg = c.comment, },
  CodeActionNumber = { bg = 'NONE', fg = c.cyan },

  -- IndentBlankLine
  IndentBlanklineContextChar = { fg = c.bright_red, nocombine = true, },

  -- Nvim compe
  CmpItemAbbrDeprecated = { fg = c.white, bg = c.bg, },
  CmpItemAbbrMatch = { fg = c.cyan, bg = c.bg, },

  -- barbar
  BufferVisibleTarget = { fg = c.red },
  BufferTabpages = { fg = c.nontext, bg = c.black, bold = true },
  BufferTabpageFill = { fg = c.nontext, bg = c.black },
  BufferCurrentSign = { fg = c.purple },
  BufferCurrentTarget = { fg = c.red },
  BufferInactive = { fg = c.comment, bg = c.black, italic = true },
  BufferInactiveIndex = { fg = c.nontext, bg = c.black, italic = true },
  BufferInactiveMod = { fg = c.yellow, bg = c.black, italic = true },
  BufferInactiveSign = { fg = c.nontext, bg = c.black, italic = true },
  BufferInactiveTarget = { fg = c.red, bg = c.black, bold = true },

  -- Compe
  CompeDocumentation = { link = "Pmenu" },
  CompeDocumentationBorder = { link = "Pmenu" },

  -- Cmp
  CmpItemAbbr = { fg = c.white, bg = c.bg },
  CmpItemKind = { fg = c.white, bg = c.bg },
  CmpItemKindMethod = { link = "@function.method" },
  CmpItemKindText = { link = "@markup" },
  CmpItemKindFunction = { link = "@function" },
  CmpItemKindConstructor = { link = "@type" },
  CmpItemKindVariable = { link = "@variable" },
  CmpItemKindClass = { link = "@type" },
  CmpItemKindInterface = { link = "@type" },
  CmpItemKindModule = { link = "@module" },
  CmpItemKindProperty = { link = "@property" },
  CmpItemKindOperator = { link = "@operator" },
  CmpItemKindReference = { link = "@variable.parameter.reference" },
  CmpItemKindUnit = { link = "@variable.member" },
  CmpItemKindValue = { link = "@variable.member" },
  CmpItemKindField = { link = "@variable.member" },
  CmpItemKindEnum = { link = "@variable.member" },
  CmpItemKindKeyword = { link = "@keyword" },
  CmpItemKindSnippet = { link = "@markup" },
  CmpItemKindColor = { link = "DevIconCss" },
  CmpItemKindFile = { link = "TSURI" },
  CmpItemKindFolder = { link = "TSURI" },
  CmpItemKindEvent = { link = "@constant" },
  CmpItemKindEnumMember = { link = "@variable.member" },
  CmpItemKindConstant = { link = "@constant" },
  CmpItemKindStruct = { link = "@structure" },
  CmpItemKindTypeParameter = { link = "@variable.parameter" },

  -- Blink
  BlinkCmpLabel = { fg = c.white, bg = c.menu },
  BlinkCmpLabelDeprecated = { fg = c.white, bg = c.menu },
  BlinkCmpLabelMatch = { fg = c.cyan, bg = c.menu },
  BlinkCmpKind = { fg = c.white, bg = c.menu },
  BlinkCmpScrollBarThumb = { bg = c.fg },
  BlinkCmpScrollBarGutter = { bg = c.menu },
  BlinkCmpKindFunction = { link = "@function" },
  BlinkCmpKindConstructor = { link = "@type" },
  BlinkCmpKindVariable = { link = "@variable" },
  BlinkCmpKindClass = { link = "@type" },
  BlinkCmpKindInterface = { link = "@type" },
  BlinkCmpKindModule = { link = "@module" },
  BlinkCmpKindProperty = { link = "@property" },
  BlinkCmpKindOperator = { link = "@operator" },
  BlinkCmpKindReference = { link = "@variable.parameter.reference" },
  BlinkCmpKindUnit = { link = "@variable.member" },
  BlinkCmpKindValue = { link = "@variable.member" },
  BlinkCmpKindField = { link = "@variable.member" },
  BlinkCmpKindEnum = { link = "@variable.member" },
  BlinkCmpKindKeyword = { link = "@keyword" },
  BlinkCmpKindSnippet = { link = "@markup" },
  BlinkCmpKindColor = { link = "DevIconCss" },
  BlinkCmpKindFile = { link = "TSURI" },
  BlinkCmpKindFolder = { link = "TSURI" },
  BlinkCmpKindEvent = { link = "@constant" },
  BlinkCmpKindEnumMember = { link = "@variable.member" },
  BlinkCmpKindConstant = { link = "@constant" },
  BlinkCmpKindStruct = { link = "@structure" },
  BlinkCmpKindTypeParameter = { link = "@variable.parameter" },

  -- navic
  NavicIconsFile = { link = "CmpItemKindFile" },
  NavicIconsModule = { link = "CmpItemKindModule" },
  NavicIconsNamespace = { link = "CmpItemKindModule" },
  NavicIconsPackage = { link = "CmpItemKindModule" },
  NavicIconsClass = { link = "CmpItemKindClass" },
  NavicIconsMethod = { link = "CmpItemKindMethod" },
  NavicIconsProperty = { link = "CmpItemKindProperty" },
  NavicIconsField = { link = "CmpItemKindField" },
  NavicIconsConstructor = { link = "CmpItemKindConstructor" },
  NavicIconsEnum = { link = "CmpItemKindEnum" },
  NavicIconsInterface = { link = "CmpItemKindInterface" },
  NavicIconsFunction = { link = "CmpItemKindFunction" },
  NavicIconsVariable = { link = "CmpItemKindVariable" },
  NavicIconsConstant = { link = "CmpItemKindConstant" },
  NavicIconsString = { link = "String" },
  NavicIconsNumber = { link = "Number" },
  NavicIconsBoolean = { link = "Boolean" },
  NavicIconsArray = { link = "CmpItemKindClass" },
  NavicIconsObject = { link = "CmpItemKindClass" },
  NavicIconsKey = { link = "CmpItemKindKeyword" },
  NavicIconsKeyword = { link = "CmpItemKindKeyword" },
  NavicIconsNull = { fg = "blue" },
  NavicIconsEnumMember = { link = "CmpItemKindEnumMember" },
  NavicIconsStruct = { link = "CmpItemKindStruct" },
  NavicIconsEvent = { link = "CmpItemKindEvent" },
  NavicIconsOperator = { link = "CmpItemKindOperator" },
  NavicIconsTypeParameter = { link = "CmpItemKindTypeParameter" },
  NavicText = { fg = 'gray' },
  NavicSeparator = { fg = 'gray' },

  -- TS rainbow colors
  rainbowcol1 = { fg = c.fg },
  rainbowcol2 = { fg = c.pink },
  rainbowcol3 = { fg = c.cyan },
  rainbowcol4 = { fg = c.green },
  rainbowcol5 = { fg = c.purple },
  rainbowcol6 = { fg = c.orange },
  rainbowcol7 = { fg = c.fg },

  -- Rainbow delimiter
  RainbowDelimiterRed = { fg = c.fg },
  RainbowDelimiterYellow = {fg = c.pink },
  RainbowDelimiterBlue = {fg = c.cyan },
  RainbowDelimiterOrange = { fg = c.green },
  RainbowDelimiterGreen = { fg = c.purple },
  RainbowDelimiterViolet = { fg = c.orange },
  RainbowDelimiterCyan = { fg = c.fg },

  -- mini.indentscope
  MiniIndentscopeSymbol = { fg = "#B5629B" },
  MiniIndentscopeSymbolOff = { fg = "#B5629B" },

  -- mini.icons
  MiniIconsAzure = { fg = c.bright_cyan },
  MiniIconsBlue = { fg = c.bright_blue },
  MiniIconsCyan = { fg = c.cyan },
  MiniIconsGrey = { fg = c.white },
  MiniIconsOrange = { fg = c.orange },
  MiniIconsPurple = { fg = c.purple },
  MiniIconsRed = { fg = c.red },
  MiniIconsYellow = { fg = c.yellow },

  -- mini.statusline
  MiniStatuslineModeNormal = { fg = c.black, bg = c.purple, bold = true },
  MiniStatuslineModeInsert = { fg = c.black, bg = c.green, bold = true },
  MiniStatuslineModeVisual = { fg = c.black, bg = c.pink, bold = true },
  MiniStatuslineModeReplace = { fg = c.black, bg = c.yellow, bold = true },
  MiniStatuslineModeCommand = { fg = c.black, bg = c.cyan, bold = true },
  MiniStatuslineInactive = { fg = c.fg, bg = c.visual, bold = true },
  MiniStatuslineDevinfo = { fg = c.purple, bg = c.black },
  MiniStatuslineFilename = { fg = c.white, bg = c.black },
  MiniStatuslineFileinfo = { fg = c.purple, bg = c.black },

  -- mini.files
  MiniFilesNormal = { fg = c.fg, bg = c.menu },
  MiniFilesBorder = { fg = c.purple, bg = c.menu },
  MiniFilesBorderModified = { },
  MiniFilesCursorLine = { bg = c.selection, },
  MiniFilesDirectory = { fg = c.fg },
  MiniFilesFile = { fg = c.fg },
  MiniFilesTitle = { fg = c.fg },
  MiniFilesTitleFocused = { fg = c.yellow },

  -- goolord/alpha-nvim
  AlphaHeader = { fg = c.purple },
  AlphaButtons = { fg = c.cyan },
  AlphaShortcut = { fg = c.orange },
  AlphaFooter = { fg = c.purple, italic = true },

  -- nvimdev/dashboard-nvim
  DashboardShortCut = { fg = c.cyan },
  DashboardHeader = { fg = c.purple },
  DashboardCenter = { fg = c.fg },
  DashboardFooter = { fg = c.purple, italic = true },
  DashboardKey = { fg = c.orange },
  DashboardDesc = { fg = c.cyan },
  DashboardIcon = { fg = c.cyan, bold = true },

  -- dap UI
  DapUIPlayPause = { fg = c.bright_green },
  DapUIRestart = { fg = c.green },
  DapUIStop = { fg = c.red },
  DapUIStepOver = { fg = c.cyan },
  DapUIStepInto = { fg = c.cyan },
  DapUIStepOut = { fg = c.cyan },
  DapUIStepBack = { fg = c.cyan },
  DapUIType = { fg = c.bright_blue },
  DapUIScope = { fg = c.bright_cyan },
  DapUIModifiedValue = { fg = c.bright_cyan, bold = true },
  DapUIDecoration = { fg = c.bright_cyan },
  DapUIThread = { fg = c.bright_green },
  DapUIStoppedThread = { fg = c.bright_cyan },
  DapUISource = { fg = c.bright_blue },
  DapUILineNumber = { fg = c.bright_cyan },
  DapUIFloatBorder = { fg = c.bright_cyan },
  DapUIWatchesEmpty = { fg = c.pink },
  DapUIWatchesValue = { fg = c.bright_green },
  DapUIWatchesError = { fg = c.pink },
  DapUIBreakpointsPath = { fg = c.bright_cyan },
  DapUIBreakpointsInfo = { fg = c.bright_green },
  DapUIBreakpointsCurrentLine = { fg = c.bright_green, bold = true },
  DapStoppedLine = { default = true, link = 'Visual' },
  DapUIWinSelect = { fg = c.bright_cyan, bold = true },

  -- Notify
  NotifyInfoIcon = { fg = c.green },
  NotifyInfoTitle = { fg = c.green },
  NotifyInfoBorder = { fg = "#2C453F" },
  NotifyErrorIcon = { fg = c.red },
  NotifyErrorTitle = { fg = c.red },
  NotifyErrorBorder = { fg = "#DD6E6B" },
  NotifyWarnIcon = { fg = c.orange },
  NotifyWarnTitle = { fg = c.orange },
  NotifyWarnBorder = { fg = "#785637" },

  -- SnacksDashboard
  SnacksDashboardHeader = { fg = c.purple },
  SnacksDashboardKey = { fg = c.orange },
  SnacksDashboardDesc = { fg = c.cyan },
  SnacksDashboardIcon = { fg = c.cyan },
  SnacksDashboardFooter = { fg = c.purple, italic = true },

  -- SnacksPicker
  SnacksBackdrop = { link = "FloatShadow" },
  SnacksPickerBorder = { fg = c.comment },
  SnacksPickerDir = { fg = c.fg },
  SnacksPickerDirectory = { fg = c.fg },
  SnacksPickerFile = { fg = c.fg },
  SnacksPickerGitStatusIgnored = { fg = c.comment },
  SnacksPickerGitStatusModified = { fg = c.yellow },
  SnacksPickerGitStatusRenamed = { fg = c.yellow },
  SnacksPickerGitStatusStaged = { fg = c.bright_green },
  SnacksPickerGitStatusUnmerged = { fg = c.orange },
  SnacksPickerGitStatusUntracked = { fg = c.green },
  SnacksPickerInput = { link = "NormalFloat" },
  SnacksPickerInputBorder = { link = "SnacksPickerBorder" },
  SnacksPickerMatch = { fg = c.green, italic = true },
  SnacksPickerPathHidden = { fg = c.comment },
  SnacksPickerPrompt = { fg = c.purple },
  SnacksPickerTitle = { fg = c.cyan, bold = true },

  -- Neogit
  NeogitDiffAdd = { fg = c.bright_green, bg = c.menu },
  NeogitDiffDelete = { fg = c.bright_red, bg = c.menu },
  NeogitDiffContext = { fg = c.comment, bg = c.visual },
  NeogitDiffAddHighlight = { fg = c.green, bg = c.bg },
  NeogitDiffDeleteHighlight = { fg = c.red, bg = c.bg },
  NeogitDiffContextHighlight = { fg = c.comment, bg = c.visual },
  NeogitDiffAddCursor = { fg = c.green, bg = c.selection },
  NeogitDiffDeleteCursor = { fg = c.red, bg = c.selection },
  NeogitDiffContextCursor = { fg = c.comment, bg = c.selection },
}

-- Groups which differ from dracula.nvim, besides those set from the theme's
-- roles (below).

-- The cursor line is a step lighter than the background, as Dracula's current
-- line is the same color as selected text.
groups.CursorLine = {bg = colors.bg1}
groups.ColorColumn = {bg = colors.bg1}

-- The changed text within a changed line of a diff: dracula.nvim only colors
-- its text, which doesn't stand out on the line's background.
groups.DiffText = {fg = c.bg, bg = c.orange}

-- The status line matches side panels (see below), as in the other styles.
groups.StatusLine.fg = ui.panel

-- Groups set from the theme's roles.

-- Floating windows have the normal background and text.
groups.NormalFloat = {fg = ui.text, bg = ui.background}
groups.FloatTitle = {fg = ui.text, bg = ui.background}

-- Selected regions, search matches and window separators, so that they match
-- the shell and multiplexer.
groups.Visual = {bg = ui.selection_bg}
groups.Search = {fg = search.text, bg = search.match}
groups.IncSearch = {fg = search.text, bg = search.current}
groups.CurSearch = {link = "IncSearch"}
groups.WinSeparator = {fg = ui.border, bg = ui.background}

-- Menus and pickers, like zsh's completions and fzf: the completion menu is a
-- panel, the current item (or a picker's current line) is bold on its own
-- background, and matched characters are a picker's matches.
groups.Pmenu = {fg = ui.text, bg = ui.panel}
groups.PmenuSel = {fg = ui.current_fg, bg = ui.current_bg, bold = true}
groups.SnacksPickerListCursorLine = {bg = ui.current_bg, bold = true}
groups.SnacksPickerMatch = {fg = picker.match}
groups.CmpItemAbbrMatch = {fg = picker.match, bold = true}
groups.CmpItemAbbrMatchFuzzy = {link = "CmpItemAbbrMatch"}
groups.BlinkCmpLabelMatch = {link = "CmpItemAbbrMatch"}

-- Side panels (e.g. neo-tree's).
groups.NeoTreeNormal = {bg = ui.panel}
groups.NeoTreeNormalNC = {link = "NeoTreeNormal"}
groups.NeoTreeSignColumn = {link = "NeoTreeNormal"}
groups.NeoTreeCursorLine = {bg = ui.current_bg}

-- Directories.
groups.Directory = {fg = file.directory, bold = true}
groups.NeoTreeDirectoryName = {link = "Directory"}
groups.NeoTreeDirectoryIcon = {fg = file.directory}

-- Version control, and diffs.
groups.GitSignsAdd = {fg = git.added}
groups.GitSignsChange = {fg = git.modified}
groups.GitSignsDelete = {fg = git.deleted}
groups.SignifySignAdd = {link = "GitSignsAdd"}
groups.SignifySignChange = {link = "GitSignsChange"}
groups.SignifySignDelete = {link = "GitSignsDelete"}
groups.NeoTreeGitAdded = {fg = git.added}
groups.NeoTreeGitStaged = {fg = git.added}
groups.NeoTreeGitModified = {fg = git.modified}
groups.NeoTreeGitRenamed = {fg = git.modified}
groups.NeoTreeGitDeleted = {fg = git.deleted}
groups.NeoTreeGitUntracked = {fg = git.untracked}
groups.DiffAdd = {bg = diff.added}
groups.DiffChange = {bg = diff.changed}
groups.DiffDelete = {bg = diff.deleted}

-- Diagnostics.
for name, color in pairs({
  Error = diagnostics.error,
  Warn = diagnostics.warning,
  Info = diagnostics.info,
  Hint = diagnostics.hint,
  Ok = diagnostics.ok,
}) do
  groups["Diagnostic" .. name] = {fg = color}
  groups["DiagnosticSign" .. name] = {fg = color}
  groups["DiagnosticVirtualText" .. name] = {fg = color}
  groups["DiagnosticUnderline" .. name] = {undercurl = true, sp = color}
end

-- Don't give markdown code blocks a background. render-markdown links this to
-- ColorColumn, which virt-column clears when it loads, so otherwise the result
-- depends on which loads first. This links to render-markdown's empty group
-- since a group with no attributes doesn't count as set, and render-markdown
-- would still link it.
groups.RenderMarkdownCode = {link = "RenderMarkdownPadding"}

-- The groups the icons use (see the icons module), one for each of their colors.
groups.IconsRed = {fg = "#ff5555"}
groups.IconsGreen = {fg = "#50fa7b"}
groups.IconsMagenta = {fg = "#ff79c6"}
groups.IconsCyan = {fg = "#8be9fd"}
groups.IconsBrightBlack = {fg = "#6272a4"}
groups.IconsBrightRed = {fg = "#ff6e6e"}
groups.IconsBrightGreen = {fg = "#69ff94"}
groups.IconsBrightYellow = {fg = "#ffffa5"}
groups.IconsBrightBlue = {fg = "#d6acff"}
groups.IconsBrightMagenta = {fg = "#ff92df"}
groups.IconsBrightCyan = {fg = "#a4ffff"}
groups.IconsFilePlain = {fg = "#ffffff"}
groups.IconsFileScript = {fg = "#ffffff"}
groups.IconsFileDirectory = {fg = "#bd93f9"}
groups.IconsFileArchive = {fg = "#ff6e6e"}
groups.IconsFileMedia = {fg = "#ff92df"}
groups.IconsFileCompiled = {fg = "#f1fa8c"}
groups.IconsExtraColorsOrange = {fg = "#fe8019"}
groups.IconsExtraColorsVimGreen = {fg = "#019833"}
groups.IconsExtraColorsAzure = {fg = "#3d9df3"}
groups.IconsExtraColorsSky = {fg = "#00add8"}
groups.IconsExtraColorsViolet = {fg = "#a78bfa"}

for group, settings in pairs(groups) do
  vim.api.nvim_set_hl(0, group, settings)
end
