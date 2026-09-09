&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE VAR C-DESMOV AS CHAR.
DEFINE VAR C-OP AS CHAR.
DEFINE STREAM REPORT.
DEFINE VAR X-PROCEDENCIA AS CHAR.
DEFINE VAR x-codmov AS CHAR.
DEFINE VAR X-CODPRO as CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-20 C-TipMov I-CodMov DesdeF ~
HastaF Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-TipMov I-CodMov N-MOVI DesdeF HastaF 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Codigo Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .69 NO-UNDO.

DEFINE VARIABLE C-TipMov AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingresos", "I",
"Salidas", "S"
     SIZE 14 BY 1.54 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 1.92.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.86 BY 5.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-TipMov AT ROW 1.58 COL 19 NO-LABEL
     I-CodMov AT ROW 3.81 COL 15.57 COLON-ALIGNED
     N-MOVI AT ROW 3.85 COL 20.43 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 4.62 COL 15.57 COLON-ALIGNED
     HastaF AT ROW 5.38 COL 15.57 COLON-ALIGNED
     Btn_OK AT ROW 1.62 COL 49.86
     Btn_Cancel AT ROW 3.92 COL 49.86
     RECT-19 AT ROW 1.38 COL 17
     RECT-20 AT ROW 1 COL 1
     "Tipo Movimiento" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 1.58 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Analisis de Documentos por Movimento"
         HEIGHT             = 5.46
         WIDTH              = 62.57
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Analisis de Documentos por Movimento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Analisis de Documentos por Movimento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN C-TipMov DesdeF HastaF I-CodMov .
  IF I-CODMOV <> 0 THEN DO:
    FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA AND
                           Almcmov.CodAlm  = S-CODALM AND
                           Almcmov.TipMov  = C-TipMov AND
                           Almcmov.CodMov  = I-CodMov NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "CODIGO NO TIENE MOVIMIENTO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
      X-CODMOV = STRING(I-CODMOV).
  END.
  ELSE  X-CODMOV = "".
  
  
  FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA AND
                           Almcmov.Fchdoc >= DESDEF AND 
                           Almcmov.Fchdoc <= HASTAF NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "RANGO DE FECHAS SIN MOVIMIENTOS" VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO DESDEF.
        RETURN NO-APPLY.
  END.
    
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main /* Codigo Movimiento */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = C-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY C-TipMov I-CodMov N-MOVI DesdeF HastaF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-19 RECT-20 C-TipMov I-CodMov DesdeF HastaF Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-flgest  AS CHAR NO-UNDO.
  DEFINE VAR x-desmat  AS CHAR NO-UNDO.
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR SW        AS INTEGER INITIAL 0.
  
  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  CASE C-TipMov:
     WHEN 'I' THEN x-titulo1 = 'ANALISIS DE DOCUMENTOS - INGRESOS'.
     WHEN 'S' THEN x-titulo1 = 'ANALISIS DE DOCUMENTOS - SALIDAS'.
  END CASE.
  DEFINE FRAME F-REP
         Almcmov.NroDoc 
         Almcmov.CodAlm AT 10
         Almcmov.FchDoc AT 16 FORMAT "99/99/9999"
         Almcmov.NomRef AT 28 FORMAT 'X(35)'
         Almcmov.usuario AT 65
         Almcmov.NroRf1  AT 75
         Almtmovm.Desmov FORMAT 'X(35)'
         x-flgest FORMAT 'X(10)'
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         Almmmatg.DesMat AT 28 FORMAT "X(40)"
         Almdmov.CodUnd  AT 75
         Almdmov.CanDes  AT 80 FORMAT "->>,>>,>>9.99" 
         
    HEADER
         {&Prn6a} S-NOMCIA 
         "Pagina :" AT 112 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
         x-titulo1  AT 45 FORMAT 'X(35)'
         "Fecha  :" at 112 Almcmov.FchDoc FORMAT "99/99/9999" SKIP
         x-titulo2  AT 48 FORMAT 'X(35)'
         "Hora   :" at 112 STRING(TIME,"HH:MM:SS") {&Prn6b} SKIP
         "----------------------------------------------------------------------------------------------------------------------------------" SKIP
         " Nro.  Almacen Fecha/Doc.          D e s t i n o                Respons.  Doc.Refer.    M o v i m i e n t o               Estado  " SKIP
         " Doc.          Cod/Articulo   Descripcion                                 Unid      Cantidad                                      " SKIP
         "----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(62) + {&PRN3}.
  
  FOR EACH Almcmov WHERE Almcmov.CodCia = S-CODCIA AND 
                        Almcmov.CodAlm  = S-CODALM AND
                        string(Almcmov.CodMov) begins X-CodMov AND 
                        Almcmov.TipMov  = C-TipMov AND
                        Almcmov.FchDoc >= DesdeF   AND
                        Almcmov.FchDoc <= HastaF NO-LOCK,
          EACH Almdmov OF Almcmov WHERE 
                        Almdmov.CodCia = Almcmov.CodCia AND
                        Almdmov.CodAlm = Almcmov.CodAlm AND
                        Almdmov.TipMov = Almcmov.TipMov AND
                        Almdmov.CodMov = Almcmov.CodMov AND
                        Almdmov.NroDoc = Almcmov.NroDoc NO-LOCK 
         BREAK BY Almcmov.Nrodoc
               BY Almdmov.CodMat:

      IF Almcmov.flgest = 'A' THEN x-flgest = 'ANULADO'.
      ELSE x-flgest = 'RECIBIDO'.
      FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
           Almtmovm.tipmov = Almcmov.tipmov AND
           Almtmovm.codmov = Almcmov.CodMov NO-LOCK NO-ERROR.

      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND 
           Almmmatg.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
           IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
           ELSE x-desmat = Almmmatg.DesMat.
           
      SW = SW + 1.     
      IF SW > 1 THEN DO:
         PUT STREAM REPORT Almdmov.codmat AT 16 FORMAT "X(6)"
                           x-desmat       AT 28 FORMAT "X(40)"
                           Almdmov.CodUnd AT 75 FORMAT "X(4)"
                           Almdmov.CanDes AT 80 FORMAT "->>,>>,>>9.99". 
      END.

      IF SW = 1 THEN DO:
         DISPLAY STREAM REPORT 
           Almcmov.NroDoc 
           Almcmov.CodAlm
           Almcmov.FchDoc  
           Almcmov.NomRef
           Almcmov.usuario
           Almcmov.NroRf1 
           Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-' + Almtmovm.Desmov @ Almtmovm.Desmov 
           x-flgest 
           Almdmov.codmat  
           Almmmatg.DesMat  
           Almdmov.CodUnd   
           Almdmov.CanDes WITH FRAME F-REP.
      END.

     IF LAST-OF(Almcmov.NroDoc) THEN DO:
        SW = 0.
     END.
     
