&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR lh_Handle AS HANDLE.

DEF SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.FchPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.DirCli FacCPedi.RucCli FacCPedi.CodMon 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.DirCli FacCPedi.RucCli ~
FacCPedi.CodMon 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado COMBO-BOX-CodRef ~
FILL-IN-NroRef FILL-IN-Glosa 

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
DEFINE VARIABLE COMBO-BOX-CodRef AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Referencia" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "TCK","FAC" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 11 COLON-ALIGNED
          LABEL "No. de Control"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Estado AT ROW 1 COL 34 COLON-ALIGNED
     FacCPedi.FchPed AT ROW 1 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.77 COL 11 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 1.77 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
     FacCPedi.DirCli AT ROW 2.54 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     FacCPedi.RucCli AT ROW 2.54 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     COMBO-BOX-CodRef AT ROW 3.5 COL 11 COLON-ALIGNED
     FILL-IN-NroRef AT ROW 3.5 COL 19 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 3.5 COL 80 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 15 BY .77
     FILL-IN-Glosa AT ROW 4.46 COL 11 COLON-ALIGNED
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.5 COL 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 6.88
         WIDTH              = 96.57.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Glosa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie
  THEN ASSIGN
            FacCPedi.DirCli:SCREEN-VALUE = gn-clie.dircli
            FacCPedi.NomCli:SCREEN-VALUE = gn-clie.nomcli
            FacCPedi.RucCli:SCREEN-VALUE = gn-clie.ruc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroRef V-table-Win
ON LEAVE OF FILL-IN-NroRef IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = COMBO-BOX-CodRef:SCREEN-VALUE
        AND Ccbcdocu.nrodoc = FILL-IN-NroRef:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.codcli <> FacCPedi.CodCli:SCREEN-VALUE THEN DO:
        MESSAGE 'Documento NO válido' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ASSIGN
        s-PorIgv = Ccbcdocu.PorIgv
        COMBO-BOX-CodRef:SENSITIVE = NO
        FacCPedi.CodCli:SENSITIVE = NO
        FILL-IN-NroRef:SENSITIVE = NO.
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Facdpedi OF Faccpedi:
    DELETE FAcdpedi.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PEDI.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE PEDI.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE PEDI.
    BUFFER-COPY Facdpedi TO PEDI.
  END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-detalle V-table-Win 
PROCEDURE Genera-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NroItm AS INT INIT 1 NO-UNDO.
  
  RUN Borra-Detalle. 
  FOR EACH PEDI BY NroItm:
    CREATE Facdpedi.
    BUFFER-COPY PEDI TO Facdpedi.
    ASSIGN 
        Facdpedi.NroItm = x-NroItm
        Facdpedi.CodCia = Faccpedi.CodCia 
        Facdpedi.CodDiv = Faccpedi.CODDIV
        Facdpedi.CodDoc = Faccpedi.CodDoc 
        Facdpedi.NroPed = Faccpedi.NroPed.
    x-NroItm = x-NroItm + 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-cotizacion-cred.i}

