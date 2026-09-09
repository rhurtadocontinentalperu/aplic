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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

/*
    "RECIBO     CLIENTE     NOMBRE                        EFECTIVO NETO             CHEQUE DEL DIA       BILLETERA ELECT.      POS        POS        B.D. / WHATSAPP       NOTA DE CREDITO          ANTICIPOS             RAPPI        TARJETA PUNTOS     VALE CONSUMO" SKIP
    "                                                   S/.           US$           S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        S/.        US$" SKIP
*/

DEFINE TEMP-TABLE tDetalle 
        FIELDS nrodoc   LIKE ccbccaja.nrodoc FORMAT "xxx-xxxxxx"    COLUMN-LABEL "RECIBO"
        FIELDS codcli   LIKE ccbccaja.codcli FORMAT 'x(15)'    COLUMN-LABEL "CLIENTE"
        FIELDS nomcli   LIKE ccbccaja.nomcli FORMAT "x(20)" COLUMN-LABEL "NOMBRE"
        FIELDS ImpNac1a  AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "VUELTO S/"
        FIELDS ImpUSA1a  AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "VUELTO $"
        FIELDS ImpNac1  LIKE ccbccaja.ImpNac[1] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "EFECTIVO NETO S/"
        FIELDS ImpUsa1  LIKE ccbccaja.ImpUsa[1] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "EFECTIVO NETO $"
        /*
        FIELDS ImpNac2 LIKE ccbccaja.ImpNac[2] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "CHEQUE DEL DIA DEL DIA S/"
        FIELDS ImpUSA2 LIKE ccbccaja.ImpUSA[2] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "CHEQUE DEL DIA DEL DIA $"
        FIELDS ImpNac3 LIKE ccbccaja.ImpNac[3] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "BILLETERA ELECT. DEL DIA S/"
        FIELDS ImpUSA3 LIKE ccbccaja.ImpUSA[3] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "BILLETERA ELECT. DEL DIA $"
        */
        FIELDS ImpNac4 LIKE ccbccaja.ImpNac[4] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "POS DEL DIA S/"
        FIELDS ImpUSA4 LIKE ccbccaja.ImpUSA[4] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "POS DEL DIA $"
        FIELDS ImpNac5 LIKE ccbccaja.ImpNac[5] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "B.D. / WHATSAPP DEL DIA S/"
        FIELDS ImpUSA5 LIKE ccbccaja.ImpUSA[5] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "B.D. / WHATSAPP DEL DIA $"
        FIELDS ImpNac6 LIKE ccbccaja.ImpNac[6] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "NOTA DE CREDITO DEL DIA S/"
        FIELDS ImpUSA6 LIKE ccbccaja.ImpUSA[6] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "NOTA DE CREDITO DEL DIA $"
        FIELDS ImpNac7 LIKE ccbccaja.ImpNac[7] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "ANTICIPOS DEL DIA S/"
        FIELDS ImpUSA7 LIKE ccbccaja.ImpUSA[7] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "ANTICIPOS DEL DIA $"
        /*FIELDS ImpNac8 LIKE ccbccaja.ImpNac[8] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "RAPPI DEL DIA S/"
        FIELDS ImpUSA8 LIKE ccbccaja.ImpUSA[8] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "RAPPI DEL DIA $"
        */
        FIELDS TarPtoNac  LIKE ccbccaja.TarPtoNac FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "TARJETA PUNTOS"
        FIELDS ImpNac10 LIKE ccbccaja.ImpNac[10] FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "VALE CONSUMO S/"
        FIELDS ImpUsa10 LIKE ccbccaja.ImpUSA[10] FORMAT "->>,>>>,>>>9.99" COLUMN-LABEL "VALE CONSUMO $"
    .

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
&Scoped-Define ENABLED-OBJECTS TOGGLE-excel FILL-IN-div FILL-IN-Fecha ~
TGL-pend BTN_Ok BTN_Exit RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-excel FILL-IN-div FILL-IN-Fecha ~
TGL-pend 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BTN_Exit AUTO-END-KEY DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BTN_Ok AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE FILL-IN-div AS CHARACTER FORMAT "X(8)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.46.

