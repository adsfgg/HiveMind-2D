if not string.find(Script.CallStack(), "Main.lua") then
	local Mod = GetMod()

	Mod.Logger:PrintDebug("Loading Server files", "Server")

	for i = 1, #Mod:GetModules() do
		local path = Mod:FormatDir(Mod:GetModules()[i], "Server")

		local ServerFiles = {}
		Shared.GetMatchingFileNames(path, true, ServerFiles)

		for j = 1, #ServerFiles do
			Mod.Logger:PrintDebug("Loading server file: " .. ServerFiles[j], "Server")
			Script.Load(ServerFiles[j])
		end
	end

	Mod.Logger:PrintDebug("Server files loaded.", "Server")

	if Mod:GetConfig().disableRanking == true then
	  gRankingDisabled = true
	end

	Mod.Logger:PrintVersion("Server")
end
