-- Homebrew must be on PATH for Apple Silicon (/opt/homebrew) or Intel (/usr/local).
property brewPathEnv : "export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH; "

on caskUpdateStatus()
	try
		set s to do shell script brewPathEnv & "if ! command -v brew >/dev/null 2>&1; then echo 'no_brew'; " & "elif ! brew list --cask ungoogled-chromium >/dev/null 2>&1; then echo 'not_installed'; " & "elif brew outdated --cask ungoogled-chromium 2>/dev/null | grep -q '^ungoogled-chromium'; then echo 'outdated'; " & "else echo 'current'; fi"
		return s
	on error errMsg
		return "error:" & errMsg
	end try
end caskUpdateStatus

on outdatedDetail()
	try
		return do shell script brewPathEnv & "brew outdated --cask ungoogled-chromium 2>/dev/null"
	on error
		return ""
	end try
end outdatedDetail

-- Installed version as Homebrew reports it (keeps prompts/notifications aligned with brew outdated).
on installedCaskVersion()
	try
		return do shell script brewPathEnv & "brew list --cask --versions ungoogled-chromium 2>/dev/null | awk '{print $2}'"
	on error
		return ""
	end try
end installedCaskVersion

on upgradeChromium()
	display notification "Updating Ungoogled-Chromium via Homebrew…" with title "Ungoogled-Chromium Updater"
	try
		do shell script brewPathEnv & "brew upgrade --cask ungoogled-chromium"
		display notification "Ungoogled-Chromium updated successfully." with title "Ungoogled-Chromium Updater"
	on error errMsg
		display dialog "Homebrew update failed:" & return & return & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end upgradeChromium

on installCask()
	display notification "Installing Ungoogled-Chromium via Homebrew…" with title "Ungoogled-Chromium Updater"
	try
		do shell script brewPathEnv & "brew install --cask ungoogled-chromium"
		display notification "Ungoogled-Chromium installed successfully." with title "Ungoogled-Chromium Updater"
	on error errMsg
		display dialog "Homebrew install failed:" & return & return & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end installCask

-- Main
set status to caskUpdateStatus()
if status is "no_brew" then
	display dialog "Homebrew is not installed or not in PATH. Install it from https://brew.sh and try again." buttons {"OK"} default button "OK" with icon stop
	return
end if

if status starts with "error:" then
	display dialog status buttons {"OK"} default button "OK" with icon stop
	return
end if

if status is "current" then
	set ver to installedCaskVersion()
	if ver is not "" then
		display notification "Ungoogled-Chromium is up to date (" & ver & ", Homebrew cask)." with title "Ungoogled-Chromium Updater"
	else
		display notification "Ungoogled-Chromium cask is up to date." with title "Ungoogled-Chromium Updater"
	end if
	return
end if

if status is "not_installed" then
	try
		set userChoice to button returned of (display dialog "Ungoogled-Chromium is not installed via Homebrew (cask ungoogled-chromium). Install it now?" buttons {"Cancel", "Install"} default button "Install" with icon note giving up after 3600)
		if userChoice is "Install" then
			installCask()
		end if
	on error number -128
		display notification "Install cancelled" with title "Ungoogled-Chromium Updater"
	end try
	return
end if

if status is "outdated" then
	set detail to outdatedDetail()
	try
		set dlgMsg to "A new version of Ungoogled-Chromium is available via Homebrew."
		if detail is not "" then
			set dlgMsg to dlgMsg & return & return & detail
		end if
		set dlgMsg to dlgMsg & return & return & "This will run: brew upgrade --cask ungoogled-chromium"
		set userChoice to button returned of (display dialog dlgMsg buttons {"Later", "Update"} default button "Update" with icon note giving up after 3600)
		
		if userChoice is "Update" then
			upgradeChromium()
		else
			display notification "Update postponed" with title "Ungoogled-Chromium Updater"
		end if
		
	on error number -128
		display notification "Update postponed" with title "Ungoogled-Chromium Updater"
	end try
end if
