&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEFINE SHARED VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.
DEFINE SHARED VARIABLE s-PorIgv   LIKE Faccpedi.porigv.
DEFINE SHARED VARIABLE s-CodCli   LIKE Faccpedi.codcli.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.

DEFINE BUFFER B-DPedi FOR FacDPedi.

DEFINE STREAM report.
    DEFINE TEMP-TABLE Reporte
        FIELD CodDoc    LIKE FacCPedi.CodDoc
        FIELDS NroPed   LIKE FacCPedi.NroPed
        FIELD  CodRef    LIKE FacCPedi.CodRef
        FIELDS NroRef   LIKE FacCPedi.NroRef
        FIELDS CodAlm   LIKE Facdpedi.almdes
        FIELDS CodMat   LIKE FacDPedi.CodMat
        FIELDS DesMat   LIKE Almmmatg.DesMat
        FIELDS DesMar   LIKE Almmmatg.DesMar
        FIELDS UndBas   LIKE Almmmatg.UndBas
        FIELDS CanPed   LIKE FacDPedi.CanPed
        FIELDS CodUbi   LIKE Almmmate.CodUbi
        FIELDS CodZona  LIKE Almtubic.CodZona
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

DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF VAR pMensaje AS CHAR NO-UNDO.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.RucCli FacCPedi.Atencion FacCPedi.fchven ~
FacCPedi.NomCli FacCPedi.usuario FacCPedi.DirCli FacCPedi.ordcmp ~
FacCPedi.LugEnt FacCPedi.CodRef FacCPedi.NroRef FacCPedi.NroCard ~
FacCPedi.CodMon FacCPedi.Sede FacCPedi.FlgIgv FacCPedi.CodVen ~
FacCPedi.FmaPgo FacCPedi.CodAlm FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Situac F-Nomtar FILL-IN-sede ~
F-nOMvEN F-CndVta f-NomAlm 

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
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE F-Situac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 16 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1 COL 40 COLON-ALIGNED NO-LABEL
     F-Situac AT ROW 1 COL 69 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1 COL 100 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.81 COL 16 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.RucCli AT ROW 1.81 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 1.81 COL 54 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.fchven AT ROW 1.81 COL 100 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NomCli AT ROW 2.62 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     FacCPedi.usuario AT ROW 2.62 COL 100 COLON-ALIGNED WIDGET-ID 56
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.DirCli AT ROW 3.42 COL 16 COLON-ALIGNED
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     FacCPedi.ordcmp AT ROW 3.42 COL 100 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
     FacCPedi.LugEnt AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 20
          LABEL "Lugar de entrega" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     FacCPedi.CodRef AT ROW 4.23 COL 100 COLON-ALIGNED WIDGET-ID 114
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.NroRef AT ROW 4.23 COL 105 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.NroCard AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 40
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FacCPedi.CodMon AT ROW 5.04 COL 102 NO-LABEL WIDGET-ID 46
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     BUTTON-10 AT ROW 5.85 COL 13
     FacCPedi.Sede AT ROW 5.85 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-sede AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FacCPedi.FlgIgv AT ROW 5.85 COL 102 WIDGET-ID 58
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
     FacCPedi.CodVen AT ROW 6.65 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-nOMvEN AT ROW 6.65 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.FmaPgo AT ROW 7.46 COL 16 COLON-ALIGNED
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-CndVta AT ROW 7.46 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.CodAlm AT ROW 8.27 COL 16 COLON-ALIGNED WIDGET-ID 60
          LABEL "Almacén Despacho"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 8 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     f-NomAlm AT ROW 8.27 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FacCPedi.Glosa AT ROW 9.08 COL 13.28 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
          BGCOLOR 11 FGCOLOR 0 
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.31 COL 95 WIDGET-ID 54
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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         WIDTH              = 131.14.
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
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.FlgIgv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Sede IN FRAME F-Main
   NO-ENABLE                                                            */
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
      /* Bloqueamos Cabeceras */
      FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
          AND PEDIDO.coddoc = Faccpedi.codref
          AND PEDIDO.nroped = Faccpedi.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDIDO THEN DO:
          pMensaje = "NO se pudo extornar el " + PEDIDO.codref + " " + PEDIDO.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
          
      FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
          AND COTIZACION.coddoc = PEDIDO.codref
          AND COTIZACION.nroped = PEDIDO.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE COTIZACION THEN DO:
          pMensaje = "NO se pudo extornar la " + COTIZACION.codref + " " + COTIZACION.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      
      /* Actualizamos saldo de cotización */
      FOR EACH Facdpedi OF Faccpedi NO-LOCK:
          FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
              AND B-DPEDI.coddoc = COTIZACION.coddoc
              AND B-DPEDI.nroped = COTIZACION.nroped
              AND B-DPEDI.codmat = Facdpedi.codmat
              AND B-DPEDI.libre_c05 = Facdpedi.libre_c05
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-DPEDI THEN ASSIGN B-DPEDI.canate = B-DPEDI.canate - Facdpedi.canped.
      END.
      ASSIGN
          COTIZACION.FlgEst = "P".
      /* Borramos detalles */
      FOR EACH Facdpedi OF PEDIDO:
          DELETE Facdpedi.
      END.
      /* ************************************ */
      /* RHC 13/03/2020 Log de Modificaciones */
      /* ************************************ */
      FOR EACH PEDI NO-LOCK, FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.CodMat = PEDI.CodMat
          AND Facdpedi.CanPed <> PEDI.CanPed:
          CREATE LogTabla.
          ASSIGN
              logtabla.codcia = s-CodCia
              logtabla.Dia = TODAY
              logtabla.Evento = 'CORRECCION'
              logtabla.Hora = STRING(TIME, 'HH:MM:SS')
              logtabla.Tabla = 'FACDPEDI'
              logtabla.Usuario = s-User-Id
              logtabla.ValorLlave = Facdpedi.CodDoc + '|' +
                                      Facdpedi.NroPed + '|' +
                                      Facdpedi.CodMat + '|' +
                                      STRING(Facdpedi.CanPed) + '|' +
                                      STRING(PEDI.CanPed).
      END.
      FOR EACH Facdpedi OF Faccpedi NO-LOCK:
          FIND FIRST PEDI WHERE PEDI.CodMat = Facdpedi.CodMat NO-LOCK NO-ERROR.
          IF AVAILABLE PEDI THEN NEXT.
          CREATE LogTabla.
          ASSIGN
              logtabla.codcia = s-CodCia
              logtabla.Dia = TODAY
              logtabla.Evento = 'CORRECCION'
              logtabla.Hora = STRING(TIME, 'HH:MM:SS')
              logtabla.Tabla = 'FACDPEDI'
              logtabla.Usuario = s-User-Id
              logtabla.ValorLlave = Facdpedi.CodDoc + '|' +
                                      Facdpedi.NroPed + '|' +
                                      Facdpedi.CodMat + '|' +
                                      STRING(Facdpedi.CanPed) + '|' +
                                      STRING(0.00).
      END.
      /* ************************************ */
      FOR EACH Facdpedi OF Faccpedi:
          DELETE Facdpedi.
      END.
  END.
  RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Rb V-table-Win 
