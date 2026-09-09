&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF SHARED VAR S-NOMCIA  AS CHAR.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR F-CODDOC AS CHAR INIT "A/R".
DEF VAR Y-CODMON AS INTEGER.
DEF VAR X-CTASOL AS CHAR INIT "122101".
DEF VAR X-CTADOL AS CHAR INIT "122102".

DEF BUFFER b-ccbccaja FOR ccbccaja.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCCaja.CodCli CcbCCaja.ImpNac[1] ~
CcbCCaja.Codcta[10] CcbCCaja.Glosa 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.CodDiv ~
CcbCCaja.FchDoc CcbCCaja.CodCli CcbCCaja.usuario CcbCCaja.TpoCmb ~
CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] CcbCCaja.Codcta[10] CcbCCaja.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja
&Scoped-Define DISPLAYED-OBJECTS X-Status F-NomDiv F-Descli F-NroDoc ~
x-Nombr 

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
DEFINE VARIABLE moneda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "S/.","US$" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-Descli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-NroDoc AS CHARACTER FORMAT "xxx-xxxxxx" 
     LABEL "Numero Doc" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 7.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.NroDoc AT ROW 1.19 COL 10 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 6
     X-Status AT ROW 1.19 COL 63 COLON-ALIGNED
     CcbCCaja.CodDiv AT ROW 1.96 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .69
     F-NomDiv AT ROW 1.96 COL 17.86 COLON-ALIGNED NO-LABEL
     CcbCCaja.FchDoc AT ROW 1.96 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.CodCli AT ROW 2.73 COL 10 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .69
     CcbCCaja.usuario AT ROW 2.73 COL 63 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-Descli AT ROW 2.77 COL 21.72 COLON-ALIGNED NO-LABEL
     F-NroDoc AT ROW 3.5 COL 10 COLON-ALIGNED
     CcbCCaja.TpoCmb AT ROW 3.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     moneda AT ROW 4.27 COL 10 COLON-ALIGNED HELP
          "Ingrese Moneda  --> Use flechas del cursor"
     CcbCCaja.ImpNac[1] AT ROW 4.35 COL 63 COLON-ALIGNED
          LABEL "Importe S/." FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.ImpUsa[1] AT ROW 5.15 COL 63 COLON-ALIGNED
          LABEL "Importe US$" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.Codcta[10] AT ROW 5.23 COL 10 COLON-ALIGNED
          LABEL "Cond. Venta" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     x-Nombr AT ROW 5.23 COL 17 COLON-ALIGNED NO-LABEL
     CcbCCaja.Glosa AT ROW 7.04 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 73.29 BY 1.35
     "Detalle" VIEW-AS TEXT
          SIZE 5.72 BY .5 AT ROW 6.38 COL 2.57
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
         HEIGHT             = 7.88
         WIDTH              = 77.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCCaja.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCCaja.Codcta[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Descli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX moneda IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-Nombr IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = "" THEN RETURN.
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = CcbCCaja.CodCli:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie  THEN DO:
            MESSAGE
                "Código de cliente no existe"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        DISPLAY gn-clie.NomCli @ F-Descli.
        IF gn-clie.CodCli BEGINS "11111111" THEN DO:
            F-Descli:SENSITIVE = TRUE.
            APPLY 'ENTRY':U TO F-Descli.
        END.
        ELSE F-Descli:SENSITIVE = FALSE.
    END. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.Codcta[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.Codcta[10] V-table-Win
ON LEAVE OF CcbCCaja.Codcta[10] IN FRAME F-Main /* Cond. Venta */
DO:
  x-Nombr:SCREEN-VALUE = ''.
  FIND Gn-convt WHERE Gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN x-Nombr:SCREEN-VALUE = Gn-convt.nombr.
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
        IF moneda:SCREEN-VALUE = "S/." THEN y-CodMon = 1.
        ELSE y-CodMon = 2.
        IF Y-CodMon = 1 THEN DO:       
            CcbCcaja.ImpNac[1]:SENSITIVE = YES.
            CcbCcaja.ImpUsa[1]:SENSITIVE = NO.
            DISPLAY 0 @ CcbCcaja.ImpUsa[1].
        END.
        IF Y-CodMon = 2 THEN DO:
            DISPLAY 0 @ CcbCcaja.ImpNac[1].
            CcbCcaja.ImpNac[1]:SENSITIVE = NO.
            CcbCcaja.ImpUsa[1]:SENSITIVE = YES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Documento V-table-Win 
PROCEDURE Cancelar-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST FacCorre WHERE
        FacCorre.CodCia = s-codcia AND
        FacCorre.Coddiv = s-coddiv AND
        FacCorre.CodDoc = f-coddoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.
    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.Codcia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.Coddoc = F-CODDOC
        CcbCDocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
        CcbCDocu.CodCli = CcbCcaja.Codcli
        CcbCDocu.NomCli = CcbCcaja.Nomcli
        CcbCDocu.CodRef = CcbCcaja.CodDoc
        CcbCDocu.NroRef = CcbCcaja.NroDoc
        CcbCDocu.fmapgo = CcbCcaja.Codcta[10]
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodMon = Y-CODMON
        CcbCDocu.Usuario = S-USER-ID            
        CcbCCaja.Voucher[1] = STRING(F-Coddoc,"X(3)") + CcbCDocu.NroDoc
        CcbCDocu.FlgEst = "P"
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Y-CodMon = 2 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = CcbCcaja.ImpUsa[1]
            CcbCDocu.SdoAct = CcbCcaja.ImpUsa[1].
    END.
    IF Y-CodMon = 1 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = CcbCcaja.ImpNac[1]
            CcbCDocu.SdoAct = CcbCcaja.ImpNac[1].
    END.
END.
RETURN 'OK'.

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
  DEFINE VARIABLE lAnswer AS LOGICAL NO-UNDO.
  
  IF s-user-id <> 'admin' THEN DO:
      /* RHC 28/03/2016 Rutrina que verifica que no haya un cierre de caja pendiente */
      RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* Verifica Monto Tope por CAJA */
      RUN ccb\p-vermtoic (OUTPUT lAnswer).
      IF lAnswer THEN RETURN ERROR.

      /* Busca I/C tipo "Sencillo" Activo */
      IF NOT s-codter BEGINS "ATE" THEN DO:
          lAnswer = FALSE.
          FOR EACH b-ccbccaja WHERE
              b-ccbccaja.codcia = s-codcia AND
              b-ccbccaja.coddiv = s-coddiv AND
              b-ccbccaja.coddoc = "I/C" AND
              b-ccbccaja.tipo = "SENCILLO" AND
              b-ccbccaja.usuario = s-user-id AND
              b-ccbccaja.codcaja = s-codter AND
              b-ccbccaja.flgcie = "P" NO-LOCK:
              IF b-ccbccaja.flgest <> "A" THEN lAnswer = TRUE.
          END.
          IF NOT lAnswer THEN DO:
              MESSAGE
                  "Se debe ingresar el I/C SENCILLO como primer movimiento"
                  VIEW-AS ALERT-BOX ERROR.
              RETURN ERROR.
          END.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

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
        CcbCCaja.Codcli:SCREEN-VALUE = "".
        CcbCCaja.Codcta[10]:SCREEN-VALUE = "002".       /* Ic - 09Feb2021, coordinacion con Susana Leon x cell */
        ASSIGN MONEDA:SENSITIVE = YES.
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
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          CcbCCaja.CodCia  = s-codcia
          CcbCCaja.CodDoc  = s-coddoc
          CcbCCaja.NroDoc  = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
          CcbCCaja.CodDiv  = S-CODDIV
          CcbCCaja.Tipo    = s-tipo
          CcbCCaja.usuario = s-user-id
          CcbCCaja.CodCaja = S-CODTER
          CcbCCaja.FchDoc  = TODAY
          CcbCCaja.TpoCmb  = DECI(CcbCCaja.TpoCmb:SCREEN-VALUE)
          CcbCCaja.ImpNac[1] = DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE)
          CcbCCaja.ImpUsa[1] = DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE)
          CcbcCaja.Flgest    = "C"
          CcbCCaja.Voucher[1] = STRING(F-Coddoc,"X(3)") +
              STRING(F-Nrodoc:SCREEN-VALUE,"X(9)")
          CcbCCaja.NomCli = F-DesCli:SCREEN-VALUE
          CcbCCaja.Voucher[10] = STRING(TIME,"HH:MM:SS").
      FacCorre.Correlativo = FacCorre.Correlativo + 1.     
      IF Y-CodMon = 2 THEN DO:
          CcbCCaja.CodCta[1] = X-CTADOL.
      END.
      IF Y-CodMon = 1 THEN DO:
          CcbCCaja.CodCta[1] = X-CTASOL.
      END.
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
      /* *************************** */
      /* 19/01/2024: Mejora contínua */
      /* *************************** */
      DEF VAR pNroAR AS CHAR NO-UNDO.
      RUN ccb/p-genera-ar.p (INPUT ROWID(Ccbccaja),
                             INPUT y-CodMon,
                             OUTPUT pNroAR,
                             OUTPUT pMensaje).
      ASSIGN
          CcbCCaja.Voucher[1] = pNroAR.
      /* *************************** */
      /* *************************** */
