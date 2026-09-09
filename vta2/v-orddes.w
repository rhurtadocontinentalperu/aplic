&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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
{src/bin/_prns.i}

/* Public Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODREF   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE s-NroSer   AS INT.
DEFINE SHARED VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE SHARED VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.

DEFINE BUFFER B-DPedi FOR FacDPedi.

DEFINE STREAM report.
DEFINE TEMP-TABLE Reporte
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.FchPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.fchven FacCPedi.DirCli FacCPedi.ordcmp ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.NroRef FacCPedi.Sede ~
FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.FlgIgv FacCPedi.Glosa ~
FacCPedi.CodVen FacCPedi.FmaPgo 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.fchven FacCPedi.DirCli ~
FacCPedi.ordcmp FacCPedi.RucCli FacCPedi.Atencion FacCPedi.NroRef ~
FacCPedi.Sede FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.FlgIgv ~
FacCPedi.Glosa FacCPedi.usuario FacCPedi.CodVen FacCPedi.FmaPgo ~
FacCPedi.NroCard 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Situac FILL-IN-sede F-nOMvEN ~
F-CndVta F-Nomtar 

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
DEFINE BUTTON BUTTON-10 
     LABEL "Sede:" 
     SIZE 5 BY .81.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE F-Situac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          FONT 0
     F-Estado AT ROW 1 COL 45 COLON-ALIGNED NO-LABEL
     F-Situac AT ROW 1 COL 60 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1 COL 94.14 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.NomCli AT ROW 1.81 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     FacCPedi.fchven AT ROW 1.81 COL 94.14 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.62 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     FacCPedi.ordcmp AT ROW 2.62 COL 94 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
     FacCPedi.RucCli AT ROW 3.42 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 3.42 COL 28 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.NroRef AT ROW 3.42 COL 94 COLON-ALIGNED
          LABEL "No. Pedido"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
          BGCOLOR 15 FGCOLOR 12 
     BUTTON-10 AT ROW 4.23 COL 6
     FacCPedi.Sede AT ROW 4.23 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-sede AT ROW 4.23 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FacCPedi.CodMon AT ROW 4.23 COL 96 NO-LABEL WIDGET-ID 46
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     FacCPedi.LugEnt AT ROW 5.04 COL 9 COLON-ALIGNED WIDGET-ID 20
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.FlgIgv AT ROW 5.04 COL 96 NO-LABEL WIDGET-ID 50
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11.57 BY .81
     FacCPedi.Glosa AT ROW 5.85 COL 6.28 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
          BGCOLOR 11 
     FacCPedi.usuario AT ROW 5.85 COL 94 COLON-ALIGNED WIDGET-ID 56
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.CodVen AT ROW 6.65 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-nOMvEN AT ROW 6.65 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FmaPgo AT ROW 7.46 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta."
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-CndVta AT ROW 7.46 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.NroCard AT ROW 8.27 COL 9 COLON-ALIGNED WIDGET-ID 40
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 8.27 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.5 COL 89 WIDGET-ID 54
     "Con IGV:" VIEW-AS TEXT
          SIZE 6.43 BY .81 AT ROW 5.04 COL 89 WIDGET-ID 26
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
   Temp-Tables and Buffers:
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: T-CPEDI T "SHARED" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 11.08
         WIDTH              = 130.86.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 V-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Sede: */
DO:
  ASSIGN
    input-var-1 = FacCPedi.CodCli:SCREEN-VALUE
    input-var-2 = FacCPedi.NomCli:SCREEN-VALUE
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN vta/c-clied.
  IF output-var-2 <> '' 
      THEN ASSIGN 
            /*FacCPedi.DirCli:SCREEN-VALUE = output-var-2*/
            FILL-IN-sede:SCREEN-VALUE = output-var-2
            FacCPedi.Sede:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
