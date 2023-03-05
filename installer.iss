; -- installer.iss --
; Installer for the Renamer Tool

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
SignTool=signtool
AppName=Renamer
AppPublisher=Maximilian Schwärzler
ArchitecturesAllowed=x64
SetupIconFile=icon.ico
AppVersion=1.2
WizardStyle=modern
DefaultDirName={autopf}\Renamer
DefaultGroupName=Renamer
UninstallDisplayIcon={app}\Renamer.exe
Compression=lzma2
SolidCompression=yes
OutputDir=.
SourceDir=installer-files
OutputBaseFilename="Renamer Installer v{#SetupSetting("AppVersion")}"

[Files]
Source: "Renamer.exe"; DestDir: "{app}"; Flags: sign
Source: "Renamer.dll"; DestDir: "{app}"; Flags: onlyifdoesntexist sign
Source: "Renamer.runtimeconfig.json"; DestDir: "{app}"
Source: "README.txt"; DestDir: "{app}"; Flags: isreadme
Source: "dotnet-runtime-6.0.14-win-x64.exe"; DestDir: "{tmp}"

; [Icons]
; Name: "{group}\Renamer"; Filename: "{app}\Renamer.exe"

[Registry]
; Create reg key for directory context menu
Root: HKCR; Subkey: "Directory\shell\Renamer"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\Renamer"; ValueType: string; ValueData: "Rename all Office docs in the folder"
Root: HKCR; Subkey: "Directory\shell\Renamer"; ValueType: string; ValueName: "icon"; ValueData: """{app}\Renamer.exe"""
Root: HKCR; Subkey: "Directory\shell\Renamer\command"; ValueType: string; ValueData: """{app}\Renamer.exe"" ""%V"""

; Create reg key for file context menu
Root: HKCR; Subkey: "*\shell\Renamer"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\Renamer"; ValueType: string; ValueData: "Rename this Office doc"
Root: HKCR; Subkey: "*\shell\Renamer"; ValueType: string; ValueName: "icon"; ValueData: """{app}\Renamer.exe"""
Root: HKCR; Subkey: "*\shell\Renamer\command"; ValueType: string; ValueData: """{app}\Renamer.exe"" ""%1"""

[Run]
Filename: "{tmp}\dotnet-runtime-6.0.14-win-x64.exe"; Parameters: "/quiet"