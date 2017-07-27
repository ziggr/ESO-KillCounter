--stats stuff

local stats_window = nil
local stats_position = 1
local stats_num_to_show = 23
local stats_kills_buffery = 15
local stats_kills_starty = 225
local stats_kills_bufferx = 10
local player_view_window = nil
local showingStats = false
local showingSettings = false


local stats_killed_array = {}
local stats_killed_labels = {}

local stats_table = nil
local kills_table = nil
local seige_table = nil
local deaths_table = nil
local breakdown_table = nil
local breakdown_graph = nil
local breakdown_death_graph = nil
local killing_blow_spells_table = nil

local LMM = LibStub("LibMainMenu")



function KC_G.showingStats() return showingStats end
function KC_G.showingSettings() return showingSettings end


function KC_G.settingsWindowGUISetup()
	if settings_window == nil then return end

	d("settings window")


	--START Kills Table
	local tlw = Scene_KC_Menu_Settings_Table
	tlw:ClearAnchors()
	tlw.DataOffset = 0
    tlw.MaxLines = 9
    tlw.MaxColumns = 2
    tlw.DataLines = {}
    tlw.Lines = {}
	tlw:SetHeight(360)
    tlw:SetWidth(500)
    tlw:SetAnchor(TOPLEFT,Scene_KC_Menu_Settings,TOPLEFT,50,25)
    tlw:SetDrawLayer(DL_BACKGROUND)
    tlw:SetMouseEnabled(true)
    tlw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tlw:SetHandler("OnShow",function(self)

        tlw.DataLines = {}
        for i=1,4 do
            tlw.DataLines[i] = string.format("kills and stuff %d", 0)
        end

    end)
 
    tlw.BackGround = WINDOW_MANAGER:CreateControl(nil,tlw,CT_BACKDROP)
    tlw.BackGround:SetAnchorFill(tlw)
    tlw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tlw.BackGround:SetEdgeColor(1, 1, 1, 0.0)
    tlw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    for i=1,tlw.MaxLines do
        tlw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Settings_Line_" .. i, tlw, "KillCounter_Overview_Line")
        tlw.Lines[i]:SetDimensions(tlw:GetWidth()-10,35)
        if i == 1 then
            tlw.Lines[i]:SetAnchor(TOPLEFT,tlw,TOPLEFT,5,5)
        else
            tlw.Lines[i]:SetAnchor(TOPLEFT,tlw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tlw.Lines[i].Columns = {}
 		for j=1,tlw.MaxColumns do 
 			if j == 1 then
		        tlw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tlw.Lines[i],CT_LABEL)
		        tlw.Lines[i].Columns[j]:SetFont("ZoFontGameSmall")
		        tlw.Lines[i].Columns[j]:SetDimensions(tlw.Lines[i]:GetWidth()/2,30)

	            tlw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tlw.Lines[i],TOPLEFT,18,8)

	        else
	        	tlw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tlw.Lines[i],CT_BUTTON)
	        	tlw.Lines[i].Columns[j].Label = WINDOW_MANAGER:CreateControl(nil,tlw.Lines[i].Columns[j],CT_LABEL)
		        tlw.Lines[i].Columns[j].Label:SetFont("ZoFontGameBold")
		        tlw.Lines[i].Columns[j]:SetDimensions(tlw.Lines[i]:GetWidth()/2,30)
		        tlw.Lines[i].Columns[j].Label:SetDimensions(tlw.Lines[i]:GetWidth()/2,30)

	            tlw.Lines[i].Columns[j]:SetAnchor(TOPRIGHT,tlw.Lines[i],TOPRIGHT,85,8)
	            tlw.Lines[i].Columns[j].Label:SetAnchorFill()
	            
	        end



	        --Sounds
    		if i==1 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Kill/Streak Sound Effects") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.Sounds then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("Sounds")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatKills
	   		if i==2 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Player Kill Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatKills then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatKills")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatSeiges
	   		if i==3 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Cyrodiil Seige Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatSeiges then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatSeiges")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end


	   		--ChatCaptures
	   		if i==4 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Resource/Keep Capture Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatCaptures then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatCaptures")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatDeaths
	   		if i==5 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Deaths Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatDeaths then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatDeaths")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatKStreak
	   		if i==6 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Kill Streak Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatKStreak then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatKStreak")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatDStreaj
	   		if i==7 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Death Streak Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatDStreak then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatDStreak")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ChatCaptures
	   		if i==8 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Resource/Keep Capture Streak Alerts") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ChatCapStreak then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ChatCapStreak")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end

	   		--ignore npc deaths
	   		if i==9 then
    			if j==1 then 
    				tlw.Lines[i].Columns[j]:SetText("Ignore NPC Deaths") 
    			end
		        if j==2 then 
		        	local txt = "On"
		        	if not KC_G.savedVars.settings.ignoreNPCDeath then txt = "Off" end
		        	tlw.Lines[i].Columns[j].Label:SetText(txt) 
		        	tlw.Lines[i].Columns[j].Label:SetHidden(false)
		        	tlw.Lines[i].Columns[j]:SetHandler("OnClicked",function(self,delta)
	            	
		            	--d("clicked on you bitch")
		            	local ret = KC_Fn.ToggleSetting("ignoreNPCDeath")
		            	local txt = "On"
			        	if not ret then txt = "Off" end
			        	settings_table.Lines[i].Columns[j].Label:SetText(txt) 
		            	


	    			end)
		        end

	   		end





	        tlw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    settings_table = tlw
    --E
end