/*  F-NomVen = "".
  IF FacCPedi.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.fchven V-table-Win
ON LEAVE OF FacCPedi.fchven IN FRAME F-Main /* Vencimiento */
DO:
  IF INPUT {&SELF-NAME} < TODAY THEN DO:
    MESSAGE 'Fecha de Vencimiento errada' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH PEDI:
    DELETE PEDI.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' THEN DO:
   FOR EACH FacDPedi OF FacCPedi NO-LOCK:
       CREATE PEDI.
       BUFFER-COPY FacDPedi TO PEDI.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El PEDIDO siempre se cierra
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH facdPedi OF faccPedi NO-LOCK:
          FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
              AND B-DPedi.CodDiv = FacCPedi.CodDiv
              AND B-DPedi.CodDoc = FacCPedi.CodRef
              AND B-DPedi.NroPed = FacCPedi.NroRef 
              AND B-DPedi.CodMat = FacDPedi.CodMat 
              AND B-DPedi.AlmDes = FacDPedi.AlmDes
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
              B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * FacDPedi.CanPed
              B-DPEDI.FlgEst = (IF x-Tipo = +1 THEN "C" ELSE "P").
          RELEASE B-DPedi.
      END.
      FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
          AND B-CPedi.CodDiv = S-CODDIV 
          AND B-CPedi.CodDoc = FacCPedi.CodRef
          AND B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
      IF x-Tipo = -1 THEN B-CPedi.FlgEst = "P".
      IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".
      RELEASE B-CPedi.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-datos V-table-Win 
PROCEDURE Asigna-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Orden NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        

    IF LOOKUP (FacCPedi.FlgEst,"P") > 0 THEN DO:
        RUN vta/w-agtrans-02 (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Pedido V-table-Win 
PROCEDURE Asigna-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-OK     AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:  
    FOR EACH PEDI:
        DELETE PEDI.
    END.
   FIND B-CPedi WHERE 
        B-CPedi.CodCia = S-CODCIA  AND  
        B-CPedi.CodDiv = S-CODDIV  AND  
        B-CPedi.CodDoc = s-CodRef  AND  
        B-CPedi.NroPed = s-NroCot 
        NO-LOCK NO-ERROR.
   ASSIGN
       F-NomVen = ""
       F-CndVta = "".

   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA  
       AND gn-ven.CodVen = B-CPedi.CodVen 
       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
   FIND gn-convt WHERE gn-convt.Codig = B-CPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
   FIND Gn-Card WHERE Gn-Card.NroCard = B-CPEDI.NroCard NO-LOCK NO-ERROR.
   IF AVAILABLE GN-CARD THEN F-NomTar = GN-CARD.NomClie[1].

   DISPLAY 
       B-CPEDI.CodCli @ Faccpedi.codcli
       B-CPEDI.NomCli @ Faccpedi.nomcli
       B-CPEDI.DirCli @ Faccpedi.dircli
       B-CPEDI.RucCli @ Faccpedi.ruccli
       B-CPEDI.Atencion @ FAccpedi.Atencion
       S-NROCOT       @ FacCPedi.nroref
       B-CPedi.CodVen @ FacCPedi.CodVen 
       B-CPedi.FmaPgo @ FacCPedi.FmaPgo 
       B-CPedi.Ordcmp @ FaccPedi.Ordcmp
       B-CPedi.FchVen @ FaccPedi.FchVen
       B-CPedi.Glosa  @ FaccPedi.Glosa
       B-CPEDI.Sede   @ Faccpedi.Sede
       B-CPEDI.LugEnt @ Faccpedi.LugEnt
       B-CPEDI.NroCard @ FacCPedi.NroCard
       f-NomVen
       f-CndVta.
   FacCPedi.CodMon:SCREEN-VALUE = ENTRY(B-CPEDI.CodMon, FacCPedi.CodMon:LIST-ITEMS).
   FacCPedi.FlgIgv:SCREEN-VALUE = ENTRY((IF B-CPEDI.FlgIgv THEN 1 ELSE 2), FacCPedi.FlgIgv:LIST-ITEMS).

   /* DETALLES */
   FOR EACH FacDPedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
       BY FacDPedi.NroItm:
       CREATE PEDI.
       BUFFER-COPY Facdpedi 
           EXCEPT Facdpedi.CanPick Facdpedi.CanAte
           TO PEDI
           ASSIGN PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte).
   END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna_datos V-table-Win 
