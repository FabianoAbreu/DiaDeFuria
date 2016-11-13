
local fisica = require("physics")
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local myData = require( "mydata" )
local sheetInfoInimigoDE = require("inimigoDE")
local sheetInfoInimigoED = require("inimigoED")
local physicsDataDE = (require "inimigoDEFisica").physicsData(1.0)
local physicsDataED = (require "inimigoEDFisica").physicsData(1.0)

local largura = display.contentWidth
local altura = display.contentHeight
local sequenceDataDE
local sequenceDataED
local inimigos = {}
local bolinhaPapel
local verificarIndex = 0
local quantErros = 0
local spawnEnemies
local vida1
local vida2
local vida3
local pontuacaoCorrente
local pontuacaoCorrenteDisplay

local function moverPlayerDireitaEsquerda( self )
	if ( self.x < -100 ) or ( quantErros == 3 ) then
		self.enterFrame = nil
		display.remove( self )
		self = nil
	elseif ( self.x > -100 ) then
		self.x = self.x - 5
	end
end

local function moverPlayerEsquerdaDireita( self )
	if ( self.x > 2020 ) or ( quantErros == 3 ) then
		self.enterFrame = nil
		display.remove( self )
		self = nil
	elseif ( self.x < 2020 ) then
		self.x = self.x + 5
	end
end

local function setAlpha ( objeto ) 
	objeto.alpha = 0
	objeto.alpha = 1
end

local function detectarColisao( self, event )
	if ( event.phase == "began" )  then
		if ( self.myName == "bola" ) and ( event.other.myName == "inimigo" ) then
			local somColisao = audio.loadSound( "audio/single_shot_from_semi_automatic_paintball_gun.mp3" )
			audio.play( somColisao )
            pontuacaoCorrente = pontuacaoCorrente + 10
			pontuacaoCorrenteDisplay.text = string.format( "%06d", pontuacaoCorrente )
			--event.other.alpha = 0
			bolinhaPapel.enterFrame = nil
			display.remove( bolinhaPapel )
	 	    bolinhaPapel = nil
		end
    end
end

local function detectarNaoHouveColisao ( self )
	if 	( self.x > largura ) or ( self.x < 0 ) or 	( self.y > altura ) or ( self.y < 0 ) then
		local somNaoHouveColisao = audio.loadSound( "audio/single_gun_shot_with_ricochet.mp3" )
		audio.play( somNaoHouveColisao )

		-- remover a bolinha de papel da tela
		self.enterFrame = nil
		display.remove( self )
	 	self = nil
		quantErros = quantErros + 1
	end
end

local function preencherVidaPerdida( event )
	local sceneGroup = scene.view
	
	if ( quantErros == 1 ) then
		vida1 = display.newImageRect( "imagens/x.png", 32, 32 )
		vida1.x = 50
		vida1.y = 40
		sceneGroup:insert(vida1)
	elseif ( quantErros == 2 ) then
		vida2 = display.newImageRect( "imagens/x.png", 32, 32 )
		vida2.x = 100
		vida2.y = 40
		sceneGroup:insert(vida2)
	end
end

local function gameOver( event )
	if ( quantErros == 3 ) then
		composer.removeScene("gameover")
        composer.gotoScene( "gameover", { time= 1500, effect = "crossFade" })
	end
	return true
end

-------------------------------------------------------------------------------------------------------------------------------
--										ARREMESSO DA BOLINHA DE PAPEL
-------------------------------------------------------------------------------------------------------------------------------

local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)

local prediction = display.newGroup() ; prediction.alpha = 0.2
local line
local circ

local function getTrajectoryPoint( startingPosition, startingVelocity, n )
	--velocity and gravity are given per second but we want time step values here
	local t = 1/display.fps --seconds per time step at 60fps
	local stepVelocity = { x=t*startingVelocity.x, y=t*startingVelocity.y }
	local stepGravity = { x=t*0, y=t*9.8 }
	return {
		x = largura*0.48 + n * stepVelocity.x + 0.25 * (n*n+n) * stepGravity.x,
		y = altura*0.25 + n * stepVelocity.y + 0.25 * (n*n+n) * stepGravity.y
	}
end