function KC_G.statsWindowGUISetup()
	if stats_window == nil then return end

	--KC_G.KCMenuSetup()

	--KillCounter_Stats_BG:SetCenterTexture("esoui/art/ava/ava_allianceflag_aldmeri")
	--KillCounter_Stats_Window_Logo_Texture:SetTexture(KC_Fn.Alliance_Texture_From_Id(GetUnitAlliance('player')))

	--[[
	for i=1, stats_num_to_show do 

		stats_killed_labels[i] = CreateControlFromVirtual("KillCounter_Kills_Label", stats_window, "KillCounter_Kills_Label", i)
		stats_killed_labels[i]:SetText(stats_killed_array[i])
		stats_killed_labels[i]:SetAnchor(TOPLEFT,CL,TOPLEFT,stats_kills_bufferx,stats_kills_starty + stats_kills_buffery*(i))

	end
	--]]
	--/print("setting up")
	--START Kills Table
	local tlw = Scene_KC_Menu_Stats_Table
	tlw.Logo = KillCounter_Stats_Window_Kills_Logo
	tlw:ClearAnchors()
	tlw.DataOffset = 0
    tlw.MaxLines = 8
    tlw.MaxColumns = 3
    tlw.DataLines = {}
    tlw.Lines = {}
	tlw:SetHeight(430)
    tlw:SetWidth(600)
    tlw:SetAnchor(TOPLEFT,Scene_KC_Menu,TOPLEFT,80,30)
    tlw:SetDrawLayer(DL_BACKGROUND)
    tlw:SetMouseEnabled(true)
    tlw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tlw:SetHandler("OnShow",function(self)

        tlw.DataLines = {}
        for i=1,4 do
            tlw.DataLines[i] = string.format("kills and stuff %d", 0)
        end

    end)
 
    tlw.BackGround = WINDOW_MANAGER:CreateControl(nil,tlw,CT_BACKDROP)
    tlw.BackGround:SetAnchorFill(tlw)
    tlw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tlw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tlw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    for i=1,tlw.MaxLines do
        tlw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Overview_Line_" .. i, tlw, "KillCounter_Overview_Line")
        tlw.Lines[i]:SetDimensions(tlw:GetWidth()-10,50)
        if i == 1 then
            tlw.Lines[i]:SetAnchor(TOPLEFT,tlw,TOPLEFT,5,5)
        else
            tlw.Lines[i]:SetAnchor(TOPLEFT,tlw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tlw.Lines[i].Columns = {}
 		for j=1,tlw.MaxColumns do 
	        tlw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tlw.Lines[i],CT_LABEL)
	        tlw.Lines[i].Columns[j]:SetFont("ZoFontGame")
	        tlw.Lines[i].Columns[j]:SetDimensions(tlw.Lines[i]:GetWidth()/3,30)
	        if j == 1 then
            	 tlw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tlw.Lines[i],TOPLEFT,18,15)
        	else
        		local oy = 0
        		if i ~= 1 then 
        			tlw.Lines[i].Columns[j]:SetFont("ZoFontCenterScreenAnnounceSmall")
        			if j == 2 then
        				oy = -8
        			end
        		end
            	tlw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tlw.Lines[i].Columns[j-1],TOPLEFT, (tlw.Lines[i]:GetWidth()/3),oy)
        	end




        	if i==1 then
        		if j==1 then tlw.Lines[i].Columns[j]:SetText("Stats Overview") end
        		if j==2 then tlw.Lines[i].Columns[j]:SetText("Overall/Longest") end
        		if j==3 then tlw.Lines[i].Columns[j]:SetText("Current") end
        	else
        		if i==2 then
        			if j==1 then tlw.Lines[i].Columns[j]:SetText("Kills: ") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("T Kills") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("C Kills") end

		   		end
		   		if i==3 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("Deaths: ") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("T Deaths") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("C Deaths") end

		   		end
		   		if i==4 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("Streaks: ") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("L Streak") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("C Streak") end

		   		end
		   		if i==5 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("Death Streaks: ") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("L DStreak") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("C DStreak") end

		   		end
		   		if i==6 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("Kills/Deaths: ") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("L DStreak") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("C DStreak") end

		   		end
		   		if i==7 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("AP gained") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("0") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("0") end

		   		end
		   		if i==8 then
		   			if j==1 then tlw.Lines[i].Columns[j]:SetText("Killing Blows") end
			        if j==2 then tlw.Lines[i].Columns[j]:SetText("0") end
	        		if j==3 then tlw.Lines[i].Columns[j]:SetText("0") end

		   		end


		    end
	        tlw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    stats_table = tlw
    --END OVERVIEW TABLE

    --START KILLS TABLE
    local tkw = Scene_KC_Menu_Kills_Kills_Table
	tkw:ClearAnchors()
	tkw.DataOffset = 0
    tkw.MaxLines = 16
    tkw.MaxColumns = 7
    tkw.DataLines = {}
    tkw.Lines = {}
	tkw:SetHeight(455)
    tkw:SetWidth(850)
    tkw:SetAnchor(TOPLEFT,Scene_KC_Menu_Kills,TOPLEFT,25,25)
    tkw:SetDrawLayer(DL_BACKGROUND)
    tkw:SetMouseEnabled(true)
    tkw:SetHandler("OnMouseWheel",function(self,delta)
    	if kills_table == nil then return end
    	local tlw = kills_table
    	local value = tlw.DataOffset - delta
        if value < 0 then 
            value = 0
        elseif value > KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines then 
            value = KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines 
        end
        tlw.DataOffset = value
        tlw.Slider:SetValue(tlw.DataOffset)
        KC_G.UpdateKillsTable()
    end)
    tkw:SetHandler("OnShow",function(self)

        tkw.DataLines = {}

        for k,v in pairs(KC_G.savedVars.killed) do
        	table.insert(tkw.DataLines, v)
        end
        KC_G.UpdateKillsTable()
        --d("showing")


    end)
 
    tkw.BackGround = WINDOW_MANAGER:CreateControl(nil,tkw,CT_BACKDROP)
    tkw.BackGround:SetAnchorFill(tkw)
    tkw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tkw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tkw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  

    local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
    tkw.Slider = WINDOW_MANAGER:CreateControl("KillCounter_THIS_FUCKING_ASSHOLE_SCROLLBAR",tkw,CT_SLIDER)
    
    
    tkw.Slider:SetDimensions(13,tkw:GetHeight())
    tkw.Slider:SetMouseEnabled(true)
    tkw.Slider:SetThumbTexture(tex,tex,tex,13,35,0,0,1,1)
    tkw.Slider:SetValue(0)
    tkw.Slider:SetValueStep(1)
    tkw.Slider:SetAnchorFill()
 	tkw.Slider:SetMinMax(0,50)
 	tkw.Slider:ClearAnchors()
 	tkw.Slider:SetAnchor(TOPLEFT,tkw,TOPLEFT,tkw:GetWidth() - 15,5)

        -- When we change the slider's value we need to change the data offset and redraw the display
    tkw.Slider:SetHandler("OnValueChanged",function(self,value,eventReason)
        --tkw.DataOffset = math.min(value,#tkw.DataLines - tkw.MaxLines)
        --d("changing things you bitch")
        if kills_table == nil then return end
        local tlw = kills_table
        tlw.DataOffset = math.min(value,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
        KC_G.UpdateKillsTable()
    end)
 


    for i=1,tkw.MaxLines do
        tkw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Kills_Table_Line_" .. i, tkw, "KillCounter_Kills_Table_Line")
        tkw.Lines[i]:SetDimensions(tkw:GetWidth()-10,25)
        if i == 1 then
            tkw.Lines[i]:SetAnchor(TOPLEFT,tkw,TOPLEFT,0,5)
        else
            tkw.Lines[i]:SetAnchor(TOPLEFT,tkw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tkw.Lines[i].Columns = {}
 		for j=1,tkw.MaxColumns do 
	        tkw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i],CT_LABEL)
	        local oy = 0
	        if i == 1 then
	        	tkw.Lines[i].Columns[j]:SetFont("ZoFontGameBold")
	        else
	        	tkw.Lines[i].Columns[j]:SetFont("ZoFontGameSmall")
	        	--cell if second cell, set offset y to 3
	        	 oy = 3
	        	
	        end
	        tkw.Lines[i].Columns[j]:SetDimensions(tkw.Lines[i]:GetWidth()/3,25)
	        if i==1 then
		        local sw, wh = tkw.Lines[i].Columns[j]:GetTextDimensions()
	    		--d(wh)
	    		tkw.Lines[i].Columns[j]:SetDimensions(sw,25)
		        if j == 1 then
	            	 tkw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkw.Lines[i],TOPLEFT,18,0)
	        	else
	        		local sw, wh = tkw.Lines[i].Columns[j-1]:GetTextDimensions()
	        		local ox = (tkw.Lines[i]:GetWidth()/tkw.MaxColumns) - sw
	        		--d(tkw.Lines[i].Columns[j]:GetWidth(), (tkw.Lines[i]:GetWidth()/tkw.MaxColumns))
	            	 tkw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j-1],TOPRIGHT, ox,oy)
	        	end
	        else
	        	--.d("happen")
	        	--center that bitch
	        	local w, h = tkw.Lines[1].Columns[j]:GetTextDimensions()

	        	local offx = 0
	        	if j ~= 1 and i == 2 and j ~= 6 and j ~= 7 then
	        		offx = (w/2) - tkw.Lines[i].Columns[j]:GetTextDimensions()
	        	end



	        	tkw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkw.Lines[i-1].Columns[j],BOTTOMLEFT,offx,oy)
	        end


        	--tkw.Lines[i].Columns[j]:SetText("Column")
        	if i == 1 then
        		if j == 1 then 
        			tkw.Lines[i].Columns[j]:SetText("Player Name")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Name < t[a].Name end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Name > t[a].Name end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 2 then 
        			tkw.Lines[i].Columns[j]:SetText("Total Kills")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Kills < t[a].Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Kills> t[a].Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 3 then 
        			tkw.Lines[i].Columns[j]:SetText("Killing Blows")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].KillingBlows< t[a].KillingBlows end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].KillingBlows > t[a].KillingBlows end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 4 then 
        			tkw.Lines[i].Columns[j]:SetText("Revenge Kills")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Revent_Kills < t[a].Revent_Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Revent_Kills > t[a].Revent_Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 5 then 
        			tkw.Lines[i].Columns[j]:SetText("Avenge Kills")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Avenge_Kills< t[a].Avenge_Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Avenge_Kills > t[a].Avenge_Kills end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 6 then 
        			tkw.Lines[i].Columns[j]:SetText("Class")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Class< t[a].Class end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) return t[b].Class > t[a].Class end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 7 then 
        			tkw.Lines[i].Columns[j]:SetText("Alliance")
        			tkw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].SortButton:SetWidth(tkw.Lines[i].Columns[j]:GetWidth())
        			tkw.Lines[i].Columns[j].SortButton:SetHeight(tkw.Lines[i].Columns[j]:GetHeight())
        			tkw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].SortButton.Desc = false
        			tkw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkw.Lines[i].Columns[j].SortButton.Desc = not tkw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) 
		        						local n1 = tonumber(t[b].Alliance)
		        						if n1 == nil then n1 = 0 end
		        						local n2 = tonumber(t[a].Alliance)
		        						if n2 == nil then n2 = 0 end
		        						return n1 < n2 
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(kills_table.DataLines, function(t,a,b) 
		        						local n1 = tonumber(t[b].Alliance)
		        						if n1 == nil then n1 = 0 end
		        						local n2 = tonumber(t[a].Alliance)
		        						if n2 == nil then n2 = 0 end
		        						return n1 > n2 
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							kills_table.DataLines = dl
							KC_G.UpdateKillsTable()
							--d(#dl)

	    			end)
	    			tkw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			--
    		else
    			if j==1 then
    				tkw.Lines[i].Columns[j].PlayerButton = WINDOW_MANAGER:CreateControl(nil,tkw.Lines[i].Columns[j],CT_BUTTON)

        			tkw.Lines[i].Columns[j].PlayerButton:SetWidth(tkw.Lines[i]:GetWidth()-22)
        			tkw.Lines[i].Columns[j].PlayerButton:SetHeight(tkw.Lines[i]:GetHeight())
        			tkw.Lines[i].Columns[j].PlayerButton:SetAnchor(TOPLEFT,tkw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkw.Lines[i].Columns[j].PlayerButton:SetHandler("OnClicked",function(self,delta)
        					--d("bitches")
        					KC_G.ShowPlayer(tkw.Lines[i].Columns[j]:GetText())

	    			end)
	    			tkw.Lines[i].Columns[j].PlayerButton:SetHidden(false)
        		end
    		end
	    		
	    			
	    			

	        tkw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    --d(KC_G.savedVars.killed)
	--tkw.DataLines = KC_G.savedVars.killed
	--d(tkw.DataLines)
	for k,v in pairs(KC_G.savedVars.killed) do
		table.insert(tkw.DataLines, v)
	end

	--tkw:SetHidden(true)
    kills_table = tkw


    KC_G.UpdateKillsTable()

    --START Kills Table
	local tsw = Scene_KC_Menu_Seige_Table
	--tlw.Logo = KillCounter_Stats_Window_Kills_Logo
	tsw:ClearAnchors()
	tsw.DataOffset = 0
    tsw.MaxLines = 5
    tsw.MaxColumns = 3
    tsw.DataLines = {}
    tsw.Lines = {}
	tsw:SetHeight(147)
    tsw:SetWidth(500)
    tsw:SetAnchor(TOPLEFT,Scene_KC_Menu,TOPLEFT,80,475)
    tsw:SetDrawLayer(DL_BACKGROUND)
    tsw:SetMouseEnabled(true)
    tsw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tsw:SetHandler("OnShow",function(self)

        tsw.DataLines = {}
        for i=1,4 do
            tsw.DataLines[i] = string.format("kills and stuff %d", i)
        end

    end)
 
    tsw.BackGround = WINDOW_MANAGER:CreateControl(nil,tsw,CT_BACKDROP)
    tsw.BackGround:SetAnchorFill(tsw)
    tsw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tsw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tsw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    for i=1,tsw.MaxLines do
        tsw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Seige_Overview_Line_" .. i, tsw, "KillCounter_Overview_Line")
        tsw.Lines[i]:SetDimensions(tsw:GetWidth()-10,25)
        if i == 1 then
            tsw.Lines[i]:SetAnchor(TOPLEFT,tsw,TOPLEFT,5,5)
        else
            tsw.Lines[i]:SetAnchor(TOPLEFT,tsw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tsw.Lines[i].Columns = {}
 		for j=1,tsw.MaxColumns do 
	        tsw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tsw.Lines[i],CT_LABEL)
	        tsw.Lines[i].Columns[j]:SetFont("ZoFontGame")
	        tsw.Lines[i].Columns[j]:SetDimensions(tsw.Lines[i]:GetWidth()/3,30)
	        if j == 1 then
            	 tsw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tsw.Lines[i],TOPLEFT,18,0)
        	else
            	 tsw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tsw.Lines[i].Columns[j-1],TOPLEFT, (tsw.Lines[i]:GetWidth()/3),0)
        	end


        	if i==1 then
        		if j==1 then tsw.Lines[i].Columns[j]:SetText("Seige Overview") end
        		if j==2 then tsw.Lines[i].Columns[j]:SetText("Total/Longest") end
        		if j==3 then tsw.Lines[i].Columns[j]:SetText("Current") end
        	else
        		if i==2 then
        			if j==1 then tsw.Lines[i].Columns[j]:SetText("Keep Captures: ") end
			        if j==2 then tsw.Lines[i].Columns[j]:SetText("T KCaps") end
	        		if j==3 then tsw.Lines[i].Columns[j]:SetText("C KCaps") end

		   		end
		   		if i==3 then
		   			if j==1 then tsw.Lines[i].Columns[j]:SetText("Resource Captures: ") end
			        if j==2 then tsw.Lines[i].Columns[j]:SetText("T RCaps") end
	        		if j==3 then tsw.Lines[i].Columns[j]:SetText("C RCaps") end

		   		end
		   		if i==4 then
		   			if j==1 then tsw.Lines[i].Columns[j]:SetText("Resource Streak: ") end
			        if j==2 then tsw.Lines[i].Columns[j]:SetText("L Streak") end
	        		if j==3 then tsw.Lines[i].Columns[j]:SetText("C Streak") end

		   		end
		   		if i==5 then
		   			if j==1 then tsw.Lines[i].Columns[j]:SetText("Keep Streak: ") end
			        if j==2 then tsw.Lines[i].Columns[j]:SetText("L DStreak") end
	        		if j==3 then tsw.Lines[i].Columns[j]:SetText("C DStreak") end

		   		end
		    end
	        tsw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    seige_table = tsw
    --seige_table:SetHidden(true)
    --END SEIGE TABLE

    --START DEATHS TABLE

    local tdw = Scene_KC_Menu_Deaths_Deaths_Table
	tdw:ClearAnchors()
	tdw.DataOffset = 0
    tdw.MaxLines = 16
    tdw.MaxColumns = 5
    tdw.DataLines = {}
    tdw.Lines = {}
	tdw:SetHeight(455)
    tdw:SetWidth(850)
    tdw:SetAnchor(TOPLEFT,Scene_KC_Menu_Deaths,TOPLEFT,25,25)
    tdw:SetDrawLayer(DL_BACKGROUND)
    tdw:SetMouseEnabled(true)
    tdw:SetHandler("OnMouseWheel",function(self,delta)
    	if deaths_table == nil then return end
    	local tlw = deaths_table
    	local value = tlw.DataOffset - delta
        if value < 0 then 
            value = 0
        elseif value > KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines then 
            value = KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines 
        end
        tlw.DataOffset = value
        tlw.Slider:SetValue(tlw.DataOffset)
        KC_G.UpdateKillsTable()
    end)
    tdw:SetHandler("OnShow",function(self)

        tdw.DataLines = {}

        for k,v in pairs(KC_G.savedVars.killedBy) do
        	table.insert(tdw.DataLines, v)
        end
        KC_G.UpdateDeathsTable()
        --d("showing")


    end)
 
    tdw.BackGround = WINDOW_MANAGER:CreateControl(nil,tdw,CT_BACKDROP)
    tdw.BackGround:SetAnchorFill(tdw)
    tdw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tdw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tdw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  

    local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
    tdw.Slider = WINDOW_MANAGER:CreateControl("KillCounter_THIS_FUCKING_ASSHOLE_SCROLLBAR_PART_2_BITCH",tdw,CT_SLIDER)
    
    
    tdw.Slider:SetDimensions(13,tdw:GetHeight())
    tdw.Slider:SetMouseEnabled(true)
    tdw.Slider:SetThumbTexture(tex,tex,tex,13,35,0,0,1,1)
    tdw.Slider:SetValue(0)
    tdw.Slider:SetValueStep(1)
    tdw.Slider:SetAnchorFill()
 	tdw.Slider:SetMinMax(0,50)
 	tdw.Slider:ClearAnchors()
 	tdw.Slider:SetAnchor(TOPLEFT,tdw,TOPLEFT,tdw:GetWidth() - 15,5)

        -- When we change the slider's value we need to change the data offset and redraw the display
    tdw.Slider:SetHandler("OnValueChanged",function(self,value,eventReason)
        --tdw.DataOffset = math.min(value,#tdw.DataLines - tdw.MaxLines)
        --d("changing things you bitch")
        if deaths_table == nil then return end
        local tlw = deaths_table
        tlw.DataOffset = math.min(value,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
        KC_G.UpdateDeathsTable()
    end)
 


    for i=1,tdw.MaxLines do
        tdw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Deaths_Table_Line_" .. i, tdw, "KillCounter_Kills_Table_Line")
        tdw.Lines[i]:SetDimensions(tdw:GetWidth()-10,25)
        if i == 1 then
            tdw.Lines[i]:SetAnchor(TOPLEFT,tdw,TOPLEFT,0,5)
        else
            tdw.Lines[i]:SetAnchor(TOPLEFT,tdw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tdw.Lines[i].Columns = {}
 		for j=1,tdw.MaxColumns do 
	        tdw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i],CT_LABEL)
	        local oy = 0
	        if i == 1 then
	        	tdw.Lines[i].Columns[j]:SetFont("ZoFontGameBold")
	        else
	        	tdw.Lines[i].Columns[j]:SetFont("ZoFontGameSmall")
	        	--cell if second cell, set offset y to 3
	        	 oy = 3
	        	
	        end
	        tdw.Lines[i].Columns[j]:SetDimensions(tdw.Lines[i]:GetWidth()/3,25)
	        if i==1 then
		        local sw, wh = tdw.Lines[i].Columns[j]:GetTextDimensions()
	    		--d(wh)
	    		tdw.Lines[i].Columns[j]:SetDimensions(sw,25)
		        if j == 1 then
	            	 tdw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tdw.Lines[i],TOPLEFT,18,0)
	        	else
	        		local sw, wh = tdw.Lines[i].Columns[j-1]:GetTextDimensions()
	        		local ox = (tdw.Lines[i]:GetWidth()/tdw.MaxColumns) - sw
	        		--d(tdw.Lines[i].Columns[j]:GetWidth(), (tdw.Lines[i]:GetWidth()/tdw.MaxColumns))
	            	 tdw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j-1],TOPRIGHT, ox,oy)
	        	end
	        else
	        	--.d("happen")
	        	--center that bitch
	        	local w, h = tdw.Lines[1].Columns[j]:GetTextDimensions()

	        	local offx = 0
	        	if j ~= 1 and i == 2 and j ~= 6 and j ~= 7 then
	        		offx = (w/2) - tdw.Lines[i].Columns[j]:GetTextDimensions()
	        	end



	        	tdw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tdw.Lines[i-1].Columns[j],BOTTOMLEFT,offx,oy)
	        end


        	--tdw.Lines[i].Columns[j]:SetText("Column")
        	if i == 1 then
        		if j == 1 then 
        			tdw.Lines[i].Columns[j]:SetText("Player Name")
        			tdw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].SortButton:SetWidth(tdw.Lines[i].Columns[j]:GetWidth())
        			tdw.Lines[i].Columns[j].SortButton:SetHeight(tdw.Lines[i].Columns[j]:GetHeight())
        			tdw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].SortButton.Desc = false
        			tdw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tdw.Lines[i].Columns[j].SortButton.Desc = not tdw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tdw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].Name < t[a].Name end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].Name > t[a].Name end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							deaths_table.DataLines = dl
							KC_G.UpdateDeathsTable()
							--d(#dl)

	    			end)
	    			tdw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 2 then 
        			tdw.Lines[i].Columns[j]:SetText("Kills On You")
        			tdw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].SortButton:SetWidth(tdw.Lines[i].Columns[j]:GetWidth())
        			tdw.Lines[i].Columns[j].SortButton:SetHeight(tdw.Lines[i].Columns[j]:GetHeight())
        			tdw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].SortButton.Desc = false
        			tdw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tdw.Lines[i].Columns[j].SortButton.Desc = not tdw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tdw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].KilledBy < t[a].KilledBy end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].KilledBy> t[a].KilledBy end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							deaths_table.DataLines = dl
							KC_G.UpdateDeathsTable()
							--d(#dl)

	    			end)
	    			tdw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 3 then 
        			tdw.Lines[i].Columns[j]:SetText("Class")
        			tdw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].SortButton:SetWidth(tdw.Lines[i].Columns[j]:GetWidth())
        			tdw.Lines[i].Columns[j].SortButton:SetHeight(tdw.Lines[i].Columns[j]:GetHeight())
        			tdw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].SortButton.Desc = false
        			tdw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tdw.Lines[i].Columns[j].SortButton.Desc = not tdw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tdw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].Class< t[a].Class end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) return t[b].Class > t[a].Class end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							deaths_table.DataLines = dl
							KC_G.UpdateDeathsTable()
							--d(#dl)

	    			end)
	    			tdw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 4 then 
        			tdw.Lines[i].Columns[j]:SetText("Alliance")
        			tdw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].SortButton:SetWidth(tdw.Lines[i].Columns[j]:GetWidth())
        			tdw.Lines[i].Columns[j].SortButton:SetHeight(tdw.Lines[i].Columns[j]:GetHeight())
        			tdw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].SortButton.Desc = false
        			tdw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tdw.Lines[i].Columns[j].SortButton.Desc = not tdw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tdw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) 
		        						local n1 = tonumber(t[b].Alliance)
		        						if n1 == nil then n1 = 0 end
		        						local n2 = tonumber(t[a].Alliance)
		        						if n2 == nil then n2 = 0 end

		        						return n1 < n2 
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) 
		        						local n1 = tonumber(t[b].Alliance)
		        						if n1 == nil then n1 = 0 end
		        						local n2 = tonumber(t[a].Alliance)
		        						if n2 == nil then n2 = 0 end

		        						return n1 > n2 
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							deaths_table.DataLines = dl
							KC_G.UpdateDeathsTable()
							--d(#dl)

	    			end)
	    			tdw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 5 then 
        			tdw.Lines[i].Columns[j]:SetText("Level")
        			tdw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].SortButton:SetWidth(tdw.Lines[i].Columns[j]:GetWidth())
        			tdw.Lines[i].Columns[j].SortButton:SetHeight(tdw.Lines[i].Columns[j]:GetHeight())
        			tdw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].SortButton.Desc = false
        			tdw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tdw.Lines[i].Columns[j].SortButton.Desc = not tdw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tdw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) 
	        							if b == nil then return true end
		        						local al = tonumber(t[a].Level)
		        						local avl = tonumber(t[a].vLevel)
		        						--d(b)
		        						local bl = tonumber(t[b].Level)
		        						local bvl = tonumber(t[b].vLevel)
		        						if al == 50 and al == bl then
		        							return avl > bvl 
		        						end
		        						if al == 50 and bl ~= 50 then return true end
		        						if bl == 50 and al ~= 50 then return false end

		        						return al > bl
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(deaths_table.DataLines, function(t,a,b) 
		        						local al = tonumber(t[a].Level)
		        						local avl = tonumber(t[a].vLevel)

		        						local bl = tonumber(t[b].Level)
		        						local bvl = tonumber(t[b].vLevel)
		        						if al == 50 and al == bl then
		        							return avl < bvl 
		        						end
		        						if al == 50 and bl ~= 50 then return false end
		        						if bl == 50 and al ~= 50 then return true end

		        						return al < bl
	        						end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							deaths_table.DataLines = dl
							KC_G.UpdateDeathsTable()
							--d(#dl)

	    			end)
	    			tdw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			--
    		else
    			if j==1 then
    				tdw.Lines[i].Columns[j].PlayerButton = WINDOW_MANAGER:CreateControl(nil,tdw.Lines[i].Columns[j],CT_BUTTON)

        			tdw.Lines[i].Columns[j].PlayerButton:SetWidth(tdw.Lines[i]:GetWidth()-22)
        			tdw.Lines[i].Columns[j].PlayerButton:SetHeight(tdw.Lines[i]:GetHeight())
        			tdw.Lines[i].Columns[j].PlayerButton:SetAnchor(TOPLEFT,tdw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tdw.Lines[i].Columns[j].PlayerButton:SetHandler("OnClicked",function(self,delta)
        					--d("bitches")
        					KC_G.ShowPlayer(tdw.Lines[i].Columns[j]:GetText())

	    			end)
        		end
    		end

	    		
	    			
	    			

	        tdw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    --d(KC_G.savedVars.killed)
	--tdw.DataLines = KC_G.savedVars.killed
	--d(tdw.DataLines)
	for k,v in pairs(KC_G.savedVars.killedBy) do
		table.insert(tdw.DataLines, v)
	end

	--tdw:SetHidden(true)
    deaths_table = tdw


    KC_G.UpdateDeathsTable()

    --END DEATHS TABLE

    --START Stats Breakdown
	local tbw = Scene_KC_Menu_Breakdown_Breakdown_Table
	--tlw.Logo = KillCounter_Stats_Window_Kills_Logo
	tbw:ClearAnchors()
	tbw.DataOffset = 0
    tbw.MaxLines = 16
    tbw.MaxColumns = 2
    tbw.DataLines = {}
    tbw.Lines = {}
	tbw:SetHeight(485)
    tbw:SetWidth(550)
    tbw:SetAnchor(TOPLEFT,Scene_KC_Menu_Breakdown,TOPLEFT,35,25)
    tbw:SetDrawLayer(DL_BACKGROUND)
    tbw:SetMouseEnabled(true)
    tbw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tbw:SetHandler("OnShow",function(self)

        tbw.DataLines = {}
        for i=1,4 do
            tbw.DataLines[i] = string.format("kills and stuff %d", i)
        end

    end)
 
    tbw.BackGround = WINDOW_MANAGER:CreateControl(nil,tbw,CT_BACKDROP)
    tbw.BackGround:SetAnchorFill(tbw)
    tbw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tbw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tbw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    for i=1,tbw.MaxLines do
        tbw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Line_" .. i, tbw, "KillCounter_Overview_Line")
        tbw.Lines[i]:SetDimensions(tbw:GetWidth()-10,27)
        if i == 1 then
            tbw.Lines[i]:SetAnchor(TOPLEFT,tbw,TOPLEFT,5,5)
        else
            tbw.Lines[i]:SetAnchor(TOPLEFT,tbw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tbw.Lines[i].Columns = {}
 		for j=1,tbw.MaxColumns do 
	        tbw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tbw.Lines[i],CT_LABEL)
	        tbw.Lines[i].Columns[j]:SetFont("ZoFontGame")
	        tbw.Lines[i].Columns[j]:SetDimensions(tbw.Lines[i]:GetWidth()/2,30)
	        if j == 1 then
            	 tbw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tbw.Lines[i],TOPLEFT,18,0)
        	else
            	 tbw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tbw.Lines[i].Columns[j-1],TOPLEFT, (tbw.Lines[i]:GetWidth()/2),0)
        	end


        	if i==1 then
        		if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Killed Player") end
        		if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
        	else
        		if i==2 then
        			if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Killing Blowed Player") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
        		if i==3 then
        			if j==1 then tbw.Lines[i].Columns[j]:SetText("Total Players Killed") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==4 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Killed Alliance") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==5 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Killed Class") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==6 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText(" ") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==7 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Biggest Killer") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==8 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Total Killers") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==9 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Dangerous Class") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==10 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Most Dangerous Alliance") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==11 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Aldermi Dominion Kills") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==12 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Daggerfall Covenant Kills") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==13 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Ebonheart Pact Kills") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==14 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Killing Blow Ratio") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==15 then
		   			if j==1 then tbw.Lines[i].Columns[j]:SetText("Killing Blow Level") end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		   		if i==16 then
		   			if j==1 then 
		   				tbw.Lines[i].Columns[j]:SetText("Top Killing Blow Spell")
		   				tbw.Lines[i].Columns[j].SpellsTableButton = WINDOW_MANAGER:CreateControl(nil,tbw.Lines[i].Columns[j],CT_BUTTON)
			   			tbw.Lines[i].Columns[j].SpellsTableButton:SetWidth(tbw.Lines[i].Columns[j]:GetWidth())
	        			tbw.Lines[i].Columns[j].SpellsTableButton:SetHeight(tbw.Lines[i].Columns[j]:GetHeight())
	        			tbw.Lines[i].Columns[j].SpellsTableButton:SetAnchor(TOPLEFT,tbw.Lines[i].Columns[j],TOPLEFT,0,0)
	        			tbw.Lines[i].Columns[j].SpellsTableButton:SetHandler("OnClicked",function(self,delta)
		   					--KC_G.Stats_Window_Switch("KBSpells")
		   					LMM:Update(MENU_CATEGORY_KILLCOUNTER, "KillCounterSpells")
		   				end)

		   			end
			        if j==2 then tbw.Lines[i].Columns[j]:SetText(" ") end
		   		end
		    end
	        tbw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end

    breakdown_table = tbw
    --breakdown_table:SetHidden(true)


    ---stats breakdown graphs
    local ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp = KC_G.Percentages()
    --START Stats Breakdown
	local tbgw = Scene_KC_Menu_Breakdown_Breakdown_Graph
	--tlw.Logo = KillCounter_Stats_Window_Kills_Logo
	tbgw:ClearAnchors()
	tbgw.DataOffset = 0
    tbgw.MaxLines = 13
    tbgw.DataLines = {}
    tbgw.Lines = {}
	tbgw:SetHeight(138)
    tbgw:SetWidth(275)
    tbgw:SetAnchor(TOPLEFT,Scene_KC_Menu_Breakdown,TOPLEFT,600,25)
    tbgw:SetDrawLayer(DL_BACKGROUND)
    tbgw:SetMouseEnabled(true)
    tbgw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tbgw:SetHandler("OnShow",function(self)

        tbgw.DataLines = {}
        for i=1,4 do
            tbgw.DataLines[i] = string.format("kills and stuff %d", i)
        end

    end)
 
    tbgw.BackGround = WINDOW_MANAGER:CreateControl(nil,tbgw,CT_BACKDROP)
    tbgw.BackGround:SetAnchorFill(tbgw)
    tbgw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tbgw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tbgw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    --Templar Percentage
    tbgw.Templar = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Graph_Templar", tbgw, "KillCounter_Graph_Line_Templar")
    tbgw.Templar:SetAnchor(TOPLEFT,tbgw,TOPLEFT,5,5)

    tbgw.Templar.Label = WINDOW_MANAGER:CreateControl(nil,tbgw.Templar,CT_LABEL)
    tbgw.Templar.Label:SetFont("ZoFontGame")
    tbgw.Templar.Label:SetDimensions(tbgw:GetWidth(),30)
    tbgw.Templar.Label:SetAnchor(TOPLEFT,tbgw.Templar,TOPLEFT,0,2)
    tbgw.Templar.Label:SetText("|CabababTemplars: ".. KC_Fn.round(tempp*100, 2).."% " .. templar .. " Kills")

    tbgw.Templar:SetDimensions(((tbgw:GetWidth()*.75)-10) * tempp,30)

    --Dragon Knight Percentage
    tbgw.DragonKnight = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Graph_DragonKnight", tbgw, "KillCounter_Graph_Line_DragonKnight")
    tbgw.DragonKnight:SetAnchor(TOPLEFT,tbgw.Templar,BOTTOMLEFT,0,3)

    tbgw.DragonKnight.Label = WINDOW_MANAGER:CreateControl(nil,tbgw.DragonKnight,CT_LABEL)
    tbgw.DragonKnight.Label:SetFont("ZoFontGame")
    tbgw.DragonKnight.Label:SetDimensions(tbgw:GetWidth(),30)
    tbgw.DragonKnight.Label:SetAnchor(TOPLEFT,tbgw.DragonKnight,TOPLEFT,0,2)
    tbgw.DragonKnight.Label:SetText("|CabababDragon Knights: ".. KC_Fn.round(dkp*100, 2).."% " .. dragonknight .. " Kills")

    tbgw.DragonKnight:SetDimensions(((tbgw:GetWidth()*.75)-10) * dkp,30)

    --NightBlade Percentage
    tbgw.NightBlade = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Graph_NightBlade", tbgw, "KillCounter_Graph_Line_NightBlade")
    tbgw.NightBlade:SetAnchor(TOPLEFT,tbgw.DragonKnight,BOTTOMLEFT,0,3)

    tbgw.NightBlade.Label = WINDOW_MANAGER:CreateControl(nil,tbgw.NightBlade,CT_LABEL)
    tbgw.NightBlade.Label:SetFont("ZoFontGame")
    tbgw.NightBlade.Label:SetDimensions(tbgw:GetWidth(),30)
    tbgw.NightBlade.Label:SetAnchor(TOPLEFT,tbgw.NightBlade,TOPLEFT,0,2)
    tbgw.NightBlade.Label:SetText("|CabababNightBlades: ".. KC_Fn.round(nbp*100, 2).."% " .. nightblade .. " Kills")

    tbgw.NightBlade:SetDimensions(((tbgw:GetWidth()*.75)-10) * nbp,30)

    --Sorceror Percentage
    tbgw.Sorceror = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Graph_Sorceror", tbgw, "KillCounter_Graph_Line_Sorceror")
    tbgw.Sorceror:SetAnchor(TOPLEFT,tbgw.NightBlade,BOTTOMLEFT,0,3)

    tbgw.Sorceror.Label = WINDOW_MANAGER:CreateControl(nil,tbgw.Sorceror,CT_LABEL)
    tbgw.Sorceror.Label:SetFont("ZoFontGame")
    tbgw.Sorceror.Label:SetDimensions(tbgw:GetWidth(),30)
    tbgw.Sorceror.Label:SetAnchor(TOPLEFT,tbgw.Sorceror,TOPLEFT,0,2)
    tbgw.Sorceror.Label:SetText("|CabababSorcerors: ".. KC_Fn.round(sorcp*100, 2).."% " .. sorceror .. " Kills")

    tbgw.Sorceror:SetDimensions(((tbgw:GetWidth()*.75)-10) * sorcp,30)
   -- tbgw:SetHidden(true)

    breakdown_graph = tbgw



    local ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp = KC_G.DeathPercentages()
    --START Stats Breakdown Death graph
	local tbdgw = Scene_KC_Menu_Breakdown_Breakdown_Death_Graph
	--tlw.Logo = KillCounter_Stats_Window_Kills_Logo
	tbdgw:ClearAnchors()
	tbdgw.DataOffset = 0
    tbdgw.MaxLines = 13
    tbdgw.DataLines = {}
    tbdgw.Lines = {}
	tbdgw:SetHeight(138)
    tbdgw:SetWidth(275)
    tbdgw:SetAnchor(TOPLEFT,Scene_KC_Menu_Breakdown,TOPLEFT,600,310)
    tbdgw:SetDrawLayer(DL_BACKGROUND)
    tbdgw:SetMouseEnabled(true)
    tbdgw:SetHandler("OnMouseWheel",function(self,delta)

    end)
    tbdgw:SetHandler("OnShow",function(self)

        tbdgw.DataLines = {}
        for i=1,4 do
            tbdgw.DataLines[i] = string.format("kills and stuff %d", i)
        end

    end)
 
    tbdgw.BackGround = WINDOW_MANAGER:CreateControl(nil,tbdgw,CT_BACKDROP)
    tbdgw.BackGround:SetAnchorFill(tbdgw)
    tbdgw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tbdgw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tbdgw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  
 


    --Templar Percentage
    tbdgw.Templar = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Death_Graph_Templar", tbdgw, "KillCounter_Graph_Line_Templar")
    tbdgw.Templar:SetAnchor(TOPLEFT,tbdgw,TOPLEFT,5,5)

    tbdgw.Templar.Label = WINDOW_MANAGER:CreateControl(nil,tbdgw.Templar,CT_LABEL)
    tbdgw.Templar.Label:SetFont("ZoFontGame")
    tbdgw.Templar.Label:SetDimensions(tbdgw:GetWidth(),30)
    tbdgw.Templar.Label:SetAnchor(TOPLEFT,tbdgw.Templar,TOPLEFT,0,2)
    tbdgw.Templar.Label:SetText("|CabababTemplars: ".. KC_Fn.round(tempp*100, 2).."% " .. templar .. " Kills")

    tbdgw.Templar:SetDimensions(((tbdgw:GetWidth()*.75)-10) * tempp,30)

    --Dragon Knight Percentage
    tbdgw.DragonKnight = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Death_Graph_DragonKnight", tbdgw, "KillCounter_Graph_Line_DragonKnight")
    tbdgw.DragonKnight:SetAnchor(TOPLEFT,tbdgw.Templar,BOTTOMLEFT,0,3)

    tbdgw.DragonKnight.Label = WINDOW_MANAGER:CreateControl(nil,tbdgw.DragonKnight,CT_LABEL)
    tbdgw.DragonKnight.Label:SetFont("ZoFontGame")
    tbdgw.DragonKnight.Label:SetDimensions(tbdgw:GetWidth(),30)
    tbdgw.DragonKnight.Label:SetAnchor(TOPLEFT,tbdgw.DragonKnight,TOPLEFT,0,2)
    tbdgw.DragonKnight.Label:SetText("|CabababDragon Knights: ".. KC_Fn.round(dkp*100, 2).."% " .. dragonknight .. " Kills")

    tbdgw.DragonKnight:SetDimensions(((tbdgw:GetWidth()*.75)-10) * dkp,30)

    --NightBlade Percentage
    tbdgw.NightBlade = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Death_Graph_NightBlade", tbdgw, "KillCounter_Graph_Line_NightBlade")
    tbdgw.NightBlade:SetAnchor(TOPLEFT,tbdgw.DragonKnight,BOTTOMLEFT,0,3)

    tbdgw.NightBlade.Label = WINDOW_MANAGER:CreateControl(nil,tbdgw.NightBlade,CT_LABEL)
    tbdgw.NightBlade.Label:SetFont("ZoFontGame")
    tbdgw.NightBlade.Label:SetDimensions(tbdgw:GetWidth(),30)
    tbdgw.NightBlade.Label:SetAnchor(TOPLEFT,tbdgw.NightBlade,TOPLEFT,0,2)
    tbdgw.NightBlade.Label:SetText("|CabababNightBlades: ".. KC_Fn.round(nbp*100, 2).."% " .. nightblade .. " Kills")

    tbdgw.NightBlade:SetDimensions(((tbdgw:GetWidth()*.75)-10) * nbp,30)

    --Sorceror Percentage
    tbdgw.Sorceror = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Breakdown_Death_Graph_Sorceror", tbdgw, "KillCounter_Graph_Line_Sorceror")
    tbdgw.Sorceror:SetAnchor(TOPLEFT,tbdgw.NightBlade,BOTTOMLEFT,0,3)

    tbdgw.Sorceror.Label = WINDOW_MANAGER:CreateControl(nil,tbdgw.Sorceror,CT_LABEL)
    tbdgw.Sorceror.Label:SetFont("ZoFontGame")
    tbdgw.Sorceror.Label:SetDimensions(tbdgw:GetWidth(),30)
    tbdgw.Sorceror.Label:SetAnchor(TOPLEFT,tbdgw.Sorceror,TOPLEFT,0,2)
    tbdgw.Sorceror.Label:SetText("|CabababSorcerors: ".. KC_Fn.round(sorcp*100, 2).."% " .. sorceror .. " Kills")

    tbdgw.Sorceror:SetDimensions(((tbdgw:GetWidth()*.75)-10) * sorcp,30)
    --tbdgw:SetHidden(true)



    breakdown_death_graph = tbdgw

    --START Killing Blows Table
    
    local tkbsw = Scene_KC_Menu_Spells_Killing_Blows_Table
	tkbsw:ClearAnchors()
	tkbsw.DataOffset = 0
    tkbsw.MaxLines = 10
    tkbsw.MaxColumns = 2
    tkbsw.DataLines = {}
    tkbsw.Lines = {}
	tkbsw:SetHeight(280)
    tkbsw:SetWidth(440)
    tkbsw:SetAnchor(TOPLEFT,Scene_KC_Menu_Spells,TOPLEFT,75,25)
    tkbsw:SetDrawLayer(DL_BACKGROUND)
    tkbsw:SetMouseEnabled(true)
    tkbsw:SetHandler("OnMouseWheel",function(self,delta)
    	if killing_blow_spells_table == nil then return end
    	--d("mouse scroll")
    	local tlw = killing_blow_spells_table
    	local value = tlw.DataOffset - delta
        if value < 0 then 
            value = 0
        elseif value > KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines then 
            value = KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines 
        end
        tlw.DataOffset = value
        tlw.Slider:SetValue(tlw.DataOffset)
        KC_G.updateKillingSpellTable()
    end)
    tkbsw:SetHandler("OnShow",function(self)

        tkbsw.DataLines = {}
        --d("showing")
        for k,v in pairs(KC_G.savedVars.kbSpells) do
        	--d(k,v)
        	local line = {SpellName = k, Kills = v}
        	table.insert(tkbsw.DataLines, line)
        end
        KC_G.updateKillingSpellTable()
        --d("showing")


    end)
 
    tkbsw.BackGround = WINDOW_MANAGER:CreateControl(nil,tkbsw,CT_BACKDROP)
    tkbsw.BackGround:SetAnchorFill(tkbsw)
    tkbsw.BackGround:SetCenterColor(0.0, 0.0, 0.0, 0.5)   
    tkbsw.BackGround:SetEdgeColor(1, 1, 1, 0.5)
    tkbsw.BackGround:SetEdgeTexture(nil, 2, 2, 2.0, 2.0)  

    local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
    tkbsw.Slider = WINDOW_MANAGER:CreateControl("KillCounter_THIS_FUCKING_ASSHOLE_SCROLLBAR_PART_3_BITCH",tkbsw,CT_SLIDER)
    
    
    tkbsw.Slider:SetDimensions(13,tkbsw:GetHeight())
    tkbsw.Slider:SetMouseEnabled(true)
    tkbsw.Slider:SetThumbTexture(tex,tex,tex,13,35,0,0,1,1)
    tkbsw.Slider:SetValue(0)
    tkbsw.Slider:SetValueStep(1)
    tkbsw.Slider:SetAnchorFill()
 	tkbsw.Slider:SetMinMax(0,50)
 	tkbsw.Slider:ClearAnchors()
 	tkbsw.Slider:SetAnchor(TOPLEFT,tkbsw,TOPLEFT,tkbsw:GetWidth() - 15,5)

        -- When we change the slider's value we need to change the data offset and redraw the display
    tkbsw.Slider:SetHandler("OnValueChanged",function(self,value,eventReason)
        --tdw.DataOffset = math.min(value,#tdw.DataLines - tdw.MaxLines)
        --d("changing things you bitch")
        if killing_blow_spells_table == nil then return end
        local tlw = killing_blow_spells_table
        tlw.DataOffset = math.min(value,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
        KC_G.updateKillingSpellTable()
    end)
 


    for i=1,tkbsw.MaxLines do
        tkbsw.Lines[i] = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Spells_Table_Line_" .. i, tkbsw, "KillCounter_Kills_Table_Line")
        tkbsw.Lines[i]:SetDimensions(tkbsw:GetWidth()-10,25)
        if i == 1 then
            tkbsw.Lines[i]:SetAnchor(TOPLEFT,tkbsw,TOPLEFT,0,5)
        else
            tkbsw.Lines[i]:SetAnchor(TOPLEFT,tkbsw.Lines[i-1],BOTTOMLEFT,0,3)
        end

        local index = i
        tkbsw.Lines[i].Columns = {}
 		for j=1,tkbsw.MaxColumns do 
	        tkbsw.Lines[i].Columns[j] = WINDOW_MANAGER:CreateControl(nil,tkbsw.Lines[i],CT_LABEL)
	        local oy = 0
	        if i == 1 then
	        	tkbsw.Lines[i].Columns[j]:SetFont("ZoFontGameBold")
	        else
	        	tkbsw.Lines[i].Columns[j]:SetFont("ZoFontGameSmall")
	        	--cell if second cell, set offset y to 3
	        	 oy = 3
	        	
	        end
	        tkbsw.Lines[i].Columns[j]:SetDimensions(tkbsw.Lines[i]:GetWidth()/3,25)
	        if i==1 then
		        local sw, wh = tkbsw.Lines[i].Columns[j]:GetTextDimensions()
	    		--d(wh)
	    		tkbsw.Lines[i].Columns[j]:SetDimensions(sw,25)
		        if j == 1 then
	            	 tkbsw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkbsw.Lines[i],TOPLEFT,18,0)
	        	else
	        		local sw, wh = tkbsw.Lines[i].Columns[j-1]:GetTextDimensions()
	        		local ox = (tkbsw.Lines[i]:GetWidth()/tkbsw.MaxColumns) - sw
	        		--d(tdw.Lines[i].Columns[j]:GetWidth(), (tdw.Lines[i]:GetWidth()/tdw.MaxColumns))
	            	 tkbsw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkbsw.Lines[i].Columns[j-1],TOPRIGHT, ox,oy)
	        	end
	        else
	        	--.d("happen")
	        	--center that bitch
	        	local w, h = tkbsw.Lines[1].Columns[j]:GetTextDimensions()

	        	local offx = 0
	        	if j ~= 1 and i == 2 and j ~= 6 and j ~= 7 then
	        		offx = (w/2) - tkbsw.Lines[i].Columns[j]:GetTextDimensions()
	        	end



	        	tkbsw.Lines[i].Columns[j]:SetAnchor(TOPLEFT,tkbsw.Lines[i-1].Columns[j],BOTTOMLEFT,offx,oy)
	        end


        	--tdw.Lines[i].Columns[j]:SetText("Column")
        	if i == 1 then
        		if j == 1 then 
        			tkbsw.Lines[i].Columns[j]:SetText("Spell Name")
        			tkbsw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkbsw.Lines[i].Columns[j],CT_BUTTON)

        			tkbsw.Lines[i].Columns[j].SortButton:SetWidth(tkbsw.Lines[i].Columns[j]:GetWidth())
        			tkbsw.Lines[i].Columns[j].SortButton:SetHeight(tkbsw.Lines[i].Columns[j]:GetHeight())
        			tkbsw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkbsw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkbsw.Lines[i].Columns[j].SortButton.Desc = false
        			tkbsw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
        					tkbsw.Lines[i].Columns[j].SortButton.Desc = not tkbsw.Lines[i].Columns[j].SortButton.Desc
        					local dl = {}
        					if tkbsw.Lines[i].Columns[j].SortButton.Desc then
	        					for k,v in KC_Fn.spairs(killing_blow_spells_table.DataLines, function(t,a,b) return t[b].SpellName < t[a].SpellName end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							else
	        					for k,v in KC_Fn.spairs(killing_blow_spells_table.DataLines, function(t,a,b) return t[b].SpellName > t[a].SpellName end) do
								    --print(k,v)
								    table.insert(dl, v)
								end
							end
							killing_blow_spells_table.DataLines = dl
							KC_G.updateKillingSpellTable()
							--d(#dl)

	    			end)
	    			tkbsw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    			if j == 2 then 
        			tkbsw.Lines[i].Columns[j]:SetText("Killing Blows")
        			tkbsw.Lines[i].Columns[j].SortButton = WINDOW_MANAGER:CreateControl(nil,tkbsw.Lines[i].Columns[j],CT_BUTTON)
        			
        			tkbsw.Lines[i].Columns[j].SortButton:SetWidth(tkbsw.Lines[i].Columns[j]:GetWidth())
        			tkbsw.Lines[i].Columns[j].SortButton:SetHeight(tkbsw.Lines[i].Columns[j]:GetHeight())
        			tkbsw.Lines[i].Columns[j].SortButton:SetAnchor(TOPLEFT,tkbsw.Lines[i].Columns[j],TOPLEFT,0,0)
        			tkbsw.Lines[i].Columns[j].SortButton.Desc = false

        			tkbsw.Lines[i].Columns[j].SortButton:SetHandler("OnClicked",function(self,delta)
    					--wawd("sort")
    					tkbsw.Lines[i].Columns[j].SortButton.Desc = not tkbsw.Lines[i].Columns[j].SortButton.Desc
    					local dl = {}
    					
    					if tkbsw.Lines[i].Columns[j].SortButton.Desc then
        					for k,v in KC_Fn.spairs(killing_blow_spells_table.DataLines, function(t,a,b) return t[b].Kills < t[a].Kills end) do
							    --print(k,v)
							    table.insert(dl, v)
							end
						else
        					for k,v in KC_Fn.spairs(killing_blow_spells_table.DataLines, function(t,a,b) return t[b].Kills > t[a].Kills end) do
							    --print(k,v)
							    table.insert(dl, v)
							end
						end
						killing_blow_spells_table.DataLines = dl
						KC_G.updateKillingSpellTable()
						--d(#dl)

	    			end)
	    			tkbsw.Lines[i].Columns[j].SortButton:SetHidden(false)
    			end
    		end


	    		
	    			
	    			

	        tkbsw.Lines[i].Columns[j]:SetHidden(false)
	    end
    end


    --d(KC_G.savedVars.killed)
	--tdw.DataLines = KC_G.savedVars.killed
	--d(tdw.DataLines)
	tkbsw.DataLines = {}
	for k,v in pairs(KC_G.savedVars.kbSpells) do
    	--d(k,v)
    	local line = {SpellName = k, Kills = v}
        table.insert(tkbsw.DataLines, line)
    end

	--tkbsw:SetHidden(true)
    killing_blow_spells_table = tkbsw
    --[[]]

    KC_G.updateKillingSpellTable()

    --END Killing Blows Table]]
