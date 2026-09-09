&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b_pen FOR CcbPenDep.
DEFINE TEMP-TABLE T-CcbPenDep NO-UNDO LIKE CcbPenDep
       FIELD CodMon AS INT
       FIELD SdoAct AS DEC.



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
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INITIAL "E/C".
DEF VAR s-ptovta AS INT.
DEF VAR s-tipo   AS CHAR INITIAL "REMEBOV".

DEF VAR total_decNac AS DECIMAL NO-UNDO.
DEF VAR total_decUSA AS DECIMAL NO-UNDO.

DEF VAR X-ImpNac LIKE ccbccaja.impnac.
DEF VAR X-ImpUsa LIKE ccbccaja.impusa.
DEF VAR X-VueNac LIKe ccbccaja.vuenac.
DEF VAR X-VueUsa LIKe ccbccaja.vueusa.
DEF VAR X-HorCie AS CHAR NO-UNDO.

DEF VAR X-Ok AS LOGICAL NO-UNDO.

DEF TEMP-TABLE t-ccbccaja LIKE ccbccaja.

DEF VAR X-AsgNac AS DEC NO-UNDO.
DEF VAR X-AsgUsa AS DEC NO-UNDO.

{ccb\i-ChqUser.i}

FIND FIRST CcbDTerm WHERE 
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-coddoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE
        "Egreso de caja no esta configurado en este terminal"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-ptovta = ccbdterm.nroser.
  
