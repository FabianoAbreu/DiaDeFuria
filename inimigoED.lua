--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1e4d5e12dace1afc5031316ce11e56b9:abda2933c3276e6748bf296f5cc19c52:02e478a6e34112788717b5b0d5868f2b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            x=1,
            y=1,
            width=160,
            height=160,
        },
        {
            x=163,
            y=1,
            width=160,
            height=160,
        },
        {
            x=325,
            y=1,
            width=160,
            height=160,
        },
        {
            x=487,
            y=1,
            width=160,
            height=160,
        },
    },
    
    sheetContentWidth = 648,
    sheetContentHeight = 162
}

SheetInfo.frameIndex =
{
    ["sprite_0"] = 1,
    ["sprite_1"] = 2,
    ["sprite_2"] = 3,
    ["sprite_3"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
