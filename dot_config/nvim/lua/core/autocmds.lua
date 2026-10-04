-- ==========================================================================
--  core/autocmds.lua – skutecne autocmdy (NE plugin specy!)
-- ==========================================================================
--  POZN: Plugin seznam + lazy.setup() zije VYHRADNE v lua/plugins/init.lua.
--  Tento soubor drzi jen vim.api.nvim_create_autocmd(...). Zatim prazdny.
-- ==========================================================================

-- Priklad (odkomentuj dle potreby):
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     callback = function() vim.highlight.on_yank() end,
-- })

-- Truecolor jen v Neovide GUI; v terminalu vzdy OFF (citelny 256-color).
-- Musi byt v ColorScheme autocmd, protoze gruvbox.nvim si termguicolors
-- pri nacteni sam prepne na true (prepisuje core/options.lua).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TruecolorPolicy", { clear = true }),
  callback = function()
    vim.o.termguicolors = (vim.g.neovide ~= nil)
  end,
})
