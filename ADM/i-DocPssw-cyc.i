&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

FIND gn-DocPssw WHERE
    gn-DocPssw.CodCia = {1} AND
    gn-DocPssw.CodDoc = {2}
    NO-LOCK NO-ERROR.
PASSWORD:
DO:
IF AVAILABLE gn-DocPssw THEN DO
    ON ERROR UNDO, RETURN "ADM-ERROR"
    ON ENDKEY UNDO, RETURN "ADM-ERROR":
    /* Verificamos si tiene una clave registrada */
    CASE {3}:
        WHEN "ADD" THEN IF gn-docpssw.PsswCreate = '' THEN LEAVE PASSWORD.
        WHEN "UPD" THEN IF gn-docpssw.PsswUpdate = '' THEN LEAVE PASSWORD.
        WHEN "DEL" THEN IF gn-docpssw.PsswDelete = '' THEN LEAVE PASSWORD.
    END CASE.

    clave-cyc = "".
    /*
    UPDATE
        SKIP(.5)
        "E/C cuenta con cierre de caja. La anulacion" SKIP
        "solamente puede ser procesada por contraloria" SKIP 
        SKIP
        SPACE(2)
        clave-cyc PASSWORD-FIELD
        SPACE(2)
        SKIP(.5)
        WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
        SIDE-LABEL TITLE "Ingrese Clave".
    */
    UPDATE
        " "
        SKIP
        "E/C cuenta con cierre de caja, solamente" SKIP
        "puede ser procesada por contraloria" SKIP
        SKIP
        " "
        clave-cyc PASSWORD-FIELD
        SKIP
        " "       
        WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
        SIDE-LABEL TITLE "Ingrese Clave".


    CASE {3}:
        WHEN "ADD" THEN DO:
            IF gn-docpssw.PsswCreate <> clave-cyc THEN DO:
                MESSAGE
                    "CLAVE DE CREACION INCORRECTA"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
        WHEN "UPD" THEN DO:
            IF gn-docpssw.PsswUpdate <> clave-cyc THEN DO:
                MESSAGE
                    "CLAVE DE MODIFICACION INCORRECTA"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
        WHEN "DEL" THEN DO:
            IF gn-docpssw.PsswDelete <> clave-cyc THEN DO:
                MESSAGE
                    "CLAVE DE ELIMINACION INCORRECTA"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
    END CASE.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


