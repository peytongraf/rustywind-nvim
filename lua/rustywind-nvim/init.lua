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

-- Function to execute a RustyWind command and display output in a window or message
local function execute_rustywind_command(cmd, show_output)

  local result = vim.fn.system(cmd)
   if not show_output then
    print(result)
   end

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln(result)
  else if show_output then

    local height = 8

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))

    local win_id = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      title = 'Rustywind-nvim',
      title_pos = 'left',
      row = math.floor(((vim.o.lines - height) / 2) - 1),
      col = math.floor((vim.o.lines - height) / 2),
      width = 70,
      height = height,
      style = 'minimal',
      border = 'rounded',
    })

    -- Set up key mapping for closing the window
    vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<cmd>lua vim.api.nvim_win_close('..win_id..', true)<CR>', { noremap = true, silent = true })
     end
  end
end

-- Table of RustyWind commands
local rustywind_commands = {
format = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" or current_file == nil then
        print("Rustywind: No file name associated with the current buffer.")
        return
    end
    execute_rustywind_command('rustywind --write ' .. current_file, false)
end,
   autoformatEnable = function()
    M.opts.auto_sort_on_save = true
    print("Rustywind autoformat enabled")
   end,
   autoformatDisable = function()
    M.opts.auto_sort_on_save = false
    print("Rustywind autoformat disabled")
   end,
}

-- Main Rustywind command with subcommand completion
vim.api.nvim_create_user_command('RW', function(args)
  local subcommand = args.args:match("^(%S+)")
  if rustywind_commands[subcommand] then
    rustywind_commands[subcommand](args)
  else
    print("Invalid subcommand: " .. subcommand)
  end
end, {
  nargs = 1,
  complete = function(arglead, cmdline, cursorpos)
    local completions = {}
    for key, _ in pairs(rustywind_commands) do
      table.insert(completions, key)
    end
    return completions
  end,
})

-- Auto-save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = {"*.html", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte"},
  callback = function()
  if M.opts.auto_sort_on_save then
      vim.api.nvim_set_option('autoread', true)
      rustywind_commands.format()
      vim.cmd("edit!")
      vim.cmd("redraw!")
  end
end,
})

return M