/*   ASSIGN                 */
/*     Faccpedi.ImpBrt = 0  */
/*     Faccpedi.ImpExo = 0  */
/*     Faccpedi.ImpDto = 0  */
/*     Faccpedi.ImpIgv = 0  */
/*     Faccpedi.ImpTot = 0. */
/*   FOR EACH PEDI:                                                                                           */
/*     ASSIGN                                                                                                 */
/*           Faccpedi.ImpBrt = Faccpedi.ImpBrt + (IF PEDI.AftIgv = Yes THEN PEDI.PreUni * PEDI.CanPed ELSE 0) */
/*           Faccpedi.ImpExo = Faccpedi.ImpExo + (IF PEDI.AftIgv = No  THEN PEDI.PreUni * PEDI.CanPed ELSE 0) */
/*           Faccpedi.ImpDto = Faccpedi.ImpDto + PEDI.ImpDto                                                  */
/*           Faccpedi.ImpIgv = Faccpedi.ImpIgv + PEDI.ImpIgv                                                  */
/*           Faccpedi.ImpTot = Faccpedi.ImpTot + PEDI.ImpLin.                                                 */
/*     DELETE PEDI.                                                                                           */
/*   END.                                                                                                     */
/*   ASSIGN                                                                                                   */
/*       Faccpedi.ImpVta = Faccpedi.ImpBrt - Faccpedi.ImpIgv                                                  */
/*       Faccpedi.ImpBrt = Faccpedi.ImpTot - Faccpedi.ImpIgv + Faccpedi.ImpDto.                               */

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
  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'No está configurado el correlativo para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      s-PorIgv = Faccfggn.PorIgv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DISPLAY
    STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999') @ faccpedi.nroped
    TODAY @ Faccpedi.fchped
    WITH FRAME {&FRAME-NAME}.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_handle('Pagina2') .
  RUN Procesa-Handle IN lh_handle('Browse') .
  
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
  ASSIGN
    Faccpedi.nroref = TRIM(COMBO-BOX-CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 
                        TRIM(FILL-IN-NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    Faccpedi.glosa  = FILL-IN-Glosa:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    Faccpedi.PorIgv = s-PorIgv
    Faccpedi.TpoCmb = FacCfgGn.TpoCmb[1]
    Faccpedi.usuario = S-USER-ID.
  FIND FIRST Ccbcdocu WHERE Ccbcdocu.CodCia = s-codcia 
    AND Ccbcdocu.CodDoc = SUBSTRING(Faccpedi.NroRef,1,3)
    AND Ccbcdocu.NroDoc = SUBSTRING(Faccpedi.NroRef,4) NO-LOCK NO-ERROR.   
  IF NOT AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'Ya no existe el documento de referencia' VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
    Faccpedi.CodVen = Ccbcdocu.CodVen.
  RUN Genera-detalle.
  RUN Graba-Totales.
                          
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
  RUN Procesa-Handle IN lh_handle('Pagina1') .
  RUN Procesa-Handle IN lh_handle('Browse') .

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
  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'No se pudo bloquear el control de correlativos'
        VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Faccpedi.codcia = s-codcia
    Faccpedi.coddiv = s-coddiv
    Faccpedi.coddoc = s-coddoc
    Faccpedi.nroped = STRING(Faccorre.nroser, '999') +
                        STRING(Faccorre.correlativo, '999999')
    Faccpedi.flgest = 'E'.                        
  ASSIGN
    Faccorre.correlativo = Faccorre.correlativo + 1.
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
  RUN valida-update.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
  DO TRANSACTION:
    FOR EACH Facdpedi OF Faccpedi ON ERROR UNDO, RETURN 'ADM-ERROR':
        DELETE Facdpedi.
    END.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

  END.

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
        COMBO-BOX-CodRef:SENSITIVE = NO
        FILL-IN-Glosa:SENSITIVE = NO
        FILL-IN-NroRef:SENSITIVE = NO.
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
  IF AVAILABLE Faccpedi THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodRef:SCREEN-VALUE = SUBSTRING(Faccpedi.nroref,1,3)
        FILL-IN-NroRef:SCREEN-VALUE = SUBSTRING(Faccpedi.nroref,4) 
        FILL-IN-Glosa:SCREEN-VALUE = Faccpedi.glosa
        FILL-IN-Estado:SCREEN-VALUE = ''.
    CASE Faccpedi.flgest:
        WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'EMITIDO'.
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'APROBADO'.
        WHEN 'R' THEN FILL-IN-Estado:SCREEN-VALUE = 'RECHAZADO'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'CERRADO'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
    END.        
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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodRef:SENSITIVE = YES
        FILL-IN-Glosa:SENSITIVE = YES
        FILL-IN-NroRef:SENSITIVE = YES
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.FchPed:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.NroPed:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = "NO" THEN DISABLE Faccpedi.CodCli COMBO-BOX-CodRef FILL-IN-NroRef.
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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle('Pagina1') .
  RUN Procesa-Handle IN lh_handle('Browse') .

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
  {src/adm/template/snd-list.i "FacCPedi"}

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
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FacCPedi.CodCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = COMBO-BOX-CodRef:SCREEN-VALUE
        AND Ccbcdocu.nrodoc = FILL-IN-NroRef:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'Documento no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-NroRef.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.flgest = 'A' THEN DO:
        MESSAGE 'Documento anulado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-NroRef.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.codcli <> FacCPedi.CodCli:SCREEN-VALUE THEN DO:
        MESSAGE 'Documento no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-NroRef.
        RETURN 'ADM-ERROR'.
    END.
    /* CONTROL DE TOTALES */
/*     DEF VAR x-ImpLin AS DEC NO-UNDO.                               */
/*     x-ImpLin = 0.                                                  */
/*     FOR EACH PEDI:                                                 */
/*         x-ImpLin = x-ImpLin + PEDI.ImpLin.                         */
/*     END.                                                           */
/*     IF x-ImpLin > Ccbcdocu.ImpTot THEN DO:                         */
/*         MESSAGE 'El importe no pude ser mayor que' Ccbcdocu.ImpTot */
/*             VIEW-AS ALERT-BOX ERROR.                               */
/*         RETURN 'ADM-ERROR'.                                        */
/*     END.                                                           */

    DEF VAR x-NroItm AS INT INIT 0 NO-UNDO.

    FOR EACH PEDI BY NroItm:
      x-NroItm = x-NroItm + 1.
    END.
    IF x-NroItm > 1 THEN DO:
        MESSAGE 'Debe haber UN SOLO REGISTRO en el detalle' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".   
    END.

  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Detalle V-table-Win 
PROCEDURE Valida-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FILL-IN-NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
    OR FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
    THEN DO:
    MESSAGE 'Tiene que ingresar el cliente y el documento de referencia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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
  IF NOT Available Faccpedi THEN RETURN 'ADM-ERROR'.
  IF Faccpedi.flgest <> 'E' THEN RETURN 'ADM-ERROR'.

  ASSIGN
      s-PorIgv = Faccpedi.PorIgv.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle('Pagina2') .
  RUN Procesa-Handle IN lh_handle('Browse') .
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

