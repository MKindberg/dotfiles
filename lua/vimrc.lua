local keymap = vim.keymap.set
local set = vim.opt

-- runCmd {{{
local runCmd_config = {
  trigger = "Run with:",
  keymap = "<M-r>",
}
function runCmd(line, linenr)
  local cmd
  local start, stop = line:find(runCmd_config.trigger)
  if (stop ~= nil) then
    cmd = string.sub(line,stop+1,-1)
  else
    cmd = "./" .. vim.fn.expand("%")
  end
  cmd = string.gsub(cmd,"^%s+","")
  cmd = string.gsub(cmd,"%s+$","")

  print("Executing", cmd)
  if (string.sub(cmd,1,1) == ':') then
    vim.api.nvim_command(string.sub(cmd,2,-1))
  else
    vim.api.nvim_command("!"..cmd)
  end
end
keymap('n', runCmd_config.keymap, '<cmd>0luado runCmd(line, linenr)<CR>', {expr = false, noremap = true})
-- }}}

-- Treesitter {{{
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldlevelstart = 20

-- }}}

-- Telescope {{{
require('telescope').setup{
  defaults = {
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}

keymap('n', '<Leader>p', '<cmd>Telescope find_files<cr>', {expr = false, noremap = true})
keymap('n', '<Leader>q', '<cmd>Telescope quickfix<cr>', {expr = false, noremap = true})
keymap('n', '<Leader>b', '<cmd>Telescope buffers<cr>', {expr = false, noremap = true})
keymap('n', '<Leader>/', '<cmd>Telescope live_grep<cr>', {expr = false, noremap = true})
keymap('n', '<Leader>/h', '<cmd>Telescope help_tags<cr>', {expr = false, noremap = true})
keymap('n', '<Leader>/t', '<cmd>Telescope treesitter<cr>', {expr = false, noremap = true})

-- }}}

-- nvim-cmp {{{
local cmp = require'cmp'

local source_mapping = {
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
      require'luasnip'.lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources(
  {
    {
      name= 'luasnip',
      keyword_length = 2,
    },
    {
      name = 'nvim_lsp',
      keyword_length = 2,
    },
    {
      name = 'cmp_tabnine',
      keyword_length = 3,
    },
    {
      name = 'buffer',
      keyword_length = 3,
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
local tabnine = require('cmp_tabnine.config')
tabnine:setup({
  max_lines = 1000;
  max_num_results = 20;
  sort = true;
  run_on_every_keystroke = true;
  snippet_placeholder = '..';
})
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
      text({"#!/bin/bash", "tail -n +3 $0 | gcc -std=c17 -Wall -Werror -O3 -x c - && exec ./a.out"}),
    }
    )
  },
  cpp = {
    snip("cscript",
    {
      text({"#!/bin/bash", "tail -n +3 $0 | g++ -std=c++17 -Wall -Werror -O3 -x c++ - && exec ./a.out"}),
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

keymap("i", "<Esc>n", "<Plug>luasnip-expand-or-jump", {expr = false})
keymap("s", "<Esc>n", "<Plug>luasnip-expand-or-jump", {expr = false})
keymap("i", "<Esc>p", "<Plug>luasnip-jump-prev", {expr = false})
keymap("s", "<Esc>p", "<Plug>luasnip-jump-prev", {expr = false})
keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- }}}

-- Lsp {{{
if(os.execute("bash -c 'command -v gopls'") == 0) then
  require'lspconfig'.gopls.setup{}
end
if(os.execute("bash -c 'command -v pyright'") == 0) then
  require'lspconfig'.pyright.setup{}
end
if(os.execute("bash -c 'command -v bash-language-server'") == 0) then
  require'lspconfig'.bashls.setup{}
end
if(os.execute("bash -c 'command -v lua-language-server'") == 0) then
  require'lspconfig'.sumneko_lua.setup{
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end
if(os.execute("bash -c 'command -v texlab'") == 0) then
  require'lspconfig'.texlab.setup{}
end

keymap('n', '<Leader>lr', vim.lsp.buf.rename, {expr = false, noremap = true})
keymap('n', '<Leader>lf', vim.lsp.buf.formatting, {expr = false, noremap = true})
keymap('n', '<Leader>ln', vim.diagnostic.goto_next, {expr = false, noremap = true})
keymap('n', '<Leader>lp', vim.diagnostic.goto_prev, {expr = false, noremap = true})
keymap('n', '<Leader>le', vim.diagnostic.open_float, {expr = false, noremap = true})
keymap('n', '<Leader>la', vim.lsp.buf.code_action, {expr = false, noremap = true})
keymap('n', '<Leader>lh', vim.lsp.buf.hover, {expr = false, noremap = true})
keymap('n', '<Leader>ld', vim.lsp.buf.definition, {expr = false, noremap = true})
keymap('n', '<Leader>lD', vim.lsp.buf.declaration, {expr = false, noremap = true})
keymap('n', '<Leader>li', vim.lsp.buf.implementation, {expr = false, noremap = true})
keymap('n', '<Leader>lt', vim.lsp.buf.references, {expr = false, noremap = true})

local opts = {
  tools = { -- rust-tools options
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
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
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
}

require('rust-tools').setup({})
-- }}}

-- Clangd {{{

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require("clangd_extensions").setup {
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
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- whether to show variable name before type hints with the inlay hints or not
            show_variable_name = false,
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

-- Comment {{{
require('Comment').setup()
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
  if(preview_active) then
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    preview_active = false
    return
  end

  local bnr = vim.fn.bufnr('%')
  local line_num = vim.api.nvim_call_function("line", {"."}) - 1
  local col_num = 0

  local i = 1
  local file = io.open(filename, "r")
  local virt_text = {}

  if(file ~= nil) then
    line = file:read("*line")
    while(line ~= nil) do
      line = preview_config.prefix .. line
      if(preview_config.as_comment) then
        line = string.gsub(vim.api.nvim_buf_get_option(0, "commentstring"), "%%s", " "..line.." ")
      end

      virt_text[i] = {{line, preview_config.hightlight_group}}
      i = i+1

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
    print("Cannot open file '" .. filename .."'")
  end
end

keymap('n', preview_config.keybind, '<cmd>lua preview_file(vim.call("expand", "<cfile>"))<cr>', {expr = false, noremap = true})
-- }}}

-- Web-devicons {{{
require'nvim-web-devicons'.setup {
  -- default = true;
}
-- }}}

-- Lualine {{{
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diff', 'diagnostics'},
    lualine_c = {{'filename', file_status = true, path = 1}},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{'buffers', mode=2}},
    lualine_b = {'branch'},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {{'tabs', mode=2}}
  },
  extensions = {}
}
-- }}}

require("neogit").setup{
  disable_commit_confirmation = true
}
