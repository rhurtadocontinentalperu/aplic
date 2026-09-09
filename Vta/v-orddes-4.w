&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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
{src/bin/_prns.i}

/* Public Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.

DEFINE VARIABLE S-PORIGV LIKE Ccbcdocu.PorIgv.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
/*DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO. */
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias           AS INTEGER NO-UNDO.

FIND First FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
DEFINE VARIABLE sw-tpoped AS LOGICAL NO-UNDO.

DEFINE VAR x-ordcmp AS CHARACTER.

DEFINE VAR dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VAR lEnCampan AS LOGICAL NO-UNDO.

DEFINE BUFFER B-DPedi FOR FacDPedi.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

DEFINE VAR c-items AS INT NO-UNDO.

DEFINE STREAM report.
DEFINE TEMP-TABLE Reporte
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli.

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
FacCPedi.DirCli FacCPedi.Sede FacCPedi.NroRef FacCPedi.CodVen ~
FacCPedi.ordcmp FacCPedi.FmaPgo FacCPedi.CodMon FacCPedi.CodAlm ~
FacCPedi.Glosa FacCPedi.LugEnt FacCPedi.Ubigeo[3] FacCPedi.LugEnt2 ~
FacCPedi.Ubigeo[2] FacCPedi.Atencion FacCPedi.Ubigeo[1] 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-22 BUTTON-10 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.TpoPed ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.fchven FacCPedi.NomCli ~
FacCPedi.RucCli FacCPedi.DirCli FacCPedi.TpoCmb FacCPedi.Sede ~
FacCPedi.NroRef FacCPedi.CodVen FacCPedi.ordcmp FacCPedi.FmaPgo ~
FacCPedi.CodMon FacCPedi.CodAlm FacCPedi.Glosa FacCPedi.LugEnt ~
FacCPedi.Ubigeo[3] FacCPedi.LugEnt2 FacCPedi.Ubigeo[2] FacCPedi.Atencion ~
FacCPedi.Ubigeo[1] 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Situac FILL-IN-sede F-nOMvEN ~
F-CndVta FILL-IN-Almacen F-Departamento F-Provincia F-Distrito 

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
     SIZE 3 BY .81.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE F-Departamento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Distrito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE F-Provincia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Situac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 10.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          FONT 0
     FacCPedi.TpoPed AT ROW 1.27 COL 25 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "G/R Manual", "M":U,
