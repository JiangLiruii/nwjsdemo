; Unicode is not enabled by default.
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
 VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductVersion" "${DEMO_VERSION}.0";版本号

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
  ;定义卸载路径变量
  !define UNINST "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo"

  ;Write uninstall keys, 这里是显示在控制面板的卸载程序里.
  WriteRegStr HKCU UNINST "DisplayName" "nwjs-demo" ;应用名
  WriteRegStr HKCU UNINST "UninstallString" "$INSTDIR\uninst.exe";卸载程序位置
  WriteRegStr HKCU UNINST "ProductVersion" "${DEMO_VERSION}.0";版本号
  WriteRegStr HKCU UNINST "DisplayIcon" "$INSTDIR\ jlr.ico";icon
  WriteRegStr HKCU UNINST "Publisher" " 蒋礼锐";开发者

  ;Associate jlr file format 自有格式
  ;First delete any existing file extension bindings.
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jlr";
  WriteRegStr HKCU "Software\Classes\.jlr" "" "JLRFile"
  WriteRegStr HKCU "Software\Classes\JLRFile\shell\open\command" "" "$\"$INSTDIR\nwjs-demo.exe$\" $\"%1$\""
  WriteRegStr HKCU "Software\Classes\JLRFile\DefaultIcon" "" "$INSTDIR\jlr.ico,0"; 显示 icon

SectionEnd

Section "Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\nwjs-demo"
  CreateShortcut "$SMPROGRAMS\nwjs-demo\nwjs-demo.lnk" "$INSTDIR\nwjs-demo.exe" "" "$INSTDIR\nwjs-demo.exe" 0
  CreateShortcut "$SMPROGRAMS\nwjs-demo\uninst.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0

  ; Also create desktop shortcut.
  CreateShortCut "$desktop\nwjs-demo.lnk" "$INSTDIR\nwjs-demo.exe" "" "$INSTDIR\nwjs-demo.exe" 0
SectionEnd

Section "Finish Installation" FinishInstall
  ExecShell "" "$INSTDIR\nwjs-demo.exe";完成之后自动打开应用
  SetAutoClose true;是否自动关闭
SectionEnd

;;;Uninstaller Section
Section "Uninstall"
  ;Delete program folder
  RMDIR /r "$INSTDIR"

  ;Delete shortcut in startup menu
  Delete "$SMPROGRAMS\nwjs-demo\nwjs-demo.lnk";要全部删除应用程序和卸载程序的快捷方式才能移除掉文件夹
  Delete "$SMPROGRAMS\nwjs-demo\uninst.lnk"
  RMDIR "$SMPROGRAMS\nwjs-demo";移除文件夹
  Delete "$desktop\nwjs-demo.lnk";移除桌面快捷方式

  ;Cleanup registry
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "DisplayName"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\demo" "UninstallString"
  DeleteRegValue HKCU SOFTWARE\demo "InstallDir"

  ;Unregister file association
  ;${unregisterExtension} ".jlr" "jlr Format"
  DeleteRegKey HKCU "Software\Classes\.jlr"
  DeleteRegKey HKCU "Software\Classes\JLRFile\shjell\open\command"

SectionEnd
