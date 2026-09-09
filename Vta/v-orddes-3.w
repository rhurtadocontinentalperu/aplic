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
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-TIPVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOPED   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE BUFFER B-DPedi  FOR FacDPedi.
DEFINE BUFFER B-DPedi2 FOR FacDPedi.
DEFINE BUFFER B-CPedi  FOR FacCPedi.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias           AS INTEGER NO-UNDO.
DEFINE VARIABLE x-codalm AS CHARACTER NO-UNDO.

FIND First FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
DEFINE VARIABLE sw-tpoped AS LOGICAL NO-UNDO.

DEFINE VAR x-ordcmp AS CHARACTER.
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-20 BUTTON-10 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.TpoPed ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.fchven FacCPedi.NomCli ~
FacCPedi.RucCli FacCPedi.DirCli FacCPedi.TpoCmb FacCPedi.CodVen ~
FacCPedi.NroRef FacCPedi.FmaPgo FacCPedi.CodAlm FacCPedi.Glosa ~
FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.LugEnt2 FacCPedi.CodTrans ~
FacCPedi.Atencion FacCPedi.Hora FacCPedi.ordcmp FacCPedi.Ubigeo[3] ~
FacCPedi.Ubigeo[2] FacCPedi.Ubigeo[1] FacCPedi.TpoLic 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Situac F-nOMvEN F-CndVta ~
C-TipVta F-Departamento F-Provincia F-Distrito 

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
     LABEL "..." 
     SIZE 3 BY .69.

DEFINE VARIABLE C-TipVta AS CHARACTER FORMAT "X(8)" 
     LABEL "Detalle" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "CON IGV","SIN IGV" 
     DROP-DOWN-LIST
     SIZE 10.86 BY 1.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Departamento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-Distrito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .62 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Provincia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-Situac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 9.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.15 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
          FONT 0
     FacCPedi.TpoPed AT ROW 1.19 COL 25 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "G/R Manual", "M":U,
"Normal", ""
          SIZE 21 BY .69
     F-Estado AT ROW 1.19 COL 44.43 COLON-ALIGNED NO-LABEL
     F-Situac AT ROW 1.19 COL 59.57 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 83.14 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodCli AT ROW 1.85 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FacCPedi.fchven AT ROW 1.85 COL 83.14 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.NomCli AT ROW 2.54 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .69
     FacCPedi.RucCli AT ROW 2.54 COL 83.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FacCPedi.DirCli AT ROW 3.31 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 51 BY .69
     BUTTON-10 AT ROW 3.31 COL 62
     FacCPedi.TpoCmb AT ROW 3.31 COL 83.14 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodVen AT ROW 4.04 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-nOMvEN AT ROW 4.04 COL 14.14 COLON-ALIGNED NO-LABEL
     FacCPedi.NroRef AT ROW 4.04 COL 83.14 COLON-ALIGNED
          LABEL "No. Pedido"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     FacCPedi.FmaPgo AT ROW 4.69 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta."
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-CndVta AT ROW 4.69 COL 14.14 COLON-ALIGNED NO-LABEL
     FacCPedi.CodAlm AT ROW 4.69 COL 83.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     FacCPedi.Glosa AT ROW 5.42 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     FacCPedi.CodMon AT ROW 5.42 COL 85 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .62
     FacCPedi.LugEnt AT ROW 6.15 COL 13.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47.29 BY .69
          FGCOLOR 4 
     C-TipVta AT ROW 6.15 COL 83.14 COLON-ALIGNED
     FacCPedi.LugEnt2 AT ROW 6.85 COL 13.14 COLON-ALIGNED
          LABEL "2do. Lugar Entrega"
          VIEW-AS FILL-IN 
          SIZE 47.29 BY .69
     FacCPedi.CodTrans AT ROW 6.85 COL 83.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
     FacCPedi.Atencion AT ROW 7.54 COL 13.14 COLON-ALIGNED
          LABEL "Contacto"
          VIEW-AS FILL-IN 
          SIZE 47.43 BY .69
     FacCPedi.Hora AT ROW 7.54 COL 83.14 COLON-ALIGNED FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FacCPedi.ordcmp AT ROW 8.27 COL 83.29 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     FacCPedi.Ubigeo[3] AT ROW 8.38 COL 13.14 COLON-ALIGNED
          LABEL "Dpto"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-Departamento AT ROW 8.38 COL 16.29 COLON-ALIGNED NO-LABEL
     FacCPedi.Ubigeo[2] AT ROW 8.38 COL 30 COLON-ALIGNED
          LABEL "Prov"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
     F-Provincia AT ROW 8.38 COL 33.14 COLON-ALIGNED NO-LABEL
     FacCPedi.Ubigeo[1] AT ROW 8.38 COL 48.57 COLON-ALIGNED
          LABEL "Distrito"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
     F-Distrito AT ROW 8.38 COL 51.57 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoLic AT ROW 9.08 COL 29 RIGHT-ALIGNED
          LABEL "Para despachar"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .65
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.14 BY .5 AT ROW 5.46 COL 77.86
     RECT-20 AT ROW 1 COL 1
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
         HEIGHT             = 9.04
         WIDTH              = 102.14.
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
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX C-TipVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodTrans IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Departamento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Distrito IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Provincia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FacCPedi.Hora IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.TpoLic IN FRAME F-Main
   NO-ENABLE ALIGN-R EXP-LABEL                                          */
