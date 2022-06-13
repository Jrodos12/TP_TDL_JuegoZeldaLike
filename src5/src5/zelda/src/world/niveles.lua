function room0(player)
room = Room(player, 1, 1)
room:generateEntitie('bat', 2)
room:generateEntitie('slime', 1)
room:generateDoorsWays(true, false, false, false)
return room
end

function room1(player)
  room = Room(player,0,2)
  room:generateEntitie('bat', 1)
  room:generateDoorsWays(false, true, true, false)
  return room
end

function room2(player)
  room = Room(player,0,2)
  room:generateEntity('bat', 0)
  room:generateDoorWays(false, false, true, true)
  return room
end

function room3(player)
  room = Room(player,0,2)
  room:generateEntity('bat', 0)
  room:generateDoorWays(true, false, false, false)
  return room
end