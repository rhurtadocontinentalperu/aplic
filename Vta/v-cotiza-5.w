&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-lgcocmp NO-UNDO LIKE LG-COCmp.
DEFINE TEMP-TABLE t-lgdocmp NO-UNDO LIKE LG-DOCmp.



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
DEFINE SHARED TEMP-TABLE PEDI2      NO-UNDO LIKE VtaDDocu.
DEFINE SHARED TEMP-TABLE T-DPEDI2   NO-UNDO LIKE VtaDDocu.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODIGV   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv   LIKE Ccbcdocu.PorIgv.

DEFINE VARIABLE s-pendiente-ibc AS LOG.

/* Local Variable Definitions ---                                       */

DEFINE BUFFER B-CPedi FOR VtaCDocu.

DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VARIABLE w-import       AS INTEGER NO-UNDO.
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VAR s-cndvta-validos AS CHAR.
DEFINE VAR lRpta AS LOG NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodAlm = S-CodAlm 
               NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR F-Observa AS CHAR NO-UNDO.
DEFINE VAR X-Codalm  AS CHAR NO-UNDO.
X-Codalm = S-CODALM.

DEFINE BUFFER B-CCB FOR CcbCDocu.

DEFINE stream entra .

DEFINE TEMP-TABLE tt-cab
    FIELDS codped AS CHAR
    FIELDS codven AS CHAR
    FIELDS codcli AS CHAR
    FIELDS codcia AS CHAR
    FIELDS cndvta AS CHAR
    FIELDS imptot AS DEC
    FIELDS fchdoc AS CHAR.

DEFINE TEMP-TABLE tt-det
    FIELDS codped AS CHAR
    FIELDS codven AS CHAR
    FIELDS codcli AS CHAR
    FIELDS codcia AS CHAR
    FIELDS coddet AS CHAR
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS canmat AS DEC
    FIELDS implin AS DEC.

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
&Scoped-Define ENABLED-FIELDS VtaCDocu.FchPed VtaCDocu.CodCli ~
VtaCDocu.NomCli VtaCDocu.TpoCmb VtaCDocu.DirCli VtaCDocu.FchVen ~
VtaCDocu.RucCli VtaCDocu.Sede VtaCDocu.Cmpbnte VtaCDocu.LugEnt ~
VtaCDocu.CodMon VtaCDocu.Glosa VtaCDocu.CodVen VtaCDocu.FmaPgo ~
VtaCDocu.NroCard 
&Scoped-define ENABLED-TABLES VtaCDocu
&Scoped-define FIRST-ENABLED-TABLE VtaCDocu
&Scoped-Define ENABLED-OBJECTS RECT-23 
&Scoped-Define DISPLAYED-FIELDS VtaCDocu.NroPed VtaCDocu.FchPed ~
VtaCDocu.CodCli VtaCDocu.NomCli VtaCDocu.TpoCmb VtaCDocu.DirCli ~
VtaCDocu.FchVen VtaCDocu.RucCli VtaCDocu.Sede VtaCDocu.Cmpbnte ~
VtaCDocu.LugEnt VtaCDocu.CodMon VtaCDocu.Glosa VtaCDocu.FlgIgv ~
VtaCDocu.CodVen VtaCDocu.FmaPgo VtaCDocu.NroCard 
&Scoped-define DISPLAYED-TABLES VtaCDocu
&Scoped-define FIRST-DISPLAYED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-sede f-NomVen F-NRODEC ~
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
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .81 NO-UNDO.

DEFINE VARIABLE F-NRODEC AS INTEGER FORMAT "9":U INITIAL 2 
     LABEL "Nro Dec" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 8.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCDocu.NroPed AT ROW 1.27 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          FONT 0
     F-Estado AT ROW 1.27 COL 23 COLON-ALIGNED NO-LABEL
     VtaCDocu.FchPed AT ROW 1.27 COL 88 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.CodCli AT ROW 2.08 COL 9 COLON-ALIGNED HELP
          ""
          LABEL "Código" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.NomCli AT ROW 2.08 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
     VtaCDocu.TpoCmb AT ROW 2.08 COL 88 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.DirCli AT ROW 2.88 COL 9 COLON-ALIGNED
          LABEL "Dirección" FORMAT "x(70)"
          VIEW-AS FILL-IN 
          SIZE 67 BY .81
     VtaCDocu.FchVen AT ROW 2.88 COL 88 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.RucCli AT ROW 3.69 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     BUTTON-10 AT ROW 4.5 COL 6 WIDGET-ID 10
     VtaCDocu.Sede AT ROW 4.5 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-sede AT ROW 4.5 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     VtaCDocu.Cmpbnte AT ROW 4.5 COL 88 COLON-ALIGNED WIDGET-ID 2
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.LugEnt AT ROW 5.31 COL 9 COLON-ALIGNED WIDGET-ID 20
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 67 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.CodMon AT ROW 5.31 COL 90 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.Glosa AT ROW 6.12 COL 6.29 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 67 BY .81
          BGCOLOR 11 FGCOLOR 9 
     VtaCDocu.FlgIgv AT ROW 6.12 COL 90 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11.57 BY .81
     VtaCDocu.CodVen AT ROW 6.92 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     f-NomVen AT ROW 6.92 COL 15 COLON-ALIGNED NO-LABEL
     F-NRODEC AT ROW 6.92 COL 89 COLON-ALIGNED
     VtaCDocu.FmaPgo AT ROW 7.73 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-CndVta AT ROW 7.73 COL 15 COLON-ALIGNED NO-LABEL
     VtaCDocu.NroCard AT ROW 8.54 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-Nomtar AT ROW 8.54 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Con IGV:" VIEW-AS TEXT
          SIZE 6.43 BY .81 AT ROW 6.12 COL 83
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .81 AT ROW 5.31 COL 83
     RECT-23 AT ROW 1 COL 1 WIDGET-ID 22
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
      TABLE: t-lgcocmp T "?" NO-UNDO INTEGRAL LG-COCmp
      TABLE: t-lgdocmp T "?" NO-UNDO INTEGRAL LG-DOCmp
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
         HEIGHT             = 8.77
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX VtaCDocu.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN VtaCDocu.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaCDocu.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NRODEC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchVen IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET VtaCDocu.FlgIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCDocu.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN VtaCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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
            /*VtaCDocu.DirCli:SCREEN-VALUE = output-var-2*/
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
  IF SELF:SCREEN-VALUE = "FAC"
  THEN DO:
