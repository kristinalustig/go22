SC = {}

local background
local titlePage
local comicPage1
local comicPage2
local comicPage3
local briefingScreen
local briefingText
local notebook
local notebookWithTranscription
local openCurtains
local closedCurtains
local lightOn
local chestLid
local pinkDrawerOpen
local purpleDrawerOpen
local map
local calendar
local ui
local diary
local letter
local bgWithOverlay
local bgWIthDrawerOpen
local lightPluggedIn
local lightPlugOut
local dossier
local helpScreen
local chestDisplay
local endScreen
local policeCall
local endOfGame
local tuneOne
local tuneTwo
local tuneTiming

local consoleColor

local item

local gameFont
local uiLabel
local briefingFont
local dossierFont
local endOfGameFont

local currentScene
local midFade
local comicNum

--important "special" states for investigation 1. janky, I know.
local pinkDrawerIsOpen
local purpleDrawerIsOpen
local lightIsOn
local chestIsOpen
local curtainsAreOpen
local heardMachine
local machineIsPlaying
local ansMachineNotes

local errorText
local isZoomed

local answeringMachine

function SC.loadAssetsOnStart()
  
  gameFont = lg.newFont("/assets/fonts/CourierPrime-Regular.ttf", 16)
  uiLabelFontTiny = lg.newFont("/assets/fonts/CourierPrime-Regular.ttf", 12)
  uiLabelFont = lg.newFont("/assets/fonts/OpenSans-Italic.ttf", 20)
  briefingFont = lg.newFont("/assets/fonts/CrimsonText-Regular.ttf", 30)
  dossierFont = lg.newFont("/assets/fonts/CutiveMono-Regular.ttf", 30)
  endOfGameFont = lg.newFont("/assets/fonts/Lora-SemiBold.ttf", 30)
  
  background = lg.newImage("/assets/background.png")
  notebook = lg.newImage("/assets/notebook.png")
  notebookWithTranscription = lg.newImage("/assets/notebookWithTranscription.png")
  map = lg.newImage("/assets/map.png")
  calendar = lg.newImage("/assets/calendar.png")
  ui = lg.newImage("/assets/ui.png")
  endScreen = lg.newImage("/assets/end.png")
  titlePage = lg.newImage("/assets/title.png")
  briefingText = lg.newImage("/assets/briefingText.png")
  briefingScreen = lg.newImage("/assets/briefing.png")
  comicPage1 = lg.newImage("/assets/story.png")
  comicPage2 = lg.newImage("/assets/story2.png")
  comicPage3 = lg.newImage("/assets/story3.png")
  openCurtains = lg.newImage("/assets/curtains-open.png")
  closedCurtains = lg.newImage("/assets/curtains-shut.png")
  lightOn = lg.newImage("/assets/light-rays.png")
  chestLid = lg.newImage("/assets/chest-lid.png")
  pinkDrawerOpen = lg.newImage("/assets/drawer-open-pink.png")
  purpleDrawerOpen = lg.newImage("/assets/drawer-open-purple.png")
  diary = lg.newImage("/assets/diary.png")
  letter = lg.newImage("/assets/letter.png")
  bgWithOverlay = lg.newImage("/assets/bg-overlay-drawer.png")
  bgWIthDrawerOpen = lg.newImage("/assets/bg-drawer-open.png")
  lightPluggedIn = lg.newImage("/assets/lamp-plugged-in.png")
  lightPlugOut = lg.newImage("/assets/lamp-unplugged.png")
  dossier = lg.newImage("/assets/dossier.png")
  helpScreen = lg.newImage("/assets/help.png")
  chestDisplay = lg.newImage("/assets/chest-display.png")
  endOfGame = lg.newImage("/assets/endOfGame.png")
  policeCall = lg.newImage("/assets/policeCall.png")
  
  answeringMachine = love.audio.newSource("/assets/audio/clarinet.mp3", "stream")
  tuneOne = love.audio.newSource("/assets/audio/clarinet.mp3", "stream")
  tuneTwo = love.audio.newSource("/assets/audio/sax.mp3", "stream")
  tuneTiming = 500
    
  lg.setFont(gameFont)
  consoleColor = {.65, .79, .35}
  midFade = 1
  comicNum = 1
  errorText = "You shouldn't have been able to see this message."
  
  pinkDrawerIsOpen = false
  purpleDrawerIsOpen = false
  lightIsOn = true
  chestIsOpen = false
  curtainsAreOpen = true
  heardMachine = true
  machineIsPlaying = false
  
  currentScene = Scenes.INVESTIGATION_1
  tuneTwo:play()
  
