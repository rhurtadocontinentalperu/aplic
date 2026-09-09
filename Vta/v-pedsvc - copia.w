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
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR Lh_Handle AS HANDLE.
DEF SHARED VAR s-TpoCmb LIKE Faccpedi.tpocmb.
DEF SHARED VAR s-CodMon AS INT.

DEF VAR cl-codcia AS INT NO-UNDO.
DEF VAR s-cndvta-validos AS CHAR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.TpoCmb FacCPedi.CodCli ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.TipVta FacCPedi.NomCli ~
FacCPedi.DirCli FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.CodVen ~
FacCPedi.fchven FacCPedi.FmaPgo 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.TpoCmb FacCPedi.CodCli FacCPedi.RucCli FacCPedi.Atencion ~
FacCPedi.TipVta FacCPedi.NomCli FacCPedi.DirCli FacCPedi.CodMon ~
FacCPedi.LugEnt FacCPedi.CodVen FacCPedi.fchven FacCPedi.FmaPgo ~
FacCPedi.usuario 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomVen f-ConVta 

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
DEFINE VARIABLE f-ConVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 5.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.19 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-Estado AT ROW 1.19 COL 31 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 61 COLON-ALIGNED
          LABEL "Fecha Emisión" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     FacCPedi.TpoCmb AT ROW 1.19 COL 84 COLON-ALIGNED
          LABEL "T. Cambio"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.CodCli AT ROW 1.96 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.RucCli AT ROW 1.96 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 1.96 COL 51 COLON-ALIGNED
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.TipVta AT ROW 1.96 COL 86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "FACTURA", "1":U,
"BOLETA", "2":U
          SIZE 10 BY 1.54
     FacCPedi.NomCli AT ROW 2.73 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY .81
     FacCPedi.DirCli AT ROW 3.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY .81
     FacCPedi.CodMon AT ROW 3.5 COL 86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 7 BY 1.54
     FacCPedi.LugEnt AT ROW 4.27 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY .81
     FacCPedi.CodVen AT ROW 5.04 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-NomVen AT ROW 5.04 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.fchven AT ROW 5.04 COL 84 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     FacCPedi.FmaPgo AT ROW 5.81 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCPedi.usuario AT ROW 5.81 COL 84 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     f-ConVta AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.69 COL 80
     "Documento:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 1.96 COL 77
     RECT-21 AT ROW 1 COL 1
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
         HEIGHT             = 7.77
         WIDTH              = 101.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN f-ConVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
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
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:

  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
     MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  IF NOT (SELF:SCREEN-VALUE) BEGINS 'ND'  THEN
  IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
      MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = Faccpedi.CodCli:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  IF gn-clie.cndvta = '' THEN DO:
      MESSAGE 'El cliente NO tiene definida una condición de venta' 
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  /* BLOQUEO DEL CLIENTE */
  IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  IF LOOKUP(gn-clie.flgsit, 'B,C') > 0 THEN DO:
    MESSAGE 'Cliente Bloqueado o Cesado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  /*Hallando su condicion de Venta*/
  s-cndvta-validos = gn-clie.cndvta.
