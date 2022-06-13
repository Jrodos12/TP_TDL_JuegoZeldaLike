--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Dungeon = Class{}

function Dungeon:init(player)
    self.player = player

    self.rooms = {{room1(player),room0(player) }, {room2(player), room3(player)}}
    self.currentRoomx = 1
    self.currentRoomy = 2
    self.light = 0
    self.pulse = true
    self.current = 0.6
    -- current room we're operating in
    --table.insert(self.rooms, room0(player))
    --table.insert(self.rooms, room1(player))
    self.currentRoom = (self.rooms[self.currentRoomx][self.currentRoomy])
    
    -- room we're moving camera to during a shift; becomes active room afterwards
    self.nextRoom = nil

    -- love.graphics.translate values, only when shifting screens
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    -- trigger camera translation and adjustment of rooms whenever the player triggers a shift
    -- via a doorway collision, triggered in PlayerWalkState
    Event.on('shift-left', function()
        self:beginShifting(-VIRTUAL_WIDTH, 0, 'right')
    end)

    Event.on('shift-right', function()
        self:beginShifting(VIRTUAL_WIDTH, 0, 'left')
    end)

    Event.on('shift-up', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT, 'down')
    end)

    Event.on('shift-down', function()
        self:beginShifting(0, VIRTUAL_HEIGHT, 'top')
    end)
end

--[[
    Prepares for the camera shifting process, kicking off a tween of the camera position.
]]
function Dungeon:beginShifting(shiftX, shiftY,deDondeVengo)
    self.shifting = true
    self.currentRoomx = self.currentRoomx + (shiftX / VIRTUAL_WIDTH)  
    self.currentRoomy = self.currentRoomy + (shiftY / VIRTUAL_HEIGHT)
    
    self.nextRoom = (self.rooms[self.currentRoomx][self.currentRoomy])

    -- start all doors in next room as open until we get in
    for k, doorway in pairs(self.nextRoom.doorways) do
        doorway.open = true
    end

    self.nextRoom.adjacentOffsetX = shiftX
    self.nextRoom.adjacentOffsetY = shiftY

    -- tween the player position so they move through the doorway
    local playerX, playerY = self.player.x, self.player.y

    if shiftX > 0 then
        playerX = VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + TILE_SIZE)
    elseif shiftX < 0 then
        playerX = -VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width)
    elseif shiftY > 0 then
        playerY = VIRTUAL_HEIGHT + (MAP_RENDER_OFFSET_Y + self.player.height / 2)
    else
        playerY = -VIRTUAL_HEIGHT + MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
    end

    -- tween the camera in whichever direction the new room is in, as well as the player to be
    -- at the opposite door in the next room, walking through the wall (which is stenciled)
    Timer.tween(1, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()
        self:finishShifting()

        -- reset player to the correct location in the room
        if shiftX < 0 then
            self.player.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width
            self.player.direction = 'left'
        elseif shiftX > 0 then
            self.player.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.player.direction = 'right'
        elseif shiftY < 0 then
            self.player.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
            self.player.direction = 'up'
        else
            self.player.y = MAP_RENDER_OFFSET_Y + self.player.height / 2
            self.player.direction = 'down'
        end

        -- close all doors in the current room
        for k, doorway in pairs(self.currentRoom.doorways) do
              doorway.open = false
        end
        (self.currentRoom.doorways[deDondeVengo]).open = true

        gSounds['door']:play()
    end)
end

--[[
    Resets a few variables needed to perform a camera shift and swaps the next and
    current room.
]]
function Dungeon:finishShifting()
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    self.currentRoom = self.nextRoom
    self.nextRoom = nil
    self.currentRoom.adjacentOffsetX = 0
    self.currentRoom.adjacentOffsetY = 0 
end

function Dungeon:update(dt)
    -- pause updating if we're in the middle of shifting
    if self.player.health <=2 then
        gSounds['heart']:setLooping(true)
        gSounds['heart']:play()
        if self.light>0 and self.pulse then
        self.light = self.light - 0.005
        effect.desaturate.strength = self.light
        else
          self.pulse = false
          self.light = self.light + 0.005
          effect.desaturate.strength = self.light
          if self.light > 0.15 then
            self.pulse = true
          end
        end--
    else
      effect.desaturate.strength = 0
    end
      
    if not self.shifting then    
        
        self.currentRoom:update(dt)
    else
        -- still update the player animation if we're shifting rooms
        self.player.currentAnimation:update(dt)
    end
    if self.player.health <=2 then
      self.currentRoomx = 1
      self.currentRoomy = 2
    end
end

function Dungeon:render()
    -- translate the camera if we're actively shifting
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    effect(function()
      self.currentRoom:render()
    end)
  
  
    if self.nextRoom then
        self.nextRoom:render()
    end
end