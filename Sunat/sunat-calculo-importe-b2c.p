&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN procesar.
 
QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-procesar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar Procedure 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.    
DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

DISPLAY "Iniciandoooo".
    
RUN sunat\sunat-calculo-importes.p PERSISTENT SET hProc.            

DEFINE BUFFER b-OpenVentas FOR OpenVentas.

DISABLE TRIGGERS FOR LOAD OF faccpedi.
DISABLE TRIGGERS FOR LOAD OF facdpedi.
            
FOR EACH OpenVentas WHERE OpenVentas.codcia = 1 AND 
                            OpenVentas.flagmigracion = 'P' NO-LOCK:

    /* Procedimientos */
    RUN tabla-faccpedi IN hProc (INPUT OpenVentas.coddiv, 
                                 INPUT OpenVentas.coddoc, 
                                 INPUT OpenVentas.nrodoc,
                                OUTPUT x-RetVal).       
    DISPLAY "VALOR RETORNO " + nrodoc + " " + x-RetVal FORMAT 'x(60)'.            

    FIND FIRST b-OpenVentas WHERE ROWID(b-OpenVentas) = ROWID(OpenVentas) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-OpenVentas THEN DO:
        ASSIGN b-OpenVentas.glosa = x-retval
                b-OpenVentas.flagfechahora = TODAY
                b-OpenVentas.flagusuario = 'BATCH'.
        IF x-retval = 'OK' THEN DO:
            ASSIGN b-OpenVentas.flagmigracion = 'C'.
        END.
        ELSE DO:
            ASSIGN b-OpenVentas.flagmigracion = 'X'.
        END.
    END.

END.

RELEASE b-OpenVentas.

DELETE PROCEDURE hProc.                     /* Release Libreria */            

DISPLAY "FIN.....".

END PROCEDURE.

/*
        ASSIGN combo-box-coddoc fill-in-nrodoc radio-set-proceso.

    x-coddoc = "combo-box-coddoc".
    x-nrodoc = "fill-in-nrodoc".
    /*
    MESSAGE "combo-box-coddoc " combo-box-coddoc SKIP
            "fill-in-nrodoc " fill-in-nrodoc.
    */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = combo-box-coddoc AND
                                faccpedi.nroped = fill-in-nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE faccpedi  THEN DO:        

        x-RetVal = "OK".
        IF radio-set-proceso = 1 THEN DO:
            DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
            
            */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

