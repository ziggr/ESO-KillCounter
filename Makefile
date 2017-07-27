.PHONY: put get zip

put:
	cp -f ./KillCounter*.lua /Volumes/Elder\ Scrolls\ Online/live/AddOns/KillCounter/
	cp -f ./KillCounter.txt  /Volumes/Elder\ Scrolls\ Online/live/AddOns/KillCounter/
	cp -f ./*.xml            /Volumes/Elder\ Scrolls\ Online/live/AddOns/KillCounter/
	cp -f lib/*.lua          /Volumes/Elder\ Scrolls\ Online/live/AddOns/KillCounter/lib/

get:
	cp -f /Volumes/Elder\ Scrolls\ Online/live/SavedVariables/KillCounter.lua ../../SavedVariables/
	cp -f ../../SavedVariables/KillCounter.lua data/

zip:
	-rm -rf    published/KillCounter published/KillCounter\ x.x.x.zip
	mkdir -p   published/KillCounter
	cp -R libs published/KillCounter/libs
	cp ./KillCounter* bindings.xml keepcounter.lua readme.txt published/KillCounter/
	cd published; zip -r KillCounter\ x.x.x.zip KillCounter

