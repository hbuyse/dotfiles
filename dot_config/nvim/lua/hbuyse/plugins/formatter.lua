return {
  {
    -- formatter
    'mhartington/formatter.nvim',
    -- not using opts or you will have installation problems
    opts = function()
      local has_formatter, _ = pcall(require, 'formatter')
      if not has_formatter then
        return {}
      end

      return {
        filetype = {
          json = {
            require('formatter.filetypes.json').jq,
          },
          lua = {
            require('formatter.filetypes.lua').stylua,
          },
          python = {
            require('formatter.filetypes.python').isort,
            require('formatter.filetypes.python').black,
          },
          rust = {
            require('formatter.filetypes.rust').rustfmt,
          },
          sh = {
            require('formatter.filetypes.sh').shfmt,
          },
          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      }
    end,
    init = function()
      -- Trim whitespace
      local format_gid = vim.api.nvim_create_augroup('FormatAutogroup', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = format_gid,
        desc = 'Format code and trim whitespaces',
        callback = function()
          -- Do not remove whitespaces if we are in git diff
          for _, v in ipairs({ 'diff' }) do
            if vim.bo.filetype == v then
              return
            end
          end

          vim.api.nvim_command('FormatWrite')
        end,
      })

      local has_notify, notify = pcall(require, 'notify')
      if has_notify then
        vim.api.nvim_create_autocmd('User', {
          pattern = 'FormatterPost',
          group = format_gid,
          desc = 'Post format hook',
          callback = function()
            notify('File formatted', nil, { title = 'formatter.nvim' })
          end,
        })
      end
    end,
  },
}
