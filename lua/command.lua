---@type table
local M = {}
---@type table
M.default_config = {
  ---@type string
  prompt = "$ ",
  ---@type string
  open_with = "terminal",
  ---@type string
  commands_file = vim.fn.stdpath("data") .. "/command.nvim/commands.lua",
  overrides_file = vim.fn.stdpath("data") .. "/command.nvim/overrides.lua",
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
}
---@type table
Commands = {}
---@type table
Overrides = {}

-- saves a key value pair table of the directories
-- and their respective commands
function M.save_commands()
  os.execute("mkdir -p " .. vim.fs.dirname(M.config.commands_file))
  os.execute("mkdir -p " .. vim.fs.dirname(M.config.overrides_file))
  local file, err = io.open(M.config.commands_file, "w")

  if file then
    file:write("Commands = " .. vim.inspect(Commands))
    file:close()
  else
    error("Error opening file: " .. err)
  end
end

-- executes a command according to your current working directory on the
-- `commands` table
function M.command()
  pcall(dofile, M.config.commands_file)
  pcall(dofile, M.config.overrides_file)
  local cwd = vim.fn.getcwd()
  local command
  local open

  if type(Overrides[cwd]) ~= "nil" then
    command = Overrides[cwd]
  elseif type(Commands[cwd]) ~= "nil" then
    command = Commands[cwd]
  end

  if M.config.open_with == "float" then
    open = function(cmd)
      require("utils.utils").floating(cmd)
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

  vim.ui.input({ prompt = M.config.prompt, default = command }, function(input)
    command = input
    if command ~= nil then
      open(command)
      Commands[cwd] = command
    end
  end)
end

---@param config table|nil
function M.setup(config)
  if config == nil then
    M.config = M.default_config
  else
    vim.validate({ config = { config, "table", true } })
    M.config = vim.tbl_deep_extend("force", M.default_config, config or {})
  end

  local group = vim.api.nvim_create_augroup("command", {})
  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = { "*" },
    group = group,
    callback = M.save_commands,
  })
end

return M
