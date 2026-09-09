&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.
DEFINE SHARED VAR cl-codcia AS INTEGER.
DEFINE        VAR S-task-no AS INTEGER.
DEFINE        VAR D-MORA    AS INTEGER.
DEFINE        VAR S-PROYEC  AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-42 RECT-43 RECT-44 F-CodDiv ~
C-CodDoc RADIO-SET-Zona F-CodCli F-FchDes F-FchHas Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodDiv C-CodDoc RADIO-SET-Zona Nombre ~
F-CodCli F-FchDes F-FchHas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 8.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-FchDes AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-FchHas AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Zona AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "General", 1,
"Lima", 2,
"Provincia", 3
     SIZE 11 BY 1.46 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.72 BY 6.04.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.69.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14 BY 6.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13.86 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodDiv AT ROW 1.58 COL 14.57 COLON-ALIGNED
     C-CodDoc AT ROW 2.5 COL 14.57 COLON-ALIGNED
     RADIO-SET-Zona AT ROW 1.85 COL 30 NO-LABEL
     Nombre AT ROW 3.73 COL 19 COLON-ALIGNED NO-LABEL
     F-CodCli AT ROW 3.73 COL 6.86 COLON-ALIGNED
     F-FchDes AT ROW 5.62 COL 10.43 COLON-ALIGNED
     F-FchHas AT ROW 5.62 COL 29.29 COLON-ALIGNED
     Btn_OK AT ROW 1.88 COL 52.72
     Btn_Cancel AT ROW 4.38 COL 52.72
     RECT-21 AT ROW 1 COL 1
     RECT-42 AT ROW 5.04 COL 2.14
     RECT-43 AT ROW 1.04 COL 51.14
     RECT-44 AT ROW 1.54 COL 28.72
     "  Rango de Fechas" VIEW-AS TEXT
          SIZE 16.14 BY .62 AT ROW 4.85 COL 3.43
          FONT 6
     " Zona" VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 1.31 COL 30.57
     SPACE(30.85) SKIP(5.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Estado de Cuenta Corriente".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Nombre IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Estado de Cuenta Corriente */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN  C-CodDoc F-CodCli F-CodDiv F-FchDes F-FchHas RADIO-SET-Zona.
  
  RUN imprimir.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCli D-Dialog
ON LEAVE OF F-CodCli IN FRAME D-Dialog /* Cliente */
DO:
  ASSIGN F-CodCli.
  IF F-CodCli = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND 
       gn-clie.codcli = F-CodCli NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN  DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND FIRST CcbCDocu WHERE 
       CcbCDocu.CodCia = S-CODCIA AND
       CcbcDocu.codcli = F-CodCli AND
       CcbCDocu.flgest = "P" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
     MESSAGE "Cliente sin Mov. Pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  nombre:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDiv D-Dialog
ON LEAVE OF F-CodDiv IN FRAME D-Dialog /* Division */
DO:
    ASSIGN F-CodDiv.
    IF F-CodDiv = "" THEN RETURN.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND 
         gn-divi.coddiv = F-CodDiv NO-LOCK NO-ERROR.
    If NOT AVAILABLE gn-divi THEN DO:
       MESSAGE "Codigo de division no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY F-CodDiv C-CodDoc RADIO-SET-Zona Nombre F-CodCli F-FchDes F-FchHas 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 RECT-42 RECT-43 RECT-44 F-CodDiv C-CodDoc RADIO-SET-Zona 
         F-CodCli F-FchDes F-FchHas Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato D-Dialog 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VARIABLE ltpodoc AS LOGICAL NO-UNDO.
 DEFINE VARIABLE F-IMPORTE AS DECIMAL EXTENT 2 NO-UNDO.
 DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
 DEFINE VARIABLE X-ZONA AS CHAR NO-UNDO.
 DEFINE VARIABLE D-ZONA AS CHAR NO-UNDO.
 CASE RADIO-SET-Zona: 
    WHEN 1 THEN X-ZONA = ' ZONA : GENERAL'.
    WHEN 2 THEN X-ZONA = '  ZONA : LIMA'.
    WHEN 3 THEN X-ZONA = 'ZONA : PROVINCIA'.
 END CASE.
 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)"
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "ESTADO DE CUENTA CORRIENTE DEL " AT 44 F-FchDes " AL " F-FchHas
        "FECHA : " AT 115 TODAY FORMAT "99/99/9999" SKIP
        "Division : " AT 58 F-CODDIV 
        "HORA  : " AT 115 STRING(TIME,"HH:MM") SKIP
        X-ZONA AT 58 FORMAT 'X(20)' SKIP
         CAPS(S-PROYEC) + {&PRN2} + {&PRN6B} AT 52 FORMAT "X(45)" SKIP
        "------------------------------------------------------------------------------------------------" SKIP
        "Cod  Numero             Fecha          Dias          Importe                                    " SKIP
        "Doc  Documento    Vencmto.    Emision  Mora  Mon       Total        Saldo S/.        Saldo US$  " SKIP
        "------------------------------------------------------------------------------------------------" + {&PRN6B} + {&PRND} FORMAT "X(100)" SKIP
        {&PRN6B} + {&PRND} + " " SKIP
        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 DEFINE FRAME F-Detalle 
        CcbCDocu.CodDoc 
        CcbCDocu.NroDoc AT 6  FORMAT "XXX-XXXXXX"
        CcbCDocu.FchDoc AT 18 
        CcbCDocu.FchVto AT 29 
        D-MORA          AT 40 FORMAT "ZZZ9"
        C-MON           AT 45 FORMAT " XXX "
        CcbCDocu.ImpTot AT 50 FORMAT ">,>>>,>>9.99"        
        F-IMPORTE[1]    AT 63 COLUMN-LABEL "Saldo S/."  FORMAT "(>>>,>>>,>>9.99)" 
        F-IMPORTE[2]    AT 81 COLUMN-LABEL "Saldo US$"  FORMAT "(>>>,>>>,>>9.99)" 
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

