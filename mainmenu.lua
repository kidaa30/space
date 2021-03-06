mainmenu = {
	selitem = 1,
	sely = 40,
	seldy = 0,
	names = {new = 'New game', cont = 'Continue', load = 'Load game',
		save = 'Save game', settings = 'Settings', credits = 'Credits', quit = 'Quit'},
	items = {
			{'new', 'load', 'settings', 'credits', 'quit'},
			{'cont', 'save', 'new', 'load', 'settings', 'credits', 'quit'}
			},
	menu_type_index = 1,
	actions = {},
	settings = {
		timeout = 0,
		selitem = 1,
		items = {
			{name='Reverse zoom keys', hint='Make scrolling up zoom out', type='bool', value='revzoom'},
			{name='Disable shaking', hint='Do not shake the camera when close to a black hole', type='bool', value='noshaking'},
			{name='Auto-rotate camera', hint='Rotate the camera to show the nearby planet down', type='bool', value='autorot'},
			{name='Back to main menu', hint='Return to the main menu, all changes are applied', type='return'},
			},
		},
	credits = {
		totaltime = 0,
		items = {
			{'gvx', 'Robin Wellner', 'Project lead, code'},
			{'CyaNox', 'Mark Sanders', 'Spaceship design and artwork'},
			{'Thanks', 'to the LOVE CLUB', 'for the feedback and support'},
			{'', '', ''},
			}
		},
	transition = {
		timeout = 0,
		},
	saving = {},
	loading = {},
	quitting = {},
	}

function mainmenu.actions.new()
	mainmenu.transition.targetfont = smallfont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'game'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.cont()
	mainmenu.transition.targetfont = smallfont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'game'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.save()
	mainmenu.transition.targetfont = smallfont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'mainmenu_saving'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.load()
	mainmenu.transition.targetfont = smallfont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'mainmenu_loading'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.settings()
	mainmenu.transition.targetfont = largefont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'mainmenu_settings'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.credits()
	mainmenu.transition.targetfont = largefont
	mainmenu.credits.totaltime = 0
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'mainmenu_credits'
	state.current = 'mainmenu_transition'
end
function mainmenu.actions.quit()
	mainmenu.transition.targetfont = largefont
	mainmenu.transition.timeout = .5
	mainmenu.transition.target = 'mainmenu_quitting'
	state.current = 'mainmenu_transition'
end

settings = {}
settinginfo = {revzoom = 'bool', noshaking = 'bool', autorot = 'bool'}
registerstate 'mainmenu'
registerstate 'mainmenu_transition'
registerstate 'mainmenu_saving'
registerstate 'mainmenu_loading'
registerstate 'mainmenu_settings'
registerstate 'mainmenu_credits'
registerstate 'mainmenu_quitting'


function mainmenu.load()
end

function mainmenu.update(dt)
	local to = mainmenu.selitem*40
	if mainmenu.sely > to + 15 then
		--mainmenu.sely = mainmenu.sely - 100 * dt
		mainmenu.seldy = mainmenu.seldy - 450 * dt
	elseif mainmenu.sely > to + 5 then
		mainmenu.seldy = mainmenu.seldy*.94 - 50 * dt
	elseif mainmenu.sely < to - 15 then
		mainmenu.seldy = mainmenu.seldy + 450 * dt
	elseif mainmenu.sely < to - 5 then
		mainmenu.seldy = mainmenu.seldy*.94 + 50 * dt
	end
	if mainmenu.seldy > 200 then
		mainmenu.seldy = 200
	end
	if mainmenu.seldy < -200 then
		mainmenu.seldy = -200
	end
	mainmenu.sely = mainmenu.sely + mainmenu.seldy * dt
	if love.mouse.isDown'l' then
		local y = love.mouse.getY() 
		if y > 340 - mainmenu.sely and y < 330 + 40*#mainmenu.items - mainmenu.sely then
			mainmenu.selitem = math.floor((y - 300 + mainmenu.sely)/40)
			states.mainmenu.keypressed.enter()
		end
	end
end

function mainmenu.draw(a)
	a = a or 255
	love.graphics.setColor(255,255,255, a)
	local sh = math.sqrt(math.abs(mainmenu.seldy))*.3
	local shx = sh > 2 and math.random(sh)-.5*sh or 0
	local shy = sh > 2 and math.random(sh)-.5*sh or 0
	love.graphics.print('Space', 20 + shx, 25 + shy)
	local I = mainmenu.selitem
	for i=1,#mainmenu.items[mainmenu.menu_type_index] do
		local m = math.abs(i - mainmenu.sely / 40)*10
		local M = i==I and 0 or (100+ math.sqrt(math.abs(i-I))*50)
		if math.floor((love.mouse.getY() - 300 + mainmenu.sely)/40) == i then
			love.graphics.setColor(i==I and 20 or (255-M),255,255, i==I and 255 or a)
		else
			love.graphics.setColor(255-M,255-M,255-M, i==I and 255 or a)
		end
		love.graphics.print(mainmenu.names[mainmenu.items[mainmenu.menu_type_index][i]], 300 - m, 300 + i * 40 - mainmenu.sely)
		--love.graphics.rectangle('line', 300 - m, 275 + i * 40 - mainmenu.sely, 100, 25)
	end
