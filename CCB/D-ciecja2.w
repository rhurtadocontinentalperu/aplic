&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR X-ImpNac LIKE ccbccaja.impnac.
DEF VAR X-ImpUsa LIKE ccbccaja.impusa.
DEF VAR X-VueNac LIKe ccbccaja.vuenac.
DEF VAR X-VueUsa LIKe ccbccaja.vueusa.
DEF VAR X-HorCie LIKE ccbccaja.horcie.

DEF VAR X-Ok AS LOGICAL NO-UNDO.

DEF TEMP-TABLE t-ccbccaja LIKE ccbccaja.

DEF VAR X-AsgNac AS DEC NO-UNDO.
DEF VAR X-AsgUsa AS DEC NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr CcbDecl

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog CcbCierr.FchCie CcbDecl.ImpNac[1] ~
CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] ~
CcbCierr.usuario CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] ~
CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] CcbCierr.HorCie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog CcbCierr.FchCie ~
CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] CcbDecl.ImpNac[4] ~
CcbDecl.ImpNac[5] CcbCierr.usuario CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] ~
CcbDecl.ImpUsa[3] CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog CcbCierr CcbDecl
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog CcbCierr
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-D-Dialog CcbDecl

&Scoped-define FIELD-PAIRS-IN-QUERY-D-Dialog~
 ~{&FP1}FchCie ~{&FP2}FchCie ~{&FP3}~
 ~{&FP1}ImpNac[1] ~{&FP2}ImpNac[1] ~{&FP3}~
 ~{&FP1}ImpNac[2] ~{&FP2}ImpNac[2] ~{&FP3}~
 ~{&FP1}ImpNac[3] ~{&FP2}ImpNac[3] ~{&FP3}~
 ~{&FP1}ImpNac[4] ~{&FP2}ImpNac[4] ~{&FP3}~
 ~{&FP1}ImpNac[5] ~{&FP2}ImpNac[5] ~{&FP3}~
 ~{&FP1}usuario ~{&FP2}usuario ~{&FP3}~
 ~{&FP1}ImpUsa[1] ~{&FP2}ImpUsa[1] ~{&FP3}~
 ~{&FP1}ImpUsa[2] ~{&FP2}ImpUsa[2] ~{&FP3}~
 ~{&FP1}ImpUsa[3] ~{&FP2}ImpUsa[3] ~{&FP3}~
 ~{&FP1}ImpUsa[4] ~{&FP2}ImpUsa[4] ~{&FP3}~
 ~{&FP1}ImpUsa[5] ~{&FP2}ImpUsa[5] ~{&FP3}
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCierr SHARE-LOCK, ~
      EACH CcbDecl OF CcbCierr SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCierr CcbDecl
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCierr


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCierr.FchCie CcbDecl.ImpNac[1] ~
CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] ~
CcbCierr.usuario CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] ~
CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}FchCie ~{&FP2}FchCie ~{&FP3}~
 ~{&FP1}ImpNac[1] ~{&FP2}ImpNac[1] ~{&FP3}~
 ~{&FP1}ImpNac[2] ~{&FP2}ImpNac[2] ~{&FP3}~
 ~{&FP1}ImpNac[3] ~{&FP2}ImpNac[3] ~{&FP3}~
 ~{&FP1}ImpNac[4] ~{&FP2}ImpNac[4] ~{&FP3}~
 ~{&FP1}ImpNac[5] ~{&FP2}ImpNac[5] ~{&FP3}~
 ~{&FP1}usuario ~{&FP2}usuario ~{&FP3}~
 ~{&FP1}ImpUsa[1] ~{&FP2}ImpUsa[1] ~{&FP3}~
 ~{&FP1}ImpUsa[2] ~{&FP2}ImpUsa[2] ~{&FP3}~
 ~{&FP1}ImpUsa[3] ~{&FP2}ImpUsa[3] ~{&FP3}~
 ~{&FP1}ImpUsa[4] ~{&FP2}ImpUsa[4] ~{&FP3}~
 ~{&FP1}ImpUsa[5] ~{&FP2}ImpUsa[5] ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCierr CcbDecl
