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

/* Public Variable Definitions ---                                       */
DEFINE BUFFER B-CPEDM FOR Faccpedm.
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedm.

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE s-nivel    AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.  

/* Local Variable Definitions ---                          */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE C-CODVEN       AS CHARACTER NO-UNDO.
DEFINE VARIABLE F-DTOMAX       AS DECIMAL   NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.


DEFINE VAR NIV  AS CHAR.

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
&Scoped-define EXTERNAL-TABLES faccpedm
&Scoped-define FIRST-EXTERNAL-TABLE faccpedm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR faccpedm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Faccpedm.Glosa Faccpedm.PorDto 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS RECT-18 B-calc 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.NroPed Faccpedm.FchPed ~
Faccpedm.CodCli Faccpedm.NomCli Faccpedm.CodMon Faccpedm.CodVen ~
Faccpedm.TpoCmb Faccpedm.Glosa Faccpedm.Importe[3] Faccpedm.Importe[1] ~
Faccpedm.Importe[2] Faccpedm.PorDto 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS F-nomVen F-Admin 

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
DEFINE BUTTON B-calc 
     LABEL "Calcular" 
     SIZE 7.29 BY .69.

DEFINE VARIABLE F-Admin AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Administrador" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 4.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Faccpedm.NroPed AT ROW 1.23 COL 7.43 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 1
     Faccpedm.FchPed AT ROW 1.46 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.CodCli AT ROW 1.96 COL 7.43 COLON-ALIGNED
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .69
     Faccpedm.NomCli AT ROW 1.96 COL 17 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39 BY .69
     Faccpedm.CodMon AT ROW 2.23 COL 77.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .5
     Faccpedm.CodVen AT ROW 2.73 COL 7.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     F-nomVen AT ROW 2.73 COL 15.14 COLON-ALIGNED NO-LABEL
     Faccpedm.TpoCmb AT ROW 2.77 COL 75 COLON-ALIGNED
          LABEL "Tpo.Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.Glosa AT ROW 3.5 COL 4.71
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 48.43 BY .69
     Faccpedm.Importe[3] AT ROW 3.54 COL 75.14 COLON-ALIGNED
          LABEL "Importe S/Dscto" FORMAT "->,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.Importe[1] AT ROW 4.23 COL 7.72 COLON-ALIGNED
          LABEL "PromoConti" FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.Importe[2] AT ROW 4.27 COL 25.43 COLON-ALIGNED
          LABEL "Tarjeta" FORMAT "->>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-Admin AT ROW 4.27 COL 46.86 COLON-ALIGNED
     Faccpedm.PorDto AT ROW 4.35 COL 70.14 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 FGCOLOR 12 
     B-calc AT ROW 4.38 COL 82.86
     "Moneda" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.19 COL 70.43
     RECT-18 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.faccpedm
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
         HEIGHT             = 4.31
         WIDTH              = 93.14.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Faccpedm.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET Faccpedm.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Admin IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Faccpedm.Importe[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.Importe[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.Importe[3] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.PorDto IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Faccpedm.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME B-calc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-calc V-table-Win
ON CHOOSE OF B-calc IN FRAME F-Main /* Calcular */
DO:
  DEFINE VAR X-TOTAL AS DECI INIT 0.
  FOR EACH ITEM NO-LOCK:
      X-TOTAL = X-TOTAL + ITEM.ImpLin.
  END. 
  DO WITH FRAME {&FRAME-NAME}:
     F-ADMIN  =  ((DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) / 100) * X-TOTAL ) - (Faccpedm.importe[1] + Faccpedm.importe[2] ) .
     DISPLAY F-ADMIN @ F-ADMIN.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodMon V-table-Win
ON VALUE-CHANGED OF Faccpedm.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.PorDto V-table-Win
ON LEAVE OF Faccpedm.PorDto IN FRAME F-Main /* % Dscto. */
DO:

  IF DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) > 0 THEN DO:
     IF DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) > F-DTOMAX THEN DO:
        MESSAGE "El descuento no puede ser mayor a " F-DTOMAX  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle V-table-Win 
PROCEDURE Actualiza-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-NRO AS DECIMAL NO-UNDO.

FOR EACH ITEM:
    DELETE ITEM.
END.

