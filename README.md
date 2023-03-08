# simpleCommand.nvim

Simple command runner that prompts you for a command based on neovim cwd and save a lua
table to a file

## Installation

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
-- executes with ":! <command>"
vim.keymap.set("n", "<leader>c", require("simpleCommand").command)
-- executes in a fullscreen terminal
vim.keymap.set("n", "<leader>c", function()
  require("simpleCommand").command(":edit term://")
end)
-- executes in a terminal split
vim.keymap.set("n", "<leader>c", function()
  require("simpleCommand").command(":split term://")
end)
-- executes in a vertical terminal split
vim.keymap.set("n", "<leader>c", function()
  require("simpleCommand").command(":vsplit term://")
end)
-- executes in a floating window
vim.keymap.set("n", "<leader>c", function()
  require("simpleCommand").command("float")
end)
```

## Customization

Default config:

```lua
require("simpleCommand").setup({
  prompt = "command> ",
  -- file where commands are saved.
  commands_file = vim.fn.stdpath("data") .. "/simpleCommand.nvim/commands.lua",
})
```

### floating window

Options to customize the floating window

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
