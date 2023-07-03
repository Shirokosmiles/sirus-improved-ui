local DF = LibStub('AceAddon-3.0'):GetAddon('Sirus_ImprovedUI')
local mName = 'Unitframe'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local noop = function() end

local defaults = {
    profile = {
        scale = 1,
        focus = {
            classcolor = false,
            scale = 1.0,
            override = false,
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = 250,
            y = -170
        },
        player = {
            classcolor = false,
            scale = 1.0,
            override = false,
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = -19,
            y = -4
        },
        target = {
            classcolor = false,
            scale = 1.0,
            override = false,
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = 250,
            y = -4
        }
    }
}

local defaultsPROTO = {
    classcolor = false,
    scale = 1.0,
    override = false,
    anchor = 'TOPLEFT',
    anchorParent = 'TOPLEFT',
    x = -19,
    y = -4
}

local localSettings = {
    scale = 1,
    focus = {
        scale = 1.0,
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = 250,
        y = -170
    },
    player = {
        scale = 1.0,
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = -19,
        y = -4
    },
    target = {
        scale = 1.0,
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = 250,
        y = -4
    }
}

local function getDefaultStr(key, sub)
    --print('default str', sub, key)
    if sub then
        local obj = defaults.profile[sub]
        local value = obj[key]
        return '\n' .. '(Default: ' .. tostring(value) .. ')'
    else
        local obj = defaults.profile
        local value = obj[key]
        return '\n' .. '(Default: ' .. tostring(defaults.profile[key]) .. ')'
    end
end

local function setDefaultValues()
    for k, v in pairs(defaults.profile) do
        if type(v) == 'table' then
            local obj = Module.db.profile[k]
            for kSub, vSub in pairs(v) do
                obj[kSub] = vSub
            end
        else
            Module.db.profile[k] = v
        end
    end
    Module.ApplySettings()
end

-- db[info[#info] = VALUE
local function getOption(info)
    local key = info[1]
    local sub = info[2]
    --print('getOption', key, sub)
    --print('db', db[key])

    if sub then
        --return db[key .. '.' .. sub]
        local t = Module.db.profile[key]
        return t[sub]
    else
        --return db[info[#info]]
        return db[key]
    end
end

local function setOption(info, value)
    local key = info[1]
    local sub = info[2]
    --print('setOption', key, sub)

    if sub then
        local t = Module.db.profile[key]
        t[sub] = value
        --Module.db.profile[key .. '.' .. sub] = value
        Module.ApplySettings()
    else
        Module.db.profile[key] = value
        Module.ApplySettings()
    end
end

local optionsPlayer = {
    name = 'Player',
    desc = 'PlayerframeDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        configGeneral = {
            type = 'header',
            name = 'General',
            order = 10
        },
        classcolor = {
            type = 'toggle',
            name = 'class color',
            desc = 'Enable classcolors for the healthbar',
            order = 10.1
        },
        configSize = {
            type = 'header',
            name = 'Size',
            order = 50
        },
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'player'),
            min = 0.1,
            max = 3,
            bigStep = 0.025,
            order = 50.1
        },
        configPos = {
            type = 'header',
            name = 'Position',
            order = 100
        },
        override = {
            type = 'toggle',
            name = 'Override',
            desc = 'Override positions',
            order = 101,
            width = 'full'
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'player'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'player'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105.1
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 107
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 108
        }
    }
}

local optionsTarget = {
    name = 'Target',
    desc = 'TargetFrameDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        configGeneral = {
            type = 'header',
            name = 'General',
            order = 10
        },
        classcolor = {
            type = 'toggle',
            name = 'class color',
            desc = 'Enable classcolors for the healthbar',
            order = 10.1
        },
        configSize = {
            type = 'header',
            name = 'Size',
            order = 50
        },
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'target'),
            min = 0.1,
            max = 3,
            bigStep = 0.025,
            order = 50.1
        },
        configPos = {
            type = 'header',
            name = 'Position',
            order = 100
        },
        override = {
            type = 'toggle',
            name = 'Override',
            desc = 'Override positions',
            order = 101,
            width = 'full'
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'target'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'target'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105.1
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 107
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 108
        }
    }
}

local optionsFocus = {
    name = 'Focus',
    desc = 'FocusFrameDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        configGeneral = {
            type = 'header',
            name = 'General',
            order = 10
        },
        classcolor = {
            type = 'toggle',
            name = 'class color',
            desc = 'Enable classcolors for the healthbar',
            order = 10.1
        },
        configSize = {
            type = 'header',
            name = 'Size',
            order = 50
        },
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'focus'),
            min = 0.1,
            max = 3,
            bigStep = 0.025,
            order = 50.1
        },
        configPos = {
            type = 'header',
            name = 'Position',
            order = 100
        },
        override = {
            type = 'toggle',
            name = 'Override',
            desc = 'Override positions',
            order = 101,
            width = 'full'
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'focus'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'focus'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 105.1
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 107
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 108
        }
    }
}

