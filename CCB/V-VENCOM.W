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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INT.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR X-ImpNac AS DEC NO-UNDO.
DEF VAR X-ImpUsa AS DEC NO-UNDO.

DEF BUFFER b-ccbccaja FOR ccbccaja.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.CodCli CcbCCaja.CodMon ~
CcbCCaja.TpoCmb CcbCCaja.Importe CcbCCaja.NomCli CcbCCaja.ImpNac[1] ~
CcbCCaja.ImpUsa[1] CcbCCaja.VueNac CcbCCaja.VueUsa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}Importe ~{&FP2}Importe ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}~
 ~{&FP1}ImpNac[1] ~{&FP2}ImpNac[1] ~{&FP3}~
 ~{&FP1}ImpUsa[1] ~{&FP2}ImpUsa[1] ~{&FP3}~
 ~{&FP1}VueNac ~{&FP2}VueNac ~{&FP3}~
 ~{&FP1}VueUsa ~{&FP2}VueUsa ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.FchDoc ~
CcbCCaja.CodCli CcbCCaja.CodMon CcbCCaja.TpoCmb CcbCCaja.Importe ~
CcbCCaja.NomCli CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] CcbCCaja.VueNac ~
CcbCCaja.VueUsa 
&Scoped-Define DISPLAYED-OBJECTS X-Status FILL-IN-1 

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
DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Valor de cambio S/." 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY .96.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 1.15.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 1.15.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14 BY 3.27.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 9.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     X-Status AT ROW 1.96 COL 58 COLON-ALIGNED
     CcbCCaja.NroDoc AT ROW 1.19 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCCaja.FchDoc AT ROW 1.19 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCCaja.CodCli AT ROW 1.96 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbCCaja.CodMon AT ROW 3.5 COL 19 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Venta", 1,
"Compra", 2
          SIZE 16 BY .77
     CcbCCaja.TpoCmb AT ROW 3.5 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCCaja.Importe AT ROW 4.27 COL 17 COLON-ALIGNED
          LABEL "Importe a cambiar US$"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-1 AT ROW 5.04 COL 17 COLON-ALIGNED
     CcbCCaja.NomCli AT ROW 2.73 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 39 BY .81
     CcbCCaja.ImpNac[1] AT ROW 7.54 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[1] AT ROW 7.54 COL 43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.VueNac AT ROW 8.69 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbCCaja.VueUsa AT ROW 8.69 COL 43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     RECT-5 AT ROW 6.38 COL 16
     RECT-6 AT ROW 7.35 COL 16
     RECT-7 AT ROW 8.5 COL 16
     RECT-8 AT ROW 6.38 COL 30
     RECT-9 AT ROW 1 COL 1
     "Tipo de operacion:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 3.65 COL 5
     "Cliente entrega" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 7.73 COL 18
     "Vuelto" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 8.88 COL 18
     "S/." VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 6.58 COL 33
     "US$" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 6.58 COL 46
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
         HEIGHT             = 9.46
         WIDTH              = 72.57.
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

/* SETTINGS FOR FILL-IN CcbCCaja.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.Importe IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = 0 AND
    gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie 
  THEN CcbCCaja.NomCli:SCREEN-VALUE = gn-clie.nomcli.
  ELSE CcbCCaja.NomCli:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCCaja.CodMon IN FRAME F-Main /* Moneda */
