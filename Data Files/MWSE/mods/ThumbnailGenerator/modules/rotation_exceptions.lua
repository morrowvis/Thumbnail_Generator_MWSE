
local this = {}

local exceptions = {}
this.exceptions = exceptions

this.luaModKey = "ThumbnailGenerator"
this.metadataKey = "Thumbnail Generator"

function this.addEntry(rotation, path)
    local norm = path:gsub("\\", "/"):lower()
    norm = norm:match("^%s*(.-)%s*$")
    norm = norm:gsub("%.[nN][iI][fF]$", "")
    norm = norm:gsub("/+", "/"):gsub("^/+", ""):gsub("/+$", "")

    local dir, file
    local lastSlash = nil
    for i = #norm, 1, -1 do
        if norm:sub(i, i) == "/" then
            lastSlash = i
            break
        end
    end
    if lastSlash then
        dir = norm:sub(1, lastSlash - 1)
        file = norm:sub(lastSlash + 1)
    else
        dir = ""
        file = norm
    end

    table.insert(exceptions, { dir = dir, file = file, rotation = rotation })
end


-- Groups live in the mod's metadata file; array-of-tables order is kept so later entries still win.
function this.loadFromMetadata()
    local metadata = tes3.getLuaModMetadata(this.luaModKey) or toml.loadMetadata(this.metadataKey)
    local groups = metadata and metadata.tools and metadata.tools["thumbnail-generator"]
    if type(groups) ~= "table" then
        return false
    end

    for i = #exceptions, 1, -1 do
        table.remove(exceptions, i)
    end

    for _, group in ipairs(groups) do
        local rotation = tonumber(group.rotate)
        if rotation and type(group.meshes) == "table" then
            for _, path in ipairs(group.meshes) do
                this.addEntry(rotation, path)
            end
        end
    end

    return true
end


function this.match(normalizedMeshPath)
    if not normalizedMeshPath or normalizedMeshPath == "" then return nil end

    local dir, file
    local lastSlash = nil
    for i = #normalizedMeshPath, 1, -1 do
        if normalizedMeshPath:sub(i, i) == "/" then
            lastSlash = i
            break
        end
    end
    if lastSlash then
        dir = normalizedMeshPath:sub(1, lastSlash - 1)
        file = normalizedMeshPath:sub(lastSlash + 1)
    else
        dir = ""
        file = normalizedMeshPath
    end

    local best = nil
    for _, entry in ipairs(exceptions) do
        if entry.dir == dir and file:find(entry.file, 1, true) then
            best = entry
        end
    end

    if not best then return nil end
    return {
        rotation = best.rotation,
        dir = best.dir,
        file = best.file,
    }
end


if not this.loadFromMetadata() then
    mwse.log(string.format(
        "[Thumbnail Generator] rotation_exceptions.lua: no [[tools.thumbnail-generator]] rotation groups in '%s-metadata.toml' -- no rotation exceptions loaded.",
        this.metadataKey))
end


return this
