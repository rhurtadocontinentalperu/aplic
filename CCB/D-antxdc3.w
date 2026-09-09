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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEF SHARED VAR cl-codcia AS INT.

DEFINE VAR I-TPOREP AS INTEGER INIT 1.

/* Local Variable Definitions ---                                       */
def var tporep as integer.
def var subtit as character.
def var subtit-1 as character.
def var subdiv as character format 'x(50)'.

DEF TEMP-TABLE DETALLE LIKE Ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-Desde x-Hasta x-FchDoc Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje F-Division x-Desde x-Hasta ~
x-FchDoc 

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

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Corte" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-mensaje AT ROW 6.65 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     F-Division AT ROW 2.35 COL 13 COLON-ALIGNED
     BUTTON-1 AT ROW 2.35 COL 59
     x-Desde AT ROW 3.42 COL 13 COLON-ALIGNED WIDGET-ID 18
     x-Hasta AT ROW 3.42 COL 35 COLON-ALIGNED WIDGET-ID 20
     x-FchDoc AT ROW 4.5 COL 13 COLON-ALIGNED
     Btn_OK AT ROW 1.81 COL 71
     Btn_Cancel AT ROW 3.35 COL 71
     SPACE(3.71) SKIP(3.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resumen Documentos por Cobrar".


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

/* SETTINGS FOR FILL-IN F-Division IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen Documentos por Cobrar */
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
  ASSIGN F-Division x-Desde x-FchDoc x-Hasta.

  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division D-Dialog
ON LEAVE OF F-Division IN FRAME D-Dialog /* Division */
DO:
/*    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
 *     If available gn-divi then
 *         F-DesDiv:screen-value = gn-divi.desdiv.
 *     else
 *         F-DesDiv:screen-value = "".*/
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

DEFINE VAR XDOCINI AS CHAR.
DEFINE VAR XDOCFIN AS CHAR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal D-Dialog 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Control AS INT NO-UNDO.
  DEF VAR x-Division AS CHAR NO-UNDO.
/*

  DEF FRAME F-Mensaje
    SPACE(1) SKIP
    'Procesando: ' ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    'Un momento por favor...' SKIP
    SPACE(1)
    WITH CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX TITLE 'DETERMINANDO SALDOS'.
  DEF FRAME F-Mensaje-1
    SPACE(1) SKIP
    'Procesando: ' ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    'Un momento por favor...' SKIP
    SPACE(1)
    WITH CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX TITLE 'DETERMINANDO SALDOS'.
        
  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.
*/

DO x-Control = 1 TO NUM-ENTRIES(f-Division):
  x-Division = ENTRY(x-Control, f-Division).
  /* DOS procesos */
  IF x-FchDoc < TODAY THEN DO:
    FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        /*AND Ccbcdocu.coddoc BEGINS x-Docu*/
        AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET') > 0
        AND Ccbcdocu.coddiv = x-Division
        AND Ccbcdocu.flgest <> 'A'
        AND Ccbcdocu.fchdoc >= x-Desde
        AND Ccbcdocu.fchdoc <= x-Hasta
        AND Ccbcdocu.fchdoc <= x-FchDoc NO-LOCK,
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli:

        /*
        DISPLAY ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc
          WITH FRAME F-Mensaje.
        */
        DISPLAY STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        /* RHC 03.11.05 hay casos que no tiene sustento de cancelacion => nos fijamos en la fecha de cancelacion */
        IF ccbcdocu.flgest = 'C' 
            AND ccbcdocu.fchcan <> ? 
            AND ccbcdocu.fchcan <= x-FchDoc THEN DO:
            FIND FIRST Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                AND Ccbdcaja.codref = Ccbcdocu.coddoc
                AND Ccbdcaja.nroref = Ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbdcaja THEN NEXT.
        END.

        IF ccbcdocu.flgest = 'C' AND ccbcdocu.fchcan = ? THEN NEXT.   /* Suponemos que está cancelada en la fecha */
        /* ***************************************************************************************************** */
        CREATE DETALLE.
        BUFFER-COPY Ccbcdocu TO DETALLE
            ASSIGN DETALLE.sdoact = Ccbcdocu.imptot.
        /* Buscamos las cancelaciones */
        FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
            AND Ccbdcaja.codref = Ccbcdocu.coddoc
            AND Ccbdcaja.nroref = Ccbcdocu.nrodoc
            AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
            ASSIGN
                DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
        END.            

        IF DETALLE.CodDoc = 'N/C' THEN DO:
            FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
                AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
                AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
                ASSIGN
                    DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
            END.            
        END.
    END.
    HIDE FRAME F-Mensaje.
  END.
  ELSE DO:
      FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
          /*AND Ccbcdocu.coddoc BEGINS x-Docu*/
          AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET') > 0
          AND Ccbcdocu.coddiv = x-Division
          AND Ccbcdocu.flgest = 'P' NO-LOCK,
          FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = Ccbcdocu.codcli:
          /*
          DISPLAY ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc
              WITH FRAME F-Mensaje-1.
          */

          DISPLAY STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + 
              ccbcdocu.nrodoc @ x-mensaje
              WITH FRAME {&FRAME-NAME}.

          CREATE DETALLE.
          BUFFER-COPY Ccbcdocu TO DETALLE
              ASSIGN DETALLE.sdoact = Ccbcdocu.sdoact.
          IF DETALLE.FchVto = ? THEN DETALLE.FchVto = DETALLE.FchDoc.
      END.
      /*
      HIDE FRAME F-Mensaje-1.
      */
  END.
END.

DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

  /* Depuramos los cancelados */
FOR EACH DETALLE:
    IF DETALLE.sdoact <= 0 THEN DO:
        DELETE DETALLE.
        NEXT.
    END.
END.
                  
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
  DISPLAY x-mensaje F-Division x-Desde x-Hasta x-FchDoc 
      WITH FRAME D-Dialog.
  ENABLE BUTTON-1 x-Desde x-Hasta x-FchDoc Btn_OK Btn_Cancel 
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

/*
 DEFINE VARIABLE F-Impor AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Saldo AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Rango AS DECIMAL EXTENT 10 NO-UNDO.
 DEFINE VARIABLE F-Dias  AS INTEGER NO-UNDO.

 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "RESUMEN DOCUMENTOS POR COBRAR AL " x-FchDoc  AT 50 
        "FECHA : " AT 115 TODAY SKIP       
        /*
        SubDiv AT 62 FORMAT "X(30)" 
        {&PRN6A} + "HORA : " + {&PRN6B} AT 115 STRING(TIME,"HH:MM") SKIP
        {&PRN6A} + SubTit + {&PRN6B} AT 55 FORMAT "X(32)" SKIP
        {&PRN6A} + SubTit-1 + {&PRN6B} FORMAT "X(50)" SKIP
        */
        "------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                Documentos  Vencidos                      Documentos por Vencer                                    " SKIP
        "Div   Cliente   Razon Social            Importe Total S/.   Importe Total $.      Importe Total S/.   Importe Total $.   " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123 XXX-XXXXXX 99/99/9999 99/99/9999 (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) 
*/

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 250 STREAM-IO DOWN.


 DEFINE FRAME F-Detalle
        CcbCDocu.CodDoc COLUMN-LABEL "Tip!Doc" FORMAT "X(3)"
        CcbCDocu.NroDoc COLUMN-LABEL "Numero de!Documento" FORMAT "XXX-XXXXXX"
        CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Documento"
        CcbCDocu.FchVto COLUMN-LABEL "Fecha de!Vencimient"
        F-Rango[2]      COLUMN-LABEL "0-7   Dias"       FORMAT "(>>>,>>9.99)"
        F-Rango[3]      COLUMN-LABEL "8-15  Dias"       FORMAT "(>>>,>>9.99)"
        F-Rango[4]      COLUMN-LABEL "15-30 Dias"       FORMAT "(>>>,>>9.99)"
        F-Rango[5]      COLUMN-LABEL "31-60 Dias"       FORMAT "(>>>,>>9.99)"
        F-Rango[6]      COLUMN-LABEL "61-90 Dias"       FORMAT "(>>>,>>9.99)"
        F-Rango[7]      COLUMN-LABEL "91-180 Dias"      FORMAT "(>>>,>>9.99)"
        F-Rango[8]      COLUMN-LABEL "181-270 Dias"     FORMAT "(>>>,>>9.99)"
        F-Rango[9]      COLUMN-LABEL "271-360 Dias"     FORMAT "(>>>,>>9.99)"
        F-Rango[10]      COLUMN-LABEL " > 360 Dias"     FORMAT "(>>>,>>9.99)"
        F-Rango[1]      COLUMN-LABEL "Por Vencer"       FORMAT "(>>>,>>9.99)"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia     
                    AND  CcbCDocu.coddoc BEGINS x-docu  
                    AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET') > 0
                    AND  CcbCDocu.codcli >= clienteD    
                    AND  (ClienteH = '' OR CcbCDocu.codcli <= clienteH)
                    AND  CcbCDocu.flgest = "P"          
                    /*AND  CcbCDocu.FchVto <= TODAY*/
                    AND  CcbCDocu.CodDiv BEGINS F-Division
                    AND  CcbCDocu.CodMon = x-moneda
                    AND  CcbCDocu.FchDoc <= x-FchDoc
                BREAK BY CcbCDocu.CodCia
                      BY CcbCDocu.CodCli
                      BY CcbCDocu.coddoc
                      BY CcbCDocu.nrodoc:
     VIEW STREAM REPORT FRAME F-Titulo.
     IF FIRST-OF(CcbCDocu.CodCli) THEN DO:
        PUT STREAM REPORT 
            SKIP(1)
            {&PRN6A} + "Cliente : " AT 1 FORMAT "X(15)" CcbCDocu.codcli FORMAT "X(12)" CcbCDocu.NomCli + {&PRN6B} FORMAT "X(60)" SKIP(1).
     END.
     ASSIGN
        F-Impor = CcbCDocu.ImpTot
        F-Saldo = CcbCDocu.SdoAct.
     
/*     FIND FacDocum WHERE FacDocum.codcia = S-CODCIA AND
 *           FacDocum.CodDoc = CcbCDocu.coddoc NO-LOCK NO-ERROR.
 *      IF AVAILABLE FacDocum AND NOT FacDocum.TpoDoc THEN*/
    IF CcbCDocu.CodDoc = 'N/C' THEN
        ASSIGN F-Impor = F-Impor * -1
               F-Saldo = F-Saldo * -1.
     F-Rango[1] = 0.
     F-Rango[2] = 0.
     F-Rango[3] = 0.
     F-Rango[4] = 0.
     F-Rango[5] = 0.
     F-Rango[6] = 0.
     F-Rango[7] = 0.
     F-Rango[8] = 0.
     F-Rango[9] = 0.
     F-Rango[10] = 0.
     IF CcbCDocu.FchVto > TODAY THEN F-Rango[1] = F-Impor.
     ELSE DO:
         F-DIAS = TODAY - CcbCDocu.FchVto.
         IF F-DIAS > 360 THEN F-Rango[10] = F-Saldo. /* > 361 */
         IF F-DIAS > 270 AND F-DIAS <= 360 THEN F-Rango[9] = F-Saldo. /* 271-360 */
         IF F-DIAS > 180 AND F-DIAS <= 270 THEN F-Rango[8] = F-Saldo. /* 181-270 */
         IF F-DIAS > 90 AND F-DIAS <= 180 THEN F-Rango[7] = F-Saldo. /*91-180 */
         IF F-DIAS > 60 AND F-DIAS <= 90  THEN F-Rango[6] = F-Saldo. /*61-90 */

         IF F-DIAS > 30 AND F-DIAS < 60 THEN F-Rango[5] = F-Saldo. /* 31-60  */
         IF F-DIAS > 15 AND F-DIAS < 30 THEN F-Rango[4] = F-Saldo. /* 61-90  */
         IF F-DIAS > 8  AND F-DIAS < 15 THEN F-Rango[3] = F-Saldo. /* 31-60  */
         IF F-DIAS >= 0 AND F-DIAS < 8  THEN F-Rango[2] = F-Saldo. /* 15-30  */
     END.
     IF CcbCDocu.FchVto <= TODAY THEN
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc
             CcbCDocu.NroDoc
             CcbCDocu.FchDoc
             CcbCDocu.FchVto
             F-Rango[2] WHEN F-Rango[2] <> 0
             F-Rango[3] WHEN F-Rango[3] <> 0
             F-Rango[4] WHEN F-Rango[4] <> 0
             F-Rango[5] WHEN F-Rango[5] <> 0
             F-Rango[6] WHEN F-Rango[6] <> 0
             F-Rango[7] WHEN F-Rango[7] <> 0
             F-Rango[8] WHEN F-Rango[8] <> 0
             F-Rango[9] WHEN F-Rango[9] <> 0
             F-Rango[10] WHEN F-Rango[10] <> 0
             WITH FRAME F-Detalle.
            
     ACCUMULATE F-Impor    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Saldo    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[1] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[2] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[3] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[4] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[5] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[6] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[7] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[8] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[9] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[10] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Impor    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Saldo    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[1] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[2] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[3] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[4] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[5] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[6] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[7] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[8] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[9] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[10] (SUB-TOTAL BY CcbCDocu.CodCli).

     IF LAST-OF(CcbCDocu.CodCli) THEN DO:
        UNDERLINE STREAM REPORT 
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]       
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8]
                  F-Rango[9]
                  F-Rango[10] WITH FRAME F-Detalle.
        PUT STREAM REPORT
            " TOTAL >>"
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[2] FORMAT "(>>>,>>9.99)" AT 38 SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[3] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[4] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[5] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[6] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[7] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[8] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[9] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[10] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[1] FORMAT "(>>>,>>9.99)" 
            SKIP(1).
            
