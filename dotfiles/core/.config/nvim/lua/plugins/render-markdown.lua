-- render-markdown renders markdown in the buffer (headings, code blocks, tables,
-- checkboxes, ...), showing the raw text on the cursor line.

-- HTML entities to replace with text when rendering, e.g. &mdash; as --- (which
-- kitty draws as a long dash ligature). Unlike a treesitter conceal, the
-- replacement can be more than one character.
local entities = {
  ["&mdash;"] = "---",
  ["&ndash;"] = "--",
}

-- Custom handler (see render-markdown's doc/custom-handlers.md) which conceals
-- the entities above and inlines their replacements, and highlights the raw
-- entities.
local function parse_entities(ctx)
  local marks = {}
  local query = vim.treesitter.query.parse("markdown_inline", "(entity_reference) @entity")
  for _, node in query:iter_captures(ctx.root, ctx.buf) do
    local text = entities[vim.treesitter.get_node_text(node, ctx.buf)]
    if text then
      local row, col, _, end_col = node:range()
      marks[#marks + 1] = {
        conceal = true,
        start_row = row,
        start_col = col,
        opts = {
          end_col = end_col,
          conceal = "",
          -- Highlight the same as link text.
          virt_text = {{text, "@markup.link.label"}},
          virt_text_pos = "inline",
        },
      }
      -- Highlight the raw entity (shown on the cursor line) the same as the
      -- entities handled by nvim's default queries (&lt;, &amp;, ...). This
      -- mark isn't concealed, so it stays on the cursor line.
      marks[#marks + 1] = {
        conceal = false,
        start_row = row,
        start_col = col,
        opts = {
          end_col = end_col,
          hl_group = "@character.special",
        },
      }
    end
  end
  return marks
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = {"markdown"},
  opts = {
    latex = {enabled = false},
    -- This plugin disables nvim's highlight patterns which hide the lines
    -- around code blocks (so that it can draw its borders there). But it's
    -- lazy-loaded after the highlighter starts, so restart it for that to apply.
    restart_highlighter = true,
    custom_handlers = {
      markdown_inline = {extends = true, parse = parse_entities},
    },
    -- Use conceallevel 2 rather than 3 when rendering, so that concealed text
    -- with a replacement (e.g. &lt; or &mdash;) shows that replacement rather
    -- than being hidden entirely.
    win_options = {
      conceallevel = {rendered = 2},
    },
    -- Don't add heading/code icons to the sign column, where they conflict with
    -- git signs.
    sign = {enabled = false},
    heading = {
      -- Conceal the '#'s and put the icon at the start of the line, rather than
      -- padding it to the width of the '#'s (which indents deeper headings).
      position = "inline",
      -- End the heading background at textwidth rather than the window's edge
      -- (headings longer than textwidth still extend to their end).
      width = "block",
      min_width = vim.o.textwidth,
    },
    code = {
      -- Size the background to the code (rather than the window), and draw
      -- half-block borders above and below it.
      width = "block",
      border = "thin",
      -- Don't show the language (icon, name, ...) above the block.
      language = false,
    },
  },
  keys = {
    {
      "<leader>m",
      "<cmd>RenderMarkdown toggle<cr>",
      desc = "Toggle markdown rendering",
    },
  },
}
