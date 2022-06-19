function split(pString, pPattern)
   local Table = {}  
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function loadDungeon(path, player)
  local file = io.open(path,"r")
  local lineSplit,rooms, dungeon = {}, {},{}
  io.input(file)
  local dimensionDungeon = split (io.read(), ',')
  local alto,largo = dimensionDungeon[1], dimensionDungeon[2]
  header = io.read()
  for line in io.lines()  do
    lineSplit = split(line,',')
    local enemies,topDoor,leftDoor,downDoor,rightDoor,newRoom = lineSplit[1],lineSplit[2],lineSplit[3],lineSplit[4],lineSplit[5],Room(player)
    for index, enemy in ipairs( split(enemies, ';') ) do
      local enemyData = split(enemy, ':')
      local nombre,cantidad = enemyData[1],enemyData[2]
      newRoom:generateEntity(nombre, cantidad)
      newRoom:generateDoorWays(topDoor,leftDoor,downDoor,rightDoor)
    end
    table.insert(rooms, newRoom)
  end
  io.close()
  local indice = 1
  for j = 1, largo do
    table.insert(dungeon, {})
    for i = 1, alto do
      table.insert(dungeon[j], rooms[indice])
      indice = indice + 1
    end
  end
  
  return dungeon
end