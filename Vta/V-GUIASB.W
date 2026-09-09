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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.

DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE S-CODVEN       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.FchDoc ~
CcbCDocu.CodVen CcbCDocu.FmaPgo CcbCDocu.NroPed CcbCDocu.CodAge ~
CcbCDocu.NroOrd CcbCDocu.LugEnt CcbCDocu.Glosa CcbCDocu.CodMon 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.FchDoc ~
CcbCDocu.HorCie CcbCDocu.CodVen CcbCDocu.FchVto CcbCDocu.FmaPgo ~
CcbCDocu.CodPed CcbCDocu.NroPed CcbCDocu.CodAge CcbCDocu.NroOrd ~
CcbCDocu.LugEnt CcbCDocu.Glosa CcbCDocu.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-pedido F-Estado FILL-IN_NomCli ~
FILL-IN_DirCli FILL-IN_RucCli F-nOMvEN F-CndVta F-NomTra C-TpoVta 

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
     LIST-ITEMS "Factura","Letras" 
     DROP-DOWN-LIST
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(60)" 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .69.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .69.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-pedido AT ROW 1.08 COL 29.57 COLON-ALIGNED
     CcbCDocu.NroDoc AT ROW 1.12 COL 9 COLON-ALIGNED FORMAT "XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .69
          FONT 1
     CcbCDocu.CodRef AT ROW 1.12 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
     CcbCDocu.NroRef AT ROW 1.12 COL 53.72 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .69
     F-Estado AT ROW 1.12 COL 72.43 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FILL-IN_NomCli AT ROW 1.81 COL 19 COLON-ALIGNED NO-LABEL
     CcbCDocu.TpoCmb AT ROW 1.81 COL 74 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     FILL-IN_DirCli AT ROW 2.5 COL 9 COLON-ALIGNED
     FILL-IN_RucCli AT ROW 2.5 COL 50 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 2.5 COL 69.29 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .69
     CcbCDocu.HorCie AT ROW 2.5 COL 78.72 COLON-ALIGNED HELP
          "" NO-LABEL FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .69
          FGCOLOR 12 
     CcbCDocu.CodVen AT ROW 3.19 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-nOMvEN AT ROW 3.19 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchVto AT ROW 3.19 COL 74 COLON-ALIGNED
          LABEL "Vencmento"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCDocu.FmaPgo AT ROW 3.88 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-CndVta AT ROW 3.88 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodPed AT ROW 3.88 COL 64.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     CcbCDocu.NroPed AT ROW 3.88 COL 74 COLON-ALIGNED
          LABEL "O/D" FORMAT "XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.CodAge AT ROW 4.58 COL 9 COLON-ALIGNED
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-NomTra AT ROW 4.58 COL 20 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 4.58 COL 74 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     CcbCDocu.LugEnt AT ROW 5.27 COL 9 COLON-ALIGNED
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
          FGCOLOR 9 
     C-TpoVta AT ROW 5.27 COL 74 COLON-ALIGNED
     CcbCDocu.Glosa AT ROW 5.96 COL 9 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     CcbCDocu.CodMon AT ROW 6.12 COL 76 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .62
     "Referencia" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.15 COL 39.43
     "Moneda   :" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 6.12 COL 67.72
     RECT-21 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
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
         HEIGHT             = 5.85
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
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.CodPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       CcbCDocu.CodPed:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-pedido IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-pedido:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.HorCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
ASSIGN 
       CcbCDocu.HorCie:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodAge V-table-Win