FOR EACH facdpedm OF faccpedm NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY FacDPedm TO ITEM.
/*    F-DTOMAX = 0.
 *     F-NRO = F-NRO + ITEM.CanPed * ITEM.PreUni.
 *     FIND Almmmatg OF Facdpedm NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almmmatg THEN DO:
 *        F-DTOMAX = F-DTOMAX + Almmmatg.PorMax * ITEM.CanPed * ITEM.PreUni.
 *     END.*/
END.
/*
F-DTOMAX = ROUND(F-DTOMAX / F-NRO,2).
*/
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
FIND FIRST FacUsers WHERE 
           FacUsers.CodCia = S-CODCIA AND  
           FacUsers.Usuario = S-USER-ID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacUsers THEN F-DTOMAX = 0.
CASE NIV:
   WHEN "D1" THEN F-DTOMAX = FacCfgGn.DtoMax.
   WHEN "D2" THEN F-DTOMAX = FacCfgGn.DtoDis.
   WHEN "D3" THEN F-DTOMAX = FacCfgGn.DtoMay.
   WHEN "D4" THEN F-DTOMAX = FacCfgGn.DtoPro.
   OTHERWISE F-DTOMAX = 0.
END CASE.

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
/*  FOR EACH ITEM NO-LOCK: 
 *       ASSIGN ITEM.PorDto = IF faccpedm.PorDto > 0 THEN facCpedm.PorDto ELSE ITEM.PorDto  
 *              ITEM.ImpDto = ROUND( ITEM.PreUni * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
 *              ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ) - ITEM.ImpDto.
 *        IF ITEM.AftIsc THEN 
 *           ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
 *        IF ITEM.AftIgv THEN  
 *           ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 *   END. */
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
  {src/adm/template/row-list.i "faccpedm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "faccpedm"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH facdpedm WHERE facdpedm.codcia = faccpedm.codcia AND
        facdpedm.coddoc = faccpedm.coddoc AND
        facdpedm.nroped = faccpedm.nroped:
        DELETE facdpedm.
    END.        
      
   FOR EACH ITEM NO-LOCK:
       CREATE facdpedm.
       BUFFER-COPY ITEM TO facdpedm.
       ASSIGN facdpedm.CodCia = faccpedm.CodCia
              facdpedm.coddoc = faccpedm.coddoc
              facdpedm.NroPed = faccpedm.NroPed
              Facdpedm.FlgEst = Faccpedm.FlgEst
              Facdpedm.Hora   = Faccpedm.Hora
              FacDPedm.FchPed = FacCPedm.FchPed.
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
   
   FIND B-CPEDM WHERE ROWID(B-CPEDM) = ROWID(Faccpedm) NO-ERROR.
   B-CPEDM.UsrDscto = S-USER-ID.
   B-CPEDM.ImpDto = 0.
   B-CPEDM.ImpIgv = 0.
   B-CPEDM.ImpIsc = 0.
   B-CPEDM.ImpTot = 0.
   B-CPEDM.ImpExo = 0.
   B-CPEDM.ImpBrt = 0.
   FOR EACH ITEM NO-LOCK:
       B-CPEDM.ImpDto = B-CPEDM.ImpDto + ITEM.ImpDto.
               F-IGV  = F-IGV + ITEM.ImpIgv.
               F-ISC  = F-ISC + ITEM.ImpIsc.
       B-CPEDM.ImpTot = B-CPEDM.ImpTot + ITEM.ImpLin.
       IF NOT ITEM.AftIgv THEN B-CPEDM.ImpExo = B-CPEDM.ImpExo + ITEM.ImpLin.
   END.
   B-CPEDM.ImpIgv = ROUND(F-IGV,2).
   B-CPEDM.ImpIsc = ROUND(F-ISC,2).
   B-CPEDM.ImpBrt = B-CPEDM.ImpTot - B-CPEDM.ImpIgv - B-CPEDM.ImpIsc + 
                    B-CPEDM.ImpDto - B-CPEDM.ImpExo.
   B-CPEDM.ImpVta = B-CPEDM.ImpBrt - B-CPEDM.ImpDto.
   
   /*** DESCUENTO GLOBAL ****/
   IF B-cpedm.PorDto > 0 THEN DO:
      /**** Add by C.Q. 29/03/2000  ****/
      /*********************************/
      B-CPEDM.ImpDto = B-CPEDM.ImpDto + ROUND(B-CPEDM.ImpTot * B-cpedm.PorDto / 100,2).
      B-CPEDM.ImpTot = ROUND(B-CPEDM.ImpTot * (1 - B-cpedm.PorDto / 100),2).
      B-CPEDM.ImpVta = ROUND(B-CPEDM.ImpTot / (1 + B-CPEDM.PorIgv / 100),2).
      B-CPEDM.ImpIgv = B-CPEDM.ImpTot - B-CPEDM.ImpVta.
      B-CPEDM.ImpBrt = B-CPEDM.ImpTot - B-CPEDM.ImpIgv - B-CPEDM.ImpIsc + 
                       B-CPEDM.ImpDto - B-CPEDM.ImpExo.
   END.

   RELEASE B-CPEDM.

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
  IF AVAILABLE Faccpedm THEN DO WITH FRAME {&FRAME-NAME}:
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedm.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     S-CODMON = Faccpedm.CodMon.
     S-TPOCMB = Faccpedm.TpoCmb.
     B-CALC:VISIBLE = FALSE.
     F-ADMIN  = Faccpedm.ImpDto - (Faccpedm.importe[1] + Faccpedm.importe[2] ) .
     DISPLAY F-ADMIN @ F-ADMIN.
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
  
  IF Faccpedm.FlgEst <> "A" THEN RUN vtamay/r-impvm.r(ROWID(Faccpedm)).

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

  RUN Actualiza-Item.
  RUN Genera-Detalle.
  RUN Graba-Totales.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('browse').
  DO WITH FRAME {&FRAME-NAME} :
     B-CALC:VISIBLE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen V-table-Win 
PROCEDURE Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR RPTA AS CHAR.
DEFINE VAR NIV  AS CHAR.

IF FacCPedm.FlgEst <> "A" THEN DO:
/*   NIV = "".
 *    RUN VTA/D-CLAVE.R("D",
 *                     " ",
 *                     OUTPUT NIV,
 *                     OUTPUT RPTA).
 *    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/
   
   RUN vtamay/d-mrgpem (ROWID(FacCPedm)).

/* RHC 16.10.04 NUEVO PROGRAMA */
/*   DEFINE VAR X-COSTO  AS DECI INIT 0.
 *    DEFINE VAR T-COSTO  AS DECI INIT 0.
 *    DEFINE VAR X-MARGEN AS DECI INIT 0.
 *    FOR EACH FacDPedi OF FacCPedi NO-LOCK :
 *        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
 *                            Almmmatg.Codmat = FacDPedi.Codmat NO-LOCK NO-ERROR.
 *        X-COSTO = 0.
 *        IF AVAILABLE Almmmatg THEN DO:
 *           IF FacCPedi.CodMon = 1 THEN DO:
 *              IF Almmmatg.MonVta = 1 THEN 
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) * FacCPedi.Tpocmb .
 *           END.        
 *           IF FacCPedi.CodMon = 2 THEN DO:
 *              IF Almmmatg.MonVta = 2 THEN
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) / FacCPedi.Tpocmb .
 *           END.      
 *           T-COSTO = T-COSTO + X-COSTO * FacDPedi.CanPed.          
 *        END.
 *    END.
 *    X-MARGEN = ROUND(((( FacCPedi.ImpTot / T-COSTO ) - 1 ) * 100 ),2).
 *    IF X-MARGEN < 20 THEN DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX WARNING .
 *    END.
 *    ELSE DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX INFORMATION.
 *    END.*/
            
END.
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
  {src/adm/template/snd-list.i "faccpedm"}

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
     RUN Actualiza-Detalle.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
     DO WITH FRAME {&FRAME-NAME} :
        B-CALC:VISIBLE = YES.
     END.
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
   
   /******************************************/
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   DEFINE VARIABLE POR_DSCREM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE DSCT_REM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE P-VAL1 AS DECIMAL.
   DEFINE VARIABLE P-VAL2 AS DECIMAL.
   DEFINE VARIABLE M1 AS DECIMAL.
   DEFINE VARIABLE M2 AS DECIMAL.
   
   DEFINE VARIABLE X-ImpDto AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIgv AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIsc AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpTot AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpExo AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpBrt AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpVta AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-Bruto  AS DECIMAL NO-UNDO.

   X-ImpDto = 0.
   X-ImpIgv = 0.
   X-ImpIsc = 0.
   X-ImpTot = 0.
   X-ImpExo = 0.
   X-ImpBrt = 0.
   X-ImpVta = 0.
   X-Bruto = 0.
   F-IGV = 0.
   F-ISC = 0.
   P-VAL1 = 0.
   P-VAL2 = 0.
   M1 = 0.
   M2 = 0. 
   FOR EACH ITEM NO-LOCK:
        POR_DSCREM = ROUND((( 1 - 
                        ( 1 - (ITEM.Por_Dsctos[2] / 100) ) /
                        ( 1 + (ABSOLUTE(ITEM.PorDto) / 100) ) 
                     ) * 100), 2).
        DSCT_REM = DSCT_REM + (ITEM.PreUni * ITEM.CanPed) * (POR_DSCREM / 100).
        X-Bruto = X-Bruto + (ITEM.PreUni * ITEM.CanPed).
        X-ImpDto = X-ImpDto + ITEM.ImpDto.
        F-IGV  = F-IGV + ITEM.ImpIgv.
        F-ISC  = F-ISC + ITEM.ImpIsc.
        X-ImpTot = X-ImpTot + ITEM.ImpLin.
        IF NOT ITEM.AftIgv THEN X-ImpExo = X-ImpExo + ITEM.ImpLin.
   END.
   X-ImpIgv = ROUND(F-IGV,2).
   X-ImpIsc = ROUND(F-ISC,2).
   X-ImpBrt = X-ImpTot - X-ImpIgv - X-ImpIsc + X-ImpDto - X-ImpExo.
   X-ImpVta = X-ImpBrt - X-ImpDto.

   P-VAL1 = (((DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) / 100) * X-ImpVta) + X-ImpDto).
   P-VAL2 = ((F-DTOMAX / 100) * X-Bruto ).
   
   M1 = ROUND(((((F-DTOMAX / 100) * X-Bruto ) - X-ImpDto) / X-Bruto) * 100 , 2).
   M2 = ROUND(((DSCT_REM - X-ImpDto) / X-ImpVta) * 100, 2).

