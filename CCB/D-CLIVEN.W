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
DEFINE        VAR X-DESCAN  AS CHARACTER.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS F-CodDiv F-Canal BUTTON-8 F-CodCli F-FchDes ~
F-FchHas Btn_OK Btn_Cancel RECT-21 RECT-42 RECT-43 
&Scoped-Define DISPLAYED-OBJECTS F-CodDiv F-Canal F-CodCli Nombre F-FchDes ~
F-FchHas 

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

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Btn 8" 
     SIZE 4.29 BY .92.

DEFINE VARIABLE F-Canal AS CHARACTER FORMAT "X(6)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

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
     SIZE 27.43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 5.19.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.04.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.29 BY 5.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodDiv AT ROW 1.35 COL 8.43 COLON-ALIGNED
     F-Canal AT ROW 1.35 COL 27.57 COLON-ALIGNED
     BUTTON-8 AT ROW 1.27 COL 41
     F-CodCli AT ROW 2.31 COL 8.29 COLON-ALIGNED
     Nombre AT ROW 2.31 COL 20 COLON-ALIGNED NO-LABEL
     F-FchDes AT ROW 4.42 COL 12.86 COLON-ALIGNED
     F-FchHas AT ROW 4.42 COL 32.72 COLON-ALIGNED
     Btn_OK AT ROW 1.81 COL 53
     Btn_Cancel AT ROW 4.08 COL 53
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 15.14 BY .58 AT ROW 3.5 COL 4.57
          FONT 6
     RECT-21 AT ROW 1 COL 1.29
     RECT-42 AT ROW 3.77 COL 2.72
     RECT-43 AT ROW 1 COL 51.29
     SPACE(0.27) SKIP(0.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Documentos Vencidos x Cliente".


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

{src/adm/method/containr.i}
{src/bin/_prns.i}
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Documentos Vencidos x Cliente */
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
  ASSIGN  F-CodCli F-CodDiv F-canal F-FchDes F-FchHas.
  RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 D-Dialog
ON CHOOSE OF BUTTON-8 IN FRAME D-Dialog /* Btn 8 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "CN".
    output-var-2 = "".
    RUN lkup\C-ALMTAB.r("Canal").
    IF output-var-2 <> ? THEN DO:
        F-canal = output-var-2.
        DISPLAY F-Canal.
        APPLY "ENTRY" TO F-Canal .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Canal D-Dialog
ON LEAVE OF F-Canal IN FRAME D-Dialog /* Canal */
DO:
   ASSIGN F-Canal.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Canal = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Canal no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
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
  DISPLAY F-CodDiv F-Canal F-CodCli Nombre F-FchDes F-FchHas 
      WITH FRAME D-Dialog.
  ENABLE F-CodDiv F-Canal BUTTON-8 F-CodCli F-FchDes F-FchHas Btn_OK Btn_Cancel 
         RECT-21 RECT-42 RECT-43 
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
 DEFINE VARIABLE F-IMPORTE AS DECIMAL EXTENT 2 NO-UNDO.
 DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
 X-DESCAN = "TODOS".

 DEFINE FRAME F-Titulo
        HEADER
        "DOCUMENTOS VENCIDOS x CLIENTE DEL " AT 18 F-FchDes " AL " F-FchHas
        "DIVISION : " AT 1 F-CODDIV 
        "FECHA : " AT 85 TODAY FORMAT "99/99/9999" SKIP
        "CANAL    : " AT 1 F-CANAL
        "HORA  : " AT 85 STRING(TIME,"HH:MM") SKIP
        "------------------------------------------------------------------------------------------------" SKIP
        "Cod  Numero             Fecha          Dias          Importe                                    " SKIP
        "Doc  Documento    Vencmto.   Emision   Mora  Mon       Total        Saldo S/.        Saldo US$  " SKIP
        "------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 DEFINE FRAME F-Detalle 
        CcbCDocu.CodDoc 
        CcbCDocu.NroDoc AT  6  FORMAT "XXX-XXXXXX"
        CcbCDocu.FchDoc AT  18 
        CcbCDocu.FchVto AT  29 
        D-MORA          AT  40 FORMAT "ZZZ9"
        C-MON           AT  45 FORMAT " XXX "
        CcbCDocu.ImpTot AT  50 FORMAT ">,>>>,>>9.99"        
        F-IMPORTE[1]    AT  63 COLUMN-LABEL "Saldo S/."  FORMAT "(>>>,>>>,>>9.99)" 
        F-IMPORTE[2]    AT  81 COLUMN-LABEL "Saldo US$"  FORMAT "(>>>,>>>,>>9.99)" 
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
   
 /*CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.

 PUT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

 
 FOR EACH CcbCDocu NO-LOCK WHERE 
          CcbCDocu.CodCia = S-CODCIA      AND 
          CcbCDocu.CodDiv BEGINS F-CodDiv AND
          CcbCDocu.FlgEst = "P"           AND
          CcbCDocu.FchVto >= F-FchDes     AND
          CcbCDocu.FchVto <= F-FchHas     AND
          CcbcDocu.CodDoc <> "N/C"        AND
          CcbCDocu.CodCli BEGINS F-CodCli, 
          each gn-clie where gn-clie.codcia = cl-codcia and
          gn-clie.codcli = ccbcdocu.codcli and 
          gn-clie.canal begins f-canal
          
          
          BREAK BY CcbCDocu.CodCia
                BY CcbCDocu.Codcli
                BY CcbCDocu.FchVto:
     
     DISPLAY CcbCdocu.Codcli @ Fi-Mensaje LABEL "Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
        
     VIEW STREAM REPORT FRAME F-Titulo.
         
    
     IF FIRST-OF(CcbCDocu.codcli) THEN DO:
        PUT STREAM REPORT "Cliente : " FORMAT "X(12)" CcbCDocu.codcli "  " CcbCDocu.NomCli   SKIP.
     END.
     FIND Facdocum WHERE facdocum.codcia = ccbcdocu.codcia and facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
     if not available facdocum then display ccbcdocu.coddoc.
     
     IF CcbCDocu.CodMon = 1 THEN
        ASSIGN C-MON = "S/." 
               F-IMPORTE[1] = CcbCDocu.SdoAct * (IF Facdocum.tpodoc THEN  1 ELSE -1)
               F-IMPORTE[2] = 0.
     ELSE ASSIGN C-MON = "US$"
                 F-IMPORTE[2] = CcbCDocu.SdoAct * (IF Facdocum.tpodoc THEN  1 ELSE -1)
                 F-IMPORTE[1] = 0.
                 
     IF TODAY > CcbCDocu.FchVto THEN D-MORA = TODAY - CcbCDocu.FchVto.
        ELSE  D-MORA = 0.
                 
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc 
             CcbCDocu.NroDoc 
             CcbCDocu.FchVto 
             CcbCDocu.FchDoc
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

HIDE FRAME F-Proceso.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita D-Dialog 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL.
END.

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
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita D-Dialog 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

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
  
/*FOR EACH facdocum WHERE FacDocum.TpoDoc OR 
           NOT FacDocum.TpoDoc WITH FRAME {&FRAME-NAME}:
      IF C-CodDoc:ADD-LAST(facdocum.coddoc) THEN . 
  END.  */
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

