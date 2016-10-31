local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local ads = require( "ads" )

local params

local myData = require( "mydata" )

local function handlePlayButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "game", false )
        composer.gotoScene("game", { effect = "crossFade", time = 333 })
    end
end

-- local function handleHelpButtonEvent( event )
--     if ( "ended" == event.phase ) then
--         composer.gotoScene("help", { effect = "crossFade", time = 333, isModal = true })
--     end
-- end

-- local function handleCreditsButtonEvent( event )
--     if ( "ended" == event.phase ) then
--         composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
--     end
-- end

local function handleSettingsButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene("gamesettings", { effect = "crossFade", time = 333 })
    end
end

function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    local background = display.newRect( 0, 0, 1920, 1080 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local title = display.newImage("Imagens/enfezado.png") 
    title.x = display.contentCenterX
    title.y = 150
    title.width = 800
    title.height = 150
    sceneGroup:insert( title )

    -- Create the widget
    local playButton = widget.newButton ({
        defaultFile = "Imagens/play1.png",
        id = "button1",
        width = 600,
        height = 150,
        onEvent = handlePlayButtonEvent
    })
    playButton.x = display.contentCenterX
    playButton.y = display.contentCenterY - 100
    sceneGroup:insert( playButton )

    -- -- Create the widget
    -- local settingsButton = widget.newButton({
    --     id = "button2",
    --     label = "Settings",
    --     width = 100,
    --     height = 32,
    --     onEvent = handleSettingsButtonEvent
    -- })
    -- settingsButton.x = display.contentCenterX
    -- settingsButton.y = display.contentCenterY - 30
    -- sceneGroup:insert( settingsButton )

    -- -- Create the widget
    -- local helpButton = widget.newButton({
    --     id = "button3",
    --     label = "Help",
    --     width = 100,
    --     height = 32,
    --     onEvent = handleHelpButtonEvent
    -- })
    -- helpButton.x = display.contentCenterX
    -- helpButton.y = display.contentCenterY + 30
    -- sceneGroup:insert( helpButton )

    -- Create the widget
    local creditsButton = widget.newButton({
        defaultFile = "Imagens/creditos.png",
        id = "button4",
        width = 550,
        height = 120,
        onEvent = handleCreditsButtonEvent
    })
    creditsButton.x = display.contentCenterX
    creditsButton.y = display.contentCenterY + 90
    sceneGroup:insert( creditsButton )

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
