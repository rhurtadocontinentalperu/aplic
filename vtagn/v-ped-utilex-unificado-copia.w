&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE Facdpedi.
DEFINE SHARED TEMP-TABLE PEDI-2 LIKE Facdpedi.
DEFINE SHARED TEMP-TABLE PEDI-3 LIKE Facdpedi.
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
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMinoristaContado
/*&SCOPED-DEFINE precio-venta-general pri/p-precio-utilex-contado.p*/

/* Public Variable Definitions ---                                       */
DEFINE NEW SHARED VAR input-var-4 AS CHAR.

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODREF   AS CHAR.
DEFINE SHARED VARIABLE S-NROREF   AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC-2 AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-FMAPGO   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-FLGSIT   AS CHAR.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODIGV   AS INTEGER.
DEFINE SHARED VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE SHARED VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE SHARED VARIABLE pCodAlm AS CHAR.     /* ALMACEN POR DEFECTO */
DEFINE SHARED VARIABLE s-nomcia AS CHAR.
DEFINE SHARED VARIABLE s-codbko AS CHAR.
DEFINE SHARED VARIABLE s-tarjeta  AS CHAR.
DEFINE SHARED VARIABLE s-codpro   AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv   LIKE Faccpedi.PorIgv.
DEFINE SHARED VARIABLE s-NroVale  AS CHAR.  /* MUESTRA DEL VALE CONTINENTAL */
DEFINE SHARED VARIABLE s-tpoped AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VARIABLE w-import       AS INTEGER NO-UNDO.
DEFINE VAR F-Observa AS CHAR NO-UNDO.
DEFINE VAR X-Codalm  AS CHAR NO-UNDO.
DEFINE VARIABLE s-FlgEnv AS LOG NO-UNDO.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodAlm = S-CodAlm 
               NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

x-CodAlm = S-CODALM.

DEFINE BUFFER B-CCB   FOR CcbCDocu.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.

DEFINE stream entra .

/*DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111,11111112'.*/
DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

/* RHC 23.12.04 Variable para controlar cuando un pedido se ha generado a partir de una copia */
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VAR s-documento-registro AS CHAR INIT '' NO-UNDO.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.
DEFINE VAR x-coddoc AS CHARACTER   NO-UNDO.
DEFINE VAR x-nrodoc AS CHARACTER   NO-UNDO.

DEFINE SHARED VARIABLE s-codter     LIKE ccbcterm.codter.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

/* TABLAS PARA DESCUENTO POR VOLUMEN X LINEA X DIVISION */  
DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

/* Temporal para descuento de HP, cartuchos tinta el 2do al 80% */
DEFINE TEMP-TABLE ttDsctoHP
        FIELD   tcodmat AS CHAR FORMAT 'x(6)' INIT ""
        FIELD   tpuni   AS DEC INIT 0
        FIELD   trowid  AS ROWID
        FIELD   tcanped AS DEC INIT 0.

/* Articulo impuesto a las bolas plasticas ICBPER */
DEFINE VAR x-articulo-icbper AS CHAR.
x-articulo-ICBPER = "099268".

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
&Scoped-Define ENABLED-FIELDS FacCPedi.Cmpbnte FacCPedi.fchven ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.FlgSit FacCPedi.FlgIgv ~
FacCPedi.DirCli FacCPedi.CodMon FacCPedi.RucCli FacCPedi.Atencion ~
FacCPedi.TpoCmb FacCPedi.LugEnt FacCPedi.CodVen FacCPedi.FmaPgo ~
FacCPedi.Libre_c05 FacCPedi.Libre_c03 FacCPedi.Libre_c04 FacCPedi.NroCard ~
FacCPedi.NroRef FacCPedi.Libre_c01 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.Cmpbnte FacCPedi.fchven FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.FlgSit FacCPedi.FlgIgv FacCPedi.DirCli FacCPedi.CodMon ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.TpoCmb FacCPedi.LugEnt ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.Libre_c05 FacCPedi.Libre_c03 ~
FacCPedi.Libre_c04 FacCPedi.NroCard FacCPedi.NroRef FacCPedi.Libre_c01 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-programa F-Estado F-nOMvEN ~
COMBO-BOX-Proveedor F-CndVta F-Nomtar txtNombrePersonal 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico V-table-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetSoloLetras V-table-Win 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor Vales" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-programa AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81
     FGCOLOR 9 FONT 4 NO-UNDO.

DEFINE VARIABLE txtNombrePersonal AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-programa AT ROW 4.08 COL 47.72 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FacCPedi.NroPed AT ROW 1 COL 10 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.04 COL 30 COLON-ALIGNED
     FacCPedi.FchPed AT ROW 1 COL 86 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Cmpbnte AT ROW 1.77 COL 10 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL"
          DROP-DOWN-LIST
          SIZE 12 BY 1
          BGCOLOR 14 FGCOLOR 0 FONT 6
     FacCPedi.fchven AT ROW 1.77 COL 86 COLON-ALIGNED WIDGET-ID 98
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.54 COL 10 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NomCli AT ROW 2.54 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FlgSit AT ROW 2.54 COL 88 NO-LABEL WIDGET-ID 104
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Otros", "",
"Vales CONTINENTAL", "KC":U,
"Cupón de Descuento", "CD":U,
"Cupón VIRTUAL", "CV":U
          SIZE 19 BY 3.08
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.FlgIgv AT ROW 1 COL 121 NO-LABEL WIDGET-ID 100
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11.57 BY .81
     FacCPedi.DirCli AT ROW 3.31 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
          BGCOLOR 11 FGCOLOR 1 
     FacCPedi.CodMon AT ROW 1.77 COL 121 NO-LABEL WIDGET-ID 92
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     FacCPedi.RucCli AT ROW 4.08 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 4.08 COL 31 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.TpoCmb AT ROW 2.54 COL 119 COLON-ALIGNED WIDGET-ID 120
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.LugEnt AT ROW 4.85 COL 10 COLON-ALIGNED WIDGET-ID 20
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodVen AT ROW 5.62 COL 10 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-nOMvEN AT ROW 5.62 COL 16 COLON-ALIGNED NO-LABEL
     COMBO-BOX-Proveedor AT ROW 5.62 COL 86 COLON-ALIGNED WIDGET-ID 96
     FacCPedi.FmaPgo AT ROW 6.38 COL 10 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 6.38 COL 16 COLON-ALIGNED NO-LABEL
     FacCPedi.Libre_c05 AT ROW 6.38 COL 86 COLON-ALIGNED WIDGET-ID 112 PASSWORD-FIELD 
          LABEL "Cupón de descuento" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 21 BY .81
          BGCOLOR 11 FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.Libre_c03 AT ROW 7.15 COL 86 COLON-ALIGNED WIDGET-ID 124
          LABEL "Cliente asociado" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 29.86 BY .81
     FacCPedi.Libre_c04 AT ROW 7.92 COL 86 COLON-ALIGNED WIDGET-ID 110
          LABEL "Código de Personal" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NroCard AT ROW 7.15 COL 10 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-Nomtar AT ROW 7.15 COL 23 COLON-ALIGNED NO-LABEL
     FacCPedi.NroRef AT ROW 7.92 COL 10 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vitrinas" FORMAT "X(254)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 15 FGCOLOR 12 
     txtNombrePersonal AT ROW 7.92 COL 99 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FacCPedi.Libre_c01 AT ROW 4.77 COL 112 COLON-ALIGNED WIDGET-ID 126
          LABEL "CUPON" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.96 COL 114 WIDGET-ID 118
     "Cancela con:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 2.73 COL 78 WIDGET-ID 114
     "Con IGV:" VIEW-AS TEXT
          SIZE 6.43 BY .81 AT ROW 1.08 COL 114 WIDGET-ID 116
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
      TABLE: PEDI T "SHARED" ? INTEGRAL Facdpedi
      TABLE: PEDI-2 T "SHARED" ? INTEGRAL Facdpedi
      TABLE: PEDI-3 T "SHARED" ? INTEGRAL Facdpedi
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
         HEIGHT             = 8.81
         WIDTH              = 133.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX FacCPedi.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Proveedor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-programa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c04 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN txtNombrePersonal IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF FacCPedi.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
  IF SELF:SCREEN-VALUE = "FAC"
  THEN DO:
    ASSIGN
        Faccpedi.NomCli:SENSITIVE = NO
        Faccpedi.RucCli:SENSITIVE = NO
        Faccpedi.Atencion:SENSITIVE = NO
        Faccpedi.Atencion:SCREEN-VALUE = ''.
  END.
  ELSE DO:
    ASSIGN
        Faccpedi.NomCli:SENSITIVE = YES
        Faccpedi.RucCli:SENSITIVE = NO
        Faccpedi.Atencion:SENSITIVE = YES
        Faccpedi.RucCli:SCREEN-VALUE = ''.
  END.


  /* Ic - 13Ago2020 */
  IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = "11111111111" THEN DO:
      Faccpedi.nomcli:SENSITIVE = YES.
      Faccpedi.dircli:SENSITIVE = YES.
      Faccpedi.atencion:SENSITIVE = NO.
  END.
  ELSE DO:
      Faccpedi.nomcli:SENSITIVE = NO.
      Faccpedi.dircli:SENSITIVE = NO.
      Faccpedi.atencion:SENSITIVE = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Faccpedi.CodCli:SCREEN-VALUE = "" THEN RETURN.

  Faccpedi.CodCli:SCREEN-VALUE = REPLACE(Faccpedi.CodCli:SCREEN-VALUE,".","").
  Faccpedi.CodCli:SCREEN-VALUE = REPLACE(Faccpedi.CodCli:SCREEN-VALUE,",","").

  IF Faccpedi.CodCli:SCREEN-VALUE = "" THEN RETURN.

  /* Verificar la Longuitud */
  DEFINE VAR x-data AS CHAR.
  x-data = TRIM(Faccpedi.CodCli:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.

  Faccpedi.CodCli:SCREEN-VALUE = x-data.

  s-CodCli = SELF:SCREEN-VALUE.

  FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = Faccpedi.CodCli:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:      /* CREA EL CLIENTE NUEVO */
      RUN vtamay/d-regcli (INPUT-OUTPUT S-CODCLI).
      IF TRUE <> (S-CODCLI > "" ) THEN DO:
          APPLY "ENTRY" TO Faccpedi.CodCli.
          RETURN NO-APPLY.
      END.
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
          AND  gn-clie.CodCli = S-CODCLI 
          NO-LOCK NO-ERROR.
  END.
  /* **************************************** */
  /* RHC 22/07/2020 Nuevo bloqueo de clientes */
  /* **************************************** */
  RUN pri/p-verifica-cliente (INPUT gn-clie.codcli,
                              INPUT s-CodDoc,
                              INPUT s-CodDiv).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  /* **************************************** */
  /* **************************************** */
  /* RHC 06/02/2020 */
/*   IF gn-clie.Libre_f01 <> ? AND gn-clie.Libre_f01 >= TODAY THEN DO:                                         */
/*       MESSAGE 'NO podemos emitir comprobantes el día de hoy porque el RUC aún NO está activo en SUNAT' SKIP */
/*           'Fecha de inscrición SUNAT:' gn-clie.Libre_f01                                                    */
/*           VIEW-AS ALERT-BOX ERROR.                                                                          */
/*       SELF:SCREEN-VALUE = ''.                                                                               */
/*       RETURN NO-APPLY.                                                                                      */
/*   END.                                                                                                      */
  /* BLOQUEO DEL CLIENTE */
/*   IF gn-clie.FlgSit = "I" THEN DO:                             */
/*       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR. */
/*       RETURN NO-APPLY.                                         */
/*   END.                                                         */
/*   IF gn-clie.FlgSit = "C" THEN DO:                             */
/*       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.   */
/*       RETURN NO-APPLY.                                         */
/*   END.                                                         */
  /* RHC Convenio 17.04.07 NO instituciones publicas */
  IF Gn-Clie.Canal = '00001'
  THEN DO:
    MESSAGE 'El cliente pertenece a una institución PUBLICA' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO Faccpedi.CodCli.
    RETURN NO-APPLY.
  END.
  /* RHC 27/04/2016 Control del cliente */
/*   IF FacCPedi.Cmpbnte:SCREEN-VALUE = "FAC" AND gn-clie.Libre_C01 <> "J"           */
/*       THEN DO:                                                                    */
/*       MESSAGE 'El cliente debe ser una persona jurídica' VIEW-AS ALERT-BOX ERROR. */
/*       SELF:SCREEN-VALUE = ''.                                                     */
/*       RETURN NO-APPLY.                                                            */
/*   END.                                                                            */
  /* *********************************************** */
 
  DO WITH FRAME {&FRAME-NAME}:
    IF LOOKUP (SELF:SCREEN-VALUE, x-ClientesVarios) = 0
    THEN DISPLAY 
            gn-clie.CodCli  @ Faccpedi.CodCli
            gn-clie.ruc     @ Faccpedi.Ruccli
            gn-clie.DNI     @ Faccpedi.ATENCION
            gn-clie.NroCard @ Faccpedi.NroCard
            gn-clie.NomCli  @ Faccpedi.NomCli
            gn-clie.DirCli  @ Faccpedi.DirCli.
    ASSIGN
        S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE)
        S-CODCLI = gn-clie.CodCli
        F-NomVen = "".

    IF x-ClientesVarios = SELF:SCREEN-VALUE THEN DISPLAY gn-clie.NomCli  @ Faccpedi.NomCli.

    IF LOOKUP(TRIM(Faccpedi.CodCli:SCREEN-VALUE), x-ClientesVarios) > 0
    THEN ASSIGN
            Faccpedi.NroCard:SCREEN-VALUE = ''
            Faccpedi.NroCard:SENSITIVE = NO
            F-NomTar:SCREEN-VALUE = ''.
    ELSE DO:
        ASSIGN
            Faccpedi.NroCard:SENSITIVE = YES.
        /* Tarjeta */
        FIND FIRST Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCard:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CARD 
        THEN ASSIGN
                  F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
                  Faccpedi.NroCard:SENSITIVE = NO.
        ELSE ASSIGN
                  F-NomTar:SCREEN-VALUE = ''
                  Faccpedi.NroCard:SENSITIVE = YES.
    END.

    /* LOS ALMACENES SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
    RUN vtagn/p-alm-despacho (s-coddiv, s-flgenv, s-codcli, OUTPUT s-codalm).
    /* FIN DE CARGA DE ALMACENES */

    /* Si tiene RUC o Cliente Varios, Blanquear el DNI */
    IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = "11111111111" OR 
        Faccpedi.ruccli:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "" THEN DO:
        Faccpedi.atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.

    IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = "11111111111" THEN DO:
        Faccpedi.nomcli:SENSITIVE = YES.
        Faccpedi.dircli:SENSITIVE = YES.
        Faccpedi.atencion:SENSITIVE = NO.
    END.
    ELSE DO:
        Faccpedi.nomcli:SENSITIVE = NO.
        Faccpedi.dircli:SENSITIVE = NO.
        Faccpedi.atencion:SENSITIVE = NO.
    END.

  END.
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
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = Faccpedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Proveedor V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Proveedor IN FRAME F-Main /* Proveedor Vales */
DO:
    s-codpro = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
    /* CASO TICKETS CONTINENTAL */
    IF s-CodPro = "10003814" AND s-FlgSit = "KC" THEN DO:
        ENABLE faccpedi.libre_c05 WITH FRAME {&FRAME-NAME}.
        faccpedi.libre_c05:LABEL IN FRAME {&FRAME-NAME} = "INGRESE BARRAS".
        APPLY 'ENTRY':U TO Faccpedi.Libre_c05.
    END.
    ELSE DO:
/*         DISABLE faccpedi.libre_c05 WITH FRAME {&FRAME-NAME}. */
        faccpedi.libre_c05:LABEL IN FRAME {&FRAME-NAME} = "Cupón de Descuento".
    END.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.fchven V-table-Win
ON LEAVE OF FacCPedi.fchven IN FRAME F-Main /* Vencimiento */
DO:

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                    AND  (TcmbCot.Rango1 <=  DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1
                    AND   TcmbCot.Rango2 >= DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1 )
                   NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN DO:
      
          DISPLAY TcmbCot.TpoCmb @ Faccpedi.TpoCmb
                  WITH FRAME {&FRAME-NAME}.
          S-TPOCMB = TcmbCot.TpoCmb.  
      END.
   
      RUN Procesa-Handle IN lh_Handle ('Recalculo').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FlgIgv V-table-Win
ON VALUE-CHANGED OF FacCPedi.FlgIgv IN FRAME F-Main /* Con IGV */
DO:
  S-CODIGV = IF FacCPedi.FlgIgv:SCREEN-VALUE = "YES" THEN 1 ELSE 2.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FlgSit V-table-Win
ON VALUE-CHANGED OF FacCPedi.FlgSit IN FRAME F-Main /* Situaci¾n */
DO:
    DEFINE VARIABLE c-codbkO AS CHARACTER   NO-UNDO.
    s-FlgSit = SELF:SCREEN-VALUE.
    Faccpedi.Libre_c01:SENSITIVE = NO.
    CASE s-FlgSit:
        WHEN "KC" THEN DO:
            DISABLE COMBO-BOX-Proveedor WITH FRAME {&FRAME-NAME}.                
            DISABLE faccpedi.libre_c03 WITH FRAME {&FRAME-NAME}.                
            DISABLE faccpedi.libre_c04 WITH FRAME {&FRAME-NAME}.                
            DISABLE faccpedi.libre_c05 WITH FRAME {&FRAME-NAME}.                
            /* CASO TICKETS CONTINENTAL */
            ENABLE faccpedi.libre_c05 WITH FRAME {&FRAME-NAME}.
            faccpedi.libre_c05:LABEL IN FRAME {&FRAME-NAME} = "INGRESE BARRAS".
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = '10003814'
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN COMBO-BOX-Proveedor:SCREEN-VALUE = gn-prov.codpro + ' - ' + gn-prov.nompro.
            APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Proveedor.
            APPLY 'ENTRY':U TO Faccpedi.Libre_c05.
        END.
        WHEN "CD" THEN DO:
            faccpedi.libre_c05:LABEL IN FRAME {&FRAME-NAME} = "Cupón de descuento".
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = '10003814'
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN COMBO-BOX-Proveedor:SCREEN-VALUE = gn-prov.codpro + ' - ' + gn-prov.nompro.
            ENABLE  faccpedi.libre_c05 WITH FRAME {&FRAME-NAME}.   
            APPLY 'ENTRY':U TO INTEGRAL.FacCPedi.Libre_c05.
        END.
        WHEN "CV" THEN DO:      /* RHC 09/02/2018 CUPON VIRTUAL */
            Faccpedi.Libre_c01:SENSITIVE = YES.
            Faccpedi.Libre_c05:SENSITIVE = NO.
            Faccpedi.Libre_c05:SCREEN-VALUE = ''.
            APPLY 'ENTRY':U TO FacCPedi.Libre_c01.
        END.
        OTHERWISE DO:
            DISABLE 
                faccpedi.libre_c03 
                faccpedi.libre_c04 
                faccpedi.libre_c05 
                WITH FRAME {&FRAME-NAME}.  
            ENABLE
                COMBO-BOX-Proveedor 
                WITH FRAME {&FRAME-NAME}.  
            ASSIGN
                COMBO-BOX-Proveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' '
                faccpedi.libre_c03:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
                faccpedi.libre_c04:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
                faccpedi.libre_c05:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
            ASSIGN
                s-codpro = ''
                s-codbko = ''
                s-Tarjeta = ''.
        END.
    END CASE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  F-CndVta:SCREEN-VALUE = ''.
  S-FMAPGO = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_c01 V-table-Win
ON LEAVE OF FacCPedi.Libre_c01 IN FRAME F-Main /* CUPON */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /* RHC 09/02/2018 Buscamos cupón virtual */
  DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
  FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
      AND VtaCTabla.Tabla = 'UTILEX-CUPON'
      AND VtaCTabla.Estado <> "I":
      FIND VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = s-coddiv
          AND VtaDTabla.LlaveDetalle = FacCPedi.Libre_c01:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE VtaDTabla THEN NEXT.
      IF VtaDTabla.Libre_c01 <> "A" THEN NEXT.      /* NO ACTIVADO */
      IF NOT (TODAY >= VtaDTabla.Libre_f01 AND TODAY <= VtaDTabla.Libre_f02) THEN NEXT.
      x-Ok = YES.
      FacCPedi.Libre_c05:SCREEN-VALUE = VtaDTabla.Llave.
      LEAVE.
  END.
  IF x-Ok = NO THEN DO:
      MESSAGE 'CUPON VIRTUAL no válido' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  ASSIGN
      FacCPedi.FlgSit:SENSITIVE = NO
      FacCPedi.Libre_c01:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_c04 V-table-Win