/* SETTINGS FOR RADIO-SET FacCPedi.TpoPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[3] IN FRAME F-Main
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
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* ... */
DO:
  ASSIGN
    input-var-1 = FacCPedi.CodCli:SCREEN-VALUE
    input-var-2 = FacCPedi.NomCli:SCREEN-VALUE
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN vta/c-clied.
  IF output-var-2 <> '' THEN FacCPedi.DirCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-TipVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TipVta V-table-Win
ON VALUE-CHANGED OF C-TipVta IN FRAME F-Main /* Detalle */
DO:
  S-TIPVTA = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodAlm V-table-Win
ON LEAVE OF FacCPedi.CodAlm IN FRAME F-Main /* Almacén */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN NO-APPLY.
  FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
    MESSAGE 'Almacen no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  s-codalm = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:
  IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.NomCli @ Faccpedi.nomcli
    gn-clie.Ruc    @ Faccpedi.ruccli
    gn-clie.DirCli @ Faccpedi.dircli
    gn-clie.CodDept @ Faccpedi.ubigeo[3]
    gn-clie.CodProv @ Faccpedi.ubigeo[2]
    gn-clie.CodDist @ Faccpedi.ubigeo[1]
    WITH FRAME {&FRAME-NAME}.
  
  S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE.
/*  /* RHC agregamos el distrito */
 *   FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
 *         AND Tabdistr.Codprovi = gn-clie.codprov 
 *         AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
 *   IF AVAILABLE Tabdistr 
 *   THEN Faccpedi.dircli:SCREEN-VALUE = TRIM(Faccpedi.dircli:SCREEN-VALUE) + ' - ' +
 *                                         TabDistr.NomDistr.*/
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.Fmapgo NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN DO:
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    f-totdias = gn-convt.totdias.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".
  RUN Procesa-Handle IN lh_Handle ('browse').
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


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta. */
DO:

    IF FacCPedi.Fmapgo:SCREEN-VALUE = "" THEN DO:
        F-CndVta:SCREEN-VALUE = "".
        RETURN.
    END.

    F-CndVta:SCREEN-VALUE = "".
    IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE,"000,001,002") = 0 THEN DO:
        lEnCampan = FALSE.
        dImpLCred = 0.
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            /* Línea Crédito Campaña */
            FOR EACH Gn-ClieL WHERE
                Gn-ClieL.CodCia = gn-clie.codcia AND
                Gn-ClieL.CodCli = gn-clie.codcli AND
                Gn-ClieL.FchIni >= TODAY AND
                Gn-ClieL.FchFin <= TODAY NO-LOCK:
                dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.
        END.
        IF dImpLCred <= 0 THEN DO:
            MESSAGE
                " Cliente no Tiene Línea de Crédito " SKIP
                " Solicitar en Administración "
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.FacCPedi.FmaPgo.
            RETURN NO-APPLY.
        END.
    END.
    FIND gn-convt WHERE
        gn-convt.Codig = FacCPedi.Fmapgo:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
        IF gn-convt.totdias > F-totdias THEN DO:
            MESSAGE
                " Condición Crédito es Mayor al Asignado "
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    IF gn-convt.totdias > 0 THEN DO:
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            run vta\lincre.r(gn-clie.CodCli,0,OUTPUT T-SALDO).
            IF RETURN-VALUE <> "OK" THEN
                  MESSAGE "Línea de Crédito agotada" VIEW-AS ALERT-BOX ERROR.
        END.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Ubigeo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[1] V-table-Win