/*        DISPLAY STREAM REPORT 
 *                 " TOTAL  >>"   @ CcbCDocu.FchVto    
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[2] @ F-Rango[2]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[3] @ F-Rango[3]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[4] @ F-Rango[4]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[5] @ F-Rango[5]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[6] @ F-Rango[6]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[7] @ F-Rango[7]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[8] @ F-Rango[8]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[9] @ F-Rango[9]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[10] @ F-Rango[10]
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[1] @ F-Rango[1]
 *                 WITH FRAME F-Detalle.
 *         DOWN STREAM REPORT WITH FRAME F-Detalle.*/
     END.
     IF LAST-OF(CcbCDocu.CodCia) THEN DO:
        UNDERLINE STREAM REPORT 
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8]
                  F-Rango[9]
                  F-Rango[10] WITH FRAME F-Detalle.
        PUT STREAM REPORT
            " TOTAL GENERAL >>"
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[2] FORMAT "(>>>,>>9.99)" AT 38 SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[3] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[4] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[5] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[6] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[7] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[8] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[9] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[10] FORMAT "(>>>,>>9.99)" SPACE(1)
            ACCUM SUB-TOTAL BY (CcbCDocu.CodCia) F-Rango[1] FORMAT "(>>>,>>9.99)" 
            SKIP(1).

