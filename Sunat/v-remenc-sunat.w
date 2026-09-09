&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DIVI FOR GN-DIVI.



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
DEF SHARED VAR s-FlgSit AS CHAR.    /* YES o NO */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR S-NOMCIA  AS CHAR.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR f-CodDoc  AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR Y-CODMON AS INTEGER NO-UNDO.
DEF VAR c-CODMON AS INTEGER NO-UNDO.
DEF VAR x-Saldo AS DECIMAL NO-UNDO.

DEF BUFFER b-ccbccaja FOR ccbccaja.
DEF BUFFER b-CDocu    FOR ccbcdocu.

DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR CodCli   AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.Glosa CcbCCaja.TpoCmb 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] ~
CcbCCaja.Glosa CcbCCaja.NroDoc CcbCCaja.CodDiv CcbCCaja.FchDoc ~
CcbCCaja.usuario CcbCCaja.TpoCmb 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Saldo FILL-IN-CodCli ~
FILL-IN-NroDoc FILL-IN-CodRef FILL-IN-NomCli FILL-IN-NroRef F-NomDiv ~
X-Status 

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
DEFINE BUTTON BUTTON-TpoCmb 
     LABEL "Modificar Tipo Cambio" 
     SIZE 18 BY .96.

DEFINE VARIABLE moneda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "S/.","US$" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencia" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "xxx-xxxxxxxx" 
     LABEL "Nro Doc" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Saldo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Documento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.57 BY 8.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Saldo AT ROW 4.08 COL 62 COLON-ALIGNED
     FILL-IN-CodCli AT ROW 3.12 COL 9 COLON-ALIGNED
     FILL-IN-NroDoc AT ROW 4.08 COL 9 COLON-ALIGNED
     moneda AT ROW 5.04 COL 9 COLON-ALIGNED HELP
          "Ingrese Moneda  --> Use flechas del cursor"
     CcbCCaja.ImpNac[1] AT ROW 6 COL 62 COLON-ALIGNED
          LABEL "Importe S/." FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.ImpUsa[1] AT ROW 6.96 COL 62 COLON-ALIGNED
          LABEL "Importe US$" FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.Glosa AT ROW 8 COL 3 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 72.14 BY 1.35
     FILL-IN-CodRef AT ROW 6 COL 9 COLON-ALIGNED
     FILL-IN-NomCli AT ROW 3.12 COL 20 COLON-ALIGNED NO-LABEL
     FILL-IN-NroRef AT ROW 6 COL 13 COLON-ALIGNED NO-LABEL
     CcbCCaja.NroDoc AT ROW 1.19 COL 9 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FONT 6
     CcbCCaja.CodDiv AT ROW 2.15 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .81
     F-NomDiv AT ROW 2.15 COL 16 COLON-ALIGNED NO-LABEL
     X-Status AT ROW 1.19 COL 62 COLON-ALIGNED
     CcbCCaja.FchDoc AT ROW 2.15 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.usuario AT ROW 3.12 COL 62 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.TpoCmb AT ROW 5.04 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     BUTTON-TpoCmb AT ROW 5.04 COL 34 WIDGET-ID 2
     "Detalle" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 7.35 COL 3.57
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCaja
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DIVI B "?" ? INTEGRAL GN-DIVI
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.65
         WIDTH              = 76.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX moneda IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN X-Status IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-TpoCmb V-table-Win
ON CHOOSE OF BUTTON-TpoCmb IN FRAME F-Main /* Modificar Tipo Cambio */
DO:
    RUN proc_ModificaTpoCmb.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli V-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = "" THEN RETURN.
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = SELF:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie  THEN DO:
            MESSAGE
                "Codigo de cliente no existe"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        DISPLAY gn-clie.NomCli @ FILL-IN-nomcli.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc V-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Nro Doc */
