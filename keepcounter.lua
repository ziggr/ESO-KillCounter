--seige counter
SC_G = {}
local shouldTrack = false
local takingKeep = false
local keepTakenByMe = false
local lastKeepFlag = ""

local keepCaptures = 0
local resourceCaptures = 0
local keepStreak = 0
local resourceStreak = 0
local showSeige = true

local seigeAlertColor = "|CA15406"
local captureAlertColor = "|C7685A3"

kStreakArray = {}
rStreakArray = {}

function SC_G.GetKCaps() return keepCaptures end
function SC_G.GetRCaps() return resourceCaptures end
function SC_G.GetKStreak() return keepStreak end
function SC_G.GetRStreak() return resourceStreak end


function SC_G.KeepChanged(self, keepID, context, owningAlliance)
	d("keep changed")
	d(keepID, context, owningAlliance)
end

function SC_G.ObjectiveControlState(self, objectiveKeepId, objectiveObjectiveId, battlegroundContext, objectiveName, objectiveType, objectiveControlEvent, objectiveControlState, objectiveParam1, objectiveParam2)
	if not IsPlayerInAvAWorld() then return end
	--d("objectives")
	--wtf is battlegroundContext. fuckin why... always 3... wat
	--context might be the compaign. 3 is home 2 may be gueste.
	--nope, but definitely got different values in auriels bow vs wabba
	 --objective params seem to be based on the faction.
	 --param1 2 = ebon 3 = dagger 1 = almeri
	 --what is param2? why is it usually 0? why sometimes no? i think its always 0
	 --objectiveType = 4 for capture area 3 for capture point.
	 --ALIIANCE_EBONHEART_PACT
	if objectiveControlEvent == OBJECTIVE_CONTROL_EVENT_CAPTURED or objectiveControlEvent == OBJECTIVE_CONTROL_EVENT_RECAPTURED  then 
		--d("keep captured")
		--d(objectiveKeepId, objectiveObjectiveId, objectiveName,battlegroundContext, objectiveType, "removed control state and event", objectiveParam1, objectiveParam2)
		local keepname = GetKeepName(objectiveKeepId)
		--local kkkk = GetKeepName(-5000)
		--d(keepname)
		if KC_Fn.CheckSetting("ChatSeiges") then
			d(seigeAlertColor .. objectiveName .. " has been Taken by " .. KC_Fn.Alliance_From_Id(objectiveParam1, true))
		end
		if objectiveParam1 == GetUnitAlliance("player") then --your faction has taken this one, 
			--d("Your faction has taken " .. objectiveName)
			--zo_callLater(function justTaken = false end, 5000) --should be enough time nvm not necessary leaving for reference

			--check if objective name is same as lastKeep
			--this should be extremely rare. basically handle if they have captured something, had it recaptured, then captured it again before capturing anything else
			if objectiveName == lastKeepFlag then
				lastKeepFlag = objectiveName
				takingKeep = true
				return
			end
			
			local pieces = KC_Fn.string_split(objectiveName)
		 	--d(pieces)
		 	if pieces ~= nil then
		 		--get last item
		 		local last = pieces[#pieces]
		 		if last == "Nave" or last == "Apse" or last == "Tower" or last == "Courtyard" then
		 			keepname = zo_strformat("<<1>>", keepname)
	 				objectivename = zo_strformat("<<1>>", objectivename)
		 			if not takingKeep then
			 			takingKeep = true
			 			lastKeepFlag = objectiveName
			 			--d("1/2 flags for " .. keepname .. " taken.") 
			 		else
			 			if keepTakenByMe then
			 				--check if its the right keep
			 				local resetLast = false
			 				lastpieces = KC_Fn.string_split(lastKeepFlag)
			 				if #lastpieces ~= #pieces then
				 				--not even the same size. abandon ship!
				 				resetLast = true
				 			else 
				 				--compare the first n-1 things. they should be the same
				 				for j=1,#lastpieces-1 do
				 					if lastpieces[j] ~= pieces[j] then
				 						resetLast = true
				 						break
				 					end
				 				end
				 			end

				 			if resetLast then
				 				--this wasnt the same one. keep going. 
				 				--do nothing
				 			else
								--We have captured the keep!
								if keepname == nil then keepname = objectiveName end
								d(captureAlertColor .. "You have captured " .. keepname)
								--do keep capture processing
								SC_G.addKeepCapture()
				 			end

			 			end
			 		end
			 	end
			end
		else
			--this keep was taken by an enemy. do something here 
		end
	end
end

function SC_G.CaptureAreaStatus(self, keepId, objectiveId, battlegroundContext, curValue, maxValue, currentCapturePlayers, alliance1, alliance2)
 if not IsPlayerInAvAWorld() then return end
 --d(curValue .. " " .. maxValue)
 if curValue == maxValue and alliance1 == GetUnitAlliance("player") then
 	--d("capture status")
 	--d(keepId, objectiveId, battlegroundContext, curValue, maxValue, currentCapturePlayers, alliance1, alliance2)
 	if shouldTrack then
	 	local keepname = GetKeepName(keepId)
	 	local objectivename = GetAvAObjectiveInfo(keepId, objectiveId, battlegroundContext)

	 	--d("You have taken " .. on .. " at " .. kn)
	 	
	 	local pieces = KC_Fn.string_split(objectivename)
	 	--d(pieces)
	 	if pieces ~= nil then
	 		--get last item
	 		local last = pieces[#pieces]
	 		--d(last)
	 		if last == "Nave" or last == "Apse" or last == "Tower" or last == "Courtyard" then
	 			--lkf=on because above event happens before this one.
	 			keepname = zo_strformat("<<1>>", keepname)
	 			objectivename = zo_strformat("<<1>>", objectivename)
	 			if not takingKeep or lastKeepFlag == objectivename then
		 			takingKeep = true
		 			lastKeepFlag = objectivename
		 			if KC_Fn.CheckSetting("ChatCaptures") then
			 			--d("1/2 flags for " .. keepname .. " taken.")
			 		end
		 			keepTakenByMe = true
		 		else
		 			local resetLast = false
		 			--we are taking a keep. compare peices of last to peices of first
		 			local lastpieces = KC_Fn.string_split(lastKeepFlag)
		 			if #lastpieces ~= #pieces then
		 				--not even the same size. abandon ship!
		 				resetLast = true
		 			else 
		 				--compare the first n-1 things. they should be the same
		 				for j=1,#lastpieces-1 do
		 					if lastpieces[j] ~= pieces[j] then
		 						resetLast = true
		 						break
		 					end
		 				end

		 				--this shouldnt happen, because if they are equal, the above if should be true, but just in case 
		 				if lastpieces[#lastpieces] == pieces[#pieces] then resetLast = true end

		 			end
		 			--now we know whether or not resetLast is true
		 			if resetLast then
		 				--this was a diffent keep. treat it like a normal one
		 				takingKeep = true --just in case
		 				lastKeepFlag = objectivename
		 				keepTakenByMe = true
		 			else
		 				--We have captured the keep!
		 				if KC_Fn.CheckSetting("ChatCaptures") then
		 					d(captureAlertColor .. "You have captured " .. keepname)
		 				end
		 				--do keep capture processing
		 				SC_G.addKeepCapture()
		 			end
		 		end
		 	else
		 		--this is a normal resource
		 		if KC_Fn.CheckSetting("ChatCaptures") then
		 			d(captureAlertColor .. "You have captured the " .. keepname .. ".")
		 		end
		 		--do resource processing
		 		resourceCaptures = resourceCaptures + 1
		 		resourceStreak = resourceStreak + 1
		 		KC_G.savedVars.SC.resourcesCaptured = KC_G.savedVars.SC.resourcesCaptured + 1
		 		SC_G.doRStreak()
		 		lastKeepFlag = ""
	 		end
	 	end

	 	shouldTrack = false
	 end
 else
 	shouldTrack = true
 end

end

function SC_G.addKeepCapture()
	keepCaptures = keepCaptures + 1
	keepStreak = keepStreak + 1
	KC_G.savedVars.SC.keepsCaptured = KC_G.savedVars.SC.keepsCaptured + 1
	SC_G.doKStreak()
	lastKeepFlag = ""
	keepTakenByMe = false
end

function SC_G.slashCommands()
	SLASH_COMMANDS["/sc"] = function (extra)
 		if string.lower(extra) == "stats" then
 			d("Keep Captures: " .. keepCaptures, "Resource Captures: " .. resourceCaptures, "Keep Captures Streak: " .. keepStreak, "Resource Captures Streak: " .. resourceStreak, "Total Keep Captures: " .. KC_G.savedVars.SC.keepsCaptured, "Total Resource Captures: " .. KC_G.savedVars.SC.resourcesCaptured, "Longest Keep Streak: " .. KC_G.savedVars.SC.longestKeepStreak, "Longest Resource Streak: " .. KC_G.savedVars.SC.longestResourceStreak)
 		end
 		if string.lower(extra) == "showcaps" then
 			showSeige = true
 		end
 		if string.lower(extra) == "hidecaps" then
 			showSeige = false
 		end
	end
end

function SC_G.doKStreak()
	if keepStreak > KC_G.savedVars.SC.longestKeepStreak then
		if KC_Fn.CheckSetting("ChatCapStreak") then
			d("New Keep Capture Streak Record!")
		end
		KC_G.savedVars.SC.longestKeepStreak = keepStreak
	end

	if kStreakArray[keepStreak] ~= nil then
		if KC_Fn.CheckSetting("ChatCapStreak") then
			d(kStreakArray[keepStreak] .. " (" .. keepStreak .. " Keeps)")
		end

		if keepStreak < 5 then
			--play sounds
		elseif keepStreak <= 50 then
			--play sounds
		end
		return true
	end
	return false
end

function SC_G.doRStreak()
	if resourceStreak > KC_G.savedVars.SC.longestResourceStreak then
		if KC_Fn.CheckSetting("ChatCapStreak") then
			d("New Resource Capture Streak Record!")
		end
		KC_G.savedVars.SC.longestResourceStreak = resourceStreak
	end

	if rStreakArray[resourceStreak] ~= nil then
		if KC_Fn.CheckSetting("ChatCapStreak") then
			d(rStreakArray[resourceStreak] .. " (" .. resourceStreak .. " Resources)")
		end
		if resourceStreak < 12 then
			--play sounds
		elseif resourceStreak <= 50 then
			--play sounds
		end
		return true
	end
	return false
end

function SC_G.initStreak() 

	--kill streaks
	kStreakArray[2] = "Vanquisher!"
	kStreakArray[3] = "Subjugator!"
	kStreakArray[4] = "Usurper"
	kStreakArray[5] = "Conqueror!"
	kStreakArray[6] = "King Maker!"
	kStreakArray[7] = "Holy Crusader!"
	kStreakArray[8] = "Agent of Akatosh!"




	rStreakArray[2] = "Outlaw!"
	rStreakArray[3] = "Raider!"
	rStreakArray[6] = "Pillager!"
	rStreakArray[9] = "Marauder!"
	rStreakArray[12] = "Plunderer!"
	rStreakArray[18] = "Ravager!"
	rStreakArray[24] = "Viking King!"
end

function SC_G.resetStreaks()
	KC_G.savedVars.SC.keepStreak = 0
	KC_G.savedVars.SC.resourceStreak = 0
end

function SC_G.ResetSeigeStats()
	SC_G.resetStreaks()
	KC_G.savedVars.SC = KC_Fn.table_shallow_copy(KC_G.svDefaults.SC)
end
--control stat fires before capture area status, but capstatus only happens when you are there.


---objective types in OBJECTIVE section of zgoo under other CONSTS
--I think i'm interested in OBJECTIVE_ARTIFACT_OFFENSIVE, OBJECTIVE_CAPTURE_AREA,
--seems for keeps, they  split into two flags, Aspe and Nave yep definitely
--towe keeps like bleakers go Tower and Courtyard
--[[
["SC"] = {
	keepsCaptured = 0,
	resourcesCaptured = 0,
	longestKeepStreak = 0,
	longestResourceStreak = 0

}
--]]