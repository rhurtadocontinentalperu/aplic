/* Acelera la descargar a Excel */
chExcelApplication:ScreenUpdating = YES.

IF lNuevoFile = YES THEN DO:
    /*chExcelApplication:Visible = TRUE.*/
    IF lFIleXls <> "" THEN DO:
	    chExcelApplication:DisplayAlerts = False.
	    chWorkSheet:SaveAs(lFIleXls).
    END.    
END.
ELSE DO:	
    /*
	chExcelApplication:DisplayAlerts = False.
	chExcelApplication:Quit().
    */
END.
IF lCerrarAlTerminar = NO THEN DO:
    chExcelApplication:Visible = TRUE.
END.
ELSE DO:
    chExcelApplication:Visible = FALSE.
    chExcelApplication:Quit().
END.

    
/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

IF lMensajeAlTerminar = YES THEN DO:
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