/*     ASSIGN                              */
/*         VtaCDocu.DirCli:SENSITIVE = NO  */
/*         VtaCDocu.NomCli:SENSITIVE = NO. */
  END.
  ELSE DO:
    ASSIGN
/*         VtaCDocu.DirCli:SENSITIVE = YES */
/*         VtaCDocu.NomCli:SENSITIVE = YES */
        VtaCDocu.RucCli:SCREEN-VALUE = ''.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON LEAVE OF VtaCDocu.CodCli IN FRAME F-Main /* Código */
DO:
   IF SELF:SCREEN-VALUE = '' THEN RETURN.
   IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
       MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.

   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
     AND  gn-clie.CodCli = VtaCDocu.CodCli:SCREEN-VALUE 
     NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF gn-clie.cndvta = '' THEN DO:
       MESSAGE 'El cliente NO tiene definida una condición de venta' 
           VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.
   /* BLOQUEO DEL CLIENTE */
   RUN vtagn/p-gn-clie-01 (VtaCDocu.CodCli:SCREEN-VALUE , s-coddoc).
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.


   /*
   IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   */
   /* Cargamos las condiciones de venta válidas */
   s-cndvta-validos = gn-clie.cndvta.
   FIND gn-convt WHERE gn-ConVt.Codig = '900' NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN s-cndvta-validos = gn-clie.cndvta + ',900'.

   DO WITH FRAME {&FRAME-NAME} :
      DISPLAY 
          gn-clie.NomCli @ VtaCDocu.NomCli
          gn-clie.Ruc    @ VtaCDocu.RucCli
          gn-clie.DirCli @ VtaCDocu.DirCli
          gn-clie.CodVen @ VtaCDocu.CodVen
          ENTRY(1, gn-clie.cndvta) @ VtaCDocu.fmapgo.  /* Puede haber mas de una */

      S-CODCLI = VtaCDocu.CodCli:SCREEN-VALUE.
      S-CNDVTA = ENTRY(1, gn-clie.CndVta).
      IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO: 
          ASSIGN
              VtaCDocu.NomCli:SENSITIVE = NO
              VtaCDocu.RucCli:SENSITIVE = NO
              VtaCDocu.DirCli:SENSITIVE = NO.
          APPLY "ENTRY" TO VtaCDocu.CodVen.
      END.   
      ELSE DO: 
          ASSIGN
              VtaCDocu.NomCli:SENSITIVE = YES
              VtaCDocu.RucCli:SENSITIVE = YES
              VtaCDocu.DirCli:SENSITIVE = YES.
          APPLY "ENTRY" TO VtaCDocu.NomCli.
      END. 
   END.  
   /* Ubica la Condicion Venta */
   FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
      F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      f-totdias = gn-convt.totdias.
   END.  
   ELSE F-CndVta:SCREEN-VALUE = "".
   FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                 AND  (TcmbCot.Rango1 <= gn-convt.totdias
                 AND   TcmbCot.Rango2 >= gn-convt.totdias)
                 NO-LOCK NO-ERROR.
   IF AVAIL TcmbCot THEN DO:
      DISPLAY TcmbCot.TpoCmb @ VtaCDocu.TpoCmb
              WITH FRAME {&FRAME-NAME}.
      S-TPOCMB = TcmbCot.TpoCmb.  
   END.

   IF s-Import-IBC = NO THEN RUN Procesa-Handle IN lh_Handle ('Recalculo').
   RETURN NO-APPLY.
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
  F-NomVen = "".
  IF VtaCDocu.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = VtaCDocu.CodVen:screen-value 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-NRODEC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NRODEC V-table-Win
