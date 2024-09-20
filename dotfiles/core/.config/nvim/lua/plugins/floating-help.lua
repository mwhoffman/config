local function cmd_abbrev(abbrev, expansion)
  vim.cmd(
    'cabbr ' .. abbrev .. 
    ' <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "' .. expansion .. 
    '" : "' .. abbrev .. '")<CR>')
end

return {
  "Tyler-Barham/floating-help.nvim",
  name = "floating-help",
  opts = function() 
    cmd_abbrev('h', 'FloatingHelp')
    cmd_abbrev('help', 'FloatingHelp')

    return {
      width = 80,
      height = 0.9,
      position = "C",
      border = "rounded",
    }
  end,
}
