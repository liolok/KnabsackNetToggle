local Widget = require('widgets/widget')
local ImageButton = require('widgets/imagebutton')
local Image = require('widgets/image')

local Util = require('nabbag_util')

local NabBagToggleWidget = Class(Widget, function(self)
  Widget._ctor(self, 'NabBagToggleWidget')

  self.root = self:AddChild(Widget('ROOT'))
  self.root:SetScale(0.6, 0.6)
  self.root:SetPosition(0, 50)
  self.root:MoveToBack()
  self.bg = self.root:AddChild(Image('images/background.xml', 'background.tex'))
  self.button = self.bg:AddChild(ImageButton('images/bugnet_off.xml', 'bugnet_off.tex'))
  self.button_overlay = self.button:AddChild(Image('images/bugnet_on.xml', 'bugnet_on.tex'))

  self.button.scale_on_focus = false
  self.button.move_on_click = false
  self.button:SetOnClick(Util.ToggleNabBagNet)

  self:StartUpdating()
end)

function NabBagToggleWidget:OnUpdate()
  if Util.IsNabBagEquipped() then
    self.root:Show() -- show button widget only when player is holding Knabsack in hand
  else
    self.root:Hide()
  end

  if ThePlayer and ThePlayer.nabbag_net_enabled then
    self.button_overlay:Show()
  else
    self.button_overlay:Hide()
  end
end

return NabBagToggleWidget
