-- util/env.lua
local availableEnvVars = require "generated.env_vars_available"

local function env(varName, defaultValue)
    return availableEnvVars[varName] or defaultValue
end

return env;
