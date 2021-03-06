
say "Processing your request. Please wait" using "Victoria"
do shell script "cd /Users/yen/Pictures/;rm test.jpg"

activate application "Photo Booth"
delay 2
tell application "System Events" to tell process "Photo Booth"
	keystroke "t" using {command down, option down}
	keystroke "1" using {command down}
	click menu item "Export..." of menu 1 of menu bar item "File" of menu bar 1
	delay 2
	keystroke "test"
	delay 1
	key code 36 # Hit enter
end tell
delay 2
quit application "Photo Booth"

tell application "Mail"
	
	set theSubject to "Test Subject" -- the subject
	set theContent to "Test Content" -- the content
	set theAddress to "EMAILADDRESS" -- the receiver 
	set theSignatureName to "signature_name" -- the signature name
	set theAttachmentFile to "Macintosh HD:Users:yen:Pictures:test.jpg" -- the attachment path
	set msg to make new outgoing message with properties {subject:theSubject, content:theContent, visible:true}
	tell msg to make new to recipient at end of every to recipient with properties {address:theAddress}
	tell msg to make new attachment with properties {file name:theAttachmentFile as alias}
	
	
	send msg
end tell

--delay 5

-- Starts Facetime Session
do shell script "open facetime://PHONENUMBER"
tell application "System Events"
	repeat while not (button "Call" of window 1 of application process "FaceTime" exists)
		delay 1
	end repeat
	click button "Call" of window 1 of application process "FaceTime"
end tell

-- Check to see if Facetime is active
tell application "System Events" to set theCount to the count of (processes whose name is "Facetime")
if theCount = 0 then
	do shell script "sleep 1"
else
	tell application "FaceTime" to activate
	-- starts automator script to take picture and email it
end if

-- Starts Video capture
tell application "QuickTime Player"
	try
		activate
		new movie recording
		document "Movie Recording" start
		do shell script "sleep 5"
		
		set status to true
		
		repeat until status = false
			-- sets how long facetime will ring your phone (30 secs)
			delay 5 -- if call is active wait 60 seconds before rechecking
			--3600 is 1 hour, 1800 =1/2 hour, 60 =1 min, 300 =5 mins
			--add 300 (5 mins) ahead/behind starting
			
			-- Check to see if call is still active
			
			tell application "FaceTime" to activate
			tell application "System Events" to tell process "FaceTime"
				if name of front window contains "not available" then
					do shell script "sleep 1"
					set status to false
					
				else
					
					-- Check to see if call is still active
					
					tell application "FaceTime" to activate
					tell application "System Events" to tell process "FaceTime"
						if name of front window contains "with" then
							set status to true
							do shell script "sleep 5"
							
							-- Check to see if call is still active
							
						else
							-- Quit Facetime / video recording if call is not active
							tell application "System Events" to tell process "FaceTime"
								if name of front window contains "facetime" then
									set status to false
									tell application "FaceTime" to quit
									do shell script "sleep 1"
									tell application "QuickTime Player"
										document "Movie Recording" stop
										
									end tell
									
									
									set date_ to ((current date) as string)
									set the clipboard to the date_
									
									tell application "System Events"
										tell process "QuickTime Player"
											keystroke "s" using {command down} # that you want to save whatever document was being recorded.
											delay 1 # Wait for the Save As sheet to appear.
											keystroke "v" using {command down}
											delay 3 # Wait for the paste to happen corrctly.
											key code 36 # Hit enter			
											delay 0.5 # Wait for the "Go" sheet
											key code 36 # Hit enter
											delay 10 #wait for export    # Wait for export to complete exporting movie.
											
										end tell
									end tell
									
									
								end if
							end tell
						end if
					end tell
				end if
			end tell
		end repeat
	end try
end tell
end
end
end
