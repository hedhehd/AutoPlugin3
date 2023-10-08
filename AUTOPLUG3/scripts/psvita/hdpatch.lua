--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

dofile("scripts/psvita/p4golden.lua")
dofile("scripts/psvita/catherine.lua")

local p4_callback = function ()
	P4Golden_HD()
end

local catherine_callback = function ()
	Catherine_HD()
end

function HD_Patch()

	local menu = {
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD"],	    desc = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD_DESC"],		  funct = p4_callback },
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD_DESC"], funct = catherine_callback },
	}

	local scroll = newScroll(menu,#menu)
	local xscroll = 10

	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_HD_PATCH"],1.0,color.white,color.blue,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21) end
			--	tam = 1.4
			--else tam = 1.2 end

			screen.print(480,y,menu[i].text,1.0,color.white,color.blue,__ACENTER)
			y += 45
		end

		if screen.textwidth(menu[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 520, menu[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 520, menu[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		screen.flip()

		--Controls
		if buttons.left or buttons.right then xscroll = 10 end

        if buttons.up or buttons.analogly < -60 then
			if scroll:up() then xscroll = 10 end
		end
        if buttons.down or buttons.analogly > 60 then
			if scroll:down() then xscroll = 10 end
		end

		if buttons.cancel then break end
		if buttons.accept then menu[scroll.sel].funct() end

		vol_mp3()

	end

end
