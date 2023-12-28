# RustyWind-nvim

Automatically sort Tailwind CSS classes upon saving in Neovim with RustyWind-nvim. This integration brings the functionality of the Rustywind CLI into your Neovim environment, eliminating the need for manual CLI commands to format Tailwind classes.

![rustywind](https://github.com/peytongraf/rustywind-nvim/assets/108034200/d31173c8-d5b6-4a93-89e7-d9e5a54c3e88)

## Demo

https://github.com/peytongraf/rustywind-nvim/assets/108034200/b6a1c45e-ea47-4d8e-aa3d-58d862a51d2e

## Requirements

First, install the RustyWind CLI https://github.com/avencera/rustywind

## Installation

Install using your package manager. Here I am using lazy.

```lua
  {
  "peytongraf/rustywind-nvim",
  ft = {
    -- add or remove filetypes in which the plugin should load for as needed
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

After installation, the plugin will automatically sort Tailwind CSS classes upon saving, provided that the filetype of the current buffer has been included in the ft = {} configuration. This ensures that the plugin activates only when opening files of the specified filetypes.

## Commands

- Autoformat Enable: `:RW autoformatEnable` - Enables autoformatting on save
- Autoformat Disable: `:RW autoformatDisable` - Disables autoformatting on save

License
MIT License
