--[[
  The following legacy code is created by blocco.
	
	This code created the menu that was present on both the server and the client.
	One menu.  One script.  Simple.
	
	Here is where I used locally persistent data, to store the IP and Port of the
		last connected to server.  It saved a lot of time, and it was a nice feature.
	
	You'll notice I had a little structure for generating the menu.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "menu.lua".
--]]

local uiBase = game.CoreGui.RPUI;
local btnShield = uiBase.UIShield;

function createMenu(layout, fn)

	local validTypes={
		Button={"string", "string", "boolean", "function", "table"};
		Separator={};
		InformationRow={"string", "string", "string", "boolean"};
	}
	
	local function isValidType(tbl)
		for i, v in pairs(validTypes) do
			if tbl[1] == i then return true; end
		end
		return false;
	end
	local function isValidEntry(tbl)
		for i, v in ipairs(tbl) do
			if i ~= 1 then
				if type(v) ~= validTypes[tbl[1]][i-1] then return false; end
			end
		end
		return true;
	end

	local function createButton(main, nam, txt, act, fn, i)
		local btn = Instance.new("TextButton");
		btn.AutoButtonColor=false;
		btn.Name = nam or "MenuButton";
		btn.Text = txt;
		btn.TextTransparency = act and 0.2 or 0.5;
		btn.TextColor3 = Color3.new(0, 0, 0);
		btn.Font = "ArialBold";
		btn.FontSize = main and "Size14" or "Size12";
		btn.BackgroundTransparency = act and 0.8 or 0.6;
		btn.BackgroundColor3 = act and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8);
		btn.Size = UDim2.new(0, 100, 0, main and 20 or 16);--main and UDim2.new(0, 100, 0, 20) or UDim2.new(0, 120, 0, 16);
		btn.BorderSizePixel = 0;
		btn.Active = act;
		btn.MouseEnter:connect(function()
			if btn.Active then
				btn.TextTransparency = 0.2
				btn.BackgroundTransparency = 0;
			end
		end)
		btn.MouseLeave:connect(function()
			if btn.Active then
				btn.TextTransparency = 0.2
				btn.BackgroundTransparency = 0.8;
			end
		end)
		btn.MouseButton1Down:connect(function()
			if btn.Active then
				btn.TextTransparency = 0
				btn.BackgroundTransparency = 0;
			end
		end)
		btn.MouseButton1Up:connect(function()
			if btn.Active then
				btn.TextTransparency = 0.2
				btn.BackgroundTransparency = 0;
			end
		end)
		btn.MouseButton1Click:connect(function()
			if btn.Active then
				fn(btn);
			end
		end)
		btn.Changed:connect(function(p)
			if p == "Active" then
				btn.TextTransparency = btn.Active and 0.2 or 0.5;
				btn.BackgroundTransparency = btn.Active and 0.8 or 0.6;
				btn.BackgroundColor3 = btn.Active and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8);
			end
		end)
		return btn;
	end
	
	local function createSeparator(main, i)
		local sep=Instance.new("Frame");
		sep.Size = UDim2.new(0, main and 1 or 96, 0, main and 16 or 1)--UDim2.new(0, main and 1 or 116, 0, main and 16 or 1);
		sep.BackgroundColor3 = Color3.new(0, 0, 0);
		sep.Active=true;
		sep.BorderSizePixel=0;
		sep.Name = "Separator";
		return sep;
	end
	
	local function createInformationRow(main, nam, txt, typ, sav)
		valLookup={
			["string"]="";
			["int"]="0";
			["number"]="0";
		}
		local val=valLookup[typ];
		local infRow = Instance.new("Frame");
		infRow.Name = nam;
		infRow.Size = UDim2.new(0, 100, 0, main and 20 or 16)--UDim2.new(0, 120, 0, main and 20 or 16);
		infRow.BackgroundColor3 = Color3.new(1, 1, 1);
		infRow.BackgroundTransparency = 0.8;
		infRow.BorderSizePixel=0;
		infRow.Active=true;
		
		local function isValidEntry(typ, val)
			if type(val) ~= "string" then return false end;
			if typ == "string" then return true;
			elseif typ == "number" then return tonumber(val) ~= nil;
			elseif typ == "int" then
				if not tonumber(val) then return false end
				return tonumber(val)%1 == 0;
			end
		end
		
		local tonumber=tonumber;
		local floor=math.floor;
		
		local function convertVal(v, t)
			if t == "int" then v=floor(tonumber(v)+0.5)
			elseif t == "number" then v=tonumber(v) end
			return t:sub(1, 1):upper() .. t:sub(2), v
		end
		
		local lbl = Instance.new("TextLabel");
		lbl.Name = "Label";
		lbl.Text = txt;
		lbl.TextTransparency = 0.2;
		lbl.Size = UDim2.new(1, typ == "boolean" and -20 or -60, 1, 0);
		lbl.Font = "ArialBold";
		lbl.BackgroundTransparency=1;
		lbl.TextXAlignment = "Right";
		lbl.FontSize = main and "Size14" or "Size12";
		lbl.TextColor3 = Color3.new(0, 0, 0)
		lbl.Active = true;
		lbl.Parent = infRow;
		
		local typInd = Instance.new("StringValue");
		typInd.Name = "TypeIndicator";
		typInd.Value = typ;
		typInd.Parent = infRow;
		
		if typ == "boolean" then
			local val=RbxData.GetValue(nam) or false;
			local cbox = Instance.new("TextButton");
			cbox.AutoButtonColor=false;
			cbox.BackgroundColor3 = Color3.new(1, 1, 1);
			cbox.BorderColor3 = Color3.new(0, 0, 0);
			cbox.BackgroundTransparency = 0.6
			cbox.Font = "Arial";
			cbox.FontSize = "Size12"
			if sav then cbox.Text = (val and "X" or "") else cbox.Text = "" end
			cbox.Name = "Input";
			cbox.TextColor3 = Color3.new(0, 0, 0)
			cbox.Position = UDim2.new(1, -14, 1, -14);
			cbox.Size = UDim2.new(0, 12, 0, 12);
			cbox.MouseButton1Click:connect(function()
				val = not RbxData.GetValue(nam);
				cbox.Text = val and "X" or "";
				if sav then RbxData.SetValue(nam, "Bool", val) end
			end)
			cbox.MouseEnter:connect(function() cbox.BackgroundTransparency = 0 end)
			cbox.MouseLeave:connect(function() cbox.BackgroundTransparency = 0.6 end)
			cbox.Parent = infRow
		else
			local focus=false;
			local ibox = Instance.new("TextBox");
			ibox.Name = "Input";
			ibox.BackgroundColor3 = Color3.new(1, 1, 1);
			ibox.BorderColor3 = Color3.new(0, 0, 0);
			ibox.BackgroundTransparency = 0.6;
			ibox.ClearTextOnFocus=false;
			ibox.Font = "Arial";
			ibox.FontSize = "Size12";
			ibox.Text = tostring(sav and (RbxData.GetValue(nam) or val) or val)
			ibox.TextColor3 = Color3.new(0, 0, 0);
			ibox.Position = UDim2.new(1, -54, 1, -14);
			ibox.Size = UDim2.new(0, 52, 0, 12);
			ibox.TextXAlignment = "Left";
			ibox.Parent = infRow;
			local fakeibox=Instance.new("TextButton");
			fakeibox.Size = UDim2.new(1, 0, 1, 0)
			fakeibox.Name = "fakebutton";
			fakeibox.BackgroundTransparency = 1;
			fakeibox.TextTransparency = 1;
			fakeibox.ZIndex = 2;
			fakeibox.MouseButton1Click:connect(function()
				ibox:CaptureFocus();
				focus=true;
				ibox.BackgroundTransparency = 0;
				fakeibox.Visible=false;
			end)
			fakeibox.MouseEnter:connect(function() ibox.BackgroundTransparency = 0 end)
			fakeibox.MouseLeave:connect(function() ibox.BackgroundTransparency = 0.6 end)
			fakeibox.Parent = ibox;
			ibox.FocusLost:connect(function() if isValidEntry(typ, ibox.Text) then val=ibox.Text; else ibox.Text=val; end if sav then RbxData.SetValue(nam, convertVal(val, typ)) end fakeibox.Visible=true; ibox.BackgroundTransparency = 0.6; end)
		end
		
		return infRow
	end
	
	local layoutFns={Button=createButton, Separator=createSeparator, InformationRow=createInformationRow}
	
	local uiMenu = Instance.new("Frame");
	uiMenu.Name = "UIMenu"
	uiMenu.BackgroundTransparency = 1;
	uiMenu.BackgroundColor3 = Color3.new(0, 0, 0);
	uiMenu.BorderSizePixel = 0;
	uiMenu.Size = UDim2.new(0, 0, 0, 0);
	uiMenu.Position = UDim2.new(0, 0, 0, 0);
	
	local validMainButtons=0;
	local validMainSeps=0;
	
	for i, v in ipairs(layout) do
		if isValidType(v) and isValidEntry(v) then
			if v[1] == "Button" then
				validMainButtons = validMainButtons + 1;
			elseif v[1] == "Separator" then
				validMainSeps = validMainSeps + 1;
			end
		end
	end
	
	uiMenu.Size = UDim2.new(0, validMainButtons*100 + validMainSeps*3, 0, 20);
	uiMenu.Position = UDim2.new(0.5, -(validMainButtons*100 + validMainSeps*3)/2, 0, 0)
	
	local posVars={Button={[true]=100, [false]=16}, Separator={[true]=3, [false]=3}, InformationRow={[true]=120, [false]=16}}
	local function createLayout(tab)
		local function recurseCreateLayout(tab, obj, main)
			main = main or false;
			local posVar=0;
			for i, v in pairs(tab) do
				if isValidType(v) and isValidEntry(v) then
					local ptab={};
					for ii, vv in ipairs(v) do
						if ii ~= 1 then
							ptab[ii-1]=vv
						end
					end
					local gobj=layoutFns[v[1]](main, unpack(ptab));
					gobj.Position = UDim2.new(0, main and (v[1] == "Separator" and posVar+1 or posVar) or (v[1] == "Separator" and 2 or 0), 0, main and (v[1] == "Separator" and 2 or 0) or (v[1] == "Separator" and posVar+1 or posVar)+20)
					gobj.Visible=main
					gobj.Parent = obj;
					local typVal = Instance.new("StringValue");
					typVal.Name = "ElementType"
					typVal.Value = v[1];
					typVal.Parent = gobj;
					posVar=posVar+posVars[v[1]][main]
					if v[1] == "Button" then
						gobj.MouseButton1Click:connect(
							function()
								if main or not gobj.Active then return end;
								for i, v in pairs(uiMenu:GetChildren()) do
									for ii, vv in pairs(v:children()) do
										if vv:IsA("GuiObject") then vv.Visible=false; end
									end
								end
								btnShield.Visible=false;
							end
						) recurseCreateLayout(v[6], gobj)
					end
				end
			end
		end
		recurseCreateLayout(tab, uiMenu, true);
	end
	createLayout(layout);
	
	for i, v in pairs(uiMenu:GetChildren()) do
		if v.ElementType.Value == "Button" then
			v.MouseEnter:connect(function()
				if not v.Active then return end
				for ii, vv in pairs(uiMenu:GetChildren()) do
					for iii, vvv in pairs(vv:children()) do
						if vvv:IsA("GuiObject") then vvv.Visible=false; end
					end
				end
				for ii, vv in pairs(v:children()) do
					if vv:IsA("GuiObject") then vv.Visible=true; end
				end
				btnShield.Visible=true;
			end)
		end
	end
	btnShield.MouseButton1Down:connect(function()
		for i, v in pairs(uiMenu:GetChildren()) do
			for ii, vv in pairs(v:children()) do
				if vv:IsA("GuiObject") then vv.Visible=false; end
			end
		end
		btnShield.Visible=false;
	end)
	btnShield.MouseButton2Down:connect(function()
		for i, v in pairs(uiMenu:GetChildren()) do
			for ii, vv in pairs(v:children()) do
				if vv:IsA("GuiObject") then vv.Visible=false; end
			end
		end
		btnShield.Visible=false;
	end)
	
	return uiMenu;