/*        DISPLAY STREAM REPORT 
 *                 "     TOTAL"   @ CcbCDocu.FchDoc
 *                 "GENERAL >>"   @ CcbCDocu.FchVto
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[2] @ F-Rango[2]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[3] @ F-Rango[3]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[4] @ F-Rango[4]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[5] @ F-Rango[5]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[6] @ F-Rango[6]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[7] @ F-Rango[7]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[8] @ F-Rango[8]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[9] @ F-Rango[9]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[10] @ F-Rango[10]
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[1] @ F-Rango[1]
 *                 WITH FRAME F-Detalle.
 *         UNDERLINE STREAM REPORT 
 *                   F-Rango[2]     
 *                   F-Rango[3]     
 *                   F-Rango[4]     
 *                   F-Rango[5]     
 *                   F-Rango[6]     
 *                   F-Rango[7]     
 *                   F-Rango[8]
 *                   F-Rango[9]
 *                   F-Rango[10] WITH FRAME F-Detalle.
 *         DOWN STREAM REPORT 1 WITH FRAME F-Detalle.*/
     END.
 END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 D-Dialog 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE F-Impor AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Saldo AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Rango AS DECIMAL EXTENT 10 NO-UNDO.
 DEFINE VARIABLE F-Dias  AS INTEGER NO-UNDO.

 DEFINE VARIABLE dSdoAct-1 AS DECIMAL NO-UNDO EXTENT 2.
 DEFINE VARIABLE dSdoAct-2 AS DECIMAL NO-UNDO EXTENT 2.
 DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.

 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "RESUMEN DOCUMENTOS POR COBRAR AL " AT 50 x-FchDoc  AT 85 
        "FECHA : " AT 115 TODAY SKIP     
        "DESDE : " x-Desde 
        "HASTA : " AT 115 x-Hasta SKIP     
        /*
        SubDiv AT 62 FORMAT "X(30)" 
        {&PRN6A} + "HORA : " + {&PRN6B} AT 115 STRING(TIME,"HH:MM") SKIP
        {&PRN6A} + SubTit + {&PRN6B} AT 55 FORMAT "X(32)" SKIP
        {&PRN6A} + SubTit-1 + {&PRN6B} FORMAT "X(50)" SKIP
        */
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Documentos  Vencidos            Documentos por Vencer                                    " SKIP
        "Div   Cliente      Razon Social                                           Importe S/.      Importe $.      Importe S/.      Importe $.          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123 XXX-XXXXXX 99/99/9999 99/99/9999 (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) 
