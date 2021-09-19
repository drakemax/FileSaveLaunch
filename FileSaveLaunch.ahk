/*
AHK script Version 1- You need to be running Version 1 of AHK for this to work. If you have an issue check out Version 2 
Date:
Sunday,September 19, 2021 

By Max Drake 
drakemax@hotmail.com

You're welcome to use as is for whatever purpose 
apart from Global destruction, that wouldn't be nice. 

==========ListView- Joe Glines code========
For Reading file and displaying as ListView I used Joe Glines code (thank you for sharing Joe) from:
https://www.the-automator.com/easily-pushing-delimited-data-into-a-listview-in-autohotkey/
explained in this vid:
https://www.youtube.com/watch?v=XdHqE6v4Ov8


=======================Class_LV_Colors.ahk- AHK-just-me===============================
For alternate colors in ListView thanks to AHK-just-me for Class_LV_Colors.ahk
https://github.com/AHK-just-me/Class_LV_Colors

=========================================================================================


*/
#NoEnv
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%

#Include %A_ScriptDir%\Class_LV_Colors.ahk

;-----------------------Recent Files Macro Global  Variables -----------------------------
; FileList is for Recent Files Macro storing file 
FileList= FileSaveLaunch.txt 
; FileListOut is temp file for Recent Files Macro storing file , copies data less selected linme to delelte
;and then deletes original file and names this original file (filelist)
FileListOut= FileSaveLaunchOut.txt 

; IniFile is for all user inputs for countX, filee extensions and associated programs etc 
IniFile=FileSaveLaunch.ini 


;The header file for the Data file is below if you delete the original
;"#, Name___________________________________________,Desc__________________________________________,Ext_,Date______,Project_,Path__________________________________________________________

; reading Start Folders from Ini file
IniRead, StartFolder4File, %IniFile%,Folder_Locations, StartFolder4File
IniRead, StartFolder4Folder, %IniFile%,Folder_Locations, StartFolder4Folder

;---------TRAY INFO----------
;
;Menu, Tray, NoStandard ; remove default tray menu entries
Menu, Tray, Icon, launch.ico
Menu, Tray, Add ; adds a separator between 
Menu, Tray, Add, Run "FileSaveLaunch" Win+Space, Refresh_Table
Menu, Tray, Add ; 
Menu, Tray, Add, Help for "FileSaveLaunch", FSL_HelpHandler


^#a:: ;select file
Select_File:
  FileSelectFile, SelectedFile, 3, %StartFolder4File%, SELECT FILE TO SAVE ;, Text Documents (*.txt, *.ahk)

  DT= %A_YYYY%-%A_MM%-%A_DD%- 

  splitpath, SelectedFile, FileN
  splitpath, SelectedFile, ,,OutExtension

  IniRead, Countx, %IniFile%,Counter, counter1

  Countx+=1
  ; boxes for input file desc and project code
  InputBox, Desc , %SelectedFolder% , DESCRIPTION
  InputBox, Proj , %SelectedFolder% , PROJECT
  ; concatenate file line number, date, and other file info
  FileToSave =%Countx%,%FileN%,%Desc%,%OutExtension%,%DT%,%Proj%,%SelectedFile%,`n
  ;This appends the information to main file.
  FileAppend, %FileToSave%, %FileList%
  ;updates couter for file /folder number in list
  IniWrite, %Countx%, %IniFile%, Counter, counter1
  goto, Refresh_Table
Return

^#q:: ;select folder
Select_Folder:
  ;Refer to above ^#a for comments 
  FileSelectFolder, SelectedFolder,%StartFolder4Folder%,3,SELECT FOLDER TO SAVE 

  InputBox, Desc , %SelectedFolder%, DESCRIPTION
  InputBox, Proj , %SelectedFolder%, PROJECT 

  IniRead, Countx, %IniFile%,Counter, counter1
  Countx+=1
  DT= %A_YYYY%-%A_MM%-%A_DD%

  splitpath, SelectedFolder, FolderN
  DummyExt=Dir

  FileToSave =%Countx%,%FolderN%,%Desc%,%DummyExt%,%DT%,%Proj%,%SelectedFolder%,`n
  FileAppend, %FileToSave%, %FileList%
  IniWrite, %Countx%, %IniFile%, Counter, counter1
  goto, Refresh_Table
Return

