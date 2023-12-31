local M = {}

local default_opts = {
  auto_sort_on_save = true
}

function M.setup(opts)
  opts = opts or {}
  for key, value in pairs(default_opts) do
    if opts[key] == nil then
      opts[key] = value
    end
  end
  M.opts = opts
end

local function rustywind_format()

  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" or current_file == nil then
      print("Rustywind: No file name associated with the current buffer.")
      return
  end

  local result = vim.fn.system('rustywind --write ' .. current_file)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Rustywind: ", result)
  end
end

-- RustyWind Autoformat Enable Command
vim.api.nvim_create_user_command('RWEnable', function()
  M.opts.auto_sort_on_save = true
  print("Rustywind autoformat enabled")
end, {})

-- RustyWind Autoformat Disable Command
vim.api.nvim_create_user_command('RWDisable', function()
  M.opts.auto_sort_on_save = false
  print("Rustywind autoformat disabled")
end, {})

-- Auto-save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = "*",
  callback = function()
    if M.opts.auto_sort_on_save then
      -- Save the view state
      local view = vim.fn.winsaveview()
      rustywind_format()
      -- Reload the buffer to reflect the changes
      vim.cmd("edit")
      -- Restore the view state
      vim.fn.winrestview(view)
    end
  end,
})

return M