"Normal", ""
          SIZE 21 BY .69
          BGCOLOR 11 FGCOLOR 9 
     F-Estado AT ROW 1.27 COL 45 COLON-ALIGNED NO-LABEL
     F-Situac AT ROW 1.27 COL 60 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.27 COL 83 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.CodCli AT ROW 2.08 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.fchven AT ROW 2.08 COL 83 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.NomCli AT ROW 2.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     FacCPedi.RucCli AT ROW 2.88 COL 83 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.DirCli AT ROW 3.69 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.TpoCmb AT ROW 3.69 COL 83 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Sede AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-sede AT ROW 4.5 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     BUTTON-10 AT ROW 4.5 COL 71
     FacCPedi.NroRef AT ROW 4.5 COL 83 COLON-ALIGNED
          LABEL "No. Pedido"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.CodVen AT ROW 5.31 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-nOMvEN AT ROW 5.31 COL 14 COLON-ALIGNED NO-LABEL
     FacCPedi.ordcmp AT ROW 5.31 COL 83 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
     FacCPedi.FmaPgo AT ROW 6.12 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta."
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-CndVta AT ROW 6.12 COL 14 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 6.12 COL 84.86 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .81
     FacCPedi.CodAlm AT ROW 6.92 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Almacen AT ROW 6.92 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FacCPedi.Glosa AT ROW 7.73 COL 6.28 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 
     FacCPedi.LugEnt AT ROW 8.54 COL 14 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Ubigeo[3] AT ROW 8.54 COL 83 COLON-ALIGNED WIDGET-ID 26
          LABEL "Dpto"
          VIEW-AS FILL-IN 
          SIZE 3 BY .81
          BGCOLOR 11 FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-Departamento AT ROW 8.54 COL 86.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FacCPedi.LugEnt2 AT ROW 9.35 COL 14 COLON-ALIGNED WIDGET-ID 22
          LABEL "2do. Lugar Entrega"
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Ubigeo[2] AT ROW 9.35 COL 83 COLON-ALIGNED WIDGET-ID 30
          LABEL "Prov"
          VIEW-AS FILL-IN 
          SIZE 3 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-Provincia AT ROW 9.35 COL 86.14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FacCPedi.Atencion AT ROW 10.15 COL 14 COLON-ALIGNED WIDGET-ID 18
          LABEL "Contacto"
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FacCPedi.Ubigeo[1] AT ROW 10.15 COL 83 COLON-ALIGNED WIDGET-ID 34
          LABEL "Distrito"
          VIEW-AS FILL-IN 
          SIZE 3 BY .81
          BGCOLOR 11 FGCOLOR 9 
     F-Distrito AT ROW 10.15 COL 86 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 6.12 COL 77 WIDGET-ID 14
     RECT-22 AT ROW 1 COL 1 WIDGET-ID 16
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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 11.08
         WIDTH              = 107.43.
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
   EXP-LABEL                                                            */
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
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
  IF output-var-2 <> '' 
      THEN ASSIGN 
            /*FacCPedi.DirCli:SCREEN-VALUE = output-var-2*/
            FILL-IN-sede:SCREEN-VALUE = output-var-2
            FacCPedi.Sede:SCREEN-VALUE = output-var-3.
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
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' THEN DO:
   FOR EACH FacDPedi OF FacCPedi NO-LOCK:
       CREATE PEDI.
       BUFFER-COPY FacDPedi TO PEDI.
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
  Notes:       El PEDIDO siempre se cierra
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH facdPedi OF faccPedi NO-LOCK:
          FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
              AND B-DPedi.CodDoc = "PED"           
              AND B-DPedi.NroPed = FacCPedi.NroRef 
              AND B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF AMBIGUOUS B-DPEDI THEN DO:
              MESSAGE 'El producto' facdpedi.codmat 'está duplicado' SKIP
                  'revise su pedido' VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
              B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * FacDPedi.CanPed
              B-DPEDI.FlgEst = (IF x-Tipo = +1 THEN "C" ELSE "P").
          RELEASE B-DPedi.
      END.
      FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
          AND B-CPedi.CodDiv = S-CODDIV 
          AND B-CPedi.CodDoc = "PED"    
          AND B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
      IF x-Tipo = -1 THEN B-CPedi.FlgEst = "P".
      IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".
      RELEASE B-CPedi.
  END.

END PROCEDURE.

/*
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH facdPedi OF faccPedi NO-LOCK:
          FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
              AND B-DPedi.CodDoc = "PED"           
              AND B-DPedi.NroPed = FacCPedi.NroRef 
              AND B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
              B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed * X-Tipo)
              B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
          RELEASE B-DPedi.
      END.
      FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
          AND B-CPedi.CodDiv = S-CODDIV 
          AND B-CPedi.CodDoc = "PED"    
          AND B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
      IF x-Tipo = -1 THEN B-CPedi.FlgEst = "P".
      IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".
      RELEASE B-CPedi.
  END.
*/

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
   RUN Actualiza-Item.
   FIND B-CPedi WHERE 
        B-CPedi.CodCia = S-CODCIA  AND  
        B-CPedi.CodDiv = S-CODDIV  AND  
        B-CPedi.CodDoc = "PED"     AND  
        B-CPedi.NroPed = s-NroCot 
        NO-LOCK NO-ERROR.
   ASSIGN
       F-NomVen = ""
       F-CndVta = ""
       fill-in-Almacen = ''.

   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA  
       AND gn-ven.CodVen = B-CPedi.CodVen 
       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
   FIND gn-convt WHERE gn-convt.Codig = B-CPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
   FIND Almacen WHERE Almacen.codcia = s-codcia
       AND Almacen.codalm = B-CPEDI.codalm
       NO-LOCK NO-ERROR.
   IF AVAILABLE Almacen THEN fill-in-Almacen = Almacen.Descripcion.
   
   DISPLAY 
       B-CPEDI.CodCli @ Faccpedi.codcli
       B-CPEDI.NomCli @ Faccpedi.nomcli
       B-CPEDI.DirCli @ Faccpedi.dircli
       B-CPEDI.RucCli @ Faccpedi.ruccli
       S-NROCOT       @ FacCPedi.nroref
       B-CPedi.CodVen @ FacCPedi.CodVen 
       B-CPedi.FmaPgo @ FacCPedi.FmaPgo 
       B-CPEDI.CodAlm @ Faccpedi.codalm
       B-CPedi.Ordcmp @ FaccPedi.Ordcmp
       B-CPedi.FchVen @ FaccPedi.FchVen
       B-CPedi.Glosa  @ FaccPedi.Glosa
       B-CPEDI.Sede   @ Faccpedi.Sede
       B-CPEDI.LugEnt @ Faccpedi.LugEnt
       f-NomVen
       f-CndVta
       fill-in-Almacen.
   FacCPedi.CodMon:SCREEN-VALUE = STRING(B-CPEDI.CodMon).

   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
       AND gn-clie.CodCli = B-CPEDI.CodCli NO-LOCK NO-ERROR.

   /* DETALLES */
   FOR EACH FacDPedi OF B-CPEDI NO-LOCK BY FacDPedi.NroItm:
       CREATE PEDI.
       BUFFER-COPY Facdpedi TO PEDI
         ASSIGN 
             PEDI.CanPick = facdpedi.CanPed
             PEDI.Pesmat  = facdpedi.CanPed
             PEDI.CanAte  = 0.       /* OJO */
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
       IF PEDI.AftIgv THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna_datos V-table-Win 
