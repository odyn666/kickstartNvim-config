local function gh(repo)
  return "https://github.com/" .. repo
end


vim.pack.add({
  gh"hrsh7th/nvim-cmp",
  gh"hrsh7th/cmp-nvim-lsp",
})

local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})
