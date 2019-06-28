if not string.find(Script.CallStack(), "Main.lua") then
	local Mod = GetMod()

	Mod.Logger:PrintDebug("Loading Client files", "Client")

	for i = 1, #Mod:GetModules() do
		local path = Mod:FormatDir(Mod.config.modules[i], "Client")

		local ClientFiles = {}
		Shared.GetMatchingFileNames(path, true, ClientFiles)

		for j = 1, #ClientFiles do
			Mod.Logger:PrintDebug("Loading client file: " .. ClientFiles[j], "Client")
			Script.Load(ClientFiles[j])
		end
	end

	Mod.Logger:PrintDebug("Client files loaded.", "Client")

	Mod.Logger:PrintVersion("Client")

	if Mod:GetConfig().use_config == "client" or Mod:GetConfig().use_config == "both" then
		WriteDefaultConfigFile(Mod.ModConfig:GetConfigFileName(), Mod.ModConfig:GetDefaultConfigOptions())

		Mod.ModConfig:LoadConfig()
	end
end
