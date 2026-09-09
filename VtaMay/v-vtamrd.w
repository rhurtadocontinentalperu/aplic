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
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.

DEF SHARED VAR CL-CODCIA AS INT.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.Cmpbnte ~
FacCPedi.NroRef 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.RucCli FacCPedi.Cmpbnte ~
FacCPedi.NroRef FacCPedi.usuario FacCPedi.DirCli FacCPedi.NroCard ~
FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.FmaPgo FacCPedi.CodMon 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc f-NomVen f-CndVta 

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
DEFINE VARIABLE f-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Emision" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.FchPed AT ROW 1 COL 83 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.77 COL 11 COLON-ALIGNED
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 1.77 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 47 BY .81
     FacCPedi.RucCli AT ROW 1.77 COL 83 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.Cmpbnte AT ROW 2.54 COL 11 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 7 BY 1
     FacCPedi.NroRef AT ROW 2.54 COL 19 COLON-ALIGNED NO-LABEL FORMAT "X(9)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     x-FchDoc AT ROW 2.54 COL 37 COLON-ALIGNED
     FacCPedi.usuario AT ROW 2.54 COL 83 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.DirCli AT ROW 3.31 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 59 BY .81
     FacCPedi.NroCard AT ROW 3.31 COL 83 COLON-ALIGNED
          LABEL "Nº de Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.CodVen AT ROW 4.08 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     f-NomVen AT ROW 4.08 COL 20 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 4.08 COL 83 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.FmaPgo AT ROW 4.85 COL 11 COLON-ALIGNED
          LABEL "Cond. de Venta"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     f-CndVta AT ROW 4.85 COL 20 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 4.85 COL 85 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .77
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.85 COL 78
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
         HEIGHT             = 5
         WIDTH              = 104.86.
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

/* SETTINGS FOR COMBO-BOX FacCPedi.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie
  THEN DISPLAY gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.ruc @ FacCPedi.RucCli
                WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY '' @ FacCPedi.NomCli
                '' @ FacCPedi.RucCli
                WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroRef V-table-Win
ON LEAVE OF FacCPedi.NroRef IN FRAME F-Main /* Numero!Referencia */
OR RETURN OF {&SELF-NAME}
DO:
  FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = FacCPedi.Cmpbnte:SCREEN-VALUE
    AND ccbcdocu.nrodoc = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE ccbcdocu AND ccbcdocu.codcli = FacCPedi.CodCli:SCREEN-VALUE
  THEN DISPLAY ccbcdocu.dircli @ FacCPedi.DirCli
                ccbcdocu.fchdoc @ x-fchdoc
                ccbcdocu.codven @ faccpedi.codven
                ccbcdocu.fmapgo @ faccpedi.fmapgo
                ccbcdocu.nrocard @ faccpedi.nrocard
                WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     El calculo debe ser similar al que está e v-pedido.w
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-LINEA1    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-OTROS     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-AFECTO    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-DTO1      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-DTO2      AS DECIMAL NO-UNDO.

  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  
  FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  
  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[1] = 0
    FacCPedi.Importe[2] = 0
    FacCPedi.Importe[3] = 0.
  FOR EACH facdpedi OF faccpedi NO-LOCK: 
    ASSIGN
        /*FacCPedi.ImpDto = FacCPedi.ImpDto + facdpedi.ImpDto*/
        F-Igv = F-Igv + facdpedi.ImpIgv
        F-Isc = F-Isc + facdpedi.ImpIsc
        FacCPedi.ImpTot = FacCPedi.ImpTot + facdpedi.ImpLin.
    IF NOT facdpedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + facdpedi.ImpLin.
    IF Facdpedi.AftIgv = YES
    THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(Facdpedi.ImpDto / (1 + FacCPedi.PorIgv / 100), 2).
    ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + Facdpedi.ImpDto.
    /******************Identificacion de Importes para Descuento**********/
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA 
        AND Almmmatg.Codmat = facdpedi.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" 
            AND TRIM(Almmmatg.Desmar) = "STANDFORD" THEN X-STANDFORD = X-STANDFORD + facdpedi.ImpLin.
           IF facdpedi.Por_Dsctos[3] = 0 THEN DO:
              IF Almmmatg.CodFam = "001" 
              THEN X-LINEA1 = X-LINEA1 + facdpedi.ImpLin.
              ELSE X-OTROS = X-OTROS + facdpedi.ImpLin.
           END.                
        END.
    /*********************************************************************/
  END.
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
/*    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
 *                         FacCPedi.ImpDto - FacCPedi.ImpExo
 *     FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto.*/
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
   
  /*******Descuento Especial********************/
  IF X-STANDFORD >= 500 THEN DO:
      X-AFECTO = X-LINEA1 .
      IF X-LINEA1 > X-STANDFORD THEN X-AFECTO = X-STANDFORD.  
      X-DTO1   = 0 .
  END.
  /*********************************************/
  DEFINE VAR X-IMPTOT AS DECI INIT 0.
  DEFINE VAR Y-IMPTOT AS DECI INIT 0.
  X-DTO2 = 0.
  Y-IMPTOT = ( X-LINEA1 - X-AFECTO + X-OTROS ) .
  IF FacCPedi.CodMon = 1 THEN X-IMPTOT = Y-IMPTOT .
  IF FacCPedi.CodMon = 2 THEN X-IMPTOT = Y-IMPTOT * FacCPedi.TpoCmb .           
  IF LOOKUP(FacCPedi.FmaPgo,"000,001") > 0  THEN DO:
    FacCPedi.Importe[1] = ROUND((( X-AFECTO * X-DTO1 ) / 100 ),2) .
    FacCPedi.Importe[2] = ROUND((( Y-IMPTOT * X-DTO2 ) / 100 ),2) .
  END.