PROCEDURE Asigna_datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        

    IF FaccPedi.FchVen < TODAY THEN DO:
       MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
    END.
    IF FacCPedi.FlgEst <> "A" THEN RUN vta\w-agtrans(ROWID(FacCPedi)).
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

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FOR EACH FacdPedi OF faccPedi:
          DELETE FacDPedi.
      END.
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
DEF INPUT PARAMETER cFamilia AS CHAR.

DEF VAR xFamilia AS CHAR.
DEFINE VARIABLE ped            AS CHARACTER.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.

CASE cFamilia:
    WHEN '+' THEN DO:
        xFamilia = '010'.
    END.
    WHEN '-' THEN DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
            AND Almtfami.codfam <> '010':
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
    OTHERWISE DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
END CASE.

DEFINE BUFFER b-CPedi FOR FacCPedi.

DEFINE VAR conta AS INTEGER NO-UNDO INIT 0.
FOR EACH reporte.
    DELETE Reporte.
END.

ped = FacCPedi.NroPed.
FOR EACH b-CPedi NO-LOCK WHERE b-CPedi.CodCia = s-codcia 
    AND b-CPedi.CodDiv =  s-CodDiv                     
    AND b-CPedi.CodDoc =  s-CodDoc                     
    AND b-CPedi.NroPed =  PED:                         
    FOR EACH FacDPedi OF b-CPedi NO-LOCK,
        FIRST Almmmatg OF Facdpedi NO-LOCK WHERE LOOKUP(Almmmatg.codfam, xFamilia) > 0,
        FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = b-CPedi.CodCia
        AND Almmmate.CodAlm = b-CPedi.CodAlm
        AND Almmmate.CodMat = FacDPedi.CodMat
        BREAK BY Almmmate.CodUbi BY FacDPedi.CodMat:
        conta = conta + 1.
        CREATE Reporte.
        ASSIGN 
            Reporte.NroPed   = b-CPedi.NroPed
            Reporte.CodMat   = FacDPedi.CodMat
            Reporte.DesMat   = Almmmatg.DesMat
            Reporte.DesMar   = Almmmatg.DesMar
            Reporte.UndBas   = FacDPedi.UndVta
            Reporte.CanPed   = FacDPedi.CanPed
            Reporte.CodUbi   = Almmmate.CodUbi
            Reporte.X-TRANS  = b-CPedi.Libre_c01
            Reporte.X-DIREC  = b-CPedi.Libre_c02
            Reporte.X-LUGAR  = b-CPedi.Libre_c03
            Reporte.X-CONTC  = b-CPedi.Libre_c04
            Reporte.X-HORA   = b-CPedi.Libre_c05
            Reporte.X-FECHA  = b-CPedi.Libre_f01
            Reporte.X-OBSER  = b-CPedi.Observa
            Reporte.X-Glosa  = b-CPedi.Glosa
            Reporte.X-nomcli = b-CPedi.codcli
            Reporte.X-NomCli = b-CPedi.NomCli.
    END.
