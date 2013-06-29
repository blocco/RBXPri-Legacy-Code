--[[
  The following legacy code is created by blocco.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "client.lua".
--]]

--[<>[  DOCUMENTATION  ]<>]--
--[==[
	Global ClientUtilities Class
		Connect => string name, int userId, string ip, int port => Connects you to a server with your name and userId;
		Disconnect => Disconnects you from a server;
		GetIP => Gets server IP;
		GetPort => Gets server Port;
		ConnectAsGuest => string ip, int port => Connects you to a server with random Guest ID and name;
		SetCommandBarVisibility => boolean cmdBarVis => Sets command bar visibility in game;
		SetGuestTalk => boolean canGuestTalk => Sets whether or not you can talk if you're a guest;
]==]--

local Instance=Instance;
local clientConnected=false;
local selfDisconnect=false;

local showServerInfo=false;

-- Why go through all the trouble of creating labels and whatnot when you can insert it from a model?
local svInfTbl = workspace:InsertContent("rbxasset://rpui//serverInfo.rbxm");
table.foreachi(svInfTbl, function(i, v)v.Visible=false;v.Parent=nil;svInfTbl[v.Name]=v;end);

_G.ClientUtilities={};

-------------------------------
--> SetCommandBarVisibility <--
-------------------------------
local cmdBarVis=false;
local updatecb=false;
_G.ClientUtilities.SetCommandBarVisibility=function(b)
	cmdBarVis = not(not(b))
	updatecb = not updatecb;
end
-------------------------------

--------------------
--> SetGuestTalk <--
--------------------
local guestTalk=true;
local updategb=false;
_G.ClientUtilities.SetGuestTalk=function(b)
	guestTalk = not(b)
	updategb=not updategb;
end
--------------------

--------------------
--> SetToolSpawn <--
--------------------
local toolSpawn=true;
_G.ClientUtilities.SetToolSpawn=function(b)
	toolSpawn = not(not(b))
end
--------------------

function robloxLock(obj)
	local function lock(nobj)
		for i, v in pairs(nobj:children()) do
			v.RobloxLocked=true;
			lock(v)
		end
	end
	obj.RobloxLocked=true;
	lock(obj);
end

-------------------
--> UI Controls <--
-------------------
local LBL_SML = "Size18";

function createTextbox(nam, typ)
	local tb = Instance.new("TextBox");
	local tbh = Instance.new("TextButton");
	tbh.Name = nam .. "_holder";
	tbh.Style = "RobloxButton";
	tbh.Active=false;
	tbh.TextTransparency = 1;
	tb.Name = nam;
	tb.Font = "Arial";
	tb.TextWrap = true;
	tb.TextXAlignment = "Left"
	tb.FontSize = typ or LBL_SML;
	tb.BackgroundTransparency = 1;
	tb.TextColor3 = Color3.new(1, 1, 1);
	tb.Size = UDim2.new(1, 0, 1, 16)
	tb.Position = UDim2.new(0, 0, 0, -8);
	tb.Parent = tbh;
	return {Input=tb, Holder=tbh}
end

function createButton(nam, txt, typ)
	local btn = Instance.new("TextButton");
	btn.Style = "RobloxButton";
	btn.Font = "ArialBold";
	btn.FontSize = typ or LBL_SML;
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = txt;
	btn.Name = nam;
	return btn;
end
-------------------

