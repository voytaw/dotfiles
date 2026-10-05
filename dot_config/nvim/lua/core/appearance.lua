-- ==========================================================================
--  Cyklování témat a fontů s persistencí
--  F10 / Shift+F10  = téma vpřed / vzad
--  F9 / Shift+F11  = font vpřed / vzad  (pouze Neovide)
--
--  Nastavení se ukládá do:
--  %LOCALAPPDATA%\nvim-data\appearance.json
-- ==========================================================================

-- ══════════════════════════════════════════════════════════════
-- NOVÉ: Persistence – ukládání a načítání
-- ══════════════════════════════════════════════════════════════

local data_file = vim.fn.stdpath("data") .. "/appearance.json"

local function load_saved()
    if vim.fn.filereadable(data_file) == 0 then
        return {}
    end
    local ok, content = pcall(vim.fn.readfile, data_file)
    if not ok or #content == 0 then
        return {}
    end
    local ok2, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
    if not ok2 then
        return {}
    end
    return data or {}
end

local function save_current(t_idx, f_idx)
    local data = { theme_index = t_idx, font_index = f_idx }
    local ok, json = pcall(vim.fn.json_encode, data)
    if ok then
        vim.fn.writefile({ json }, data_file)
    end
end

local saved = load_saved()

-- ══════════════════════════════════════════════════════════════
-- TÉMATA (funguje v terminálu i Neovide)
-- ══════════════════════════════════════════════════════════════

local themes = {
    "gruvbox",
    "dracula",
    "catppuccin-mocha",
    "desert",
}

-- NOVÉ: načtení uloženého indexu
local theme_index = saved.theme_index or 1
if theme_index < 1 or theme_index > #themes then
    theme_index = 1
end

-- NOVÉ: font_index definován zde, aby byl dostupný pro save_current
local font_index = 1

