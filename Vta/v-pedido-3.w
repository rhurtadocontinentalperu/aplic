&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE Facdpedi.
DEFINE SHARED TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-3 NO-UNDO LIKE FacDPedi.



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
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VAR s-adm-new-record AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VAR X-Codalm  AS CHAR NO-UNDO.

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

DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

/* RHC 23.12.04 Variable para controlar cuando un pedido se ha generado a partir de una copia */
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VAR s-documento-registro AS CHAR INIT '' NO-UNDO.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.TpoCmb FacCPedi.DirCli FacCPedi.fchven FacCPedi.RucCli ~
FacCPedi.Atencion FacCPedi.ordcmp FacCPedi.Sede FacCPedi.Cmpbnte ~
FacCPedi.LugEnt FacCPedi.CodMon FacCPedi.Glosa FacCPedi.CodAlm ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.NroCard FacCPedi.NroRef 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.DirCli ~
FacCPedi.fchven FacCPedi.RucCli FacCPedi.Atencion FacCPedi.ordcmp ~
FacCPedi.Sede FacCPedi.Cmpbnte FacCPedi.LugEnt FacCPedi.CodMon ~
FacCPedi.Glosa FacCPedi.CodAlm FacCPedi.CodVen FacCPedi.FmaPgo ~
FacCPedi.NroCard FacCPedi.NroRef 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-sede FILL-IN-Almacen ~
F-nOMvEN F-CndVta F-Nomtar 

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
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 10.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.27 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.27 COL 86 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.08 COL 9 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.NomCli AT ROW 2.08 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
     FacCPedi.TpoCmb AT ROW 2.08 COL 86 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     FacCPedi.fchven AT ROW 2.88 COL 86 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.RucCli AT ROW 3.69 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 3.69 COL 29 COLON-ALIGNED WIDGET-ID 4
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.ordcmp AT ROW 3.69 COL 86 COLON-ALIGNED
          LABEL "O/Compra"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Sede AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-sede AT ROW 4.5 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FacCPedi.Cmpbnte AT ROW 4.5 COL 86 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL","TCK" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
     FacCPedi.LugEnt AT ROW 5.31 COL 9 COLON-ALIGNED WIDGET-ID 20
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     FacCPedi.CodMon AT ROW 5.5 COL 88 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     FacCPedi.Glosa AT ROW 6.12 COL 6.28 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodAlm AT ROW 6.92 COL 9 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-Almacen AT ROW 6.92 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FacCPedi.CodVen AT ROW 7.73 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 7.73 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FmaPgo AT ROW 8.54 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 8.54 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.NroCard AT ROW 9.35 COL 9 COLON-ALIGNED WIDGET-ID 14
          LABEL "Nro. Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-Nomtar AT ROW 9.35 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.NroRef AT ROW 10.15 COL 9 COLON-ALIGNED WIDGET-ID 10
          LABEL "Cotizacion"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 12 
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.5 COL 79
     RECT-21 AT ROW 1 COL 1
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
      TABLE: ITEM T "SHARED" NO-UNDO INTEGRAL Facdpedi
      TABLE: ITEM-2 T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-3 T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 10.5
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

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX FacCPedi.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
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
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME FacCPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF FacCPedi.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
  IF SELF:SCREEN-VALUE = "FAC"
  THEN DO:
    ASSIGN
        Faccpedi.DirCli:SENSITIVE = NO
        Faccpedi.NomCli:SENSITIVE = NO.
    /*APPLY "ENTRY":U TO Faccpedi.codcli.*/
  END.
  ELSE DO:
    ASSIGN
        Faccpedi.DirCli:SENSITIVE = YES 
        Faccpedi.NomCli:SENSITIVE = YES
        Faccpedi.RucCli:SCREEN-VALUE = ''.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodAlm V-table-Win
ON LEAVE OF FacCPedi.CodAlm IN FRAME F-Main /* Almacén */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    FILL-IN-Almacen:SCREEN-VALUE = Almacen.Descripcion.
    /* 08.09.09 Almacenes de despacho */
    IF s-codalm <> SELF:SCREEN-VALUE THEN DO:
        FIND almrepos WHERE almrepos.codalm = s-codalm
            AND almrepos.almped = SELF:SCREEN-VALUE
            AND almrepos.tipmat = 'VTA'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almrepos THEN DO:
            MESSAGE 'Almacen NO AUTORIZADO para ventas' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodAlm V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodAlm IN FRAME F-Main /* Almacén */
