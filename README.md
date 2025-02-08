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