end

function SC.getCurrentScene()
  
  return currentScene
  
end

function SC.setCurrentScene(s)
  
  currentScene = s
  
end

function SC.getNumLines(t, w)
  
  local _, text = gameFont:getWrap(t, w)
  return #text
  
end

function SC.draw()
  
  if currentScene == Scenes.INVESTIGATION_1 then
    lg.draw(background)
    if purpleDrawerIsOpen then
      lg.draw(purpleDrawerOpen)
    end
    if pinkDrawerIsOpen then
      lg.draw(pinkDrawerOpen)
    end
    if curtainsAreOpen then
      lg.draw(openCurtains)
    else
      lg.draw(closedCurtains)
    end
    if not chestIsOpen then
      lg.draw(chestLid)
    end
    if not lightIsOn and not curtainsAreOpen then
      lg.draw(bgWithOverlay)
      if purpleDrawerIsOpen then
        lg.draw(bgWIthDrawerOpen)
      end
      if chestIsOpen then
        lg.draw(chestDisplay)
      end
    end
    if lightIsOn then
      lg.draw(lightPluggedIn)
      lg.draw(lightOn)
    else
      lg.draw(lightPlugOut)
    end
    
  elseif currentScene == Scenes.NOTEBOOK then
    if heardMachine == false then
      lg.draw(notebook)
    else
      lg.draw(notebookWithTranscription)
    end
  elseif currentScene == Scenes.MAP then
    lg.draw(map)
  elseif currentScene == Scenes.CALENDAR then
    lg.draw(calendar)
  elseif currentScene == Scenes.DIARY then
    lg.draw(diary)
  elseif currentScene == Scenes.LETTER then
    lg.draw(letter)
    lg.setFont(briefingFont)
    lg.setColor(0, 0, 0)
    lg.printf("JEAN CABOT", 140, 800, 300, "left")
    lg.printf("74F MAGNOLIA STREET", 140, 850, 500, "left")
    lg.printf("PITTSBURG, CA 90107", 140, 900, 300, "left")
  elseif currentScene == Scenes.HELP then
    lg.setFont(dossierFont)
    lg.setColor(0, 0, 0)
    lg.draw(helpScreen)
  elseif currentScene == Scenes.DOSSIER then
    lg.setFont(dossierFont)
    lg.setColor(0, 0, 0)
    lg.draw(dossier)
  end
  
end

function SC.checkFades()
  
  return midFade <= 0
  
end

function SC.incrementComic()
  
  if comicNum < 3 then
    comicNum = comicNum + 1
  else
    currentScene = Scenes.INVESTIGATION_1
  end
end

