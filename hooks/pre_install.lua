--- Returns version information for installation
--- @param ctx table Context provided by vfox (contains version)
--- @return table Version info
function PLUGIN:PreInstall(ctx)
    local version = ctx.version

    if version == nil or version == "" then
        error("You must provide a version number, eg: vfox install bashly@1.2.0")
    end

    -- No download URL needed - we install via bundler
    return {
        version = version,
    }
end
