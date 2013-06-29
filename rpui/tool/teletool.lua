--[[
  The following legacy code is created by blocco.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "tools\teletool.lua".
--]]

local TeleportTool = Instance.new("HopperBin");
TeleportTool.Name = "Teleport";
TeleportTool.TextureId = "";
local Code = Instance.new("LocalScript");
Code.Name = "lua";
Code.Source = [[
local Player;
script.Parent.Selected:connect(function(mouse)
	Player = game.Players.LocalPlayer;
	mouse.Button1Down:connect(function()
		if mouse.Target and Player.Character then
			Player.Character:MoveTo(mouse.Hit.p + Vector3.new(0, 3.5, 0))
		end
	end)
end)
]]
Code.Parent = TeleportTool;
return TeleportTool;
