-- ==========================================================================
--  Základní nastavení (odpovídá sekcím 1, 2, 4 původního .vimrc)
-- ==========================================================================

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- Nastavení Python provideru — přesná cesta (bez shimu)
-- Python3 provider: jen Windows potrebuje explicitni cestu.
-- Linux guest + macOS: nvim autodetekuje python3 z PATH.
if vim.fn.has("win32") == 1 then
    vim.g.python3_host_prog = "C:/Users/wostry/scoop/apps/python/current/python.exe"
end
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")
local opt = vim.opt

-- --------------------------------------------------------------------------
-- 1. OS-specific
-- --------------------------------------------------------------------------
if vim.fn.has("win32") == 1 then
    opt.shell = "cmd.exe"
    opt.shellcmdflag = "/c"
else
    opt.shell = "/bin/bash"
end

-- GUI font (relevantní pouze pro Neovide nebo jiné GUI frontendy)
-- opt.guifont = "JetBrains Mono:h11"
-- opt.guifont = "Courier Prime:h10"
-- opt.guifont = "Source Code Pro:h10"
-- opt.guifont = "PT Mono:h10"
-- opt.guifont = "Libertinus Mono:h10"
-- opt.guifont = "Doto:h11"

-- --------------------------------------------------------------------------
-- 2. Soubory – zálohy, swap, undo
-- --------------------------------------------------------------------------
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- --------------------------------------------------------------------------
-- 2b. Odsazení a tabulátory
-- --------------------------------------------------------------------------
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- --------------------------------------------------------------------------
-- 2c. Zalamování
-- --------------------------------------------------------------------------
opt.wrap = true
opt.linebreak = true

-- --------------------------------------------------------------------------
-- 3. Kódování
-- --------------------------------------------------------------------------
-- opt.encoding NENASTAVUJEME – NeoVim má vždy UTF-8
opt.fileencoding = "utf-8"
opt.fileencodings = { "utf-8", "cp1250", "latin2", "latin1" }

-- --------------------------------------------------------------------------
-- 4. Zobrazení
-- --------------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.laststatus = 2
opt.ruler = true
opt.cmdheight = 2
opt.showmatch = true
opt.cursorline = true
opt.signcolumn = "yes"
-- termguicolors jen když terminál/GUI umí truecolor (Neovide, iTerm2);
-- Terminal.app spadne na 256-color fallback colorschemu
local ct = os.getenv("COLORTERM")
opt.termguicolors = (ct == "truecolor" or ct == "24bit")
--opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- --------------------------------------------------------------------------
-- 5. Hledání
-- --------------------------------------------------------------------------
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- --------------------------------------------------------------------------
-- 6. Schránka (clipboard)
-- --------------------------------------------------------------------------
opt.clipboard = "unnamedplus"

-- --------------------------------------------------------------------------
-- 7. Folding (skládání kódu)
-- --------------------------------------------------------------------------
opt.foldmethod = "marker"
opt.foldmarker = "{{{,}}}"
opt.foldenable = true
opt.foldcolumn = "1"
opt.foldlevelstart = 0

-- --------------------------------------------------------------------------
-- 8. Různé
-- --------------------------------------------------------------------------
-- opt.hidden NENASTAVUJEME – v NeoVimu vždy aktivní
-- opt.mousehide NENASTAVUJEME – v NeoVimu neexistuje
-- opt.visualbell NENASTAVUJEME – v NeoVimu neexistuje
-- opt.errorbells NENASTAVUJEME – v NeoVimu neexistuje
opt.backspace = { "indent", "eol", "start" }
opt.history = 200
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.suffixes:append({ ".class", ".exe", ".obj", ".dat", ".dll" })
opt.showtabline = 2
opt.matchpairs:append("<:>")
opt.sessionoptions:append({ "resize", "winpos", "folds", "tabpages" })

-- --------------------------------------------------------------------------
-- 9. Pravopis (spell checking) – čeština + angličtina
-- --------------------------------------------------------------------------
opt.spelllang = { "cs", "en" }
