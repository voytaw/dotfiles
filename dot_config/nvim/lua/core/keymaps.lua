-- ==========================================================================
--  Klávesové zkratky (odpovídá sekcím 5, 6.2 původního .vimrc)
-- ==========================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader klávesa (důležité nastavit před pluginy)
vim.g.mapleader = " "         -- mezerník jako leader (moderní standard)
vim.g.maplocalleader = ","

-- --------------------------------------------------------------------------
-- Obecné zkratky
-- --------------------------------------------------------------------------

-- Uložit soubor
map("n", "<F2>", ":w!<CR>", { desc = "Uložit soubor" })
map("n", "<C-s>", ":w<CR>", { desc = "Uložit soubor" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Uložit soubor (insert mode)" })

-- Reload souboru
map("n", "<F5>", ":e!<CR>", { desc = "Znovu načíst soubor" })

-- Další/předchozí soubor
map("n", "<F3>", ":n<CR>", { desc = "Další soubor" })
map("n", "<S-F3>", ":previous<CR>", { desc = "Předchozí soubor" })

-- Split
map("n", "<F6>", ":split<CR>", { desc = "Horizontální split" })
map("n", "<S-F6>", ":vsplit<CR>", { desc = "Vertikální split" })

-- Buffer delete
map("n", "<F8>", ":bdelete<CR>", { desc = "Smazat buffer" })
map("n", "<S-F8>", ":bdelete!<CR>", { desc = "Smazat buffer (force)" })

-- Quit
map("n", "<C-q>", ":q!<CR>", { desc = "Zavřít bez uložení" })
map("n", "<C-x>", ":x<CR>", { desc = "Uložit a zavřít" })

-- Formátování místo Ex mode
map("n", "Q", "gq", { desc = "Formátovat text" })

-- Select All
map("n", "<C-a>", "ggVG", { desc = "Vybrat vše" })

-- Zrušit zvýraznění hledání (novinka – velmi užitečné)
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Zrušit zvýraznění" })

-- --------------------------------------------------------------------------
-- Tabs (záložky) – zachováno z vašeho .vimrc
-- --------------------------------------------------------------------------
map("n", "<C-t>", ":tabnew<CR>", { desc = "Nový tab" })
map("n", "<C-F4>", ":tabclose<CR>", { desc = "Zavřít tab" })
-- Poznámka: <C-Tab> a <C-S-Tab> nefungují ve většině terminálů
-- Alternativa:
map("n", "<Tab>", ":tabnext<CR>", { desc = "Další tab" })
map("n", "<S-Tab>", ":tabprev<CR>", { desc = "Předchozí tab" })
-- Pokud používáte Neovide nebo terminál s podporou (Windows Terminal):
-- map("n", "<C-Tab>", ":tabnext<CR>", opts)
-- map("n", "<C-S-Tab>", ":tabprev<CR>", opts)

-- --------------------------------------------------------------------------
-- Splits (rozdělená okna) – z vašeho .vimrc, sekce 5.2
-- --------------------------------------------------------------------------
-- Přechod mezi okny (BEZ maximalizace – v NeoVim se to řeší jinak)
map("n", "<C-h>", "<C-w>h", { desc = "Okno vlevo" })
map("n", "<C-j>", "<C-w>j", { desc = "Okno dolů" })
map("n", "<C-k>", "<C-w>k", { desc = "Okno nahoru" })
map("n", "<C-l>", "<C-w>l", { desc = "Okno vpravo" })

-- Změna velikosti oken (novinka)
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)
map("n", "<C-=>", "<C-w>=", { desc = "Vyrovnat okna" })

-- --------------------------------------------------------------------------
-- Kopírování/vkládání – systémová schránka
-- --------------------------------------------------------------------------
map("x", "<C-S-c>", '"+y', { desc = "Kopírovat do schránky" })
map("n", "<C-S-v>", '"+p', { desc = "Vložit ze schránky" })
map("i", "<C-S-v>", '<C-r>+', { desc = "Vložit ze schránky (insert)" })
map("x", "<C-S-x>", '"+d', { desc = "Vyjmout do schránky" })
map("v", "<C-S-v>", '"+p', { desc = "Vložit ze schránky (visual)" })

-- --------------------------------------------------------------------------
-- Folding (skládání) – z vašeho .vimrc
-- --------------------------------------------------------------------------
map("n", "-", "v%zf", { desc = "Složit blok" })
map("n", "=", "v%zd", { desc = "Rozložit blok" })

-- --------------------------------------------------------------------------
-- Přesouvání řádků (novinka – velmi užitečné)
-- --------------------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Přesunout řádky dolů" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Přesunout řádky nahoru" })