&Scoped-define FIRST-ENABLED-TABLE CcbCierr
&Scoped-define SECOND-ENABLED-TABLE CcbDecl
&Scoped-Define ENABLED-OBJECTS RECT-23 RECT-21 RECT-24 RECT-25 RECT-22 ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS CcbCierr.FchCie CcbDecl.ImpNac[1] ~
CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] ~
CcbCierr.usuario CcbDecl.ImpUsa[1] CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] ~
CcbDecl.ImpUsa[4] CcbDecl.ImpUsa[5] CcbCierr.HorCie 

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

DEFINE VARIABLE FILL-IN-13 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY .77.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 4.42.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 1.15.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16 BY 6.35.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 14.86 BY 6.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCierr, 
      CcbDecl SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CcbCierr.FchCie AT ROW 1.27 COL 13 COLON-ALIGNED
          LABEL "Fecha de cierre"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-13 AT ROW 9.04 COL 18.43 COLON-ALIGNED NO-LABEL
     CcbDecl.ImpNac[1] AT ROW 3.35 COL 22.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[2] AT ROW 4.15 COL 22.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[3] AT ROW 4.96 COL 22.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[4] AT ROW 5.77 COL 22.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpNac[5] AT ROW 6.58 COL 22.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCierr.usuario AT ROW 1.27 COL 31.43 COLON-ALIGNED
          LABEL "Cajero"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbDecl.ImpUsa[1] AT ROW 3.35 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[2] AT ROW 4.15 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[3] AT ROW 4.96 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
     CcbDecl.ImpUsa[4] AT ROW 5.77 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbDecl.ImpUsa[5] AT ROW 6.58 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     Btn_OK AT ROW 3.69 COL 53.72
     Btn_Cancel AT ROW 5.42 COL 53.86
     CcbCierr.HorCie AT ROW 1.27 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     "Tarjeta de credito" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 5.81 COL 4.43
     RECT-23 AT ROW 7.54 COL 3.43
     "US$" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 2.54 COL 41.43
     RECT-21 AT ROW 2.38 COL 3.57
     "Efectivo" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 3.5 COL 4.43
     RECT-24 AT ROW 2.35 COL 20.43
     RECT-25 AT ROW 2.35 COL 52.14
     "S/." VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 2.54 COL 26.43
     "Cheques del dia" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 4.27 COL 4.43
     RECT-22 AT ROW 3.15 COL 3.29
     "Cheques diferidos" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 5.04 COL 4.43
     "Depositos" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 6.58 COL 4.43
     SPACE(48.99) SKIP(2.99)
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCierr.FchCie IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-13 IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-13:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN CcbCierr.HorCie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCierr.usuario IN FRAME D-Dialog
   EXP-LABEL                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
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
  MESSAGE "Procedemos al cierre de caja?" VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE X-Ok.
  /*  IF X-Ok THEN RUN Verifica-contra-entrega.*/  
  RUN Procesa-cierre.
  RUN Cierre-de-caja.
  IF RETURN-VALUE = "ADM-ERROR"
  THEN MESSAGE "No se pudo realizar el cierre de caja" VIEW-AS ALERT-BOX ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCierr.FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCierr.FchCie D-Dialog
ON LEAVE OF CcbCierr.FchCie IN FRAME D-Dialog /* Fecha de cierre */
OR "RETURN":U OF ccbCierr.FchCie
DO:
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