ON LEAVE OF FacCPedi.Libre_c04 IN FRAME F-Main /* Código de Personal */
DO:
    /* Ic - 20Jul2017 */
    txtNombrePersonal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
    FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                            pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        txtNombrePersonal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(pl-pers.patper) + " " + 
                            TRIM(pl-pers.matper) + " " + TRIM(pl-pers.nomper).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_c05
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_c05 V-table-Win
ON LEAVE OF FacCPedi.Libre_c05 IN FRAME F-Main /* Cupón de descuento */
DO:
  s-NroVale = SELF:SCREEN-VALUE.
  IF SELF:SCREEN-VALUE = "" THEN DO :
      FacCPedi.Libre_c04:SCREEN-VALUE = ''. /* Ic - 20Jul2017 */
      RETURN.
  END.
  CASE TRUE:
      WHEN s-FlgSit = "KC" THEN DO:
          FacCPedi.Libre_c04:SCREEN-VALUE = ''. /* Ic - 20Jul2017 */
          IF LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,4), '0001,0002,0003,0004,0005,0006,0007') = 0 THEN DO:
              MESSAGE 'BARRAS no válido' SKIP
                  'Vuelva a intentarlo'
                  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
      END.
      WHEN s-FlgSit = "CD" THEN DO:          
          /* Veamos si tiene clientes asociados */
          /* Ic - 22Nov2017 */
          FIND FIRST Vtadtabla WHERE Vtadtabla.codcia = s-codcia
              AND Vtadtabla.tabla = "UTILEX-ENCARTE"
              AND Vtadtabla.llave = SELF:SCREEN-VALUE
              AND Vtadtabla.tipo  = "CA"
              NO-LOCK NO-ERROR.
          IF AVAILABLE Vtadtabla THEN DO:
               FacCPedi.Libre_c03:SCREEN-VALUE = 'Ingrese Cliente Asociado'.
               FacCPedi.Libre_c03:SENSITIVE = YES.
               FacCPedi.Libre_c04:SENSITIVE = YES.
               APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
          END.
          FIND FIRST VtaCTabla WHERE VtaCTabla.codcia = s-codcia
              AND VtaCTabla.tabla = "UTILEX-ENCARTE"
              AND VtaCTabla.llave = SELF:SCREEN-VALUE
              AND VtaCTabla.estado = "A"
              NO-LOCK NO-ERROR.
        
        FacCPedi.Libre_c04:SENSITIVE = NO.
        IF AVAILABLE VtacTabla AND VtaCtabla.libre_l04 = YES THEN DO:            
            FacCPedi.Libre_c04:SENSITIVE = YES.
        END.

      END.

      OTHERWISE DO:
            FacCPedi.Libre_c04:SCREEN-VALUE = ''. /* Ic - 20Jul2017 */
      END.

  END CASE.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
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


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Card THEN DO:
     S-NROTAR = SELF:SCREEN-VALUE.
     RUN vtamay/D-RegCar (S-NROTAR).
     IF S-NROTAR = "" THEN DO:
         APPLY "ENTRY" TO Faccpedi.NroCard.
         RETURN NO-APPLY.
     END.
  END.
  F-NomTar:SCREEN-VALUE = ''.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TpoCmb V-table-Win
ON LEAVE OF FacCPedi.TpoCmb IN FRAME F-Main /* T/  Cambio */
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
EMPTY TEMP-TABLE PEDI-2.
EMPTY TEMP-TABLE PEDI-3.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':
        CREATE PEDI.
        BUFFER-COPY Facdpedi TO PEDI.
/*         /* KIT */                                                              */
/*         FIND FIRST AlmCKits WHERE AlmCKits.CodCia = Faccpedi.codcia            */
/*             AND AlmCKits.codmat = Facdpedi.codmat                              */
/*             NO-LOCK NO-ERROR.                                                  */
/*         IF AVAILABLE AlmCKits THEN DO:                                         */
/*             FOR EACH AlmDKits OF AlmCKits NO-LOCK,                             */
/*                 FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Facdpedi.codcia */
/*                 AND Almmmatg.codmat = AlmDKits.codmat2:                        */
/*                 CREATE PEDI.                                                   */
/*                 BUFFER-COPY Facdpedi                                           */
/*                     TO PEDI                                                    */
/*                     ASSIGN                                                     */
/*                     PEDI.codmat = AlmDKits.codmat2                             */
/*                     PEDI.undvta = Almmmatg.undstk                              */
/*                     PEDI.factor = 1                                            */
/*                     PEDI.canped = Facdpedi.canped * Almdkits.cantidad.         */
/*             END.                                                               */
/*         END.                                                                   */
/*         ELSE DO:                                                               */
/*             CREATE PEDI.                                                       */
/*             BUFFER-COPY Facdpedi TO PEDI.                                      */
/*         END.                                                                   */
    END.
    DEF VAR i-NroItm AS INT INIT 1 NO-UNDO.
    FOR EACH PEDI BY PEDI.NroItm:
        PEDI.NroItm = i-NroItm.
        i-NroItm = i-NroItm + 1.
    END.
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Vitrinas V-table-Win 
PROCEDURE Actualiza-Vitrinas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-NroRef = '' THEN RETURN.

DEF var i AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    DO i = 1 TO NUM-ENTRIES(s-NroRef):
        FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddoc = 'PPV'
            AND B-CPEDI.nroped = ENTRY(i, s-NroRef)
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN "ADM-ERROR".
        ASSIGN
            B-CPEDI.FlgEst = "C".
    END.
    ASSIGN
        Faccpedi.codref = "PPV"
        Faccpedi.nroref = s-NroRef.
END.
RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Detalle-Cotizacion V-table-Win 
PROCEDURE Asigna-Detalle-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
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

  FOR EACH PEDI:
    DELETE PEDI.
  END.
  FOR EACH PEDI-3:
    DELETE PEDI-3.
  END.
  i-NPedi = 0.

  /* CARGAMOS STOCK DISPONIBLE POR ALMACEN EN EL ORDEN DE LOS ALMACENES VALIDOS */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DETALLES:
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
      FIRST Almmmatg OF Facdpedi NO-LOCK
      BY Facdpedi.NroItm:
      DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      /* BARREMOS LOS ALMACENES VALIDOS Y DECIDIMOS CUAL ES EL MEJOR DESPACHO */
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
              MESSAGE 'Material' Facdpedi.codmat 'NO asignado al almacén' x-CodAlm
                  VIEW-AS ALERT-BOX WARNING.
              NEXT ALMACENES.
          END.
          x-StkAct = Almmmate.StkAct.
/*           RUN vtagn/Stock-Comprometido (Facdpedi.CodMat, x-CodAlm, OUTPUT s-StkComprometido). */
          RUN vtagn/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido.
          IF s-StkDis <= 0 THEN NEXT ALMACENES.
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO Facdpedi.Factor)) / Facdpedi.Factor).
          END.
          /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
              f-CanPed = TRUNCATE( (f-CanPed * Facdpedi.Factor / Almmmatg.CanEmp), 0 ) * Almmmatg.CanEmp / Facdpedi.Factor.
          END.
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
          BUFFER-COPY FacDPedi TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = s-coddoc
                  PEDI.NroPed = ''
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
              PEDI.ImpDto = ROUND( PEDI.PreUni * PEDI.CanPed * (PEDI.Por_Dsctos[1] / 100),4 ).
              PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
              IF PEDI.AftIsc 
                  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
              IF PEDI.AftIgv 
                  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
          END.
          /* FIN DE CARGA */
      END.
  END.
  HIDE FRAME F-Mensaje.

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
          IF p-Ok = YES
          THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */
      END.    
      FIND B-CPedi WHERE 
           B-CPedi.CodCia = S-CODCIA AND  
           B-CPedi.CodDiv = S-CODDIV AND  
           B-CPedi.CodDoc = Faccpedi.CodRef AND  
           B-CPedi.NroPed = Faccpedi.NroRef
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CPedi THEN B-CPedi.FlgEst = "P".
      RELEASE B-CPedi.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Pedido V-table-Win 
PROCEDURE Cancelar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE FaccPedi OR FaccPedi.FlgEst <> "P" THEN RETURN.

  IF AVAILABLE faccpedi THEN DO:          
      IF faccpedi.codcli = '11111111119' THEN DO:        
          MESSAGE "Pedido esta considerado como PRUEBA " SKIP.
                    " Imposible generar PAGO".
          RETURN .
      END.
  END.      
  /*RUN sunat\cancelar-pedido-minorista-sunat-v21 (ROWID(FacCPedi)).*/
  RUN sunat\cancelar-pedido-minorista-sunat-v3 (ROWID(FacCPedi)).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE descuento-hp_2do-dscto20xcto V-table-Win 
PROCEDURE descuento-hp_2do-dscto20xcto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE ttDsctoHP.                                             
DEFINE VAR lTotCan AS DEC.
DEFINE VAR lTotCanDscto AS INT.
DEFINE VAR lCanVen AS DEC.
DEFINE VAR lImpLin AS DEC.
                                             
lTotCan = 0.
DEFINE VAR lDesde AS DATE.
DEFINE VAR lHasta AS DATE.

/* % Dscto */
DEFINE VAR x-dscto AS DEC.
DEFINE VAR x-unidades AS DEC.
DEFINE VAR x-codigo AS CHAR.
DEFINE VAR x-nombre AS CHAR.

/*
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'DSCTO_HP_CARTUCHOS' AND
                            factabla.codigo = 'VIGENCIA' NO-LOCK NO-ERROR.
*/                            
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'DSCTO_TANTO_X_UNO' AND
                            factabla.codigo = 'VIGENCIA' NO-LOCK NO-ERROR.


/*Verificamos la vigencia */
IF NOT AVAILABLE factabla THEN RETURN "OK".

lDesde = factabla.campo-d[1].       /* Desde */
lhasta = factabla.campo-d[2].       /* Hasta */
x-dscto = factabla.valor[3].        /* %Dscto */
x-unidades = factabla.valor[1].     /* Unidades */
x-nombre = factabla.nombre.
x-codigo = "DSCTO_TANTO_X_UNO".

IF x-unidades < 0 THEN x-unidades = 0.
IF x-dscto < 0 THEN x-dscto = 0.

IF NOT (faccpedi.fchped >= lDesde AND faccpedi.fchped <= lhasta) THEN RETURN "OK".

/* No OFertas,  Ningun Vol y/o Promocional */
FOR EACH facdpedi OF faccpedi WHERE facdpedi.libre_c05 <> 'OF' AND 
                                    TRUE <> (facdpedi.libre_c04 > "") AND
                                    facdpedi.impdto = 0 AND facdpedi.impdto = 0 :
    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = 'DSCTO_TANTO_X_UNO' AND            /*DSCTO_HP_CARTUCHOS*/
                                factabla.codigo = facdpedi.codmat NO-LOCK NO-ERROR.
   
    IF AVAILABLE factabla THEN DO:
        FIND FIRST ttDsctoHP WHERE ttDsctoHP.tcodmat = facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE ttDsctoHP THEN DO:

            CREATE ttDsctoHP.
            ASSIGN ttDsctoHP.tCodMat = facdpedi.codmat
                    ttDsctoHP.tpuni = facdpedi.preuni
                    ttDsctoHP.trowid = ROWID(facdpedi)
                    ttDsctoHP.tcanped = 0.
        END.
        ASSIGN ttDsctoHP.tCanPed = ttDsctoHP.tCanPed + facdpedi.canped /*(facdpedi.canped * facdpedi.factor)*/.
        lTotCan = lTotCan + facdpedi.canped /*(facdpedi.canped * facdpedi.factor)*/.
    END.
