S = {}
G = require "grammar"

local suggestionsPos
local suggestions
local isTabbingSuggs

function S.init()
  
  suggestionsPos = 0
  suggestions = {}
  
end

function S.handleSuggestionState(t, isTab)
  
  if isTab then
    if suggestionsPos >= #suggestions then
      suggestionsPos = 0
    end
    suggestionsPos = suggestionsPos + 1
  else
    suggestionsPos = 0
  end
  
  if suggestionsPos > 0 and suggestionsPos <= #suggestions then
    return suggestions[suggestionsPos]
  else
    return t
  end
  
end

function S.updateSuggestions(t)
  if suggestionsPos > 0 then return suggestions end
  
  suggestions = {}
  for k, v in ipairs(G.verbs) do
    if string.len(t) >= 1 and string.match(v, t:lower()) then
      table.insert(suggestions, v)
    end
  end
  
  return suggestions
      
end

function S.drawSuggestions()
  
  for k, v in ipairs(suggestions) do
    lg.printf(v, 20, 20*k, 400, "left")
  end
  
end


return S