end

function mainmenu.settings.update(dt)
	mainmenu.settings.timeout = mainmenu.settings.timeout + dt
end
function mainmenu.settings.draw()
	for i, setting in ipairs(mainmenu.settings.items) do
		if i == mainmenu.settings.selitem then
			love.graphics.setColor(100,100,100)
			love.graphics.roundrect('fill', 15, i*30-15, 750, 30, 10, 10)
			love.graphics.roundrect('line', 15, i*30-15, 750, 30, 10, 10)
			if mainmenu.settings.timeout > .5 then
				love.graphics.setFont(smallfont)
				love.graphics.setColor(255,255,255, math.min((mainmenu.settings.timeout-.5)*255, 255))
				love.graphics.print(setting.hint, 740 - smallfont:getWidth(setting.hint), i*30-8)
				love.graphics.setFont(largefont)
			end
		end
		love.graphics.setColor(255,255,255)
		love.graphics.print(setting.name, 50, i*30-15)
		if setting.type == 'bool' then
			love.graphics.setLineWidth(2)
			love.graphics.rectangle('line', 25, i*30-10, 20, 20)
			if settings[setting.value] then
				love.graphics.rectangle('fill', 25, i*30-10, 20, 20)
			end
		end
	end
end

function mainmenu.transition.update(dt)
	mainmenu.transition.timeout = mainmenu.transition.timeout - dt
	if mainmenu.transition.timeout <= 0 then
		state.current = mainmenu.transition.target
		love.graphics.setFont(mainmenu.transition.targetfont)
		love.update(0.001)
	end
end
function mainmenu.transition.draw()
	local t = mainmenu.transition.timeout
	mainmenu.draw(510*t)
end
function mainmenu.quitting.update(dt)
	love.event.push'q'
end
function mainmenu.quitting.draw()
end

function mainmenu.saving.update(dt)
	savegame 'bluh'
	state.current = 'game'
end
function mainmenu.saving.draw()
end

function mainmenu.loading.update(dt)
	loadgame 'bluh'
	state.current = 'game'
end
function mainmenu.loading.draw()
end


function mainmenu.credits.update(dt)
	mainmenu.credits.totaltime = mainmenu.credits.totaltime + dt
	if mainmenu.credits.totaltime > #mainmenu.credits.items * 2 then
		states.mainmenu_credits.keypressed.escape()
	end
end
function mainmenu.credits.draw()
	local t = mainmenu.credits.totaltime
	local i = math.floor(t/2)+1
	local name = mainmenu.credits.items[i]
	if name then
		local a = 255 - (t%2-1)^2*255
		local displacement = t%2 * 30
		love.graphics.setColor(255,255,255, a)
		love.graphics.print(name[1], 10 + (i * 74) % 95, 20 + i + displacement)
		love.graphics.print(name[2], 130 - displacement + (i * 185) % 115, 120 + i)
		love.graphics.print(name[3], 70 + (i * 18) % 39, 220 + i - displacement)
	end
end

function states.mainmenu.keypressed.down()
	if mainmenu.selitem < #mainmenu.items[mainmenu.menu_type_index] then
		mainmenu.selitem = mainmenu.selitem + 1
	end
end

function states.mainmenu.keypressed.up()
	if mainmenu.selitem > 1 then
		mainmenu.selitem = mainmenu.selitem - 1
	end
end

function states.mainmenu.keypressed.enter()
	mainmenu.actions[mainmenu.items[mainmenu.menu_type_index][mainmenu.selitem]]()
end

function states.mainmenu_settings.keypressed.escape()
	love.graphics.setFont(largefont)
	state.current = 'mainmenu'
end
states.mainmenu_credits.keypressed.escape = states.mainmenu_settings.keypressed.escape

function states.mainmenu_settings.keypressed.up()
	mainmenu.settings.selitem = (mainmenu.settings.selitem - 2) % #mainmenu.settings.items + 1
	mainmenu.settings.timeout = 0
end

function states.mainmenu_settings.keypressed.down()
	mainmenu.settings.selitem = mainmenu.settings.selitem % #mainmenu.settings.items + 1
	mainmenu.settings.timeout = 0
end

function states.mainmenu_settings.keypressed.enter()
	local s = mainmenu.settings.items[mainmenu.settings.selitem]
	if s.type == 'return' then
		states.mainmenu_settings.keypressed.escape()
	elseif s.type == 'bool' then
		settings[s.value] = not settings[s.value]
	else
	end
end

function mainmenu.allowsave()
	return false
end
