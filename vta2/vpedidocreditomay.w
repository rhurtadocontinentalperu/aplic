&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE Facdpedi.



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
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE s-codref   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE SHARED VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE SHARED VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE SHARED VARIABLE s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VARIABLE S-TPOPED AS CHAR.
DEFINE SHARED VARIABLE S-TPOPED2 AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE s-FlgIgv LIKE Faccpedi.FlgIgv.
DEFINE SHARED VARIABLE s-FmaPgo AS CHAR.
DEFINE SHARED VARIABLE s-NroDec AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE T-SALDO     AS DECIMAL.
DEFINE VARIABLE F-totdias   AS INTEGER NO-UNDO.
DEFINE VARIABLE s-FlgEnv AS LOG NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.

DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.
DEFINE BUFFER B-MATG  FOR Almmmatg.

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

/* MENSAJES DE ERROR Y DEL SISTEMA */
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensajeFinal AS CHAR NO-UNDO.

DEFINE VAR pNroCotizacion AS CHAR.
DEFINE VAR pFechaEntrega AS DATE.

/* CONTROL DE CLIENTES POR DIA */
DEF TEMP-TABLE T-CLIENTE
    FIELD CodCli AS CHAR FORMAT 'x(11)'.

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
&Scoped-define EXTERNAL-TABLES Faccpedi
&Scoped-define FIRST-EXTERNAL-TABLE Faccpedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Faccpedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.FaxCli FacCPedi.CodCli ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.fchven FacCPedi.NomCli ~
FacCPedi.FchEnt FacCPedi.DirCli FacCPedi.Cmpbnte FacCPedi.LugEnt ~
FacCPedi.CodMon FacCPedi.NroCard FacCPedi.TpoCmb FacCPedi.Sede ~
FacCPedi.FlgIgv FacCPedi.CodPos FacCPedi.NroRef FacCPedi.CodVen ~
FacCPedi.ordcmp FacCPedi.FmaPgo FacCPedi.CodAlm FacCPedi.Libre_c03 ~
FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FaxCli ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.RucCli FacCPedi.Atencion ~
FacCPedi.fchven FacCPedi.NomCli FacCPedi.FchEnt FacCPedi.DirCli ~
FacCPedi.Cmpbnte FacCPedi.LugEnt FacCPedi.CodMon FacCPedi.NroCard ~
FacCPedi.TpoCmb FacCPedi.Sede FacCPedi.FlgIgv FacCPedi.CodPos ~
FacCPedi.NroRef FacCPedi.CodVen FacCPedi.ordcmp FacCPedi.FmaPgo ~
FacCPedi.usuario FacCPedi.CodAlm FacCPedi.Libre_c03 FacCPedi.Glosa ~
FacCPedi.TpoLic 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-Lista F-Nomtar ~
FILL-IN-sede FILL-IN-CodPos f-NomVen F-CndVta f-NomAlm 

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
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista Precios" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 16 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1 COL 39 COLON-ALIGNED NO-LABEL
     FacCPedi.FaxCli AT ROW 1 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 120 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FacCPedi.FchPed AT ROW 1 COL 99 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.81 COL 16 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.RucCli AT ROW 1.81 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 1.81 COL 49 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-Lista AT ROW 1.81 COL 74 COLON-ALIGNED WIDGET-ID 124
     FacCPedi.fchven AT ROW 1.81 COL 99 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NomCli AT ROW 2.62 COL 16 COLON-ALIGNED FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 71 BY .81
     FacCPedi.FchEnt AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 3.42 COL 16 COLON-ALIGNED
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 71 BY .81
     FacCPedi.Cmpbnte AT ROW 3.42 COL 101 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FAC", "FAC":U,
"BOL", "BOL":U
          SIZE 13 BY .81
     FacCPedi.LugEnt AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 20
          LABEL "Lugar de entrega" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 71 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodMon AT ROW 4.23 COL 101 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 15 BY .81
     FacCPedi.NroCard AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 14
          LABEL "Nro. Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-Nomtar AT ROW 5.04 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FacCPedi.TpoCmb AT ROW 5.04 COL 99 COLON-ALIGNED
          LABEL "Tipo de cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Sede AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-sede AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FacCPedi.FlgIgv AT ROW 5.85 COL 101 WIDGET-ID 108
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
     FacCPedi.CodPos AT ROW 6.58 COL 16 COLON-ALIGNED WIDGET-ID 126
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-CodPos AT ROW 6.58 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FacCPedi.NroRef AT ROW 6.65 COL 99 COLON-ALIGNED WIDGET-ID 10
          LABEL "Cotizacion"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 4 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.CodVen AT ROW 7.35 COL 16 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     f-NomVen AT ROW 7.35 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.ordcmp AT ROW 7.46 COL 99 COLON-ALIGNED
          LABEL "O/Compra" FORMAT "X(20)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .81
     FacCPedi.FmaPgo AT ROW 8.12 COL 16 COLON-ALIGNED
          LABEL "Condición de Venta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 8.12 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.usuario AT ROW 8.27 COL 99 COLON-ALIGNED WIDGET-ID 34
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodAlm AT ROW 8.88 COL 16 COLON-ALIGNED WIDGET-ID 110
          LABEL "Almacén Despacho"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 8 FGCOLOR 0 
     f-NomAlm AT ROW 8.88 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FacCPedi.Libre_c03 AT ROW 9.08 COL 99 COLON-ALIGNED WIDGET-ID 130
          LABEL "Bol. Depósito" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.Glosa AT ROW 9.65 COL 13.28 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
     FacCPedi.TpoLic AT ROW 9.88 COL 101 WIDGET-ID 118
          LABEL "APLICAR ADELANTOS"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .77
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.69 COL 91 WIDGET-ID 106
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.5 COL 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Faccpedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL Facdpedi
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
         HEIGHT             = 9.96
         WIDTH              = 119.29.
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
/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-CodPos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Lista IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.TpoLic IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
    /*MESSAGE 'NO debería pasar por LEAVE Faccpedi.codcli'.*/
    /* RHC 12/01/17 Buscamos su código postal por defecto */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
            AND TabDistr.CodProvi = gn-clie.CodProv 
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN FacCPedi.CodPos:SCREEN-VALUE = TabDistr.CodPos.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodPos V-table-Win
ON LEAVE OF FacCPedi.CodPos IN FRAME F-Main /* Postal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND Almtabla WHERE almtabla.Tabla = "CP"
      AND almtabla.Codigo = FacCPedi.CodPos:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-CodPos:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = Faccpedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NomCli V-table-Win
ON LEAVE OF FacCPedi.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TpoCmb V-table-Win
ON LEAVE OF FacCPedi.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
    S-TPOCMB = DEC(Faccpedi.TpoCmb:SCREEN-VALUE).
    
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

  EMPTY TEMP-TABLE PEDI.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF'    /* SIN PROMOCIONES */
      BREAK BY Facdpedi.codmat:
      CREATE PEDI.
      BUFFER-COPY Facdpedi TO PEDI.
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
  {src/adm/template/row-list.i "Faccpedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Faccpedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Cotizacion V-table-Win 
PROCEDURE Asigna-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

    Modificó    : Miguel Landeo /*ML01*/
    Fecha       : 13/Nov/2009
    Objetivo    : Captura Múltiplo configurado por artículo - cliente.
  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.

  EMPTY TEMP-TABLE PEDI.

  i-NPedi = 0.

  /* VERIFICACION DE LOS SALDOS DE LA COTIZACION */
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0:
      IF Facdpedi.CanAte < 0 THEN DO:   /* HAY UN NEGATIVO */
          MESSAGE 'Hay una incosistencia el el producto:' Facdpedi.codmat SKIP
              'Avisar a sistemas' SKIP(2)
              'Proceso abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* PRIMERA PASADA: CARGAMOS STOCK DISPONIBLE */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DETALLES:
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
      FIRST Almmmatg OF Facdpedi NO-LOCK
      BY Facdpedi.NroItm:
      DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      /* BARREMOS LOS ALMACENES VALIDOS Y DECIDIMOS CUAL ES EL MEJOR DESPACHO */
      /* RHC AHORA ES UN SOLO ALMACEN */
      f-Factor = Facdpedi.Factor.
      t-AlmDes = ''.
      t-CanPed = 0.
      ALMACENES:
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
          x-CodAlm = ENTRY(i, s-CodAlm).
          /* FILTROS */
          FIND Almmmate WHERE Almmmate.codcia = s-codcia
              AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
              AND Almmmate.codmat = Facdpedi.CodMat
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmate THEN DO:
              MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén' x-CodAlm
                  VIEW-AS ALERT-BOX WARNING.
              IF B-CPEDI.TpoPed = "LF" THEN RETURN 'ADM-ERROR'.
              NEXT ALMACENES.
          END.
          x-StkAct = Almmmate.StkAct.
          RUN vta2/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido.
          
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis <= 0 THEN DO:
              /* RHC 04/02/2016 Solo en caso de LISTA EXPRESS */
              IF B-CPEDI.TpoPed = "LF" THEN DO:
                  MESSAGE 'Producto ' Facdpedi.codmat 'NO tiene Stock en el almacén ' x-CodAlm SKIP
                      'Abortamos la generación del Pedido?'
                      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta AS LOG.
                  IF rpta = YES THEN RETURN "ADM-ERROR".
              END.
              ELSE DO:
                  MESSAGE 'Producto ' Facdpedi.codmat 'NO tiene Stock en el almacén ' x-CodAlm
                        VIEW-AS ALERT-BOX WARNING.
              END.
              NEXT ALMACENES.
          END.
          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
          END.
          /* EMPAQUE SUPERMERCADOS */
          FIND FIRST supmmatg WHERE supmmatg.codcia = B-CPedi.CodCia
              AND supmmatg.codcli = B-CPedi.CodCli
              AND supmmatg.codmat = FacDPedi.codmat 
              NO-LOCK NO-ERROR.
          f-CanPed = f-CanPed * f-Factor.
          
          IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
              f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
          END.
          ELSE DO:    /* EMPAQUE OTROS */
              IF s-FlgEmpaque = YES THEN DO:
                  IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
              END.
          END.
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
          
          IF f-CanPed <= 0 THEN NEXT ALMACENES.
          IF f-CanPed > t-CanPed THEN DO:
              t-CanPed = f-CanPed.
              t-AlmDes = x-CodAlm.
          END.
      END.
      IF t-CanPed > 0 THEN DO:
          /* GRABACION */
          I-NPEDI = I-NPEDI + 1.
          CREATE PEDI.
          BUFFER-COPY FacDPedi 
              EXCEPT Facdpedi.CanSol Facdpedi.CanApr
              TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = s-coddoc
                  PEDI.NroPed = ''
                  PEDI.CodCli = B-CPEDI.CodCli
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          /* RHC 28/04/2016 Caso extraño */
          IF PEDI.CanPed > PEDI.Libre_d01 
              THEN ASSIGN PEDI.CanPed = PEDI.Libre_d01 PEDI.Libre_d02 = PEDI.Libre_d01.
          /* *************************** */
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
              ASSIGN
                  PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                                ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[3] / 100 ).
              IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
              THEN PEDI.ImpDto = 0.
              ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
              ASSIGN
                  PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
                  PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
              IF PEDI.AftIsc 
                  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
              IF PEDI.AftIgv 
                  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
          END.
          /* FIN DE CARGA */
      END.
  END.
  HIDE FRAME F-Mensaje.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Datos V-table-Win 
