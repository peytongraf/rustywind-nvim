-- Default options
local default_options = {
  auto_sort_on_save = true
}

local opts = {}

local function setup(user_options)
  opts = vim.tbl_extend('force', default_options, user_options or {})
end


-- Function to execute a RustyWind command and display output
local function execute_rustywind_command(cmd)
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln(result)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = 80,
      height = 20,
      row = 10,
      col = 10,
      style = 'minimal',
      border = 'rounded',
    })
  end
end

-- Table of RustyWind commands
local rustywind_commands = {
  run = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind ' .. current_file)
  end,
  write = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --write ' .. current_file)
  end,
  dryrun = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --dry-run ' .. current_file)
  end,
  stdin = function()
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    execute_rustywind_command('echo "' .. content .. '" | rustywind --stdin')
  end,
  checkformatted = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --check-formatted ' .. current_file)
  end,
  config = function(args)
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --config-file ' .. args.args .. ' ' .. current_file)
  end,
}

-- Auto-save
 vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.html', '*.js', '*.vue', '*.jsx', '*.tsx', '*.ts'}, -- specify your file types
  callback = function()
    if opts.auto_sort_on_save then
      rustywind_commands.write()
    end
  end,
})

-- Main Rustywind command with subcommand completion
vim.api.nvim_create_user_command('Rustywind', function(args)
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

return {
  setup = setup,
}