/*   FIND gn-convt WHERE gn-ConVt.Codig = '900' NO-LOCK NO-ERROR.           */
/*   IF AVAILABLE gn-convt THEN s-cndvta-validos = gn-clie.cndvta + ',900'. */

  DISPLAY gn-clie.NomCli @ Faccpedi.NomCli
    gn-clie.Ruc    @ Faccpedi.RucCli
    gn-clie.DirCli @ Faccpedi.DirCli
    gn-clie.CodVen @ FacCPedi.CodVen
    /*gn-clie.CndVta @ FacCPedi.FmaPgo */
    ENTRY(1, gn-clie.cndvta) @ Faccpedi.fmapgo
    WITH FRAME {&FRAME-NAME}.
  IF gn-clie.CodCli <> FacCfgGn.CliVar 
  THEN DO:
         FacCPedi.NomCli:SENSITIVE = NO.
         FacCPedi.RucCli:SENSITIVE = NO.
         FacCPedi.DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO FacCPedi.CodVen.
  END.   
  ELSE DO: 
        FacCPedi.NomCli:SENSITIVE = YES.
        FacCPedi.RucCli:SENSITIVE = YES.
        FacCPedi.DirCli:SENSITIVE = YES.
        APPLY "ENTRY" TO FacCPedi.NomCli.
  END. 
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN F-ConVta:SCREEN-VALUE = gn-convt.Nombr.
  ELSE F-ConVta:SCREEN-VALUE = "".
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
OR 'F8' OF FacCPedi.CodCli DO:

    RUN LKUP\C-CLIENT.R ("Maestro de Clientes").
    IF output-var-1 = ? THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = output-var-2.
    /*FacCPedi.NomCli:SCREEN-VALUE = output-var-3. */
    
    ASSIGN
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.codcia = s-codcia
    AND gn-ven.CodVen = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven 
  THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
  ELSE F-NomVen:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON F8 OF FacCPedi.FmaPgo IN FRAME F-Main /* Condicion de ventas */
OR left-mouse-dblclick OF Faccpedi.fmapgo
DO:
    input-var-1 = s-cndvta-validos.
    input-var-2 = ''.
    input-var-3 = ''.

    RUN vta/d-cndvta.
    IF output-var-1 = ? THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = output-var-2.
    f-convta:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Condicion de ventas */
DO:
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN F-ConVta:screen-value = gn-convt.Nombr.
  ELSE F-Convta:screen-value = "".
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
  FOR EACH FacDPedi OF FacCPedi EXCLUSIVE-LOCK 
        ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    DELETE Facdpedi.
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
  FOR EACH PEDI:
    DELETE PEDI.
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
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    CREATE PEDI.
    BUFFER-COPY FacDPedi TO PEDI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH PEDI:
    CREATE FacDPedi.
    BUFFER-COPY PEDI TO FacDPedi
        ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodCli = FacCPedi.CodCli
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.CodDoc = FacCPedi.CodDoc
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora
            FacDPedi.NroPed = FacCPedi.NroPed.
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
    FacCPedi.ImpBrt = 0
    FacCPedi.ImpDto = 0
    FacCPedi.ImpExo = 0
    FacCPedi.ImpFle = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpVta = 0.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    Faccpedi.impigv = Faccpedi.impigv + Facdpedi.impigv.
    Faccpedi.impisc = Faccpedi.impisc + Facdpedi.impisc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    IF NOT Facdpedi.AftIgv THEN Faccpedi.ImpExo = Faccpedi.ImpExo + Facdpedi.ImpLin.
    IF Facdpedi.AftIgv = YES
    THEN Faccpedi.ImpDto = Faccpedi.ImpDto + ROUND(Facdpedi.ImpDto / (1 + Faccpedi.PorIgv / 100), 2).
    ELSE Faccpedi.ImpDto = Faccpedi.ImpDto + Facdpedi.ImpDto.
  END.
  Faccpedi.impvta = Faccpedi.imptot - Faccpedi.impexo - Faccpedi.impigv.
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
  END.
  FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.

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
  FIND FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.nroser = s-nroser
    NO-LOCK NO-ERROR.
  IF Faccorre.flgest = NO THEN DO:
    MESSAGE 'Serie INACTIVA' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY
        STRING(s-nroser, '999') + STRING(Faccorre.correlativo, '999999') @ FacCPedi.NroPed
        FacCfgGn.CliVar @ Faccpedi.codcli
        TODAY @ Faccpedi.fchped
        TODAY @ FacCPedi.fchven
        FacCfgGn.Tpocmb[1] @ FacCPedi.TpoCmb
        s-user-id @ Faccpedi.usuario.
    ASSIGN
        s-TpoCmb = FacCfgGn.Tpocmb[1]
        s-CodMon = INTEGER(FacCPedi.CodMon:SCREEN-VALUE).
    RUN Borra-Temporal.
  END.
  RUN Procesa-Handle IN lh_handle ('Pagina2').

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    FIND FacCorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddiv = s-coddiv
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO se pudo bloquear el control de correlativos' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    ASSIGN
        Faccpedi.codcia = s-codcia
        Faccpedi.coddiv = s-coddiv
        Faccpedi.coddoc = s-coddoc
        Faccpedi.nroped = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999')
        Faccpedi.fchped = TODAY
        FacCPedi.Hora   = STRING(TIME, 'HH:MM')
        FacCPedi.PorIgv = FacCfgGn.PorIgv
        FacCPedi.FlgEst = 'X'.      /* Por aprobar */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
    RUN Borra-Detalle.
  END.
  ASSIGN
    Faccpedi.usuario = s-user-id.

  RUN Genera-Detalle.
  RUN Graba-Totales.
  
  RELEASE FacCorre.
  RELEASE FacDPedi.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