PROCEDURE Asigna-Datos :
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
       MESSAGE 'Pedido vencido' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
    END.
    IF LOOKUP (FacCPedi.FlgEst,"X,G,P") > 0 THEN DO:
        RUN vta/w-agtrans-02 (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).
    END.

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
  DEF INPUT PARAMETER p-Ok AS LOG.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH Facdpedi OF Faccpedi:
          IF p-Ok = YES THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */
      END.    
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Despachar-Pedido V-table-Win 
PROCEDURE Despachar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
IF Faccpedi.flgest <> "G" THEN RETURN.
/* LISTA EXPRESS */
FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia
    AND COTIZACION.coddiv = Faccpedi.coddiv
    AND COTIZACION.coddoc = Faccpedi.codref
    AND COTIZACION.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE COTIZACION AND COTIZACION.TpoPed = "LF" AND COTIZACION.FlgEst <> "C" 
    THEN DO:
    MESSAGE 'PEDIDO LISTA EXPRESS' SKIP 'NO se puede despachar parciales'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'El Pedido está listo para ser despachado' SKIP
      'Continuamos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/* Cliente */
FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = Faccpedi.codcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-clie THEN DO:
    MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Revisar datos del Transportista */
FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
    AND Ccbadocu.coddiv = Faccpedi.coddiv
    AND Ccbadocu.coddoc = Faccpedi.coddoc
    AND Ccbadocu.nrodoc = Faccpedi.nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbadocu THEN DO:
    MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP
        'Continuamos?'
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN.
END.
/* RHC 08/02/2016 Consolidar en OTR */
DEF VAR x-FlgSit AS CHAR INIT "" NO-UNDO.
/*
IF Faccpedi.coddiv = '00015' AND Faccpedi.codalm = '21' THEN DO:
    MESSAGE 'Consolidamos el pedido en Orden de Transferencia (OTR) para ATE?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta-2 AS LOG.
    IF rpta-2 = YES THEN x-FlgSit = "O".    /* es la letra "o", no es cero */
