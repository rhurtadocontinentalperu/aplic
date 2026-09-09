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
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE C-clfCli   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE BUFFER B-CPedi FOR FacCPedi.
DEFINE BUFFER B-DPedi FOR FacDPedi.
DEFINE BUFFER B-Pedi FOR PEDI.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias           AS INTEGER NO-UNDO.
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.

FIND First FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE F-Coddoc       AS CHAR NO-UNDO.
DEFINE VAR F-Orddes  AS CHAR NO-UNDO.
DEFINE VAR F-Fchent  AS DATE NO-UNDO.
DEFINE VAR F-Codtra  AS CHAR NO-UNDO.
DEFINE VAR F-LugEnt  AS CHAR NO-UNDO.
DEFINE VAR F-LugEnt2 AS CHAR NO-UNDO.
DEFINE VAR F-Flgsit  AS CHAR NO-UNDO.

DEFINE VAR F-Observa AS CHAR NO-UNDO.

DEFINE VAR SW-OK AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-MARGEN AS DECIMAL NO-UNDO.
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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.fchven ~
FacCPedi.ordcmp FacCPedi.Glosa FacCPedi.CodMon 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-20 T-Especial 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.TpoLic ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.DirCli ~
FacCPedi.FchPed FacCPedi.RucCli FacCPedi.fchven FacCPedi.ordcmp ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.Glosa FacCPedi.CodMon 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS T-Especial F-Estado F-nOMvEN C-TpoVta ~
F-CndVta 

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
DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "Contado" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Factura","Boleta" 
     DROP-DOWN-LIST
     SIZE 11.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.38.

DEFINE VARIABLE T-Especial AS LOGICAL INITIAL no 
     LABEL "Venta Especial" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .65 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.15 COL 9 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
          FONT 0
     T-Especial AT ROW 1.19 COL 29
     FacCPedi.TpoLic AT ROW 1.19 COL 46.86
          LABEL "Licitación"
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .65
     F-Estado AT ROW 1.19 COL 71.29 COLON-ALIGNED NO-LABEL
     FacCPedi.CodCli AT ROW 1.85 COL 9 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FacCPedi.NomCli AT ROW 1.85 COL 21.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39.72 BY .69
     FacCPedi.TpoCmb AT ROW 1.88 COL 73 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.DirCli AT ROW 2.54 COL 9 COLON-ALIGNED
          LABEL "Dirección" FORMAT "x(70)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     FacCPedi.FchPed AT ROW 2.54 COL 73 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.RucCli AT ROW 3.19 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FacCPedi.fchven AT ROW 3.19 COL 73 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.ordcmp AT ROW 3.88 COL 73 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     FacCPedi.CodVen AT ROW 3.92 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     F-nOMvEN AT ROW 3.96 COL 18 COLON-ALIGNED NO-LABEL
     C-TpoVta AT ROW 4.54 COL 73 COLON-ALIGNED
     FacCPedi.FmaPgo AT ROW 4.58 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     F-CndVta AT ROW 4.58 COL 18 COLON-ALIGNED NO-LABEL
     FacCPedi.Glosa AT ROW 5.46 COL 6.57
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     FacCPedi.CodMon AT ROW 5.46 COL 75 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .62
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 5.38 COL 67
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
         HEIGHT             = 5.38
         WIDTH              = 88.
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