/*   IF P-VAL1 > P-VAL2 THEN DO:
 *         MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
 *                 "posible DSCTO1. : " M1 " %" SKIP
 *                 VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
 *         APPLY "ENTRY":U TO Faccpedm.PorDto.
 *         RETURN "ADM-ERROR".
 *    END.*/
  IF DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) > f-DtoMax THEN DO:
    MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
        "posible DSCTO1. : " f-DtoMax " %" SKIP
        VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
    APPLY "ENTRY":U TO Faccpedm.PorDto.
    RETURN "ADM-ERROR".
  END.
  
   /*P-VAL2 = ((DSCT_REM / 100) * X-Bruto ).*/
   P-VAL2 = DSCT_REM.
   IF P-VAL1 > P-VAL2 THEN DO:
        MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                "posible DSCTO2. : " M2 " %" SKIP
                VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
        APPLY "ENTRY":U TO Faccpedm.PorDto.
        RETURN "ADM-ERROR".
   END.
 
    IF ((DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) / 100) * X-Bruto ) - (FaccPedm.Importe[1] + FaccPedm.Importe[2]) > ((F-DTOMAX / 100) * FaccPedm.Importe[3] ) THEN DO:
         MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                 "Pedido con Descuentos Conti-StandFord,Tarjeta" SKIP 
                 "Posible Descuento  : " ROUND((((((F-DTOMAX / 100 ) * FaccPedm.Importe[3]) + (FaccPedm.Importe[1] + FaccPedm.Importe[2]) ) / X-Bruto ) * 100 ),2) - 0.01 " %" SKIP
                 VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
         APPLY "ENTRY":U TO Faccpedm.PorDto.
         RETURN "ADM-ERROR".
    END.
 
