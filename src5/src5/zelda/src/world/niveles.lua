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
  io.read() --para saltearme el header del .csv
  for line in io.lines()  do
    local newRoom = Room(player)
    if line == '' then
      table.insert(rooms, newRoom)
      goto next
    end
    local lineSplit = split(line,',')
    local enemies,topDoor,leftDoor,downDoor,rightDoor,switch,chest = lineSplit[1],lineSplit[2],lineSplit[3],lineSplit[4],lineSplit[5],lineSplit[6],lineSplit[7]
    for index, enemy in ipairs( split(enemies, ';') ) do
      local enemyData = split(enemy, ':')
      local nombre,cantidad = enemyData[1],enemyData[2]
      newRoom:generateEntity(nombre, cantidad)
      newRoom:generateDoorWays(topDoor,leftDoor,downDoor,rightDoor)
    end
    if switch == 'si' then newRoom:generateSwitch() end
    if chest == 'si' then newRoom:generateChest() end
    table.insert(rooms, newRoom)
    ::next::
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