/*MLR* 12/11/07 * ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN2}.

 FOR EACH CcbCDocu NO-LOCK WHERE 
          CcbCDocu.CodCia = S-CODCIA      AND 
          CcbCDocu.CodDiv = F-CODDIV      AND 
          CcbCDocu.FlgEst = "P"           AND
          CcbCDocu.FchVto >= F-FchDes     AND
          CcbCDocu.FchVto <= F-FchHas     AND
          CcbCDocu.CodDoc BEGINS C-CodDoc AND
          CcbcDocu.CodDoc <> "N/C"        AND
          CcbCDocu.CodCli BEGINS F-CodCli 
          
          BREAK BY CcbCDocu.CodCia
                BY CcbCDocu.Codcli
                BY CcbCDocu.FchVto :
     VIEW STREAM REPORT FRAME F-Titulo.
     CASE RADIO-SET-Zona: 
        WHEN 2 THEN IF CcbCDocu.CodDpto <> '15' THEN NEXT.
        WHEN 3 THEN IF CcbCDocu.CodDpto =  '15' THEN NEXT.
     END CASE.
            
     IF FIRST-OF(CcbCDocu.codcli) THEN DO:
        D-ZONA = ''.
        IF CcbCDocu.CodDpto = '15' THEN DO:
           FIND TabDistr WHERE TabDistr.CodDepto = CcbCDocu.CodDpto AND
                TabDistr.CodDistr = CcbCDocu.CodDist AND
                TabDistr.CodProvi = CcbCDocu.CodProv NO-LOCK NO-ERROR.
           IF AVAILABLE TabDistr THEN D-ZONA = TabDistr.NomDistr.
           END.
        ELSE DO:
           FIND TabDepto WHERE TabDepto.CodDepto = CcbCDocu.CodDpto NO-LOCK NO-ERROR.
           IF AVAILABLE TabDepto THEN D-ZONA = TabDepto.NomDepto.
        END.
        PUT STREAM REPORT 
                   {&PRN6A} + "Cliente : " FORMAT "X(12)" CcbCDocu.codcli "  " CcbCDocu.NomCli "   " D-ZONA + {&PRN6B} + {&PRND} FORMAT "X(60)" SKIP
                   {&PRN6B} + {&PRN2} + " " SKIP.
     END.
     FIND Facdocum WHERE facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
     IF AVAILABLE FacDocum THEN ltpodoc = Facdocum.tpodoc.
     IF CcbCDocu.CodMon = 1 THEN
        ASSIGN C-MON = "S/." 
               F-IMPORTE[1] = CcbCDocu.SdoAct * (IF ltpodoc THEN  1 ELSE -1)
               F-IMPORTE[2] = 0.
     ELSE ASSIGN C-MON = "US$"
                 F-IMPORTE[2] = CcbCDocu.SdoAct * (IF ltpodoc THEN  1 ELSE -1)
                 F-IMPORTE[1] = 0.
                 
     IF TODAY > CcbCDocu.FchVto THEN D-MORA = TODAY - CcbCDocu.FchVto.
        ELSE  D-MORA = 0.
                 
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc 
             CcbCDocu.NroDoc 
             CcbCDocu.FchDoc 
             CcbCDocu.FchVto 
             D-MORA WHEN D-MORA > 0
             C-MON 
             CcbCDocu.ImpTot
             F-IMPORTE[1] WHEN F-IMPORTE[1] <> 0
             F-IMPORTE[2] WHEN F-IMPORTE[2] <> 0
             WITH FRAME F-Detalle.
     ACCUMULATE F-IMPORTE[1] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-IMPORTE[2] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-IMPORTE[1] (SUB-TOTAL BY CcbCDocu.codcli).
     ACCUMULATE F-IMPORTE[2] (SUB-TOTAL BY CcbCDocu.codcli).
     IF LAST-OF(CcbCDocu.codcli) THEN DO:
        UNDERLINE STREAM REPORT
                  F-IMPORTE[1]
                  F-IMPORTE[2] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "   TOTAL >>"   @ CcbCDocu.ImpTot
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-IMPORTE[1] @ F-IMPORTE[1]
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-IMPORTE[2] @ F-IMPORTE[2]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
     IF LAST-OF(CcbCDocu.codcia) THEN DO:
        UNDERLINE STREAM REPORT
                  F-IMPORTE[1]
                  F-IMPORTE[2] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "TOTAL"        @ C-MON
                " GENERAL >>"   @ CcbCDocu.ImpTot
                ACCUM TOTAL BY (CcbCDocu.codcia) F-IMPORTE[1] @ F-IMPORTE[1]
                ACCUM TOTAL BY (CcbCDocu.codcia) F-IMPORTE[2] @ F-IMPORTE[2]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
 END.
/*MLR* 12/11/07 ***
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
* ***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    IF C-CODDOC = "" THEN 
        S-PROYEC = "DOCUMENTOS :  " + " G E N E R A L ".
    ELSE DO:
        FIND Facdocum WHERE
            facdocum.codcia = S-CODCIA AND
            Facdocum.coddoc = C-CODDOC NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN
            S-PROYEC = "DOCUMENTOS :  " + FacDocum.NomDoc.
    END.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  FOR EACH facdocum WHERE FacDocum.TpoDoc OR 
           NOT FacDocum.TpoDoc WITH FRAME {&FRAME-NAME}:
      IF C-CodDoc:ADD-LAST(facdocum.coddoc) THEN . 
  END.  
  DO WITH FRAME {&FRAME-NAME}:
     F-FchDes = TODAY - DAY(TODAY) + 1.
     F-FchHas = TODAY.
     F-CodDiv = S-CODDIV.
     DISPLAY F-CodDiv F-FchDes F-FchHas.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


