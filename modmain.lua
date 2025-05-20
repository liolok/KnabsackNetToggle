-- Translation
local lc = GLOBAL.LOC.GetLocaleCode()
modimport('lang/' .. (GLOBAL.kleifileexists(MODROOT .. 'lang/' .. lc .. '.lua') and lc or 'en'))

-- Hook Knabsack
local Update = require('nabbag_util').UpdateNabBagNet
AddPrefabPostInit('wortox_nabbag', function(inst) inst:DoTaskInTime(0, Update) end)
AddPlayerPostInit(function(player)
  if player.prefab ~= 'wortox' then return end
  player.nabbag_net_enabled = GetModConfigData('default_state')
  player:ListenForEvent('equip', function(_, data) return Update(data and data.item) end)
end)

-- Show Button
if GetModConfigData('show_button_widget') then
  Assets = {
    Asset('IMAGE', 'images/background.tex'),
    Asset('ATLAS', 'images/background.xml'),
    Asset('IMAGE', 'images/bugnet_off.tex'),
    Asset('ATLAS', 'images/bugnet_off.xml'),
    Asset('IMAGE', 'images/bugnet_on.tex'),
    Asset('ATLAS', 'images/bugnet_on.xml'),
  }
  local Widget = require('widgets/nabbag_toggle_widget')
  local f = function(self) self.nabbag_toggle = self.hand_inv and self.hand_inv:AddChild(Widget()) end
  AddClassPostConstruct('widgets/inventorybar', f)
end

-- Toggle Key
modimport('keybind') -- refine key binding UI
local Input = GLOBAL.TheInput
local handler = nil -- key event handler
local Toggle, need_tip = require('nabbag_util').ToggleNabBagNet, true
function KeyBind(_, key)
  if handler then handler:Remove() end -- disable old binding, re-add handler if new key assigned.
  local function f(_key, down) return (_key == key and down) and Toggle(need_tip) end
  handler = key and (key >= 1000 and Input:AddMouseButtonHandler(f) or Input:AddKeyHandler(f))
end
