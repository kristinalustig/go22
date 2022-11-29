N = require("notebook")
SC = require("sceneContent")

G = {}

G.verbs = {}

G.nouns = {}

G.combos = {}

G.dialog = {}

local currentDialogPosition = 1
local waitOnScreen = 300

G.specialCommands = {
  "help", "notes", "back", "reset", "1223", "dossier", "station"
  }

local scale = 1
local transformX = 0
local transformY = 0
local numTimesCantDoThat = 0

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


function G.checkNouns(n)
  
  if n == "bin" or n == "refuse" or n == "trash" or n == "wastebasket" or n == "dustbin" then
    return "garbage"
  elseif n == "pinboard" or n == "board" or n == "notice board" then
    return "corkboard"
  elseif n == "photo" or n == "snapshot" then
    return "polaroid"
  elseif n == "sticky notes" or n == "stickies" or n == "post-its" then
    return "postits"
  end
  
  return n
end


function G.checkMatches(t)

  local noun = ""
  if t ~= "" and t ~= nil then
    if t:find(" ") then
      noun = t:sub(t:find(" ")+1, #t)
    end
  end

  local needsReplacement = G.checkNouns(noun)
  if needsReplacement ~= noun then
    t = t..needsReplacement
  end

  for k, v in ipairs(G.combos) do
    local hackyskip = false
    if t:find(v[1]) ~= nil and v[1] == "code" then
      return SC.executeAction(nil, "code", t:sub(t:find("e")+2, #t))
    elseif t:find(v[1]) ~= nil and t:find(v[2]) ~= nil then
      if v[2] == "lamp" and t:find("outlet") then
        hackyskip = true--fix someday; this finds "lamp" when it is supposed to find "lamp outlet" sometimes
      elseif v[2] == "desk" and t:find("drawer") then
        hackyskip = true --fix someday; this finds "lamp" when it is supposed to find "lamp outlet" sometimes
      elseif v[2] == "telephone" and t:find("receiver") then
        hackyskip = true
      elseif v[2] == "desk" and t:find("outlet") then
        hackyskip = true
      elseif v[2] == "lamp" and t:find("lamp plug") then
        hackyskip = true
      end
      if not hackyskip then
        if not SC.isCurrentlyAccessible(v[2]) then
          return "You can't do that."
        end
        if v[4] ~= nil then
          if v[4] == "special" then
            local textToDisplay = SC.executeAction(v[4], v[5], v[6])
            if textToDisplay == "true" then
              return v[3]
            else
              return textToDisplay
            end
          elseif v[4] == "clue" then
            local textToDisplay = v[3] .. " ".. SC.executeAction(v[4], v[5], nil)
            return textToDisplay
          else
            SC.executeAction(v[4], v[5], nil)
          end
        end
        return v[3]
      end
    end
  end
  for k, v in ipairs(G.specialCommands) do
    if t:find(v) then
      local textToDisplay = SC.executeAction(t)
      return textToDisplay
    end
  end
  
  numTimesCantDoThat = numTimesCantDoThat + 1
  
  if numTimesCantDoThat == 6 then
    return "You can't do that, either. Are you really just trying every action possible? Button mashing? Good for you."
  else
    return "You can't do that."
  end
  
end

function G.drawDialog(num)
  
  local scene = SC.getCurrentScene()
  
  if scene == Scenes.POLICE_CALL then
    num = num + 1
  end
  
  if scene == Scenes.INTRO_BRIEFING or scene == Scenes.DEBRIEFING_1 then
    lg.printf(G.dialog[num]:sub(1, currentDialogPosition), 90, 120, 650, "left")
  elseif scene == Scenes.POLICE_CALL then
    lg.setColor(1, 1, 1)
    SC.setEndFont()
    lg.printf(G.dialog[num-1], 100, 200, 800, "center")
    lg.printf(G.dialog[num]:sub(1, currentDialogPosition), 100, 400, 800, "left")
  elseif scene == Scenes.END_OF_GAME then
    lg.setColor(0, 0, 0)
    SC.setEndFont()
    lg.printf(G.dialog[num]:sub(1, currentDialogPosition), 100, 200, 800, "left")
  end
  
  if currentDialogPosition < string.len(G.dialog[num]) then
    currentDialogPosition = currentDialogPosition + 1
  else
    if scene == Scenes.DEBRIEFING_1 then
      -----NEW FONT HERE
      SC.setUiLabelFont()
      lg.printf(G.dialog[num+1], 90, 380, 600, "left")
    elseif scene == Scenes.POLICE_CALL then
      lg.printf(G.dialog[num+1], 0, 580, 1400, "center")
    elseif scene == Scenes.END_OF_GAME then
      lg.printf(G.dialog[num+1], 0, 580, 1400, "center")
    else
      waitOnScreen = waitOnScreen - 1
      if waitOnScreen <= 0 then
        waitOnScreen = 200
        return true
      end
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
    if value:sub(#value, #value) == " " then
      value = value:sub(1, #value-1)
    end
    if value == "nil" then
      value = nil
    end
    table.insert(values, value)
  end
  return values
  
end
  
return G
