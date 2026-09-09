&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEFINE        VAR S-task-no AS integer.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-43 RECT-44 F-CodDiv F-Dias ~
F-CodCliDes F-CodCliHas Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodDiv F-Dias F-CodCliDes F-NomDes ~
F-CodCliHas F-NomHas 

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

DEFINE VARIABLE F-CodCliDes AS CHARACTER FORMAT "X(8)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCliHas AS CHARACTER FORMAT "X(8)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE F-Dias AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Dias de Anticipacion" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomHas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.14 BY 6.81.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12.43 BY 5.62.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.29 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodDiv AT ROW 1.58 COL 15 COLON-ALIGNED
     F-Dias AT ROW 2.92 COL 15 COLON-ALIGNED
     F-CodCliDes AT ROW 5.15 COL 9.72 COLON-ALIGNED
     F-NomDes AT ROW 5.15 COL 19.72 COLON-ALIGNED NO-LABEL
     F-CodCliHas AT ROW 6.12 COL 9.72 COLON-ALIGNED
     F-NomHas AT ROW 6.12 COL 19.72 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.58 COL 55
     Btn_Cancel AT ROW 4.27 COL 55
     RECT-21 AT ROW 1 COL 1
     RECT-43 AT ROW 1.04 COL 54.29
     RECT-44 AT ROW 4.77 COL 2.43
     "Rango de Clientes" VIEW-AS TEXT
          SIZE 17.29 BY .69 AT ROW 4.38 COL 4
          FONT 1
     SPACE(45.43) SKIP(2.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Avisos de Cobranza".

 

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

/* SETTINGS FOR FILL-IN F-NomDes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomHas IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Avisos de Cobranza */
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
  ASSIGN  F-CodCliDes F-CodCliHas F-CodDiv F-Dias.
                    
  RUN imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCliDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCliDes D-Dialog
ON LEAVE OF F-CodCliDes IN FRAME D-Dialog /* Desde */
DO:
  ASSIGN F-CodCliDes.
  IF F-CodCliDes = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND 
       gn-clie.codcli = F-CodCliDes NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN  DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND FIRST CcbCDocu WHERE 
       CcbCDocu.CodCia = S-CODCIA AND
       CcbcDocu.codcli = F-CodCliDes AND
       CcbCDocu.flgest = "P" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
     MESSAGE "Cliente sin Mov. Pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCliHas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCliHas D-Dialog
ON LEAVE OF F-CodCliHas IN FRAME D-Dialog /* Hasta */
DO:
  ASSIGN F-CodCliHas.
  IF F-CodCliHas = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND 
       gn-clie.codcli = F-CodCliHas NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN  DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND FIRST CcbCDocu WHERE 
       CcbCDocu.CodCia = S-CODCIA AND
       CcbcDocu.codcli = F-CodCliHas AND
       CcbCDocu.flgest = "P" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
     MESSAGE "Cliente sin Mov. Pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomHas:SCREEN-VALUE = gn-clie.nomcli.
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
  DISPLAY F-CodDiv F-Dias F-CodCliDes F-NomDes F-CodCliHas F-NomHas 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 RECT-43 RECT-44 F-CodDiv F-Dias F-CodCliDes F-CodCliHas Btn_OK 
         Btn_Cancel 
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
 DEFINE VARIABLE C-DESC AS CHAR EXTENT 3 NO-UNDO.
 DEFINE VARIABLE C-MON  AS CHAR NO-UNDO.
 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN2} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "AVISO DE VENCIMIENTO" + {&PRN6B} AT 70 FORMAT "X(30)" SKIP
        SKIP
        "FECHA : " TO 78 TODAY FORMAT "99/99/9999" SKIP
        "Cliente : " CcbCDocu.codcli "  " CcbCDocu.NomCli FORMAT "X(40)"
        "HORA : " TO 78 STRING(TIME,"HH:MM") SKIP(1)
        "      Mediante la presente los saludamos y a la vez les informamos de la situacion de los" SKIP
        "siguientes documentos:" SKIP(1)
        "-----------------------------------------------------------------------------------------" SKIP
        "Cod Numero de  Fecha de                                                                  " SKIP
        "Doc Documento  Vencimient Mon          Importe Situacion  Banco                Agencia   " SKIP
        "-----------------------------------------------------------------------------------------" SKIP(1)
        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 DEFINE FRAME F-PiePag
        HEADER
        "Atentamente" SKIP(2)
        "---------------------------" AT 40 SKIP
        "Jefe de Credito y Cobranzas" AT 40 SKIP(1)
        WITH PAGE-BOTTOM NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 DEFINE FRAME F-Detalle 
        CcbCDocu.CodDoc COLUMN-LABEL "Cod!Doc"
        CcbCDocu.NroDoc COLUMN-LABEL "Numero de!Documento" FORMAT "XXX-XXXXXX"
        CcbCDocu.FchVto COLUMN-LABEL "Fecha de!Vencimient"
        C-MON COLUMN-LABEL "Mon" FORMAT "X(3)" 
        CcbCDocu.SdoAct COLUMN-LABEL "Importe"  FORMAT "(>>>,>>>,>>9.99)" 
        CcbCDocu.FlgUbi COLUMN-LABEL "Situacion"  FORMAT "X(10)"
        CcbCDocu.CodCta COLUMN-LABEL "Banco"      FORMAT "X(20)"
        CcbCDocu.CodAge COLUMN-LABEL "Agencia"    FORMAT "X(10)"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
 
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 30. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN2}.
 
 FOR EACH CcbCDocu NO-LOCK WHERE 
          CcbCDocu.CodCia = S-CODCIA      AND 
          (CcbCDocu.codcli BEGINS F-CodCliDes OR CcbCDocu.codcli >= F-CodCliDes) AND 
          (CcbCDocu.codcli BEGINS F-CodCliHas OR CcbCDocu.codcli <= F-CodCliDes) AND 
          CcbCDocu.CodDiv BEGINS F-CodDiv AND
          CcbCDocu.FchVto = (TODAY + F-Dias) AND
          CcbCDocu.flgest = "P" 
          BREAK BY CcbCDocu.CodCia
                BY CcbCDocu.codcli
                BY CcbCDocu.coddoc
                BY CcbCDocu.FchVto DESCENDING:
     VIEW STREAM REPORT FRAME F-Titulo.
     FIND Facdocum WHERE facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
     IF NOT Facdocum.tpodoc THEN NEXT.
     C-MON = "S/.".
     IF CcbCDocu.CodMon = 2 THEN ASSIGN C-MON = "US$".
     C-DESC[1] = IF CcbCDocu.FlgUbi = "B" THEN "Banco" ELSE "Cartera".
     C-DESC[2] = "".
     C-DESC[3] = "".
     FIND cb-ctas WHERE cb-ctas.CodCia = 0 AND
          cb-ctas.Codcta = CcbCDocu.CodCta NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN DO:
        FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND
             cb-tabl.Codigo = cb-ctas.codbco NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN C-DESC[2] = cb-tabl.Nombre.
        C-DESC[3] = CcbCDocu.CodAge.
     END.
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc 
             CcbCDocu.NroDoc 
             CcbCDocu.FchVto 
             C-MON 
             CcbCDocu.SdoAct
             C-DESC[1] @ CcbCDocu.FlgUbi 
             C-DESC[2] @ CcbCDocu.CodCta 
             C-DESC[3] @ CcbCDocu.CodAge 
             WITH FRAME F-Detalle.
     IF LAST-OF(CcbCDocu.codcli) THEN DO:
        VIEW STREAM REPORT FRAME F-PiePag.
        PAGE STREAM REPORT.
     END.
 END.
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
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
  
  DO WITH FRAME {&FRAME-NAME}:
     F-CodDiv = S-CODDIV.
     F-Dias = 15.
     DISPLAY F-CodDiv F-Dias.
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