function SC.drawUi()
  
  if currentScene == Scenes.TITLE then
    lg.draw(titlePage)
    lg.setFont(endOfGameFont)
    lg.setColor(0, 0, 0)
    lg.printf("(Press 'enter' to begin)", 300, 600, 1100, "center")
    return
  elseif currentScene == Scenes.INTRO_BRIEFING then
    lg.draw(briefingScreen)
    if midFade <= 0 then
      lg.draw(briefingText)
    else
      midFade = midFade - .01
      lg.setColor(0, 0, 0, midFade)
      lg.rectangle("fill", 0, 0, 1400, 700)
    end
    return
  elseif currentScene == Scenes.INTRO_COMIC then
    midFade = 1
    if comicNum == 1 then
      lg.draw(comicPage1)
    elseif comicNum == 2 then
      lg.draw(comicPage2)
    else
      lg.draw(comicPage3)
    end
    return
  elseif currentScene == Scenes.DEBRIEFING_1 then
    lg.draw(briefingScreen)
    lg.draw(briefingText)
    return
  elseif currentScene == Scenes.GAME_OVER then
    lg.draw(endScreen)
    lg.setFont(gameFont)
    lg.setColor(0, 0, 0, 1)
    lg.printf("That's the end of the game!", 0, 200, 1400, "center")
    lg.printf("Thank you so much for taking the time to play.", 0, 240, 1400, "center")
    lg.printf("All code, art, music, and game design by kristinamay", 0, 280, 1400, "center")
    return  
  elseif currentScene == Scenes.END_OF_GAME then
    lg.draw(endOfGame)
    if midFade >= 0 then
      midFade = midFade - .01
      lg.setColor(0, 0, 0, midFade)
      lg.rectangle("fill", 0, 0, 1400, 700)
    end
    return  
  elseif currentScene == Scenes.POLICE_CALL then
    lg.draw(policeCall)
    if midFade >= 0 then
      midFade = midFade - .01
      lg.setColor(0, 0, 0, midFade)
      lg.rectangle("fill", 0, 0, 1400, 700)
    end
    return  
  end
  
  lg.draw(ui)
  lg.setColor(consoleColor)
  lg.setFont(uiLabelFontTiny)
  lg.printf("'notes'", 26, 78, 100, "center")
  lg.printf("'help'", 104, 78, 100, "center")
  lg.printf("'station'", 186, 78, 100, "center")
  lg.printf("'dossier'", 270, 78, 100, "center")
  
  lg.setColor(0, 0, 0)
  lg.setFont(gameFont)
  if currentScene == Scenes.NOTEBOOK then
    N.drawClues()
  end
  
  if currentScene ~= Scenes.INVESTIGATION_1 or isZoomed then
    lg.setColor(consoleColor)
    lg.printf("(Hit 'esc' or type 'back' to return)", 30, 560, 500, "left")
  end
  
  if midFade >= 0 then
    midFade = midFade - .01
    lg.setColor(0, 0, 0, midFade)
    lg.rectangle("fill", 0, 0, 1400, 700)
  end
  
end

function SC.setSuggestionsFont()
  lg.setFont(uiLabelFontTiny)
end

function SC.setTextFont()
  lg.setColor(consoleColor)
  lg.setFont(gameFont)
end

function SC.setDialogFont()
  lg.setColor(0,0,0)
  lg.setFont(briefingFont)
end

function SC.setUiLabelFont()
  lg.setColor(1, 1, 1)
  lg.setFont(uiLabelFont)
end

function SC.setFade()
  
  midFade = 1
  
end

function SC.checkDebrief(question, answer)
  
  answer = answer:lower()
  
  if question == "name" then
    if answer:find("jean") and answer:find("cabot") then
      return true
    end
  elseif question == "what" then
    if answer:find("kidnap") or answer:find("abduct") or answer:find("taken") then
      return true
    end
  elseif question == "when" then
    if answer:find("14") or answer:find("15") then
      return true
    end  
  elseif question == "who" then
    if answer:find("spider") then
      return true
    end
  elseif question == "where" then
    if answer:find("williams") then
      return true
    end
  elseif question == "streetNum" then
    if answer:find("126") then
      return true
    end
  end
end


