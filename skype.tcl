package require tcom
package require fileutil
set skype [::tcom::ref createobject Skype4COM.skype]
if { [[$skype Client] IsRunning] == 0 } {[$skype Client] Start}
$skype Attach
::tcom::bind $skype eventHandler

proc eventHandler args {
	set event [lindex $args 0]
	set handle [lindex $args 1]
	set status [lindex $args 2]
	if { $event == "MessageStatus" && $status == 1 || $status == 2 } {
		set msg "[clock format [clock second] -format %Y%m%dT%H:%M:%S] [$handle FromDisplayName]\([$handle FromHandle]\):[$handle Body]\n"
		::fileutil::appendToFile skype.log "$msg"
	}
}

proc sendMessage {message} {
	set chat [[$::skype ActiveChats] Item 1]
	$chat SendMessage $message
}