-- NOVÉ: přidán parametr silent
local function set_theme(index, silent)
    theme_index = index
    local name = themes[theme_index]
    local ok = pcall(vim.cmd, "colorscheme " .. name)
    if ok then
        vim.opt.background = "dark"
    else
        vim.cmd("colorscheme desert")
        name = "desert (fallback)"
    end
    if not silent then
        vim.notify(string.format(" Téma [%d/%d]: %s", theme_index, #themes, name))
    end
    save_current(theme_index, font_index)    -- NOVÉ
end

local function cycle_theme(direction)
    local new_index = theme_index + direction
    if new_index > #themes then new_index = 1 end
    if new_index < 1 then new_index = #themes end
    set_theme(new_index)
end

-- F10 = další téma, Shift+F10 = předchozí téma
vim.keymap.set("n", "<F10>", function() cycle_theme(1) end, { desc = "Další téma" })
vim.keymap.set("n", "<S-F10>", function() cycle_theme(-1) end, { desc = "Předchozí téma" })

-- Příkaz :Theme – bez argumentu vypíše seznam, s argumentem nastaví
vim.api.nvim_create_user_command("Theme", function(args)
    -- Bez argumentu → vypsat seznam
    if args.args == "" then
        vim.notify("Dostupná témata:", vim.log.levels.INFO)
        for i, t in ipairs(themes) do
            local marker = (i == theme_index) and " → " or "   "
            vim.notify(string.format("%s%d. %s", marker, i, t))
        end
        return
    end

    -- Argument je číslo → nastavit podle indexu
    local idx = tonumber(args.args)
    if idx and idx >= 1 and idx <= #themes then
        set_theme(idx)
        return
    end

    -- Argument je název → hledat v seznamu
    for i, t in ipairs(themes) do
        if t == args.args then
            set_theme(i)
            return
        end
    end

    -- Není v seznamu → zkusit přímo jako colorscheme
    local ok = pcall(vim.cmd, "colorscheme " .. args.args)
    if ok then
        vim.opt.background = "dark"
        vim.notify("Téma: " .. args.args)
    else
        vim.notify("Téma nenalezeno: " .. args.args, vim.log.levels.WARN)
    end
end, {
    nargs = "?",       -- ZMĚNA: bylo "1", nyní "?" = volitelný argument
    complete = function()
        return themes
    end,
    desc = "Zobrazit/vybrat téma (:Theme nebo :Theme gruvbox nebo :Theme 2)",
})

set_theme(theme_index, true) 

-- ══════════════════════════════════════════════════════════════
-- FONTY (pouze Neovide)
-- ══════════════════════════════════════════════════════════════

do  -- FONTY blok: detekce Neovide AZ ZA BEHU (headless-first start!)

    local fonts = {
    -- NOVÉ: načtení uloženého indexu
        -- ┌──────────────────────────────────────────────────────┐
        -- │ ⭐ Populární – Nerd Font varianty                    │
        -- └──────────────────────────────────────────────────────┘
        { name = "JetBrainsMono Nerd Font",      size = 12 },
        { name = "FiraCode Nerd Font",           size = 12 },
        { name = "CaskaydiaCove Nerd Font",      size = 12 },  -- Cascadia Code
        { name = "CaskaydiaMono Nerd Font",      size = 12 },  -- Cascadia Mono
        { name = "Hack Nerd Font",               size = 12 },
        { name = "Iosevka Nerd Font",            size = 12 },
        { name = "IosevkaTerm Nerd Font",        size = 12 },
        { name = "IosevkaTermSlab Nerd Font",    size = 12 },
        { name = "SauceCodePro Nerd Font",       size = 12 },  -- Source Code Pro
        { name = "VictorMono Nerd Font",         size = 12 },
        { name = "Monaspace Neon",               size = 12 },  -- Monaspace (více variant)
        { name = "Monaspace Argon",              size = 12 },
        { name = "Monaspace Radon",              size = 12 },
        --{ name = "Monaspace Krypton",            size = 12 },
        --{ name = "Monaspace Xenon",              size = 12 },
        { name = "GeistMono Nerd Font",          size = 12 },
        { name = "ZedMono Nerd Font",            size = 12 },
        { name = "CommitMono Nerd Font",         size = 12 },

        -- ┌──────────────────────────────────────────────────────┐
        -- │ 🆕 Moderní / Zajímavé                                │
        -- └──────────────────────────────────────────────────────┘
        { name = "0xProto Nerd Font",            size = 12 },
        { name = "Lilex Nerd Font",              size = 12 },
        --{ name = "IntelOneMono Nerd Font",       size = 12 },
        { name = "BlexMono Nerd Font",           size = 12 },  -- IBM Plex Mono
        { name = "MartianMono Nerd Font",        size = 12 },
        { name = "SpaceMono Nerd Font",          size = 12 },
        --{ name = "RecMonoLinear Nerd Font",      size = 12 },  -- Recursive Mono
        { name = "Agave Nerd Font",              size = 12 },
        --{ name = "DaddyTimeMono Nerd Font",      size = 12 },
        { name = "Monoid Nerd Font",             size = 12 },
        { name = "Mononoki Nerd Font",           size = 12 },
        { name = "EnvyCodeR Nerd Font",          size = 12 },

        -- ┌──────────────────────────────────────────────────────┐
        -- │ 📚 Klasické                                          │
        -- └──────────────────────────────────────────────────────┘
        { name = "DejaVuSansM Nerd Font",        size = 12 },  -- DejaVu Sans Mono
        { name = "LiterationMono Nerd Font",     size = 12 },  -- Liberation Mono
        --{ name = "Meslo Nerd Font",              size = 12 },
        { name = "Hurmit Nerd Font",             size = 12 },  -- Hermit
        { name = "Hasklug Nerd Font",            size = 12 },  -- Hasklig
        --{ name = "Anonymice Nerd Font",          size = 12 },  -- Anonymous Pro
        --{ name = "GoMono Nerd Font",             size = 12 },
        { name = "FiraMono Nerd Font",           size = 12 },
        { name = "DroidSansM Nerd Font",         size = 12 },
        { name = "CodeNewRoman Nerd Font",       size = 12 },
        { name = "ShureTechMono Nerd Font",      size = 12 },  -- Share Tech Mono
        { name = "RobotoMono Nerd Font",         size = 12 },
        { name = "UbuntuMono Nerd Font",         size = 12 },
        { name = "UbuntuSans Nerd Font",         size = 12 },
        { name = "Cousine Nerd Font",            size = 12 },
        { name = "Arimo Nerd Font",              size = 12 },
        --{ name = "Tinos Nerd Font",              size = 12 },
        --{ name = "Overpass Nerd Font",           size = 12 },
        --{ name = "Lekton Nerd Font",             size = 12 },
        --{ name = "Noto Nerd Font",               size = 12 },

        -- ┌──────────────────────────────────────────────────────┐
        -- │ 🎮 Speciální / Retro / Zábavné                      │
        -- └──────────────────────────────────────────────────────┘
        --{ name = "FantasqueSansM Nerd Font",     size = 12 },  -- Fantasque Sans Mono
        --{ name = "ComicShannsMono Nerd Font",    size = 12 },
        --{ name = "Monofur Nerd Font",            size = 12 },
        --{ name = "BigBlueTerminal Nerd Font",    size = 12 },
        --{ name = "3270 Nerd Font",               size = 12 },
        --{ name = "ProggyClean Nerd Font",        size = 13 },  -- Bitmap, lepší větší
        --{ name = "Terminess Nerd Font",          size = 12 },  -- Terminus
        --{ name = "OpenDyslexicM Nerd Font",      size = 12 },  -- Pro dyslexii
        --{ name = "D2Coding Nerd Font",           size = 12 },
        --{ name = "M+1Code Nerd Font",            size = 12 },  -- M+
        --{ name = "Gohu Nerd Font",               size = 12 },
        --{ name = "InconsolataGo Nerd Font",      size = 12 },
        --{ name = "InconsolataLGC Nerd Font",     size = 12 },
        --{ name = "BitstreamVeraSansMono Nerd Font", size = 12 },
        --{ name = "ProFont Nerd Font",            size = 12 },
        --{ name = "iM-Writing Nerd Font",         size = 12 },  -- iA Writer
        --{ name = "HeavyData Nerd Font",          size = 12 },

        -- ┌──────────────────────────────────────────────────────┐
        -- │ 🐧 Systémové Debian fonty (fallback, bez ikon)      │
        -- └──────────────────────────────────────────────────────┘
        --{ name = "DejaVu Sans Mono",             size = 12 },
        --{ name = "Liberation Mono",              size = 12 },
        --{ name = "Noto Sans Mono",               size = 12 },
    }
    font_index = saved.font_index or 1
    if font_index < 1 or font_index > #fonts then
        font_index = 1
    end

    -- NOVÉ: přidán parametr silent
    local function set_font(index, silent)
        if not vim.g.neovide then
            if not silent then
                vim.notify("Přepínání fontů je dostupné pouze v Neovide", vim.log.levels.WARN)
            end
        return
    end
    font_index = index        
        local f = fonts[font_index]
        vim.opt.guifont = f.name .. ":h" .. f.size
        if not silent then
            vim.notify(string.format(" Font [%d/%d]: %s (h%d)",
                font_index, #fonts, f.name, f.size))
        end
        save_current(theme_index, font_index)    -- NOVÉ
    end

    local function cycle_font(direction)
        local new_index = font_index + direction
        if new_index > #fonts then new_index = 1 end
        if new_index < 1 then new_index = #fonts end
        set_font(new_index)
    end

    -- F9 = další font, Shift+F11 = předchozí font
    vim.keymap.set("n", "<F9>", function() cycle_font(1) end,
        { desc = "Další font" })
    vim.keymap.set("n", "<S-F9>", function() cycle_font(-1) end,
        { desc = "Předchozí font" })

    -- Příkaz :Font <index> pro přímý výběr
    vim.api.nvim_create_user_command("Font", function(args)
        local idx = tonumber(args.args)
        if idx and idx >= 1 and idx <= #fonts then
            set_font(idx)
        else
            -- Vypsat dostupné fonty
            vim.notify("Dostupné fonty:", vim.log.levels.INFO)
            for i, f in ipairs(fonts) do
                local marker = (i == font_index) and " → " or "   "
                vim.notify(string.format("%s%d. %s (h%d)", marker, i, f.name, f.size))
            end
        end
    end, {
        nargs = "?",
        desc = "Zobrazit/vybrat font (:Font nebo :Font 3)",
    })

    -- Aplikuj ulozeny font AZ kdyz se pripoji Neovide UI (ne pri headless startu!)
    vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
            if vim.g.neovide then
                set_font(font_index, true)
            end
        end,
    })
end
