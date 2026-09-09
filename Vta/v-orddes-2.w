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

DEFINE BUFFER B-CPedi FOR FacCPedi.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.TpoPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.fchven FacCPedi.NomCli FacCPedi.RucCli ~
FacCPedi.DirCli FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.CodAlm ~
FacCPedi.Glosa FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.LugEnt2 ~
FacCPedi.CodTrans FacCPedi.Atencion FacCPedi.Ubigeo[3] FacCPedi.Ubigeo[2] ~
FacCPedi.Ubigeo[1] FacCPedi.TpoLic FacCPedi.ordcmp 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-20 BUTTON-10 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.TpoPed ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.fchven FacCPedi.NomCli ~
FacCPedi.RucCli FacCPedi.DirCli FacCPedi.TpoCmb FacCPedi.CodVen ~
FacCPedi.NroRef FacCPedi.FmaPgo FacCPedi.CodAlm FacCPedi.Glosa ~
FacCPedi.CodMon FacCPedi.LugEnt FacCPedi.LugEnt2 FacCPedi.CodTrans ~
FacCPedi.Atencion FacCPedi.Hora FacCPedi.Ubigeo[3] FacCPedi.Ubigeo[2] ~
FacCPedi.Ubigeo[1] FacCPedi.TpoLic FacCPedi.ordcmp 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nOMvEN F-CndVta C-TipVta ~
F-Departamento F-Provincia F-Distrito F-Situac 

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
     SIZE 10 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.43 BY 9.04.


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
     F-Estado AT ROW 1.19 COL 48 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 73 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodCli AT ROW 1.85 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FacCPedi.fchven AT ROW 1.85 COL 73 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.NomCli AT ROW 2.54 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .69
     FacCPedi.RucCli AT ROW 2.54 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FacCPedi.DirCli AT ROW 3.31 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 51 BY .69
     BUTTON-10 AT ROW 3.31 COL 62
     FacCPedi.TpoCmb AT ROW 3.31 COL 73 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodVen AT ROW 4.04 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-nOMvEN AT ROW 4.04 COL 14.14 COLON-ALIGNED NO-LABEL
     FacCPedi.NroRef AT ROW 4.04 COL 73 COLON-ALIGNED
          LABEL "No. Pedido"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     FacCPedi.FmaPgo AT ROW 4.69 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta."
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-CndVta AT ROW 4.69 COL 14.14 COLON-ALIGNED NO-LABEL
     FacCPedi.CodAlm AT ROW 4.69 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     FacCPedi.Glosa AT ROW 5.42 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     FacCPedi.CodMon AT ROW 5.42 COL 74.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .62
     FacCPedi.LugEnt AT ROW 6.15 COL 13.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47.29 BY .69
          FGCOLOR 4 
     C-TipVta AT ROW 6.15 COL 73 COLON-ALIGNED
     FacCPedi.LugEnt2 AT ROW 6.85 COL 13.14 COLON-ALIGNED
          LABEL "2do. Lugar Entrega"
          VIEW-AS FILL-IN 
          SIZE 47.29 BY .69
     FacCPedi.CodTrans AT ROW 6.85 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
     FacCPedi.Atencion AT ROW 7.54 COL 13.14 COLON-ALIGNED
          LABEL "Contacto"
          VIEW-AS FILL-IN 
          SIZE 47.43 BY .69
     FacCPedi.Hora AT ROW 7.54 COL 73 COLON-ALIGNED FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FacCPedi.Ubigeo[3] AT ROW 8.38 COL 13.14 COLON-ALIGNED
          LABEL "Dpto"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
     F-Departamento AT ROW 8.38 COL 16.29 COLON-ALIGNED NO-LABEL
     FacCPedi.Ubigeo[2] AT ROW 8.38 COL 30 COLON-ALIGNED
          LABEL "Prov"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-Provincia AT ROW 8.38 COL 33.14 COLON-ALIGNED NO-LABEL
     FacCPedi.Ubigeo[1] AT ROW 8.38 COL 48.57 COLON-ALIGNED
          LABEL "Distrito"
          VIEW-AS FILL-IN 
          SIZE 3 BY .69
     F-Distrito AT ROW 8.38 COL 51.57 COLON-ALIGNED NO-LABEL
     F-Situac AT ROW 8.38 COL 73 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoLic AT ROW 9.08 COL 29 RIGHT-ALIGNED
          LABEL "Para despachar"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .65
     FacCPedi.ordcmp AT ROW 9.08 COL 73 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 5.42 COL 67
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
         WIDTH              = 87.43.
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
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX C-TipVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
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
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.Hora IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.TpoLic IN FRAME F-Main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Ubigeo[3] IN FRAME F-Main
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
IF NOT L-CREA THEN DO:
   FOR EACH FacDPedi OF FacCPedi NO-LOCK:
       CREATE PEDI.
       RAW-TRANSFER FacDPedi TO PEDI.
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
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  DEFINE BUFFER B-DPedi FOR FacDPedi.
  
  FOR EACH facdPedi OF faccPedi NO-LOCK
           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND B-DPedi WHERE 
           B-DPedi.CodCia = faccPedi.CodCia AND
           B-DPedi.CodDoc = "PED"           AND
           B-DPedi.NroPed = S-NroCot        AND
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
           B-DPedi.NroPed = S-NroCot:
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
          B-CPedi.NroPed = S-NroCot 
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
   FIND FIRST PEDI NO-LOCK NO-ERROR.
   IF AVAILABLE PEDI THEN RETURN "ADM-ERROR".
   S-NroCot = "".
   input-var-1 = "PED".
   input-var-2 = s-coddiv.
   input-var-3 = 'P'.
   RUN lkup\c-pedi-2 ("Pedidos Pendientes").
   IF output-var-1 = ? THEN RETURN "ADM-ERROR".
   RUN Actualiza-Item.
   /* Busca PEDIDO */
   S-NroCot = output-var-2.
   FIND B-CPedi WHERE 
        B-CPedi.CodCia = S-CODCIA  AND  
        B-CPedi.CodDiv = S-CODDIV  AND  
        B-CPedi.CodDoc = "PED"     AND  
        B-CPedi.NroPed = s-NroCot 
        NO-LOCK NO-ERROR.
   IF Faccpedi.CodAlm:SCREEN-VALUE = '' THEN Faccpedi.CodAlm:SCREEN-VALUE = B-CPEDI.CodAlm.
   F-NomVen = "".
   F-CndVta = "".
   x-codalm = Faccpedi.CodAlm:SCREEN-VALUE.
    IF x-codalm = "" THEN DO:
      MESSAGE "No se puede continuar con la Asignacion" SKIP
              "Codigo de Almacen en blanco "
              VIEW-AS ALERT-BOX.
              RETURN. 
    END.
    ASSIGN
        Faccpedi.CodCli:SCREEN-VALUE = B-CPedi.codcli
        Faccpedi.NomCli:SCREEN-VALUE = B-CPedi.nomcli
        Faccpedi.DirCli:SCREEN-VALUE = B-CPedi.dircli
        Faccpedi.RucCli:SCREEN-VALUE = B-CPedi.ruccli.
  
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = Faccpedi.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
    DISPLAY 
        gn-clie.CodDept @ Faccpedi.ubigeo[3]
        gn-clie.CodProv @ Faccpedi.ubigeo[2]
        gn-clie.CodDist @ Faccpedi.ubigeo[1].
  /**************************************************/
   FIND gn-ven WHERE 
        gn-ven.CodCia = S-CODCIA  AND  
        gn-ven.CodVen = B-CPedi.CodVen 
        NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
   FIND gn-convt WHERE gn-convt.Codig = B-CPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
   
   S-TIPVTA = FacCPedi.Tipvta.
   C-TIPVTA = S-TIPVTA.
   Faccpedi.CodAlm:SENSITIVE = FALSE.
   
   DISPLAY S-NROCOT @ FacCPedi.nroref
           B-CPedi.FmaPgo @ FacCPedi.FmaPgo 
           B-CPedi.CodVen @ FacCPedi.CodVen 
           B-CPedi.Ordcmp @ FaccPedi.Ordcmp
           B-CPedi.Glosa  @ FaccPedi.Glosa
           C-Tipvta F-NomVen F-CndVta.
   FaccPedi.CodMon:SCREEN-VALUE = STRING(B-CPedi.CodMon).
   S-TPOPED = B-CPedi.TpoPed.
   /* DETALLES */
   FOR EACH FacDPedi NO-LOCK WHERE 
            FacDPedi.CodCia = S-CODCIA AND  
            FacDPedi.CodDoc = "PED"    AND  
            FacDPedi.NroPed = S-NroCot
            BY FacDPedi.NroItm:
    IF (FacDPedi.CanPed - FacDPedi.CanAte) gt 0  then do:      
       F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
       RUN vta/stkdispo (s-codcia, x-codalm, FacDPedi.codmat, FacDPedi.Factor * F-CANPED ,
                         OUTPUT S-OK, OUTPUT S-STKDIS).
       IF NOT S-OK THEN F-CANPED = S-STKDIS.
       
       IF F-CANPED > 0 THEN DO:
          CREATE PEDI.
          BUFFER-COPY Facdpedi TO PEDI
            ASSIGN 
                PEDI.Almdes  = x-codalm
                PEDI.CanPed  = F-CANPED
                PEDI.Pesmat  = facdpedi.CanPed
                PEDI.CanAte  = f-CanPed.     /* OJO */
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
             FIND Almmmatg WHERE 
                  Almmmatg.CodCia = PEDI.CodCia AND  
                  Almmmatg.codmat = PEDI.codmat 
                  NO-LOCK NO-ERROR.
             PEDI.ImpDto = ROUND( PEDI.PreBas * (PEDI.PorDto / 100) * PEDI.CanPed , 2 ).
             /* RHC 22.06.06 */
             PEDI.ImpDto = PEDI.ImpDto + ROUND( PEDI.PreBas * PEDI.CanPed * (1 - PEDI.PorDto / 100) * (PEDI.Por_Dsctos[1] / 100),4 ).
             /* ************ */
             PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ).
             IF PEDI.AftIsc THEN 
                PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
             IF PEDI.AftIgv AND S-TIPVTA = 'CON IGV' THEN  
                PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
          END.
       END.
     END.
     ELSE 
        MESSAGE 
            "PED" S-NroCot skip
            "El articulo " facdpedi.codmat "ha sido despachado" skip
            "Cantidad Pedida: " facdpedi.canped skip
            "Cantidad Despachada: " FacDPedi.Canate.
   END.
