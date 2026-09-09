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
DEF SHARED VAR s-NomCia  AS CHAR.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR lh_Handle AS HANDLE.

DEF VAR Y-CODMON AS INTEGER.

DEF BUFFER b-ccbccaja FOR ccbccaja.

DEF VAR s-titulo AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCCaja.FchDoc CcbCCaja.ImpNac[1] ~
CcbCCaja.Glosa 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS moneda 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.CodDiv ~
CcbCCaja.FchDoc CcbCCaja.usuario CcbCCaja.TpoCmb CcbCCaja.ImpNac[1] ~
CcbCCaja.ImpUsa[1] CcbCCaja.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja
&Scoped-Define DISPLAYED-OBJECTS X-Status x-cerrado 

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

DEFINE VARIABLE x-cerrado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Esta cerrado ?" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.NroDoc AT ROW 1.19 COL 10 COLON-ALIGNED
          LABEL "Número" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 6
     X-Status AT ROW 1.19 COL 62 COLON-ALIGNED
     CcbCCaja.CodDiv AT ROW 1.96 COL 10 COLON-ALIGNED
          LABEL "División"
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .69
     CcbCCaja.FchDoc AT ROW 1.96 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     moneda AT ROW 2.73 COL 10 COLON-ALIGNED HELP
          "Ingrese Moneda  --> Use flechas del cursor"
     CcbCCaja.usuario AT ROW 2.73 COL 62 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.TpoCmb AT ROW 3.5 COL 62 COLON-ALIGNED
          LABEL "Tipo de Cambio"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.ImpNac[1] AT ROW 3.69 COL 10 COLON-ALIGNED
          LABEL "Importe S/." FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.ImpUsa[1] AT ROW 4.46 COL 10 COLON-ALIGNED
          LABEL "Importe US$" FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     x-cerrado AT ROW 4.46 COL 62 COLON-ALIGNED WIDGET-ID 2
     CcbCCaja.Glosa AT ROW 6.19 COL 2.72 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 72.14 BY 1.35
     "Detalle" VIEW-AS TEXT
          SIZE 5.72 BY .5 AT ROW 5.54 COL 3.29
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
         HEIGHT             = 6.92
         WIDTH              = 76.57.
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

