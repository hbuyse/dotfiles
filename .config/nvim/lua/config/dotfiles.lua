local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  return nil
end

local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local utils = require('telescope.utils')

local conf = require('telescope.config').values

local M = {}

M.search_dotfiles = function(opts)
  if opts.cwd == nil then
    opts.cwd = vim.env.HOME
  end

  local show_untracked = utils.get_default(opts.show_untracked, false)
  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  if show_untracked and recurse_submodules then
    error('Git does not suppurt both --others and --recurse-submodules')
  end

  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = 'Dotfiles',
    finder = finders.new_oneshot_job(
      vim.tbl_flatten({
        'git',
        '--git-dir=' .. vim.env.HOME .. '/.dotfiles.git',
        '--work-tree=' .. vim.env.HOME,
        'ls-files',
        '--exclude-standard',
        '--cached',
        show_untracked and '--others' or nil,
        recurse_submodules and '--recurse-submodules' or nil,
      }),
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return M
-- vim: set ts=2 sw=2 tw=0 noet ft=lua :
