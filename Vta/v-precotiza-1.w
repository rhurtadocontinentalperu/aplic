&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODTER   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODIGV   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC   AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE s-nrocot   AS CHAR.
DEFINE SHARED VARIABLE s-CODPRO   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER          AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME    AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO           AS DECIMAL   NO-UNDO.
DEFINE VARIABLE F-totdias         AS INTEGER   NO-UNDO.
DEFINE VARIABLE w-import          AS INTEGER   NO-UNDO.
DEFINE VARIABLE F-Observa         AS CHAR      NO-UNDO.
DEFINE VARIABLE X-Codalm          AS CHAR      NO-UNDO.
DEFINE VARIABLE cFlgSit           AS CHAR      NO-UNDO.

/*Define Buffers*/
DEFINE BUFFER B-CCB FOR CcbCDocu.
DEFINE BUFFER B-CPedi FOR VtaCDocu.
DEFINE BUFFER B-DPedi FOR VtaDDocu.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND  FacCorre.CodDoc = S-CODDOC 
    AND  FacCorre.CodDiv = S-CODDIV
    AND  FacCorre.CodAlm = S-CodAlm NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
    ASSIGN 
        I-NroSer = FacCorre.NroSer
        S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

x-CodAlm = S-CODALM.

DEFINE stream entra .
DEFINE VARIABLE x-ClientesVarios AS CHAR INIT '11111111,11111112'.
DEFINE VARIABLE s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE s-cndvta-validos AS CHAR.

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
&Scoped-define EXTERNAL-TABLES VtaCDocu
&Scoped-define FIRST-EXTERNAL-TABLE VtaCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCDocu.CodCli VtaCDocu.TpoCmb ~
VtaCDocu.FchVen VtaCDocu.DirCli VtaCDocu.FchEnt VtaCDocu.RucCli ~
VtaCDocu.DniCli VtaCDocu.Cmpbnte VtaCDocu.Sede VtaCDocu.CodMon ~
VtaCDocu.LugEnt VtaCDocu.Glosa VtaCDocu.FlgIgv VtaCDocu.CodVen ~
VtaCDocu.FmaPgo VtaCDocu.NroCard 
&Scoped-define ENABLED-TABLES VtaCDocu
&Scoped-define FIRST-ENABLED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-FIELDS VtaCDocu.NroPed VtaCDocu.FchPed ~
VtaCDocu.CodCli VtaCDocu.NomCli VtaCDocu.TpoCmb VtaCDocu.FchVen ~
VtaCDocu.DirCli VtaCDocu.FchEnt VtaCDocu.RucCli VtaCDocu.DniCli ~
VtaCDocu.Cmpbnte VtaCDocu.Sede VtaCDocu.CodMon VtaCDocu.LugEnt ~
VtaCDocu.Glosa VtaCDocu.FlgIgv VtaCDocu.CodVen VtaCDocu.FmaPgo ~
VtaCDocu.NroCard 
&Scoped-define DISPLAYED-TABLES VtaCDocu
&Scoped-define FIRST-DISPLAYED-TABLE VtaCDocu
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
     FGCOLOR 12 FONT 0 NO-UNDO.

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
     VtaCDocu.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          BGCOLOR 15 FGCOLOR 9 FONT 0
     F-Estado AT ROW 1.19 COL 52 COLON-ALIGNED NO-LABEL
     VtaCDocu.FchPed AT ROW 1.19 COL 99.29 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.TpoCmb AT ROW 1.96 COL 99.29 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.FchVen AT ROW 2.73 COL 99.29 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.DirCli AT ROW 2.77 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.FchEnt AT ROW 3.5 COL 99.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.RucCli AT ROW 3.58 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCDocu.DniCli AT ROW 3.58 COL 28.29 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.Cmpbnte AT ROW 4.31 COL 99.29 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 10 BY 1
     BUTTON-10 AT ROW 4.38 COL 5.72 WIDGET-ID 10
     VtaCDocu.Sede AT ROW 4.38 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-sede AT ROW 4.38 COL 14.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     VtaCDocu.CodMon AT ROW 5.15 COL 101.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     VtaCDocu.LugEnt AT ROW 5.19 COL 9 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.Glosa AT ROW 6 COL 6.28
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.FlgIgv AT ROW 6 COL 101.29 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11 BY .58
     VtaCDocu.CodVen AT ROW 6.81 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-nOMvEN AT ROW 6.81 COL 14.43 COLON-ALIGNED NO-LABEL
     VtaCDocu.FmaPgo AT ROW 7.62 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-CndVta AT ROW 7.62 COL 14.43 COLON-ALIGNED NO-LABEL
     VtaCDocu.NroCard AT ROW 8.42 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-Nomtar AT ROW 8.42 COL 21.14 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 6.86 BY .5 AT ROW 5.27 COL 94.29
     "Con IGV:" VIEW-AS TEXT
          SIZE 6.43 BY .81 AT ROW 5.92 COL 94.29 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.VtaCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 9.31
         WIDTH              = 117.29.
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