OR F8 OF Faccpedi.codalm
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = 'VTA'
        input-var-3 = ''.
    RUN lkup/c-almrep ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  
  IF Faccpedi.CodCli:SCREEN-VALUE = "" THEN RETURN.
   IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
      MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = Faccpedi.CodCli:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie  
  THEN DO:      /* CREA EL CLIENTE NUEVO */
    S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE.
    RUN vta/d-regcli (INPUT-OUTPUT S-CODCLI).
    IF S-CODCLI = "" 
    THEN DO:
        APPLY "ENTRY" TO Faccpedi.CodCli.
        RETURN NO-APPLY.
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND  gn-clie.CodCli = S-CODCLI 
        NO-LOCK NO-ERROR.    
  END.
  /* BLOQUEO DEL CLIENTE */
  IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF gn-clie.FlgSit = "C" THEN DO:
      MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
 
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY 
        gn-clie.CodCli  @ Faccpedi.CodCli
        gn-clie.ruc     @ Faccpedi.Ruccli
        gn-clie.NomCli  @ Faccpedi.NomCli
        gn-clie.DirCli  @ Faccpedi.DirCli.
/*     /* RHC agregamos el distrito */                                                  */
/*     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept                          */
/*         AND Tabdistr.Codprovi = gn-clie.codprov                                      */
/*         AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.                    */
/*     IF AVAILABLE Tabdistr                                                            */
/*     THEN Faccpedi.DirCli:SCREEN-VALUE = TRIM(Faccpedi.DirCli:SCREEN-VALUE) + ' - ' + */
/*                                         TabDistr.NomDistr.                           */
    ASSIGN
        S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE)
        S-CNDVTA = gn-clie.CndVta
        S-CODCLI = gn-clie.CodCli.
  END.
  RUN Procesa-Handle IN lh_Handle ('browse').
  /* DETERMINAMOS LA FECHA Y LA HORA DE INICIO DEL TRACKING */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      s-FechaI = DATETIME(TODAY, MTIME).
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


&Scoped-define SELF-NAME FacCPedi.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.fchven V-table-Win
ON LEAVE OF FacCPedi.fchven IN FRAME F-Main /* Vencimiento */
DO:
  IF INPUT {&self-name} > TODAY + 7 THEN DO:
      MESSAGE 'No pude ser mas de 7 días'
          VIEW-AS ALERT-BOX WARNING.
      DISPLAY TODAY @ {&self-name} WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  F-CndVta:SCREEN-VALUE = ''.
  s-CndVta = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cotizacion V-table-Win 
