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
local isCorrect
local shouldShowHint
local triedAnswer
local maxCharsBriefing
local commandHistory = {}
local commandHistoryPosition = 0

function TE.init()
  
  S.init()
  
  text = ""
  love.keyboard.setKeyRepeat(true)
  maxChars = 30
  charCount = 0
  textHistory = {}
  textSize = 24
  maxTableSize = 8
  textInputY = 580
  maxTextWidth = 400
  dialogNum = 1
  isCorrect = false
  shouldShowHint = false
  triedAnswer = false
  maxCharsBriefing = 30
  
end

function TE.updateText()
  
  local cs = SC.getCurrentScene()
  if cs == Scenes.INVESTIGATION_1 then
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
      if dialogNum < 4 then
        SC.setUiLabelFont()
        lg.printf("(type 'next' to continue.)", 80, 380, 400, "left")
      end
      SC.setTextFont()
      lg.printf(">> " .. text, 80, 560, maxTextWidth, "left")
    end
    return
  end
  
  if cs == Scenes.DEBRIEFING_1 then
    if dialogNum < 8 then
      dialogNum = 8
    end
    SC.setDialogFont()
    if shouldDisplayHint then
      G.drawDialog(dialogNum + 100)
    elseif triedAnswer then
      G.drawDialog(dialogNum + 50)
    else
      G.drawDialog(dialogNum)
    end
    SC.setTextFont()
    lg.printf(">> " .. text, 80, 560, maxTextWidth+200, "left")
    return
  end
  
  if cs == Scenes.POLICE_CALL then
    G.drawDialog(22)
    return
  elseif cs == Scenes.END_OF_GAME then
    G.drawDialog(25)
    return
  elseif cs == Scenes.GAME_OVER then
    return
  end
  
  if cs == Scenes.INTRO_COMIC1 then
    SC.setComicFont()
    lg.printf(G.dialog[5], 0, 600, 1400, "center")
    SC.setTextFont()
    lg.printf("(Press 'enter' to continue)", 0, 660, 1400, "center")
    return
  elseif cs == Scenes.INTRO_COMIC2 then
    SC.setComicFont()
    lg.printf(G.dialog[6], 0, 600, 1400, "center")
    SC.setTextFont()
    lg.printf("(Press 'enter' to continue)", 0, 660, 1400, "center")
    return
  elseif cs == Scenes.INTRO_COMIC3 then
    SC.setComicFont()
    lg.printf(G.dialog[7], 0, 600, 1400, "center")
    SC.setTextFont()
    lg.printf("(Press 'enter' to continue)", 0, 660, 1400, "center")
    return
  end
  
  lg.printf(">> " .. text, 20, textInputY, maxTextWidth, "left")
  local textPosition = textInputY - (textSize * 1)
  for k, v in ipairs(textHistory) do
    local linesLength = SC.getNumLines(v, maxTextWidth)
    lg.printf(v, 20, textPosition - (textSize * linesLength), maxTextWidth, "left")
    textPosition = textPosition - (textSize * linesLength)
  end
  
  if cs == Scenes.INVESTIGATION_1 then
    S.drawSuggestions()
  end
  
end

