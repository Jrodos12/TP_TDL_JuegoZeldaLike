--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]


Room = Class{}

function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT
    self.waitTimer = 0
    self.wait = false
    self.waitTime = 0

    
    self.waitTimerSW = 0
    self.waitSW = false
    self.waitTimeSW = 0

    
    self.tiles = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    --self:generateEntities()
    
    -- game objects in the room
    self.objects = {}
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    --table.insert(self.doorways, Doorway('top', false, self))
    --table.insert(self.doorways, Doorway('bottom', false, self))
    --table.insert(self.doorways, Doorway('left', false, self))
    --table.insert(self.doorways, Doorway('right', false, self))

    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = ENTITY_DEFS[type].health
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

function generate_random_coordinates()
    return math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16), 
                    math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
end

--Inserta un objeto a la tabla con coordenadas aleatorias, y le asigna un comportamiento
--en el caso de que colisione con el jugador
function add_object(table,room,type,on_collide_behaviour)
    random_x, random_y = generate_random_coordinates()
    table.insert(room.objects, GameObject(
        GAME_OBJECT_DEFS[type],
        random_x,
        random_y
    ))
    local obj = room.objects[#room.objects]
    obj.onCollide = on_collide_behaviour
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    function health_potion_on_collide(heal_pot)
        if heal_pot.state == 'sitting' then
            gSounds['potion']:play()
            self.player.health = 8 --Podriamos usar una variable para max health en el futuro
        end
        heal_pot.state = 'used'
    end

    -- define a function for the switch that will open all doors in the room
    function switch_on_collide(switch)     
        if switch.state == 'unpressed' and not self.player.switchinvulnerable then
            local allDead = true
            for k, entity in pairs(self.entities) do
              if not entity.dead then allDead = false end
            end

            if allDead then
              switch.state = 'pressed'
              -- open every door in the room if we press the switch
              for k, doorway in pairs(self.doorways) do
                  doorway.open = true
              end
              gSounds['door']:play()
            else
              self.waitTimer = love.timer.getTime(0)
              self.wait = true
              self.waitTime = 1.7
            end
        end
    end


    --Definimos una funcion que de invulnerabilidad al jugador por 10 segundos
    --Tambien cambia el estado del objet
    function inv_pot_on_collide(inv_pot)
        if inv_pot.state == 'sitting' then
            gSounds['invulnerability-potion']:play()
            self.player:goInvulnerable(5)
        end
        inv_pot.state = 'used'
    end

    --Definimos una funcion que de armadura al jugador
    --Tambien cambia el estado del objeto
    function chest_on_collide(chest)
        if chest.state == 'closed' then
            gSounds['chest']:play()
            self.player:add_armor(1)
        end
        chest.state = 'open'
    end

    function silver_chest_key_on_collide(key)
        if key.state == 'on-floor' then
            gSounds['key']:play()
            self.player:give_silver_chest_keys(1)
        end
        key.state = 'has-been-picked-up'
    end

    function silver_chest_on_collide(chest)
        if chest.state == 'closed' and self.player:try_to_open_silver_chest() then
            gSounds['chest']:play()
            self.player:add_armor(2)
            chest.state = 'open'
        end
    end

    function papersOnCollide(peper2)
    end
    --add_object(table,self,'health-potion',health_potion_on_collide)
    --add_object(table,self,'switch',switch_on_collide)
    -------------------------------- decoraciones
    if math.random(1,10) > 6  then
      for i=1,math.random(1,2) do
        add_object(table,self,'paper1',papersOnCollide)
      end
    end
    if math.random(1,10) > 4  then
      for i=1,math.random(1,2) do
      add_object(table,self,'paper2',papersOnCollide)
      end
    end
    if math.random(1,10) > 5  then
      for i=1,math.random(1,2) do
        add_object(table,self,'paper3',papersOnCollide)
      end
    end    
    ------------------------


    --add_object(table,self,'health-potion',health_potion_on_collide)
    --add_object(table,self,'switch',switch_on_collide)


    --Hay un 20% de chance de que aparezca un cofre gris + su llave
    if math.random(1,10) > 8 then
        add_object(table,self,'key',silver_chest_key_on_collide)
        add_object(table,self,'silver-chest',silver_chest_on_collide)
    end

    --Hay un 50% de chance de que aparezca la pocion de invulnerabilidad
    if math.random(1,10) > 5 then
        add_object(table,self,'invulnerability-potion',inv_pot_on_collide)
    end
    --Hay un 50% de chance de que aparezca un cofre normal
    if math.random(1,10) > 5 then
        add_object(table,self,'chest',chest_on_collide)
    end
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)
  
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end


    if not self.wait then
      self.player:update(dt)
      
      for i = #self.entities, 1, -1 do
          local entity = self.entities[i]
          -------------musica de jefe
          local thereIsNoBoss = true
            for k, entity in pairs(self.entities) do
              if entity.isBoss then thereIsNoBoss = false end
            end
          if thereIsNoBoss then
            gSounds['boss-music']:stop()
            gSounds['music']:setLooping(true)
            gSounds['music']:play()
          else
            gSounds['music']:stop()
            gSounds['boss-music']:setLooping(true)
            gSounds['boss-music']:play()
          end
          ------------------spawn enemigos
          local enemies = 0
          for k, entity in pairs(self.entities) do
            if not entity.dead then enemies = enemies + 1 end
          end
          if not thereIsNoBoss and not self.waitSW then
              if enemies < 12 then
                local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}
                local type = types[math.random(#types)]
                self:generateEntityCorners(type, 1)
                gSounds['spawn']:play()
                self.waitSW = true
                self.waitTimeSW = love.timer.getTime(0)
                self.waitTimerSW = 5
              end
          elseif not thereIsNoBoss then
              local timePassedSW = love.timer.getTime(0) - self.waitTimerSW
              if timePassedSW > self.waitTimeSW then
                self.waitSW = false
                self.waitTimeSW = 0
              end
          end
          -- remove entity from the table if health is <= 0
          if entity.health <= 0 then
              entity.dead = true
              if entity.isBoss then
                gStateMachine:change('game-finished')
              end
          elseif not entity.dead then
              entity:processAI({room = self}, dt)
              entity:update(dt)
          end
---------------------------------
          -- collision between the player and entities in the room
          if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
              gSounds['hit-player']:play()
              self.player:damage(1)
              self.player:goInvulnerable(1.5)

              if self.player.health == 0 then
                  gStateMachine:change('game-over')
              end
          end
      end

      for k, object in pairs(self.objects) do
          object:update(dt)

          -- trigger collision callback on object
          if self.player:collides(object) then
              object:onCollide()
          end
      end
    end
    
    
end


function Room:render()
    
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    if self.player then
        self.player:render()
    end
    
    if self.wait then
      local timePassed = love.timer.getTime(0) - self.waitTimer
      if  timePassed < self.waitTime then 
        love.graphics.setColor(85/255, 148/255, 161/255, 0.2)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 -100, 20,400,18)
        love.graphics.setColor(43/255, 56/255, 69/255, 0.8)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 -200, 20,400,15)
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1,1,1, 1)
        love.graphics.printf('Kill all the enemies to continue', 0, 20, VIRTUAL_WIDTH - 20, 'center')
      else 
        self.wait = false
        self.player:cantPressSwitch(1.7)
        self.waitTime = 0
       
      end
    end
    love.graphics.setStencilTest()
