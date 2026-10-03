local constants = require("ThumbnailGenerator.constants")

-- All object categories enabled by default.
local enabledTypes = {}
for _, meta in ipairs(constants.typeMetadata) do
    enabledTypes[meta.key] = true
end

local config = {

    -- =============================================================================
    -- GENERAL
    -- =============================================================================

    outputFolder = "Thumbnail Generator",
    flaggedMeshesFile = "flagged_meshes.toml",
    useSavedConfig = false,

    resolutionOptions = { 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384 },

    -- =============================================================================
    -- CAMERA
    -- =============================================================================

    globalRotation = 0,
    forceOrtho = true,
    fitToFrame = true,

    -- Draw every subject double-sided instead of only rescuing renders that come
    -- out empty. Costs nothing on well-built meshes, but open-backed geometry
    -- (capes, tent interiors) shows faces the artist meant to be culled.
    forceDoubleSided = false,

    orthoDistanceFactor = 200, -- higher = flatter
    perspectiveDistanceFactor = 8, -- lower = wider-angle look

    -- Base view per category, MW world axes (+X east, +Y north, +Z up);
    -- unlisted types use "standard".
    viewDirections = {
        bodypart = { 0, -1, 0 },
        creature = { -1, 1, 1 },
        hair     = { 1, -1, 1 },
        npc      = { 0, 1, 0 },
        standard = { 1, -1, 1 },
    },

    -- =============================================================================
    -- BATCH
    -- =============================================================================

    enabledTypes = enabledTypes,
    renderResolution = 2048,
    outputResolution = 1024,
    outputFormat = "png", -- "png", "tga" or "dds"

    skipEmptyRenders = true,
    skipExistingThumbnails = true,
    renderOnlyRotationExceptions = false,

    npcFiltering = true,
    npcRequireRespawn = true,
    npcIncludePattern = "outfit", -- ids containing this always pass (empty to disable)

    writeLogs = true,

    -- =============================================================================
    -- PREVIEW
    -- =============================================================================

    previewRenderResolution = 2048,
    previewOutputResolution = 1024,
    previewOutputFormat = "png",
    panSpeed = 0.75, -- subject radii per second

    -- Config-only (no MCM)
    previewForceVertexLighting = false,
    previewDollyFit = false,

    -- =============================================================================
    -- PROFILES
    -- =============================================================================

    useProfiles = true,

    -- =============================================================================
    -- RENDER DEFAULTS
    -- =============================================================================

    yaw = 0,
    pitch = 0,
    roll = 0,
    zoom = 1.0,
    panX = 0,
    panY = 0,
    ortho = true,
    lodAdjust = 0.001,
    particlePrimeTime = 0, -- seconds of pre-simulation; 0 = capture live state

    keyDimmer = 1.2,
    keyX = -1.2,
    keyY = 1.2,
    keyZ = 2.0,
    fillDimmer = 0.7,
    ambientScale = 1.0,
    diffuseScale = 1.3,
}

return config
