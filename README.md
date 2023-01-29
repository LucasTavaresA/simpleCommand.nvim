# simpleCommand.nvim

Simple command runner that prompts you for a command based on neovim cwd and save a lua
table to a file

## Installation

**You need to use the setup() function to load this plugin**

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'lucastavaresa/simpleCommand.nvim',
  config = function()
    require("simpleCommand").setup()
  end
}
```

## Usage

```lua
vim.keymap.set("n", "<leader>c", require("simpleCommand").command)
```

## Customization

Default config:

```lua
require("simpleCommand").setup({
  prompt = "command> ",
  -- you can open with: "float", "message", "terminal"
  open_with = "terminal",
  -- file where commands are saved.
  commands_file = vim.fn.stdpath("data") .. "/simpleCommand.nvim/commands.lua",
})
```

### floating window

Options to customize the floating window when `open_with` is set to `float`

```lua
float = {
  close_key = "<ESC>",
  -- Window border (see ':h nvim_open_win')
  border = "none",
  -- Num from `0 - 1` for measurements
  height = 0.8,
  width = 0.8,
  x = 0.5,
  y = 0.5,
  -- Highlight group for floating window/border (see ':h winhl')
  border_hl = "FloatBorder",
  float_hl = "Normal",
  -- Transparency (see ':h winblend')
  blend = 0,
},
```