DISPLAY s-user-id @ ccbcierr.usuario WITH FRAME D-Dialog.
/* ***************************  Main Block  *************************** */
  DISPLAY TODAY @ ccbcierr.FchCie s-user-id @ ccbcierr.usuario WITH FRAME D-Dialog.
  /* buscamos pendientes de caja */
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-caja D-Dialog 
PROCEDURE Cierre-de-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* por cada documento descargamos el vuelto */
  DEFINE VAR x-vuelto AS DECIMAL NO-UNDO.

  FOR EACH T-ccbccaja:
      t-ccbccaja.Impnac[1] = t-ccbCCaja.ImpNac[1] - t-ccbccaja.VueNac.
      t-ccbccaja.VueNac    = 0.
      /*
      IF t-ccbccaja.ImpUsa[1] = 0 AND t-ccbccaja.VueUsa > 0 THEN DO:
         x-vuelto = ROUND((t-ccbccaja.VueUsa * t-ccbccaja.Tpocmb), 2).
         t-ccbccaja.Impnac[1] = t-ccbccaja.Impnac[1] - x-vuelto.
         t-ccbccaja.VueUsa = 0.
      END.
      */
      /**/
      t-ccbccaja.Impusa[1] = t-ccbCCaja.ImpUsa[1] - t-ccbccaja.VueUsa.
      t-ccbccaja.VueUsa    = 0.
      /*
      IF t-ccbccaja.ImpNac[1] = 0 AND t-ccbccaja.VueNac > 0 THEN DO:
         x-vuelto = ROUND((t-ccbccaja.VueNac / t-ccbccaja.Tpocmb), 2).
         t-ccbccaja.ImpUsa[1] = t-ccbccaja.ImpUsa[1] - x-vuelto.
         t-ccbccaja.VueNac = 0.
      END.
      */
  END.
    
  /* ahora si grabamos el cierre */
  X-HorCie = STRING(TIME, "HH:MM").
  DISPLAY /*TODAY @ ccbcierr.FchCie s-user-id @ ccbcierr.usuario */
      X-HorCie @ ccbcierr.horcie WITH FRAME D-Dialog.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    
    CREATE ccbcierr.
    ASSIGN
      CcbCierr.FchCie
      CcbCierr.CodCia = s-codcia
      CcbCierr.HorCie = X-HorCie
      CcbCierr.usuario= s-user-id.
    FOR EACH t-ccbccaja:
      FIND ccbccaja OF t-ccbccaja EXCLUSIVE-LOCK.
      ASSIGN
          CcbCCaja.FlgCie    = "C"
          CcbCCaja.FchCie    = CcbCierr.FchCie
          CcbCCaja.HorCie    = CcbCierr.HorCie
          CcbCierr.ImpNac[1] = CcbCierr.ImpNac[1] + t-ccbccaja.impnac[1]
          CcbCierr.ImpNac[2] = CcbCierr.ImpNac[2] + t-ccbccaja.impnac[2]
          CcbCierr.ImpNac[3] = CcbCierr.ImpNac[3] + t-ccbccaja.impnac[3]
          CcbCierr.ImpNac[4] = CcbCierr.ImpNac[4] + t-ccbccaja.impnac[4]
          CcbCierr.ImpNac[5] = CcbCierr.ImpNac[5] + t-ccbccaja.impnac[5]
          CcbCierr.ImpNac[6] = CcbCierr.ImpNac[6] + t-ccbccaja.impnac[6]
          CcbCierr.ImpNac[7] = CcbCierr.ImpNac[7] + t-ccbccaja.impnac[7]
          CcbCierr.ImpUsa[1] = CcbCierr.ImpUsa[1] + t-ccbccaja.impusa[1]
          CcbCierr.ImpUsa[2] = CcbCierr.ImpUsa[2] + t-ccbccaja.impusa[2]
          CcbCierr.ImpUsa[3] = CcbCierr.ImpUsa[3] + t-ccbccaja.impusa[3]
          CcbCierr.ImpUsa[4] = CcbCierr.ImpUsa[4] + t-ccbccaja.impusa[4]
          CcbCierr.ImpUsa[5] = CcbCierr.ImpUsa[5] + t-ccbccaja.impusa[5]
          CcbCierr.ImpUsa[6] = CcbCierr.ImpUsa[6] + t-ccbccaja.impusa[6]
          CcbCierr.ImpUsa[7] = CcbCierr.ImpUsa[7] + t-ccbccaja.impusa[7].
      /****    Solo para generar pendientes por depositar    *****/  
      IF ccbccaja.CodDoc = "I/C" THEN DO:
          /****    Efectivo    ****/
         IF T-CcbCCaja.ImpNac[1] + T-CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            FIND ccbpendep WHERE 
                 CcbPenDep.CodCia = CcbCCaja.CodCia AND  
                 CcbPenDep.CodDoc = "PXD"           AND  
                 CcbPenDep.CodDiv = CcbCCaja.CodDiv AND  
                 CcbPenDep.CodRef = "EFEC"          AND  
                 CcbPenDep.FchCie = CcbCCaja.FchCie AND  
                 CcbPenDep.NroRef = STRING(CcbCCaja.FchCie, "99999999")
                 NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
               CREATE CcbPenDep.
               ASSIGN
                  CcbPenDep.CodCia  = CcbCCaja.CodCia 
                  CcbPenDep.CodDoc  = "PXD" 
                  CcbPenDep.CodDiv  = CcbCCaja.CodDiv
                  CcbPenDep.CodRef  = "EFEC"
                  CcbPenDep.NroRef  = STRING(CcbCCaja.FchCie, "99999999")
                  CcbPenDep.FchCie  = CcbCCaja.FchCie
                  CcbPenDep.HorCie  = X-HorCie
                  CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.FlgEst  = "P"
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[1]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[1]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[1]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[1]. 
         END.
         /****    Cheques Diarios    ****/
         IF CcbCCaja.Voucher[2] <> "" THEN DO:
            FIND ccbpendep WHERE CcbPenDep.CodCia = CcbCCaja.CodCia 
                            AND  CcbPenDep.CodDoc = "PXD" 
                            AND  CcbPenDep.CodDiv = CcbCCaja.CodDiv
                            AND  CcbPenDep.CodRef = "CHEC"
                            AND  CcbPenDep.FchCie = CcbCCaja.FchCie
                            AND  CcbPenDep.NroRef = CcbCCaja.Voucher[2]
                           NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
              CREATE CcbPenDep.
              ASSIGN
                  CcbPenDep.CodCia  = CcbCCaja.CodCia 
                  CcbPenDep.CodDoc  = "PXD" 
                  CcbPenDep.CodDiv  = CcbCCaja.CodDiv
                  CcbPenDep.CodRef  = "CHEC"
                  CcbPenDep.NroRef  = CcbCCaja.Voucher[2]
                  CcbPenDep.FchCie  = CcbCCaja.FchCie
                  CcbPenDep.HorCie  = X-HorCie
                  CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.FlgEst = "P"
                CcbPenDep.CodBco = CcbCCaja.CodBco[2]
                CcbPenDep.FchVto = CcbCCaja.FchVto[2]
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[2]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[2]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[2]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[2]. 
         END.
         /****    Cheques Diferidos    ****/  
         IF CcbCCaja.Voucher[3] <> "" THEN DO:
            FIND ccbpendep WHERE CcbPenDep.CodCia = CcbCCaja.CodCia 
                            AND  CcbPenDep.CodDoc = "PXD" 
                            AND  CcbPenDep.CodDiv = CcbCCaja.CodDiv
                            AND  CcbPenDep.CodRef = "CHED"
                            AND  CcbPenDep.FchCie = CcbCCaja.FchCie
                            AND  CcbPenDep.NroRef = CcbCCaja.Voucher[3]
                           NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
              CREATE CcbPenDep.
              ASSIGN
                  CcbPenDep.CodCia  = CcbCCaja.CodCia 
                  CcbPenDep.CodDoc  = "PXD" 
                  CcbPenDep.CodDiv  = CcbCCaja.CodDiv
                  CcbPenDep.CodRef  = "CHED"
                  CcbPenDep.NroRef  = CcbCCaja.Voucher[3]
                  CcbPenDep.FlgEst  = "P"
                  CcbPenDep.FchCie  = CcbCCaja.FchCie
                  CcbPenDep.HorCie  = X-HorCie
                  CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.FlgEst = "P"
                CcbPenDep.CodBco = CcbCCaja.CodBco[3]
                CcbPenDep.FchVto = CcbCCaja.FchVto[3]
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[3]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[3]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[3]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[3]. 
         END.
         /****    Tar/Cre    ****/
         IF CcbCCaja.Voucher[4] <> "" THEN DO:
            FIND ccbpendep WHERE CcbPenDep.CodCia = CcbCCaja.CodCia 
                            AND  CcbPenDep.CodDoc = "PXD" 
                            AND  CcbPenDep.CodDiv = CcbCCaja.CodDiv
                            AND  CcbPenDep.CodRef = "TARC"
                            AND  CcbPenDep.FchCie = CcbCCaja.FchCie
                            AND  CcbPenDep.NroRef = CcbCCaja.Voucher[4]
                           NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
              CREATE CcbPenDep.
              ASSIGN
                  CcbPenDep.CodCia  = CcbCCaja.CodCia 
                  CcbPenDep.CodDoc  = "PXD" 
                  CcbPenDep.CodDiv  = CcbCCaja.CodDiv
                  CcbPenDep.CodRef  = "TARC"
                  CcbPenDep.NroRef  = CcbCCaja.Voucher[4]
                  CcbPenDep.FlgEst  = "P"
                  CcbPenDep.FchCie  = CcbCCaja.FchCie
                  CcbPenDep.HorCie  = X-HorCie
                  CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.FlgEst = "P"
                CcbPenDep.CodBco = CcbCCaja.CodBco[4]
                CcbPenDep.FchVto = CcbCCaja.FchVto[4]
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[4]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[4]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[4]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[4]. 
         END.    
         /****    Bol/Dep    ****/
         IF CcbCCaja.Voucher[5] <> "" THEN DO:
            FIND ccbpendep WHERE CcbPenDep.CodCia = CcbCCaja.CodCia 
                            AND  CcbPenDep.CodDoc = "PXD" 
                            AND  CcbPenDep.CodDiv = CcbCCaja.CodDiv
                            AND  CcbPenDep.CodRef = "BOLD"
                            AND  CcbPenDep.FchCie = CcbCCaja.FchCie
                            AND  CcbPenDep.NroRef = CcbCCaja.Voucher[5]
                           NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
              CREATE CcbPenDep.
              ASSIGN
                  CcbPenDep.CodCia  = CcbCCaja.CodCia 
                  CcbPenDep.CodDoc  = "PXD" 
                  CcbPenDep.CodDiv  = CcbCCaja.CodDiv
                  CcbPenDep.CodRef  = "BOLD"
                  CcbPenDep.NroRef  = CcbCCaja.Voucher[5]
                  CcbPenDep.FlgEst  = "P"
                  CcbPenDep.FchCie  = CcbCCaja.FchCie
                  CcbPenDep.HorCie  = X-HorCie
                  CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.FlgEst = "P"
                CcbPenDep.CodBco = CcbCCaja.CodBco[5]
                CcbPenDep.FchVto = CcbCCaja.FchVto[5]
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[5]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[5]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[5]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[5]. 
         END.
      END.
      /************************************/
    END.
  END.
  CREATE ccbdecl .
    ASSIGN
      Ccbdecl.FchCie = CcbCierr.FchCie
      Ccbdecl.CodCia = s-codcia
      Ccbdecl.HorCie = X-HorCie
      Ccbdecl.usuario= s-user-id
      Ccbdecl.ImpNac[1] 
      Ccbdecl.ImpNac[2] 
      Ccbdecl.ImpNac[3] 
      Ccbdecl.ImpNac[4] 
      Ccbdecl.ImpNac[5] 
      Ccbdecl.ImpUsa[1] 
      Ccbdecl.ImpUsa[2] 
      Ccbdecl.ImpUsa[3] 
      Ccbdecl.ImpUsa[4] 
      Ccbdecl.ImpUsa[5] .
 
  RETURN "OK".
      
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
  IF AVAILABLE CcbCierr THEN 
    DISPLAY CcbCierr.FchCie CcbCierr.usuario CcbCierr.HorCie 
      WITH FRAME D-Dialog.
  IF AVAILABLE CcbDecl THEN 
    DISPLAY CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] 
          CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] CcbDecl.ImpUsa[1] 
          CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] CcbDecl.ImpUsa[4] 
          CcbDecl.ImpUsa[5] 
      WITH FRAME D-Dialog.
  ENABLE RECT-23 RECT-21 RECT-24 RECT-25 RECT-22 CcbCierr.FchCie 
         CcbDecl.ImpNac[1] CcbDecl.ImpNac[2] CcbDecl.ImpNac[3] 
         CcbDecl.ImpNac[4] CcbDecl.ImpNac[5] CcbCierr.usuario CcbDecl.ImpUsa[1] 
         CcbDecl.ImpUsa[2] CcbDecl.ImpUsa[3] CcbDecl.ImpUsa[4] 
         CcbDecl.ImpUsa[5] Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

