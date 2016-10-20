-- util/env.lua
local availableEnvVars = require "generated.env_vars_available"

local ERRTXT__REQUIRED_ENV_UNDEFINED = "undefined required environment variable"

local function env(varName, defaultValue, isRequired)
    local value = availableEnvVars[varName];

    if value == nil then
        if defaultValue == nil and isRequired then
            error(ERRTXT__REQUIRED_ENV_UNDEFINED, 2)
        end
        return defaultValue
    end

    return value
end

return env;
