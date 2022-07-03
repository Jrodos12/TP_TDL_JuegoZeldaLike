GameFinishedState = Class{__includes = BaseState}

function GameFinishedState:update(dt)
    gSounds['music']:stop()
    gSounds['boss-music']:stop()
    gSounds['heart']:stop()
    gSounds['game-finished']:play()

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['game-finished']:stop()
        gSounds['music']:setLooping(true)
        gSounds['music']:play()
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameFinishedState:render()
    --love.graphics.setColor(1, 1, 1, 0.5)
    --love.graphics.rectangle('fill',100,100, VIRTUAL_HEIGHT -100,VIRTUAL_WIDTH-100)
    love.graphics.setFont(gFonts['Triforce'])
    love.graphics.setColor(1,1,1, 1)
    love.graphics.printf('You won the game!', 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['zelda-small2'])
    love.graphics.printf('Press Escape to quit or Enter for main menu', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1,0.7)
end