PROCEDURE Carga-Temporal-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Reporte.
/* NO KITS */
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = FacDPedi.CodMat:
    FIND FIRST Almckits OF Facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almckits THEN NEXT.
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = FacCPedi.CodDoc
        Reporte.NroPed = FacCPedi.NroPed
        Reporte.CodRef = FacCPedi.CodRef
        Reporte.NroRef = FacCPedi.NroRef
        Reporte.CodMat = FacDPedi.CodMat
        Reporte.DesMat = Almmmatg.DesMat
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = FacDPedi.CanPed * FacDPedi.Factor
        Reporte.CodAlm = FacCPedi.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
        AND Almmmate.CodAlm = FacDPedi.AlmDes
        AND Almmmate.CodMat = FacDPedi.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        ASSIGN 
            Reporte.CodUbi = Almmmate.CodUbi.
        FIND Almtubic WHERE Almtubic.codcia = s-codcia
            AND Almtubic.codubi = Almmmate.codubi
            AND Almtubic.codalm = Almmmate.codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
    END.
END.
/* SOLO KITS */
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almckits OF Facdpedi NO-LOCK,
    EACH Almdkits OF Almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = AlmDKits.codmat2:
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = FacCPedi.CodDoc
        Reporte.NroPed = FacCPedi.NroPed
        Reporte.CodRef = FacCPedi.CodRef
        Reporte.NroRef = FacCPedi.NroRef
        Reporte.CodMat = Almmmatg.CodMat
        Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad
        Reporte.CodAlm = FacCPedi.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
        AND Almmmate.CodAlm = FacDPedi.AlmDes
        AND Almmmate.CodMat = Almmmatg.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        ASSIGN 
            Reporte.CodUbi = Almmmate.CodUbi.
        FIND Almtubic WHERE Almtubic.codcia = s-codcia
            AND Almtubic.codubi = Almmmate.codubi
            AND Almtubic.codalm = Almmmate.codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb V-table-Win 