local options = {
    type = 'group',
    name = 'Sirus: Improved UI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        focus = optionsFocus,
        player = optionsPlayer,
        target = optionsTarget
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    db = self.db.profile

    self:SetEnabledState(DF:GetModuleEnabled(mName))
    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')

    Module.Wrath()
    Module:SaveLocalSettings()
    Module:ApplySettings()
end

function Module:OnDisable()
end

function Module:SaveLocalSettings()
    -- playerframe
    do
        local scale = PlayerFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = PlayerFrame:GetPoint(1)
        --print('PlayerFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.player
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end
    -- targetframe
    do
        local scale = TargetFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = TargetFrame:GetPoint(1)
        --print('TargetFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.target
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end
    -- focusframe
    do
        local scale = FocusFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = FocusFrame:GetPoint(1)
        --print('FocusFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.focus
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end

    --DevTools_Dump({localSettings})
end

function Module:ApplySettings()
    db = Module.db.profile
    local orig = defaults.profile

    -- playerframe
    do
        local obj = db.player
        local objLocal = localSettings.player
        if obj.override then
            Module.MovePlayerFrame(obj.anchor, obj.anchorParent, obj.x, obj.y)
            PlayerFrame:SetUserPlaced(true)
        else
            Module.MovePlayerFrame(objLocal.anchor, objLocal.anchorParent, objLocal.x, objLocal.y)
        end
        PlayerFrame:SetScale(obj.scale)
        Module.ChangePlayerframe()
    end

    -- target
    do
        local obj = db.target
        local objLocal = localSettings.target
        if obj.override then
            Module.MoveTargetFrame(obj.anchor, obj.anchorParent, obj.x, obj.y)
            TargetFrame:SetUserPlaced(true)
        else
            Module.MoveTargetFrame(objLocal.anchor, objLocal.anchorParent, objLocal.x, objLocal.y)
        end
        TargetFrame:SetScale(obj.scale)
        Module.ReApplyTargetFrame()
    end

    -- focus
    do
        local obj = db.focus
        local objLocal = localSettings.focus
        if obj.override then
            Module.MoveFocusFrame(obj.anchor, obj.anchorParent, obj.x, obj.y)
            FocusFrame:SetUserPlaced(true)
        else
            Module.MoveFocusFrame(objLocal.anchor, objLocal.anchorParent, objLocal.x, objLocal.y)
        end
        FocusFrame:SetScale(obj.scale)
        Module.ReApplyFocusFrame()
    end
end

function Module.MovePlayerTargetPreset(name)
    db = Module.db.profile

    if name == 'DEFAULT' then
        local orig = defaults.profile

        db.playerOverride = false
        db.playerAnchor = orig.playerAnchor
        db.playerAnchorParent = orig.playerAnchorParent
        db.playerX = orig.playerX
        db.playerY = orig.playerY

        db.targetOverride = false
        db.targetAnchor = orig.targetAnchor
        db.targetAnchorParent = orig.targetAnchorParent
        db.targetX = orig.targetX
        db.targetY = orig.targetY

        Module.ApplySettings()
    elseif name == 'CENTER' then
        local deltaX = 50
        local deltaY = 180

        db.playerOverride = true
        db.playerAnchor = 'CENTER'
        db.playerAnchorParent = 'CENTER'
        -- player and target frame center is not perfect/identical
        db.playerX = -107.5 - deltaX
        db.playerY = -deltaY

        db.targetOverride = true
        db.targetAnchor = 'CENTER'
        db.targetAnchorParent = 'CENTER'
        -- see above
        db.targetX = 112 + deltaX
        db.targetY = -deltaY

        Module.ApplySettings()
    end
end

local frame = CreateFrame('FRAME', 'ImprovedUIUnitframeFrame', UIParent)

function Module.GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-UnitFrame-Player-Absorb-Edge'] = {8, 32, 0.984375, 0.9921875, 0.001953125, 0.064453125, false, false},
        ['UI-HUD-UnitFrame-Player-CombatIcon'] = {
            16,
            16,
            0.9775390625,
            0.9931640625,
            0.259765625,
            0.291015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-CombatIcon-Glow'] = {
            32,
            32,
            0.1494140625,
            0.1806640625,
            0.8203125,
            0.8828125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-FriendOnlineIcon'] = {
            16,
            16,
            0.162109375,
            0.177734375,
            0.716796875,
            0.748046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-GuideIcon'] = {
            16,
            16,
            0.162109375,
            0.177734375,
            0.751953125,
            0.783203125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-LeaderIcon'] = {
            16,
            16,
            0.1259765625,
            0.1416015625,
            0.919921875,
            0.951171875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-GroupIndicator'] = {
            71,
            13,
            0.927734375,
            0.9970703125,
            0.3125,
            0.337890625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PlayTimeTired'] = {29, 29, 0.1904296875, 0.21875, 0.505859375, 0.5625, false, false},
        ['UI-HUD-UnitFrame-Player-PlayTimeUnhealthy'] = {
            29,
            29,
            0.1904296875,
            0.21875,
            0.56640625,
            0.623046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff'] = {
            133,
            51,
            0.0009765625,
            0.130859375,
            0.716796875,
            0.81640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy'] = {
            124,
            10,
            0.6708984375,
            0.7919921875,
            0.35546875,
            0.375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus'] = {
            124,
            10,
            0.6708984375,
            0.7919921875,
            0.37890625,
            0.3984375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'] = {
            126,
            23,
            0.0009765625,
            0.1240234375,
            0.919921875,
            0.96484375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status'] = {
            124,
            20,
            0.5478515625,
            0.6689453125,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana'] = {
            126,
            12,
            0.0009765625,
            0.1240234375,
            0.96875,
            0.9921875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage'] = {
            124,
            10,
            0.8203125,
            0.94140625,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower'] = {
            124,
            10,
            0.1904296875,
            0.3115234375,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn'] = {198, 71, 0.7890625, 0.982421875, 0.001953125, 0.140625, false, false},
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy'] = {
            124,
            10,
            0.3134765625,
            0.4345703125,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus'] = {
            124,
            10,
            0.4365234375,
            0.5576171875,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'] = {
            124,
            20,
            0.5478515625,
            0.6689453125,
            0.35546875,
            0.39453125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'] = {
            124,
            20,
            0.6708984375,
            0.7919921875,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana'] = {
            124,
            10,
            0.5595703125,
            0.6806640625,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status'] = {
            124,
            10,
            0.6826171875,
            0.8037109375,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage'] = {
            124,
            10,
            0.8056640625,
            0.9267578125,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower'] = {
            124,
            10,
            0.1904296875,
            0.3115234375,
            0.482421875,
            0.501953125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'] = {
            23,
            23,
            0.953125,
            0.9755859375,
            0.259765625,
            0.3046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-InCombat'] = {
            192,
            71,
            0.1943359375,
            0.3818359375,
            0.169921875,
            0.30859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Status'] = {
            196,
            71,
            0.0009765625,
            0.1923828125,
            0.169921875,
            0.30859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle'] = {
            202,
            84,
            0.0009765625,
            0.1982421875,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-InCombat'] = {
            198,
            84,
            0.3984375,
            0.591796875,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-Status'] = {
            201,
            84,
            0.2001953125,
            0.396484375,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-AllianceIcon'] = {
            28,
            41,
            0.1201171875,
            0.1474609375,
            0.8203125,
            0.900390625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-FFAIcon'] = {
            28,
            44,
            0.1328125,
            0.16015625,
            0.716796875,
            0.802734375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-HordeIcon'] = {
            44,
            44,
            0.953125,
            0.99609375,
            0.169921875,
            0.255859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-HighLevelTarget_Icon'] = {
            11,
            14,
            0.984375,
            0.9951171875,
            0.068359375,
            0.095703125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn'] = {
            192,
            67,
            0.57421875,
            0.76171875,
            0.169921875,
            0.30078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Energy'] = {
            127,
            10,
            0.8544921875,
            0.978515625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Focus'] = {
            127,
            10,
            0.1904296875,
            0.314453125,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health'] = {
            125,
            12,
            0.7939453125,
            0.916015625,
            0.3515625,
            0.375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status'] = {
            125,
            12,
            0.7939453125,
            0.916015625,
            0.37890625,
            0.40234375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana'] = {
            127,
            10,
            0.31640625,
            0.4404296875,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana-Status'] = {
            127,
            10,
            0.4423828125,
            0.56640625,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Rage'] = {
            127,
            10,
            0.568359375,
            0.6923828125,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-RunicPower'] = {
            127,
            10,
            0.6943359375,
            0.818359375,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-InCombat'] = {
            188,
            67,
            0.0009765625,
            0.1845703125,
            0.447265625,
            0.578125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Status'] = {
            193,
            69,
            0.3837890625,
            0.572265625,
            0.169921875,
            0.3046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn'] = {
            192,
            67,
            0.763671875,
            0.951171875,
            0.169921875,
            0.30078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'] = {
            134,
            10,
            0.7890625,
            0.919921875,
            0.14453125,
            0.1640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'] = {
            134,
            10,
            0.1904296875,
            0.3212890625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'] = {
            126,
            20,
            0.4228515625,
            0.5458984375,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'] = {
            126,
            20,
            0.4228515625,
            0.5458984375,
            0.35546875,
            0.39453125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'] = {
            134,
            10,
            0.3232421875,
            0.4541015625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status'] = {
            134,
            10,
            0.4560546875,
            0.5869140625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'] = {
            134,
            10,
            0.5888671875,
            0.7197265625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'] = {
            134,
            10,
            0.7216796875,
            0.8525390625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-InCombat'] = {
            188,
            67,
            0.0009765625,
            0.1845703125,
            0.58203125,
            0.712890625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Type'] = {
            135,
            18,
            0.7939453125,
            0.92578125,
            0.3125,
            0.34765625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Vehicle'] = {
            198,
            81,
            0.59375,
            0.787109375,
            0.001953125,
            0.16015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-Rare-PortraitOn'] = {
            192,
            67,
            0.0009765625,
            0.1884765625,
            0.3125,
            0.443359375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn'] = {
            120,
            49,
            0.0009765625,
            0.1181640625,
            0.8203125,
            0.916015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'] = {
            74,
            7,
            0.91796875,
            0.990234375,
            0.37890625,
            0.392578125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus'] = {
            74,
            7,
            0.3134765625,
            0.3857421875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'] = {
            70,
            10,
            0.921875,
            0.990234375,
            0.14453125,
            0.1640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status'] = {
            70,
            10,
            0.91796875,
            0.986328125,
            0.3515625,
            0.37109375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'] = {
            74,
            7,
            0.3876953125,
            0.4599609375,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana-Status'] = {
            74,
            7,
            0.4619140625,
            0.5341796875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'] = {
            74,
            7,
            0.5361328125,
            0.6083984375,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'] = {
            74,
            7,
            0.6103515625,
            0.6826171875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-InCombat'] = {
            114,
            47,
            0.3095703125,
            0.4208984375,
            0.3125,
            0.404296875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Status'] = {
            120,
            49,
            0.1904296875,
            0.3076171875,
            0.3125,
            0.408203125,
            false,
            false
        }
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

function Module.CreatePlayerFrameTextures()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    if not frame.PlayerFrameBackground then
        local background = PlayerFrame:CreateTexture('ImprovedUIPlayerFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)

        background:SetTexture(base)
        background:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
        background:SetSize(198, 71)
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0)
        frame.PlayerFrameBackground = background
    end

    if not frame.PlayerFrameBorder then
        local border = PlayerFrameHealthBar:CreateTexture('ImprovedUIPlayerFrameBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER')
        border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)
        frame.PlayerFrameBorder = border
    end

    if not frame.PlayerFrameDeco then
        local textureSmall = PlayerFrame:CreateTexture('ImprovedUIPlayerFrameDeco')
        textureSmall:SetDrawLayer('OVERLAY', 5)
        textureSmall:SetTexture(base)
        textureSmall:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'))
        local delta = 15
        textureSmall:SetPoint('CENTER', PlayerPortrait, 'CENTER', delta, -delta - 2)
        textureSmall:SetSize(23, 23)
        frame.PlayerFrameDeco = textureSmall
    end
end

local function ReApplyPvPIcon(unitFrame, pvpIcon, offsetX, offsetY)
    if pvpIcon ~= nil then
        if pvpIcon.SetDrawLayer ~= nil then
            pvpIcon:SetDrawLayer("OVERLAY", 2)
        else
            pvpIcon:SetFrameLevel(32)
        end
        pvpIcon:ClearAllPoints()
        if pvpIcon.SetDrawLayer ~= nil then
            pvpIcon:SetPoint('CENTER', unitFrame.portrait, 'CENTER', offsetX, offsetY)
        else
            pvpIcon:SetPoint('CENTER', unitFrame.portrait, 'CENTER', offsetX, offsetY)
        end
    end
end

local function ReApplyPvPIcons(unitFrame, pvpOffsetX, pvpOffsetY, rankedOffsetX, rankedOffsetY, renegadeOffsetX, renegadeOffsetY)
    ReApplyPvPIcon(unitFrame, unitFrame.pvpIcon, pvpOffsetX, pvpOffsetY)
    ReApplyPvPIcon(unitFrame, unitFrame.TextureFrame.RankFrame, rankedOffsetX, rankedOffsetY)
    ReApplyPvPIcon(unitFrame, unitFrame.renegadeIcon, renegadeOffsetX, renegadeOffsetY)
    if unitFrame.TextureFrame.RankFrame ~= nil then
        unitFrame.TextureFrame.RankFrame:SetFrameLevel(unitFrame.TextureFrame:GetFrameLevel() + 1)
    end
end

function Module.MoveAttackIcon()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    PlayerAttackIcon:SetTexture(base)
    PlayerAttackBackground:SetTexture(base)

    PlayerAttackIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon'))
    PlayerAttackBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon-Glow'))

    PlayerAttackIcon:ClearAllPoints()
    PlayerAttackBackground:ClearAllPoints()

    PlayerAttackIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -3, 0)
    PlayerAttackBackground:SetPoint('CENTER', PlayerAttackIcon, 'CENTER')

    PlayerAttackIcon:SetSize(16, 16)
    PlayerAttackBackground:SetSize(32, 32)
end

function Module.HookDrag()
    local DragStopPlayerFrame = function(self)
        Module.SaveLocalSettings()

        for k, v in pairs(localSettings.player) do
            Module.db.profile.player[k] = v
        end
        Module.db.profile.player.override = false
    end
    PlayerFrame:HookScript('OnDragStop', DragStopPlayerFrame)
    hooksecurefunc('PlayerFrame_ResetUserPlacedPosition', DragStopPlayerFrame)

    local DragStopTargetFrame = function(self)
        Module.SaveLocalSettings()

        for k, v in pairs(localSettings.target) do
            Module.db.profile.target[k] = v
        end
        Module.db.profile.target.override = false
    end
    TargetFrame:HookScript('OnDragStop', DragStopTargetFrame)
    hooksecurefunc('TargetFrame_ResetUserPlacedPosition', DragStopTargetFrame)

    local DragStopFocusFrame = function(self)
        Module.SaveLocalSettings()

        for k, v in pairs(localSettings.focus) do
            Module.db.profile.focus[k] = v
        end
        Module.db.profile.focus.override = false
    end
    FocusFrame:HookScript('OnDragStop', DragStopFocusFrame)
    --hooksecurefunc('FocusFrame_ResetUserPlacedPosition', DragStopFocusFrame)
end

function Module.HookVertexColor()
    PlayerFrameHealthBar:HookScript(
        'OnValueChanged',
        function(self)
            if Module.db.profile.player.classcolor then
                PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'
                )

                local localizedClass, englishClass, classIndex = UnitClass('player')
                PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
            else
                PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'
                )
                PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
            end
        end
    )

    TargetFrameHealthBar:HookScript(
        'OnValueChanged',
        function(self)
            if Module.db.profile.target.classcolor and UnitIsPlayer('target') then
                TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'
                )
                local localizedClass, englishClass, classIndex = UnitClass('target')
                TargetFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
            else
                TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
                )
                TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
            end
        end
    )

    FocusFrameHealthBar:HookScript(
        'OnValueChanged',
        function(self)
            if Module.db.profile.focus.classcolor and UnitIsPlayer('focus') then
                FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'
                )
                local localizedClass, englishClass, classIndex = UnitClass('focus')
                FocusFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
            else
                FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
                )
                FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
            end
        end
    )
