# FileSaveLaunch
 ###(Winkey + Spacebar) hotkey to open once script/exe file activated
This is a AutoHotKey V1 script & compiled .exe file 
It allows you to select a file from your PC, add a Comment/Note/Description and saves it to a file. 
If you use Winkey + Spacebar hotkey it will open a List of stored files that you can click on to open in the program you hacve designated to open its specific extension. 
eg if you have a .txt file and you've assigned "notepad.exe" as the program to edit that file then when you click on the row of that file it will activate and open it. 

I wrote this as I jump between projects and return to them days/weeks/months later, so being able to add a note about a file or directory is helpful when returning to the project. 

If you do not need to keep the file you can delete it by typing in number at beginning of row after clicking Delete Row button. 

The list displayed reads from the Data file, so you are only seeing a copy of the file. 
You can Edit the file with button at bottom of pop-up. 
For help file go to:
 https://pir2.tk/index.php/files-save-launch/
 
 Depending on file/Folder paths, 
 File extensions you use you can edit the .ini file to create key/value associations of Program files with File extensions 
 such as:
pdf="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat XI Pro.lnk"
txt="notepad.exe"
xlsx="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
xlsm="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
xls="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
jpg="%windir%\system32\mspaint.exe"
gif="%windir%\system32\mspaint.exe"
tif="%windir%\system32\mspaint.exe"
Dir="explorer /select,"
doc="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
docx="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
html="C:\Program Files\Mozilla Firefox\firefox.exe"
ahk="C:\Program Files\AutoHotkey\AutoHotkey.exe"
 
 I hope you find it useful
