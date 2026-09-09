&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEFINE INPUT PARAMETER X-CODCTA AS CHAR.
DEFINE INPUT PARAMETER X-CODAUX AS CHAR.
DEFINE INPUT PARAMETER X-CODDOC AS CHAR.
DEFINE INPUT PARAMETER X-NRODOC AS CHAR.

/* Local Variable Definitions ---                                       */

{CBD/CBGLOBAL.I}

DEFINE TEMP-TABLE RMOV LIKE cb-dmov.

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE BUFFER DETALLE FOR cb-dmov.

DEFINE STREAM report.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES RMOV

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table RMOV.Fchvto RMOV.GloDoc RMOV.TpoMov RMOV.ImpMn1 RMOV.ImpMn2 RMOV.TpoCmb RMOV.NroAst RMOV.CodOpe RMOV.NroRef   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-ORDEN = 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH RMOV NO-LOCK    BY RMOV.CodCia     BY RMOV.Fchvto      BY RMOV.Codaux       BY RMOV.Coddoc        BY RMOV.Nrodoc     INDEXED-REPOSITION. ELSE OPEN QUERY {&SELF-NAME} FOR EACH RMOV NO-LOCK    BY RMOV.CodCia     BY RMOV.Codaux      BY RMOV.Fchvto       BY RMOV.Coddoc        BY RMOV.Nrodoc     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table RMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table RMOV


/* Definitions for DIALOG-BOX D-Dialog                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 Btn-Imprime Btn_OK Btn_Cancel ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS F-CODAUX F-CodDoc F-NOMAUX F-NRODOC ~
F-ImpMn1 F-ImpMn2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Imprime 
     LABEL "Imprimir" 
     SIZE 12 BY 2
     FONT 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE F-CODAUX AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-ImpMn1 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-ImpMn2 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMAUX AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE VARIABLE F-NRODOC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.43 BY 2.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      RMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table D-Dialog _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      RMOV.Fchvto COLUMN-LABEL "Vencimiento"
      RMOV.GloDoc FORMAT "X(30)"
      RMOV.TpoMov 
      RMOV.ImpMn1 
      RMOV.ImpMn2 
      RMOV.TpoCmb 
      RMOV.NroAst COLUMN-LABEL "Voucher"
      RMOV.CodOpe COLUMN-LABEL "Libro"
      RMOV.NroRef
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 77.43 BY 7.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn-Imprime AT ROW 11.85 COL 15.14
     F-CODAUX AT ROW 1.15 COL 8.57 COLON-ALIGNED
     F-CodDoc AT ROW 2.04 COL 8.57 COLON-ALIGNED
     F-NOMAUX AT ROW 1.15 COL 20.86 COLON-ALIGNED NO-LABEL
     F-NRODOC AT ROW 2.04 COL 23.43 COLON-ALIGNED
     Btn_OK AT ROW 11.85 COL 33
     F-ImpMn1 AT ROW 10.81 COL 43 COLON-ALIGNED
     Btn_Cancel AT ROW 11.77 COL 51
     F-ImpMn2 AT ROW 10.81 COL 60.86 COLON-ALIGNED
     br_table AT ROW 3.15 COL 1
     RECT-17 AT ROW 1 COL 1
     "Saldos" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 11 COL 33
          FONT 1
     SPACE(38.13) SKIP(2.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Movimiento por Documento".

 

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
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CODAUX IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CodDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpMn1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpMn2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMAUX IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NRODOC IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
IF I-ORDEN = 1 THEN
OPEN QUERY {&SELF-NAME} FOR EACH RMOV NO-LOCK
   BY RMOV.CodCia
    BY RMOV.Fchvto
     BY RMOV.Codaux
      BY RMOV.Coddoc
       BY RMOV.Nrodoc
    INDEXED-REPOSITION.
ELSE
OPEN QUERY {&SELF-NAME} FOR EACH RMOV NO-LOCK
   BY RMOV.CodCia
    BY RMOV.Codaux
     BY RMOV.Fchvto
      BY RMOV.Coddoc
       BY RMOV.Nrodoc
    INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Movimiento por Documento */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Imprime D-Dialog
