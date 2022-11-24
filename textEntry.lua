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
local dialogNum

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
  dialogNum = 1
  
end

function TE.updateText()
  
  local cs = SC.getCurrentScene()
  if cs ~= Scenes.NOTEBOOK then
    S.updateSuggestions(text)
  end
  
end

function TE.drawText()
  
  SC.setTextFont()
  
  local cs = SC.getCurrentScene()
  if cs == Scenes.TITLE then
    return
  end
  
  if cs == Scenes.INTRO_BRIEFING then
    local shouldPrint = SC.checkFades()
    if shouldPrint then
      SC.setDialogFont()
      G.drawDialog(dialogNum)
      SC.setTextFont()
      lg.printf(">> " .. text, 80, 560, maxTextWidth, "left")
    end
    return
  end
  
  if cs == Scenes.DEBRIEFING_1 then
    if dialogNum < 12 then
      dialogNum = 12
    end
    SC.setDialogFont()
    G.drawDialog(dialogNum)
    SC.setTextFont()
    lg.printf(">> " .. text, 80, 560, maxTextWidth, "left")
    return
  end
  
  if cs == Scenes.INTRO_COMIC then
    local isTextDone = G.drawDialog(dialogNum)
    if isTextDone then
      SC.incrementComic()
      G.resetCurrDiagNum()
      dialogNum = dialogNum + 1
    end
    return
  end
  
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
  
  
  local cs = SC.getCurrentScene()
  
  if cs == Scenes.INTRO_BRIEFING then
    if key == "return" then
      if text == "next" then
        dialogNum = dialogNum + 1
      elseif text == "repeat" then
        dialogNum = 1
      elseif text == "ready" then
        dialogNum = 9
        SC.setCurrentScene(Scenes.INTRO_COMIC)
      end
      text = ""
      G.resetCurrDiagNum()
    end
    return
  elseif cs == Scenes.DEBRIEFING_1 then
    text = ""
    return
    --HANDLE GAME ANSWERS HERE
  end
  
  if cs == Scenes.INTRO_COMIC then
    return
  end
  
  text = S.handleSuggestionState(text, key)
  
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
    elseif text == "station" then
      SC.executeAction("station")
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