end

function Module.ChangePlayerframe()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    PlayerFrameTexture:Hide()
    PlayerFrameBackground:Hide()
    PlayerFrameVehicleTexture:Hide()

    PlayerFrameFlash:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-InCombat')
    PlayerFrameFlash:SetTexCoord(-18/256, 220/256, -4/128, 83/128)
    PlayerFrameFlash:SetVertexColor(1.0, 0, 0, 1.0)
    PlayerFrameFlash:SetBlendMode('ADD')

    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 42, -15)
    PlayerPortrait:SetDrawLayer('ARTWORK', 5)
    PlayerPortrait:SetSize(56, 56)

    -- @TODO: change text spacing
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint('BOTTOMLEFT', PlayerFrameHealthBar, 'TOPLEFT', 0, 1)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', -5, 1)

    -- Health 119,12
    PlayerFrameHealthBar:SetSize(125, 20)
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, 0)

    if Module.db.profile.player.classcolor then
        PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'
        )

        local localizedClass, englishClass, classIndex = UnitClass('player')
        PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'
        )
        PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    local dx = 5
    PlayerFrameHealthBarTextLeft:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', dx, 0)
    PlayerFrameHealthBarTextRight:SetPoint('RIGHT', PlayerFrameHealthBar, 'RIGHT', -dx, 0)

    -- Mana 119,12
    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, -17 + 0.5)
    PlayerFrameManaBar:SetSize(125, 8)

    PlayerFrameManaBarText:SetPoint('CENTER', PlayerFrameManaBar, 'CENTER', 0, 0)
    PlayerFrameManaBarTextLeft:SetPoint('LEFT', PlayerFrameManaBar, 'LEFT', dx, 0)
    PlayerFrameManaBarTextRight:SetPoint('RIGHT', PlayerFrameManaBar, 'RIGHT', -dx, 0)

    local powerType, powerTypeString = UnitPowerType('player')

    if powerTypeString == 'MANA' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana'
        )
    elseif powerTypeString == 'RAGE' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'FOCUS' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus'
        )
    elseif powerTypeString == 'ENERGY' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower'
        )
    end

    PlayerFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    --UI-HUD-UnitFrame-Player-PortraitOn-Status
    PlayerStatusTexture:SetTexture(base)
    PlayerStatusTexture:SetSize(192, 71)
    PlayerStatusTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-InCombat'))

    PlayerStatusTexture:ClearAllPoints()
    PlayerStatusTexture:SetPoint('TOPLEFT', frame.PlayerFrameBorder, 'TOPLEFT', 1, 1)