*/

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 250 STREAM-IO DOWN.

 DEFINE FRAME F-Detalle
        DETALLE.CodDiv 
        DETALLE.CodCli FORMAT "XXXXXXXXXXX"
        DETALLE.NomCli 
        dSdoAct-1[1]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-1[2]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-2[1]   FORMAT "->>>,>>>,>>9.99"
        dSdoAct-2[2]   FORMAT "->>>,>>>,>>9.99"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 190 STREAM-IO DOWN.

 FOR EACH DETALLE NO-LOCK 
     BREAK BY DETALLE.CodCia
     BY DETALLE.CodDiv
     BY DETALLE.CodCli:
     VIEW STREAM REPORT FRAME F-Titulo.

     FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
         AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
     IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
     ELSE cNomCli = "".

     IF FIRST-OF(Detalle.CodCli) THEN DO:
         dSdoAct-1 = 0.
         dSdoAct-2 = 0.
     END.

     IF Detalle.FchVto < 01/15/2010 THEN DO:
         CASE Detalle.CodMon:
             WHEN 1 THEN dSdoAct-1[1] = Detalle.SdoAct + dSdoAct-1[1].
             WHEN 2 THEN dSdoAct-1[2] = Detalle.SdoAct + dSdoAct-1[2].
         END CASE.
     END.
     ELSE DO:
         CASE Detalle.CodMon:
             WHEN 1 THEN dSdoAct-2[1] = Detalle.SdoAct + dSdoAct-2[1].
             WHEN 2 THEN dSdoAct-2[2] = Detalle.SdoAct + dSdoAct-2[2].
         END CASE.
     END.

     IF LAST-OF(Detalle.CodCli) THEN
         DISPLAY STREAM Report
            Detalle.CodDiv
            Detalle.CodCli
            cNomCli @ Detalle.NomCli
            dSdoAct-1[1]
            dSdoAct-1[2]
            dSdoAct-2[1]
            dSdoAct-2[2]
            WITH FRAME f-Detalle.     
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1A D-Dialog 
PROCEDURE Formato-1A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
 DEFINE VARIABLE F-Impor AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Saldo AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Rango AS DECIMAL EXTENT 10 NO-UNDO.
 DEFINE VARIABLE F-Dias  AS INTEGER NO-UNDO.
 DEFINE VAR x-CodMon AS CHAR NO-UNDO.
 DEFINE VARIABLE D-Rango AS DECIMAL EXTENT 10 NO-UNDO.
 DEFINE VARIABLE T-Rango AS DECIMAL EXTENT 10 NO-UNDO.

 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "CUENTAS POR COBRAR POR ANTIGUEDAD 15-30-60-90-180-270+" AT 50 
        "FECHA : " AT 115 TODAY SKIP       
        {&PRN6A} + "HORA : " + {&PRN6B} AT 115 STRING(TIME,"HH:MM") SKIP
        {&PRN6A} + SubTit + {&PRN6B} AT 55 FORMAT "X(32)" SKIP
        {&PRN6A} + SubTit-1 + {&PRN6B} FORMAT "X(50)" SKIP
        SubDiv FORMAT "X(150)" SKIP
   "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
   "                           (                                                  DIAS VENCIDOS                                                    )              " SKIP
   "Division               Mon        0-7         8-15        16-30        31-60        61-90       91-180      181-270      271-360        > 360     Por Vencer  " SKIP
   "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 123456789012345 123 (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) 