function TE.handleKeyPressed(key)

  local cs = SC.getCurrentScene()
  
  text = text:gsub("[^%a%s%d]","")
  
  if cs == Scenes.DEBRIEFING_1 and isWeb then
    if key == "space" then
      text = text .. " " --web version what u doing
    end
  end
  
  if text == "stop music" then
    local t = ""
    if SC.getMusicPlaying() then
      t = "Stopped music."
    else
      t = "Music is already stopped."
    end
    SC.setMusicPlaying(false)
    if cs ~= Scenes.DEBRIEFING_1 and cs ~= Scenes.INTRO_BRIEFING then
      S.clearSuggestions()
      TE.lopOffEndOfTable()
      table.insert(textHistory, 1, ">> " .. text)
      commandHistoryPosition = 0
      table.insert(textHistory, 1, t)
      charCount = 0
      text = ""
      love.keyboard.setTextInput(true)
      movedToNouns = false
    else
      charCount = 0
      text = ""
    end
    return
  elseif text == "play music" then
    local t = ""
    if not SC.getMusicPlaying() then
      t = "Restarted music."
    else
      t = "Music is already enabled."
    end
    SC.setMusicPlaying(true)
    if cs ~= Scenes.DEBRIEFING_1 and cs ~= Scenes.INTRO_BRIEFING then
      S.clearSuggestions()
      TE.lopOffEndOfTable()
      table.insert(textHistory, 1, ">> " .. text)
      commandHistoryPosition = 0
      table.insert(textHistory, 1, t)
      charCount = 0
      text = ""
      love.keyboard.setTextInput(true)
      movedToNouns = false
    else
      charCount = 0
      text = ""
    end
    return
  end
  
  if cs == Scenes.POLICE_CALL then 
    if key == "return" or key == "kpenter"  then
      SC.setFade()
      SC.setCurrentScene(Scenes.END_OF_GAME)
      G.resetCurrDiagNum()
      return
    end
  elseif cs == Scenes.END_OF_GAME then
    if key == "return"  or key == "kpenter" then
      SC.setFade()
      SC.setCurrentScene(Scenes.GAME_OVER)
      return
    end
  elseif cs == Scenes.GAME_OVER then
    return
  end
  
  if cs == Scenes.INTRO_COMIC1 or cs == Scenes.INTRO_COMIC2 or cs == Scenes.INTRO_COMIC3 then
    if key == "return"  or key == "kpenter" then
      SC.incrementComic()
    end
    return
  end
  
  if cs == Scenes.INTRO_BRIEFING or cs == Scenes.DEBRIEFING_1 then
    if key == "return"  or key == "kpenter" then
      text = text:lower()
      charCount = 0
      love.keyboard.setTextInput(true)
    elseif key == "backspace" then
      TE.handleBackspace()
    else
      TE.checkCharCount()
    end
  end
  
  if cs == Scenes.TITLE then
    if key == "return"  or key == "kpenter" then
      SC.setCurrentScene(Scenes.INTRO_BRIEFING)
    end
    return
  end
  
  if cs == Scenes.INTRO_BRIEFING then
    if key == "return"  or key == "kpenter" then
      text = string.gsub(text, '%s+', '')
      if text == "next" and dialogNum < 4 then
        dialogNum = dialogNum + 1
        text = ""
      elseif text == "repeat" then
        dialogNum = 1
        text = ""
      elseif text == "ready" then
        dialogNum = 5
        text = ""
        SC.setCurrentScene(Scenes.INTRO_COMIC1)
      end
      G.resetCurrDiagNum()
      text = ""
    end
    return
  elseif cs == Scenes.DEBRIEFING_1 then
    if key == "return"  or key == "kpenter" then
      if text == "okay" then
        shouldDisplayHint = false
        triedAnswer = false
        text = ""
        G.resetCurrDiagNum()
        return
      elseif text == "back" then
        dialogNum = 8
        triedAnswer = false
        text = ""
        G.resetCurrDiagNum()
        SC.setCurrentScene(Scenes.INVESTIGATION_1)
        return
      elseif text == "hint" then
        shouldDisplayHint = true
        triedAnswer = false
        text = ""
        G.resetCurrDiagNum()
        return
      end
      if dialogNum == 8 then
        if text == "yes" then
          dialogNum = dialogNum + 2
          G.resetCurrDiagNum()
        end
        text = ""
        return
      elseif dialogNum == 10 then --name
        isCorrect = SC.checkDebrief("name", text)
        triedAnswer = true
      elseif dialogNum == 12 then --what happened
        isCorrect = SC.checkDebrief("what", text) 
        triedAnswer = true
      elseif dialogNum == 14 then --date
        isCorrect = SC.checkDebrief("when", tostring(text))
        triedAnswer = true
      elseif dialogNum == 16 then --kidnapper
        isCorrect = SC.checkDebrief("who", text)
        triedAnswer = true
      elseif dialogNum == 18 then --street
        isCorrect = SC.checkDebrief("where", text)
        triedAnswer = true
      elseif dialogNum == 20 then --house number
        isCorrect = SC.checkDebrief("streetNum", tostring(text))
        triedAnswer = true
      end
      if isCorrect then
        dialogNum = dialogNum + 2
        triedAnswer = false
        if dialogNum == 22 then
          SC.setCurrentScene(Scenes.POLICE_CALL)
          SC.setFade()
        end
      end
      text = ""
      G.resetCurrDiagNum()
      return
    end
    return
  end
  
  text = S.handleSuggestionState(text, key)
  
  if key == "escape" or text == "back" then
    text = ""
    SC.executeAction("reset")
    S.clearSuggestions()
  elseif key == "up" or key == "down" then
    TE.handleCommandHistory(key)
    return
  elseif key == "tab" then
    --do nothing else
  elseif key == "return" or key == "kpenter" then
    --check for special commands
    table.insert(commandHistory, 1, text)
    if text == "help" then
      SC.executeAction("help")
    elseif text == "notes" then
      SC.executeAction("notes")
    elseif text == "station" then
      SC.executeAction("station")
    end
    --if we're in another scene, in order to make stuff show up properly, we have to reset to the main scene first.
    if cs == Scenes.NOTEBOOK or cs == Scenes.DOSSIER or cs == Scenes.HELP or cs == Scenes.MAP or cs == Scenes.DIARY or cs == Scenes.CALENDAR or SC.getZoomed() then
      SC.executeAction("reset")
    end
    S.clearSuggestions()
    TE.lopOffEndOfTable()
    table.insert(textHistory, 1, ">> " .. text)
    commandHistoryPosition = 0
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

function TE.handleCommandHistory(k)
  
  if k == "up" and commandHistoryPosition < #commandHistory then
    commandHistoryPosition = commandHistoryPosition + 1
    text = commandHistory[commandHistoryPosition]
  elseif k == "down" and commandHistoryPosition > 1 then
    commandHistoryPosition = commandHistoryPosition - 1
    text = commandHistory[commandHistoryPosition]
  elseif k == "down" and commandHistoryPosition == 1 then
    commandHistoryPosition = 0
    text = ""
  end
  
end

function TE.textInput(t)
  
  text = text .. t
  
end

function TE.lopOffEndOfTable()
  
  if #textHistory >= maxTableSize then
    table.remove(textHistory, #textHistory)
  end
  
end

function TE.handleBackspace()
  
  local byteoffset = utf8.offset(text, -1)
  if byteoffset then
    text = string.sub(text, 1, byteoffset - 1)
    charCount = charCount - 1
    love.keyboard.setTextInput(true)
  end
  
end

function TE.checkCharCount()
  
  if charCount >= maxCharsBriefing then
    love.keyboard.setTextInput(false)
  else
    charCount = charCount + 1
    love.keyboard.setTextInput(true)
  end
  
end

return TE