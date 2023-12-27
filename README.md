# RustyWind-nvim

Automatically sort Tailwind CSS classes upon saving in Neovim with RustyWind-nvim. This integration brings the functionality of the Rustywind CLI into your Neovim environment, eliminating the need for manual CLI commands to format Tailwind classes.

## Features

Automatic Formatting on Save: Automatically formats Tailwind classes when saving files.
Manual Formatting Commands: Manually trigger formatting of Tailwind classes in your files.
Supports Multiple File Types: Works with .html, .js, .jsx, .ts, .tsx, .vue, and more.

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
- Autoformat Enable: `:RW autoformatEnable` - Enables autoformatting on save
- Autoformat Disable: `:RW autoformatDisable` - Disables autoformatting on save

License
MIT License