ON LEAVE OF FacCPedi.Ubigeo[1] IN FRAME F-Main /* Distrito */
DO:
  IF FaccPedi.Ubigeo[1]:SCREEN-VALUE = "" THEN DO:
   F-Distrito:SCREEN-VALUE = "" .
   RETURN. 
  END.
  FIND TabDistr WHERE TabDistr.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE AND
                      TabDistr.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE AND
                      TabDistr.CodDistr = FacCPedi.Ubigeo[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TabDistr THEN DO:
      MESSAGE "Distrito no existe " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO FacCPedi.Ubigeo[1].
      RETURN NO-APPLY.   
  END.
  
  F-Distrito:SCREEN-VALUE = TabDistr.NomDistr .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[1] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF FacCPedi.Ubigeo[1] IN FRAME F-Main /* Distrito */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = FacCPedi.Ubigeo[3]:SCREEN-VALUE.
    input-var-2 = FacCPedi.Ubigeo[2]:SCREEN-VALUE.
    output-var-2 = "".
    RUN lkup\C-Distri.r("Distritos").
    IF output-var-2 <> ? THEN FacCPedi.Ubigeo[1]:SCREEN-VALUE = output-var-2.     
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Ubigeo[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[2] V-table-Win
ON LEAVE OF FacCPedi.Ubigeo[2] IN FRAME F-Main /* Prov */
DO:
  IF Faccpedi.Ubigeo[2]:SCREEN-VALUE = "" THEN DO:
   F-Provincia:SCREEN-VALUE = "" .
   F-Distrito:SCREEN-VALUE = "" .
   FacCPedi.Ubigeo[1]:SCREEN-VALUE = "" .
   FacCPedi.Ubigeo[1]:SENSITIVE = NO.
   RETURN. 
  END.
  FIND TabProvi WHERE TabProvi.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE AND
                      TabProvi.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TabProvi THEN DO:
      MESSAGE "Provincia no existe " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO FacCPedi.Ubigeo[2].
      RETURN NO-APPLY.   
  END.
  
  F-Provincia:SCREEN-VALUE = TabProvi.NomProvi .
  FacCPedi.Ubigeo[1]:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[2] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF FacCPedi.Ubigeo[2] IN FRAME F-Main /* Prov */
DO:
   DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = FacCPedi.Ubigeo[3]:SCREEN-VALUE.
    output-var-2 = "".
    RUN lkup\C-Provin.r("Provincias").
    IF output-var-2 <> ? THEN FacCPedi.Ubigeo[2]:SCREEN-VALUE = output-var-2.     
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Ubigeo[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[3] V-table-Win
ON LEAVE OF FacCPedi.Ubigeo[3] IN FRAME F-Main /* Dpto */
DO:
  IF Faccpedi.Ubigeo[3]:SCREEN-VALUE = "" THEN DO:
   F-Departamento:SCREEN-VALUE = "" .
   F-Provincia:SCREEN-VALUE = "" .
   F-Distrito:SCREEN-VALUE = "" .
   FacCPedi.Ubigeo[1]:SENSITIVE = NO.
   FacCPedi.Ubigeo[2]:SENSITIVE = NO.
   FacCPedi.Ubigeo[1]:SCREEN-VALUE = "".
   FacCPedi.Ubigeo[2]:SCREEN-VALUE = "".
   RETURN. 
  END.
  FIND TabDepto WHERE TabDepto.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TabDepto THEN DO:
      MESSAGE "Departamento no existe " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO FacCPedi.Ubigeo[3].
      RETURN NO-APPLY.   
  END.
  
  F-Departamento:SCREEN-VALUE = TabDepto.NomDepto .
  FacCPedi.Ubigeo[2]:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Ubigeo[3] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF FacCPedi.Ubigeo[3] IN FRAME F-Main /* Dpto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Depart.r("Departamentos").
    IF output-var-2 <> ? THEN FacCPedi.Ubigeo[3]:SCREEN-VALUE = output-var-2.     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Documento V-table-Win 
PROCEDURE Actualiza-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /*Actualiza Orden de Despacho y Pedido*/
  IF FacCPedi.FlgEst = 'P' AND FacCPedi.FlgSit = '' THEN DO:
        FOR EACH B-DPedi WHERE B-DPedi.CodCia = FacCPedi.CodCia
          AND B-DPedi.CodDiv = FacCPedi.CodDiv
          AND B-DPedi.CodDoc = FacCPedi.CodDoc
          AND B-DPedi.NroPed = FacCPedi.NroPed
          BREAK BY B-DPedi.CodMat:
            ASSIGN 
              B-DPedi.CanPed = B-DPedi.CanPick.
       /*     FOR EACH B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
                 AND B-CPedi.CodDiv = FacCPedi.CodDiv
                 AND B-CPedi.CodDoc = 'PED'
                 AND B-CPedi.NroPed = FacCPedi.NroRef
                 AND B-CPedi.FlgEst <> 'A' NO-LOCK,
                 EACH B-DPedi2 OF B-CPedi EXCLUSIVE-LOCK 
                      BREAK BY B-DPedi2.CodMat:
                      ACCUMULATE B-DPedi2.CanPed (SUB-TOTAL BY B-DPedi2.CodMat).
                      IF B-DPedi2.CodMat = B-DPedi.CodMat THEN DO:
                         ASSIGN 
                            B-DPedi2.CanAte = ACCUM SUB-TOTAL BY B-DPedi2.CodMat B-DPedi2.CanPed.
                      END.
            END. 
        END.

              FIND FIRST B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
                 AND B-CPedi.CodDiv = FacCPedi.CodDiv
                 AND B-CPedi.CodDoc = 'PED'
                 AND B-CPedi.NroPed = FacCPedi.NroRef 
                 NO-LOCK NO-ERROR.
              IF AVAILABLE B-CPedi THEN DO:
                 FOR EACH B-DPedi2 OF B-CPedi EXCLUSIVE-LOCK
                      BREAK BY B-DPedi2.CodMat:
                      IF B-DPedi2.CodMat = B-DPedi.CodMat THEN DO:
                         ASSIGN 
                            B-DPedi2.CanAte = B-DPedi.CanPick.
                      END.
                 END.
              END.
              ELSE DO:
                FIND B-DPedi WHERE 
                    B-DPedi.CodCia = faccPedi.CodCia AND
                    B-DPedi.CodDoc = "PED"           AND
                    B-DPedi.NroPed = facCPedi.NroRef AND
                    B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE B-DPedi THEN DO:
                        B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed * X-Tipo).
                        B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".                     
                    END.
                    RELEASE B-DPedi.
              END.
*/
            FIND FIRST B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
                 AND B-CPedi.CodDiv = FacCPedi.CodDiv
                 AND B-CPedi.CodDoc = 'PED'
                 AND B-CPedi.NroPed = FacCPedi.NroRef 
                 NO-LOCK NO-ERROR.
            IF AVAILABLE B-CPedi THEN DO:
                 FOR EACH B-DPedi2 OF B-CPedi EXCLUSIVE-LOCK
                      BREAK BY B-DPedi2.CodMat:
                      IF B-DPedi2.CodMat = B-DPedi.CodMat THEN DO:
                         ASSIGN 
                            B-DPedi2.CanAte = B-DPedi.CanPick.
                      END.
                 END.                  
            END.
        
    
        END.
      RELEASE B-CPedi.
      RELEASE B-DPedi.
      RUN Graba-Totales.
      FOR EACH B-CPedi OF FacCPedi EXCLUSIVE-LOCK:
          ASSIGN B-CPedi.FlgSit = 'P'.
      END.
      /*RUN Actualiza-Pedido(1).*/
  END.
  ELSE RETURN 'ADM-ERROR'.
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  DEFINE BUFFER B-DPedi FOR FacDPedi.
  
  /*Buscando Pedido*/
  FOR EACH facdPedi OF faccPedi NO-LOCK
           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND B-DPedi WHERE 
           B-DPedi.CodCia = faccPedi.CodCia AND
           B-DPedi.CodDoc = "PED"           AND
           B-DPedi.NroPed = facCPedi.NroRef AND
           B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi THEN DO:
              B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed * X-Tipo).
              B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".                     
      END.
      RELEASE B-DPedi.
  END.
  FOR EACH B-DPedi WHERE 
           B-DPedi.CodCia = S-CODCIA AND
           B-DPedi.CodDoc = "PED"    AND
           B-DPedi.NroPed = FacCPedi.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
      IF (B-DPedi.CanPed - B-DPedi.CanAte) > 0 THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  RELEASE B-DPedi.
  DO ON ERROR UNDO, RETURN "ADM-ERROR":
     FIND B-CPedi WHERE 
          B-CPedi.CodCia = S-CODCIA AND
          B-CPedi.CodDiv = S-CODDIV AND
          B-CPedi.CodDoc = "PED"    AND
          B-CPedi.NroPed = FacCPedi.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
          EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE B-CPedi THEN 
        ASSIGN B-CPedi.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P".
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
DEFINE VARIABLE f-tot AS DECIMAL NO-UNDO INIT 0.

FIND FIRST B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) 
     EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE B-CPedi THEN DO:
           B-CPEDI.ImpDto = 0.
           B-CPEDI.ImpIgv = 0.
           B-CPEDI.ImpIsc = 0.
           B-CPEDI.ImpTot = 0.
           B-CPEDI.ImpExo = 0.
    FOR EACH B-DPedi OF B-CPedi EXCLUSIVE-LOCK:
         FIND Almmmatg WHERE 
              Almmmatg.CodCia = B-DPedi.CodCia AND  
              Almmmatg.codmat = B-DPedi.codmat 
              NO-LOCK NO-ERROR.
              IF AVAILABLE Almmmatg THEN DO:
                  B-DPedi.ImpDto = ROUND( B-DPedi.PreBas * (B-DPedi.PorDto / 100) * B-DPedi.CanPed , 2 ).   
                  B-DPedi.ImpDto = B-DPedi.ImpDto + ROUND( B-DPedi.PreBas * B-DPedi.CanPed * (1 - B-DPedi.PorDto / 100) * (B-DPedi.Por_Dsctos[1] / 100),4 ).
                  B-DPedi.ImpLin = ROUND( B-DPedi.PreUni * B-DPedi.CanPed , 2 ).
                  F-Tot = f-tot + B-DPedi.ImpLin.
                  F-Igv = F-Igv + B-DPedi.ImpIgv.
                  F-Isc = F-Isc + B-DPedi.ImpIsc.
                    IF B-DPedi.AftIsc THEN B-DPedi.ImpIsc = ROUND(B-DPedi.PreBas * B-DPedi.CanPed * (Almmmatg.PorIsc / 100),4).
                    IF B-DPedi.AftIgv AND C-TIPVTA:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CON IGV' THEN DO: 
                        B-DPedi.ImpIgv = B-DPedi.ImpLin - ROUND(B-DPedi.ImpLin / (1 + (FacCfgGn.PorIgv / 100)),4). 
                    END.
                    IF NOT B-DPedi.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + B-DPedi.ImpLin.
                    IF B-DPedi.AftIgv = YES
                        THEN B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND(B-DPedi.ImpDto / (1 + B-CPEDI.PorIgv / 100), 2).
                    ELSE B-CPEDI.ImpDto = B-CPEDI.ImpDto + B-DPedi.ImpDto.
              END.
              
    END.
        B-CPedi.ImpTot = f-tot.
        B-CPEDI.ImpIgv = ROUND(F-IGV,2).
        B-CPEDI.ImpIsc = ROUND(F-ISC,2).
        B-CPEDI.ImpVta = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpIgv.
        IF B-CPedi.PorDto > 0 THEN DO:
                B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND((B-CPEDI.ImpVta + B-CPEDI.ImpExo) * B-CPEDI.PorDto / 100, 2).
                B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2).
                B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpVta * (1 - B-CPEDI.PorDto / 100),2).
                B-CPEDI.ImpExo = ROUND(B-CPEDI.ImpExo * (1 - B-CPEDI.PorDto / 100),2).
                B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpVta.
        END.  
            B-CPEDI.ImpBrt = B-CPEDI.ImpVta + B-CPEDI.ImpIsc + B-CPEDI.ImpDto + B-CPEDI.ImpExo.