ON LEAVE OF F-NRODEC IN FRAME F-Main /* Nro Dec */
DO:
  IF x-NroDec = INTEGER(F-NRODEC:SCREEN-VALUE) THEN RETURN.
  X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE).
  IF X-NRODEC < 2 OR X-NRODEC > 4 THEN DO:
    MESSAGE "Numero de Decimales No Permitido " VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  RUN Procesa-Handle IN lh_Handle ('Recalculo').

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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FlgIgv V-table-Win
ON VALUE-CHANGED OF VtaCDocu.FlgIgv IN FRAME F-Main /* Incluido IGV */
DO:
  
  S-CODIGV = IF VtaCDocu.FlgIgv:SCREEN-VALUE = "YES" THEN 1 ELSE 2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON F8 OF VtaCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
OR left-mouse-dblclick OF VtaCDocu.fmapgo
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
   IF VtaCDocu.FmaPgo:SCREEN-VALUE <> "" THEN DO:
       /* FIltrado de las condiciones de venta */
       IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
           MESSAGE 'Condición de venta NO autorizado para este cliente'
               VIEW-AS ALERT-BOX WARNING.
           RETURN NO-APPLY.
       END.
       F-CndVta:SCREEN-VALUE = "".
       S-CNDVTA = VtaCDocu.FmaPgo:SCREEN-VALUE.
       FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt THEN DO:
          F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
       END.   
   END.
   ELSE F-CndVta:SCREEN-VALUE = "".

    /* RHC: 11/09/08 EL TIPO DE CAMBIO AHORA DEPENDE DE LA FAMILIA */
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
    /* ************************************************************** */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.NomCli V-table-Win
ON LEAVE OF VtaCDocu.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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
       RUN vtamay/D-RegCar (S-NROTAR).
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


&Scoped-define SELF-NAME VtaCDocu.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON LEAVE OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
DO:
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = VtaCDocu.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied
    THEN ASSIGN 
          FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
          VtaCDocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
          VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE VtaCDocu.Glosa:SCREEN-VALUE).
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
/** Modificar Pedidos **/
EMPTY TEMP-TABLE PEDI2.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' THEN DO:
   FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
       CREATE PEDI2.
       BUFFER-COPY VtaDDocu TO PEDI2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Texto V-table-Win 
PROCEDURE Asigna-Texto :
/*------------------------------------------------------------------------------
  Purpose:     Importacion del archivo de texto de IBC
  Parameters:  <none>
  Notes:       

    Modificó    : Miguel Landeo /*ML01*/
    Fecha       : 19/Nov/2009
    Objetivo    : Guarda campo Punto de Entrega (sede)

------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
  DEF VAR x-CodMat LIKE PEDI2.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE PEDI2.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE PEDI2.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE PEDI2.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF VtaCDocu.CodVen:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero el codigo del vendedor'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.CodVen.
      RETURN NO-APPLY.
    END.
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.FmaPgo.
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

  RUN Actualiza-Item.

/*************
DEFINE TEMP-TABLE tmp-table                                  codped
    FIELDS codmat LIKE almmmatg.codmat                       codven
    FIELDS codfam LIKE almmmatg.codfam                       codcli
    FIELDS subfam LIKE almmmatg.subfam                       codcia
    FIELDS codmar LIKE almmmatg.codmar.                      cndvta
                                                             imptot
INPUT FROM VALUE "D:\ArtWeb.txt".                            fchdoc
REPEAT:
    CREATE tmp-table.
    IMPORT DELIMITER "|" tmp-table NO-ERROR.
END.
INPUT CLOSE.

***************/

  INPUT FROM VALUE(x-Archivo).
  REPEAT:
      CREATE tt-cab.
      IMPORT DELIMITER "|" tt-cab NO-ERROR.
  END.
  INPUT CLOSE.

  FOR EACH tt-cab NO-LOCK:
      DISPLAY tt-cab WITH WIDTH 320.
  END.