*/

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 230 STREAM-IO DOWN.


 DEFINE FRAME F-Detalle
        DETALLE.CodDiv      FORMAT "X(6)"
        GN-DIVI.DesDiv      FORMAT "X(15)"
        x-CodMon            FORMAT "X(3)"
        F-Rango[2]      COLUMN-LABEL "0-7   Dias"       FORMAT "(>>>>>>9.99)"
        F-Rango[3]      COLUMN-LABEL "8-15  Dias"       FORMAT "(>>>>>>9.99)"
        F-Rango[4]      COLUMN-LABEL "15-30 Dias"       FORMAT "(>>>>>>9.99)"
        F-Rango[5]      COLUMN-LABEL "31-60 Dias"       FORMAT "(>>>>>>9.99)"
        F-Rango[6]      COLUMN-LABEL "61-90 Dias"       FORMAT "(>>>>>>9.99)"
        F-Rango[7]      COLUMN-LABEL "91-180 Dias"      FORMAT "(>>>>>>9.99)"
        F-Rango[8]      COLUMN-LABEL "181-270 Dias"     FORMAT "(>>>>>>9.99)"
        F-Rango[9]      COLUMN-LABEL "271-360 Dias"     FORMAT "(>>>>>>9.99)"
        F-Rango[10]      COLUMN-LABEL " > 360 Dias"     FORMAT "(>>>>>>9.99)"
        F-Rango[1]      COLUMN-LABEL "Por Vencer"       FORMAT "(>>>>>>9.99)"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

 FOR EACH DETALLE NO-LOCK,
        FIRST GN-DIVI OF DETALLE NO-LOCK
                BREAK BY DETALLE.CodCia
                      BY DETALLE.CodDiv
                      BY DETALLE.CodMon:
     VIEW STREAM REPORT FRAME F-Titulo.

    IF FIRST-OF(DETALLE.CodDiv)
    THEN ASSIGN
            D-Rango[1] = 0
            D-Rango[2] = 0
            D-Rango[3] = 0
            D-Rango[4] = 0
            D-Rango[5] = 0
            D-Rango[6] = 0
            D-Rango[7] = 0
            D-Rango[8] = 0
            D-Rango[9] = 0
            D-Rango[10] = 0.
    
     ASSIGN
        F-Impor = DETALLE.ImpTot
        F-Saldo = DETALLE.SdoAct.
     
    IF DETALLE.CodDoc = 'N/C' THEN
        ASSIGN F-Impor = F-Impor * -1
               F-Saldo = F-Saldo * -1.
    F-Rango[1] = 0.
    F-Rango[2] = 0.
    F-Rango[3] = 0.
    F-Rango[4] = 0.
    F-Rango[5] = 0.
    F-Rango[6] = 0.
    F-Rango[7] = 0.
    F-Rango[8] = 0.
    F-Rango[9] = 0.
    F-Rango[10] = 0.
    IF DETALLE.FchVto > x-FchDoc THEN F-Rango[1] = F-Impor.
    ELSE DO:
         F-DIAS = x-FchDoc - DETALLE.FchVto.
         
         IF F-DIAS >= 360 THEN F-Rango[10] = F-Saldo. /* > 361 */
         IF F-DIAS > 270 AND F-DIAS < 360 THEN F-Rango[9] = F-Saldo. /* 271-360 */
         IF F-DIAS > 180 AND F-DIAS <= 270 THEN F-Rango[8] = F-Saldo. /* 181-270 */
         IF F-DIAS > 90 AND F-DIAS <= 180 THEN F-Rango[7] = F-Saldo. /*91-180 */
         IF F-DIAS > 60 AND F-DIAS <= 90  THEN F-Rango[6] = F-Saldo. /*61-90 */

         IF F-DIAS > 30 AND F-DIAS < 60 THEN F-Rango[5] = F-Saldo. /* 31-60  */
         IF F-DIAS > 15 AND F-DIAS < 30 THEN F-Rango[4] = F-Saldo. /* 61-90  */
         IF F-DIAS > 8  AND F-DIAS < 15 THEN F-Rango[3] = F-Saldo. /* 31-60  */
         IF F-DIAS >= 0 AND F-DIAS < 8  THEN F-Rango[2] = F-Saldo. /* 15-30  */
    END.
    ACCUMULATE F-Impor    (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Saldo    (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[1] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[2] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[3] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[4] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[5] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[6] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[7] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[8] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[9] (SUB-TOTAL BY DETALLE.CodMon).
    ACCUMULATE F-Rango[10] (SUB-TOTAL BY DETALLE.CodMon).
    IF LAST-OF(DETALLE.CodMon) THEN DO:
        IF DETALLE.CodMon = 2
        THEN ASSIGN
                D-Rango[1] = D-Rango[1] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[1] 
                D-Rango[2] = D-Rango[2] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[2] 
                D-Rango[3] = D-Rango[3] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[3] 
                D-Rango[4] = D-Rango[4] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[4] 
                D-Rango[5] = D-Rango[5] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[5] 
                D-Rango[6] = D-Rango[6] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[6] 
                D-Rango[7] = D-Rango[7] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[7] 
                D-Rango[8] = D-Rango[8] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[8] 
                D-Rango[9] = D-Rango[9] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[9] 
                D-Rango[10] = D-Rango[10] + ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[10] .
        ELSE 
            ASSIGN
                D-Rango[1] = D-Rango[1] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[1]) / x-TpoCmb
                D-Rango[2] = D-Rango[2] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[2]) / x-TpoCmb
                D-Rango[3] = D-Rango[3] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[3]) / x-TpoCmb
                D-Rango[4] = D-Rango[4] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[4]) / x-TpoCmb
                D-Rango[5] = D-Rango[5] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[5]) / x-TpoCmb
                D-Rango[6] = D-Rango[6] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[6]) / x-TpoCmb
                D-Rango[7] = D-Rango[7] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[7]) / x-TpoCmb
                D-Rango[8] = D-Rango[8] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[8]) / x-TpoCmb
                D-Rango[9] = D-Rango[9] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[9]) / x-TpoCmb
                D-Rango[10] = D-Rango[10] + (ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[10]) / x-TpoCmb.
        x-CodMon = IF DETALLE.CodMon = 1 THEN 'S/.' ELSE 'US$'.
        DISPLAY STREAM REPORT
            DETALLE.CodDiv 
            GN-DIVI.DesDiv
            x-CodMon            
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[2] @ F-Rango[2]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[3] @ F-Rango[3]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[4] @ F-Rango[4]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[5] @ F-Rango[5]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[6] @ F-Rango[6]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[7] @ F-Rango[7]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[8] @ F-Rango[8]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[9] @ F-Rango[9]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[10] @ F-Rango[10]
            ACCUM SUB-TOTAL BY (DETALLE.CodMon) F-Rango[1] @ F-Rango[1]
            WITH FRAME F-Detalle.
    END.
    IF LAST-OF(DETALLE.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT 
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]       
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8]
                  F-Rango[9]
                  F-Rango[10] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT
            "TOTAL DIVISION >>" @ GN-DIVI.DesDiv
            "US$" @ x-CodMon
            D-Rango[2] @ F-Rango[2]
            D-Rango[3] @ F-Rango[3]
            D-Rango[4] @ F-Rango[4]
            D-Rango[5] @ F-Rango[5]
            D-Rango[6] @ F-Rango[6]
            D-Rango[7] @ F-Rango[7]
            D-Rango[8] @ F-Rango[8]
            D-Rango[9] @ F-Rango[9]
            D-Rango[10] @ F-Rango[10]
            D-Rango[1] @ F-Rango[1] 
            WITH FRAME F-Detalle.
        DOWN STREAM REPORT 2 WITH FRAME F-Detalle.
        ASSIGN
            T-Rango[1] = T-Rango[1] + D-Rango[1]
            T-Rango[2] = T-Rango[2] + D-Rango[2]
            T-Rango[3] = T-Rango[3] + D-Rango[3]
            T-Rango[4] = T-Rango[4] + D-Rango[4]
            T-Rango[5] = T-Rango[5] + D-Rango[5]
            T-Rango[6] = T-Rango[6] + D-Rango[6]
            T-Rango[7] = T-Rango[7] + D-Rango[7]
            T-Rango[8] = T-Rango[8] + D-Rango[8]
            T-Rango[9] = T-Rango[9] + D-Rango[9]
            T-Rango[10] = T-Rango[10] + D-Rango[10].
    END.
    IF LAST-OF(DETALLE.CodCia) THEN DO:
        UNDERLINE STREAM REPORT 
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8]
                  F-Rango[9]
                  F-Rango[10] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>" @ GN-DIVI.DesDiv
            "US$" @ x-CodMon
            T-Rango[2] @ f-Rango[2]
            T-Rango[3] @ f-Rango[3]
            T-Rango[4] @ f-Rango[4]
            T-Rango[5] @ f-Rango[5]
            T-Rango[6] @ f-Rango[6]
            T-Rango[7] @ f-Rango[7]
            T-Rango[8] @ f-Rango[8]
            T-Rango[9] @ f-Rango[9]
            T-Rango[10] @ f-Rango[10]
            T-Rango[1]  @ f-Rango[1]
            WITH FRAME F-Detalle.
     END.
 END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir D-Dialog 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN Borra-Temporal.
    RUN Carga-Temporal.

    IF F-Division = "" THEN  subdiv = "".
    ELSE subdiv = "Division : " + F-Division.

    subtit-1 = 'FECHA DE CORTE: ' + STRING(x-FchDoc).

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

        RUN Formato-1.

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
  DEF VAR xx as logical.
  
  x-fchdoc = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
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

DO WITH FRAME {&FRAME-NAME}:
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
            /*
        WHEN "" THEN ASSIGN input-var-1 = x-CodDept:screen-value.
        WHEN "x-CodDist" THEN DO:
               input-var-1 = x-CodDept:screen-value.
               input-var-2 = x-CodProv:screen-value.
          END.
          */
    END CASE.
END.

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

