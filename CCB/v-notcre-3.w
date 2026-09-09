&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-ADocu NO-UNDO LIKE CcbDMvto.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.
DEFINE SHARED VARIABLE S-NRODOC   AS CHAR.

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.NomCli CcbCDocu.RucCli ~
CcbCDocu.DirCli CcbCDocu.CodMon CcbCDocu.Glosa CcbCDocu.Libre_c05 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.NomCli CcbCDocu.RucCli ~
CcbCDocu.DirCli CcbCDocu.CodMon CcbCDocu.Glosa CcbCDocu.usuario ~
CcbCDocu.Libre_c05 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado x-NomCon 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Estado AT ROW 1 COL 36 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 1.81 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CcbCDocu.TpoCmb AT ROW 1.81 COL 69 COLON-ALIGNED
          LABEL "Tpo. Cambio"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.NomCli AT ROW 2.62 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     CcbCDocu.RucCli AT ROW 2.62 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.DirCli AT ROW 3.42 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCDocu.CodMon AT ROW 3.42 COL 71 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 15 BY .77
          BGCOLOR 11 FGCOLOR 9 
     CcbCDocu.Glosa AT ROW 4.23 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CcbCDocu.usuario AT ROW 4.23 COL 69 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.Libre_c05 AT ROW 5.04 COL 11 COLON-ALIGNED WIDGET-ID 4
          LABEL "Concepto" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     x-NomCon AT ROW 5.04 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.42 COL 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-ADocu T "SHARED" NO-UNDO INTEGRAL CcbDMvto
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
         HEIGHT             = 8.04
         WIDTH              = 93.86.
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

/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                  AND  gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE
                 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie  THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.

    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.CodCli.
       RETURN NO-APPLY.
    END.
    s-codcli = SELF:SCREEN-VALUE.
    DISPLAY gn-clie.NomCli @ CcbCDocu.NomCli
            gn-clie.Ruc    @ CcbCDocu.RucCli
            gn-clie.DirCli @ CcbCDocu.DirCli WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodMon IN FRAME F-Main /* Moneda */
DO:
  s-codmon = INPUT {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.Libre_c05
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.Libre_c05 V-table-Win
ON LEAVE OF CcbCDocu.Libre_c05 IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc AND 
        CcbTabla.Codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbTabla 
    THEN x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
    ELSE x-NomCon:SCREEN-VALUE = ''.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-en-bloque V-table-Win 
PROCEDURE Asignar-en-bloque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN CCB/D-NOTCRE-3.
RUN Bloquea-campos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bloquea-campos V-table-Win 
PROCEDURE Bloquea-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        CcbCDocu.CodCli:SENSITIVE = NO
        CcbCDocu.CodMon:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Ccbdmvto OF Ccbcdocu:
    DELETE Ccbdmvto.
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

FOR EACH T-ADOCU:
    DELETE T-ADOCU.
END.

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
  FOR EACH T-ADOCU:
    DELETE T-ADOCU.
  END.
  FOR EACH Ccbdmvto OF Ccbcdocu NO-LOCK:
    CREATE T-ADOCU.
    BUFFER-COPY Ccbdmvto TO T-ADOCU.
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
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  

  FOR EACH T-ADOCU BY T-ADOCU.NroMes:
    CREATE Ccbdmvto.
    BUFFER-COPY T-ADOCU TO Ccbdmvto
        ASSIGN 
            Ccbdmvto.NroMes = x-Item
            Ccbdmvto.CodCia = CcbCDocu.CodCia 
            Ccbdmvto.CodDiv = CcbCDocu.coddiv
            Ccbdmvto.CodDoc = CcbCDocu.CodDoc 
            Ccbdmvto.NroDoc = CcbCDocu.NroDoc.
    x-Item = x-Item + 1.
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
  ASSIGN
    Ccbcdocu.ImpBrt = 0
    Ccbcdocu.ImpExo = 0
    Ccbcdocu.ImpDto = 0
    Ccbcdocu.ImpIgv = 0
    Ccbcdocu.ImpTot = 0.     
 
  IF CcbTabla.Afecto THEN
    ASSIGN
        Ccbcdocu.PorIgv = Faccfggn.porigv.
  ELSE
    ASSIGN
        Ccbcdocu.PorIgv = 0.

  FOR EACH Ccbdmvto OF Ccbcdocu NO-LOCK:
      Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbdmvto.imptot.
  END.
  IF Ccbcdocu.porigv = 0 THEN DO:
      ASSIGN
          Ccbcdocu.ImpExo = Ccbcdocu.ImpTot.
  END.
  ELSE DO:
      ASSIGN
          Ccbcdocu.ImpVta = ROUND(Ccbcdocu.ImpTot / (1 + Ccbcdocu.PorIgv / 100), 2)
          Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpVta.
  END.
  ASSIGN 
    Ccbcdocu.ImpBrt = Ccbcdocu.ImpTot - Ccbcdocu.ImpIgv - Ccbcdocu.ImpExo
    Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.

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
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
      AND Faccorre.coddiv = s-coddiv
      AND Faccorre.coddoc = s-coddoc
      AND FacCorre.nroser = s-nroser
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Correlativo INACTIVO' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        CcbCDocu.NroDoc:SCREEN-VALUE = STRING(Faccorre.nroser, '999') +
                                        STRING(Faccorre.correlativo, '999999').
    DISPLAY 
        TODAY @ CcbCDocu.FchDoc 
        FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb.
  END.
  s-codcli = ''.
  s-codmon = 1.
  s-nrodoc = ''.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  APPLY 'ENTRY':U TO Ccbcdocu.codcli.

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
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
          AND Faccorre.coddoc = s-coddoc
          AND Faccorre.coddiv = s-coddiv
          AND FacCorre.nroser = s-nroser
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccorre THEN DO:
          MESSAGE 'No se pudo bloquear el control de correlativos'
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      ASSIGN
        Ccbcdocu.codcia = s-codcia
        Ccbcdocu.coddoc = s-coddoc
        Ccbcdocu.coddiv = s-coddiv
        Ccbcdocu.nrodoc = STRING(Faccorre.nroser, '999') +
                            STRING(Faccorre.correlativo, '999999')
        CcbCDocu.FchVto = CcbCDocu.FchDoc /*TODAY*/
        CcbCDocu.FlgEst = "P"
        CcbCDOcu.TpoFac = "E"       /* rEbade */
        CcbCDocu.PorIgv = FacCfgGn.PorIgv
        CcbCDocu.CndCre = 'N'.
      ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
  END.
  ELSE DO:
      RUN Borra-Documento.
  END.
  ASSIGN
    CcbCDocu.usuario = S-USER-ID.

  RUN Genera-Detalle.   
  RUN Graba-Totales.
  RELEASE Faccorre.                        
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 


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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

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
  IF CcbCDocu.FlgEst = "A" THEN DO:
    MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
    MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.CndCre <> 'N' THEN DO:
    MESSAGE 'El documento corresponde a devolucion de mercaderia' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}