/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                 AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
     S-CODCLI = SELF:SCREEN-VALUE.
     RUN VTA\D-RegCli.R (INPUT-OUTPUT S-CODCLI).
     IF S-CODCLI = "" THEN RETURN NO-APPLY.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                   AND  gn-clie.CodCli = S-CODCLI
                  NO-LOCK NO-ERROR.
   END.
  IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Desactivado" skip
              "Consulte con el Jefe de Creditos"
              VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
      END.

   IF gn-clie.FlgSit = "C" THEN DO:
      MESSAGE "Cliente esta Cesado"
      "Consulte con el Jefe de Creditos"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   
   DO WITH FRAME {&FRAME-NAME}:
        IF Faccpedi.NomCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.NomCli @ Faccpedi.NomCli.
        IF Faccpedi.RucCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.Ruc    @ Faccpedi.RucCli.
        IF Faccpedi.DirCli:SCREEN-VALUE = "" THEN DO:
            DISPLAY gn-clie.DirCli @ Faccpedi.DirCli.
            /* RHC agregamos el distrito */
            FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                AND Tabdistr.Codprovi = gn-clie.codprov 
                AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
            IF AVAILABLE Tabdistr 
            THEN Faccpedi.DirCli:SCREEN-VALUE = TRIM(Faccpedi.DirCli:SCREEN-VALUE) + ' - ' +
                                                TabDistr.NomDistr.
        END.            
        IF FacCPedi.CodVen:SCREEN-VALUE = '' THEN DISPLAY gn-clie.CodVen @ FacCPedi.CodVen.
        IF FAcCPedi.FmaPgo:SCREEN-VALUE = '' THEN DISPLAY gn-clie.CndVta @ FacCPedi.FmaPgo.
    
        S-CNDVTA = gn-clie.CndVta.
        
        S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE.
        
        /* Ubica la Condicion Venta */
        FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
             F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
             f-totdias = gn-convt.totdias.
        END.
        ELSE F-CndVta:SCREEN-VALUE = "".
    
       RUN Calcula-importes.
    
        IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
            Faccpedi.NomCli:SENSITIVE = NO.
            Faccpedi.DirCli:SENSITIVE = NO.
            Faccpedi.RucCli:SENSITIVE = NO.
        END.
        ELSE DO: 
           Faccpedi.NomCli:SENSITIVE = NO.
           Faccpedi.DirCli:SENSITIVE = NO.
           Faccpedi.RucCli:SENSITIVE = NO. 
        END.
   END.
   
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
  F-NomVen = "".
  IF FacCPedi.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
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
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:

    S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.

    IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
        F-CndVta:SCREEN-VALUE = "".
        RETURN.
    END.

    S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.

    IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE,"000,001,002") = 0 AND
        gn-clie.FlgSit = "I" THEN DO:
        MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN NO-APPLY.
    END.

    IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE,"000,001,002") = 0 THEN DO:
        dImpLCred = 0.
        lEnCampan = FALSE.
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
        gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE
            "Condición de Venta no Configurado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.FacCPedi.FmaPgo.
        RETURN NO-APPLY.
    END.
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    FacCPedi.fchven:SCREEN-VALUE = STRING(TODAY + gn-convt.totdias).
    IF gn-convt.totdias > F-totdias THEN DO:
        MESSAGE
            " Condición Crédito es Mayor al Asignado "
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF gn-convt.totdias > 0 THEN DO:
        RUN Calcula-importes.
        IF SW-OK THEN DO:
            MESSAGE
                "TIENE DOCUMENTOS VENCIDOS" 
                VIEW-AS ALERT-BOX WARNING.
        END.
        T-SALDO = 0.
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            RUN vta\lincre.r(gn-clie.CodCli,0,OUTPUT T-SALDO).
            IF RETURN-VALUE <> "OK" THEN DO:
                MESSAGE
                    "Linea de Crédito agotada. " SKIP(1)
                    "Verifique su Cta.Cte. o   " SKIP
                    "Pedidos Crédito Pendientes" SKIP
                    VIEW-AS ALERT-BOX WARNING.
                RETURN NO-APPLY.
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-Especial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-Especial V-table-Win
ON VALUE-CHANGED OF T-Especial IN FRAME F-Main /* Venta Especial */
DO:
  ASSIGN T-Especial.
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
  DEFINE BUFFER B-DPedi FOR FacDPedi.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH facdPedi OF faccPedi NO-LOCK :
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = faccPedi.CodCia AND  
               B-DPedi.CodDoc = "COT"           AND  
               B-DPedi.NroPed = S-NroCot        AND  
               B-DPedi.CodMat = FacDPedi.CodMat 
               EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-DPedi THEN B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed.
          RELEASE B-DPedi.
      END.
      FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
          AND  FacDPedi.CodDoc = "COT"    
          AND  FacDPedi.NroPed = S-NroCot:
          IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
             I-NRO = 1.
             LEAVE.
          END.
      END.
      IF I-NRO = 0 THEN DO:
         FIND B-CPedi WHERE 
              B-CPedi.CodCia = S-CODCIA AND  
              B-CPedi.CodDiv = S-CODDIV AND  
              B-CPedi.CodDoc = "COT"    AND  
              B-CPedi.NroPed = S-NroCot 
              EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = "C".
         RELEASE B-CPedi.
      END.
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

IF output-var-1 <> ? THEN 
    FIND faccPedi WHERE ROWID(faccPedi) = output-var-1 NO-LOCK NO-ERROR.

FOR EACH PEDI:
    DELETE PEDI.
END.
IF NOT L-CREA THEN DO:
   FOR EACH facdPedi OF faccPedi NO-LOCK:
       CREATE PEDI.
        BUFFER-COPY facdpedi TO PEDI
            ASSIGN 
                PEDI.CanAte = (IF s-copia-registro = YES THEN 0 ELSE FacDPedi.CanAte).
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
DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-OK     AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:  
   IF NOT FacCPedi.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
   FIND FIRST PEDI NO-LOCK NO-ERROR.
   IF AVAILABLE PEDI THEN RETURN "ADM-ERROR".
   S-NroCot = "".
   input-var-1 = "COT".
   input-var-2 = FacCPedi.CodCli:SCREEN-VALUE.
   input-var-3 = ''.
   RUN lkup\C-Pedidot.r("Cotizaciones Vigentes").
   IF output-var-1 = ? THEN RETURN "ADM-ERROR".
   RUN Actualiza-Item.
   
   S-NroCot = SUBSTRING(output-var-2,4,9).
   FIND B-CPedi WHERE 
        B-CPedi.CodCia = S-CODCIA AND  
        B-CPedi.CodDiv = S-CODDIV AND  
        B-CPedi.CodDoc = "COT"    AND  
        B-CPedi.NroPed = s-NroCot 
        NO-LOCK NO-ERROR.
   F-NomVen = "".
   F-CndVta = "".
   S-CODALM = B-CPedi.Codalm.
   /**************************************************/
   IF gn-clie.CodCli = FacCfgGn.CliVar THEN DO:
   
     FacCPedi.CodCli:SCREEN-VALUE = B-CPedi.codcli.
     FacCPedi.nomCli:SCREEN-VALUE = B-CPedi.nomcli.
     FacCPedi.dirCli:SCREEN-VALUE = B-CPedi.dircli.
     FacCPedi.ruc:SCREEN-VALUE = B-CPedi.ruc.
     FacCPedi.glosa:SCREEN-VALUE = B-CPedi.glosa.
   End.
   
   
   /**************************************************/
   
   FIND gn-ven WHERE 
        gn-ven.CodCia = S-CODCIA AND  
        gn-ven.CodVen = B-CPedi.CodVen 
        NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
   FIND gn-convt WHERE gn-convt.Codig = B-CPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
   
   DISPLAY B-CPedi.FmaPgo @ FacCPedi.FmaPgo
           B-CPedi.CodVen @ FaccPedi.CodVen
           B-CPedi.ordcmp @ FacCPedi.ordcmp
           B-CPedi.FchVen @ FacCPedi.FchVen
           F-NomVen
           F-CndVta.
           
   C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(B-CPedi.TipVta),C-TpoVta:LIST-ITEMS).
   FaccPedi.CodMon:SCREEN-VALUE = STRING(B-CPedi.CodMon).
   s-CodMon = B-CPEDI.CodMon.       /* >>> OJO <<< */

   /* DETALLES */
   FOR EACH FacDPedi NO-LOCK WHERE 
            FacDPedi.CodCia = S-CODCIA AND  
            FacDPedi.CodDoc = "COT"    AND  
            FacDPedi.NroPed = S-NroCot 
           /* (FacDPedi.CanPed - FacDPedi.CanAte) > 0 */:
       F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
       IF F-CANPED > 0 THEN DO:

