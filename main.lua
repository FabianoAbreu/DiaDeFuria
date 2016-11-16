local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )
composer.gotoScene( "menu", { effect="crossFade", time=500 } )
