--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function sub_read(txt, mountP, tb, tb2)

	for line in io.lines(txt) do

		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13

		pathp,status = line:match("(.+) (.+)")
		if pathp then
			for j=1,#tb do
				if not tb[j].hide then
					if pathp:lower() == "ms0:/"..tb[j].path:lower()..tb[j].name:lower() then

						if files.exists(mountP.."pspemu/"..tb[j].path:lower()..tb[j].name:lower()) then
							tb2[mountP..tb[j].name:lower()] = tonumber(status) or nil
							break
						end
					end
				end
			end

		end

	end

end

function read_configs(tb,tb2)

	for i=1, #PMounts do

		--vsh.txt
		if files.exists(PMounts[i].."pspemu/seplugins/vsh.txt") then
			sub_read(PMounts[i].."pspemu/seplugins/vsh.txt", PMounts[i], tb, tb2)
		end

		--game.txt
		if files.exists(PMounts[i].."pspemu/seplugins/game.txt") then
			sub_read(PMounts[i].."pspemu/seplugins/game.txt", PMounts[i], tb, tb2)
		end

	end

end

function add_disable_psp_plugin(device,obj,install)

	--add vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/"..obj.path..obj.name

	for line in io.lines(device.."pspemu/seplugins/"..obj.txt) do
		cont += 1
		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
		table.insert(file_txt,line)

		pathp,status = line:match("(.+) (.+)")

		if pathp then
			if pathp:lower() == find_obj:lower() then
				_find = true
				nlinea = cont
			end
		end

	end

	if install == 1 then
		if _find then
			file_txt[nlinea] = find_obj.." 1"
		else
			table.insert(file_txt, find_obj.." 1")
		end
	else
		--file_txt[nlinea] = find_obj.." 0"
		table.remove(file_txt, nlinea)
	end

	local fp = io.open(device.."pspemu/seplugins/"..obj.txt, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function pluginsPSP()

	local tb_cop = {}
	update_translations(pluginsP, tb_cop)

	for k = #tb_cop,1,-1 do
		if tb_cop[k].REMOVE then
			table.remove(tb_cop,k)
		end
	end

	local plugins_status={}
	read_configs(tb_cop,plugins_status)

	local selector,limit = 1,8
	if #tb_cop < limit then limit = #tb_cop end
	local scroll = newScroll(tb_cop, limit)
	local xscroll = 10

	for i=1,scroll.maxim do
		tb_cop[i].inst = false
	end

	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["PLUGINS_PSP_TITLE"],1.0,color.white,color.blue,__ACENTER)

		screen.print(13, 65, " ("..scroll.maxim..")", 1, color.yellow, 0x0)

		--Partitions
		local xRoot = 700
		local w = (955-xRoot)/#PMounts
		for i=1, #PMounts do
			if selector == i then
				draw.fillrect(xRoot,56,w,42, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 65, PMounts[i], 1, color.white, color.blue, __ACENTER)
			xRoot += w
		end

		--List of Plugins
		local y = 110
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(15,y-10,945,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			if tb_cop[i].inst then ccolor = color.green else ccolor = color.white end
			screen.print(25,y, tb_cop[i].nameR,1,ccolor,0x0)

			if plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] then
				if plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] == 1 then
					if dotg then dotg:blit(925,y-1) end
				elseif plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] == 0 then
					if doty then doty:blit(925,y-1) end
				end
			end
			screen.print(920,y, "( "..tb_cop[i].txt.." )",1,ccolor,0x0,__ARIGHT)

			y+=35
		end

		--Bar Scroll
		local ybar, h = 103, (limit*35)-2
		draw.fillrect(3, ybar-2, 8, h, color.shine)
		local pos_height = math.max(h/scroll.maxim, limit)
		draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

		if tb_cop[scroll.sel].desc then
			if screen.textwidth(tb_cop[scroll.sel].desc) > 925 then
				xscroll = screen.print(xscroll, 400, tb_cop[scroll.sel].desc,1,color.green,0x0,__SLEFT,935)
			else
				screen.print(480, 400, tb_cop[scroll.sel].desc,1,color.green,0x0,__ACENTER)
			end
		end

		if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
		if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
		screen.print(895,450,LANGUAGE["PSPCTRLS_LR_SWAP"],1,color.white,color.black,__ARIGHT)

		if buttonskey then buttonskey:blitsprite(10,448,__TRIANGLE) end
		screen.print(45,450,LANGUAGE["UNINSTALL_PLUGIN"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,472,__SQUARE) end
		screen.print(45,475,LANGUAGE["MARK_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(5,498,0) end
		screen.print(45,500,LANGUAGE["CLEAN_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.cancel then break end

		--L/R
		if buttons.released.l or buttons.released.r then
			if buttons.released.l then selector -= 1 else selector += 1 end
			if selector > #PMounts then selector = 1
			elseif selector < 1 then selector = #PMounts end
			for i=1,scroll.maxim do
				tb_cop[i].inst = false
			end
			scroll = newScroll(tb_cop, limit)
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if scroll.maxim > 0 then

			if buttons.left or buttons.right then xscroll = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end

			if buttons.accept then

				if not files.exists(PMounts[selector].."pspemu/seplugins/vsh.txt") then
					files.new(PMounts[selector].."pspemu/seplugins/vsh.txt")
				end
				if not files.exists(PMounts[selector].."pspemu/seplugins/game.txt") then
					files.new(PMounts[selector].."pspemu/seplugins/game.txt")
				end

				tb_cop[scroll.sel].inst = true

				for i=1, scroll.maxim do
					if tb_cop[i].inst then
						
						--install plugin
						files.copy("resources/plugins_psp/"..tb_cop[i].name, PMounts[selector].."pspemu/"..tb_cop[i].path)

						--install config
						if tb_cop[i].config then
							files.copy("resources/plugins_psp/"..tb_cop[i].config, PMounts[selector].."pspemu/"..tb_cop[i].path)
						end

						if plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] == 0 or not plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] then
							add_disable_psp_plugin(PMounts[selector], tb_cop[i], 1)
							plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] = 1
							tb_cop[i].inst = false
						end

						if back2 then back2:blit(0,0) end
							message_wait(tb_cop[i].name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
						os.delay(750)

					end
				end

				for i=1,scroll.maxim do
					tb_cop[scroll.sel].inst = false
				end

			end
			
			--Mark/Unmark
			if buttons.square then
				tb_cop[scroll.sel].inst = not tb_cop[scroll.sel].inst
			end

			--Clean selected
			if buttons.select then
				for i=1,scroll.maxim do
					tb_cop[i].inst = false
				end
			end

			--disable plugins
			if buttons.triangle then

				tb_cop[scroll.sel].inst = true

				for i=1,scroll.maxim do
					if tb_cop[i].inst then
						if files.exists(PMounts[selector].."pspemu/seplugins/"..tb_cop[i].txt) and plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] == 1 then

							add_disable_psp_plugin(PMounts[selector], tb_cop[i],0)
							plugins_status[ PMounts[selector]..tb_cop[i].name:lower() ] = nil--0
							tb_cop[i].inst = false

							if back2 then back2:blit(0,0) end
								message_wait(tb_cop[i].name.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
							os.delay(750)
						end
					end
				end

				for i=1,scroll.maxim do
					tb_cop[scroll.sel].inst = false
				end

			end

		end

	end

end
