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

/* Public Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-DTOMAX       AS DECIMAL   NO-UNDO.

DEFINE BUFFER B-CPedi FOR FacCPedi.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.FmaPgo FacCPedi.PorDto ~
FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-20 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.CodCli ~
FacCPedi.FchPed FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.FmaPgo ~
FacCPedi.CodMon FacCPedi.PorDto FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN_NomCli F-nOMvEN F-CndVta 

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
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .69.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 3.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.15 COL 8.72 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
          FONT 0
     F-Estado AT ROW 1.19 COL 71.29 COLON-ALIGNED NO-LABEL
     FacCPedi.CodCli AT ROW 1.88 COL 8.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     FILL-IN_NomCli AT ROW 1.88 COL 18 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.88 COL 73 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodVen AT ROW 2.58 COL 8.72 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     F-nOMvEN AT ROW 2.58 COL 18 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 2.58 COL 73 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.FmaPgo AT ROW 3.27 COL 8.72 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     F-CndVta AT ROW 3.27 COL 18 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 3.27 COL 75 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .62
     FacCPedi.PorDto AT ROW 3.92 COL 73.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .69
     FacCPedi.Glosa AT ROW 3.96 COL 6
          VIEW-AS FILL-IN 
          SIZE 51.86 BY .69
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.14 BY .58 AT ROW 3.31 COL 67.86
     RECT-20 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCPedi
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
         HEIGHT             = 3.88
         WIDTH              = 87.86.
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
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   IF FacCPedi.FmaPgo:SCREEN-VALUE <> "" THEN DO:
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.PorDto V-table-Win
ON LEAVE OF FacCPedi.PorDto IN FRAME F-Main /* % Dscto. */
DO:
  /* IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > F-DTOMAX THEN DO:
      MESSAGE "El descuento no puede ser mayor a " F-DTOMAX  VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Descuento V-table-Win 
PROCEDURE Actualiza-Descuento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH PEDI NO-LOCK: 
       ASSIGN PEDI.PorDto = IF faccpedi.PorDto > 0 THEN facCpedi.PorDto ELSE PEDI.PorDto  
              PEDI.ImpDto = ROUND( PEDI.PreUni * (PEDI.PorDto / 100) * PEDI.CanPed , 2 ).
              PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
        IF PEDI.AftIsc THEN 
           PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
        IF PEDI.AftIgv THEN  
           PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
   END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE F-NRO AS DECIMAL NO-UNDO.
 FOR EACH PEDI:
     DELETE PEDI.
 END.
 FOR EACH facdPedi OF faccPedi NO-LOCK:
     CREATE PEDI.
     ASSIGN PEDI.CodCia = facdPedi.CodCia 
            PEDI.codmat = facdPedi.codmat 
            PEDI.Factor = facdPedi.Factor 
            PEDI.CanPed = facdPedi.CanPed 
            PEDI.CanAte = FacDPedi.CanAte
            PEDI.ImpDto = facdPedi.ImpDto 
            PEDI.ImpLin = facdPedi.ImpLin 
            PEDI.NroItm = facdPedi.NroItm 
            PEDI.PorDto = facdPedi.PorDto 
            PEDI.PreUni = facdPedi.PreUni 
            PEDI.UndVta = facdPedi.UndVta
            PEDI.AftIgv = FacdPedi.AftIgv 
            PEDI.AftIsc = FacdPedi.AftIsc 
            PEDI.ImpDto = FacdPedi.ImpDto 
            PEDI.ImpIgv = FacdPedi.ImpIgv 
            PEDI.ImpIsc = FacdPedi.ImpIsc 
            PEDI.PreBas = FacdPedi.PreBas.
     F-NRO = F-NRO + PEDI.CanPed * PEDI.PreUni.
     FIND Almmmatg OF Facdpedi NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmatg THEN DO:
        F-DTOMAX = F-DTOMAX + PEDI.CanPed * Almmmatg.PorMax * PEDI.PreUni.
     END.
 END.
 F-DTOMAX = ROUND(F-DTOMAX / F-NRO,2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DELETE FROM FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia AND
        FacDPedi.coddoc = FacCPedi.coddoc AND
        FacDPedi.nroped = FacCPedi.nroped.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Borra-Pedido. 
   FOR EACH PEDI NO-LOCK: 
       CREATE FacDPedi. 
       ASSIGN FacDPedi.CodCia = FacCPedi.CodCia 
              FacDPedi.coddoc = FacCPedi.coddoc 
              FacDPedi.NroPed = FacCPedi.NroPed 
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.codmat = PEDI.codmat 
              FacDPedi.Factor = PEDI.Factor 
              FacDPedi.CanPed = PEDI.CanPed 
              FacDPedi.CanAte = PEDI.CanAte
              FacDPedi.ImpDto = PEDI.ImpDto 
              FacDPedi.ImpLin = PEDI.ImpLin 
              FacDPedi.NroItm = PEDI.NroItm 
              FacDPedi.PorDto = PEDI.PorDto 
              FacDPedi.PreUni = PEDI.PreUni 
              FacDPedi.UndVta = PEDI.UndVta 
              FacDPedi.AftIgv = PEDI.AftIgv 
              FacDPedi.AftIsc = PEDI.AftIsc 
              FacDPedi.ImpIgv = PEDI.ImpIgv 
              FacDPedi.ImpIsc = PEDI.ImpIsc 
              FacDPedi.PreBas = PEDI.PreBas. 
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
DO TRANSACTION:
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) NO-ERROR.
   B-CPEDI.UsrDscto = S-USER-ID.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   FOR EACH PEDI NO-LOCK: 
       B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
       F-Igv = F-Igv + PEDI.ImpIgv.
       F-Isc = F-Isc + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
   END.
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto.
   IF B-CPEDI.PorDto > 0 THEN DO:
/*      B-CPEDI.ImpDto = B-CPEDI.ImpBrt * B-CPEDI.PorDto / 100.*/
      B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto.
      B-CPEDI.ImpIgv = B-CPEDI.ImpVta * B-CPEDI.PorIgv / 100.
      B-CPEDI.ImpTot = B-CPEDI.ImpVta + B-CPEDI.ImpIgv + B-CPEDI.ImpIsc + B-CPEDI.ImpExo.
   END.
   RELEASE B-CPEDI.
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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
     CASE FacCPedi.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = FacCPedi.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli.
     END.  
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
  
  IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-ImpPed.r(ROWID(FacCPedi)).

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
  
  RUN Actualiza-Descuento.
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
        END CASE.
    END.

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

  IF p-state = 'update-begin':U THEN DO:
     RUN Actualiza-Item.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.
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
DEFINE VARIABLE F-DSCTO AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
   FOR EACH PEDI:
       F-DSCTO = F-DSCTO + PEDI.ImpDto.
   END.
   IF F-DSCTO > 0 AND DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
      MESSAGE "El pedido ya tiene descuentos por item"  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO Faccpedi.PorDto.
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
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".
DEFINE VAR RPTA AS CHAR NO-UNDO.
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

