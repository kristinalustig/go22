N = require("notebook")
SC = require("sceneContent")

G = {}

G.verbs = {}

G.nouns = {}

G.combos = {}

G.dialog = {}

local currentDialogPosition = 1
local waitOnScreen = 200

G.specialCommands = {
  "help", "notes", "back", "reset"
  }

local scale = 1
local transformX = 0
local transformY = 0

function G.loadContentOnStart()
  
  for line in love.filesystem.lines("content/verbs.txt") do
    table.insert(G.verbs, line)
  end
  
  for line in love.filesystem.lines("content/nouns.txt") do
    table.insert(G.nouns, line)
  end
  
  for line in love.filesystem.lines("content/combos.txt") do
    table.insert(G.combos, G.splitLinesBySemicolon(line))
  end
  
  for line in love.filesystem.lines("content/dialog.txt") do
    table.insert(G.dialog, line)
  end
  
end


function G.checkMatches(t)

  for k, v in ipairs(G.combos) do
    if t:find(v[1]) and t:find(v[2]) then
      if v[4] ~= nil then
        SC.executeAction(v[4], v[5])
      end
      return v[3]
    end
  end
  for k, v in ipairs(G.specialCommands) do
    if t:find(v) then
      local textToDisplay = SC.executeAction(t)
      return textToDisplay
    end
  end
  
  return "You can't do that."
  
end

function G.drawDialog(num)
  
  local scene = SC.getCurrentScene()
  
  if scene == Scenes.INTRO_BRIEFING or scene == Scenes.DEBRIEFING_1 then
    lg.printf(G.dialog[num]:sub(1, currentDialogPosition), 90, 120, 600, "left")
  elseif scene == Scenes.INTRO_COMIC then
    lg.printf(G.dialog[num]:sub(1, currentDialogPosition), 40, 620, 1200, "left")
  end
  
  if currentDialogPosition < string.len(G.dialog[num]) then
    currentDialogPosition = currentDialogPosition + 1
  else
    waitOnScreen = waitOnScreen - 1
    if waitOnScreen <= 0 then
      waitOnScreen = 200
      return true
    end
  end
  return false
  
end

function G.resetCurrDiagNum()
  
  currentDialogPosition = 1
  
end

function G.splitLinesBySemicolon(line)
  
  local values = {}
  for value in line:gmatch("[^;]+") do
    if value:sub(1,1) == " " then
      value = value:sub(2)
    end
    if value == "nil" then
      value = nil
    end
    table.insert(values, value)
  end
  return values
  
end
  
return G