DEFINE VARIABLE TGL-pend AS LOGICAL INITIAL no 
     LABEL "Incluir Pendientes por Cerrar" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-excel AS LOGICAL INITIAL no 
     LABEL "En formato Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     TOGGLE-excel AT ROW 6.58 COL 12 WIDGET-ID 2
     FILL-IN-div AT ROW 1.58 COL 9 COLON-ALIGNED
     FILL-IN-Fecha AT ROW 2.35 COL 9 COLON-ALIGNED
     TGL-pend AT ROW 3.31 COL 4.72
     BTN_Ok AT ROW 4.65 COL 5
     BTN_Exit AT ROW 4.65 COL 24
     RECT-1 AT ROW 1.19 COL 2
     RECT-2 AT ROW 4.27 COL 2
     SPACE(0.42) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte Anexo Cierre de Caja".


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte Anexo Cierre de Caja */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTN_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTN_Ok D-Dialog
ON CHOOSE OF BTN_Ok IN FRAME D-Dialog /* Imprimir */
DO:

        ASSIGN
            FILL-IN-Div
            FILL-IN-Fecha
            TGL-pend
            toggle-excel.

    IF toggle-excel  THEN DO:
        RUN formatoxls.
    END.
    ELSE DO:
        RUN Imprimir.
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
  DISPLAY TOGGLE-excel FILL-IN-div FILL-IN-Fecha TGL-pend 
      WITH FRAME D-Dialog.
  ENABLE TOGGLE-excel FILL-IN-div FILL-IN-Fecha TGL-pend BTN_Ok BTN_Exit RECT-1 
         RECT-2 
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

DEFINE VARIABLE ImpNac1 AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>9.99".
DEFINE VARIABLE ImpUSA1 AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>9.99".

DEFINE FRAME f-cab
    HEADER
    S-NOMCIA FORMAT "X(60)" AT 1 
    "ANEXO CIERRE DE CAJA" AT 70
    "FECHA : " TO 213 TODAY SKIP
    "DIVISION: " FILL-IN-Div
    "PAGINA : " TO 213 PAGE-NUMBER FORMAT "ZZZ9" SKIP
    FILL("-",300) FORMAT "x(262)" SKIP
    /*
    "RECIBO     CLIENTE     NOMBRE                        EFECTIVO NETO             CHEQUE DEL DIA       CHEQUE DIFERIDO       TARJETA CREDITO       BOLETA DEPOSITO       NOTA DE CREDITO          ANTICIPOS             RAPPI        RETENCIONES        VALE CONSUMO" SKIP
    "                                                   S/.           US$           S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        S/.        US$" SKIP
    */
    /*                                                                                                                                                                                                                                   
    "RECIBO     CLIENTE     NOMBRE                        EFECTIVO NETO             CHEQUE DEL DIA       CHEQUE DIFERIDO       TARJETA CREDITO       B.D. / WHATSAPP       NOTA DE CREDITO          ANTICIPOS             RAPPI        TARJETA PUNTOS     VALE CONSUMO" SKIP
    "                                                   S/.           US$           S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        S/.        US$" SKIP
    */
    /* Susana dijo que lo de billetera electronica pase a tarjeta de credito - 09Ene2023 - se quedo si efecto estoooo
    "RECIBO     CLIENTE     NOMBRE                        EFECTIVO NETO             CHEQUE DEL DIA       CHEQUE DIFERIDO       TARJETA CREDITO       B.D. / WHATSAPP       NOTA DE CREDITO          ANTICIPOS             RAPPI        BILLETERA ELECT.   VALE CONSUMO" SKIP
    "                                                   S/.           US$           S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        S/.        US$" SKIP    
    */
    "RECIBO     CLIENTE     NOMBRE                        EFECTIVO NETO             CHEQUE DEL DIA       BILLETERA ELECT.      POS        POS        B.D. / WHATSAPP       NOTA DE CREDITO          ANTICIPOS             RAPPI        TARJETA PUNTOS     VALE CONSUMO" SKIP
    "                                                   S/.           US$           S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        US$        S/.        S/.        US$" SKIP

    FILL("-",300) FORMAT "x(262)" SKIP
    WITH WIDTH 300 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO PAGE-TOP.

VIEW FRAME f-cab.

