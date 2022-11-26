local G = require("grammar")
local TE = require("textEntry")
local SC = require("sceneContent")
lg = love.graphics

local scale, tx, ty

Scenes = {
    TITLE_SCREEN = 1,
    INTRO_BRIEFING = 2,
    INTRO_COMIC = 3,
    INVESTIGATION_1 = 4,
    NOTEBOOK = 5,
    DIARY = 6,
    CALENDAR = 7,
    MAP = 8,
    DEBRIEFING_1 = 9,
    GAME_OVER = 10,
    HELP = 11
}

function love.load()
  
  G.loadContentOnStart()
  TE.init()
  SC.loadAssetsOnStart()

end

function love.update(dt)

  TE.updateText()
  scale, tx, ty = SC.updateDraw()
  SC.checkFades()

end

function love.draw()
  
  lg.scale(.3, .3)
  lg.translate(1500, 0)
  --special addtl scale and translate for zooming on areas of screen
  lg.scale(scale, scale)
  lg.translate(tx, ty)
  SC.draw()
  lg.reset()
  
  SC.drawUi()
  TE.drawText()
  lg.reset()
  
end

function love.textinput(t)
  
  TE.textInput(t)
  
end

function love.keypressed(key)
  
  TE.handleKeyPressed(key)
  
end
