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

local function voltarParaOMenu( event )

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

local function reiniciarJogo( event )
     if ( "ended" == event.phase ) then
        composer.removeScene( "game", false )
        composer.gotoScene("game", { effect = "crossFade", time = 333 })
    end
end

local function postToGameNetwork()
    local category = "com.yourdomain.yourgame.leaderboard"
    if myData.isGPGS then
        category = "CgkIusrvppwDJFHJKDFg"
    end
    gameNetwork.request("setHighScore", {
        localPlayerScore = {
            category = category, 
            value = myData.settings.bestScore
        },
        listener = postScoreSubmit
    })
end
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local background = display.newRect( 0, 0, 1920, 1080)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local title = display.newImage("Imagens/fimdejogo.png") 
    title.x = display.contentCenterX
    title.y = 150
    title.width = 800
    title.height = 150
    sceneGroup:insert(title)

    local voltarAoMenuButton = widget.newButton({
        defaultFile = "Imagens/voltaraomenu.png",
        id = "leaderboard",
        width = 650,
        height = 150,
        onEvent = voltarParaOMenu
    })
    voltarAoMenuButton.x = display.contentCenterX 
    voltarAoMenuButton.y = display.contentCenterY - 150
    sceneGroup:insert( voltarAoMenuButton )

    local reiniciarJogoButton = widget.newButton({
         defaultFile = "Imagens/reiniciarjogo.png",
        id = "button1",
        width = 650,
        height = 150,
        onEvent = reiniciarJogo
    })
    reiniciarJogoButton.x = display.contentCenterX
    reiniciarJogoButton.y = display.contentCenterY + 100
    sceneGroup:insert( reiniciarJogoButton )
end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
        --
        -- Hook up your score code here to support updating your leaderboards
        --[[
        if newHighScore then
            local popup = display.newText("New High Score", 0, 0, native.systemFontBold, 32)
            popup.x = display.contentCenterX
            popup.y = display.contentCenterY
            sceneGroup:insert( popup )
            postToGameNetwork(); 
        end
        --]]
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
