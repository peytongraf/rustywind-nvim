 local M = {}
--
-- Default options
local default_options = {
  auto_sort_on_save = true
}
--
function M.setup(user_options)
  user_options = user_options or {}
  for key, value in pairs(default_options) do
    if user_options[key] == nil then
      user_options[key] = value
    end
  end
  M.options = user_options
end

-- Function to execute a RustyWind command and display output
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
      width = 69,
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
     --print("Formatting...")
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" or current_file == nil then
        print("No file name associated with the current buffer.")
        return
    end

    -- Get the file's last modification time before running the command
    local initial_mod_time = vim.fn.getftime(current_file)

    execute_rustywind_command('rustywind --write ' .. current_file)

    local function run_periodically()
        local counter = 0
        local start_time = os.clock()

        local function periodically()
            if counter >= 10 or os.clock() - start_time > 10 then  -- Stop after 10 seconds or 10 iterations
                print("Stopped checking for file update.")
                return
            end

            local current_mod_time = vim.fn.getftime(current_file)
            if current_mod_time > initial_mod_time then
                vim.cmd('edit ' .. vim.fn.fnameescape(current_file))
                print("File updated and buffer reloaded.")
                return
            else
                counter = counter + 1
                vim.defer_fn(periodically, 1000)
                print("Checking for file update...")
            end
        end

        periodically()
    end

    run_periodically()
end,
  run = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind ' .. current_file, false)
  end,
  dryrun = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --dry-run ' .. current_file, true)
  end,
  stdin = function()
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    execute_rustywind_command('echo "' .. content .. '" | rustywind --stdin', true)
  end,
  checkformatted = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --check-formatted ' .. current_file, true)
  end,
  config = function(args)
    local current_file = vim.api.nvim_buf_get_name(0)
    execute_rustywind_command('rustywind --config-file ' .. args.args .. ' ' .. current_file, true)
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
 -- BufWritePost is triggered after the current buffer is written to file
vim.api.nvim_create_autocmd('BufWritePost', {
    --pattern = "*",
    pattern = {"*.html", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte"},
    callback = function()
    --print("Auto-formatting on save...")
    vim.defer_fn(function()
     rustywind_commands.format()
     end, 500)
    end,
})

-- Auto-reload on file change
--  vim.api.nvim_create_autocmd("FileChangedShellPost", {
--     pattern = "*",
--     callback = function()
--         print("File changed on disk. Reloading...")
--         vim.cmd("edit!")
--     end,
-- })


return M
