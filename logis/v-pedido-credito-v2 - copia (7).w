&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PCO FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE Facdpedi.
DEFINE TEMP-TABLE PEDI-2 LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE Reporte NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE t-FacDPedi NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-LogTabla NO-UNDO LIKE logtabla.
DEFINE TEMP-TABLE x-FacDPedi NO-UNDO LIKE FacDPedi.



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
/*&SCOPED-DEFINE precio-venta-general pri/p-precio-mayor-contado.p*/
/*&SCOPED-DEFINE Promocion vta2/promocion-generalv21.p*/
&SCOPED-DEFINE Promocion vta2/promocion-generalv2.p

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
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.

DEFINE SHARED VARIABLE input-var-4 AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE T-SALDO     AS DECIMAL.
DEFINE VARIABLE F-totdias   AS INTEGER NO-UNDO.
DEFINE VARIABLE s-FlgEnv AS LOG NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.

DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.
DEFINE BUFFER B-MATG  FOR Almmmatg.
DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER y-vtatabla FOR vtatabla.

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

/* CONTROL DE NUMERO DE PCO SELECCIONADA */
DEF VAR xNroPCO AS CHAR NO-UNDO.

/* TIPO DE ABASTECIMIENTO */
/* NORMAL
   PCO 
   */
DEF SHARED VAR s-Tipo-Abastecimiento AS CHAR.

/* Articulo impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = "099268".

/*  */
DEFINE VAR x-cod-boleta-deposito AS CHAR.
DEFINE VAR x-boleta-deposito AS CHAR.
DEFINE VAR x-BD-PEDIDO AS CHAR.

x-BD-PEDIDO = "BD-PEDIDO".

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
FacCPedi.FchEnt FacCPedi.Libre_f02 FacCPedi.DirCli FacCPedi.TpoCmb ~
FacCPedi.Cmpbnte FacCPedi.FmaPgo FacCPedi.FlgIgv FacCPedi.Libre_c03 ~
FacCPedi.CodMon FacCPedi.CodAlm FacCPedi.NroRef FacCPedi.ordcmp ~
FacCPedi.Sede FacCPedi.CodOrigen FacCPedi.NroOrigen FacCPedi.CodPos ~
FacCPedi.Cliente_Recoge FacCPedi.Glosa FacCPedi.TipVta FacCPedi.EmpaqEspec 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-66 RECT-67 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FaxCli ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.RucCli FacCPedi.Atencion ~
FacCPedi.fchven FacCPedi.NomCli FacCPedi.FchEnt FacCPedi.Libre_f02 ~
FacCPedi.DirCli FacCPedi.TpoCmb FacCPedi.Cmpbnte FacCPedi.FmaPgo ~
FacCPedi.FlgIgv FacCPedi.Libre_c03 FacCPedi.CodMon FacCPedi.TpoLic ~
FacCPedi.CodAlm FacCPedi.NroRef FacCPedi.DT FacCPedi.AlmacenDT ~
FacCPedi.ordcmp FacCPedi.Sede FacCPedi.CodOrigen FacCPedi.NroOrigen ~
FacCPedi.CodPos FacCPedi.Cliente_Recoge FacCPedi.Glosa FacCPedi.TipVta ~
FacCPedi.EmpaqEspec 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-Lista F-CndVta ~
COMBO-BOX-doc f-NomAlm FILL-IN-AlmacenDT FILL-IN-sede FILL-IN-CodPos ~
FILL-IN-Libre_c16 FILL-IN-embalado-especial 

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
DEFINE VARIABLE COMBO-BOX-doc AS CHARACTER FORMAT "X(5)":U 
     LABEL "Cod. Doc. deposito" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 8 BY 1
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmacenDT AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-embalado-especial AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Libre_c16 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Glosa Destino Final" 
     VIEW-AS FILL-IN 
     SIZE 74 BY .81
     BGCOLOR 10 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista Precios" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 125 BY 7.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 125 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 12 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.27 COL 35 COLON-ALIGNED NO-LABEL
     FacCPedi.FaxCli AT ROW 1.27 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 120 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FacCPedi.FchPed AT ROW 1.27 COL 96 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.08 COL 12 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.RucCli AT ROW 2.08 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 2.08 COL 46 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-Lista AT ROW 2.08 COL 74 COLON-ALIGNED WIDGET-ID 124
     FacCPedi.fchven AT ROW 2.08 COL 96 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NomCli AT ROW 2.88 COL 12 COLON-ALIGNED FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 71 BY .81
     FacCPedi.FchEnt AT ROW 2.88 COL 96 COLON-ALIGNED WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.Libre_f02 AT ROW 3.65 COL 96 COLON-ALIGNED WIDGET-ID 154
          LABEL "Fecha Entrega" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 3.69 COL 12 COLON-ALIGNED
          LABEL "Dirección Fiscal" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 71 BY .81
     FacCPedi.TpoCmb AT ROW 4.46 COL 72.57 COLON-ALIGNED
          LABEL "T.C."
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Cmpbnte AT ROW 4.46 COL 98 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FAC", "FAC":U,
"BOL", "BOL":U
          SIZE 13 BY .81
     FacCPedi.FmaPgo AT ROW 4.5 COL 12 COLON-ALIGNED
          LABEL "Cond. de Venta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 4.5 COL 18 COLON-ALIGNED NO-LABEL
     FacCPedi.FlgIgv AT ROW 4.5 COL 55.43 WIDGET-ID 108
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
     FacCPedi.Libre_c03 AT ROW 5.27 COL 34.14 COLON-ALIGNED WIDGET-ID 130
          LABEL "Nro. Depósito" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.CodMon AT ROW 5.27 COL 98 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 15 BY .81
     COMBO-BOX-doc AT ROW 5.31 COL 13.57 COLON-ALIGNED WIDGET-ID 182
     FacCPedi.TpoLic AT ROW 5.31 COL 55.29 WIDGET-ID 118
          LABEL "APLICAR ADELANTOS"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .77
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.CodAlm AT ROW 6.12 COL 12 COLON-ALIGNED WIDGET-ID 110
          LABEL "Alm. Despacho" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 8 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     f-NomAlm AT ROW 6.12 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FacCPedi.NroRef AT ROW 6.12 COL 103 COLON-ALIGNED WIDGET-ID 10
          LABEL "Pedido Comercial"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 FONT 6
     FacCPedi.DT AT ROW 6.92 COL 15 WIDGET-ID 160
          LABEL "Dejar en Tienda"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .77
     FacCPedi.AlmacenDT AT ROW 6.92 COL 35 COLON-ALIGNED WIDGET-ID 162
          LABEL "Alm. DT"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-AlmacenDT AT ROW 6.92 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 144
     FacCPedi.ordcmp AT ROW 6.92 COL 96 COLON-ALIGNED
          LABEL "O/Compra" FORMAT "X(25)"
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     FacCPedi.Sede AT ROW 8.27 COL 14 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-sede AT ROW 8.27 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FacCPedi.CodOrigen AT ROW 8.27 COL 104.43 COLON-ALIGNED NO-LABEL WIDGET-ID 152
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.NroOrigen AT ROW 8.27 COL 109.43 COLON-ALIGNED NO-LABEL WIDGET-ID 146
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.CodPos AT ROW 9.08 COL 14 COLON-ALIGNED WIDGET-ID 126
          LABEL "Código Postal"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-CodPos AT ROW 9.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FacCPedi.Cliente_Recoge AT ROW 9.08 COL 112 NO-LABEL WIDGET-ID 164
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 12 BY .81
          BGCOLOR 10 FGCOLOR 0 
     FacCPedi.Glosa AT ROW 9.88 COL 11.28 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 74 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.TipVta AT ROW 9.88 COL 112 NO-LABEL WIDGET-ID 134
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "No", "",
"Si", "Si":U
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-Libre_c16 AT ROW 10.69 COL 14 COLON-ALIGNED WIDGET-ID 170
     FacCPedi.EmpaqEspec AT ROW 10.69 COL 107 WIDGET-ID 176
          LABEL "Embalaje Especial"
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .77
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-embalado-especial AT ROW 8.38 COL 74.86 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     "Text 7" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.23 COL 117 WIDGET-ID 172
     "Trámite Documentario?" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 10.15 COL 94 WIDGET-ID 138
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.38 COL 91
     "Pactado con cliente" VIEW-AS TEXT
          SIZE 14.43 BY .5 AT ROW 3.77 COL 108.57 WIDGET-ID 158
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.65 COL 88 WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Cliente Recoge:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 9.35 COL 100 WIDGET-ID 168
     "Calendario logistico" VIEW-AS TEXT
          SIZE 14.43 BY .5 AT ROW 2.96 COL 108.57 WIDGET-ID 156
     RECT-66 AT ROW 1 COL 1 WIDGET-ID 148
     RECT-67 AT ROW 8 COL 1 WIDGET-ID 150
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
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PCO B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL Facdpedi
      TABLE: PEDI-2 T "?" ? INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: Reporte T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: t-FacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-LogTabla T "NEW SHARED" NO-UNDO INTEGRAL logtabla
      TABLE: x-FacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 11.15
         WIDTH              = 126.
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

/* SETTINGS FOR FILL-IN FacCPedi.AlmacenDT IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN FacCPedi.CodPos IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-doc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.DT IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.EmpaqEspec IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-AlmacenDT IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodPos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-embalado-especial IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Libre_c16 IN FRAME F-Main
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
/* SETTINGS FOR FILL-IN FacCPedi.Libre_f02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME FacCPedi.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodAlm V-table-Win
ON LEAVE OF FacCPedi.CodAlm IN FRAME F-Main /* Alm. Despacho */
DO:
    FIND Almacen WHERE Almacen.codcia = s-codcia AND
        Almacen.codalm = Faccpedi.codalm:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN f-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
      gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie AND FacCPedi.Cmpbnte:SCREEN-VALUE = 'FAC' 
      THEN 
      DISPLAY
        gn-clie.NomCli @ Faccpedi.NomCli
        gn-clie.Ruc @ Faccpedi.RucCli
        gn-clie.DirCli @ Faccpedi.Dircli
        gn-clie.DNI @ Faccpedi.Atencion
        gn-clie.FaxCli @ Faccpedi.FaxCli
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodPos V-table-Win
ON LEAVE OF FacCPedi.CodPos IN FRAME F-Main /* Código Postal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND Almtabla WHERE almtabla.Tabla = "CP"
      AND almtabla.Codigo = FacCPedi.CodPos:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-CodPos:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond. de Venta */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    FIND gn-convt WHERE gn-convt.Codig = Faccpedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_f02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_f02 V-table-Win