end
--ChangePlayerframe()
--frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function Module.UpdatePlayerStatus()
    if not frame.PlayerFrameDeco then
        return
    end

    -- TODO: fix statusglow
    PlayerStatusGlow:Hide()

    if not frame.RestIcon then
        Module.CreateRestFlipbook()
    end

    if UnitHasVehiclePlayerFrameUI and UnitHasVehiclePlayerFrameUI('player') then
        -- TODO: vehicle stuff
        --frame.PlayerFrameDeco:Show()
    elseif IsResting() then
        frame.PlayerFrameDeco:Show()
        frame.PlayerFrameBorder:SetVertexColor(1.0, 1.0, 1.0, 1.0)

        frame.RestIcon:Show()
        frame.RestIconAnimation:Play()

        --PlayerStatusTexture:Show()
        --PlayerStatusTexture:SetVertexColor(1.0, 0.88, 0.25, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    elseif PlayerFrame.onHateList then
        --PlayerStatusTexture:Show()
        --PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        frame.PlayerFrameDeco:Hide()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBorder:SetVertexColor(1.0, 0, 0, 1.0)
        frame.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)
    elseif PlayerFrame.inCombat then
        frame.PlayerFrameDeco:Hide()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)

        --PlayerStatusTexture:Show()
        --PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    else
        frame.PlayerFrameDeco:Show()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBorder:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        frame.PlayerFrameBackground:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    end
end

function Module.HookPlayerStatus()
    --[[ PlayerFrame:HookScript(
        'OnUpdate',
        function(self)
            if PlayerStatusTexture:IsShown() and Module.onHateList == 1 and Module.inCombat ~= 1 then
                PlayerStatusTexture:SetAlpha(1.0)
            end
        end
    ) ]]
    local UpdatePvPStatus = function()
        ReApplyPvPIcon(PlayerFrame, PlayerPVPIcon, -15, -30)
        ReApplyPvPIcon(PlayerFrame, RatedBattlegroundRankFrame, -25, -20)
        ReApplyPvPIcon(PlayerFrame, PlayerRenegadeIcon, -25, -20)
        if RatedBattlegroundRankFrame ~= nil then
            RatedBattlegroundRankFrame:SetFrameLevel(PVPIconFrame:GetFrameLevel() + 1)
        end
    end
    hooksecurefunc('PlayerFrame_UpdateStatus', Module.UpdatePlayerStatus)
    hooksecurefunc('PlayerFrame_UpdatePvPStatus', UpdatePvPStatus)
end

function Module.HookTargetFaction()
    local OnUpdateTargetFaction = function()
        ReApplyPvPIcons(TargetFrame, 30, -30, 20, -20, 20, -20)
    end
    hooksecurefunc('TargetFrame_CheckFaction', OnUpdateTargetFaction)
end

function Module.ApplyRunesTextures()
    for i = 1, 6 do
        local rune = _G['RuneButtonIndividual' .. i].rune
        if rune.runeType == 1 then
            rune:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Runes\\UI-PlayerFrame-Deathknight-Blood')
        elseif rune.runeType == 2 then
            rune:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Runes\\UI-PlayerFrame-Deathknight-Unholy')
        elseif rune.runeType == 3 then
            rune:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Runes\\UI-PlayerFrame-Deathknight-Frost')
        elseif rune.runeType == 4 then
            rune:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Runes\\UI-PlayerFrame-Deathknight-Death')
        end
       _G['RuneButtonIndividual' .. i]:SetScale(0.9)
       _G['RuneButtonIndividual' .. i .. 'Border']:SetScale(1.05)
       _G['RuneButtonIndividual' .. i .. 'BorderTexture']:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Runes\\UI-PlayerFrame-Deathknight-Ring')
       _G['RuneButtonIndividual' .. i .. 'BorderTexture']:SetVertexColor(1, 1, 1, 1)
       _G['RuneButtonIndividual' .. i .. 'Cooldown']:SetScale(1.06)
       _G['RuneButtonIndividual' .. i .. 'Cooldown']:SetPoint('CENTER', _G['RuneButtonIndividual' .. i], 'CENTER', -0.6, -1)
       if i >= 2 then
          _G['RuneButtonIndividual' .. i]:SetPoint('LEFT', _G['RuneButtonIndividual' .. i - 1], 'RIGHT', 5.5, 0)
       end
    end
end

function Module.HookRunes()
    local ReapplyRunes = function(self, unit, healthbar, manabar)
        if (self == PlayerFrame or self == PetFrame) and unit == "player" then
            local _, class = UnitClass("player")
            if class == "DEATHKNIGHT" then
                RuneFrame:SetFrameLevel(32)
                RuneFrame:ClearAllPoints()
                RuneFrame:SetPoint("TOP", self, "BOTTOM", 50, 32)
            end
        end
    end
    hooksecurefunc('RuneButton_Update', Module.ApplyRunesTextures)
    hooksecurefunc('UnitFrame_SetUnit', ReapplyRunes)
end

function Module.MovePlayerFrame(anchor, anchorOther, dx, dy)
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint(anchor, UIParent, anchorOther, dx, dy)
end