-- --------------------------------------------------------------------------
-- Kopírování cesty souboru do schránky (z vašeho .vimrc)
-- --------------------------------------------------------------------------
map("n", "<Leader>fp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Zkopírováno: " .. path)
end, { desc = "Kopírovat cestu souboru" })

-- --------------------------------------------------------------------------
-- ── Neovide (macOS GUI) clipboard keymapy ──────────────────────────────
-- --------------------------------------------------------------------------
-- POZOR: NE v `if vim.g.neovide`! nvim bezi headless (--listen) a Neovide
-- se pripojuje az POTE -> vim.g.neovide je pri nacitani configu jeste false
-- a blok by se preskocil. <D-...> stejne nelze zadat v terminalu, takze
-- mimo Neovide jsou tyto mapy inertni (nic nerozbiji).
map({ "n", "v" }, "<D-c>", '"+y',    { desc = "Cmd+C kopirovat" })
map({ "n", "v" }, "<D-v>", '"+p',    { desc = "Cmd+V vlozit" })
map({ "n", "v" }, "<D-x>", '"+d',    { desc = "Cmd+X vyjmout" })
map({ "n", "v" }, "<D-a>", "ggVG",   { desc = "Cmd+A vybrat vse" })
map("i",          "<D-v>", "<C-r>+", { desc = "Cmd+V vlozit (insert)" })
map("c",          "<D-v>", "<C-r>+", { desc = "Cmd+V vlozit (cmdline)" })

-- --------------------------------------------------------------------------
-- ── Prohazovani radku (jako MS Word) ──────────────────────────────────
-- --------------------------------------------------------------------------
-- Ctrl+Shift+Sipka (macOS) + Shift+Alt+Sipka (Windows styl)
-- Normal mode: posun aktualniho radku
map("n", "<C-S-Down>", ":m .+1<CR>==",  { desc = "Přesunout řádek dolů" })
map("n", "<C-S-Up>",   ":m .-2<CR>==",  { desc = "Přesunout řádek nahoru" })
map("n", "<M-S-Down>", ":m .+1<CR>==",  { desc = "Přesunout řádek dolů" })
map("n", "<M-S-Up>",   ":m .-2<CR>==",  { desc = "Přesunout řádek nahoru" })
-- Insert mode: vyskoc, posun, vrat se do insertu
map("i", "<C-S-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Přesunout řádek dolů (insert)" })
map("i", "<C-S-Up>",   "<Esc>:m .-2<CR>==gi", { desc = "Přesunout řádek nahoru (insert)" })
map("i", "<M-S-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Přesunout řádek dolů (insert)" })
map("i", "<M-S-Up>",   "<Esc>:m .-2<CR>==gi", { desc = "Přesunout řádek nahoru (insert)" })
-- Visual mode: posun celeho vyberu (zustane oznaceny)
map("v", "<C-S-Down>", ":m '>+1<CR>gv=gv", { desc = "Přesunout výběr dolů" })
map("v", "<C-S-Up>",   ":m '<-2<CR>gv=gv", { desc = "Přesunout výběr nahoru" })
map("v", "<M-S-Down>", ":m '>+1<CR>gv=gv", { desc = "Přesunout výběr dolů" })
map("v", "<M-S-Up>",   ":m '<-2<CR>gv=gv", { desc = "Přesunout výběr nahoru" })
  
