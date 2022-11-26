local SC = require "sceneContent"

N = {}

local clues = 
{polaroid = "There's a photo of Sparrow on the board with a caption that reads 'My brother W.S.' She looks anxious.",
  tickets = "There are two tickets to the opera on February 18 tacked to the board. The stubs are not torn.",
  flower = "The flower in the vase on the desk appears fresh, but is actually just plastic.", 
  key = "Sparrow's car keys are still at home.",
  linedPaper = "Sparrow had a large list of perishable groceries on her shopping list.",
  postIts = "clue", 
  guide = "Sparrow had a guide to Alaska's best hikes in her chest.", 
  garbage = "The food-related garbage in the can is starting to rot.", 
  answeringMachine = "There are several messages on the machine.",
  backpack = "The backpack in the chest has never been used, but seems meant for a long trip.", 
  painting = "The painting is of Sparrow hiking in the mountains.",
  calendar = "There are several appointments on the calendar.", 
  map = "The map has some street names highlighted across its quadrants.", 
  stickers = "The stickers across the chest have numbers and letters on them.",
  letter = "clue", 
  receipt = "Sparrow purchased lots of camping supplies on February 13.", 
  envelope = "The envelope has no return address but is addressed to Jean Cabot."
}

local foundClues = {}


function N.drawClues()
  
  if #foundClues > 0 then
    local iter = 80
    for k, v in ipairs(foundClues) do
      local textLines = SC.getNumLines(v, 600)
      lg.printf("- "..v, 580, iter + (40*textLines), 600, "left")
      iter = iter + (textLines * 40)
    end
  end

end

function N.add(obj)
  
  if obj == "polaroid" then
    if not N.clueAlreadyFound(clues.polaroid) then
      table.insert(foundClues, clues.polaroid)
      return true
    else
      return false
    end
  elseif obj == "tickets" then
    if not N.clueAlreadyFound(clues.tickets) then
      table.insert(foundClues, clues.tickets)
      return true
    else
      return false
    end
  elseif obj == "flower" then
    if not N.clueAlreadyFound(clues.flower) then
      table.insert(foundClues, clues.flower)
      return true
    else
      return false
    end
  elseif obj == "key" then
    if not N.clueAlreadyFound(clues.key) then
      table.insert(foundClues, clues.key)
      return true
    else
      return false
    end
  elseif obj == "lined paper" then
    if not N.clueAlreadyFound(clues.linedPaper) then
      table.insert(foundClues, clues.linedPaper)
      return true
    else
      return false
    end
  elseif obj == "post-its" then
    if not N.clueAlreadyFound(clues.postIts) then
      table.insert(foundClues, clues.postIts)
      return true
    else
      return false
    end
  elseif obj == "guide" then
    if not N.clueAlreadyFound(clues.guide) then
      table.insert(foundClues, clues.guide)
      return true
    else
      return false
    end
  elseif obj == "garbage" then
    if not N.clueAlreadyFound(clues.garbage) then
      table.insert(foundClues, clues.garbage)
      return true
    else
      return false
    end
  elseif obj == "answering machine" then
    if not N.clueAlreadyFound(clues.answeringMachine) then
      table.insert(foundClues, clues.answeringMachine)
      return true
    else
      return false
    end
  elseif obj == "backpack" then
    if not N.clueAlreadyFound(clues.backpack) then
      table.insert(foundClues, clues.backpack)
      return true
    else
      return false
    end
  elseif obj == "painting" then
    if not N.clueAlreadyFound(clues.painting) then
      table.insert(foundClues, clues.painting)
      return true
    else
      return false
    end
  elseif obj == "calendar" then
    if not N.clueAlreadyFound(clues.calendar) then
      table.insert(foundClues, clues.calendar)
      return true
    else
      return false
    end
  elseif obj == "map" then
    if not N.clueAlreadyFound(clues.map) then
      table.insert(foundClues, clues.map)
      return true
    else
      return false
    end
  elseif obj == "stickers" then
    if not N.clueAlreadyFound(clues.stickers) then
      table.insert(foundClues, clues.stickers)
      return true
    else
      return false
    end
  elseif obj == "letter" then
    if not N.clueAlreadyFound(clues.letter) then
      table.insert(foundClues, clues.letter)
      return true
    else
      return false
    end
  elseif obj == "receipt" then
    if not N.clueAlreadyFound(clues.receipt) then
      table.insert(foundClues, clues.receipt)
      return true
    else
      return false
    end
  elseif obj == "envelope" then
    if not N.clueAlreadyFound(clues.envelope) then
      table.insert(foundClues, clues.envelope)
      return true
    else
      return false
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