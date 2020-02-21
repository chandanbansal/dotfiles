-- Credits http://www.jamierubin.net/2014/08/12/going-paperless-how-and-why-ive-automated-backups-of-my-evernote-data/
-- PURPOSE: Export all notes in Evernote to an ENEX file so that
-- the notes can be backed up to an external drive or to the cloud

-- Please note: For this script to work properly, 
-- you must use the version of Evernote downloaded from the Evernote website. 
-- The version of Evernote from the app store will not work correctly with this script 
-- because of the way the app is sandboxed.

set curDate to do shell script "date +'%Y%m%d'"

-- Change the path below to the location you want the notes to be exported
set exportPath to "/Users/chandan.bansal/Dropbox/daily_files/Notes/Evernote-" & curDate & "/"

do shell script "if [ ! -e " & exportPath & " ]; then mkdir " & exportPath & "; fi;"

with timeout of (30 * 60) seconds
	tell application "Evernote"
		repeat with nb in every notebook of application "Evernote"
			set theName to the name of nb
			
			set matches to find notes "notebook:" & "\"" & theName & "\""
			set f to exportPath & theName & "-" & curDate & ".enex"
			export matches to f
			if (count of matches) > 0 then
				set p to POSIX path of f
				
				do shell script "/usr/bin/gzip -f " & quoted form of p
				
			end if
		end repeat
	end tell
end timeout