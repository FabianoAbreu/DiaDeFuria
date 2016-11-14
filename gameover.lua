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

    local title = display.newImage("imagens/fimdejogo.png") 
    title.x = display.contentCenterX
    title.y = 150
    title.width = 800
    title.height = 150
    sceneGroup:insert(title)

    local voltarAoMenuButton = widget.newButton({
        defaultFile = "imagens/menu.png",
        id = "menu",
        width = 500,
        height = 110,
        onEvent = voltarParaOMenuEvent
    })
    voltarAoMenuButton.x = display.contentCenterX
    voltarAoMenuButton.y = display.contentCenterY - 150
    sceneGroup:insert( voltarAoMenuButton )

    local reiniciarJogoButton = widget.newButton({
         defaultFile = "imagens/jogar.png",
        id = "reiniciarJogo",
        width = 500,
        height = 150,
        onEvent = reiniciarJogoEvent
    })
    reiniciarJogoButton.x = display.contentCenterX
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