/*  ASSIGN
 *     FacCPedi.PorDto = ROUND(((( FacCPedi.Importe[1] + FacCPedi.Importe[2] ) / FacCPedi.ImpTot ) * 100 ),2)
 *     FacCPedi.ImpDto = FacCPedi.ImpDto + FacCPedi.Importe[1] + FacCPedi.Importe[2]
 *     FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
 *     FacCPedi.ImpVta = ROUND(FacCPedi.ImpTot / (1 + FacCPedi.PorIgv / 100),2)
 *     FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpVta
 *     FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
 *                      FacCPedi.ImpDto - FacCPedi.ImpExo.
 *   IF LOOKUP(FacCPedi.FmaPgo,"000,001") > 0  THEN DO:
 *     FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.
 *   END.                 */
  /******************************************************/
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
  END.
  FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.
  FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.

  FIND CURRENT FacCPedi NO-LOCK.

END PROCEDURE.

/*
  Y-IMPTOT = ( X-LINEA1 + X-OTROS ) .   
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
  END.
  FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.
  FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Control de correlativos */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv 
    AND FacCorre.CodDoc = s-coddoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre
  THEN DO:
    MESSAGE 'No ha configurado el correlativo para esta división'
        VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina-2').

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
  IF RETURN-VALUE = 'YES'
  THEN DO:
    /* Control de correlativos */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
        AND FacCorre.CodDiv = s-coddiv 
        AND FacCorre.CodDoc = s-coddoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.CodCia = s-codcia
        FacCPedi.CodDiv = s-coddiv
        FacCPedi.CodDoc = s-coddoc
        FacCPedi.FchPed = TODAY
        FacCPedi.NroPed = STRING(FacCorre.NroSer, '999') +
                            STRING(FacCorre.Correlativo, '999999')
        FacCPedi.FlgEst = 'P'
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
  END.
  /* Trasladamos la informacion */
  BUFFER-COPY CcbCDocu 
    EXCEPT ccbcdocu.codcia 
            ccbcdocu.coddiv 
            ccbcdocu.coddoc 
            ccbcdocu.nrodoc 
            ccbcdocu.nroped
            ccbcdocu.nroref
            ccbcdocu.usuario
    TO FacCPedi.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    faccpedi.usuario = s-user-id.
    
  /* Cargamos el detalle */
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
    CREATE FacDPedi.
    BUFFER-COPY CcbDDocu TO FacDPedi
        ASSIGN facdpedi.codcia = faccpedi.codcia
                facdpedi.coddoc = faccpedi.coddoc
                FacDPedi.CanPed = CcbDDocu.CanDes
                facdpedi.nroped = faccpedi.nroped
                facdpedi.coddiv = faccpedi.coddiv
                facdpedi.nroitm = x-Item.
    x-Item = x-Item + 1.
    /* RHC 31.01.2007 Cambiar el precio unitario a neto y eliminar el monto de descuento, recalculamos factura */
    IF Facdpedi.por_dsctos[1] > 0 THEN DO:
        Facdpedi.preuni = ROUND(Facdpedi.ImpLin / Facdpedi.CanPed, 5).
        Facdpedi.por_dsctos[1] = 0.
        Facdpedi.impdto = 0.
    END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca V-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

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
  FOR EACH FacDPedi OF FacCPedi:
    DELETE FacDPedi.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
    FIND CcbCDocu WHERE ccbcdocu.codcia = faccpedi.codcia
        AND ccbcdocu.coddoc = FacCPedi.Cmpbnte
        AND ccbcdocu.nrodoc = FacCPedi.NroRef
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu
    THEN DISPLAY ccbcdocu.fchdoc @ x-fchdoc.        
    F-NomVen:screen-value = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
    F-CndVta:SCREEN-VALUE = "".
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
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
  RUN vtamay/R-ImpPmr(ROWID(FacCPedi)).


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
  RUN Procesa-Handle IN lh_handle ('calcula-totales').
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

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

   RUN vtamay/d-mrgped (ROWID(FacCPedi)).

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
        WHEN "NroRef" THEN
            ASSIGN 
                input-var-1 = FacCPedi.Cmpbnte:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-3 = s-coddiv.
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
    /* Buscamos el documento de referencia */
    FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = FacCPedi.Cmpbnte:SCREEN-VALUE
        AND ccbcdocu.nrodoc = FacCPedi.NroRef:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu
    THEN DO:
        MESSAGE 'El documento NO está registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO faccpedi.codcli.
        RETURN 'ADM-ERROR'.
    END.
    IF ccbcdocu.codcli <> faccpedi.codcli:SCREEN-VALUE
    THEN DO:
        MESSAGE 'El documento NO pertenece a este cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO faccpedi.codcli.
        RETURN 'ADM-ERROR'.
    END.
