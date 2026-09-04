local keymap = vim.keymap.set
local set = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.spelllang = { 'en_us' }

vim.cmd("source ~/dotfiles/common.vim")

-- Telescope {{{
local function config_telescope()
    require('telescope').setup({
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
            }
        }
    }
    )
    require('telescope').load_extension('fzf')
end


local function init_telescope()
    keymap('n', '<Leader>p', '<cmd>Telescope find_files<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>q', '<cmd>Telescope quickfix<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>b', '<cmd>Telescope buffers<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>/', '<cmd>Telescope live_grep<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>/h', '<cmd>Telescope help_tags<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>/t', '<cmd>Telescope treesitter<cr>', { expr = false, noremap = true })
    keymap('n', '<Leader>/d', '<cmd>Telescope diagnostics<cr>', { expr = false, noremap = true })
end

-- }}}

-- LuaSnip {{{
local function config_luasnip()
    local ls = require("luasnip")
    local snip = ls.snippet
    local text = ls.text_node
    ls.add_snippets(
        "c", {
            snip("cscript",
                {
                    text({ "#!/bin/bash", "tail -n +3 $0 | gcc -std=c17 -Wall -Werror -O3 -x c - && exec ./a.out" }),
                }
            )
        })
    ls.add_snippets(
        "cpp", {
            snip("cscript",
                {
                    text({ "#!/bin/bash", "tail -n +3 $0 | g++ -std=c++17 -Wall -Werror -O3 -x c++ - && exec ./a.out" }),
                }
            )
        }
    )

    require("luasnip.loaders.from_vscode").lazy_load()
end

local function init_luasnip()
    keymap("i", "<Esc>n", "<Plug>luasnip-expand-or-jump", { expr = false })
    keymap("s", "<Esc>n", "<Plug>luasnip-expand-or-jump", { expr = false })
    keymap("i", "<Esc>p", "<Plug>luasnip-jump-prev", { expr = false })
    keymap("s", "<Esc>p", "<Plug>luasnip-jump-prev", { expr = false })
end
-- }}}

-- nvim-cmp {{{
local function opts_cmp()
    local cmp = require('cmp')

    local source_mapping = {
        copilot = "[AI]",
        codeium = "[AI]",
        luasnip = "[Snip]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[LSP]",
        buffer = "[Buf]",
        path = "[Path]",
        spell = "[Spell]",
    }

    return {
        mapping = {

            ['<C>n'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C>p'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<Right>'] = cmp.mapping.close(),
            ['<C-f>'] = cmp.mapping.complete(),
            ['§'] = cmp.mapping.confirm({ select = true }),
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
        sources = cmp.config.sources(
            {
                { name = "copilot", },
                {
                    name = 'codeium',
                },
                {
                    name = 'luasnip',
                },
                {
                    name = 'nvim_lsp',
                },
                {
                    name = 'nvim_lsp_signature_help',
                },
                {
                    name = 'buffer',
                },
                {
                    name = 'spell',
                    option = {
                        keep_all_entries = true,
                        enable_in_context = function()
                            return require('cmp.config.context').in_treesitter_capture('spell')
                        end,
                    },
                },
            }),
        view = {
            entries = "native"
        },
        experimental = {
            ghost_text = false,
        },
    }
end
-- }}}

-- Lualine {{{
local opts_lualine = {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = { { 'filename', file_status = true, path = 1 } },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = { { 'buffers', mode = 4 } },
        lualine_b = { 'branch' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { 'tabs', mode = 2 } }
    },
    extensions = {}
}
-- }}}

local opts_treesitter = {
    install_dir = vim.fn.stdpath('data') .. '/site',
}

local init_treesitter = function()
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match) or args.match
            if not vim.tbl_contains(require('nvim-treesitter').get_installed(), lang) then
                if vim.tbl_contains(require('nvim-treesitter').get_available(), lang) then
                    require('nvim-treesitter').install(lang)
                end
                return
            end

            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    })
    set.foldlevelstart = 20
end

local init_treesitter_textobjects = function()
    require('nvim-treesitter-textobjects').setup({
        select = {
            lookahead = true,
        },
        move = {
            set_jumps = true,
        },
    })

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')

    local select_keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ak"] = "@comment.outer",
        ["ik"] = "@comment.outer",
    }
    for lhs, query in pairs(select_keymaps) do
        keymap({ 'x', 'o' }, lhs, function() select.select_textobject(query, 'textobjects') end,
            { expr = false, noremap = true })
    end

    local move_keymaps = {
        ["]m"] = { move.goto_next_start, "@function.outer" },
        ["]]"] = { move.goto_next_start, "@class.outer" },
        ["]M"] = { move.goto_next_end, "@function.outer" },
        ["]["] = { move.goto_next_end, "@class.outer" },
        ["[m"] = { move.goto_previous_start, "@function.outer" },
        ["[["] = { move.goto_previous_start, "@class.outer" },
        ["[M"] = { move.goto_previous_end, "@function.outer" },
        ["[]"] = { move.goto_previous_end, "@class.outer" },
        ["]k"] = { move.goto_next_start, "@comment.outer" },
        ["[k"] = { move.goto_previous_start, "@comment.outer" },
    }
    for lhs, fn_query in pairs(move_keymaps) do
        local fn, query = fn_query[1], fn_query[2]
        keymap({ 'n', 'x', 'o' }, lhs, function() fn(query, "textobjects") end, { expr = false, noremap = true })
    end