/*ML01* Inicio de bloque */
            FOR FIRST supmmatg
                FIELDS (supmmatg.codcia supmmatg.codcli supmmatg.codmat supmmatg.Libre_d01)
                WHERE supmmatg.codcia = FacCPedi.CodCia
                AND supmmatg.codcli = FacCPedi.CodCli
                AND supmmatg.codmat = FacDPedi.codmat
                NO-LOCK:
            END.
            IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
                F-CANPED = (TRUNCATE((FacDPedi.CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
            END.
/*ML01* Inicio de bloque */

          CREATE PEDI.
          RAW-TRANSFER FacDPedi TO PEDI.
          ASSIGN PEDI.CodCia = facdPedi.CodCia 
                 PEDI.codmat = facdPedi.codmat 
                 PEDI.Factor = facdPedi.Factor 
                 PEDI.CanPed = F-CANPED
                 PEDI.CanAte = 0
                 PEDI.NroItm = facdPedi.NroItm 
                 PEDI.PorDto = facdPedi.PorDto 
                 PEDI.PreBas = FacdPedi.PreBas 
                 PEDI.PreUni = facdPedi.PreUni 
                 PEDI.UndVta = facdPedi.UndVta
                 PEDI.ALMDES = S-CODALM
                 PEDI.AftIgv = FacdPedi.AftIgv 
                 PEDI.AftIsc = FacdPedi.AftIsc 
                 PEDI.ImpIgv = FacdPedi.ImpIgv 
                 PEDI.ImpIsc = FacdPedi.ImpIsc 
                 PEDI.ImpDto = facdPedi.ImpDto 
                 PEDI.ImpLin = facdPedi.ImpLin.
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
            FIND Almmmatg WHERE Almmmatg.CodCia = PEDI.CodCia 
                            AND  Almmmatg.codmat = PEDI.codmat 
                           NO-LOCK NO-ERROR.
            PEDI.ImpDto = ROUND( PEDI.PreBas * (PEDI.PorDto / 100) * PEDI.CanPed , 2 ).
            /* RHC 22.06.06 */
            PEDI.ImpDto = PEDI.ImpDto + ROUND( PEDI.PreBas * PEDI.CanPed * (1 - PEDI.PorDto / 100) * (PEDI.Por_Dsctos[1] / 100),4 ).
            /* ************ */
            PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ).
            IF PEDI.AftIsc THEN 
                PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
            IF PEDI.AftIgv THEN  
                PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
          END.
       END.
   END.
   FacCPedi.CodCli:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Texto V-table-Win 
PROCEDURE Asigna-Texto :
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
  
  SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Archivo texto (.txt)' '*.txt'
  RETURN-TO-START-DIR
  TITLE 'Selecciona al archivo texto'
  MUST-EXIST
  USE-FILENAME
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.

  RUN Actualiza-Item.
  ASSIGN
    FaccPedi.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1'.
    
  INPUT FROM VALUE(x-Archivo).
  TEXTO:
  REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' 
    THEN ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES
    THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            IF NUM-ENTRIES(x-Linea) = 6
            THEN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999').
            ELSE x-CodMat = ENTRY(3,x-Linea).
        END.
        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = x-codmat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg
            THEN DO:
                FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                    AND almmmatg.codbrr = x-codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
            END.
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            IF NOT AVAILABLE Almmmatg
            THEN DO:
                MESSAGE "El Item" x-NroItm "no esta registrado en el catalogo" SKIP
                        "Codigo:" x-codmat
                        VIEW-AS ALERT-BOX ERROR.
                NEXT TEXTO.
            END.
            CREATE PEDI.
            ASSIGN 
                PEDI.CodCia = s-codcia
                PEDI.codmat = x-CodMat
                PEDI.Factor = 1 
                PEDI.CanPed = x-CanPed
                PEDI.NroItm = x-NroItm 
                PEDI.PreUni = (x-ImpLin / x-CanPed) 
                PEDI.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                PEDI.ALMDES = S-CODALM
                PEDI.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO)
                PEDI.ImpIgv = x-ImpIgv 
                PEDI.ImpLin = x-ImpLin.
        END.
    END.
  END.
  INPUT CLOSE.
  ASSIGN
    FacCPedi.CodCli:SENSITIVE = NO.
  
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
    AND  FacDPedi.nroped = FacCPedi.nroped 
    ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    DELETE FacDPedi.     
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-importes V-table-Win 
PROCEDURE Calcula-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-DIAS   AS INTEGER NO-UNDO.

DEFINE VAR w-cambio AS INTEGER NO-UNDO.

DEFINE VAR F-lincre AS DECIMAL.
DEFINE VAR F-creusa AS DECIMAL.
DEFINE VAR F-credis AS DECIMAL.
DEFINE VAR F-TotDol AS DECIMAL.
DEFINE VAR F-TotSol AS DECIMAL.

DEFINE VAR F-TpoVSo AS DECIMAL.
DEFINE VAR F-TVenSo AS DECIMAL.
DEFINE VAR F-TotS0  AS DECIMAL.

DEFINE VAR r-TpoDoc AS LOGICAL INITIAL TRUE.

DEFINE  VAR F-FlgEst AS CHAR NO-UNDO.
F-Flgest = 'P'.
DEFINE  VAR S-DOCUMEN AS CHAR.

/*ASSIGN F-TpoVDo = 0 
 *        F-TvenDo = 0 
 *        F-TotD0  = 0 
 *        F-TotD15 = 0 
 *        F-TotD30 = 0 
 *        F-TotD45 = 0 
 *        F-TotD60 = 0 
 *        F-TotS15 = 0
 *        F-TotS30 = 0 
 *        F-TotS45 = 0
 *        F-TotS60 = 0*/

ASSIGN F-CreUsa = 0
       F-CreDis = 0
       F-TotDol = 0 
       F-TotSol = 0
       F-TpoVSo = 0 
       F-TVenSo = 0 
       F-TotS0  = 0.
     
FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
      IF AVAILABLE FacCfgGn THEN 
            w-cambio = FacCfgGn.Tpocmb[1].
      ELSE  w-cambio = 0.     

SW-OK = FALSE.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia
                     AND  CcbCDocu.CodCli = gn-clie.CodCli
                     AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0 /* BEGINS f-CodDoc */
                     AND  CcbCDocu.FlgEst BEGINS f-FlgEst 
                     AND  CcbCDocu.FchVto <= TODAY
                    NO-LOCK NO-ERROR. 
IF AVAIL CcbCDocu THEN DO:
    SW-OK = TRUE.
    RETURN.
END.
        
/*FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia
 *                    AND  CcbCDocu.CodCli = gn-clie.CodCli
 *                    AND  CcbCDocu.CodDiv = s-CodDiv 
 *                    AND  CcbCDocu.CodDoc BEGINS f-CodDoc 
 *                    AND  CcbCDocu.FlgEst BEGINS f-FlgEst 
 *                   NO-LOCK,
 *     FIRST FacDocum OF CcbCDocu
 *                   WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK :
 *     CASE CcbCDocu.CodMon :           
 *          WHEN 1 THEN DO :
 *                 F-TotSol = F-TotSol + CcbCDocu.SdoAct.
 *                 /* por vencer */
 * /*                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVSo = F-TpoVSo + CcbCDocu.SdoAct.
 *  *                 /* Vencido */
 *  *                 IF CcbCDocu.FchVto < TODAY THEN DO:
 *  *                    F-TVenSo = F-TVenSo + CcbCDocu.SdoAct. 
 *  *                    I-DIAS = TODAY - CcbCDocu.FchVto.
 *  *                    CASE (I-DIAS > 0):
 *  *                         WHEN YES AND I-DIAS <= 15 THEN 
 *  *                              F-TotS0  = F-TotS0 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
 *  *                              F-TotS15  = F-TotS15 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
 *  *                              F-TotS30  = F-TotS30 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
 *  *                              F-TotS45  = F-TotS45 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 60 THEN 
 *  *                              F-TotS60  = F-TotS60 + CcbCDocu.SdoAct.
 *  *                    END CASE.
 *  *                 END.*/
 *            END.     
 *          WHEN 2 THEN DO :
 *                 F-TotDol = F-TotDol + CcbCDocu.SdoAct.
 *                 /* por vencer */
 * /*                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVDo = F-TpoVDo + CcbCDocu.SdoAct.
 *  *                 /* Vencido */
 *  *                 IF CcbCDocu.FchVto < TODAY THEN DO:
 *  *                    F-TVenDo = F-TVenDo + CcbCDocu.SdoAct.   
 *  *                    I-DIAS = TODAY - CcbCDocu.FchVto.
 *  *                    CASE (I-DIAS > 0):
 *  *                         WHEN YES AND I-DIAS <= 15 THEN 
 *  *                              F-TotD0  = F-TotD0 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
 *  *                              F-TotD15  = F-TotD15 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
 *  *                              F-TotD30  = F-TotD30 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
 *  *                              F-TotD45  = F-TotD45 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 60 THEN 
 *  *                              F-TotD60  = F-TotD60 + CcbCDocu.SdoAct.
 *  *                    END CASE.
 *  *                 END.*/
 *            END.
 *     END CASE .
 * END.
 * 
 * CASE gn-clie.MonLC:  
 *      WHEN 1 THEN 
 *           F-CreUsa = ( F-TotDol * w-cambio ) + F-TotSol.
 *      WHEN 2 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 *      WHEN 0 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 * END CASE.           
 * 
 * F-CreDis = gn-clie.ImpLC - F-CreUsa.
 * F-LinCre = gn-clie.ImpLC.
 * 
 * IF F-CreDis < 0 THEN DO:
 *     MESSAGE "LINEA DE CREDITO SOBREGIRADO"
 *             VIEW-AS ALERT-BOX WARNING.
 *     APPLY "ENTRY" TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.
 *     RETURN NO-APPLY.
 * END.
 * 
 * /*
 * MESSAGE F-LinCre F-CreUsa F-CreDis VIEW-AS ALERT-BOX.
 * */*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Despacho V-table-Win 
PROCEDURE Genera-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  F-CODDOC = 'O/D'.
  FIND FacCorre WHERE 
       FacCorre.CodCia = S-CODCIA AND  
       FacCorre.CodDoc = F-CODDOC AND  
       FacCorre.CodDiv = S-CODDIV 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
     I-NroPed = FacCorre.Correlativo.
     CREATE B-CPedi.
     ASSIGN 
        B-CPedi.codcia = s-codcia
        B-CPedi.coddoc = F-Coddoc
        B-CPedi.nroped = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.
  ASSIGN 
     B-CPedi.FchPed = FacCPedi.Fchped
     B-CPedi.CodAlm = S-CODALM
     B-CPedi.PorIgv = FacCfgGn.PorIgv 
     B-CPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
     B-CPedi.CodDiv = S-CODDIV
     B-CPedi.Nroref = FacCPedi.NroPed
     B-CPedi.Hora   = STRING(TIME,"HH:MM")
     B-CPedi.Usuario = S-USER-ID
     B-CPedi.TipVta = FacCPedi.Tipvta
     B-CPedi.Codcli = FacCPedi.Codcli
     B-CPedi.NomCli = FacCPedi.Nomcli
     B-CPedi.DirCli = FacCPedi.DirCli
     B-CPedi.Codven = FacCPedi.Codven
     B-CPedi.Fmapgo = FacCPedi.Fmapgo
     B-CPedi.Fchven = F-Fchent
     B-CPedi.Tpocmb = FacCPedi.Tpocmb
     B-CPedi.Glosa  = FacCPedi.Glosa
     B-CPedi.CodTrans = F-Codtra
     B-CPedi.LugEnt = F-Lugent
     B-CPedi.LugEnt2 = F-Lugent2
     B-CPedi.Flgsit = IF F-flgsit = "2" THEN "P" ELSE ""
     B-CPEDI.ImpBrt = FacCPedi.ImpBrt
     B-CPEDI.ImpDto = FacCPedi.ImpDto
     B-CPEDI.ImpVta = FacCPedi.ImpVta
     B-CPEDI.ImpExo = FacCPedi.ImpExo
     B-CPEDI.ImpIgv = FacCPedi.ImpIgv
     B-CPEDI.ImpIsc = FacCPedi.ImpIsc
     B-CPEDI.ImpFle = FacCPedi.ImpFle
     B-CPEDI.ImpTot = FacCPedi.ImpTot.
     
  RUN Genera-Orden-Detalle.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  FOR EACH FacDPedi OF B-CPedi NO-LOCK:
      FIND B-DPedi WHERE 
           B-DPedi.CodCia = FacCPedi.CodCia AND  
           B-DPedi.CodDoc = FacCPedi.Coddoc AND  
           B-DPedi.NroPed = FacCPedi.Nroped AND  
           B-DPedi.CodMat = FacDPedi.CodMat 
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi THEN DO:
         B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed).
      END.
      RELEASE B-DPedi.
  END.
  FOR EACH FacDPedi NO-LOCK WHERE 
           FacDPedi.CodCia = S-CODCIA AND  
           FacDPedi.CodDoc = FacCPedi.coddoc AND  
           FacDPedi.NroPed = FacCPedi.nroped:
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  FIND B-CPedi WHERE 
       B-CPedi.CodCia = S-CODCIA AND  
       B-CPedi.CodDiv = FacCPedi.Coddiv AND  
       B-CPedi.CodDoc = FacCPedi.Coddoc AND  
       B-CPedi.NroPed = FacCPedi.Nroped 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CPedi THEN 
     ASSIGN B-CPedi.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P".
     
  RELEASE B-CPedi.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Detalle V-table-Win 
