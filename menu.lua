local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local function iniciarJogoEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "game", false )
        composer.gotoScene("game", { effect = "crossFade", time = 333 })
    end
end

local function creditosEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
    end
end

function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImage("imagens/backmenu.png") 
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local backgroundMusic = audio.loadStream( "audio/happy.mp3" )
	audio.play( backgroundMusic, { channel=2, loops=-1, fadein=5000 } )
	audio.setVolume( 0.5 )

    local title = display.newText( "Furious", 10, 10, "28 Days Later.ttf", 300) 
    title.x = display.contentCenterX
    title.y = display.contentCenterY - 230
    title:setFillColor(1)
    sceneGroup:insert( title )

    local iniciarJogoButton = widget.newButton ({
        id = "button1",
        label = "Play",
        font = "ASPHALTIC GRAIN CONDENSED PERSONAL USE.ttf",
        fontSize = 150,
        textOnly = true,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onEvent = iniciarJogoEvent
    })
    iniciarJogoButton.x = display.contentCenterX - 250
    iniciarJogoButton.y = display.contentCenterY + 80
    sceneGroup:insert( iniciarJogoButton )

    local creditosButton = widget.newButton({
         id = "button2",
        label = "Credits",
        font = "ASPHALTIC GRAIN CONDENSED PERSONAL USE.ttf",
        fontSize = 150,
        textOnly = true,
        --width = 2000,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onEvent = creditosEvent
    })
    creditosButton.x = display.contentCenterX + 230
    creditosButton.y = display.contentCenterY + 80
    sceneGroup:insert( creditosButton )
end

function scene:show( event )
    local sceneGroup = self.view
    if event.phase == "did" then
        composer.removeScene( "game" ) 
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    if event.phase == "will" then
        audio.stop()
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