/* Control de correlativos */
FIND FIRST FacCorre WHERE 
    faccorre.codcia = s-codcia AND 
    faccorre.coddoc = s-coddoc AND
    faccorre.nroser = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "No esta definida la serie" s-ptovta SKIP
        "para el ingreso a caja"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

    DEFINE BUFFER b_Ccaja FOR ccbccaja.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr CcbDecl

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog CcbDecl.ImpNac[10] CcbCierr.FchCie ~
CcbDecl.ImpUsa[10] CcbDecl.ImpNac[9] CcbCierr.usuario CcbDecl.ImpUsa[9] ~
CcbCierr.HorCie CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] ~
CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] CcbDecl.ImpNac[6] CcbDecl.ImpNac[7] ~
CcbDecl.ImpNac[8] CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] ~
CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] CcbDecl.ImpUsa[6] CcbDecl.ImpUsa[7] ~
CcbDecl.ImpUsa[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog CcbCierr.FchCie ~
CcbDecl.ImpNac[1] CcbDecl.ImpUsa[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog CcbCierr CcbDecl
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog CcbCierr
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-D-Dialog CcbDecl
&Scoped-define QUERY-STRING-D-Dialog FOR EACH CcbCierr SHARE-LOCK, ~
      EACH CcbDecl OF CcbCierr SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCierr SHARE-LOCK, ~
      EACH CcbDecl OF CcbCierr SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCierr CcbDecl
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCierr
&Scoped-define SECOND-TABLE-IN-QUERY-D-Dialog CcbDecl


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCierr.FchCie CcbDecl.ImpNac[1] ~
CcbDecl.ImpUsa[1] 
&Scoped-define ENABLED-TABLES CcbCierr CcbDecl
&Scoped-define FIRST-ENABLED-TABLE CcbCierr
&Scoped-define SECOND-ENABLED-TABLE CcbDecl
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel RECT-21 RECT-22 RECT-24 ~
RECT-25 
&Scoped-Define DISPLAYED-FIELDS CcbDecl.ImpNac[10] CcbCierr.FchCie ~
CcbDecl.ImpUsa[10] CcbDecl.ImpNac[9] CcbCierr.usuario CcbDecl.ImpUsa[9] ~
CcbCierr.HorCie CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] ~
CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] CcbDecl.ImpNac[6] CcbDecl.ImpNac[7] ~
CcbDecl.ImpNac[8] CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] ~
CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] CcbDecl.ImpUsa[6] CcbDecl.ImpUsa[7] ~
CcbDecl.ImpUsa[8] 
&Scoped-define DISPLAYED-TABLES CcbDecl CcbCierr
&Scoped-define FIRST-DISPLAYED-TABLE CcbDecl
&Scoped-define SECOND-DISPLAYED-TABLE CcbCierr
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Division 

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
     IMAGE-UP FILE "img\cerrar":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN_Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1.08
     BGCOLOR 11 FGCOLOR 0 FONT 10 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY .77.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 8.46.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 9.23.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.86 BY 9.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCierr, 
      CcbDecl SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_Division AT ROW 1 COL 1 NO-LABEL WIDGET-ID 2
     CcbDecl.ImpNac[10] AT ROW 11.5 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCierr.FchCie AT ROW 2.35 COL 12 COLON-ALIGNED
          LABEL "Fecha de cierre"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbDecl.ImpUsa[10] AT ROW 11.5 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[9] AT ROW 10.69 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCierr.usuario AT ROW 2.35 COL 30 COLON-ALIGNED
          LABEL "Cajero"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbDecl.ImpUsa[9] AT ROW 10.69 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCierr.HorCie AT ROW 2.35 COL 53 COLON-ALIGNED FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbDecl.ImpNac[1] AT ROW 4.46 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[2] AT ROW 5.23 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[3] AT ROW 6 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[4] AT ROW 6.77 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[5] AT ROW 7.54 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[6] AT ROW 8.31 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[7] AT ROW 9.08 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[8] AT ROW 9.88 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[1] AT ROW 4.46 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[2] AT ROW 5.23 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[3] AT ROW 6 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[4] AT ROW 6.77 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[5] AT ROW 7.54 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[6] AT ROW 8.31 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[7] AT ROW 9.08 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[8] AT ROW 9.88 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     Btn_OK AT ROW 4.85 COL 53
     Btn_Cancel AT ROW 6.58 COL 53
     "Notas de Crédito" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 8.5 COL 4
     "Efectivo" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.65 COL 4
     "Comisiones Factoring" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 10.04 COL 4
     "Anticipos" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 9.27 COL 4
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     "S/." VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 3.69 COL 26
     "Cheques del Día" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 5.42 COL 4
     "Vales de Consumo" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 11.58 COL 4
     "Cheques Diferidos" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 6.19 COL 4
     "Retenciones" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 10.81 COL 4
     "B.D./ Vtas Whatsapp" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.73 COL 4
     "Tarjeta de Crédito" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 6.96 COL 4
     "US$" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 3.69 COL 42
     RECT-21 AT ROW 3.5 COL 2
     RECT-22 AT ROW 4.27 COL 2
     RECT-24 AT ROW 3.5 COL 19.43
     RECT-25 AT ROW 3.5 COL 51.14
     SPACE(2.42) SKIP(0.88)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierre de Caja".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b_pen B "?" ? INTEGRAL CcbPenDep
      TABLE: T-CcbPenDep T "?" NO-UNDO INTEGRAL CcbPenDep
      ADDITIONAL-FIELDS:
          FIELD CodMon AS INT
          FIELD SdoAct AS DEC
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

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

/* SETTINGS FOR FILL-IN CcbCierr.FchCie IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Division IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN CcbCierr.HorCie IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[10] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[2] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[3] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[4] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[5] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[6] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[7] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[8] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpNac[9] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[10] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[2] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[3] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[4] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[5] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[6] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[7] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[8] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbDecl.ImpUsa[9] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCierr.usuario IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.CcbCierr,integral.CcbDecl OF integral.CcbCierr"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cierre de Caja */
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
    
    X-HorCie = STRING(TIME,"HH:MM:SS").
    DISPLAY X-HorCie @ ccbcierr.horcie WITH FRAME D-Dialog.

    MESSAGE
        "¿Esta seguro de realizar el CIERRE DE CAJA?"
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE X-Ok.

    IF x-Ok <> TRUE THEN RETURN NO-APPLY.

    /* Verificamos si tiene una diferencia por sustentar */
    FIND FIRST Ccbpendep WHERE Ccbpendep.codcia = s-codcia
        AND Ccbpendep.coddiv = s-coddiv
        AND Ccbpendep.coddoc = 'DCC'
        AND Ccbpendep.codref = 'DCC'
        AND Ccbpendep.flgest = 'P'
        AND Ccbpendep.usuario = s-user-id
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbpendep THEN DO:
/*         MESSAGE 'Tiene diferencia por sustentar del día' Ccbpendep.fchcie SKIP */
/*             'El plazo máximo es de 24 horas'                                   */
/*             VIEW-AS ALERT-BOX INFORMATION.                                     */
    END.

    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, LEAVE trloop ON STOP UNDO trloop, LEAVE trloop:
        X-HorCie = STRING(TIME,"HH:MM:SS").
        DISPLAY X-HorCie @ ccbcierr.horcie WITH FRAME D-Dialog.
        RUN Procesa-cierre.
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE
                "No se pudo realizar el cierre de caja"
                VIEW-AS ALERT-BOX ERROR.
            UNDO trloop, LEAVE trloop.
        END.
        
        RUN Cierre-de-caja.
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE
                "No se pudo realizar el cierre de caja"
                VIEW-AS ALERT-BOX ERROR.
            UNDO trloop, LEAVE trloop.
        END.
        
    END.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
    IF AVAILABLE(Ccbcierr) THEN RELEASE Ccbcierr.
    IF AVAILABLE(Ccbdecl)  THEN RELEASE Ccbdecl.
    IF AVAILABLE(CcbPenDep) THEN RELEASE CcbPenDep.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCierr.FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCierr.FchCie D-Dialog