FOR EACH ccbccaja NO-LOCK WHERE
    CcbCCaja.CodCia = s-CodCia AND
    CcbCCaja.CodDiv = FILL-IN-Div AND
    CcbCCaja.FchDoc = FILL-IN-Fecha AND
    ccbccaja.flgest <> 'A' AND
    CcbCCaja.FlgCie BEGINS IF TGL-pend THEN '' ELSE 'C'
    BREAK BY ccbccaja.usuario BY ccbccaja.coddoc DESCENDING BY ccbccaja.tipo
    WITH FRAME b STREAM-IO WIDTH 300 NO-UNDERLINE NO-LABELS NO-BOX:
    ImpNac1 = ccbccaja.ImpNac[1] - ccbccaja.VueNac.
    ImpUSA1 = ccbccaja.ImpUSA[1] - ccbccaja.VueUSA.
    ACCUMULATE ImpNac1 (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA1 (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[2] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[2] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[3] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[3] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[4] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[4] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[5] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[5] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[6] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[6] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[7] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[7] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpNac[8] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[8] (SUB-TOTAL BY ccbccaja.coddoc).    
    ACCUMULATE TarPtoNac (SUB-TOTAL BY ccbccaja.coddoc).
    /*ACCUMULATE ImpNac[9] (SUB-TOTAL BY ccbccaja.coddoc).*/
    ACCUMULATE ImpNac[10] (SUB-TOTAL BY ccbccaja.coddoc).
    ACCUMULATE ImpUSA[10] (SUB-TOTAL BY ccbccaja.coddoc).
    IF FIRST-OF(ccbccaja.usuario) THEN DO:
        DISPLAY WITH STREAM-IO.
        PUT UNFORMATTED "Cajera(o): " ccbccaja.usuario SKIP.
    END.
    IF FIRST-OF(ccbccaja.coddoc) THEN DO:
        IF ccbccaja.coddoc = "I/C" THEN
            PUT UNFORMATTED "INGRESOS" SKIP.
        ELSE
            PUT UNFORMATTED "EGRESOS" SKIP.
    END.
    IF FIRST-OF(ccbccaja.tipo) THEN DO:
        PUT UNFORMATTED ccbccaja.tipo SKIP.            
    END.
    DISPLAY
        ccbccaja.nrodoc FORMAT "xxx-xxxxxx"
        ccbccaja.codcli
        ccbccaja.nomcli FORMAT "x(20)"
        ImpNac1
        ImpUSA1
        ccbccaja.ImpNac[2] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[2] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[2] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[2] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[3] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[3] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[4] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[4] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[5] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[5] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[6] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[6] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[7] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[7] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpNac[8] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[8] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        /*ccbccaja.ImpNac[9] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"*/
        ccbccaja.TarPtoNac FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"        
        ccbccaja.ImpNac[10] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        ccbccaja.ImpUSA[10] FORMAT "->>>>>9.99" WHEN ccbccaja.coddoc = "I/C"
        WITH STREAM-IO.
    IF LAST-OF(ccbccaja.coddoc) THEN DO:
        IF ccbccaja.coddoc = "I/C" THEN DO:
            UNDERLINE
                ImpNac1
                ImpUSA1
                ccbccaja.ImpNac[2]
                ccbccaja.ImpUSA[2]
                ccbccaja.ImpNac[2]
                ccbccaja.ImpUSA[2]
                ccbccaja.ImpNac[3]
                ccbccaja.ImpUSA[3]
                ccbccaja.ImpNac[4]
                ccbccaja.ImpUSA[4]
                ccbccaja.ImpNac[5]
                ccbccaja.ImpUSA[5]
                ccbccaja.ImpNac[6]
                ccbccaja.ImpUSA[6]
                ccbccaja.ImpNac[7]
                ccbccaja.ImpUSA[7]
                ccbccaja.ImpNac[8]
                ccbccaja.ImpUSA[8]
                /*ccbccaja.ImpNac[9]*/
                ccbccaja.TarPtoNac
                ccbccaja.ImpNac[10]
                ccbccaja.ImpUSA[10]
                WITH STREAM-IO.
            DISPLAY
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ImpNac1 @ ImpNac1
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ImpUSA1 @ ImpUSA1
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[2] @ ccbccaja.ImpNac[2]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[2] @ ccbccaja.ImpUSA[2]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[3] @ ccbccaja.ImpNac[3]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[3] @ ccbccaja.ImpUSA[3]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[4] @ ccbccaja.ImpNac[4]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[4] @ ccbccaja.ImpUSA[4]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[5] @ ccbccaja.ImpNac[5]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[5] @ ccbccaja.ImpUSA[5]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[6] @ ccbccaja.ImpNac[6]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[6] @ ccbccaja.ImpUSA[6]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[7] @ ccbccaja.ImpNac[7]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[7] @ ccbccaja.ImpUSA[7]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[8] @ ccbccaja.ImpNac[8]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[8] @ ccbccaja.ImpUSA[8]
                /*ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[9] @ ccbccaja.ImpNac[9]*/
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.TarPtoNac @ ccbccaja.TarPtoNac
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpNac[10] @ ccbccaja.ImpNac[10]
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ccbccaja.ImpUSA[10] @ ccbccaja.ImpUSA[10]
                WITH STREAM-IO.
        END.
        ELSE DO:
            UNDERLINE
                ImpNac1
                ImpUSA1
                WITH STREAM-IO.
            DISPLAY
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ImpNac1 @ ImpNac1
                ACCUM SUB-TOTAL BY ccbccaja.coddoc ImpUSA1 @ ImpUSA1
                WITH STREAM-IO.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formatoxls D-Dialog 
PROCEDURE formatoxls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

                                    
DEFINE VAR x-Archivo AS CHAR.                                    
DEFINE VAR rpta AS LOG.
                                    
	SYSTEM-DIALOG GET-FILE x-Archivo
	    FILTERS 'Texto (*.xlsx)' '*.xlsx'
	    ASK-OVERWRITE
	    CREATE-TEST-FILE
	    DEFAULT-EXTENSION '.xlsx'
	    RETURN-TO-START-DIR
	    SAVE-AS
	    TITLE 'Exportar a Excel'
	    UPDATE rpta.

	IF rpta = NO OR x-Archivo = '' THEN RETURN.

DEFINE VARIABLE ImpNac1 AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>9.99".
DEFINE VARIABLE ImpUSA1 AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>9.99".

DEFINE VAR iConteo AS INTEGER.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH ccbccaja NO-LOCK WHERE
    CcbCCaja.CodCia = s-CodCia AND
    CcbCCaja.CodDiv = FILL-IN-Div AND
    CcbCCaja.FchDoc = FILL-IN-Fecha AND
    ccbccaja.flgest <> 'A' AND
    CcbCCaja.FlgCie BEGINS IF TGL-pend THEN '' ELSE 'C' :
                                                    /*
    BREAK BY ccbccaja.usuario BY ccbccaja.coddoc DESCENDING BY ccbccaja.tipo:
                                                      */
    ImpNac1 = ccbccaja.ImpNac[1] - ccbccaja.VueNac.
    ImpUSA1 = ccbccaja.ImpUSA[1] - ccbccaja.VueUSA.

    iConteo = iConteo + 1.

    CREATE tDetalle.
        ASSIGN tDetalle.nrodoc = ccbccaja.nrodoc
            tDetalle.codcli = ccbccaja.codcli
            tDetalle.nomcli = ccbccaja.nomcli
            tDetalle.ImpNac1a = ImpNac1
            tDetalle.ImpUSA1a = ImpUSA1
            tDetalle.ImpNac1 = ccbccaja.ImpNac[1]
            tDetalle.ImpUsa1 = ccbccaja.ImpUsa[1]
            /*
            tDetalle.ImpNac2 = ccbccaja.ImpNac[2]
            tDetalle.ImpUsa2 = ccbccaja.ImpUsa[2]
            tDetalle.ImpNac3 = ccbccaja.ImpNac[3]
            tDetalle.ImpUsa3 = ccbccaja.ImpUsa[3]
            */
            tDetalle.ImpNac4 = ccbccaja.ImpNac[4]
            tDetalle.ImpUsa4 = ccbccaja.ImpUsa[4]
            tDetalle.ImpNac5 = ccbccaja.ImpNac[5]
            tDetalle.ImpUsa5 = ccbccaja.ImpUsa[5]
            tDetalle.ImpNac6 = ccbccaja.ImpNac[6]
            tDetalle.ImpUsa6 = ccbccaja.ImpUsa[6]
            tDetalle.ImpNac7 = ccbccaja.ImpNac[7]
            tDetalle.ImpUsa7 = ccbccaja.ImpUsa[7]
            /*
            tDetalle.ImpNac8 = ccbccaja.ImpNac[8]
            tDetalle.ImpUsa8 = ccbccaja.ImpUsa[8]
            */
            tDetalle.ImpNac10 = ccbccaja.ImpNac[10]
            tDetalle.ImpUsa10 = ccbccaja.ImpUsa[10]
        .
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

/*c-xls-file = 'd:\xpciman\OtrapruebaZZ.xlsx'.*/

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tDetalle:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tDetalle:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido..." SKIP 
        "Cantidad de registros " iConteo.

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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-Div
            FILL-IN-Fecha
            TGL-pend.
    END.

    IF FILL-IN-Fecha = ? THEN FILL-IN-Fecha = TODAY.


/*MLR* 17/12/07 ***
    DEF VAR s-subtit AS CHAR NO-UNDO.
    DEF VAR s-divi AS CHAR NO-UNDO.

    s-subtit = "FECHA: " + STRING(FILL-IN-Fecha).
    s-divi = "DIVISION: " + FILL-IN-Div.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "ANEXO CIERRE DE CAJA"
        RB-INCLUDE-RECORDS = "O"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-subtit = " + s-subtit +
            "~ns-divi = " + s-divi
        RB-FILTER =
            "CcbCCaja.CodCia = " + STRING(s-CodCia) +
            " AND CcbCCaja.CodDiv = '" + FILL-IN-Div + "'" +
            " AND CcbCCaja.FchDoc = " +
                STRING(MONTH(FILL-IN-Fecha)) + "/" +
                STRING(DAY(FILL-IN-Fecha)) + "/" +
                STRING(YEAR(FILL-IN-Fecha)) +
            " AND ccbccaja.flgest <> 'A'" +
            " AND CcbCCaja.FlgCie BEGINS " +
                IF TGL-pend THEN "''" ELSE "'C'".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).
* ***/

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} + {&PrnD}.
        RUN Formato.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

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
  ASSIGN
    FILL-IN-Div = s-CodDiv
    FILL-IN-Fecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

