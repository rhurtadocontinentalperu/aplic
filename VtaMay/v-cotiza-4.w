&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE T-DPedi LIKE FacDPedi.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CODIGV   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INT.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.
DEFINE SHARED VARIABLE pCodAlm AS CHAR.     /* ALMACEN POR DEFECTO */

DEFINE VARIABLE s-pendiente-ibc AS LOG.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-DiasAmpCot LIKE GN-DIVI.DiasAmpCot.

/* Local Variable Definitions ---                                       */
DEFINE VAR s-cndvta-validos AS CHAR.
DEFINE VAR F-Observa AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.

DEF VAR i-NroPed AS INT.

DEFINE BUFFER B-CCB FOR CcbCDocu.
DEFINE BUFFER B-CPedi FOR FacCPedi.

DEFINE TEMP-TABLE t-lgcocmp NO-UNDO LIKE LG-COCmp.
DEFINE TEMP-TABLE t-lgdocmp NO-UNDO LIKE LG-DOCmp.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.TpoCmb FacCPedi.DirCli FacCPedi.fchven FacCPedi.RucCli ~
FacCPedi.Atencion FacCPedi.FchEnt FacCPedi.Sede FacCPedi.ordcmp ~
FacCPedi.LugEnt FacCPedi.Cmpbnte FacCPedi.Glosa FacCPedi.CodMon ~
FacCPedi.CodVen FacCPedi.FlgIgv FacCPedi.FmaPgo FacCPedi.NroCard 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.DirCli ~
FacCPedi.fchven FacCPedi.RucCli FacCPedi.Atencion FacCPedi.FchEnt ~
FacCPedi.Sede FacCPedi.ordcmp FacCPedi.LugEnt FacCPedi.Cmpbnte ~
FacCPedi.Glosa FacCPedi.CodMon FacCPedi.CodVen FacCPedi.FlgIgv ~
FacCPedi.FmaPgo FacCPedi.NroCard 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-sede F-nOMvEN F-CndVta ~
F-Nomtar 

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
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1 COL 52 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1 COL 94 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.NomCli AT ROW 1.81 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.TpoCmb AT ROW 1.81 COL 94 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.62 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.fchven AT ROW 2.62 COL 94 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.RucCli AT ROW 3.42 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 3.42 COL 26 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.FchEnt AT ROW 3.42 COL 94 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     BUTTON-10 AT ROW 4.23 COL 6 WIDGET-ID 10
     FacCPedi.Sede AT ROW 4.23 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-sede AT ROW 4.23 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FacCPedi.ordcmp AT ROW 4.23 COL 94 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.LugEnt AT ROW 5.04 COL 9 COLON-ALIGNED WIDGET-ID 20
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Cmpbnte AT ROW 5.04 COL 94 COLON-ALIGNED WIDGET-ID 6
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 7 BY 1
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Glosa AT ROW 5.85 COL 6.28 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodMon AT ROW 5.85 COL 96 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodVen AT ROW 6.65 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-nOMvEN AT ROW 6.65 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FlgIgv AT ROW 6.65 COL 96 NO-LABEL WIDGET-ID 22
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.FmaPgo AT ROW 7.46 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-CndVta AT ROW 7.46 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.NroCard AT ROW 8.27 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-Nomtar AT ROW 8.27 COL 21 COLON-ALIGNED NO-LABEL
     "Con IGV:" VIEW-AS TEXT
          SIZE 6.43 BY .81 AT ROW 6.65 COL 89 WIDGET-ID 26
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6.12 COL 89
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
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-DPedi T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 9.23
         WIDTH              = 118.57.
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
/* SETTINGS FOR COMBO-BOX FacCPedi.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
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
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
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
            FILL-IN-Sede:SCREEN-VALUE = output-var-2
            FacCPedi.LugEnt:SCREEN-VALUE = output-var-2
            FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE FacCPedi.Glosa:SCREEN-VALUE)
            FacCPedi.Sede:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF FacCPedi.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'BOL' THEN DISPLAY "" @ FacCPedi.Ruccli.
        IF SELF:SCREEN-VALUE = 'FAC' THEN DO:
            DISPLAY "" @ FacCPedi.Atencion.
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = NO
                FacCPedi.NomCli:SENSITIVE = NO
                FacCPedi.Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli.
                IF FacCPedi.RucCli:SCREEN-VALUE = ''  THEN FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
            IF FacCPedi.CodCli:SCREEN-VALUE = '11111111112'
            THEN ASSIGN
                    FacCPedi.DirCli:SENSITIVE = YES
                    FacCPedi.NomCli:SENSITIVE = YES
                    FacCPedi.RucCli:SENSITIVE = YES.
        END.
        ELSE DO:
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = YES
                FacCPedi.NomCli:SENSITIVE = YES
                FacCPedi.Atencion:SENSITIVE = YES.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF SELF:SCREEN-VALUE = S-CODCLI THEN RETURN. 

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vtagn/p-fmapgo-01 (s-CodCli, OUTPUT s-cndvta-validos).

  DISPLAY 
    gn-clie.NomCli @ Faccpedi.NomCli
    gn-clie.Ruc    @ Faccpedi.RucCli
    gn-clie.DirCli @ Faccpedi.DirCli
    ENTRY(1, gn-clie.CndVta) @ FacCPedi.FmaPgo
    gn-clie.NroCard @ FacCPedi.NroCard
    gn-clie.CodVen WHEN Faccpedi.CodVen:SCREEN-VALUE = '' @ Faccpedi.CodVen 
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
    S-CNDVTA = ENTRY(1, gn-clie.CndVta)
    S-NROTAR = gn-clie.NroCard.

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = S-NROTAR NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            FacCPedi.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            FacCPedi.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF FacCPedi.FmaPgo:SCREEN-VALUE = '900' 
    AND FacCPedi.Glosa:SCREEN-VALUE = ''
  THEN FacCPedi.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND (TcmbCot.Rango1 <= gn-convt.totdias
    AND  TcmbCot.Rango2 >= gn-convt.totdias)
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
       DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
               WITH FRAME {&FRAME-NAME}.
       S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* Determina si es boleta o factura */
  IF FacCPedi.RucCli:SCREEN-VALUE = ''
  THEN Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = 'FAC'.
  APPLY 'VALUE-CHANGED' TO Faccpedi.Cmpbnte.

  IF SELF:SCREEN-VALUE = '11111111112' THEN DO:
      FacCPedi.FmaPgo:SENSITIVE = NO.
      APPLY 'LEAVE':U TO FacCPedi.FmaPgo.
  END.
  ELSE FacCPedi.FmaPgo:SENSITIVE = YES.
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
    AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt V-table-Win