PROCEDURE Formato-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv no-lock.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-500 V-table-Win 
PROCEDURE Formato-Rb-500 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv no-lock.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    

DEFINE FRAME f-cab
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NomCia + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN4} + {&PRN7A} + {&PRN6B} + "        Pagina: " + STRING(PAGE-NUMBER(REPORT), "ZZ9") + "/" + STRING(npage, "ZZ9") + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(40)" AT 80 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " + STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(27)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6A} + "       Hora: " + STRING(TIME,"HH:MM") + {&PRN6B} FORMAT "X(22)" SKIP
        {&PRN4} + {&PRN6A} + "  Dirección: " + x-Direccion + {&PRN6B} FORMAT "X(120)" SKIP
        "Ubicación  Código  Descripción                                                    Marca                  Unidad      Cantidad Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     1234567890 9999999 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234 1234 >>,>>>,>>9.9999 ________________________ */
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY SUBSTRING(Reporte.CodUbi,1,2) BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodUbi
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF LAST-OF(SUBSTRING(Reporte.CodUbi,1,2)) THEN DO:
        DOWN STREAM Report 1 WITH FRAME f-cab.
    END.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

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
   DEFINE VARIABLE r-Rowid AS ROWID NO-UNDO.

   rloop:
   DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Bloqueamos Cabeceras */
       FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
           AND PEDIDO.coddiv = Faccpedi.coddiv
           AND PEDIDO.coddoc = Faccpedi.codref
           AND PEDIDO.nroped = Faccpedi.nroref
           EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE PEDIDO THEN DO:
           pMensaje = "NO se pudo actualizar el " + PEDIDO.codref + " " + PEDIDO.nroref.
           UNDO, RETURN 'ADM-ERROR'.
       END.

       FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
           AND COTIZACION.coddiv = PEDIDO.coddiv
           AND COTIZACION.coddoc = PEDIDO.codref
           AND COTIZACION.nroped = PEDIDO.nroref
           EXCLUSIVE-LOCK NO-ERROR.
       IF ERROR-STATUS:ERROR = YES THEN DO:
           pMensaje = "NO se pudo actualizar la " + COTIZACION.codref + " " + COTIZACION.nroref.
           UNDO, RETURN 'ADM-ERROR'.
       END.

       FOR EACH PEDI BY PEDI.NroItm:
           /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
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
               FacDPedi.CanSol  = FacDPedi.CanPed
               FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */
       END.
       /* Regeneramos PEDIDO */
       FOR EACH Facdpedi OF Faccpedi NO-LOCK:
           CREATE B-DPEDI.
           BUFFER-COPY Facdpedi
               TO B-DPEDI
               ASSIGN
               B-DPEDI.coddiv = PEDIDO.coddiv
               B-DPEDI.coddoc = PEDIDO.coddoc
               B-DPEDI.fchped = PEDIDO.fchped
               B-DPEDI.nroped = PEDIDO.nroped.
           ASSIGN
               B-DPEDI.canate = B-DPEDI.canped.
       END.

       ASSIGN r-Rowid = ROWID(Faccpedi).
       RUN Recalcula-Pedido.
       FIND Faccpedi WHERE ROWID(Faccpedi) = r-Rowid.

       /* Actualizamos la cotización  */
       FOR EACH Facdpedi OF Faccpedi NO-LOCK:
           FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
               AND B-DPEDI.coddoc = COTIZACION.coddoc
               AND B-DPEDI.nroped = COTIZACION.nroped
               AND B-DPEDI.codmat = Facdpedi.codmat
               AND B-DPEDI.libre_c05 = Facdpedi.libre_c05
               EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE B-DPEDI THEN DO:
               ASSIGN B-DPEDI.canate = B-DPEDI.canate + Facdpedi.canped.
               /* CONTROL DE ATENCIONES */
               IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
                   MESSAGE 'Se ha detectado un error en el producto ' B-DPEDI.codmat SKIP
                       'Los despachos superan a lo cotizado' SKIP
                       'Cant. cotizada: ' B-DPEDI.CanPed SKIP
                       'Total pedidos : ' B-DPEDI.CanAte SKIP
                       'FIN DEL PROCESO'.
                   UNDO RLOOP, RETURN "ADM-ERROR".
               END.
           END.
       END.
       FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
           AND B-DPEDI.coddoc = COTIZACION.coddoc
           AND B-DPEDI.nroped = COTIZACION.nroped
           AND B-DPEDI.CanAte < B-DPEDI.CanPed NO-LOCK NO-ERROR.
       IF NOT AVAILABLE B-DPEDI THEN ASSIGN COTIZACION.FlgEst = "C".
   END.
   RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Transportista V-table-Win 