PROCEDURE Actualiza-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH facdPedi OF faccPedi NO-LOCK :
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = FaccPedi.CodCia AND  
               B-DPedi.CodDoc = "COT"           AND  
               B-DPedi.NroPed = Faccpedi.NroRef AND  
               B-DPedi.CodMat = FacDPedi.CodMat 
               EXCLUSIVE-LOCK NO-ERROR.
          /*IF AVAILABLE B-DPedi THEN B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed.*/
          IF AVAILABLE B-DPedi THEN B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanAte.  /* <<< OJO <<< */
          RELEASE B-DPedi.
      END.
      FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
          AND  FacDPedi.CodDoc = "COT"    
          AND  FacDPedi.NroPed = Faccpedi.NroRef:
          IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
             I-NRO = 1.
             LEAVE.
          END.
      END.
      FIND B-CPedi WHERE 
           B-CPedi.CodCia = S-CODCIA AND  
           B-CPedi.CodDiv = S-CODDIV AND  
           B-CPedi.CodDoc = "COT"    AND  
           B-CPedi.NroPed = Faccpedi.NroRef
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CPedi AND I-NRO = 0 THEN B-CPedi.FlgEst = "C".
      IF AVAILABLE B-CPedi AND I-NRO = 1 THEN B-CPedi.FlgEst = "P".
      RELEASE B-CPedi.
  END.

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
  FOR EACH ITEM:
    DELETE ITEM.
  END.
  FOR EACH ITEM-2:
    DELETE ITEM-2.
  END.
  FOR EACH ITEM-3:
    DELETE ITEM-3.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.

  DO WITH FRAME {&FRAME-NAME}:  
    IF NOT Faccpedi.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
    IF NOT Faccpedi.CodAlm:SENSITIVE THEN RETURN "ADM-ERROR".
    IF Faccpedi.CodCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el código del cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Faccpedi.codcli.
        RETURN "ADM-ERROR".
    END.
    IF Faccpedi.CodAlm:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el código del almacen' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Faccpedi.codalm.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        S-NroCot = ""
        input-var-1 = "COT"
        input-var-2 = Faccpedi.CodCli:SCREEN-VALUE.
    RUN lkup/C-PedidoT ("Cotizaciones Vigentes").
    IF output-var-1 = ? THEN RETURN "ADM-ERROR".
    FIND B-CPEDI WHERE ROWID(B-CPEDI) = output-var-1 NO-LOCK NO-ERROR.
    IF B-CPEDI.FchPed >= 12/28/2010 THEN DO:
        MESSAGE 'Esta opción es solo para cotizaciones generadas antes del 28/12/2010'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF TODAY >= 12/30/2010 AND TODAY <= 01/01/2011
        AND LOOKUP (B-CPEDI.FmaPgo, '000,001,002,003') = 0 THEN DO:
        MESSAGE 'Pedidos al crédito bloqueados hasta el 01 de enero del 2011'
            VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
    END.
    RUN Actualiza-Item.
    ASSIGN
        S-NroCot = SUBSTRING(output-var-2,4,9)      /* *** OJO *** */
        s-CodMon = B-CPEDI.CodMon                   /* >>> OJO <<< */
        F-NomVen = ""
        F-CndVta:SCREEN-VALUE = ""
        S-CNDVTA = B-CPEDI.FmaPgo
        F-NomTar = ''.

    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = B-CPEDI.CodVen 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
    
    FIND gn-convt WHERE gn-convt.Codig = B-CPEDI.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
    
    FIND Gn-Card WHERE Gn-Card.NroCard = B-CPEDI.NroCard NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CARD THEN F-NomTar = GN-CARD.NomClie[1].

    DISPLAY 
        B-CPEDI.CodCli @ Faccpedi.CodCli
        B-CPEDI.NomCli @ Faccpedi.NomCli
        B-CPEDI.RucCli @ Faccpedi.RucCli
        B-CPEDI.DirCli @ Faccpedi.Dircli
        B-CPEDI.CodVen @ Faccpedi.CodVen
        B-CPEDI.Glosa  @ Faccpedi.Glosa
        B-CPEDI.FmaPgo @ Faccpedi.FmaPgo
        B-CPEDI.OrdCmp @ Faccpedi.OrdCmp
        B-CPedi.FchVen @ FacCPedi.FchVen
        B-CPEDI.NroPed @ FacCPedi.NroRef
        B-CPEDI.NroCard @ FacCPedi.NroCard
        B-CPEDI.Sede   @ Faccpedi.Sede
        B-CPEDI.LugEnt @ Faccpedi.LugEnt
        F-CndVta           
        F-NomVen
        F-NomTar.
    ASSIGN
        Faccpedi.Cmpbnte:SCREEN-VALUE = B-CPEDI.Cmpbnte        
        Faccpedi.CodMon:SCREEN-VALUE = STRING(B-CPEDI.CodMon).

    DETALLES:
    FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
        DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
        F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
        /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Facdpedi.UndVta
            NO-LOCK NO-ERROR.
        f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = FacCPedi.CodAlm:SCREEN-VALUE  /* *** OJO *** */
            AND Almmmate.codmat = Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE 'Material' Facdpedi.codmat 'NO asignado al almacén' FacCPedi.CodAlm:SCREEN-VALUE
                VIEW-AS ALERT-BOX WARNING.
            NEXT detalles.
        END.
        x-StkAct = Almmmate.StkAct.
        RUN gn/Stock-Comprometido (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT s-StkComprometido).
        /*MESSAGE facdpedi.codmat x-stkact s-stkcomprometido.*/
        s-StkDis = x-StkAct - s-StkComprometido.
        IF s-StkDis <= 0 THEN DO:
            MESSAGE 'Artículo' Facdpedi.codmat 'no tiene stock disponible' SKIP
                'Almacén:' FAccpedi.codalm:SCREEN-VALUE SKIP
                'Stock actual:' x-StkAct SKIP
                'Stock Comprometido:' s-StkComprometido SKIP
                'Stock Disponible:' s-StkDis
                VIEW-AS ALERT-BOX WARNING.
            NEXT DETALLES.
        END.
        x-CanPed = f-CanPed * f-Factor.
        IF s-StkDis < x-CanPed THEN DO:
            f-CanPed = ((S-STKDIS - (S-STKDIS MODULO Facdpedi.Factor)) / Facdpedi.Factor).
        END.

/*ML01* Inicio de bloque */
        FOR FIRST supmmatg
            FIELDS (supmmatg.codcia supmmatg.codcli supmmatg.codmat supmmatg.Libre_d01)
            WHERE supmmatg.codcia = B-CPedi.CodCia
            AND supmmatg.codcli = B-CPedi.CodCli
            AND supmmatg.codmat = FacDPedi.codmat 
            NO-LOCK:
        END.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
            f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
        END.
