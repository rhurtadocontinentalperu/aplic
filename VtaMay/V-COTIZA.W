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
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi. 
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
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

/* Local Variable Definitions ---                                       */

DEFINE BUFFER B-CPedi FOR FacCPedi.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VARIABLE w-import       AS INTEGER NO-UNDO.

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
FacCPedi.TpoCmb FacCPedi.DirCli FacCPedi.RucCli FacCPedi.fchven ~
FacCPedi.CodPos FacCPedi.FchEnt FacCPedi.CodVen FacCPedi.ordcmp ~
FacCPedi.FmaPgo FacCPedi.NroCard FacCPedi.Glosa FacCPedi.CodMon ~
FacCPedi.TpoLic FacCPedi.FlgIgv 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 F-NRODEC Remate 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.DirCli ~
FacCPedi.RucCli FacCPedi.fchven FacCPedi.CodPos FacCPedi.FchEnt ~
FacCPedi.CodVen FacCPedi.ordcmp FacCPedi.FmaPgo FacCPedi.NroCard ~
FacCPedi.Glosa FacCPedi.CodMon FacCPedi.TpoLic FacCPedi.FlgIgv 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-Postal F-nOMvEN F-CndVta ~
C-TpoVta F-NRODEC Remate 

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
DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "Factura" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Factura","Letras","Boleta" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .81 NO-UNDO.

DEFINE VARIABLE F-NRODEC AS INTEGER FORMAT "9":U INITIAL 2 
     LABEL "Nro Dec" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 6.73.

DEFINE VARIABLE Remate AS LOGICAL INITIAL no 
     LABEL "Remate" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          FONT 0
     F-Estado AT ROW 1.19 COL 52 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 75 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .81
     FacCPedi.TpoCmb AT ROW 1.96 COL 75 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.73 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 39 BY .81
     FacCPedi.RucCli AT ROW 2.73 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.fchven AT ROW 2.73 COL 75 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodPos AT ROW 3.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Postal AT ROW 3.5 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FchEnt AT ROW 3.5 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodVen AT ROW 4.27 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 4.27 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.ordcmp AT ROW 4.27 COL 75 COLON-ALIGNED
          LABEL "Solicitud Cotización"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     FacCPedi.FmaPgo AT ROW 5.04 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.NroCard AT ROW 5.04 COL 52 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     C-TpoVta AT ROW 5.04 COL 75 COLON-ALIGNED
     FacCPedi.Glosa AT ROW 5.81 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
     FacCPedi.CodMon AT ROW 6 COL 77 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     F-NRODEC AT ROW 6.77 COL 9 COLON-ALIGNED
     FacCPedi.TpoLic AT ROW 6.77 COL 21
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .81
     Remate AT ROW 6.77 COL 35
     FacCPedi.FlgIgv AT ROW 6.77 COL 77 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11.57 BY .81
     "Con IGV:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6.77 COL 70
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6 COL 70
     RECT-21 AT ROW 1 COL 1
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
         HEIGHT             = 9
         WIDTH              = 89.86.
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

/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-Postal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:
   IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   S-CODALM = IF Remate:SCREEN-VALUE = "YES" THEN "79" ELSE X-CODALM.
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF gn-clie.ClfCli = "E" THEN DO:
      MESSAGE "Cliente, NECESITA AUTORIZACION " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   /* RHC 09.09.04 NO debe ser cliente varios */
   IF SELF:SCREEN-VALUE = FacCfgGn.CliVar
   THEN DO:
    MESSAGE 'Codigo de clientes varios NO permitido'
        VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
   END.
   DO WITH FRAME {&FRAME-NAME} :
      DISPLAY gn-clie.NomCli @ Faccpedi.NomCli
            gn-clie.Ruc    @ Faccpedi.RucCli
            gn-clie.DirCli @ Faccpedi.DirCli
            gn-clie.CodVen @ FacCPedi.CodVen
            gn-clie.CndVta @ FacCPedi.FmaPgo
            gn-clie.NroCard @ FacCPedi.NroCard.
      S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE.
      S-CNDVTA = gn-clie.CndVta.
      IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
       /*  FILL-IN_NomCli:SENSITIVE = NO.
 *          FILL-IN_RucCli:SENSITIVE = NO.
 *          FILL-IN_DirCli:SENSITIVE = NO.*/
         FacCPedi.NomCli:SENSITIVE = NO.
         FacCPedi.RucCli:SENSITIVE = NO.
         FacCPedi.DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO FacCPedi.CodVen.

      END.   
     ELSE DO: 
