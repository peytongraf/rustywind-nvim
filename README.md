# RustyWind-nvim

Automatically sort tailwind css classes on save from with neovim. Rustywind-nvim integrates the RustyWind CLI tool allowing you to also run Rustywind CLI commands as neovim commands.

## Features

Automatic Formatting on Save: Automatically formats Tailwind classes when saving files.
Manual Formatting Commands: Manually trigger formatting of Tailwind classes in your files.
Supports Multiple File Types: Works with .html, .js, .jsx, .ts, .tsx, .vue, and more.
Installation
To install the RustyWind Neovim plugin, use your favorite plugin manager.

## **Requirements**

First, install the RustyWind CLI https://github.com/avencera/rustywind

## **Usage**

Install using your package manager. Here I am using lazy.

```lua
  {
  "peytongraf/rustywind-nvim",
  ft = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    },
  config = function()
    require("rustywind-nvim").setup({
      -- add the following line to initially disable autoformatting on save
      -- auto_sort_on_save = false
    })
  end
  },

```

## Usage

After installation, the plugin will automatically sort Tailwind CSS classes upon saving, provided that the filetype of the current buffer has been included in the ft = {} configuration. This ensures that the plugin activates only when opening files of the specified filetypes.

### Commands

- Format Current File: `:RW format` - Formats the Tailwind classes in the current file.
- Check Formatted: `:RW checkformatted` - Checks if the file is already formatted.
- Autoformat Enable: `:RW autoformatEnable` - Enables autoformatting on save
- Autoformat Disable: `:RW autoformatDisable` - Disables autoformatting on save

License
MIT License
