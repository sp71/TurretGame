--[[
	Satinder Singh - April 6 2014
	Turret Program
	Dimensions created for iPhone5
]]--

local physics = require("physics")
physics.start()

local tur
local score = 70
local time = 0
local rotateAmount = 0
local swan
local duck
local w,h = display.contentWidth, display.contentHeight
local sound = audio.loadSound("bomb.wav")
local scoreDisplay = display.newText("Score: " .. score, 520, 1080, font, 50)
local timeDisplay = display.newText("Time: " .. time, 120, 1080, font, 50)
local boomViews = { width = 134, height = 134, numFrames = 12 }
local boomSheet = graphics.newImageSheet("boom.png", boomViews)
local boomSequenceData = { name = "explosion", start = 1, count = 10, time = 300, loopCount = 1, loopDirection = "forward" }
local boomEvent = display.newSprite(boomSheet, boomSequenceData)
--physics.setDrawMode ("hybrid")

function backGround()  
	island = display.newImage("art.png", 350, 1150)
	island.alpha = 0.50
	display.newImage("island.png", 500, 450):toBack()
	tur = display.newImage("Turret.png",300,1050)
end

local function onCollision(event)
	if event.object1.isBullet or event.object2.isBullet then
		if (event.phase == "ended") then
			audio.play(sound)
	    	event.object1:removeSelf()
	    	event.object2:removeSelf()
	    	boomEvent.x = event.object1.x
			boomEvent.y = event.object1.y
	    	boomEvent:play()
	    	if(score > 0 ) then
		    	score = score + 1
		    	scoreDisplay.text = "Score: "..score
		    end
		end
	end
end

function makeItRain() -- OBJECTS FALL!!
	swan = display.newImage("swan.png", math.random(600), -20)
	physics.addBody (swan)
	swan:applyLinearImpulse(0,time*40/1000,swan.x,swan.y)	
	if(math.random(2) == 1) then
		duckk = display.newImage("duck.png",math.random(w),-60)
		physics.addBody(duckk, "kinematic", {density = 3.0, friction = 0.5, bounce = 0.0})
		transition.to( duckk, { time=1500, x=math.random(w), y= time < 30 and h+400 or h+700} )
	end
end

function timeIncrease()
	if(time < 100) then
		time = time + 1
	end
	timeDisplay.text = "Time:" .. time
end
function fireMissle(event)
	local x = event.x - tur.x
	local y = event.y - tur.y
	local z = math.floor( math.sqrt(x*x + y*y) )
	tur.rotation = math.deg(math.asin(y/z)) + 90
	if(x < 0 ) then tur.rotation = -tur.rotation end
	bullets = {}
	for i=1,3,1 do
		bullets[i] = display.newImage("bullet.png", 300,1050)
		bullets[i].isBullet = true
		physics.addBody (bullets[i], {filter = {groupIndex = -1}})
		bullets[i].isFixedRotation = true
		bullets[i].rotation = tur.rotation
		bullets[i].x = 300
		bullets[i].y = 1050
		bullets[i]:applyLinearImpulse( x/100,y/100,bullets[i].x,bullets[i].y)
		if( i == 1) then x = x + 50  end
		if(i==2) then x = x - 100 end
	end
	if(score > 0) then
		score = score - 3
		scoreDisplay.text = "Score: "..score
	end
	if(score <= 0 or time >= 100) then 
		scoreDisplay.text = "Score:  0"
		local GameOver = display.newImage("game over.png",350,450)
		GameOver:scale(2,3)
		GameOver:rotate(30 + rotateAmount)
		rotateAmount = rotateAmount + 1
	end
end 

backGround()
timer.performWithDelay( 500, makeItRain, 0)
timer.performWithDelay( 1000, timeIncrease, 0)
Runtime:addEventListener("tap", fireMissle)
Runtime:addEventListener("collision", onCollision)