PROCEDURE Asigna_datos :
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
       MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
    END.
    IF FacCPedi.FlgEst <> "A" THEN RUN vta\w-agtrans(ROWID(FacCPedi)).
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

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FOR EACH FacdPedi OF faccPedi:
          DELETE FacDPedi.
      END.
  END.

END PROCEDURE.

/*
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FOR EACH facdPedi OF faccPedi:
          FIND B-DPedi WHERE
               B-DPedi.CodCia = FaccPedi.CodCia AND
               B-DPedi.CodDoc = "PED" AND
               B-DPedi.NroPed = Faccpedi.NroRef AND
               B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
          B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed.
          RELEASE B-DPedi.
          DELETE FacDPedi.
      END.
  END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFamilia AS CHAR.

DEF VAR xFamilia AS CHAR.
DEFINE VARIABLE ped            AS CHARACTER.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.

CASE cFamilia:
    WHEN '+' THEN DO:
        xFamilia = '010'.
    END.
    WHEN '-' THEN DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
            AND Almtfami.codfam <> '010':
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
    OTHERWISE DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
END CASE.

DEFINE BUFFER b-CPedi FOR FacCPedi.

DEFINE VAR conta AS INTEGER NO-UNDO INIT 0.
FOR EACH reporte.
    DELETE Reporte.
END.

ped = FacCPedi.NroPed.
FOR EACH b-CPedi NO-LOCK WHERE b-CPedi.CodCia = s-codcia 
    AND b-CPedi.CodDiv =  s-CodDiv                     
    AND b-CPedi.CodDoc =  s-CodDoc                     
    AND b-CPedi.NroPed =  PED:                         
    FOR EACH FacDPedi OF b-CPedi NO-LOCK,
        FIRST Almmmatg OF Facdpedi NO-LOCK WHERE LOOKUP(Almmmatg.codfam, xFamilia) > 0,
        FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = b-CPedi.CodCia
        AND Almmmate.CodAlm = b-CPedi.CodAlm
        AND Almmmate.CodMat = FacDPedi.CodMat
        BREAK BY Almmmate.CodUbi BY FacDPedi.CodMat:
        conta = conta + 1.
        CREATE Reporte.
        ASSIGN 
            Reporte.NroPed   = b-CPedi.NroPed
            Reporte.CodMat   = FacDPedi.CodMat
            Reporte.DesMat   = Almmmatg.DesMat
            Reporte.DesMar   = Almmmatg.DesMar
            Reporte.UndBas   = FacDPedi.UndVta
            Reporte.CanPed   = FacDPedi.CanPed
            Reporte.CodUbi   = Almmmate.CodUbi
            Reporte.X-TRANS  = b-CPedi.Libre_c01
            Reporte.X-DIREC  = b-CPedi.Libre_c02
            Reporte.X-LUGAR  = b-CPedi.Libre_c03
            Reporte.X-CONTC  = b-CPedi.Libre_c04
            Reporte.X-HORA   = b-CPedi.Libre_c05
            Reporte.X-FECHA  = b-CPedi.Libre_f01
            Reporte.X-OBSER  = b-CPedi.Observa
            Reporte.X-Glosa  = b-CPedi.Glosa
            Reporte.X-nomcli = b-CPedi.codcli
            Reporte.X-NomCli = b-CPedi.NomCli.
    END.
END.
npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
IF npage < 0 THEN npage = INTEGER(conta / c-items).
ELSE npage = INTEGER(conta / c-items) + 1. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 V-table-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".
DEF        VAR I-NroItm AS INTEGER.
DEF VAR X-Lugent   AS CHAR NO-UNDO.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
              AND  Almacen.CodAlm = FacCPedi.codalm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN              
   ASSIGN 
        W-DIRALM = Almacen.DirAlm
        W-TLFALM = Almacen.TelAlm. 

DEFINE FRAME F-FtrOD
    HEADER
    "-----------------------------------------------------------------------------------------------" SKIP
    'PTO.PARTIDA : '  AT 2 W-DIRALM FORMAT 'X(60)' SKIP
    'PTO.LLEGADA : ' AT 2 FacCPedi.LugEnt FORMAT 'X(60)' SKIP
    x-lugent   AT 2 FORMAT 'X(60)' SKIP
    S-USER-ID  AT 2 STRING(TIME,"HH:MM:SS") AT 30 SKIP
    '    IMPORTE:' AT 2 Faccpedi.ImpTot FORMAT '(ZZZ,ZZZ,ZZ9.99)' SKIP
    'TOTAL ITEMS:' AT 2 c-items SKIP
    "-----------------------------------------------------------------------------------------------" 

    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-HdrOD
    HEADER 
    {&PRN2} + {&PRN7A} + {&PRN6A} + 'ORDEN DE DESPACHO' + {&PRN6B} + {&PRN7B} + {&PRN2} AT 20 FORMAT "X(30)" 
    {&PRN2} + {&PRN7A} + {&PRN6A}  + 'No : ' AT 55 FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "XXX-XXXXXX" SKIP(1)

    "FECHA     : " FacCPedi.Fchped  
    "PEDIDO    : " AT 70 FacCPedi.NroRef FORMAT 'XXX-XXXXXX' SKIP
    "CLIENTE   : " FacCPedi.nomcli FORMAT "x(45)" SKIP
    "O/COMPRA  : " AT 70 FacCPedi.OrdCmp SKIP
    "DIRECCION : " FacCPedi.Dircli FORMAT "x(60)" SKIP 
    "RUC       : " FacCPedi.Ruccli FORMAT "x(11)" 
    "FCH VENC. : " AT 70 FacCPedi.FchVen AT 85 SKIP
    "ATENCION  : " FacCPedi.Atencion FORMAT "x(30)" 
    "HORA      : " AT 70 FacCPedi.Hora AT 85 FORMAT "x(10)"  SKIP
    "GLOSA     : " FaccPedi.Glosa VIEW-AS TEXT FORMAT "X(50)"
    "USUARIO   : " AT 70 FacCPedi.Usuario AT 85 FORMAT "x(10)" SKIP
    "-----------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   D E S C R I P C I O N                          MARCA       UND   CANTIDAD   ZONA " SKIP
    "-----------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-DetaOD
    I-NroItm FORMAT ">>9"
    Reporte.codmat FORMAT "X(6)"
    Reporte.desmat FORMAT "X(50)"
    Reporte.Desmar FORMAT "x(10)"
    Reporte.undbas  FORMAT "X(4)"
    Reporte.CanPed  FORMAT ">>>,>>9.99"
    Reporte.codubi FORMAT "x(6)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

I-NroItm = 0.
FOR EACH Reporte BREAK BY Reporte.NroPed BY Reporte.CodUbi:
    I-NroItm = I-NroItm + 1.
     VIEW STREAM Report FRAME F-HdrOD.
     VIEW STREAM Report FRAME F-FtrOD. 
     DISPLAY STREAM Report 
            I-NroItm
            Reporte.CodMat 
            Reporte.DesMat
            Reporte.DesMar
            Reporte.UndBas
            Reporte.CanPed
            Reporte.CodUbi
            WITH FRAME f-DetaOD.
     IF LAST-OF(Reporte.NroPed) THEN DO:
            PAGE STREAM Report.
            HIDE STREAM REPORT FRAME F-FtrOD.
     END.
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
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH PEDI NO-LOCK WHERE PEDI.CodMat <> "" BY PEDI.NroItm: 
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
            FacDPedi.NroItm  = I-NITEM
            FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */
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

