function WarhornTimer.EventAddOnLoaded(event, addonName)
  if addonName == WarhornTimer.name then
    EVENT_MANAGER:UnregisterForEvent(WarhornTimer.name, EVENT_ADD_ON_LOADED)
    WarhornTimer:SettingsLoad()
    WarhornTimer:SettingsBuildMenu()
    WarhornTimer:WindowCreate()
    WarhornTimer:EventsRegister(false)
  end
end

function WarhornTimer.EventEffectChanged(eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
  if sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_GROUP then
    if changeType == EFFECT_RESULT_GAINED then
      if WarhornTimer.abilityIdList[abilityId] then
        WarhornTimer:WindowStart(beginTime, endTime, iconName)
      end
    end
  end
end

function WarhornTimer.EventUpdate()
  WarhornTimer:WindowRefresh()
end

function WarhornTimer.EventsRegister(refresh)
  if refresh then
    EVENT_MANAGER:UnregisterForEvent(WarhornTimer.name)
    EVENT_MANAGER:UnregisterForUpdate(WarhornTimer.name)
  end
  EVENT_MANAGER:RegisterForEvent(WarhornTimer.name, EVENT_EFFECT_CHANGED, WarhornTimer.EventEffectChanged)
  EVENT_MANAGER:RegisterForUpdate(WarhornTimer.name, WarhornTimer.settings.updateSpeed, WarhornTimer.EventUpdate)
end
