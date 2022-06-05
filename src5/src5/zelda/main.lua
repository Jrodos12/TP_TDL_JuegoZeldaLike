--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Legend of Zelda')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true) --pone la musica en loop
    gSounds['music']:play()

    love.keyboard.keysPressed = {} --settea un diccionario vacio con las keys apretadas
    --Explicacion de esta linea:
    --https://stackoverflow.com/questions/59969356/why-do-we-make-a-separate-function-for-detecting-input-for-other-classes

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true -- pone que dic[key] = true si lo apretas
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] -- para saber si apreto tecla chequea dic
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {} --vacia el dic
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