END.
npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
IF npage < 0 THEN npage = INTEGER(conta / c-items).
ELSE npage = INTEGER(conta / c-items) + 1. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Confirmar-O/D V-table-Win 
PROCEDURE Confirmar-O/D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF FacCPedi.Flgest = "P" THEN DO:
     FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) NO-ERROR.
     IF AVAILABLE B-CPedi THEN DO:
        ASSIGN B-CPedi.FlgSit = IF B-CPedi.FlgSit = "P" THEN "" ELSE "P".
        RELEASE B-CPedi.
     END.
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Una Orden por cada almacén
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH pedi WHERE codmat = '' OR almdes = '':
       DELETE pedi.
   END.

   /* tomamos la primera */
   FOR EACH PEDI,
       FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND Almacen.codalm = PEDI.AlmDes
       BREAK BY PEDI.AlmDes BY PEDI.NroItm:
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       IF FIRST-OF(PEDI.AlmDes) THEN DO:
           ASSIGN
               FacCPedi.DivDes = Almacen.CodDiv
               FacCPedi.CodAlm = Almacen.CodAlm.
           FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
               AND gn-divi.coddiv = Faccpedi.divdes
               NO-LOCK.
           ASSIGN
               s-FlgPicking = GN-DIVI.FlgPicking
               s-FlgBarras  = GN-DIVI.FlgBarras.
           IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear */
           IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
           IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Picking OK */
       END.
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY PEDI TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
           FacDPedi.coddoc  = FacCPedi.coddoc 
           FacDPedi.NroPed  = FacCPedi.NroPed 
           FacDPedi.FchPed  = FacCPedi.FchPed
           FacDPedi.Hora    = FacCPedi.Hora 
           FacDPedi.FlgEst  = FacCPedi.FlgEst
           FacDPedi.NroItm  = I-NITEM
           FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */
       IF LAST-OF(PEDI.AlmDes) THEN LEAVE.
   END.

   FOR EACH PEDI WHERE PEDI.AlmDes = FacCPedi.CodAlm:
       DELETE PEDI.
   END.