{vta/graba-totales.i}

/*
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
    ASSIGN
        F-Igv = F-Igv + Facdpedi.ImpIgv
        F-Isc = F-Isc + Facdpedi.ImpIsc
        FacCPedi.ImpTot = FacCPedi.ImpTot + Facdpedi.ImpLin.
    IF NOT Facdpedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + Facdpedi.ImpLin.
    IF Facdpedi.AftIgv = YES
    THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(Facdpedi.ImpDto / (1 + FacCPedi.PorIgv / 100), 2).
    ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + Facdpedi.ImpDto.
END.
ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
/* RHC 22.12.06 */
IF FacCPedi.PorDto > 0 THEN DO:
    FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2).
    FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2).
    FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2).
    FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2).
    FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
END.  
FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir1 V-table-Win 
PROCEDURE Imprimir1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
    IF x-Ok = NO THEN RETURN.
    
    /* RHC 04.12.09 VAMOS A HACER 2 IMPRESIONES:
    Una con la familia 010 y otra con las demás familias
    */
    RUN Carga-Temporal ('+').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
    END.
    RUN Carga-Temporal ('-').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
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
/*   FIND Faccorre WHERE Faccorre.codcia = s-codcia */
/*       AND Faccorre.coddoc = s-coddoc             */
/*       AND Faccorre.coddiv = s-coddiv             */
/*       AND Faccorre.flgest = YES                  */
/*       NO-LOCK NO-ERROR.                          */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                 AND  FacCorre.CodDoc = S-CODDOC 
                 AND  FacCorre.CodDiv = S-CODDIV
                 AND  FacCorre.CodAlm = S-CodAlm 
                 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
      MESSAGE 'NO está configurado el control de correlativos para la divisió' s-coddiv SKIP
          'y el almacén' s-codalm
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  s-FechaI = DATETIME(TODAY, MTIME).
  S-NroCot = "".
  input-var-1 = "PED".
  input-var-2 = "".
  RUN lkup\C-Pedido.r("Pedidos Pendientes").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  ASSIGN
      S-NroCot = SUBSTRING(output-var-2,4,9)
      s-PorIgv = FacCfgGn.PorIgv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      RUN Asigna-Pedido.
      DISPLAY 
          STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999') @ Faccpedi.nroped
          TODAY @ FacCPedi.FchPed
          TODAY + 7 @ FacCPedi.FchVen
          FacCfgGn.Tpocmb[1] @ FacCPedi.TpoCmb.
      FAcCPedi.TpoPEd:SCREEN-VALUE = "".
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
  FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
      FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
          AND B-CPEDI.coddoc = 'PED'
          AND B-CPEDI.nroped = Faccpedi.nroref:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN DO:
          MESSAGE 'NO se encontró el Pedido' Faccpedi.nroref:SCREEN-VALUE
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV AND
           Faccorre.Codalm = S-CodAlm AND
           FacCorre.FlgEst = YES
           EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccorre THEN UNDO, RETURN 'ADM-ERROR'.
      BUFFER-COPY B-CPEDI 
          EXCEPT 
            B-CPEDI.TpoPed
            B-CPEDI.FchVen
            B-CPEDI.FchVen
            B-CPEDI.DirCli
            B-CPEDI.Sede
            B-CPEDI.NroRef
            B-CPEDI.FlgEst
            B-CPEDI.FlgSit
            B-CPEDI.Glosa
            B-CPEDI.LugEnt
            B-CPEDI.LugEnt2
            B-CPEDI.Atencion
            B-CPEDI.Ubigeo
          TO FacCPedi
          ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.CodRef = "PED"
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCorre.Correlativo = FacCorre.Correlativo + 1
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.PorIgv = s-PorIgv.
      /* División Destino */
      FIND Almacen WHERE Almacen.codcia = Faccpedi.codcia
          AND Almacen.codalm = Faccpedi.codalm
          NO-LOCK.
      ASSIGN
          FacCPedi.DivDes = Almacen.CodDiv.
      /* TRACKING */
      s-FechaT = DATETIME(TODAY, MTIME).
  END.
  ELSE DO:
      RUN Actualiza-Pedido (-1).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
    FacCPedi.Usuario = S-USER-ID.
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  RUN Actualiza-Pedido (+1).
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
/*     IF FacCPedi.FlgSit = "P" THEN DO:                                 */
/*         MESSAGE "La orden ya está con PICKING" SKIP                   */
/*             "Tiene que usar la opción: CIERRE DE ORDENES DE DESPACHO" */
/*             VIEW-AS ALERT-BOX WARNING.                                */
/*         RETURN "ADM-ERROR".                                           */
/*      END.                                                             */
    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       RUN Actualiza-Pedido (-1).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       RUN Borra-Pedido.
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
       /* TRACKING */
      FIND Almacen OF Faccpedi NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
       ASSIGN 
           B-CPedi.FlgEst = "A"
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
        FacCPedi.FchPed:SENSITIVE = NO
        FacCPedi.CodCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO
        FacCPedi.Sede:SENSITIVE   = NO
        FacCPedi.OrdCmp:SENSITIVE = NO
        FacCPedi.NroPed:SENSITIVE = NO
        FacCPedi.NroRef:SENSITIVE = NO
        FacCPedi.CodVen:SENSITIVE = NO
        FacCPedi.FmaPgo:SENSITIVE = NO
        FacCPedi.CodAlm:SENSITIVE = NO
        FacCPedi.CodMon:SENSITIVE = NO
        FacCPedi.TpoPed:SENSITIVE = NO
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
  IF NOT AVAILABLE Faccpedi THEN RETURN.
  IF Faccpedi.flgest = 'A'  THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-ImpOD.r(ROWID(FacCPedi)).*/

  DEFINE VARIABLE cMode AS CHARACTER NO-UNDO.

  RUN vta/d-imp-od (OUTPUT cMode).
  
  IF cMode = 'ADM-ERROR' THEN RETURN NO-APPLY.

  c-items = 0.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      c-items = c-items + 1.
  END.

  CASE cMode:
      WHEN '1' THEN RUN vta/R-ImpOD (ROWID(FacCPedi)).
      WHEN '2' THEN RUN Imprimir1.
      WHEN '3' THEN DO: 
            RUN vta/R-ImpOD (ROWID(FacCPedi)).
            RUN Imprimir1.
      END.
  END CASE.


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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
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