function Module.ChangeTargetFrame()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameBackground:Hide()

    if not frame.TargetFrameBackground then
        local background = TargetFrame:CreateTexture('ImprovedUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBackground = background
    end

    if not frame.TargetFrameBorder then
        local border = TargetFrame:CreateTexture('ImprovedUITargetFrameBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBorder = border
    end

    TargetFramePortrait:SetDrawLayer('ARTWORK', 1)
    TargetFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    TargetFramePortrait:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    --TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 5, 0)

    -- @TODO: change text spacing
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint('BOTTOM', TargetFrameHealthBar, 'TOP', 10, 3 - 2)

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    -- Health 119,12
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(125, 20)
    TargetFrameHealthBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, 0)
    TargetFrameHealthBar:SetFrameLevel(TargetFrame:GetFrameLevel())
    --[[     TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(132, 9)
    TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    TargetFrameManaBar:SetFrameLevel(TargetFrame:GetFrameLevel())
    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    TargetFrameNameBackground:SetTexture(base)
    TargetFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    TargetFrameNameBackground:SetSize(135, 18)
    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    local dx = 5
    -- health vs mana bar
    local deltaSize = 132 - 125

    TargetFrameTextureFrameHealthBarText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)
    TargetFrameTextureFrameHealthBarTextLeft:SetPoint('LEFT', TargetFrameHealthBar, 'LEFT', dx, 0)
    TargetFrameTextureFrameHealthBarTextRight:SetPoint('RIGHT', TargetFrameHealthBar, 'RIGHT', -dx, 0)

    TargetFrameTextureFrameManaBarText:SetPoint('CENTER', TargetFrameManaBar, 'CENTER', -deltaSize / 2, 0)
    TargetFrameTextureFrameManaBarTextLeft:SetPoint('LEFT', TargetFrameManaBar, 'LEFT', dx, 0)
    TargetFrameTextureFrameManaBarTextRight:SetPoint('RIGHT', TargetFrameManaBar, 'RIGHT', -deltaSize - dx, 0)

    TargetFrameFlash:SetTexture('')

    if not frame.TargetFrameFlash then
        local flash = TargetFrame:CreateTexture('ImprovedUITargetFrameFlash')
        flash:SetDrawLayer('BACKGROUND', 2)
        flash:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat'
        )
        flash:SetPoint('CENTER', TargetFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
        flash:SetSize(256, 128)
        flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        flash:SetBlendMode('ADD')
        frame.TargetFrameFlash = flash
    end

    hooksecurefunc(
        TargetFrameFlash,
        'Show',
        function()
            --print('show')
            TargetFrameFlash:SetTexture('')
            frame.TargetFrameFlash:Show()
            if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
            else
                --print('go flash')
                local dt = 0.5
                UIFrameFlash(frame.TargetFrameFlash, dt, dt, -1)
            end
        end
    )

    hooksecurefunc(
        TargetFrameFlash,
        'Hide',
        function()
            --print('hide')
            TargetFrameFlash:SetTexture('')
            if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
                UIFrameFlashStop(frame.TargetFrameFlash)
            end
            frame.TargetFrameFlash:Hide()
        end
    )

    if not frame.PortraitExtra then
        local extra = TargetFrame:CreateTexture('ImprovedUITargetFramePortraitExtra')
        extra:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('OVERLAY', 3)
        extra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('target')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(99, 81)
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            else
                frame.PortraitExtra:Hide()
            end
        end

        frame.PortraitExtra = extra
    end
end

function Module.ReApplyTargetFrame()
    if TargetFrameHeadHuntingWantedFrame ~= nil then
        TargetFrameHeadHuntingWantedFrame:ClearAllPoints()
        TargetFrameHeadHuntingWantedFrame:SetPoint('TOP', TargetFramePortrait, 'BOTTOM', -15, 16)
    end

    if Module.db.profile.target.classcolor and UnitIsPlayer('target') then
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'
        )
        local localizedClass, englishClass, classIndex = UnitClass('target')
        TargetFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
        )
        TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('target')
    local show = true
    if powerTypeString == 'MANA' then
        if not UnitHasMana or not UnitHasMana('target') then
            show = false
        else
            TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
            )
        end
    elseif powerTypeString == 'FOCUS' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'
        )
    elseif powerTypeString == 'RAGE' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'
        )
    end

    if show then
        TargetFrameManaBar:Show()
    else
        TargetFrameManaBar:Hide()
    end

    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
    TargetFrameFlash:SetTexture('')

    if frame.PortraitExtra then
        frame.PortraitExtra:UpdateStyle()
    end
end
--frame:RegisterEvent('PLAYER_TARGET_CHANGED')

function Module.MoveTargetFrame(anchor, anchorOther, dx, dy)
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint(anchor, UIParent, anchorOther, dx, dy)
end

function Module.UpdateTargetToTManaBarTextures()
    local powerType, powerTypeString = UnitPowerType('playertargettarget')
    local show = true
    if powerTypeString == 'MANA' then
        if not UnitHasMana or not UnitHasMana('playertargettarget') then
            show = false
        else
            frame.ToTManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
            )
        end
    elseif powerTypeString == 'FOCUS' then
        frame.ToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus'
        )
    elseif powerTypeString == 'RAGE' then
        frame.ToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        frame.ToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        frame.ToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'
        )
    end

    if show then
        frame.ToTManaBar:Show()
    else
        frame.ToTManaBar:Hide()
    end

    frame.ToTManaBar:SetStatusBarColor(1, 1, 1, 1)
end

function Module.ChangeToT()
    --TargetFrameToTTextureFrame:Hide()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35, -10 - 5)

    TargetFrameToTBackground:Hide()
    TargetFrameToTTextureFrameTexture:SetTexture('')
    --TargetFrameToTTextureFrameTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-TargetofTarget-PortraitOn'))

    if not frame.TargetFrameToTBackground then
        local background = TargetFrameToTTextureFrame:CreateTexture('ImprovedUITargetFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10)
        frame.TargetFrameToTBackground = background
    end

    if not frame.TargetFrameToTBorder then
        local border = TargetFrameToTHealthBar:CreateTexture('ImprovedUITargetFrameToTBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10)
        frame.TargetFrameToTBorder = border
    end

    TargetFrameToTHealthBar:ClearAllPoints()
    TargetFrameToTHealthBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 0)
    TargetFrameToTHealthBar:SetFrameLevel(TargetFrameToTTextureFrame:GetFrameLevel())
    TargetFrameToTHealthBar:SetSize(70.5, 10)

    TargetFrameToTManaBar:ClearAllPoints()
    TargetFrameToTManaBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
    TargetFrameToTManaBar:SetFrameLevel(TargetFrameToTTextureFrame:GetFrameLevel())
    TargetFrameToTManaBar:SetSize(74, 7.5)
    TargetFrameToTManaBar:Hide()

    if not frame.ToTManaBar then
        local f = CreateFrame('StatusBar', 'ImprovedUIToTManaBar', TargetFrameToT)
        f:SetSize(74, 7.5)
        f:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
        f:SetFrameLevel(TargetFrameToTTextureFrame:GetFrameLevel())
        f:SetStatusBarTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
        )
        f:SetStatusBarColor(1, 1, 1, 1)

        frame.ToTManaBar = f

        local UpdateManaBarValues = function(other)
            local value = other:GetValue()
            local statusMin, statusMax = other:GetMinMaxValues()

            frame.ToTManaBar:SetValue(value)
            frame.ToTManaBar:SetMinMaxValues(statusMin, statusMax)
        end

        --[[   hooksecurefunc(
            'TargetofTarget_Update',
            function()
                --print('TargetofTarget_Update')
            end
        ) ]]
        TargetFrame:HookScript(
            'OnShow',
            function(self)
                Module.UpdateTargetToTManaBarTextures()
            end
        )

        TargetFrameToTManaBar:HookScript(
            'OnShow',
            function(self)
                Module.UpdateTargetToTManaBarTextures()
            end
        )

        TargetFrameToTManaBar:HookScript(
            'OnValueChanged',
            function(self)
                TargetFrameToTManaBar:Hide()
                UpdateManaBarValues(self)
            end
        )
        TargetFrameToTManaBar:HookScript(
            'OnMinMaxChanged',
            function(self)
                TargetFrameToTManaBar:Hide()
                UpdateManaBarValues(self)
                Module.UpdateTargetToTManaBarTextures()
            end
        )
    end

    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)
