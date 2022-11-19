G = {}

G.verbs = {}

G.nouns = {}

function G.loadContentOnStart()
  
  for line in love.filesystem.lines("content/verbs.txt") do
    table.insert(G.verbs, line)
  end
  
end


return G
