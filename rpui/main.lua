--[[
    The following legacy code is created by blocco.
    
    It contains many comments for documentation purposes.
    It is to be used for educational purposes.
    
    This code is from RBXPri (Blocco Edition).
    This file is "main.lua".
--]]

-- in case I want people to know what they're using
local showVersion, versionString=false, "RBXPri Server/Client (Blocco Edition) v0.7.3";

-- robloxLock recursively RobloxLocks objects, no biggie
function robloxLock(obj)
    local function lock(nobj)
        for i, v in pairs(nobj:children()) do
            v.RobloxLocked=true;
            lock(v);
        end
    end
    obj.RobloxLocked=true;
    lock(obj);
end

-- This is a sort of Locally Persistent Data set-up.
-- UserSettings() stores all of its data locally and it is persistent, so I exploited this to create locally persistent data
rd_clbcks={};
RbxData={};

-- nam = name of value, cs = type of value, val = value of value; this creates or overrides data, it returns nothing
RbxData.SetValue=function(nam, cs, val)
    local defVals={String=""; Int=0; Number=0; Bool=false; Object=nil}
    if cs == nil or defVals[cs] == val then
        if RbxData.GetValue(nam) ~= nil then
            UserSettings()[nam].Parent = nil
            for i, v in pairs(rd_clbcks) do v(nam) end
            return
        elseif RbxData.GetValue(nam) == nil then
            for i, v in pairs(rd_clbcks) do v(nam) end
            return 
        end
    end;
    local valo;
    if RbxData.GetValue(nam) == nil then
        valo=Instance.new(cs .. "Value", UserSettings());
        valo.Name = nam;
    else
        valo=UserSettings()[nam];
    end
    valo.Value = val;
    for i, v in pairs(rd_clbcks) do v(nam) end
end;

-- this finds the data and returns it
RbxData.GetValue=function(nam)
    return UserSettings():FindFirstChild(nam) and UserSettings()[nam].Value or nil;
end;

-- in case you want to know when your data changes
RbxData.AddChangeCallback=function(fn)
    if type(fn) ~= "function" then return end;
    getfenv(fn).disconnect = function() for i, v in pairs(rb_clbcks) do if v == fn then table.remove(rb_clbcks, i) end end end;
    rd_clbcks[#rd_clbcks+1]=fn;
end

-- set up the UI base so that stuff can be put in it
local uiBase = Instance.new("ScreenGui");
uiBase.Name = "RPUI";
uiBase.Parent = game.CoreGui;

-- btnShield is so I can capture the mouse when people are interacting with the menu and they want to "click out" of it
local btnShield=Instance.new("TextButton");
btnShield.Name = "UIShield";
btnShield.Size = UDim2.new(2, 0, 2, 0);
btnShield.Position = UDim2.new(-0.5, 0, -0.5, 0);
btnShield.BackgroundTransparency = 1;
btnShield.TextTransparency = 1;
btnShield.Visible = false;
btnShield.Parent = uiBase;

-- create threads for these files
coroutine.resume(coroutine.create(function() dofile("rbxasset://rpui//cjoin.lua") end));
coroutine.resume(coroutine.create(function() dofile("rbxasset://rpui//rptp.lua") end));
coroutine.resume(coroutine.create(function() dofile("rbxasset://rpui//menu.lua") end));

-- we don't want the default UI getting in our way
game.CoreGui.RobloxGui.Parent = nil;

-- that robloxLock function we defined up there came in handy, huh? :P
-- it's to prevent people from changing my UI unauthorized, because the RBXPri client had little to no security
robloxLock(uiBase);
uiBase.AncestryChanged:connect(function()robloxLock(uiBase)end)
uiBase.DescendantAdded:connect(function()robloxLock(uiBase)end)
uiBase.DescendantRemoving:connect(function()robloxLock(uiBase)end)

-- It was neat for me to have showVersion at the top so I didn't have to waste energy scrolling all the way down here
if showVersion then
    local versionLabel = Instance.new("TextLabel");
    versionLabel.Text = versionString;
    versionLabel.Name = "VersionLabel";
    versionLabel.Size = UDim2.new(0, 420, 0, 20);
    versionLabel.Position = UDim2.new(0, 15, 1, -35);
    versionLabel.BackgroundTransparency = 1;
    versionLabel.Font = "Arial";
    versionLabel.FontSize = "Size24";
    versionLabel.TextXAlignment = "Left";
    versionLabel.TextTransparency = 0.5;
    versionLabel.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    versionLabel.ZIndex = 10;
    local versionLabelShadow = versionLabel:Clone();
    versionLabelShadow.Name = "VersionLabelShadow";
    versionLabelShadow.TextColor3 = Color3.new(0, 0, 0);
    versionLabelShadow.TextTransparency = 0.9;
    versionLabelShadow.Position = UDim2.new(0, 2, 0, 2);
    versionLabelShadow.Parent = versionLabel;
    versionLabel.Parent = uiBase;
    versionLabelShadow.ZIndex = 9;
    
    -- aesthetics were always important to me
    versionLabel.MouseEnter:connect(function()
        versionLabel.TextTransparency = 0.1;
        versionLabelShadow.TextTransparency = 0.6;
    end)
    versionLabel.MouseLeave:connect(function()
        versionLabel.TextTransparency = 0.5;
        versionLabelShadow.TextTransparency = 0.9;
    end)
end
