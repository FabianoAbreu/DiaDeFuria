fisica = require("physics")
fisica.start()

local background = display.newImage("Imagens/background.jpg")

local w = display.contentWidth -- largura da tela
local h = display.contentHeight -- altura da tela
local pontuacao = 0
local texto = display.newText( "0", w*0.5, h*0.02, native.systemFont, 50 )

-- width: largura de cada frame
-- height: altura de cada frame
-- numFrames: número de frames da sprite
local sheetData =  { width=45, height=63, numFrames=12 }

-- cria uma nova imagem usando a sprite "gaara.png" e as propriedades vistas acima
local sheet = graphics.newImageSheet("Imagens/gaara.png", sheetData)

local sequenceData = 
{
	{ name = "idleDown", start = 1, count = 1, time = 0, loopCount = 1 },
    { name = "moveLeft", start = 5, count = 2, time = 1000, loopCount = 0 },
    { name = "moveRight", start = 8, count = 2, time = 1000, loopCount = 0 },
}

-- cria a sprite utilizando a propriedades vistas acima
local player = display.newSprite(sheet, sequenceData)
player.x = w
player.y = h * .8
fisica.addBody(player, "kinematic", {density=1, friction=1, bounce=0.5})

local player2 = display.newRect(0, 0, 30, 30)
player2.x = 0
player2.y = h * .7
fisica.addBody(player2, "kinematic", {density=1, friction=1, bounce=0.5})

function moverPlayerDireitaEsquerda(self, event)
	if self.x < 0 then
		self.x = w
 	else
		self.x = self.x - 2
 	end
end

function moverPlayerEsquerdaDireita(self, event)
	if self.x > w then
		self.x = 0
	else
		self.x = self.x + 2
	end
end

player:setSequence("moveLeft")
player.enterFrame = moverPlayerDireitaEsquerda
player:play()

player2:setSequence("moveRight")
player2.enterFrame = moverPlayerEsquerdaDireita
player2:play()

local function atualizarPontos (event)
	texto.text = math.floor( pontuacao )
end

local function detectarColisao( event )
    if ( event.phase == "ended" ) then
       pontuacao = pontuacao + 10
    end
end

Runtime:addEventListener("enterFrame", player)
Runtime:addEventListener("enterFrame", player2)
Runtime:addEventListener( "collision", detectarColisao )
Runtime:addEventListener( "enterFrame", atualizarPontos )