/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.FchVen IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCDocu.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN VtaCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN VtaCDocu.Sede IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.TpoCmb IN FRAME F-Main
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
    input-var-1 = VtaCDocu.CodCli:SCREEN-VALUE
    input-var-2 = VtaCDocu.NomCli:SCREEN-VALUE
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN vta/c-clied.
  IF output-var-2 <> '' 
      THEN ASSIGN 
            FILL-IN-Sede:SCREEN-VALUE = output-var-2
            VtaCDocu.LugEnt:SCREEN-VALUE = output-var-2
            VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE VtaCDocu.Glosa:SCREEN-VALUE)
            VtaCDocu.Sede:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Cmpbnte V-table-Win
ON VALUE-CHANGED OF VtaCDocu.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'BOL' THEN DISPLAY "" @ VtaCDocu.Ruccli.
        IF SELF:SCREEN-VALUE = 'FAC' THEN DO:
            DISPLAY "" @ VtaCDocu.dnicli.
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = VtaCDocu.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                VtaCDocu.DirCli:SENSITIVE = NO
                VtaCDocu.NomCli:SENSITIVE = NO
                VtaCDocu.dnicli:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    VtaCDocu.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    VtaCDocu.NomCli:SCREEN-VALUE = GN-CLIE.NomCli.
                IF VtaCDocu.RucCli:SCREEN-VALUE = ''  THEN VtaCDocu.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
            IF VtaCDocu.CodCli:SCREEN-VALUE = '11111111112'
            THEN ASSIGN
                    VtaCDocu.DirCli:SENSITIVE = YES
                    VtaCDocu.NomCli:SENSITIVE = YES
                    VtaCDocu.RucCli:SENSITIVE = YES.
        END.
        ELSE DO:
            ASSIGN
                VtaCDocu.DirCli:SENSITIVE = YES
                VtaCDocu.NomCli:SENSITIVE = YES
                VtaCDocu.dnicli:SENSITIVE = YES.
        END.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON LEAVE OF VtaCDocu.CodCli IN FRAME F-Main /* Codigo */
DO:  
  IF SELF:SCREEN-VALUE = '' THEN DO: 
      s-CodCli = SELF:SCREEN-VALUE.
      RETURN.
  END.
  IF SELF:SCREEN-VALUE = S-CODCLI THEN RETURN. 

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli NO-LOCK.
  /**R.D.P 10/10/2010
  RUN vtagn/p-fmapgo-01 (s-CodCli, OUTPUT s-cndvta-validos).
  /* PARCHE EXPOLIBRERIA 28.10.2010 */
  s-cndvta-validos = '001'.
  IF LOOKUP('400', gn-clie.cndvta) > 0
      THEN s-cndvta-validos = s-cndvta-validos + ',400'.
  IF LOOKUP('401', gn-clie.cndvta) > 0
      THEN s-cndvta-validos = s-cndvta-validos + ',401'.
  **/
  DISPLAY 
    gn-clie.NomCli @ VtacDocu.NomCli
    gn-clie.Ruc    @ VtacDocu.RucCli
    gn-clie.DirCli @ VtacDocu.DirCli
    /*ENTRY(1, gn-clie.cndvta) @ VtacDocu.FmaPgo*/
    '001' @ VtacDocu.FmaPgo
    gn-clie.NroCard @ VtacDocu.NroCard
    gn-clie.CodVen WHEN VtacDocu.CodVen:SCREEN-VALUE = '' @ VtacDocu.CodVen     
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
    /*S-CNDVTA = ENTRY(1, s-cndvta-validos)*/
    S-CNDVTA = VtacDocu.FmaPgo:SCREEN-VALUE
    S-NROTAR = gn-clie.NroCard.

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = S-NROTAR NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            VtaCDocu.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            VtaCDocu.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF VtacDocu.FmaPgo:SCREEN-VALUE = '900' 
    AND VtacDocu.Glosa:SCREEN-VALUE = ''
  THEN VtacDocu.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND (TcmbCot.Rango1 <= gn-convt.totdias
    AND  TcmbCot.Rango2 >= gn-convt.totdias)
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
       DISPLAY TcmbCot.TpoCmb @ VtacDocu.TpoCmb
               WITH FRAME {&FRAME-NAME}.
       S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = VtacDocu.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* Determina si es boleta o factura */
  IF VtacDocu.RucCli:SCREEN-VALUE = ''
  THEN VtacDocu.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE VtacDocu.Cmpbnte:SCREEN-VALUE = 'FAC'.
  APPLY 'VALUE-CHANGED' TO VtacDocu.Cmpbnte.

  IF SELF:SCREEN-VALUE = '11111111112' THEN DO:
      VtacDocu.FmaPgo:SENSITIVE = NO.
      APPLY 'LEAVE':U TO VtacDocu.FmaPgo.
  END.
  ELSE VtacDocu.FmaPgo:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF VtaCDocu.CodMon IN FRAME F-Main /* Cod!mon */
