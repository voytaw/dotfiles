local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Pomocná funkce: bezpečné načtení modulu
local function safe_require(name)
    local ok, err = pcall(require, name)
    if not ok then
        vim.notify("✗ " .. name .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
    return ok
end

-- Postupně načítáme moduly
safe_require("core.options")
safe_require("core.keymaps")
safe_require("core.autocmds")
safe_require("core.functions")
safe_require("plugins")          -- tento volá lazy.setup()
safe_require("core.appearance")
