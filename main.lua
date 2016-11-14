local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

local function onKeyEvent( event )
    composer.gotoScene( "menu", { effect="crossFade", time=500 } )
end

Runtime:addEventListener("system", onKeyEvent)