^#d::
Delete_Row:
  ; delete a line (create temp file, writeline to new less one selected, deletes old file and creates new 
  ;file of same name from temp file)
  InputBox, LineNumDel , Which LINE NUMBER CODE to Delete ?
  {
    ; FileAppend, %headr%, %FileListOut%
    Loop, Read, %FileList%
    {
      LineNumber = %A_Index%
      Loop, Parse, A_LoopReadLine, CSV
      {
        var%A_Index% := A_LoopField

      }

      x=%A_LoopReadLine%`n

      IfNotEqual, var1 , %LineNumDel%
      {
        FileAppend, %x%, %FileListOut%
      }

    }
  }
  FileDelete, %FileList%
  FileCopy, %FileListOut%, %FileList% , Overwrite
  FileDelete, %FileListOut%
  goto, Refresh_Table
return

^#s:: ; This edits file (if you want to change project code or desc)
Edit_Data_File:
  IniRead, Program1, %IniFile%,File_Type, txt

  Run, %Program1% "%FileList%" , , UseErrorLevel
  if ErrorLevel = ERROR
    MsgBox Could not launch the "Txt" extension file. Perhaps it is not associated with anything?`nPATH:"%FileList%"
return

Edit_Ini_File:
  IniRead, Program1, %IniFile%,File_Type, txt

  Run, %Program1% "%IniFile%" , , UseErrorLevel
  if ErrorLevel = ERROR
    MsgBox Could not launch the "Txt" extension file. Perhaps it is not associated with anything?`nPATH:"%FileList%"
return

FSL_HelpHandler:
  Run, https://pir2.tk/index.php/files-save-launch/
Return


; --------------RUNNING SCRIPT------------

#Space:: ; hotkey to run 
Refresh_Table:

  ; THIS CALLS FUNCTION
  LV_Table(FileList,",",1,Title:="Files & Folders- Save & Launch- 'WinKey+Spacebar'") ;comma on variable

  ; THIS IS FUNCTION

  LV_Table(Data_Source, delimiter="`t",UseHeader=1,Title=""){ ; default delimiter set to ,

    ;--------LOCAL VARIABLES------------
    global IniFile ;function calls global variable (https://autohotkey.com/board/topic/71814-global-variable-use-in-functions/)
    IniRead, Col_Width, %IniFile%,Table_Width, Col_Width
    IniRead, Txt_Ht, %IniFile%,Gui_Text_Height, Txt_Ht
    IniRead, Button_Width, %IniFile%,Gui_Text_Height, Button_Width
    IniRead, Gui_Colour, %IniFile%,Gui_Table_Colour, Gui_Colour

    colrB= %Gui_Colour% ;0xFFA500 ; 160042 NavyBlue, 6e57d2 purple, FFA500 orange
    colrT=0xFFFFFF ; white

    ;--------LOCAL VARIABLES------------
    if FileExist(Data_Source) ;if file exists use it as source
      FileRead, Data_Source, %Data_Source% ;read in and store as variable

    ;***********parse the data in variable and store in object*******************
    data_obj := StrSplit(Data_Source,"`n","`r") ;parse earch row and store in object
    rowHeader:=StrReplace(data_obj.RemoveAt(1),Delimiter,"|",Numb_Columns) ; Remove header from Object and convert to pipe delimited
    if (useHeader=0){
      loop, % Numb_Columns+1
        RH.="Col_" A_Index "|"
      rowHeader:=RH
    }

    dRows:= (data_obj.MaxIndex() >27) ? 26 : data_obj.MaxIndex()+1 ;if rows >27 use 26 else use # of rows

    ;----------GUI Layout----------
    ;select file, select folder, delete row

    Gui, Table_View: New,,%Title% ;create new gui window and set title
    Gui, Font, %Txt_Ht% ; height for text font (set in ini file)

    Gui, Color, Black ; background colour
    Gui, Add, Text,cWhite , Click on row to select and activate File/Folder, or use button at bottom to select a new file/folder to add to list or Delete a row

    Gui, Add, ListView, w%Col_Width% r%dRows% grid gQuickBox hwndHLV, % rowHeader ;set headers
    For Each, Row In data_obj ;add the data lines to the ListView
      LV_Add("", StrSplit(Row, Delimiter)*) ;LV_Add is a variadic function

    ; Create a new instance of LV_Colors
    CLV := New LV_Colors(HLV, False, False, False)
    ; Set the colors for selected rows
    ;CLV.SelectionColors(0xF0F0F0)
    CLV.AlternateRows(colrB,colrT) ;(0x160042, 0xFFFFFF) ;(colrB,colrT) ;(0x160042, 0xFFFFFF) ;(colrB, colrT) (Background Col, Text Col)- Gray, white0xFFFFFF,0x808080 Blue-0x160042 , yellow: 0xfef65b 0xFFFFFF,0x808080 0xfef65b
    If !IsObject(CLV) {
      MsgBox, 0, ERROR, Couldn't create a new LV_Colors object!
      ExitApp
    }

    Gui, Add, Button, Default %Button_Width% gSelect_File, Select FILE ;rowHeader+100 y10
    Gui, Add, Button, x+20 %Button_Width% gSelect_Folder, Select FOLDER ;rowHeader+200 y10
    Gui, Add, Button, x+20 %Button_Width% gDelete_Row, Delete Row #
    Gui, Add, Button, x+20 %Button_Width% gEdit_Data_File, Edit Data File
    Gui, Add, Button, x+20 %Button_Width% gEdit_Ini_File, Edit Ini File
    Gui, Add, Button, x+20 %Button_Width% gGuiEscape, Close Table
    Gui, Add, Button, x+40 %Button_Width% gExit, Exit App

    Gui, Table_View:Show
    WinSet, Redraw, , ahk_id %HLV%
  }

QuickBox:
  if A_GuiEvent <> DoubleClick
    return
  GuiControlGet, QuickBox ;Retrieve the ListBox's current selection.
  LV_GetText(ExtType, A_EventInfo,4)
  LV_GetText(FPath, A_EventInfo, 7)

  /*
 splitpath, ProgName, FileN
  */

  IniRead, Program1, %IniFile%,File_Type, %ExtType%
  ;Msg box used to check that programs work - comment out later

  ;msgbox, %ExtType% %FileN% %Program1% %FPath% 

  Run, %Program1% "%FPath%" , , UseErrorLevel
  if ErrorLevel = ERROR
    MsgBox Could not launch the %ExtType% extension file. Perhaps it is not associated with anything?`nPATH:"%FPath%"

  Gui, Destroy
return

^#x::Reload ; Reload script with Ctrl+Win+x

GuiClose:
GuiEscape:
  Gui, Destroy

return
Exit:
ExitApp
