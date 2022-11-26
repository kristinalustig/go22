SC = {}

local background
local titlePage
local comicPage1
local comicPage2
local comicPage3
local briefingScreen
local briefingText
local notebook
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

local consoleColor

local item

local gameFont
local uiLabel
local briefingFont

local currentScene
local midFade
local comicNum

--important "special" states for investigation 1. janky, I know.
local pinkDrawerIsOpen
local purpleDrawerIsOpen
local lightIsOn
local chestIsOpen
local curtainsAreOpen

local errorText

function SC.loadAssetsOnStart()
  
  gameFont = lg.newFont("/assets/fonts/CourierPrime-Regular.ttf", 16)
  uiLabel = lg.newFont("/assets/fonts/CourierPrime-Regular.ttf", 12)
  briefingFont = lg.newFont("/assets/fonts/CrimsonText-Regular.ttf", 30)
  
  background = lg.newImage("/assets/background.png")
  notebook = lg.newImage("/assets/notebook.png")
  map = lg.newImage("/assets/map.png")
  calendar = lg.newImage("/assets/calendar.png")
  ui = lg.newImage("/assets/ui.png")
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
  
  currentScene = Scenes.INVESTIGATION_1
  
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
      lg.draw(pinkDrawerIsOpen)
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
      if purpleDrawerIsOpen then
        lg.setColor(0, 0, 0, .3)
        lg.rectangle(0, 0, 800, 700)
        lg.draw(bgWIthDrawerOpen)
      else
        lg.draw(bgWithOverlay)
      end
    end
    if lightIsOn then
      lg.draw(lightPluggedIn)
      lg.draw(lightOn)
    else
      lg.draw(lightPlugOut)
    end
    
  elseif currentScene == Scenes.NOTEBOOK then
    lg.draw(notebook)
  elseif currentScene == Scenes.MAP then
    lg.draw(map)
  elseif currentScene == Scenes.CALENDAR then
    lg.draw(calendar)
  elseif currentScene == Scenes.DIARY then
    lg.draw(diary)
  elseif currentScene == Scenes.LETTER then
    lg.draw(letter)
----------NEED NEW FONT HERE!-------------------------------------------------
    lg.printf(
  elseif currentScene == Scenes.HELP then
----------NEED NEW FONT HERE!-------------------------------------------------
    lg.draw(helpScreen)
  elseif currentScene == Scenes.DOSSIER then
----------NEED NEW FONT HERE!-------------------------------------------------
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
  end
  
  lg.draw(ui)
  lg.setColor(consoleColor)
  lg.setFont(uiLabel)
  lg.printf("'notes'", 26, 78, 100, "center")
  lg.printf("'help'", 104, 78, 100, "center")
  lg.printf("'station'", 186, 78, 100, "center")
  lg.printf("'dossier'", 270, 78, 100, "center")
  
  lg.setColor(0, 0, 0)
  lg.setFont(gameFont)
  if currentScene == Scenes.NOTEBOOK then
    N.drawClues()
  end
  
  if currentScene ~= Scenes.INVESTIGATION_1 then
    lg.setColor(consoleColor)
    lg.printf("(Hit 'esc' or type 'back' to return)", 30, 620, 500, "left")
  end
  
  if midFade >= 0 then
    midFade = midFade - .01
    lg.setColor(0, 0, 0, midFade)
    lg.rectangle("fill", 0, 0, 1400, 700)
  end
  
end

function SC.setSuggestionsFont()
  lg.setFont(uiLabel)
end

function SC.setTextFont()
  lg.setColor(consoleColor)
  lg.setFont(gameFont)
end

function SC.setDialogFont()
  lg.setColor(0,0,0)
  lg.setFont(briefingFont)
end

function SC.executeAction(action, obj, state)
  
  if action == "1223" then
    chestIsOpen = true
    return ("You unlocked the chest!")
  end
  
  if action == "reset" then
    item = ""
    currentScene = Scenes.INVESTIGATION_1
  elseif action == "help" then
    item = "help"
    currentScene = Scenes.HELP
    return "*Opening help folder...*"
  elseif action == "dossier" then
    item = "dossier"
    currentScene = Scenes.DOSSIER
    return "*Opening dossier...*"
  elseif action == "clue" then
    N.add(obj)
    --play a clue found sound
    --blink the notebook
  elseif action == "zoom" then
    item = obj
  elseif action == "sceneChange" then
    item = obj
    currentScene = SC.getNewScene(item)
  elseif action == "special" then
    return SC.handleSpecialActions(obj, state)
  elseif action == "notes" then
    item = "notebook"
    currentScene = Scenes.NOTEBOOK
    return "*Opening notebook...*"
  elseif action == "station" then
    currentScene = Scenes.DEBRIEFING_1
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
    if (state == "open" and chestIsOpen) or (state == "close" and not chestIsOpen) then
        chestIsOpen = not chestIsOpen
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
  
  return "You can't do that."
end

function SC.updateDraw()
  if item == "map" or item == "notebook" or item == "help" or item == "dossier" or item == "chest" or item == "letter" or item == "calendar" then
    scale = 2
  elseif item == "desk" or item == "envelope" or item == "telephone" or item == "pink desk drawer" or item == "purple desk drawer" or item == "answering machine" or item == "book" or item == "pen" or item == "telephone receiver" or item == "vase" or item == "painting" then
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