ON LEAVE OF CcbCierr.FchCie IN FRAME D-Dialog /* Fecha de cierre */
OR "RETURN":U OF ccbCierr.FchCie
DO:
   IF INPUT {&SELF-NAME} > TODAY THEN DO:
       MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX WARNING.
       DISPLAY TODAY @ {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
       RETURN NO-APPLY.
   END.
/*    IF INPUT {&SELF-NAME} < TODAY - 1                                             */
/*        OR INPUT {&SELF-NAME} > TODAY                                             */
/*        THEN DO:                                                                  */
/*        MESSAGE 'La fecha debe estar entre ayer y hoy' VIEW-AS ALERT-BOX WARNING. */
/*        DISPLAY TODAY @ {&SELF-NAME} WITH FRAME {&FRAME-NAME}.                    */
/*        RETURN NO-APPLY.                                                          */
/*    END.                                                                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */


DISPLAY
    TODAY @ ccbcierr.FchCie
    s-user-id @ ccbcierr.usuario
    WITH FRAME D-Dialog.
 
{src/adm/template/dialogmn.i}

{ccb/i-ciecja-rutinas.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-caja D-Dialog 
PROCEDURE Cierre-de-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Valida.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
DEFINE VAR x-vuelto AS DECIMAL NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* por cada documento descargamos el vuelto */
    FOR EACH T-ccbccaja:
        t-ccbccaja.Impnac[1] = t-ccbCCaja.ImpNac[1] - t-ccbccaja.VueNac.
        t-ccbccaja.VueNac    = 0.
        t-ccbccaja.Impusa[1] = t-ccbCCaja.ImpUsa[1] - t-ccbccaja.VueUsa.
        t-ccbccaja.VueUsa    = 0.
    END.
    CREATE ccbcierr.
    ASSIGN
        CcbCierr.CodCia = s-codcia
        CcbCierr.HorCie = X-HorCie
        CcbCierr.usuario= s-user-id.
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN CcbCierr.FchCie.
    END.
    FOR EACH t-ccbccaja:
        {ccb/i-ciecja-base.i}
    END. /* FOR EACH t-ccbccaja... */

    CREATE ccbdecl.
    ASSIGN
        Ccbdecl.FchCie = CcbCierr.FchCie
        Ccbdecl.CodCia = s-codcia
        Ccbdecl.HorCie = X-HorCie
        Ccbdecl.usuario = s-user-id
        Ccbdecl.ImpNac[1] = total_decNac
        Ccbdecl.ImpNac[2]
        Ccbdecl.ImpNac[3]
        Ccbdecl.ImpNac[4]
        Ccbdecl.ImpNac[5]
        Ccbdecl.ImpNac[6]
        Ccbdecl.ImpNac[7]
        Ccbdecl.ImpNac[8]
        Ccbdecl.ImpNac[9]
        Ccbdecl.ImpNac[10]
        Ccbdecl.ImpUsa[1] = total_decUSA
        Ccbdecl.ImpUsa[2]
        Ccbdecl.ImpUsa[3]
        Ccbdecl.ImpUsa[4]
        Ccbdecl.ImpUsa[5]
        Ccbdecl.ImpUsa[6]
        Ccbdecl.ImpUsa[7]
        Ccbdecl.ImpUsa[8]
        Ccbdecl.ImpUsa[9]
        Ccbdecl.ImpUsa[10].

    /*RUN aplic/sypsa/registroventascontado (ROWID(Ccbcierr), "I").*/

    /* RHC 15/12/16 Registro de Diferencia de Caja */
    RUN Diferencia-de-Caja.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    MESSAGE 'todo ok'.
END.

RETURN "OK".

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
  DISPLAY FILL-IN_Division 
      WITH FRAME D-Dialog.
  IF AVAILABLE CcbCierr THEN 
    DISPLAY CcbCierr.FchCie CcbCierr.usuario CcbCierr.HorCie 
      WITH FRAME D-Dialog.
  IF AVAILABLE CcbDecl THEN 
    DISPLAY CcbDecl.ImpNac[10] CcbDecl.ImpUsa[10] CcbDecl.ImpNac[9] 
          CcbDecl.ImpUsa[9] CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] 
          CcbDecl.ImpNac[3] CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] 
          CcbDecl.ImpNac[6] CcbDecl.ImpNac[7] CcbDecl.ImpNac[8] 
          CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] 
          CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] CcbDecl.ImpUsa[6] 
          CcbDecl.ImpUsa[7] CcbDecl.ImpUsa[8] 
      WITH FRAME D-Dialog.
  ENABLE CcbCierr.FchCie CcbDecl.ImpNac[1] CcbDecl.ImpUsa[1] Btn_OK Btn_Cancel 
         RECT-21 RECT-22 RECT-24 RECT-25 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia AND
      GN-DIVI.CodDiv = s-coddiv
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN lib/_centrar (GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv, FILL-IN_Division:WIDTH, OUTPUT FILL-IN_Division).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Cierre D-Dialog 
PROCEDURE Procesa-Cierre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Valida.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

