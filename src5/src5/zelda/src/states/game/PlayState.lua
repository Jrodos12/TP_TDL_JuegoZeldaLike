--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,
        
        width = 16,
        height = 22,

        -- one heart == 2 health
        health = 8, -- Esto cambia el valor pero hay q modificar la graficacion de corazones. Lo modifique para testing, CAMBIAR!!!

        -- rendering and collision offset for spaced sprites
        offsetY = 3
    }

    self.dungeon = Dungeon(self.player)
    self.currentRoom = Room(self.player)
    
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['second-action'] = function() return PlayerSecondAction(self.player, self.dungeon) end
    }
    self.player:changeState('idle')
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.dungeon:update(dt)
end

function PlayState:render()
    -- render dungeon and all entities separate from hearts GUI
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1
  
    -- ********** MODIFICACION: ahora los corazones se dibujan en base a cuanta vida tiene
    -- asi si le agremos hearts conteiners (posibilidad de recuperar vida) se modifica en base a eso
   
   local heartsDraw = self.player.health -- Como redondea division para abajo y existe tener medio corazon, si es impar tiene q igual dibujar un corazon mas
    if heartsDraw % 2 == 0 then
      heartsDraw = heartsDraw / 2
    else
      heartsDraw = heartsDraw/2 + 1
    end
    
    for i = 1, heartsDraw   do --ACA DIBUJA LOS CORAZONES. No hace falta tocar el resto pq ya utiliza health left para graficar
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1), 2)
        
        healthLeft = healthLeft - 2
    end

    --Dibujamos armor
    for i = 1, self.player.armor do
        love.graphics.draw(gTextures['armor'], gFrames['armor'][5], (i - 1) * (TILE_SIZE + 1), 20)
    end
end