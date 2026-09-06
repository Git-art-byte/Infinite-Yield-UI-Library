# Infinite Yield UI Library
```lua
local IY = loadstring(game:HttpGet('https://raw.githubusercontent.com/Git-art-byte/Infinite-Yield-UI-Library/refs/heads/main/source.Luau'))()
repeat task.wait() until _G.IY_LOADED  
```
## Remove Premade CMDs(optional)
```lua
if _G.CMDs then
    _G.CMDs = {}          -- clear the command table
    if _G.refreshCmds then
        _G.refreshCmds()  -- refresh the UI to show an empty list
    end
end
```
# Custom Commands
```lua
local MyCommandLib = {}

function MyCommandLib:Register(cmdName, description, func)
    if not _G.CMDs then _G.CMDs = {} end
    table.insert(_G.CMDs, {
        NAME = cmdName,
        DESC = description,
        Function = function(args, speaker)
            return func(args, speaker)
        end
    })
    if _G.refreshCmds then _G.refreshCmds() end
end

function MyCommandLib:GetPlayer(input, speaker)
    return _G.getPlayer and _G.getPlayer(input, speaker) or {}
end

function MyCommandLib:Notify(title, msg)
    return _G.notify and _G.notify(title, msg)
end

function MyCommandLib:Bind(cmd, key)
    return _G.addbind and _G.addbind(cmd, key)
end

MyCommandLib:Register("hello [player]", "Say hello to someone", function(args, speaker)
    local target = args[1] or speaker.Name
    local players = MyCommandLib:GetPlayer(target, speaker)
    for _, plr in ipairs(players) do
        MyCommandLib:Notify("Hello!", "Hello " .. plr.Name .. " from " .. speaker.Name)
    end
end)

MyCommandLib:Register("mycmd", "My custom command", function(args, speaker)
    print("Executed by", speaker.Name, "with args:", table.concat(args, " "))
    game.Players.LocalPlayer:Kick()
end)

print("Use ;hello or ;mycmd")
```