/*ML01* Fin de bloque */

        I-NITEM = I-NITEM + 1.
        CREATE ITEM.
        BUFFER-COPY FacDPedi TO ITEM
            ASSIGN 
                ITEM.CodCia = s-codcia
                ITEM.CodDiv = s-coddiv
                ITEM.CodDoc = s-coddoc
                ITEM.NroPed = ''
                ITEM.ALMDES = FacCPedi.CodAlm:SCREEN-VALUE  /* *** OJO *** */
                ITEM.NroItm = I-NITEM
                ITEM.CanPed = F-CANPED
                ITEM.CanAte = 0.
        ITEM.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte).
        ITEM.Libre_c01 = '*'.
        IF ITEM.CanPed <> facdPedi.CanPed THEN DO:
            ITEM.ImpDto = ROUND( ITEM.PreBas * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
            /* RHC 22.06.06 */
            ITEM.ImpDto = ITEM.ImpDto + ROUND( ITEM.PreBas * ITEM.CanPed * (1 - ITEM.PorDto / 100) * (ITEM.Por_Dsctos[1] / 100),4 ).
            /* ************ */
            ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ).
            IF ITEM.AftIsc THEN 
                ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            IF ITEM.AftIgv THEN  
                ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
        END.
    END.
    HIDE FRAME F-Mensaje.
    ASSIGN
        Faccpedi.CodCli:SENSITIVE = NO
        Faccpedi.CodAlm:SENSITIVE = NO.
  END.

  FIND FIRST ITEM NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ITEM THEN DO:
      MESSAGE 'NO hay stock suficiente para atender el pedido' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  RUN Venta-Corregida.

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
          /* BORRAMOS SALDO EN LAS COTIZACIONES */
          FIND B-DPEDI WHERE B-DPEDI.CodCia = Faccpedi.CodCia 
              AND  B-DPEDI.CodDoc = "COT" 
              AND  B-DPEDI.NroPed = Faccpedi.NroRef
              AND  B-DPEDI.CodMat = Facdpedi.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-DPEDI 
          THEN ASSIGN
                B-DPEDI.FlgEst = 'P'
                B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.  /* <<<< OJO <<<< */
          RELEASE B-DPEDI.
          IF p-Ok = YES
          THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */

           FIND B-CPedi WHERE 
                B-CPedi.CodCia = S-CODCIA AND  
                B-CPedi.CodDiv = S-CODDIV AND  
                B-CPedi.CodDoc = "COT"    AND  
                B-CPedi.NroPed = Faccpedi.NroRef
                EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE B-CPedi THEN B-CPedi.FlgEst = "P".
           RELEASE B-CPedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       ML01 /* Salida a Excel como hoja de trabajo */
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

    DEFINE VARIABLE W-DIRALM AS CHAR FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE W-TLFALM AS CHAR FORMAT "X(65)" NO-UNDO.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    IF FacCpedi.FlgIgv THEN DO:
       dImpTot = FacCPedi.ImpTot.
    END.
    ELSE DO:
       dImpTot = FacCPedi.ImpVta.
    END.

    FIND Almacen WHERE 
         Almacen.CodCia = S-CODCIA AND  
         Almacen.CodAlm = S-CODALM 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN W-DIRALM = Almacen.DirAlm. 
    W-TLFALM = Almacen.TelAlm. 
    W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  

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

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

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

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH ITEM WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  FOR EACH item-3:
      DELETE item-3.
  END.
  DETALLE:
  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm: 
      ITEM.Libre_d02 = ITEM.Libre_d01.        /* CONTROL DE CANTIDAD SOLICITADA */
      ITEM.Libre_d01 = ITEM.CanPed.
      ITEM.Libre_c01 = '*'.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = ITEM.UndVta
          NO-LOCK NO-ERROR.
      f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = Almmmate.StkAct.
      RUN gn/Stock-Comprometido (ITEM.CodMat, ITEM.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos los valores de acuerdo a la cantidad */
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* Ajustamos de acuerdo a los multiplos */
          ITEM.CanPed = s-StkDis / f-Factor.
          IF Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */
          RELEASE ITEM-3.
          /* FIN DE CONTROL DE AJUSTES */
          ITEM.ImpDto = ROUND( ITEM.PreBas * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
          /* RHC 22.06.06 */
          ITEM.ImpDto = ITEM.ImpDto + ROUND( ITEM.PreBas * ITEM.CanPed * (1 - ITEM.PorDto / 100) * (ITEM.Por_Dsctos[1] / 100),4 ).
          /* ************ */
          ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ).
          IF ITEM.AftIsc THEN 
              ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
          IF ITEM.AftIgv THEN  
              ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
      END.
      /* ************************************************************************************** */
      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NITEM.
      RELEASE Facdpedi.
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle V-table-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETRY ON STOP UNDO, RETRY:
    /* Detalle del Pedido */
    RUN Genera-Pedido.    /* Detalle del pedido */ 

    /* Grabamos Totales */
    RUN Graba-Totales.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETRY.

    /* Actualizamos la cotizacion */
    RUN Actualiza-Cotizacion.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETRY.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.CodDiv = S-CODDIV 
      AND Faccorre.Codalm = S-CodAlm
      AND Faccorre.FlgEst = YES
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'Correlativo NO configurado para ' s-coddoc SKIP
          'de la division' s-coddiv SKIP
          'del almacén' s-codalm
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  ASSIGN
    s-Copia-Registro = NO
    s-Documento-Registro = ''
    s-FechaHora = ''
    s-FechaI = DATETIME(TODAY, MTIME)
    s-FechaT = ?
    s-CodMon = 2.
  s-adm-new-record = 'YES'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed.
    ASSIGN
        s-TpoCmb = FacCfgGn.TpoCmb[1].
    DISPLAY 
        TODAY @ Faccpedi.FchPed
        S-TPOCMB @ Faccpedi.TpoCmb
        TODAY @ Faccpedi.FchVen
        x-ClientesVarios @ Faccpedi.CodCli
        s-CodAlm @ Faccpedi.codalm.             /* Almacen por defecto */
    ASSIGN
        S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE
        S-CNDVTA = Faccpedi.FmaPgo:SCREEN-VALUE
        Faccpedi.CodMon:SCREEN-VALUE = STRING(s-CodMon).

    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND gn-clie.CodCli = Faccpedi.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  
    THEN DO:
        DISPLAY 
            gn-clie.CodCli @ Faccpedi.CodCli
            gn-clie.ruc    @ Faccpedi.Ruccli.
        IF gn-clie.Ruc = "" 
        THEN Faccpedi.Cmpbnte:SCREEN-VALUE = "BOL".
        ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC".
    END.
    FIND gn-convt WHERE gn-convt.Codig = Faccpedi.FmaPgo:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = s-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FILL-IN-Almacen:SCREEN-VALUE = Almacen.Descripcion.

    RUN Actualiza-Item.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
          AND FacCorre.CodDoc = S-CODDOC 
          AND FacCorre.CodDiv = S-CODDIV 
          AND Faccorre.Codalm = S-CodAlm
          AND FacCorre.FlgEst = YES
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.CodRef = "COT"
        Faccpedi.FchPed = TODAY 
        Faccpedi.PorIgv = FacCfgGn.PorIgv 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodDiv = S-CODDIV
        Faccpedi.FlgEst = "G"
        FacCPedi.Libre_c01 = 'COT'.
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
      /* TRACKING */
      FIND Almacen OF Faccpedi NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
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
/*       RUN gn/pTracking-01 (s-CodCia,                               */
/*                         Almacen.CodDiv,                            */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         s-User-Id,                                 */
/*                         'GNP',                                     */
/*                         'P',                                       */
/*                         s-FechaI,                                  */
/*                         s-FechaT,                                  */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         'COT',                                     */
/*                         Faccpedi.NroRef).                          */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
  END.
  ELSE DO:
      RUN Borra-Pedido (TRUE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      Faccpedi.Usuario = S-USER-ID
      Faccpedi.Hora   = STRING(TIME,"HH:MM").

  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO se pudo generar el pedido' SKIP
          'NO hay stock suficiente en los almacenes' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Venta-Corregida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Procesa-Handle IN lh_Handle ('browse'). 
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Grabamos Totales */
  RUN Graba-Totales.

  /* APROBAMOS EL PEDIDO O LO RECHAZAMOS */
  IF FacCPedi.FlgEst <> 'P' THEN DO:
      RUN Verifica-Cliente.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Actualizamos la cotizacion */
  RUN gn/actualiza-cotizacion ( ROWID(Faccpedi), +1 ).
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
    AND FacCorre.CodDiv = S-CODDIV 
    AND Faccorre.Codalm = S-CodAlm
    AND Faccorre.FlgEst = YES
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'Correlativo NO configurado para ' s-coddoc SKIP
          'de la division' s-coddiv SKIP
          'del almacén' s-codalm
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
    S-CNDVTA = Faccpedi.FmaPgo.
  FOR EACH ITEM:
    DELETE ITEM.
  END.
  FOR EACH ITEM-2:
    DELETE ITEM-2.
  END.
  FOR EACH ITEM-3:
    DELETE ITEM-3.
  END.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
    /* SI HUBIERA UN PICKING ANTERIOR */
    IF Faccpedi.FchPed = TODAY AND Faccpedi.FlgEst = 'C' 
        THEN ITEM.CanPed = ITEM.CanPick.
    IF ITEM.CanPed = 0 THEN DELETE ITEM.
    /* ****************************** */
  END.
  /* RHC 13.02.08 anular el pedido original */
  IF Faccpedi.FlgEst <> 'C' THEN DO:
      IF Faccpedi.FlgEst = 'P' THEN DO:
          /* TRACKING */
          s-FechaT = DATETIME(TODAY, MTIME).
          RUN vta/pFlujoPedido (s-CodCia,
                                s-CodDiv,
                                'GNP',
                                s-User-Id,
                                Faccpedi.CodDoc,
                                Faccpedi.NroPed,
                                'A',
                                'IO',
                                s-FechaI,
                                s-FechaT).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.almdes <> s-codalm,
              FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = Facdpedi.almdes
              AND Almacen.coddiv <> s-coddiv
              BREAK BY Almacen.coddiv:
              IF FIRST-OF(Almacen.coddiv) THEN DO:
                  /* TRACKING */
                  s-FechaT = DATETIME(TODAY, MTIME).
                  RUN vta/pFlujoPedido (s-CodCia,
                                        Almacen.CodDiv,
                                        'GNP',
                                        s-User-Id,
                                        Faccpedi.CodDoc,
                                        Faccpedi.NroPed,
                                        'A',
                                        'IO',
                                        s-FechaI,
                                        s-FechaT).
                  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
              END.
          END.
      END.
      ASSIGN Faccpedi.FlgEst = 'A'.
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
    IF FacCPedi.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "E" THEN DO:
       MESSAGE "No puede eliminar un pedido cerrado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    /*
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
    */

/*     FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.canate > 0 NO-LOCK NO-ERROR. */
/*     IF AVAILABLE Facdpedi THEN DO:                                              */
/*        MESSAGE "No puede eliminar un pedido con atención parcial" SKIP          */
/*         "Codigo:" Facdpedi.codmat                                               */
/*         VIEW-AS ALERT-BOX ERROR.                                                */
/*        RETURN "ADM-ERROR".                                                      */
/*     END.                                                                        */

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

      IF Faccpedi.flgest = 'P' THEN DO:
          /* TRACKING */
          FIND Almacen OF Faccpedi NO-LOCK.
          s-FechaT = DATETIME(TODAY, MTIME).
          RUN vtagn/pTracking-04 (s-CodCia,
                        s-CodDiv,
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        s-User-Id,
                        'ANP',
                        'A',
                        DATETIME(TODAY, MTIME),
                        DATETIME(TODAY, MTIME),
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        Faccpedi.CodRef,
                        Faccpedi.NroRef).
/*           RUN gn/pTracking-01 (s-CodCia,                               */
/*                             Almacen.CodDiv,                            */
/*                             Faccpedi.CodDoc,                           */
/*                             Faccpedi.NroPed,                           */
/*                             s-User-Id,                                 */
/*                             'ANP',                                     */
/*                             'A',                                       */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             Faccpedi.CodDoc,                           */
/*                             Faccpedi.NroPed,                           */
/*                             Faccpedi.CodDoc,                           */
/*                             Faccpedi.NroPed).                          */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
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
      FIND Almacen OF Faccpedi NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
/*       RUN gn/pTracking-01 (s-CodCia,                               */
/*                         Almacen.CodDiv,                            */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         s-User-Id,                                 */
/*                         'GNP',                                     */
/*                         'A',                                       */
/*                         DATETIME(TODAY, MTIME),                    */
/*                         DATETIME(TODAY, MTIME),                    */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         'COT',                                     */
/*                         Faccpedi.NroRef).                          */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

      /* BORRAMOS DETALLE */
      RUN Borra-Pedido (FALSE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN
          Faccpedi.FlgEst = 'A'.
      FIND CURRENT Faccpedi NO-LOCK.
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
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = Faccpedi.CodCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY Faccpedi.NomCli 
                Faccpedi.RucCli  
                Faccpedi.DirCli.
        CASE FaccPedi.FlgEst:
          WHEN "A" THEN DISPLAY "  ANULADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY " ATENDIDO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "G" THEN DISPLAY " GENERADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY " APROBADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY "  VENCIDO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "F" THEN DISPLAY " FACTURADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY "NO APROBADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "W" THEN DISPLAY "NO APROBADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "R" THEN DISPLAY " RECHAZADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "E" THEN DISPLAY "  CERRADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
    END.  
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
    fill-in-Almacen:SCREEN-VALUE = ''.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND ALmacen.codalm = Faccpedi.codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN fill-in-Almacen:SCREEN-VALUE = Almacen.Descripcion.

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
        Faccpedi.NomCli:SENSITIVE = NO
        Faccpedi.DirCli:SENSITIVE = NO
        Faccpedi.RucCli:SENSITIVE = NO
        Faccpedi.FchPed:SENSITIVE = NO
        Faccpedi.TpoCmb:SENSITIVE = NO
        Faccpedi.FmaPgo:SENSITIVE = NO
        /*Faccpedi.OrdCmp:SENSITIVE = NO*/
        Faccpedi.CodVen:SENSITIVE = NO
        Faccpedi.CodMon:SENSITIVE = NO
        Faccpedi.Cmpbnte:SENSITIVE = NO
        Faccpedi.NroRef:SENSITIVE = NO
        Faccpedi.NroCard:SENSITIVE = NO
        Faccpedi.Sede:SENSITIVE = NO
        Faccpedi.LugEnt:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' 
        THEN Faccpedi.CodAlm:SENSITIVE = NO.
        ELSE Faccpedi.CodAlm:SENSITIVE = YES.
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
  IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-ImpPed (ROWID(FacCPedi)).

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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
DEFINE VARIABLE F-SALDO AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Código de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE
        gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Código de cliente no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Faccpedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF LOOKUP(TRIM(Faccpedi.CodCli:SCREEN-VALUE), x-ClientesVarios) = 0
        AND LENGTH(TRIM(Faccpedi.CodCli:SCREEN-VALUE)) <> 11
        THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Faccpedi.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    IF Faccpedi.CodAlm:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO Faccpedi.CodAlm.
      RETURN "ADM-ERROR".
    END.
    IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Código de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".
    END.
    FIND gn-ven WHERE
        gn-ven.CodCia = S-CODCIA AND
        gn-ven.CodVen = FacCPedi.CodVen:screen-value 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Código de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".
    END.
    ELSE DO:
        IF gn-ven.flgest = "C" THEN DO:
            MESSAGE "Código de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.CodVen.
            RETURN "ADM-ERROR".
        END.
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condición Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
    END.
    FIND gn-convt WHERE
        gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condición Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
    END.
    FOR EACH ITEM NO-LOCK: 
        F-Tot = F-Tot + ITEM.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.

    /* VERIFICAMOS LA LINEA DE CREDITO */
    f-Saldo = f-Tot.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN F-Saldo = F-Tot - FacCpedi.Imptot.
    DEF VAR t-Resultado AS CHAR NO-UNDO.
    RUN gn/linea-de-credito ( s-CodCli,
                              f-Saldo,
                              s-CodMon,
                              s-CndVta,
                              TRUE,
                              OUTPUT t-Resultado).
    IF t-Resultado = 'ADM-ERROR' THEN DO:
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.

/*     IF LOOKUP(TRIM(Faccpedi.Fmapgo:SCREEN-VALUE),"000,001,002,403") = 0 THEN DO:     */
/*         IF S-CODMON = 1 THEN DO:                                                     */
/*             IF gn-clie.MonLC = 2 THEN F-Tot = F-Tot / FacCfgGn.TpoCmb[1].            */
/*         END.                                                                         */
/*         ELSE DO:                                                                     */
/*             IF gn-clie.MonLC = 1 THEN F-Tot = F-Tot * FacCfgGn.TpoCmb[1].            */
/*         END.                                                                         */
/*         RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                         */
/*         IF RETURN-VALUE = 'YES' THEN DO:                                             */
/*             RUN vta\lincre (gn-clie.CodCli,F-Tot,OUTPUT T-SALDO).                    */
/*             F-SALDO = F-TOT.                                                         */
/*         END.                                                                         */
/*         ELSE DO:                                                                     */
/*             RUN vta\lincre.r(gn-clie.CodCli,F-Tot - FacCpedi.Imptot,OUTPUT T-SALDO). */
/*             F-SALDO = F-Tot - FacCpedi.Imptot.                                       */
/*         END.                                                                         */
/*         IF RETURN-VALUE <> "OK" THEN DO:                                             */
/*             dImpLCred = 0.                                                           */
/*             lEnCampan = FALSE.                                                       */
/*             /* Línea Crédito Campaña */                                              */
/*             FOR EACH Gn-ClieL WHERE                                                  */
/*                 Gn-ClieL.CodCia = gn-clie.codcia AND                                 */
/*                 Gn-ClieL.CodCli = gn-clie.codcli AND                                 */
/*                 TODAY >= Gn-ClieL.FchIni AND                                         */
/*                 TODAY <= Gn-ClieL.FchFin NO-LOCK:                                    */
/*                 dImpLCred = dImpLCred + Gn-ClieL.ImpLC.                              */
/*                 lEnCampan = TRUE.                                                    */
/*             END.                                                                     */
/*             /* Línea Crédito Normal */                                               */
/*             IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.                         */
/*                                                                                      */
/*             MESSAGE                                                                  */
/*                 "LINEA CREDITO  : "                                                  */
/*                     (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )                  */
/*                     STRING(dImpLCred,"ZZ,ZZZ,ZZ9.99") SKIP                           */
/*                 "USADO                 : "                                           */
/*                     (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )                  */
/*                     STRING(T-SALDO + F-SALDO,"-Z,ZZZ,ZZ9.99") SKIP                   */
/*                 "CREDITO DISPONIBLE    : "                                           */
/*                     (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " )                  */
/*                     STRING(dImpLCred - (T-SALDO + F-SALDO),"-Z,ZZZ,ZZ9.99") SKIP     */
/*                 "VENCIMIENTO           : " gn-clie.FchVLC                            */
/*                 VIEW-AS ALERT-BOX ERROR.                                             */
/*             APPLY "ENTRY" TO FacCPedi.CodCli.                                        */
/*             RETURN "ADM-ERROR".                                                      */
/*         END.                                                                         */
/*    END.                                                                              */
    /**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
    f-TOT = IF S-CODMON = 1 THEN
        F-TOT ELSE F-TOT * DECI(FaccPedi.Tpocmb:SCREEN-VALUE).
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
    /* RHC 15.12.09 CONTROL DE IMPORTE MINIMO POR COTIZACION */
    DEF VAR pImpMin AS DEC NO-UNDO.
    RUN gn/pMinCotPed (s-CodCia,
                       s-CodDiv,
                       s-CodDoc,
                       OUTPUT pImpMin).
    IF pImpMin > 0 AND f-Tot < pImpMin THEN DO:
        MESSAGE 'El importe mínimo para los pedidos es de S/.' pImpMin
            VIEW-AS ALERT-BOX ERROR.
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
  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  IF LOOKUP(FacCPedi.FlgEst,"P,F,C,A,E,R") > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  S-CODMON = FacCPedi.CodMon.
  S-CODCLI = FacCPedi.CodCli.
  s-Copia-Registro = NO.
  s-NroCot = FacCPedi.NroRef.
  s-adm-new-record = 'NO'.
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

FIND FIRST ITEM-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM-3 THEN RETURN 'OK'.
RUN vta/d-vtacorr.
RETURN 'ADM-ERROR'.

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

{vta/verifica-cliente.i}

/*
DEFINE VAR OK AS LOGICAL NO-UNDO.
DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE F-MRGUTI     AS INTEGER   NO-UNDO.
DEFINE VARIABLE dImpTot      AS DECIMAL   NO-UNDO.

IF LOOKUP(FacCPedi.Flgest, 'G,X,W') > 0 THEN DO:
   OK = TRUE.
   /* Linea de Credito */
   FIND gn-clie WHERE
        gn-clie.CodCia = cl-codcia AND  
        gn-clie.CodCli = FacCPedi.Codcli 
        NO-LOCK NO-ERROR.

    dImpTot = FacCPedi.Imptot.

    IF FacCPedi.CodMon = 1 THEN DO:
        IF gn-clie.MonLC = 2 THEN dImpTot = dImpTot / FacCPedi.TpoCmb.
    END. 
    ELSE DO:
        IF gn-clie.MonLC = 1 THEN dImpTot = dImpTot * FacCPedi.TpoCmb.
    END.

   RUN vta\lincre.r(gn-clie.CodCli,dImpTot,OUTPUT T-SALDO).
      
   IF RETURN-VALUE <> "OK" THEN OK = FALSE.

   IF LOOKUP(FacCPedi.fmapgo,"000") > 0 THEN OK = TRUE.
   /* SOLO CONTADO ANTICIPADO */
   IF LOOKUP(FacCPedi.fmapgo,"002") > 0 THEN OK = FALSE.

   IF NOT OK 
   THEN ASSIGN 
            FacCPedi.Flgest = 'X'
            FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Linea Credito'.
   ELSE ASSIGN 
            FacCPedi.Flgest = 'P'.
             
   /* Condicion Crediticia */
   FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-totdias = gn-convt.totdias.
                
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN 
      IF gn-convt.totdias > F-totdias AND F-totdias > 0 THEN OK = FALSE.
   IF AVAILABLE FacCPedi AND NOT OK THEN
      ASSIGN FacCPedi.Flgest = 'X'
             FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.'.
   ELSE ASSIGN FacCPedi.Flgest = 'P'.          

   FOR EACH FacDPedi OF FacCPedi:
       ASSIGN  FacDPedi.Flgest = FacCPedi.Flgest.   /* <<< OJO <<< */
       RELEASE FacDPedi.
   END.
   IF FacCPedi.FlgEst = 'P' THEN DO:    /* APROBACION AUTOMATICA DEL PEDIDO */
       /* TRACKING */
       RUN vta/pFlujoPedido (s-CodCia,
                             s-CodDiv,
                             'ANP',
                             s-User-Id,
                             Faccpedi.CodDoc,
                             Faccpedi.NroPed,
                             'P',
                             'IO',
                             DATETIME(TODAY, MTIME),
                             DATETIME(TODAY, MTIME)).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   END.
END.      
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

