!include "MUI.nsh"

!define VERSION 0.6.1
!define PROJECT_NAME PianoGame

Name "${PROJECT_NAME} ${VERSION}"
OutFile "${PROJECT_NAME}-${VERSION}-installer.exe"
InstallDir "$PROGRAMFILES\${PROJECT_NAME}"
BrandingText " "

!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_SMALLDESC 

!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
  
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM SOFTWARE\${PROJECT_NAME} "Install_Dir"

ComponentText "This will install ${PROJECT_NAME} ${VERSION} to your computer."
DirText "Choose a directory to install in to:"



Section "!${PROJECT_NAME}" main_application
SectionIn RO
  SetOutPath $INSTDIR

  File "Release\${PROJECT_NAME}.exe"
  File "readme.txt"
  File "license.txt"

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\${PROJECT_NAME} "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROJECT_NAME}" "DisplayName" "${PROJECT_NAME} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROJECT_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"
SectionEnd



Section "Start Menu Shortcuts" ShortcutMenu
  CreateDirectory "$SMPROGRAMS\${PROJECT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PROJECT_NAME}\Play ${PROJECT_NAME}.lnk" "$INSTDIR\${PROJECT_NAME}.exe" "" "$INSTDIR\${PROJECT_NAME}.exe" 0
  CreateShortCut "$SMPROGRAMS\${PROJECT_NAME}\View Readme.lnk" "$INSTDIR\readme.txt"
  CreateShortCut "$SMPROGRAMS\${PROJECT_NAME}\View License.lnk" "$INSTDIR\license.txt"
  CreateShortCut "$SMPROGRAMS\${PROJECT_NAME}\Visit the ${PROJECT_NAME} Website.lnk" "http://www.synthesiagame.com/"
  CreateShortCut "$SMPROGRAMS\${PROJECT_NAME}\Uninstall ${PROJECT_NAME}.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
SectionEnd



Section "Right-click Association" Association
  WriteRegStr HKCR "MIDFile\shell\Play in ${PROJECT_NAME}\command" "" "$\"$INSTDIR\${PROJECT_NAME}.exe$\" $\"%1$\""
SectionEnd



Section /o "Desktop Icon" DesktopIcon
  CreateShortCut "$DESKTOP\Play ${PROJECT_NAME}.lnk" "$INSTDIR\${PROJECT_NAME}.exe" "" "$INSTDIR\${PROJECT_NAME}.exe" 0
SectionEnd



UninstallText "This will uninstall ${PROJECT_NAME} ${VERSION}. Click next to continue."
Section "Uninstall"

  ; remove registry keys
  ;
  ; NOTE: this intentionally leaves the "Install_Dir"
  ; entry in HKLM\SOFTWARE\[program-name] in the event of
  ; subsequent reinstalls/upgrades
  ;
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROJECT_NAME}"
  DeleteRegKey HKCU "SOFTWARE\${PROJECT_NAME}"

  ; delete program files
  Delete $INSTDIR\readme.txt
  Delete $INSTDIR\license.txt
  Delete $INSTDIR\uninstall.exe
  Delete "$INSTDIR\${PROJECT_NAME}.exe"
  RMDir /r "$INSTDIR"

  ; this won't delete the directory if the user has added anything
  RMDir  "$DOCUMENTS\${PROJECT_NAME} Music"

  ; remove Start Menu shortcuts
  Delete "$SMPROGRAMS\${PROJECT_NAME}\*.*"
  RMDir "$SMPROGRAMS\${PROJECT_NAME}"

  ; remove Desktop shortcut
  Delete "$DESKTOP\Play ${PROJECT_NAME}.lnk"

  ; remove File Association
  DeleteRegKey HKCR "MIDFile\shell\Play in ${PROJECT_NAME}"

SectionEnd




LangString DESC_main_application ${LANG_ENGLISH} "Install the ${PROJECT_NAME} application files (required)."
LangString DESC_ShortcutMenu ${LANG_ENGLISH} "Create a ${PROJECT_NAME} start menu group on the 'All Programs' section of your start menu."
LangString DESC_Association ${LANG_ENGLISH} "Add a right-click 'Play in ${PROJECT_NAME}' file association to MIDI files."
LangString DESC_DesktopIcon ${LANG_ENGLISH} "Create a ${PROJECT_NAME} icon on your Windows Desktop."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${main_application} $(DESC_main_application)
  !insertmacro MUI_DESCRIPTION_TEXT ${ShortcutMenu} $(DESC_ShortcutMenu)
  !insertmacro MUI_DESCRIPTION_TEXT ${Association} $(DESC_Association)
  !insertmacro MUI_DESCRIPTION_TEXT ${DesktopIcon} $(DESC_DesktopIcon)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