/*    /* definimos cuantas divisiones y almacenes estan involucradas */                                  */
/*    DEF VAR x-Divisiones AS CHAR NO-UNDO.                                                              */
/*    FOR EACH PEDI NO-LOCK,                                                                             */
/*        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia                                          */
/*        AND Almacen.codalm = PEDI.AlmDes                                                               */
/*        BREAK BY Almacen.coddiv:                                                                       */
/*        IF FIRST-OF(Almacen.coddiv) THEN DO:                                                           */
/*            IF x-Divisiones = '' THEN x-Divisiones = Almacen.coddiv.                                   */
/*            ELSE x-Divisiones = x-Divisiones + ',' + Almacen.coddiv.                                   */
/*        END.                                                                                           */
/*    END.                                                                                               */
/*    /* tomamos la primera */                                                                           */
/*    FOR EACH PEDI,                                                                                     */
/*        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia                                          */
/*        AND Almacen.codalm = PEDI.AlmDes                                                               */
/*        /*AND Almacen.coddiv = ENTRY(1, x-Divisiones)*/                                                */
/*        BREAK BY PEDI.AlmDes BY PEDI.NroItm:                                                           */
/*        I-NITEM = I-NITEM + 1.                                                                         */
/*        CREATE FacDPedi.                                                                               */
/*        BUFFER-COPY PEDI TO FacDPedi                                                                   */
/*            ASSIGN                                                                                     */
/*            FacDPedi.CodCia  = FacCPedi.CodCia                                                         */
/*            FacDPedi.coddiv  = FacCPedi.coddiv                                                         */
/*            FacDPedi.coddoc  = FacCPedi.coddoc                                                         */
/*            FacDPedi.NroPed  = FacCPedi.NroPed                                                         */
/*            FacDPedi.FchPed  = FacCPedi.FchPed                                                         */
/*            FacDPedi.Hora    = FacCPedi.Hora                                                           */
/*            FacDPedi.FlgEst  = FacCPedi.FlgEst                                                         */
/*            FacDPedi.NroItm  = I-NITEM                                                                 */
/*            FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */                                  */
/*        /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */                                 */
/*        ASSIGN                                                                                         */
/*            FacCPedi.DivDes = Almacen.CodDiv                                                           */
/*            FacCPedi.CodAlm = Almacen.CodAlm.                                                          */
/*        FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia                                            */
/*            AND gn-divi.coddiv = Faccpedi.divdes                                                       */
/*            NO-LOCK.                                                                                   */
/*        ASSIGN                                                                                         */
/*            s-FlgPicking = GN-DIVI.FlgPicking                                                          */
/*            s-FlgBarras  = GN-DIVI.FlgBarras.                                                          */
/*        IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear */                         */
/*        IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */       */
/*        IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Picking OK */      */
/*        /* ******************************************* */                                              */
/*        /* DETERMINAMOS LA SITUACION FINAL DE LA ORDEN DE DESPACHO */                                  */
/*        FIND FIRST T-CPEDI WHERE T-CPEDI.coddiv = FacCPedi.divdes NO-LOCK NO-ERROR.                    */
/*        IF AVAILABLE T-CPEDI AND T-CPEDI.FlgEst <> "P" THEN FacCPedi.FlgEst = "X".   /* POR APROBAR */ */
/*        /* ******************************************************* */                                  */
/*        DELETE PEDI.                                                                                   */
/*        IF LAST-OF(PEDI.AlmDes) THEN LEAVE.                                                            */
/*    END.                                                                                               */

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

    {vta2/graba-totales-ped.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir1 V-table-Win 
PROCEDURE Imprimir1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
    IF x-Ok = NO THEN RETURN.
    
    /* RHC 04.12.09 VAMOS A HACER 2 IMPRESIONES:
    Una con la familia 010 y otra con las demás familias
    */
    RUN Carga-Temporal ('+').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
    END.
    RUN Carga-Temporal ('-').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
    END.

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
  FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                 AND  FacCorre.CodDoc = S-CODDOC 
                 AND  FacCorre.NroSer = S-NroSer
                 NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      S-NroCot = ""
      input-var-1 = s-CodRef
      input-var-2 = s-CodDiv
      input-var-3 = "".
  RUN vta2\c-cotpen ("Pedidos Pendientes").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  S-NroCot = output-var-2.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      RUN Asigna-Pedido.
      DISPLAY 
          STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999') @ Faccpedi.nroped
          TODAY @ FacCPedi.FchPed
          TODAY + 7 @ FacCPedi.FchVen.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalcular').

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
  FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
      FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
          AND B-CPEDI.coddoc = s-CodRef
          AND B-CPEDI.nroped = Faccpedi.nroref:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN DO:
          MESSAGE 'NO se encontró el Pedido' Faccpedi.nroref:SCREEN-VALUE
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

      /* RESUMEN POR DIVISION Y ALMACEN DESTINO */
      /*RUN vta2/orde-des-por-div (s-codcia, B-CPEDI.codalm, B-CPEDI.codmon, B-CPEDI.tpocmb, B-CPEDI.flgenv).*/

      /* **************************** */
      BUFFER-COPY B-CPEDI 
          EXCEPT 
            B-CPEDI.TpoPed
            B-CPEDI.FchVen
            B-CPEDI.DirCli
            B-CPEDI.Sede
            B-CPEDI.NroRef
            B-CPEDI.FlgEst
            B-CPEDI.FlgSit
            B-CPEDI.Glosa
            B-CPEDI.LugEnt
            B-CPEDI.Atencion
          TO FacCPedi
          ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.CodRef = s-CodRef
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCorre.Correlativo = FacCorre.Correlativo + 1
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = "P".      /* APROBADO: revisar rutine Genera-Pedido */

      /* TRACKING */
      RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                              Faccpedi.CodDiv,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef,
                              s-User-Id,
                              'GOD',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef).
      /* COPIAMOS DATOS DEL TRANSPORTISTA */
      FIND Ccbadocu WHERE Ccbadocu.codcia = B-CPEDI.codcia
          AND Ccbadocu.coddiv = B-CPEDI.coddiv
          AND Ccbadocu.coddoc = B-CPEDI.coddoc
          AND Ccbadocu.nrodoc = B-CPEDI.nroped
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbadocu THEN DO:
          FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = s-codcia
              AND B-ADOCU.coddiv = Faccpedi.coddiv
              AND B-ADOCU.coddoc = Faccpedi.coddoc
              AND B-ADOCU.nrodoc = Faccpedi.nroped
              NO-ERROR.
          IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
          BUFFER-COPY Ccbadocu TO B-ADOCU
              ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed.
      END.
      /* ******************************** */
  END.
  ELSE DO:
      RUN Actualiza-Pedido (-1).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
    FacCPedi.Usuario = S-USER-ID.

  RUN Genera-Pedido.    /* Detalle del pedido */ 

  /* Grabamos Totales */
  RUN Graba-Totales.

  RUN Actualiza-Pedido (+1).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* SE VAN A GENERAR TANTAS ORDENES COMO ** ALMACENES ** DESTINO EXISTAN */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN REPEAT:
      FIND FIRST PEDI NO-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDI THEN LEAVE.

      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

      CREATE B-CPEDI.
      BUFFER-COPY FacCPedi TO B-CPEDI
          ASSIGN 
            B-CPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCorre.Correlativo = FacCorre.Correlativo + 1
            B-CPedi.Hora = STRING(TIME,"HH:MM").
      FIND FacCPedi WHERE ROWID(FacCPedi) = ROWID(B-CPEDI) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCPedi THEN UNDO, RETURN "ADM-ERROR".
      /* TRACKING */
      RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                              Faccpedi.CodDiv,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef,
                              s-User-Id,
                              'GOD',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef).
      /* COPIAMOS DATOS DEL TRANSPORTISTA */
      IF AVAILABLE Ccbadocu THEN DO:
          CREATE B-ADOCU.
          BUFFER-COPY Ccbadocu TO B-ADOCU
              ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed.
      END.
      /* ******************************** */
      RUN Genera-Pedido.    /* Detalle del pedido */ 

      /* Grabamos Totales */
      RUN Graba-Totales.

      RUN Actualiza-Pedido (+1).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
  IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.

  RUN dispatch IN THIS-PROCEDURE("display-fields").

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
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
    IF LOOKUP(FacCPedi.FlgEst,"P,X") = 0 THEN DO:
        MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
    END.
    FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
        MESSAGE "No puede modificar una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "P" THEN DO:
        MESSAGE "La orden ya está con PICKING" SKIP
            'Continuamos con la anulación?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta-1 AS LOG.
        IF rpta-1 = NO THEN RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C" THEN DO:
        MESSAGE "La orden ya está con CHEQUEO DE BARRAS" SKIP
            'Continuamos con la anulación?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta-2 AS LOG.
        IF rpta-2 = NO THEN RETURN "ADM-ERROR".
    END.

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       RUN Actualiza-Pedido (-1).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                               Faccpedi.CodDiv,
                               Faccpedi.CodRef,
                               Faccpedi.NroRef,
                               s-User-Id,
                               'GOD',
                               'A',
                               DATETIME(TODAY, MTIME),
                               DATETIME(TODAY, MTIME),
                               Faccpedi.CodDoc,
                               Faccpedi.NroPed,
                               Faccpedi.CodRef,
                               Faccpedi.NroRef).
       FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
       ASSIGN 
           B-CPedi.FlgEst = "A"
           B-CPedi.Glosa = " A N U L A D O".
       RELEASE B-CPedi.
    END.
        
    RUN Procesa-Handle IN lh_Handle ('browse').
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    
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
        BUTTON-10:SENSITIVE = NO.
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
      RUN vta2/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.

      CASE Faccpedi.FlgSit:
          WHEN 'P' THEN DISPLAY "PICKEADO OK"    @ F-Situac WITH FRAME {&FRAME-NAME}.
          WHEN 'C' THEN DISPLAY "BARRAS OK"      @ F-Situac WITH FRAME {&FRAME-NAME}.
          WHEN 'T' THEN DISPLAY "FALTA PICKEAR"  @ F-Situac WITH FRAME {&FRAME-NAME}.
          OTHERWISE DISPLAY "" @ F-Situac WITH FRAME {&FRAME-NAME}.
      END CASE.
      F-NomVen:screen-value = "".
      FIND gn-ven WHERE 
           gn-ven.CodCia = S-CODCIA AND  
           gn-ven.CodVen = FacCPedi.CodVen 
           NO-LOCK NO-ERROR.

      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".

      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.

      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = FacCPedi.Codcli
          AND GN-ClieD.sede = FacCPedi.sede
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD 
      THEN ASSIGN FILL-IN-sede = GN-ClieD.dircli.
      ELSE ASSIGN FILL-IN-sede = "".
      DISPLAY FILL-IN-sede WITH FRAME {&FRAME-NAME}.
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
        FacCPedi.FchPed:SENSITIVE = NO
        FacCPedi.FchVen:SENSITIVE = NO
        FacCPedi.CodCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO
        FacCPedi.Atencion:SENSITIVE = NO
        FacCPedi.Sede:SENSITIVE   = NO
        FacCPedi.OrdCmp:SENSITIVE = NO
        FacCPedi.NroPed:SENSITIVE = NO
        FacCPedi.NroRef:SENSITIVE = NO
        FacCPedi.CodVen:SENSITIVE = NO
        FacCPedi.FmaPgo:SENSITIVE = NO
        FacCPedi.CodMon:SENSITIVE = NO
        FacCPedi.FlgIgv:SENSITIVE = NO
        BUTTON-10:SENSITIVE = YES.
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
  IF NOT AVAILABLE Faccpedi OR Faccpedi.flgest = 'A'  THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE cMode   AS CHAR NO-UNDO.
  DEFINE VARIABLE c-Items AS INT NO-UNDO.

  RUN vta/d-imp-od (OUTPUT cMode).
  
  IF cMode = 'ADM-ERROR' THEN RETURN NO-APPLY.

  c-items = 0.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      c-items = c-items + 1.
  END.

  CASE cMode:
      WHEN '1' THEN RUN vta/R-ImpOD (ROWID(FacCPedi)).
      WHEN '2' THEN RUN Imprimir1.
      WHEN '3' THEN DO: 
            RUN vta/R-ImpOD (ROWID(FacCPedi)).
            RUN Imprimir1.
      END.
  END CASE.

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
DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE t_it  AS DECIMAL INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
   IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
        gn-ven.CodVen = FacCPedi.CodVen:screen-value NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.
   IF FacCPedi.Fmapgo:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-convt THEN DO:
      MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.
   FOR EACH PEDI NO-LOCK: 
       F-Tot = F-Tot + PEDI.ImpLin.
       T_IT  = T_IT + 1 .
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.