PROCEDURE Genera-Orden-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm: 
       CREATE B-DPedi. 
       ASSIGN B-DPedi.CodCia = B-CPedi.CodCia 
              B-DPedi.coddoc = B-CPedi.coddoc 
              B-DPedi.NroPed = B-CPedi.NroPed 
              B-DPedi.FchPed = B-CPedi.FchPed
              B-DPedi.Hora   = B-CPedi.Hora 
              B-DPedi.FlgEst = B-CPedi.FlgEst
              B-DPedi.tipvta = FacDPedi.tipvta
              B-DPedi.codmat = FacDPedi.codmat 
              B-DPedi.Factor = FacDPedi.Factor 
              B-DPedi.CanPed = FacDPedi.CanPed 
              B-DPedi.Pesmat = FacDPedi.Pesmat
              B-DPedi.ImpDto = FacDPedi.ImpDto 
              B-DPedi.ImpLin = FacDPedi.ImpLin 
              B-DPedi.NroItm = FacDPedi.Nroitm 
              B-DPedi.PorDto = FacDPedi.PorDto 
              B-DPedi.PorDto2 = FacDPedi.PorDto2 
              B-DPedi.MrgUti = FacDPedi.MrgUti
              B-DPedi.PreUni = FacDPedi.PreUni 
              B-DPedi.UndVta = FacDPedi.UndVta 
              B-DPedi.AftIgv = FacDPedi.AftIgv 
              B-DPedi.AftIsc = FacDPedi.AftIsc 
              B-DPedi.ImpIgv = FacDPedi.ImpIgv 
              B-DPedi.ImpIsc = FacDPedi.ImpIsc 
              B-DPedi.PreBas = FacDPedi.PreBas. 
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
  ------------------------------------------------------------------------------ */
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   RUN Borra-Pedido. 
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

   FOR EACH PEDI NO-LOCK WHERE PEDI.CodMat <> "" BY PEDI.NroItm
            ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR': 
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
              FacDPedi.AlmDes = PEDI.AlmDes.
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

  Faccpedi.ImpDto = 0.
  Faccpedi.ImpIgv = 0.
  Faccpedi.ImpIsc = 0.
  Faccpedi.ImpTot = 0.
  Faccpedi.ImpExo = 0.
  FOR EACH PEDI NO-LOCK WHERE PEDI.CodMat <> '': 
       F-Igv = F-Igv + PEDI.ImpIgv.
       F-Isc = F-Isc + PEDI.ImpIsc.
       Faccpedi.ImpTot = Faccpedi.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN Faccpedi.ImpExo = Faccpedi.ImpExo + PEDI.ImpLin.
       IF PEDI.AftIgv = YES
       THEN Faccpedi.ImpDto = Faccpedi.ImpDto + ROUND(PEDI.ImpDto / (1 + Faccpedi.PorIgv / 100), 2).
       ELSE Faccpedi.ImpDto = Faccpedi.ImpDto + PEDI.ImpDto.
  END.
  Faccpedi.ImpIgv = ROUND(F-IGV,2).
  Faccpedi.ImpIsc = ROUND(F-ISC,2).
  Faccpedi.ImpVta = Faccpedi.ImpTot - Faccpedi.ImpExo - Faccpedi.ImpIgv.
  /* RHC 22.12.06 */
  IF Faccpedi.PorDto > 0 THEN DO:
    Faccpedi.ImpDto = Faccpedi.ImpDto + ROUND((Faccpedi.ImpVta + Faccpedi.ImpExo) * Faccpedi.PorDto / 100, 2).
    Faccpedi.ImpTot = ROUND(Faccpedi.ImpTot * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpVta = ROUND(Faccpedi.ImpVta * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpExo = ROUND(Faccpedi.ImpExo * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpIgv = Faccpedi.ImpTot - Faccpedi.ImpExo - Faccpedi.ImpVta.
  END.  
  Faccpedi.ImpBrt = Faccpedi.ImpVta + Faccpedi.ImpIsc + Faccpedi.ImpDto + Faccpedi.ImpExo.

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
    s-Copia-Registro = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  L-CREA = YES.
  S-CODMON = 2.
  S-NroCot = "".
  T-Especial = NO.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ FacCPedi.FchPed
/*             TODAY /*+ 10*/ @ FacCPedi.FchVen*/
             FacCfgGn.Tpocmb[1] @ FacCPedi.TpoCmb
             FacCfgGn.CliVar @ FacCPedi.CodCli
             T-Especial.
     FacCPedi.CodMon:SCREEN-VALUE = "2".
     C-TpoVta:SENSITIVE = YES. 
     C-TpoVta:SCREEN-VALUE = ENTRY(1,C-TpoVta:LIST-ITEMS).
     Faccpedi.NomCli:SENSITIVE = NO.
     Faccpedi.DirCli:SENSITIVE = NO.
     Faccpedi.RucCli:SENSITIVE = NO.
     T-Especial:SENSITIVE = YES.

  END.
  output-var-1 = ?.
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
     IF L-CREA THEN DO:
         FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                        AND  FacCorre.CodDoc = S-CODDOC 
                        AND  FacCorre.CodDiv = S-CODDIV 
                       EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE Faccorre THEN UNDO, RETURN 'ADM-ERROR'.
         ASSIGN I-NroPed = FacCorre.Correlativo.
         ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
/*          RUN Numero-de-Pedido(YES). */
         ASSIGN FacCPedi.CodCia = S-CODCIA
                FacCPedi.CodDoc = s-coddoc 
             /*   FacCPedi.FchPed = TODAY */
                FacCPedi.CodAlm = S-CODALM
                FacCPedi.PorIgv = FacCfgGn.PorIgv 
                FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
                FacCPedi.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                FacCPedi.CodDiv = S-CODDIV
                FacCPedi.Flgest = 'G'
                FacCPedi.Hora = STRING(TIME,"HH:MM").
          /*    DISPLAY FacCPedi.NroPed.*/
     END.
     ASSIGN 
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.TipVta = STRING(LOOKUP(C-TpoVta,C-TpoVta:LIST-ITEMS))
        FacCPedi.NomCli = FacCPedi.NomCli:screen-value
        FacCPedi.DirCli = FacCPedi.DirCli:screen-value
        FacCPedi.RucCli = FacCPedi.RucCli:screen-value
        FacCPedi.TpoPed = ""
        FaccPedi.TipBon[1] = IF T-Especial THEN 1 ELSE 0
        
       /**************MAGM******************/
        FaccPedi.NroRef = S-nrocot.
       /*************************************/
       /* RHC 13-01-2004 */
        FaccPedi.CodVen = FacCPedi.CodVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        FaccPedi.FmaPgo = FaccPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

     IF AVAIL B-CPedi THEN ASSIGN FacCPedi.TpoLic = B-CPedi.TpoLic.
  END.
  
  IF SW-OK = TRUE THEN FacCPedi.flgest = "W".

  RUN Genera-Pedido.    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Graba-Totales.
  IF S-NroCot <> "" THEN DO: 
      RUN Actualiza-Cotizacion.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /*RUN aprobar-con-documentos-vencidos.*/

  /* RHC 30-11-2006 Transferencias gratuitas deben aprobarse de todas maneras */
  IF Faccpedi.fmapgo = '900' THEN Faccpedi.flgest = 'X'.

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
        CcbAudit.CodRef = 'COT'
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
  output-var-1 = ?.
  s-copia-registro = Yes.
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
       MESSAGE "No puede eliminar un pedido atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "E" THEN DO:
       MESSAGE "No puede eliminar un pedido cerrado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.canate > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
       MESSAGE "No puede eliminar un pedido con atención parcial" SKIP
        "Codigo:" Facdpedi.codmat
        VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    
    DO ON ERROR UNDO, RETURN "ADM-ERROR":
        FOR EACH FacDPedi WHERE 
                FacDPedi.codcia = FacCPedi.codcia AND  
                FacDPedi.coddoc = FacCPedi.coddoc AND  
                FacDPedi.nroped = FacCPedi.nroped :
           FacDPedi.FlgEst = "A".
        END.
        FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-CPedi THEN 
          ASSIGN B-CPedi.FlgEst = "A"
                 B-CPedi.Glosa = " A N U L A D O".
        RELEASE B-CPedi.
        /* Actualizamos Cotizacion */
        FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddoc = 'COT'
            AND B-CPEDI.nroped = Faccpedi.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-CPEDI THEN DO:
            FOR EACH FacDPedi OF FacCPedi NO-LOCK:
                FIND B-DPEDI OF B-CPEDI WHERE B-DPEDI.codmat = Facdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
                B-DPEDI.canate = B-DPEDI.canate - Facdpedi.canped.
                RELEASE B-DPEDI.
            END.
            B-CPEDI.flgest = 'P'.
            RELEASE B-CPEDI.
        END.
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
  T-Especial:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                   AND  gn-clie.CodCli = FacCPedi.CodCli 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO: 
/*        DISPLAY gn-clie.NomCli @ FacCPedi.NomCli 
 *                 gn-clie.Ruc    @ FacCPedi.RucCli  
 *                 gn-clie.DirCli @ FacCPedi.DirCli.
 *         IF gn-clie.CodCli = FacCfgGn.CliVar THEN DO:
 *            DISPLAY FacCPedi.NomCli 
 *                    FacCPedi.RucCli  
 *                    FacCPedi.DirCli.
 *         END.*/
                
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
                  AND  gn-ven.CodVen = FacCPedi.CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS).
     T-Especial = IF FaccPedi.TipBon[1] = 1 THEN TRUE ELSE NO.
     DISPLAY T-Especial.

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
  Purpose: Override standard ADM method
  Notes  : 
  ------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  
  /* APROBAMOS EL PEDIDO O LO RECHAZAMOS */
  
  RUN Verifica-Cliente.
  
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
   
/*   DEFINE VAR X-COSTO  AS DECI INIT 0.
 *    DEFINE VAR T-COSTO  AS DECI INIT 0.
 *    DEFINE VAR X-MARGEN AS DECI INIT 0.
 *    FOR EACH FacDPedi OF FacCPedi NO-LOCK :
 *        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
 *                            Almmmatg.Codmat = FacDPedi.Codmat NO-LOCK NO-ERROR.
 *        X-COSTO = 0.
 *        IF AVAILABLE Almmmatg THEN DO:
 *           IF FacCPedi.CodMon = 1 THEN DO:
 *              IF Almmmatg.MonVta = 1 THEN 
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) * FacCPedi.Tpocmb .
 *           END.        
 *           IF FacCPedi.CodMon = 2 THEN DO:
 *              IF Almmmatg.MonVta = 2 THEN
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) / FacCPedi.Tpocmb .
 *           END.      
 *           T-COSTO = T-COSTO + X-COSTO * FacDPedi.CanPed.          
 *        END.
 *    END.
 *    X-MARGEN = ROUND(((( FacCPedi.ImpTot / T-COSTO ) - 1 ) * 100 ),2).
 *    IF X-MARGEN < 20 THEN DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX WARNING .
 *    END.
 *    ELSE DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX INFORMATION.
 *    END.*/
            
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
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                     AND  FacCorre.CodDoc = S-CODDOC 
                     AND  FacCorre.CodDiv = S-CODDIV 
                    EXCLUSIVE-LOCK NO-ERROR.
  ELSE 
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                     AND  FacCorre.CodDoc = S-CODDOC 
                     AND  FacCorre.CodDiv = S-CODDIV 
                    NO-LOCK NO-ERROR.
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
     output-var-1 = ?.
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
DEFINE VARIABLE F-SALDO AS DECIMAL INIT 0 NO-UNDO.

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
    FOR EACH PEDI NO-LOCK: 
        F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
    END.

    IF LOOKUP(TRIM(Faccpedi.Fmapgo:SCREEN-VALUE),"000,001,002,403,900") = 0 THEN DO: 
        IF S-CODMON = 1 THEN DO:
            IF gn-clie.MonLC = 2 THEN F-Tot = F-Tot / FacCfgGn.TpoCmb[1].
        END. 
        ELSE DO:
            IF gn-clie.MonLC = 1 THEN F-Tot = F-Tot * FacCfgGn.TpoCmb[1].
        END.
        IF L-CREA THEN DO:
            RUN vta\lincre.r(gn-clie.CodCli,F-Tot,OUTPUT T-SALDO).
            F-SALDO = F-TOT.
        END.
        ELSE DO:
            RUN vta\lincre.r(gn-clie.CodCli,F-Tot - FacCpedi.Imptot,OUTPUT T-SALDO).
            F-SALDO = F-Tot - FacCpedi.Imptot.
        END.
        IF RETURN-VALUE <> "OK" THEN DO:

            dImpLCred = 0.
            lEnCampan = FALSE.
            /* Línea Crédito Campaña */
            FOR EACH Gn-ClieL WHERE
                Gn-ClieL.CodCia = gn-clie.codcia AND
                Gn-ClieL.CodCli = gn-clie.codcli AND
                TODAY >= Gn-ClieL.FchIni AND
                TODAY <= Gn-ClieL.FchFin NO-LOCK:
                dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.

            MESSAGE
                "LINEA CREDITO  : "
                    (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(dImpLCred,"ZZ,ZZZ,ZZ9.99") SKIP
                "USADO                 : "
                    (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(T-SALDO + F-SALDO,"-Z,ZZZ,ZZ9.99") SKIP
                "CREDITO DISPONIBLE    : "
                    (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(dImpLCred - (T-SALDO + F-SALDO),"-Z,ZZZ,ZZ9.99") SKIP
                "VENCIMIENTO           : " gn-clie.FchVLC
                VIEW-AS ALERT-BOX ERROR. 
            APPLY "ENTRY" TO FacCPedi.CodCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
    f-TOT = IF S-CODMON = 1 THEN
        F-TOT ELSE F-TOT * DECI(FaccPedi.Tpocmb:SCREEN-VALUE).
    IF F-Tot >= 1725 THEN DO:
        IF C-TpoVta:SCREEN-VALUE = 'Boleta' THEN DO:
            MESSAGE
                "Boleta de Venta Venta Mayor a S/.1,725.00 Ingresar Nro. Ruc., Verifique... " 
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.CodCli.
            RETURN "ADM-ERROR".   
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
  IF LOOKUP(FacCPedi.FlgEst,"P,F,C,A,E") > 0 THEN  RETURN "ADM-ERROR".

  S-CODMON = FacCPedi.CodMon.
  S-CODCLI = FacCPedi.CodCli.
  s-Copia-Registro = NO.
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = YES. 
  RETURN "OK".

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
DEFINE VAR OK AS LOGICAL NO-UNDO.
DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE F-MRGUTI     AS INTEGER   NO-UNDO.
DEFINE VARIABLE dImpTot      AS DECIMAL   NO-UNDO.

IF LOOKUP(FacCPedi.Flgest, 'G,X,W') > 0 THEN DO:
   FIND B-CPedi WHERE 
        B-CPedi.codcia = s-codcia AND  
        B-CPedi.coddoc = FacCPedi.coddoc AND  
        B-CPedi.nroped = FacCPedi.nroped 
        EXCLUSIVE-LOCK NO-ERROR.

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

   /*IF AVAILABLE B-CPedi AND LOOKUP(B-CPedi.fmapgo,"000,001") > 0 THEN OK = TRUE.*/
   IF AVAILABLE B-CPedi AND LOOKUP(B-CPedi.fmapgo,"000") > 0 THEN OK = TRUE.
   /* SOLO CONTADO ANTICIPADO */
   IF AVAILABLE B-CPedi AND LOOKUP(B-CPedi.fmapgo,"002") > 0 THEN OK = FALSE.

   IF AVAILABLE B-CPedi AND NOT OK 
   THEN ASSIGN 
            B-CPedi.Flgest = 'X'
            B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Linea Credito'.
   ELSE ASSIGN 
            B-CPedi.Flgest = 'P'.
             
   /* Condicion Crediticia */
   FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-totdias = gn-convt.totdias.
                
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN 
      IF gn-convt.totdias > F-totdias AND F-totdias > 0 THEN OK = FALSE.
   IF AVAILABLE B-CPedi AND NOT OK THEN
      ASSIGN B-CPedi.Flgest = 'X'
             B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Cond.Cred.'.
   ELSE ASSIGN B-CPedi.Flgest = 'P'.          

   FOR EACH FacDPedi OF FacCPedi:
       ASSIGN  FacDPedi.Flgest = FacCPedi.Flgest.
       RELEASE FacDPedi.
   END.

   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Orden-Despacho V-table-Win 
PROCEDURE Verifica-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FacCPedi.Flgest = 'P' THEN DO:
  DEFINE VAR ok AS LOGICAL NO-UNDO.
  IF FacCPedi.TpoPed = "2" THEN DO:
    MESSAGE "No puede generar una Orden de Despacho Total" skip
            "El pedido es de Tipo Programado"
            VIEW-AS ALERT-BOX WARNING.
  END.
  ELSE DO:
    MESSAGE 'Desea generar ORDEN DE DESPACHO TOTAL' VIEW-AS ALERT-BOX 
        QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
    IF x-rpta THEN DO TRANSACTION:
       F-Orddes = ''.
       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                      AND  FacCorre.CodDoc = 'O/D' 
                      AND  FacCorre.CodDiv = S-CODDIV 
                     NO-LOCK NO-ERROR.
       IF AVAILABLE FacCorre THEN 
          F-Orddes = STRING(I-NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
       RUN vta\d-orddes (F-Orddes, INPUT-OUTPUT F-Fchent, INPUT-OUTPUT F-Codtra, INPUT-OUTPUT F-Lugent, INPUT-OUTPUT F-Lugent2, INPUT-OUTPUT F-flgsit, OUTPUT ok).
       IF OK THEN RUN Genera-Orden-Despacho.
       RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