end

function Module.ReApplyToT()
    if UnitExists('playertargettarget') then
        TargetFrameToT:SetFrameLevel(math.max(TargetFrameTextureFrame:GetFrameLevel(), TargetFrameTextureFrameRankFrame and TargetFrameTextureFrameRankFrame:GetFrameLevel() or 0) + 1)

        TargetFrameToTDebuff1:SetPoint("TOPLEFT", TargetFrameToT, "TOPRIGHT", 25, -10)

        --frame.ToTManaBar:Show()

        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'
        )

        TargetFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)
        TargetFrameToTHealthBar.SetStatusBarColor = noop

        Module.UpdateTargetToTManaBarTextures()

        if UnitIsUnit('player', 'playertarget') then
        --frame.ToTManaBar:Hide()
        end
    else
        --print('ToT doesnt exist')
        --frame.ToTManaBar:Hide()
    end
end

function Module.ReApplyFocusToT()
    if UnitExists('focustarget') then
        FocusFrameToT:ClearAllPoints()
        FocusFrameToT:SetPoint('BOTTOMRIGHT', FocusFrame, 'BOTTOMRIGHT', -35, -10 - 5)
        FocusFrameToT:SetFrameLevel(math.max(FocusFrameTextureFrame:GetFrameLevel(), FocusFrameTextureFrameRankFrame and FocusFrameTextureFrameRankFrame:GetFrameLevel() or 0) + 1)
        FocusFrameToT:SetScale(1)
        FocusFrameToTDebuff1:SetPoint("TOPLEFT", FocusFrameToT, "TOPRIGHT", 25, -10)

        local UpdateManaBarColor = function()
            local powerType, powerTypeString = UnitPowerType('focustarget')
            if powerTypeString == 'MANA' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
                )
            elseif powerTypeString == 'FOCUS' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'
                )
            elseif powerTypeString == 'RAGE' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'
                )
            elseif powerTypeString == 'ENERGY' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'
                )
            elseif powerTypeString == 'RUNIC_POWER' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'
                )
            end
        end

        FocusFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'
        )
        FocusFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)
        FocusFrameToTHealthBar.SetStatusBarColor = noop

        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
        )
        FocusFrameToTManaBar:SetStatusBarColor(1, 1, 1, 1)
        FocusFrameToTManaBar.SetStatusBarColor = UpdateManaBarColor
    end
end