/*         RUN Cancelar-Documento.                                      */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
    END.
    IF AVAILABLE(FacCorre) THEN RELEASE faccorre.

    F-Descli:SENSITIVE = FALSE.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        F-Descli:SENSITIVE = FALSE.
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

/* Correo Susana Leon 23Jun2017 */
MESSAGE "NO se permite ANULACION"
    VIEW-AS ALERT-BOX ERROR.

RETURN "ADM-ERROR".

    IF ccbccaja.flgcie = "C" THEN DO:
        MESSAGE "Ya se hizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF ccbccaja.flgest = "A" THEN DO:
        MESSAGE
            "Registro ya fue Anulado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        FIND CcbCdocu WHERE
            CcbCdocu.CodCia = s-codcia AND
            CcbCdocu.CodDiv = S-CODDIV AND
            CcbCdocu.CodDoc = F-Coddoc AND
            CcbCdocu.NroDoc = INPUT FRAME {&FRAME-NAME} F-Nrodoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbCdocu THEN DO:
            MESSAGE
                'Anticipo no se encuentra registrado'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        IF CcbCdocu.SdoAct <> CcbCdocu.ImpTot THEN DO:
            MESSAGE
                'Anticipo presenta cancelaciones'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        ASSIGN
            CcbCdocu.SdoAct = 0
            CcbCdocu.FlgEst = "A".
        FOR EACH ccbdcaja OF ccbccaja:
            DELETE ccbdcaja.
        END.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CCBCCAJA THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            b-ccbccaja.flgest = "A"
            b-ccbccaja.usranu = s-user-id
            b-ccbccaja.fchanu = TODAY
            b-ccbccaja.horanu = STRING(TIME, 'HH:MM:SS').
        RELEASE b-ccbccaja.
    END.

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
  IF AVAILABLE CcbCCaja THEN DO WITH FRAME {&FRAME-NAME}:
        IF CcbCCaja.FlgEst = "A" THEN X-Status:SCREEN-VALUE = " ANULADO ".
        IF CcbCCaja.FlgEst = "C" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgEst = "P" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgEst = " " THEN X-Status:SCREEN-VALUE = " PENDIENTE".
        IF CcbCCaja.FlgCie = "C" THEN X-Status:SCREEN-VALUE = " CERRADO ".

        DISPLAY
            CcbCCaja.NomCli @ F-Descli
            SUBSTRING(CcbCCaja.Voucher[1],4,15) @ F-NroDoc.

        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            moneda = "S/.".
        END.
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            moneda = "US$" .
        END.
        DISPLAY moneda.
        x-Nombr:SCREEN-VALUE = ''.
        FIND Gn-convt WHERE Gn-convt.codig = CcbCCaja.Codcta[10]NO-LOCK NO-ERROR.
        IF AVAILABLE GN-convt THEN x-Nombr:SCREEN-VALUE = gn-ConVt.Nombr.
  END.
  ASSIGN
        moneda:SENSITIVE = NO
        CcbCCaja.ImpNac[1]:SENSITIVE = NO
        CcbCCaja.ImpUsa[1]:SENSITIVE = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR s-titulo AS CHAR NO-UNDO.

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
        RB-REPORT-NAME = "Anticipos"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "Ccbccaja.Codcia = " + string(S-CODCIA,"999") +
            " AND Ccbccaja.Coddoc = '" + S-CODDOC + "'" +
            " AND Ccbccaja.Nrodoc = '" + STRING(Ccbccaja.Nrodoc, 'x(12)') + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo.

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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

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
/*        WHEN "CodCta" THEN ASSIGN input-var-1 = "IJ".*/
        WHEN "CodCta[10]" THEN ASSIGN input-var-1 = "1".
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

  DO WITH FRAME {&FRAME-NAME} :
      IF CcbCCaja.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
          MESSAGE 'NO se puede registrar a un cliente genérico'
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
          AND gn-clie.CodCli = CcbCCaja.CodCli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie  THEN DO:
          MESSAGE "Codigo de cliente no existe"
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCCaja.CodCli.
          RETURN "ADM-ERROR".
      END.
      /* ************************************************************************* */
      /* RHC Control del RUC y DNI */
      /* ************************************************************************* */
      DEF VAR pResultado AS CHAR.
      CASE TRUE:
          WHEN gn-clie.Libre_C01 = "J" 
              THEN DO:
              IF LENGTH(gn-clie.Ruc) < 11 OR LOOKUP(SUBSTRING(gn-clie.Ruc,1,2), '20') = 0 THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Debe tener 11 dígitos y comenzar con 20' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
              /* dígito verificador */
              RUN lib/_ValRuc (gn-clie.Ruc, OUTPUT pResultado).
              IF pResultado = 'ERROR' THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Código mal registrado' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
          END.
          WHEN gn-clie.Libre_C01 = "E" AND LOOKUP(SUBSTRING(gn-clie.Ruc,1,2), '15,17') > 0 THEN DO:
              IF LENGTH(gn-clie.Ruc) < 11 THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Debe tener 11 dígitos y comenzar con 15 ó 17' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
              /* dígito verificador */
              RUN lib/_ValRuc (gn-clie.Ruc, OUTPUT pResultado).
              IF pResultado = 'ERROR' THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Código mal registrado' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
          END.
