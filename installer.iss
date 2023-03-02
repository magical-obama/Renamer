; -- installer.iss --
; Installer for the Renamer Tool

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
SignTool=signtool
AppName=Renamer
AppVersion=1.0
WizardStyle=modern
DefaultDirName={autopf}\Renamer
DefaultGroupName=Renamer
UninstallDisplayIcon={app}\Renamer.exe
Compression=lzma2
SolidCompression=yes
OutputDir=.
SourceDir=installer-files
OutputBaseFilename="Renamer Installer"

[Files]
Source: "Renamer.*"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "README.txt"; DestDir: "{app}"; Flags: isreadme

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