DO:
    S-CODMON = INTEGER(VtaCDocu.CodMon:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodVen V-table-Win
ON LEAVE OF VtaCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = VtaCDocu.CodVen:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FchEnt V-table-Win
ON LEAVE OF VtaCDocu.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
    /* RHC 22.12.05 MAXIMO 40 DESPACHOS POR DIA */
    IF NOT (INPUT {&SELF-NAME} >= 01/15/2009) THEN DO:
        MESSAGE 'Los despachos deben programarse a partir del 15 de Enero'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF INPUT {&SELF-NAME} <> ? AND RETURN-VALUE = 'YES' THEN DO:
        DEF VAR x-Cuentas AS INT NO-UNDO.
        DEF VAR x-Tope    AS INT INIT 40 NO-UNDO.
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= 01/01/2008
            AND B-CPEDI.fchent = INPUT {&SELF-NAME}:
            x-Cuentas = x-Cuentas + 1.
        END.            

        IF x-Cuentas > x-Tope THEN DO:
            MESSAGE 'Ya se cubrieron los despachos para ese día' 
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FchVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FchVen V-table-Win
ON LEAVE OF VtaCDocu.FchVen IN FRAME F-Main /* Vencimiento */
DO:

    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <=  DATE(VtaCDocu.FchVen:SCREEN-VALUE) - DATE(VtaCDocu.FchPed:SCREEN-VALUE) + 1
        AND   TcmbCot.Rango2 >= DATE(VtaCDocu.FchVen:SCREEN-VALUE) - DATE(VtaCDocu.FchPed:SCREEN-VALUE) + 1 )
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ VtaCDocu.TpoCmb
            WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON F8 OF VtaCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
OR left-mouse-dblclick OF VtacDocu.fmapgo
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON LEAVE OF VtaCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:

  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  F-CndVta:SCREEN-VALUE = ''.
  s-CndVta = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

  /* Ubica la Condicion Venta */
  IF AVAILABLE gn-convt THEN DO:
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND (TcmbCot.Rango1 <= gn-convt.totdias
        AND  TcmbCot.Rango2 >= gn-convt.totdias)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ VtacDocu.TpoCmb
            WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.
  END.  
  IF VtacDocu.FmaPgo:SCREEN-VALUE = '900' 
    AND VtacDocu.Glosa:SCREEN-VALUE = ''
  THEN VtacDocu.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  RUN Procesa-Handle IN lh_Handle ('Recalculo').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.NroCard V-table-Win
ON LEAVE OF VtaCDocu.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Card THEN DO:
        S-NROTAR = SELF:SCREEN-VALUE.
        RUN vta/D-RegCar (INPUT S-NROTAR).
        IF S-NROTAR = "" THEN DO:
            APPLY "ENTRY" TO VtaCDocu.NroCard.
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


&Scoped-define SELF-NAME VtaCDocu.RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.RucCli V-table-Win
ON LEAVE OF VtaCDocu.RucCli IN FRAME F-Main /* Ruc */
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