END.
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
        BUTTON-10:VISIBLE = NO.
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
     FIND gn-clie WHERE 
          gn-clie.CodCia = cl-codcia AND  
          gn-clie.CodCli = FacCPedi.CodCli 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO: 
/*        DISPLAY FacCPedi.NomCli @ FILL-IN_NomCli 
 *                   FacCPedi.RucCli @ FILL-IN_RucCli 
 *                   FacCPedi.DirCli @ FILL-IN_DirCli.*/
        CASE FaccPedi.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY " CERRADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
       IF FaccPedi.FlgSit = "P" THEN 
          DISPLAY "PICKEADO OK" @ F-Situac WITH FRAME {&FRAME-NAME}.
       ELSE 
          DISPLAY "FALTA PICK" @ F-Situac WITH FRAME {&FRAME-NAME}.
     END.  
     C-Tipvta:SCREEN-VALUE = FacCPedi.Tipvta.
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE 
          gn-ven.CodCia = S-CODCIA AND  
          gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     
     FIND TabDepto WHERE TabDepto.CodDepto = FacCPedi.Ubigeo[3] NO-LOCK NO-ERROR.
     IF AVAILABLE TabDepto THEN F-Departamento:SCREEN-VALUE = TabDepto.NomDepto .

     FIND TabProvi WHERE TabProvi.CodDepto = FacCPedi.Ubigeo[3] AND
                         TabProvi.CodProvi = FacCPedi.Ubigeo[2] NO-LOCK NO-ERROR.
     IF AVAILABLE TabProvi THEN F-Provincia:SCREEN-VALUE = TabProvi.NomProvi .
     
     FIND TabDistr WHERE TabDistr.CodDepto = FacCPedi.Ubigeo[3] AND
                         TabDistr.CodProvi = FacCPedi.Ubigeo[2] AND
                         TabDistr.CodDistr = FacCPedi.Ubigeo[1] NO-LOCK NO-ERROR.
     IF AVAILABLE TabDistr THEN F-Distrito:SCREEN-VALUE = TabDistr.NomDistr .
     
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
/*  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FacCPedi.FchPed:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO
        BUTTON-10:VISIBLE = YES.
  END.*/

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
    BUTTON-10:VISIBLE = NO.
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
  /* Code placed here will execute AFTER standard behavior.    */

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
     L-CREA = NO.
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

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