END.
*/
/* ********************************* */
DEF VAR pMensaje AS CHAR NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN LEAVE.
    IF Faccpedi.flgest <> "G" THEN DO:
        MESSAGE 'El Pedido ya fue aprobado por:' SKIP
            'Usuario:' FacCPedi.UsrAprobacion SKIP
            'Fecha:' FacCPedi.FchAprobacion SKIP(1)
            'Proceso abortado'
            VIEW-AS ALERT-BOX WARNING.
        LEAVE RLOOP.
    END.
    /* VERIFICAMOS DEUDA DEL CLIENTE */
    {vta2/verifica-cliente-01.i &VarMensaje = pMensaje}
    
    IF Faccpedi.FlgEst = "X" THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO pasó la línea de crédito".
        LEAVE RLOOP.
    END.
    /* VERIFICAMOS MARGEN DE UTILIDAD */
    IF LOOKUP(s-CodDiv, '00000,00017,00018') > 0 THEN DO:
        {vta2/i-verifica-margen-utilidad-1.i}
        IF Faccpedi.FlgEst = "W" THEN DO:
            pMensaje = FacCPedi.Libre_c05.
            LEAVE RLOOP.
        END.
    END.
    /* CREAMOS LA ORDEN */
    pMensaje = "".
    /* RHC 14/11/2016 Se puede crear una O/D o una OTR */
    IF CAN-FIND(FIRST VtaTabla WHERE VtaTabla.CodCia = COTIZACION.codcia
                AND VtaTabla.Tabla = 'EXPOCOT'
                AND VtaTabla.Llave_c1 = COTIZACION.libre_c01
                AND VtaTabla.Llave_c2 = COTIZACION.coddoc
                AND VtaTabla.LLave_c3 = COTIZACION.nroped
                AND VtaTabla.Llave_c4 = COTIZACION.coddiv 
                NO-LOCK) THEN DO:
        RUN vta2/pcreaordentransf ( ROWID(Faccpedi), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
        ASSIGN
            FacCPedi.FlgEst = "O".  /* Con OTR */
        x-FlgSit = "O".
    END.
    ELSE DO:
        RUN vta2/pcreaordendesp ( ROWID(Faccpedi), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
        x-FlgSit = "".
    END.
    /* MARCAMOS EL PEDIDO */
    ASSIGN
        Faccpedi.FlgSit = x-FlgSit.
END.
FIND CURRENT Faccpedi NO-LOCK.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE cColumn AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iRow AS INTEGER NO-UNDO INITIAL 1.

    DEFINE VARIABLE cNomCli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomVen AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMoneda AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomCon AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOrdCom AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPreUni LIKE FacDPedi.Preuni NO-UNDO.
    DEFINE VARIABLE dImpLin LIKE FacDPedi.ImpLin NO-UNDO.
    DEFINE VARIABLE dImpTot LIKE FacCPedi.ImpTot NO-UNDO.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    IF FacCpedi.FlgIgv THEN DO:
       dImpTot = FacCPedi.ImpTot.
    END.
    ELSE DO:
       dImpTot = FacCPedi.ImpVta.
    END.

    FIND gn-ven WHERE 
         gn-ven.CodCia = FacCPedi.CodCia AND  
         gn-ven.CodVen = FacCPedi.CodVen 
         NO-LOCK NO-ERROR.
    cNomVen = FacCPedi.CodVen.
    IF AVAILABLE gn-ven THEN cNomVen = cNomVen + " - " + gn-ven.NomVen.
    FIND gn-clie WHERE 
         gn-clie.codcia = cl-codcia AND  
         gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
    cNomCli  = FacCPedi.CodCli + ' - ' + FaccPedi.Nomcli.

    IF FacCPedi.coddoc = "PED" THEN 
        cOrdCom = "Orden de Compra : ".
    ELSE 
        cOrdCom = "Solicitud Cotiz.: ".

    FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    cNomCon = FacCPedi.FmaPgo.
    IF AVAILABLE gn-ConVt THEN cNomCon = gn-ConVt.Nombr.

    IF FacCpedi.Codmon = 2 THEN cMoneda = "DOLARES US$.".
    ELSE cMoneda = "SOLES   S/. ".

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* set the column names for the Worksheet */
    chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):ColumnWidth = 11.43.
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 45.
    chWorkSheet:COLUMNS("C"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):ColumnWidth = 14.

    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Número:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = FacCPedi.NroPed.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Fecha:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.fchped. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cliente:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomCli. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Vencimiento:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.fchven. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Dirección :". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = gn-clie.dircli. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Tpo. Cambio:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = FacCPedi.Tpocmb. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "R.U.C.:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = gn-clie.ruc. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Vendedor:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomVen.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cOrdCom.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.ordcmp. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cond.Venta:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomCon. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Moneda:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cMoneda. 

    iRow = iRow + 2.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "No".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Artículo".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Descripción".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Marca".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Unidad".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Alm Des".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cant. Solicitada".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cant. Aprobada".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "% Descto".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Precio Unitario".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Importe".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    FOR EACH b-facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF b-facdpedi NO-LOCK
        BREAK BY b-facdpedi.NroPed BY b-facdpedi.NroItm:
        IF FacCpedi.FlgIgv THEN DO:
            dPreUni = b-facdpedi.PreUni.
            dImpLin = b-facdpedi.ImpLin. 
        END.
        ELSE DO:
            dPreUni = ROUND(b-facdpedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
            dImpLin = ROUND(b-facdpedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
        END.  
        iRow = iRow + 1.
        cColumn = STRING(iRow).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = STRING(b-facdpedi.nroitm, '>>>9').
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.codmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almmmatg.desmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almmmatg.desmar.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.undvta.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.almdes.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.canped.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.canate.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.pordto.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dPreUni.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dImpLin.
    END.

    iRow = iRow + 2.
    cColumn = STRING(iRow).
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NETO A PAGAR:" + cMoneda.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = dImpTot.
    /* PERCEPCION */
    IF Faccpedi.acubon[5] > 0 THEN DO:
        iRow = iRow + 4.
        cColumn = STRING(iRow).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
            (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
            TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas V-table-Win 
PROCEDURE Facturas-Adelantadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-saldo-mn AS DEC NO-UNDO.
  DEFINE VARIABLE x-saldo-me AS DEC NO-UNDO.


  GetLock:
  REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, RETRY GetLock:
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN LEAVE.
  END.
  ASSIGN
      x-saldo-mn = 0
      x-saldo-me = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
      AND Ccbcdocu.codcli = Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C":
      IF Ccbcdocu.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + Ccbcdocu.SdoAct.
      ELSE x-saldo-me = x-saldo-me + Ccbcdocu.SdoAct.
  END.
  /* RHC 09/02/17 Luis Urbano solo para condciones de pago 403 */
  IF LOOKUP(Faccpedi.FmaPgo,'403,391') > 0 
      AND x-saldo-mn > 0 OR x-saldo-me > 0 THEN DO:
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' x-saldo-mn SKIP
          'Por aplicar DOLARES:' x-saldo-me SKIP(1)
          'Aplicamos automáticamente a la factura?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = YES THEN FacCPedi.TpoLic = YES.
      ELSE FacCPedi.TpoLic = NO.
  END.
  FIND CURRENT Faccpedi NO-LOCK.

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

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE f-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.
  
  RUN vta2/promocion-generalv2 (COTIZACION.Libre_c01,   /* División Lista Precio */
                                Faccpedi.CodCli,
                                INPUT-OUTPUT TABLE PEDI, 
                                OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
  DETALLES:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = Almmmate.StkAct.
      RUN vta2/Stock-Comprometido-v2 (PEDI.CodMat, PEDI.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensajeFinal = pMensajeFinal + CHR(10) +
              'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
              'en el almacén ' + PEDI.AlmDes + CHR(10).
          /*IF COTIZACION.TpoPed = "LF" THEN RETURN "ADM-ERROR".      /* Lista Express */*/
          /* OJO: NO DESPACHAR */
          PEDI.CanPed = 0.  /* << OJO << */
          NEXT DETALLES.    /* << OJO << */
      END.
      /* **************************************************************************************** */
      f-Factor = PEDI.Factor.
      x-CanPed = PEDI.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
/*           IF COTIZACION.TpoPed = "LF" THEN DO:       /* Lista Express */    */
/*                 pMensajeFinal = pMensajeFinal +                             */
/*                 'No hay STOCK suficiente para el producto ' + PEDI.codmat + */
/*                 'en el almacén ' + PEDI.AlmDes + CHR(10).                   */
/*               RETURN "ADM-ERROR".                                           */
/*           END.                                                              */
      END.
      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos de acuerdo a los multiplos */
          PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLES.
      END.
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
          AND supmmatg.codcli = FacCPedi.CodCli
          AND supmmatg.codmat = PEDI.codmat 
          NO-LOCK NO-ERROR.
      f-CanPed = PEDI.CanPed * f-Factor.

      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
      END.
      PEDI.CanPed = ( f-CanPed - ( f-CanPed MODULO f-Factor ) ) / f-Factor.
  END.
  /* RECALCULAMOS */
  FOR EACH PEDI:
      ASSIGN
          PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
          THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      IF PEDI.AftIgv 
          THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI WHERE PEDI.CanPed > 0, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NPEDI.
  END.
  
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* RHC 30/12/2015 

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.
  /* **************************** PROMOCIONES ESPECIALES  **************************** */
/*   IF TODAY <= 03/09/2014 AND B-CPedi.TpoPed = "N" THEN                        */
/*   RUN vta2/promociones-pedidos-cred-01a ("MITZY", INPUT-OUTPUT TABLE PEDI).   */
/*   IF TODAY <= 03/09/2014 AND B-CPedi.TpoPed = "N" THEN                        */
/*   RUN vta2/promociones-pedidos-cred-01a ("AVENGER", INPUT-OUTPUT TABLE PEDI). */
  /* ********************************************************************************* */

  /* RHC 05/05/2014 nueva rutina de promociones */
  /*RUN vta2/promocion-general (INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).*/
  FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
      AND COTIZACION.coddoc = Faccpedi.codref
      AND COTIZACION.nroped = Faccpedi.nroref
      NO-LOCK NO-ERROR.
  RUN vta2/promocion-generalv2 (COTIZACION.Libre_c01,   /* División Lista Precio */
                                INPUT-OUTPUT TABLE PEDI, 
                                OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  DETALLE:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = PEDI.UndVta
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtconv THEN DO:
          pMensaje = 'Se ha encontrado un problema con el producto ' + PEDI.codmat + CHR(10) +
              'No se encuentra definido su factor de equivalencia' + CHR(10) +
              'Unidad base en el catálogo: ' + Almmmatg.UndBas + CHR(10) +
              'Unidad de venta pedido:' + PEDI.UndVta.
          RETURN 'ADM-ERROR'.
      END.
      /*f-Factor = Almtconv.Equival / Almmmatg.FacEqu.*/
      f-Factor = Almtconv.Equival.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = Almmmate.StkAct.
      RUN vta2/Stock-Comprometido (PEDI.CodMat, PEDI.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensajeFinal = pMensajeFinal + 
              'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
              'en el almacén ' + PEDI.AlmDes + CHR(10).
          IF s-coddiv = "00506" THEN RETURN "ADM-ERROR".
          NEXT DETALLE.    /* << OJO << */
      END.
      /* **************************************************************************************** */
      x-CanPed = PEDI.CanPed * f-Factor.

      IF s-StkDis < x-CanPed THEN DO:
          IF s-coddiv = '00506' THEN DO:
                pMensajeFinal = pMensajeFinal + 
                'No hay STOCK suficiente para el producto ' + PEDI.codmat + 
                'en el almacén ' + PEDI.AlmDes + CHR(10).
              RETURN "ADM-ERROR".
          END.
      END.

      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos de acuerdo a los multiplos */
          PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLE.
          /* EMPAQUE SUPERMERCADOS */
          x-CanPed = PEDI.CanPed * f-Factor.
          FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
              AND supmmatg.codcli = FacCPedi.CodCli
              AND supmmatg.codmat = PEDI.codmat 
              NO-LOCK NO-ERROR.
          IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
              x-CanPed = (TRUNCATE((x-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
          END.
          ELSE DO:    /* EMPAQUE OTROS */
              IF s-FlgEmpaque = YES THEN DO:
                  IF Almmmatg.DEC__03 > 0 THEN x-CanPed = (TRUNCATE((x-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
              END.
          END.
          PEDI.CanPed = ( x-CanPed - ( x-CanPed MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLE.    /* << OJO << */
      END.
      /* FIN DE CONTROL DE AJUSTES */
      ASSIGN
          PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
          THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      IF PEDI.AftIgv 
          THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
      /* ************************************************************************************** */
/*       I-NPEDI = I-NPEDI + 1.                    */
/*       CREATE Facdpedi.                          */
/*       BUFFER-COPY PEDI                          */
/*           TO Facdpedi                           */
/*           ASSIGN                                */
/*               Facdpedi.CodCia = Faccpedi.CodCia */
/*               Facdpedi.CodDiv = Faccpedi.CodDiv */
/*               Facdpedi.coddoc = Faccpedi.coddoc */
/*               Facdpedi.NroPed = Faccpedi.NroPed */
/*               Facdpedi.FchPed = Faccpedi.FchPed */
/*               Facdpedi.Hora   = Faccpedi.Hora   */
/*               Facdpedi.FlgEst = Faccpedi.FlgEst */
/*               Facdpedi.NroItm = I-NPEDI.        */
  END.
  /* RHC 21/10/2013 Deben despacharse completos los items que han tenido 
  descuento por volumen por lineas y sublineas agrupados.
  Si no se pueden cubrir entonces NO se despachan */
/*   FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-codcia                                        */
/*       AND B-DPEDI.coddiv = s-coddiv                                                               */
/*       AND B-DPEDI.coddoc = Faccpedi.codref                                                        */
/*       AND B-DPEDI.nroped = Faccpedi.nroref                                                        */
/*       AND B-DPEDI.Libre_c04 = "DVXDSF",                                                           */
/*       FIRST B-MATG OF B-DPEDI NO-LOCK:                                                            */
/*       FIND FIRST PEDI WHERE PEDI.codmat = B-DPEDI.codmat NO-LOCK NO-ERROR.                        */
/*       IF NOT AVAILABLE PEDI OR PEDI.canped < B-DPEDI.canped THEN DO:                              */
/*           /* eliminamos toda la familia y subfamilia */                                           */
/*           FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK WHERE Almmmatg.codfam = B-MATG.codfam AND */
/*               Almmmatg.subfam = B-MATG.subfam:                                                    */
/*               DELETE PEDI.                                                                        */
/*           END.                                                                                    */
/*       END.                                                                                        */
/*   END.                                                                                            */

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NPEDI.
  END.
  
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.


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
  DEF VAR i AS INT NO-UNDO.

  DEF VAR lCotProg AS LOG.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  pNroCotizacion = "".

  EMPTY TEMP-TABLE PEDI.
  RUN vta2/d-cotizacion-pend (OUTPUT s-CodAlm, OUTPUT s-NroCot).
  
  IF s-CodAlm = "" THEN RETURN "ADM-ERROR".
  
  /* Validar que la COTIZACION tenga la fecha de entrega dentro de la programacion */
  IF s-user-id <> 'ADMIN' THEN DO:
      RUN ue-cotizacion-programada (INPUT s-nroCot, OUTPUT lCotProg).
      IF lCotProg = NO THEN DO:
          MESSAGE 'La cotizacion no esta programada por el area de ABASTECIMIENTO' VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.

  FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
      AND B-CPEDI.coddiv = s-CodDiv
      AND B-CPEDI.coddoc = s-CodRef
      AND B-CPEDI.nroped = s-NroCot
      NO-LOCK.

  /* Ic - 29Ene2016 ValesUtilex */
  IF s-tpoped2 = 'VU' AND B-CPEDI.tpoped <> 'VU'  THEN DO:
      MESSAGE 'Cotización NO pertenece a VALES de UTILEX' SKIP
          'Proceso abortado'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* chequeamos cotización */
  IF B-CPEDI.FchVen < TODAY THEN DO:
      FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          MESSAGE 'Cotización VENCIDA el' B-CPEDI.FchVen SKIP
              'Proceso abortado'
              VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
  END.

  ASSIGN
      s-FechaHora = ''
      s-FechaI = DATETIME(TODAY, MTIME)
      s-FechaT = ?
      s-adm-new-record = 'YES'
      s-PorIgv = FacCfgGn.PorIgv
      s-FlgEnv = YES.

  /* DISTRIBUYE LOS PRODUCTOS POR ORDEN DE ALMACENES */
  RUN Asigna-Cotizacion.
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /* *********************************************** */
  FIND FIRST PEDI NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PEDI THEN DO:
      MESSAGE 'NO hay stock suficiente para atender ese pedido' SKIP
          'PROCESO ABORTADO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-NroPed = ''
          s-CodCli = B-CPEDI.CodCli
          s-CodMon = B-CPEDI.CodMon                   /* >>> OJO <<< */
          s-TpoCmb = FacCfgGn.TpoCmb[1]
          F-NomVen = ""
          F-CndVta = ""
          F-NomTar = ''
          FILL-IN-sede = ''
          s-FmaPgo = B-CPEDI.FmaPgo
          S-FlgIgv = B-CPedi.FlgIgv.
      FIND gn-clied WHERE gn-clied.codcia = cl-codcia
         AND gn-clied.codcli = B-CPEDI.codcli
         AND gn-clied.sede = B-CPEDI.sede NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clied THEN FILL-IN-Sede = GN-ClieD.dircli.
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = B-CPEDI.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
      FIND gn-convt WHERE gn-convt.Codig = B-CPEDI.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
      FIND Gn-Card WHERE Gn-Card.NroCard = B-CPEDI.NroCard NO-LOCK NO-ERROR.
      IF AVAILABLE GN-CARD THEN F-NomTar = GN-CARD.NomClie[1].
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = s-codalm NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN f-NomAlm = Almacen.Descripcion.
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed
          TODAY @ Faccpedi.FchPed
          S-TPOCMB @ Faccpedi.TpoCmb
          TODAY + s-DiasVtoPed @ Faccpedi.FchVen
          B-CPEDI.FchEnt @ Faccpedi.FchEnt
          B-CPEDI.CodCli @ Faccpedi.CodCli
          B-CPEDI.NomCli @ Faccpedi.NomCli
          B-CPEDI.RucCli @ Faccpedi.RucCli
          B-CPEDI.Atencion @ Faccpedi.Atencion
          B-CPEDI.DirCli @ Faccpedi.Dircli
          B-CPEDI.LugEnt @ Faccpedi.LugEnt
          B-CPEDI.NroCard @ FacCPedi.NroCard
          B-CPEDI.Sede   @ Faccpedi.Sede
          B-CPEDI.CodVen @ Faccpedi.CodVen
          B-CPEDI.FmaPgo @ Faccpedi.FmaPgo
          B-CPEDI.Glosa  @ Faccpedi.Glosa
          B-CPEDI.NroPed @ FacCPedi.NroRef
          B-CPEDI.OrdCmp @ FacCPedi.OrdCmp
          B-CPEDI.FaxCli @ FacCPedi.FaxCli
          B-CPEDI.CodPos @ FacCPedi.CodPos
          B-CPEDI.Libre_c01 @ FILL-IN-Lista     /* Lista Base */
          s-CodAlm @ FacCPedi.CodAlm
          FILL-IN-sede
          F-CndVta           
          F-NomVen
          F-NomTar
          f-NomAlm.
      ASSIGN
          Faccpedi.Cmpbnte:SCREEN-VALUE = B-CPEDI.Cmpbnte        
          Faccpedi.CodMon:SCREEN-VALUE = STRING(B-CPEDI.CodMon)
          Faccpedi.FlgIgv:SCREEN-VALUE = (IF B-CPEDI.FlgIgv = YES THEN "YES" ELSE "NO").
        CASE Faccpedi.Cmpbnte:SCREEN-VALUE:
            WHEN 'FAC' THEN DO:
                ASSIGN  
                    FacCPedi.DirCli:SENSITIVE = NO
                    FacCPedi.NomCli:SENSITIVE = NO.
            END.
            WHEN 'BOL' THEN DO:
                ASSIGN  
                    FacCPedi.DirCli:SENSITIVE = YES
                    FacCPedi.NomCli:SENSITIVE = YES.
                APPLY 'ENTRY':U TO FacCPedi.NomCli.
            END.
        END CASE.
        /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
        IF s-FmaPgo = '002' AND LOOKUP(s-CodDiv, '00018,00024') > 0 
            THEN FacCPedi.Libre_c03:SENSITIVE = YES.
            ELSE FacCPedi.Libre_c03:SENSITIVE = NO.
        /* **************************************************** */
        APPLY 'LEAVE':U TO FacCPedi.CodCli.
        APPLY 'LEAVE':U TO FacCPedi.CodPos.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  /* RHC 04/02/2016 Caso Lista Express */
  IF B-CPEDI.TpoPed = "LF" THEN RUN Procesa-Handle IN lh_Handle ('Pagina3').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       El ALMACEN NO se pude modificar, entonces solo se hace 1 tracking
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Bloqueamos el correlativo para controlar las actualizaciones multiusuario */
  DEF VAR iLocalCounter AS INTEGER INITIAL 0 NO-UNDO.
  GetLock:
  DO ON STOP UNDO GetLock, RETRY GetLock:
      IF RETRY THEN DO:
          iLocalCounter = iLocalCounter + 1.
          IF iLocalCounter = 5 THEN LEAVE GetLock.
      END.
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-coddoc AND
          FacCorre.NroSer = s-nroser EXCLUSIVE-LOCK NO-ERROR.
  END. 
  IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN DO:
      pMensaje = "NO se pudo bloquear el Control de Correlativos".
      UNDO, RETURN "ADM-ERROR".
  END.
  
  /* RHC 21/01/2014 BLOQUEAMOS LA COTIZACION TAMBIEN */
  iLocalCounter = 0.
  GetLock :
  DO ON STOP UNDO GetLock, RETRY GetLock:
      IF RETRY THEN DO:
          iLocalCounter = iLocalCounter + 1.
          IF iLocalCounter = 5 THEN LEAVE GetLock.
      END.
      FIND COTIZACION WHERE COTIZACION.CodCia = s-CodCia
          AND COTIZACION.CodDiv = s-CodDiv
          AND COTIZACION.CodDoc = s-CodRef
          AND COTIZACION.NroPed = s-NroCot EXCLUSIVE-LOCK NO-ERROR.
  END. 
  IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN DO:
      pMensaje = "NO se pudo bloquear la Cotización Referenciada".
      UNDO, RETURN "ADM-ERROR".
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "YES" THEN DO:  /* SOLO CUANDO ES UN NUEVO PEDIDO */
      IF COTIZACION.FlgEst <> "P" THEN DO:
          pMensaje = "La Cotizacion ya no esta pendiente."  + CHR(10) +
              "Proceso abortado".
          UNDO, RETURN "ADM-ERROR".
      END.
      /* RHC 28/04/2016 */
/*       FOR EACH PEDI NO-LOCK WHERE PEDI.Libre_c05 <> "OF",                                 */
/*           FIRST B-DPEDI OF COTIZACION NO-LOCK WHERE B-DPEDI.codmat = PEDI.codmat:         */
/*           IF (B-DPEDI.CanPed - B-DPEDI.CanAte) <> PEDI.Libre_d01 THEN DO:                 */
/*               pMensaje = "La cotización ha sido modificada por otro usuario"  + CHR(10) + */
/*               "Proceso abortado".                                                         */
/*               UNDO, RETURN "ADM-ERROR".                                                   */
/*           END.                                                                            */
/*       END.                                                                                */
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* DATOS DE LA CABECERA */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          Faccpedi.CodCia = S-CODCIA
          Faccpedi.CodDoc = s-coddoc 
          Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          Faccpedi.CodRef = s-CodRef      /* COT */
          Faccpedi.NroRef = s-NroCot
          Faccpedi.FchPed = TODAY 
          Faccpedi.PorIgv = s-PorIgv 
          Faccpedi.CodDiv = S-CODDIV
          Faccpedi.FlgEst = "G"       /* FLAG TEMPORAL POR APROBAR */
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEnv = s-FlgEnv
          FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
          FacCPedi.Ubigeo[1] = COTIZACION.Ubigeo[1]    /* Sede del Cliente CANAL MODERNO */
          /* INFORMACION PARA LISTA EXPRESS */
          FacCPedi.PorDto     = COTIZACION.PorDto      /* Descuento LISTA EXPRESS */
          FacCPedi.ImpDto2    = COTIZACION.ImpDto2     /* Importe Decto Lista Express */
          FacCPedi.Importe[2] = COTIZACION.Importe[2] /* Importe Dcto Lista Express SIN IGV */
          .
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
      /* TRACKING */
      RUN vtagn/pTracking-04 (s-CodCia,
                        s-CodDiv,
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        s-User-Id,
                        'GNP',
                        'P',
                        DATETIME(TODAY, MTIME),
                        DATETIME(TODAY, MTIME),
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        Faccpedi.CodRef,
                        Faccpedi.NroRef).
  END.
  ELSE DO:
      /* Actualizamos la cotizacion */
      RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "D", OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN Borra-Pedido (TRUE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo extornar el pedido".
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      Faccpedi.Usuario = S-USER-ID
      Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
  /* Division destino */
  FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* RHC 08.08.11 agrupamos las promociones */
/*   RUN vta2/promociones-pedidos-cred-01 ( ROWID(Faccpedi), OUTPUT pMensaje). */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.              */

  /* Grabamos Totales */
  {vta2/graba-totales-cotizacion-cred.i}

  /* Actualizamos la cotizacion */
  RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* *********************************************************** */

/*   RUN Facturas-Adelantadas. */

  IF AVAILABLE(FacCorre)    THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi)    THEN RELEASE Facdpedi.
  IF AVAILABLE(COTIZACION)  THEN RELEASE COTIZACION.

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

  DO WITH FRAME {&FRAME-NAME}:
     Faccpedi.NomCli:SENSITIVE = NO.
     Faccpedi.RucCli:SENSITIVE = NO.
     Faccpedi.DirCli:SENSITIVE = NO.
  END. 

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
    IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
    IF LOOKUP(FacCPedi.FlgEst,"A,C,O,E,R,F,S") > 0 THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
    END.
    /* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */
    FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte <> 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
        MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.fchdoc >= Faccpedi.fchped
        AND Ccbcdocu.codped = Faccpedi.coddoc
        AND Ccbcdocu.nroped = Faccpedi.nroped
        AND LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0
        AND Ccbcdocu.flgest <> "A"
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* RHC 21/01/2014 BLOQUEAMOS LA COTIZACION COMO CONTROL MULTIUSUARIO */
        {lib/lock-wait.i &Tabla=B-CPedi &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
            AND B-CPedi.CodDiv=FacCPedi.CodDiv ~
            AND B-CPedi.CodDoc=FacCPedi.CodRef ~
            AND B-CPedi.NroPed=FacCPedi.NroRef"}

        /* RHC BLOQUEAMOS PEDIDO */
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.

        /* Actualizamos Cotizacion */
        RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "D", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.

        /* TRACKING */
        RUN vtagn/pTracking-04 (s-CodCia,
                          s-CodDiv,
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          s-User-Id,
                          'GNP',
                          'A',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          Faccpedi.CodRef,
                          Faccpedi.NroRef).
        ASSIGN
            FacCPedi.Glosa = "ANULADO POR " + s-user-id + " EL DIA " + STRING ( DATETIME(TODAY, MTIME), "99/99/9999 HH:MM" ).
            Faccpedi.FlgEst = 'A'.
        FIND CURRENT Faccpedi NO-LOCK.
        IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE Faccpedi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.

      F-NomVen:screen-value = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = Faccpedi.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      IF Faccpedi.FchVen < TODAY AND Faccpedi.FlgEst = 'P'
      THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND Gn-Card WHERE Gn-Card.NroCard = FacCPedm.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
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

      FILL-IN-Lista = ''.
      FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
          AND COTIZACION.coddiv = Faccpedi.coddiv
          AND COTIZACION.coddoc = Faccpedi.codref
          AND COTIZACION.nroped = Faccpedi.nroref
          NO-LOCK NO-ERROR.
      IF AVAILABLE COTIZACION THEN FILL-IN-Lista = COTIZACION.Libre_c01.
      DISPLAY FILL-IN-Lista WITH FRAME {&FRAME-NAME}.

      FIND Almtabla WHERE almtabla.Tabla = "CP"
          AND almtabla.Codigo = FacCPedi.CodPos
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN  FILL-IN-CodPos:SCREEN-VALUE = almtabla.Nombre.
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
        Faccpedi.CodCli:SENSITIVE = NO
        Faccpedi.NomCli:SENSITIVE = NO
        Faccpedi.DirCli:SENSITIVE = NO
        Faccpedi.RucCli:SENSITIVE = NO
        Faccpedi.FchPed:SENSITIVE = NO
        Faccpedi.FchVen:SENSITIVE = NO
        Faccpedi.TpoCmb:SENSITIVE = NO
        Faccpedi.FmaPgo:SENSITIVE = NO
        Faccpedi.CodVen:SENSITIVE = NO
        Faccpedi.CodMon:SENSITIVE = NO
        Faccpedi.flgigv:SENSITIVE = NO
        Faccpedi.Cmpbnte:SENSITIVE = NO
        Faccpedi.NroRef:SENSITIVE  = NO
        Faccpedi.NroCard:SENSITIVE = NO
        Faccpedi.Sede:SENSITIVE   = NO
        Faccpedi.CodAlm:SENSITIVE = NO
        Faccpedi.FaxCli:SENSITIVE = NO
        .
    /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
    ASSIGN
        FacCPedi.Libre_c03:SENSITIVE = NO.
    /* **************************************************** */
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
  IF FacCPedi.FlgEst <> "A" THEN RUN vta2\r-ImpPed-1 (ROWID(FacCPedi)).

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

  pMensajeFinal = "".
  pMensaje = "".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF AVAILABLE(FacCorre)    THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi)    THEN RELEASE Facdpedi.
  IF AVAILABLE(COTIZACION)  THEN RELEASE COTIZACION.
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Facturas-Adelantadas.
  RUN vta2/d-saldo-cot-cred (ROWID(Faccpedi)).
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  IF pMensajeFinal <> "" THEN MESSAGE pMensajeFinal.
  
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

IF FacCPedi.FlgEst <> "A" THEN DO:
   NIV = "".
   RUN VTA/D-CLAVE.R("D",
                    " ",
                    OUTPUT NIV,
                    OUTPUT RPTA).
   IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

   RUN vta/d-mrgped (ROWID(FacCPedi)).
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
            WHEN 'CodPos' THEN input-var-1 = 'CP'.
            WHEN 'Libre_c03' THEN DO:
                ASSIGN
                    input-var-1 = 'BD'
                    input-var-2 = FacCPedi.CodCli:SCREEN-VALUE
                    input-var-3 = 'P'.
            END.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Redondeo V-table-Win 
PROCEDURE Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
RUN vta2/d-redondeo-ped (ROWID(Faccpedi)).
RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-Division V-table-Win 
PROCEDURE Resumen-por-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN vtagn/p-pedresdiv (s-codcia, s-codalm, s-codmon, s-tpocmb, s-flgenv).

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
  {src/adm/template/snd-list.i "Faccpedi"}

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

  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     RUN Actualiza-Item.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cotizacion-preventa V-table-Win 
PROCEDURE ue-cotizacion-preventa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cotizacion-programada V-table-Win 
PROCEDURE ue-cotizacion-programada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCotizacion AS CHAR.
DEFINE OUTPUT PARAMETER pRet AS LOG.

DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lFechaControl AS DATE.

DEFINE BUFFER b-faccpedi FOR faccpedi.

/* Ic - 11Ene2017, solo para expos de LIMA segun MAcchiu */
FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
                            b-faccpedi.coddoc = 'COT' AND 
                            b-faccpedi.nroped = pCotizacion
                            NO-LOCK NO-ERROR.
IF AVAILABLE b-faccpedi THEN DO:
    lDivisiones = "20015,00015,10015,50015".
    IF LOOKUP(b-faccpedi.libre_c01,lDivisiones) = 0 THEN DO:
        /* La cotizacion no es PREVENTA/EXPO */
        pRet = YES.
        RETURN .
    END.
END.

/* Ic - Que usuarios no validar fecha de entrega */
DEFINE VAR lUsrFchEnt AS CHAR.
DEFINE VAR lValFecEntrega AS CHAR.

DEFINE BUFFER r-factabla FOR factabla.

lUsrFchEnt = "".
lValFecEntrega = ''.
FIND FIRST r-factabla WHERE r-factabla.codcia = s-codcia AND 
                           r-factabla.tabla = 'VALIDA' AND 
                           r-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
IF AVAILABLE r-factabla THEN DO:
   lUsrFchEnt      = r-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
   lValFecEntrega  = r-factabla.campo-c[2].  /* Valida Si o NO */
END.

RELEASE r-factabla.

IF lValFecEntrega = 'NO' OR LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
   /* 
       No requiere validacion la fecha de entrega ò
       El usuario esta inscrito para no validar la fecha de entrega
   */
   pRet = YES.
   RETURN .
END.

DEFINE BUFFER b-vtatabla FOR vtatabla.
DEFINE BUFFER z-gn-divi FOR gn-divi.

pRet = YES.

/* Ubicar la fecha de control de la programacion de LUCY */
FIND FIRST b-vtatabla WHERE b-vtatabla.codcia = s-codcia AND 
                           b-vtatabla.tabla = 'DSTRB' AND 
                           b-vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
IF AVAILABLE b-vtatabla THEN DO:
    lFechaControl = b-vtatabla.rango_fecha[2].
    /* Ubicar la Cotizacion */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
                                b-faccpedi.coddoc = 'COT' AND 
                                b-faccpedi.nroped = pCotizacion
                                NO-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        /* Preguntar si la Cotizacion es de PREVENTA segun su lista de precio */
        IF b-faccpedi.libre_c01 <> ? THEN DO:
            FIND FIRST z-gn-divi WHERE z-gn-divi.coddiv = b-faccpedi.libre_c01 NO-LOCK NO-ERROR.
            IF AVAILABLE z-gn-divi THEN DO:
                /* Si es FERIA */
                IF z-gn-divi.canalventa = 'FER' THEN DO:
                    IF b-faccpedi.libre_c02 <> "PROCESADO" THEN DO:
                        IF b-faccpedi.fchent > lFechaControl THEN pRet = NO.
                    END.                    
                END.
            END.
        END.
    END.
END.

RELEASE b-vtatabla.
RELEASE b-faccpedi.
RELEASE z-gn-divi.

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
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-SALDO AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    /* VALIDACION DEL CLIENTE */
    RUN vtagn/p-gn-clie-01 (Faccpedi.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO FacCPedi.Glosa.
        RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Faccpedi.codcli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.Glosa.
        RETURN 'ADM-ERROR'.
    END.
    IF gn-clie.flagaut = "R" THEN DO:
        MESSAGE 'Ha sido RECHAZADA su línea de crédito'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.Glosa.
        RETURN 'ADM-ERROR'.
    END.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (FacCPedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO FacCPedi.Glosa.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.flagaut = "" THEN DO:
        MESSAGE 'Su Línea de Crédito aún NO ha sido Autorizada' SKIP
            'Continuamos con la grabación' VIEW-AS ALERT-BOX WARNING.
    END.
    /* CODIGO POSTAL */
    FIND Almtabla WHERE almtabla.Tabla = "CP"
        AND almtabla.Codigo = FacCPedi.CodPos:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF FacCPedi.CodPos:SCREEN-VALUE <> '' AND NOT AVAILABLE Almtabla THEN DO:
        MESSAGE 'NO registrado el código postal' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR'.
    END.
    /* CONSISTENCIA DE FECHA */
    IF INPUT FacCPedi.fchven < INPUT FacCPedi.FchPed THEN DO:
        MESSAGE 'Fecha de vencimiento errada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.FchVen.
        RETURN "ADM-ERROR".
    END.
    IF INPUT FacCPedi.fchent < INPUT FacCPedi.FchPed THEN DO:
        MESSAGE 'Fecha de entrega errada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.FchEnt.
        RETURN "ADM-ERROR".
    END.
    IF DATE(FacCPedi.fchent:SCREEN-VALUE) > DATE(FacCPedi.FchPed:SCREEN-VALUE) + 25 THEN DO: 
        MESSAGE 'La fecha de entrega no puede superar los 25 días'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.FchEnt.
        RETURN "ADM-ERROR".
    END.
    /* RHC 04/10/2016 CONSISTENCIA DE FECHA DE ENTREGA */
    pMensaje = "".
    DEF VAR pFchEnt AS DATE NO-UNDO.
    pFchEnt = (INPUT FacCPedi.FchEnt).
    /* OJO con la hora */
    RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, s-CodDiv, FacCPedi.CodAlm:SCREEN-VALUE, OUTPUT pMensaje).
    IF pMensaje <> '' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.FchEnt.
        RETURN "ADM-ERROR".
    END.
    /* ************************************************************** */
    /* RHC 11/01/2017 CONSISTENCIA DIA PROGRAMADO Y DESPACHOS POR DIA */
    /* ************************************************************** */
    DEF BUFFER B-DIVI FOR gn-divi.
    DEF VAR pFchProg AS DATE NO-UNDO.
    pFchProg = pFchEnt.
    FIND B-DIVI WHERE B-DIVI.codcia = s-codcia
        AND B-DIVI.coddiv = FILL-IN-Lista:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE B-DIVI AND B-DIVI.Campo-Log[8] = YES THEN DO:
        /* Verificamos si tiene programación en el almacén de despacho */
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = FacCPedi.CodAlm:SCREEN-VALUE
            NO-LOCK.
        FIND gn-divi WHERE GN-DIVI.CodCia = Almacen.codcia
            AND GN-DIVI.CodDiv = Almacen.coddiv
            NO-LOCK.
        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Tabla = "CPXDIA"
            AND VtaTabla.Llave_c1 = GN-DIVI.CodDiv
            AND VtaTabla.Llave_c2 = FacCPedi.CodPos:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaTabla THEN DO:
            MESSAGE 'NO existe una programación para este código postal'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        REPEAT:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Tabla = "CPXDIA"
                AND VtaTabla.Llave_c1 = GN-DIVI.CodDiv
                AND VtaTabla.Llave_c2 = FacCPedi.CodPos:SCREEN-VALUE
                AND VtaTabla.Valor[1] = WEEKDAY(pFchProg)
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN DO:
                /* Verificamos clientes por dia */
                IF B-DIVI.DiasAmpCot > 0 THEN DO:
                    DEF VAR x-Cuentas AS INT NO-UNDO.
                    x-Cuentas = 0.
                    EMPTY TEMP-TABLE T-CLIENTE.
                    FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
                        AND B-CPEDI.coddiv = s-coddiv
                        AND B-CPEDI.coddoc = s-coddoc
                        AND LOOKUP(B-CPEDI.flgest, "P,G,T,W,WX,WL") > 0
                        AND B-CPEDI.fchent = pFchProg:
                        FIND T-CLIENTE WHERE T-CLIENTE.codcli = B-CPEDI.codcli NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE T-CLIENTE THEN DO:
                            CREATE T-CLIENTE.
                            ASSIGN T-CLIENTE.codcli = B-CPEDI.codcli.
                            x-Cuentas = x-Cuentas + 1.
                        END.
                    END.  
                    IF x-Cuentas <= B-DIVI.DiasAmpCot THEN LEAVE.
                END.
                ELSE LEAVE.
            END.
            pFchProg = pFchProg + 1.    /* Siguiente día */
        END.
    END.
    IF pFchEnt <> pFchProg THEN DO:
        MESSAGE 'Se sugiere como fecha de entrega el' pFchProg
            VIEW-AS ALERT-BOX WARNING.
        DISPLAY pFchProg @ FacCPedi.FchEnt.
        APPLY 'ENTRY':U TO FacCPedi.FchEnt.
        RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************** */
    /* CONSISTENCIA ALMACEN DESPACHO */
    IF Faccpedi.CodAlm:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO Faccpedi.CodAlm.
      RETURN "ADM-ERROR".
    END.
    /* CONSISTENCIA DE IMPORTES */
    f-Tot = 0.
    FOR EACH PEDI NO-LOCK:
       F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot <= 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
    END.

    /* VERIFICAMOS LA LINEA DE CREDITO */
    f-Saldo = f-Tot.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN F-Saldo = F-Tot - FacCpedi.Imptot.
    DEF VAR t-Resultado AS CHAR NO-UNDO.
    FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddiv = s-CodDiv
        AND B-CPEDI.coddoc = s-CodRef
        AND B-CPEDI.nroped = s-NroCot
        NO-LOCK.
    IF B-CPEDI.TpoPed <> 'M' THEN DO:  /*No valida LC para Contratos Marco***/
        RUN vta2/linea-de-credito-01 ( s-CodCli,
                                  f-Saldo,
                                  s-CodMon,
                                  s-FmaPgo,
                                  TRUE,
                                  OUTPUT t-Resultado).
        IF t-Resultado = 'ADM-ERROR' THEN DO:
            MESSAGE 'Se ha encontrado un error en la linea de crédito' SKIP
                'Grabación Abortada' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.Glosa.
            RETURN "ADM-ERROR".   
        END.
    END.
    /**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
    f-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * DECI(FaccPedi.Tpocmb:SCREEN-VALUE).
    IF F-Tot > 700 THEN DO:
        IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND
            Faccpedi.Atencion:SCREEN-VALUE = ''
            THEN DO:
            MESSAGE
                "Boleta de Venta Venta Mayor a S/.700.00 Ingresar Nro. DNI, Verifique... " 
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.Atencion.
            RETURN "ADM-ERROR".   
        END.
    END.

    /* RHC 15.12.09 CONTROL DE IMPORTE MINIMO POR PEDIDO */
    DEF VAR pImpMin AS DEC NO-UNDO.
    RUN vta2/p-MinCotPed (s-CodCia,
                       s-CodDiv,
                       s-CodDoc,
                       OUTPUT pImpMin).
    IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
        MESSAGE 'El importe mínimo para hacer un pedido es de S/.' pImpMin
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
    IF s-FmaPgo = '002' AND LOOKUP(s-CodDiv, '00018,00024') > 0 THEN DO:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = 'BD'
            AND Ccbcdocu.nrodoc = FacCPedi.Libre_c03:SCREEN-VALUE
            AND Ccbcdocu.codcli = FacCPedi.CodCli:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.flgest <> 'P' THEN DO:
            MESSAGE 'Boleta de Depósito NO válida' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
            RETURN 'ADM-ERROR'.
        END.
        IF Ccbcdocu.FmaPgo <> s-FmaPgo THEN DO:
            MESSAGE 'La condición de venta de la Boleta de Depósito NO es CONTADO ANTICIPADO'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE FacCPedi.Libre_c03:SCREEN-VALUE = ''.

    /* ******************************************************************************** */
    /* Validacion Fecha de ENTREGA para pedido de FERIA */
    /* ******************************************************************************** */
    /* RHC 04/10/2016 BLOQUEADO 
    /* Verificar si la cotizacion es FERIA  */
    DEFINE BUFFER z-faccpedi FOR faccpedi.
    DEFINE BUFFER z-gn-divi FOR gn-divi.
    DEFINE VAR lValidacionFeria AS LOG.
    FIND FIRST z-faccpedi WHERE z-faccpedi.codcia = s-codcia AND
                                z-faccpedi.coddoc = 'COT' AND 
                                z-faccpedi.nroped = faccpedi.nroref
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE z-faccpedi THEN DO:
        RELEASE z-faccpedi.
        RETURN "OK".
    END.
    lValidacionFeria = NO.
    IF z-faccpedi.libre_c01 <> ? THEN DO:
        FIND FIRST z-gn-divi WHERE z-gn-divi.coddiv = z-faccpedi.libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE z-gn-divi THEN DO:
            /* Si es FERIA */
            IF z-gn-divi.canalventa = 'FER' THEN DO:
                lValidacionFeria = YES.
            END.
        END.
    END.
    RELEASE z-faccpedi.
    RELEASE z-gn-divi.
    DEFINE BUFFER b-factabla FOR factabla.
    /* Ic - Que usuarios no validar fecha de entrega */
    DEFINE VAR lUsrFchEnt AS CHAR.
    DEFINE VAR lValFecEntrega AS CHAR.
    lUsrFchEnt = "".
    lValFecEntrega = ''.
    FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND 
                               b-factabla.tabla = 'VALIDA' AND 
                               b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
   IF AVAILABLE b-factabla THEN DO:
       lUsrFchEnt      = b-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
       lValFecEntrega  = b-factabla.campo-c[2].  /* Valida Si o NO */
   END.
   RELEASE b-factabla.
   IF lValFecEntrega = 'NO' OR LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
       /* 
           No requiere validacion la fecha de entrega ò
           El usuario esta inscrito para no validar la fecha de entrega
       */
       lValidacionFeria = NO.
   END.
    /* El pedido proviene de una Cotizacion que no es de feria */
    IF lValidacionFeria = NO THEN RETURN "OK".
    /* El Rango de Fechas de LUCY */   
    DEFINE VAR lFechaDesde AS DATE.
    DEFINE VAR lFechaHasta AS DATE.
    DEFINE VAR lDias AS INT.
    lValidacionFeria = NO.
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                               vtatabla.tabla = 'DSTRB' AND 
                               vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
       lValidacionFeria = YES.
       lDias = vtatabla.valor[1].
       IF lDias = 0 THEN lDias = 1000. /* Sin Limite */
       lFechaDesde = vtatabla.rango_fecha[1].
       lFechaHasta = vtatabla.rango_fecha[2].
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        IF INPUT FacCPedi.FchEnt <= lFechaHasta THEN DO:
            MESSAGE 'La fecha de entrega NO debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(1) ' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.FchEnt.
            RETURN "ADM-ERROR".   
        END.            
    END.
    ELSE DO:
        /* Verificar si realizo modificacion de cambio de fecha */
        IF pFechaEntrega <> INPUT FacCPedi.FchEnt THEN DO:
            /* Si la fecha anterior (pFechaEntrega) es mayor al programado
                y la nueva fecha dentro de lo programado ERROR */
            IF pFechaEntrega > lFechaHasta AND INPUT FacCPedi.FchEnt <= lFechaHasta THEN DO:
                MESSAGE 'La fecha de entrega NO debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(2) ' VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO FacCPedi.FchEnt.
                RETURN "ADM-ERROR".   
            END.
        END.
    END.
    ******************** RHC FIN DE BLOQUEO */
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
IF FacCPedi.FlgEst <> "G" THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
END.
/* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */
FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE FacDPedi THEN DO:
    MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.coddoc
    AND Ccbcdocu.nroped = Faccpedi.nroped
    AND LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0
    AND Ccbcdocu.flgest <> "A"
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia
    AND COTIZACION.coddiv = Faccpedi.coddiv
    AND COTIZACION.coddoc = Faccpedi.codref
    AND COTIZACION.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE COTIZACION AND COTIZACION.TpoPed = "LF" THEN DO:
    MESSAGE 'NO se puede modificar un pedido por Lista Express'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroPed = FacCPedi.NroPed
    S-CODMON = FacCPedi.CodMon
    s-TpoCmb = FacCPedi.TpoCmb
    S-CODCLI = FacCPedi.CodCli
    s-NroCot = FacCPedi.NroRef
    s-adm-new-record = 'NO'
    s-FlgEnv = FacCPedi.FlgEnv
    s-codalm = FacCPedi.CodAlm
    s-PorIgv = Faccpedi.PorIgv
    s-FmaPgo = Faccpedi.FmaPgo.

ASSIGN pFechaEntrega = faccpedi.fchent.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Corregida V-table-Win 
PROCEDURE Venta-Corregida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FIND FIRST PEDI-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDI-3 THEN RETURN 'OK'.
RUN vtamay/d-vtacorr-ped.
/*RETURN 'ADM-ERROR'.*/
RETURN 'OK'.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cliente V-table-Win 
PROCEDURE Verifica-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
{vta2/verifica-cliente.i}

/* RHC 22.11.2011 Verificamos los margenes y precios */
IF Faccpedi.FlgEst = "X" THEN RETURN.   /* NO PASO LINEA DE CREDITO */
IF LOOKUP(s-CodDiv, '00000,00017,00018') = 0 THEN RETURN.     /* SOLO PARA LA DIVISION DE ATE */

{vta2/i-verifica-margen-utilidad-1.i}
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

