--- Returns all available versions of bashly from RubyGems
--- @param ctx table Context provided by vfox
--- @return table Available versions
function PLUGIN:Available(ctx)
    local http = require("http")
    local json = require("json")

    local result = {}

    local resp, err = http.get({
        url = "https://rubygems.org/api/v1/versions/bashly.json",
        headers = {
            ["Accept"] = "application/json",
        }
    })

    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end

    if resp.status_code ~= 200 then
        error("Failed to fetch versions, status: " .. resp.status_code)
    end

    local versions = json.decode(resp.body)
    if versions == nil then
        return result
    end

    for _, v in ipairs(versions) do
        -- Only include release versions (not prereleases)
        if v.number and not v.prerelease then
            table.insert(result, {
                version = v.number,
            })
        end
    end

    return result
end
