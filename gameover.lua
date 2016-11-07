local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local myData = require( "mydata" )
local gameNetwork = require( "gameNetwork" )
local device = require( "device" )

local params
local newHighScore = false
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

-- local function postToGameNetwork()
--     local category = "com.yourdomain.yourgame.leaderboard"
--     if myData.isGPGS then
--         category = "CgkIusrvppwDJFHJKDFg"
--     end
--     gameNetwork.request("setHighScore", {
--         localPlayerScore = {
--             category = category, 
--             value = myData.settings.bestScore
--         },
--         listener = postScoreSubmit
--     })
-- end
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    local background = display.newRect( 0, 0, 1920, 1080)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

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
    voltarAoMenuButton.y = display.contentCenterY - 100
    sceneGroup:insert( voltarAoMenuButton )

    local reiniciarJogoButton = widget.newButton({
         defaultFile = "imagens/jogar.png",
        id = "reiniciarJogo",
        width = 500,
        height = 150,
        onEvent = reiniciarJogoEvent
    })
    reiniciarJogoButton.x = display.contentCenterX
    reiniciarJogoButton.y = display.contentCenterY + 120
    sceneGroup:insert( reiniciarJogoButton )
end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

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
