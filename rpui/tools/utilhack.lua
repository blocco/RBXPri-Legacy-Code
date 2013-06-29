--[[
  The following legacy code is created by blocco.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "tools\utilhack.lua".
--]]

local UtilityHack = Instance.new("HopperBin");
UtilityHack.Name = "UtilHack";
UtilityHack.TextureId = "rbxasset://rpui//images//utilhack.png"
local Code = Instance.new("LocalScript");
Code.Name = "lua";
Code.Source = [===[local hovBox = Instance.new("SelectionBox");
hovBox.Name = "UtilityHackBox";
hovBox.Color = BrickColor.new("White");
hovBox.Visible = false;
hovBox.Parent = script.Parent;

local UtilityHackGui = Instance.new("ScreenGui", script.Parent);
UtilityHackGui.Name = "UtilityHackGui";

local selectedMode="Anchor Toggle";

local modes={
	["Anchor Toggle"]=function(mouse)
		local prt = mouse.Target;
		prt.Anchored = not prt.Anchored;
	end;
	["Random Color"]=function(mouse)
		local prt = mouse.Target;
		prt.BrickColor = BrickColor.Random();
	end;
	["Spawn Bomb"]=function(mouse)
		local exploded=false;
		local prt=Instance.new("Part");
		local eVal = Instance.new("BoolValue");
		eVal.Name = "ForceExplode";
		eVal.Parent = prt;
		prt.Name = "Bomb";
		prt.BrickColor = BrickColor.new("Bright red");
		prt.Reflectance = 0.7;
		prt.Size = Vector3.new(2, 2, 2);
		prt.Shape = "Ball";
		prt.Locked=true;
		prt.TopSurface = "Smooth";
		prt.BottomSurface = "Smooth";
		prt.CFrame = mouse.Hit + Vector3.new(0, 6, 0)
		prt.Parent = workspace;
		local explosion = Instance.new("Explosion")
		explosion.BlastRadius = 10;
		explosion.BlastPressure = 10e5;
		local n=0;
		for i = 2, 12 do n = n + 6/(i^2) end
		game:service("Debris"):AddItem(prt, n+0.45)
		for i = 2, 12 do
			if eVal.Value then exploded = true; game:service("Debris"):AddItem(prt, 0) explosion.Position = prt.Position; explosion.Parent = workspace; break end;
			prt.Reflectance = 1-prt.Reflectance;
			wait(6/i^2);
		end
		explosion.Position = prt.Position;
		explosion.Hit:connect(function(p)
			if p:FindFirstChild("ForceExplode") and p.Name == "Bomb" then
				p.ForceExplode.Value = true;
			end
		end)
		if prt.Parent and not exploded then explosion.Parent = workspace; prt.CanCollide = false; prt.Transparency = 1 end
	end;
	--[==[["Spawn Mega Bomb"]=function(mouse)
		local exploded=false;
		local prt=Instance.new("Part");
		local eVal = Instance.new("BoolValue");
		eVal.Name = "ForceExplode";
		eVal.Parent = prt;
		prt.Name = "Bomb";
		prt.BrickColor = BrickColor.new("Bright red");
		prt.Reflectance = 0.7;
		prt.Size = Vector3.new(12, 12, 12);
		prt.Shape = "Ball";
		prt.TopSurface = "Smooth";
		prt.BottomSurface = "Smooth";
		prt.CFrame = mouse.Hit + Vector3.new(0, 16, 0)
		prt.Locked=true;
		prt.Parent = workspace;
		local explosion = Instance.new("Explosion")
		explosion.BlastRadius = 150;
		explosion.BlastPressure = 10e8;
		for i = 2, 12 do
			if eVal.Value then exploded = true; game:service("Debris"):AddItem(prt, 0) explosion.Position = prt.Position; explosion.Parent = workspace; break end;
			prt.Reflectance = 1-prt.Reflectance;
			wait(6/i^2);
		end
		game:service("Debris"):AddItem(prt, 0)
		explosion.Position = prt.Position;
		explosion.Hit:connect(function(p)
			if p:FindFirstChild("ForceExplode") and p.Name == "Bomb" then
				p.ForceExplode.Value = true;
			end
		end)
		if prt.Parent and not exploded then explosion.Parent = workspace; end
	end;]==]--
	["Collide Toggle"]=function(mouse)
		mouse.Target.CanCollide = not mouse.Target.CanCollide;
	end;
}

local function createDropDownUtility(list, sel, onsel)
	
	sel = sel or 1;
	local width = 160; -- these can be changed to change the look of it
	local height = 24;
	local gapSize = 2;
	
	local utilityColor = Color3.new(0.85, 0.85, 0.85);
	local utilityBorderColor = Color3.new(0, 0, 0);
	local inputColor = Color3.new(1, 1, 1);
	local fontColor = Color3.new(0, 0, 0);
	
	local btnColor = Color3.new(0.9, 0.9, 0.9);
	local btnColorHov = Color3.new(0.95, 0.95, 0.95);
	local btnColorDn = Color3.new(0.65, 0.65, 0.65);
	
	local btnColorSel = Color3.new(0.7, 0.7, 1);
	local btnColorHovSel = Color3.new(0.75, 0.75, 1);
	local btnColorDnSel = Color3.new(0.45, 0.45, 0.8);
	
	local function createButton(nam, sel)
		local btn=Instance.new("TextButton");
		btn.AutoButtonColor = false;
		btn.Name = nam;
		btn.Font = sel and "ArialBold" or "Arial";
		btn.FontSize = "Size14";
		btn.TextColor3 = fontColor;
		btn.BackgroundColor3 = sel and btnColorSel or btnColor;
		btn.BorderColor3 = utilityBorderColor;
		
		btn.MouseEnter:connect(function()
			btn.BackgroundColor3 = sel and btnColorHovSel or btnColorHov;
		end)
		btn.MouseLeave:connect(function()
			btn.BackgroundColor3 = sel and btnColorSel or btnColor;
		end)
		btn.MouseButton1Down:connect(function()
			btn.BackgroundColor3 = sel and btnColorDnSel or btnColorDn;
		end)
		btn.MouseButton1Up:connect(function()
			btn.BackgroundColor3 = sel and btnColorSel or btnColor;
		end)
		return btn;
	end
	
	local holder = Instance.new("Frame");
	holder.Name = "DropDownList";
	holder.Size = UDim2.new(0, width, 0, height);
	holder.BackgroundColor3 = utilityColor;
	holder.BorderColor3 = Color3.new(0, 0, 0);
	
	local frm=Instance.new("Frame");
	frm.Name = "LabelHolder";
	frm.Size = UDim2.new(1, -(gapSize*2), 0, height-(gapSize*2))--UDim2.new(0, width-(gapSize*3 + height-(gapSize*2)), 0, height-(gapSize*2));
	frm.Position = UDim2.new(0, gapSize, 0, gapSize);
	frm.BackgroundColor3 = inputColor; -- cheating since this isn't an input
	frm.BorderColor3 = utilityBorderColor;
	frm.Parent = holder;
	
	local lbl = Instance.new("TextLabel");
	lbl.TextXAlignment = "Left";
	lbl.Name = "Label";
	lbl.Font = "ArialBold";
	lbl.FontSize = "Size14";
	lbl.Size = UDim2.new(1, -height, 1, -(gapSize*2));
	lbl.Position = UDim2.new(0, gapSize, 0, gapSize);
	lbl.Text = list[sel] and sel or "Select an item";
	lbl.TextColor3 = fontColor;
	lbl.BackgroundColor3 = inputColor; -- cheating since this isn't an input
	lbl.BorderColor3 = utilityBorderColor;
	lbl.BorderSizePixel = 0;
	lbl.BackgroundTransparency = 1;
	lbl.Parent = frm;
	
	local btn=Instance.new("ImageButton");
	btn.Name = "DropDownButton";
	btn.AutoButtonColor = false;
	btn.Image = "rbxasset://rpui//images//dropdown_down.png"
	btn.BorderSizePixel=0;
	btn.BackgroundTransparency = 1;
	btn.Size = UDim2.new(0, height-(gapSize*2), 0, height-(gapSize*2));
	btn.Position = UDim2.new(1, -height+gapSize, 0, 0);
	btn.Parent = frm;
	
	local lstObj = Instance.new("Frame");
	lstObj.BackgroundColor3 = utilityColor;
	lstObj.BorderColor3 = utilityBorderColor;
	lstObj.Name = "ListObject";
	lstObj.Visible=false;
	lstObj.Position = UDim2.new(0, 0, 0, height+gapSize);
	lstObj.Parent = holder;
	
	updateList = function()
		local objs=0;
		for i, v in pairs(lstObj:GetChildren()) do
			v.Parent = nil;
		end
		for i, v in pairs(list) do
			objs=objs+1;
			local objBtn=createButton("object_" .. i, sel == i);
			objBtn.Size = UDim2.new(0, width-(gapSize*3 + height-(gapSize*2)), 0, height-(gapSize*2));
			objBtn.Position = UDim2.new(0, gapSize, 0, (height-gapSize)*(objs-1) + gapSize);
			objBtn.Text = tostring(i);
			objBtn.Parent = lstObj;
			objBtn.MouseButton1Click:connect(function()
				sel = i;
				onsel(i);
				lstObj.Visible=false;
				btn.Image = "rbxasset://rpui//images//dropdown_down.png"
				lbl.Text = tostring(i);
				updateList();
			end)
		end
		lstObj.Size = UDim2.new(0, width-(gapSize + height-(gapSize*2)), 0, (height-gapSize)*objs + gapSize);
	end
	
	btn.MouseButton1Click:connect(function()
		lstObj.Visible = not lstObj.Visible;
		btn.Image = lstObj.Visible and "rbxasset://rpui//images//dropdown_up.png" or "rbxasset://rpui//images//dropdown_down.png"
		updateList();
	end)
	
	return holder;
	
end

local function onDropDownSelect(obj)
	selectedMode = obj;
end

local dropDownUtility = createDropDownUtility(modes, "Anchor Toggle", onDropDownSelect);
dropDownUtility.Position = UDim2.new(1, -164, 0, 100)
dropDownUtility.Parent = UtilityHackGui;

script.Parent.Selected:connect(function(ms)
	repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui");
	UtilityHackGui.Parent = game.Players.LocalPlayer.PlayerGui;
	hovBox.Parent = game.Players.LocalPlayer.PlayerGui;
	hovBox.Visible = true;
	hovBox.Adornee = nil;
	ms.Move:connect(function()
		if ms.Target and ms.Target:IsA("BasePart") and not ms.Target.Locked then
			hovBox.Adornee = ms.Target;
		else
			hovBox.Adornee = nil;
		end
	end)
	ms.Button1Down:connect(function()
		if ms.Target and ms.Target:IsA("BasePart") and not ms.Target.Locked then coroutine.resume(coroutine.create(function() modes[selectedMode or "Anchor Toggle"](ms) end)); end
	end)
end)

script.Parent.Deselected:connect(function()
	hovBox.Adornee = nil;
	hovBox.Visible = false;
	hovBox.Parent = script.Parent;
	UtilityHackGui.Parent = script.Parent;
end)]===]
Code.Parent = UtilityHack;

return UtilityHack;
