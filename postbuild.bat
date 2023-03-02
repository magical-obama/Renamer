if %2==Release (
	copy %1%Renamer.exe .\installer-files\Renamer.exe
	copy %1%Renamer.dll .\installer-files\Renamer.dll
	copy %1%Renamer.runtimeconfig.json .\installer-files\Renamer.runtimeconfig.json
)