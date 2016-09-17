--OBS: Frame = quadro de anima��o. Ex: a sprite q usaremos contem 12 quadros de anima��o.
--Timer.*
-- display.setStatusBar (display.HiddenStatusBar) -- esconde a barra de status no iphone
fisica = require("physics")
fisica.start()

local w = display.contentWidth -- largura da tela
local h = display.contentHeight -- altura da tela
local circulo
local pontuacao = 0
local texto
texto = display.newText( "0", 20, 30, native.systemFont, 22 )

-- simula o garoto que vai jogar o papel
local quadrado = display.newRect(215, 40, 25, 25)

-- local background = display.newImage("background.jpg") -- cria uma nova imagem de fundo

local sheetData =  { width=45, height=63, numFrames=12 }
-- width: largura de cada frame
-- height: altura de cada frame
-- numFrames: número de frames da sprite

local sheet = graphics.newImageSheet("Imagens/gaara.png", sheetData)
-- cria uma nova imagem usando a sprite "gaara.png" e as propriedades vistas acima

local sequenceData = 
{
	{ name = "idleDown", start = 1, count = 1, time = 0, loopCount = 1 }, --idleDown = parado para baixo (� s� um nome, vc quem nomeia como quiser)
	-- name: nome desse movimento
	-- start: frame da sprite onde a anima��o come�a (nesse caso come�a no primeiro frame da sprite)
	-- count: n�mero de frames para essa anima��o (nesse caso essa anima��o s� ter� um frame, o primeiro, aquele q o gaara t� parado pra baixo)
	-- time: tempo de dura��o da anima��o (est� zero pq essa anima��o s� tem um quadro
	-- loopCount: n�mero de vezes que a anima��o � executada, nesse caso a anima��o s� � executada uma vez, pois s� tem um frame
	
	-- os outros vetores s�o da mesma forma, cada um com a sua anima��o
    --{ name = "idleLeft", start = 4, count = 1, time = 0, loopCount = 1 }, --parado pra esquerda
    --{ name = "idleRight", start = 7, count = 1, time = 0, loopCount = 1 }, --parado pra direita
    --{ name = "idleUp", start = 10, count = 1, time = 0, loopCount = 1 }, --parado pra cima
	
	-- esses vetores j� contem mais do q um frame de anima��o, ent�o eles j� mostram um movimento
    --{ name = "moveDown", start = 2, count = 2, time = 300, loopCount = 0 },
	-- nesse caso a anima��o come�a do segundo frame e termina do terceiro (j� q o count � igual a 2)
	-- e o 'time' � igual a 300, isso significa q essa anima��o (moveDown), ser� executada em 300 cent�simos de segundo, ou 0,3 segundos
	-- o loopCount � igual a zero, isso significa q anima��o ser� executada para sempre, at� q algu�m cancele essa anima��o ou execute outra
    { name = "moveLeft", start = 5, count = 2, time = 1000, loopCount = 0 },
	-- mesmo principio da anima��o de cima, mas agora come�a no quinto frame (start=5) e cont�m 2 frames de anima��o apenas
    { name = "moveRight", start = 8, count = 2, time = 1000, loopCount = 0 },
    --{ name = "moveUp", start = 11, count = 2, time = 300, loopCount = 0 },
}

-- cria finalmente a sprite utilizando a propriedades vistas acima
local player = display.newSprite(sheet, sequenceData)
player.x = w
player.y = h * .8
fisica.addBody(player, "kinematic", {density=1, friction=1, bounce=0.5})

--local player2 = display.newSprite(sheet, sequenceData)
local player2 = display.newRect(0, 0, 30, 30)
player2.x = 0
player2.y = h * .7
fisica.addBody(player2, "kinematic", {density=1, friction=1, bounce=0.5})

-- configura um valor inicial para sprite, nesse caso é o "idleDown", por isso o gaara começa olhando para baixo
player:setSequence("moveLeft")
--player2:setSequence("moveRight")

function moverPlayerDireitaEsquerda(self, event)
	if self.x < 0 then
		self.x = 480
 	else
		self.x = self.x - 2
 	end
end

function moverPlayerEsquerdaDireita(self, event)
	if self.x > 480 then
		self.x = 0
	else
		self.x = self.x + 2
	end
end

player:setSequence("moveLeft")
player.enterFrame = moverPlayerDireitaEsquerda
Runtime:addEventListener("enterFrame", player)
--executa a animação, é necessário usar essa função para ativar a animação
player:play()

--player2:setSequence("moveRight")
player2.enterFrame = moverPlayerEsquerdaDireita
Runtime:addEventListener("enterFrame", player2)
--executa a animação, é necessário usar essa função para ativar a animação
--player2:play()

local function onTouch(event)
        if(event.phase == "ended") then
			circulo = display.newCircle(215, 40, 10)
			fisica.addBody(circulo, "dynamic", {density=0, friction=0, bounce=0.1})
            --transition.to( circulo, {x=event.x, y=event.y, time = 1000})
            circulo:setLinearVelocity((event.x-circulo.x), (event.y-circulo.y))
        end
    end

local function atualizarPontos (event)
	texto.text = math.floor( pontuacao )
end

local function onGlobalCollision( event )

    if ( event.phase == "began" ) then
       pontuacao = pontuacao + 10
    --elseif ( event.phase == "ended" ) then
    --    pontuacao = pontuacao + 50
    end
end

Runtime:addEventListener( "collision", onGlobalCollision )
Runtime:addEventListener( "enterFrame", atualizarPontos )
Runtime:addEventListener( "touch", onTouch )
--transition=easing.outExpo
