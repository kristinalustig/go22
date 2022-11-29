S = {}
G = require "grammar"
SC = require "sceneContent"

local suggestionsPos
local suggestions
movedToNouns = false

function S.init()
  
  suggestionsPos = 0
  suggestions = {}
  
end

function S.clearSuggestions()
  
  suggestions = {}
  
end


function S.handleSuggestionState(t, key)
  
  if key == "space" then
    movedToNouns = true
    suggestionsPos = 0
    return t
  elseif key == "tab" then
    if suggestionsPos >= #suggestions then
      suggestionsPos = 0
    end
    suggestionsPos = suggestionsPos + 1
  else
    suggestionsPos = 0
  end
  
  if suggestionsPos > 0 and suggestionsPos <= #suggestions then
    if movedToNouns then
        local t = string.sub(t, 1, t:find(" ")).." "
      return t ..suggestions[suggestionsPos]
    else
      return suggestions[suggestionsPos]
    end
  else
    return t
  end
  
end

function S.updateSuggestions(t)
  if suggestionsPos > 0 then return suggestions end
  
  suggestions = {}
  local startSuggsAt = 0
  
  if t ~= nil and #t > 0 then
    t = t:gsub("[^[:alnum:][:space:]]","")
  else
    return
  end
  
  local suggTable = {}
  if movedToNouns then
    startSuggsAt = 1
    suggTable = G.nouns
    local catchFirst = t:find(" ")
    if catchFirst ~= nil then
      t = string.sub(t, t:find(" ")+1)
    else
      return
    end
  else
    suggTable = G.verbs
  end
  for k, v in ipairs(suggTable) do
    if string.len(t) > startSuggsAt and string.match(v, t:lower()) then
      if SC.isCurrentlyAccessible(v) then
        table.insert(suggestions, v)
      end
    end
  end
  
  return suggestions
      
end

function S.drawSuggestions()
  SC.setSuggestionsFont()
  local suggnum = 0
  local yVal = 14
  for k, v in ipairs(suggestions) do
    lg.printf(v, 40+(150*math.floor(suggnum/4)), 610 + yVal*(suggnum%4), 200, "left")
    suggnum = suggnum + 1
  end
  
end


return S