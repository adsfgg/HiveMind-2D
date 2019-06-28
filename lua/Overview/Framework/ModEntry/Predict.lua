if not string.find(Script.CallStack(), "Main.lua") then
	local Mod = GetMod()

	Mod.Logger:PrintDebug("Loading Predict files", "Predict")

	for i = 1, #Mod:GetModules() do
		local path = Mod:FormatDir(Mod:GetModules()[i], "Predict")

		local PredictFiles = {}
		Shared.GetMatchingFileNames(path, true, PredictFiles)

		for j = 1, #PredictFiles do
			Mod.Logger:PrintDebug("Loading predict file: " .. PredictFiles[j], "Predict")
			Script.Load(PredictFiles[j])
		end
	end

	Mod.Logger:PrintDebug("Predict files loaded.", "Predict")
end
