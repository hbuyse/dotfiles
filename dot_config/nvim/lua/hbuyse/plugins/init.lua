return {
  {
    -- Smart and powerful comment
    'numToStr/Comment.nvim',
    config = true,
    keys = {
      { 'gcA', mode = { 'n', 'v' }, desc = 'Comment insert end of line' },
      { 'gcO', mode = { 'n', 'v' }, desc = 'Comment insert above' },
      { 'gco', mode = { 'n', 'v' }, desc = 'Comment insert below' },
      { 'gbc', mode = { 'n', 'v' }, desc = 'Comment toggle current block' },
      { 'gcc', mode = { 'n', 'v' }, desc = ' Comment toggle current line' },
      { 'gb', mode = { 'n', 'v' }, desc = 'Comment toggle blockwise' },
      { 'gc', mode = { 'n', 'v' }, desc = 'Comment toggle linewise' },
    },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
  },
  {
    -- Add/change/delete surrounding delimiter pairs with ease
    'kylechui/nvim-surround',
    config = true,
  },
  {
    -- Robot framework highlight
    'mfukar/robotframework-vim',
    ft = 'robot',
  },
}
