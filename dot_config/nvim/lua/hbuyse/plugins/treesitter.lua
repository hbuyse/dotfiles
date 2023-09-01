return {
  {
    -- Treesitter configurations and abstraction layer
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
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
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        -- Disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      lazy = false,
    },
    keys = function()
      local l = {
        { '<leader>th', vim.show_pos, desc = '[T]reesitter [H]ighlight' },
        { '<leader>tp', vim.treesitter.inspect_tree, desc = '[T]reesitter [P]layground' },
      }
      if not vim.version.lt(vim.version(), { 0, 10, 0 }) then
        table.insert(l, { '<leader>tq', '<cmd>PreviewQuery<CR>', desc = '[T]reesitter [Q]uery Editor' })
      end
      return l
    end,
  },
}
