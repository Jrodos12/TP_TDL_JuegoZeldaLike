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
<<<<<<< Updated upstream
    }
=======
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

    ['silver-chest'] = {
        type = 'silver-chest',
        texture = 'chest',
        frame = 15,
        width = 16,
        height = 16,
        solid = False,
        defaultState = 'closed',
        states = {
            ['closed'] = {
                frame = 8
            },
            ['open'] = {
                frame = 7
            }
        }
    },

    ['key'] = {
        type = 'key',
        texture = 'key',
        frame = 48,
        width = 16,
        height = 16,
        solid = False,
        defaultState = 'on-floor',
        states = {
            ['on-floor'] = {
                frame = 19
            },
            ['has-been-picked-up'] = {
                frame = 1 --esta frame es una parte del png que se borro deliberadamente para que
                --parezca que la llave desaparece
            }
        }
    },
        ['paper1'] = {
        type = 'paper1',
        texture = 'paper1',
        frame = 1,
        width = 18,
        height = 14,
        solid = true,
        defaultState = 'whitepaper',
        states = {
            ['whitepaper'] = {
                frame = 1
            }
        }
    },
    ['paper3'] = {
        type = 'paper3',
        texture = 'paper3',
        frame = 1,
        width = 18,
        height = 14,
        solid = true,
        defaultState = 'whitepaper',
        states = {
            ['whitepaper'] = {
                frame = 1
            }
        }
    },  
        ['paper2'] = {
        type = 'paper2',
        texture = 'paper2',
        frame = 1,
        width = 18,
        height = 18,
        solid = true,
        defaultState = 'whitepaper',
        states = {
            ['whitepaper'] = {
                frame = 1
            }
        }
    },
        ['poster'] = {
        type = 'poster',
        texture = 'poster',
        frame = 1,
        width = 12,
        height = 11,
        solid = true,
        defaultState = 'whitepaper',
        states = {
            ['whitepaper'] = {
                frame = 1
            }
        }
    },
>>>>>>> Stashed changes
}