DO:

    ASSIGN FILL-IN-NroDoc FILL-IN-CodCli.
    IF FILL-IN-NroDoc = "" THEN RETURN.

    IF FILL-IN-CodCli = "" THEN DO:
        MESSAGE
            'Debe ingresar el cliente'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-CodCli.
        RETURN NO-APPLY.
    END.

    FIND FIRST CcbCDocu WHERE
        CcbCDocu.CodCia = s-codcia AND
        CcbCDocu.CodDoc = f-CodDoc AND
        CcbCDocu.NroDoc = FILL-IN-NroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE
            'Documento no existe'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CcbCDocu.CodCli <> FILL-IN-CodCli THEN DO:
        MESSAGE
            'Documento no corresponde a este cliente'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CcbCDocu.FlgEst = 'A' THEN DO:
        MESSAGE
            'Documento Anulado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.fchvto < TODAY THEN DO:
        MESSAGE 'N/C Vencida el' Ccbcdocu.fchvto VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CcbCDocu.FlgEst = 'C' THEN DO:
        MESSAGE
            'Documento Cancelado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CcbCDocu.Codmon = 1 THEN DO:
        c-CODMON = 1.
        Y-CODMON = 1.
        MONEDA = "S/.".
    END.
    IF CcbCDocu.Codmon = 2 THEN DO:
        c-CODMON = 2.
        Y-CODMON = 2.
        MONEDA = "US$".
    END.   
    /* ********************************************* */
    /* RHC 06/11/2015 Restricciones aprobadas por SL */
    /* ********************************************* */
    IF s-FlgSit = "YES" THEN DO:    /* Control Activo */
        IF Ccbcdocu.FchDoc < (TODAY - 90) THEN DO:
            MESSAGE 'Solo se permiten devolver anticipos dentro de los 3 meses'
            VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF GN-DIVI.CanalVenta = "MIN" AND Ccbcdocu.FchDoc < (TODAY - 30) THEN DO: /* UTILEX */
            MESSAGE 'Solo se permiten devolver anticipos dentro de los 30 dias'
            VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF FILL-IN-CodCli:SCREEN-VALUE = FacCfgGn.CliVar 
            AND Ccbcdocu.coddiv <> s-coddiv THEN DO:
            MESSAGE 'El documento ha sido registrado en otra división' SKIP
                'División:' Ccbcdocu.coddiv VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    /* *********************************************** */
    /* RHC 11/03/2016 Restriccione para tiendas utilex */
    FIND b-divi WHERE b-divi.codcia = ccbcdocu.codcia AND b-divi.coddiv = ccbcdocu.coddiv
        NO-LOCK NO-ERROR.
    IF s-Tipo = "DEVONC" 
        AND AVAILABLE b-divi 
        AND b-divi.CanalVenta = "MIN" 
        AND ccbcdocu.coddiv <> s-coddiv
        THEN DO:
        MESSAGE 'El documento ha sido registrado en las tiendas UTILEX' SKIP
            'División:' Ccbcdocu.coddiv VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* *********************************************** */
    DO WITH FRAME {&FRAME-NAME}:
        FILL-IN-Saldo:LABEL = "Saldo Documento " + MONEDA.
        FILL-IN-Saldo = CcbCDocu.SdoAct.
        x-Saldo = CcbCDocu.SdoAct.
        IF Y-CodMon = 1 THEN DO:
            CcbCcaja.ImpNac[1]:SENSITIVE = YES.
            CcbCcaja.ImpUsa[1]:SENSITIVE = NO.
            DISPLAY
                CcbCDocu.SdoAct @ CcbcCaja.ImpNac[1]
                0 @ CcbCcaja.ImpUsa[1]. 
        END.
        IF Y-CodMon = 2 THEN DO:
            CcbCcaja.ImpNac[1]:SENSITIVE = NO.
            CcbCcaja.ImpUsa[1]:SENSITIVE = YES.
            DISPLAY
                0 @ CcbCcaja.ImpNac[1]
                CcbCDocu.SdoAct @ CcbcCaja.ImpUsa[1].
        END.
        CodCli = CcbCDocu.CodCli.
        DISPLAY
            MONEDA
            FILL-IN-Saldo
            CcbCDocu.CodRef @ FILL-IN-CodRef
            CcbCDocu.NroRef @ FILL-IN-NroRef
            CcbCDocu.NomCli @ FILL-IN-NomCli.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-NroDoc IN FRAME F-Main /* Nro Doc */