function connect(nam, userId, ip, prt)
	if clientConnected then return end;
	for i, v in pairs(workspace:children()) do
		if not v == workspace.CurrentCamera then
			v:Remove();
		end
	end
	game:service("RunService"):Run();
	local plyr;
	clientConnected=true;
	local cl=game:service("NetworkClient");
	game:SetMessage("Connecting...")
	cl.ConnectionAccepted:connect(function(p, rep)
		rep:SendMarker().Received:connect(function()
			game:SetMessage("Waiting for character...");
			rep:RequestCharacter();
			
			-- looking back, when I figured out I was able to use models as a sort of template, I had to have been excited
			svInfTbl.SvInfMax.PortValue.Text = tostring(prt);
			svInfTbl.SvInfMax.URIValue.Text = tostring(ip);
			svInfTbl.SvInfMax.InButton.MouseButton1Click:connect(function()svInfTbl.SvInfMax.Visible=false;svInfTbl.SvInfMin.Visible=true;end)
			svInfTbl.SvInfMin.OutButton.MouseButton1Click:connect(function()svInfTbl.SvInfMax.Visible=true;svInfTbl.SvInfMin.Visible=false;end)
			if showServerInfo then
				svInfTbl.SvInfMax.Visible = true;
				svInfTbl.SvInfMax.Parent = game.CoreGui.RPUI;
				svInfTbl.SvInfMin.Parent = game.CoreGui.RPUI;
			else
				svInfTbl.SvInfMin.Visible = true;
				svInfTbl.SvInfMin.Parent = game.CoreGui.RPUI;
				svInfTbl.SvInfMax.Parent = game.CoreGui.RPUI;
			end
			
			------------------------
			--) Command Bar Area (--
			------------------------
			--if cmdBarVis then
				local runCode=function(cde)
					local cdeFn=loadstring(cde) or function() end;
					getfenv(cdeFn).Player=game.Players.LocalPlayer;
					getfenv(cdeFn).Character=game.Players.LocalPlayer.Character;
					getfenv(cdeFn).ClientUtilities=_G.ClientUtilities;
					coroutine.resume(coroutine.create(cdeFn));
				end
				
				local comBar=createTextbox("CLI_CommandBar");
				comBar.Holder.Size = UDim2.new(0.8, -3, 0, 24);
				comBar.Holder.Position = UDim2.new(0, 3, 0, -27);
				comBar.Input.Size = UDim2.new(1, -16, 1, 16)
				comBar.Input.ClearTextOnFocus=false;
				comBar.Input.Text = "";
				comBar.Input.FocusLost:connect(function(e)
					if e then
						local cde=comBar.Input.Text;
						runCode(cde)
					end
				end)
				game.GuiService:AddKey("-");
				game.GuiService.KeyPressed:connect(function(k)
					if k == "-" then
						comBar.Input:CaptureFocus();
					end
				end)
				comBar.Holder.Parent = game.CoreGui.RPUI;
				
				local clrBut=createButton("CLI_ClearButton", "Clear Code");
				clrBut.Size = UDim2.new(0.1, -4, 0, 24);
				clrBut.Position = UDim2.new(0.8, 2, 0, -27);
				clrBut.Parent = game.CoreGui.RPUI;
				clrBut.MouseButton1Click:connect(function()
					comBar.Input.Text="";
				end)
				
				local comBut=createButton("CLI_EnterButton", "Run Code");
				comBut.Size = UDim2.new(0.1, -4, 0, 24);
				comBut.Position = UDim2.new(0.9, 0, 0, -27);
				comBut.Parent = game.CoreGui.RPUI;
				comBut.MouseButton1Click:connect(function()
					local cde=comBar.Input.Text;
					runCode(cde);
				end)
				
				robloxLock(comBar.Holder);
				robloxLock(clrBut);
				robloxLock(comBut);
				
				uiMenu = game.CoreGui.RPUI.UIMenu;
				
				if cmdBarVis then -- how neat, a tweening command bar for your in-game command bar needs :P
					comBar.Holder:TweenPosition(UDim2.new(0, 3, 0, 3), nil, nil, 0.5)
					clrBut:TweenPosition(UDim2.new(0.8, 2, 0, 3), nil, nil, 0.5)
					comBut:TweenPosition(UDim2.new(0.9, 0, 0, 3), nil, nil, 0.5)
					uiMenu:TweenPosition(UDim2.new(uiMenu.Position.X.Scale, uiMenu.Position.X.Offset, uiMenu.Position.Y.Scale, 32), nil, nil, 0.5)
				end
				
				local uB = updatecb;
				local lB = uB;
				coroutine.resume(coroutine.create(function() while true do
					uB = updatecb;
					wait(0.1);
					if uB ~= lB then
						comBar.Holder:TweenPosition(UDim2.new(0, 3, 0, cmdBarVis and 3 or -27), cmdBarVis and nil or Enum.EasingDirection.In, nil, 0.5)
						clrBut:TweenPosition(UDim2.new(0.8, 2, 0, cmdBarVis and 3 or -27), cmdBarVis and nil or Enum.EasingDirection.In, nil, 0.5)
						comBut:TweenPosition(UDim2.new(0.9, 0, 0, cmdBarVis and 3 or -27), cmdBarVis and nil or Enum.EasingDirection.In, nil, 0.5)
						uiMenu:TweenPosition(UDim2.new(uiMenu.Position.X.Scale, uiMenu.Position.X.Offset, uiMenu.Position.Y.Scale, cmdBarVis and 32 or 0), cmdBarVis and nil or Enum.EasingDirection.In, nil, 0.5)
						wait(0.5)
					end
					lB = uB
				end end))
			--end
		end);
		local conn=plyr.CharacterAdded:connect(function()
			game:ClearMessage();
			conn:disconnect();
		end)
		plyr.CharacterAdded:connect(function() -- here, we make hopperbins with Lua scripts
			local utilhack = dofile("rbxasset://rpui//tools//utilhack.lua");
			local teletool = dofile("rbxasset://rpui//tools//teletool.lua");
			if toolSpawn then
				utilhack.Parent = plyr.Backpack;
				teletool.Parent = plyr.Backpack;
			end
		end)
		rep.Disconnection:connect(function(p, lc)
			if not selfDisconnect then
				if lc then
					game:SetMessage("You have lost connection.")
				else
					game:SetMessage("You have been disconnected.")
				end
			end
		end)
	end)
	cl.ConnectionRejected:connect(function() -- can happen many times
		game:SetMessage("Connection has been rejected.")
	end)
	cl.ConnectionFailed:connect(function(p, code, r) -- only should happen once
		game:SetMessage("Connection to server has failed.  Try again.  (ID=" .. code .. ")")
	end)
	
	-- the client allowed us to join games as any player we wished
	-- this was a glorious feature of the RBXPri Client
	-- you could even join as a simulated guest!
	math.randomseed(tick()+2)
	plyr=cl:PlayerConnect(userId, ip, prt, settings().Network.PreferredClientPort)
	plyr.Name = nam or "Player";
	if userId < 0 then
		plyr:SetSuperSafeChat(guestTalk);
		local uB2 = updategb;
		local lB2 = uB2;
		coroutine.resume(coroutine.create(function() while true do
			uB2 = updategb;
			wait(0.1);
			if uB2 ~= lB2 then
				plyr:SetSuperSafeChat(guestTalk);
			end
			lB2 = uB2
		end end))
	end
	userId = (userId < 0 and 1 or userId);
	plyr.CharacterAppearance = "http://www.roblox.com/asset/CharacterFetch.ashx?userId=" .. tostring(userId);
	game:ClearMessage();
end

-- simulated guest lol!  and it worked too
function connectAsGuest(ip, prt)
	math.randomseed(tick()+2)
	local n = -(math.random(1, 1000001)-1);
	local nam="Guest " .. tostring((-n)%10000);
	_G.ClientUtilities.Connect(nam, n, ip, prt);
end

function disconnect()
	if not clientConnected then return end;
	selfDisconnect=true;
	clientConnected=false;
	game:service("NetworkClient"):Disconnect();
	game:SetMessage("You have disconnected yourself.")
	
	game:ClearContent(true); -- keep our coregui stuffz
end

function getIP()
	if not clientConnected then return end
	return game:service("NetworkClient"):children()[1].MachineAddress;
end

function getPort()
	if not clientConnected then return end
	return game:service("NetworkClient"):children()[1].Port;
end

_G.ClientUtilities.Connect = connect;
_G.ClientUtilities.Disconnect = disconnect;
_G.ClientUtilities.GetIP = getIP;
_G.ClientUtilities.GetPort = getPort;
_G.ClientUtilities.ConnectAsGuest = connectAsGuest;
