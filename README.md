# package-versions.nvim

A simple plugin to show the versions of the packages in your `package.json` file.
This plugin for personal use, but if you find it useful, feel free to use it.
In case you want more features, you might want to take a look at [package-info.nvim](https://github.com/vuki656/package-info.nvim).

## Motivation

I just wanted a simple way to see the latest versions of my npm packages in my `package.json` file.
Maybe I will add more features in the future, but for now, this is enough for me.

## Installation

- Using [lazy.vim](https://github.com/folke/lazy.nvim)
```lua
return {
  'MerryChaos/package-versions.nvim',
  config = function()
    require('package-versions').setup()
  end
}
```

## Configuration

You can configure the plugin by calling the `setup` function with a table as an argument.
```lua
require('package-versions').setup({ ... })
```


Here is the configuration with the default values:

```lua
{
    -- Highlight groups to use
    highlights = {
        ok = "Comment", -- Highlight group for up-to-date packages
        warning = "WarningMsg", -- Highlight group for outdated packages
        error = "ErrorMsg", -- Highlight group for packages with errors
    },

    -- When to update the package version info
    autocmds = {
        "BufReadPost",
        "BufWritePost",
    },
}
