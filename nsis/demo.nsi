﻿; Unicode is not enabled by default.
Unicode true
!include "MUI2.nsh"

; The version value is updated in script
!define DEMO_VERSION 1.0.0

;;;General
Name "nwjsDemo"
OutFile "..\dist\nwjsDemo_${DEMO_VERSION}_安装包.exe"
; Icons
!define MUI_ICON "demo.ico"

;Default installation folder
InstallDir "$LOCALAPPDATA\nwjs-demo"

;Request application privileges for Windows Vista
RequestExecutionLevel user

;;;Interface Settings
!define MUI_ABORTWARNING

;;;Pages
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "SimpChinese"

;;; Languages
;LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
VIProductVersion "${DEMO_VERSION}.0"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductName" "nwjs-demo"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "Comments" "nwjs-demo"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "CompanyName" "lorry ltd"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalCopyright" "Copyright (c) 2015-2019 Lorry"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileDescription" "nwjs-demo客户端"
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileVersion" "${DEMO_VERSION}"

;;;Installer Section
Section "Install Section" InstallSection
  SetOutPath "$INSTDIR"

  ;Put files
  ;自有格式
  File jlr.ico
  File demo.ico
  File demo_tab.png
  ;File /r demo/*
  File /r ..\dist\nwjs-demo-${DEMO_VERSION}-win-x86\*

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"

  ;;Write registry
  ;Save installation path
  WriteRegStr HKCU SOFTWARE\demo "InstallDir" "$INSTDIR"

  ;Write uninstall keys
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "DisplayName" "nwjs-demo"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "UninstallString" "$INSTDIR\uninst.exe"

  ;Associate jlr file format 自有格式
  ;First delete any existing file extension bindings.
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jlr"
  WriteRegStr HKCU "Software\Classes\.jlr" "" "JLRFile"
  WriteRegStr HKCU "Software\Classes\JLRFile\shell\open\command" "" "$\"$INSTDIR\nwjs-demo.exe$\" $\"%1$\""
  WriteRegStr HKCU "Software\Classes\JLRFile\DefaultIcon" "" "$INSTDIR\jlr.ico,0"

SectionEnd

Section "Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\nwjs-demo"
  CreateShortcut "$SMPROGRAMS\demo\nwjs-demo.lnk" "$INSTDIR\nwjs-demo.exe" "" "$INSTDIR\nwjs-demo.exe" 0
  CreateShortcut "$SMPROGRAMS\demo\uninst.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0

  ; Also create desktop shortcut.
  CreateShortCut "$desktop\nwjs-demo.lnk" "$INSTDIR\nwjs-demo.exe" "" "$INSTDIR\nwjs-demo.exe" 0
SectionEnd

Section "Finish Installation" FinishInstall
  ExecShell "" "$INSTDIR\nwjs-demo.exe"
  SetAutoClose true
SectionEnd

;;;Uninstaller Section
Section "Uninstall"
  ;Delete program folder
  RMDIR /r "$INSTDIR"

  ;Delete shortcut in startup menu
  Delete "$SMPROGRAMS\nwjs-demo.lnk"
  Delete "$SMPROGRAMS\uninst.lnk"
  RMDIR "$SMPROGRAMS\nwjs-demo"
  Delete "$desktop\nwjs-demo.lnk"

  ;Cleanup registry
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "DisplayName"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "UninstallString"
  DeleteRegValue HKCU SOFTWARE\demo "InstallDir"

  ;Unregister file association
  ;${unregisterExtension} ".jlr" "jlr Format"
  DeleteRegKey HKCU "Software\Classes\.jlr"
  DeleteRegKey HKCU "Software\Classes\JLRFile\shjell\open\command"

SectionEnd