end

local CliButFn = function(btn)
	if (RbxData.GetValue("IP") and RbxData.GetValue("CPort")) or RbxData.GetValue("CJoinString") or RbxData.GetValue("RPTPString") then
		_G.ClientUtilities.SetCommandBarVisibility(RbxData.GetValue("IGCB"))
		_G.ClientUtilities.SetGuestTalk(RbxData.GetValue("GT"))
		_G.ClientUtilities.SetToolSpawn(RbxData.GetValue("TS"));
		local success;
		if not RbxData.GetValue("RPTPString") and not RbxData.GetValue("CJoinString") then
			_G.ClientUtilities.Connect(RbxData.GetValue("PName") or "Player", RbxData.GetValue("PID") or 0, RbxData.GetValue("IP"), RbxData.GetValue("CPort"));
			success = true;
		elseif RbxData.GetValue("CJoinString") then
			local b, ip, prt = pcall(CJoinEx.Decode, RbxData.GetValue("CJoinString"));
			if not b then print("ERROR: " .. ip) else _G.ClientUtilities.Connect(RbxData.GetValue("PName") or "Player", RbxData.GetValue("PID") or 0, ip, prt) success = true end
		elseif RbxData.GetValue("RPTPString") or (RbxData.GetValue("CJoinString") and not success) then
			local b, ip, prt = pcall(RPTP2.Decode, RbxData.GetValue("RPTPString"));
			if not b then print("ERROR: " .. ip) else _G.ClientUtilities.Connect(RbxData.GetValue("PName") or "Player", RbxData.GetValue("PID") or 0, ip, prt) success = true end
		end
		
		if not success then return end;
		
		RbxData.AddChangeCallback(function(nam)
			if nam == "IGCB" then
				_G.ClientUtilities.SetCommandBarVisibility(RbxData.GetValue("IGCB"));
			elseif nam == "GT" then
				_G.ClientUtilities.SetGuestTalk(RbxData.GetValue("GT"));
			elseif nam == "TS" then
				_G.ClientUtilities.SetToolSpawn(RbxData.GetValue("TS"));
			end
		end)
		
		for i, v in pairs(btn.Parent:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible=false end
		end
		btn.Parent.Active=false;
	end
end
local CliButFn2 = function(btn)
	if (RbxData.GetValue("IP") and RbxData.GetValue("CPort")) or RbxData.GetValue("CJoinString") or RbxData.GetValue("RPTPString") then
		_G.ClientUtilities.SetCommandBarVisibility(RbxData.GetValue("IGCB"))
		_G.ClientUtilities.SetGuestTalk(RbxData.GetValue("IGCB"))
		_G.ClientUtilities.SetToolSpawn(RbxData.GetValue("TS"));
		local success;
		if not RbxData.GetValue("RPTPString") and not RbxData.GetValue("CJoinString") then
			_G.ClientUtilities.ConnectAsGuest(RbxData.GetValue("IP"), RbxData.GetValue("CPort"));
			success = true;
		elseif RbxData.GetValue("CJoinString") then
			local b, ip, prt = pcall(CJoinEx.Decode, RbxData.GetValue("CJoinString"));
			if not b then print("ERROR: " .. ip) else _G.ClientUtilities.ConnectAsGuest(CJoinEx.Decode(RbxData.GetValue("CJoinString"))) success = true end
		elseif RbxData.GetValue("RPTPString") or (RbxData.GetValue("CJoinString") and not success) then -- uses this if CJoinString doesn't work
			local b, ip, prt = pcall(RPTP2.Decode, RbxData.GetValue("RPTPString"));
			if not b then print("ERROR: " .. ip) else _G.ClientUtilities.ConnectAsGuest(RPTP2.Decode(RbxData.GetValue("RPTPString"))) success = true end
		end
		
		if not success then return end;
		
		RbxData.AddChangeCallback(function(nam)
			if nam == "IGCB" then
				_G.ClientUtilities.SetCommandBarVisibility(RbxData.GetValue("IGCB"));
			elseif nam == "GT" then
				_G.ClientUtilities.SetGuestTalk(RbxData.GetValue("GT"));
			elseif nam == "TS" then
				_G.ClientUtilities.SetToolSpawn(RbxData.GetValue("TS"));
			end
		end)
		
		for i, v in pairs(btn.Parent:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible=false end
		end
		btn.Parent.Active=false;
	end
end
local num;
local SerButFn = function(btn)
	if not RbxData.GetValue("SPort") then return end
	_G.ServerUtilities.Start(RbxData.GetValue("SPort") or 53640)
	math.randomseed(tick()+2)
	num = num or math.random(16) - 9;
	print("RPTP2:", RPTP2.Encode(RbxData.GetValue("SIP") or "127.0.0.1", RbxData.GetValue("SPort") or 53640, num));
	print("CJoinEx:", CJoinEx.Encode(RbxData.GetValue("SIP") or "127.0.0.1", RbxData.GetValue("SPort") or 53640));
end
local SerStopButFn = function(btn)
	_G.ServerUtilities.Stop();
end
local RdFn = function(btn)
	for i, v in pairs(btn.Parent:children()) do
		if v:IsA("GuiObject") and v.ElementType.Value == "InformationRow" then
			RbxData.SetValue(v.Name, nil);
			if v.TypeIndicator.Value == "number" or v.TypeIndicator.Value == "int" then
				v.Input.Text = "0";
			else
				v.Input.Text = "";
			end
		end
	end
end
local RadFn = function(btn)
	for i, v in pairs(btn.Parent.Parent:children()) do
		for i, v in pairs(v:children()) do
			if v:IsA("GuiObject") and v.ElementType.Value == "InformationRow" then
				RbxData.SetValue(v.Name, nil);
				if v.TypeIndicator.Value == "number" or v.TypeIndicator.Value == "int" then
					v.Input.Text = "0";
				else
					v.Input.Text = "";
				end
			end
		end
	end
end
local ExitFn = function(btn)
	game:Shutdown();
end

local menuLayout={
	{"Button", "ClientButton", "Client", false, function() end,
		{
			{"InformationRow", "IP", "IP", "string", true};
			{"InformationRow", "CPort", "Port", "int", true};
			{"InformationRow", "CJoinString", "CJoinEx", "string", true};
			{"InformationRow", "RPTPString", "RPTP2", "string", true};
			{"InformationRow", "PName", "Name", "string", true};
			{"InformationRow", "PID", "ID", "int", true};
			{"Button", "JoinButton", "Join As Guest", true, CliButFn2, {}};
			{"Button", "JoinButton", "Join Game", true, CliButFn, {}};
			{"Separator"};
			{"Button", "RD1Button", "Reset Data", true, RdFn, {}};
		};
	};
	{"Button", "ServerButton", "Server", false, function() end,
		{
			{"InformationRow", "SIP", "IP", "string", true}; -- used for creation of RPTPStrings
			{"InformationRow", "SPort", "Port", "int", true};
			{"Button", "StartButton", "Start Game", true, SerButFn, {}};
			{"Button", "StopButton", "Stop Game", true, SerStopButFn, {}};
			{"Separator"};
			{"Button", "RD2Button", "Reset Data", true, RdFn, {}};
		};
	};
	{"Button", "OptionsButton", "Options", true, function() end,
		{
			{"InformationRow", "GT", "Guest Talk", "boolean", true};
			{"InformationRow", "IGCB", "IG Cmd Bar", "boolean", true};
			{"InformationRow", "TS", "Tools Spawn", "boolean", true};
			{"Separator"};
			{"Button", "RD3Button", "Reset Data", true, RdFn, {}};
			{"Button", "RADButton", "Reset All Data", true, RadFn, {}};
		};
	};
	{"Separator"};
	{"Button", "ExitButton", "Exit", true, ExitFn, {}};
}

local uiMenu = createMenu(menuLayout);
uiMenu.Parent = uiBase;

-- This is to make sure that the client can't access server stuff and vice versa
coroutine.resume(coroutine.create(function() repeat wait() until _G.ClientUtilities; uiMenu.ClientButton.Active=true; end))
coroutine.resume(coroutine.create(function() repeat wait() until _G.ServerUtilities; uiMenu.ServerButton.Active=true; end))
