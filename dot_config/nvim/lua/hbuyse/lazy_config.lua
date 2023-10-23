-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup('hbuyse.plugins', {
  defaults = {
    lazy = false,
    -- version = '*', -- try installing the latest stable versions of plugins
  },
})

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
