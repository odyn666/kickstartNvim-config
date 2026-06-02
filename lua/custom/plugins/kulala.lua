local function gh(repo)
  return "https://github.com/" .. repo
end

-- 1. ŁADOWANIE WTYCZKI
vim.pack.add({
  gh("mistweaverco/kulala.nvim"),
})

local kulala = require("kulala")
local environments = { "local", "dev", "stage", "prod" }

local env_choice="dev";
-- 2. KONFIGURACJA ZGODNA Z NAJNOWSZYM API
kulala.setup({
  global_keymaps = false,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps_prefix = "",
  default_env = env_choice,
  environment_scope = "bft",
})

-- 3. MAPOWANIA KLAWISZY
vim.keymap.set("n", "<leader>Rs", function()
  kulala.run()
end, { desc = "Send request" })

-- NAPRAWIONA FUNKCJA: Wybieranie środowiska za pomocą stabilnych komend Vima
vim.keymap.set("n", "<leader>Re", function()
  
  vim.ui.select(environments, {
    prompt = "Wybierz środowisko HTTP:",
  }, function(choice)
    if choice then
      -- Kulala rejestruje komendy Vim w formacie KulalaEnv<NazwaŚrodowiska>
      -- np. :KulalaEnvDev, :KulalaEnvLocal. Używamy pierwszej litery jako wielkiej.
      local cmd_env = choice:sub(1,1):upper() .. choice:sub(2)
      local cmd = "KulalaEnv" .. cmd_env

      -- Wykonujemy komendę w edytorze i sprawdzamy czy istnieje
      local success = pcall(vim.cmd, cmd)
      
      -- Jeśli specyficzna komenda nie istnieje, używamy uniwersalnej komendy z argumentem
      if not success then
        pcall(vim.cmd, "KulalaEnvSelect " .. choice)
      end
      kulala.set_selected_env(choice)
      vim.notify("Aktywne środowisko: " .. choice, vim.log.levels.INFO)
    end
  end)
end, { desc = "Select HTTP Environment (Hardcoded Fix)" })

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
