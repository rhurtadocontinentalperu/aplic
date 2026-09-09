&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.


/*/* PARAMETROS */
 * DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
 * DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
 * DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
 * DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
 * DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */
 * 
 * /* Variables locales */
 * DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
 * DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
 * DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
 * DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
 * DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
 * DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
 * DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
 * DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
 * DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
 * DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
 * DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
 * DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
 * DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
 * DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCli CcbCMvto.CodAge ~
CcbCMvto.Glosa CcbCMvto.ImpTot CcbCMvto.NroLet 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}CodAge ~{&FP2}CodAge ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}~
 ~{&FP1}ImpTot ~{&FP2}ImpTot ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.Usuario CcbCMvto.CodCli CcbCMvto.CodAge CcbCMvto.Glosa ~
CcbCMvto.ImpTot CcbCMvto.NroLet 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc ~
FILL-IN-Estado FILL-IN-NomCli FILL-IN-RUC FILL-IN-Direccion FILL-IN-FmaPgo ~
FILL-IN-DesFmaPgo FILL-IN-Moneda FILL-IN-Monto-1 FILL-IN-FchVto-1 ~
FILL-IN-Monto-2 FILL-IN-FchVto-2 FILL-IN-Monto-3 FILL-IN-FchVto-3 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "FAC","BOL" 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Direccion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-3 AS DATE FORMAT "99/99/99":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fma. de Pago" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Moneda AS CHARACTER FORMAT "X(3)":U 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Monto-1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Monto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Monto-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Monto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Monto-3 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Monto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-RUC AS CHARACTER FORMAT "X(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDoc AT ROW 1.77 COL 13 COLON-ALIGNED
     FILL-IN-NroDoc AT ROW 1.77 COL 21 COLON-ALIGNED NO-LABEL
     CcbCMvto.NroDoc AT ROW 1 COL 13 COLON-ALIGNED
          LABEL "No. de Control"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Estado AT ROW 1 COL 38 COLON-ALIGNED
     CcbCMvto.FchDoc AT ROW 1 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.Usuario AT ROW 1.77 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCMvto.CodCli AT ROW 2.54 COL 13 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-NomCli AT ROW 2.54 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN-RUC AT ROW 3.31 COL 13 COLON-ALIGNED
     FILL-IN-Direccion AT ROW 4.08 COL 13 COLON-ALIGNED
     CcbCMvto.CodAge AT ROW 4.85 COL 13 COLON-ALIGNED
          LABEL "Lugar de Entrega" FORMAT "X(30)"
          VIEW-AS FILL-IN 
          SIZE 38 BY .81
     CcbCMvto.Glosa AT ROW 5.62 COL 13 COLON-ALIGNED
          LABEL "D.O.I" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-FmaPgo AT ROW 6.38 COL 13 COLON-ALIGNED
     FILL-IN-DesFmaPgo AT ROW 6.38 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN-Moneda AT ROW 7.15 COL 13 COLON-ALIGNED
     CcbCMvto.ImpTot AT ROW 7.15 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCMvto.NroLet AT ROW 8.5 COL 13 COLON-ALIGNED
          LABEL "No de Cuotas" FORMAT "9"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "1","2","3" 
          SIZE 5 BY 1
     FILL-IN-Monto-1 AT ROW 8.5 COL 26 COLON-ALIGNED
     FILL-IN-FchVto-1 AT ROW 8.5 COL 46 COLON-ALIGNED
     FILL-IN-Monto-2 AT ROW 9.46 COL 26 COLON-ALIGNED
     FILL-IN-FchVto-2 AT ROW 9.46 COL 46 COLON-ALIGNED
     FILL-IN-Monto-3 AT ROW 10.42 COL 26 COLON-ALIGNED
     FILL-IN-FchVto-3 AT ROW 10.42 COL 46 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCMvto
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.15
         WIDTH              = 77.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesFmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Direccion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Monto-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Monto-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Monto-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-RUC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX CcbCMvto.NroLet IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc V-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = COMBO-BOX-CodDoc:SCREEN-VALUE
    AND Ccbcdocu.nrodoc = SELF:SCREEN-VALUE
    AND Ccbcdocu.coddiv = s-coddiv
    AND Ccbcdocu.flgest = 'P'
    AND Ccbcdocu.imptot = Ccbcdocu.sdoact NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'Documento no encontrado o no cumple los requisitos' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  ASSIGN
    CcbCMvto.NroLet:SCREEN-VALUE = '1'
    FILL-IN-FchVto-1 = Ccbcdocu.fchvto
    FILL-IN-FchVto-2 = ?
    FILL-IN-FchVto-3 = ?
    FILL-IN-Monto-1 = Ccbcdocu.imptot
    FILL-IN-Monto-2 = 0
    FILL-IN-Monto-3 = 0
    FILL-IN-FchVto-1:SENSITIVE = YES
    FILL-IN-FchVto-2:SENSITIVE = NO
    FILL-IN-FchVto-3:SENSITIVE = NO
    FILL-IN-Monto-1:SENSITIVE = YES
    FILL-IN-Monto-2:SENSITIVE = NO
    FILL-IN-Monto-3:SENSITIVE = NO.
  DISPLAY
    Ccbcdocu.codcli @ CcbCMvto.CodCli
    Ccbcdocu.dircli @ FILL-IN-Direccion 
    Ccbcdocu.fmapgo @ FILL-IN-FmaPgo 
    Ccbcdocu.nomcli @ FILL-IN-NomCli 
    Ccbcdocu.ruccli @ FILL-IN-RUC
    (IF Ccbcdocu.codmon = 1 THEN 'S/.' ELSE 'US$') @ FILL-IN-Moneda 
    Ccbcdocu.Imptot @ CcbCMvto.ImpTot
    FILL-IN-FchVto-1 
    FILL-IN-Monto-1
    WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.NroLet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.NroLet V-table-Win
ON VALUE-CHANGED OF CcbCMvto.NroLet IN FRAME F-Main /* No de Cuotas */
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN '1' THEN DO:
        ASSIGN
            FILL-IN-Monto-1:SENSITIVE = YES
            FILL-IN-Monto-2:SENSITIVE = NO
            FILL-IN-Monto-3:SENSITIVE = NO
            FILL-IN-FchVto-1:SENSITIVE = YES
            FILL-IN-FchVto-2:SENSITIVE = NO
            FILL-IN-FchVto-3:SENSITIVE = NO.
        ASSIGN
            FILL-IN-Monto-1 = DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE)
            FILL-IN-Monto-2 = 0
            FILL-IN-Monto-3 = 0
            FILL-IN-FchVto-1 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?
            FILL-IN-FchVto-2 = ?
            FILL-IN-FchVto-3 = ?.
    END.
    WHEN '2' THEN DO:
        ASSIGN
            FILL-IN-Monto-1:SENSITIVE = YES
            FILL-IN-Monto-2:SENSITIVE = YES
            FILL-IN-Monto-3:SENSITIVE = NO
            FILL-IN-FchVto-1:SENSITIVE = YES
            FILL-IN-FchVto-2:SENSITIVE = YES
            FILL-IN-FchVto-3:SENSITIVE = NO.
        ASSIGN
            FILL-IN-Monto-1 = ROUND(DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) / 2, 2)
            FILL-IN-Monto-2 = ROUND(DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) / 2, 2)
            FILL-IN-Monto-3 = 0
            FILL-IN-FchVto-1 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?
            FILL-IN-FchVto-2 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?
            FILL-IN-FchVto-3 = ?.
    END.
    WHEN '3' THEN DO:
        ASSIGN
            FILL-IN-Monto-1:SENSITIVE = YES
            FILL-IN-Monto-2:SENSITIVE = YES
            FILL-IN-Monto-3:SENSITIVE = YES
            FILL-IN-FchVto-1:SENSITIVE = YES
            FILL-IN-FchVto-2:SENSITIVE = YES
            FILL-IN-FchVto-3:SENSITIVE = YES.
        ASSIGN
            FILL-IN-Monto-1 = ROUND(DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) / 3, 2)
            FILL-IN-Monto-2 = ROUND(DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) / 3, 2)
            FILL-IN-Monto-3 = ROUND(DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) / 3, 2)
            FILL-IN-FchVto-1 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?
            FILL-IN-FchVto-2 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?
            FILL-IN-FchVto-3 = IF AVAILABLE Ccbcdocu THEN Ccbcdocu.fchvto ELSE ?.
    END.
  END CASE.
  FILL-IN-Monto-1 = FILL-IN-Monto-1 +
                    (DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE) -
                     FILL-IN-Monto-1 -
                     FILL-IN-Monto-2 - 
                     FILL-IN-Monto-3).
  DISPLAY
    FILL-IN-FchVto-1 
    FILL-IN-FchVto-2 
    FILL-IN-FchVto-3 
    FILL-IN-Monto-1 
    FILL-IN-Monto-2 
    FILL-IN-Monto-3
    WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "CcbCMvto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCMvto"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FAccorre THEN DO:
    MESSAGE 'Correlativo no configurado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodDoc:SENSITIVE = YES
        FILL-IN-FchVto-1:SENSITIVE = YES
        FILL-IN-Monto-1:SENSITIVE = YES
        FILL-IN-NroDoc:SENSITIVE = YES
        CcbCMvto.CodCli:SENSITIVE = NO
        CcbCMvto.ImpTot:SENSITIVE = NO
        COMBO-BOX-CodDoc:SCREEN-VALUE = 'FAC'
        CcbCMvto.NroLet:SCREEN-VALUE = '1'.
    DISPLAY 
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ CcbCMvto.NroDoc
        TODAY @ CcbCMvto.FchDoc 
        s-user-id @ CcbCMvto.Usuario.
    APPLY 'ENTRY':U TO COMBO-BOX-CodDoc.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Cuotas AS INT NO-UNDO.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    CcbCMvto.Usuario = s-user-id.
  /* CUOTAS */
  DO x-Cuotas = 1 TO CcbCMvto.NroLet:
    CREATE Ccbdmvto.
    BUFFER-COPY Ccbcmvto TO Ccbdmvto
        ASSIGN
            CcbDMvto.TpoRef = STRING(x-Cuotas, '9').
    CASE x-Cuotas:
        WHEN 1 THEN ASSIGN
                        CcbDMvto.FchVto = FILL-IN-FchVto-1 
                        CcbDMvto.ImpTot = FILL-IN-Monto-1.
        WHEN 2 THEN ASSIGN
                        CcbDMvto.FchVto = FILL-IN-FchVto-2 
                        CcbDMvto.ImpTot = FILL-IN-Monto-3.
        WHEN 3 THEN ASSIGN
                        CcbDMvto.FchVto = FILL-IN-FchVto-3 
                        CcbDMvto.ImpTot = FILL-IN-Monto-3.
    END CASE.         
    RELEASE Ccbdmvto.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN RETURN 'ADM-ERROR'.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    CcbCMvto.CodCia = s-codcia
    CcbCMvto.CodDiv = s-coddiv
    CcbCMvto.CodDoc = s-coddoc
    CcbCMvto.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
    CcbCMvto.NroRef = COMBO-BOX-CodDoc + FILL-IN-NroDoc
    CcbCMvto.FchDoc = TODAY.
  ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE Faccorre.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH Ccbdmvto WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
        AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
        AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc 
        EXCLUSIVE-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR':
    DELETE Ccbdmvto.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodDoc:SENSITIVE = NO
        FILL-IN-NroDoc:SENSITIVE = NO
        FILL-IN-FchVto-1:SENSITIVE = NO
        FILL-IN-FchVto-2:SENSITIVE = NO
        FILL-IN-FchVto-3:SENSITIVE = NO
        FILL-IN-Monto-1:SENSITIVE = NO
        FILL-IN-Monto-2:SENSITIVE = NO
        FILL-IN-Monto-3:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Ccbcmvto THEN DO WITH FRAME {&FRAME-NAME}:
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
        AND Ccbcdocu.coddoc = SUBSTRING(Ccbcmvto.NroRef, 1, 3)
        AND Ccbcdocu.nrodoc = SUBSTRING(Ccbcmvto.nroref,4)
        NO-LOCK NO-ERROR.
    ASSIGN
        COMBO-BOX-CodDoc:SCREEN-VALUE = SUBSTRING(Ccbcmvto.nroref,1,3)
        FILL-IN-Moneda:SCREEN-VALUE = (IF Ccbcmvto.codmon = 1 THEN 'S/.' ELSE 'US$').
    DISPLAY
        SUBSTRING(Ccbcmvto.nroref,4) @ FILL-IN-NroDoc
        Ccbcdocu.fmapgo @ FILL-IN-FmaPgo 
        Ccbcdocu.nomcli @ FILL-IN-NomCli 
        Ccbcdocu.ruccli @ FILL-IN-RUC
        Ccbcdocu.dircli @ FILL-IN-Direccion.
    /* CUOTAS */
    ASSIGN
        FILL-IN-FchVto-1 = ?
        FILL-IN-FchVto-2 = ?
        FILL-IN-FchVto-3 = ?
        FILL-IN-Monto-1 = 0
        FILL-IN-Monto-2 = 0
        FILL-IN-Monto-3 = 0.
    FOR EACH Ccbdmvto WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
            AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
            AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc NO-LOCK:
        CASE Ccbdmvto.tporef:
            WHEN '1' THEN ASSIGN
                            FILL-IN-FchVto-1 = Ccbdmvto.fchvto
                            FILL-IN-Monto-1 = CcbDMvto.ImpTot.
            WHEN '2' THEN ASSIGN
                            FILL-IN-FchVto-2 = Ccbdmvto.fchvto
                            FILL-IN-Monto-2 = CcbDMvto.ImpTot.
            WHEN '3' THEN ASSIGN
                            FILL-IN-FchVto-3 = Ccbdmvto.fchvto
                            FILL-IN-Monto-3 = CcbDMvto.ImpTot.
        END CASE.
    END.        
    DISPLAY
        FILL-IN-FchVto-1 
        FILL-IN-FchVto-2 
        FILL-IN-FchVto-3 
        FILL-IN-Monto-1
        FILL-IN-Monto-2
        FILL-IN-Monto-3.
    CASE CcbCMvto.FlgEst:
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
        OTHERWISE FILL-IN-Estado:SCREEN-VALUE = 'EMITIDO'.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN vtamay/r-faccon (ROWID(ccbcmvto)).

