return {
  {
    -- Treesitter configurations and abstraction layer
    -- Based on https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = {
      'BufReadPost', -- 'LazyFile',
      'BufNewFile', -- 'LazyFile',
      'BufWritePre', -- 'LazyFile',
      'VeryLazy',
    },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    opts_extend = { 'ensure_installed' },
    opts = {
      ensure_installed = {
        'arduino',
        'awk',
        'bash',
        'bibtex',
        'c',
        'cmake',
        'comment',
        'cpp',
        'css',
        'devicetree',
        'diff',
        'dockerfile',
        'func',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'html',
        'htmldjango',
        'http',
        'ini',
        'jq',
        'json',
        'json5',
        'latex',
        'llvm',
        'lua',
        'luadoc',
        'luap',
        'luau',
        'make',
        'markdown',
        'markdown_inline',
        'meson',
        'ninja',
        'nix',
        'passwd',
        'perl',
        'po',
        'proto',
        'puppet',
        'python',
        'query',
        'rst',
        'rust',
        'scheme',
        'scss',
        'sql',
        'toml',
        'twig',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        -- Disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = {
        enable = true,
      },
    },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
      { '<leader>th', vim.show_pos, desc = '[T]reesitter [H]ighlight' },
      { '<leader>tp', vim.treesitter.inspect_tree, desc = '[T]reesitter [P]layground' },
      { '<leader>tq', vim.treesitter.query.edit, desc = '[T]reesitter [Q]uery Editor' },
    },
  },
}