/*        FILL-IN_NomCli:SENSITIVE = YES.
 *         FILL-IN_RucCli:SENSITIVE = YES.
 *         FILL-IN_DirCli:SENSITIVE = YES.*/
        FacCPedi.NomCli:SENSITIVE = YES.
        FacCPedi.RucCli:SENSITIVE = YES.
        FacCPedi.DirCli:SENSITIVE = YES.

        APPLY "ENTRY" TO FacCPedi.NomCli.
   
     END. 
   END.  
   /* Ubica la Condicion Venta */
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
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
       DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
               WITH FRAME {&FRAME-NAME}.
       S-TPOCMB = TcmbCot.TpoCmb.  
   END.
      
  RUN Procesa-Handle IN lh_Handle ('browse').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RETURN NO-APPLY.

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


&Scoped-define SELF-NAME FacCPedi.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodPos V-table-Win
ON LEAVE OF FacCPedi.CodPos IN FRAME F-Main /* Postal */
DO:
  FIND almtabla WHERE almtabla.tabla = 'CP'
    AND almtabla.codigo = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla
  THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
  ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen = "".
  IF FacCPedi.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedi.CodVen:screen-value 
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
  X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE).
  IF X-NRODEC < 2 OR X-NRODEC > 4 THEN DO:
   MESSAGE "Numero de Decimales No Permitido " VIEW-AS ALERT-BOX ERROR.
   RETURN NO-APPLY.
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
      
          DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
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
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   IF FacCPedi.FmaPgo:SCREEN-VALUE <> "" THEN DO:
      F-CndVta:SCREEN-VALUE = "".
      S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
         F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      END.   
   END.
   ELSE F-CndVta:SCREEN-VALUE = "".
   RUN Procesa-Handle IN lh_Handle ('Recalculo').
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Gn-Card THEN DO:
        S-NROTAR = SELF:SCREEN-VALUE.
        RUN VTA\D-RegCar.R (INPUT S-NROTAR).
        IF S-NROTAR = "" THEN DO:
            APPLY "ENTRY" TO Faccpedi.NroCard.
            RETURN NO-APPLY.
        END.
        FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
                           NO-LOCK NO-ERROR.
  
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Remate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Remate V-table-Win
ON VALUE-CHANGED OF Remate IN FRAME F-Main /* Remate */
DO:
  S-CODALM = IF Remate:SCREEN-VALUE = "YES" THEN "79" ELSE X-CODALM.
  
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
   FOR EACH facdPedi OF faccPedi NO-LOCK:
       CREATE PEDI.
       RAW-TRANSFER FacDPedi TO PEDI.
       ASSIGN PEDI.CodCia = facdPedi.CodCia 
              PEDI.codmat = facdPedi.codmat 
              PEDI.Factor = facdPedi.Factor 
              PEDI.CanPed = facdPedi.CanPed 
              PEDI.CanAte = 0
       /*       PEDI.CanAte = FacDPedi.CanAte*/
              PEDI.ImpDto = facdPedi.ImpDto 
              PEDI.ImpLin = facdPedi.ImpLin 
              PEDI.NroItm = facdPedi.NroItm 
              PEDI.PorDto = facdPedi.PorDto 
              PEDI.PreUni = facdPedi.PreUni 
              PEDI.UndVta = facdPedi.UndVta
              PEDI.AftIgv = FacdPedi.AftIgv 
              PEDI.AftIsc = FacdPedi.AftIsc 
              PEDI.ImpDto = FacdPedi.ImpDto 
              PEDI.ImpIgv = FacdPedi.ImpIgv 
              PEDI.ImpIsc = FacdPedi.ImpIsc 
              PEDI.PreBas = FacdPedi.PreBas.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
            AND  FacDPedi.coddoc = FacCPedi.coddoc 
            AND  FacDPedi.nroped = FacCPedi.nroped:
            DELETE FacDPedi.
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
   FOR EACH PEDI NO-LOCK BY PEDI.NroItm: 
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi.
              Pedi.CodCia = FacCPedi.CodCia.
              Pedi.CodDiv = FacCPedi.CodDiv.
              Pedi.coddoc = FacCPedi.coddoc. 
              Pedi.NroPed = FacCPedi.NroPed. 
       RAW-TRANSFER PEDI TO FacDPedi.
              ASSIGN 
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.codmat = PEDI.codmat 
              FacDPedi.Factor = PEDI.Factor 
              FacDPedi.CanPed = PEDI.CanPed 
              FacDPedi.CanAte = PEDI.CanAte
              FacDPedi.ImpDto = PEDI.ImpDto 
              FacDPedi.ImpLin = PEDI.ImpLin 
              FacDPedi.NroItm = I-NITEM 
              FacDPedi.PorDto = PEDI.PorDto 
              FacDPedi.PreUni = PEDI.PreUni 
              FacDPedi.UndVta = PEDI.UndVta 
              FacDPedi.AftIgv = PEDI.AftIgv 
              FacDPedi.AftIsc = PEDI.AftIsc 
              FacDPedi.ImpIgv = PEDI.ImpIgv 
              FacDPedi.ImpIsc = PEDI.ImpIsc 
              FacDPedi.PreBas = PEDI.PreBas
              FacDPedi.CodAux = PEDI.CodAux 
              FacDPedi.Por_Dsctos[3] = PEDI.Por_Dsctos[3]. 
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
DO TRANSACTION:

   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   FOR EACH PEDI NO-LOCK: 
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


   /*
   /*******Descuento Por Tarjeta **************************/
   DO WITH FRAME {&FRAME-NAME}:
      IF Faccpedi.NroCard:SCREEN-VALUE <> "" THEN DO:
         B-CPEDI.PorDto = 0.25.
      END.
   END.
           
   /******************************************************/
   */
    B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-cpedi.PorDto / 100),2).
    B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpTot / (1 + B-CPEDI.PorIgv / 100),2).
    B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpVta.
    B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                     B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   RELEASE B-CPEDI.
   