END.

RETURN "OK".

END PROCEDURE.

/*
   /******************************************/
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   DEFINE VARIABLE POR_DSCREM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE DSCT_REM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE P-VAL1 AS DECIMAL.
   DEFINE VARIABLE P-VAL2 AS DECIMAL.
   DEFINE VARIABLE M1 AS DECIMAL.
   DEFINE VARIABLE M2 AS DECIMAL.
   
   DEFINE VARIABLE X-ImpDto AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIgv AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIsc AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpTot AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpExo AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpBrt AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpVta AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-Bruto  AS DECIMAL NO-UNDO.

   X-ImpDto = 0.
   X-ImpIgv = 0.
   X-ImpIsc = 0.
   X-ImpTot = 0.
   X-ImpExo = 0.
   X-ImpBrt = 0.
   X-ImpVta = 0.
   X-Bruto = 0.
   F-IGV = 0.
   F-ISC = 0.
   P-VAL1 = 0.
   P-VAL2 = 0.
   M1 = 0.
   M2 = 0. 
   FOR EACH ITEM NO-LOCK:
       POR_DSCREM = ROUND(((1 - ((1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.PorDto / 100))) * 100), 2).
       DSCT_REM = DSCT_REM + (ITEM.PreUni * (IF ITEM.Flg_factor = "1" THEN 
                              ITEM.CanPed ELSE (ITEM.CanPed * ITEM.Factor)) * 
                              (POR_DSCREM / 100)
                              ).
       X-Bruto = X-Bruto + (ITEM.PreUni * (IF ITEM.Flg_factor = "1" THEN 
                              ITEM.CanPed ELSE (ITEM.CanPed * ITEM.Factor))
                              ).
                              
       X-ImpDto = X-ImpDto + ITEM.ImpDto.
         F-IGV  = F-IGV + ITEM.ImpIgv.
         F-ISC  = F-ISC + ITEM.ImpIsc.
       X-ImpTot = X-ImpTot + ITEM.ImpLin.
       IF NOT ITEM.AftIgv THEN X-ImpExo = X-ImpExo + ITEM.ImpLin.
   END.
   
   X-ImpIgv = ROUND(F-IGV,2).
   X-ImpIsc = ROUND(F-ISC,2).
   X-ImpBrt = X-ImpTot - X-ImpIgv - X-ImpIsc + 
                    X-ImpDto - X-ImpExo.
   X-ImpVta = X-ImpBrt - X-ImpDto.

   P-VAL1 = (((DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) / 100) * X-ImpVta) + X-ImpDto).
   P-VAL2 = ((F-DTOMAX / 100) * X-Bruto ).
   
   M1 = ROUND(((((F-DTOMAX / 100) * X-Bruto ) - X-ImpDto) / X-Bruto) * 100 , 2).
   M2 = ROUND(((DSCT_REM - X-ImpDto) / X-ImpVta) * 100, 2).

   IF P-VAL1 > P-VAL2 THEN DO:
        MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                "posible DSCTO1. : " M1 " %" SKIP
                VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
        APPLY "ENTRY":U TO Faccpedm.PorDto.
        RETURN "ADM-ERROR".
   END.

   P-VAL2 = ((DSCT_REM / 100) * X-Bruto ).
   IF P-VAL1 > P-VAL2 THEN DO:
        MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                "posible DSCTO2. : " M2 " %" SKIP
                VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
        APPLY "ENTRY":U TO Faccpedm.PorDto.
        RETURN "ADM-ERROR".
   END.
 
    IF ((DECIMAL(Faccpedm.PorDto:SCREEN-VALUE) / 100) * X-Bruto ) - (FaccPedm.Importe[1] + FaccPedm.Importe[2]) > ((F-DTOMAX / 100) * FaccPedm.Importe[3] ) THEN DO:
         MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                 "Pedido con Descuentos Conti-StandFord,Tarjeta" SKIP 
                 "Posible Descuento  : " ROUND((((((F-DTOMAX / 100 ) * FaccPedm.Importe[3]) + (FaccPedm.Importe[1] + FaccPedm.Importe[2]) ) / X-Bruto ) * 100 ),2) - 0.01 " %" SKIP
                 VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
         APPLY "ENTRY":U TO Faccpedm.PorDto.
         RETURN "ADM-ERROR".
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE faccpedm THEN RETURN "ADM-ERROR".
IF LOOKUP(faccpedm.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".
DEFINE VAR RPTA AS CHAR NO-UNDO.

/*FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
 * RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
 * IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/

/******************/
  RUN VTA/D-CLAVE.R("D",
                    "DESCUENTOS",
                    OUTPUT NIV,
                    OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  s-nivel = NIV.
/******************/

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