/*     IF ccbcdocu.coddiv <> s-coddiv                                 */
/*     THEN DO:                                                       */
/*         MESSAGE 'El documento NO pertenece a la división' s-coddiv */
/*            VIEW-AS ALERT-BOX ERROR.                                */
/*         APPLY 'ENTRY':U TO faccpedi.codcli.                        */
/*         RETURN 'ADM-ERROR'.                                        */
/*     END.                                                           */
    IF ccbcdocu.flgest = 'A'
    THEN DO:
        MESSAGE 'El documento está ANULADO' s-coddiv 
           VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO faccpedi.codcli.
        RETURN 'ADM-ERROR'.
    END.
    /* Buscamos que no exista */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES'
    THEN DO:
        IF CAN-FIND(faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = s-coddoc
            AND faccpedi.cmpbnte = faccpedi.cmpbnte:SCREEN-VALUE
            AND faccpedi.nroref = faccpedi.nroref:SCREEN-VALUE NO-LOCK)
        THEN DO:
            MESSAGE 'La' faccpedi.cmpbnte:SCREEN-VALUE faccpedi.nroref:SCREEN-VALUE
                'ya ha sido registrada anteriormente' SKIP
                'Desea grabarlo de todas maneras?'
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE rpta-1 AS LOG.
            IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.                
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