/*           WHEN gn-clie.Libre_C01 = "N" AND gn-clie.Ruc <> '' THEN DO:                              */
/*               IF LENGTH(gn-clie.Ruc) < 11 OR LOOKUP(SUBSTRING(gn-clie.Ruc,1,2), '10') = 0 THEN DO: */
/*                   MESSAGE 'ERROR en el RUC del cliente' SKIP                                       */
/*                       'RUC:' gn-clie.Ruc SKIP                                                      */
/*                       'Debe tener 11 dígitos y comenzar con 10' SKIP                               */
/*                       'Hacer las correcciones en el maestro de clientes'                           */
/*                       VIEW-AS ALERT-BOX ERROR.                                                     */
/*                   APPLY 'ENTRY':U TO CcbCCaja.CodCli.                                              */
/*                   RETURN 'ADM-ERROR'.                                                              */
/*               END.                                                                                 */
/*               /* dígito verificador */                                                             */
/*               RUN lib/_ValRuc (gn-clie.Ruc, OUTPUT pResultado).                                    */
/*               IF pResultado = 'ERROR' THEN DO:                                                     */
/*                   MESSAGE 'ERROR en el RUC del cliente' SKIP                                       */
/*                       'RUC:' gn-clie.Ruc SKIP                                                      */
/*                       'Código mal registrado' SKIP                                                 */
/*                       'Hacer las correcciones en el maestro de clientes'                           */
/*                       VIEW-AS ALERT-BOX ERROR.                                                     */
/*                   APPLY 'ENTRY':U TO CcbCCaja.CodCli.                                              */
/*                   RETURN 'ADM-ERROR'.                                                              */
/*               END.                                                                                 */
/*           END.                                                                                     */
      END CASE.
      /* ************************************************************************* */
      /* SOLO OPENORANGE */
      DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
      RUN gn/clienteopenorange (cl-codcia, CcbCCaja.CodCli:SCREEN-VALUE, s-CodDoc, OUTPUT pClienteOpenOrange).
      IF pClienteOpenOrange = YES THEN DO:
          MESSAGE "Cliente NO se puede antender por Continental" SKIP
              "Solo se le puede antender por OpenOrange"
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCCaja.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE) + DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) = 0 
          THEN DO:
          MESSAGE "Importe no debe ser cero"
              VIEW-AS ALERT-BOX ERROR.
          IF y-codmon = 1 THEN APPLY "ENTRY" TO CcbCCaja.ImpNac[1].
          IF y-codmon = 2 THEN APPLY "ENTRY" TO CcbCCaja.ImpUsa[1].
          RETURN "ADM-ERROR".      
      END.
      IF CcbCCaja.Codcta[10]:SCREEN-VALUE <> '' THEN DO:
          FIND Gn-convt WHERE Gn-convt.codig = CcbCCaja.Codcta[10]:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE GN-convt THEN DO:
              MESSAGE "Condicion de venta no existe"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO CcbCCaja.CodCta[10].
              RETURN "ADM-ERROR".
          END.
      END.
      ELSE DO:
          /* Ic - 09Feb2021, coordinacion con Susana Leon x cell */
          MESSAGE "Ingrese la condicion de venta. Por favor!!!"
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCCaja.CodCta[10].
          RETURN "ADM-ERROR".
      END.
  END.

  /* Realizar la PREGUNTA */
        MESSAGE 'Una vez GRABADO no hay ANULACION ni MODIFICACION' SKIP
        'Esta seguro de GRABAR?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN "ADM-ERROR".

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

