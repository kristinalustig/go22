N = {}

local clues = 
{polaroid = "clue",
  tickets = "clue",
  flower = "clue", 
  key = "clue",
  linedPaper = "clue",
  postIts = "clue", 
  guide = "clue", 
  garbage = "clue", 
  answeringMachine = "clue",
  backpack = "clue", 
  painting = "clue",
  calendar = "clue", 
  map = "clue", 
  stickers = "clue",
  letter = "clue", 
  receipt = "clue", 
  envelope = "clue"
}

local foundClues = {}


function N.drawClues()
  
  local iter = 1
  
  if #foundClues > 0 then
    for k, v in ipairs(foundClues) do
      lg.printf(v, 600, 100 + (20*iter), 400, "left")
    end
  end

end

function N.add(obj)
  
  if obj == "polaroid" then
    if not N.clueAlreadyFound(clues.polaroid) then
      table.insert(foundClues, clues.polaroid)
    end
  end
  
  
end

function N.clueAlreadyFound(clue)
  
  for k, v in ipairs(foundClues) do
    if v == clue then
      return true
    end
  end
  return false
end

return N