/*    IF FacCPedi.Ubigeo[3]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabDepto WHERE TabDepto.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE NO-LOCK NO-ERROR. */
/*        IF NOT AVAILABLE TabDepto THEN DO:                                                        */
/*            MESSAGE "DEPARTAMENTO no existe" VIEW-AS ALERT-BOX ERROR.                             */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[3].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */
/*    IF FacCPedi.Ubigeo[2]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabProvi WHERE TabProvi.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE                   */
/*            AND TabProvi.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE NO-LOCK NO-ERROR.             */
/*        IF NOT AVAILABLE TabProvi THEN DO:                                                        */
/*            MESSAGE "PROVINCIA no existe" VIEW-AS ALERT-BOX ERROR.                                */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[2].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */
/*    IF FacCPedi.Ubigeo[1]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabDistr WHERE TabDistr.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE                   */
/*            AND TabDistr.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE                               */
/*            AND TabDistr.CodDistr = FacCPedi.Ubigeo[1]:SCREEN-VALUE NO-LOCK NO-ERROR.             */
/*        IF NOT AVAILABLE TabDistr THEN DO:                                                        */
/*            MESSAGE "DISTRITO no existe" VIEW-AS ALERT-BOX ERROR.                                 */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[1].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */

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
  
IF NOT AVAILABLE FacCPedi            THEN RETURN "ADM-ERROR".

IF LOOKUP(FacCPedi.FlgEst,"X") = 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "P" THEN DO:
    MESSAGE "La orden ya está con PICKING" SKIP
/*         "Tiene que usar la opción: CIERRE DE ORDENES DE DESPACHO" */
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C" THEN DO:
    MESSAGE "La orden ya está con CHEQUEO DE BARRAS" SKIP
/*         "Tiene que usar la opción: CIERRE DE ORDENES DE DESPACHO" */
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
IF AVAILABLE Facdpedi THEN DO:
    MESSAGE "No puede modificar una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

