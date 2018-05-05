function WarhornTimer:WindowApplySettings()
  self.window:SetWidth(self.settings.width)
  self.window:SetHeight(self.settings.height)
  self.window:ClearAnchors()
  self.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.settings.offset['x'], self.settings.offset['y'])
  self.window:SetMouseEnabled(not self.settings.locked)
  self.window:SetMovable(not self.settings.locked)
  self.window:SetHidden(not self.settings.alwaysShow)
  self.window.label:SetFont('$(BOLD_FONT)|'..tostring(self.settings.textSize)..'|soft-shadow-thin')
  self.window.background:SetEdgeColor(unpack(self.settings.colorEdge))
  self.window.background:SetCenterColor(unpack(self.settings.colorBackground))
  self.window.bar:SetGradientColors(unpack(self.settings.colorBar))
  self.window.icon:SetHidden(not self.settings.showIcon)
  self.window.icon:SetWidth(self.settings.iconSize)
  self.window.icon:SetHeight(self.settings.iconSize)
  self.window.icon:SetTexture(self.settings.iconTexture)
end

function WarhornTimer:WindowCreate()
  self.window = WINDOW_MANAGER:CreateTopLevelWindow('WarhornTimerWindow')
  self.window:SetHandler('OnMoveStop', function() self:WindowMoved() end)
  self.window:SetClampedToScreen(true)

  self.window.background = WINDOW_MANAGER:CreateControl('$(parent)Background', self.window, CT_BACKDROP)
  self.window.background:SetAnchorFill()
  self.window.background:SetDrawLayer(1)
  self.window.background:SetEdgeTexture(nil, 1, 1, 2, 0)

  self.window.bar = WINDOW_MANAGER:CreateControl('$(parent)Bar', self.window, CT_STATUSBAR)
  self.window.bar:SetAnchor(TOPLEFT, self.window, TOPLEFT, 2, 2)
  self.window.bar:SetAnchor(BOTTOMRIGHT, self.window, BOTTOMRIGHT, -2, -2)
  self.window.bar:SetMinMax(0, 1)

  self.window.label = WINDOW_MANAGER:CreateControl('$(parent)Label', self.window, CT_LABEL)
  self.window.label:SetAnchor(TOPLEFT, self.window, TOPLEFT, 2, 2)
  self.window.label:SetAnchor(BOTTOMRIGHT, self.window, BOTTOMRIGHT, -2, -2)
  self.window.label:SetVerticalAlignment(1)
  self.window.label:SetHorizontalAlignment(1)
  self.window.label:SetColor(1,1,1,1)

  self.window.icon = WINDOW_MANAGER:CreateControl('$(parent)Icon', self.window, CT_TEXTURE)
  self.window.icon:SetAnchor(RIGHT, self.window, LEFT, -1,0)

  self:WindowApplySettings()
end

function WarhornTimer:WindowMoved()
  self.settings.offset['x'] = self.window:GetLeft()
  self.settings.offset['y'] = self.window:GetTop()
end

function WarhornTimer:WindowRefresh()
  if self.endTime ~= nil then
    local remainTime = self.endTime - GetFrameTimeSeconds()
    if remainTime < 0 then
      self.endTime = nil
      self.window.label:SetText('')
      self.window:SetHidden(not self.settings.alwaysShow)
    else
      if remainTime < self.settings.criticalTime then
        self.window.label:SetColor(1,0,0,1)
      else
        self.window.label:SetColor(1,1,1,1)
      end
      self.window.bar:SetValue(remainTime)
      self.window.label:SetText(('%02.01f'):format(remainTime))
    end
  end
end

function WarhornTimer:WindowStart(beginTime, endTime, iconName)
  local remainTime = endTime - beginTime
  if remainTime > 0 then
    self.endTime = endTime
    self.window:SetHidden(false)
    self.window.bar:SetMinMax(0, remainTime)
    self.window.icon:SetTexture(iconName)
  end
end
