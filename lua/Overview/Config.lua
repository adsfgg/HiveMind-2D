function GetModConfig(kLogLevels)
	local config = {}

	config.kLogLevel = kLogLevels.debug
	config.kShowInFeedbackText = true
	config.disableRanking = false
	config.use_config = "none"
	config.techIdsToAdd = {
	}

	config.libraries = {
		"LibDeflate"
	}

	config.modules = {
		"Overview"
	}

	return config
end

function GetVersionInformation(Versioning)
	Versioning:SetVersion(0, 1, 3, "alpha")
end