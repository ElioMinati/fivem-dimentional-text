# fivem-dimentional-text
A FiveM Resource that implements export functions that allows you to display 3D text however you wish !

## Preview

[Preview](https://youtu.be/y74kh4rXTWw)

## How to install

* Put the script in your fivem resource folder and rename it "dimentional-text".
* Add  ```start dimentional-text``` to your server.cfg
* Call the exports listed below in your scripts.
* Enjoy !

## Based off of Jeva's motiontext script ([motiontext](https://github.com/ThatZiv/motiontext))

## Documentation 
* `Draw3DTextPermanent` - Draws 3D text permanently on specific coordinates. 
 ```lua
exports["dimentional-text"]:Draw3DTextPermanent(
    "unique-identifier", -- unique identifier specific to that text
    {x = -1377.514282266, y = -2852.64941406, z = 13.9448}, -- Coordinates
    {
        content = "Example text", -- This is the string that you want to be displayed
        rgba = {255 , 255, 255, 255}, --T he color value of the text in RGBA 
        textOutline = true, -- Text outline
        scaleMultiplie r= 1, -- Text Size Multiplier
        font = 0, -- Font type (0-5)
    }, 150, -- radius (in units) in which the player will be able to see the text
    4 -- Perspective Scale
)
```

* `Draw3DTextTimeout` - Draws 3D text permanently on specific coordinates. 
 ```lua
exports["dimentional-text"]:Draw3DTextTimeout(
    "unique-identifier", -- unique identifier specific to that text
    {x = -1377.514282266, y = -2852.64941406, z = 13.9448}, -- Coordinates
    {
        content = "Example text", -- This is the string that you want to be displayed
        rgba = {255 , 255, 255, 255}, --T he color value of the text in RGBA 
        textOutline = true, -- Text outline
        scaleMultiplie r= 1, -- Text Size Multiplier
        font = 0, -- Font type (0-5)
    }, 150, -- radius (in units) in which the player will be able to see the text
    4, -- Perspective Scale
    2000 -- Time in ms until the text will disappear.
)
```

* `Draw3DTextThisFrame` - Draws 3D text permanently on specific coordinates. 
 ```lua
exports["dimentional-text"]:Draw3DTextThisFrame(
    {x = -1377.514282266, y = -2852.64941406, z = 13.9448}, -- Coordinates
    {
        content = "Example text", -- This is the string that you want to be displayed
        rgba = {255 , 255, 255, 255}, --T he color value of the text in RGBA 
        textOutline = true, -- Text outline
        scaleMultiplie r= 1, -- Text Size Multiplier
        font = 0, -- Font type (0-5)
    }, 150, -- radius (in units) in which the player will be able to see the text
    4 -- Perspective Scale
)
```

* `Delete3DText` - Deletes the 3D permanent / timeout text previously setup
 ```lua
exports["dimentional-text"]:Delete3DText("unique-identifier")
```