/* SETTINGS FOR FILL-IN CcbCCaja.CodDiv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR EDITOR CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX moneda IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCCaja.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-cerrado IN FRAME F-Main
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
/*   RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter). */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.        */

    DEFINE VARIABLE lFound AS LOGICAL NO-UNDO.
    DEFINE VARIABLE fMonto AS DECIMAL NO-UNDO.

    IF s-tipo = "SENCILLO" THEN DO:

        /* Busca I/C tipo "Sencillo" Activo */
        lFound = FALSE.
        FOR EACH b-ccbccaja WHERE
            b-ccbccaja.codcia = s-codcia AND
            b-ccbccaja.coddiv = s-coddiv AND
            b-ccbccaja.coddoc = "I/C" AND
            b-ccbccaja.tipo = s-tipo AND
            b-ccbccaja.usuario = s-user-id AND 
            b-ccbccaja.codcaja = s-codter AND
            b-ccbccaja.flgcie = "P" NO-LOCK:
            IF b-CcbCCaja.FlgEst <> "A" THEN DO:
                lFound = TRUE.
                fMonto = fMonto + b-ccbccaja.ImpNac[1].
            END.
        END.
        IF NOT lFound THEN DO:
            MESSAGE
                "No se realizó el I/C correspondiente de tipo" s-tipo "para el terminal" s-codter
                VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.

        /* Busca E/C tipo "Sencillo" Activo */
        lFound = FALSE.
        FOR EACH b-ccbccaja WHERE
            b-ccbccaja.codcia = s-codcia AND
            b-ccbccaja.coddiv = s-coddiv AND
            b-ccbccaja.coddoc = s-coddoc AND
            b-ccbccaja.tipo = s-tipo AND
            b-ccbccaja.usuario = s-user-id AND 
            b-ccbccaja.codcaja = s-codter AND
            b-ccbccaja.flgcie = "P" NO-LOCK:
            IF b-CcbCCaja.FlgEst <> "A" THEN lFound = TRUE.
        END.
        IF lFound THEN DO:
            MESSAGE
                "Ya se realizó el E/C de tipo" s-tipo "para el terminal" s-codter
                VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.

    END.

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
            fMonto @ CcbCCaja.ImpNac[1]
            MONEDA.
        IF s-tipo = "SENCILLO" THEN DO:
            moneda:SENSITIVE = FALSE.
            CcbCCaja.ImpNac[1]:SENSITIVE = FALSE.
        END.
        ELSE moneda:SENSITIVE = TRUE.
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
          /*CcbCCaja.FchDoc  = TODAY*/
          CcbCCaja.FchCbd  = TODAY
          CcbCCaja.HorDoc = STRING(TIME, 'HH:MM:SS')
          CcbCCaja.TpoCmb  = DECI(CcbCCaja.TpoCmb:SCREEN-VALUE)
          CcbCCaja.ImpNac[1] = DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE)
          CcbCCaja.ImpUsa[1] = DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE)
          /*CcbcCaja.Flgest    = "C"*/
          CcbcCaja.Flgest    = (IF s-Tipo = "REMEBOV" THEN "E" ELSE "C")
          CcbCCaja.Voucher[10] = STRING(TIME,"HH:MM:SS")
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

    IF ccbccaja.flgcie = "C" THEN DO:
        MESSAGE
            "Cierre de caja ya realizado"
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
        FOR EACH ccbdcaja OF ccbccaja:
            DELETE ccbdcaja.
        END.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  DO WITH FRAME {&FRAME-NAME}.
    X-Cerrado:SCREEN-VALUE = "    " .
  END.

  /* Code placed here will execute AFTER standard behavior.    */
    IF AVAILABLE CcbCCaja THEN DO WITH FRAME {&FRAME-NAME}:
        X-Cerrado:SCREEN-VALUE = " No " .
        IF CcbCCaja.FlgEst  = "A" THEN X-Status:SCREEN-VALUE = "ANULADO ".  
        IF CcbCCaja.FlgEst  = "C" THEN X-Status:SCREEN-VALUE = "PENDIENTE".  
        IF CcbCCaja.FlgEst  = "P" THEN X-Status:SCREEN-VALUE = "PENDIENTE".  
        IF CcbCCaja.FlgEst  = "E" THEN X-Status:SCREEN-VALUE = "POR APROBAR".  
        IF CcbCCaja.FlgEst  = " " THEN X-Status:SCREEN-VALUE = "PENDIENTE".  
        IF CcbCCaja.FlgCie  = "C" THEN X-Cerrado:SCREEN-VALUE = " Si " .
        IF CcbCCaja.ImpNac[1] <> 0 THEN moneda = "S/.".
        IF CcbCCaja.ImpUsa[1] <> 0 THEN moneda = "US$" .
        DISPLAY moneda.
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF CcbcCaja.Flgest = "A" THEN DO:
        MESSAGE
            "Recibo Anulado. Verifique"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    CASE s-tipo:
        WHEN "REMECJC" THEN s-titulo = "REMESA A CAJA CENTRAL".
        WHEN "REMEBOV" THEN s-titulo = "REMESA A BÓVEDA".
        OTHERWISE s-titulo = "OTRO".
    END CASE.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Remesas"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "Ccbccaja.Codcia = " + STRING(S-CODCIA) +
            " AND Ccbccaja.Coddoc = '" + ccbccaja.coddoc + "'" +
            " AND Ccbccaja.nrodoc = '" + ccbccaja.nrodoc + "'"
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
        WHEN "CodCta" THEN ASSIGN input-var-1 = "".
        
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
        IF NOT (INPUT INTEGRAL.CcbCCaja.FchDoc >= TODAY - 7 AND INPUT INTEGRAL.CcbCCaja.FchDoc <= TODAY) 
            THEN DO:
            MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX ERROR.
            DISPLAY TODAY @ Ccbccaja.fchdoc WITH FRAME {&FRAME-NAME}.
            APPLY 'ENTRY':U TO Ccbccaja.fchdoc.
            RETURN 'ADM-ERROR'.
        END.
        IF DECIMAL(CcbCCaja.ImpNac[1]:SCREEN-VALUE) +
            DECIMAL(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) = 0 THEN DO:
            MESSAGE
                "Importe debe ser mayor que cero"
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