ON LEAVE OF CcbCDocu.CodAge IN FRAME F-Main /* Transportista */
DO:
  F-NomTra = "".
  IF CcbcDocu.CodAge:SCREEN-VALUE <> "" THEN DO: 
     FIND admrutas WHERE admrutas.CodPro = CcbcDocu.CodAge:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE admrutas THEN F-NomTra = admrutas.NomTra.
  END.
  DISPLAY F-NomTra WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
   
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                 AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DO WITH FRAME {&FRAME-NAME} :
  
      DISPLAY gn-clie.NomCli @ fill-in_NomCli
            gn-clie.Ruc    @ fill-in_RucCli
            gn-clie.DirCli @ fill-in_DirCli
            gn-clie.CodVen @ Ccbcdocu.CodVen
            gn-clie.CndVta @ Ccbcdocu.FmaPgo .
 
      S-CODCLI = ccbcdocu.CodCli:SCREEN-VALUE.
   
      IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
         fill-in_NomCli:SENSITIVE = NO.
         fill-in_RucCli:SENSITIVE = NO.
         fill-in_DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO ccbcdocu.CodVen.

      END.   
     ELSE DO: 
        FILL-IN_NomCli:SENSITIVE = YES.
        FILL-IN_RucCli:SENSITIVE = YES.
        FILL-IN_DirCli:SENSITIVE = YES.
        APPLY "ENTRY" TO fill-in_NomCli.
   
     END. 
   END.  
   /* Ubica la Condicion Venta */
   FIND gn-convt WHERE gn-convt.Codig = ccbcdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
           F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
        END.  
        ELSE F-CndVta:SCREEN-VALUE = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEAVE OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  
  F-NomVen = "".
  IF SELF:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = SELF:screen-value 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
   
   F-CndVta:SCREEN-VALUE = "".
   FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-convt THEN DO:
      MESSAGE "Condicion de Venta No existe"
              VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
   END.
   
   F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroDoc V-table-Win
