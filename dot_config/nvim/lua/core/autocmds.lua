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