ON LEAVE OF FacCPedi.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
    IF INPUT {&self-name} = ? THEN RETURN NO-APPLY.
    IF INPUT {&self-name} < TODAY THEN RETURN NO-APPLY.
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
      
          DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
                  WITH FRAME {&FRAME-NAME}.
          S-TPOCMB = TcmbCot.TpoCmb.  
      END.
/*       RUN Procesa-Handle IN lh_Handle ('Recalculo'). */
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


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON F8 OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
OR left-mouse-dblclick OF Faccpedi.fmapgo
DO:
    input-var-1 = s-cndvta-validos.
    input-var-2 = ''.
    input-var-3 = ''.

    RUN vta/d-cndvta.
    IF output-var-1 = ? THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = output-var-2.
    f-cndvta:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  F-CndVta:SCREEN-VALUE = ''.
  s-CndVta = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

  /* Filtrado de las condiciones de venta */
  IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
      MESSAGE 'Condición de venta NO autorizado para este cliente'
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  /* Ubica la Condicion Venta */
  IF AVAILABLE gn-convt 
  THEN DO:
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND (TcmbCot.Rango1 <= gn-convt.totdias
        AND  TcmbCot.Rango2 >= gn-convt.totdias)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
            WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.
  END.  
  IF FacCPedi.FmaPgo:SCREEN-VALUE = '900' 
    AND FacCPedi.Glosa:SCREEN-VALUE = ''
  THEN FacCPedi.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  RUN Procesa-Handle IN lh_Handle ('Recalculo').
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
     RUN vta/D-RegCar (INPUT S-NROTAR).
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


