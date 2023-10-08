local keymap = vim.keymap.set
local set = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd("source ~/dotfiles/common.vim")

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

local function use_ai_completion()
  return vim.g.use_ai_comp == 1
end

local plugins = {
  {
    "tamton-aquib/duck.nvim",
    init = function()
      keymap('n', '<leader>dd', function() require("duck").hatch() end, {})
      keymap('n', '<leader>dk', function() require("duck").cook() end, {})
    end
  },
  "Raimondi/delimitMate", -- Automatically close parantheses etc.
  "junegunn/fzf",         -- { 'do': { -> fzf#install() } },
  {
    "junegunn/fzf.vim",
    init = function()
      keymap('n', '<C-P>', "<cmd>Files<cr>", { noremap = true })
      keymap('n', '<&>', "<cmd>Lines<cr>", { noremap = true })
    end
  },
  {
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
    end
  },
  "tpope/vim-sleuth", -- " Automatic detection of tabwidth,
  {
    "sainnhe/sonokai",
    config = function()
      vim.cmd([[colorscheme sonokai]])
      vim.cmd("highlight EndOfBuffer ctermbg=none")
      vim.cmd("highlight CursorLine cterm=bold ctermbg=black")
      vim.cmd("highlight Normal ctermbg=None")
      vim.cmd("highlight NormalNC ctermbg=None")
    end,
  },
  { "Yggdroot/indentLine",             init = function() vim.g.indentLine_char = '|' end }, -- " Show indentation markers,
  {
    "szw/vim-maximizer",
    init = function()
      keymap('n', '<leader>m', "<cmd>MaximizerToggle<cr>",
        { noremap = true })
    end,
    lazy = true,
    cmd = "MaximizerToggle",
  },
  { "kylechui/nvim-surround",          config = true },
  { "nvim-lua/popup.nvim",             lazy = true },
  { "nvim-lua/plenary.nvim",           lazy = true },
  { "nvim-telescope/telescope.nvim",   dependencies = { 'nvim-lua/plenary.nvim' } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-refactor",
  "romgrk/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "gennaro-tedesco/nvim-peekup", -- " Preview registers,
  { "williamboman/mason.nvim",           config = true, lazy = true, cmd = { "Mason" } },
  { "williamboman/mason-lspconfig.nvim", config = true, },
  "neovim/nvim-lspconfig",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "p00f/clangd_extensions.nvim",
  "nvim-lua/lsp-status.nvim",
  "simrat39/rust-tools.nvim",
  {
    "numToStr/Comment.nvim",
    init = function()
      keymap({''}, '<leader>c', "gc", { remap = true })
    end,
    config = true,
    lazy = true,
    keys = "gc"
  },
  "nvim-lualine/lualine.nvim",
  { "kyazdani42/nvim-web-devicons", config = true },
  "ray-x/lsp_signature.nvim",
  "weilbith/nvim-code-action-menu",
  "unblevable/quick-scope",
  {
    "tzachar/cmp-tabnine",
    enabled = use_ai_completion(),
    build =
    "./install.sh"
  },
  { "jcdickinson/codeium.nvim",     enabled = use_ai_completion(), config = {} },
}
local lazy_opts = {}

require("lazy").setup(plugins, lazy_opts)

-- runCmd {{{
local runCmd_config = {
  trigger = "Run with:",
  keymap = "<M-r>",
}
function runCmd(line, linenr)
  local cmd
  local start, stop = line:find(runCmd_config.trigger)
  if (stop ~= nil) then
    cmd = string.sub(line, stop + 1, -1)
  else
    cmd = "./" .. vim.fn.expand("%")
  end
  cmd = string.gsub(cmd, "^%s+", "")
  cmd = string.gsub(cmd, "%s+$", "")

  print("Executing", cmd)
  if (string.sub(cmd, 1, 1) == ':') then
    vim.api.nvim_command(string.sub(cmd, 2, -1))
  else
    vim.api.nvim_command("!" .. cmd)
  end
end

keymap('n', runCmd_config.keymap, '<cmd>0luado runCmd(line, linenr)<CR>', { expr = false, noremap = true })
-- }}}

-- Treesitter {{{
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  auto_install = true,
  indent = {
    enable = true
  },
  -- refactor = {
  --   highlight_definitions = { enable = true },
  --   highlight_current_scope = { enable = false },
  -- },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ak"] = "@comment.outer",
        ["ik"] = "@comment.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },

    },
  },
}
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldlevelstart = 20

-- }}}