ON LEAVE OF CcbCDocu.NroDoc IN FRAME F-Main /* Numero */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  IF LENGTH(SELF:SCREEN-VALUE) <> 9 THEN DO:
     MESSAGE "Numero de Documento debe tener 9 digitos......"
             VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.        

  END.
  
  FIND B-CDOCU WHERE B-CDOCU.Codcia = S-CODCIA AND
                     B-CDOCU.Coddiv = S-CODDIV AND
                     B-CDOCU.Coddoc = S-CODDOC AND
                     B-CDOCU.NroDoc = SELF:SCREEN-VALUE 
                     NO-LOCK NO-ERROR. 
  IF AVAILABLE B-CDOCU THEN DO:
     MESSAGE "Documento Ya existe......"
             VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.        
  END.   
  assign
  I-nrodoc = integer(ccbcdocu.nrodoc:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Deta V-table-Win 
PROCEDURE Actualiza-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DETA:
    DELETE DETA.
END.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDDocu NO-LOCK WHERE 
            CcbDDocu.CodCia = CcbCDocu.CodCia AND
            CCbddocu.CodDoc = Ccbcdocu.Coddoc AND  
            CcbDDocu.NroDoc = CcbCDocu.NroDoc :
       CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia 
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.CanDes = CcbDDocu.CanDes 
              DETA.Pesmat = CcbDDocu.Pesmat
              DETA.Factor = CcbDDocu.Factor 
              DETA.UndVta = CcbDDocu.UndVta
              DETA.PreBas = CcbDDocu.PreBas 
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.ImpLin = CcbDDocu.ImpLin 
              DETA.ImpIsc = CcbDDocu.ImpIsc 
              DETA.ImpIgv = CcbDDocu.ImpIgv 
              DETA.ImpDto = CcbDDocu.ImpDto 
              DETA.AftIsc = CcbDDocu.AftIsc 
              DETA.AftIgv = CcbDDocu.AftIgv.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Guia V-table-Win 
PROCEDURE Borra-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CcbDDocu EXCLUSIVE-LOCK WHERE 
           CcbDDocu.CodCia = CcbCDocu.CodCia AND  
           CcbDDocu.CodDoc = CcbCDocu.CodDoc AND  
           CcbDDocu.Nrodoc = CcbCDocu.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE CcbDDocu.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia V-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  ------------------------------------------------------------------------------*/
   FOR EACH DETA NO-LOCK WHERE 
            DETA.CodMat <> ""
            ON ERROR UNDO, RETURN "ADM-ERROR": 
       CREATE CcbDDocu. 
       ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.Coddoc = CcbCDocu.Coddoc
              CcbDDocu.NroDoc = CcbCDocu.NroDoc 
              CcbDDocu.codmat = DETA.codmat 
              CcbDDocu.CanDes = DETA.CanDes 
              CcbDDocu.UndVta = DETA.UndVta
              CcbDDocu.Factor = DETA.Factor 
              CcbDDocu.Pesmat = DETA.Pesmat
              CcbDDocu.PreUni = DETA.PreUni 
              CcbDDocu.PreBas = DETA.PreBas 
              CcbDDocu.PorDto = DETA.PorDto 
              CcbDDocu.ImpLin = DETA.ImpLin 
              CcbDDocu.ImpIsc = DETA.ImpIsc 
              CcbDDocu.ImpIgv = DETA.ImpIgv 
              CcbDDocu.ImpDto = DETA.ImpDto 
              CcbDDocu.AftIsc = DETA.AftIsc 
              CcbDDocu.AftIgv = DETA.AftIgv
              CcbDDocu.FchDoc = CcbCdocu.fchDoc
              CcbDDocu.CodDiv = CcbcDocu.CodDiv.
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
   FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
   B-CDOCU.ImpDto = 0.
   B-CDOCU.ImpIgv = 0.
   B-CDOCU.ImpIsc = 0.
   B-CDOCU.ImpTot = 0.
   B-CDOCU.ImpExo = 0.
   FOR EACH DETA NO-LOCK: 
       B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto.
       F-Igv = F-Igv + DETA.ImpIgv.
       F-Isc = F-Isc + DETA.ImpIsc.
       B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
       IF NOT DETA.AftIgv THEN B-CDOCU.ImpExo = B-CDOCU.ImpExo + DETA.ImpLin.
   END.
   B-CDOCU.ImpIgv = ROUND(F-IGV,2).
   B-CDOCU.ImpIsc = ROUND(F-ISC,2).
   B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                    B-CDOCU.ImpDto - B-CDOCU.ImpExo.
   B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpDto.
   B-CDOCU.SdoAct = B-CDOCU.ImpTot.
   RELEASE B-CDOCU.
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
  
  RUN Actualiza-Deta.
  
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
  IF L-CREA THEN DO :
     S-CODALM = "11".
     ASSIGN CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.CodAlm = S-CODALM
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.NroDoc = CcbCDocu.NroDoc:SCREEN-VALUE
            CcbCDocu.CodMov = S-CODMOV 
            CcbCDocu.CodPed = "O/D" 
            CcbCDocu.Tipo   = "OFICINA"
            CcbCDocu.TipVta = "2"
            CcbCDocu.TpoFac = "R"
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.PorIgv = FacCfgGn.PorIgv
            CcbCDocu.FlgEst = "P"
            CcbCDocu.FlgSit = "P"
         /* CcbCDocu.FlgAte = "P" */
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.HorCie = string(time,'hh:mm:ss').
     
     FIND gn-clie WHERE 
          gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO:
        ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
               CcbCDocu.CodProv = gn-clie.CodProv 
               CcbCDocu.CodDist = gn-clie.CodDist.
     END.
  END.
  ASSIGN
    CcbCDocu.Nomcli = FILL-IN_NomCli:screen-value
    CcbCDocu.Dircli = FILL-IN_DirCli:screen-value
    CcbCDocu.Ruccli = FILL-IN_RucCli:screen-value
    CcbCDocu.FchDoc = DATE(CcbCDocu.Fchdoc:SCREEN-VALUE)
    CcbCDocu.NroPed = CcbCDocu.NroPed:SCREEN-VALUE 
    CcbCDocu.CodCli = CcbCDocu.CodCli:SCREEN-VALUE
    CcbCDocu.CodVen = CcbCDocu.CodVen:SCREEN-VALUE
    CcbCDocu.CodRef = CcbCDocu.CodRef:SCREEN-VALUE
    CcbCDocu.NroRef = CcbCDocu.NroRef:SCREEN-VALUE
    CcbCDocu.FmaPgo = CcbCDocu.FmaPgo:SCREEN-VALUE
    CcbCDocu.CodMon = INTEGER(CcbCDocu.CodMon:SCREEN-VALUE)
    CcbCDocu.NroOrd = CcbCDocu.NroOrd:SCREEN-VALUE .

     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN 
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
     IF Ccbcdocu.Codref <> "" and ccbcdocu.nroref <> "" then ccbcdocu.flgest = "F".   
     DISPLAY CcbCDocu.NroDoc.
  
  END.

  IF NOT L-CREA THEN DO:
     RUN Borra-Guia.
     RUN VTA\des_alm.r(ROWID(CcbCDocu)).

  END.   

  RUN Genera-Guia.    /* Detalle de la Guia */ 

  RUN Graba-Totales.

  
  /* descargamos de almacen */
  RUN VTA\act_alm.r(ROWID(CcbCDocu)).
  do WITH FRAME {&FRAME-NAME}:
         fill-in_NomCli:SENSITIVE = NO.
         fill-in_RucCli:SENSITIVE = NO.
         fill-in_DirCli:SENSITIVE = NO.
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
   DEFINE VAR RPTA AS CHAR.
   
   IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      
      
      RUN Borra-Guia.
      
      /* ACTUALIZAMOS STOCK DE ALMACEN */
      RUN VTA\des_alm.r(ROWID(CcbCDocu)).
      
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CDOCU THEN 
         ASSIGN B-CDOCU.FlgEst = "A"
                B-CDOCU.SdoAct = 0
                B-CDOCU.Glosa  = "A N U L A D O"
                B-CDOCU.FchAnu = TODAY
                B-CDOCU.Usuanu = S-USER-ID. 
      RELEASE B-CDOCU.
      FIND FacCPedi WHERE 
           FacCPedi.CodCia = CcbCDocu.CodCia AND
           FacCPedi.CodDoc = CcbCDocu.Codped AND
           FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCPedi THEN ASSIGN FacCPedi.FlgEst = "P".
      RELEASE FacCPedi.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
                gn-clie.Ruc    @ FILL-IN_RucCli  
                gn-clie.DirCli @ FILL-IN_DirCli.
       
       IF gn-clie.CodCli = FacCfgGn.CliVar THEN DO:
          DISPLAY ccbcdocu.NomCli @ FILL-IN_NomCli 
                  ccbcdocu.RucCli @ FILL-IN_RucCli 
                  ccbcdocu.DirCli @ FILL-IN_DirCli.
         
       END.                   
     CASE CcbCDocu.FlgEst:
         WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "F" THEN DISPLAY "FACTURADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
     END CASE.         
                  
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     FIND admrutas WHERE admrutas.CodPro = CcbCDocu.CodAge NO-LOCK NO-ERROR.
     IF AVAILABLE admrutas THEN F-NomTra:SCREEN-VALUE = admrutas.NomTra.
     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(CcbCDocu.TipVta),C-TpoVta:LIST-ITEMS).
     FILL-IN-pedido:screen-value = "".
  
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  IF CcbCDocu.FlgEst <> "A" THEN RUN VTA\R-ImpGui.R(ROWID(CcbCDocu)).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento V-table-Win 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
 *   IF L-INCREMENTA THEN
 *      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
 *           FacCorre.CodDoc = S-CODDOC AND
 *           FacCorre.CodDiv = S-CODDIV AND
 *           FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
 *   ELSE
 *      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
 *           FacCorre.CodDoc = S-CODDOC AND
 *           FacCorre.CodDiv = S-CODDIV AND
 *           FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.
 *      
 *   IF AVAILABLE FacCorre THEN DO:
 *      ASSIGN I-NroDoc = FacCorre.Correlativo.
 *      IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
 *      I-NROSER = FacCorre.NroSer.
 *      S-CODALM = FacCorre.CodAlm.
 *   END.
 *   RELEASE FacCorre.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Pedido V-table-Win 