end

function KC_G.Percentages()
	local templar = 0
	local nightblade = 0
	local dragonknight = 0
	local sorceror = 0

	local list = KC_G.savedVars.killed

	local ad = 0
	local dc = 0
	local ep = 0
	for ii,v in pairs(list) do

		if v.Class == "Templar" then 
			templar = templar + v.Kills
		end
		if v.Class == "Dragonknight" then 
			dragonknight = dragonknight + v.Kills
		end
		if v.Class == "Sorcerer" then 
			sorceror = sorceror + v.Kills
		end
		if v.Class == "Nightblade" then 
			nightblade = nightblade + v.Kills
		end

		if v.Alliance == ALLIANCE_EBONHEART_PACT then 
			ep = ep + v.Kills
		end
		if v.Alliance == ALLIANCE_DAGGERFALL_COVENANT then 
			dc = dc + v.Kills
		end
		if v.Alliance == ALLIANCE_ALDMERI_DOMINION then 
			ad = ad + v.Kills
		end
	end
	local adp = 0
	local dcp = 0
	local epp = 0

	local tempp = 0
	local dkp = 0
	local nbp = 0
	local sorcp = 0

	local totalKills = ad + dc + ep
	if totalKills > 0 then
		adp = ad/ totalKills
		dcp = dc/totalKills
		epp = ep/totalKills

		tempp = templar/totalKills
		dkp = dragonknight/totalKills
		nbp = nightblade/totalKills
		sorcp = sorceror/totalKills
	end


	

	return ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp
end

function KC_G.DeathPercentages()
	local templar = 0
	local nightblade = 0
	local dragonknight = 0
	local sorceror = 0

	local list = KC_G.savedVars.killedBy

	local ad = 0
	local dc = 0
	local ep = 0
	for ii,v in pairs(list) do

		if v.Class == "Templar" then 
			templar = templar + v.KilledBy
		end
		if v.Class == "Dragonknight" then 
			dragonknight = dragonknight + v.KilledBy
		end
		if v.Class == "Sorcerer" then 
			sorceror = sorceror + v.KilledBy
		end
		if v.Class == "Nightblade" then 
			nightblade = nightblade + v.KilledBy
		end

		if v.Alliance == ALLIANCE_EBONHEART_PACT then 
			ep = ep + v.KilledBy
		end
		if v.Alliance == ALLIANCE_DAGGERFALL_COVENANT then 
			dc = dc + v.KilledBy
		end
		if v.Alliance == ALLIANCE_ALDMERI_DOMINION then 
			ad = ad + v.KilledBy
		end
	end

	local adp = 0
	local dcp = 0
	local epp = 0

	local tempp = 0
	local dkp = 0
	local nbp = 0
	local sorcp = 0

	local totalKills = ad + dc + ep
	if totalKills > 0 then
		adp = ad/ totalKills
		dcp = dc/totalKills
		epp = ep/totalKills

		tempp = templar/totalKills
		dkp = dragonknight/totalKills
		nbp = nightblade/totalKills
		sorcp = sorceror/totalKills
	end

	return ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp
end


function KC_G.updateKillingSpellTable()
	if killing_blow_spells_table == nil then return end
	--d("stuff")
	local tlw = killing_blow_spells_table
	--tlw.DataLines = {}


	if #tlw.DataLines < tlw.MaxLines then
		tlw.Slider:SetHidden(true)
		--d("hiding slider")
	else
		tlw.Slider:SetHidden(false)
		--d("showing slider")
	end

	tlw.DataOffset = tlw.DataOffset or 0
    if tlw.DataOffset < 0 then tlw.DataOffset = 0 end
    --d(tlw.DataLines)
    if KC_Fn.tablelength(tlw.DataLines) == 0 then return end

    tlw.Slider:SetMinMax(0,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
    --d(tlw.DataOffset)
    --for i=1,tlw.DataOffset-1 do
    	--d("nexting")
    	--pk = next(tlw.DataLines, pk)

   -- end
   local pk = tlw.DataOffset
   --d(#tlw.DataLines, pk)
    for i = 2,tlw.MaxLines do
    	if pk + (i-1) > #tlw.DataLines then break end
        local curLine = tlw.Lines[i]
        local curData = tlw.DataLines[pk + i -1]
        --d(i)
        --d(curData)
        curLine.Columns[1]:SetText(curData.SpellName)
        curLine.Columns[2]:SetText(curData.Kills)


    end 
end




function KC_G.UpdateKillsTable(...)
	if kills_table == nil then return end
    local tlw = kills_table
    tlw.DataOffset = tlw.DataOffset or 0
    if tlw.DataOffset < 0 then tlw.DataOffset = 0 end
    --d(tlw.DataLines)
    if KC_Fn.tablelength(tlw.DataLines) == 0 then return end

    tlw.Slider:SetMinMax(0,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
    --d(tlw.DataOffset)
    --for i=1,tlw.DataOffset-1 do
    	--d("nexting")
    	--pk = next(tlw.DataLines, pk)

   -- end
   local pk = tlw.DataOffset
   --d(#tlw.DataLines, pk)
    for i = 2,tlw.MaxLines do
    	if pk + (i-1) > #tlw.DataLines then break end
        local curLine = tlw.Lines[i]
        local curData = tlw.DataLines[pk + i -1]
        --d(i)
        curLine.Columns[1]:SetText(curData.Name)
        curLine.Columns[2]:SetText(curData.Kills)
        curLine.Columns[3]:SetText(curData.KillingBlows)
        curLine.Columns[4]:SetText(curData.Revent_Kills)
        curLine.Columns[5]:SetText(curData.Avenge_Kills)
        curLine.Columns[6]:SetText(curData.Class)
        curLine.Columns[7]:SetText(KC_Fn.Colored_Alliance_From_Id(curData.Alliance))

    end 
end

function KC_G.UpdateDeathsTable(...)
	if deaths_table == nil then return end
    local tlw = deaths_table
    tlw.DataOffset = tlw.DataOffset or 0
    if tlw.DataOffset < 0 then tlw.DataOffset = 0 end
    --d(tlw.DataLines)
    if KC_Fn.tablelength(tlw.DataLines) == 0 then return end

    tlw.Slider:SetMinMax(0,KC_Fn.tablelength(tlw.DataLines) - tlw.MaxLines)
    --d(tlw.DataOffset)
    --for i=1,tlw.DataOffset-1 do
    	--d("nexting")
    	--pk = next(tlw.DataLines, pk)

   -- end
   local pk = tlw.DataOffset
   --d(#tlw.DataLines, pk)
    for i = 2,tlw.MaxLines do
    	if pk + (i-1) > #tlw.DataLines then break end
        local curLine = tlw.Lines[i]
        curData = tlw.DataLines[pk + i -1]
        --d(i)
        curLine.Columns[1]:SetText(curData.Name)
        curLine.Columns[2]:SetText(curData.KilledBy)
        curLine.Columns[3]:SetText(curData.Class)
        curLine.Columns[4]:SetText(KC_Fn.Colored_Alliance_From_Id(curData.Alliance))
        local level = curData.Level
        if curData.Level == 50 then level = "v" .. curData.vLevel end
        curLine.Columns[5]:SetText(level)


    end 
end


--function KC_updateStats(override)
function KC_G.updateStats(override)
	override = override or false
	if (not showingStats) and not override == nil then 
		--d("sds")
		return 
	end
	local l = 1
	for i=stats_position,stats_position + stats_num_to_show do
		if l > #stats_killed_labels then break end
		if i > #stats_killed_array then 
			stats_killed_labels[l]:SetText("")
		else
			stats_killed_labels[l]:SetText(stats_killed_array[i])
		end
		l = l + 1
	end

	KC_G.UpdateKillsTable()
	KC_G.updateKillingSpellTable()
end

--function KC_showStats()
function KC_G.showStats()

	--d("Showing Stats")
 	LMM:ToggleCategory(MENU_CATEGORY_KILLCOUNTER)
 	--[[]]
	if stats_window == nil then
		--[[]
		stats_window = CreateControlFromVirtual("KillCounter_Stats_Window", GuiRoot, "KillCounter_Stats")
		stats_window:SetHandler("OnMouseWheel",function(self,delta)
			KC_G.statsMouseWheel(self, delta)
		end)
		--]]
		stats_window = true
		KC_G.statsWindowGUISetup()
		KC_G.settingsWindowGUISetup()
		--creating for first time. initialize the labels
		--d(#stats_killed_array)

		
	else
		--stats_window:SetHidden(false)

	end
	--]]
	showingStats = true
	KC_G.updateStats()
	--KC_G.loadKilled()
	
	--d("test")
	KC_G.UpdateGui()
end

--function KC_closeStats()
function KC_G.closeStats()
	--[[]
	if stats_window ~= nil then
		stats_window:SetHidden(true)
	else 
		--wut
	end
	]]--
	showingStats = false
end

function KC_G.showSettings()
	--d("Showing Stats")
	if settings_window == nil then
		settings_window = true
		--[[]
		settings_window = CreateControlFromVirtual("KillCounter_Settings_Window", GuiRoot, "KillCounter_Settings")
		settings_window:SetHandler("OnMouseWheel",function(self,delta)
			--KC_G.statsMouseWheel(self, delta)
		end)
		--]]
		--KC_G.statsWindowGUISetup()
		KC_G.settingsWindowGUISetup()
		--creating for first time. initialize the labels
		--d(#stats_killed_array)

		
	else
		--settings_window:SetHidden(false)
		
		--KC_G.updateStats()
	end
	LMM:Update(MENU_CATEGORY_KILLCOUNTER, "KillCounterSettings")
	showingSettings = true
	--KC_G.loadKilled()
end

--function KC_closeStats()
function KC_G.closeSettings()
	--[[]
	if settings_window ~= nil then
		settings_window:SetHidden(true)
	else 
		--wut
	end
	]]--
	showingSettings = false
end




--function KC_statsMouseWheel(self, delta)
function KC_G.statsMouseWheel(self, delta)

	delta = delta/math.abs(delta)
	delta = delta * -1
	--check
	--d(delta)
	if stats_position <= 1 and delta == -1 then return end
	--d(#stats_killed_array)
	if stats_position >= (#stats_killed_array - stats_num_to_show) and delta == 1 then return end
	--d(self)
	--d(delta)
	stats_position = stats_position + delta
	--d(stats_position .. "stats")

	KC_G.updateStats()


end


function KC_G.UpdateGui()
	KC_G.updateSessionGui()
	local dd = 0
	local t = 0
	if KC_G.savedVars ~= nil then dd = KC_G.savedVars.totalDeaths or 0 end
	if KC_G.savedVars ~= nil then t = KC_G.savedVars.totalKills or 0 end

	local Ckdr = 0
	Ckdr = KC_G.GetCounter()
	if KC_G.GetDeathCounter() > 0 then Ckdr = KC_G.GetCounter()/KC_G.GetDeathCounter() end
	--d("trying to update " .. tostring(showingSettings) .. " | " .. tostring(stats_window ~= nil) .. " | " .. tostring(stats_table ~= nil) .. " | " .. tostring(KC_G.savedVars ~= nil))
	if showingStats and KC_G.savedVars ~= nil and stats_table ~= nil then 
    	--local t = stats_window:GetChildren()
    	--d("updating gui")
    	local kdr=t
    	if dd > 0 then kdr=t/dd end

	    for i=1,stats_table.MaxLines do
	 		for j=1,stats_table.MaxColumns do 
	        	if i==1 then
	        		--do nothing
	        	else
	        		if i==2 then
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(t) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_G.GetCounter()) end

			   		end
			   		if i==3 then

				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(dd) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_G.GetDeathCounter()) end

			   		end
			   		if i==4 then
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.longestStreak) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_G.GetStreak()) end
			   		end
			   		if i==5 then
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.longestDeathStreak) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_G.GetDStreak()) end
			   		end
			   		if i==6 then
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(KC_Fn.round(kdr, 2)) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_Fn.round(Ckdr, 2)) end
			   		end
			   		if i==7 then
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.rankPointsGained) end
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(KC_G.GetRankPoints()) end
			   		end
			   		if i==8 then
			   			local kbs = 0
			   			for n, guy in pairs(KC_G.savedVars.killed) do
			   				kbs = kbs + guy.KillingBlows
			   			end
			   			kbstr = kbs .. " (" .. KC_G.savedVars.longestKBStreak .. ")"
				        if j==2 then stats_table.Lines[i].Columns[j]:SetText(kbstr) end
				        kbstr2 = KC_G.GetKillingBlows() .. " (" .. KC_G.GetKBStreak()  .. ")"
		        		if j==3 then stats_table.Lines[i].Columns[j]:SetText(kbstr2) end
			   		end
			    end
		    end
	    end

	    for i=1,seige_table.MaxLines do
	 		for j=1,seige_table.MaxColumns do 
	        	if i==1 then
	        		--do nothing
	        	else
	        		if i==2 then
				        if j==2 then seige_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.SC.keepsCaptured) end
		        		if j==3 then seige_table.Lines[i].Columns[j]:SetText(SC_G.GetKCaps()) end

			   		end
			   		if i==3 then

				        if j==2 then seige_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.SC.resourcesCaptured) end
		        		if j==3 then seige_table.Lines[i].Columns[j]:SetText(SC_G.GetRCaps()) end

			   		end
			   		if i==4 then
				        if j==2 then seige_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.SC.longestResourceStreak) end
		        		if j==3 then seige_table.Lines[i].Columns[j]:SetText(SC_G.GetRStreak()) end
			   		end
			   		if i==5 then
				        if j==2 then seige_table.Lines[i].Columns[j]:SetText(KC_G.savedVars.SC.longestKeepStreak) end
		        		if j==3 then seige_table.Lines[i].Columns[j]:SetText(SC_G.GetKStreak()) end
			   		end
			    end
		    end
	    end

	    for i=1,breakdown_table.MaxLines do
	 		for j=1,breakdown_table.MaxColumns do 
	        	if i==1 then
	        		--do nothing
	        		if j==2 then 
	        			--go through all killed players, find one with most kills
	        			local mostkills = -1
	        			local mkplayer = {}

	        			for ii,v in pairs(KC_G.savedVars.killed) do
	        				--d(v)
	        				if v.Kills > mostkills then 
	        					mkplayer = v 
	        					mostkills = v.Kills
	        				end
	        			end
	        			if mkplayer.Name ~= nil and mkplayer.Kills ~= nil then
	        				breakdown_table.Lines[i].Columns[j]:SetText(mkplayer.Name .. " (" .. mkplayer.Kills .. " Kills)")
	        			end
	        		end
	        	else
	        		if i==2 then
				        if j==2 then 
				        	local mostkbs = -1
		        			local mkplayer = {}
		        			for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.KillingBlows > mostkbs then 
		        					mkplayer = v 
		        					mostkbs = v.KillingBlows
		        				end
		        			end
		        			if mkplayer.Name ~= nil and mkplayer.KillingBlows ~= nil then
			        			breakdown_table.Lines[i].Columns[j]:SetText(mkplayer.Name .. " (" .. mkplayer.KillingBlows .. " Killing Blows)")
		        			end
	        			end

			   		end
			   		if i==3 then
				        if j==2 then 
				        	
		        			breakdown_table.Lines[i].Columns[j]:SetText(KC_Fn.tablelength(KC_G.savedVars.killed))
	        			end

			   		end
			   		if i==4 then
				        if j==2 then 
				        	local ad = 0
				        	local ep = 0
				        	local dc = 0
				        	for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.Alliance == ALLIANCE_EBONHEART_PACT then 
		        					ep = ep + v.Kills
		        				end
		        				if v.Alliance == ALLIANCE_DAGGERFALL_COVENANT then 
		        					dc = dc + v.Kills
		        				end
		        				if v.Alliance == ALLIANCE_ALDMERI_DOMINION then 
		        					ad = ad + v.Kills
		        				end



		        			end
		        			max = math.max(ad, dc, ep)

		        			if ep == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Ebonheart Pact" .. " (" .. max .. " Kills)")
		        			end
		        			if dc == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Dagerfall Covenant" .. " (" .. max .. " Kills)")
		        			end
		        			if ad == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Aldmeri Dominion" .. " (" .. max .. " Kills)")
		        			end
	        			end

			   		end
			   		if i==5 then
				        if j==2 then 
				        	local temp = 0
				        	local sorc = 0
				        	local dk = 0
				        	local nb = 0
				        	for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.Class == "Templar" then 
		        					temp = temp + v.Kills
		        				end
		        				if v.Class == "Dragonknight" then 
		        					dk = dk + v.Kills
		        				end
		        				if v.Class == "Sorcerer" then 
		        					sorc = sorc + v.Kills
		        				end
		        				if v.Class == "Nightblade" then 
		        					nb = nb + v.Kills
		        				end



		        			end
		        			max = math.max(temp, sorc, dk, nb)

		        			if temp == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Templar" .. " (" .. max .. " Kills)")
		        			end
		        			if sorc == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Sorcerer" .. " (" .. max .. " Kills)")
		        			end
		        			if dk == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Dragonknight" .. " (" .. max .. " Kills)")
		        			end
		        			if nb == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Nightblade" .. " (" .. max .. " Kills)")
		        			end
	        			end

			   		end

			   		if i==7 then
		        		--do nothing
		        		if j==2 then 
		        			--go through all killed players, find one with most kills
		        			local mostkills = -1
		        			local mkplayer = {}

		        			for ii,v in pairs(KC_G.savedVars.killedBy) do
		        				--d(v)
		        				if v.KilledBy > mostkills then 
		        					mkplayer = v 
		        					mostkills = v.KilledBy
		        				end
		        			end
		        			if mkplayer.Name ~= nil and mkplayer.KilledBy ~= nil then
		        				breakdown_table.Lines[i].Columns[j]:SetText(mkplayer.Name .. " (" .. mkplayer.KilledBy .. " Kills)")
		        			end
		        		end
		        	end
		        	if i==8 then
		        		if j == 2 then
				        	breakdown_table.Lines[i].Columns[j]:SetText(KC_Fn.tablelength(KC_G.savedVars.killedBy))
				        end

			   		end
			   		if i==9 then
				        if j==2 then 
				        	local temp = 0
				        	local sorc = 0
				        	local dk = 0
				        	local nb = 0
				        	for ii,v in pairs(KC_G.savedVars.killedBy) do
		        				if v.Class == "Templar" then 
		        					temp = temp + v.KilledBy
		        				end
		        				if v.Class == "Dragonknight" then 
		        					dk = dk + v.KilledBy
		        				end
		        				if v.Class == "Sorcerer" then 
		        					sorc = sorc + v.KilledBy
		        				end
		        				if v.Class == "Nightblade" then 
		        					nb = nb + v.KilledBy
		        				end



		        			end
		        			max = math.max(temp, sorc, dk, nb)

		        			if temp == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Templar")
		        			end
		        			if sorc == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Sorcerer")
		        			end
		        			if dk == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Dragonknight")
		        			end
		        			if nb == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Nightblade")
		        			end
	        			end

			   		end
			   		if i==10 then
				        if j==2 then 
				        	local ad = 0
				        	local ep = 0
				        	local dc = 0
				        	for ii,v in pairs(KC_G.savedVars.killedBy) do
		        				if v.Alliance == ALLIANCE_EBONHEART_PACT then 
		        					ep = ep + v.KilledBy
		        				end
		        				if v.Alliance == ALLIANCE_DAGGERFALL_COVENANT then 
		        					dc = dc + v.KilledBy
		        				end
		        				if v.Alliance == ALLIANCE_ALDMERI_DOMINION then 
		        					ad = ad + v.KilledBy
		        				end



		        			end
		        			max = math.max(ad, dc, ep)

		        			if ep == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Ebonheart Pact" .. " (" .. max .. " Kills)")
		        			end
		        			if dc == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Dagerfall Covenant" .. " (" .. max .. " Kills)")
		        			end
		        			if ad == max then
		        				breakdown_table.Lines[i].Columns[j]:SetText("Aldmeri Dominion" .. " (" .. max .. " Kills)")
		        			end
	        			end

			   		end
			   		if i==11 then
				        if j==2 then 
				        	local ad = 0
				        	--local ep = 0
				        	--local dc = 0
				        	for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.Alliance == ALLIANCE_ALDMERI_DOMINION then 
		        					ad = ad + v.Kills
		        				end
		        			end

		        			breakdown_table.Lines[i].Columns[j]:SetText(ad)

	        			end

			   		end
			   		if i==12 then
				        if j==2 then 
				        	--local ad = 0
				        	--local ep = 0
				        	local dc = 0
				        	for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.Alliance == ALLIANCE_DAGGERFALL_COVENANT then 
		        					dc = dc + v.Kills
		        				end
		        			end

		        			breakdown_table.Lines[i].Columns[j]:SetText(dc)

	        			end

			   		end
			   		if i==13 then
				        if j==2 then 
				        	--local ad = 0
				        	local ep = 0
				        	--local dc = 0
				        	for ii,v in pairs(KC_G.savedVars.killed) do
		        				if v.Alliance == ALLIANCE_EBONHEART_PACT then 
		        					ep = ep + v.Kills
		        				end
		        			end

		        			breakdown_table.Lines[i].Columns[j]:SetText(ep)

	        			end

			   		end

			   		if i==14 then
				        if j==2 then 
				        	--kb ratio
				        	local kbr = 0

				        	for k,v in pairs(KC_G.savedVars.killed) do
				        		kbr = kbr + v.KillingBlows
				        	end

				        	if (KC_G.savedVars.totalDeaths > 0) then
				        		kbr = kbr / KC_G.savedVars.totalKills
				        	end
				        	local kpkb = 0
				        	if kbr > 0 then 
				        		kpkb = 1.0 / kbr end
				        	kpkb = KC_Fn.round(kpkb,2)
				        	breakdown_table.Lines[i].Columns[j]:SetText(KC_Fn.round(kbr, 2) .. " (" .. kpkb .. " Kills/KB)")
	        			end

			   		end
			   		if i==15 then
				        if j==2 then 
				        	local kbr = 0

				        	for k,v in pairs(KC_G.savedVars.killed) do
				        		kbr = kbr + v.KillingBlows
				        	end

				        	if (KC_G.savedVars.totalKills > 0) then
				        		kbr = kbr / KC_G.savedVars.totalKills
				        	end



		        			breakdown_table.Lines[i].Columns[j]:SetText(KC_Fn.KBLevel(kbr))

	        			end

			   		end
			   		if i==16 then
				        if j==2 then 
				        	local spell = "None"
				        	local max = 0
				        	for k,v in pairs(KC_G.savedVars.kbSpells) do
				        		--d(v)
				        		if v > max then 
				        			spell = k
				        			max = v
				        		end
				        	end

				        	local noun = "KB"
				        	if max > 1 then 
				        		noun = noun .. "s" 
				        	end

		        			breakdown_table.Lines[i].Columns[j]:SetText(spell .. " (" .. max .. " " .. noun .. ")")

	        			end

			   		end
			    end
		    end
	    end

	    local ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp = KC_G.Percentages()

	    breakdown_graph.DragonKnight.Label:SetText("|CabababDragon Knights: ".. KC_Fn.round(dkp*100, 2).."% " .. dragonknight .. " Kills" .. "|r")
	    breakdown_graph.DragonKnight:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * dkp,30)
		
		breakdown_graph.Sorceror:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * sorcp,30)
	    breakdown_graph.Sorceror.Label:SetText("|CabababSorcerors: ".. KC_Fn.round(sorcp*100, 2).."% " .. sorceror .. " Kills" .. "|r")

	    breakdown_graph.NightBlade.Label:SetText("|CabababNightBlades: ".. KC_Fn.round(nbp*100, 2).."% " .. nightblade .. " Kills" .. "|r")
	    breakdown_graph.NightBlade:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * nbp,30)
	    
	    breakdown_graph.Templar.Label:SetText("|CabababTemplars: ".. KC_Fn.round(tempp*100, 2).."% " .. templar .. " Kills" .. "|r")
	    breakdown_graph.Templar:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * tempp,30)

	    local ad, dc, ep, adp, dcp, epp, templar, dragonknight, nightblade, sorceror, tempp, dkp, nbp, sorcp = KC_G.DeathPercentages()

	    breakdown_death_graph.DragonKnight.Label:SetText("|CabababDragon Knights: ".. KC_Fn.round(dkp*100, 2).."% " .. dragonknight .. " Deaths" .. "|r")
	    breakdown_death_graph.DragonKnight:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * dkp,30)
		
		breakdown_death_graph.Sorceror:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * sorcp,30)
	    breakdown_death_graph.Sorceror.Label:SetText("|CabababSorcerors: ".. KC_Fn.round(sorcp*100, 2).."% " .. sorceror .. " Deaths" .. "|r")

	    breakdown_death_graph.NightBlade.Label:SetText("|CabababNightBlades: ".. KC_Fn.round(nbp*100, 2).."% " .. nightblade .. " Deaths" .. "|r")
	    breakdown_death_graph.NightBlade:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * nbp,30)
	    
	    breakdown_death_graph.Templar.Label:SetText("|CabababTemplars: ".. KC_Fn.round(tempp*100, 2).."% " .. templar .. " Deaths" .. "|r" )
	    breakdown_death_graph.Templar:SetDimensions(((breakdown_graph:GetWidth()*.75)-10) * tempp,30)

    end
