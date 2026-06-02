local function gh(repo)
  return "https://github.com/" .. repo
end

-- 1. ŁADOWANIE WTYCZKI
vim.pack.add({
  gh("mistweaverco/kulala.nvim"),
})

local kulala = require("kulala")

-- 2. KONFIGURACJA ZGODNA Z NAJNOWSZYM API
kulala.setup({
  global_keymaps = false,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps_prefix = "",
  -- Ustawiamy domyślne środowisko na poziomie konfiguracji wtyczki,
  -- dzięki czemu kulala wie, że ma szukać bloku "dev" w Twoim pliku json.
  default_env = "dev",
  environment_scope = "bft",
})

-- 3. MAPOWANIA KLAWISZY (Używamy wyłącznie bezpiecznego, publicznego API)
vim.keymap.set("n", "<leader>Rs", function()
  kulala.run()
end, { desc = "Send request" })

-- Jeśli kiedykolwiek zechcesz zmienić środowisko z palca, 
-- używamy wbudowanej komendy Vim, która jest odporna na zmiany w Lua API:
-- Funkcja z zaszytymi na sztywno opcjami środowisk do wyboru
vim.keymap.set("n", "<leader>Re", function()
  local environments = { "local", "dev", "stage", "prod" }
  
  vim.ui.select(environments, {
    prompt = "Wybierz środowisko HTTP:",
  }, function(choice)
    if choice then
      -- Bezpieczna próba ustawienia środowiska w Kulala
      pcall(function()
        require('kulala.parser.env').set_env(choice)
      end)
      vim.notify("Aktywne środowisko: " .. choice, vim.log.levels.INFO)
    end
  end)
end, { desc = "Select HTTP Environment (Hardcoded)" })

vim.keymap.set("n", "<leader>Ra", function() kulala.run_all() end, { desc = "Send all requests" })
vim.keymap.set("n", "<leader>Rb", function() kulala.scratchpad() end, { desc = "Open scratchpad" })

-- 4. REJESTRACJA ROZSZERZENIA PLIKÓW
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- 5. AUTOMATYCZNE SZYBKIE CZYSZCZENIE BUFORA (Zabezpieczenie przed śmieciami schowka w VM)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.http",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local changed = false

    for i, line in ipairs(lines) do
      local original = line
      -- Usunięcie ukrytych spacji webowych i znaków powrotu karetki \r z maszyn wirtualnych
      line = line:gsub("\194\160", " "):gsub("\r", "")
      if line ~= original then
        lines[i] = line
        changed = true
      end
    end

    if changed then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end
  end,
})