end
function Room:generateDoorWays(doorTop, doorRight, doorDown, doorLeft)
  --door = Doorway('top', false, self)
  if doorTop == 'si' then
    self.doorways['top'] = (Doorway('top', false, self))
    
  end
  if doorDown == 'si' then
    self.doorways['down'] = (Doorway('down', false, self))
  end
  if doorLeft == 'si' then
    self.doorways['left'] = (Doorway('left', false, self))
  end
  if doorRight == 'si' then
    self.doorways['right'] = (Doorway('right', false, self))
  end
end  
function Room:generateEntityCorners(enemy, quantity)
    --local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}
    local XCorners = {MAP_RENDER_OFFSET_X + TILE_SIZE,VIRTUAL_WIDTH - TILE_SIZE * 2 - 16}
    local YCorners = {MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16}
    for i = table.getn(self.entities) + 1 , (table.getn(self.entities) + quantity) do
        --local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[enemy].animations,
            walkSpeed = ENTITY_DEFS[enemy].walkSpeed or 30,

            -- ensure X and Y are within bounds of the map
            x = XCorners[math.random(#XCorners)],
            y = YCorners[math.random(#YCorners)],
            
            width = ENTITY_DEFS[enemy].width or 16,
            height = ENTITY_DEFS[enemy].height or 16,

            health = ENTITY_DEFS[enemy].health,
            isBoss = ENTITY_DEFS[enemy].isBoss or false
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end
function Room:generateSwitch()
  add_object(table,self,'switch',switch_on_collide)
end

function Room:generateEntity(enemy, quantity)
    --local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = table.getn(self.entities) + 1 , (table.getn(self.entities) + quantity) do
        --local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[enemy].animations,
            walkSpeed = ENTITY_DEFS[enemy].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = ENTITY_DEFS[enemy].width or 16,
            height = ENTITY_DEFS[enemy].height or 16,

            health = ENTITY_DEFS[enemy].health,
            isBoss = ENTITY_DEFS[enemy].isBoss or false
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end
function Room:generateSwitch()
  add_object(table,self,'switch',switch_on_collide)
  end