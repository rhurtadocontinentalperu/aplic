&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE        VAR I-CODMON AS INTEGER.
DEFINE        VAR R-ROWID  AS ROWID.
DEFINE        VAR D-FCHDOC AS DATE.
DEFINE        VAR F-TPOCMB AS DECIMAL.

DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.

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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.FchDoc Almcmov.CodMon Almcmov.TpoCmb ~
Almcmov.CodCli Almcmov.CodPro Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.CodMon Almcmov.TpoCmb Almcmov.CodCli Almcmov.CodPro Almcmov.NroRf1 ~
Almcmov.NroRf2 Almcmov.Observ 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomCli FILL-IN-NomPro 

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
DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY .69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.72 BY 4.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1.19 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     Almcmov.FchDoc AT ROW 1.19 COL 72.86 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     Almcmov.CodMon AT ROW 2.04 COL 75.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .5
     Almcmov.TpoCmb AT ROW 2.73 COL 72.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     Almcmov.CodCli AT ROW 1.96 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     FILL-IN-NomCli AT ROW 1.96 COL 23 COLON-ALIGNED NO-LABEL
     Almcmov.CodPro AT ROW 2.73 COL 13.29 COLON-ALIGNED FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     FILL-IN-NomPro AT ROW 2.73 COL 23 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf1 AT ROW 3.5 COL 13.29 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf2 AT ROW 3.5 COL 72.86 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 4.35 COL 13.29 COLON-ALIGNED FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 57.43 BY .69
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 1.96 COL 67.43
     RECT-2 AT ROW 1.96 COL 74.86
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov,integral.Almtdocm
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
         HEIGHT             = 4.35
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN Almcmov.CodPro IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME Almcmov.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodCli V-table-Win
ON LEAVE OF Almcmov.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Almcmov.CodCli:VISIBLE THEN DO:
     FIND gn-clie WHERE gn-clie.CodCia = cl-CodCia AND 
                        gn-clie.CodCli = INPUT Almcmov.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
/*      ELSE DO:                                                                                         */
/*           FIND gn-clie WHERE gn-clie.CodCia = 0 AND                                                   */
/*                gn-clie.CodCli = INPUT Almcmov.CodCli NO-LOCK NO-ERROR.                                */
/*           IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}. */
/*      END.                                                                                             */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodMon V-table-Win
ON ENTRY OF Almcmov.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF I-CODMON <> 3 OR Almtdocm.TipMov = "S" THEN DO:
     IF Almtdocm.TipMov = "S" THEN ASSIGN Almcmov.CodMon:SCREEN-VALUE = "1".
     ELSE ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(I-CODMON,'9').
     APPLY "ENTRY" TO Almcmov.TpoCmb.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodPro V-table-Win
ON LEAVE OF Almcmov.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF Almcmov.CodPro:VISIBLE THEN DO:
     FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia AND 
                        gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