function Module.ChangeFocusFrame()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    if not frame.FocusFrameBackground then
        local background = FocusFrame:CreateTexture('ImprovedUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBackground = background
    end

    if not frame.FocusFrameBorder then
        local border = FocusFrame:CreateTexture('ImprovedUITargetFrameBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBorder = border
    end

    FocusFramePortrait:SetDrawLayer('ARTWORK', 1)
    FocusFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    FocusFramePortrait:SetPoint('TOPRIGHT', FocusFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetTexture(base)
    FocusFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    FocusFrameNameBackground:SetSize(135, 18)
    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetPoint('BOTTOMLEFT', FocusFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    -- @TODO: change text spacing
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameTextureFrameName:SetPoint('BOTTOM', FocusFrameHealthBar, 'TOP', 10, 3 - 2)

    FocusFrameTextureFrameLevelText:ClearAllPoints()
    FocusFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', FocusFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    local dx = 5
    -- health vs mana bar
    local deltaSize = 132 - 125

    FocusFrameTextureFrameHealthBarText:ClearAllPoints()
    FocusFrameTextureFrameHealthBarText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    FocusFrameTextureFrameHealthBarTextLeft:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', dx, 0)
    FocusFrameTextureFrameHealthBarTextRight:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', -dx, 0)

    FocusFrameTextureFrameManaBarText:ClearAllPoints()
    FocusFrameTextureFrameManaBarText:SetPoint('CENTER', FocusFrameManaBar, -deltaSize / 2, 0)
    FocusFrameTextureFrameManaBarTextLeft:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', dx, 0)
    FocusFrameTextureFrameManaBarTextRight:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', -deltaSize - dx, 0)

    -- Health 119,12
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetSize(125, 20)
    FocusFrameHealthBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, 0)
    FocusFrameHealthBar:SetFrameLevel(FocusFrame:GetFrameLevel())
    --[[    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )
    FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetSize(132, 9)
    FocusFrameManaBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    FocusFrameManaBar:SetFrameLevel(FocusFrame:GetFrameLevel())
    FocusFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
    )
    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    -- CUSTOM HealthText
    if not frame.FocusFrameHealthBarText then
        local FocusFrameHealthBarDummy = CreateFrame('FRAME', 'FocusFrameHealthBarDummy')
        FocusFrameHealthBarDummy:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('TOP', FocusFrameHealthBar, 'TOP', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('BOTTOM', FocusFrameHealthBar, 'BOTTOM', 0, 0)
        FocusFrameHealthBarDummy:SetParent(FocusFrame)
        FocusFrameHealthBarDummy:SetFrameStrata('LOW')
        FocusFrameHealthBarDummy:SetFrameLevel(3)
        FocusFrameHealthBarDummy:EnableMouse(true)

        frame.FocusFrameHealthBarDummy = FocusFrameHealthBarDummy

        local t = FocusFrameHealthBarDummy:CreateFontString('FocusFrameHealthBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameHealthBarDummy, 0, 0)
        t:SetText('HP')
        t:Hide()
        frame.FocusFrameHealthBarText = t

        FocusFrameHealthBarDummy:HookScript(
            'OnEnter',
            function(self)
                if
                    FocusFrameTextureFrameHealthBarTextRight:IsVisible() or
                        FocusFrameTextureFrameHealthBarText:IsVisible()
                 then
                else
                    Module.UpdateFocusText()
                    frame.FocusFrameHealthBarText:Show()
                end
            end
        )
        FocusFrameHealthBarDummy:HookScript(
            'OnLeave',
            function(self)
                frame.FocusFrameHealthBarText:Hide()
            end
        )
    end

    -- CUSTOM ManaText
    if not frame.FocusFrameManaBarText then
        local FocusFrameManaBarDummy = CreateFrame('FRAME', 'FocusFrameManaBarDummy')
        FocusFrameManaBarDummy:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('TOP', FocusFrameManaBar, 'TOP', 0, 0)
        FocusFrameManaBarDummy:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('BOTTOM', FocusFrameManaBar, 'BOTTOM', 0, 0)
        FocusFrameManaBarDummy:SetParent(FocusFrame)
        FocusFrameManaBarDummy:SetFrameStrata('LOW')
        FocusFrameManaBarDummy:SetFrameLevel(3)
        FocusFrameManaBarDummy:EnableMouse(true)

        frame.FocusFrameManaBarDummy = FocusFrameManaBarDummy

        local t = FocusFrameManaBarDummy:CreateFontString('FocusFrameManaBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameManaBarDummy, -dx, 0)
        t:SetText('MANA')
        t:Hide()
        frame.FocusFrameManaBarText = t

        FocusFrameManaBarDummy:HookScript(
            'OnEnter',
            function(self)
                if FocusFrameTextureFrameManaBarTextRight:IsVisible() or FocusFrameTextureFrameManaBarText:IsVisible() then
                else
                    Module.UpdateFocusText()
                    frame.FocusFrameManaBarText:Show()
                end
            end
        )
        FocusFrameManaBarDummy:HookScript(
            'OnLeave',
            function(self)
                frame.FocusFrameManaBarText:Hide()
            end
        )
    end

    FocusFrameFlash:SetTexture('')

    if not frame.FocusFrameFlash then
        local flash = FocusFrame:CreateTexture('ImprovedUIFocusFrameFlash')
        flash:SetDrawLayer('BACKGROUND', 2)
        flash:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat'
        )
        flash:SetPoint('CENTER', FocusFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
        flash:SetSize(256, 128)
        -- flash:SetScale(1)
        flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        flash:SetBlendMode('ADD')
        frame.FocusFrameFlash = flash
    end

    hooksecurefunc(
        FocusFrameFlash,
        'Show',
        function()
            --print('show')
            FocusFrameFlash:SetTexture('')
            frame.FocusFrameFlash:Show()
            if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
            else
                --print('go flash')
                local dt = 0.5
                UIFrameFlash(frame.FocusFrameFlash, dt, dt, -1)
            end
        end
    )

    hooksecurefunc(
        FocusFrameFlash,
        'Hide',
        function()
            --print('hide')
            FocusFrameFlash:SetTexture('')
            if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
                UIFrameFlashStop(frame.FocusFrameFlash)
            end
            frame.FocusFrameFlash:Hide()
        end
    )

    if not frame.FocusExtra then
        local extra = FocusFrame:CreateTexture('ImprovedUIFocusFramePortraitExtra')
        extra:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('OVERLAY', 3)
        extra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('focus')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(99, 81)
                frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            else
                frame.FocusExtra:Hide()
            end
        end

        frame.FocusExtra = extra
    end
end
--ChangeFocusFrame()
-- frame:RegisterEvent('UNIT_POWER_UPDATE')
-- frame:RegisterEvent('UNIT_HEALTH')
-- frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

function Module.MoveFocusFrame(anchor, anchorOther, dx, dy)
    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint(anchor, UIParent, anchorOther, dx, dy)
end

function Module.ReApplyFocusFrame()
    ReApplyPvPIcons(FocusFrame, 30, -30, 20, -20, 20, -20)

    if FocusFrameHeadHuntingWantedFrame ~= nil then
        FocusFrameHeadHuntingWantedFrame:ClearAllPoints()
        FocusFrameHeadHuntingWantedFrame:SetPoint('TOP', FocusFramePortrait, 'BOTTOM', -15, 16)
    end

    if Module.db.profile.focus.classcolor and UnitIsPlayer('focus') then
        FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'
        )
        local localizedClass, englishClass, classIndex = UnitClass('focus')
        FocusFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
        )
        FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    if frame.FocusFrameHealthBarText ~= nil then
        frame.FocusFrameHealthBarText:SetPoint('CENTER', FocusFrameHealthBarDummy, 0, 0)
    end

    local powerType, powerTypeString = UnitPowerType('focus')
    local show = true
    if powerTypeString == 'MANA' then
        if not UnitHasMana or not UnitHasMana('focus') then
            show = false
        else
            FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
            )
        end
    elseif powerTypeString == 'FOCUS' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'
        )
    elseif powerTypeString == 'RAGE' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'
        )
    end

    if show then
        FocusFrameManaBar:Show()
    else
        FocusFrameManaBar:Hide()
    end

    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    FocusFrameFlash:SetTexture('')

    if frame.FocusExtra then
        frame.FocusExtra:UpdateStyle()
    end
end

function Module.ChangeFocusToT()
    FocusFrameToTBackground:Hide()
    FocusFrameToTTextureFrameTexture:SetTexture('')

    if not frame.FocusFrameToTBackground then
        local background = FocusFrameToTTextureFrame:CreateTexture('ImprovedUIFocusFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBackground = background
    end

    if not frame.FocusFrameToTBorder then
        local border = FocusFrameToTHealthBar:CreateTexture('ImprovedUIFocusFrameToTBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBorder = border
    end

    FocusFrameToTHealthBar:ClearAllPoints()
    FocusFrameToTHealthBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 0 + 1)
    FocusFrameToTHealthBar:SetFrameLevel(FocusFrameToTTextureFrame:GetFrameLevel())
    FocusFrameToTHealthBar:SetSize(70.5, 10)

    FocusFrameToTManaBar:ClearAllPoints()
    FocusFrameToTManaBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
    FocusFrameToTManaBar:SetFrameLevel(FocusFrameToTTextureFrame:GetFrameLevel())
    FocusFrameToTManaBar:SetSize(74, 7.5)

    FocusFrameToTTextureFrameName:ClearAllPoints()
    FocusFrameToTTextureFrameName:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)
end

function Module.UpdateFocusText()
    --print('UpdateFocusText')
    if UnitExists('focus') then
        local max_health = UnitHealthMax('focus')
        local health = UnitHealth('focus')

        if not frame.FocusFrameHealthBarText then
            Module.ChangeFocusFrame()
        end

        frame.FocusFrameHealthBarText:SetText(health .. ' / ' .. max_health)

        local max_mana = UnitPowerMax('focus')
        local mana = UnitPower('focus')

        if max_mana == 0 then
            frame.FocusFrameManaBarText:SetText('')
        else
            frame.FocusFrameManaBarText:SetText(mana .. ' / ' .. max_mana)
        end
    end
end

function Module.HookFunctions()
    hooksecurefunc(
        PlayerFrameTexture,
        'Show',
        function()
            --print('PlayerFrameTexture - Show()')
            Module.ChangePlayerframe()
        end
    )
end

function Module.ChangePetFrame()
    local base = 'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframe'

    local zOffset = -70
    if RuneFrame:IsShown() then
       zOffset = zOffset - 13
    end
    PetFrame:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 50, zOffset)
    PetFrameTexture:SetTexture('')
    PetFrameTexture:Hide()

    if not frame.PetFrameBackground then
        local background = PetFrame:CreateTexture('ImprovedUIPetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBackground = background
    end

    if not frame.PetFrameBorder then
        local border = PetFrameHealthBar:CreateTexture('ImprovedUIPetFrameBorder')
        border:SetDrawLayer('OVERLAY', 2)
        border:SetTexture(
            'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBorder = border
    end

    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1 - 2 + 0.5, 0)
    PetFrameHealthBar:SetSize(70.5, 10)
    PetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'
    )
    PetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    PetFrameHealthBar.SetStatusBarColor = noop

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 - 2 - 1.5 + 1 - 2 + 0.5, 2 - 10 - 1)
    PetFrameManaBar:SetSize(74, 7.5)
    PetFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
    )
    PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    frame.UpdatePetManaBarTexture = function()
        local powerType, powerTypeString = UnitPowerType('pet')
        local show = true
        if powerTypeString == 'MANA' then
            if not UnitHasMana or not UnitHasMana('pet') then
                show = false
            else
                PetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
                )
            end
        elseif powerTypeString == 'FOCUS' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus'
            )
        elseif powerTypeString == 'RAGE' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'
            )
        elseif powerTypeString == 'ENERGY' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'
            )
        elseif powerTypeString == 'RUNIC_POWER' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'
            )
        end

        if show then
            PetFrameManaBar:Show()
        else
            PetFrameManaBar:Hide()
        end

        PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
    end

    hooksecurefunc(
        'PetFrame_Update',
        function(self)
            frame.UpdatePetManaBarTexture()
        end
    )

    local dx = 2
    -- health vs mana bar
    local deltaSize = 74 - 70.5

    local newPetTextScale = 0.8

    PetName:ClearAllPoints()
    PetName:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)
    -- PetFrameHealthBarTextLeft:SetPoint('LEFT', PetFrameHealthBar, 'LEFT', dx, 0)
    -- PetFrameHealthBarTextRight:SetPoint('RIGHT', PetFrameHealthBar, 'RIGHT', -dx, 0)

    -- PetFrameHealthBarText:SetScale(newPetTextScale)
    -- PetFrameHealthBarTextLeft:SetScale(newPetTextScale)
    -- PetFrameHealthBarTextRight:SetScale(newPetTextScale)

    PetFrameManaBarText:SetPoint('CENTER', PetFrameManaBar, 'CENTER', deltaSize / 2, 0)
    -- PetFrameManaBarTextLeft:ClearAllPoints()
    -- PetFrameManaBarTextLeft:SetPoint('LEFT', PetFrameManaBar, 'LEFT', deltaSize + dx + 1.5, 0)
    -- PetFrameManaBarTextRight:SetPoint('RIGHT', PetFrameManaBar, 'RIGHT', -dx, 0)

    -- PetFrameManaBarText:SetScale(newPetTextScale)
    -- PetFrameManaBarTextLeft:SetScale(newPetTextScale)
    -- PetFrameManaBarTextRight:SetScale(newPetTextScale)