END.
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
        DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

    
    f-totdias = DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1.
    S-CODCLI = trim(entry(1,lin,'|')).
    S-CNDVTA = trim(entry(3,lin,'|')).
    S-CODVEN = trim(entry(2,lin,'|')).

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY  S-CODCLI @ FacCPedi.Codcli
                 Gn-Clie.NomCli @ FacCPedi.Nomcli
                 Gn-Clie.Ruc    @ FacCPedi.Ruc
                 S-CODVEN @ FacCPedi.CodVen
                 Gn-ven.NomVen @ F-Nomven
                 S-CNDVTA @ FacCPedi.FmaPgo
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  S-CODMON = 1.
  S-NroCot = "".
  X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2.

  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND  gn-clie.CodCli = FacCfgGn.CliVar
                 NO-LOCK NO-ERROR.

  FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
                       NO-LOCK NO-ERROR.

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
                AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
               NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
      S-TPOCMB = TcmbCot.TpoCmb.  
  END.
    
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ FacCPedi.FchPed
             TODAY @ FacCPedi.FchVen
             TODAY @ FacCPedi.FchEnt
             S-TPOCMB @ FacCPedi.TpoCmb.
             /*FacCfgGn.CliVar @ FacCPedi.CodCli.*/
     IF s-CodDiv = '00013'      /* Expolibreria */
        AND TODAY < DATE(02,23,2004)
     THEN DISPLAY DATE(02,23,2004) @ FacCPedi.FchVen.
     FacCPedi.CodMon:SCREEN-VALUE = "1".
     C-TpoVta:SENSITIVE = YES. 
     C-TpoVta:SCREEN-VALUE = ENTRY(1,C-TpoVta:LIST-ITEMS).
     FacCPedi.TpoCmb:SENSITIVE = NO.
     F-Nrodec:HIDDEN = NO.
     F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9").
     /*X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE). */
     Remate:HIDDEN = NO.
     Remate:SCREEN-VALUE = STRING(Remate).
     S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE.

  END.
  RUN Actualiza-Item.
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
     
     ASSIGN C-TPOVTA.
            X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE).
          
     IF L-CREA THEN DO:
         RUN Numero-de-Pedido(YES).
         ASSIGN FacCPedi.CodCia = S-CODCIA
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.FchPed = TODAY 
                FacCPedi.CodAlm = S-CODALM
                FacCPedi.PorIgv = FacCfgGn.PorIgv 
                FacCPedi.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                FacCPedi.CodDiv = S-CODDIV
                FacCPedi.TpoPed = "".
                FaccPedi.NroCard = FaccPedi.NroCard:SCREEN-VALUE .
         DISPLAY FacCPedi.NroPed.
     END.
     ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.TipVta  = STRING(LOOKUP(C-TpoVta,C-TpoVta:LIST-ITEMS))
        /*FacCPedi.NomCli  = FILL-IN_NomCli:screen-value*/
        FacCPedi.NomCli 
        FacCPedi.RucCli
        FacCPedi.DirCli  
        FacCPedi.Observa = F-Observa.
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
     FaccPedi.NomCli:SENSITIVE = NO.
     FaccPedi.RucCli:SENSITIVE = NO.
     FaccPedi.DirCli:SENSITIVE = NO.
  END. 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  

  
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
/*  IF LOOKUP(FaccPedi.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".*/
  S-CODMON = FaccPedi.CodMon.
  S-CODCLI = FaccPedi.CodCli.
