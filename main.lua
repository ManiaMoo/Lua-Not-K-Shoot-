-- tutorial #2
-- added enemys, shooting, background etc.

function love.load()
  src1 = love.audio.newSource("Floral.mp3")
  src1:setVolume (0.5)
  src2 = love.audio.newSource("nofx.ogg")
  src2:setVolume (0.5)
	hero = {} -- new table for the hero
	hero.x = 300	-- x,y coordinates of the hero
	hero.y = 450
	hero.width = 30
	hero.height = 15
	hero.speed = 150
	hero.shots = {} -- holds our fired shots
	shootxposition = 0
  songstarted = 0 
  noteshit = 0
  notesmissed = 0
	enemies = {}
	
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

function love.keypressed(key)
  if (key == "1") then
    src1:play()
    songstarted = 1
    print (noteshit)
	end
    if (key == "2") then
    src2:play()
    songstarted = 1
    print (notesmissed)
	end
	if (key == "s") then
    shootxposition = 15
		shoot(shootxposition)
	end
  if (key == "d") then
    shootxposition = 115
		shoot(shootxposition)
	end
    if (key == "f") then
    shootxposition = 215
		shoot(shootxposition)
	end
    if (key == "j") then
    shootxposition = 315
		shoot(shootxposition)
	end
    if (key == "k") then
    shootxposition = 415
		shoot(shootxposition)
	end
    if (key == "l") then
    shootxposition = 515
		shoot(shootxposition)
	end
end

function love.update(dt)
	-- keyboard actions for our hero
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end
	
	local remEnemy = {}
	local remShot = {}
	
	-- update the shots
	for i,v in ipairs(hero.shots) do
    -- move them up up up
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
				table.insert(remEnemy, ii)

				
			end
		end
		
		
		
	end
	
		-- update those evil enemies
	for i,v in ipairs(enemies) do
		-- let them fall down slowly
    if songstarted == 1 then
      v.y = v.y + dt + 5
    end
		
		-- check for collision with ground
		if v.y > 780 then
      notesmissed = notesmissed + 1
      table.insert(remEnemy, i)
			-- you loose!!!
		end
		
	end
	-- remove the marked enemies
	for i,v in ipairs(remEnemy) do
		table.remove(enemies, v)
	end
	
	for i,v in ipairs(remShot) do
		table.remove(hero.shots, v)
	end
	
	
	

	
end


function love.draw()
  	-- let's draw some ground
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", 0, 770, 800, 150)
  	-- let's draw some ground
	love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 745, 800, 15)
	-- let's draw some ground
	love.graphics.setColor(119,136,153,255)
	love.graphics.rectangle("fill", 0, 750, 800, 5)
	
	-- let's draw our hero
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)
	
	-- let's draw our heros shots
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(hero.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 75, 100)
	end
	-- let's draw our enemies

	for i,v in ipairs(enemies) do
    love.graphics.setColor(0,255,255,255)
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
	end
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("SCORE:"..noteshit*100, 25, 25)
end

function shoot(shootxposition)
	
	local shot = {}
  
	shot.x = shootxposition
	shot.y = 750
	
	table.insert(hero.shots, shot)
	
	
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end