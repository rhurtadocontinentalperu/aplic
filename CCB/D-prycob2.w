&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodDiv C-CodDoc F-CodCli F-FchDes x-moneda ~
Btn_OK Btn_Cancel RECT-21 RECT-42 RECT-43 RECT-45 
&Scoped-Define DISPLAYED-OBJECTS F-CodDiv C-CodDoc F-CodCli Nombre F-FchDes ~
x-moneda 

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
     LIST-ITEMS "","FAC","BOL","LET","N/D","CHQ" 
     DROP-DOWN-LIST
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-FchDes AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY .81 NO-UNDO.

DEFINE VARIABLE x-moneda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 21.72 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.72 BY 5.65.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.69.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 7.23.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.72 BY 1.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodDiv AT ROW 1.23 COL 19 COLON-ALIGNED
     C-CodDoc AT ROW 2.15 COL 19 COLON-ALIGNED
     F-CodCli AT ROW 3.19 COL 7.86 COLON-ALIGNED
     Nombre AT ROW 3.19 COL 19 COLON-ALIGNED NO-LABEL
     F-FchDes AT ROW 5.19 COL 10.43 COLON-ALIGNED
     x-moneda AT ROW 7.19 COL 21.14 NO-LABEL
     Btn_OK AT ROW 2.96 COL 52.86
     Btn_Cancel AT ROW 5.42 COL 52.57
     "  Rango de Fechas de Vencimiento" VIEW-AS TEXT
          SIZE 30.57 BY .62 AT ROW 4.31 COL 3.43
          FONT 6
     " Tipo Moneda" VIEW-AS TEXT
          SIZE 10.29 BY .5 AT ROW 7.27 COL 7.57
     RECT-21 AT ROW 1 COL 1
     RECT-42 AT ROW 4.62 COL 2.14
     RECT-43 AT ROW 1.04 COL 51.14
     RECT-45 AT ROW 6.85 COL 1.29
     SPACE(14.70) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Proyeccion de Cobranza".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Proyeccion de Cobranza */
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
  ASSIGN  C-CodDoc F-CodCli F-CodDiv F-FchDes /*F-FchHas*/ x-moneda.
                    
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
       CcbcDocu.codcli = F-CodCli /*AND
       CcbCDocu.flgest = "P"*/ NO-LOCK NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-CodDiv C-CodDoc F-CodCli Nombre F-FchDes x-moneda 
      WITH FRAME D-Dialog.
  ENABLE F-CodDiv C-CodDoc F-CodCli F-FchDes x-moneda Btn_OK Btn_Cancel RECT-21 
         RECT-42 RECT-43 RECT-45 
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
 DEFINE VARIABLE F-RANGO AS DECIMAL EXTENT 5 NO-UNDO.
 DEFINE VARIABLE F-SALDO   AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-DIAS    AS INTEGER NO-UNDO.
 DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)"
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "PROYECCION DE COBRANZA - VENCIMIENTOS A PARTIR DEL" AT 44 F-FchDes /*" AL " F-FchHas*/
        "FECHA : " AT 115 TODAY FORMAT "99/99/9999" SKIP
        "Division : " AT 58 F-CODDIV 
        "HORA  : " AT 115 STRING(TIME,"HH:MM") SKIP
         CAPS(S-PROYEC) + {&PRN4} + {&PRN6B} AT 52 FORMAT "X(45)" SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Cod  Numero                   Fecha    Dias        Importe                    PROYECCION DE VENCIMIENTOS EN SEMANAS                       " SKIP
        "Doc  Documento    Emision     Vencmto. Mora        Total             Semana 1       Semana 2       Semana 3       Semana 4     .......... " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 DEFINE FRAME F-Detalle 
        CcbCDocu.CodDoc 
        CcbCDocu.NroDoc AT 6  FORMAT "XXX-XXXXXX"
        CcbCDocu.FchDoc AT 18 
        CcbCDocu.FchVto AT 29 
        D-MORA          AT 40 FORMAT "ZZZ9"
        CcbCDocu.ImpTot AT 50 FORMAT ">,>>>,>>9.99"        
        F-RANGO[1]    AT 63 COLUMN-LABEL "Saldo S/."  FORMAT "(>,>>>,>>9.99)" 
        F-RANGO[2]    AT 78 COLUMN-LABEL "Saldo US$"  FORMAT "(>,>>>,>>9.99)" 
        F-RANGO[3]    AT 93 COLUMN-LABEL "Saldo US$"  FORMAT "(>,>>>,>>9.99)" 
        F-RANGO[4]    AT 108 COLUMN-LABEL "Saldo US$" FORMAT "(>,>>>,>>9.99)" 
        F-RANGO[5]    AT 123 COLUMN-LABEL "Saldo US$" FORMAT "(>,>>>,>>9.99)" 
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
   
 
 
 FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = S-CODCIA
                            AND  CcbCDocu.CodDiv BEGINS F-CODDIV      
                            AND  CcbCDocu.FlgEst = "P"
                            AND  CcbCDocu.FchVto >= F-FchDes     
                            AND  CcbCDocu.CodDoc BEGINS C-CodDoc
                            /*AND  CcbcDocu.CodDoc <> "N/C" */
                            AND  CcbCDocu.CodCli BEGINS F-CodCli
                            AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/D,LET,CHQ') > 0
                            AND  CcbCDocu.CodMon = x-moneda
                            BREAK BY CcbCDocu.CodCia
                              BY CcbCDocu.Codcli
                              BY CcbCDocu.FchVto :
     VIEW STREAM REPORT FRAME F-Titulo.
    
     IF FIRST-OF(CcbCDocu.codcli) THEN DO:
        PUT STREAM REPORT 
                   {&PRN6A} + "Cliente : " FORMAT "X(12)" CcbCDocu.codcli "  " CcbCDocu.NomCli + {&PRN6B} FORMAT "X(50)" SKIP.
     END.
     FIND Facdocum WHERE facdocu.codcia = s-codcia
         AND facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
     IF NOT AVAIL Facdocum THEN NEXT.
     
     F-Saldo = CcbCDocu.SdoAct * (IF Facdocum.tpodoc THEN  1 ELSE -1).
     
     IF TODAY > CcbCDocu.FchVto 
     THEN D-MORA = TODAY - CcbCDocu.FchVto.
     ELSE  D-MORA = 0.

     F-Rango[1] = 0.
     F-Rango[2] = 0.
     F-Rango[3] = 0.
     F-Rango[4] = 0.
     F-Rango[5] = 0.
     
     F-DIAS =  CcbCDocu.FchVto - TODAY .
     
     IF F-DIAS > 28                  THEN F-Rango[5] = F-Saldo.
     IF F-DIAS > 21 AND F-DIAS <= 28 THEN F-Rango[4] = F-Saldo. 
     IF F-DIAS > 14 AND F-DIAS <= 21 THEN F-Rango[3] = F-Saldo.
     IF F-DIAS > 7  AND F-DIAS <= 14 THEN F-Rango[2] = F-Saldo.
     IF F-DIAS > 0  AND F-DIAS <= 7  THEN F-Rango[1] = F-Saldo.
             
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc 
             CcbCDocu.NroDoc 
             CcbCDocu.FchVto
             CcbCDocu.FchDoc
             D-MORA WHEN D-MORA > 0
             CcbCDocu.ImpTot
             F-RANGO[1] WHEN F-RANGO[1] <> 0
             F-RANGO[2] WHEN F-RANGO[2] <> 0
             F-RANGO[3] WHEN F-RANGO[3] <> 0
             F-RANGO[4] WHEN F-RANGO[4] <> 0
             F-RANGO[5] WHEN F-RANGO[5] <> 0 
             WITH FRAME F-Detalle.
     ACCUMULATE F-RANGO[1] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-RANGO[2] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-RANGO[3] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-RANGO[4] (TOTAL BY CcbCDocu.codcia).
     ACCUMULATE F-RANGO[5] (TOTAL BY CcbCDocu.codcia).

     ACCUMULATE F-RANGO[1] (SUB-TOTAL BY CcbCDocu.codcli).
     ACCUMULATE F-RANGO[2] (SUB-TOTAL BY CcbCDocu.codcli).
     ACCUMULATE F-RANGO[3] (SUB-TOTAL BY CcbCDocu.codcli).
     ACCUMULATE F-RANGO[4] (SUB-TOTAL BY CcbCDocu.codcli).
     ACCUMULATE F-RANGO[5] (SUB-TOTAL BY CcbCDocu.codcli).
     
     
     IF LAST-OF(CcbCDocu.codcli) THEN DO:
        UNDERLINE STREAM REPORT
                  F-RANGO[1]
                  F-RANGO[2]
                  F-RANGO[3]
                  F-RANGO[4]
                  F-RANGO[5] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "   TOTAL >>"   @ CcbCDocu.ImpTot
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-RANGO[1] @ F-RANGO[1]
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-RANGO[2] @ F-RANGO[2]
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-RANGO[3] @ F-RANGO[3]
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-RANGO[4] @ F-RANGO[4]
                ACCUM SUB-TOTAL BY (CcbCDocu.codcli) F-RANGO[5] @ F-RANGO[5]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
     IF LAST-OF(CcbCDocu.codcia) THEN DO:
        UNDERLINE STREAM REPORT
                  F-RANGO[1]
                  F-RANGO[2] 
                  F-RANGO[3]
                  F-RANGO[4]
                  F-RANGO[5] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "TOTAL"         @ CcbCDocu.Fchvto
                " GENERAL >>"   @ CcbCDocu.ImpTot
                ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[1] @ F-RANGO[1]
                ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[2] @ F-RANGO[2]
                ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[3] @ F-RANGO[3]                /*ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[1] @ F-RANGO[1]*/
                ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[4] @ F-RANGO[4]
                ACCUM TOTAL BY (CcbCDocu.codcia) F-RANGO[5] @ F-RANGO[5]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
 END.
 PAGE STREAM REPORT.
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
        FIND Facdocum WHERE facdocum.codcia = S-CODCIA AND
            Facdocum.coddoc = C-CODDOC NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN
            S-PROYEC = "DOCUMENTOS :  " + FacDocum.NomDoc.
    END.
    IF X-Moneda = 1 THEN S-PROYEC  = S-PROYEC + " ( Soles )" .
    ELSE S-PROYEC  = S-PROYEC + " ( Dolares)" .

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
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
  
/*   FOR EACH facdocum WHERE FacDocum.TpoDoc OR             */
/*            NOT FacDocum.TpoDoc WITH FRAME {&FRAME-NAME}: */
/*       IF C-CodDoc:ADD-FIRST(facdocum.coddoc) THEN .      */
/*   END.                                                   */
  DO WITH FRAME {&FRAME-NAME}:
     F-FchDes = TODAY + 1  /*- DAY(TODAY) + 1*/.
     /*F-FchHas = TODAY + 1.*/
     F-CodDiv = S-CODDIV.
     DISPLAY F-CodDiv F-FchDes /*F-FchHas*/.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

