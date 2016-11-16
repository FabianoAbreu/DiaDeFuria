local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local largura = display.contentWidth
local altura = display.contentHeight

local function voltarParaOMenuEvent( event )

    if ( "ended" == event.phase ) then
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        composer.gotoScene( "menu", options )
    end
    return true
end

local function reiniciarJogoEvent( event )
     if ( "ended" == event.phase ) then
        composer.removeScene( "game", false )
        composer.gotoScene("game", { effect = "crossFade", time = 333 })
    end
end

function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    local background = display.newImage("imagens/backmenu.png") 
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local somColisao = audio.loadSound( "audio/Cartoon_Bank_Heist_Sting.mp3" )
	audio.play( somColisao )

    local title = display.newText( "Game Over", 10, 10, "28 Days Later.ttf", 250)
    title.x = display.contentCenterX
    title.y = display.contentCenterY - 230
    title:setFillColor(1)
    sceneGroup:insert(title)

    local voltarAoMenuButton = widget.newButton({
         id = "button1",
        label = "Menu",
        font = "ASPHALTIC GRAIN CONDENSED PERSONAL USE.ttf",
        fontSize = 150,
        textOnly = true,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onEvent = voltarParaOMenuEvent
    })
    voltarAoMenuButton.x = display.contentCenterX - 250
    voltarAoMenuButton.y = display.contentCenterY + 80
    sceneGroup:insert( voltarAoMenuButton )

    local reiniciarJogoButton = widget.newButton({
        id = "button2",
        label = "Restart",
        font = "ASPHALTIC GRAIN CONDENSED PERSONAL USE.ttf",
        fontSize = 150,
        textOnly = true,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onEvent = reiniciarJogoEvent
    })
    reiniciarJogoButton.x = display.contentCenterX + 250
    reiniciarJogoButton.y = display.contentCenterY + 80
    sceneGroup:insert( reiniciarJogoButton )
end

function scene:show( event )
    local sceneGroup = self.view
    if event.phase == "did" then
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