end

-- }}}

-- Lsp {{{
local function opts_mason_lspconfig()
    -- Rust {{{

    local rust_opts = {
        tools = { -- rust-tools options
            autoSetHints = true,
            hover_actions = {
                auto_focus = true,
            },
            inlay_hints = {
                only_current_line = true,
                show_parameter_hints = true,
            },
        },
        -- All the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
            -- on_attach is a callback called when the language server attaches to the buffer
            -- on_attach = on_attach,
            settings = {
                -- To enable rust-analyzer settings visit:
                -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                ["rust_analyzer"] = {
                    -- enable clippy on save
                    checkOnSave = {
                        command = "clippy"
                    },
                }
            }
        },
    }
    -- }}}

    -- Lua {{{
    local lua_opts = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }
    -- }}}

    -- C/C++ {{{
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Used with the CursorHold event below to display inlay hints after a delay
    vim.api.nvim_set_option_value("updatetime", 300, {})

    local clangd_opts = {
        capabilities = capabilities,
        on_attach = function()
            require("clangd_extensions").setup({
                inlay_hints = {
                    inline = false,
                    only_current_line = true,
                }
            })
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
        end
    }
    -- }}}

    -- Zig {{{
    local zig_opts = {
        settings = {
            warn_style = true,
            enable_build_on_save = true,
        }
    }
    -- }}}

    vim.lsp.config('lua_ls', lua_opts)
    vim.lsp.config('clangd', clangd_opts)
    vim.lsp.config('rust_analyzer', rust_opts)
    vim.lsp.config('zls', zig_opts)
    return {}
end

local function init_lspconfig()
    keymap('n', '<Leader>lr', vim.lsp.buf.rename, { expr = false, noremap = true })
    keymap('n', '<Leader>ls', "<cmd>Telescope lsp_references<cr>", { expr = false, noremap = true })
    keymap('n', 'gr', "<cmd>Telescope lsp_references<cr>", { expr = false, noremap = true })
    keymap('', '<Leader>lf', vim.lsp.buf.format, { expr = false, noremap = true })
    keymap('n', '<Leader>ln', function() vim.diagnostic.jump { count = 1, float = true } end,
        { expr = false, noremap = true })
    keymap('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, { expr = false, noremap = true })
    keymap('n', '<Leader>lp', function() vim.diagnostic.jump { count = -1, float = true } end,
        { expr = false, noremap = true })
    keymap('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, { expr = false, noremap = true })
    keymap('n', '<Leader>le', vim.diagnostic.open_float, { expr = false, noremap = true })
    keymap('n', '<Leader>la', require('actions-preview').code_actions, { expr = false, noremap = true })
    keymap('n', '<Leader>lh', vim.lsp.buf.hover, { expr = false, noremap = true })
    keymap('n', '<Leader>ld', "<cmd>Telescope diagnostics<cr>", { expr = false, noremap = true })
    keymap('n', 'gd', "<cmd>Telescope lsp_definitions<cr>", { expr = false, noremap = true })
    keymap('n', '<Leader>lD', vim.lsp.buf.declaration, { expr = false, noremap = true })
    keymap('n', 'gD', vim.lsp.buf.declaration, { expr = false, noremap = true })
    keymap('n', '<Leader>li', vim.lsp.buf.implementation, { expr = false, noremap = true })
    keymap('n', '<Leader>lt', vim.lsp.buf.references, { expr = false, noremap = true })
    keymap('n', '<Leader>lc', vim.lsp.codelens.run, { expr = false, noremap = true })
    keymap('i', '<C-h>', vim.lsp.buf.signature_help, { expr = false, noremap = true })
    keymap('i', '<C-k>', vim.lsp.buf.hover, { expr = false, noremap = true })

    vim.lsp.codelens.enable(true)
    vim.cmd("highlight LspInlayHint ctermfg=darkgrey")
end
-- }}}

