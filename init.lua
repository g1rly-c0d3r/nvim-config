-- general options
vim.opt.number = true
vim.opt.relativenumber = true

-- TODO: find a way to get this to change based on file ext
-- so it will wrap for .typ and .tex files, but nothing else.
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false

vim.pack.add({
    'https://github.com/tinted-theming/tinted-vim.git',
	'https://github.com/stevearc/oil.nvim.git',
	'https://github.com/hrsh7th/nvim-cmp.git',
	'https://github.com/hrsh7th/cmp-nvim-lsp.git',
	'https://github.com/neovim/nvim-lspconfig.git',
	'https://github.com/hrsh7th/cmp-path.git',
})

-- colorscheme
vim.cmd.colorscheme 'base16-irblack'


-- oil
require("oil").setup()

-- nvim-cmp
local cmp = require'cmp' cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
	 vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
  end,
},
window = {
   completion = cmp.config.window.bordered(),
   documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
}, {
  { name = 'buffer' },
})
})

-- cmp path completion
require'cmp'.setup {
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        {
        name = 'path',
        option = {
            pathMappings = {
                ['@'] = '${folder}/src',
                -- ['/'] = '${folder}/src/public/',
                -- ['~@'] = '${folder}/src',
                -- ['/images'] = '${folder}/src/images',
                -- ['/components'] = '${folder}/src/components',
            },
        },
        },
        { name = 'buffer' },
        { name = 'luasnip' },
    }),
}


-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['rust_analyzer'].setup {
capabilities = capabilities
}
require('lspconfig')['clangd'].setup {
capabilities = capabilities
}
require('lspconfig')['bashls'].setup {
capabilities = capabilities
}
require('lspconfig')['tinymist'].setup {
capabilities = capabilities
}
require('lspconfig')['texlab'].setup {
capabilities = capabilities
}
require('lspconfig')['pyright'].setup {
capabilities = capabilities
}
require'lspconfig'.fortls.setup{
capabilities = capabilities,
cmd = {
'fortls',
'--lowercase_intrinsics',
'--hover_signature',
'--hover_language=fortran',
'--use_signature_help'
}
}