ON LEAVE OF FacCPedi.Libre_f02 IN FRAME F-Main /* Fecha Entrega */
DO:
  /*FacCPedi.FchEnt:SCREEN-VALUE = SELF:SCREEN-VALUE.*/
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


&Scoped-define SELF-NAME FacCPedi.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEAVE OF FacCPedi.Sede IN FRAME F-Main /* Sede */
DO:
    FILL-IN-Sede:SCREEN-VALUE = ''.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
       AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE
       AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        FILL-IN-Sede:SCREEN-VALUE = GN-ClieD.dircli.
        IF TRUE <> (FacCPedi.CodPos:SCREEN-VALUE > '') THEN DO:
            FacCPedi.CodPos:SCREEN-VALUE = Gn-ClieD.Codpos.
            APPLY 'LEAVE':U TO FacCPedi.CodPos.
        END.
        /* *************************************************************************************** */
        /* Embalaje Especial */
        /* *************************************************************************************** */
        /*FacCPedi.EmpaqEspec:SCREEN-VALUE = 'NO'.*/
        fill-in-embalado-especial:SCREEN-VALUE = ''.
        FIND Gn-ClieD WHERE Gn-ClieD.CodCia = cl-codcia
            AND Gn-ClieD.CodCli = FacCPedi.CodCli:SCREEN-VALUE
            AND Gn-ClieD.Sede = FacCPedi.Sede:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-ClieD AND Gn-ClieD.Libre_c03 = "Si" THEN DO:
            fill-in-embalado-especial:SCREEN-VALUE = 'Requiere - embalado especial'.
            /*FacCPedi.EmpaqEspec:SCREEN-VALUE = 'YES'.*/
        END.
            
        /* *************************************************************************************** */
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TpoCmb V-table-Win
ON LEAVE OF FacCPedi.TpoCmb IN FRAME F-Main /* T.C. */
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
  EMPTY TEMP-TABLE x-Facdpedi.  /* PED antes de ser modificado */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':    /* SIN PROMOCIONES */
      CREATE PEDI.
      BUFFER-COPY Facdpedi TO PEDI.
      CREATE x-Facdpedi.
      BUFFER-COPY Facdpedi TO x-Facdpedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p-Ok AS LOG.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
          IF p-Ok = YES THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */
      END.    
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Cotizacion V-table-Win 
PROCEDURE Captura-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pFchEnt AS DATE.

  ASSIGN
      s-FechaHora = ''
      s-FechaI = DATETIME(TODAY, MTIME)
      s-FechaT = ?
      s-PorIgv = FacCfgGn.PorIgv
      s-FlgEnv = YES.
  ASSIGN
      xNroPCO = ''
      s-NroCot = ''
      pFchEnt = TODAY.

  /* *************************************************************************** */
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN PED_Add-Record IN hProc (INPUT s-PorIgv,
                               OUTPUT pFchEnt,
                               OUTPUT xNroPCO,
                               OUTPUT s-NroCot,
                               OUTPUT s-CodAlm,
                               OUTPUT s-Tipo-Abastecimiento,
                               OUTPUT TABLE PEDI).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* *************************************************************************** */
  FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-CodCia AND
      COTIZACION.coddiv = s-CodDiv AND
      COTIZACION.coddoc = "COT"    AND
      COTIZACION.nroped = s-NroCot NO-LOCK NO-ERROR.
  /* Ic - 29Ene2016 ValesUtilex */
  IF s-tpoped2 = 'VU' AND COTIZACION.tpoped <> 'VU'  THEN DO:
      MESSAGE 'Cotización NO pertenece a VALES de UTILEX' SKIP
          'Proceso abortado'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* chequeamos cotización */
  IF COTIZACION.FchVen < TODAY THEN DO:
      FIND FIRST B-DPEDI OF COTIZACION WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          MESSAGE 'Cotización VENCIDA el' COTIZACION.FchVen SKIP
              'Proceso abortado'
              VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
  END.
  /* *********************************************** */
  FIND FIRST PEDI NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PEDI THEN DO:
      MESSAGE 'NO hay stock suficiente para atender ese pedido' SKIP 'PROCESO ABORTADO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  /* **************************************************************************************** */
  /* RHC 23/05/2019 CONTROL ADICIONAL: GUARDAMOS EL DETALLE Y SALDO DE LA COTIZACION
  SI HAY DIFERENCIA AL MOMENTO DE GRABAR ENTONCES NO GRABAMOS NADA */
  /* **************************************************************************************** */
  EMPTY TEMP-TABLE t-Facdpedi.
  FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
      CREATE t-Facdpedi.
      BUFFER-COPY Facdpedi TO t-Facdpedi.
  END.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREATE-TRANSACION V-table-Win 
PROCEDURE CREATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       SOLO PARA REGISTROS NUEVOS 
------------------------------------------------------------------------------*/

