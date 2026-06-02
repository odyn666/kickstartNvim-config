local function gh(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  gh("kdheepak/lazygit.nvim"),
})

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", {
  desc = "Open LazyGit",
})