DO:
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
  IF SELF:SCREEN-VALUE = "1"
  THEN ASSIGN
        CcbCCaja.TpoCmb:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[1])
        CcbCCaja.ImpNac[1]:SENSITIVE = YES
        CcbCCaja.ImpUsa[1]:SENSITIVE = NO.
  ELSE ASSIGN
        CcbCCaja.TpoCmb:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[1])   /* Por ahora */
        CcbCCaja.ImpNac[1]:SENSITIVE = NO
        CcbCCaja.ImpUsa[1]:SENSITIVE = YES.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpNac[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpNac[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpNac[1] IN FRAME F-Main /* Importe Nacional[1] */
DO:
  RUN Calcular.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.Importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.Importe V-table-Win
ON LEAVE OF CcbCCaja.Importe IN FRAME F-Main /* Importe a cambiar US$ */
DO:
  FILL-IN-1:SCREEN-VALUE = STRING(DECIMAL(CcbCCaja.TpoCmb:SCREEN-VALUE) *
                            DECIMAL(SELF:SCREEN-VALUE)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpUsa[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpUsa[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpUsa[1] IN FRAME F-Main /* Importe US$[1] */
DO:
  RUN Calcular.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcular V-table-Win 
PROCEDURE Calcular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        X-ImpNac = DECIMAL(CcbCCaja.ImpNac[1]:SCREEN-VALUE) + 
                    DECIMAL(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) *
                    DECIMAL(CcbCCaja.TpoCmb:SCREEN-VALUE)
        X-ImpUsa = DECIMAL(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) + 
                    DECIMAL(CcbCCaja.ImpNac[1]:SCREEN-VALUE) /
                    DECIMAL(CcbCCaja.TpoCmb:SCREEN-VALUE)
        CcbCCaja.VueNac:SCREEN-VALUE = STRING(X-ImpNac -
                                        DECIMAL(FILL-IN-1:SCREEN-VALUE))
        CcbCCaja.VueUsa:SCREEN-VALUE = STRING(X-ImpUsa -
                                        DECIMAL(CcbCCaja.Importe:SCREEN-VALUE)).
    IF CcbCCaja.CodMon:SCREEN-VALUE = "1"
    THEN CcbCCaja.VueUsa:SCREEN-VALUE = "".
    ELSE CcbCCaja.VueNac:SCREEN-VALUE = "".
  END.
  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY TODAY @ ccbccaja.fchdoc.
    FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = s-coddoc AND
      NroSer = s-ptovta NO-LOCK.
    DISPLAY STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
        @ ccbccaja.nrodoc WITH FRAME {&FRAME-NAME}.
    FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
    IF CcbCCaja.CodMon:SCREEN-VALUE = "1"
    THEN CcbCCaja.TpoCmb:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[1]).
    ELSE CcbCCaja.TpoCmb:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[2]).
    ASSIGN
        CcbCCaja.TpoCmb:SENSITIVE = NO
        CcbCCaja.FchDoc:SENSITIVE = NO
        CcbCCaja.VueNac:SENSITIVE = NO
        CcbCCaja.VueUsa:SENSITIVE = NO.
    IF CcbCCaja.CodMon:SCREEN-VALUE = "1"
    THEN ASSIGN
            CcbCCaja.ImpNac[1]:SENSITIVE = YES
            CcbCCaja.ImpUsa[1]:SENSITIVE = NO.
    ELSE ASSIGN
            CcbCCaja.ImpNac[1]:SENSITIVE = NO
            CcbCCaja.ImpUsa[1]:SENSITIVE = YES.
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
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDoc = s-coddoc AND FacCorre.NroSer = s-ptovta
    EXCLUSIVE-LOCK.
  ASSIGN
    CcbCCaja.CodCia = s-codcia
    CcbCCaja.CodDoc = s-coddoc
    CcbCCaja.NroDoc = STRING(faccorre.nroser, "999") + 
                        STRING(faccorre.correlativo, "999999")
    CcbCCaja.Tipo   = s-tipo
    CcbCCaja.CodDiv = s-coddiv
    CcbCCaja.usuario= s-user-id
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  IF ccbccaja.codmon = 1
  THEN ccbccaja.impusa[1] = -1 * ccbccaja.importe.
  ELSE ccbccaja.impnac[1] = -1 * ccbccaja.importe * ccbccaja.tpocmb.
  RELEASE faccorre.

   

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
  IF ccbccaja.flgcie NE "P"
  THEN DO:
    MESSAGE "Ya se hizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    /*
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    */
    FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
    ASSIGN
        b-ccbccaja.flgest = "A".
    RELEASE b-ccbccaja.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE ccbccaja THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN
        FILL-IN-1:SCREEN-VALUE = STRING(CcbCCaja.TpoCmb * CcbCCaja.Importe).
     CASE ccbccaja.flgest:
          WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
          OTHERWISE X-Status:SCREEN-VALUE = "EMITIDO".
     END CASE.
  END.
  
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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
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
DO WITH FRAME {&FRAME-NAME} :
  FIND gn-clie WHERE gn-clie.codcia = 0 AND 
    gn-clie.codcli = ccbccaja.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie
  THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO ccbccaja.codcli.
    RETURN "ADM-ERROR".
  END.
  IF DECIMAL(CcbCCaja.Importe:SCREEN-VALUE) <= 0
  THEN DO:
    MESSAGE "Ingrese el importe a cambiar" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO ccbccaja.importe.
    RETURN "ADM-ERROR".
  END.
  IF DECIMAL(CcbCCaja.VueNac:SCREEN-VALUE) < 0 OR 
    DECIMAL(CcbCCaja.VueUsa:SCREEN-VALUE) < 0
  THEN DO:
    MESSAGE "El pago no cubre el monto" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO CcbCCaja.ImpNac[1].
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

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


