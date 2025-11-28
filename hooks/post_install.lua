--- Installs bashly via bundler
--- @param ctx table Context provided by vfox
function PLUGIN:PostInstall(ctx)
    local cmd = require("cmd")

    local sdkInfo = ctx.sdkInfo["bashly"]
    local path = sdkInfo.path
    local version = sdkInfo.version

    -- Get the inherited PATH from the environment
    local inheritedPath = os.getenv("PATH") or ""

    -- Create directories
    cmd.exec("mkdir -p '" .. path .. "/gem' '" .. path .. "/artifacts' '" .. path .. "/bin'")

    -- Set up gem environment variables with inherited PATH
    local gemHome = path .. "/gem"
    local gemEnv = "GEM_HOME='" .. gemHome .. "' GEM_PATH='" .. gemHome .. "' PATH='" .. gemHome .. "/bin:" .. inheritedPath .. "'"

    -- Ensure bundler is installed
    cmd.exec(gemEnv .. " gem install bundler --no-document")

    -- Initialize bundle in the install directory
    cmd.exec("cd '" .. path .. "' && " .. gemEnv .. " bundle init")

    -- Configure bundle to use local artifacts directory
    cmd.exec("cd '" .. path .. "' && " .. gemEnv .. " bundle config set --local path artifacts")

    -- Add bashly with specific version
    cmd.exec("cd '" .. path .. "' && " .. gemEnv .. " bundle add bashly --version '= " .. version .. "'")

    -- Add dependencies to avoid runtime warnings (Ruby stdlib gems being extracted)
    local addDepsResult = pcall(function()
        cmd.exec("cd '" .. path .. "' && " .. gemEnv .. " bundle add fiddle 2>/dev/null || true")
    end)
    local addLoggerResult = pcall(function()
        cmd.exec("cd '" .. path .. "' && " .. gemEnv .. " bundle add logger 2>/dev/null || true")
    end)

    -- Create wrapper script
    local wrapperContent = [[#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
install_dir="$(dirname "${script_dir}")"
gem_home="${install_dir}/gem"

PATH="${gem_home}/bin:${PATH}" \
    BUNDLE_GEMFILE="${install_dir}/Gemfile" \
    BUNDLE_PATH="${install_dir}/artifacts" \
    GEM_HOME="${gem_home}" \
    GEM_PATH="${gem_home}" \
    bundle exec bashly "${@}"
]]

    -- Write wrapper script
    local wrapperPath = path .. "/bin/bashly"
    local file = io.open(wrapperPath, "w")
    if file then
        file:write(wrapperContent)
        file:close()
        cmd.exec("chmod +x '" .. wrapperPath .. "'")
    else
        error("Failed to create wrapper script")
    end
end
