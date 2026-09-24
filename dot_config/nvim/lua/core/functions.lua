-- ==========================================================================
--  Vlastní funkce (odpovídá sekci 8 původního .vimrc)
-- ==========================================================================

-- --------------------------------------------------------------------------
-- Session management (zjednodušená verze vašich SaveSession/RestoreSession)
-- --------------------------------------------------------------------------
-- Poznámka: Pro pokročilejší správu sessions doporučuji plugin
-- 'rmagatti/auto-session' (viz plugins). Nicméně základní funkce:

local M = {}

local session_dir = vim.fn.stdpath("data") .. "/sessions/"

-- Zajistit existenci adresáře
vim.fn.mkdir(session_dir, "p")

function M.save_session(name)
    name = name or "default"
    local file = session_dir .. name .. ".vim"
    vim.cmd("mksession! " .. vim.fn.fnameescape(file))
    vim.notify("Session uložena: " .. name)
end

function M.restore_session(name)
    name = name or "default"
    local file = session_dir .. name .. ".vim"
    if vim.fn.filereadable(file) == 1 then
        vim.cmd("source " .. vim.fn.fnameescape(file))
        vim.notify("Session obnovena: " .. name)
    else
        vim.notify("Session nenalezena: " .. name, vim.log.levels.WARN)
    end
end

-- Uložit session při ukončení NeoVimu
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        M.save_session("last")
    end,
})

-- Příkazy
vim.api.nvim_create_user_command("SessionSave", function(args)
    M.save_session(args.args ~= "" and args.args or nil)
end, { nargs = "?" })

vim.api.nvim_create_user_command("SessionRestore", function(args)
    M.restore_session(args.args ~= "" and args.args or nil)
end, { nargs = "?" })

return M
