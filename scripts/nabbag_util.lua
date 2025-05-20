-- shortcut for code like `ThePlayer and ThePlayer.replica and ThePlayer.replica.inventory`
local function Get(head, ...)
  local current = head
  for _, key in ipairs({ ... }) do
    if not current then return end
    current = current[key]
  end
  return current
end

local function IsNabBagEquipped()
  local inventory = Get(ThePlayer, 'replica', 'inventory')
  if not inventory then return end

  local equipment_in_hand = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
  return equipment_in_hand and equipment_in_hand.prefab == 'wortox_nabbag'
end

local function UpdateNabBagNet(inst)
  if not (inst and inst.prefab == 'wortox_nabbag') then return end

  if not Get(inst, 'components', 'tool') then inst:AddComponent('tool') end

  local actions = Get(inst, 'components', 'tool', 'actions')
  if not actions then return end

  if Get(ThePlayer, 'nabbag_net_enabled') and Get(ACTIONS, 'NET', 'id') then
    actions[ACTIONS.NET] = true
    inst:AddTag(ACTIONS.NET.id .. '_tool')
  else
    actions[ACTIONS.NET] = nil
    inst:RemoveTag(ACTIONS.NET.id .. '_tool')
  end
end

local S = STRINGS.KNABSACK_NET_TOGGLE
local function ToggleNabBagNet(need_tip)
  if not (ThePlayer and ThePlayer.HUD and ThePlayer.prefab == 'wortox') then return end
  if ThePlayer.HUD:HasInputFocus() then return end -- typing or in some menu

  ThePlayer.nabbag_net_enabled = not ThePlayer.nabbag_net_enabled

  if need_tip and S then -- display tip message above player character
    local tip_msg = S.NET_CAPACITY .. '\n' .. (ThePlayer.nabbag_net_enabled and S.ENABLED or S.DISABLED)
    local time, no_animation, force = nil, true, true
    local talker = Get(ThePlayer, 'components', 'talker')
    if talker then talker:Say(tip_msg, time, no_animation, force) end
  end

  local inventory = Get(ThePlayer, 'replica', 'inventory')
  return UpdateNabBagNet(inventory and inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
end

return {
  IsNabBagEquipped = IsNabBagEquipped,
  UpdateNabBagNet = UpdateNabBagNet,
  ToggleNabBagNet = ToggleNabBagNet,
}