DEF VAR x-CodAlm AS CHAR NO-UNDO.     
DEF VAR pFchEnt AS DATE NO-UNDO.
DEF VAR i-Cuenta AS INT NO-UNDO.

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Cargamos el temporal con todos los items de todos los almacenes */
    FOR EACH PEDI WHERE PEDI.CanPed <= 0:
        DELETE PEDI.
    END.
    EMPTY TEMP-TABLE PEDI-2.
    FOR EACH PEDI:
        CREATE PEDI-2.
        BUFFER-COPY PEDI TO PEDI-2.
    END.
    /* ********************************************************************************************** */
    /* Bloqueamos Correlativo */
    /* ********************************************************************************************** */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* En Caso de s-TpoPed = "FER" */
    CASE TRUE:
        WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
            /* Primero Extornamos la CanAte actualizada por el PCO en la COTIZACION */
            FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.CodCia = s-CodCia AND
                    B-DPEDI.CodDoc = "PCO" AND
                    B-DPEDI.NroPed = xNroPCO:
                FIND FIRST Facdpedi WHERE Facdpedi.CodCia = COTIZACION.CodCia AND
                    Facdpedi.CodDoc = COTIZACION.CodDoc AND
                    Facdpedi.NroPed = COTIZACION.NroPed AND
                    Facdpedi.CodMat = B-DPEDI.CodMat NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Facdpedi THEN NEXT.
                FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE Facdpedi THEN DO:
                    pMensaje = "NO se pudo extornar la PCO".
                    UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                END.
                Facdpedi.CanAte = Facdpedi.CanAte - B-DPEDI.CanPed.
                IF Facdpedi.CanAte < 0 THEN DO:
                    pMensaje = 'Se ha detectado un error al extornar la PCO en el producto ' + Facdpedi.codmat + CHR(10) +
                        'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
        END.
    END CASE.
    /* La primera pasada usa el registro creado por el mismo Smart-Viewer */
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
        /* INFORMACION PARA LISTA EXPRESS */
        FacCPedi.PorDto     = COTIZACION.PorDto      /* Descuento LISTA EXPRESS */
        FacCPedi.ImpDto2    = COTIZACION.ImpDto2     /* Importe Decto Lista Express */
        FacCPedi.Importe[2] = COTIZACION.Importe[2] /* Importe Dcto Lista Express SIN IGV */
        FacCPedi.Libre_c02 = s-Tipo-Abastecimiento  /* PCO o NORMAL */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* INFORMACION QUE NO SE VE EN EL VIEWER */
    /* ********************************************************************************************** */
    ASSIGN
        FacCPedi.NroCard = COTIZACION.NroCard
        FacCPedi.CodVen  = COTIZACION.CodVen.
    /* ********************************************************************************************** */
    /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
    /* ********************************************************************************************** */
    FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli
        AND gn-clied.sede = Faccpedi.sede
        NO-LOCK NO-ERROR.
    ASSIGN
        FacCPedi.Ubigeo[1] = FacCPedi.Sede
        FacCPedi.Ubigeo[2] = "@CL"
        FacCPedi.Ubigeo[3] = FacCPedi.CodCli.
    /* ********************************************************************************************** */
    /* EN CASO DE VENIR DE UN PCO */
    /* ********************************************************************************************** */
    CASE TRUE:
        WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
            /* Bloqueamos PCO */
            FIND FIRST PCO WHERE PCO.codcia = s-codcia AND
                PCO.coddoc = "PCO" AND
                PCO.nroped = xNroPCO
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                PCO.FlgEst = "C".   /* SE CIERRA TOTALMENTE EL PCO */
            RELEASE PCO.
            ASSIGN
                FacCPedi.CodOrigen = "PCO"
                FacCPedi.NroOrigen = xNroPCO.
        END.
    END CASE.
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
    /* ********************************************************************************************** */
    /* RHC 23/07/2018 CONTROL DE TOPE DE PEDIDOS */
    /* ********************************************************************************************** */
    FOR EACH T-LogTabla NO-LOCK:
        CREATE LogTabla.
        BUFFER-COPY T-LogTabla TO LogTabla
            ASSIGN
            logtabla.codcia = s-CodCia
            logtabla.Tabla = "TOPEDESPACHO"
            LogTabla.ValorLlave = Faccpedi.CodDoc + '|' + Faccpedi.NroPed + '|' + T-LogTabla.ValorLlave.
        DELETE T-LogTabla.
    END.
    /* ********************************************************************************************** */
    /* Control de Pedidos Generados */
    /* ********************************************************************************************** */
    CREATE Reporte.
    BUFFER-COPY Faccpedi TO Reporte.
    /* ********************************************************************************************** */
    /* Definimos cuantos almacenes hay de despacho */
    /* Cuando se modifica un pedido hay solo un almacén */
    /* ********************************************************************************************** */
    x-CodAlm = ENTRY(1, s-CodAlm).        /* El primer almacén por defecto */
    ASSIGN 
        FacCPedi.CodAlm = x-CodAlm.               /* <<<< OJO <<<< : Almacén del PEDIDO */
    /* ********************************************************************************************** */
    /* Division destino */
    /* ********************************************************************************************** */
    FIND Almacen OF Faccpedi NO-LOCK.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ********************************************************************************************** */
    /* Las Promociones solo se calculan en el PRIMER PEDIDO */
    /* ********************************************************************************************** */
    /* RHC 05/05/2014 nueva rutina de promociones */
    RUN {&Promocion} (COTIZACION.Libre_c01, Faccpedi.CodCli, INPUT-OUTPUT TABLE PEDI-2, OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    /* ********************************************************************************************** */
    /* CARGAMOS LA INFORMACION POR ALMACEN DESPACHO */
    /* ********************************************************************************************** */
    EMPTY TEMP-TABLE PEDI.
    FOR EACH PEDI-2 NO-LOCK WHERE PEDI-2.almdes = x-CodAlm:
        CREATE PEDI.
        BUFFER-COPY PEDI-2 TO PEDI.
    END.
    RUN Genera-Pedido (INPUT 'CREATE').    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ********************************************************************************************** */
    /* RHC 07/04/2021 */
    pFchEnt = Faccpedi.Libre_f02.   /* Pactada con el cliente */
/*     pFchEnt = FacCPedi.FchEnt. */
    RUN Fecha-Entrega (INPUT-OUTPUT pFchEnt, OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.
    DISPLAY FacCPedi.FchEnt WITH FRAME {&FRAME-NAME}.
    /* ****************************************************************************** */
    /* Grabamos Totales */
    /* ********************************************************************************************** */
    RUN Graba-Totales.
    /* ********************************************************************************************** */
    /* Actualizamos la cotizacion */
    /* ********************************************************************************************** */
    RUN vta2/pactualizacotizacion.r ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ********************************************************************************************** */
    /* ********************************************************************************************** */
    /* SE VA A DAR TANTAS VUELTAS COMO ALMACENES EXISTAN */
    /* ********************************************************************************************** */
    DEF VAR LocalLoop AS INT NO-UNDO.
    DO LocalLoop = 2 TO NUM-ENTRIES(s-CodAlm):
        x-CodAlm = ENTRY(LocalLoop, s-CodAlm).
        /* Copiamos las Original */
        CREATE PEDIDO.
        BUFFER-COPY FacCPedi TO PEDIDO
            ASSIGN
            PEDIDO.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            NO-ERROR
            .
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        FIND FacCPedi WHERE ROWID(FacCPedi) = ROWID(PEDIDO) EXCLUSIVE-LOCK.
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
        /* ********************************************************************************************** */
        /* Control de Pedidos Generados */
        /* ********************************************************************************************** */
        CREATE Reporte.
        BUFFER-COPY Faccpedi TO Reporte.
        /* ********************************************************************************************** */
        /* GRABAMOS DETALLE DEL PEDIDO */
        /* ********************************************************************************************** */
        ASSIGN 
            FacCPedi.CodAlm = x-CodAlm.               /* <<<< OJO <<<< : Almacén del PEDIDO */
        /* ********************************************************************************************** */
        /* Division destino */
        /* ********************************************************************************************** */
        FIND Almacen OF Faccpedi NO-LOCK.
        ASSIGN FacCPedi.DivDes = Almacen.CodDiv.
        /* ********************************************************************************************** */
        /* CARGAMOS LA INFORMACION POR ALMACEN DESPACHO */
        /* ********************************************************************************************** */
        EMPTY TEMP-TABLE PEDI.
        FOR EACH PEDI-2 NO-LOCK WHERE PEDI-2.almdes = x-CodAlm:
            CREATE PEDI.
            BUFFER-COPY PEDI-2 TO PEDI.
        END.
        RUN Genera-Pedido (INPUT 'CREATE').    /* Detalle del pedido */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* ********************************************************************************************** */
        /* Grabamos Totales */
        /* ********************************************************************************************** */
        RUN Graba-Totales.
        /* ********************************************************************************************** */
        /* Actualizamos la cotizacion */
        /* ********************************************************************************************** */
        RUN vta2/pactualizacotizacion.r ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items-Pbo V-table-Win 
PROCEDURE Delete-Items-Pbo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = Faccpedi.codcia AND
        FacDPedi.CodDiv = Faccpedi.coddiv AND
        FacDPedi.CodDoc = "pbo" AND
        FacDPedi.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="B-DPEDI" ~
            &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE B-DPEDI.            
    END.
END.

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

DEF VAR pMensaje AS CHAR NO-UNDO.                                          
                                          
IF NOT AVAILABLE Faccpedi THEN RETURN.

IF Faccpedi.flgest <> "G" THEN RETURN.

/* 
    Ic - 23Jun2020, para casos de pedido de 002 - CONTADO ANTICIPADO
    que aun no haya actualizado la BD
*/

DEFINE VAR x-fmapago AS CHAR.
DEFINE VAR x-boleta-deposito AS CHAR.

x-fmapago = faccpedi.fmapgo.
x-boleta-deposito = faccpedi.libre_c03.

IF x-fmapago = '002' THEN DO:
    IF TRUE <> (x-boleta-deposito > "") THEN DO:
        MESSAGE "Imposible realizar despacho" SKIP
                "para CONTADO ANTICIPADO, debe asignar" SKIP
                "la BD APROBADO " VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.
END.

/* Ic - 23Jun2020 - FIN */

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.
pMensaje = "".
RUN PED_Despachar-Pedido IN hProc (INPUT ROWID(Faccpedi),
                                   OUTPUT pMensaje).
DELETE PROCEDURE hProc.

FIND CURRENT Faccpedi NO-LOCK.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

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

IF Faccpedi.TpoLic = NO THEN RETURN.

DEF VAR pSdoAct AS DEC NO-UNDO.

RUN vtagn/p-saldo-ac-infly (INPUT ROWID(Faccpedi),  OUTPUT pSdoAct).
MESSAGE 'Saldo Disponible del A/C =' (IF Faccpedi.CodMon = 1 THEN 'S/.' ELSE 'US$') pSdoAct
    VIEW-AS ALERT-BOX INFORMATION.

/*
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
  FIND FIRST gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
  IF (x-saldo-mn > 0 OR x-saldo-me > 0) AND 
      (AVAILABLE gn-convt AND gn-ConVt.Libre_l03 = YES)     /*LOOKUP(Faccpedi.FmaPgo,'403,391') > 0 */
      THEN DO:
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' STRING(x-saldo-mn, '->>>,>>>,>>9.99') SKIP
          'Por aplicar DOLARES:' STRING(x-saldo-me, '->>>,>>>,>>9.99') SKIP(1)
          'Aplicamos automáticamente a la factura?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      FOR EACH Reporte NO-LOCK, FIRST PEDIDO OF Reporte EXCLUSIVE-LOCK:
          IF rpta = YES THEN PEDIDO.TpoLic = YES.
          ELSE PEDIDO.TpoLic = NO.
      END.
      RELEASE PEDIDO.
  END.
  FIND CURRENT Faccpedi NO-LOCK.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega V-table-Win 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
RUN logis/p-fecha-de-entrega (
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).

/*
RUN gn/p-fchent-v3.p (
    FacCPedi.CodAlm,              /* Almacén de despacho */
    TODAY,                        /* Fecha base */
    STRING(TIME,'HH:MM:SS'),      /* Hora base */
    FacCPedi.CodCli,              /* Cliente */
    FacCPedi.CodDiv,              /* División solicitante */
    (IF FacCPedi.TipVta = "Si" THEN "CR" ELSE FacCPedi.CodPos),   /* Ubigeo: CR es cuando el cliente recoje  */
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    pNroSKU,
    pPeso,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).
*/

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

  DEFINE INPUT PARAMETER pEvento AS CHAR.
  /* pEvento: CREATE o UPDATE */

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

  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  DEF VAR LocalVerificaStock AS LOG NO-UNDO.

  /* RHC 24/04/2020 Validación VENTA DELIVERY */
  DEF VAR x-VentaDelivery AS LOG NO-UNDO.
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "GN-DIVI" AND
      FacTabla.Codigo = s-CodDiv AND
      FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN x-VentaDelivery = YES.
  ELSE x-VentaDelivery = NO.
       
  DETALLES:
  FOR EACH PEDI EXCLUSIVE-LOCK, 
      FIRST Almmmatg OF PEDI NO-LOCK,
      FIRST Almtfami OF Almmmatg NO-LOCK 
      BY PEDI.NroItm:
      /* RHC 13/06/2020 NO se verifica el stock de productos con Cat. Contab. = "SV" */
      /* el x-articulo-ICBPER es un impuesto clasificado coomo SV (servicio) */
      /* RHC 10/07/2020 NO se verifica el stock de productos Drop Shipping */
      IF Almtfami.Libre_c01 = "SV" THEN NEXT.
      FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
          VtaTabla.Tabla = "DROPSHIPPING" AND
          VtaTabla.Llave_c1 = PEDI.CodMat 
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN NEXT.
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = 0.
      /* RHC 15/03/2021 Decidimos cuándo verificamos el stock */
      LocalVerificaStock = NO.
      IF pEvento = "CREATE" THEN LocalVerificaStock = YES.
      IF pEvento = "UPDATE" THEN DO:
          /* Solo cuando hay una modificación de la cantidad: debe ser mayor a la solicitada anteriormente */
          FIND FIRST x-Facdpedi WHERE x-Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE x-Facdpedi AND PEDI.CanPed > x-Facdpedi.CanPed THEN LocalVerificaStock = YES.
      END.
      /* ******************************************************** */
      /* RHC 13/07/2021: Siempre verificar stock para PROMOCIONES */
      /* ******************************************************** */
      IF PEDI.Libre_c05 = "OF" THEN LocalVerificaStock = YES.
      /* ******************************************************** */
      IF LocalVerificaStock = YES THEN DO:
          IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
          RUN gn/stock-comprometido-v2.p (PEDI.CodMat, PEDI.AlmDes, YES, OUTPUT s-StkComprometido).
          /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
          FIND FIRST FacTabla WHERE FacTabla.CodCia = COTIZACION.CodCia AND
              FacTabla.Tabla = "GN-DIVI" AND
              FacTabla.Codigo = COTIZACION.CodDiv AND
              FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
              FacTabla.Valor[1] > 0           /* Horas de reserva */
              NO-LOCK NO-ERROR.
          IF AVAILABLE FacTabla THEN DO:
              /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
              /* Afectamos lo comprometido: extornamos el comprometido */
              FIND FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi THEN
                  s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
          END.
          s-StkDis = x-StkAct - s-StkComprometido.
          IF s-StkDis <= 0 THEN DO:
              pMensajeFinal = pMensajeFinal + CHR(10) +
                  'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
                  'en el almacén ' + PEDI.AlmDes + CHR(10).
              /* OJO: NO DESPACHAR */
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN RETURN "ADM-ERROR".
              /* ******************************** */
              DELETE PEDI.      /* << OJO << */
              NEXT DETALLES.    /* << OJO << */
          END.
          f-Factor = PEDI.Factor.
          x-CanPed = PEDI.CanPed * f-Factor.
          IF s-StkDis < x-CanPed THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN RETURN "ADM-ERROR".
              /* ******************************** */
              /* Ajustamos de acuerdo a los multiplos */
              PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
              IF PEDI.CanPed <= 0 THEN DO:
                  DELETE PEDI.
                  NEXT DETALLES.
              END.
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
                  CASE TRUE:
                      WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
                          RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.codmat, 
                                                               f-CanPed, 
                                                               OUTPUT pSugerido, 
                                                               OUTPUT pEmpaque).
                          f-CanPed = pSugerido.
                          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                      END.
                      OTHERWISE DO:
                          RUN vtagn/p-cantidad-sugerida.p (s-TpoPed,
                                                           PEDI.codmat, 
                                                           f-CanPed, 
                                                           OUTPUT pSugerido, 
                                                           OUTPUT pEmpaque).
                          f-CanPed = pSugerido.
                          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                      END.
                  END CASE.
              END.
          END.
          IF f-CanPed <> PEDI.CanPed THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN RETURN "ADM-ERROR".
              /* ******************************** */
          END.
          IF PEDI.CanPed <= 0 THEN DO:
              DELETE PEDI.
          END.
      END.
      /* **************************************************************************************** */
  END.
  /* RECALCULAMOS */
  FOR EACH PEDI EXCLUSIVE-LOCK:
      {vta2/calcula-linea-detalle.i &Tabla="PEDI"}
      IF PEDI.CanPed <= 0 THEN DELETE PEDI.
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          EXCEPT PEDI.TipVta    /* Campo con valor A, B, C o D */
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              /* Facdpedi.FlgEst = Faccpedi.FlgEst */ 
              Facdpedi.NroItm = I-NPEDI.

             /* 
                Ic - 23Jun2020, se coordino con Ruben para que no grabe el estado(flgest) 
                en el detalle ya que el storeprocedure lo hace    
             */
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

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
  DEF VAR i AS INT NO-UNDO.
  DEF VAR lCotProg AS LOG.
  DEF VAR pFchEnt AS DATE NO-UNDO.  /* Fecha de entrega programada */

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  /* ***************************************************************************** */
  /* ***************************************************************************** */
  /* TIPO DE ABASTECIMIENTO */
  RUN Captura-Cotizacion (OUTPUT pFchEnt).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  /* ***************************************************************************** */
  /* ***************************************************************************** */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* ******************************************************************** */
  /* PINTAMOS INFORMACION EN PANTALLA */
  /* ******************************************************************** */
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-embalado-especial:SCREEN-VALUE = ''.
      FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-CodCia AND
          COTIZACION.coddiv = s-CodDiv AND
          COTIZACION.coddoc = "COT"    AND
          COTIZACION.nroped = s-NroCot NO-LOCK NO-ERROR.
      ASSIGN
          s-NroPed = ''
          s-CodCli = COTIZACION.CodCli
          s-CodMon = COTIZACION.CodMon                   /* >>> OJO <<< */
          s-TpoCmb = FacCfgGn.TpoCmb[1]
          F-CndVta = ""
          s-FmaPgo = COTIZACION.FmaPgo
          S-FlgIgv = COTIZACION.FlgIgv.
      FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = ENTRY(1,s-codalm) NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN f-NomAlm = Almacen.Descripcion.
      /* La fecha de entrega viene de la COTIZACION O LA PCO */
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed
          TODAY @ Faccpedi.FchPed
          S-TPOCMB @ Faccpedi.TpoCmb
          TODAY + s-DiasVtoPed @ Faccpedi.FchVen
          (IF pFchEnt >= TODAY THEN pFchEnt ELSE TODAY) @ Faccpedi.FchEnt
          (IF pFchEnt >= TODAY THEN pFchEnt ELSE TODAY) @ Faccpedi.libre_f02
          COTIZACION.CodCli @ Faccpedi.CodCli
          COTIZACION.NomCli @ Faccpedi.NomCli
          COTIZACION.RucCli @ Faccpedi.RucCli
          COTIZACION.Atencion @ Faccpedi.Atencion
          COTIZACION.DirCli @ Faccpedi.Dircli
          COTIZACION.FmaPgo @ Faccpedi.FmaPgo
          COTIZACION.Glosa  @ Faccpedi.Glosa
          COTIZACION.NroPed @ FacCPedi.NroRef
          COTIZACION.OrdCmp @ FacCPedi.OrdCmp
          COTIZACION.FaxCli @ FacCPedi.FaxCli
          "@@@" @ FacCPedi.Sede     /* POR DEFECTO LA DIRECCION FISCAL */
          COTIZACION.Libre_c01 @ FILL-IN-Lista     /* Lista Base */
          s-CodAlm @ FacCPedi.CodAlm
          f-NomAlm.
      ASSIGN
         FacCPedi.Cliente_Recoge:SCREEN-VALUE = STRING(COTIZACION.Cliente_Recoge).
      ASSIGN
          FacCPedi.TipVta:SCREEN-VALUE = "No".
      /* ******************************************************* */
      /* RHC 10/09/2020 Sede del Cliente (ej. caso B2B div 00519 */
      /* ******************************************************* */
      DEF VAR pSede AS CHAR NO-UNDO.
      RUN Sede-Cliente (OUTPUT pSede, OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      IF pSede > '' THEN Faccpedi.Sede:SCREEN-VALUE = pSede.
      /* ******************************************************* */
      /* ******************************************************* */
      CASE s-Tipo-Abastecimiento:
          WHEN "PCO" THEN DO:
              FIND PCO WHERE PCO.codcia = s-CodCia AND
                  PCO.coddiv = s-CodDiv AND
                  PCO.coddoc = "PCO" AND
                  PCO.nroped = xNroPCO NO-LOCK NO-ERROR.
              DISPLAY 
                  PCO.CodDoc @ FacCPedi.CodOrigen 
                  PCO.NroPed @ FacCPedi.NroOrigen WITH FRAME {&FRAME-NAME}.
          END.
          OTHERWISE DO:
              DISPLAY COTIZACION.NroPed @ FacCPedi.NroRef WITH FRAME {&FRAME-NAME}.
          END.
      END CASE.
      
      /* CASO CANAL MODERNO */
      IF CAN-FIND(gn-divi WHERE gn-divi.codcia = s-codcia AND 
                  gn-divi.coddiv = s-coddiv AND
                  gn-divi.canalventa = "MOD" NO-LOCK)
          THEN DISPLAY COTIZACION.Ubigeo[1] @ Faccpedi.Sede.
      ASSIGN
          Faccpedi.Cmpbnte:SCREEN-VALUE = COTIZACION.Cmpbnte        
          Faccpedi.CodMon:SCREEN-VALUE = STRING(COTIZACION.CodMon)
          Faccpedi.FlgIgv:SCREEN-VALUE = (IF COTIZACION.FlgIgv = YES THEN "YES" ELSE "NO").
      
      /* ********************************************************************** */
      /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
      /* ********************************************************************** */
      IF s-FmaPgo = '002' THEN DO:           /*AND LOOKUP(s-CodDiv, '00018,00024,00030') > 0 */
          combo-box-doc:SCREEN-VALUE = ''.
          combo-box-doc:SENSITIVE = YES.
          FacCPedi.Libre_c03:SENSITIVE = YES.
      END.
      ELSE DO:
          combo-box-doc:SCREEN-VALUE = ''.
          FacCPedi.Libre_c03:SCREEN-VALUE = ''.
          combo-box-doc:SENSITIVE = NO.
          FacCPedi.Libre_c03:SENSITIVE = NO.
      END.
      /* ********************************************************************** */
      /* RHC 27/12/2019 Si ya viene con CLIENTE RECOGE => NO se puede modificar */
      /* ********************************************************************** */
      IF COTIZACION.Cliente_Recoge = YES THEN FacCPedi.Cliente_Recoge:SENSITIVE = NO.
      IF COTIZACION.Sede > '' THEN FacCPedi.Sede:SCREEN-VALUE = COTIZACION.Sede.
      /* ********************************************************************** */
      
      APPLY 'LEAVE':U TO FacCPedi.CodCli.
      APPLY 'LEAVE':U TO FacCPedi.FmaPgo.
      APPLY 'LEAVE':U TO FacCPedi.Sede.
  END.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  /* RHC 04/02/2016 Caso Lista Express */
  IF COTIZACION.TpoPed = "LF" THEN RUN Procesa-Handle IN lh_Handle ('Pagina3').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       El ALMACEN NO se pude modificar, entonces solo se hace 1 tracking
  Actualizaciones:
  22/09/2017 Condición de Venta Unica Campaña puede generar mas de un pedido
    
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pFchEnt AS DATE NO-UNDO.

  /* Control de Pedidos Generados: Para aplicar los A/C de Facturas Adelantas */
  EMPTY TEMP-TABLE Reporte.

  /* SIEMPRE Bloqueamos la COTIZACION */
  pMensaje = ''.
  {lib/lock-genericov3.i ~
      &Tabla="COTIZACION" ~
      &Condicion="COTIZACION.CodCia = s-CodCia AND ~
                    COTIZACION.CodDiv = s-CodDiv AND ~
                    COTIZACION.CodDoc = s-CodRef AND ~
                    COTIZACION.NroPed = s-NroCot" ~
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }
  /* RHC 23/05/2019 SI HAY ALGUNA MODIFICACION EN LA COTIZACION NO SE GRABA NADA */
  FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.libre_c05 <> "OF":
      FIND FIRST t-Facdpedi WHERE t-Facdpedi.codmat = Facdpedi.codmat NO-LOCK NO-ERROR.
      IF NOT AVAILABLE t-Facdpedi OR 
          (t-Facdpedi.canate <> Facdpedi.canate) OR
          (t-Facdpedi.canped <> Facdpedi.canped) THEN DO:
          pMensaje = 'La Cotizacion ' + COTIZACION.NroPed + ' ha sido modificada por otro usuario' + CHR(10) +
              'Artículo: ' + t-Facdpedi.codmat + CHR(10) + 
              'Vuelva a intentarlo' + CHR(10) + 'Proceso Abortado'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  /*
    Ic - 27Jun2020, correo de susana del dia 26Jun2020
    
    la  ASIGNACIÓN DE BD APROBADO A UN PEDIDO, porque he detectado una vulnerabilidad riesgosa:
    * Varios pedidos de un mismo cliente puede asignar a una misma BD aprobado.
    - La funcionalidad correcta es que una vez asignado la BD APROBADO a un pedido, ya no debe permitir la visualización para que lo puedan asignar nuevamente.
 
  */
  x-boleta-deposito = FacCPedi.Libre_c03:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF TRUE <> (x-boleta-deposito > "") THEN x-boleta-deposito = "".
  x-boleta-deposito = TRIM(x-boleta-deposito).

  IF NOT (TRUE <> (x-boleta-deposito > "")) THEN DO:
      /* BD o A/R */
      ASSIGN 
          faccpedi.usrchq = combo-box-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
          vtatabla.tabla = x-bd-pedido AND
          vtatabla.llave_c1 = x-boleta-deposito AND
          vtatabla.llave_c2 = faccpedi.coddoc AND
          vtatabla.llave_c3 = faccpedi.nroped AND
          vtatabla.libre_c03 = combo-box-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}  /* BD o A/R */
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF LOCKED vtatabla THEN DO:    
          pMensaje = "Ocurrió un problema con la tabla VTATABLA" + CHR(10) +                    
              "Está siendo usado por otro usuario".
          UNDO, RETURN 'ADM-ERROR'.
      END.
      IF NOT AVAILABLE vtatabla THEN DO:
          CREATE vtatabla.
          ASSIGN 
              vtatabla.codcia = s-codcia
              vtatabla.tabla = x-bd-pedido
              vtatabla.libre_c01 = s-user-id + "|" + STRING(TODAY,"99/99/9999") + 
              "|" + STRING(TIME,"HH:MM:SS")
              vtatabla.libre_c03 = combo-box-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
      END.
      ASSIGN            
          vtatabla.llave_c1 = x-boleta-deposito
          vtatabla.llave_c2 = "PED"
          vtatabla.llave_c3 = faccpedi.nroped:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
      vtatabla.libre_c02 = s-user-id + "|" + STRING(TODAY,"99/99/9999") + 
          "|" + STRING(TIME,"HH:MM:SS").            
  END.

  /* DATOS DE LA CABECERA */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      /* MODIFICANDO UN PEDIDO */
      ASSIGN                                                  
          FacCPedi.UsrAct = S-USER-ID
          FacCPedi.HorAct = STRING(TIME,"HH:MM:SS")
          /*FacCPedi.Libre_f02 = FacCpedi.FchEnt*/.
      /* RUTINA PRINCIPAL */
      RUN UPDATE-TRANSACION.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ELSE DO:
      /* NUEVO PEDIDO */
      ASSIGN
          Faccpedi.Usuario = S-USER-ID
          Faccpedi.Hora   = STRING(TIME,"HH:MM:SS")
          /*FacCPedi.Libre_f02 = FacCpedi.FchEnt*/.
      /* Se van a generar tantos pedidos con almacenes de despacho se encuentren */
      s-CodAlm = ''.
      FOR EACH PEDI NO-LOCK BREAK BY PEDI.AlmDes:
          IF FIRST-OF(PEDI.AlmDes) THEN s-CodAlm = s-CodAlm + (IF TRUE <> (s-CodAlm > '') THEN '' ELSE ',') + 
                                                    PEDI.AlmDes.
      END.
      /* RUTINA PRINCIPAL */
      RUN CREATE-TRANSACION.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  /* *************************************************************************************** */
  /* RHC 16/12/2021 Control de A/C por aplicar */
  /* *************************************************************************************** */
  RUN Verifica-AC (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* *************************************************************************************** */
  /* Embalaje Especial */
  /* *************************************************************************************** */
  /*FacCPedi.EmpaqEspec = NO.
  FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = cl-codcia
      AND Gn-ClieD.CodCli = FacCPedi.CodCli
      AND Gn-ClieD.Sede = FacCPedi.Sede
      NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-ClieD AND Gn-ClieD.Libre_c03 = "Si" THEN FacCPedi.EmpaqEspec = YES.
  */
  /* *************************************************************************************** */
  /* RHC 09/04/2021 Datos del B2C y B2B */
  /* *************************************************************************************** */
  ASSIGN
      FacCPedi.ContactReceptorName = COTIZACION.ContactReceptorName 
      FacCPedi.TelephoneContactReceptor = COTIZACION.TelephoneContactReceptor 
      FacCPedi.ReferenceAddress = COTIZACION.ReferenceAddress 
      FacCPedi.DNICli = COTIZACION.DNICli.

  IF AVAILABLE(FacCorre)    THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi)    THEN RELEASE Facdpedi.
  IF AVAILABLE(COTIZACION)  THEN RELEASE COTIZACION.
  IF AVAILABLE(PCO)         THEN RELEASE PCO.

  ASSIGN
      combo-box-doc:SENSITIVE = NO.
  RELEASE vtatabla NO-ERROR.

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
     COMBO-BOX-doc:SENSITIVE = NO.
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
    IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN vtagn/ventas-library PERSISTENT SET hProc.

    RUN PED_Validate-Delete IN hProc (INPUT ROWID(Faccpedi)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    DELETE PROCEDURE hProc.

/*     IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".                                                       */
/*     IF LOOKUP(FacCPedi.FlgEst, "G,P,X,T,WL") = 0 THEN DO:                                                    */
/*         MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.                                                   */
/*         RETURN "ADM-ERROR".                                                                                  */
/*     END.                                                                                                     */
/*     /* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */                                               */
/*     FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte <> 0 NO-LOCK NO-ERROR.                             */
/*     IF AVAILABLE FacDPedi THEN DO:                                                                           */
/*         MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR. */
/*         RETURN 'ADM-ERROR'.                                                                                  */
/*     END.                                                                                                     */
/*     FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia                                                     */
/*         AND Ccbcdocu.fchdoc >= Faccpedi.fchped                                                               */
/*         AND Ccbcdocu.codped = Faccpedi.coddoc                                                                */
/*         AND Ccbcdocu.nroped = Faccpedi.nroped                                                                */
/*         AND LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0                                                           */
/*         AND Ccbcdocu.flgest <> "A"                                                                           */
/*         NO-LOCK NO-ERROR.                                                                                    */
/*     IF AVAILABLE Ccbcdocu THEN DO:                                                                           */
/*         MESSAGE 'No se puede eliminar/modificar un pedido con facturas emitidas' VIEW-AS ALERT-BOX ERROR.    */
/*         RETURN 'ADM-ERROR'.                                                                                  */
/*     END.                                                                                                     */

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* RHC 21/01/2014 BLOQUEAMOS LA COTIZACION COMO CONTROL MULTIUSUARIO */
        {lib/lock-genericov3.i ~
            &Tabla="B-CPEDI" ~
            &Condicion="B-CPedi.CodCia = FacCPedi.CodCia ~
                AND B-CPedi.CodDiv = FacCPedi.CodDiv ~
                AND B-CPedi.CodDoc = FacCPedi.CodRef ~
                AND B-CPedi.NroPed = FacCPedi.NroRef" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        /* RHC BLOQUEAMOS PEDIDO */
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN DO:            
            UNDO, RETURN 'ADM-ERROR'.
        END.
                       
        x-boleta-deposito = FacCPedi.Libre_c03:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        IF TRUE <> (x-boleta-deposito > "") THEN x-boleta-deposito = "".
        x-boleta-deposito = TRIM(x-boleta-deposito).

        IF NOT (TRUE <> (x-boleta-deposito > "")) THEN DO:
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                        vtatabla.tabla = x-bd-pedido AND
                                        vtatabla.llave_c1 = x-boleta-deposito AND
                                        vtatabla.llave_c2 = faccpedi.coddoc AND
                                        vtatabla.llave_c3 = faccpedi.nroped EXCLUSIVE-LOCK NO-ERROR.
            IF LOCKED vtatabla THEN DO:    
                MESSAGE "La tabla VTATABLA esta BLOQUEADA" + CHR(10) +                    
                                ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            IF AVAILABLE vtatabla THEN DO:
                ASSIGN 
                    vtatabla.libre_c03 = "ANULADO|" + s-user-id + "|" + STRING(TODAY,"99/99/9999") + 
                            "|" + STRING(TIME,"DD:MM:YYYY").            
            END.
        END.

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
    END.

    RELEASE vtatabla NO-ERROR.

    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
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

      IF Faccpedi.FchVen < TODAY AND Faccpedi.FlgEst = 'P'
      THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.

      FILL-IN-Lista = ''.
      FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
          AND COTIZACION.coddiv = Faccpedi.coddiv
          AND COTIZACION.coddoc = Faccpedi.codref
          AND COTIZACION.nroped = Faccpedi.nroref
          NO-LOCK NO-ERROR.
      IF AVAILABLE COTIZACION THEN FILL-IN-Lista = COTIZACION.Libre_c01.
      DISPLAY FILL-IN-Lista WITH FRAME {&FRAME-NAME}.

      FILL-IN-AlmacenDT = ''.
      IF Faccpedi.DT = YES THEN DO:
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = Faccpedi.AlmacenDT
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN FILL-IN-AlmacenDT = Almacen.Descripcion.
      END.
      DISPLAY FILL-IN-AlmacenDT.

      FILL-IN-Libre_c16 = ''.
      FIND FIRST Ccbadocu WHERE  CcbADocu.CodCia = Faccpedi.codcia AND
          CcbADocu.CodDiv = Faccpedi.coddiv AND
          CcbADocu.CodDoc = Faccpedi.coddoc AND
          CcbADocu.NroDoc = Faccpedi.nroped NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbadocu THEN FILL-IN-Libre_c16 = CcbADocu.Libre_c[16].      
      DISPLAY FILL-IN-Libre_c16.
      combo-box-doc = " ".
      IF NOT (TRUE <> (faccpedi.usrchq > "")) THEN combo-box-doc = faccpedi.usrchq. /* BD o A/R */            
      DISPLAY combo-box-doc.

      APPLY 'LEAVE':U TO FacCPedi.FmaPgo.
      APPLY 'LEAVE':U TO FacCPedi.CodAlm.
      APPLY 'LEAVE':U TO FacCPedi.CodPos.

      FILL-IN-Sede = ''.
      FIND gn-clied WHERE gn-clied.codcia = cl-codcia
          AND gn-clied.codcli = Faccpedi.codcli
          AND gn-clied.sede = Faccpedi.sede NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clied THEN FILL-IN-Sede = GN-ClieD.dircli.
      DISPLAY FILL-IN-Sede.
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

  DEFINE VAR x-boleta-deposito AS CHAR INIT "".

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
          Faccpedi.CodMon:SENSITIVE = NO
          Faccpedi.flgigv:SENSITIVE = NO
          Faccpedi.Cmpbnte:SENSITIVE = NO
          Faccpedi.NroRef:SENSITIVE  = NO
          Faccpedi.CodAlm:SENSITIVE = NO
          Faccpedi.FaxCli:SENSITIVE = NO
          FacCPedi.CodPos:SENSITIVE = NO
          FacCPedi.CodOrigen:SENSITIVE = NO
          FacCPedi.NroOrigen:SENSITIVE = NO
          Faccpedi.FchEnt:SENSITIVE = NO.
      ASSIGN
          FacCPedi.Libre_c03:SENSITIVE = NO
          combo-box-doc:SENSITIVE = NO.
      /* ************************************************************************ */
      /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17: Boleta de Depósito */
      /* ************************************************************************ */
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').

      fill-in-embalado-especial:SCREEN-VALUE = ''.

      IF RETURN-VALUE = "NO" THEN DO:
          IF FacCPedi.FmaPgo = "002" THEN DO:
              ASSIGN
                  FacCPedi.Libre_c03:SENSITIVE = YES
                  combo-box-doc:SENSITIVE = YES.
          END.
          ELSE DO:
              ASSIGN
                  FacCPedi.Libre_c03:SENSITIVE = NO
                  combo-box-doc:SENSITIVE = NO.
          END.
          FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = cl-codcia
              AND Gn-ClieD.CodCli = FacCPedi.CodCli:SCREEN-VALUE
              AND Gn-ClieD.Sede = FacCPedi.Sede:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-ClieD AND Gn-ClieD.Libre_c03 = "Si" THEN DO:
              fill-in-embalado-especial:SCREEN-VALUE = 'Requiere - embalado especial'.
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
  /*IF FacCPedi.FlgEst <> "A" THEN RUN vta2\r-ImpPed-1 (ROWID(FacCPedi)).*/
  RUN vtagn/p-imprime-pedido (ROWID(Faccpedi)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-doc:DELETE(COMBO-BOX-doc:NUM-ITEMS).
      COMBO-BOX-doc:ADD-LAST("").
      COMBO-BOX-doc:SCREEN-VALUE = "".

      FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "DOC-DEPOSITOS" AND
                                x-vtatabla.llave_c2 = "COND.VTA" AND
                                x-vtatabla.llave_c3 = "002" NO-LOCK.      /* Cond. Vta - Contado Anticipado */

            /* Verificar si esta configurado para la division de venta */
            FIND FIRST y-vtatabla WHERE y-vtatabla.codcia = s-codcia AND
                                        y-vtatabla.tabla = "CONFIG-VTAS" AND
                                        y-vtatabla.llave_c1 = "DOC-DEPOSITOS" AND
                                        y-vtatabla.llave_c2 = "DIVISIONES" AND
                                        y-vtatabla.llave_c3 = x-vtatabla.llave_c4 AND
                                        y-vtatabla.llave_c4 = "*" NO-LOCK NO-ERROR. /* Todas las divisiones */   
            IF NOT AVAILABLE y-vtatabla THEN DO:
                FIND FIRST y-vtatabla WHERE y-vtatabla.codcia = s-codcia AND
                                            y-vtatabla.tabla = "CONFIG-VTAS" AND
                                            y-vtatabla.llave_c1 = "DOC-DEPOSITOS" AND
                                            y-vtatabla.llave_c2 = "DIVISIONES" AND
                                            y-vtatabla.llave_c3 = x-vtatabla.llave_c4 AND
                                            y-vtatabla.llave_c4 = s-coddiv NO-LOCK NO-ERROR. /* Todas las divisiones */   
            END.
            IF AVAILABLE y-vtatabla THEN DO:
                COMBO-BOX-doc:ADD-LAST(x-vtatabla.llave_c4).            /* A/R o BD */
                IF TRUE <> (COMBO-BOX-doc:SCREEN-VALUE > "") THEN DO:
                    COMBO-BOX-doc:SCREEN-VALUE = x-vtatabla.llave_c4.
                END.
            END.
      END.
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

  pMensajeFinal = "".
  pMensaje = "".
  
  /* Dispatch standard ADM method.                             */
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Facturas-Adelantadas. 

  /* Muestra en pantalla los saldos por atender */
  RUN vta2/d-saldo-cot-cred.r (ROWID(Faccpedi)).

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  IF pMensajeFinal > "" THEN MESSAGE pMensajeFinal.
  
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
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "Sede" THEN ASSIGN input-var-1 = FacCPedi.CodCli:SCREEN-VALUE.
            WHEN 'CodPos' THEN input-var-1 = 'CP'.
            WHEN 'Libre_c03' THEN DO:
                ASSIGN
                    /*input-var-1 = 'BD'*/
                    input-var-1 = COMBO-BOX-doc:SCREEN-VALUE    /* 13/01/2021 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Sede-Cliente V-table-Win 
PROCEDURE Sede-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEF OUTPUT PARAMETER pSede AS CHAR NO-UNDO.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
                                                  
  ASSIGN
      pSede = ''
      pMensaje = ''.

  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN gn/master-library PERSISTENT SET hProc.
  RUN B2B_Sede-Cliente IN hProc (INPUT COTIZACION.CodCli,
                                 INPUT COTIZACION.DeliveryAddress,
                                 INPUT COTIZACION.Region1Name,
                                 INPUT COTIZACION.Region2Name,
                                 INPUT COTIZACION.Region3Name, 
                                 INPUT COTIZACION.ReferenceAddress, 
                                 INPUT COTIZACION.TelephoneContactReceptor, 
                                 INPUT COTIZACION.ContactReceptorName,
                                 OUTPUT pSede,
                                 OUTPUT pMensaje).
                                 
  DELETE PROCEDURE hProc.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transportista V-table-Win 
PROCEDURE Transportista :
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
    IF FacCPedi.DT = YES THEN RETURN.
    /*IF LOOKUP (FacCPedi.FlgEst,"X,G,P") > 0 THEN DO:*/
    IF LOOKUP (FacCPedi.FlgEst,"X,G") > 0 THEN DO:
        RUN logis/d-agencia-transporte (Faccpedi.codcia, 
                                        Faccpedi.coddiv, 
                                        Faccpedi.coddoc, 
                                        Faccpedi.nroped).
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    END.
    
    /*
    RUN logis/d-agencia-transporte (Faccpedi.codcia, 
                                    Faccpedi.coddiv, 
                                    Faccpedi.coddoc, 
                                    Faccpedi.nroped).
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UPDATE-TRANSACION V-table-Win 
PROCEDURE UPDATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pFchEnt AS DATE NO-UNDO.

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ********************************************************************************************** */
    /* Borramos Detalle del Pedido */
    /* ********************************************************************************************** */
    REPEAT:
        FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN LEAVE.
        FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "NO se pudo extornar el pedido".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        DELETE Facdpedi.
    END.
    /* Eliminamos Bonificaciones */
    RUN Delete-Items-Pbo.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* ********************************************************************************************** */
    /* PROMOCIONES */
    /* ********************************************************************************************** */
    /* RHC 05/05/2014 nueva rutina de promociones */
    RUN {&Promocion} (COTIZACION.Libre_c01, Faccpedi.CodCli, INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    /* ********************************************************************************************** */
    /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
    /* ********************************************************************************************** */
    IF FacCPedi.Ubigeo[2] = "@CL" THEN DO:
        ASSIGN
            FacCPedi.Ubigeo[1] = Faccpedi.Sede
            FacCPedi.Ubigeo[2] = "@CL"
            FacCPedi.Ubigeo[3] = Faccpedi.CodCli
            .
    END.
    /* ********************************************************************************************** */
    /* Control de Pedidos Generados */
    /* ********************************************************************************************** */
    CREATE Reporte.
    BUFFER-COPY Faccpedi TO Reporte.
    /* ********************************************************************************************** */
    /* Grabamos en Detalle del Pedido */
    /* ********************************************************************************************** */
    RUN Genera-Pedido (INPUT 'UPDATE').    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ****************************************************************************** */
    /* RHC 07/04/2021 */
    pFchEnt = FacCPedi.FchEnt.      /* OJO */
    IF FacCPedi.Ubigeo[2] <> "@PV" THEN DO:
        pFchEnt = FacCPedi.Libre_f02.   /* Pactada con el cliente */
        RUN Fecha-Entrega (INPUT-OUTPUT pFchEnt, OUTPUT pMensaje).
        IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
/*     pFchEnt = FacCPedi.FchEnt.                           */
/*     RUN Fecha-Entrega (OUTPUT pFchEnt, OUTPUT pMensaje). */
/*     IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.      */
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.
    DISPLAY FacCPedi.FchEnt WITH FRAME {&FRAME-NAME}.
    /* ********************************************************************************************** */
    /* Grabamos Totales */
    /* ********************************************************************************************** */
    RUN Graba-Totales.
    /* ********************************************************************************************** */
    /* Actualizamos la cotizacion */
    /* ********************************************************************************************** */
    RUN vta2/pactualizacotizacion-upd ( INPUT ROWID(Faccpedi), 
                                        INPUT TABLE x-Facdpedi,
                                        INPUT TABLE PEDI,
                                        OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

x-boleta-deposito = "".
x-cod-boleta-deposito = "".

DO WITH FRAME {&FRAME-NAME}:
    /* **************************************** */
    /* RHC 22/07/2020 Nuevo bloqueo de clientes */
    /* **************************************** */
    RUN pri/p-verifica-cliente (INPUT Faccpedi.CodCli:SCREEN-VALUE,
                                INPUT s-CodDoc,
                                INPUT s-CodDiv).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO FacCPedi.Glosa.
        RETURN "ADM-ERROR".   
    END.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Faccpedi.codcli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (FacCPedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' SKIP(1)
                'Comunicarse con el Administrador o' SKIP
                'con el Gestor del Maestro de Clientes'
                VIEW-AS ALERT-BOX INFORMATION
                TITLE 'VERIFICACION DEL CLIENTE'.
            APPLY 'ENTRY':U TO FacCPedi.Glosa.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* SEDE */
    FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE
        AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE 'Sede NO registrada' SKIP(1)
            'Comunicarse con el Administrador o' SKIP
            'con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'VERIFICACION DEL CLIENTE'.
        APPLY 'ENTRY':U TO Faccpedi.sede.
        RETURN 'ADM-ERROR'.
    END.
    /* CODIGO POSTAL */
    IF TRUE <> (FacCPedi.CodPos:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código Postal no debe estar en blanco' SKIP(1)
            'Comunicarse con el Administrador o' SKIP
            'con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR'.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR'.
    END.
    FIND Almtabla WHERE almtabla.Tabla = "CP" AND almtabla.Codigo = FacCPedi.CodPos:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtabla THEN DO:
        MESSAGE 'Código Postal no registrado' SKIP(1)
            'Comunicarse con el Administrador o' SKIP
            'con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR'.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR'.
    END.
    /* CONSISTENCIA DE FECHA */
    IF INPUT FacCPedi.fchven < INPUT FacCPedi.FchPed THEN DO:
        MESSAGE 'Fecha de vencimiento no debe ser menor a la fecha del pedido' 
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR'.
        APPLY 'ENTRY':U TO Faccpedi.FchVen.
        RETURN "ADM-ERROR".
    END.
    IF INPUT FacCPedi.Libre_f02 > DATE(FacCPedi.FchPed:SCREEN-VALUE) + 25 THEN DO: 
        MESSAGE 'La fecha de entrega no puede superar los 25 días de la fecha de emisión del pedido'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR'.
        APPLY 'ENTRY':U TO Faccpedi.Libre_f02.
        RETURN "ADM-ERROR".
    END.
    /* CONSISTENCIA ALMACEN DESPACHO */
    IF TRUE <> (Faccpedi.CodAlm:SCREEN-VALUE > "") THEN DO:
        MESSAGE "Almacén de Despacho no debe ser blanco" 
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR'.
        APPLY 'ENTRY':U TO Faccpedi.CodAlm.
        RETURN "ADM-ERROR".
    END.
    /* CONSISTENCIA DE IMPORTES */
    f-Tot = 0.
    FOR EACH PEDI NO-LOCK:
       F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot <= 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" 
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'ERROR IMPORTE'.
        RETURN "ADM-ERROR".   
    END.
    /**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
    f-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * DECI(FaccPedi.Tpocmb:SCREEN-VALUE).
    IF F-Tot > 700 THEN DO:
        IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND (TRUE <> (Faccpedi.Atencion:SCREEN-VALUE > ''))
            THEN DO:
            MESSAGE "Boleta de Venta Venta Mayor a S/.700.00 Ingresar Nro. DNI, Verifique... " 
                VIEW-AS ALERT-BOX INFORMATION
                TITLE 'VERIFICACION DNI'.
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
        MESSAGE 'El importe mínimo para hacer un pedido es de S/.' pImpMin SKIP(1)
            'Comunicarse con el Gestor Comercial'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'VERIFICACION IMPORTES'.
        RETURN "ADM-ERROR".
    END.
    /* ******************************************************************************** */
    /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
    /* ******************************************************************************** */
    DEFINE VAR x-ret-msg AS CHAR.
    IF s-FmaPgo = '002' THEN DO:
        /* Ic - 23Jun2020, permitir grabar pedido sin BD */
        ASSIGN
            x-boleta-deposito = FacCPedi.Libre_c03:SCREEN-VALUE
            x-cod-boleta-deposito = combo-box-doc:SCREEN-VALUE.

        IF TRUE <> (x-cod-boleta-deposito > "") THEN x-cod-boleta-deposito = "".
        IF TRUE <> (x-boleta-deposito > "") THEN x-boleta-deposito = "".

        IF x-boleta-deposito > "" THEN DO:

            IF x-cod-boleta-deposito = "" THEN DO:
                MESSAGE 'Ingrese el Cod. Doc. deposito'
                    VIEW-AS ALERT-BOX INFORMATION
                    TITLE 'VERIFICACION DOC DEPOSITO (1)'.
                RETURN "ADM-ERROR".
            END.

            RUN valida-deposito(INPUT x-cod-boleta-deposito, 
                                INPUT x-boleta-deposito, 
                                INPUT f-tot, 
                                OUTPUT x-ret-msg).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                IF TRUE <> (x-ret-msg > '') THEN x-ret-msg = 'Debe seleccionar el Doc. depósito'.
                MESSAGE x-ret-msg SKIP(1)
                    'Comunicarse con el Gestor Contraloria'
                    VIEW-AS ALERT-BOX INFORMATION 
                    TITLE 'VERIFICACION DOC DE DEPOSITO (2)'.
                APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
                RETURN 'ADM-ERROR'.
            END.
            IF x-ret-msg > "" THEN DO:
                MESSAGE x-ret-msg SKIP(1)
                    'Comunicarse con el Gestor de Contraloria'
                    VIEW-AS ALERT-BOX WARNING
                    TITLE 'VERIFICACION DOC DE DEPOSITO (3)'.
            END.
        END.
        ELSE DO:
            x-cod-boleta-deposito = "".
        END.
    END.
    ELSE ASSIGN 
        COMBO-BOX-doc:SCREEN-VALUE = ''
        FacCPedi.Libre_c03:SCREEN-VALUE = ''.
    /* ******************************************************************************** */
    /* Ic 30Set2019 - CONTRA-ENTREGA no es aplicable a CLIENTES-NUEVOS */
    /* ******************************************************************************** */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    DEFINE VAR x-moroso AS CHAR.

    RUN ccb\libreria-ccb PERSISTENT SET hProc.
    /* 
        Ic - 23Abr2020, ventas por whatsapp no validar cliente nuevo
        ya que esta venta viene como tpoped = 'E'
    */
    IF COTIZACION.tpoped <> 'E' THEN DO:
        IF faccpedi.fmapgo:SCREEN-VALUE = '001'  THEN DO:
            DEFINE VAR x-retval AS LOG.

            x-retval = NO.
            DO WITH FRAME {&FRAME-NAME} :
                RUN cliente-nuevo IN hProc (INPUT faccpedi.codcli:SCREEN-VALUE, 
                                            OUTPUT x-retval).        
            END.

            IF x-retval = YES THEN DO:
                MESSAGE 'CONTRA-ENTREGA no es aplicable para CLIENTES NUEVOS' 
                    VIEW-AS ALERT-BOX INFORMATION
                    TITLE 'VERIFICACION VENTA CONTRA-ENTREGA'.
                RETURN "ADM-ERROR".
            END.
        END.
    END.
    /* ******************************************************************************** */
    /* Ic 30Set2019 - Direccion de clientes es de CLIENTE moroso no pasa */
    /* ******************************************************************************** */
    x-moroso = "".
    DO WITH FRAME {&FRAME-NAME} :
        RUN direccion-de-moroso IN hProc (INPUT faccpedi.codcli:SCREEN-VALUE, 
                                          INPUT fill-in-sede:SCREEN-VALUE,
                                          INPUT faccpedi.fmapgo:SCREEN-VALUE,
                                          OUTPUT x-moroso).        
    END.

    DELETE PROCEDURE hProc.

    IF x-moroso <> "" THEN DO:
        MESSAGE 'ATENCION : La dirección de entrega pertenece ' SKIP
            'a un cliente con deuda calificada como morosidad' SKIP
            'El pedido va ir obligatoriamente a evaluación de créditos y cobranzas' SKIP(1)
            'Comunicarse con el Gestor de Créditos y Cobranzas'
            VIEW-AS ALERT-BOX WARNING
            TITLE 'VERIFICACION CLIENTE MOROSO'.
    END.
    /* **************************************************************************** */
    /* RHC 13/07/2020 NO artículo tipo SV ni Drop Shipping */
    /* **************************************************************************** */
    DEF VAR x-Cuenta-Items AS INTE INIT 0 NO-UNDO.

    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
        CASE TRUE:
            WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
            OTHERWISE DO:
                FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                    VtaTabla.Tabla = "DROPSHIPPING" AND
                    VtaTabla.Llave_c1 = PEDI.CodMat 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla THEN NEXT.
            END.
        END CASE.
        x-Cuenta-Items = x-Cuenta-Items + 1.
    END.
    IF x-Cuenta-Items = 0 AND FacCPedi.TipVta:SCREEN-VALUE <> "Si" THEN DO:
        MESSAGE 'Debido a las características de esta venta'
            'es necesario que seleccione TRAMITE DOCUMENTARIO'
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCPedi.TipVta.
        RETURN 'ADM-ERROR'.
    END.
    /* **************************************************************************** */
    /* RHC 03/10/19 Trámite Documentario por Configuración */
    /* **************************************************************************** */
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
        Almacen.codalm = FacCPedi.CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
    FIND FIRST GN-DIVI WHERE gn-divi.codcia = s-codcia AND
        gn-divi.coddiv = Almacen.coddiv NO-LOCK NO-ERROR.
    FIND FIRST TabGener WHERE TabGener.CodCia = GN-DIVI.CodCia
        AND TabGener.Codigo = GN-DIVI.CodDiv
        AND TabGener.Clave = "CFGINC" NO-LOCK NO-ERROR.
    IF FacCPedi.TipVta:SCREEN-VALUE = "Si" THEN DO:
        IF (NOT AVAILABLE TabGener OR TabGener.Libre_l05 = NO) 
            THEN DO:
            MESSAGE 'Trámite Documentario NO autorizado en la división de despacho' SKIP(1)
                'Comunicarse con el Gestor de Abastecimientos'
                VIEW-AS ALERT-BOX INFORMATION
                TITLE 'VERIFICACION TRAMITE DOCUMENTARIO'.
            RETURN "ADM-ERROR".
        END.
    END.
    /* ***************************************************************************
    RHC 25/01/2018 Verificamos la linea de crédito en 3 pasos
    1. Solicitar línea de crédito activa
    2. Solicitar deuda pendiente
    3. Tomar decisión
    ***************************************************************************** */
    DEF VAR f-Importe AS DEC NO-UNDO.
    f-Importe = 0.
    FOR EACH PEDI NO-LOCK:
       f-Importe = f-Importe + PEDI.ImpLin.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN f-Importe = f-Importe - FacCpedi.Imptot.
    FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddiv = s-CodDiv
        AND B-CPEDI.coddoc = s-CodRef
        AND B-CPEDI.nroped = s-NroCot
        NO-LOCK.

    IF B-CPEDI.TpoPed = 'M' THEN RETURN 'OK'.   /*** No valida LC para Contratos Marco ***/

    RUN vta2/linea-de-credito-v2 (s-CodDiv,
                                  s-CodCli,
                                  s-FmaPgo,
                                  s-CodMon,
                                  f-Importe,
                                  YES).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        APPLY "ENTRY" TO FacCPedi.Glosa.
        RETURN "ADM-ERROR".
    END.
END.

/* Ic - 23Abr2020. Validacion para ventas por WHATSAPP */
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
    FacTabla.Tabla = "GN-DIVI" AND
    FacTabla.Codigo = s-CodDiv AND
    FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    DEFINE VAR x-validawsp AS LOG.
    x-validawsp = YES.
    VALIDAWSP:
    FOR EACH t-facdpedi NO-LOCK, FIRST Almmmatg OF t-facdpedi NO-LOCK:
        FIND FIRST PEDI WHERE t-facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE PEDI THEN DO:
            IF PEDI.canped < (t-facdpedi.canped - t-facdpedi.canate) THEN DO:
                MESSAGE "Los items de la cotización deben despacharse en su totalidad" SKIP
                    "Código: " t-facdpedi.codmat almmmatg.desmat
                    VIEW-AS ALERT-BOX INFORMATION
                    TITLE 'VALIDACION VENTAS AL 100%'.
                x-validawsp = NO.
                LEAVE VALIDAWSP.
            END.
        END.
        ELSE DO:
            MESSAGE "No debe quedarse ningún item de la Cotización pendiente de despacho" SKIP
                "Código: " t-facdpedi.codmat almmmatg.desmat
                VIEW-AS ALERT-BOX INFORMATION
                TITLE 'VALIDACION VENTAS AL 100%'.
            x-validawsp = NO.
            LEAVE VALIDAWSP.
        END.
    END.
    IF x-validawsp = NO THEN RETURN "ADM-ERROR".
END.

/* Ic - 23Jun2020  */
IF s-FmaPgo = '002' THEN DO:
    IF TRUE <> (x-boleta-deposito > "") THEN DO:
        MESSAGE "1.- Seleccionar GUARDAR para la reserva de stock según" SKIP
                "    configuración de cada division" SKIP
                "2.- Debe ASIGNAR el BD APROBADO para el PROCESO" SKIP
                "    AUTOMATICO DEL PEDIDO" SKIP
                "3.- No procesará si cliente TIENE DEUDA, pedido debe ser" SKIP
                "    aprobado por Créditos y Cobranzas"
            VIEW-AS ALERT-BOX TITLE "NOTA IMPORTANTE :".
    END.
END.

RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-deposito V-table-Win 
PROCEDURE valida-deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDeposito AS CHAR.
DEFINE INPUT PARAMETER pNumeroDeposito AS CHAR.
DEFINE INPUT PARAMETER pTot AS DEC.
DEFINE OUTPUT PARAMETER pMsgRet AS CHAR.

pMsgRet = "".

    /* Tambien puede ser A/R */
DO WITH FRAME {&FRAME-NAME}:

    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = pCodDeposito
        AND Ccbcdocu.nrodoc = FacCPedi.Libre_c03:SCREEN-VALUE
        AND Ccbcdocu.codcli = FacCPedi.CodCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.flgest <> 'P' OR Ccbcdocu.SdoAct <= 0 THEN DO:
        pMsgRet = "El " + pCodDeposito + " " + pNumeroDeposito + " NO ESTA PENDIENTE o TIENE SALDO CERO".
        /*
        MESSAGE 'Boleta de Depósito NO ESTA PENDIENTE o TIENE SALDO CERO' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
        */
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.FmaPgo <> s-FmaPgo THEN DO:
        pMsgRet = "La condición de venta de la Boleta de Depósito NO es CONTADO ANTICIPADO".
        /*
        MESSAGE 'La condición de venta de la Boleta de Depósito NO es CONTADO ANTICIPADO'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
        */
        RETURN 'ADM-ERROR'.
    END.

    /* RHC 21/05/2019 El saldo debe cubrir el PED */
    /*
        01Oct2019, Susana Leon converso con Daniel Llican y en coordinacion
                    con Julisa calderon, cuando la boleta de deposito (BD) es inferior 
                    al monto del pedido se debe derivar a la bandeja de CyC
    */

    DEFINE VAR x-saldo-bd AS DEC INIT 0.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-bd-pedido AND
                                vtatabla.llave_c1 = pNumeroDeposito AND
                                vtatabla.libre_c03 = pCodDeposito NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        /*
        MESSAGE "La BOLETA DE DEPOSITO ya esta asignado a un pedido"
            VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'ENTRY':U TO FacCPedi.Libre_c03.                
        RETURN 'ADM-ERROR'.
        */
    END.

    IF INPUT FacCPedi.CodMon = Ccbcdocu.CodMon THEN DO:
        IF Ccbcdocu.sdoact < pTot THEN DO:
            pMsgRet = "El saldo del " + pCodDeposito + " NO cubre el monto total" + CHR(13) + CHR(10) +
                        "El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas".
            /*
            MESSAGE 'El saldo de la Boleta de Depósito NO cubre el monto total' SKIP
                    'El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas'
                VIEW-AS ALERT-BOX INFORMATION.
            */
        END.
    END.
    ELSE DO:
        IF Ccbcdocu.codmon = 1 THEN DO:
            IF Ccbcdocu.sdoact < (pTot * DECI(FaccPedi.Tpocmb:SCREEN-VALUE)) THEN DO:
                pMsgRet = "El saldo del " + pCodDeposito + " NO cubre el monto total" + CHR(13) + CHR(10) +
                            "El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas".
                /*
                MESSAGE 'El saldo de la Boleta de Depósito NO cubre el monto total' SKIP
                        'El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas'
                    VIEW-AS ALERT-BOX INFORMATION.
                */
            END.
        END.
        ELSE DO:
            IF Ccbcdocu.sdoact < (pTot / DECI(FaccPedi.Tpocmb:SCREEN-VALUE)) THEN DO:
                pMsgRet = "El saldo del " + pCodDeposito + " NO cubre el monto total" + CHR(13) + CHR(10) +
                            "El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas".
                /*
                MESSAGE 'El saldo de la Boleta de Depósito NO cubre el monto total' SKIP
                        'El pedido va ir obligatoriamente a evaluacion de creditos y cobranzas'
                    VIEW-AS ALERT-BOX INFORMATION.
                */
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
/* **************************************************************************************** */
/* RHC 23/05/2019 CONTROL ADICIONAL: GUARDAMOS EL DETALLE Y SALDO DE LA COTIZACION
SI HAY DIFERENCIA AL MOMENTO DE GRABAR ENTONCES NO GRABAMOS NADA */
/* **************************************************************************************** */
EMPTY TEMP-TABLE t-Facdpedi.
FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
    CREATE t-Facdpedi.
    BUFFER-COPY Facdpedi TO t-Facdpedi.
END.
/* **************************************************************************************** */
/* **************************************************************************************** */
ASSIGN
    s-NroPed = FacCPedi.NroPed
    S-CODMON = FacCPedi.CodMon
    s-TpoCmb = FacCPedi.TpoCmb
    S-CODCLI = FacCPedi.CodCli
    s-NroCot = FacCPedi.NroRef
    s-FlgEnv = FacCPedi.FlgEnv
    s-codalm = FacCPedi.CodAlm
    s-PorIgv = Faccpedi.PorIgv
    s-FmaPgo = Faccpedi.FmaPgo.
/* **************************************************** */
/* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA COTIZACION */
/* **************************************************** */
DEF BUFFER B-DIVI FOR gn-divi.
FIND B-DIVI WHERE B-DIVI.codcia = COTIZACION.CodCia AND B-DIVI.coddiv = COTIZACION.Libre_c01 
    NO-LOCK NO-ERROR.
IF AVAILABLE B-DIVI THEN DO:
    ASSIGN
        s-DiasVtoPed = B-DIVI.DiasVtoPed
        s-FlgEmpaque = B-DIVI.FlgEmpaque
        s-VentaMayorista = B-DIVI.VentaMayorista.
END.
/* **************************************************** */
/* **************************************************** */
ASSIGN pFechaEntrega = faccpedi.fchent.

/* TIPO DE ABASTECIMIENTO */
ASSIGN 
    s-Tipo-Abastecimiento = FacCPedi.Libre_c02.     /* PCO o NORMAL */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-AC V-table-Win 
PROCEDURE Verifica-AC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  {vtagn/i-verifica-ac.i}

/*   DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.                                       */
/*                                                                                        */
/*   /* RHC 09/02/17 Luis Urbano solo para condciones de pago 403 */                      */
/*   ASSIGN                                                                               */
/*     Faccpedi.TpoLic = NO.                                                              */
/*                                                                                        */
/*   FIND FIRST gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.         */
/*   IF NOT AVAILABLE gn-convt OR gn-ConVt.Libre_l03 = NO THEN RETURN 'OK'.               */
/*                                                                                        */
/*   /* Control de Facturas Adelantadas */                                                */
/*   DEFINE VARIABLE x-Saldo AS DEC NO-UNDO.                                              */
/*                                                                                        */
/*   ASSIGN                                                                               */
/*       x-Saldo = 0.                                                                     */
/*   /* 1ro Buscamos los A/C por aplicar pero que tengan la misma moneda que el pedido */ */
/*   FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia  */
/*       AND Ccbcdocu.codcli = Faccpedi.CodCli                                            */
/*       AND Ccbcdocu.flgest = "P"                                                        */
/*       AND Ccbcdocu.coddoc = "A/C"                                                      */
/*       AND Ccbcdocu.CodMon = Faccpedi.CodMon:                                           */
/*       IF Ccbcdocu.SdoAct > 0 THEN x-Saldo = x-Saldo + Ccbcdocu.SdoAct.                 */
/*   END.                                                                                 */
/*                                                                                        */
/*   /* Ajustamos el saldo del A/C */                                                     */
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                                 */
/*   IF RETURN-VALUE = 'NO' THEN x-Saldo = x-Saldo + Faccpedi.imptot.                     */
/*                                                                                        */
/*   IF x-Saldo <= 0 THEN DO:                                                             */
/*       pMensaje = "NO hay A/C por aplicar".                                             */
/*       RETURN 'ADM-ERROR'.                                                              */
/*   END.                                                                                 */
/*   /* 2do Buscamos PED y O/D en trámite */                                              */
/*   FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,                            */
/*       EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia                               */
/*       AND PEDIDO.coddiv = gn-divi.coddiv                                               */
/*       AND PEDIDO.coddoc = "PED"                                                        */
/*       AND LOOKUP(PEDIDO.flgest, "V,F,R,A,C,S,E,O") = 0:                                */
/*       IF NOT (PEDIDO.codcli = Faccpedi.codcli                                          */
/*               AND PEDIDO.fchven >= TODAY                                               */
/*               AND PEDIDO.codmon = Faccpedi.codmon                                      */
/*               AND PEDIDO.TpoLic = YES)                                                 */
/*           THEN NEXT.                                                                   */
/*       x-Saldo = x-Saldo - PEDIDO.imptot.                                               */
/*   END.                                                                                 */
/*   FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,                            */
/*       EACH ORDEN NO-LOCK WHERE ORDEN.codcia = s-codcia                                 */
/*       AND ORDEN.coddiv = gn-divi.coddiv                                                */
/*       AND ORDEN.coddoc = "O/D"                                                         */
/*       AND ORDEN.codcli = Faccpedi.codcli                                               */
/*       AND ORDEN.flgest = "P"                                                           */
/*       AND ORDEN.fchven >= TODAY                                                        */
/*       AND ORDEN.codmon = Faccpedi.codmon,                                              */
/*       FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = ORDEN.codcia                          */
/*       AND PEDIDO.coddoc = ORDEN.codref                                                 */
/*       AND PEDIDO.nroped = ORDEN.nroref:                                                */
/*       IF PEDIDO.TpoLic = NO THEN NEXT.                                                 */
/*       x-Saldo = x-Saldo - ORDEN.imptot.                                                */
/*   END.                                                                                 */
/*   IF x-Saldo < Faccpedi.imptot THEN DO:                                                */
/*       pMensaje = "SALDO INSUFICIENTE DEL A/C".                                         */
/*       RETURN 'ADM-ERROR'.                                                              */
/*   END.                                                                                 */
/*   /* Actualizamos flag de  control */                                                  */
/*   ASSIGN                                                                               */
/*       Faccpedi.TpoLic = YES.                                                           */
/*                                                                                        */
/*   RETURN 'OK'.                                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

