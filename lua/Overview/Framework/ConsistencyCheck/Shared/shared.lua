local Mod = GetMod()

Shared.RegisterNetworkMessage(Mod:GetModName() .. "_EntryCheck", {
  count = "integer",
})