FOR EACH t-ccbccaja:
   DELETE t-ccbccaja.
END.

/* buscamos pendientes de caja */
DO WITH FRAME {&FRAME-NAME}:  
   ASSIGN
      X-ImpNac = 0
      X-ImpUsa = 0
      X-VueNac = 0
      X-VueUsa = 0.
  /* PRIMERO LOS INGRESOS */
  FOR EACH ccbccaja WHERE 
           ccbccaja.codcia = s-codcia AND  
           CcbCCaja.CodDiv = s-coddiv AND  
           ccbccaja.coddoc = "I/C"    AND  
           CcbCCaja.FchDoc = DATE(ccbcierr.FchCie:SCREEN-VALUE) AND  
           ccbccaja.flgcie = "P"      AND  
           ccbccaja.flgest NE "A"     AND  
           ccbccaja.usuario BEGINS ccbcierr.usuario:SCREEN-VALUE 
           USE-INDEX LLAVE07 NO-LOCK:
      CREATE t-ccbccaja.
      ASSIGN
        t-CcbCCaja.CodCia = CcbCCaja.CodCia
        t-CcbCCaja.CodDoc = CcbCCaja.CodDoc
        t-CcbCCaja.NroDoc = CcbCCaja.NroDoc
        t-CcbCCaja.ImpNac[1] = CcbCCaja.ImpNac[1]
        t-CcbCCaja.ImpNac[2] = CcbCCaja.ImpNac[2]
        t-CcbCCaja.ImpNac[3] = CcbCCaja.ImpNac[3]
        t-CcbCCaja.ImpNac[4] = CcbCCaja.ImpNac[4]
        t-CcbCCaja.ImpNac[5] = CcbCCaja.ImpNac[5]
        t-CcbCCaja.ImpNac[6] = CcbCCaja.ImpNac[6]
        t-CcbCCaja.ImpNac[7] = CcbCCaja.ImpNac[7]
        t-CcbCCaja.ImpUsa[1] = CcbCCaja.ImpUsa[1]
        t-CcbCCaja.ImpUsa[2] = CcbCCaja.ImpUsa[2]
        t-CcbCCaja.ImpUsa[3] = CcbCCaja.ImpUsa[3]
        t-CcbCCaja.ImpUsa[4] = CcbCCaja.ImpUsa[4]
        t-CcbCCaja.ImpUsa[5] = CcbCCaja.ImpUsa[5]
        t-CcbCCaja.ImpUsa[6] = CcbCCaja.ImpUsa[6]
        t-CcbCCaja.ImpUsa[7] = CcbCCaja.ImpUsa[7]
        t-CcbCCaja.VueNac    = CcbCCaja.VueNac
        t-CcbCCaja.VueUsa    = CcbCCaja.VueUsa
        t-CcbCCaja.TpoCmb    = CcbCCaja.TpoCmb.
    ASSIGN
        X-Impnac[1] = X-Impnac[1] + ccbccaja.impnac[1]
        X-Impnac[2] = X-Impnac[2] + ccbccaja.impnac[2]
        X-Impnac[3] = X-Impnac[3] + ccbccaja.impnac[3]
        X-Impnac[4] = X-Impnac[4] + ccbccaja.impnac[4]
        X-Impnac[5] = X-Impnac[5] + ccbccaja.impnac[5]
        X-Impnac[6] = X-Impnac[6] + ccbccaja.impnac[6]
        X-Impnac[7] = X-Impnac[7] + ccbccaja.impnac[7]
        X-Impusa[1] = X-Impusa[1] + ccbccaja.impusa[1]
        X-Impusa[2] = X-Impusa[2] + ccbccaja.impusa[2]
        X-Impusa[3] = X-Impusa[3] + ccbccaja.impusa[3]
        X-Impusa[4] = X-Impusa[4] + ccbccaja.impusa[4]
        X-Impusa[5] = X-Impusa[5] + ccbccaja.impusa[5]
        X-Impusa[6] = X-Impusa[6] + ccbccaja.impusa[6]
        X-Impusa[7] = X-Impusa[7] + ccbccaja.impusa[7]
        X-Vuenac    = X-Vuenac    + ccbccaja.vuenac
        X-Vueusa    = X-Vueusa    + ccbccaja.vueusa.
  END.
  /* LUEGO LOS EGRESOS */
  FOR EACH ccbccaja WHERE 
           ccbccaja.codcia = s-codcia AND  
           CcbCCaja.CodDiv = s-coddiv AND  
           ccbccaja.coddoc = "E/C"    AND  
           CcbCCaja.FchDoc = DATE(ccbcierr.FchCie:SCREEN-VALUE) AND  
           ccbccaja.flgcie = "P"      AND  
           ccbccaja.flgest NE "A"     AND  
           ccbccaja.usuario BEGINS ccbcierr.usuario:SCREEN-VALUE 
           USE-INDEX LLAVE07 NO-LOCK:
      CREATE t-ccbccaja.
      ASSIGN
        t-CcbCCaja.CodCia = CcbCCaja.CodCia
        t-CcbCCaja.CodDoc = CcbCCaja.CodDoc
        t-CcbCCaja.NroDoc = CcbCCaja.NroDoc
        t-CcbCCaja.ImpNac[1] = CcbCCaja.ImpNac[1]
        t-CcbCCaja.ImpNac[2] = CcbCCaja.ImpNac[2]
        t-CcbCCaja.ImpNac[3] = CcbCCaja.ImpNac[3]
        t-CcbCCaja.ImpNac[4] = CcbCCaja.ImpNac[4]
        t-CcbCCaja.ImpNac[5] = CcbCCaja.ImpNac[5]
        t-CcbCCaja.ImpUsa[1] = CcbCCaja.ImpUsa[1]
        t-CcbCCaja.ImpUsa[2] = CcbCCaja.ImpUsa[2]
        t-CcbCCaja.ImpUsa[3] = CcbCCaja.ImpUsa[3]
        t-CcbCCaja.ImpUsa[4] = CcbCCaja.ImpUsa[4]
        t-CcbCCaja.ImpUsa[5] = CcbCCaja.ImpUsa[5]
        t-CcbCCaja.VueNac    = CcbCCaja.VueNac
        t-CcbCCaja.VueUsa    = CcbCCaja.VueUsa
        t-CcbCCaja.TpoCmb    = CcbCCaja.TpoCmb.
    ASSIGN
        X-Impnac[1] = X-Impnac[1] - ccbccaja.impnac[1]
        X-Impnac[2] = X-Impnac[2] - ccbccaja.impnac[2]
        X-Impnac[3] = X-Impnac[3] - ccbccaja.impnac[3]
        X-Impnac[4] = X-Impnac[4] - ccbccaja.impnac[4]
        X-Impnac[5] = X-Impnac[5] - ccbccaja.impnac[5]
        X-Impusa[1] = X-Impusa[1] - ccbccaja.impusa[1]
        X-Impusa[2] = X-Impusa[2] - ccbccaja.impusa[2]
        X-Impusa[3] = X-Impusa[3] - ccbccaja.impusa[3]
        X-Impusa[4] = X-Impusa[4] - ccbccaja.impusa[4]
        X-Impusa[5] = X-Impusa[5] - ccbccaja.impusa[5]
        X-Vuenac    = X-Vuenac    - ccbccaja.vuenac
        X-Vueusa    = X-Vueusa    - ccbccaja.vueusa.
  END.
  /*DISPLAY 
 *     X-Impnac[1] @ ccbcierr.impnac[1] X-Impnac[2] @ ccbcierr.impnac[2]
 *     X-Impnac[3] @ ccbcierr.impnac[3] X-Impnac[4] @ ccbcierr.impnac[4]
 *     X-Impnac[5] @ ccbcierr.impnac[5]
 *     X-Impusa[1] @ ccbcierr.impusa[1] X-Impusa[2] @ ccbcierr.impusa[2]
 *     X-Impusa[3] @ ccbcierr.impusa[3] X-Impusa[4] @ ccbcierr.impusa[4]
 *     X-Impusa[5] @ ccbcierr.impusa[5]
 *     X-Vuenac    @ ccbcierr.vuenac
 *     X-Vueusa    @ ccbcierr.vueusa WITH FRAME D-Dialog.*/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reparte-nac-1 D-Dialog 
