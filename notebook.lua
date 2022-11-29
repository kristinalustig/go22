local SC = require "sceneContent"

N = {}

local clues = 
{polaroid = "There's a photo of Sparrow on the board with a caption that reads 'My brother W.S.' She looks anxious.",
  tickets = "There are two tickets to the opera on February 15 tacked to the board. The stubs are not torn.",
  flower = "The flower in the vase seems fresh, but it's just plastic.", 
  key = "Sparrow's car keys are still at home, so wherever she is, she didn't bring her car.",
  linedPaper = "Sparrow had a lot of perishable groceries on her shopping list. She wasn't planning on going anywhere.",
  postIts = "There's some sort of code involving numbers on the post-it notes on the whiteboard.", 
  guide = "Sparrow has an Alaskan hiking guide in her chest.", 
  garbage = "The food-related garbage in the can is starting to rot.", 
  answeringMachine = "There are several messages on the machine. I wrote down the transcripts here.",
  backpack = "The backpack in the chest has never been used, but seems meant for a long trip.", 
  painting = "The painting is of Sparrow hiking in the mountains, she seems to really love that.",
  calendar = "The calendar has many appointments throughout.", 
  map = "The map has some letters circled across its quadrants.", 
  stickers = "The stickers on the chest have numbers and letters on them.",
  letter = "There's a threatening letter to 'Jean' from a 'Spider.' What a weird name.", 
  receipt = "Sparrow purchased camping supplies on February 13.", 
  envelope = "The envelope is addressed to 'Jean Cabot.'",
  boots = "The boots are broken in but have no traces of mud.",
  carpet = "The apartment is exceptionally tidy, so why is there a big rip in the carpet? Did something happen here?"
}

local foundCluesTest = {"There's a photo of Sparrow on the board with a caption that reads 'My brother W.S.' She looks anxious.",
  "There are two tickets to the opera on February 15 tacked to the board. The stubs are not torn.",
  "The flower in the vase seems fresh, but it's just plastic.", 
  "Sparrow's car keys are still at home, so wherever she is, she didn't bring her car.",
  "Sparrow had a lot of perishable groceries on her shopping list. She wasn't planning on going anywhere.",
  "There's some sort of code involving numbers on the post-it notes on the whiteboard.", 
  "Sparrow has an Alaskan hiking guide in her chest.", 
  "The food remains in the can are starting to rot, it's been there for a while.", 
  "There are several messages on the machine. I wrote down the transcripts here.",
  "The backpack in the chest has never been used, but seems meant for a long trip.", 
  "The painting is of Sparrow hiking in the mountains, she seems to really love that.",
  "The calendar has many appointments throughout.", 
  "The map has some letters circled across its quadrants.", 
  "The stickers on the chest have numbers and letters on them.",
  "There's a threatening letter to 'Jean' from a 'Spider.'", 
  "Sparrow purchased camping supplies on February 13.", 
  "The envelope is addressed to 'Jean Cabot'.",
  "The boots are broken in but have no traces of mud.",
  "The apartment is exceptionally tidy, so why is there a big rip in the carpet? Did something happen here?"
}

local foundClues = {}


function N.drawClues()
  
  if #foundClues > 0 then
    local iter = 96
    local height = 40
    --print("start")
    for k, v in ipairs(foundClues) do
      --print(k .. " " ..#v)
      if #v > 70 then
        height = 40
      else
        height = 20
      end
      lg.printf("- "..v, 480, iter, 580, "left")
      iter = iter + height
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
  elseif obj == "postits" then
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
  elseif obj == "boots" then
    if not N.clueAlreadyFound(clues.boots) then
      table.insert(foundClues, clues.boots)
      return true
    else
      return false
    end
  elseif obj == "carpet" then
    if not N.clueAlreadyFound(clues.carpet) then
      table.insert(foundClues, clues.carpet)
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