--[[]
    ]]
end


function KC_G.ShowPlayer(player)
	if KC_G.savedVars.killed[player] == nil and KC_G.savedVars.killedBy[player] == nil then return end
	
	didkill = not (KC_G.savedVars.killed[player] == nil)
	diddie = not (KC_G.savedVars.killedBy[player] == nil)
	--d(player)

	if player_view_window == nil then
		--setup the player view window
		local pv = WINDOW_MANAGER:CreateControlFromVirtual("KillCounter_Player_View_Window", GuiRoot, "KillCounter_Player_View")
		pv.AllianceTexture = KillCounter_Player_View_Window_Alliance_Logo_Texture
		pv:SetHidden(false)

		--d(pv)
		font = "ZoFontCenterScreenAnnounceSmall"
		pv.NameLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Name",pv,CT_LABEL)
		pv.NameLabel:SetFont(font)
		pv.NameLabel:SetAnchor(TOPLEFT, pv, TOPLEFT, 25, 25)
		pv.NameLabel:SetHidden(false)

		pv.KillLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Kills",pv,CT_LABEL)
		pv.KillLabel:SetFont(font)
		pv.KillLabel:SetAnchor(TOPLEFT, pv.NameLabel, BOTTOMLEFT, -20, 3)
		pv.KillLabel:SetHidden(false)

		pv.DeathLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Deaths",pv,CT_LABEL)
		pv.DeathLabel:SetFont(font)
		pv.DeathLabel:SetAnchor(TOPLEFT, pv.KillLabel, BOTTOMLEFT, 0, 3)
		pv.DeathLabel:SetHidden(false)

		pv.RatioLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Ratio",pv,CT_LABEL)
		pv.RatioLabel:SetFont(font)
		pv.RatioLabel:SetAnchor(TOPLEFT, pv.DeathLabel, BOTTOMLEFT, 0, 3)
		pv.RatioLabel:SetHidden(false)

		pv.ClassLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Class",pv,CT_LABEL)
		pv.ClassLabel:SetFont(font)
		pv.ClassLabel:SetAnchor(TOPLEFT, pv.RatioLabel, BOTTOMLEFT, 0, 3)
		pv.ClassLabel:SetHidden(false)

		pv.LevelLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Level",pv,CT_LABEL)
		pv.LevelLabel:SetFont(font)
		pv.LevelLabel:SetAnchor(TOPLEFT, pv.ClassLabel, BOTTOMLEFT, 0, 3)
		pv.LevelLabel:SetHidden(false)

		pv.ThreatLevelLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Threat_Level",pv,CT_LABEL)
		pv.ThreatLevelLabel:SetFont("ZoFontGameBold")
		pv.ThreatLevelLabel:SetAnchor(TOPLEFT, pv.LevelLabel, BOTTOMLEFT, 0, 28)
		pv.ThreatLevelLabel:SetHidden(false)

		pv.AvengeLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Label_Avenge",pv,CT_LABEL)
		pv.AvengeLabel:SetFont("ZoFontGameBold")
		pv.AvengeLabel:SetAnchor(TOPLEFT, pv.ThreatLevelLabel, BOTTOMLEFT, 0, 3)
		pv.AvengeLabel:SetHidden(false)

		pv.RevengeLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_Revenge",pv,CT_LABEL)
		pv.RevengeLabel:SetFont("ZoFontGameBold")
		pv.RevengeLabel:SetAnchor(TOPLEFT, pv.AvengeLabel, BOTTOMLEFT, 0, 3)
		pv.RevengeLabel:SetHidden(false)

		pv.KBLabel = WINDOW_MANAGER:CreateControl("KillCounter_Player_View_Window_KillingBlow",pv,CT_LABEL)
		pv.KBLabel:SetFont("ZoFontGameBold")
		pv.KBLabel:SetAnchor(TOPLEFT, pv.RevengeLabel, BOTTOMLEFT, 0, 3)
		pv.KBLabel:SetHidden(false)

		player_view_window = pv
	end
		--
		
		local name = ""
		local kills = 0
		local deaths = 0
		local class = ""
		local alliance = 0
		local level = ""
		local revenge = 0
		local avenge = 0
		local kbs = 0

		--d(didkill, diddie)

		if didkill then
			name = KC_G.savedVars.killed[player].Name
			kills = KC_G.savedVars.killed[player].Kills
			class = KC_G.savedVars.killed[player].Class
			alliance = KC_G.savedVars.killed[player].Alliance
			level = KC_G.savedVars.killed[player].Level
			revenge = KC_G.savedVars.killed[player].Revent_Kills
			avenge = KC_G.savedVars.killed[player].Avenge_Kills
			kbs = KC_G.savedVars.killed[player].KillingBlows
		end

		if diddie then
			name = KC_G.savedVars.killedBy[player].Name
			deaths = KC_G.savedVars.killedBy[player].KilledBy
			if class == "" and KC_G.savedVars.killedBy[player].Class ~= "" then 
				class = KC_G.savedVars.killedBy[player].Class
			end

			alliance = KC_G.savedVars.killedBy[player].Alliance
			local lvl = KC_G.savedVars.killedBy[player].Level
			local vlvl = KC_G.savedVars.killedBy[player].vLevel
			level = lvl
			if lvl == 50 then 
				level = "v" .. vlvl
			end
		end

		local ratio = kills
		if deaths > 0 then ratio = ratio / deaths end



		--labels
		player_view_window.NameLabel:SetText(name)
		player_view_window.KillLabel:SetText("Kills: " .. kills)
		player_view_window.DeathLabel:SetText("Deaths: " .. deaths)
		player_view_window.RatioLabel:SetText("Ratio: " .. ratio)

		if class ~= "" then
			player_view_window.ClassLabel:SetText("Class: " .. class)
		else
			player_view_window.ClassLabel:SetText("")
		end

		if level ~= 0 then
			player_view_window.LevelLabel:SetText("Level: " .. level)
		else
			player_view_window.LevelLabel:SetText("")
		end
		player_view_window.ThreatLevelLabel:SetText("Threat Level: " .. KC_Fn.ThreatLevel(ratio) .. KC_Fn.ThreatLevelText(ratio))
		player_view_window.RevengeLabel:SetText("Revenge Kills: " .. revenge)
		player_view_window.AvengeLabel:SetText("Avenge Kills: " .. avenge)
		--textures
		local tex = KC_Fn.Alliance_Texture_From_Id(alliance)
		if tex ~= "No One" then
			KillCounter_Player_View_Window_Alliance_Logo_Texture:SetTexture(tex)
			KillCounter_Player_View_Window_Alliance_Logo_Texture:SetAlpha(0.3)
		else
			KillCounter_Player_View_Window_Alliance_Logo_Texture:SetAlpha(0.0)
		end
		player_view_window.KBLabel:SetText("Killing Blows: " .. kbs)

	if player_view_window:IsHidden() then player_view_window:SetHidden(false) end
