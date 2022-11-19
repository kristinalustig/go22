local utf8 = require("utf8")
local G = require("grammar")
local S = require("suggestions")
lg = love.graphics

function love.load()
  
  G.loadContentOnStart()
  S.init()
  
  background = lg.newImage("/assets/background.png")
  text = "type here"
  love.keyboard.setKeyRepeat(true)
  maxChars = 20
  charCount = 0
  textHistory = {}
  textSize = 24
  maxTableSize = 5
  textInputY = 580

end

function love.update(dt)
  
  S.updateSuggestions(text)
  
end

function love.draw()
  
  lg.scale(.3, .3)
  lg.translate(1500, 0)
  lg.draw(background)
  lg.reset()
  
  lg.printf(text, 20, textInputY, 400, "left")
  local textPosition = textInputY - (textSize * 1)
  for k, v in ipairs(textHistory) do
    lg.printf(v, 20, textPosition, 200, "left")
    textPosition = textPosition - textSize
  end
  
  S.drawSuggestions()
  
end

function love.textinput(t)
  
  text = text .. t
  
end

function love.keypressed(key)
  
  
  text = S.handleSuggestionState(text, key == "tab")
  
  --send command
  if key == "return" then
    lopOffEndOfTable()
    table.insert(textHistory, 1, text)
    charCount = 0
    text = ""
    love.keyboard.setTextInput(true)
  --remove last latter 
  elseif key == "backspace" then
    local byteoffset = utf8.offset(text, -1)
    if byteoffset then
      text = string.sub(text, 1, byteoffset - 1)
      charCount = charCount - 1
      love.keyboard.setTextInput(true)
    end
    isTabbingThru = false
  elseif charCount >= maxChars then
    love.keyboard.setTextInput(false)
  else
    charCount = charCount + 1
  end
    
end

function lopOffEndOfTable()
  
  if #textHistory > maxTableSize then
    table.remove(textHistory, #textHistory)
  end
  
end