/*  NRO_PED = FaccPedi.NroPed.*/
  L-CREA = NO.
  RUN Actualiza-Item.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ FaccPedi.NroPed
             "" @ F-Estado.
  END.
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
    IF FacCPedi.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido TOTALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
       MESSAGE "No puede eliminar un pedido PARCIALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
/*        DELETE FROM FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
 *                               AND  FacDPedi.coddoc = FacCPedi.coddoc 
 *                               AND  FacDPedi.nroped = FacCPedi.nroped.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = YES. 
  Remate:HIDDEN IN FRAME {&FRAME-NAME} = YES. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = FacCPedi.CodCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY FaccPedi.NomCli 
                FaccPedi.RucCli  
                FaccPedi.DirCli.
        CASE FaccPedi.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
    END.  
    F-NomVen:screen-value = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedi.CodVen 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
    F-CndVta:SCREEN-VALUE = "".
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS).
    IF FaccPedi.FchVen < TODAY THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = faccpedi.codpos
        NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla
    THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
    ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO'
  THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FacCPedi.CodCli:SENSITIVE = NO
        FacCPedi.fchven:SENSITIVE = NO
        FacCPedi.FlgIgv:SENSITIVE = NO
        FacCPedi.FmaPgo:SENSITIVE = NO
        FacCPedi.NroCard:SENSITIVE = NO
        FacCPedi.CodMon:SENSITIVE = NO
        FacCPedi.TpoCmb:SENSITIVE = NO.
    F-NroDec:SENSITIVE = NO.
  END.
  ELSE F-NroDec:SENSITIVE = YES.
   
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
      RUN VTA\R-ImpCot (ROWID(FacCPedi)).
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
  RUN vta\d-cotiza.r (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        FacCPedi.FlgIgv:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

  IF L-CREA = YES THEN DO:
    MESSAGE "Desea Imprimir Cotizacion?" SKIP(1)
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
    CASE choice:
      WHEN TRUE THEN /* Yes */
      DO:
        RUN dispatch IN THIS-PROCEDURE ('imprime':U).
      END.
    END CASE.
  END.
  
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
     L-CREA = NO.
     RUN Actualiza-Item.
     
     FacCPedi.TpoCmb:SENSITIVE = NO.
     
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
   IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodVen.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                AND  gn-ven.CodVen = FacCPedi.CodVen:screen-value 
               NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodVen.
      RETURN "ADM-ERROR".   
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
   FOR EACH PEDI NO-LOCK: 
       F-Tot = F-Tot + PEDI.ImpLin.
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
    IF FacCPedi.CodPos:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Ingrese el código postal'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR':U.
    END.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = FacCPedi.CodPos:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla
    THEN DO:
        MESSAGE 'Código Postal no Regsitrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR':U.
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
IF LOOKUP(FacCPedi.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".
/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

S-CODMON = FacCPedi.CodMon.
S-CODCLI = FacCPedi.CodCli.
S-CODIGV = IF FacCPedi.FlgIgv THEN 1 ELSE 2.
C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 
S-TPOCMB = FacCPedi.TpoCmb.
X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2.
S-CNDVTA = FacCPedi.FmaPgo.

IF FacCPedi.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
F-Nrodec:HIDDEN = NO.
     F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9").

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