PROCEDURE Imprimir-Transportista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.

RUN vta2/imprime-transportista ( Faccpedi.codcia,
                                 Faccpedi.coddiv,
                                 Faccpedi.coddoc,
                                 Faccpedi.nroped,
                                 Faccpedi.codcli,
                                 Faccpedi.nomcli).

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

DEF VAR pOrden AS CHAR INIT "ZONA" NO-UNDO.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" THEN RUN Formato-Rb.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2.
      END CASE.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Rutina relacionada vta2/pcreaordendesp.p
  
  SOLO SE VA A MODIFICAR LA ORDEN DE DESPACHO
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      FacCPedi.Libre_C02 = s-user-id + '|' + STRING(DATETIME(TODAY,MTIME)).
  
  RUN Borra-Pedido.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  {vta2/graba-totales-cotizacion-cred.i}

  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
  IF AVAILABLE(COTIZACION) THEN RELEASE COTIZACION.

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
    /* RHC LA ANULACION QUEDA A CARGO DEL ENCARGADO DE DISTRIBUCION/ALMACENES */
    MESSAGE 'LA ANULACIÓN ESTÁ A CARGO DEL AREA DE DISTRIBUCION/ALMACENES' SKIP
        'Proceso abortado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".

/*     IF FacCPedi.FlgEst <> "P" THEN DO:                                                           */
/*         MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.                                     */
/*         RETURN "ADM-ERROR".                                                                      */
/*     END.                                                                                         */
/*     FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.                  */
/*     IF AVAILABLE Facdpedi THEN DO:                                                               */
/*         MESSAGE "No puede modificar una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR. */
/*         RETURN "ADM-ERROR".                                                                      */
/*     END.                                                                                         */
/*     IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "P" THEN DO:                                  */
/*         MESSAGE "La orden ya está con PICKING" SKIP                                              */
/*             'Continuamos con la anulación?'                                                      */
/*             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO                                            */
/*             UPDATE rpta-1 AS LOG.                                                                */
/*         IF rpta-1 = NO THEN RETURN "ADM-ERROR".                                                  */
/*     END.                                                                                         */
/*     IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C" THEN DO:                                  */
/*         MESSAGE "La orden ya está con CHEQUEO DE BARRAS" SKIP                                    */
/*             'Continuamos con la anulación?'                                                      */
/*             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO                                            */
/*             UPDATE rpta-2 AS LOG.                                                                */
/*         IF rpta-2 = NO THEN RETURN "ADM-ERROR".                                                  */
/*     END.                                                                                         */
/*                                                                                                  */
/*     {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}                                                  */
/*                                                                                                  */
/*     DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":                       */
/*        RUN Actualiza-Pedido (-1).                                                                */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                              */
/*        RUN vtagn/pTracking-04 (Faccpedi.CodCia,                                                  */
/*                                Faccpedi.CodDiv,                                                  */
/*                                Faccpedi.CodRef,                                                  */
/*                                Faccpedi.NroRef,                                                  */
/*                                s-User-Id,                                                        */
/*                                'GOD',                                                            */
/*                                'A',                                                              */
/*                                DATETIME(TODAY, MTIME),                                           */
/*                                DATETIME(TODAY, MTIME),                                           */
/*                                Faccpedi.CodDoc,                                                  */
/*                                Faccpedi.NroPed,                                                  */
/*                                Faccpedi.CodRef,                                                  */
/*                                Faccpedi.NroRef).                                                 */
/*        FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.              */
/*        IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.                                   */
/*        ASSIGN                                                                                    */
/*            B-CPedi.FlgEst = "A"                                                                  */
/*            B-CPedi.Glosa = " A N U L A D O".                                                     */
/*        RELEASE B-CPedi.                                                                          */
/*     END.                                                                                         */
/*                                                                                                  */
/*     RUN Procesa-Handle IN lh_Handle ('browse').                                                  */
/*     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).                                         */
    
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

      f-NomAlm:SCREEN-VALUE = "".
      FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN f-NomAlm:SCREEN-VALUE = Almacen.Descripcion.

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
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
  IF AVAILABLE(COTIZACION) THEN RELEASE COTIZACION.
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-Pedido V-table-Win 
PROCEDURE Recalcula-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND Faccpedi OF PEDIDO EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