/*
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
*/

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR' ON ERROR UNDO, RETURN 'ADM-ERROR':
    RUN Borra-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedi THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FlgEst = 'A'.
    FIND CURRENT FacCPedi NO-LOCK NO-ERROR.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
    CASE FaccPedi.FlgEst:
      WHEN "A" THEN DISPLAY "ANULADO"   @ F-Estado WITH FRAME {&FRAME-NAME}.
      WHEN "C" THEN DISPLAY "ATENDIDO"  @ F-Estado WITH FRAME {&FRAME-NAME}.
      WHEN "P" THEN DISPLAY "APROBADO"  @ F-Estado WITH FRAME {&FRAME-NAME}.
      WHEN "F" THEN DISPLAY "FACTURADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
      WHEN "X" THEN DISPLAY "NO APROBADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
      WHEN "R" THEN DISPLAY "RECHAZADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
    END CASE.         
    F-NomVen:SCREEN-VALUE = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = FacCPedi.CodVen 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
    F-ConVta:SCREEN-VALUE = "".
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-ConVta:SCREEN-VALUE = gn-convt.Nombr.
    IF FaccPedi.FchVen < TODAY AND FacCPedi.FlgEst = 'P'
    THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
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
    FacCPedi.FchPed:SENSITIVE = NO.
    FacCPedi.TpoCmb:SENSITIVE = NO.
    /*FacCPedi.TipVta:SENSITIVE = NO.*/
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
  IF FacCPedi.FlgEst <> "A" THEN RUN vta/r-PedSvc (ROWID(FacCPedi)).

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
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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

  DEF VAR F-Tot AS DEC.
  DEF VAR F-Bol AS DEC.
  DEF VAR x-Ok  AS LOG.
  DEF VAR T-SALDO AS DECIMAL.
  DEF VAR t-Resultado AS CHAR NO-UNDO.
  DEF VAR f-Saldo AS DEC NO-UNDO.
  DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
  DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
       F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
    END.
    RUN vtagn/p-gn-clie-01 (Faccpedi.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF Faccpedi.TipVta:SCREEN-VALUE = "1" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (FacCPedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO FacCPedi.CodCli.
            RETURN 'ADM-ERROR'.
        END.
    END.

    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = Faccpedi.codven:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Codigo de vendedor NO existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
    END.
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-convt THEN DO:
      MESSAGE "Condición de venta NO registrada" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
    END.

    /****   COMENTAR SI EN CASO NO SE QUIERE VALIDAR LA CTA.CTE.    ****/
    f-Saldo = f-Tot.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN F-Saldo = F-Tot - FacCpedi.Imptot.
    RUN vta2/linea-de-credito-01 ( Faccpedi.CodCli:SCREEN-VALUE,
                              f-Saldo,
                              INTEGER(FacCPedi.CodMon:SCREEN-VALUE),
                              FacCPedi.FmaPgo:SCREEN-VALUE,
                              TRUE,
                              OUTPUT t-Resultado).
    IF t-Resultado = 'ADM-ERROR' THEN DO:
        MESSAGE 'Se ha encontrado un error en la linea de crédito'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".   
    END.
/*     IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1                       */
/*     THEN IF gn-clie.MonLC = 2 THEN F-Tot = F-Tot / FacCfgGn.TpoCmb[1]. */
/*     ELSE IF gn-clie.MonLC = 1 THEN F-Tot = F-Tot * FacCfgGn.TpoCmb[1]. */
/*     IF LOOKUP(TRIM(Faccpedi.Fmapgo:SCREEN-VALUE),"000,001,002,900") = 0 THEN DO:                     */
/*         RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                                         */
/*         IF RETURN-VALUE = 'YES'                                                                      */
/*         THEN RUN vta/lincre (FacCPedi.CodCli:SCREEN-VALUE, F-Tot, OUTPUT T-SALDO).                   */
/*         ELSE RUN vta/lincre (FacCPedi.CodCli:SCREEN-VALUE, F-Tot - FacCpedi.Imptot, OUTPUT T-SALDO). */
/*                                                                                                      */
/*         dImpLCred = 0.                                                                               */
/*         lEnCampan = FALSE.                                                                           */
/*         /* Línea Crédito Campaña */                                                                  */
/*         FOR EACH Gn-ClieL WHERE                                                                      */
/*             Gn-ClieL.CodCia = gn-clie.codcia AND                                                     */
/*             Gn-ClieL.CodCli = gn-clie.codcli AND                                                     */
/*             Gn-ClieL.FchIni >= TODAY AND                                                             */
/*             Gn-ClieL.FchFin <= TODAY NO-LOCK:                                                        */
/*             dImpLCred = dImpLCred + Gn-ClieL.ImpLC.                                                  */
/*             lEnCampan = TRUE.                                                                        */
/*         END.                                                                                         */
/*         /* Línea Crédito Normal */                                                                   */
/*         IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.                                             */
/*                                                                                                      */
/*         IF RETURN-VALUE <> "OK" THEN DO:                                                             */
/*             MESSAGE                                                                                  */
/*                 "LINEA CREDITO  : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )                  */
/*                 STRING(dImpLCred,"ZZ,ZZZ,ZZ9.99") SKIP                                               */
/*                 "USADO                 : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )           */
/*                 STRING(T-SALDO + f-Tot,"ZZ,ZZZ,ZZ9.99") SKIP                                         */
/*                 "CREDITO DISPONIBLE    : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )           */
/*                 STRING(dImpLCred - T-SALDO - f-Tot,"-Z,ZZZ,ZZ9.99")                                  */
/*                 VIEW-AS ALERT-BOX ERROR.                                                             */
/*             RETURN "ADM-ERROR".                                                                      */
/*         END.                                                                                         */
/*     END.                                                                                             */

    /* Verificamos los montos de acuerdo al documento */
    F-Tot = 0.
    FOR EACH PEDI NO-LOCK:
        F-Tot = F-Tot + PEDI.ImpLin.
    END.
    F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
            THEN F-TOT
            ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
    IF FacCPedi.TipVTa:SCREEN-VALUE = '2' AND F-BOL >= 1725 
        AND (FacCPedi.Atencion:SCREEN-VALUE = '' 
            OR LENGTH(FacCPedi.Atencion:SCREEN-VALUE, "CHARACTER") < 8)
    THEN DO:
        MESSAGE "Venta Mayor a 1725.00" SKIP
                "Debe ingresar en DNI"
            VIEW-AS ALERT-BOX ERROR.
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

  IF NOT AVAILABLE FacCPedi THEN RETURN 'ADM-ERROR'.
  IF LOOKUP(Faccpedi.flgest, 'P,X') = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  IF Faccpedi.impdto > 0 THEN DO:
    MESSAGE 'Pedido con descuento aplicado' SKIP
        'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  ASSIGN
    s-TpoCmb = Faccpedi.tpocmb
    s-CodMon = Faccpedi.codmon.
  
  RUN Carga-Temporal.

  RUN Procesa-Handle IN lh_handle ('Pagina2').
  
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

