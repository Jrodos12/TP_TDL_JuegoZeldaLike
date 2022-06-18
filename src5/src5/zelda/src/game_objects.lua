--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['health-potion'] = {
        type = 'potion',
        texture = 'potion',
        frame = 4,
        width = 16,
        height = 16,
        solid = False,
        defaultState = 'sitting',
        states = {
            ['sitting'] = {
                frame = 10
            },
            ['used'] = {
                frame = 9
            }
        }
    },

    ['invulnerability-potion'] = {
        type = 'potion',
        texture = 'potion',
        frame = 4,
        width = 16,
        height = 16,
        solid = False,
        defaultState = 'sitting',
        states = {
            ['sitting'] = {
                frame = 14
            },
            ['used'] = {
                frame = 13
            }
        }
    },

    ['chest'] = {
        type = 'chest',
        texture = 'chest',
        frame = 15,
        width = 16,
        height = 16,
        solid = False,
        defaultState = 'closed',
        states = {
            ['closed'] = {
                frame = 2
            },
            ['open'] = {
                frame = 1
            }
        }
    },
}