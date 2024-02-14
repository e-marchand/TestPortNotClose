//%attributes = {}

$WITH_BUG:=Not:C34(Shift down:C543)  // change to test with or without bug

If (Not:C34(Asserted:C1132(Is Windows:C1573; "Test if for windows")))
	return 
End if 

WEB START SERVER:C617

If (Not:C34(Asserted:C1132(WEB Is server running:C1313; "cannot test if cannot start http server")))
	return 
End if 


var $androidTools : 4D:C1709.Folder
$androidTools:=Folder:C1567(fk home folder:K87:24).folder("AppData\\Local\\Android\\Sdk\\platform-tools"; fk platform path:K87:2)

If (Not:C34(Asserted:C1132($androidTools.file("adb.exe").exists; "You must install android studio to test it")))
	return 
End if 


var $cmd; $cmdKill; $cmdBg; $in; $out; $err : Text
$cmd:=$androidTools.file("adb.exe").path+" devices"
$cmdKill:=$androidTools.file("adb.exe").platformPath+" kill-server"

var $killWorker : 4D:C1709.SystemWorker
$killWorker:=4D:C1709.SystemWorker.new($cmdKill)  // be sure no daemon to test bug
$killWorker.wait()

If ($WITH_BUG)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	$pid:=LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
Else 
	
	// by launching with background and some option, no more issue
	$cmdBg:="cmd.exe /C START /B "+$cmd
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")  // but cannot get output with that
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	
	$pid:=LAUNCH EXTERNAL PROCESS:C811($cmdBg; $in; $out; $err)
	
	// second command that do no launch the daemon, so no issue and we could get result
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	$pid:=LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
End if 

// TEST

// we try a web server restart
WEB STOP SERVER:C618

While (WEB Is server running:C1313)
	IDLE:C311
End while 

WEB START SERVER:C617  // COULD FAILED here  if child daemon process keep an handle to the socket


// kill for next test
$killWorker:=4D:C1709.SystemWorker.new($cmdKill)
$killWorker.wait()