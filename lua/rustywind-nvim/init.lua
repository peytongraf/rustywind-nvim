local M = {}

local default_opts = {
	auto_sort_on_save = true,
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
		vim.api.nvim_echo({ { "Rustywind: No file name associated with the current buffer.", "ErrorMsg" } }, true, {})
		return
	end

	-- Shell-escape the filename
	local escaped_file = vim.fn.shellescape(current_file)
	local cmd = "rustywind --write " .. escaped_file

	-- Check timestamp before running rustywind
	local before = vim.fn.getftime(current_file)
	local result = vim.fn.system(cmd)
	local after = vim.fn.getftime(current_file)

	-- Print error messages if rustywind failed
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Rustywind error:\n", "ErrorMsg" },
			{ result or "", "ErrorMsg" },
		}, true, {})
		return
	end

	-- If no change occurred, do nothing
	if before == after then
		return false
	end

	return true
end

-- User commands
vim.api.nvim_create_user_command("RWEnable", function()
	M.opts.auto_sort_on_save = true
	print("Rustywind autoformat enabled")
end, {})

vim.api.nvim_create_user_command("RWDisable", function()
	M.opts.auto_sort_on_save = false
	print("Rustywind autoformat disabled")
end, {})

-- Autosave hook
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		if M.opts.auto_sort_on_save then
			local view = vim.fn.winsaveview()

			local changed = rustywind_format()
			if changed then
				-- Only reload if the file was actually modified
				vim.cmd("edit")
			end

			vim.fn.winrestview(view)
		end
	end,
})

return M