-- Plugin list {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    "airblade/vim-gitgutter",
    {
        "ziglang/zig.vim",
        enable = true,
        ft = "zig",
        init = function()
            vim.g.zig_fmt_autosave = 0
        end,
    },
    { "tweekmonster/startuptime.vim",   cmd = "StartupTime" }, -- Meassure startup time
    "junegunn/fzf",                                            -- { 'do': { -> fzf#install() } },
    {
        "junegunn/fzf.vim",
        init = function()
            keymap('n', '<C-P>', "<cmd>Files<cr>", { noremap = true })
            keymap('n', '&', "<cmd>Lines<cr>", { noremap = true })
        end
    },
    {
        -- Git commands
        "tpope/vim-fugitive",
        init = function()
            keymap('n', '<leader>g', '<cmd>Git<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gg', ':Git grep ', { expr = false, noremap = true })
            keymap('n', '<leader>gb', '<cmd>Git blame<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gs', '<cmd>Git<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gl', '<cmd>Gclog!<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gd', '<cmd>Gvdiffsplit<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gm', '<cmd>Git mergetool -y<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>ga', '<cmd>Gwrite<cr>', { expr = false, noremap = true })
            keymap('n', '<leader>gc', '<cmd>Git commit<cr>', { expr = false, noremap = true })
        end,
        cmd = { "Git", "Gwrite", "Gvdiffsplit", "Gclog" },
    },
    "tpope/vim-sleuth", -- " Automatic detection of tabwidth,
    {
        "mkindberg/ghostty-ls",
        config = true,
        ft = "ghostty"
    },
    {
        -- Theme
        "sainnhe/sonokai",
        init = function()
            vim.g.sonokai_better_performance = 1
            vim.cmd([[colorscheme sonokai]])
            vim.cmd("highlight EndOfBuffer ctermbg=none")
            vim.cmd("highlight CursorLine cterm=bold ctermbg=black")
            vim.cmd("highlight Normal ctermbg=None")
            vim.cmd("highlight NormalNC ctermbg=None")
        end,
    },
    {
        -- Indentation guides
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = true
    },
    { "hiphish/rainbow-delimiters.nvim" }, -- colored parentheses
    {
        -- Maximize splits
        "szw/vim-maximizer",
        init = function()
            keymap('n', '<leader>m', "<cmd>MaximizerToggle<cr>",
                { noremap = true })
        end,
        cmd = "MaximizerToggle",
    },
    { "kylechui/nvim-surround", config = true }, -- Motions for adding and removing parentheses etc
    { "nvim-lua/popup.nvim",    lazy = true },   -- Needed by other plugins
    { "nvim-lua/plenary.nvim",  lazy = true },   -- Needed by other plugins
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        lazy = true,
    },
    {
        -- Fuzzy finder
        "nvim-telescope/telescope.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        init = init_telescope,
        config = config_telescope,
        cmd = "Telescope",
    },
    {
        -- Syntax highlight
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false, -- main branch does not support lazy-loading
        init = init_treesitter,
        opts = opts_treesitter,
        branch = "main",
    },
    {
        "romgrk/nvim-treesitter-context", -- Show function header etc when scrolling
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
    {
        -- More motions
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = init_treesitter_textobjects,
    },
    {
        -- Preview registers,
        "gennaro-tedesco/nvim-peekup",
        keys = '""'
    },
    {
        -- Download lsps
        "williamboman/mason.nvim",
        opts = {
            registries = {
                "github:mkindberg/censor-ls",
                "github:mkindberg/ghostty-ls",
                "github:mason-org/mason-registry",
            },
        },
        cmd = { "Mason" }
    },
    {
        -- Autostart lsps
        "williamboman/mason-lspconfig.nvim",
        opts = opts_mason_lspconfig,
        dependencies = { "mason.nvim", "nvim-lspconfig" },
    },
    {
        -- Configure lsps
        "neovim/nvim-lspconfig",
        lazy = true,
        init = init_lspconfig,
    },
    {
        -- Snippets
        "L3MON4D3/LuaSnip",
        config = config_luasnip,
        init = init_luasnip,
        event = "InsertEnter",
        dependencies = { "friendly-snippets" },
    },
    {
        -- Completions
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        opts = opts_cmp,
        dependencies = {
            { "hrsh7th/cmp-buffer",       lazy = true },
            { "hrsh7th/cmp-cmdline",      lazy = true },
            { "hrsh7th/cmp-path",         lazy = true },
            { "hrsh7th/cmp-nvim-lsp",     lazy = true },
            { "saadparwaiz1/cmp_luasnip", lazy = true, dependencies = "LuaSnip" },
            { "f3fora/cmp-spell",         lazy = true },
        },
    },
    { "p00f/clangd_extensions.nvim",  lazy = true },                     -- More clangd features
    { "nvim-lua/lsp-status.nvim",     lazy = true },                     -- Lsp info in statusline
    { "simrat39/rust-tools.nvim",     lazy = true },                     -- More rust features
    { "rafamadriz/friendly-snippets", lazy = true },                     -- Collection of snippets
    { "nvim-lualine/lualine.nvim",    opts = opts_lualine },             -- Statusline
    { "kyazdani42/nvim-web-devicons", config = true },                   -- Better icons
    { "aznhe21/actions-preview.nvim", lazy = true },                     -- Better code action selector
    {
        -- Highlight character to jump to with f
        "unblevable/quick-scope",
        lazy = true,
        event = "InsertEnter",
    },
    { "wsdjeg/vim-fetch" }, -- Open files with file:line
    {
        -- Better lsp logs
        "mhanberg/output-panel.nvim",
        cmd = "OutputPanel",
        config = function()
            require("output_panel").setup()
        end
    }
}
local lazy_opts = {}

require("lazy").setup(plugins, lazy_opts)
-- }}}

