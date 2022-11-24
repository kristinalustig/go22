TE = {}

local G = require "grammar"
local S = require "suggestions"
local SC = require "sceneContent"
local utf8 = require("utf8")

local textInputY
local textHistory
local text
local textSize
local maxChars
local charCount

function TE.init()
  
  S.init()
  
  text = ""
  love.keyboard.setKeyRepeat(true)
  maxChars = 20
  charCount = 0
  textHistory = {}
  textSize = 24
  maxTableSize = 6
  textInputY = 580
  maxTextWidth = 400
  
end

function TE.updateText()
  
  local cs = SC.getCurrentScene()
  if cs ~= Scenes.NOTEBOOK then
    S.updateSuggestions(text)
  end
  
end

function TE.drawText()
  
  SC.setTextFont()
  
  lg.printf(">> " .. text, 20, textInputY, maxTextWidth, "left")
  local textPosition = textInputY - 60 - (textSize * 1)
  for k, v in ipairs(textHistory) do
    if #v*textSize/2 >= maxTextWidth then
      lg.printf(v, 20, textPosition - textSize, maxTextWidth, "left")
      textPosition = textPosition - (textSize * 2)
    else
      lg.printf(v, 20, textPosition, maxTextWidth, "left")
      textPosition = textPosition - textSize
    end
  end
  
  S.drawSuggestions()
  
end

function TE.handleKeyPressed(key)
  
  text = S.handleSuggestionState(text, key)
  local cs = SC.getCurrentScene()
  
  if key == "escape" or text == "back" then
    text = ""
    SC.executeAction("reset")
    S.clearSuggestions()
  elseif key == "tab" then
    --do nothing else
  elseif key == "return" then
    --check for special commands
    if text == "help" then
      --do help here
    elseif text == "notes" then
      SC.executeAction("notes")
    end
    S.clearSuggestions()
    TE.lopOffEndOfTable()
    table.insert(textHistory, 1, ">> " .. text)
    local add = G.checkMatches(text)
    table.insert(textHistory, 1, add)
    charCount = 0
    text = ""
    love.keyboard.setTextInput(true)
    movedToNouns = false
  elseif key == "backspace" then
    local byteoffset = utf8.offset(text, -1)
    if byteoffset then
      text = string.sub(text, 1, byteoffset - 1)
      if not text:find(" ") then
        movedToNouns = false
      end
      charCount = charCount - 1
      love.keyboard.setTextInput(true)
    end
  elseif charCount >= maxChars then
    love.keyboard.setTextInput(false)
  else
    charCount = charCount + 1
  end
  
  return cs
end

function TE.textInput(t)
  
  text = text .. t
  
end

function TE.lopOffEndOfTable()
  
  if #textHistory > maxTableSize then
    table.remove(textHistory, #textHistory)
  end
  
end

return TE