function room0(player)
room = Room(player, 1, 1)
room:generateEntitie('bat', 0)
room:generateEntitie('slime', 0)
room:generateDoorsWays(true, false, false, false)
return room
end

function room1(player)
  room = Room(player,0,2)
  room:generateEntitie('bat', 0)
  room:generateDoorsWays(false, true, true, false)
  return room
end

function room2(player)
  room = Room(player,0,2)
  room:generateEntitie('bat', 0)
  room:generateDoorsWays(false, false, true, true)
  return room
end

function room3(player)
  room = Room(player,0,2)
  room:generateEntitie('bat', 0)
  room:generateDoorsWays(true, false, false, false)
  return room
end