OR f8 OF FILL-IN-NroDoc DO:
    CASE f-CodDoc:
        WHEN "N/C" THEN DO:
            ASSIGN
                input-var-1 = f-CodDoc
                input-var-2 = FILL-IN-CodCli:SCREEN-VALUE
                input-var-3 = "MOSTRADOR"
                output-var-1 = ?.
            RUN lkup\c-docflg-div ('N/C Pendientes').
            IF output-var-1 <> ? THEN DO:
                SELF:SCREEN-VALUE = output-var-2.
            END.
        END.
    END CASE.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpNac[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpNac[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpNac[1] IN FRAME F-Main /* Importe S/. */
DO:
    x-Saldo = INPUT CcbCcaja.ImpNac[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpUsa[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpUsa[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpUsa[1] IN FRAME F-Main /* Importe US$ */
DO:
    x-Saldo = INPUT CcbCcaja.ImpUsa[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda V-table-Win
ON RETURN OF moneda IN FRAME F-Main /* Moneda */
DO:
    APPLY "TAB":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda V-table-Win
ON VALUE-CHANGED OF moneda IN FRAME F-Main /* Moneda */
DO:

    DO WITH FRAME {&FRAME-NAME}:

        IF moneda:SCREEN-VALUE = moneda THEN RETURN NO-APPLY.
        ASSIGN moneda.

        IF INPUT FILL-IN-Nrodoc = "" THEN x-Saldo = 0.

        IF moneda = "S/." THEN y-CodMon = 1.
        ELSE y-CodMon = 2.

        IF Y-CodMon = 1 THEN DO:
            x-Saldo = x-Saldo * INPUT CcbCcaja.TpoCmb.
            CcbCcaja.ImpNac[1]:SENSITIVE = YES.
            CcbCcaja.ImpUsa[1]:SENSITIVE = NO.
            DISPLAY
                x-Saldo @ CcbCcaja.ImpNac[1]
                0 @ CcbCcaja.ImpUsa[1].
        END.
        IF Y-CodMon = 2 THEN DO:
            x-Saldo = x-Saldo / INPUT CcbCcaja.TpoCmb.
            CcbCcaja.ImpNac[1]:SENSITIVE = NO.
            CcbCcaja.ImpUsa[1]:SENSITIVE = YES.
            DISPLAY
                0 @ CcbCcaja.ImpNac[1]
                x-Saldo @ CcbCcaja.ImpUsa[1].
        END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "CcbCCaja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCaja"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  /* RHC 28/03/2016 Rutrina que verifica que no haya un cierre de caja pendiente */
  RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

    RUN proc_enable IN lh_Handle ( INPUT FALSE ).

    DO WITH FRAME {&FRAME-NAME}:
        MONEDA = "S/.". 
        Y-CODMON = 1.
        FIND LAST gn-tccja WHERE
            gn-tccja.Fecha <= TODAY 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tccja THEN
            DISPLAY gn-tccja.Compra @ CcbCCaja.TpoCmb.
        DISPLAY
            TODAY @ CcbCCaja.FchDoc
            S-USER-ID @ CcbCcaja.Usuario
            S-CODDIV @ CcbCCaja.CodDiv
            MONEDA.
        ASSIGN
            FILL-IN-CodCli:SENSITIVE = TRUE
            FILL-IN-NroDoc:SENSITIVE = TRUE
            moneda:SENSITIVE = TRUE.
        APPLY "ENTRY" TO FILL-IN-CodCli.
        BUTTON-TpoCmb:SENSITIVE = YES.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DO WITH FRAME {&FRAME-NAME}:
        FIND FacCorre WHERE
            FacCorre.CodCia = s-codcia AND
            FacCorre.CodDoc = s-coddoc AND
            FacCorre.NroSer = s-ptovta
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            CcbCCaja.CodCia  = s-codcia
            CcbCCaja.CodDoc  = s-coddoc
            CcbCCaja.NroDoc  =
                STRING(faccorre.nroser, "999") +
                STRING(faccorre.correlativo, "999999")
            CcbCCaja.CodDiv  = S-CODDIV
            CcbCCaja.Tipo    = s-tipo
            CcbCCaja.usuario = s-user-id
            CcbCCaja.CodCaja = S-CODTER
            CcbCCaja.FchDoc  = TODAY            
            /*CcbCCaja.TpoCmb  = DECI(CcbCCaja.TpoCmb:SCREEN-VALUE)*/
            CcbCCaja.ImpNac[1] = DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE)
            CcbCCaja.ImpUsa[1] = DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE)
            CcbcCaja.Flgest    = "C"
            CcbCCaja.Voucher[1] = STRING(f-CodDoc,"XXX") + TRIM(FILL-IN-NroDoc)
            CcbCCaja.CodCli  = CodCli
            CcbCCaja.NomCli  = FILL-IN-NomCli:SCREEN-VALUE
            CcbCCaja.Voucher[10] = STRING(TIME,"HH:MM:SS").
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
        RELEASE faccorre.
        CREATE CcbDCaja.
        ASSIGN
            CcbDCaja.CodCia = CcbCCaja.CodCia   
            CcbDCaja.CodDoc = CcbCCaja.CodDoc
            CcbDCaja.NroDoc = CcbCCaja.NroDoc
            CcbDCaja.CodMon = Y-CodMon
            CcbDCaja.CodRef = CcbCCaja.CodDoc
            CcbDCaja.NroRef = CcbCCaja.NroDoc
            CcbDCaja.FchDoc = CcbCCaja.FchDoc
            CcbDCaja.CodDiv = CcbCCaja.CodDiv
            CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
        IF Y-CodMon = 1 THEN DO:
            CcbDCaja.ImpTot = CcbCCaja.ImpNac[1].
        END.
        IF Y-CodMon = 2 THEN DO:
            CcbDCaja.ImpTot = CcbCCaja.ImpUsa[1].
        END.
        RUN proc_CancelaDoc.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        FILL-IN-CodCli:SENSITIVE = FALSE.
        FILL-IN-NroDoc:SENSITIVE = FALSE.
        moneda:SENSITIVE = FALSE.
        CcbCCaja.ImpNac[1]:SENSITIVE = FALSE.
        CcbCCaja.ImpUsa[1]:SENSITIVE = FALSE.
    END.

    RUN proc_enable IN lh_Handle ( INPUT TRUE ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  BUTTON-TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        FILL-IN-CodCli:SENSITIVE = FALSE.
        FILL-IN-NroDoc:SENSITIVE = FALSE.
        moneda:SENSITIVE = FALSE.
        CcbCCaja.ImpNac[1]:SENSITIVE = FALSE.
        CcbCCaja.ImpUsa[1]:SENSITIVE = FALSE.
    END.
    RUN proc_enable IN lh_Handle ( INPUT TRUE ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE monto_aplic LIKE CCBDMOV.ImpTot.

    IF ccbccaja.flgcie = "C" THEN DO:
        MESSAGE
            "Cierre de caja efectuado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF ccbccaja.flgest = "A" THEN DO:
        MESSAGE
            "Registro ya fue Anulado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":

        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = f-CodDoc AND
            B-CDocu.NroDoc = FILL-IN-NroDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                'Documento no registrado'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Elimina Detalle de la Aplicación */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = s-CodCia AND
            CCBDMOV.CodDiv = s-CodDiv AND
            CCBDMOV.NroDoc = B-CDocu.NroDoc AND
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            EXCLUSIVE-LOCK:
            /* Referencia E/C */
            IF CCBDMOV.CodRef = CcbCcaja.coddoc AND
                CCBDMOV.NroRef = CcbCcaja.NroDoc THEN
                DELETE CCBDMOV.
        END.

        IF B-CDocu.CodMon = 1 THEN DO:
            IF CcbCCaja.ImpNac[1] <> 0 THEN ASSIGN monto_aplic = CcbCCaja.ImpNac[1].
            ELSE ASSIGN monto_aplic = CcbCCaja.Impusa[1] * CcbCCaja.TpoCmb.
        END.
        ELSE DO:
            IF CcbCCaja.ImpUsa[1] <> 0 THEN ASSIGN monto_aplic = CcbCCaja.ImpUsa[1].
            ELSE ASSIGN monto_aplic = CcbCCaja.ImpNac[1] / CcbCCaja.TpoCmb.
        END.
        ASSIGN monto_aplic = ROUND(monto_aplic,2).
        RUN proc_ActualizaDoc
            (
            B-CDocu.CodDoc,
            B-CDocu.NroDoc,
            monto_aplic,
            TRUE
            ).

        FOR EACH ccbdcaja OF ccbccaja:
            DELETE ccbdcaja.
        END.

        FIND b-ccbccaja WHERE
            ROWID(b-ccbccaja) = ROWID(ccbccaja)
            EXCLUSIVE-LOCK.
        ASSIGN
            X-Status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ANULADO "
            b-ccbccaja.flgest = "A" .
        RELEASE b-ccbccaja.

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

    IF AVAILABLE CcbCCaja THEN DO WITH FRAME {&FRAME-NAME}:

        IF CcbCCaja.FlgEst = "A" THEN X-Status:SCREEN-VALUE = " ANULADO ".
        IF CcbCCaja.FlgEst = "C" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgEst = "P" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgEst = " " THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgCie = "C" THEN X-Status:SCREEN-VALUE = " CERRADO ".

        FILL-IN-NroDoc = TRIM(SUBSTRING(CcbCCaja.Voucher[1],4,15)).

        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            moneda = "S/.".
        END.
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            moneda = "US$".
        END.
        ASSIGN
            FILL-IN-CodCli = ''
            FILL-IN-NomCli = ''
            FILL-IN-CodRef = ''
            FILL-IN-NroRef = ''
            FILL-IN-Saldo:LABEL = "Saldo Documento"
            FILL-IN-Saldo = 0.
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = s-codcia AND
            CcbCDocu.CodDoc = SUBSTRING(voucher[1],1,3) AND
            CcbCDocu.NroDoc = FILL-IN-NroDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            FILL-IN-CodCli = ccbcdocu.codcli.
            FILL-IN-CodRef = CcbCDocu.CodRef.
            FILL-IN-NroRef = CcbCDocu.NroRef.
            FILL-IN-NomCli = ccbcdocu.nomcli.
            FILL-IN-Saldo:LABEL = "Saldo Documento " + moneda.
            FILL-IN-Saldo = CcbCDocu.SdoAct.
        END.
        DISPLAY
            FILL-IN-Saldo
            FILL-IN-NroDoc
            moneda
            FILL-IN-CodCli
            FILL-IN-CodRef
            FILL-IN-NomCli
            FILL-IN-NroRef.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CcbCCaja.TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  BUTTON-TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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

    IF CcbcCaja.Flgest = "A" THEN DO:
        MESSAGE
            "Recibo Anulado. Verifique"
            VIEW-AS ALERT-BOX.
        RETURN.
    END.

    s-titulo = STRING(Ccbccaja.Nrodoc,"999-999999").

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Devolución de Efectivo"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "Ccbccaja.Codcia = " + string(S-CODCIA,"9")  +
            " AND Ccbccaja.Coddoc = '" + S-CODDOC + "'" +
            " AND Ccbccaja.Nrodoc = '" + STRING(Ccbccaja.Nrodoc,"xxxxxxxxx") + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = DEVOLUCIÓN EFECTIVO".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}

  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUTTON-TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ActualizaDoc V-table-Win 
PROCEDURE proc_ActualizaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc AS CHAR.
    DEFINE INPUT PARAMETER para_NroDoc AS CHAR.
    DEFINE INPUT PARAMETER para_ImpTot AS DECIMAL.
    DEFINE INPUT PARAMETER para_SumRes AS LOGICAL.

    DO TRANSACTION ON ERROR UNDO, RETURN ERROR.
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.Codcia = S-CODCIA AND
            CcbCDocu.Coddoc = para_CodDoc AND
            CcbCDocu.Nrodoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
            IF para_SumRes THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct + para_ImpTot.
            ELSE CcbCDocu.SdoAct = CcbCDocu.SdoAct - para_ImpTot.
            IF CcbCDocu.SdoAct <= 0 
            THEN ASSIGN CcbCDocu.FlgEst = "C"
                        CcbCDocu.FchCan = TODAY.
            ELSE ASSIGN CcbCDocu.FlgEst = "P".
        END.
        ELSE RETURN ERROR.
        RELEASE CcbCDocu.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CancelaDoc V-table-Win 
PROCEDURE proc_CancelaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST B-CDocu WHERE
        B-CDocu.CodCia = s-codcia AND
        B-CDocu.CodDoc = f-CodDoc AND
        B-CDocu.NroDoc = FILL-IN-NroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDocu THEN DO:
        MESSAGE
            'Documento' F-Coddoc FILL-IN-NroDoc 'no registrado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":

        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = CcbCcaja.CodCia
            CCBDMOV.CodDiv = CcbCcaja.CodDiv
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = CcbCcaja.CodDoc
            CCBDMOV.NroRef = CcbCcaja.NroDoc
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.TpoCmb = CcbCcaja.TpoCmb
            CCBDMOV.FchMov = TODAY
            CCBDMOV.HraMov = STRING("HH:MM:SS")
            CCBDMOV.usuario = s-User-ID.

        IF B-CDocu.CodMon = 1 THEN DO:
            IF CcbCCaja.ImpNac[1] <> 0 THEN ASSIGN CCBDMOV.ImpTot = CcbCCaja.ImpNac[1].
            ELSE ASSIGN CCBDMOV.ImpTot = CcbCCaja.Impusa[1] * CcbCCaja.TpoCmb.
        END.
        ELSE DO:
            IF CcbCCaja.ImpUsa[1] <> 0 THEN ASSIGN CCBDMOV.ImpTot = CcbCCaja.ImpUsa[1].
            ELSE ASSIGN CCBDMOV.ImpTot = CcbCCaja.ImpNac[1] / CcbCCaja.TpoCmb.
        END.
        ASSIGN CCBDMOV.ImpTot = ROUND(CCBDMOV.ImpTot,2).
        RUN proc_ActualizaDoc
            (
            CCBDMOV.CodDoc,
            CCBDMOV.NroDoc,
            CCBDMOV.ImpTot,
            FALSE
            ).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ModificaTpoCmb V-table-Win 
PROCEDURE proc_ModificaTpoCmb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {adm/i-DocPssw.i s-CodCia ""TCB"" ""UPD""}

    CcbCCaja.TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
        WHEN "FILL-IN-NroDoc" THEN
            ASSIGN
                input-var-1 = f-CodDoc
                input-var-2 = FILL-IN-codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-3 = "P".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCaja"}

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

DEFINE VARIABLE x-Monto AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    IF INPUT FILL-IN-CodCli = "" THEN DO:
        MESSAGE
            "Debe ingresar el Cliente"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-CodCli.
        RETURN "ADM-ERROR".
    END.

    IF INPUT FILL-IN-NroDoc = "" THEN DO:
        MESSAGE
            "Debe ingresar el Numero de Documento"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NroDoc.
        RETURN "ADM-ERROR".
    END.

    FIND FIRST CcbCDocu WHERE
        CcbCDocu.CodCia = s-codcia AND
        CcbCDocu.CodDoc = f-CodDoc AND 
        CcbCDocu.NroDoc = INPUT FILL-IN-NroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE
            'Documento no existe'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NroDoc.
        RETURN "ADM-ERROR".
    END.
    IF CcbCDocu.CodCli <> FILL-IN-CodCli THEN DO:
        MESSAGE
            'Documento no corresponde a este cliente'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NroDoc.
        RETURN "ADM-ERROR".
    END.
    IF Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.fchvto < TODAY THEN DO:
        MESSAGE 'N/C Vencida el' Ccbcdocu.fchvto VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NroDoc.
        RETURN "ADM-ERROR".
    END.
    IF DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE) +
        DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) =  0 THEN DO:
        MESSAGE
            "Importe no debe ser cero"
            VIEW-AS ALERT-BOX ERROR.
        IF y-codmon = 1 THEN APPLY "ENTRY" TO CcbCCaja.ImpNac[1].
        IF y-codmon = 2 THEN APPLY "ENTRY" TO CcbCCaja.ImpUsa[1].
        RETURN "ADM-ERROR".      
    END.

    /* Devolucion en moneda diferente al documento */
    x-Monto = CcbCDocu.SdoAct.
    IF c-CodMon <> y-codmon THEN DO:
        IF c-codmon = 1 THEN x-Monto = x-Monto / INPUT CcbCCaja.TpoCmb.
        ELSE x-Monto = x-Monto * INPUT CcbCCaja.TpoCmb.
        x-Monto = ROUND(x-Monto,2).
    END.
    IF DECIMAL(CcbCCaja.ImpNac[1]:SCREEN-VALUE) +
        DECIMAL(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) > x-Monto THEN DO:
        MESSAGE
            "Importe Mayor al Saldo del documento"
            VIEW-AS ALERT-BOX ERROR.
        IF y-codmon = 1 THEN APPLY "ENTRY" TO CcbCCaja.ImpNac[1].
        IF y-codmon = 2 THEN APPLY "ENTRY" TO CcbCCaja.ImpUsa[1].
        RETURN "ADM-ERROR".
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