/*    IF FacCPedi.Ubigeo[3]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabDepto WHERE TabDepto.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE NO-LOCK NO-ERROR. */
/*        IF NOT AVAILABLE TabDepto THEN DO:                                                        */
/*            MESSAGE "DEPARTAMENTO no existe" VIEW-AS ALERT-BOX ERROR.                             */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[3].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */
/*    IF FacCPedi.Ubigeo[2]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabProvi WHERE TabProvi.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE                   */
/*            AND TabProvi.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE NO-LOCK NO-ERROR.             */
/*        IF NOT AVAILABLE TabProvi THEN DO:                                                        */
/*            MESSAGE "PROVINCIA no existe" VIEW-AS ALERT-BOX ERROR.                                */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[2].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */
/*    IF FacCPedi.Ubigeo[1]:SCREEN-VALUE <> '' THEN DO:                                             */
/*        FIND TabDistr WHERE TabDistr.CodDepto = FacCPedi.Ubigeo[3]:SCREEN-VALUE                   */
/*            AND TabDistr.CodProvi = FacCPedi.Ubigeo[2]:SCREEN-VALUE                               */
/*            AND TabDistr.CodDistr = FacCPedi.Ubigeo[1]:SCREEN-VALUE NO-LOCK NO-ERROR.             */
/*        IF NOT AVAILABLE TabDistr THEN DO:                                                        */
/*            MESSAGE "DISTRITO no existe" VIEW-AS ALERT-BOX ERROR.                                 */
/*            APPLY 'entry':U TO FacCPedi.Ubigeo[1].                                                */
/*            RETURN "ADM-ERROR".                                                                   */
/*        END.                                                                                      */
/*    END.                                                                                          */

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
  IF NOT AVAILABLE FacCPedi                 THEN RETURN "ADM-ERROR".
  IF LOOKUP(FacCPedi.FlgEst,"X,C,A") > 0    THEN RETURN "ADM-ERROR".
  IF LOOKUP(FacCPedi.FlgSit,"P") > 0        THEN RETURN "ADM-ERROR".
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

