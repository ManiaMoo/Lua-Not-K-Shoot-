local screen = require "shack"
function love.load()
	shots = {}
	shootxposition = 0
  notefalling = 0
  gamestate = 0 
  songstarted = 0
  noteshit = 0
  notesmissed = 0
  missvisual = 0
  misstimer = 0
  notescreated = 0
  combo = 0
  previousscore = 0
  endtimer = 0
  songending = 0
	enemies = {}
  menugraphic = love.graphics.newImage("mainmenu.png")
  backgroundgraphic = love.graphics.newImage("ingame.png")
  song1 = love.graphics.newImage("trax.jpg")
  nosong = love.graphics.newImage("nosong.jpg")
  hitmarker = love.graphics.newImage("hitmarker.png")
  love.gameload()
end
function love.gameload()
  
  if (gamestate == 0) then
    
  end
  
  if (gamestate == 1) then
    local file = io.open("cracktrax.txt")
    src1 = love.audio.newSource("cracktrax.mp3")
    src1:setVolume (0.5)
    if notescreated == 0 then
     for line in file:lines() do
      enemy = {}
      local filex, filey = line:match'(%S+)%s+(%S+)'
      filey = ((filey/1.43)+550)
      enemy.x = tonumber(filex)
      enemy.y = tonumber(filey)
      enemy.width = 100
      enemy.height = 15
      table.insert(enemies, enemy)
      --Possible X positions = 0 (100 200 300 400) 500
      --Work out Y position based on song, rhythm to be figured out
      --HARD CODED, NOT GOOD!
    end
    end
    notescreated = 1
  end
  if (gamestate == 2) then
    src1 = love.audio.newSource("nofx.ogg")
    src1:setVolume (0.5)
    if notescreated == 0 then
    for i=0,9 do
      enemy = {}
      enemy.width = 100
      enemy.height = 15
      --Possible X positions = 0 100 200 300 400 500
      --Work out Y position based on song, rhythm to be figured out
      --HARD CODED, NOT GOOD!
      if i == 1 then
        enemy.x = 0
        enemy.y = 0
        table.insert(enemies, enemy)
      end
      if i == 2 then
        enemy.x = 300
        enemy.y = -200
        table.insert(enemies, enemy)
      end
    end
    end
    notescreated = 1
  end
end
function love.keypressed(key)
    if (key == "1") then
    gamestate = 1
    love.gameload()
    print (noteshit)
	end
    if (key == "2") then
    gamestate = 2
    print (notesmissed)
	end
    if ((key == "p") and (songstarted == 0)) then
      if ((gamestate == 1) or (gamestate == 2)) then
        if (songstarted == 0) then
          songstarted = 1
        end
        src1:play()
      end
    end
  end
function notes()
	--if (love.keyboard.isDown ("s")) then
  --  shootxposition = 15
	--	shoot(shootxposition)
	--end
  if (love.keyboard.isDown ("d")) then
    notefalling = 0
    shootxposition = 115
		shoot(shootxposition)
	end
    if (love.keyboard.isDown ("f")) then
    notefalling = 0
    shootxposition = 215
		shoot(shootxposition)
	end
    if (love.keyboard.isDown ("j")) then
    notefalling = 0
    shootxposition = 315
		shoot(shootxposition)
	end
    if (love.keyboard.isDown ("k")) then
    notefalling = 0
    shootxposition = 415
		shoot(shootxposition)
	end
  --  if (love.keyboard.isDown ("l")) then
  --  notefalling = 0
  --  shootxposition = 515
	--	shoot(shootxposition)
	--end
end

function love.update(dt)
	notes()
	local remEnemy = {}
	local remShot = {}
  screen:update(dt)
 
  if (missvisual == 1) then
    misstimer = misstimer + dt
      if misstimer >= 1 then
        missvisual = 0
        misstimer = 0
    end
  end
  if (gamestate == 1) then
    if ((noteshit + notesmissed) >= 661) then
      if (previousscore <= (noteshit*100)) then
        previousscore = noteshit*100
      end
      endtimer = endtimer + dt
      songending = 0
      if endtimer >= 2 then  
        gamestate = 0
        endtimer = 0
        combo = 0
        noteshit = 0
        notesmissed = 0
        songstarted = 0
        notefalling = 0
        notescreated = 0
      end
    end
  end
	-- update the shots
	for i,v in ipairs(shots) do
    -- move them down 

      v.y = v.y + dt * 100

		-- mark shots that are not visible for removal
		if v.y > 1000 then
			table.insert(remShot, i)
		end
		-- check for collision with enemies
		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
				
				-- mark that enemy for removal
        noteshit = noteshit+1
        combo = combo + 1
        table.remove(enemies, ii)
				
			end
		end
		
		
		
	end

		-- update those evil enemies
	for i,v in ipairs(enemies) do
		-- let them fall down slowly
    if songstarted == 1 then
      v.y = v.y + dt * 700
    end
		
		-- check for collision with ground
		if v.y > 780 then
      screen:setShake(20)
      notesmissed = notesmissed + 1
      combo = 0
      
      missvisual = 1
      misstimer = 0
    
      table.remove(enemies, i)
		end
		
	end
	-- remove the marked enemies

	
	for i,v in ipairs(remShot) do
		table.remove(shots, v)
	end
	
	
	

	
end


function love.draw()
  screen:apply()
  font1 = love.graphics.newFont("digitalfont.ttf", 56)
  font2 = love.graphics.newFont("square.ttf", 42)
  font3 = love.graphics.newFont("square.ttf", 26)
  love.graphics.setFont(font2)

  	-- let's draw some ground

  
  if gamestate == 0 then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(font3)
    love.graphics.draw(menugraphic,0,0)
    love.graphics.draw(song1,645,198,0,0.2,0.2)
    love.graphics.print("Lite Show Magic\nCrackTraxxxx\nBEST:"..previousscore.."\nPress 1 to Play", 840, 198)
    love.graphics.draw(nosong,645,340,0,0.35,0.35)
    love.graphics.draw(nosong,645,485,0,0.35,0.35)
    love.graphics.setFont(font2)
  end
  if gamestate == 1 then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(backgroundgraphic,0,0)
    love.graphics.draw(song1,630,198,0,0.45,0.45)
    love.graphics.print("Lite Show Magic\nCrackTraxxxx", 650, 500)
  end
  	-- let's draw some ground
	love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 715, 605, 15)
	-- let's draw some ground
	love.graphics.setColor(119,136,153,255)
	love.graphics.rectangle("fill", 0, 720, 605, 5)
  	-- let's draw some ground
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", 605, 0, 10, 800)
	
	
	-- let's draw our heros shots
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(shots) do
		love.graphics.rectangle("fill", v.x, v.y, 75, 100)
	end
	-- let's draw our enemies

	for i,v in ipairs(enemies) do
    love.graphics.setColor(0,255,255,255)
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
  if gamestate == 1 then
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("SCORE: "..noteshit*100, 650, 25)
    love.graphics.print("MISSED NOTES: "..notesmissed, 650, 95)
    if combo >= 3 then
    love.graphics.print(combo.." COMBO", 230, 600)

  end

  end
  if missvisual == 1 then
      love.graphics.setColor(255,255,255,255)
      love.graphics.print("MISS", 260, 600)
      
    end
end
function shoot(shootxposition)
	
	local shot = {}
  
	shot.x = shootxposition
	shot.y = 725
	
	table.insert(shots, shot)
	
	
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end