function SC.executeAction(action, obj, state)
  
  if action == "1223" then
    chestIsOpen = true
    return ("You unlocked the chest!")
  end
  
  if action == "reset" then
    item = ""
    isZoomed = false
    currentScene = Scenes.INVESTIGATION_1
  elseif action == "help" then
    item = "help"
    currentScene = Scenes.HELP
    isZoomed = false
    return "*Opening help folder...*"
  elseif action == "dossier" then
    item = "dossier"
    currentScene = Scenes.DOSSIER
    isZoomed = false
    return "*Opening dossier...*"
  elseif action == "clue" then
    local objAdded = N.add(obj)
    item = obj
    isZoomed = true
    if objAdded then
      return "(New clue added to your notes!)"
    else
      return "(Clue is already in your notes.)"
    end
    --play a clue found sound
    --blink the notebook
  elseif action == "zoom" then
    isZoomed = true
    item = obj
  elseif action == "sceneChange" then
    item = obj
    currentScene = SC.getNewScene(item)
    isZoomed = false
  elseif action == "special" then
    isZoomed = false
    return SC.handleSpecialActions(obj, state)
  elseif action == "notes" then
    item = "notebook"
    isZoomed = false
    currentScene = Scenes.NOTEBOOK
    return "*Opening notebook...*"
  elseif action == "station" then
    isZoomed = false
    currentScene = Scenes.DEBRIEFING_1
    return "Heading back to the station."
  end
  
  return "You can't do that."
end

function SC.handleSpecialActions(obj, state)
  
  --curtains
  if obj == "curtains" then
    if (state == "close" and curtainsAreOpen) or (state == "open" and not curtainsAreOpen) then
      curtainsAreOpen = not curtainsAreOpen
      return "true"
    elseif state == "close" and not curtainsAreOpen then
      return "Curtains are already closed."
    elseif state == "open" and curtainsAreOpen then
      return "Curtains are already open."
    elseif state == "toggle" then
      curtainsAreOpen = not curtainsAreOpen
      if curtainsAreOpen then
        return "You open the curtains."
      else
        return "You close the curtains."
      end
    end
    return errorText
  end
  --light
  if obj == "lamp" then
    if (state == "off" and lightIsOn) or (state == "on" and not lightIsOn) then
        lightIsOn = not lightIsOn
      return "true"
    elseif state == "off" and not lightIsOn then
      return "The lamp has already been unplugged."
    elseif state == "on" and lightIsOn then
      return "The lamp is already on."
    elseif state == "toggle" then
      lightIsOn = not lightIsOn
      if not lightIsOn then
        return "You unplug the lamp."
      else
        return "You plug the lamp back in."
      end
    end
    return errorText
  end
  --chest
  if obj == "lock" then
    if state == "open" and not chestIsOpen then
      return "true"
    elseif state == "close" and chestIsOpen then
      chestIsOpen = false
      return "true"
    elseif state == "close" and not chestIsOpen then
      return "The chest is still locked."
    elseif state == "open" and chestIsOpen then
      return "The chest is already unlocked."
    elseif state == "toggle" then
      chestIsOpen = not chestIsOpen
      if chestIsOpen then
        return "You opened the chest and shoved the lid aside."
      else
        return "You closed the chest back up."
      end
    end
    return errorText
  end
  --desk drawers
  if obj == "pink desk drawer" then
    if (state == "close" and pinkDrawerIsOpen) or (state == "open" and not pinkDrawerIsOpen) then
      pinkDrawerIsOpen = not pinkDrawerIsOpen
      return "true"
    elseif state == "close" and not pinkDrawerIsOpen then
      return "The drawer is already closed."
    elseif state == "open" and pinkDrawerIsOpen then
      return "The drawer is already open."
    elseif state == "toggle" then
      pinkDrawerIsOpen = not pinkDrawerIsOpen
      if pinkDrawerIsOpen then
        return "You open the drawer."
      else
        return "You close the drawer."
      end
    end
    return errorText
  end
  
  if obj == "purple desk drawer" then
    if (state == "close" and purpleDrawerIsOpen) or (state == "open" and not purpleDrawerIsOpen) then
      purpleDrawerIsOpen = not purpleDrawerIsOpen
      return "true"
    elseif state == "close" and not purpleDrawerIsOpen then
      return "The drawer is already closed."
    elseif state == "open" and purpleDrawerIsOpen then
      return "The drawer is already open."
    elseif state == "toggle" then
      purpleDrawerIsOpen = not purpleDrawerIsOpen
      if purpleDrawerIsOpen then
        return "You open the drawer."
      else
        return "You close the drawer."
      end
    end
    return errorText
  end
  
  if obj == "answering machine" then
    if state == "on" and machineIsPlaying then
      return "Messages are currently playing."
    elseif state == "off" and not machineIsPlaying then
      return "Messages are not currently playing."
    elseif (state == "on" or state == "toggle") and not machineIsPlaying then
      heardMachine = true
      machineIsPlaying = true
      love.audio.stop()
      answeringMachine:play()
      if state == "toggle" then
        return "You play the messages. (Turn up the sound to hear, or read them in your 'notes'.)"
      else
        return "true"
      end
    elseif (state == "off" or state == "toggle") and machineIsPlaying then
      answeringMachine:stop()
      machineIsPlaying = false
      if state == "toggle" then
        return "You turn off the messages."
      else
        return "true"
      end
    end
  end
  
  return "You can't do that."