ON CHOOSE OF Btn-Imprime IN FRAME D-Dialog /* Imprimir */
DO:
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle D-Dialog 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
F-ImpMn1 = 0.
F-ImpMn2 = 0.
/* CARGAMOS EL DETALLE POR DOCUMENTO */
   FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = S-CODCIA AND
            cb-dmov.Periodo = S-PERIODO AND
            cb-dmov.Codcta  = X-CODCTA  AND
            cb-dmov.Codaux  = X-CODAUX  AND
            cb-dmov.CodDoc  = X-CODDOC  AND
            cb-dmov.NroDoc  = X-NRODOC:
       CREATE RMOV.
       ASSIGN RMOV.CODCIA = cb-dmov.codcia
              RMOV.NroAst = cb-dmov.NroAst
              RMOV.CodOpe = cb-dmov.CodOpe
              RMOV.cco    = cb-dmov.cco   
              RMOV.Clfaux = cb-dmov.Clfaux
              RMOV.Codaux = cb-dmov.Codaux
              RMOV.Codcta = cb-dmov.Codcta
              RMOV.CodDiv = cb-dmov.CodDiv
              RMOV.Coddoc = cb-dmov.Coddoc
              RMOV.Codmon = cb-dmov.Codmon
              RMOV.Fchdoc = cb-dmov.Fchdoc
              RMOV.Fchvto = cb-dmov.Fchvto
              RMOV.flgact = cb-dmov.flgact
              RMOV.Glodoc = cb-dmov.Glodoc
              RMOV.ImpMn1 = cb-dmov.ImpMn1
              RMOV.ImpMn2 = cb-dmov.ImpMn2
              RMOV.Nrodoc = cb-dmov.Nrodoc
              RMOV.Nroref = cb-dmov.NroRef
              RMOV.Nroruc = cb-dmov.Nroruc
              RMOV.tm     = cb-dmov.tm
              RMOV.Tpocmb = cb-dmov.Tpocmb
              RMOV.TpoMov = cb-dmov.TpoMov.
       FIND cb-cmov WHERE cb-cmov.Codcia = cb-dmov.codcia AND
            cb-cmov.Periodo = cb-dmov.Periodo AND
            cb-cmov.Nromes  = cb-dmov.Nromes AND
            cb-cmov.Codope  = cb-dmov.Codope AND
            cb-cmov.Nroast  = cb-dmov.Nroast NO-LOCK NO-ERROR.
       IF AVAILABLE cb-cmov AND cb-cmov.Nrochq <> "" THEN 
          ASSIGN RMOV.Nroref = cb-cmov.Nrochq.
       IF RMOV.TpoMov THEN
          ASSIGN F-ImpMn1 = F-ImpMn1 - RMOV.ImpMn1
                 F-ImpMn2 = F-ImpMn2 - RMOV.ImpMn2.
       ELSE
          ASSIGN F-ImpMn1 = F-ImpMn1 + RMOV.ImpMn1
                 F-ImpMn2 = F-ImpMn2 + RMOV.ImpMn2.
   END.
   
   {&OPEN-QUERY-{&BROWSE-NAME}}

   DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}.

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
  DISPLAY F-CODAUX F-CodDoc F-NOMAUX F-NRODOC F-ImpMn1 F-ImpMn2 
      WITH FRAME D-Dialog.
  ENABLE RECT-17 Btn-Imprime Btn_OK Btn_Cancel br_table 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR x-ImpMn1  AS DECIMAL.
 DEFINE VAR x-ImpMn2  AS DECIMAL.
 DEFINE FRAME f-cab
        RMOV.CodAux COLUMN-LABEL "Codigo"
        RMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        RMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        RMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        RMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        RMOV.Fchdoc COLUMN-LABEL "Octavo Dia" FORMAT "99/99/9999" 
        RMOV.ImpMn2 
        RMOV.ImpMn1 
        RMOV.TpoCmb 
        RMOV.NroAst COLUMN-LABEL "Voucher" FORMAT "X(7)"
        RMOV.CodOpe COLUMN-LABEL "Libro"
        HEADER
        S-NOMCIA
        "DOCUMENTOS CANCELADOS" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                       " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient Octavo Dia    Importe(US$)    Importe(S/.)  T/Cambio Voucher Libro" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
 PUT STREAM report CONTROL "~033x" NULL "~017~033P".
 FOR EACH RMOV 
     BREAK BY RMOV.CodCia
            BY RMOV.Codaux
             BY RMOV.Fchvto
              BY RMOV.Coddoc:
     DISPLAY STREAM report 
             RMOV.CodAux
             RMOV.GloDoc
             RMOV.coddoc
             RMOV.nrodoc
             RMOV.fchvto
             RMOV.fchvto + 8 @ RMOV.FchDoc
             RMOV.ImpMn1 
             RMOV.ImpMn2 
             RMOV.TpoCmb 
             RMOV.NroAst 
             RMOV.CodOpe WITH FRAME F-Cab.
     x-ImpMn1 = IF RMOV.TpoMov THEN - RMOV.ImpMn1 ELSE RMOV.ImpMn1.
     x-ImpMn2 = IF RMOV.TpoMov THEN - RMOV.ImpMn2 ELSE RMOV.ImpMn2.
     ACCUMULATE x-ImpMn1 (TOTAL BY RMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY RMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY RMOV.CodAux).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY RMOV.CodAux).
     IF LAST-OF(RMOV.CodAux) THEN DO:
        UNDERLINE STREAM report RMOV.GloDoc
                                RMOV.ImpMn1
                                RMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL PROV. " + RMOV.CodAux) @ RMOV.GloDoc
                       ACCUM SUB-TOTAL BY (RMOV.CodAux) x-ImpMn1 @ RMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (RMOV.CodAux) x-ImpMn2 @ RMOV.ImpMn2
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report RMOV.GloDoc
                                RMOV.ImpMn1
                                RMOV.ImpMn2
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(RMOV.CodCia) THEN DO:
        UNDERLINE STREAM report RMOV.GloDoc
                                RMOV.ImpMn1
                                RMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ RMOV.GloDoc
                       ACCUM TOTAL BY (RMOV.CodCia) x-ImpMn1 @ RMOV.ImpMn1
                       ACCUM TOTAL BY (RMOV.CodCia) x-ImpMn2 @ RMOV.ImpMn2
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.


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

  RUN Carga-Detalle.

  F-CODAUX = X-CODAUX.
  F-CodDoc = X-CODDOC.
  F-NRODOC = X-NRODOC.
  FIND gn-prov WHERE gn-prov.CodCia = CB-CODCIA AND
       gn-prov.CodPro = X-CODAUX NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN F-NOMAUX = gn-prov.NomPro.
  DISPLAY F-CODAUX F-NOMAUX F-CodDoc F-NRODOC WITH FRAME {&FRAME-NAME}.

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
        WHEN "" THEN .
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "RMOV"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