&Scoped-define SELF-NAME FacCPedi.RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.RucCli V-table-Win
ON LEAVE OF FacCPedi.RucCli IN FRAME F-Main /* Ruc */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10 ó 15' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEAVE OF FacCPedi.Sede IN FRAME F-Main /* Sede */
DO:
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied
    THEN ASSIGN 
          FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
          FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
          FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TpoCmb V-table-Win
ON LEAVE OF FacCPedi.TpoCmb IN FRAME F-Main /* T/  Cambio */
DO:
    S-TPOCMB = DEC(FacCPedi.TpoCmb:SCREEN-VALUE).
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-datos-cliente V-table-Win 
PROCEDURE Actualiza-datos-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAILABLE gn-clie AND s-codcli <> '' THEN RUN vtamay/gVtaCli (ROWID(gn-clie)).

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
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      FOR EACH facdPedi OF faccPedi NO-LOCK:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Supermercado V-table-Win 
PROCEDURE Asigna-Supermercado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
  DEF VAR x-CodMat LIKE PEDI.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE PEDI.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE PEDI.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE PEDI.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF FacCPedi.CodVen:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero el codigo del vendedor'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FacCPedi.CodVen.
      RETURN NO-APPLY.
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FacCPedi.FmaPgo.
      RETURN NO-APPLY.
    END.
  END.

  SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Archivo texto (.txt)' '*.txt'
  RETURN-TO-START-DIR
  TITLE 'Selecciona al archivo texto'
  MUST-EXIST
  USE-FILENAME
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.

  FOR EACH PEDI:
      DELETE PEDI.
  END.
    
  INPUT FROM VALUE(x-Archivo).
  TEXTO:
  REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' 
    THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = ENTRY(6,x-Linea).
        FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).
    END.
    IF x-Linea BEGINS 'DTM' 
    THEN DO:
        x-Item = ENTRY(5,x-Linea).
        ASSIGN
            FacCPedi.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +
                                                                                  SUBSTRING(x-Item,5,2) + '/' +
                                                                                 SUBSTRING(x-Item,1,4)) )
            NO-ERROR.
    END.
    /* Sede y Lugar de Entrega */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                /*s-codcli = gn-clie.codcli.*/
                Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
            END.
        END.
    END.

    /* DETALLE */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES
    THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.

        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
        END.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            CREATE PEDI.
            ASSIGN 
                PEDI.CodCia = s-codcia
                PEDI.codmat = x-CodMat
                PEDI.Factor = 1 
                PEDI.CanPed = x-CanPed
                PEDI.NroItm = x-NroItm 
                PEDI.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                PEDI.ALMDES = S-CODALM
                PEDI.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
            /* RHC 09.08.06 IGV de acuerdo al cliente */
            IF LOOKUP(TRIM(Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}), '20100070970,20109072177,20100106915,20504912851') > 0
            THEN ASSIGN
                    PEDI.ImpIgv = x-ImpIgv 
                    PEDI.ImpLin = x-ImpLin
                    PEDI.PreUni = (PEDI.ImpLin / PEDI.CanPed).
            ELSE ASSIGN
                    PEDI.ImpIgv = x-ImpIgv 
                    PEDI.ImpLin = x-ImpLin + x-ImpIgv
                    PEDI.PreUni = (PEDI.ImpLin / PEDI.CanPed).
            PEDI.PreBas = PEDI.PreUni.
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
  /* Variable de control */
  s-import-ibc = YES.
  /* PINTAMOS INFORMACION */
  APPLY 'LEAVE':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.

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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH FacDPedi OF FacCPedi:
      DELETE FacDPedi.
    END.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-IBC V-table-Win 
PROCEDURE Control-IBC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rpta AS CHAR.
                                  
/* Cargamos el temporal con las diferencias */
s-pendiente-ibc = NO.
RUN Procesa-Handle IN lh_handle ('IBC').
FIND FIRST T-DPEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI THEN RETURN 'OK'.

MESSAGE 'todo bien'.
RUN vta/d-ibc-dif (OUTPUT x-Rpta).
IF x-Rpta = "ADM-ERROR" THEN RETURN "ADM-ERROR".

{adm/i-DocPssw.i s-CodCia 'IBC' ""UPD""}