END.

/* Si no hay articulos HP o las %Dscto o Cantidad es cero, return OK */
FIND FIRST ttDsctoHP NO-ERROR.
IF NOT AVAILABLE ttDsctoHP THEN RETURN "OK".
IF x-dscto = 0 THEN RETURN "OK".
IF x-unidades = 0 THEN RETURN "OK".

/* Si hay Dsctos HP cartuchos */
lTotCanDscto = TRUNCATE(lTotCan / x-unidades , 0).
IF lTotCanDscto > 0 THEN DO:
    
    /* Los descuentos se realizan para los que tienen caros */
    FOR EACH ttDsctoHP WHERE lTotCanDscto > 0 BY ttDsctoHP.tpuni DESC :

        /* 
            Aplicar el descuento cuyo cartuchos no tengan ningun descuento 
            promocional, x volumen, encarte o Premio
         */
        FIND FIRST facdpedi OF faccpedi WHERE   facdpedi.codcia = s-codcia AND 
                                                facdpedi.codmat = ttDsctoHP.tcodmat AND 
                                                facdpedi.libre_c05 <> 'OF' AND 
                                                TRUE <> (facdpedi.libre_c04 > "") AND
                                                facdpedi.impdto = 0 AND facdpedi.impdto = 0.
        IF AVAILABLE facdpedi THEN DO:
            lCanVen = facdpedi.canped /*(facdpedi.canped * facdpedi.factor)*/.
            ASSIGN facdpedi.porDto2 = x-dscto.       /* 20% dscto */
            IF lCanVen <= lTotCanDscto THEN DO:                
                /* Restamos los procesados */ 
                lTotCanDscto = lTotCanDscto - lCanVen.
            END.
            ELSE DO:
                /* Cuando ya se desconto todo, los demas lo ponemos con %Dsco 0 */
                lCanVen = lTotCanDscto.
                lTotCanDscto = 0.
            END.
            ASSIGN
                lImpLin = lCanVen * Facdpedi.PreUni * 
                ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[3] / 100 )                

                Facdpedi.ImpDto2 = ROUND ( lImpLin * Facdpedi.PorDto2 / 100, 2).

                /*facdpedi.libre_c04 = "HP_CARTUCHOS|" + STRING(lCanVen).*/
                facdpedi.libre_c04 = x-codigo + "|" + STRING(lCanVen) + "|" + x-nombre.

            ASSIGN
                Faccpedi.ImpDto2 = Faccpedi.ImpDto2 + Facdpedi.ImpDto2.

           /* MESSAGE lImpLin Facdpedi.ImpDto2 Facdpedi.PorDto2.*/

        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/*
    ASSIGN
        Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni * 
        ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
        ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
        ( 1 - Facdpedi.Por_Dsctos[3] / 100 )
        Facdpedi.ImpDto2 = ROUND ( Facdpedi.ImpLin * Facdpedi.PorDto2 / 100, 2).

    IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
        THEN Facdpedi.ImpDto = 0.
    ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
    ASSIGN
        Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
        Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
    IF Facdpedi.AftIsc 
        THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    IF Facdpedi.AftIgv 
        THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ASSIGN
        Faccpedi.ImpDto2 = Faccpedi.ImpDto2 + Facdpedi.ImpDto2.

*/

    /*
    FOR EACH facdpedi OF faccpedi WHERE facdpedi.libre_c05 <> 'OF' AND 
                                        TRUE <> (facdpedi.libre_c04 > "") AND
                                        facdpedi.impdto = 0 AND facdpedi.impdto = 0 :

        FIND FIRST ttDsctoHP WHERE ttDsctoHP.tcodmat = facdpedi.codmat NO-ERROR.
        IF AVAILABLE ttDsctoHP AND lTotCanDscto > 0 THEN DO:
            lCanVen = facdpedi.canped /*(facdpedi.canped * facdpedi.factor)*/.
            ASSIGN facdpedi.porDto2 = 20.       /* 20% dscto */
            IF lCanVen <= lTotCanDscto THEN DO:                
                /* Restamos los procesados */ 
                lTotCanDscto = lTotCanDscto - lCanVen.
            END.
            ELSE DO:
                lCanVen = lTotCanDscto.
                lTotCanDscto = 0.
            END.
            ASSIGN
                lImpLin = lCanVen * Facdpedi.PreUni * 
                ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[3] / 100 )

                Facdpedi.ImpDto2 = ROUND ( lImpLin * Facdpedi.PorDto2 / 100, 2).
                
                facdpedi.libre_c04 = "HP_CARTUCHOS|" + STRING(lCanVen).

            ASSIGN
                Faccpedi.ImpDto2 = Faccpedi.ImpDto2 + Facdpedi.ImpDto2.

        END.
    END.
    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuento-por-Volumen-Linea-Division V-table-Win 
PROCEDURE Descuento-por-Volumen-Linea-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/dctoxvolxlineaxutilexresumida.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envia-Pedido V-table-Win 
PROCEDURE Envia-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* CONTROL DE PEDIDOS PARA ENVIO */
  MESSAGE 'El Pedido es para enviar?' 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      TITLE 'Confirmacion de Pedidos a Enviar' UPDATE rpta-1 AS LOG.
  FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(Faccpedi) EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CPEDI THEN Faccpedi.FlgEnv = rpta-1.
  RELEASE B-CPEDI.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel V-table-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 10.
DEFINE VARIABLE x-item                  AS INTEGER .
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE x-desmon                AS CHARACTER.
DEFINE VARIABLE x-enletras              AS CHARACTER.

