-- Translation
local lc = GLOBAL.LOC.GetLocaleCode()
modimport('lang/' .. (GLOBAL.kleifileexists(MODROOT .. 'lang/' .. lc .. '.lua') and lc or 'en'))

-- Hook Knabsack
local Util = require('nabbag_util')
AddPrefabPostInit('wortox_nabbag', function(inst) inst:DoTaskInTime(0, Util.UpdateNabBagNet) end)
AddPlayerPostInit(function(player)
  if player.prefab ~= 'wortox' then return end
  player.nabbag_net_enabled = GetModConfigData('default_state')
  player:ListenForEvent('equip', function(_, data) return Util.UpdateNabBagNet(data and data.item) end)
end)

-- Show Button
Assets = {
  Asset('IMAGE', 'images/background.tex'),
  Asset('ATLAS', 'images/background.xml'),
  Asset('IMAGE', 'images/bugnet_off.tex'),
  Asset('ATLAS', 'images/bugnet_off.xml'),
  Asset('IMAGE', 'images/bugnet_on.tex'),
  Asset('ATLAS', 'images/bugnet_on.xml'),
}
local NabBagToggleWidget = require('widgets/nabbag_toggle_widget')
AddClassPostConstruct('widgets/controls', function(self)
  self.nabbag_toggle_widget = self:AddChild(NabBagToggleWidget(self.owner))
  self.nabbag_toggle_widget:MoveToBack()
  self.nabbag_toggle_widget.should_show = GetModConfigData('show_button_widget')
end)

-- Toggle Key
modimport('keybind') -- refine key binding UI
local handler = nil -- key event handler
local Input = GLOBAL.TheInput
function KeyBind(_, key)
  if handler then handler:Remove() end -- disable old binding, re-add handler if new key assigned.
  local function f(_key, down) return (_key == key and down) and Util.ToggleNabBagNet(true) end
  handler = key and (key >= 1000 and Input:AddMouseButtonHandler(f) or Input:AddKeyHandler(f))
end