-- Autocorrect {{{
vim.cmd.abbrev("pritnf", "printf")
vim.cmd.abbrev("cosnt", "const")
-- }}}

-- Key binding {{{

keymap('n', '<leader><leader>', "za", { noremap = true })
keymap('n', '<F5>', "<cmd>e<cr>", { noremap = true })
keymap('n', '<S-H>', "<cmd>set cursorline!<cr>", { noremap = true })
keymap('i', 'jj', "<Esc>", { noremap = true })
keymap('n', '<leader>rn', "<cmd>set relativenumber!<cr>", { noremap = true })
keymap('n', '<leader>n', "<cmd>set number!<cr>", { noremap = true })

-- Movements
keymap('n', '¤', "$", { noremap = true })
keymap('n', 'ä', "$", { noremap = true })
keymap('n', 'ö', "^", { noremap = true })

keymap('n', '<A-n>', "<cmd>cn<cr>", { noremap = true })
keymap('n', '<A-p>', "<cmd>cp<cr>", { noremap = true })

-- Open vimrc
keymap('n', "<leader>ev", "<cmd>vsplit $MYVIMRC<cr>", { noremap = true })
keymap('n', "<leader>evv", "<cmd>tabnew ~/dotfiles/vimrc.lua<cr>",
    { noremap = true })

-- Save as root even when file wasn't open with sudo
keymap('c', "w!!", "w !sudo tee > /dev/null %", { noremap = true })

-- Move between buffers
keymap('n', "<leader>1", "<cmd>buffer 1<cr>", { noremap = true })
keymap('n', "<leader>2", "<cmd>buffer 2<cr>", { noremap = true })
keymap('n', "<leader>3", "<cmd>buffer 3<cr>", { noremap = true })
keymap('n', "<leader>4", "<cmd>buffer 4<cr>", { noremap = true })
keymap('n', "<leader>5", "<cmd>buffer 5<cr>", { noremap = true })
keymap('n', "<leader>6", "<cmd>buffer 6<cr>", { noremap = true })

-- Move between tabs
keymap('n', "<localleader>1", "1gt", { noremap = true })
keymap('n', "<localleader>2", "2gt", { noremap = true })
keymap('n', "<localleader>3", "3gt", { noremap = true })
keymap('n', "<localleader>4", "4gt", { noremap = true })
keymap('n', "<localleader>5", "5gt", { noremap = true })
keymap('n', "<localleader>6", "6gt", { noremap = true })

keymap('', '<leader>c', "gc", { remap = true })
--- }}}

-- Settings {{{
set.mouse = ""
set.spell = true
set.undofile = true
vim.cmd("highlight ExtraWhitespace ctermbg=red")
vim.cmd('syntax match ExtraWhitespace /\\s\\+$/')
vim.cmd("highlight LeadingTab ctermbg=blue")
vim.cmd("syntax match LeadingTab /^\\t\\+/")

-- }}}

-- Auto commands {{{

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
    {
        pattern = { "*.ghostty", "*ghostty/config" },
        callback = function()
            set.filetype = "ghostty"
            set.commentstring = "# %s"
        end
    }
)

vim.api.nvim_create_autocmd("FileType",
    { pattern = { "c", "cpp" }, callback = function() set.commentstring = "// %s" end }
)

local au_group_all = vim.api.nvim_create_augroup("all_files", { clear = true })
vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    group = au_group_all,
    pattern = "*",
    callback = function()
        set.relativenumber = false
        set.number = false
    end
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = au_group_all,
    pattern = "*",
    callback = function()
        set.relativenumber = true
        set.number = true
    end
})
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = au_group_all,
    pattern = "*",
    callback = function()
        vim.cmd("%s/\\s\\+$//e")
    end
})

local au_group_dotfiles = vim.api.nvim_create_augroup("dotfiles", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = au_group_dotfiles,
    pattern = { "*vimrc*", "*shrc", "init.lua" },
    callback = function()
        vim.opt_local.foldmethod = "marker"
        vim.opt_local.foldlevel = 0
    end
})

-- }}}

