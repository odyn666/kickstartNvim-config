local function gh(repo)
  return "https://github.com/" .. repo
end

-- Ładowanie wtyczki
vim.pack.add({
  gh("mistweaverco/kulala.nvim"),
})

-- ROZWIĄZANIE DLA WSL: 
-- Wymuszamy, aby Neovim szukał programów NAJPIERW w ścieżkach Linuksa.
-- Dzięki temu "curl" wywoła /usr/bin/curl, a nie curl.exe z Windowsa.
vim.env.PATH = "/usr/bin:/bin:/usr/local/bin:" .. vim.env.PATH

-- Czysta konfiguracja Kulala (bez fikcyjnych parametrów ścieżek)
require("kulala").setup({
  global_keymaps = false,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps_prefix = "",
})

-- Mapowania klawiszy
vim.keymap.set("n", "<leader>Rs", function()
  require("kulala").run()
end, { desc = "Send request" })

vim.keymap.set("n", "<leader>Ra", function()
  require("kulala").run_all()
end, { desc = "Send all requests" })

vim.keymap.set("n", "<leader>Rb", function()
  require("kulala").scratchpad()
end, { desc = "Open scratchpad" })

-- Rejestracja rozszerzenia plików
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})