-- Telescope {{{
require('telescope').setup {
  defaults = {
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}
require('telescope').load_extension('fzf')

keymap('n', '<Leader>p', '<cmd>Telescope find_files<cr>', { expr = false, noremap = true })
keymap('n', '<Leader>q', '<cmd>Telescope quickfix<cr>', { expr = false, noremap = true })
keymap('n', '<Leader>b', '<cmd>Telescope buffers<cr>', { expr = false, noremap = true })
keymap('n', '<Leader>/', '<cmd>Telescope live_grep<cr>', { expr = false, noremap = true })
keymap('n', '<Leader>/h', '<cmd>Telescope help_tags<cr>', { expr = false, noremap = true })
keymap('n', '<Leader>/t', '<cmd>Telescope treesitter<cr>', { expr = false, noremap = true })

-- }}}

-- nvim-cmp {{{
local cmp = require 'cmp'

local source_mapping = {
  codeium = "[AI]",
  luasnip = "[Snip]",
  nvim_lsp = "[LSP]",
  buffer = "[Buf]",
  cmp_tabnine = "[TN]",
  path = "[Path]",
}

cmp.setup({
  mapping = {
    ['<C>n'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C>p'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Right>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  snippet = {
    expand = function(args)
      require 'luasnip'.lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources(
    {
      {
        name = 'codeium',
        keyword_length = 0,
      },
      {
        name = 'luasnip',
        keyword_length = 1,
      },
      {
        name = 'nvim_lsp',
        keyword_length = 1,
      },
      {
        name = 'cmp_tabnine',
        keyword_length = 1,
      },
      {
        name = 'buffer',
        keyword_length = 1,
      },
    }),
  view = {
    entries = "native"
  },
  experimental = {
    ghost_text = true,
  },
  formatting = {
    format = function(entry, vim_item)
      local menu = source_mapping[entry.source.name]
      if entry.source.name == 'cmp_tabnine' then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = entry.completion_item.data.detail .. ' ' .. menu
        end
      end
      vim_item.menu = menu
      return vim_item
    end
  },
})


-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })
-- }}}

-- Tabnine {{{
if vim.api.nvim_eval('exists("use_ai_comp")') == true and vim.api.nvim_get_var("use_ai_comp") == 1 then
  local tabnine = require('cmp_tabnine.config')
  tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
  })
end
-- }}}

-- LuaSnip {{{
local function copy(args)
  return args[1]
end
local ls = require("luasnip")
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
ls.snippets = {
  all = {
  },
  c = {
    snip("cscript",
      {
        text({ "#!/bin/bash", "tail -n +3 $0 | gcc -std=c17 -Wall -Werror -O3 -x c - && exec ./a.out" }),
      }
    )
  },
  cpp = {
    snip("cscript",
      {
        text({ "#!/bin/bash", "tail -n +3 $0 | g++ -std=c++17 -Wall -Werror -O3 -x c++ - && exec ./a.out" }),
      }
    )
  },
}

ls.filetype_extend("cpp", { "c" })
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end
_G.tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_next_item()
  elseif ls and ls.expand_or_jumpable() then
    return t("<Plug>luasnip-expand-or-jump")
  else
    return t "<Tab>"
  end
  return ""
end
_G.s_tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_prev_item()
  elseif ls and ls.jumpable(-1) then
    return t("<Plug>luasnip-jump-prev")
  else
    return t "<S-Tab>"
  end
  return ""
end

keymap("i", "<Esc>n", "<Plug>luasnip-expand-or-jump", { expr = false })
keymap("s", "<Esc>n", "<Plug>luasnip-expand-or-jump", { expr = false })
keymap("i", "<Esc>p", "<Plug>luasnip-jump-prev", { expr = false })
keymap("s", "<Esc>p", "<Plug>luasnip-jump-prev", { expr = false })
-- keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- }}}

-- Lsp {{{

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
  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    -- on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Used with the CursorHold event below to display inlay hints after a delay
vim.api.nvim_set_option("updatetime", 600)

local clangd_opts = {
  server = {
    -- options to pass to nvim-lspconfig
    -- i.e. the arguments to require("lspconfig").clangd.setup({})
    capabilities = capabilities,
  },
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = true,
    -- Whether to show hover actions inside the hover window
    -- This overrides the default hover handler
    hover_with_actions = true,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- Only show inlay hints for the current line
      only_current_line = true,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- whether to show variable name before type hints with the inlay hints or not
      show_variable_name = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
    },
  }
}
-- }}}


require("mason-lspconfig").setup_handlers {
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  ["lua_ls"] = function()
    require 'lspconfig'.lua_ls.setup(lua_opts)
  end,
  ["rust_analyzer"] = function()
    require("rust-tools").setup(rust_opts)
  end,
  ["clangd"] = function()
    require("clangd_extensions").setup(clangd_opts)
  end,
  -- ["robotframework_ls"] = function()
  --   require'lspconfig'.robotframework_ls.setup({
  --     root_dir = function() return "/home/mkindber/csp" end
  --   })
  -- end
}

