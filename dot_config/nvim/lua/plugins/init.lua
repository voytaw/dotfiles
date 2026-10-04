-- ==========================================================================
--  Plugin manager: lazy.nvim – bootstrap a konfigurace
-- ==========================================================================

-- Automatická instalace lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- --------------------------------------------------------------------------
-- Seznam pluginů
-- --------------------------------------------------------------------------
require("lazy").setup({

    -- ======================================================================
    -- BAREVNÁ SCHÉMATA
    -- ======================================================================
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "dracula/vim",
        name = "dracula",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
    },

    -- ======================================================================
    -- GITHUB COPILOT
    -- ======================================================================
    {
        "github/copilot.vim",
        lazy = false,
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                desc = "Přijmout návrh Copilota",
            })
            vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Další návrh" })
            vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Předchozí návrh" })
            vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-dismiss)", { desc = "Odmítnout návrh" })
            vim.g.copilot_filetypes = {
                ["*"] = true,
                ["markdown"] = true,
                ["text"] = false,
            }
        end,
    },

    -- ======================================================================
    -- STAVOVÝ ŘÁDEK
    -- ======================================================================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        { "filename", path = 1 },
                    },
                    lualine_x = {
                        "encoding",
                        { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- ======================================================================
    -- TELESCOPE
    -- ======================================================================
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
            },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git", "%.class", "%.exe", "%.obj" },
                },
            })
            pcall(telescope.load_extension, "fzf")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Najít soubor" })
            vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Hledat v souborech" })
            vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Otevřené buffery" })
            vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Nápověda" })
            vim.keymap.set("n", "<F4>", builtin.lsp_document_symbols, { desc = "Symboly v souboru" })
            vim.keymap.set("n", "<Leader>fs", builtin.treesitter, { desc = "Treesitter symboly" })
        end,
    },

    -- ======================================================================
    -- TREESITTER
    -- ======================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "90cd6580",
        build = ":TSUpdate",
        pin = true,
        config = function()
            local ok_new, ts = pcall(require, "nvim-treesitter")
            if ok_new and ts.setup then
                ts.setup({
                    ensure_installed = {
                        "c", "cpp", "java", "python", "lua",
                        "javascript", "typescript", "json", "html", "css",
                        "bash", "markdown", "latex", "sql", "groovy",
                        "vim", "vimdoc", "xml", "yaml",
                    },
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<CR>",
                            node_incremental = "<CR>",
                            node_decremental = "<BS>",
                            scope_incremental = "<Tab>",
                        },
                    },
                })
                --vim.notify("Treesitter: nové API ✓"){{{}}}
                return
            end

            local ok_old, configs = pcall(require, "nvim-treesitter.configs")
            if ok_old then
                configs.setup({
                    ensure_installed = {
                        "c", "cpp", "java", "python", "lua",
                        "javascript", "typescript", "json", "html", "css",
                        "bash", "markdown", "latex", "sql", "groovy",
                        "vim", "vimdoc", "xml", "yaml",
                    },
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<CR>",
                            node_incremental = "<CR>",
                            node_decremental = "<BS>",
                            scope_incremental = "<Tab>",
                        },
                    },
                })
                -- vim.notify("Treesitter: staré API ✓"){{{}}}
                return
            end

            -- vim.notify("Treesitter: nelze nakonfigurovat", vim.log.levels.WARN)
        end,
    },

    -- ======================================================================
    -- SOUBOROVÝ PRŮZKUMNÍK
    -- ======================================================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup({
                view = { width = 35 },
                filters = { dotfiles = false },
            })
            vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { desc = "Průzkumník souborů" })
            vim.keymap.set("n", "<Leader>o", ":NvimTreeFocus<CR>", { desc = "Focus na průzkumník" })
        end,
    },

    -- ======================================================================
    -- AUTOPAIRS
    -- ======================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- ======================================================================
    -- KOMENTÁŘE
    -- ======================================================================
    {
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        config = true,
    },

    -- ======================================================================
    -- GIT INTEGRACE
    -- ======================================================================
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end,
    },

    -- ======================================================================
    -- WHICH-KEY
    -- ======================================================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                delay = 500,
            })
        end,
    },

    -- ======================================================================
    -- BUFFERLINE
    -- ======================================================================
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "tabs",
                    diagnostics = "nvim_lsp",
                    separator_style = "slant",
                },
            })
        end,
    },

    -- ======================================================================
    -- INDENT BLANKLINE
    -- ======================================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPost",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope = { enabled = true },
            })
        end,
    },

   -- ======================================================================
   -- VIMTEX – LaTeX podpora (C1: nahled deleguje na macOS Skim)
   -- ======================================================================
    {
        "lervag/vimtex",
        tag = "v2.15",                       -- PIN: bookworm ma Vim 9.0; konzistence s ~/.vimrc
        lazy = false,
        ft = { "tex", "latex", "bib" },
        init = function()
                -- VimTeX cte g:vimtex_* pri inicializaci pluginu -> MUSI byt v `init`
                -- (nikoliv `config`, ktery bezi az PO nacteni -> prepsal by se default -pdf).
        
                -- Kompilator: latexmk. Monorepo staví pres LuaLaTeX do out/
                -- (shoda s projektovym .latexmkrc: lualatex + shell-escape + synctex + biber).
                vim.g.vimtex_compiler_method = "latexmk"
                -- Default (_) prepneme z -pdf (pdflatex) na -lualatex pro cely monorepo.
                vim.g.vimtex_compiler_latexmk_engines = {
                    _ = "-lualatex",
                } 
                vim.g.vimtex_compiler_latexmk = {
                    out_dir = "out",
                    options = {
                        "-shell-escape",
                        "-file-line-error",
                        "-synctex=1",
                        "-interaction=nonstopmode",
                    },
                }
        
                -- PDF nahled per-OS:
                -- macOS (nativni nvim): Skim viewer + forward-search
                -- Linux guest (headless): view vypnut, Skim na macOS resi auto-reload
                if vim.fn.has("mac") == 1 then
                    vim.g.vimtex_view_method = "skim"
                else
                    vim.g.vimtex_view_enabled = 0
                end
        
                -- Obecne nastaveni
                vim.g.vimtex_syntax_enabled = 1
                vim.g.vimtex_quickfix_mode = 2
                vim.g.vimtex_quickfix_open_on_warning = 0
                vim.g.vimtex_syntax_conceal_disable = 1
            end,
            config = function()
                -- 
            -- ──────────────────────────────────────────────
            -- Klavesove zkratky pro LaTeX soubory
            -- ──────────────────────────────────────────────
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "tex", "latex", "bib" },
                callback = function()
                    local opts = { buffer = true, silent = true }

                    -- Kompilace
                    vim.keymap.set("n", "<Leader>ll", "<cmd>VimtexCompile<CR>",
                        vim.tbl_extend("force", opts, { desc = "Kompilace (toggle)" }))
                    vim.keymap.set("n", "<Leader>lL", "<cmd>VimtexCompileSS<CR>",
                        vim.tbl_extend("force", opts, { desc = "Jednorazova kompilace" }))

                    -- <F12> puvodne VimtexView – v guestu nema smysl (viz nize).
                    -- Ponechano zakomentovane; volitelny forward-search do Skim
                    -- resi samostatna sekce.
                    -- vim.keymap.set("n", "<F12>", "<cmd>VimtexView<CR>", ...)

                    -- Cisteni
                    vim.keymap.set("n", "<Leader>lc", "<cmd>VimtexClean<CR>",
                        vim.tbl_extend("force", opts, { desc = "Vycistit aux soubory" }))
                    vim.keymap.set("n", "<Leader>lC", "<cmd>VimtexClean!<CR>",
                        vim.tbl_extend("force", opts, { desc = "Vycistit vse vc. PDF" }))

                    -- Info a chyby
                    vim.keymap.set("n", "<Leader>li", "<cmd>VimtexInfo<CR>",
                        vim.tbl_extend("force", opts, { desc = "VimTeX info" }))
                    vim.keymap.set("n", "<Leader>le", "<cmd>VimtexErrors<CR>",
                        vim.tbl_extend("force", opts, { desc = "Zobrazit chyby" }))
                    vim.keymap.set("n", "<Leader>lt", "<cmd>VimtexTocToggle<CR>",
                        vim.tbl_extend("force", opts, { desc = "Obsah (TOC)" }))
                end,
            })
        end,
    },

    -- ======================================================================
    -- VLASTNÍ PLUGINY (z privátního GitHub repozitáře)
    -- ======================================================================

-- ← KONEC seznamu pluginů
},  {-- {{{
    -- lazy.nvim settings
    ui = {
        border = "rounded",
    },
    checker = {
        enabled = true,
        notify = false,
    },
    rocks = {
        enabled = false,
        },
})-- }}}