END PROCEDURE.

/*
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR rpta AS LOG.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* LOGICA PRINCIPAL */
  SYSTEM-DIALOG PRINTER-SETUP    UPDATE rpta.
  IF rpta = NO THEN RETURN.
  
  /* Captura parametros de impresion */
  ASSIGN
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    /*RB-PRINTER-NAME = s-printer-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias
    RB-PRINT-DESTINATION = "".      /* Impresora */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'
    RB-REPORT-NAME = 'Factura Conformada'.

  OUTPUT TO PRINTER.  
  PUT CONTROL {&Prn5a} CHR(52) {&Prn5b}.
  OUTPUT CLOSE.

  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-DB-CONNECTION,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-MEMO-FILE,
                    RB-PRINT-DESTINATION,
                    RB-PRINTER-NAME,
                    RB-PRINTER-PORT,
                    RB-OUTPUT-FILE,
                    RB-NUMBER-COPIES,
                    RB-BEGIN-PAGE,
                    RB-END-PAGE,
                    RB-TEST-PATTERN,
                    RB-WINDOW-TITLE,
                    RB-DISPLAY-ERRORS,
                    RB-DISPLAY-STATUS,
                    RB-NO-WAIT,
                    RB-OTHER-PARAMETERS).    
  OUTPUT TO PRINTER.  
  PUT CONTROL {&PRN0}.
  OUTPUT CLOSE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  ASSIGN FRAME {&FRAME-NAME}
    COMBO-BOX-CodDoc 
    FILL-IN-NroDoc
    FILL-IN-FchVto-1 
    FILL-IN-FchVto-2 
    FILL-IN-FchVto-3 
    FILL-IN-Monto-1 
    FILL-IN-Monto-2 
    FILL-IN-Monto-3.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCMvto"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddiv = s-coddiv
        AND Ccbcdocu.coddoc = COMBO-BOX-CodDoc:SCREEN-VALUE
        AND Ccbcdocu.nrodoc = FILL-IN-NroDoc:SCREEN-VALUE
        AND Ccbcdocu.flgest = 'P'
        AND Ccbcdocu.imptot = Ccbcdocu.sdoact
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'Documento no cumple los requisitos o no existe'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.imptot <> DECIMAL(FILL-IN-Monto-1:SCREEN-VALUE) + 
                        DECIMAL(FILL-IN-Monto-2:SCREEN-VALUE) +
                        DECIMAL(FILL-IN-Monto-3:SCREEN-VALUE) THEN DO:
        MESSAGE 'El monto de las cuotas no cuadra con el importe del documento'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.                        
    IF CcbCMvto.Glosa:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Debe ingresar el DOI' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.
  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


