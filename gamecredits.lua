local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local function voltarParaOMenuEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "menu", false )
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
    end
end

function scene:create( event )
    local sceneGroup = self.view

    local backcredits = display.newImage("imagens/credits.png") 
    backcredits.x = display.contentCenterX
    backcredits.y = display.contentCenterY
    sceneGroup:insert(backcredits)

    local voltarAoMenuButton = widget.newButton({
         id = "button1",
        label = "Return",
        font = "ASPHALTIC GRAIN CONDENSED PERSONAL USE.ttf",
        fontSize = 125,
        textOnly = true,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onEvent = voltarParaOMenuEvent
    })
    voltarAoMenuButton.x = display.contentCenterX
    voltarAoMenuButton.y = display.contentCenterY + (display.contentCenterY * 0.8)
    sceneGroup:insert( voltarAoMenuButton )
end

function scene:show( event )
    local sceneGroup = self.view
    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    if event.phase == "will" then
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
