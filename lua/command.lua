---@type table
local M = {}
---@type table
M.default_config = {
  ---@type string
  prompt = "$ ",
  ---@type string
  open_with = "terminal",
  ---@type string
  commands_file = vim.fn.stdpath("data") .. "/commands.lua",
}
---@type table
Commands = {}
---@type table
Overrides = {}

-- saves a key value pair table of the directories
-- and their respective commands
function M.save_commands()
  local file, err = io.open(M.config.commands_file, "w")

  if file then
    file:write(
      "Commands = "
        .. vim.inspect(Commands)
        .. "\nOverrides = "
        .. vim.inspect(Overrides)
    )
    file:close()
  else
    error("Error opening file: " .. err)
  end
end

-- executes a command according to your current working directory on the
-- `commands` table
function M.command()
  local cwd = vim.fn.getcwd()
  local command
  local open

  if type(Overrides[cwd]) ~= "nil" then
    command = Overrides[cwd]
  elseif type(Commands[cwd]) ~= "nil" then
    command = Commands[cwd]
  end

  if M.config.open_with == "message" then
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

  pcall(dofile, M.config.commands_file)

  local group = vim.api.nvim_create_augroup("command", {})
  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = { "*" },
    group = group,
    callback = M.save_commands,
  })
end

return M
