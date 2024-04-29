return {
  {
    'stevearc/conform.nvim',
    opts = {
      -- Set the log level. Use `:ConformInfo` to see the location of the log file.
      log_level = vim.log.levels.ERROR,
      -- Conform will notify you when a formatter errors
      notify_on_error = true,
      formatters = {
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
          lsp_fallback = false,
        }
      end,
    },
  },
}
