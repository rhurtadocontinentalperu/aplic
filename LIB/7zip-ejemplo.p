DEF VAR X AS CHAR.

X = '"C:\Archivos de programa\7-Zip\7z.exe" a c:\tmp\prueba.7z c:\tmp\prueba.*'.

OS-COMMAND 
    SILENT 
    /*NO-CONSOLE */
    VALUE ( X ).
