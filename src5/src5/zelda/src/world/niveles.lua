function room0(player)
room = Room(player, 1, 1)
room:generateEntity('bat', 2)
room:generateEntity('slime', 1)
room:generateDoorWays(true, false, false, false)
return room
end

function room1(player)
  room = Room(player,0,2)
  room:generateEntity('bat', 1)
  room:generateDoorWays(false, true, true, false)
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