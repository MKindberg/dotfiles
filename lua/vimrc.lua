local keymap = vim.api.nvim_set_keymap
local set = vim.opt
-- runCmd {{{
function runCmd(line, linenr)
  local cmd
  local start, stop = line:find("Run with:")
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
keymap('n', '<M-r>', '<cmd>0luado runCmd(line, linenr)<CR>', {expr = false, noremap = true})
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
  buffer = "[Buf]",
  nvim_lsp = "[LSP]",
  cmp_tabnine = "[TN]",
  path = "[Path]",
  luasnip = "[Snip]",
}
cmp.setup({
  mapping = {
    ['<C>n'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C>p'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C>q'] = cmp.mapping.close(),
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
      keyword_length = 3,
    },
    {
      name = 'cmp_tabnine',
      keyword_length = 2,
    },
    {
      name = 'buffer',
      keyword_length = 3,
    },
  }),
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- The following example advertise capabilities to `clangd`.
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
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
    snip("function",
    {
      insert(1, "void"),
      text(" "),
      insert(2, "name"),
      text("("),
      insert(3, "params"),
      text({ ")", "{", "  "}),
      insert(0),
      text({ "", "}" }),
    }
    ),
    snip("for",
    {
      text("for("),
      insert(1, "unsigned"),
      text(" "),
      insert(2, "i"),
      text(" = "),
      insert(3, "0"),
      text("; "),
      func(copy, 2),
      text(" "),
      insert(4, "<"),
      text(" "),
      insert(5),
      text("; "),
      insert(6),
      text("++"),
      func(copy, 2),
      text({") {", "  "}),
      insert(0),
      text({"", "}"}),
    }
    ),
    snip("if",
    {
      text("if("),
      insert(1),
      text({") {", "  "}),
      insert(0),
      text({"", "}"}),
    }
    ),
    snip("while",
    {
      text("while("),
      insert(1),
      text({") {", "  "}),
      insert(0),
      text({"", "}"}),
    }
    ),
    snip("do",
    {
      text({"do {", "  "}),
      insert(0),
      text({"", "} while("}),
      insert(1),
      text(");"),
    }
    ),
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
keymap('i', '<Esc>n', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' :''", {expr = true, noremap = true})
keymap('i', '<Esc>p', "<cmd>lua require'luasnip'.jump(-1)<Cr>", {expr = false, noremap = true})
keymap('s', '<Esc>n', "<cmd>lua require'luasnip'.jump(1)<Cr>", {expr = false, noremap = true})
keymap('s', '<Esc>p', "<cmd>lua require'luasnip'.jump(-1)<Cr>", {expr = false, noremap = true})
keymap('i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' :'<Tab>'", {expr = true, noremap = true})
keymap('i', '<S-Tab>', "<cmd>lua require'luasnip'.jump(-1)<Cr>", {expr = false, noremap = true})
keymap('s', '<Tab>', "<cmd>lua require'luasnip'.jump(1)<Cr>", {expr = false, noremap = true})
keymap('s', '<S-Tab>', "<cmd>lua require'luasnip'.jump(-1)<Cr>", {expr = false, noremap = true})
-- }}}

-- Lsp {{{
if(os.execute("bash -c 'command -v clangd'") == 0) then
  require'lspconfig'.clangd.setup{}
end

keymap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>ln', '<cmd>lua vim.diagnostic.goto_next()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {expr = false, noremap = true})
keymap('n', '<Leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {expr = false, noremap = true})

-- }}}