end

function KC_G.ClosePlayer()
	if player_view_window == nil then return end

	player_view_window:SetHidden(true)
end


---LibMainMenu
--[[]]
function KC_G.KCMenuSetup()
	--KC_G.statsWindowGUISetup()

	 ZO_CreateStringId("SI_KILLCOUNTER_MAIN_MENU_TITLE", "Kill Counter")
    
    -- Its infos,
    ZO_CreateStringId("SI_BINDING_NAME_KILLCOUNTER_SHOW_PANEL", "Toggle Kill Counter Stats") -- you also need to use a bindings.xml in order to display your keybind in options.
    ZO_CreateStringId("SI_BINDING_NAME_KILLCOUNTER_SHOW_SETTINGS", "Toggle Kill Counter Settings") -- you also need to use a bindings.xml in order to display your keybind in options.
    
    KILLCOUNTER_MAIN_MENU_CATEGORY_DATA =
    {
        binding = "KILLCOUNTER_SHOW_PANEL",
        categoryName = SI_KILLCOUNTER_MAIN_MENU_TITLE,
        normal = "EsoUI/Art/MainMenu/menuBar_champion_up.dds",
        pressed = "EsoUI/Art/MainMenu/menuBar_champion_down.dds",
        highlight = "EsoUI/Art/MainMenu/menuBar_champion_over.dds",
    }
    

    --START CREATE SCENE
	--MyAddon.CreateScene()
	 -- Main Scene
    KC_MAIN_SCENE = ZO_Scene:New("KillCounterMain", SCENE_MANAGER) 
    
    -- Mouse standard position and background
    KC_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KC_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KC_MAIN_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KC_MAIN_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_MAIN_MENU_TITLE", "Stats Overview")
    KC_MAIN_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_MAIN_MENU_TITLE)
    KC_MAIN_SCENE:AddFragment(KC_MAIN_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KC_MAIN_SCENE_MAIN_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu)
    KC_MAIN_SCENE:AddFragment(KC_MAIN_SCENE_MAIN_WINDOW)


    --end create scene


    --d("stuff happened")
    -- Build the Menu
    -- Its name for the menu (the meta scene)
   
    -- Then the scenes
    
    -- Main Scene is created trought our function described in 1st section
    --MyAddon.CreateScene()
    
    -- Another Scene , because using main menu without having 2 scenes should be avoided.
    KILLCOUNTER_SESSION_SCENE = ZO_Scene:New("KillCounterSession", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_SESSION_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_SESSION_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_SESSION_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_SESSION_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_IMPORT_MENU_TITLE", "Current Session")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_SESSION_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_IMPORT_MENU_TITLE) 
    KILLCOUNTER_SESSION_SCENE:AddFragment(KILLCOUNTER_SESSION_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_SESSION_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Session)
    KILLCOUNTER_SESSION_SCENE:AddFragment(KILLCOUNTER_SESSION_WINDOW)


    --END SEIGE SCENE


    --START KILLS SCENE

    KILLCOUNTER_KILLS_SCENE = ZO_Scene:New("KillCounterKills", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_KILLS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_KILLS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_KILLS_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_KILLS_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_KILLS_MENU_TITLE", "Kills")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_KILLS_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_KILLS_MENU_TITLE) 
    KILLCOUNTER_KILLS_SCENE:AddFragment(KILLCOUNTER_KILLS_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_KILLS_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Kills)
    KILLCOUNTER_KILLS_SCENE:AddFragment(KILLCOUNTER_KILLS_WINDOW)
	
	--END KILLS SCENE


    --START DEATHS SCENE

    KILLCOUNTER_DEATHS_SCENE = ZO_Scene:New("KillCounterDeaths", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_DEATHS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_DEATHS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_DEATHS_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_DEATHS_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_DEATHS_MENU_TITLE", "Killers")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_DEATHS_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_DEATHS_MENU_TITLE) 
    KILLCOUNTER_DEATHS_SCENE:AddFragment(KILLCOUNTER_DEATHS_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_DEATHS_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Deaths)
    KILLCOUNTER_DEATHS_SCENE:AddFragment(KILLCOUNTER_DEATHS_WINDOW)


    --END DEATHS SCENE


    --START BREAKDOWN SCENE

    KILLCOUNTER_BREAKDOWN_SCENE = ZO_Scene:New("KillCounterBreakdown", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_BREAKDOWN_MENU_TITLE", "Stats Breakdown")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_BREAKDOWN_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_BREAKDOWN_MENU_TITLE) 
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragment(KILLCOUNTER_BREAKDOWN_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_BREAKDOWN_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Breakdown)
    KILLCOUNTER_BREAKDOWN_SCENE:AddFragment(KILLCOUNTER_BREAKDOWN_WINDOW)

    
     --END BREAKDOWN SCENE


    --START SPELLS SCENE

    KILLCOUNTER_SPELLS_SCENE = ZO_Scene:New("KillCounterSpells", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_SPELLS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_SPELLS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_SPELLS_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_SPELLS_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_SPELLS_MENU_TITLE", "Killing Blows")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_SPELLS_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_SPELLS_MENU_TITLE) 
    KILLCOUNTER_SPELLS_SCENE:AddFragment(KILLCOUNTER_SPELLS_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_SPELLS_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Spells)
    KILLCOUNTER_SPELLS_SCENE:AddFragment(KILLCOUNTER_SPELLS_WINDOW)

    --END SPELLS SCENE

    --START SETTINGS SCENE
    --[[]]
    KILLCOUNTER_SETTINGS_SCENE = ZO_Scene:New("KillCounterSettings", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    KILLCOUNTER_SETTINGS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    KILLCOUNTER_SETTINGS_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    KILLCOUNTER_SETTINGS_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    KILLCOUNTER_SETTINGS_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_KILLCOUNTER_SETTINGS_MENU_TITLE", "Settings")
    -- The title at the left of the scene is the "global one" but we can change it
    KILLCOUNTER_SETTINGS_SCENE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_KILLCOUNTER_SETTINGS_MENU_TITLE) 
    KILLCOUNTER_SETTINGS_SCENE:AddFragment(KILLCOUNTER_SETTINGS_SCENE_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    KILLCOUNTER_SETTINGS_WINDOW = ZO_FadeSceneFragment:New(Scene_KC_Menu_Settings)
    KILLCOUNTER_SETTINGS_SCENE:AddFragment(KILLCOUNTER_SETTINGS_WINDOW)

    --]]
 
    -- Set tabs and visibility, etc
    
    
        local iconData = {
            {
                categoryName = SI_KILLCOUNTER_MAIN_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterMain",
                normal = "/esoui/art/campaign/campaign_tabicon_browser_up.dds",
                pressed = "/esoui/art/campaign/campaign_tabicon_browser_down.dds",
                highlight = "/esoui/art/campaign/campaign_tabicon_browser_over.dds",
            },
            {
                categoryName = SI_KILLCOUNTER_IMPORT_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterSession",
                normal = "/esoui/art/charactercreate/charactercreate_raceicon_up.dds",
                pressed = "/esoui/art/charactercreate/charactercreate_raceicon_down.dds",
                highlight = "/esoui/art/charactercreate/charactercreate_raceicon_over.dds",
            },
            {
                categoryName = SI_KILLCOUNTER_KILLS_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterKills",
                normal = "/esoui/art/campaign/campaign_tabicon_leaderboard_up.dds",
                pressed = "/esoui/art/campaign/campaign_tabicon_down_up.dds",
                highlight = "/esoui/art/campaign/campaign_tabicon_leaderboard_over.dds",
            },
            {
                categoryName = SI_KILLCOUNTER_DEATHS_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterDeaths",
                normal = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_up.dds",
                pressed = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_down.dds",
                highlight = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_over.dds",
            },
            {
                categoryName = SI_KILLCOUNTER_BREAKDOWN_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterBreakdown",
                normal = "/esoui/art/campaign/campaign_tabicon_history_up.dds",
                pressed = "/esoui/art/campaign/campaign_tabicon_history_down.dds",
                highlight = "/esoui/art/campaign/campaign_tabicon_history_over.dds",
            },
            {
                categoryName = SI_KILLCOUNTER_SPELLS_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterSpells",
                normal = "/esoui/art/campaign/campaignbrowser_indexicon_normal_up.dds",
                pressed = "/esoui/art/campaign/campaignbrowser_indexicon_normal_down.dds",
                highlight = "/esoui/art/campaign/campaignbrowser_indexicon_normal_over.dds",
            },
            --[[]]
            {
                categoryName = SI_KILLCOUNTER_SETTINGS_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "KillCounterSettings",
                normal = "/esoui/art/campaign/campaign_tabicon_summary_up.dds",
                pressed = "/esoui/art/campaign/campaign_tabicon_summary_down.dds",
                highlight = "/esoui/art/campaign/campaign_tabicon_summary_over.dds",
            },
            --]]
        }
        
        -- Register Scenes and the group name
        SCENE_MANAGER:AddSceneGroup("KillCounterSceneGroup", ZO_SceneGroup:New("KillCounterMain", 
        			"KillCounterSession", 
        			"KillCounterKills", 
        			"KillCounterDeaths",
        			"KillCounterBreakdown",
        			"KillCounterSpells",
        			"KillCounterSettings"))
        
        -- ZOS have hardcoded its categories, so here is LibMainMenu utility.
        MENU_CATEGORY_KILLCOUNTER = LMM:AddCategory(KILLCOUNTER_MAIN_MENU_CATEGORY_DATA)
        
        -- Register the group and add the buttons
        LMM:AddSceneGroup(MENU_CATEGORY_KILLCOUNTER, "KillCounterSceneGroup", iconData)
        
    	stats_window = true
    	settings_window = true
    	KC_G.statsWindowGUISetup()
    	KC_G.settingsWindowGUISetup()
    	KC_G.sessionWindowGUISetup()

end
--]]