-- =====================================================
--  DocumentationHandler – Custom Commands for IY Library
--  Load this AFTER the main Infinite Yield library.
-- =====================================================

-- Wait for the library to be ready
repeat task.wait() until _G.IY_LOADED

-- (Optional) Clear premade commands if you want a fresh start
if _G.CMDs then
    _G.CMDs = {}
    if _G.refreshCmds then _G.refreshCmds() end
end

-- Build your own command system
local MyCommands = {}

function MyCommands:Register(name, desc, fn)
    if not _G.CMDs then _G.CMDs = {} end
    table.insert(_G.CMDs, {
        NAME = name,
        DESC = desc,
        Function = function(args, speaker)
            local success, err = pcall(fn, args, speaker)
            if not success then warn("Command error: ", err) end
        end
    })
    if _G.refreshCmds then _G.refreshCmds() end
end

-- Safe wrappers for internal functions
function MyCommands:GetPlayer(input, speaker)
    return (_G.getPlayer and _G.getPlayer(input, speaker)) or {}
end

function MyCommands:Notify(title, msg, duration)
    return (_G.notify and _G.notify(title, msg, duration)) or print(title, msg)
end

function MyCommands:Bind(cmd, key)
    return (_G.addbind and _G.addbind(cmd, key)) or warn("Bind not available")
end

-- ========== YOUR CUSTOM COMMANDS ==========

-- 1. Hello command (greet someone)
MyCommands:Register("hello [player]", "Say hello to someone", function(args, speaker)
    local target = args[1] or speaker.Name
    local players = MyCommands:GetPlayer(target, speaker)
    for _, plr in ipairs(players) do
        MyCommands:Notify("Hello!", "Hello " .. plr.Name .. " from " .. speaker.Name)
    end
end)

-- 2. Your original kick command
MyCommands:Register("mycmd", "Kick yourself (lazy way)", function(args, speaker)
    print("Executed by", speaker.Name, "with args:", table.concat(args, " "))
    game.Players.LocalPlayer:Kick()
end)

-- 3. Teleport to a player (example)
MyCommands:Register("tp [player]", "Teleport to a player", function(args, speaker)
    local target = args[1]
    if not target then
        MyCommands:Notify("Usage", ":tp <player>")
        return
    end
    local players = MyCommands:GetPlayer(target, speaker)
    if #players == 0 then
        MyCommands:Notify("Error", "Player not found")
        return
    end
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = players[1].Character and players[1].Character.HumanoidRootPart.CFrame or CFrame.new(0, 10, 0)
    end
end)

-- 4. Give a tool (example)
MyCommands:Register("give [toolname]", "Give yourself a tool by name", function(args, speaker)
    local toolName = args[1]
    if not toolName then
        MyCommands:Notify("Usage", ":give <toolname>")
        return
    end
    local tool = game:GetService("ReplicatedStorage"):FindFirstChild(toolName) or 
                 game:GetService("Workspace"):FindFirstChild(toolName)
    if tool then
        local clone = tool:Clone()
        clone.Parent = game.Players.LocalPlayer.Backpack
        MyCommands:Notify("Gave", toolName)
    else
        MyCommands:Notify("Error", "Tool not found")
    end
end)

print("✅ Custom commands loaded! Use ;hello, ;mycmd, ;tp, ;give")