/*    /* Dispatch standard ADM method.                             */
 *     RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
 *     /* Code placed here will execute AFTER standard behavior.    */*/

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Motivo de anulacion */
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* ******************* */
    FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
    RUN Borra-Documento.
    ASSIGN
        Ccbcdocu.flgest = 'A'.
    FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
  END.
  /*RUN Procesa-Handle IN lh_Handle ('Browse').*/
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  RUN Procesa-Handle IN lh_handle ('browse').
  
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
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
    CASE Ccbcdocu.flgest:
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'PENDIENTE'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'CANCELADO'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
        OTHERWISE  FILL-IN-Estado:SCREEN-VALUE = '???'.
    END.
    FIND CcbTabla WHERE CcbTabla.CodCia = ccbcdocu.codcia AND 
        CcbTabla.Tabla  = ccbcdocu.coddoc AND 
        CcbTabla.Codigo = ccbcdocu.Libre_c05
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbTabla 
    THEN x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
    ELSE x-NomCon:SCREEN-VALUE = ''.
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
        CcbCDocu.DirCli:SENSITIVE = NO
        CcbCDocu.FchDoc:SENSITIVE = NO
        CcbCDocu.NomCli:SENSITIVE = NO
        CcbCDocu.NroDoc:SENSITIVE = NO
        CcbCDocu.RucCli:SENSITIVE = NO
        CcbCDocu.TpoCmb:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' 
        THEN ASSIGN
                CcbCDocu.CodCli:SENSITIVE = NO
                CcbCDocu.CodMon:SENSITIVE = NO.
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
  IF CCBCDOCU.FLGEST <> "A" THEN  RUN CCB/R-IMPNOT3-2 (ROWID(CCBCDOCU)).

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
        WHEN "Libre_c05" THEN 
            ASSIGN
                input-var-1 = "N/C"
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
      IF Ccbcdocu.codcli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.codcli.
         RETURN "ADM-ERROR".   
      END.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
          AND  gn-clie.CodCli = Ccbcdocu.codcli:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.codcli.
         RETURN "ADM-ERROR".   
      END.
      IF gn-clie.FlgSit = "I" THEN DO:
         MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.codcli.
         RETURN "ADM-ERROR".   
      END.
      IF gn-clie.FlgSit = "C" THEN DO:
         MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.codcli.
         RETURN "ADM-ERROR".   
      END.
      FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
          CcbTabla.Tabla  = s-coddoc AND 
          CcbTabla.Codigo = Ccbcdocu.Libre_C05:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbtabla THEN DO:
          MESSAGE 'Concepto NO registrado' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO Ccbcdocu.Libre_C05.
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
  IF CcbCDocu.FlgEst = "A" THEN DO:
    MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
    MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.CndCre <> 'N' THEN DO:
    MESSAGE 'El documento corresponde a devolucion de mercaderia' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""UPD""}

  s-codcli = Ccbcdocu.codcli.
  s-codmon = Ccbcdocu.codmon.
  s-nrodoc = Ccbcdocu.nrodoc.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