PROCEDURE Procesa-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE C-RETORNO AS CHAR INIT "OK" NO-UNDO.
FIND FacCPedi WHERE FacCPedi.CodCia = S-CODCIA 
               AND  FacCPedi.CodDiv = S-CODDIV 
               AND  FacCPedi.CodDoc = C-CODPED 
               AND  FacCPedi.NroPed = C-NROPED 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

FOR EACH FacDPedi OF FacCPedi NO-LOCK :
    IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
        FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                       AND  Almmmate.CodAlm = FacCPedi.CodAlm 
                       AND  Almmmate.codmat = FacDPedi.CodMat 
                      NO-LOCK NO-ERROR.
        
/*        IF NOT AVAILABLE Almmmate OR Almmmate.StkAct <= 0 OR
 *            (Almmmate.StkAct - ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor)) < 0  THEN DO:         
 *            MESSAGE "No hay Stock para atender el articulo " FacDPedi.CodMat VIEW-AS ALERT-BOX ERROR.
 *            C-RETORNO = "ADM-ERROR".
 *            LEAVE.
 *         END.*/
        
        /* cargamos candev con el saldo del pedido para controlar lo maximo que podemos despachar  */
        CREATE DETA.
        ASSIGN DETA.CodCia = S-CODCIA
               DETA.codmat = FacDPedi.CodMat
               DETA.CanDes = (FacDPedi.CanPed - FacDPedi.CanAte)
               DETA.CanDev = (FacDPedi.CanPed - FacDPedi.CanAte)
               DETA.UndVta = FacDPedi.UndVta
               DETA.Factor = FacDPedi.Factor
               DETA.PreUni = FacDPedi.PreUni 
               DETA.PreBas = FacDPedi.PreBas 
               DETA.PorDto = FacDPedi.PorDto 
               DETA.ImpDto = FacDPedi.ImpDto 
               DETA.AftIsc = FacDPedi.AftIsc 
               DETA.AftIgv = FacDPedi.AftIgv
               /*
               DETA.ImpDto = ROUND( DETA.PreUni * (DETA.PorDto / 100) * DETA.CanDes , 2 )
               DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 )  - DETA.ImpDto.
               */
               DETA.ImpDto = ROUND( DETA.PreBas * (DETA.PorDto / 100) * DETA.CanDes , 2 )
               DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) /* - DETA.ImpDto*/.

        IF DETA.AftIgv THEN 
           DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin / (1 + (FacCfgGn.PorIgv / 100)),4).
        FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                       AND  Almmmatg.codmat = FacDPedi.CodMat 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg AND DETA.AftIsc THEN 
           ASSIGN
              DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * Almmmatg.PorIsc / 100,2).
        IF AVAILABLE Almmmatg THEN
           ASSIGN 
              DETA.Pesmat = Almmmatg.Pesmat * (DETA.Candes * DETA.Factor).
    END.
