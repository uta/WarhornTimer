local LAM2 = LibStub('LibAddonMenu-2.0')

local addonPanel = {
  type                = 'panel',
  name                = WarhornTimer.name,
  displayName         = ZO_ColorDef:New('3366cc'):Colorize(WarhornTimer.name),
  author              = WarhornTimer.author,
  version             = WarhornTimer.version,
  registerForRefresh  = true,
  registerForDefaults = true,
}

local defaultSettings = {
  locked          = false,
  alwaysShow      = true,
  updateSpeed     = 100,
  width           = 250,
  height          = 35,
  textSize        = 30,
  showIcon        = true,
  iconSize        = 35,
  iconTexture     = '/esoui/art/icons/ability_ava_003.dds',
  colorBar        = {1,0,0,1,0,1,0,1},
  colorEdge       = {0,0,0,1},
  colorBackground = {0.2,0.2,0.2,0.4},
  offset          = {['x']=200, ['y']=200},
  criticalTime    = 5,
}

local optionControls = {
  {
    type    = 'header',
    name    = ZO_ColorDef:New('E6B85C'):Colorize('Bar Settings'),
  },
  {
    type    = 'checkbox',
    name    = 'Lock',
    getFunc = function() return WarhornTimer.settings.locked end,
    setFunc = function()
      WarhornTimer.settings.locked = not WarhornTimer.settings.locked
      WarhornTimer:WindowApplySettings()
    end
  },
  {
    type    = 'checkbox',
    name    = 'Always Show',
    getFunc = function() return WarhornTimer.settings.alwaysShow end,
    setFunc = function()
      WarhornTimer.settings.alwaysShow = not WarhornTimer.settings.alwaysShow
      WarhornTimer:WindowApplySettings()
    end
  },
  {
    type    = 'slider',
    name    = 'Interval of refreshing bar (ms)',
    min     = 100,
    max     = 500,
    step    = 5,
    getFunc = function() return WarhornTimer.settings.updateSpeed end,
    setFunc = function(number)
      WarhornTimer.settings.updateSpeed = number
      WarhornTimer.EventsRegister(true)
    end,
  },
  {
    type    = 'header',
    name    = ZO_ColorDef:New('E6B85C'):Colorize('Display Settings'),
  },
  {
    type    = 'slider',
    name    = 'Width',
    min     = 0,
    max     = 500,
    step    = 5,
    getFunc = function() return WarhornTimer.settings.width end,
    setFunc = function(number)
      WarhornTimer.settings.width = number
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'slider',
    name    = 'Height',
    min     = 0,
    max     = 200,
    step    = 5,
    getFunc = function() return WarhornTimer.settings.height end,
    setFunc = function(number)
      WarhornTimer.settings.height = number
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'slider',
    name    = 'Text Size',
    min     = 10,
    max     = 100,
    step    = 2,
    getFunc = function() return WarhornTimer.settings.textSize end,
    setFunc = function(number)
      WarhornTimer.settings.textSize = number
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'colorpicker',
    name    = 'Bar Color Left',
    getFunc = function() return WarhornTimer.settings.colorBar[1], WarhornTimer.settings.colorBar[2], WarhornTimer.settings.colorBar[3], WarhornTimer.settings.colorBar[4] end,
    setFunc = function(r,g,b,a)
      WarhornTimer.settings.colorBar[1] = r
      WarhornTimer.settings.colorBar[2] = g
      WarhornTimer.settings.colorBar[3] = b
      WarhornTimer.settings.colorBar[4] = a
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'colorpicker',
    name    = 'Bar Color Right',
    getFunc = function() return WarhornTimer.settings.colorBar[5], WarhornTimer.settings.colorBar[6], WarhornTimer.settings.colorBar[7], WarhornTimer.settings.colorBar[8] end,
    setFunc = function(r,g,b,a)
      WarhornTimer.settings.colorBar[5] = r
      WarhornTimer.settings.colorBar[6] = g
      WarhornTimer.settings.colorBar[7] = b
      WarhornTimer.settings.colorBar[8] = a
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'colorpicker',
    name    = 'Bar Color Edge',
    getFunc = function() return unpack(WarhornTimer.settings.colorEdge) end,
    setFunc = function(r,g,b,a)
      WarhornTimer.settings.colorEdge = {r,g,b,a}
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'colorpicker',
    name    = 'Bar Color Background',
    getFunc = function() return unpack(WarhornTimer.settings.colorBackground) end,
    setFunc = function(r,g,b,a)
      WarhornTimer.settings.colorBackground = {r,g,b,a}
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'checkbox',
    name    = 'Show Icon',
    getFunc = function() return WarhornTimer.settings.showIcon end,
    setFunc = function()
      WarhornTimer.settings.showIcon = not WarhornTimer.settings.showIcon
      WarhornTimer:WindowApplySettings()
    end,
  },
  {
    type    = 'slider',
    name    = 'Icon Size',
    min     = 10,
    max     = 100,
    step    = 2,
    getFunc = function() return WarhornTimer.settings.iconSize end,
    setFunc = function(number)
      WarhornTimer.settings.iconSize = number
      WarhornTimer:WindowApplySettings()
    end,
  },
}

function WarhornTimer:SettingsBuildMenu()
  LAM2:RegisterAddonPanel('WarhornTimerPanel', addonPanel)
  LAM2:RegisterOptionControls('WarhornTimerPanel', optionControls)
end

function WarhornTimer:SettingsLoad()
  self.settings = ZO_SavedVars:NewAccountWide('WarhornTimerSavedVariables', 1, nil, defaultSettings, nil, '$InstallationWide')
end
