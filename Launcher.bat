@ECHO OFF
:: Launcher for BLOCCO EDITION of RBXPri
:: 0, independent mode
:: 1, client mode
:: 2, server mode
ECHO [ Official RBXPri Blocco Edition Launcher ]
ECHO.
ECHO [ Choose Mode ]
ECHO Independent Mode:  0
ECHO Client Mode:		1
ECHO Server Mode:		2
ECHO.
SET /P LaunchMode=Choose Mode:		
ECHO.
IF %LaunchMode% == 0 GOTO IND
IF %LaunchMode% == 1 GOTO CLI
IF %LaunchMode% == 2 GOTO SER
EXIT

:IND
ECHO Launching RBXPri (BE) in INDEPENDENT Mode...
PAUSE
RobloxApp.exe -script "dofile('rbxasset://rpui\\main.lua');"
GOTO Done
GOTO::EOF

:CLI
ECHO Launching RBXPri (BE) in CLIENT Mode...
PAUSE
RobloxApp.exe -script "dofile('rbxasset://rpui\\main.lua'); coroutine.resume(coroutine.create(function() dofile('rbxasset://rpui\\client.lua') end));"
GOTO Done
GOTO::EOF

:SER
ECHO Launching RBXPri (BE) in SERVER Mode...
PAUSE
RobloxApp.exe -script "dofile('rbxasset://rpui\\main.lua'); coroutine.resume(coroutine.create(function() dofile('rbxasset://rpui\\server.lua') end));"
GOTO Done
GOTO::EOF
