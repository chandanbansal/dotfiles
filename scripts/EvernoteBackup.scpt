-- Credits http://www.jamierubin.net/2014/08/12/going-paperless-how-and-why-ive-automated-backups-of-my-evernote-data/
-- PURPOSE: Export all notes in Evernote to an ENEX(XML) file so that
-- the notes can be backed up to an external drive or to the cloud

-- Please note: For this script to work properly, 
-- you must use the version of Evernote downloaded from the Evernote website. 
-- The version of Evernote from the app store will not work correctly with this script 
-- because of the way the app is sandboxed.


-- path of the location where the notes to be exported, some how relative path was not working
set f to "/Users/chandan.bansal/Dropbox/daily files/Notes/Export.enex"

with timeout of (30 * 60) seconds
	tell application "Evernote"
		-- Set date to 1990 so it finds all notes
		set matches to find notes "created:19900101"
		-- export to file set above
		export matches to f
	end tell
end timeout

-- Compress the file so that there is less to backup to the cloud
set p to POSIX path of f
do shell script "/usr/bin/gzip " & quoted form of p