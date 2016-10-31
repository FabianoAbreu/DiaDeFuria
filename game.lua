
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
local pontuacao = 0
local texto = display.newText( "0", largura*0.5, altura*0.02, native.systemFont, 50 )
local sequenceDataDE
local sequenceDataED
local inimigos = {}
local bolinhaPapel
local verificarIndex = 0
local quantErros = 0
local spawnEnemies
local currentScore
local currentScoreDisplay
local levelText

local function gameOver( event )
	if ( quantErros == 3 ) then
		composer.removeScene("gameover")
        composer.gotoScene( "gameover", { time= 500, effect = "crossFade" })
	end
	return true
end

local function atualizarPontosNaTela ( event )
	texto.text = math.floor( pontuacao )
end

local function moverPlayerDireitaEsquerda( self )
	if ( self.x > -100 ) then
		self.x = self.x - 3
	else
		self.enterFrame = nil
		display.remove( self )
		self = nil
	end
end

local function moverPlayerEsquerdaDireita( self )
	if (self.x < 2020) then
		self.x = self.x + 3
	else
		self.enterFrame = nil
		display.remove( self )
		self = nil
	end
end

local function detectarColisao( self, event )
	if ( event.phase == "began" )  then
		if ( self.myName == "bola" ) and ( event.other.myName == "inimigo" ) then
            pontuacao = pontuacao + 10
            bolinhaPapel.enterFrame = nil
			display.remove( bolinhaPapel )
	 	    bolinhaPapel = nil
		end
    end
end

local function detectarNaoHouveColisao ( self )
	if 	( self.x > largura ) or ( self.x < 0 ) or 	( self.y > altura ) or ( self.y < 0 ) then

		-- remover a bolinha de papel da tela
		self.enterFrame = nil
		display.remove( self )
	 	self = nil

		 -- indicar a perda de vida
		quantErros = quantErros + 1
		if ( quantErros == 1 ) then
			local vida1 = display.newImageRect( "Imagens/object.png", 64, 64 )
			vida1.x = 50
			vida1.y = 50
		elseif (quantErros == 2) then
			local vida2 = display.newImageRect( "Imagens/object.png", 64, 64 )
			vida2.x = 100
			vida2.y = 50
		else
			local vida3 = display.newImageRect( "Imagens/object.png", 64, 64 )
			vida3.x = 150
			vida3.y = 50
		end
	end
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

	--if ( event.xStart < -ox+44 or event.xStart > display.contentWidth+ox-44
		--or event.yStart < -oy+44 or event.yStart > display.contentHeight+oy-44 ) then
		display.remove( prediction )
		--return
	--end
	
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

local function criandoInimigos()
	inimigos[1] = display.newSprite(sheetInimigoDE_1, sequenceDataDE)
	inimigos[1].x = largura + 100
	inimigos[1].y = altura*0.7
	fisica.addBody(inimigos[1], "kinematic", physicsDataDE:get("sprite_DE"))
	inimigos[1]:setSequence("moveLeft")
	inimigos[1].enterFrame = moverPlayerDireitaEsquerda
    inimigos[1].myName = "inimigo"

	inimigos[2] = display.newSprite(sheetInimigoDE_2,  sequenceDataDE)
	inimigos[2].x = largura + 100
	inimigos[2].y = altura*0.7
	fisica.addBody(inimigos[2], "kinematic", physicsDataDE:get("sprite_DE"))
	inimigos[2]:setSequence("moveLeft")
	inimigos[2].enterFrame = moverPlayerDireitaEsquerda
    inimigos[2].myName = "inimigo"

	inimigos[3] = display.newSprite(sheetInimigoED_1, sequenceDataED)
	inimigos[3].x = -100
	inimigos[3].y = altura*0.8
	fisica.addBody(inimigos[3], "kinematic", physicsDataED:get("sprite_ED"))
	inimigos[3]:setSequence("moveRight")
	inimigos[3].enterFrame = moverPlayerEsquerdaDireita
    inimigos[3].myName = "inimigo"
	
	inimigos[4] = display.newSprite(sheetInimigoED_2, sequenceDataDE)
	inimigos[4].x = -100
	inimigos[4].y = altura*0.8
	fisica.addBody(inimigos[4], "kinematic", physicsDataED:get("sprite_ED"))
	inimigos[4]:setSequence("moveRight")
	inimigos[4].enterFrame = moverPlayerEsquerdaDireita
    inimigos[4].myName = "inimigo"

	inimigos[5] = display.newSprite(sheetInimigoDE_1, sequenceDataDE)
	inimigos[5].x = largura + 100
	inimigos[5].y = altura*0.9
	fisica.addBody(inimigos[5], "kinematic", physicsDataDE:get("sprite_DE"))
	inimigos[5]:setSequence("moveLeft")
	inimigos[5].enterFrame = moverPlayerDireitaEsquerda
    inimigos[5].myName = "inimigo"

	inimigos[6] = display.newSprite(sheetInimigoDE_2,  sequenceDataDE)
	inimigos[6].x = largura + 100
	inimigos[6].y = altura*0.9
	fisica.addBody(inimigos[6], "kinematic", physicsDataDE:get("sprite_DE"))
	inimigos[6]:setSequence("moveLeft")
	inimigos[6].enterFrame = moverPlayerDireitaEsquerda
    inimigos[6].myName = "inimigo"
end

local function inserindoInimigosNaTela ( event )
	local index  = math.random(6)
	
	if (index == verificarIndex) then
		inserindoInimigosNaTela()
	else
		criandoInimigos()
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
    fisica.pause()

    local background = display.newImage("Imagens/background.png") 
    sceneGroup:insert(background)

	local vidaDisponivel1 = display.newImageRect( "Imagens/object-vida.png", 64, 64 )
	vidaDisponivel1.x = 50
	vidaDisponivel1.y = 50

	local vidaDisponivel2 = display.newImageRect( "Imagens/object-vida.png", 64, 64 )
	vidaDisponivel2.x = 100
	vidaDisponivel2.y = 50

	local vidaDisponivel3 = display.newImageRect( "Imagens/object-vida.png", 64, 64 )
	vidaDisponivel3.x = 150
	vidaDisponivel3.y = 50
   
 	--currentScoreDisplay = display.newText("000000", largura*0.5, altura*0.02, native.systemFont, 50 )
    currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
    sceneGroup:insert( currentScoreDisplay )
end

function scene:show( event )
    local sceneGroup = self.view
    if event.phase == "did" then
        physics.start()
		spawnEnemies = timer.performWithDelay( 3000, inserindoInimigosNaTela, -1 )
		Runtime:addEventListener( "touch", screenTouch )
		Runtime:addEventListener( "enterFrame", atualizarPontosNaTela )
		Runtime:addEventListener( "enterFrame", gameOver )
    else
        currentScore = 0
        currentScoreDisplay.text = string.format( "%06d", currentScore )
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    if event.phase == "will" then
        physics.stop()
        timer.cancel( spawnEnemies )
		Runtime:addEventListener( "touch", screenTouch )
		Runtime:addEventListener( "enterFrame", atualizarPontosNaTela )
		Runtime:addEventListener( "enterFrame", gameOver )
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