END.
RUN Procesa-Handle IN lh_Handle ('browse').

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
  DEFINE BUFFER B-DPedi FOR FacDPedi.
  FOR EACH facdPedi OF faccPedi 
           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND B-DPedi WHERE 
           B-DPedi.CodCia = faccPedi.CodCia AND
           B-DPedi.CodDoc = "PED" AND
           B-DPedi.NroPed = S-NroCot AND
           B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi THEN DO:
         B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed.
      END.
      RELEASE B-DPedi.
      DELETE FacDPedi.
  END.

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
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   RUN Borra-Pedido. 
   FOR EACH PEDI NO-LOCK WHERE PEDI.CodMat <> "" BY PEDI.NroItm ON ERROR UNDO, RETURN "ADM-ERROR": 
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
            FacDPedi.NroItm  = I-NITEM.
       RELEASE FacDPedi.
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
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

DO ON ERROR UNDO, RETURN "ADM-ERROR":
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   FOR EACH PEDI NO-LOCK WHERE PEDI.CodMat <> '': 
       /*B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.*/
       F-Igv = F-Igv + PEDI.ImpIgv.
       F-Isc = F-Isc + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
       IF PEDI.AftIgv = YES
       THEN B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND(PEDI.ImpDto / (1 + B-CPEDI.PorIgv / 100), 2).
       ELSE B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
   END.
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpVta = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpIgv.
  /* RHC 22.12.06 */
  IF B-CPedi.PorDto > 0 THEN DO:
    B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND((B-CPEDI.ImpVta + B-CPEDI.ImpExo) * B-CPEDI.PorDto / 100, 2).
    B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpVta * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpExo = ROUND(B-CPEDI.ImpExo * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpVta.
  END.  
  B-CPEDI.ImpBrt = B-CPEDI.ImpVta + B-CPEDI.ImpIsc + B-CPEDI.ImpDto + B-CPEDI.ImpExo.
/*   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
 *                     B-CPEDI.ImpDto - B-CPEDI.ImpExo.*/
  RELEASE B-CPEDI.
END.

END PROCEDURE.


/* calculo anterior 
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   FOR EACH PEDI NO-LOCK
            WHERE PEDI.CodMat <> "": 
       B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
       F-Igv = F-Igv + PEDI.ImpIgv.
       F-Isc = F-Isc + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
   END.
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto.
   IF S-TIPVTA = 'SIN IGV' THEN DO:
      B-CPEDI.ImpIgv = ROUND((B-CPEDI.ImpVta + B-CPEDI.ImpFle ) * (FacCfgGn.PorIgv / 100),2).
      B-CPEDI.Imptot = B-CPEDI.ImpVta + B-CPEDI.Impfle + B-CPEDI.Impigv. 
   END.
   
   RELEASE B-CPEDI.
   
END.
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
  FIND FIRST Almacen WHERE Almacen.Codcia = S-CODCIA AND
                           Almacen.CodDiv = S-CODDIV AND
                           Almacen.AutMov                                
                           NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen Despacho no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN .        
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  S-CODMON = 1.
  S-NroCot = "".
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     FacCPedi.CodVen:SENSITIVE = NO.
     FacCPedi.FmaPgo:SENSITIVE = NO.
     FacCPedi.CodMon:SENSITIVE = NO.
     DISPLAY TODAY @ FacCPedi.FchPed
             TODAY + 7 @ FacCPedi.FchVen
             FacCfgGn.Tpocmb[1] @ FacCPedi.TpoCmb
             FacCfgGn.CliVar @ FacCPedi.CodCli
             Almacen.CodAlm @ FacCpedi.Codalm.
     FacCPedi.CodMon:SCREEN-VALUE = "1".
     S-TIPVTA = 'CON IGV'.
     s-codalm = Almacen.codalm.
     C-Tipvta:SCREEN-VALUE = S-TIPVTA.
     FacCPedi.Ubigeo[2]:SENSITIVE = NO.
     FacCPedi.Ubigeo[1]:SENSITIVE = NO.
     FacCPedi.TpoPed:SCREEN-VALUE = ''.
  END.
  RUN Actualiza-Item.
  
  RUN Asigna-Pedido.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
     IF L-CREA THEN DO:
         RUN Numero-de-Pedido(YES).
         ASSIGN FacCPedi.CodCia = S-CODCIA
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.PorIgv = FacCfgGn.PorIgv 
                FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
                FacCPedi.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                FacCPedi.CodDiv = S-CODDIV
                FacCPedi.CodAlm = x-codalm
                FacCPedi.Nroref = S-NROCOT.
         DISPLAY FacCPedi.NroPed.
     END.
    
     ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Tipvta = C-Tipvta:SCREEN-VALUE.
  END.
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  RUN Actualiza-Pedido (1).

  /* RHC 10.11.06 Auditoria */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    CREATE CcbAudit.
    ASSIGN
        CcbAudit.CodCia = Faccpedi.codcia
        CcbAudit.CodCli = Faccpedi.codcli
        CcbAudit.CodDiv = Faccpedi.coddiv
        CcbAudit.CodDoc = Faccpedi.coddoc
        CcbAudit.CodMon = Faccpedi.codmon
        CcbAudit.CodRef = 'PED'
        CcbAudit.Evento = 'CREATE'
        CcbAudit.Fecha = TODAY
        CcbAudit.Hora = STRING(TIME, 'HH:MM')
        CcbAudit.ImpTot = Faccpedi.imptot
        CcbAudit.NomCli = Faccpedi.nomcli
        CcbAudit.NroDoc = Faccpedi.nroped
        CcbAudit.NroRef = Faccpedi.nroref
        CcbAudit.Usuario= s-user-id.
  END.
  /* ********************** */
 
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
    IF FacCPedi.FlgEst = "A" THEN DO:
       MESSAGE "La orden ya fue anulada" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar una orden atendida" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "X" THEN DO:
       MESSAGE "No puede eliminar una orden cerrada" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
       MESSAGE "No puede eliminar una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    DO ON ERROR UNDO, RETURN "ADM-ERROR":
       S-Nrocot = FacCPedi.Nroref.
       RUN Actualiza-Pedido (-1).
       FOR EACH FacDPedi WHERE 
                FacDPedi.codcia = FacCPedi.codcia AND
                FacDPedi.coddoc = FacCPedi.coddoc AND
                FacDPedi.nroped = FacCPedi.nroped :
           DELETE FacDPedi.
       END.
       FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
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
          DISPLAY "POR CONFIRMAR" @ F-Situac WITH FRAME {&FRAME-NAME}.
       ELSE 
          DISPLAY "  " @ F-Situac WITH FRAME {&FRAME-NAME}.
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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FacCPedi.FchPed:SENSITIVE = NO
        FacCPedi.CodCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO
        BUTTON-10:VISIBLE = YES.
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
  
  IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-ImpOD.r(ROWID(FacCPedi)).

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
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
  
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
           FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
  ELSE 
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
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
   /*  
   FIND FACCFGGN WHERE FACCFGGN.CODCIA = S-CODCIA.
   IF T_IT > FACCFGGN.items_guias THEN DO:
      MESSAGE "Numero de Items Excede el Maximo Permitido " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   */
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
  IF LOOKUP(FacCPedi.FlgEst,"X,C,A") > 0 THEN  RETURN "ADM-ERROR".
  /* RHC 24.01.2007 Verificar despachos parciales */
  FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    IF FacDPedi.CanAte <> 0 THEN DO:
        MESSAGE 'El material' facdpedi.codmat 'tiene atenciones parciales'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.
  S-CODMON = FacCPedi.CodMon.
  S-CODCLI = FacCPedi.CodCli.
  S-NROCOT = FacCPedi.Nroref.
  S-TIPVTA = FacCPedi.Tipvta.
  x-CodAlm = FacCPedi.CodAlm.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