/******    
  
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
                s-codcli = gn-clie.codcli.
                VtaCDocu.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    VtaCDocu.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = VtaCDocu.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = VtaCDocu.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      VtaCDocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE VtaCDocu.Glosa:SCREEN-VALUE).
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
            /* consistencia de duplicidad */
            FIND FIRST PEDI2 WHERE PEDI2.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDI2 THEN DO:
                CREATE PEDI2.
                ASSIGN 
                    PEDI2.CodCia = s-codcia
                    PEDI2.codmat = x-CodMat
                    PEDI2.Factor = 1 
                    PEDI2.CanPed = x-CanPed
                    PEDI2.NroItm = x-NroItm 
                    PEDI2.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    PEDI2.ALMDES = S-CODALM
                    PEDI2.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        PEDI2.ImpIgv = x-ImpIgv 
                        PEDI2.ImpLin = x-ImpLin
                        PEDI2.PreUni = (PEDI2.ImpLin / PEDI2.CanPed).
                ELSE ASSIGN
                        PEDI2.ImpIgv = x-ImpIgv 
                        PEDI2.ImpLin = x-ImpLin + x-ImpIgv
                        PEDI2.PreUni = (PEDI2.ImpLin / PEDI2.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      f-NroDec:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
  /* Variable de control */
  s-import-ibc = YES.
  /* PINTAMOS INFORMACION */
  APPLY 'LEAVE':U TO VtaCDocu.codcli IN FRAME {&FRAME-NAME}.

****/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Texto02 V-table-Win 
PROCEDURE Asigna-Texto02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
  DEF VAR x-CodMat LIKE PEDI2.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE PEDI2.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE PEDI2.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE PEDI2.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF VtaCDocu.CodVen:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero el codigo del vendedor'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.CodVen.
      RETURN NO-APPLY.
    END.
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.FmaPgo.
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

/****  RUN Actualiza-Item.****/

/*************
DEFINE TEMP-TABLE tmp-table                                  codped
    FIELDS codmat LIKE almmmatg.codmat                       codven
    FIELDS codfam LIKE almmmatg.codfam                       codcli
    FIELDS subfam LIKE almmmatg.subfam                       codcia
    FIELDS codmar LIKE almmmatg.codmar.                      cndvta
                                                             imptot
INPUT FROM VALUE "D:\ArtWeb.txt".                            fchdoc
REPEAT:
    CREATE tmp-table.
    IMPORT DELIMITER "|" tmp-table NO-ERROR.
END.
INPUT CLOSE.

***************/

  INPUT FROM VALUE(x-Archivo).
  REPEAT:
      CREATE tt-det.
      IMPORT DELIMITER "|" tt-det NO-ERROR.
  END.
  INPUT CLOSE.

  FOR EACH tt-det NO-LOCK:
      DISPLAY tt-det WITH WIDTH 320.
  END.

/******    
  INPUT FROM VALUE(x-Archivo).
  TEXTO:
  REPEAT:
    IMPORT DELIMITER "|" tmp-table NO-ERROR.

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
        /*VtaCDocu.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).*/
    END.
    IF x-Linea BEGINS 'DTM' 
    THEN DO:
        x-Item = ENTRY(5,x-Linea).
        ASSIGN
            VtaCDocu.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +
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
                s-codcli = gn-clie.codcli.
                VtaCDocu.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    VtaCDocu.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = VtaCDocu.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = VtaCDocu.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      VtaCDocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE VtaCDocu.Glosa:SCREEN-VALUE).
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
            /* consistencia de duplicidad */
            FIND FIRST PEDI2 WHERE PEDI2.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDI2 THEN DO:
                CREATE PEDI2.
                ASSIGN 
                    PEDI2.CodCia = s-codcia
                    PEDI2.codmat = x-CodMat
                    PEDI2.Factor = 1 
                    PEDI2.CanPed = x-CanPed
                    PEDI2.NroItm = x-NroItm 
                    PEDI2.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    PEDI2.ALMDES = S-CODALM
                    PEDI2.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        PEDI2.ImpIgv = x-ImpIgv 
                        PEDI2.ImpLin = x-ImpLin
                        PEDI2.PreUni = (PEDI2.ImpLin / PEDI2.CanPed).
                ELSE ASSIGN
                        PEDI2.ImpIgv = x-ImpIgv 
                        PEDI2.ImpLin = x-ImpLin + x-ImpIgv
                        PEDI2.PreUni = (PEDI2.ImpLin / PEDI2.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      f-NroDec:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
  /* Variable de control */
  s-import-ibc = YES.
  /* PINTAMOS INFORMACION */
  APPLY 'LEAVE':U TO VtaCDocu.codcli IN FRAME {&FRAME-NAME}.

****/


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
    FOR EACH VtaDDocu WHERE VtaDDocu.codcia = VtaCDocu.codcia 
            AND  VtaDDocu.CodPed = VtaCDocu.CodPed 
            AND  VtaDDocu.nroped = VtaCDocu.nroped:
        DELETE VtaDDocu.
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
FIND FIRST T-DPEDI2 NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI2 THEN RETURN 'OK'.

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

  EMPTY TEMP-TABLE PEDI2.
  FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
      CREATE PEDI2.
      BUFFER-COPY VtaDDocu 
          TO PEDI2
          ASSIGN 
              PEDI2.CanAte = 0
              PEDI2.Por_Dsctos[1] = 0
              PEDI2.Por_Dsctos[2] = 0
              PEDI2.Por_Dsctos[3] = 0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE VtaDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE VtaDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE VtaCDocu.ImpTot.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2.
DEFINE VARIABLE K AS INTEGER.

IF NUM-ENTRIES(VtaCDocu.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(VtaCDocu.Observa,"-"):
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = VtaCDocu.Observa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(VtaCDocu.Observa,1,INDEX(VtaCDocu.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(VtaCDocu.Observa,INDEX(VtaCDocu.Observa,'@') + 2).
   */
END.
IF VtaCDocu.FlgIgv THEN DO:
   F-ImpTot = VtaCDocu.ImpTot.
END.
ELSE DO:
   F-ImpTot = VtaCDocu.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = S-CODALM 
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN  W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 
W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  

FIND gn-ven WHERE 
     gn-ven.CodCia = VtaCDocu.CodCia AND  
     gn-ven.CodVen = VtaCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = VtaCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = VtaCDocu.codcli + ' - ' + VtaCDocu.Nomcli     .

IF VtaCDocu.CodPed = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = VtaCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF VtaCDocu.Codmon = 2 THEN C-Moneda = "DOLARES US$.".
ELSE C-Moneda = "SOLES   S/. ".

/* ******************************************************************** */

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
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.

cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = s-nomcia.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = TRIM(w-diralm) + FILL(" ",10) + w-tlfalm. 
t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :". 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :". 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = gn-clie.dircli. 
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : ". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(VtaCDocu.fchped, '99/99/9999'). 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "R.U.C.    :". 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + gn-clie.ruc. 
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : ". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(VtaCDocu.fchven, '99/99/9999'). 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "<OFICINA>". 
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Vendedor  :". 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomven. 
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = x-ordcom. 
cRange = "H" + cColumn.
/*chWorkSheet:Range(cRange):Value = VtaCDocu.ordcmp. */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Cond.Venta:". 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomcon. 
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : ". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = c-moneda. 

t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ITEM".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "CANTIDAD".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "UND.".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "D E S C R I P C I O N".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "M A R C A".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "PRECI_VTA".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL NETO".

FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK
        BREAK BY VtaDDocu.NroPed BY VtaDDocu.NroItm:
    IF VtaCDocu.FlgIgv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(VtaDDocu.nroitm, '>>>9').
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + VtaDDocu.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.canped.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.undvta.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    /*
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = .
    */
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
END.

/* PIE DE PAGINA */
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF VtaCDocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

t-column = t-column + 5.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = x-EnLetras.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "NETO A PAGAR : " + c-Moneda.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "OBSERVACIONES :".
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = VtaCDocu.glosa.
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = c-obs[1].
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = c-obs[2].
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "HORA : " +  STRING(TIME,"HH:MM:SS") + "  " + S-USER-ID .

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 V-table-Win 
PROCEDURE Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE VtaDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE VtaDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE VtaCDocu.ImpTot.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(VtaCDocu.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(VtaCDocu.Observa,"-"):
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = VtaCDocu.Observa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(VtaCDocu.Observa,1,INDEX(VtaCDocu.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(VtaCDocu.Observa,INDEX(VtaCDocu.Observa,'@') + 2).
   */
END.
/*IF VtaCDocu.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = VtaCDocu.ImpTot.
END.
ELSE DO:
   F-ImpTot = VtaCDocu.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = S-CODALM 
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN  W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 
W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  

FIND gn-ven WHERE 
     gn-ven.CodCia = VtaCDocu.CodCia AND  
     gn-ven.CodVen = VtaCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = VtaCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = VtaCDocu.codcli + ' - ' + VtaCDocu.Nomcli     .

IF VtaCDocu.CodPed = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = VtaCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF VtaCDocu.Codmon = 2 THEN DO: 
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
x-Plantilla = x-Plantilla + "Cotizacion.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = s-nomcia.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = TRIM(w-diralm) + FILL(" ",10) + w-tlfalm. 
*/
/*Datos Cliente*/
t-Column = 11.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
/*chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + VtaCDocu.ordcmp. */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(VtaCDocu.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(VtaCDocu.fchven, '99/99/9999') . 
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

t-Column = t-Column + 5.
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
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK
        BREAK BY VtaDDocu.NroPed BY VtaDDocu.NroItm DESC:
    /*RDP01 - 
    IF VtaCDocu.FlgIgv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       /*F-PreUni = VtaDDocu.PreUni.*/
       F-ImpLin = VtaDDocu.ImpLin. 
       F-PreUni = VtaDDocu.ImpLin / VtaDDocu.CanPed.
    END.
    ELSE DO:
       /*F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).*/
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
       F-PreUni = ROUND(f-ImpLin / VtaDDocu.CanPed,2).
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(VtaDDocu.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + VtaDDocu.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
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
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  VtaCDocu.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 5.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_Utilex V-table-Win 
PROCEDURE Excel_Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 6.
DEFINE VARIABLE F-PreUni                LIKE VtaDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE VtaDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE VtaCDocu.ImpTot.
DEFINE VARIABLE f-ImpDto                LIKE VtaCDocu.ImpDto.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(VtaCDocu.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(VtaCDocu.Observa,"-"):
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = VtaCDocu.Observa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(VtaCDocu.Observa,1,INDEX(VtaCDocu.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(VtaCDocu.Observa,INDEX(VtaCDocu.Observa,'@') + 2).
   */
END.
/*IF VtaCDocu.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = VtaCDocu.ImpTot.
END.
ELSE DO:
   F-ImpTot = VtaCDocu.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = S-CODALM 
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN  W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 
W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  

FIND gn-ven WHERE 
     gn-ven.CodCia = VtaCDocu.CodCia AND  
     gn-ven.CodVen = VtaCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = VtaCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = VtaCDocu.codcli + ' - ' + VtaCDocu.Nomcli     .

IF VtaCDocu.CodPed = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = VtaCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF VtaCDocu.Codmon = 2 THEN DO: 
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
x-Plantilla = x-Plantilla + "Cotizacion_Sur.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.

/*Datos Cliente*/
t-Column = 17.
cColumn = STRING(t-Column).
cRange = "G" + '15'.
chWorkSheet:Range(cRange):Value = STRING(VtaCDocu.nroped,'999-999999'). 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(VtaCDocu.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(VtaCDocu.fchven, '99/99/9999') . 
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

t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

t-Column = t-Column + 2.

P = t-Column.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK
        BREAK BY VtaDDocu.NroPed BY VtaDDocu.NroItm DESC:
    /*RDP01 - 
    IF VtaCDocu.FlgIgv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.

    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(VtaDDocu.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + VtaDDocu.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.impdto.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  VtaCDocu.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 5.
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

   FOR EACH PEDI2 NO-LOCK BY PEDI2.NroItm: 
       I-NITEM = I-NITEM + 1.
       CREATE VtaDDocu.
       BUFFER-COPY PEDI2 TO VtaDDocu
           ASSIGN
              VtaDDocu.CodCia = VtaCDocu.CodCia
              VtaDDocu.CodDiv = VtaCDocu.CodDiv
              VtaDDocu.CodPed = VtaCDocu.CodPed 
              VtaDDocu.NroPed = VtaCDocu.NroPed 
              VtaDDocu.FchPed = VtaCDocu.FchPed
              /*VtaDDocu.Hora   = VtaCDocu.Hora */
              VtaDDocu.FlgEst = VtaCDocu.FlgEst
              VtaDDocu.NroItm = I-NITEM.
       RELEASE VtaDDocu.
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

{vta/graba-totales.i}


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
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
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
                  AND  (TcmbCot.Rango1 <=  DATE(VtaCDocu.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(VtaCDocu.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1
                  AND   TcmbCot.Rango2 >= DATE(VtaCDocu.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(VtaCDocu.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1 )
                 NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ VtaCDocu.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

    
    f-totdias = DATE(VtaCDocu.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(VtaCDocu.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1.
    S-CODCLI = trim(entry(1,lin,'|')).
    S-CNDVTA = trim(entry(3,lin,'|')).
    S-CODVEN = trim(entry(2,lin,'|')).

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY  S-CODCLI @ VtaCDocu.Codcli
                 Gn-Clie.NomCli @ VtaCDocu.Nomcli
                 Gn-Clie.Ruc    @ VtaCDocu.Ruc
                 S-CODVEN @ VtaCDocu.CodVen
                 Gn-ven.NomVen @ F-Nomven
                 S-CNDVTA @ VtaCDocu.FmaPgo
                 Gn-Convt.Nombr @ F-CndVta.
    END.



input stream entra close.

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
    IF VtaCDocu.CodCli:SCREEN-VALUE  = '' OR VtaCDocu.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'Debe ingresar primero el cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO VtaCDocu.CodCli.
        RETURN.
    END.
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.FmaPgo.
      RETURN NO-APPLY.
    END.
  END.

  ASSIGN
    x-Cab = '\\inf251\intercambio\OCC*' + TRIM(VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}) +
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

/*  FIND Gn-cias WHERE Gn-cias.codcia = s-codcia NO-LOCK.
 *   FIND FIRST t-lgcocmp WHERE t-lgcocmp.codpro = Gn-cias.Libre-C[1] NO-LOCK NO-ERROR.
 *   IF NOT AVAILABLE t-lgcocmp THEN DO:
 *     MESSAGE 'Esta orden de compra no es de este cliente' VIEW-AS ALERT-BOX ERROR.
 *     RETURN 'ADM-ERROR'.
 *   END.*/
  FIND FIRST t-lgcocmp WHERE t-lgcocmp.codpro <> ''.

  DO WITH FRAME {&FRAME-NAME}:
    RUN Actualiza-Item.
    
    ASSIGN
        VtaCDocu.CodMon:SCREEN-VALUE = STRING(t-lgcocmp.codmon, '9')
        /*VtaCDocu.ordcmp:SCREEN-VALUE = STRING(t-lgcocmp.nrodoc, '999999')*/ .

    FOR EACH t-lgdocmp WHERE t-lgdocmp.codmat <> '':
        CREATE PEDI2.
        ASSIGN 
            PEDI2.CodCia = s-codcia
            PEDI2.codmat = t-lgdocmp.CodMat
            PEDI2.Factor = 1
            PEDI2.CanPed = t-lgdocmp.Canpedi
            PEDI2.NroItm = x-Item
            PEDI2.UndVta = t-lgdocmp.UndCmp
            PEDI2.ALMDES = S-CODALM
            PEDI2.AftIgv = (IF t-lgdocmp.IgvMat > 0 THEN YES ELSE NO)
            PEDI2.ImpIgv = (IF t-lgdocmp.igvmat > 0 THEN t-lgdocmp.ImpTot / (1 + t-lgdocmp.IgvMat / 100) * t-lgdocmp.IgvMat / 100 ELSE 0)
            PEDI2.ImpLin = t-lgdocmp.ImpTot
            /*PEDI2.PreUni = t-lgdocmp.PreUni.*/
            PEDI2.PreUni = PEDI2.ImpLin / PEDI2.CanPed.
        x-Item = x-Item + 1.
    END.
  END.
  
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      f-NroDec:SENSITIVE IN FRAME {&FRAME-NAME} = NO.


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
  ASSIGN
    s-Copia-Registro = NO
    s-Import-IBC = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      S-CODMON = 1
      S-NroCot = ""
      X-NRODEC = 2
      s-NroPed = ''
      s-PorIgv = FacCfgGn.PorIgv.

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND  gn-clie.CodCli = FacCfgGn.CliVar
      NO-LOCK NO-ERROR.
  FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR.
  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
      AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1 AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
      NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
      S-TPOCMB = TcmbCot.TpoCmb.  
  END.
    
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
         TODAY @ VtaCDocu.FchPed
         (TODAY + 30) @ VtaCDocu.FchVen
         S-TPOCMB @ VtaCDocu.TpoCmb
         FacCfgGn.CliVar @ VtaCDocu.CodCli.
     ASSIGN
         VtaCDocu.Cmpbnte:SCREEN-VALUE = 'FAC'
         VtaCDocu.CodMon:SCREEN-VALUE = "1"
         VtaCDocu.TpoCmb:SENSITIVE = NO
         F-Nrodec:HIDDEN = NO
         F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9")
         S-CODCLI = VtaCDocu.CodCli:SCREEN-VALUE.
  END.
  RUN Actualiza-Item.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  s-adm-new-record = 'YES'.

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
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE).
     RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
     IF RETURN-VALUE = 'YES' THEN DO:
         RUN Numero-de-Pedido(YES).
         ASSIGN 
             VtaCDocu.CodCia = S-CODCIA
             VtaCDocu.CodDiv = S-CODDIV
             VtaCDocu.CodPed = s-coddoc 
             VtaCDocu.FchPed = TODAY 
             VtaCDocu.CodAlm = S-CODALM
             VtaCDocu.PorIgv = s-PorIgv 
             VtaCDocu.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
             /*VtaCDocu.TpoPed = ""*/
             VtaCDocu.Hora = STRING(TIME,"HH:MM").
         IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN VtaCDocu.flgest = 'E'.
         IF s-Import-Ibc = YES THEN VtaCDocu.Libre_C05 = "1".
         DISPLAY VtaCDocu.NroPed.
     END.
     ELSE DO:
         RUN Borra-Pedido.
         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     END.
     ASSIGN 
         VtaCDocu.Observa = f-Observa
        VtaCDocu.Usuario = S-USER-ID
        /*VtaCDocu.TipVta  = (IF VtaCDocu.Cmpbnte = 'FAC' THEN '1' ELSE '2')*/ .
    RUN Genera-Pedido.    /* Detalle del pedido */ 
    RUN Graba-Totales.
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
/*   RETURN "ADM-ERROR".   /* OJO */ */
  
  IF NOT AVAILABLE VtaCDocu THEN RETURN "ADM-ERROR".
  ASSIGN
      S-CODMON = VtaCDocu.CodMon
      S-CODCLI = VtaCDocu.CodCli
      S-CODIGV = IF VtaCDocu.FlgIgv THEN 1 ELSE 2
      S-TPOCMB = VtaCDocu.TpoCmb
      S-NroCot = ""
      X-NRODEC = 2
      S-CNDVTA = VtaCDocu.FmaPgo
      s-Copia-Registro = YES
      s-Import-IBC = NO.
  RUN Copia-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
      AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1 AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
      NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
      S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          TODAY @ VtaCDocu.FchPed
          (TODAY + 15) @ VtaCDocu.FchVen
          S-TPOCMB @ VtaCDocu.TpoCmb.
     DISPLAY "" @ VtaCDocu.NroPed
             "" @ F-Estado.
     ASSIGN
         VtaCDocu.TpoCmb:SENSITIVE = NO
         F-Nrodec:HIDDEN = NO
         F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9").
  END.
  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = s-codcli
    NO-LOCK NO-ERROR.
  s-cndvta-validos = gn-clie.cndvta.
  FIND gn-convt WHERE gn-ConVt.Codig = '900' NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt AND INDEX(s-cndvta-validos, '900') = 0
      THEN IF s-cndvta-validos = '' 
            THEN s-cndvta-validos = '900'.
            ELSE s-cndvta-validos = gn-clie.cndvta + ',900'.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
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
       MESSAGE "La cotizacion ya fue anulada" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF VtaCDocu.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar una cotizacion atendida" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF VtaCDocu.FlgEst = "X" THEN DO:
       MESSAGE "No puede eliminar una cotizacion cerrada" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    /* NO PASA si tiene atenciones parciales */
    FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.canate <> 0 NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDDocu THEN DO:
        MESSAGE 'Tiene atenciones parciales' SKIP
            'Acceso denegado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
    END.
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
/*        DELETE FROM VtaDDocu WHERE VtaDDocu.codcia = VtaCDocu.codcia 
 *                               AND  VtaDDocu.CodPed = VtaCDocu.CodPed 
 *                               AND  VtaDDocu.nroped = VtaCDocu.nroped.*/
       FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(VtaCDocu) EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE B-CPedi THEN 
          ASSIGN B-CPedi.FlgEst = "A"
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
  F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = YES. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE VtaCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                   AND  gn-clie.CodCli = VtaCDocu.CodCli 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY VtaCDocu.NomCli 
                VtaCDocu.RucCli  
                VtaCDocu.DirCli.
        CASE VtaCDocu.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY "CERRADA"   @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "E" THEN DISPLAY "POR APROBAR" @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
     END.  
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = VtaCDocu.CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

     IF VtaCDocu.FchVen < TODAY AND VtaCDocu.flgest = 'P'
        THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.

     F-Nomtar:SCREEN-VALUE = ''.
     FIND Gn-Card WHERE Gn-Card.NroCard = FacCPedm.NroCar NO-LOCK NO-ERROR.
     IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].

     FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
         AND GN-ClieD.CodCli = VtaCDocu.Codcli
         AND GN-ClieD.sede = VtaCDocu.sede
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
          VtaCDocu.FchPed:SENSITIVE = NO
          VtaCDocu.NomCli:SENSITIVE = NO
          VtaCDocu.RucCli:SENSITIVE = NO
          VtaCDocu.DirCli:SENSITIVE = NO
          VtaCDocu.Sede:SENSITIVE = NO
          BUTTON-10:SENSITIVE = YES.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO'
      THEN ASSIGN
            VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
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
  MESSAGE '¿Para Imprimir el documento marque'  SKIP
          '   1. Si = Incluye IGV.      ' SKIP
          '   2. No = No incluye IGV.      '
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE lchoice AS LOGICAL.
  IF lchoice = ? THEN RETURN 'adm-error'.
  IF VtaCDocu.FlgEst <> "A" THEN DO:
      IF VtaCDocu.fchped < 12/28/2010 
          THEN RUN VTA\R-ImpCot (ROWID(VtaCDocu)).
      ELSE RUN VTA\R-ImpCot-1 (ROWID(VtaCDocu),lchoice).
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
  RUN vta\d-cotiza.r (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        VtaCDocu.FlgIgv:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        (DATE(VtaCDocu.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(VtaCDocu.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1)
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  s-adm-new-record = 'NO'.
  
  MESSAGE "Desea Imprimir Cotizacion?" SKIP(1)
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "" UPDATE choice AS LOGICAL.
  CASE choice:
    WHEN TRUE THEN /* Yes */
    DO:
      RUN dispatch IN THIS-PROCEDURE ('imprime':U).
    END.
  END CASE.

/* rhc 12.04.10
/*ML01* Graba log */
/*ML01*/ IF CAN-FIND (FIRST T-DPEDI) THEN
/*ML01*/    RUN vta/p-movhist(s-CodDoc,VtaCDocu.NroPed).
***************** */
  
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
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
   IF VtaCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO VtaCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
       AND  gn-clie.CodCli = VtaCDocu.CodCli:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO VtaCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.

   RUN vtagn/p-gn-clie-01 (VtaCDocu.CodCli:SCREEN-VALUE, s-coddoc).
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

   /*
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
   */
   IF VtaCDocu.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO VtaCDocu.CodVen.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
       AND  gn-ven.CodVen = VtaCDocu.CodVen:screen-value        
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
   IF VtaCDocu.NroCar:SCREEN-VALUE <> "" THEN DO:
     FIND Gn-Card WHERE Gn-Card.NroCard = VtaCDocu.NroCar:SCREEN-VALUE
                           NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Gn-Card THEN DO:
         MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.NroCar.
         RETURN "ADM-ERROR".   
      END.   
    END.           
   FOR EACH PEDI2 NO-LOCK: 
       F-Tot = F-Tot + PEDI2.ImpLin.
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO VtaCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   /* RHC 09/03/04 IMPORTE MAXIMO PARA BOLETAS */
/*    F-BOL = IF INTEGER(VtaCDocu.CodMon:SCREEN-VALUE) = 1 THEN F-TOT */
/*             ELSE F-Tot * DECIMAL(VtaCDocu.TpoCmb:SCREEN-VALUE).    */
/*    IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL >= 700       */
/*        /*AND VtaCDocu.Atencion:SCREEN-VALUE = ''*/                 */
/*    THEN DO:                                                        */
/*         MESSAGE "Venta Mayor a 700.00 Ingresar DNI, Verifique... " */
/*             VIEW-AS ALERT-BOX ERROR.                               */
/*         APPLY "ENTRY" TO VtaCDocu.Atencion.                        */
/*         RETURN "ADM-ERROR".                                        */
/*    END.                                                            */
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
   /* ***************************************************** */
   IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'FAC' AND VtaCDocu.RucCli:SCREEN-VALUE = ''
   THEN DO:
        MESSAGE "El cliente debe tener RUC" 
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.CodCli.
        RETURN "ADM-ERROR".   
   END.
   /* rhc 22.06.09 Control de Precios IBC */
   IF s-Import-IBC = YES THEN DO:
        RUN CONTROL-IBC.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
   END.
   /* RHC 23.06.10 COntrol de seds por autoservicios
        Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
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
/* NO PASA si tiene atenciones parciales */
FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.canate <> 0 NO-LOCK NO-ERROR.
IF AVAILABLE VtaDDocu THEN DO:
    MESSAGE 'Tiene atenciones parciales' SKIP
        'Acceso denegado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = VtaCDocu.CodMon
    S-CODCLI = VtaCDocu.CodCli
    S-CODIGV = IF VtaCDocu.FlgIgv THEN 1 ELSE 2
    S-TPOCMB = VtaCDocu.TpoCmb
    X-NRODEC = 2
    S-CNDVTA = VtaCDocu.FmaPgo
    s-Copia-Registro = NO
    s-Import-IBC = NO
    s-Pendiente-IBC = NO
    s-adm-new-record = 'NO'
    s-nroped = VtaCDocu.NroPed
    s-PorIgv = VtaCDocu.PorIgv.
IF VtaCDocu.Libre_C05 = "1" THEN s-Import-Ibc = YES.

IF VtaCDocu.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
ASSIGN 
    F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = NO
    F-NRODEC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(X-NRODEC,"9").
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