end

function Module.CreateRestFlipbook()
    if not frame.RestIcon then
        local rest = CreateFrame('Frame', 'ImprovedUIRestFlipbook')
        rest:SetSize(20, 20)
        rest:SetPoint('CENTER', PlayerPortrait, 'TOPRIGHT', 0, 0)

        local restTexture = rest:CreateTexture('ImprovedUIRestFlipbookTexture')
        restTexture:SetAllPoints()
        restTexture:SetVertexColor(1, 1, 1, 1)
        restTexture:SetTexture('Interface\\AddOns\\Sirus_ImprovedUI\\Textures\\uiunitframerestingflipbook')

        local animationGroup = restTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'RestFlipbookAnimation')

        animationGroup:SetLooping('REPEAT')
        --[[animation:SetFlipBookFrameWidth(64)
        animation:SetFlipBookFrameHeight(64)
        animation:SetFlipBookRows(1)
        animation:SetFlipBookColumns(8)
        animation:SetFlipBookFrames(8)]]
        animation:SetDuration(2)

        frame.RestIcon = rest
        frame.RestIconAnimation = animationGroup

        PlayerFrame_UpdateStatus()
    end
end

function Module.HookRestFunctions()
    hooksecurefunc(
        PlayerStatusGlow,
        'Show',
        function()
            PlayerStatusGlow:Hide()
        end
    )

    hooksecurefunc(
        PlayerRestIcon,
        'Show',
        function()
            PlayerRestIcon:Hide()
        end
    )

    hooksecurefunc(
        PlayerRestGlow,
        'Show',
        function()
            PlayerRestGlow:Hide()
        end
    )

    hooksecurefunc(
        'SetUIVisibility',
        function(visible)
            if visible then
                PlayerFrame_UpdateStatus()
            else
                frame.RestIcon:Hide()
                frame.RestIconAnimation:Stop()
            end
        end
    )
end

function frame:OnEvent(event, arg1)
    --print(event, arg1)
    if event == 'UNIT_POWER_UPDATE' and arg1 == 'focus' then
        Module.UpdateFocusText()
        Module.ReApplyFocusFrame()
    elseif event == 'UNIT_POWER_UPDATE' and arg1 == 'pet' then
    elseif event == 'UNIT_POWER_UPDATE' then
        --print(event, arg1)
    elseif event == 'UNIT_HEALTH' and arg1 == 'focus' then
        Module.UpdateFocusText()
        Module.ReApplyFocusFrame()
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        Module.ReApplyFocusFrame()
        Module.ReApplyFocusToT()
        Module.UpdateFocusText()
    elseif event == 'PLAYER_ENTERING_WORLD' then
        --print('PLAYER_ENTERING_WORLD')
        Module.CreatePlayerFrameTextures()
        Module.ChangePlayerframe()
        Module.ChangeTargetFrame()
        Module.ChangeToT()
        Module.ReApplyTargetFrame()
        Module.ReApplyToT()
        Module.MoveAttackIcon()
        Module.CreateRestFlipbook()
        Module.ChangeFocusFrame()
        Module.ChangeFocusToT()
        Module.ReApplyFocusToT()
        Module.ChangePetFrame()

        Module.ApplySettings()
    elseif event == 'PLAYER_TARGET_CHANGED' then
        --Module.ApplySettings()
        Module.ReApplyTargetFrame()
        Module.ReApplyToT()
        Module.ChangePlayerframe()
    elseif event == 'UNIT_ENTERED_VEHICLE' then
        Module.ChangePlayerframe()
    elseif event == 'UNIT_EXITED_VEHICLE' then
        Module.ChangePlayerframe()
    elseif event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_INDOORS' or event == 'ZONE_CHANGED_NEW_AREA' then
        Module.ChangePlayerframe()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_TARGET_CHANGED')
    frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

    frame:RegisterEvent('UNIT_ENTERED_VEHICLE')
    frame:RegisterEvent('UNIT_EXITED_VEHICLE')

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    --frame:RegisterEvent('UNIT_POWER_UPDATE') -- overriden by other RegisterUnitEvent

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    frame:RegisterEvent('UNIT_HEALTH')

    frame:RegisterEvent('ZONE_CHANGED')
    frame:RegisterEvent('ZONE_CHANGED_INDOORS')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')

    Module.HookRestFunctions()
    Module.HookVertexColor()
    Module.HookPlayerStatus()
    Module.HookRunes()
    Module.HookTargetFaction()
    Module.HookDrag()

    if _G.UnitFrameVip_Update ~= nil then
        local _UnitFrameVip_Update = _G.UnitFrameVip_Update
        _G.UnitFrameVip_Update = function(self)
            _UnitFrameVip_Update()
            if self == PlayerFrame then
                Module.UpdatePlayerStatus()
                PlayerCategoryBox:Hide()
            elseif self == TargetFrame then
                Module.ReApplyTargetFrame()
                TargetCategoryBox:Hide()
            elseif self == FocusFrame then
                Module.ReApplyFocusFrame()
                FocusFrameCategoryBox:Hide()
            elseif self == TargetFrameToT then
                Module.ReApplyToT()
            elseif self == FocusFrameToT then
                Module.ReApplyFocusToT()
            end
        end
    end
end