&Scoped-define SELF-NAME VtaCDocu.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON LEAVE OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
DO:
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = VtacDocu.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied
    THEN ASSIGN 
          FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
          VtacDocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
          VtacDocu.Glosa:SCREEN-VALUE = (IF VtacDocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE VtacDocu.Glosa:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.TpoCmb V-table-Win
ON LEAVE OF VtaCDocu.TpoCmb IN FRAME F-Main /* T/  Cambio */
DO:
    S-TPOCMB = DEC(VtaCDocu.TpoCmb:SCREEN-VALUE).    
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

    FOR EACH PEDI2:
        DELETE PEDI2.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
            CREATE PEDI2.
            BUFFER-COPY VtaDDocu TO PEDI2
                ASSIGN PEDi2.CanAte = 0.
            RELEASE PEDI2.
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
  {src/adm/template/row-list.i "VtaCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCDocu"}

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
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNroPed AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.    

    FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.Libre_d01 <> 0
        NO-LOCK NO-ERROR.
    IF NOT AVAIL VtaDDocu THEN DO: 
        MESSAGE 'No existe detalle para este documento'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.

    /*Verifica Totales*/
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
        F-Tot = F-Tot + VtaDDocu.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.        
        RETURN "ADM-ERROR".   
    END.
    /* RHC 20.09.05 Transferencia gratuita */
    IF VtaCDocu.FmaPgo = '900' AND VtaCDocu.NroCar <> '' THEN DO:
        MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* RHC 9.01.08 MINIMO S/.3000.00 */
    IF INTEGER(VtaCDocu.CodMon) = 2
        THEN f-Tot = f-Tot * DECIMAL(VtaCDocu.TpoCmb).
    IF f-Tot < 3000 THEN DO:
        MESSAGE 'El monto mínimo a cotizar es de S/.3000.00' SKIP
                '           Necesita AUTORIZACION          '
                VIEW-AS ALERT-BOX WARNING.
        DEF VAR x-Rep AS CHAR.
        RUN lib/_clave ('PCL', OUTPUT x-Rep).
        IF x-Rep = 'ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    /*****************************/


    IF VtaCDocu.FlgSit = 'T' THEN DO: 
        MESSAGE 'Pre-Pedio ya registra cotización'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO: 
        RUN Vtaexp\genera-cotizacion-1 (ROWID(VtaCDocu),OUTPUT CNroPed).
        IF cNroPed <> '' THEN DO:
            FIND FIRST b-cpedi WHERE ROWID(b-cpedi) = ROWID(VtaCDocu) NO-ERROR.
            IF AVAIL b-cpedi THEN ASSIGN b-cpedi.NroRef = cNroPed.
            MESSAGE '!!Cotización Nº ' + cNroPed + ' acaba de generarse!!.'.
        END.        
        ELSE DO:
            MESSAGE 'No Existe Número de Serie.'.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-DPEDI WHERE ROWID(B-DPEDI) = ROWID(VtaDDocu) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE B-DPedi.
        RELEASE B-DPEDI.
    END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle V-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH PEDI2:
        DELETE PEDI2.
    END.

    FOR EACH almcatvtad WHERE almcatvtad.codcia = almcatvtac.codcia
        AND AlmCatVtaD.CodDiv = AlmCatVtaC.CodDiv
        AND AlmCatVtaD.NroPag = AlmCatVtaC.NroPag NO-LOCK:
        DEFINE FRAME F-MENSAJE
            SPACE(1) SKIP
            'Procesando: ' AlmCatVtaD.codmat SKIP
            'Un momento por favor...' SKIP
            SPACE(1) SKIP
            WITH OVERLAY CENTERED NO-LABELS VIEW-AS DIALOG-BOX TITLE 'Cargando Información'.

        CREATE PEDI2.
        ASSIGN
            PEDI2.Codcia = AlmCatVtaD.CodCia 
            PEDI2.CodDiv = AlmCatVtaD.CodDiv 
            PEDI2.codmat = AlmCatVtaD.codmat. 
    END.
    RUN adm-open-query.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-atencion V-table-Win 
PROCEDURE Cierre-de-atencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Cierre de atención */
    FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
        AND expturno.coddiv = s-coddiv
        AND expturno.block = s-codter
        AND expturno.estado = 'P'
        AND expturno.fecha = TODAY
        AND expturno.codcli = VtaCDocu.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN DO:
        MESSAGE 'CERRAMOS la atención?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = YES 
        THEN DO:
            FIND CURRENT ExpTurno EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(VtaCDocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE ExpTurno AND AVAILABLE B-CPEDI
            THEN ASSIGN
                    Expturno.Estado = 'C'
                    B-CPedi.Libre_c05 = '*'.
            RELEASE ExpTurno.
            RELEASE B-CPEDI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Finaliza_1 V-table-Win 
PROCEDURE Finaliza_1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF vtacdocu.flgsit <> 'S' AND vtacdocu.flgsit <> 'T' THEN DO:
        FIND FIRST b-cpedi WHERE ROWID(b-cpedi) = ROWID(vtacdocu) NO-ERROR.
        IF AVAIL b-cpedi THEN DO: 
            IF b-cpedi.flgest = 'A' THEN DO:
                MESSAGE 'Documento Anulado'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN 'ADM-ERROR'.
            END.
            FIND FIRST vtaddocu OF b-cpedi NO-LOCK NO-ERROR.
            IF AVAIL vtaddocu THEN ASSIGN b-cpedi.FlgSit = "S".
            ELSE DO:
                MESSAGE 'Documento no presenta detalle registrado'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
    END.
    
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE G-P V-table-Win 
PROCEDURE G-P :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  FOR EACH PEDI2 NO-LOCK BY PEDI2.NroItm: 
      I-NITEM = I-NITEM + 1.
      CREATE VtaDDocu.
      BUFFER-COPY PEDI2 TO VtaDDocu
          ASSIGN
              VtaDDocu.CodCia = VtaCDocu.CodCia
              VtaDDocu.CodDiv = VtaCDocu.CodDiv
              VtaDDocu.codped = VtaCDocu.codped
              VtaDDocu.NroPed = VtaCDocu.NroPed
              VtaDDocu.FchPed = VtaCDocu.FchPed
              /*VtaDDocu.Hora   = VtaCDocu.Hora */
              VtaDDocu.FlgEst = VtaCDocu.FlgEst
              VtaDDocu.NroItm = I-NITEM.
  END.
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
  DEFINE VARIABLE I-NITEM  AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-factor AS INTEGER     NO-UNDO.
  DEFINE VARIABLE x-canped AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE Z-Dsctos AS DECIMAL     NO-UNDO.

  FOR EACH PEDI2 NO-LOCK BY PEDI2.NroItm TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR'
      ON ERROR UNDO, RETURN 'ADM-ERROR': 
      I-NITEM = I-NITEM + 1.
      F-FACTOR = 1.
      CREATE VtaDDocu.
      BUFFER-COPY PEDI2 TO VtaDDocu
      ASSIGN
          VtaDDocu.CodCia = VtaCDocu.CodCia
          VtaDDocu.CodDiv = VtaCDocu.CodDiv
          VtaDDocu.NroPed = VtaCDocu.NroPed
          VtaDDocu.FchPed = VtaCDocu.FchPed
          VtaDDocu.CodPed = VtaCDocu.CodPed
          VtaDDocu.FlgEst = VtaCDocu.FlgEst
          VtaDDocu.Factor = f-factor
          VtaDDocu.NroItm = I-NITEM.
/*****************      
      /****Calcula Precio de Venta ****/
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
          AND almmmatg.codmat = vtaddocu.codmat NO-LOCK NO-ERROR.

      ASSIGN 
          F-FACTOR = 1
          X-CANPED = VtaDDocu.CanPed.
/*       RUN vtagn/PrecioExpolibreria (s-CodCia, */
/*                         s-CodDiv,             */
/*                         VtaCDocu.CodCli,      */
/*                         VtaCDocu.CodMon,      */
/*                         VtaCDocu.TpoCmb,      */
/*                         f-Factor,             */
/*                         Almmmatg.CodMat,      */
/*                         VtaCDocu.FmaPgo,      */
/*                         x-CanPed,             */
/*                         4,                    */
/*                         OUTPUT f-PreBas,      */
/*                         OUTPUT f-PreVta,      */
/*                         OUTPUT f-Dsctos,      */
/*                         OUTPUT y-Dsctos,      */
/*                         OUTPUT z-Dsctos).     */

        RUN vta/PrecioVenta (s-CodCia,
                             VtaCDocu.CodCli,
                             VtaCDocu.CodMon,
                             f-Factor,
                             Almmmatg.CodMat,
                             VtaCDocu.FmaPgo,
                             4,
                             OUTPUT f-PreBas,
                             OUTPUT f-PreVta,
                             OUTPUT f-Dsctos).

      
      z-Dsctos = 0.
      FIND FacTabla WHERE factabla.codcia = s-codcia
          AND factabla.tabla = 'EL'
          AND factabla.codigo = STRING(YEAR(TODAY), '9999') NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla 
          AND y-Dsctos = 0 
          AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 THEN DO:    /* NO Promociones */
          CASE Almmmatg.Chr__02:
              WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1].
              WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2].
          END CASE.
      END.
      IF AVAILABLE FacTabla 
          AND y-Dsctos = 0 
          AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 THEN DO:    /* NO Promociones */
          CASE Almmmatg.Chr__02:
              WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1] /* - 1*/.
              WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2] /* - 2*/.
          END CASE.
      END.
      /* ************************************************* */
      
      ASSIGN
          VtaDDocu.UndVta = Almmmatg.Chr__01 
          VtaDDocu.AlmDes = s-codalm 
          VtaDDocu.PreBas = F-PreBas 
          VtaDDocu.PreUni = F-PREVTA
          VtaDDocu.AftIgv = Almmmatg.AftIgv 
          VtaDDocu.AftIsc = Almmmatg.AftIsc
          VtaDDocu.PorDto = F-DSCTOS
          VtaDDocu.PorDto1 = z-Dsctos
          VtaDDocu.PorDto2 = Almmmatg.PorMax
          VtaDDocu.PorDto3 = Y-DSCTOS 
          VtaDDocu.ImpDto = ROUND( VtaDDocu.PreUni * VtaDDocu.CanPed * (VtaDDocu.PorDto1 / 100),4 )
          VtaDDocu.ImpLin = ROUND( VtaDDocu.PreUni * VtaDDocu.CanPed , 2 ) - VtaDDocu.ImpDto.
      IF VtaDDocu.AftIsc THEN 
          VtaDDocu.ImpIsc = ROUND(VtaDDocu.PreBas * VtaDDocu.CanPed * (Almmmatg.PorIsc / 100),4).
      IF VtaDDocu.AftIgv THEN  
          VtaDDocu.ImpIgv = VtaDDocu.ImpLin - ROUND(VtaDDocu.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
      /******************/
      RELEASE VtaDDocu.
*********************/      
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
  {vtaexp/graba-totales-exp.i}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-Copia-Registro = NO.
      
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
          AND FacCorre.CodDoc = S-CODDOC 
          AND FacCorre.CodDiv = S-CODDIV 
          AND Faccorre.Codalm = S-CodAlm
          NO-LOCK NO-ERROR.
      DISPLAY
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ VtaCDocu.NroPed.
      ASSIGN
          s-TpoCmb = 1
          S-NroTar = "".
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
                AND   TcmbCot.Rango2 >= TODAY - TODAY + 1) NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      DISPLAY 
          TODAY @ VtaCDocu.FchPed
          TODAY @ VtaCDocu.FchEnt
          S-TPOCMB @ VtaCDocu.TpoCmb
          (TODAY + 150) @ VtaCDocu.FchVen
          '001' @ VtaCDocu.FmaPgo.
      ASSIGN
          /*C-TpoVta:SENSITIVE = YES*/
          S-CODMON = INTEGER(VtaCDocu.CodMon:SCREEN-VALUE)
          S-CODCLI = VtaCDocu.CodCli:SCREEN-VALUE
          S-CNDVTA = VtaCDocu.FmaPgo:SCREEN-VALUE.

      RUN Actualiza-Item.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'ENTRY':U TO VtaCDocu.CodCli.
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
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
          AND FacCorre.CodDoc = S-CODDOC 
          AND FacCorre.CodDiv = S-CODDIV 
          AND Faccorre.Codalm = S-CodAlm
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          VtaCDocu.CodCia = S-CODCIA
          VtaCDocu.CodPed = s-coddoc 
          VtaCDocu.FchPed = TODAY 
          VtaCDocu.CodAlm = S-CODALM
          VtaCDocu.PorIgv = FacCfgGn.PorIgv 
          VtaCDocu.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          VtaCDocu.CodDiv = S-CODDIV.
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
      RUN Borra-Pedido. 
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
         /*C-TPOVTA*/
         VtaCDocu.Hora = STRING(TIME,"HH:MM")
         VtaCDocu.Usuario = S-USER-ID
         VtaCDocu.Observa = F-Observa.

    /*RUN Genera-Pedido.    /* Detalle del pedido */*/
     RUN G-P.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Graba-Totales.
    /*C-TpoVta:SENSITIVE = NO. */
  END.  
  
  RELEASE FacCorre.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

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
     VtaCDocu.NomCli:SENSITIVE = NO.
     VtaCDocu.RucCli:SENSITIVE = NO.
     VtaCDocu.DirCli:SENSITIVE = NO.
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
    IF VtaCDocu.FlgEst = "A" THEN DO:
        MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    IF VtaCDocu.FlgSit = 'T' THEN DO:
        MESSAGE 'Este documento tiene asociado' SKIP
                ' la cotización Nº ' VtaCDocu.NroRef 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'ADM-ERROR'.
    END.

    IF VtaCDocu.FlgEst = "C" THEN DO:
        MESSAGE "No puede eliminar una cotizacion TOTALMENTE atendida" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF VtaCDocu.FlgEst = "X" THEN DO:
        MESSAGE "No puede eliminar una cotizacion CERRADA" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FIND FIRST VtaDDocu OF VtaCDocu WHERE CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDDocu THEN DO:
        MESSAGE "No puede eliminar un pedido PARCIALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCDocu THEN RETURN 'ADM-ERROR'.
    ASSIGN
        VtaCDocu.FlgEst = 'A'
        VtaCDocu.Glosa  = " A N U L A D O".
    FIND CURRENT VtaCDocu NO-LOCK.
        
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
          BUTTON-10:SENSITIVE = NO
          /*BUTTON-Turno-Avanza:SENSITIVE IN FRAME {&FRAME-NAME} = NO
          BUTTON-Turno-Retrocede:SENSITIVE IN FRAME {&FRAME-NAME} = NO*/.
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
  /*C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. */
  /*F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = YES. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE VtaCDocu THEN DO WITH FRAME {&FRAME-NAME}:
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
          AND  gn-clie.CodCli = VtaCDocu.CodCli NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie  THEN DO: 
          DISPLAY 
              VtaCDocu.NomCli 
              VtaCDocu.RucCli  
              VtaCDocu.DirCli.
          CASE VtaCDocu.FlgEst:
              WHEN "A" THEN cFlgSit = " ANULADO " .
              WHEN "C" THEN cFlgSit = "ATENDIDO " .
              WHEN "P" THEN cFlgSit = "PENDIENTE" .
              WHEN "V" THEN cFlgSit = " VENCIDO " .
              WHEN "X" THEN cFlgSit = " CERRADA " .
          END CASE.         
          IF VtaCDocu.FlgEst = 'P' THEN DO: 
              IF VtaCDocu.FlgSit = 'S' THEN cFlgSit = " FINALIZADO " .
              IF VtaCDocu.FlgSit = 'T' THEN cFlgSit = " COTIZADO  " .
          END.
          DISPLAY cFlgSit @ F-Estado WITH FRAME {&FRAME-NAME}.
      END.
      F-NomVen:screen-value = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = VtaCDocu.CodVen NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

      IF VtaCDocu.FchVen < TODAY AND VtaCDocu.FlgEst = 'P'
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
      ASSIGN
          VtaCDocu.RucCli:SENSITIVE = NO
          VtaCDocu.NomCli:SENSITIVE = NO
          VtaCDocu.DirCli:SENSITIVE = NO
          VtaCDocu.fchven:SENSITIVE = NO
          VtaCDocu.TpoCmb:SENSITIVE = NO
          BUTTON-10:SENSITIVE = YES.

      IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'BOL'
          THEN ASSIGN
          VtaCDocu.DirCli:SENSITIVE = YES.

      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          ASSIGN
              VtaCDocu.CodCli:SENSITIVE = NO
              VtaCDocu.fchven:SENSITIVE = NO
              VtaCDocu.FmaPgo:SENSITIVE = NO
              VtaCDocu.CodMon:SENSITIVE = NO
              VtaCDocu.CodVen:SENSITIVE = NO
              VtaCDocu.TpoCmb:SENSITIVE = NO.
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

  F-Observa = VtaCDocu.Observa.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> 'ADM-ERROR' THEN RUN Cierre-de-atencion.
  
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
  {src/adm/template/snd-list.i "VtaCDocu"}

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
     L-CREA = NO.
     RUN Actualiza-Item.
     
     VtaCDocu.TpoCmb:SENSITIVE = NO.
     
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
  DEFINE VARIABLE X-FREC AS INTEGER INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
      IF VtaCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = VtaCDocu.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.

      RUN vtagn/p-gn-clie-01 (VtaCDocu.CodCli:SCREEN-VALUE, s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

      IF gn-clie.FlgSit = "I" THEN DO:
          MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF gn-clie.FlgSit = "C" THEN DO:
          MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0 THEN DO:
          MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO VtaCDocu.CodCli.
          RETURN 'ADM-ERROR'.
      END.
           
      IF VtaCDocu.Cmpbnte:SCREEN-VALUE = "FAC" AND VtaCDocu.RucCli:SCREEN-VALUE = '' THEN DO:
         MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.CodCli.
         RETURN "ADM-ERROR".   
      END.

      IF VtaCDocu.Cmpbnte:SCREEN-VALUE = "BOL" AND VtaCDocu.DniCli:SCREEN-VALUE = '' THEN DO:
         MESSAGE "El Cliente NO tiene D.N.I" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.DniCli.
         RETURN "ADM-ERROR".   
      END.

      IF VtaCDocu.CodVen:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodVen.
          RETURN "ADM-ERROR".   
      END.
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND gn-ven.CodVen = VtaCDocu.CodVen:screen-value 
          NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-ven THEN DO:
            MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO VtaCDocu.CodVen.
          RETURN "ADM-ERROR".   
      END.
      ELSE DO:
          IF gn-ven.flgest = "C" THEN DO:
              MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO VtaCDocu.CodVen.
              RETURN "ADM-ERROR".   
          END.
      END.
      
      IF INPUT VtaCDocu.fchven = ? OR INPUT VtaCDocu.fchven < TODAY THEN DO:
          MESSAGE "Ingrese correctamente la fecha de vencimiento" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.FchVen.
          RETURN "ADM-ERROR".   
      END.    
      
      IF VtaCDocu.FmaPgo:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.FmaPgo.
          RETURN "ADM-ERROR".   
      END.
      FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-convt THEN DO:
          MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.FmaPgo.
          RETURN "ADM-ERROR".   
      END.

      /*Fijamos Condiciones de Venta
      IF LOOKUP(VtaCDocu.FmaPgo:SCREEN-VALUE, '002,101,102,103,104') = 0 THEN DO:
          MESSAGE "Condicion Venta INVÁLIDA" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.FmaPgo.
          RETURN "ADM-ERROR".     
      END.
      */
      
      IF VtaCDocu.FmaPgo:SCREEN-VALUE = "000" THEN DO:
          MESSAGE "Condicion Venta no debe ser contado" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.FmaPgo.
          RETURN "ADM-ERROR".   
      END.
      
      IF VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
          AND VtaCDocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
          AND VtaCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
         MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.NroCard.
         RETURN "ADM-ERROR".   
      END.
      IF VtaCDocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900'
          AND VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
          AND VtaCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
         MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
              VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.NroCard.
         RETURN "ADM-ERROR".   
      END.
    
      IF VtaCDocu.NroCar:SCREEN-VALUE <> "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = VtaCDocu.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO VtaCDocu.NroCar.
             RETURN "ADM-ERROR".   
         END.   
      END.   

      /**********/
      FOR EACH PEDI2 NO-LOCK: 
          F-Tot = F-Tot + PEDI2.ImpLin.
      END.
      IF F-Tot = 0 THEN DO:
          MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      /* RHC 09/03/04 IMPORTE MAXIMO PARA BOLETAS */
      F-BOL = IF INTEGER(VtaCDocu.CodMon:SCREEN-VALUE) = 1 THEN F-TOT
          ELSE F-Tot * DECIMAL(VtaCDocu.TpoCmb:SCREEN-VALUE).
      IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL >= 700
          THEN DO:
          MESSAGE "Venta Mayor a 700.00 Ingresar Nro. Ruc., Verifique... " 
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      
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

      /****************/
      IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'FAC' AND VtaCDocu.RucCli:SCREEN-VALUE = ''
          THEN DO:
          MESSAGE "El cliente debe tener RUC" 
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO VtaCDocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      
/*       IF s-Import-IBC = YES THEN DO:                             */
/*           RUN CONTROL-IBC.                                       */
/*           IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */
/*       END.                                                       */

      FIND FacTabla WHERE FacTabla.codcia = s-codcia
          AND FacTabla.Tabla = 'AU'
          AND FacTabla.Codigo = VtaCDocu.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla AND VtaCDocu.Sede:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      IF VtaCDocu.Sede:SCREEN-VALUE <> '' THEN DO:
          FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = VtaCDocu.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clied THEN DO:
              MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
              RETURN 'ADM-ERROR'.
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
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE VtaCDocu THEN RETURN "ADM-ERROR".
IF LOOKUP(VtaCDocu.FlgEst,"C,A,X") > 0 THEN  RETURN "ADM-ERROR".
IF (VtaCDocu.FlgSit = "S" OR VtaCDocu.FlgSit = "T") THEN RETURN "ADM-ERROR".

IF VtaCDocu.Libre_c05 = '*' THEN DO:
    MESSAGE 'La Atención al Cliente YA FUE CERRADA'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

FIND FIRST VtaDDocu OF VtaCDocu WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE VtaDDocu THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = VtaCDocu.CodMon
    S-CODCLI = VtaCDocu.CodCli
    S-CODIGV = IF VtaCDocu.FlgIgv THEN 1 ELSE 2
    /*C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = YES*/
    S-TPOCMB = VtaCDocu.TpoCmb
    X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2
    s-NroTar = VtaCDocu.NroCard
    S-CNDVTA = VtaCDocu.FmaPgo.
    
IF VtaCDocu.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
        AND  Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE ('EXPO',OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
ASSIGN s-nrocot = VtaCDocu.NroPed.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

