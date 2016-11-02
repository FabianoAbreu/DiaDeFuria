local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local utility = require( "utility" )
local ads = require( "ads" )
local myData = require( "mydata" )

local params

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

    params = event.params

    local background = display.newRect( 0, 0, 1920, 1080 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local title = display.newImage("imagens/enfezado.png") 
    title.x = display.contentCenterX
    title.y = 150
    title.width = 800
    title.height = 150
    sceneGroup:insert( title )

    local iniciarJogoButton = widget.newButton ({
        defaultFile = "imagens/iniciar.png",
        id = "button1",
        width = 500,
        height = 150,
        onEvent = iniciarJogoEvent
    })
    iniciarJogoButton.x = display.contentCenterX
    iniciarJogoButton.y = display.contentCenterY - 100
    sceneGroup:insert( iniciarJogoButton )

    local creditosButton = widget.newButton({
        defaultFile = "imagens/creditos.png",
        id = "button4",
        width = 500,
        height = 150,
        onEvent = creditosEvent
    })
    creditosButton.x = display.contentCenterX
    creditosButton.y = display.contentCenterY + 120
    sceneGroup:insert( creditosButton )
end

function scene:show( event )
    local sceneGroup = self.view
    params = event.params
    utility.print_r(event)

    if params then
        print(params.someKey)
        print(params.someOtherKey)
    end

    if event.phase == "did" then
        composer.removeScene( "game" ) 
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
