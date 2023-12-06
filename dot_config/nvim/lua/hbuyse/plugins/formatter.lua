return {
  {
    'stevearc/conform.nvim',
    opts = {
      -- Set the log level. Use `:ConformInfo` to see the location of the log file.
      log_level = vim.log.levels.ERROR,
      -- Conform will notify you when a formatter errors
      notify_on_error = true,
      formatters_by_ft = {
        c = { 'clang-format' },
        json = { 'jq' },
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        -- Use the "*" filetype to run formatters on all filetypes.
        ['*'] = { 'codespell' },
        -- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        ['_'] = { 'trim_whitespace' },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { 'diff' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        -- These options will be passed to conform.format()
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    },
    init = function()
      -- Format on save
      local format_gid = vim.api.nvim_create_augroup('FormatAutogroup', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        group = format_gid,
        callback = function(args)
          require('conform').format({ bufnr = args.buf })
        end,
      })

      -- Old notify hook
      -- local has_notify, notify = pcall(require, 'notify')
      -- if has_notify then
      --   vim.api.nvim_create_autocmd('User', {
      --     pattern = 'FormatterPost',
      --     group = format_gid,
      --     desc = 'Post format hook',
      --     callback = function()
      --       notify('File formatted', nil, { title = 'formatter.nvim' })
      --     end,
      --   })
      -- end
    end,
  },
}
