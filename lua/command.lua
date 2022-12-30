---@type table
local M = {}
---@type table
M.default_config = {
  ---@type string
  prompt = "command> ",
  ---@type string
  open_with = "terminal",
  ---@type string
  commands_file = vim.fn.stdpath("data") .. "/command.nvim/commands.lua",
  ---@type string
  overrides_file = vim.fn.stdpath("data") .. "/command.nvim/overrides.lua",
  ---@type table
  float = {
    ---@type string
    close_key = "<ESC>",
    --- Window border (see ':h nvim_open_win')
    ---@type string
    border = "none",
    --- Num from `0 - 1` for measurements
    ---@type number
    height = 0.8,
    ---@type number
    width = 0.8,
    ---@type number
    x = 0.5,
    ---@type number
    y = 0.5,
    --- Highlight group for floating window/border (see ':h winhl')
    ---@type string
    border_hl = "FloatBorder",
    ---@type string
    float_hl = "Normal",
    --- Transparency (see ':h winblend')
    ---@type number
    blend = 0,
  },
}
---@type function
local open
---@type table
M.Commands = {}
---@type table
M.Overrides = {}

--- saves a key value pair table of the directories and their respective commands
function M.save_commands()
  local file, err = io.open(M.config.commands_file, "w")

  os.execute("mkdir -p " .. vim.fs.dirname(M.config.commands_file))

  if file then
    file:write([[require("command").Commands = ]] .. vim.inspect(M.Commands))
    file:close()
  else
    error("Error opening file: " .. err)
  end
end

--- executes a command according to your current working directory on the `commands` table
function M.command()
  local cwd = vim.fn.getcwd()

  local function prompt(command)
    vim.ui.input(
      { prompt = M.config.prompt, default = command },
      function(input)
        command = input
        if command ~= nil then
          open(command)

          if M.Commands[cwd] == nil then
            M.Commands[cwd] = { command }
          elseif not vim.tbl_contains(M.Commands[cwd], command) then
            table.insert(M.Commands[cwd], 1, command)
          end
        end
      end
    )
  end

  if type(M.Overrides[cwd]) == "table" then
    if #M.Overrides[cwd] == 1 then
      prompt(M.Overrides[cwd][1])
    else
      vim.ui.select(
        M.Overrides[cwd],
        { prompt = "Select a command:" },
        function(choice)
          prompt(choice)
        end
      )
    end
  elseif type(M.Commands[cwd]) == "table" then
    if #M.Commands[cwd] == 1 then
      prompt(M.Commands[cwd][1])
    else
      vim.ui.select(
        M.Commands[cwd],
        { prompt = "Select a command:" },
        function(choice)
          prompt(choice)
        end
      )
    end
  else
    prompt()
  end
end

---@param config table|nil
function M.setup(config)
  if config == nil then
    M.config = M.default_config
  else
    vim.validate({ config = { config, "table", true } })
    M.config = vim.tbl_deep_extend("force", M.default_config, config or {})
  end

  pcall(dofile, M.config.commands_file)
  pcall(dofile, M.config.overrides_file)

  if M.config.open_with == "float" then
    open = function(cmd)
      require("command.utils").floating(cmd)
    end
  elseif M.config.open_with == "message" then
    open = function(cmd)
      vim.cmd(":!" .. cmd)
    end
  else
    open = function(cmd)
      vim.cmd(":terminal " .. cmd)
    end
  end

  local group = vim.api.nvim_create_augroup("command", {})
  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = { "*" },
    group = group,
    callback = M.save_commands,
  })
end

return M
