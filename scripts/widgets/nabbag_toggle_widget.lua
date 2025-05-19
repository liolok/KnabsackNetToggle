local Widget = require('widgets/widget')
local ImageButton = require('widgets/imagebutton')
local Image = require('widgets/image')

local Util = require('nabbag_util')
local Get = Util.Get

local NabBagToggleWidget = Class(Widget, function(self, owner)
  Widget._ctor(self, 'NabBagToggleWidget')
  self.owner = owner

  self.root = self:AddChild(Widget('ROOT'))
  self.root:SetVAnchor(ANCHOR_BOTTOM)
  self.root:SetHAnchor(ANCHOR_RIGHT)
  self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
  self.root:SetPosition(0, 0, 0)

  self.bg = self.root:AddChild(Image('images/background.xml', 'background.tex'))

  self.bg:SetScale(0.5, 0.5, 0.5)
  self.bg:SetPosition(0, 0) --1500,120
  self.button = self.bg:AddChild(ImageButton('images/bugnet_off.xml', 'bugnet_off.tex'))
  self.button_overlay = self.button:AddChild(Image('images/bugnet_on.xml', 'bugnet_on.tex'))
  self.bg:MoveToBack()
  self.button.focus_scale = { 1, 1, 1 }
  self.button.move_on_click = false

  self:StartUpdating()

  self.button:SetOnClick(Util.ToggleNabBagNet)
end)

function NabBagToggleWidget:OnUpdate(dt)
  local inv = Get(ThePlayer, 'replica', 'inventory')
  if not inv then return end

  -- show button widget only when configuration enabled and player holding Knabsack in hand
  if self.should_show and Get(inv:GetEquippedItem(EQUIPSLOTS.HANDS), 'prefab') == 'wortox_nabbag' then
    self.bg:Show()
  else
    self.bg:Hide()
  end

  if ThePlayer.nabbag_net_enabled then
    self.button_overlay:Show()
  else
    self.button_overlay:Hide()
  end

  local is_pack_open = Get(inv:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY), 'replica', 'container', '_isopen')
  local y = (is_pack_open and Profile:GetIntegratedBackpack()) and 125 or 85
  self.bg:SetPosition(-367, y, 0)
end

return NabBagToggleWidget