RUN bin/_numero(Faccpedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF Faccpedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF Faccpedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 45.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 8.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.

chWorkSheet:Columns("A:A"):NumberFormat = "0".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "@".
chWorkSheet:Columns("F:F"):NumberFormat = "0.0000".
chWorkSheet:Columns("G:G"):NumberFormat = "0.00".
chWorkSheet:Columns("H:H"):NumberFormat = "0.00".

chWorkSheet:Range("A10:H10"):Font:Bold = TRUE.
chWorkSheet:Range("A10"):Value = "Item".
chWorkSheet:Range("B10"):Value = "Codigo".
chWorkSheet:Range("C10"):Value = "Descripcion".
chWorkSheet:Range("D10"):Value = "Marca".
chWorkSheet:Range("E10"):Value = "Unidad".
chWorkSheet:Range("F10"):Value = "Precio".
chWorkSheet:Range("G10"):Value = "Cantidad".
chWorkSheet:Range("H10"):Value = "Importe".

chWorkSheet:Range("A2"):Value = "Pedido No : " + Faccpedi.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(Faccpedi.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + Faccpedi.Codcli + " " + Faccpedi.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + Faccpedi.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH Facdpedi OF Faccpedi :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = Facdpedi.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedi.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedi.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedi.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedi.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedi.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = Faccpedi.imptot.

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
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /*RUN vta2/promocion-general (INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).*/
  RUN vta2/promocion-generalv2 (Faccpedi.CodDiv, Faccpedi.CodCli, INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* RHC 14/05/2014 PROMOCIONES EXCLUYENTES DE ENCARTES */
  IF pMensaje = "**EXCLUYENTE**" THEN DO:
      /* Borramos ENCARTE */
      ASSIGN
          FacCPedi.FlgSit = ""
          s-FlgSit = ""
          FacCPedi.Libre_C05 = ""
          s-NroVale = "".
      RUN Recalcular-Precios.
  END.

/*   EMPTY TEMP-TABLE PEDI-3.                                  */
/*   FOR EACH PEDI WHERE PEDI.CanPed > 0 BREAK BY PEDI.CodMat: */
/*       IF FIRST-OF(PEDI.CodMat) THEN DO:                     */
/*           CREATE PEDI-3.                                    */
/*           BUFFER-COPY PEDI TO PEDI-3.                       */
/*       END.                                                  */
/*   END.                                                      */
/*   EMPTY TEMP-TABLE PEDI.                                    */
/*   FOR EACH PEDI-3:                                          */
/*       CREATE PEDI.                                          */
/*       BUFFER-COPY PEDI-3 TO PEDI.                           */
/*   END.                                                      */
  /* ************* FIN DE PROMOCIONES ESPECIALES ************** */

  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.
  EMPTY TEMP-TABLE PEDI-3.

  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  RUN impuesto-icbper.


  DETALLE:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      PEDI.Libre_d01 = PEDI.CanPed.
      PEDI.Libre_c01 = '*'.
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NPEDI
              Facdpedi.CanPick = Facdpedi.CanPed.   /* OJO */
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

/* rhc Graba totales y verifica restricciones por el tipo de venta */

{vta2/graba-totales-pedido-utilex.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Cabecera V-table-Win 
PROCEDURE Importar-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT parameter X-ARCHIVO AS CHAR.
IF X-Archivo = ? THEN RETURN.
Def var x as integer init 0.
Def var lin as char.
Input stream entra from value(x-archivo).

    Import stream entra unformatted lin.  
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                  AND  gn-clie.CodCli = trim(entry(1,lin,'|')) 
                 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = trim(entry(2,lin,'|')) 
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    FIND gn-convt WHERE gn-convt.Codig = trim(entry(3,lin,'|'))
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion de Pago no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.


    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                  AND  (TcmbCot.Rango1 <=  DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1
                  AND   TcmbCot.Rango2 >= DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1 )
                 NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ Faccpedi.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

    
    f-totdias = DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1.
    S-CODCLI = trim(entry(1,lin,'|')).
    S-FMAPGO = trim(entry(3,lin,'|')).
    S-CODVEN = trim(entry(2,lin,'|')).

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY  S-CODCLI @ Faccpedi.Codcli
                 Gn-Clie.NomCli @ Faccpedi.Nomcli
                 Gn-Clie.Ruc    @ Faccpedi.Ruc
                 S-CODVEN @ Faccpedi.CodVen
                 Gn-ven.NomVen @ F-Nomven
                 S-FMAPGO @ Faccpedi.FmaPgo
                 Gn-Convt.Nombr @ F-CndVta.
    END.



input stream entra close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Txt V-table-Win 
PROCEDURE Imprimir-Txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       init ""
------------------------------------------------------------------------------*/
  DEFINE VARIABLE o-file AS CHARACTER.

  IF Faccpedi.FlgEst <> "A" THEN DO:
/*      RUN VTA/d-file.r (OUTPUT o-file).*/

      RUN VTA\R-ImpTxt.r(ROWID(Faccpedi), 
                         o-file).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper V-table-Win 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  DEFINE VAR x-ultimo-item AS INT.
  DEFINE VAR x-cant-bolsas AS INT.
  DEFINE VAR x-precio-ICBPER AS DEC.
  DEFINE VAR x-alm-des AS CHAR INIT "".

  x-ultimo-item = -1.
  x-cant-bolsas = 0.

  x-precio-ICBPER = 0.0.

  /* Sacar el importe de bolsas plasticas */
    DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */
    
    RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.
    
    /* Procedimientos */
    RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).
    
    
    DELETE PROCEDURE z-hProc.                   /* Release Libreria */


  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm DESC:

      IF Almmmatg.CodFam = '086' AND Almmmatg.SubFam = '001' THEN DO:
          x-cant-bolsas = x-cant-bolsas + (PEDI.canped * PEDI.factor).
          x-alm-des = PEDI.almdes.
      END.

  END.

  x-ultimo-item = 0.
  FOR EACH PEDI WHERE PEDI.codmat = x-articulo-ICBPER :
      DELETE PEDI.
  END.

  FOR EACH PEDI BY PEDI.NroItm:
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN PEDI.implinweb = x-ultimo-item.
  END.
  FOR EACH PEDI :
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN PEDI.NroItm = PEDI.implinweb
            PEDI.implinweb = 0.
  END.

  IF x-cant-bolsas > 0 THEN DO:

      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = x-articulo-ICBPER NO-LOCK NO-ERROR.

        x-ultimo-item = x-ultimo-item + 1.

        CREATE PEDI.
        ASSIGN
          PEDI.CodCia = Faccpedi.CodCia
          PEDI.CodDiv = Faccpedi.CodDiv
          PEDI.coddoc = Faccpedi.coddoc
          PEDI.NroPed = Faccpedi.NroPed
          PEDI.FchPed = Faccpedi.FchPed
          PEDI.Hora   = Faccpedi.Hora 
          PEDI.FlgEst = Faccpedi.FlgEst
          PEDI.NroItm = x-ultimo-item
          PEDI.CanPick = 0.   /* OJO */

      ASSIGN 
          PEDI.codmat = x-articulo-ICBPER
          PEDI.UndVta = IF (AVAILABLE almmmatg) THEN Almmmatg.UndA ELSE 'UNI'
          PEDI.almdes = x-alm-des
          PEDI.Factor = 1
          PEDI.PorDto = 0
          PEDI.PreBas = x-precio-ICBPER
          PEDI.AftIgv = IF (AVAILABLE almmmatg) THEN Almmmatg.AftIgv ELSE NO
          PEDI.AftIsc = NO
          PEDI.Libre_c04 = "".
      ASSIGN 
          PEDI.CanPed = x-cant-bolsas
          PEDI.PreUni = x-precio-ICBPER
          PEDI.Por_Dsctos[1] = 0.00
          PEDI.Por_Dsctos[2] = 0.00
          PEDI.Por_Dsctos[3] = 0.00
          PEDI.Libre_d02     = 0.
      ASSIGN
          PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
          THEN PEDI.ImpDto = 0.
          ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      /* ***************************************************************** */
    
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
        THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE PEDI.ImpIsc = 0.
        IF PEDI.AftIgv 
      THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE PEDI.ImpIgv = 0.
  END.

  /* Ic - 03Oct2019, bolsas plasticas */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.

  txtNombrePersonal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  
  IF s-user-id <> 'ADMIN' THEN DO:
      /* RHC 28/03/2016 Rutrina que verifica que no haya un cierre de caja pendiente */
      RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      DEFINE VARIABLE lAnswer AS LOGICAL NO-UNDO.
      /* Verifica Monto Tope por CAJA */
      RUN ccb\p-vermtoic.p(OUTPUT lAnswer).
      IF lAnswer THEN RETURN ERROR.

      /* Busca I/C tipo "Sencillo" Activo */
      lAnswer = FALSE.
      DEFINE BUFFER b-ccbccaja FOR ccbccaja.
      FOR EACH b-ccbccaja WHERE
            b-ccbccaja.codcia = s-codcia AND
            b-ccbccaja.coddiv = s-coddiv AND
            b-ccbccaja.coddoc = "I/C" AND
            b-ccbccaja.tipo = "SENCILLO" AND
            b-ccbccaja.usuario = s-user-id AND
            b-ccbccaja.codcaja = s-codter AND
            b-ccbccaja.flgcie = "P" NO-LOCK:
            IF b-ccbccaja.flgest <> "A" THEN lAnswer = TRUE.
      END.
      IF NOT lAnswer THEN DO:
            MESSAGE
                "Se debe ingresar el I/C SENCILLO como primer movimiento"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
      END.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Correlativo NO autorizado para hacer movimientos'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  s-PorIgv = FacCfgGn.PorIgv.

  /* ENTREGA POR DELIVERY? */
  s-FlgEnv = NO.    /* OJO */

  /* LOS ALMACENES SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
  RUN vtagn/p-alm-despacho (s-coddiv, s-flgenv, "", OUTPUT s-codalm).
  /* FIN DE CARGA DE ALMACENES */

  ASSIGN
      s-Copia-Registro = NO
      s-Documento-Registro = ''
      s-FechaHora = ''
      s-FechaI = DATETIME(TODAY, MTIME)
      s-FechaT = ?
      s-CodBko = ''
      s-Tarjeta = ''
      pCodAlm = "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed.
    ASSIGN
        s-CodMon = 1
        s-CodIgv = 1
        s-CodCli = ''
        S-FMAPGO = '000'        /* << FIJO << */
        s-NroPed = ''
        s-NroCot = ''
        s-TpoCmb = 1
        s-NroTar = ""
        s-adm-new-record = 'YES'
        s-codven = '020'
        COMBO-BOX-Proveedor:SCREEN-VALUE = ' '
        s-codpro = ''.
    ASSIGN
        s-TpoCmb = Gn-Tccja.Compra
        S-NroTar = ""
        s-FlgSit = ''.
    DISPLAY 
        TODAY @ Faccpedi.FchPed
        S-TPOCMB @ Faccpedi.TpoCmb
        (TODAY + s-DiasVtoPed) @ Faccpedi.FchVen
        x-ClientesVarios @ Faccpedi.CodCli
        S-FMAPGO @ Faccpedi.fmapgo
        s-CodVen @ Faccpedi.codven.
    FacCPedi.FlgIgv:SCREEN-VALUE = IF s-CodIgv = 1 THEN 'YES' ELSE 'NO'.
    FacCPedi.Cmpbnte:SCREEN-VALUE = "BOL".
    
    ASSIGN
        S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE)
        S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE
        Faccpedi.FlgSit:SCREEN-VALUE = s-FlgSit.

/*     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA         */
/*         AND gn-clie.CodCli = Faccpedi.CodCli:SCREEN-VALUE */
/*         NO-LOCK NO-ERROR.                                 */
/*     IF AVAILABLE gn-clie                                  */
/*     THEN DO:                                              */
/*         DISPLAY                                           */
/*             gn-clie.CodCli @ Faccpedi.CodCli              */
/*             gn-clie.ruc    @ Faccpedi.Ruccli.             */
/*         IF gn-clie.Ruc = ""                               */
/*         THEN Faccpedi.Cmpbnte:SCREEN-VALUE = "TCK".       */
/*         ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC".       */
/*         ASSIGN                                            */
/*             Faccpedi.NomCli:SENSITIVE = YES               */
/*             Faccpedi.DirCli:SENSITIVE = YES.              */
/*     END.                                                  */

    FIND gn-convt WHERE gn-convt.Codig = Faccpedi.FmaPgo:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

    RUN Actualiza-Item.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    APPLY 'VALUE-CHANGED':U TO FacCPedi.Cmpbnte.
  END.

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
  DEF VAR x-Rpta AS CHAR.
  DEF VAR x-Correlativo LIKE Faccorre.correlativo NO-UNDO.

  /* 06.09.10 RUTINA PREVIA EN CASO DE DELIVERY */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' AND s-FlgEnv = YES THEN DO:
      RUN Resumen-por-Division.
      RUN vtamay/gResPed-4 (OUTPUT x-Rpta).
      IF x-Rpta = "NO" THEN UNDO, RETURN "ADM-ERROR".
      /* DEPURAMOS EL PEDIDO */
      FOR EACH T-CPEDI WHERE T-CPEDI.FlgEst = "A",
          EACH Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.coddiv = T-CPEDI.coddiv NO-LOCK:
          FOR EACH PEDI WHERE PEDI.almdes = Almacen.codalm.
              DELETE PEDI.
          END.
      END.
      FIND FIRST PEDI NO-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDI THEN DO:
          MESSAGE "NO hay registros que grabar" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN "ADM-ERROR".
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {lib/lock-genericov3.i
          &Tabla="Faccorre"
          &Condicion="Faccorre.codcia = s-codcia AND ~
          Faccorre.coddoc = s-coddoc AND ~
          Faccorre.nroser = s-nroser"
          &Bloqueo="EXCLUSIVE-LOCK"
          &Accion="RETRY"
          &Mensaje="YES"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      ASSIGN
          x-Correlativo = Faccorre.Correlativo.
      /* Verificamos que NO exista grabado el pedido */
      REPEAT:
          FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
              AND B-CPEDI.coddiv = s-coddiv
              AND B-CPEDI.coddoc = s-coddoc
              AND B-CPEDI.nroped = STRING(s-NroSer, '999') + STRING(x-Correlativo, '999999')
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE B-CPEDI THEN LEAVE.
          x-Correlativo = x-Correlativo + 1.
      END.
      ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.CodRef = s-codref
        Faccpedi.FchPed = TODAY 
        Faccpedi.PorIgv = FacCfgGn.PorIgv 
        Faccpedi.NroPed = STRING(s-NroSer,"999") + STRING(x-Correlativo,"999999")
        Faccpedi.CodDiv = S-CODDIV
        Faccpedi.TipVta = '1'
        Faccpedi.FlgEst = (IF Faccpedi.CodCli BEGINS 'SYS' THEN "I" ELSE "P")
        Faccpedi.FlgEnv = s-FlgEnv.
      ASSIGN
          s-PorIgv = FacCfgGn.PorIgv .
      /* LA VARIABLE s-codalm ES EN REALIDAD UNA LISTA DE ALMACENES VALIDOS */
      ASSIGN
          FacCPedi.CodAlm = ENTRY (1, s-CodAlm).
      /* ****************************************************************** */
      /* RHC 23.12.04 Control de pedidos hechos por copia de otro */
      IF s-Copia-Registro = YES THEN Faccpedi.CodTrans = s-Documento-Registro.       /* Este campo no se usa */
      /* ******************************************************** */
      ASSIGN
        FacCorre.Correlativo = x-Correlativo + 1.
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
      /* RHC 12/02/2018 Actualizamos el cupón Virtual
        OJO: No se puede cambiar el cupón una vez registrado */
      IF Faccpedi.FlgSit = "CV" THEN DO:
          FIND VtaDTabla WHERE VtaDTabla.CodCia = s-codcia
              AND VtaDTabla.Tabla = 'UTILEX-CUPON'
              AND VtaDTabla.Llave = FacCPedi.Libre_c05
              AND VtaDTabla.Tipo = s-coddiv
              AND VtaDTabla.LlaveDetalle = FacCPedi.Libre_c01
              AND VtaDTabla.Libre_c01 = "A"       /* SOLO ACTIVADOS */
              AND (TODAY >= VtaDTabla.Libre_f01 AND TODAY <= VtaDTabla.Libre_f02)
              AND CAN-FIND(FIRST VtaCTabla OF VtaDTabla WHERE VtaCTabla.Estado <> "I" NO-LOCK)
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE VtaDTabla THEN
              ASSIGN
              VtaDTabla.Libre_c01 = "C"       /* CERRADO */
              VtaDTabla.FchModificacion = TODAY
              VtaDTabla.UsrModificacion = s-user-id
              VtaDTabla.Libre_c04 = Faccpedi.coddoc
              VtaDTabla.Libre_c05 = Faccpedi.nroped.
          IF AVAILABLE VtaDTabla THEN RELEASE VtaDTabla.
      END.
  END.
  ELSE DO:
      RUN Borra-Pedido (TRUE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      Faccpedi.Hora   = STRING(TIME,"HH:MM")
      Faccpedi.Usuario = S-USER-ID.

  /* Proveedor */
  ASSIGN
      Faccpedi.Libre_c02 = ENTRY (1,COMBO-BOX-Proveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ' - ').

  /* Detalle del Pedido */
  RUN Resumen-Pedido.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').    /* NO afecta venta por CD */
  RUN Genera-Pedido.    /* Detalle del pedido */

  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO se pudo generar el pedido' SKIP
          'NO hay stock suficiente en los almacenes' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* ************************************************************************** */
  /* NOTA: Descuento por Encarte y Descuento por Vol. x Linea SON EXCLUYENTES,
            es decir, NO pueden darse a la vez, o es uno o es el otro */
  /* ************************************************************************** */
  /* RHC 19/02/2015 CASO EXPECIAL: FERIA PLAZA NORTE UTILEX */
  IF s-CodDiv <> '00509' THEN DO:
      RUN vta2/utilex-descuento-por-encarte (ROWID(Faccpedi)).
      RUN Descuento-por-Volumen-Linea-Division.
      RUN vta2/pkitxencarte ( ROWID(Faccpedi) ).

      /* Ic - 04Ago2017, Promocion Cartuchos HP Lleva 2 el 2do dscto 20% */
        RUN descuento-hp_2do-dscto20xcto.

      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          MESSAGE 'No se pudo armar la promoción' VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  /* ************************************************************************** */
  RUN Graba-Totales.
  /* ************************************************************** */
  /* Actualizamos Pre-Pedidos de Vitrina */
  RUN Actualiza-Vitrinas.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RELEASE FacCorre.

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
  s-adm-new-record = 'NO'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'Se va a proceder a con la copia' SKIP
      'El pedido ORIGINAL puede que sea anulado' SKIP
      'Continuamos (S-N)?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Correlativo NO autorizado para hacer movimientos'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
  ASSIGN
    S-CODMON = Faccpedi.CodMon
    S-CODCLI = Faccpedi.CodCli
    S-TPOCMB = Faccpedi.TpoCmb
    s-NroTar = Faccpedi.NroCard
    S-FMAPGO = Faccpedi.FmaPgo.
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  FOR EACH PEDI-2:
    DELETE PEDI-2.
  END.
  FOR EACH PEDI-3:
    DELETE PEDI-3.
  END.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE PEDI.
    BUFFER-COPY Facdpedi TO PEDI.
    /* SI HUBIERA UN PICKING ANTERIOR */
    IF Faccpedi.FchPed = TODAY AND Faccpedi.FlgEst = 'C' 
        THEN PEDI.CanPed = PEDI.CanPick.
    IF PEDI.CanPed = 0 THEN DELETE PEDI.
    /* ****************************** */
  END.
  /* RHC 13.02.08 anular el pedido original */
  IF Faccpedi.FlgEst = 'P' THEN DO:
      ASSIGN Faccpedi.FlgEst = 'A'.
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
  END.
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed.
      ASSIGN
          s-TpoCmb = FacCfgGn.TpoCmb[1].
      DISPLAY 
          TODAY @ Faccpedi.FchPed
          S-TPOCMB @ Faccpedi.TpoCmb
          TODAY @ Faccpedi.FchVen.
      F-Estado:SCREEN-VALUE = ''.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalcular-Precios').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  s-Copia-Registro = YES.   /* <<< OJO >>> */
  s-Documento-Registro = '*' + STRING(Faccpedi.coddoc, 'x(3)') + ' ' + ~
      STRING(Faccpedi.nroped, 'x(9)').

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
    IF Faccpedi.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF Faccpedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido TOTALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "E" THEN DO:
       MESSAGE "No puede eliminar un pedido cerrado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
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
      /* RHC 12/02/2018 Actualizamos el cupón Virtual */
      IF Faccpedi.FlgSit = "CV" THEN DO:
          FIND VtaDTabla WHERE VtaDTabla.CodCia = s-codcia
              AND VtaDTabla.Tabla = 'UTILEX-CUPON'
              AND VtaDTabla.Llave = FacCPedi.Libre_c05
              AND VtaDTabla.Tipo = s-coddiv
              AND VtaDTabla.LlaveDetalle = FacCPedi.Libre_c01
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE VtaDTabla THEN
              ASSIGN
              VtaDTabla.Libre_c01 = "A"       /* ACTIVO */
              VtaDTabla.FchModificacion = TODAY
              VtaDTabla.UsrModificacion = s-user-id
              VtaDTabla.Libre_c04 = ""
              VtaDTabla.Libre_c05 = "".
          IF AVAILABLE VtaDTabla THEN RELEASE VtaDTabla.
      END.
      /* BORRAMOS DETALLE */
      RUN Borra-Pedido (FALSE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN
          FacCPedi.Glosa = "ANULADO POR" + s-user-id + "EL DIA" + STRING(TODAY)
          Faccpedi.FlgEst = 'A'.
      FIND CURRENT Faccpedi NO-LOCK.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse').
      
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
      COMBO-BOX-Proveedor:SENSITIVE = NO.
      
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
      RUN vtagn/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
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
      FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].

/*       /* CONTROL DE TARJETAS DE CREDITO */                                     */
/*       ASSIGN                                                                   */
/*           FILL-IN-4:SCREEN-VALUE = ''                                          */
/*           FILL-IN-5:SCREEN-VALUE = ''.                                         */
/*       IF Faccpedi.Libre_c03 <> '' THEN DO:                                     */
/*           FIND cb-tabl WHERE                                                   */
/*               cb-tabl.Tabla = "04" AND                                         */
/*               cb-tabl.codigo = Faccpedi.Libre_c03                              */
/*               NO-LOCK NO-ERROR.                                                */
/*           IF AVAILABLE cb-tabl THEN FILL-IN-4:SCREEN-VALUE = cb-tabl.Nombre.   */
/*       END.                                                                     */
/*       IF Faccpedi.Libre_c04 <> '' THEN DO:                                     */
/*           FIND FIRST FacTabla WHERE                                            */
/*               FacTabla.CodCia = s-codcia AND                                   */
/*               FacTabla.Tabla = "TC" AND                                        */
/*               FacTabla.codigo = Faccpedi.Libre_c04                             */
/*               NO-LOCK NO-ERROR.                                                */
/*           IF AVAILABLE Factabla THEN FILL-IN-5:SCREEN-VALUE = FacTabla.Nombre. */
/*       END.                                                                     */

      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = Faccpedi.Libre_c02
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN DO:
          COMBO-BOX-Proveedor = gn-prov.codpro + ' - ' + gn-prov.nompro.
          DISPLAY COMBO-BOX-Proveedor.
      END.
      ELSE DO:
          COMBO-BOX-Proveedor = ' '.
          DISPLAY COMBO-BOX-Proveedor.
      END.
      /* Ic - 20Jul2017 */
      txtNombrePersonal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
      FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                              pl-pers.codper = faccpedi.libre_c04 NO-LOCK NO-ERROR.
      IF AVAILABLE pl-pers THEN DO:
          txtNombrePersonal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(pl-pers.patper) + " " + 
                              TRIM(pl-pers.matper) + " " + TRIM(pl-pers.nomper).
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
        Faccpedi.RucCli:SENSITIVE = NO
        Faccpedi.fchven:SENSITIVE = NO
        Faccpedi.TpoCmb:SENSITIVE = NO
        Faccpedi.FmaPgo:SENSITIVE = NO
        Faccpedi.NroRef:SENSITIVE = NO
        Faccpedi.FlgIgv:SENSITIVE = NO
        COMBO-BOX-Proveedor:SENSITIVE = YES
        Faccpedi.CodMon:SENSITIVE = NO
        Faccpedi.Libre_c01:SENSITIVE = NO
        Faccpedi.libre_c03:SENSITIVE = NO
        Faccpedi.libre_c04:SENSITIVE = NO
        Faccpedi.libre_c05:SENSITIVE = NO.

    RUN GET-ATTRIBUTE("ADM-NEW-RECORD").

    IF RETURN-VALUE = "NO" AND Faccpedi.FlgSit = "KC" 
        THEN ASSIGN
                COMBO-BOX-Proveedor:SENSITIVE = YES.
    IF RETURN-VALUE = "NO" AND FAccpedi.FlgSit = "CD" 
        THEN ASSIGN
                Faccpedi.libre_c05:SENSITIVE = YES.
    IF RETURN-VALUE = "NO" AND Faccpedi.FlgSit = "CV" 
        THEN ASSIGN Faccpedi.FlgSit:SENSITIVE = NO.
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
  IF FacCPedi.FlgEst <> 'C' THEN RETURN.
  
  DEF VAR RPTA AS CHAR NO-UNDO.

  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RPTA = "ERROR".        
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  
  IF RPTA = "ERROR" THEN DO:
      MESSAGE "No tiene Autorizacion Para Imprimir"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = Faccpedi.Cmpbnte
        AND CcbCDocu.CodPed = faccpedi.coddoc
        AND CcbCDocu.NroPed = faccpedi.nroped
        NO-LOCK NO-ERROR.
  IF AVAILABLE ccbcdocu AND ccbcdocu.coddoc = 'FAC'
      THEN RUN vtamin/r-tick500-caja (ROWID(ccbcdocu)).
  IF AVAILABLE ccbcdocu AND ccbcdocu.coddoc = 'TCK' 
      THEN RUN vtamin/r-tick500-caja (ROWID(ccbcdocu)).

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
       COMBO-BOX-Proveedor:ADD-LAST(' ').
      FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = s-codcia,
          FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = Vtactickets.codpro
          BREAK BY Vtactickets.codpro:
          IF FIRST-OF(Vtactickets.codpro) THEN DO:
              COMBO-BOX-Proveedor:ADD-LAST(gn-prov.codpro + ' - ' + gn-prov.nompro).
              s-codpro = gn-prov.codpro.
          END.
      END.

      fill-in-programa:SCREEN-VALUE = THIS-PROCEDURE:NAME.
      fill-in-programa:VISIBLE = NO.

      IF USERID("DICTDB") = "ADMIN" OR USERID("DICTDB") = "MASTER" THEN DO:
        fill-in-programa:VISIBLE = YES.
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  s-adm-new-record = 'NO'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Pedido V-table-Win 
PROCEDURE Numero-de-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  IF L-INCREMENTA THEN
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV AND
           Faccorre.Codalm = S-CodAlm
           EXCLUSIVE-LOCK NO-ERROR.
/*  ELSE 
 *       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
 *            FacCorre.CodDoc = S-CODDOC AND
 *            FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.*/
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroPed = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios V-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.


FOR EACH PEDI WHERE PEDI.Libre_c05 <> "OF", FIRST Almmmatg OF PEDI NO-LOCK:
    F-FACTOR = PEDI.Factor.
    x-CanPed = PEDI.CanPed.
    RUN {&precio-venta-general} (
                        s-CodDiv,
                        s-CodMon,
                        s-TpoCmb,
                        OUTPUT s-UndVta,
                        OUTPUT f-Factor,
                        Almmmatg.CodMat,
                        x-CanPed,
                        4,
                        s-flgsit,       /* s-codbko, */
                        s-codbko,
                        s-tarjeta,
                        s-codpro,
                        s-NroVale,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT z-Dsctos,
                        OUTPUT x-TipDto
                        ).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        DELETE PEDI.
        NEXT.
    END.
    ASSIGN 
        PEDI.Factor = f-Factor
        PEDI.UndVta = s-UndVta
        PEDI.PreUni = F-PREVTA
        PEDI.PreBas = F-PreBas 
        PEDI.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        PEDI.PorDto2 = 0        /* el precio unitario */
        PEDI.ImpDto2 = 0
        PEDI.Por_Dsctos[2] = z-Dsctos
        PEDI.Por_Dsctos[3] = Y-DSCTOS 
        PEDI.AftIgv = ( IF s-CodIgv = 1 THEN Almmmatg.AftIgv ELSE NO )
        PEDI.AftIsc = Almmmatg.AftIsc
        PEDI.ImpIsc = 0
        PEDI.ImpIgv = 0
        PEDI.Libre_c04 = X-TIPDTO.
    ASSIGN
        PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
        ( 1 - PEDI.Por_Dsctos[3] / 100 )
        PEDI.ImpDto2 = ROUND ( PEDI.ImpLin * PEDI.PorDto2 / 100, 2).
    IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
        THEN PEDI.ImpDto = 0.
    ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
         ASSIGN
             PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
             PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
         IF PEDI.AftIsc 
             THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
         IF PEDI.AftIgv 
             THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ).
END.
RUN Procesa-Handle IN lh_handle ("browse").

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
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-Pedido V-table-Win 
PROCEDURE Resumen-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* RHC 25.08.06
     COMO LOS ITEMS SE REPITEN ENTONCES PRIMERO LOS AGRUPAMOS POR CODIGO */
  
  EMPTY TEMP-TABLE PEDI-2.
  FOR EACH PEDI BY PEDI.CodMat:
      FIND PEDI-2 WHERE PEDI-2.CodMat = PEDI.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDI-2 THEN CREATE PEDI-2.
      BUFFER-COPY PEDI TO PEDI-2
          ASSIGN
            PEDI-2.CanPed = PEDI-2.CanPed + PEDI.CanPed
            PEDI-2.ImpIgv = PEDI-2.ImpIgv + PEDI.ImpIgv
            PEDI-2.ImpDto = PEDI-2.ImpDto + PEDI.ImpDto
            PEDI-2.ImpDto2 = PEDI-2.ImpDto2 + PEDI.ImpDto2
            PEDI-2.ImpIsc = PEDI-2.ImpIsc + PEDI.ImpIsc
            PEDI-2.ImpLin = PEDI-2.ImpLin + PEDI.ImpLin.
  END.

  EMPTY TEMP-TABLE PEDI.
  FOR EACH PEDI-2:
      CREATE PEDI.
      BUFFER-COPY PEDI-2 TO PEDI.
  END.
  EMPTY TEMP-TABLE PEDI-2.

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
     RUN Procesa-Handle IN lh_Handle ('Recalculo').
/*      IF Faccpedi.NroRef <> ''                              */
/*          THEN RUN Procesa-Handle IN lh_Handle ('Pagina3'). */
/*         ELSE RUN Procesa-Handle IN lh_Handle ('Pagina2').  */
     RUN Procesa-Handle IN lh_Handle ('browse').
     APPLY 'ENTRY':U TO Faccpedi.NomCli IN FRAME {&FRAME-NAME}.
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
  DEFINE VARIABLE X-FREC AS INTEGER INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
    IF Faccpedi.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    /* **************************************** */
    /* RHC 22/07/2020 Nuevo bloqueo de clientes */
    /* **************************************** */
    RUN pri/p-verifica-cliente (INPUT Faccpedi.CodCli:SCREEN-VALUE,
                                INPUT s-CodDoc,
                                INPUT s-CodDiv).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.
    /* **************************************** */
    /* **************************************** */
/*     RUN vtagn/p-gn-clie-01 (Faccpedi.CodCli:SCREEN-VALUE , s-coddoc). */
/*     IF RETURN-VALUE = "ADM-ERROR" THEN DO:                            */
/*         APPLY "ENTRY" TO FacCPedi.CodCli.                             */
/*         RETURN "ADM-ERROR".                                           */
/*     END.                                                              */
    IF LOOKUP(TRIM(Faccpedi.CodCli:SCREEN-VALUE), x-ClientesVarios) = 0
        AND LENGTH(TRIM(Faccpedi.CodCli:SCREEN-VALUE)) <> 11
        THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    /***** Valida Ingreso de Ruc. *****/
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" 
            AND Faccpedi.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Faccpedi.CodCli.
        RETURN "ADM-ERROR".   
    END.      
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (Faccpedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO Faccpedi.CodCli.
            RETURN 'ADM-ERROR'.
        END.
    END.

    IF Faccpedi.CodVen:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.CodVen.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = Faccpedi.CodVen:screen-value 
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.CodVen.
       RETURN "ADM-ERROR".   
    END.
    ELSE DO:
        IF gn-ven.flgest = "C" THEN DO:
            MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Faccpedi.CodVen.
            RETURN "ADM-ERROR".   
        END.
    END.
    
    FIND FIRST gn-convt WHERE gn-convt.Codig = Faccpedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
 
    IF Faccpedi.NroCar:SCREEN-VALUE <> "" THEN DO:
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar:SCREEN-VALUE
                            NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Card THEN DO:
          MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO Faccpedi.NroCar.
          RETURN "ADM-ERROR".   
      END.   
    END.     

    /* Si BOLETA DE VENTA con RUC - Karim Mujica, 19Ago2020 */
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "BOL" AND 
        NOT (TRUE <> (FacCPedi.RucCli:SCREEN-VALUE > "")) THEN DO:
       MESSAGE 'Se va a generar una BOLETA DE VENTA con R.U.C.' SKIP 
               '¿ Esta seguro de Genar el Comprobante ?' VIEW-AS ALERT-BOX QUESTION
               BUTTONS YES-NO UPDATE rpta AS LOG.
           IF rpta = NO THEN RETURN "ADM-ERROR".
    END.

    FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
        IF FIRST-OF(ALMDES) THEN DO:
           X-FREC = X-FREC + 1.
        END.        
        F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".   
    END.
    /* Verificamos DNI */
    IF Faccpedi.Atencion:SCREEN-VALUE > '' THEN DO:
        IF LENGTH(Faccpedi.Atencion:SCREEN-VALUE, "CHARACTER") <> 8 THEN DO:
            MESSAGE "DNI debe tener 8 números" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO Faccpedi.Atencion.
           RETURN "ADM-ERROR".   
        END.
        /* SOLOS números */
        DEF VAR x-DNI AS INT64 NO-UNDO.
        ASSIGN x-DNI = INT64(Faccpedi.Atencion:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'DNI debe contener solo números' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Faccpedi.Atencion.
            RETURN "ADM-ERROR".   
        END.
    END.
    DEFINE VAR X-TOT AS DECI INIT 0.
    X-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * DECI(Faccpedi.Tpocmb:SCREEN-VALUE).
    IF F-Tot > ImpMinDNI THEN DO:
       IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND TRUE <> (Faccpedi.Atencion:SCREEN-VALUE > '') 
           THEN DO:
           MESSAGE "Boleta de Venta Venta Mayor a" ImpMinDNI SKIP "Ingresar Nro. DNI, Verifique... " 
               VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO Faccpedi.Atencion.
          RETURN "ADM-ERROR".   
       END.
    END.
    /* ENCARTE */
    CASE Faccpedi.FlgSit:SCREEN-VALUE:
        WHEN "CV" THEN DO:  /* Cupón Virtual */
            /* RHC 09/02/2018 Buscamos cupón virtual */
            FIND VtaDTabla WHERE VtaDTabla.CodCia = s-codcia
                AND VtaDTabla.Tabla = 'UTILEX-CUPON'
                AND VtaDTabla.Llave = FacCPedi.Libre_c05:SCREEN-VALUE
                AND VtaDTabla.Tipo = s-coddiv
                AND VtaDTabla.LlaveDetalle = FacCPedi.Libre_c01:SCREEN-VALUE
                AND VtaDTabla.Libre_c01 = "A"       /* SOLO ACTIVADOS */
                AND (TODAY >= VtaDTabla.Libre_f01 AND TODAY <= VtaDTabla.Libre_f02)
                AND CAN-FIND(FIRST VtaCTabla OF VtaDTabla WHERE VtaCTabla.Estado <> "I" NO-LOCK)
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaDTabla THEN DO:
                MESSAGE 'CUPON VIRTUAL no válido' VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY":U TO Faccpedi.Libre_c01.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN "CD" THEN DO:  /* Cupón de Descuento */
            FIND VtaCTabla WHERE VtaCTabla.codcia = s-codcia
                AND VtaCTabla.tabla = "UTILEX-ENCARTE"
                AND VtaCTabla.llave = INPUT FacCPedi.Libre_c05
                AND VtaCTabla.estado = "A"
                NO-LOCK NO-ERROR.
            IF Faccpedi.CodCli:SCREEN-VALUE <> 'SYS00000001'
                AND (NOT AVAILABLE VtaCTabla OR NOT (TODAY >= VtaCTabla.FechaInicial AND TODAY <= VtaCTabla.FechaFinal))
                THEN DO:
                MESSAGE "Cupón de descuento NO válido o ya venció el cupón de descuento"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FacCPedi.Libre_c05.
                RETURN 'ADM-ERROR'.
            END.
            /* RHC 20/01/2016 */
            IF FacCPedi.Libre_c03:SENSITIVE = YES AND FacCPedi.Libre_c03:SCREEN-VALUE BEGINS 'Ingrese Cliente'
                THEN DO:
                MESSAGE 'Debe seleccionar un CLIENTE ASOCIADO' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
                RETURN 'ADM-ERROR'.
            END.
            /* Ic - 22Nov2017 */
            IF FacCPedi.Libre_c03:SENSITIVE = YES AND FacCPedi.Libre_c03:SCREEN-VALUE <> "" 
                AND NOT (FacCPedi.Libre_c03:SCREEN-VALUE BEGINS 'Ingrese Cliente') THEN DO:
                FIND FIRST Vtadtabla WHERE Vtadtabla.codcia = s-codcia
                    AND Vtadtabla.tabla = "UTILEX-ENCARTE"
                    AND Vtadtabla.llave = INPUT FacCPedi.Libre_c05
                    AND Vtadtabla.llavedetalle = INPUT FacCPedi.Libre_c03
                    AND Vtadtabla.tipo  = "CA"
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Vtadtabla THEN DO:
                    MESSAGE 'Debe ingresar un CLIENTE ASOCIADO' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO FacCPedi.Libre_c03.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF FacCPedi.Libre_c04:SENSITIVE = YES AND FacCPedi.Libre_c04:SCREEN-VALUE = ''
                THEN DO:
                MESSAGE 'Debe ingresar el CODIGO DEL PERSONAL' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FacCPedi.Libre_c04.
                RETURN 'ADM-ERROR'.
            END.
            /* Ic - 20Jul2017 */
            IF AVAILABLE VtaCtabla THEN DO:
                IF VtacTabla.libre_l04 = YES THEN DO:
                    /* El Encarte requiere codigo de Personal */
                    FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                                            pl-pers.codper = faccpedi.libre_c04:SCREEN-VALUE NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE pl-pers THEN DO:
                        MESSAGE 'CODIGO DEL PERSONAL NO existe' VIEW-AS ALERT-BOX ERROR.
                        APPLY 'ENTRY':U TO FacCPedi.Libre_c04.
                        RETURN 'ADM-ERROR'.
                    END.
                END.     
                IF VtacTabla.libre_l03 = YES THEN DO:
                    /* El Encarte requiere DNI */
                    IF LENGTH(faccpedi.Atencion:SCREEN-VALUE) <> 8 THEN DO:
                        MESSAGE 'Ingrese el DNI correctamente' VIEW-AS ALERT-BOX ERROR.
                        APPLY 'ENTRY':U TO FacCPedi.Atencion.
                        RETURN 'ADM-ERROR'.
                    END.
                END.     
            END.
        END.
        WHEN "KC" THEN DO:      /* Vales Continental */
            /* Ic - 04Mar2016 */
            IF s-CodPro = '10003814' THEN DO:
                DEFINE BUFFER h-vtatabla FOR vtatabla.
                FIND FIRST h-vtatabla WHERE h-vtatabla.codcia  = s-codcia
                    AND  h-vtatabla.tabla = 'VUTILEXTCK' 
                    AND  h-vtatabla.llave_c1 = s-NroVale NO-LOCK NO-ERROR.
                IF NOT AVAILABLE h-vtatabla  THEN DO:
                    /* Ic - 04Mar2016, si en vez de Pistoletear lo digita el vale x problemas de lectura */
                    FIND FIRST h-vtatabla WHERE h-vtatabla.codcia  = s-codcia
                        AND  h-vtatabla.tabla = 'VUTILEXTCK' 
                        AND  h-vtatabla.llave_c3 = s-NroVale NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE h-vtatabla THEN DO:
                        MESSAGE 'Vale DIGITADO NO EXISTE' VIEW-AS ALERT-BOX ERROR.
                         APPLY 'ENTRY':U TO FacCPedi.Libre_c05.
                         RETURN 'ADM-ERROR'.                                   
                    END.
                END.
             END.
        END.
    END CASE.
  END.

  IF Faccpedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "11111111111" THEN DO:
    IF NOT getSoloLetras(SUBSTRING(Faccpedi.Nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,2)) THEN DO:
          MESSAGE 'Nombre no pasa la validacion para SUNAT' VIEW-AS ALERT-BOX ERROR.
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
DEFINE VAR RPTA AS CHAR.

/* /* RHC 13.02.08 no se puede modificar */           */
/* MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR. */
/* RETURN 'ADM-ERROR'.                                */

IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
IF LOOKUP(Faccpedi.FlgEst, 'P,I') = 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* Si tiene atenciones parciales tambien se bloquea */
ASSIGN
    S-CODMON = Faccpedi.CodMon
    S-CODCLI = Faccpedi.CodCli
    S-TPOCMB = Faccpedi.TpoCmb
    X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2
    s-NroTar = Faccpedi.NroCard
    S-FMAPGO = Faccpedi.FmaPgo
    s-FlgSit = Faccpedi.flgsit
    s-FechaI = DATETIME(TODAY, MTIME)
    s-adm-new-record = 'NO'
    S-NROPED = Faccpedi.NroPed
    s-NroCot = Faccpedi.NroRef
    s-FlgEnv = Faccpedi.FlgEnv
    s-codpro = Faccpedi.Libre_C02
    s-codbko = Faccpedi.Libre_c03
    s-Tarjeta = Faccpedi.Libre_c04
    s-NroVale = Faccpedi.Libre_c05
    s-PorIgv = Faccpedi.PorIgv
    pCodAlm = "".

IF Faccpedi.fchven < TODAY THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ventas-Frustradas V-table-Win 
PROCEDURE Ventas-Frustradas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-CanPed AS DEC.
  DEF VAR f-Factor AS DEC.
  DEF VAR f-PreBas AS DEC.
  DEF VAR f-PreVta AS DEC.
  DEF VAR f-Dsctos AS DEC.
  DEF VAR y-Dsctos AS DEC.
  DEF VAR SW-LOG1 AS LOG.
    
  FIND FIRST PEDI-2 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PEDI-2 THEN RETURN.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN RETURN.
  
  CREATE B-CPEDI.
  BUFFER-COPY Faccpedi TO B-CPEDI
    ASSIGN
        B-CPEDI.CodDoc = 'V/F'.
  FOR EACH PEDI-2:
    CREATE B-DPEDI.
    BUFFER-COPY PEDI-2 TO B-DPEDI
        ASSIGN
            B-DPEDI.CodCia = B-CPEDI.CodCia
            B-DPEDI.CodDoc = B-CPEDI.CodDoc
            B-DPEDI.NroPed = B-CPEDI.NroPed.
    FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI-2.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi 
    THEN BUFFER-COPY Facdpedi 
            EXCEPT Facdpedi.CodCia
                    Facdpedi.CodDoc
                    Facdpedi.NroPed
                    Facdpedi.CanPed
            TO B-DPEDI
            ASSIGN B-DPEDI.canate = Facdpedi.canped.
    ELSE DO:        /* CALCULAMOS EL PRECIO DE VENTA */
        FIND Almmmatg OF B-DPEDI NO-LOCK NO-ERROR.
        FIND Almtconv WHERE 
             Almtconv.CodUnid  = Almmmatg.UndBas AND  
             Almtconv.Codalter = B-DPEDI.UndVta
             NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            x-CanPed = B-DPEDI.CanPed.
            RUN vtamay/PrecioConta (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            S-FMAPGO,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT SW-LOG1).
            ASSIGN
                B-DPEDI.Factor = F-FACTOR
                B-DPEDI.PreBas = F-PreBas 
                B-DPEDI.AftIgv = Almmmatg.AftIgv 
                B-DPEDI.AftIsc = Almmmatg.AftIsc 
                B-DPEDI.Por_DSCTOS[2] = Almmmatg.PorMax
                B-DPEDI.Por_Dsctos[3] = Y-DSCTOS 
                B-DPEDI.PorDto = F-DSCTOS
                B-DPEDI.PreUni = F-PREVTA.
        END.
    END.
  END.  
  /* CALCULOS FINALES */
  FOR EACH B-DPEDI OF B-CPEDI,
        FIRST Almmmatg OF B-DPEDI NO-LOCK:
    ASSIGN 
      B-DPEDI.ImpDto = ROUND( B-DPEDI.PreBas * (B-DPEDI.PorDto / 100) * B-DPEDI.CanPed , 2 )
      B-DPEDI.ImpLin = ROUND( B-DPEDI.PreUni * B-DPEDI.CanPed , 2 ).
    IF B-DPEDI.AftIsc 
    THEN B-DPEDI.ImpIsc = ROUND(B-DPEDI.PreBas * B-DPEDI.CanPed * (Almmmatg.PorIsc / 100),4).
    IF B-DPEDI.AftIgv 
    THEN  B-DPEDI.ImpIgv = B-DPEDI.ImpLin - ROUND(B-DPEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
  END.
  
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

  ASSIGN
    B-CPEDI.ImpDto = 0
    B-CPEDI.ImpIgv = 0
    B-CPEDI.ImpIsc = 0
    B-CPEDI.ImpTot = 0
    B-CPEDI.ImpExo = 0.
  FOR EACH B-DPEDI OF B-CPEDI NO-LOCK: 
    B-CPEDI.ImpDto = B-CPEDI.ImpDto + B-DPEDI.ImpDto.
    F-Igv = F-Igv + B-DPEDI.ImpIgv.
    F-Isc = F-Isc + B-DPEDI.ImpIsc.
    B-CPEDI.ImpTot = B-CPEDI.ImpTot + B-DPEDI.ImpLin.
    IF NOT B-DPEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + B-DPEDI.ImpLin.
  END.
  ASSIGN
    B-CPEDI.ImpIgv = ROUND(F-IGV,2)
    B-CPEDI.ImpIsc = ROUND(F-ISC,2)
    B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                        B-CPEDI.ImpDto - B-CPEDI.ImpExo
    B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto
    B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2)
    B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpTot / (1 + B-CPEDI.PorIgv / 100),2)
    B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpVta
    B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                        B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   RELEASE B-CPEDI.
     
END PROCEDURE.
/*
  ASSIGN 
    PEDI.CodCia = S-CODCIA
    PEDI.Factor = F-FACTOR
    PEDI.NroItm = I-NroItm.
    /*PEDI.ALMDES = S-CODALM.*/
         
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico V-table-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetSoloLetras V-table-Win 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