/* Continua la grabacion */
s-pendiente-ibc = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Items V-table-Win 
PROCEDURE Copia-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH PEDI:
    DELETE PEDI.
  END.
  FOR EACH facdPedi OF faccPedi NO-LOCK:
      CREATE PEDI.
      BUFFER-COPY FacDPedi 
          TO PEDI
          ASSIGN
            PEDI.CanAte = 0
            PEDI.FlgEst = "P"
            PEDI.Por_Dsctos = 0
            PEDI.PorDto = 0
            PEDI.PorDto2 = 0.
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

RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

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

chWorkSheet:Range("A2"):Value = "Cotizacion: " + FacCPedi.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(FacCPedi.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + FacCPedi.Codcli + " " + FacCPedi.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + FacCPedi.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH FacDPedi OF FacCPedi BY FacDPedi.NroItm :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedi.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = FacCPedi.imptot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel2 V-table-Win 
PROCEDURE Genera-Excel2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE faccpedi.ImpTot.

DEFINE VARIABLE C-NomVen  AS CHAR FORMAT "X(30)".
DEFINE VARIABLE C-Descli  AS CHAR FORMAT "X(60)".
DEFINE VARIABLE C-Moneda  AS CHAR FORMAT "X(7)".
DEFINE VARIABLE C-SimMon  AS CHAR FORMAT "X(7)".
DEFINE VARIABLE C-NomCon  AS CHAR FORMAT "X(30)".
DEFINE VARIABLE W-DIRALM  AS CHAR FORMAT "X(50)".
DEFINE VARIABLE X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.
DEFINE VARIABLE x-desmon                AS CHARACTER.

RUN bin/_numero(faccpedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF faccpedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF faccpedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

IF faccpedi.FlgIgv THEN DO:
   F-ImpTot = faccpedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = faccpedi.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = faccpedi.CodCia AND  
     gn-ven.CodVen = faccpedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = faccpedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = faccpedi.codcli + ' - ' + faccpedi.Nomcli     .

FIND gn-ConVt WHERE gn-ConVt.Codig = faccpedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = faccpedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF faccpedi.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "CotizacionTienda.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 40.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 20.

/*Datos Cliente*/
t-Column = 9.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.NroPed. 
t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia : " .
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 


t-Column = t-Column + 4.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

/*
chWorkSheet:Range("G20"):Value = "(" + c-simmon + ")". 
chWorkSheet:Range("H20"):Value = "(" + c-simmon + ")". 
*/

t-Column = t-Column + 2.
P = t-Column.

FOR EACH facdpedi OF faccpedi 
    BREAK BY facdpedi.NroPed
        BY facdpedi.NroItm DESC:
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = facdpedi.CodMat
                        NO-LOCK NO-ERROR.
    /*iColumn = iColumn + 1.*/
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.NroItm.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.preuni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.implin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

END.

t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF faccpedi.flgigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  faccpedi.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 2.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  FOR EACH PEDI NO-LOCK BY PEDI.NroItm: 
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY PEDI TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
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
{vtamay/graba-totales.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-entre-companias V-table-Win 
PROCEDURE Importar-entre-companias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  
  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF FacCPedi.CodCli:SCREEN-VALUE  = '' OR FacCPedi.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'Debe ingresar primero el cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCPedi.CodCli.
        RETURN.
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FacCPedi.FmaPgo.
      RETURN NO-APPLY.
    END.
  END.

  ASSIGN
    x-Cab = '\\inf251\intercambio\OCC*' + TRIM(FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}) +
            "*.*".

  SYSTEM-DIALOG GET-FILE x-Cab
  FILTERS 'Ordenes de compra' 'OCC*.*'
  INITIAL-DIR "\\inf251\intercambio"
  RETURN-TO-START-DIR
  TITLE 'Selecciona la Orden de compra'
  MUST-EXIST
  USE-FILENAME
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.

  x-Det = REPLACE(x-Cab, 'OCC', 'OCD').

  /* Datos de Cabecera */
  FOR EACH t-lgcocmp:
    DELETE t-lgcocmp.
  END.
  FOR EACH t-lgdocmp:
    DELETE t-lgdocmp.
  END.
  
  INPUT FROM VALUE(x-cab).
  REPEAT:
    CREATE t-lgcocmp.
    IMPORT t-lgcocmp.
  END.
  INPUT CLOSE.
  INPUT FROM VALUE(x-det).
  REPEAT:
    CREATE t-lgdocmp.
    IMPORT t-lgdocmp.
  END.
  INPUT CLOSE.

  FIND FIRST t-lgcocmp WHERE t-lgcocmp.codpro <> ''.

  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH PEDI:
          DELETE PEDI.
      END.
    
    ASSIGN
        FacCPedi.CodMon:SCREEN-VALUE = STRING(t-lgcocmp.codmon, '9')
        FacCPedi.ordcmp:SCREEN-VALUE = STRING(t-lgcocmp.nrodoc, '999999').

    FOR EACH t-lgdocmp WHERE t-lgdocmp.codmat <> '':
        CREATE PEDI.
        ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.codmat = t-lgdocmp.CodMat
            PEDI.Factor = 1
            PEDI.CanPed = t-lgdocmp.CanPedi
            PEDI.NroItm = x-Item
            PEDI.UndVta = t-lgdocmp.UndCmp
            PEDI.ALMDES = S-CODALM
            PEDI.AftIgv = (IF t-lgdocmp.IgvMat > 0 THEN YES ELSE NO)
            PEDI.ImpIgv = (IF t-lgdocmp.igvmat > 0 THEN t-lgdocmp.ImpTot / (1 + t-lgdocmp.IgvMat / 100) * t-lgdocmp.IgvMat / 100 ELSE 0)
            PEDI.ImpLin = t-lgdocmp.ImpTot
            PEDI.PreUni = PEDI.ImpLin / PEDI.CanPed
            PEDI.PreBas = PEDI.PreUni.
        x-Item = x-Item + 1.
    END.
  END.
  
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.FlgIgv:SENSITIVE IN FRAME {&FRAME-NAME} = NO.


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

  IF FacCPedi.FlgEst <> "A" THEN DO:
/*      RUN VTA/d-file.r (OUTPUT o-file).*/

      RUN VTA\R-ImpTxt.r(ROWID(FacCPedi), 
                         o-file).

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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      s-Copia-Registro = NO
      s-Import-IBC = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed.
    ASSIGN
        s-CodMon = 1
        s-CodIgv = 1
        s-CodCli = ''
        s-CndVta = ''
        s-NroPed = ''
        s-TpoCmb = 1
        s-NroTar = ""
        s-adm-new-record = 'YES'
        pCodAlm = "".
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND  gn-clie.CodCli = FacCfgGn.CliVar
      NO-LOCK NO-ERROR.
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
        AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    DISPLAY 
        TODAY @ FacCPedi.FchPed
        TODAY @ FacCPedi.FchEnt
        S-TPOCMB @ FacCPedi.TpoCmb
        (TODAY + s-DiasVtoCot) @ FacCPedi.FchVen 
        FacCfgGn.CliVar @ FacCPedi.CodCli
        s-CodVen @ Faccpedi.codven.

    FacCPedi.FlgIgv:SCREEN-VALUE = IF s-CodIgv = 1 THEN 'YES' ELSE 'NO'.

    ASSIGN
        S-CODMON = INTEGER(FacCPedi.CodMon:SCREEN-VALUE)
        /*S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE*/
        S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.
    RUN Actualiza-Item.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    APPLY 'ENTRY':U TO FacCPedi.CodCli.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.FchPed = TODAY 
          FacCPedi.PorIgv = FacCfgGn.PorIgv 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCPedi.TpoPed = "".
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
      IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN Faccpedi.flgest = 'E'.
      IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".
  END.
  ELSE DO:
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Observa = F-Observa.

  RUN Genera-Pedido.    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Graba-Totales.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
     FaccPedi.NomCli:SENSITIVE = NO.
     FaccPedi.RucCli:SENSITIVE = NO.
     FaccPedi.DirCli:SENSITIVE = NO.
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
  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      s-CodMon = Faccpedi.codmon
      /*s-CodCli = Faccpedi.codcli*/
      s-CodCli = ''
      s-CndVta = Faccpedi.fmapgo
      s-NroPed = ''
      s-TpoCmb = 1
      s-NroTar = Faccpedi.nrocard
      s-adm-new-record = 'YES'
      s-codigv = ( IF FacCPedi.FlgIgv = YES THEN 1 ELSE 2)
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-Import-IBC = NO.
  RUN Copia-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ FaccPedi.NroPed
             "" @ F-Estado.
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
        AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    DISPLAY 
        TODAY @ FacCPedi.FchPed
        TODAY @ FacCPedi.FchEnt
        S-TPOCMB @ FacCPedi.TpoCmb
        (TODAY + s-DiasVtoCot) @ FacCPedi.FchVen
        s-CodVen @ Faccpedi.CodVen.
  END.
  APPLY 'LEAVE':U TO Faccpedi.codcli.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

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
    IF FacCPedi.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar una cotizacion TOTALMENTE atendida" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "X" THEN DO:
       MESSAGE "No puede eliminar una cotizacion CERRADA" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
       MESSAGE "No puede eliminar una cotizacion PARCIALMENTE atendida" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedi THEN RETURN 'ADM-ERROR'.
    ASSIGN                 
        FacCPedi.FchChq = TODAY
        FacCPedi.FlgEst = 'A'
        FacCPedi.Glosa  = "ANULADO POR: " + s-user-id + " EL DIA: " + STRING(TODAY).
    FIND CURRENT FacCPedi NO-LOCK.
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
      RUN vtagn/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
      F-NomVen:screen-value = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      IF FaccPedi.FchVen < TODAY AND FacCPedi.FlgEst = 'P'
          THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = FacCPedi.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
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
        FacCPedi.RucCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.fchven:SENSITIVE = NO
        FacCPedi.TpoCmb:SENSITIVE = NO
        FacCPedi.FlgIgv:SENSITIVE = NO
        FacCPedi.CodMon:SENSITIVE = NO
        BUTTON-10:SENSITIVE = YES.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        ASSIGN
            FacCPedi.CodCli:SENSITIVE = NO
            FacCPedi.fchven:SENSITIVE = NO
            FacCPedi.FmaPgo:SENSITIVE = NO
            FacCPedi.FlgIgv:SENSITIVE = NO
            FacCPedi.TpoCmb:SENSITIVE = NO
            FacCPedi.NroCard:SENSITIVE = NO.
        IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'
        THEN ASSIGN
            FacCPedi.DirCli:SENSITIVE = YES
            FacCPedi.NomCli:SENSITIVE = YES.
    END.
    IF RETURN-VALUE = 'NO' AND s-Import-IBC = YES THEN DO:
        ASSIGN
            FacCPedi.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
            FacCPedi.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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
  
  IF FacCPedi.FlgEst <> "A" THEN DO:
      RUN vtamay/r-cotiza-4 (ROWID(FacCPedi)).
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

  F-Observa = FacCPedi.Observa.
  RUN vtamay/d-cotiza (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        YES,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
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
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN i-NroPed = FacCorre.Correlativo.
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
            WHEN 'FmaPgo' THEN input-var-1 = ''.
            WHEN 'CodPos' THEN input-var-1 = 'CP'.
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

  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
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
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
    IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    /* BLOQUEO DEL CLIENTE */
    RUN vtagn/p-gn-clie-01 (Faccpedi.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    IF NOT (s-coddoc = 'C/M' OR s-coddoc = 'P/M') THEN DO:
        IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
        THEN DO:
          MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacCPedi.CodCli.
          RETURN 'ADM-ERROR'.
        END.
    END.

    IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" AND FacCpedi.RucCli:SCREEN-VALUE = '' THEN DO:
       MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.      

    IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodVen.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodVen.
       RETURN "ADM-ERROR".   
    END.
    ELSE DO:
        IF gn-ven.flgest = "C" THEN DO:
            MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.CodVen.
            RETURN "ADM-ERROR".   
        END.
    END.
    
    IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = "000" THEN DO:
       MESSAGE "Condicion Venta no debe ser contado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
 
/*     IF FacCPedi.CodPos:SCREEN-VALUE = ''                   */
/*     THEN DO:                                               */
/*         MESSAGE 'Ingrese el código postal'                 */
/*             VIEW-AS ALERT-BOX ERROR.                       */
/*         APPLY 'ENTRY':U TO FacCPedi.CodPos.                */
/*         RETURN 'ADM-ERROR':U.                              */
/*     END.                                                   */
/*     FIND almtabla WHERE almtabla.tabla = 'CP'              */
/*         AND almtabla.codigo = FacCPedi.CodPos:SCREEN-VALUE */
/*         NO-LOCK NO-ERROR.                                  */
/*     IF NOT AVAILABLE almtabla                              */
/*     THEN DO:                                               */
/*         MESSAGE 'Código Postal no Registrado'              */
/*             VIEW-AS ALERT-BOX ERROR.                       */
/*         APPLY 'ENTRY':U TO FacCPedi.CodPos.                */
/*         RETURN 'ADM-ERROR':U.                              */
/*     END.                                                   */

    IF Faccpedi.NroCar:SCREEN-VALUE <> "" THEN DO:
      FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Card THEN DO:
          MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.NroCar.
          RETURN "ADM-ERROR".   
      END.   
    END.           

    /* RHC 04.02.10 CONTROL DE DESPACHOS POR DIA */
    DEF VAR x-Cuentas AS INT NO-UNDO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchent = INPUT Faccpedi.FchEnt:
            x-Cuentas = x-Cuentas + 1.
        END.            
    END.
    ELSE DO:
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.flgest <> 'A'
            AND ROWID(B-CPEDI) <> ROWID(Faccpedi)
            AND B-CPEDI.fchent = INPUT Faccpedi.FchEnt:
            x-Cuentas = x-Cuentas + 1.
        END.            
    END.
    IF s-DiasAmpCot > 0 AND x-Cuentas > s-DiasAmpCot THEN DO:
        MESSAGE 'Ya se cubrieron los despachos para ese día' SKIP
            'Máximo de despachos =' s-DiasAmpCot
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO Faccpedi.FchEnt.
        RETURN 'ADM-ERROR'.
    END.
 
    FOR EACH PEDI NO-LOCK:
        F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.

    /* Verificamos los montos de acuerdo al almacen de despacho */
    F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
            THEN F-TOT
            ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > 700 
        AND (FacCPedi.Atencion:SCREEN-VALUE = '' 
            OR LENGTH(FacCPedi.Atencion:SCREEN-VALUE, "CHARACTER") < 8)
    THEN DO:
        MESSAGE "Venta Mayor a 700.00" SKIP
                "Debe ingresar en DNI"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".   
    END.
   /* RHC 15.12.09 CONTROL DE IMPORTE MINIMO POR COTIZACION */
   DEF VAR pImpMin AS DEC NO-UNDO.
   RUN gn/pMinCotPed (s-CodCia,
                      s-CodDiv,
                      s-CodDoc,
                      OUTPUT pImpMin).
   IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
       MESSAGE 'El importe mínimo para cotizar es de S/.' pImpMin
           VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.

   /* rhc 22.06.09 Control de Precios IBC */
   IF s-Import-IBC = YES THEN DO:
        RUN CONTROL-IBC.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
   END.
   /* RHC 23.06.10 COntrol de sedes por autoservicios
        Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
   FIND FacTabla WHERE FacTabla.codcia = s-codcia
       AND FacTabla.Tabla = 'AU'
       AND FacTabla.Codigo = Faccpedi.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE FacTabla AND Faccpedi.Sede:SCREEN-VALUE = '' THEN DO:
       MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
   END.
   IF Faccpedi.Sede:SCREEN-VALUE <> '' THEN DO:
       FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = Faccpedi.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clied THEN DO:
            MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
   END.


    IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
        AND FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
        AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
       MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.NroCard.
       RETURN "ADM-ERROR".   
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900'
        AND FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
        AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
       MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
            VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.NroCard.
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
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"C,A,X") > 0 THEN  RETURN "ADM-ERROR".

/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-CODIGV = ( IF FacCPedi.FlgIgv THEN 1 ELSE 2 )
    S-TPOCMB = FacCPedi.TpoCmb
    s-NroTar = FacCPedi.NroCard
    S-CNDVTA = FacCPedi.FmaPgo
    S-NROPED = FacCPedi.NroPed
    s-adm-new-record = 'NO'
    s-Copia-Registro = NO
    s-Import-IBC = NO
    s-Pendiente-IBC = NO
    pCodAlm = "".
IF Faccpedi.Libre_c05 = "1" THEN s-Import-IBC = YES.

IF FacCPedi.fchven < TODAY THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""}
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