{vta2/graba-totales-cotizacion-cred.i}

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
  
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

RUN vtagn/p-tpoped ( ROWID(Faccpedi) ).
IF RETURN-VALUE = "LF" THEN DO:
    MESSAGE 'Orden De Despacho por LISTA EXPRESS' SKIP 
        'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* RHC 19/02/2048 */
IF Faccpedi.CrossDocking = YES THEN DO:
    MESSAGE 'Viene de un Cross Docking por Cliente' SKIP 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF Faccpedi.FlgSit = "T" THEN DO:
    /* NO se puede modificar mientras esté en almacenes (Picking) */
    MESSAGE "No puede modificar una orden que falta Pickear el Almacén" VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "P" THEN DO:
    /* Veamos si es verdad */
/*     FIND FIRST AlmDDocu WHERE AlmDDocu.CodCia = Faccpedi.codcia    */
/*         AND AlmDDocu.CodLlave = "PPICKING"                         */
/*         AND AlmDDocu.CodDoc = Faccpedi.coddoc                      */
/*         AND AlmDDocu.NroDoc = Faccpedi.nroped                      */
/*         NO-LOCK NO-ERROR.                                          */
/*     IF AVAILABLE Almddocu THEN DO:                                 */
/*         MESSAGE "La orden ya pasó por CHEQUEO DE PRE-PICKING" SKIP */
/*             VIEW-AS ALERT-BOX WARNING.                             */
/*         RETURN "ADM-ERROR".                                        */
/*     END.                                                           */
END.
IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C" THEN DO:
    MESSAGE "La orden ya pasó por CONTROL DE BARRAS" SKIP
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
IF AVAILABLE Facdpedi THEN DO:
    MESSAGE "No puede modificar una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

ASSIGN
    s-PorIgv = FacCPedi.PorIgv
    s-CodCli = FacCPedi.CodCli.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