local function updatePrediction( event )
	display.remove( prediction )  --remove dot group
	prediction = display.newGroup() ; prediction.alpha = 1  --now recreate it
	
	local startingVelocity = { x=event.x-event.xStart, y=event.y-event.yStart }
	
	for i = 1,180 do --for (int i = 0; i < 180; i++)
		local s = { x=event.xStart, y=event.yStart }
		local trajectoryPosition = getTrajectoryPoint( s, startingVelocity, i )
		circ = display.newCircle( prediction, trajectoryPosition.x, trajectoryPosition.y, 2 )
	end
end

local function fireProj( event )

	display.remove( prediction )
	
	bolinhaPapel = display.newImageRect( "Imagens/object.png", 64, 64 )
	physics.addBody( bolinhaPapel, "dynamic", { bounce=0.2, density=1.0, radius=14 } )
	bolinhaPapel.x, bolinhaPapel.y = largura*0.48, altura*0.25
	local vx, vy = event.x-event.xStart, event.y-event.yStart
	bolinhaPapel:setLinearVelocity( vx,vy )
    bolinhaPapel.myName = "bola"
	bolinhaPapel.collision = detectarColisao
	bolinhaPapel:addEventListener( "collision" )
	bolinhaPapel.enterFrame = detectarNaoHouveColisao
	Runtime:addEventListener( "enterFrame", bolinhaPapel )
end

local function screenTouch( event )
	local eventX, eventY = event.x, event.y
	
	if ( event.phase == "began" ) then
		-- nao faz nada
	elseif ( event.phase == "moved" ) then
		updatePrediction( event )
	else
		updatePrediction( event )
		fireProj( event )
	end
	return true
end

-------------------------------------------------------------------------------------------------------------------------------
--										CRIANDO OS SPRITES DO JOGO E OS PERSONAGENS
-------------------------------------------------------------------------------------------------------------------------------

sequenceDataDE = 
{
    { name = "moveRight", sheet = "inimigoDE", start = 1, count = 4, time = 500, loopCount = 0 },
}

sequenceDataED = 
{
   { name = "moveLeft", sheet = "inimigoED", start = 1, count = 4, time = 500, loopCount = 0 },
}

local sheetInimigoDE_1 = graphics.newImageSheet("Imagens/inimigoDE_1.png", sheetInfoInimigoDE:getSheet())
local sheetInimigoED_1 = graphics.newImageSheet("Imagens/inimigoED_1.png", sheetInfoInimigoED:getSheet())
local sheetInimigoDE_2 = graphics.newImageSheet("Imagens/inimigoDE_2.png", sheetInfoInimigoDE:getSheet())
local sheetInimigoED_2 = graphics.newImageSheet("Imagens/inimigoED_2.png", sheetInfoInimigoED:getSheet())