/* *********************** */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' WITH FRAME {&FRAME-NAME}:
    EMPTY TEMP-TABLE t-ccbccaja.
    ASSIGN
        total_decNac = 0
        total_decUSA = 0.
    /* Realiza E/C a Bóveda con el monto declarado */
    IF INPUT CcbDecl.ImpNac[1] > 0 THEN RUN proc_CreateECCJA(1, INPUT (INPUT CcbDecl.ImpNac[1])).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    IF INPUT CcbDecl.ImpUsa[1] > 0 THEN RUN proc_CreateECCJA(2, INPUT (INPUT CcbDecl.ImpUsa[1])).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        X-ImpNac = 0
        X-ImpUsa = 0
        X-VueNac = 0
        X-VueUsa = 0.
    /* INGRESOS */
    FOR EACH ccbccaja NO-LOCK WHERE
        ccbccaja.codcia = s-codcia AND
        CcbCCaja.CodDiv = s-coddiv AND
        ccbccaja.coddoc = "I/C"    AND
        CcbCCaja.FchDoc >= DATE(ccbcierr.FchCie:SCREEN-VALUE) - 1 AND
        CcbCCaja.FchDoc <= DATE(ccbcierr.FchCie:SCREEN-VALUE) AND
        ccbccaja.flgcie = "P"      AND
        ccbccaja.usuario = s-user-id AND
        ccbccaja.codcaja = s-codter
        USE-INDEX LLAVE07:
        /* Cierra Documentos Anulados */
        IF ccbccaja.flgest = "A" THEN DO:
            FIND b_Ccaja WHERE RECID(b_Ccaja) = RECID(CcbCcaja) EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE b_Ccaja THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                b_CCaja.FlgCie = "C"
                b_CCaja.FchCie = INPUT CcbCierr.FchCie
                b_CCaja.HorCie = INPUT CcbCierr.HorCie.
            NEXT.
        END.
        CREATE t-ccbccaja.
        BUFFER-COPY CcbCCaja
            TO t-CcbCCaja.
        ASSIGN
            X-Impnac[1] = X-Impnac[1] + ccbccaja.impnac[1]
            X-Impnac[2] = X-Impnac[2] + ccbccaja.impnac[2]
            X-Impnac[3] = X-Impnac[3] + ccbccaja.impnac[3]
            X-Impnac[4] = X-Impnac[4] + ccbccaja.impnac[4]
            X-Impnac[5] = X-Impnac[5] + ccbccaja.impnac[5]
            X-Impnac[6] = X-Impnac[6] + ccbccaja.impnac[6]
            X-Impnac[7] = X-Impnac[7] + ccbccaja.impnac[7]
            X-Impnac[8] = X-Impnac[8] + ccbccaja.impnac[8]
            X-Impnac[9] = X-Impnac[9] + ccbccaja.impnac[9]
            X-Impnac[10] = X-Impnac[10] + ccbccaja.impnac[10]
            X-Impusa[1] = X-Impusa[1] + ccbccaja.impusa[1]
            X-Impusa[2] = X-Impusa[2] + ccbccaja.impusa[2]
            X-Impusa[3] = X-Impusa[3] + ccbccaja.impusa[3]
            X-Impusa[4] = X-Impusa[4] + ccbccaja.impusa[4]
            X-Impusa[5] = X-Impusa[5] + ccbccaja.impusa[5]
            X-Impusa[6] = X-Impusa[6] + ccbccaja.impusa[6]
            X-Impusa[7] = X-Impusa[7] + ccbccaja.impusa[7]
            X-Impusa[8] = X-Impusa[8] + ccbccaja.impusa[8]
            X-Impusa[9] = X-Impusa[9] + ccbccaja.impusa[9]
            X-Impusa[10] = X-Impusa[10] + ccbccaja.impusa[10]
            X-Vuenac    = X-Vuenac    + ccbccaja.vuenac
            X-Vueusa    = X-Vueusa    + ccbccaja.vueusa.
    END.
    /* EGRESOS */
    FOR EACH ccbccaja NO-LOCK WHERE 
        ccbccaja.codcia = s-codcia AND  
        CcbCCaja.CodDiv = s-coddiv AND  
        ccbccaja.coddoc = "E/C"    AND  
        CcbCCaja.FchDoc >= DATE(ccbcierr.FchCie:SCREEN-VALUE) - 1 AND
        CcbCCaja.FchDoc <= DATE(ccbcierr.FchCie:SCREEN-VALUE) AND  
        ccbccaja.flgcie = "P"      AND  
        ccbccaja.usuario = s-user-id AND
        ccbccaja.codcaja = s-codter
        USE-INDEX LLAVE07:
        /* Cierra Documentos Anulados */
        IF ccbccaja.flgest = "A" THEN DO:
            FIND b_Ccaja WHERE RECID(b_Ccaja) = RECID(CcbCcaja) EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE b_Ccaja THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                b_CCaja.FlgCie = "C"
                b_CCaja.FchCie = INPUT CcbCierr.FchCie
                b_CCaja.HorCie = INPUT CcbCierr.HorCie.
            NEXT.
        END.
        CREATE t-ccbccaja.
        BUFFER-COPY CcbCCaja
            TO t-CcbCCaja.
        ASSIGN
            X-Impnac[1] = X-Impnac[1] - ccbccaja.impnac[1]
            X-Impnac[2] = X-Impnac[2] - ccbccaja.impnac[2]
            X-Impnac[3] = X-Impnac[3] - ccbccaja.impnac[3]
            X-Impnac[4] = X-Impnac[4] - ccbccaja.impnac[4]
            X-Impnac[5] = X-Impnac[5] - ccbccaja.impnac[5]
            X-Impnac[6] = X-Impnac[6] - ccbccaja.impnac[6]
            X-Impnac[7] = X-Impnac[7] - ccbccaja.impnac[7]
            X-Impnac[8] = X-Impnac[8] - ccbccaja.impnac[8]
            X-Impnac[9] = X-Impnac[9] - ccbccaja.impnac[9]
            X-Impnac[10] = X-Impnac[10] - ccbccaja.impnac[10]
            X-Impusa[1] = X-Impusa[1] - ccbccaja.impusa[1]
            X-Impusa[2] = X-Impusa[2] - ccbccaja.impusa[2]
            X-Impusa[3] = X-Impusa[3] - ccbccaja.impusa[3]
            X-Impusa[4] = X-Impusa[4] - ccbccaja.impusa[4]
            X-Impusa[5] = X-Impusa[5] - ccbccaja.impusa[5]
            X-Impusa[6] = X-Impusa[6] - ccbccaja.impusa[6]
            X-Impusa[7] = X-Impusa[7] - ccbccaja.impusa[7]
            X-Impusa[8] = X-Impusa[8] - ccbccaja.impusa[8]
            X-Impusa[9] = X-Impusa[9] - ccbccaja.impusa[9]
            X-Impusa[10] = X-Impusa[10] - ccbccaja.impusa[10]
            X-Vuenac    = X-Vuenac    - ccbccaja.vuenac
            X-Vueusa    = X-Vueusa    - ccbccaja.vueusa.
        /* Acumula lo declarado basado en todos los E/C */
        total_decNac = total_decNac + ccbccaja.impnac[1].
        total_decUSA = total_decUSA + ccbccaja.impusa[1].
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Genera-Deposito-2 D-Dialog 
PROCEDURE proc_Genera-Deposito-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR f-Banco AS CHAR NO-UNDO.
    DEF VAR f-Cta   AS CHAR NO-UNDO.
    DEF VAR FILL-IN-NroOpe AS CHAR NO-UNDO.
    DEF VAR f-Fecha AS DATE NO-UNDO.

    EMPTY TEMP-TABLE T-CcbPenDep.

    CREATE T-CcbPenDep.
    BUFFER-COPY CcbPenDep TO T-CcbPenDep.
    IF CcbPenDep.ImpNac > 0 THEN T-CcbPenDep.CodMon = 1.
    IF CcbPenDep.ImpUsa > 0 THEN T-CcbPenDep.CodMon = 2.
    T-CcbPenDep.SdoAct = CcbPenDep.SdoNac + CcbPenDep.SdoUsa.

    {ccb\i-genera-deposito.i}

    RETURN 'OK'.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCierr"}
  {src/adm/template/snd-list.i "CcbDecl"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida D-Dialog 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lFoundEC AS LOGICAL NO-UNDO.

        
    /* CONTROL ANTES DE CERRAR */
    /* Busca I/C tipo "Sencillo" Activo */
    lFoundIC = FALSE.
    lFoundEC = FALSE.
    FOR EACH ccbccaja NO-LOCK WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND
        ccbccaja.coddoc = "I/C" AND
        ccbccaja.tipo = "SENCILLO" AND
        ccbccaja.usuario = s-user-id AND
        CcbCCaja.FchDoc >= DATE(ccbcierr.FchCie:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - 1 AND
        CcbCCaja.FchDoc <= DATE(ccbcierr.FchCie:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND
        ccbccaja.flgcie = "P" AND
        ccbccaja.codcaja = s-codter:

        IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
    END.
    /* Busca E/C tipo "Sencillo" Activo */
    FOR EACH ccbccaja NO-LOCK WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND
        ccbccaja.coddoc = "E/C" AND
        ccbccaja.tipo = "SENCILLO" AND
        ccbccaja.usuario = s-user-id AND
        CcbCCaja.FchDoc >= DATE(ccbcierr.FchCie:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - 1 AND
        CcbCCaja.FchDoc <= DATE(ccbcierr.FchCie:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND
        ccbccaja.flgcie = "P" AND
        ccbccaja.codcaja = s-codter:
        IF CcbCCaja.FlgEst <> "A" THEN lFoundEC = TRUE.
    END.
    IF NOT lFoundIC AND lFoundEC THEN DO:
        MESSAGE
            "No se ha registrado el I/C del SENCILLO correspondiente"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF lFoundIC AND NOT lFoundEC THEN DO:
        MESSAGE
            "Debe realizar el E/C del SENCILLO para poder cerrar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    /* Busca E/C tipo "Boveda" */
    IF CAN-FIND(FIRST ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia 
                AND ccbccaja.coddiv = s-coddiv 
                AND ccbccaja.coddoc = "E/C" 
                AND ccbccaja.tipo = "REMEBOV" 
                AND ccbccaja.usuario = s-user-id 
                AND ccbccaja.flgest = "E"
                AND ccbccaja.flgcie = "P"
                AND ccbccaja.codcaja = s-codter)
        THEN DO:
        MESSAGE 'Está pendiente de aprobar la remesa a bóveda' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

