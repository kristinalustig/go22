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
local chestLock
local pinkDrawerOpen
local purpleDrawerOpen
local map
local calendar
local ui
local consoleColor

local item

local gameFont
local uiLabel
local briefingFont

local currentScene
local midFade
local comicNum


function SC.loadAssetsOnStart()
  
  gameFont = lg.newFont("/assets/fonts/CourierPrime-Regular.ttf", 18)
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
    
    
  lg.setFont(gameFont)
  consoleColor = {.65, .79, .35}
  midFade = 1
  comicNum = 1
  
  currentScene = Scenes.INVESTIGATION_1
  
end

function SC.getCurrentScene()
  
  return currentScene
  
end

function SC.setCurrentScene(s)
  
  currentScene = s
  
end

function SC.draw()
  
  if currentScene == Scenes.INVESTIGATION_1 then
    lg.draw(background)
  elseif currentScene == Scenes.NOTEBOOK then
    lg.draw(notebook)
  elseif currentScene == Scenes.MAP then
    lg.draw(map)
  elseif currentScene == Scenes.CALENDAR then
    lg.draw(calendar)
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
  
  lg.setColor(0, 0, 0)
  lg.setFont(gameFont)
  if currentScene == Scenes.NOTEBOOK then
    N.drawClues()
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

function SC.executeAction(action, obj)
  
  if action == "reset" then
    item = ""
    currentScene = Scenes.INVESTIGATION_1
  elseif action == "clue" then
    --register a clue in the notebook
    N.add(obj)
    --play a clue found sound
    --blink the notebook
  elseif action == "zoom" then
    --zoom in on item (aka use an appropriately sized screenshot? lol)
    item = obj
  elseif action == "sceneChange" then
    item = obj
    currentScene = SC.getNewScene(item)
  elseif action == "special" then
    --execute special action for item
  elseif action == "notes" then
    item = "notebook"
    currentScene = Scenes.NOTEBOOK
    return "*Opening notebook...*"
  elseif action == "station" then
    currentScene = Scenes.DEBRIEFING_1
  end
end

function SC.updateDraw()
  if item == "map" then
    scale = 2
  elseif item == "notebook" then
    scale = 2
  elseif item == "polaroid" then
    scale = 2
  elseif item == "tickets" then
    scale = 2
  elseif item == "chest" then
    scale = 2
  elseif item == "calendar" then
    scale = 2
  elseif item == "desk" or item == "envelope" or item == "letter" or item == "telephone" or item == "pink desk drawer" or item == "purple desk drawer" or item == "answering machine" or item == "book" or item == "pen" or item == "telephone receiver" or item == "vase" or item == "painting" then
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
  end
  
end

    
return SC