/*    IF LAST-OF(Almcmov.CodMov) THEN DO:
         UNDERLINE STREAM report 
             Almcmov.NomRef 
             Almcmov.usuario 
             Almcmov.NroRf1  
             Almtmovm.Desmov 
             x-flgest WITH FRAME F-REP.
      END.       */

  END.
/*  PAGE STREAM REPORT.*/
  OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.


/*
   FOR EACH Almcmov WHERE Almcmov.CodCia  = S-CODCIA AND
      Almcmov.CodAlm  = S-CODALM AND
      Almcmov.TipMov  = C-TipMov AND
      string(Almcmov.CodMov) begins X-CodMov AND 
      Almcmov.FchDoc >= DesdeF   AND
/*    Almcmov.FchDoc <= HastaF BREAK BY Almcmov.TipMov BY Almcmov.CodMov:*/
      Almcmov.FchDoc <= HastaF BY Almcmov.Nrodoc:


      FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
          Almdmov.CodAlm = Almcmov.CodAlm AND
          Almdmov.TipMov = Almcmov.TipMov AND
          Almdmov.CodMov = Almcmov.CodMov AND
/*        Almdmov.NroDoc = Almcmov.NroDoc BREAK BY Almdmov.NroDoc:*/
          Almdmov.NroDoc = Almcmov.NroDoc BY Almdmov.CodMat:

      FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
          Almdmov.CodAlm = Almcmov.CodAlm AND
          Almdmov.TipMov = Almcmov.TipMov AND
          Almdmov.CodMov = Almcmov.CodMov AND
/*        Almdmov.NroDoc = Almcmov.NroDoc BREAK BY Almdmov.NroDoc:*/
          Almdmov.NroDoc = Almcmov.NroDoc BY Almdmov.CodMat:

           DISPLAY STREAM REPORT 
               Almdmov.codmat 
               x-desmat @ Almmmatg.DesMat
               Almdmov.CodUnd 
               Almdmov.CanDes WITH FRAME F-REP.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*-----------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  
  RUN Formato.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
     DISPLAY DesdeF HastaF.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "I-CodMov" THEN 
               ASSIGN input-var-1 = C-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


