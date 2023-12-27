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

vim-plug:

```vim
Plug 'peytongraf/rustywind-nvim'
```

packer.nvim:

```lua
use 'peytongraf/rustywind-nvim'
```

## **Usage**

After installation, the plugin provides several commands for sorting Tailwind classes.

- Format Current File: `:RW format` - Formats the Tailwind classes in the current file.
- Dry Run: `:RW dryrun` - Shows the changes that would be made without applying them.
- Check Formatted: `:RW checkformatted` - Checks if the file is already formatted.
-

## **Configuration**

You can configure the plugin by calling the setup function in your Neovim configuration file:

```lua
require('rustywind-nvim').setup({
    -- Your configuration options here
})
```

License
MIT License