keymap('n', '<Leader>lr', vim.lsp.buf.rename, { expr = false, noremap = true })
keymap('n', '<Leader>ls', vim.lsp.buf.references, { expr = false, noremap = true })
keymap('n', 'gr', vim.lsp.buf.references, { expr = false, noremap = true })
keymap('n', '<Leader>lf', vim.lsp.buf.format, { expr = false, noremap = true })
keymap('n', '<Leader>ln', vim.diagnostic.goto_next, { expr = false, noremap = true })
keymap('n', ']d', vim.diagnostic.goto_next, { expr = false, noremap = true })
keymap('n', '<Leader>lp', vim.diagnostic.goto_prev, { expr = false, noremap = true })
keymap('n', '[d', vim.diagnostic.goto_prev, { expr = false, noremap = true })
keymap('n', '<Leader>le', vim.diagnostic.open_float, { expr = false, noremap = true })
keymap('n', '<Leader>la', ":CodeActionMenu<CR>:syntax on<CR>", { expr = false, noremap = true })
keymap('n', '<Leader>lh', vim.lsp.buf.hover, { expr = false, noremap = true })
keymap('n', '<Leader>ld', vim.lsp.buf.definition, { expr = false, noremap = true })
keymap('n', 'gd', vim.lsp.buf.definition, { expr = false, noremap = true })
keymap('n', '<Leader>lD', vim.lsp.buf.declaration, { expr = false, noremap = true })
keymap('n', 'gD', vim.lsp.buf.declaration, { expr = false, noremap = true })
keymap('n', '<Leader>li', vim.lsp.buf.implementation, { expr = false, noremap = true })
keymap('n', '<Leader>lt', vim.lsp.buf.references, { expr = false, noremap = true })
keymap('n', '<Leader>lc', vim.lsp.codelens.run, { expr = false, noremap = true })

--
--
-- if(os.execute("bash -c 'command -v rust-analyzer'") == 0) then
--   require('rust-tools').setup(opts)
-- end
-- }}}

-- Preview {{{
preview_config = {
  prefix = "",
  as_comment = true,
  max_lines = 15,
  keybind = "gF",
  hightlight_group = "Comment",
}
local preview_active = false
function preview_file(filename)
  local ns_id = vim.api.nvim_create_namespace('preview_file')
  if (preview_active) then
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    preview_active = false
    return
  end

  local bnr = vim.fn.bufnr('%')
  local line_num = vim.api.nvim_call_function("line", { "." }) - 1
  local col_num = 0

  local i = 1
  local file = io.open(filename, "r")
  local virt_text = {}

  if (file ~= nil) then
    line = file:read("*line")
    while (line ~= nil) do
      line = preview_config.prefix .. line
      if (preview_config.as_comment) then
        line = string.gsub(vim.api.nvim_buf_get_option(0, "commentstring"), "%%s", " " .. line .. " ")
      end

      virt_text[i] = { { line, preview_config.hightlight_group } }
      i = i + 1

      if i == preview_config.max_lines then
        break
      end

      line = file:read("*line")
    end

    local opts = {
      id = 1,
      virt_lines = virt_text,
    }
    local mark_id = vim.api.nvim_buf_set_extmark(0, ns_id, line_num, col_num, opts)
    preview_active = true

    file:close()
  else
    print("Cannot open file '" .. filename .. "'")
  end
end

keymap('n', preview_config.keybind, '<cmd>lua preview_file(vim.call("expand", "<cfile>"))<cr>',
  { expr = false, noremap = true })
-- }}}

-- Lualine {{{
require('lualine').setup {
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

-- Autocorrect {{{
vim.cmd.abbrev("pritnf", "printf")
-- }}}

--- Key binding {{{

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
keymap('n', '<A-p>', "<cmd>cn<cr>", { noremap = true })

-- Open vimrc
keymap('n', "<leader>ev", "<cmd>vsplit $MYVIMRC<cr>", { noremap = true })
keymap('n', "<leader>evv", "<cmd>tabnew ~/dotfiles/lua/vimrc.lua<cr>",
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

local au_group_dotfiles = vim.api.nvim_create_augroup("dotfiles", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter"}, {
  group = au_group_dotfiles,
  pattern = {"*vimrc*", "*shrc", "init.lua"},
  callback = function()
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldlevel = 0
  end
})

-- }}}

local signature_config = {
  hint_enable = false,
  max_width = 80,
}
require("lsp_signature").setup(signature_config)


function Hover()
  local width = vim.api.nvim_list_uis()[1]["width"] / 2
  local height = vim.api.nvim_list_uis()[1]["height"] / 2

  local row = vim.api.nvim_list_uis()[1]["height"] / 2 - height / 2
  local col = vim.api.nvim_list_uis()[1]["width"] / 2 - width / 2
  vim.api.nvim_open_win(0, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    border = 'single'
  })
end

vim.api.nvim_create_user_command('Hover', 'lua Hover()', {})
