-- virt-column draws the color column as a thin line rather than a highlighted
-- block; here it's placed just past textwidth.
return {
  "lukas-reineke/virt-column.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
    char = "▕",
    virtcolumn = "+1",
  }
}
