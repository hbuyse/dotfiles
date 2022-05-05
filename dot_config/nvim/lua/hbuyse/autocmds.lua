local has_packer, packer = pcall(require, 'packer')

if has_packer then
  -- Automatically compile packer when writing files in $HOME/.config/nvim
  local packer_gid = vim.api.nvim_create_augroup('packer', {})
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = packer_gid,
    desc = 'Automatic compilation of Neovim plugins',
    pattern = '*.lua',
    callback = function(data)
      local nvim_configdir = os.getenv('HOME') .. '/.config/nvim'
      if string.match(data.match, nvim_configdir) then
        packer.compile()
      end
    end,
  })
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