end

function SC.updateDraw()
  
  if answeringMachine:isPlaying() then
    machineIsPlaying = true
  else
    machineIsPlaying = false
  end
  
  if not tuneOne:isPlaying() and not tuneTwo:isPlaying() and not machineIsPlaying then
    tuneTiming = tuneTiming - 1
    if tuneTiming <= 0 then
      tuneTiming = 500
      if lastPlayed == tuneOne then
        tuneTwo:play()
        lastPlayed = tuneTwo
      else
        tuneOne:play()
        lastPlayed = tuneOne
      end
    end
  end
  
  --zoom in on corkbooard
  if item == "lined paper" or item == "post-its" or item == "lined paper" or item == "key" or item == "receipt" or item == "corkboard" or item == "tickets" then
    scale = 2.2
    transformX = -400
    transformY = -400
  --zoom in on window area
  elseif item == "window" or item == "painting" or item == "curtains" then
    scale = 2.6
    transformX = -1800
    transformY = -600
  --zoom in on lamp outlet
  elseif item == "lampOutlet" then
    scale = 4
    transformX = -100
    transformY = -1500
  --zoom in on under desk
  elseif item == "garbage" or item == "underDesk" then
    scale = 4
    transformX = -2140
    transformY = -1600
  --special scene screens
  elseif item == "map" or item == "notebook" or item == "help" or item == "dossier" or item == "letter" or item == "calendar" then
    scale = 2
    transformX = 0
    transformY = 0
  --zoom in on chest
  elseif item == "lock" or item == "chest" or item == "backpack" or item == "guide" or item == "ski cap" or item == "boots" or item == "clothing" then
    scale = 4
    transformX = -800
    transformY = -1500
  --zoom in on desk area
  elseif item == "desk" or item == "envelope" or item == "telephone" or item == "pink desk drawer" or item == "purple desk drawer" or item == "answering machine" or item == "book" or item == "pen" or item == "telephone receiver" or item == "vase" then
    scale = 4
    transformX = -2140
    transformY = -1300
  else
    scale = 1
    transformX = 0
    transformY = 0
  end
  
  return scale, transformX, transformY
  
end

function SC.isCurrentlyAccessible(obj)
  if obj == "boots" or obj == "sleeping bag" or obj == "guide" or obj == "clothing" or obj == "ski cap" then
    if chestIsOpen then
      return true
    else
      return false
    end
  end
  return true
end

function SC.getNewScene(i)
  
  if i == "map" then
    return Scenes.MAP 
  elseif i == "calendar" then
    return Scenes.CALENDAR
  elseif i == "book" then
    return Scenes.BOOK
  elseif i == "letter" then
    return Scenes.LETTER
  end
  
end
    
return SC