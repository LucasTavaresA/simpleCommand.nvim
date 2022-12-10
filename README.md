# command.nvim

Simple command runner that prompts you for a command based on neovim cwd and saves a lua
table, like `{ ["/example/folder/"] = "command" }`, to a file

## Installation

**You need to use the setup() function to load this plugin**

[packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use {
  'lucastavaresa/command.nvim',
  config = function()
    require("command").setup()
  end
}
```

## Usage

```lua
vks("n", "<leader>c", function()
  require("command").command()
end)
```

## Customization

Default config:
```lua
require("command").setup({
  prompt = "$ ",
  -- you can open with: "float", "message", "terminal"
  open_with = "terminal",
  -- file where commands and overrides are saved.
  commands_file = vim.fn.stdpath("data") .. "/commands.lua",
  -- only works when `open_with` is set to "float"
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
})
```

## Overrides [WIP]

You can add overrides in the `Overrides` array inside of the `commands_file` and
those commands will always get prompted
