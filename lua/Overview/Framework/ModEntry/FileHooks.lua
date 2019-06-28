if not string.find(Script.CallStack(), "Main.lua") then
	local kModName = debug.getinfo(1, "S").source:gsub("@lua/", ""):gsub("/Framework/.*%.lua", "")

	Script.Load("lua/" .. kModName .. "/Framework/Framework.lua")

	local Mod = _G[kModName]

	Mod.Logger:PrintDebug("Setting up file hooks", "all")

	for i = 1, #Mod:GetModules() do
		local currentModule = Mod:GetModules()[i]
		local types = { "Halt", "Post", "Pre", "Replace" }

		for j = 1, #types do
			local hookType = types[j]
			local path = Mod:FormatDir(currentModule, hookType)
			local files = {}

			Shared.GetMatchingFileNames(path, true, files)

			for k = 1, #files do
				local file = files[k]
				local vpath = file:gsub(kModName .. "/.*/" .. hookType .. "/", "")

				Mod.Logger:PrintDebug(string.format("Hooking file: %s, Vanilla Path: %s, Method: %s", file, vpath, hookType), "all")
				ModLoader.SetupFileHook(vpath, file, hookType:lower())
			end
		end
	end

	Mod.Logger:PrintDebug("File hooks complete", "all")
end