/*      ELSE DO:                                                                                         */
/*           FIND gn-prov WHERE gn-prov.CodCia = 0 AND                                                   */
/*                gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.                                */
/*           IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}. */
/*      END.                                                                                             */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.FchDoc V-table-Win
ON LEAVE OF Almcmov.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT Almcmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "Almcmov"}
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DISPLAY TODAY @ Almcmov.FchDoc WITH FRAME {&FRAME-NAME}.
  FIND LAST gn-tcmb NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb WITH FRAME {&FRAME-NAME}.
  RUN Procesa-Handle IN lh_Handle ('Inactiva').

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
  /* Revalorizamos por modificacion de fecha o tipo de cambio */
  RUN get-attribute('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' AND ( D-FCHDOC <> Almcmov.FchDoc OR
     F-TPOCMB <> Almcmov.TpoCmb ) THEN DO:
     FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
                            Almdmov.CodAlm = Almcmov.CodAlm AND
                            Almdmov.TipMov = Almcmov.TipMov AND
                            Almdmov.CodMov = Almcmov.CodMov AND
                            Almdmov.NroDoc = Almcmov.NroDoc:
         ASSIGN R-ROWID = ROWID(Almdmov).
         RUN ALM\ALMACPR1 (R-ROWID,"D").
         RUN ALM\ALMACPR2 (R-ROWID,"D").
         ASSIGN Almdmov.FchDoc = D-FCHDOC
                Almdmov.TpoCmb = F-TPOCMB.
         IF Almcmov.TipMov = "I" THEN RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen POR INGRESOS*/
         IF Almcmov.TipMov = "S" THEN RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen   POR SALIDAS*/
         RUN ALM\ALMACPR1 (R-ROWID,"U").
         RUN ALM\ALMACPR2 (R-ROWID,"U").
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO TRANSACTION:
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
            Almcmov.CodAlm  = Almtdocm.CodAlm 
            Almcmov.TipMov  = Almtdocm.TipMov
            Almcmov.CodMov  = Almtdocm.CodMov.
     FIND TDOCM WHERE ROWID(TDOCM) = ROWID(Almtdocm) EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE TDOCM THEN ASSIGN Almcmov.NroDoc  = TDOCM.NroDoc
                                       TDOCM.NroDoc = TDOCM.NroDoc + 1.
     RELEASE TDOCM.
     /*FIND TDOCM WHERE ROWID(TDOCM) = ROWID(Almtdocm) NO-LOCK NO-ERROR.*/
     DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  END.
  DO TRANSACTION:
    ASSIGN Almcmov.usuario = S-USER-ID.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

  RUN get-attribute('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO :
     RUN Procesa-Handle IN lh_Handle ('Activa').
  END.

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

  RUN Procesa-Handle IN lh_Handle ('Activa').

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
  
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Eliminamos el detalle */
  FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
           Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND
           Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           ASSIGN R-ROWID = ROWID(Almdmov).
           IF Almcmov.TipMov = "I" THEN RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
           IF Almcmov.TipMov = "S" THEN RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen */
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
      DELETE Almdmov.
  END.
 
  /* Solo marcamos el FlgEst como Anulado */
   FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia AND
                  CMOV.CodAlm = Almcmov.CodAlm AND
                  CMOV.TipMov = Almcmov.TipMov AND
                  CMOV.CodMov = Almcmov.CodMov AND
                  CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR.
  ASSIGN CMOV.FlgEst = 'A'
         CMOV.Observ = "      A   N   U   L   A   D   O       ".
  FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia AND
                  CMOV.CodAlm = Almcmov.CodAlm AND
                  CMOV.TipMov = Almcmov.TipMov AND
                  CMOV.CodMov = Almcmov.CodMov AND
                  CMOV.NroDoc = Almcmov.NroDoc NO-LOCK NO-ERROR.

  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

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

  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almtdocm.CodCia AND
                       Almtmovm.Tipmov = Almtdocm.TipMov AND 
                       Almtmovm.Codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN Almcmov.CodCli:VISIBLE = Almtmovm.PidCli
            Almcmov.CodPro:VISIBLE = Almtmovm.PidPro
            Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
            Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
                          I-CODMON = Almtmovm.CodMon.
     IF Almtmovm.CodMon <> 3 THEN DO:
        ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
     END.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1 .
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
     IF Almtdocm.TipMov = "S" THEN DO:
        ASSIGN Almcmov.TpoCmb:VISIBLE = NO
               Almcmov.CodMon:SCREEN-VALUE = '1'.
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     IF Almcmov.CodPro:VISIBLE THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
                           gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
        ELSE DO:
             FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                  gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
             IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
        END.
     END.
     IF Almcmov.CodCli:VISIBLE THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
        ELSE DO:
             FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                  gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
             IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
        END.
     END.
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
  
  RUN ALM\R-IMPFMT.R(ROWID(almcmov)).

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
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "Almtdocm"}

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
   /* Capturamos las modificaciones de fecha o tipo de cambio para revalorizar */
   ASSIGN  D-FCHDOC = INPUT Almcmov.FchDoc   
           F-TPOCMB = INPUT Almcmov.TpoCmb.  
   IF Almcmov.CodPro:VISIBLE THEN DO:
      FIND gn-prov WHERE gn-prov.CodCia = Almtdocm.CodCia AND
           gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
              gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Almcmov.CodPro.
            RETURN "ADM-ERROR".   
         END.
      END.
   END.
   IF Almcmov.CodCli:VISIBLE THEN DO:
      FIND gn-clie WHERE gn-clie.CodCia = Almtdocm.CodCia AND 
           gn-clie.CodCli = INPUT Almcmov.CodCli NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
              gn-clie.CodCli = INPUT Almcmov.CodCli NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-clie THEN DO:
            MESSAGE "Codigo de Cliente no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Almcmov.CodCli.
            RETURN "ADM-ERROR".   
         END.
      END.
   END. 
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE VARIABLE RPTA AS CHAR NO-UNDO.

IF Almcmov.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
     Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

