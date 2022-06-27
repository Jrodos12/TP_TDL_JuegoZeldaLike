--
-- libraries
--
-- ACA AGREGAR FONTS, SONIDOS ETC

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
Moonshine = require 'lib/moonshine'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'
require 'src/world/niveles'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerSecondAction'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/gamefinished'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/alt.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('graphics/character_walk2.png'),
    ['character-swing-sword'] = love.graphics.newImage('graphics/character_swing_sword2.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['potion'] = love.graphics.newImage('graphics/potion.png'),
    ['armor'] = love.graphics.newImage('graphics/armor2.png'),
    ['chest'] = love.graphics.newImage('graphics/chest-sprite.png'),
    ['key'] = love.graphics.newImage('graphics/items.png'),
    ['paper2'] = love.graphics.newImage('graphics/paper2.png'),
    ['paper1'] = love.graphics.newImage('graphics/paper1.png'),
    ['paper3'] = love.graphics.newImage('graphics/paper4.png'),
    ['poster'] = love.graphics.newImage('graphics/poster.png'),
    ['beam'] = love.graphics.newImage('graphics/proyectil.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 28),
    ['character-swing-sword'] = GenerateQuads(gTextures['character-swing-sword'], 32, 32),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 18),
    ['potion'] = GenerateQuads(gTextures['potion'],16,16),
    ['armor'] = GenerateQuads(gTextures['armor'],16,16),
    ['chest'] = GenerateQuads(gTextures['chest'],16,16),
    ['key'] = GenerateQuads(gTextures['key'],16,16),
    ['paper2'] = GenerateQuads(gTextures['paper2'],18,18),
    ['paper1'] = GenerateQuads(gTextures['paper1'],18,14),
    ['paper3'] = GenerateQuads(gTextures['paper3'],18,14),
    ['poster'] = GenerateQuads(gTextures['poster'],12,11),
    ['beam'] = GenerateQuads(gTextures['beam'],5,5)

}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/Gameplay.ttf', 12),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['Triforce'] = love.graphics.newFont('fonts/Triforce.ttf', 50),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-small2'] = love.graphics.newFont('fonts/zelda.otf', 18),
    ['info'] = love.graphics.newFont('fonts/font.ttf', 8)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3',"static"),
    ['sword'] = love.audio.newSource('sounds/sword.wav',"static"),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav',"static"),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav',"static"),
    ['door'] = love.audio.newSource('sounds/door.wav',"static"),
    ['heart'] = love.audio.newSource('sounds/HeartBeat.wav',"static"),
    ['potion'] = love.audio.newSource('sounds/heal_sound_effect.mp3', "static"),
    ['invulnerability-potion'] = love.audio.newSource('sounds/power_up_sound_effect.mp3', "static"),
    ['game-over'] = love.audio.newSource('sounds/game_over_music.mp3', "static"),
    ['chest'] = love.audio.newSource('sounds/chest-open-sound-effect.mp3', "static"),
    ['key'] = love.audio.newSource('sounds/pick_up_key.mp3', "static"),
    ['game-finished'] = love.audio.newSource('sounds/gamefinished.mp3', "static"),
    ['boss-music'] = love.audio.newSource('sounds/bossmusic.mp3', "static"),
    ['spawn'] = love.audio.newSource('sounds/spawn.mp3', "static")
}