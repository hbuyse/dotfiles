return {
  {
    'stevearc/conform.nvim',
    opts = {
      -- Set the log level. Use `:ConformInfo` to see the location of the log file.
      log_level = vim.log.levels.ERROR,
      -- Conform will notify you when a formatter errors
      notify_on_error = true,
      formatters = {
        black = {
          prepend_args = { '--line-length', '120' },
        },
        shfmt = {
          prepend_args = { '-i', '4', '-sr', '-bn' },
        },
        prettier = {
          options = {
            -- Use a specific prettier parser for a filetype
            -- Otherwise, prettier will try to infer the parser from the file name
            ft_parsers = {
              -- javascript = "babel",
              -- javascriptreact = "babel",
              typescript = 'typescript',
              -- typescriptreact = "typescript",
              vue = 'vue',
              css = 'css',
              scss = 'scss',
              less = 'less',
              html = 'html',
              json = 'json',
              jsonc = 'json',
              yaml = 'yaml',
              markdown = 'markdown',
              -- ["markdown.mdx"] = "mdx",
              -- graphql = "graphql",
              -- handlebars = "glimmer",
            },
          },
        },
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        json = { 'prettier' },
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        css = { 'prettier' },
        yaml = { 'prettier' },
        html = { 'prettier' },
        jsonc = { 'prettier' },
        perl = { 'perltidy' },
        -- Use the "*" filetype to run formatters on all filetypes.
        ['*'] = { 'codespell' },
        -- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        ['_'] = { 'trim_whitespace' },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { 'diff' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        -- These options will be passed to conform.format()
        return {
          timeout_ms = 500,
          lsp_fallback = false,
        }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
  },
}
