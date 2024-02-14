# TestPortNotClose

Some code to have issue to start web server (with an already binded port) on windows

## daemon setup

To test, we need a daemon process, that keep some socket handle I suppose, like "adb.exe" found in android platform tools

To install it we could install https://developer.android.com/studio

then the tool must be in "%userprofile%\AppData\Local\Android\Sdk\platform-tools\adb.exe" (if not maybe launch android studio and try to make an app or allow to install android sdk)

## the test

So launch the [test.4dm](Project/Sources/Methods/test.4dm) method to see the bug : web server cannot be restarted until adb.exe process is killed

even if we restart 4D, the daemon adb.exe remain and keep some ref to the handle, and the port is binded on a no more existing 4D process(not adb), we could see it with TcpView.exe

## workaround

Maintain shift down when launching the same method to execute a possible workaround (possible in this case, where output doesn't matter)

by launching on background with cmd start /b and with no blocking process, daemon is launched and do not keep handle

## other daemons

I could reproduce with other daemon like gradle java.exe process
