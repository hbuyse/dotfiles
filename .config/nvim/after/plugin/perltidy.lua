-- Used to run perltidy automatically if in a perl file
--
-- Otherwise doesn't do anything.

if vim.fn.executable('perltidy') == 0 then
  return
end

vim.cmd([[
  augroup PerltidyAuto
    autocmd BufWritePre *.pl :lua require("formatters.perltidy").format()
    autocmd BufWritePre *.pm :lua require("formatters.perltidy").format()
  augroup END
]])
