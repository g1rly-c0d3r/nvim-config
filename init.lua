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
    'https://github.com/tiagovla/tokyodark.nvim.git',
	'https://github.com/stevearc/oil.nvim.git',
	'https://github.com/hrsh7th/nvim-cmp.git',
	'https://github.com/hrsh7th/cmp-nvim-lsp.git',
	'https://github.com/neovim/nvim-lspconfig.git',
	'https://github.com/hrsh7th/cmp-path.git',
    'https://github.com/fortran-lang/fortls.git',
    'https://github.com/nvim-treesitter/nvim-treesitter.git',
})

-- colorscheme
vim.cmd.colorscheme 'tokyodark'

-- oil
require("oil").setup()

-- treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "haskell", "fortran", "python", "bash"  },
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})
-- folding
vim.opt.foldmethod = indent
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
vim.lsp.config('clangd', {
    cmd = {'clangd'},
    capabilities = capabilities,
}
)
vim.lsp.config('bashls', { cmd={'bash-language-server', 'start'},
    capabilities = capabilities
})
vim.lsp.config('pyright', {
    cmd={'pyright-langserver',
         '--stdio'
     },
    capabilities = capabilities
})
vim.lsp.config('fortls', {
cmd = {
'fortls',
'--hover_signature',
'--hover_language=fortran',
'--use_signature_help'
},
capabilities = capabilities,
})

vim.lsp.config('hls', {
    cmd = { 'haskell-language-server' , 'lsp' },
    capabilities = capabilities,
})

vim.lsp.config('texlab', {
    cmd = { 'texlab', 'run' },
    capabilities = capabilities,
})


vim.lsp.enable('clangd')
vim.lsp.enable('bashls')
vim.lsp.enable('pyright')
vim.lsp.enable('fortls')
vim.lsp.enable('hls')
vim.lsp.enable('texlab')