END.
RETURN C-RETORNO.
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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
     Ccbcdocu.NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
     RUN Actualiza-Deta.
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
DEFINE VARIABLE X-ITEMS AS INTEGER INIT 0.
DEFINE VARIABLE I-ITEMS AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :

   IF date(ccbcdocu.fchdoc:screen-value) = ? THEN DO:
      MESSAGE "Fecha de Documento por registrar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.fchDoc.
      RETURN "ADM-ERROR".   
     
   END.

   FIND admrutas WHERE admrutas.CodPro = CcbcDocu.CodAge:screen-value NO-LOCK NO-ERROR.
   IF NOT AVAILABLE admrutas THEN DO:
      MESSAGE "Codigo de transportista no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodAge.
      RETURN "ADM-ERROR".   
   END.
   X-ITEMS = 0.
   FOR EACH DETA NO-LOCK:
       I-ITEMS = I-ITEMS + DETA.CanDes.
       X-ITEMS = X-ITEMS + 1.
   END.
   IF I-ITEMS = 0 THEN DO:
      MESSAGE "No hay items por despachar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodAge.
      RETURN "ADM-ERROR".   
   END.
    
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF X-ITEMS >  FacCfgGn.Items_Guias THEN DO:
     MESSAGE "Numero de Items Mayor al Configurado para el Tipode Documento " VIEW-AS ALERT-BOX INFORMATION.
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
/*RETURN "ADM-ERROR".*/

IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

