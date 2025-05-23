local function T(en, zh, zht) return ChooseTranslationTable({ en, zh = zh, zht = zht or zh }) end

name = T('Knabsack Net Toggle', '强抢袋捕虫功能开关')
author = T('ninjabladeJr, liolok', 'ninjabladeJr、李皓奇')
local date = '2025-05-20'
version = date .. '' -- for revision in same day
description = T(
  [[Enable/disable the "Catch" capacity of Knabsack. No more Bees!
󰀏"Toggle Key" is adjustable in bottom of Settings > Controls page.]],
  [[启用/禁用强抢袋的「捕捉」功能。别乱抓蜜蜂了！
󰀏「切换按键」可以在设置 > 控制页面下方实时调整。]]
) .. '\n󰀰 ' .. T('Last updated at: ', '最后更新于：') .. date
api_version = 10
dst_compatible = true
client_only_mod = true
icon = 'icon.tex'
icon_atlas = 'icon.xml'

local keyboard = { -- from STRINGS.UI.CONTROLSSCREEN.INPUTS[1] of strings.lua, need to match constants.lua too.
  { 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause' },
  { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
  { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M' },
  { 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
  { 'Escape', 'Tab', 'CapsLock', 'LShift', 'LCtrl', 'LSuper', 'LAlt' },
  { 'Space', 'RAlt', 'RSuper', 'RCtrl', 'RShift', 'Enter', 'Backspace' },
  { 'BackQuote', 'Minus', 'Equals', 'LeftBracket', 'RightBracket' },
  { 'Backslash', 'Semicolon', 'Quote', 'Period', 'Slash' }, -- punctuation
  { 'Up', 'Down', 'Left', 'Right', 'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown' }, -- navigation
}
local numpad = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Period', 'Divide', 'Multiply', 'Minus', 'Plus' }
local mouse = { '\238\132\130', '\238\132\131', '\238\132\132' } -- Middle Mouse Button, Mouse Button 4 and 5
local key_disabled = { description = T('Disabled', '禁用'), data = 'KEY_DISABLED' }
keys = { key_disabled }
for i = 1, #mouse do
  keys[#keys + 1] = { description = mouse[i], data = mouse[i] }
end
for i = 1, #keyboard do
  for j = 1, #keyboard[i] do
    local key = keyboard[i][j]
    keys[#keys + 1] = { description = key, data = 'KEY_' .. key:upper() }
  end
  keys[#keys + 1] = key_disabled
end
for i = 1, #numpad do
  local key = numpad[i]
  keys[#keys + 1] = { description = 'Numpad ' .. key, data = 'KEY_KP_' .. key:upper() }
end

configuration_options = {
  {
    name = 'default_state',
    label = T('Default State', '默认状态'),
    hover = T(
      'Initial state of the "Catch" capacity of Knabsack when entering world',
      '进入世界时，强抢袋的「捕捉」功能的初始状态。'
    ),
    options = {
      { data = true, description = T('Enabled', '启用') },
      { data = false, description = T('Disabled', '禁用') },
    },
    default = false,
  },
  {
    name = 'show_button_widget',
    label = T('Show Button', '显示按钮'),
    hover = T('Button only shows up when holding Knabsack.', '按钮仅会在手持强抢袋时显示'),
    options = {
      { data = true, description = T('Yes', '是') },
      { data = false, description = T('No', '否') },
    },
    default = true,
  },
  {
    name = 'keybind', -- name doesn't matter when only one config about key binding
    label = T('Toggle Key', '切换按键'),
    hover = T('Key only works when playing as Wortox.', '按键仅会在使用沃拓克斯游玩时有效'),
    options = keys,
    default = 'KEY_DISABLED',
  },
}
