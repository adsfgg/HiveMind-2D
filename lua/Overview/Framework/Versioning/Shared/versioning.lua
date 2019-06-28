local Mod = GetMod()
local Versioning = {}

local majorVersion = 0
local minorVersion = 0
local patchVersion = 0
local preRelease

local function ValidateVersion(version, name)
    assert(math.floor(version) == version, "Version type must be integer.")
    assert(version >= 0, name .. " version number cannot be less than zero")
end

local function ValidatePreRelease(newPreRelease)
    if newPreRelease == nil then
        return-- we allow nil prereleases
    end
    assert(type(newPreRelease) == "string", "PreRelease must be of type string")
    assert(newPreRelease ~= "", "PreRelease cannot be empty")
end

function Versioning:GetMajorVersion()
    return majorVersion
end

function Versioning:SetMajorVersion(version)
    ValidateVersion(version, "Major")
    majorVersion = version
end

function Versioning:GetMinorVersion()
    return minorVersion
end

function Versioning:SetMinorVersion(version)
    ValidateVersion(version, "Minor")
    minorVersion = version
end

function Versioning:GetPatchVersion()
    return patchVersion
end

function Versioning:SetPatchVersion(version)
    ValidateVersion(version, "Patch")
    patchVersion = version
end

function Versioning:GetPreRelease()
    return preRelease
end

function Versioning:SetPreRelease(newPreRelease)
    ValidatePreRelease(newPreRelease)
    preRelease = newPreRelease
end

function Versioning:GetVersion()
    local formatString = "%s.%s.%s"

    local mav = self:GetMajorVersion()
    local miv = self:GetMinorVersion()
    local pv = self:GetPatchVersion()
    local pr = self:GetPreRelease()

    if pr then
        formatString = formatString .. "-" .. pr
    end

    return formatString:format(mav, miv, pv, pr)
end

function Versioning:GetFeedbackText()
    return string.format("(%s %s)", Mod:GetModName(), self:GetVersion())
end

function Versioning:SetVersion(major, minor, patch, pr)
    self:SetMajorVersion(major)
    self:SetMinorVersion(minor)
    self:SetPatchVersion(patch)
    self:SetPreRelease(pr)
end

function GetFrameworkModuleChanges()
    return "Versioning", Versioning
end