local function criandoInimigos(index)
	if ( index == 1 ) then
		inimigos[1] = display.newSprite(sheetInimigoDE_1, sequenceDataDE)
		inimigos[1].x = largura + 100
		inimigos[1].y = altura*0.7
		fisica.addBody(inimigos[1], "kinematic", physicsDataDE:get("sprite_DE"))
		inimigos[1]:setSequence("moveLeft")
		inimigos[1].enterFrame = moverPlayerDireitaEsquerda
		inimigos[1].myName = "inimigo"
	elseif ( index == 2 ) then
		inimigos[2] = display.newSprite(sheetInimigoDE_2,  sequenceDataDE)
		inimigos[2].x = largura + 100
		inimigos[2].y = altura*0.7
		fisica.addBody(inimigos[2], "kinematic", physicsDataDE:get("sprite_DE"))
		inimigos[2]:setSequence("moveLeft")
		inimigos[2].enterFrame = moverPlayerDireitaEsquerda
		inimigos[2].myName = "inimigo"
	elseif ( index == 3 ) then
		inimigos[3] = display.newSprite(sheetInimigoED_1, sequenceDataED)
		inimigos[3].x = -100
		inimigos[3].y = altura*0.8
		fisica.addBody(inimigos[3], "kinematic", physicsDataED:get("sprite_ED"))
		inimigos[3]:setSequence("moveRight")
		inimigos[3].enterFrame = moverPlayerEsquerdaDireita
		inimigos[3].myName = "inimigo"
	elseif ( index == 4 ) then
		inimigos[4] = display.newSprite(sheetInimigoED_2, sequenceDataDE)
		inimigos[4].x = -100
		inimigos[4].y = altura*0.8
		fisica.addBody(inimigos[4], "kinematic", physicsDataED:get("sprite_ED"))
		inimigos[4]:setSequence("moveRight")
		inimigos[4].enterFrame = moverPlayerEsquerdaDireita
		inimigos[4].myName = "inimigo"
	elseif ( index == 5 ) then
		inimigos[5] = display.newSprite(sheetInimigoDE_1, sequenceDataDE)
		inimigos[5].x = largura + 100
		inimigos[5].y = altura*0.9
		fisica.addBody(inimigos[5], "kinematic", physicsDataDE:get("sprite_DE"))
		inimigos[5]:setSequence("moveLeft")
		inimigos[5].enterFrame = moverPlayerDireitaEsquerda
		inimigos[5].myName = "inimigo"
	elseif ( index == 6 ) then
		inimigos[6] = display.newSprite(sheetInimigoDE_2,  sequenceDataDE)
		inimigos[6].x = largura + 100
		inimigos[6].y = altura*0.9
		fisica.addBody(inimigos[6], "kinematic", physicsDataDE:get("sprite_DE"))
		inimigos[6]:setSequence("moveLeft")
		inimigos[6].enterFrame = moverPlayerDireitaEsquerda
		inimigos[6].myName = "inimigo"
	end
end

local function inserindoInimigosNaTela ( event )
	local index  = math.random(6)
	
	if (index == verificarIndex) then
		inserindoInimigosNaTela()
	else
		criandoInimigos(index)
		inimigos[index].collision = detectarColisao
		inimigos[index]:addEventListener( "collision" )
		Runtime:addEventListener( "enterFrame", inimigos[index] )
  		inimigos[index]:play()
		verificarIndex = index
	end
end

function scene:create( event )
    local sceneGroup = self.view
    fisica.start()

    local background = display.newImage("imagens/background.png") 
    sceneGroup:insert( background )

	local backgroundMusic = audio.loadStream( "audio/If_I_Had_a_Chicken.mp3" )
	audio.play( backgroundMusic, { channel=2, loops=-1, fadein=5000 } )
	audio.setVolume( 0.5 )

	local vidaDisponivel1 = display.newImageRect( "imagens/object.png", 48, 48 )
	vidaDisponivel1.x = 50
	vidaDisponivel1.y = 40
	sceneGroup:insert( vidaDisponivel1 )

	local vidaDisponivel2 = display.newImageRect( "imagens/object.png", 48, 48 )
	vidaDisponivel2.x = 100
	vidaDisponivel2.y = 40
	sceneGroup:insert( vidaDisponivel2 )
	
	local vidaDisponivel3 = display.newImageRect( "imagens/object.png", 48, 48 )
	vidaDisponivel3.x = 150
	vidaDisponivel3.y = 40
	sceneGroup:insert( vidaDisponivel3 )
   
    pontuacaoCorrenteDisplay = display.newText("00000", display.contentWidth - (largura*0.1), 10, native.systemFont, 50 )
	pontuacaoCorrenteDisplay:setFillColor(1)
    sceneGroup:insert( pontuacaoCorrenteDisplay )
end

function scene:show( event )
    local sceneGroup = self.view
    if event.phase == "did" then
        physics.start()
		spawnEnemies = timer.performWithDelay( 3000, inserindoInimigosNaTela, -1 )
		Runtime:addEventListener( "touch", screenTouch )
		Runtime:addEventListener( "enterFrame", gameOver )
		Runtime:addEventListener( "enterFrame", preencherVidaPerdida )
    else
        pontuacaoCorrente = 0
        pontuacaoCorrenteDisplay.text = string.format( "%06d", pontuacaoCorrente )
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    if event.phase == "will" then
		audio.stop()
        physics.stop()
        timer.cancel( spawnEnemies )
		Runtime:removeEventListener( "touch", screenTouch )
		Runtime:removeEventListener( "enterFrame", gameOver )
		Runtime:removeEventListener( "enterFrame", preencherVidaPerdida )
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