PROCEDURE Reparte-nac-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF t-ccbccaja.impnac[5] > 0
  THEN ASSIGN
          X-AsgNac = MINIMUM(t-ccbccaja.vuenac, t-ccbccaja.impnac[5])
          t-ccbccaja.impnac[5] = t-ccbccaja.impnac[5] - X-AsgNac
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgNac
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgNac / t-ccbccaja.tpocmb.
  IF t-ccbccaja.impnac[4] > 0
  THEN ASSIGN
          X-AsgNac = MINIMUM(t-ccbccaja.vuenac, t-ccbccaja.impnac[4])
          t-ccbccaja.impnac[4] = t-ccbccaja.impnac[4] - X-AsgNac
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgNac
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgNac / t-ccbccaja.tpocmb.
  IF t-ccbccaja.impnac[3] > 0
  THEN ASSIGN
          X-AsgNac = MINIMUM(t-ccbccaja.vuenac, t-ccbccaja.impnac[3])
          t-ccbccaja.impnac[3] = t-ccbccaja.impnac[3] - X-AsgNac
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgNac
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgNac / t-ccbccaja.tpocmb.
  IF t-ccbccaja.impnac[2] > 0
  THEN ASSIGN
          X-AsgNac = MINIMUM(t-ccbccaja.vuenac, t-ccbccaja.impnac[2])
          t-ccbccaja.impnac[2] = t-ccbccaja.impnac[2] - X-AsgNac
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgNac
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgNac / t-ccbccaja.tpocmb.
  IF t-ccbccaja.impnac[1] > 0
  THEN ASSIGN
          X-AsgNac = MINIMUM(t-ccbccaja.vuenac, t-ccbccaja.impnac[1])
          t-ccbccaja.impnac[1] = t-ccbccaja.impnac[1] - X-AsgNac
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgNac
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgNac / t-ccbccaja.tpocmb.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reparte-usa-1 D-Dialog 
PROCEDURE Reparte-usa-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF t-ccbccaja.impusa[5] > 0
  THEN ASSIGN
          X-AsgUsa = MINIMUM(t-ccbccaja.vueusa, t-ccbccaja.impusa[5])
          t-ccbccaja.impusa[5] = t-ccbccaja.impusa[5] - X-AsgUsa
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgUsa
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgUsa * t-ccbccaja.tpocmb.
  IF t-ccbccaja.impusa[4] > 0
  THEN ASSIGN
          X-AsgUsa = MINIMUM(t-ccbccaja.vueusa, t-ccbccaja.impusa[4])
          t-ccbccaja.impusa[4] = t-ccbccaja.impusa[4] - X-AsgUsa
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgUsa
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgUsa * t-ccbccaja.tpocmb.
  IF t-ccbccaja.impusa[3] > 0
  THEN ASSIGN
          X-AsgUsa = MINIMUM(t-ccbccaja.vueusa, t-ccbccaja.impusa[3])
          t-ccbccaja.impusa[3] = t-ccbccaja.impusa[3] - X-AsgUsa
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgUsa
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgUsa * t-ccbccaja.tpocmb.
  IF t-ccbccaja.impusa[2] > 0
  THEN ASSIGN
          X-AsgUsa = MINIMUM(t-ccbccaja.vueusa, t-ccbccaja.impusa[2])
          t-ccbccaja.impusa[2] = t-ccbccaja.impusa[2] - X-AsgUsa
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgUsa
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgUsa * t-ccbccaja.tpocmb.
  IF t-ccbccaja.impusa[1] > 0
  THEN ASSIGN
          X-AsgUsa = MINIMUM(t-ccbccaja.vueusa, t-ccbccaja.impusa[1])
          t-ccbccaja.impusa[1] = t-ccbccaja.impusa[1] - X-AsgUsa
          t-ccbccaja.vueusa    = t-ccbccaja.vueusa    - X-AsgUsa
          t-ccbccaja.vuenac    = t-ccbccaja.vuenac    - X-AsgUsa * t-ccbccaja.tpocmb.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-contra-entrega D-Dialog 
PROCEDURE Verifica-contra-entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR sw AS LOGICAL.
sw = FALSE.
FOR EACH Faccpedm WHERE Faccpedm.CodCia = S-CODCIA
                   AND  Faccpedm.CodDoc = "P/M"
                   AND  Faccpedm.FlgEst = "P" 
                   AND  Faccpedm.CodDiv = S-CODDIV
                  NO-LOCK:
      FIND gn-convt WHERE gn-convt.Codig = FacCPedm.FmaPgo
                     AND  gn-ConVt.TipVta BEGINS "1"
                    NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
        IF (FacCPedm.FchPed + gn-convt.totdias) < TODAY THEN sw = TRUE. 
      END.
END.
IF sw THEN DO:
    MESSAGE "No puede hacer Cierre de Caja" SKIP
            "por que existe Documentos pendientes" SKIP
            VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO Btn_OK IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
END.
ELSE RUN Cierre-de-caja.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


