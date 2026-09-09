&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV   AS CHARACTER. 
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR INITIAL 'E/C'.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .


S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CTACJA       AS CHARACTER NO-UNDO. 

DEFINE BUFFER B-CMvto   FOR CcbCMvto.
DEFINE BUFFER B-CB-DMOV FOR CB-DMOV.
DEFINE BUFFER DETALLE   FOR CB-DMOV.

FIND FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR S-PERIODO AS INTEGER NO-UNDO.
DEFINE VAR S-NROMES  AS INTEGER NO-UNDO.
     
DEFINE VARIABLE X-NROAST  AS INTEGER NO-UNDO.
DEFINE VARIABLE X-CODOPE  AS CHAR    NO-UNDO.
DEFINE VARIABLE X-CodCta  AS CHAR    NO-UNDO.
DEFINE VARIABLE X-TpoMov  AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-CodCbd  AS CHAR    NO-UNDO.
DEFINE VARIABLE X-NroItm  AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

FIND Empresas WHERE Empresas.CodCia = s-codcia.

IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1 NO-LOCK  NO-ERROR.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VARIABLE C-NOMOPER AS CHAR.
DEFINE VARIABLE C-CTAOPER AS CHAR.
C-NOMOPER = "".
C-CTAOPER = "".
FOR EACH cb-oper NO-LOCK WHERE
         cb-oper.CodCia = CB-CODCIA AND
         cb-oper.Resume :
    IF C-NOMOPER = ""  THEN 
       ASSIGN C-NOMOPER = cb-oper.CodOpe + " - " + REPLACE(cb-oper.NomOpe,",",".").
       /*
              C-CTAOPER = cb-oper.CtaCja.    
              */
    ELSE 
       ASSIGN C-NOMOPER = C-NOMOPER + "," + cb-oper.CodOpe + " - " + REPLACE(cb-oper.NomOpe,",",".").
       /*       C-CTAOPER = C-CTAOPER + "," + cb-oper.CtaCja.
       */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCli CcbCMvto.FchDoc ~
CcbCMvto.Glosa CcbCMvto.TpoCmb CcbCMvto.NroRef 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}NroRef ~{&FP2}NroRef ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-25 CB-NomOpe 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.Nroast ~
CcbCMvto.CodDiv CcbCMvto.CodCta CcbCMvto.CodCli CcbCMvto.FchDoc ~
CcbCMvto.Glosa CcbCMvto.TpoCmb CcbCMvto.NroRef CcbCMvto.CodMon 
&Scoped-Define DISPLAYED-OBJECTS CB-NomOpe FILL-IN_NomCli 

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
DEFINE VARIABLE CB-NomOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operacion" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "","" 
     SIZE 39.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .69.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.57 BY 4.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.19 COL 8 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 14 BY .69
     CB-NomOpe AT ROW 1.19 COL 40 COLON-ALIGNED
     CcbCMvto.Nroast AT ROW 2.12 COL 8 COLON-ALIGNED
          LABEL "Asiento"
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCMvto.CodDiv AT ROW 2.12 COL 47 COLON-ALIGNED
          LABEL "Divisionaria"
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .69
     CcbCMvto.CodCta AT ROW 2.12 COL 69 COLON-ALIGNED
          LABEL "Cuenta"
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .69
     CcbCMvto.CodCli AT ROW 2.85 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
     FILL-IN_NomCli AT ROW 2.85 COL 16.43 COLON-ALIGNED NO-LABEL
     CcbCMvto.FchDoc AT ROW 2.85 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.Glosa AT ROW 3.62 COL 8 COLON-ALIGNED
          LABEL "Nota"
          VIEW-AS FILL-IN 
          SIZE 47.29 BY .69
     CcbCMvto.TpoCmb AT ROW 3.62 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCMvto.NroRef AT ROW 4.35 COL 8 COLON-ALIGNED
          LABEL "No.Cheque"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .69
     CcbCMvto.CodMon AT ROW 4.35 COL 71 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US&", 2
          SIZE 10.43 BY .69
     RECT-25 AT ROW 1 COL 1
     "Moneda :" VIEW-AS TEXT
          SIZE 7 BY .69 AT ROW 4.35 COL 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCMvto
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.73
         WIDTH              = 81.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodCta IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCMvto.CodDiv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET CcbCMvto.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Nroast IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.NroRef IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CB-NomOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-NomOpe V-table-Win
ON VALUE-CHANGED OF CB-NomOpe IN FRAME F-Main /* Operacion */
DO:
   ASSIGN CB-NomOpe.
   X-CODOPE = SUBSTRING(CB-NomOpe,1,3).
   C-CTACJA = ENTRY(LOOKUP(CB-NomOpe,CB-NomOpe:LIST-ITEMS),C-CTAOPER).
   FIND CB-CTAS WHERE 
        CB-CTAS.CODCIA = CB-CODCIA AND
        CB-CTAS.CODCTA = C-CTACJA NO-LOCK NO-ERROR.
   IF AVAILABLE CB-CTAS THEN S-CODMON = CB-CTAS.CODMON.
   CcbCMvto.CodMon:SCREEN-VALUE = STRING(S-CODMON).
   DISPLAY C-CTACJA @ CcbCMvto.CodCta 
           "" @ CcbCMvto.NroRef WITH FRAME {&FRAME-NAME}.
   CcbCMvto.NroRef:SENSITIVE IN FRAME {&FRAME-NAME} = (C-CTACJA BEGINS "104").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCli V-table-Win
ON LEAVE OF CcbCMvto.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE 
       gn-clie.CodCia = 0 AND 
       gn-clie.CodCli = SELF:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE 'Codigo de Cliente no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FILL-IN_NomCli = gn-clie.NomCli.
  DISPLAY FILL-IN_NomCli WITH FRAME {&FRAME-NAME}.
  s-codcli = CcbCMvto.Codcli:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.FchDoc V-table-Win
ON LEAVE OF CcbCMvto.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE 
            gn-tcmb.fecha <= INPUT CcbCMvto.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN S-TPOCMB = gn-tcmb.venta.
  DISPLAY S-TPOCMB @ CcbCMvto.TpoCmb WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  S-TPOCMB = DECIMAL(CcbCMvto.TpoCmb:SCREEN-VALUE).
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
/*-------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
---------------------------------------------------------*/
FOR EACH MVTO:
    DELETE MVTO.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "CcbCMvto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCMvto"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Eliminar el detalle del canje */
FOR EACH  CcbDMvto WHERE 
          CcbDMvto.CodCia = CcbCMvto.CodCia AND
          CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
          CcbDMvto.NroDoc = CcbCMvto.NroDoc
          ON ERROR UNDO, RETURN "ADM-ERROR":
    DELETE CcbDMvto.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica V-table-Win 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-GenAut AS INTEGER.
    
    DEFINE VAR i        AS INTEGER INIT 1.
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
       IF B-CB-DMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 )  THEN DO:
          IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
             x-GenAut = 1.
             LEAVE.
          END.                                              
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
       IF B-CB-DMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
             x-GenAut = 2.
             LEAVE.
          END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
       IF B-CB-DMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
             x-GenAut = 3.
             LEAVE.
          END.
       END.
    END.
    ASSIGN B-CB-DMOV.CtaAut = ""
           B-CB-DMOV.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN B-CB-DMOV.CtrCta = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN  
                  B-CB-DMOV.CtaAut = B-CB-DMOV.CodAux.
             ELSE B-CB-DMOV.CtaAut = cb-ctas.An1Cta.
             IF B-CB-DMOV.CtrCta = ""  THEN B-CB-DMOV.CtrCta = cb-cfga.Cc1Cta9.
        END. 
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
             ASSIGN B-CB-DMOV.CtaAut = cb-ctas.An1Cta
                    B-CB-DMOV.CtrCta = cb-ctas.Cc1Cta.
             IF B-CB-DMOV.CtrCta = "" THEN 
                B-CB-DMOV.CtrCta = cb-cfga.Cc1Cta6.
        END.
        WHEN 3 THEN DO:
             ASSIGN B-CB-DMOV.CtaAut = cb-ctas.An1Cta
                    B-CB-DMOV.CtrCta = cb-ctas.Cc1Cta.
        END.
    END CASE.
    
    /* Generando las cuentas autom ticas */
    IF B-CB-DMOV.CtrCta <> "" THEN DO:
       FIND cb-ctas WHERE 
            cb-ctas.CodCia = cb-codcia AND 
            cb-ctas.CodCta = B-CB-DMOV.CodCta
            NO-LOCK NO-ERROR.
       IF B-CB-DMOV.CtaAut <> "" THEN DO:
          CREATE DETALLE.
          RAW-TRANSFER B-CB-DMOV TO DETALLE.
          X-NroItm = X-NroItm + 1.
          ASSIGN DETALLE.TpoItm   = "A"
                 DETALLE.NroItm   = X-NroItm
                 DETALLE.Codcta   = B-CB-DMOV.CtaAut
                 DETALLE.TpoMov   = B-CB-DMOV.TpoMov
                 DETALLE.Relacion = RECID(B-CB-DMOV).
                 
          RUN cbd/cb-acmd.p(RECID(DETALLE), YES ,YES).
          
          IF DETALLE.TpoMov THEN 
             ASSIGN cb-cmov.HBEMN1  = cb-cmov.HBEMN1 + DETALLE.impmn1
                    cb-cmov.HBEMN2  = cb-cmov.HBEMN2 + DETALLE.impmn2.
          ELSE
             ASSIGN cb-cmov.DBEMN1  = cb-cmov.DBEMN1 + DETALLE.impmn1
                    cb-cmov.DBEMN2  = cb-cmov.DBEMN2 + DETALLE.impmn2.
       END.
         
       CREATE DETALLE.
       RAW-TRANSFER B-CB-DMOV TO DETALLE.
       X-NroItm = X-NroItm + 1.
       ASSIGN DETALLE.TpoItm   = "A"
              DETALLE.NroItm   = X-NroItm
              DETALLE.Codcta   = B-CB-DMOV.Ctrcta
              DETALLE.TpoMov   = NOT B-CB-DMOV.TpoMov
              DETALLE.Relacion = RECID(B-CB-DMOV).
       RUN cbd/cb-acmd.p(RECID(DETALLE), YES ,YES).
       IF DETALLE.TpoMov THEN 
          ASSIGN cb-cmov.HBEMN1  = cb-cmov.HBEMN1 + DETALLE.impmn1
                 cb-cmov.HBEMN2  = cb-cmov.HBEMN2 + DETALLE.impmn2.
       ELSE
          ASSIGN cb-cmov.DBEMN1  = cb-cmov.DBEMN1 + DETALLE.impmn1
                 cb-cmov.DBEMN2  = cb-cmov.DBEMN2 + DETALLE.impmn2.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH MVTO ON ERROR UNDO, RETURN "ADM-ERROR" :
       CREATE CcbDMvto.
       ASSIGN CcbDMvto.CodCia = CcbCMvto.CodCia 
              CcbDMvto.CodDoc = CcbCMvto.CodDoc 
              CcbDMvto.NroDoc = CcbCMvto.NroDoc
              CcbDMvto.CodCli = CcbCMvto.CodCli
              CcbDMvto.TpoRef = MVTO.TpoRef
              CcbDMvto.CodRef = MVTO.CodRef
              CcbDMvto.NroRef = MVTO.NroRef
              CcbDMvto.FchEmi = MVTO.FchEmi
              CcbDMvto.FchVto = MVTO.FchVto
              CcbDMvto.ImpDoc = MVTO.ImpTot
              CcbDMvto.ImpTot = MVTO.ImpTot.
   END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Diferencia-de-Cambio V-table-Win 
PROCEDURE Genera-Diferencia-de-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER I-TPODIF AS INTEGER.
   DEFINE INPUT PARAMETER L-TPODIF AS LOGICAL.
   DEFINE VARIABLE CtaDif AS CHAR NO-UNDO.
   
   FIND cb-cfgg WHERE 
        cb-cfgg.CodCia = 0 AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.

   IF NOT AVAILABLE cb-cfgg THEN RETURN.
   
   IF L-TPODIF THEN 
        CtaDif = cb-cfgg.codcta[2].  /* GANANCIA */
   ELSE CtaDif = cb-cfgg.codcta[1].  /* PERDIDA  */
   
   X-NroItm = X-NroItm + 1.
   
   CREATE B-CB-DMOV.
   B-CB-DMOV.CodCia  = CB-CMOV.CodCia. 
   B-CB-DMOV.NroMes  = CB-CMOV.NroMes. 
   B-CB-DMOV.Periodo = CB-CMOV.PERIODO.
   B-CB-DMOV.Codope  = CB-CMOV.Codope.
   B-CB-DMOV.NroAst  = CB-CMOV.NroAst.
   B-CB-DMOV.Codcta  = CtaDif.
   B-CB-DMOV.CodDiv  = CB-DMOV.CodDiv.
   B-CB-DMOV.Codmon  = I-TPODIF.
   B-CB-DMOV.TpoItm  = "D".
   B-CB-DMOV.flgact  = YES.
   IF CtaDif = cb-cfgg.codcta[2] THEN 
        B-CB-DMOV.Glodoc  = "Ganancia por Diferencia de Cambio". 
   ELSE B-CB-DMOV.Glodoc  = "Perdida por Diferencia de Cambio". 
   B-CB-DMOV.Tpocmb  = 0.
   B-CB-DMOV.ImpMn1  = IF I-TPODIF = 1 THEN CB-DMOV.Impmn3 ELSE 0.
   B-CB-DMOV.ImpMn2  = IF I-TPODIF = 2 THEN CB-DMOV.Impmn3 ELSE 0.
   B-CB-DMOV.ImpMn3  = 0.
   B-CB-DMOV.TpoMov  = L-TPODIF.
   B-CB-DMOV.NroItm  = X-NroItm.
           
   RUN cbd/cb-acmd.p(RECID(B-cb-dmov), YES ,YES).
   
   IF B-CB-DMOV.TpoMov THEN 
      ASSIGN cb-cmov.HBEMN1  = cb-cmov.HBEMN1 + B-CB-DMOV.impmn1
             cb-cmov.HBEMN2  = cb-cmov.HBEMN2 + B-CB-DMOV.impmn2.
   ELSE
      ASSIGN cb-cmov.DBEMN1  = cb-cmov.DBEMN1 + B-CB-DMOV.impmn1
             cb-cmov.DBEMN2  = cb-cmov.DBEMN2 + B-CB-DMOV.impmn2.
             
   FIND cb-ctas WHERE 
        cb-ctas.CodCia = cb-codcia AND
        cb-ctas.CodCta = B-CB-DMOV.CodCta NO-LOCK NO-ERROR.
   
   RUN Genera-Automatica.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Egreso-de-Caja V-table-Win 
PROCEDURE Genera-Egreso-de-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IMPMN3 AS DECIMAL.
DEFINE VARIABLE L-TpoMov AS LOGICAL.
X-NroItm = 0.
DO ON ERROR UNDO, RETURN "ADM-ERROR": 
   FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
   s-periodo = YEAR(B-CMVTO.FchDoc).
   s-NroMes  = MONTH(B-CMVTO.FchDoc).
   /* ********** CREAMOS LA CABECERA DEL ASIENTO ********** */
   RUN cbd/cbdnast.p(cb-codcia , s-codcia, s-periodo, s-NroMes, X-CODOPE, OUTPUT X-NroAst).
   CREATE cb-cmov. 
   ASSIGN cb-cmov.Codcia  = S-Codcia 
          cb-cmov.Periodo = S-periodo 
          cb-cmov.Nromes  = S-Nromes 
          cb-cmov.Codope  = X-Codope 
          cb-cmov.Nroast  = STRING(X-NroAst,"999999") 
          cb-cmov.Codmon  = B-CMVTO.CodMon 
          cb-cmov.Fchast  = B-CMVTO.FchDoc 
          cb-cmov.Flgest  = "" 
          cb-cmov.GloAst  = B-CMVTO.Glosa 
          cb-cmov.Tpocmb  = B-CMVTO.TpoCmb 
          cb-cmov.Usuario = S-USER-ID 
          cb-cmov.CodDiv  = B-CMVTO.CodDiv 
          cb-cmov.CodAux  = B-CMVTO.CodCli 
          cb-cmov.CtaCja  = B-CMVTO.CodCta 
          cb-cmov.C-Fcaja = "10" 
          cb-cmov.Girado  = FILL-IN_NomCli 
          cb-cmov.Coddoc  = IF B-CMVTO.NroRef = "" THEN "" ELSE "CH" 
          cb-cmov.Nrochq  = B-CMVTO.NroRef 
          cb-cmov.Impchq  = B-CMVTO.ImpTot 
          cb-cmov.Totitm  = 0
          cb-cmov.DBEMN1  = 0
          cb-cmov.DBEMN2  = 0
          cb-cmov.HBEMN1  = 0
          cb-cmov.HBEMN2  = 0
          cb-cmov.Notast  = "" 
          B-CMVTO.NroMes = S-Nromes 
          B-CMVTO.Nroast = STRING(X-NroAst,"999999").
   /* generamos detalle segun movimiento */
   FOR EACH CcbDMvto NO-LOCK WHERE 
            CcbDMvto.CodCia = B-CMVTO.CodCia AND 
            CcbDMvto.CodDoc = B-CMVTO.CodDoc AND 
            CcbDMvto.NroDoc = B-CMVTO.NroDoc : 
       X-NroItm = X-NroItm + 1.
       FIND FacDocum WHERE 
            FacDocum.CodCia = B-CMVTO.CodCia AND
            FacDocum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
       IF AVAILABLE FacDocum THEN DO:
          X-TpoMov = FacDocum.TpoDoc.
          X-CodCbd = FacDocum.CodCbd.
          FIND CcbCDocu WHERE 
               CcbCDocu.CodCia = CcbDMvto.CodCia AND
               CcbCDocu.CodDoc = CcbDMvto.CodRef AND 
               CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
          IF AVAILABLE CcbCDocu THEN DO:
             IF CcbCDocu.CodMon = 1 THEN X-CodCta = FacDocum.CodCta[1].
             ELSE X-CodCta = FacDocum.CodCta[2].
          END.
          IF  X-CodCta = '' THEN X-CodCta = FacDocum.CodCta[1].
          CREATE cb-dmov.
          ASSIGN cb-dmov.Codcia  = cb-cmov.Codcia 
                 cb-dmov.Periodo = cb-cmov.Periodo 
                 cb-dmov.Nromes  = cb-cmov.Nromes 
                 cb-dmov.Codope  = cb-cmov.Codope 
                 cb-dmov.Nroast  = cb-cmov.Nroast 
                 cb-dmov.Codmon  = cb-cmov.Codmon 
                 cb-dmov.CodDiv  = cb-cmov.CodDiv 
                 cb-dmov.codcta  = x-codcta
                 cb-dmov.tpomov  = NO /* x-tpomov */
                 cb-dmov.Tpocmb  = B-CMVTO.TpoCmb
                 cb-dmov.glodoc  = 'Canc.' + CcbDMvto.CodRef + '-' + CcbDMvto.NroRef + ' Cli.' + B-CMVTO.Codcli
                 cb-dmov.NroItm  = X-NroItm
                 cb-dmov.clfaux  = "@CL"
                 cb-dmov.codaux  = B-CMVTO.CodCli
                 cb-dmov.coddoc  = CcbDMvto.CodRef
                 cb-dmov.nrodoc  = CcbDMvto.NroRef
                 cb-dmov.nroref  = CcbDMvto.Nrodoc.
          IF AVAILABLE CcbCDocu THEN 
             ASSIGN cb-dmov.fchdoc  = CcbCDocu.FchDoc 
                    cb-dmov.fchvto  = CcbCDocu.FchVto
                    cb-dmov.TpoCmb  = CcbCDocu.TpoCmb.
                    
          IF Cb-dmov.CodMon = 1 THEN
             ASSIGN cb-dmov.impmn1  = cb-dmov.impmn1 + CcbDMvto.ImpTot
                    cb-dmov.impmn2  = cb-dmov.impmn2 + ROUND((CcbDMvto.ImpTot / cb-dmov.TpoCmb),2).
          ELSE 
             ASSIGN cb-dmov.impmn2  = cb-dmov.impmn2 + CcbDMvto.ImpTot
                    cb-dmov.impmn1  = cb-dmov.impmn1 + ROUND((CcbDMvto.ImpTot * cb-dmov.TpoCmb),2).
                    
          ASSIGN cb-cmov.DBEMN1  = cb-cmov.DBEMN1 + cb-dmov.impmn1
                 cb-cmov.DBEMN2  = cb-cmov.DBEMN2 + cb-dmov.impmn2.
                 
          RUN cbd/cb-acmd.p(RECID(cb-dmov), YES ,YES).
                 
          /* ********** CHEQUEAMOS SI GENERA DIFERENCIA DE CAMBIO ********** */
          IF AVAILABLE CcbCDocu THEN DO:
             IF CcbCDocu.CodMon = 2 THEN DO:
                F-IMPMN3 = cb-dmov.impmn1 - ROUND(cb-dmov.impmn2 * cb-cmov.Tpocmb,2).
                IF F-IMPMN3 <> 0 THEN DO:
                   cb-dmov.impmn3  = ABS(F-IMPMN3).
                   L-TpoMov = (IF F-IMPMN3 > 0 THEN YES ELSE NO).
                   RUN Genera-Diferencia-de-Cambio(1,L-TpoMov ).
                END.
             END.
             IF CcbCDocu.CodMon = 1 THEN DO:
                F-IMPMN3 = cb-dmov.impmn2 - ROUND(cb-dmov.impmn1 / cb-cmov.Tpocmb,2).
                IF F-IMPMN3 <> 0 THEN DO:
                   cb-dmov.impmn3  = ABS(F-IMPMN3).
                   L-TpoMov = (IF F-IMPMN3 > 0 THEN YES ELSE NO).
                   RUN Genera-Diferencia-de-Cambio(2,L-TpoMov).
                END.
             END.
          END.
          RELEASE cb-dmov.
       END.
   END.
   /* GENERAMOS DETALLE DE CUENTA DE CAJA */
   CREATE cb-dmov.
   ASSIGN cb-dmov.Codcia  = cb-cmov.Codcia 
          cb-dmov.Periodo = cb-cmov.Periodo 
          cb-dmov.Nromes  = cb-cmov.Nromes 
          cb-dmov.Codope  = cb-cmov.Codope 
          cb-dmov.Nroast  = cb-cmov.Nroast 
          cb-dmov.Codmon  = cb-cmov.Codmon 
          cb-dmov.CodDiv  = cb-cmov.CodDiv 
          cb-dmov.codcta  = B-CMVTO.CodCta 
          cb-dmov.tpomov  = YES
          cb-dmov.Tpocmb  = B-CMVTO.TpoCmb
          cb-dmov.glodoc  = 'Canc. cliente ' + B-CMVTO.Codcli
          cb-dmov.NroItm  = X-NroItm
          cb-dmov.clfaux  = ""
          cb-dmov.codaux  = B-CMVTO.CodCli
          cb-dmov.coddoc  = "CH"
          cb-dmov.TpoItm  = "B"
          cb-dmov.nrodoc  = B-CMVTO.NroRef
          cb-dmov.nroref  = CcbCMvto.Nrodoc.
   IF Cb-dmov.CodMon = 1 THEN
      ASSIGN cb-dmov.impmn1  = B-CMVTO.ImpTot
             cb-dmov.impmn2  = ROUND((B-CMVTO.ImpTot / B-CMVTO.TpoCmb),2).
   ELSE 
      ASSIGN cb-dmov.impmn2  = B-CMVTO.ImpTot
             cb-dmov.impmn1  = ROUND((B-CMVTO.ImpTot * B-CMVTO.TpoCmb),2).
             
   ASSIGN cb-cmov.HBEMN1 = cb-cmov.HBEMN1 + cb-dmov.impmn1
          cb-cmov.HBEMN2 = cb-cmov.HBEMN2 + cb-dmov.impmn2
          cb-cmov.Totitm = X-NroItm.
          
   /* ACTUALIZAMOS LA CUENTA CORRIENTE */
   FOR EACH CcbDMvto NO-LOCK WHERE 
            CcbDMvto.CodCia = B-CMVTO.CodCia AND 
            CcbDMvto.CodDoc = B-CMVTO.CodDoc AND 
            CcbDMvto.NroDoc = B-CMVTO.NroDoc : 
       FIND CcbCDocu WHERE 
            CcbCDocu.CodCia = CcbDMvto.CodCia AND
            CcbCDocu.CodDoc = CcbDMvto.CodRef AND 
            CcbCDocu.NroDoc = CcbDMvto.NroRef 
            EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE CcbCDocu THEN DO:
          CREATE CcbDCaja.
          ASSIGN CcbDCaja.CodCia = CcbDMvto.CodCia
                 CcbDCaja.CodDoc = B-CMVTO.CodDoc
                 CcbDCaja.NroDoc = B-CMVTO.NroDoc
                 CcbDCaja.CodCli = B-CMVTO.CodCli
                 CcbDCaja.CodMon = CcbCDocu.CodMon
                 CcbDCaja.FchCbd = B-CMVTO.FchDoc
                 CcbDCaja.FchDoc = B-CMVTO.FchDoc
                 CcbDCaja.TpoCmb = B-CMVTO.TpoCmb
                 CcbDCaja.FlgCbd = YES
                 CcbDCaja.CodRef = CcbDMvto.CodRef
                 CcbDCaja.NroRef = CcbDMvto.NroRef
                 CcbDCaja.ImpTot = CcbDMvto.ImpTot.
          IF CcbCDocu.CodMon <> B-CMVTO.CodMon THEN DO:
             IF CcbCDocu.CodMon = 1 THEN 
                  ASSIGN CcbDCaja.ImpTot = ROUND( CcbDCaja.ImpTot * B-CMVTO.TpoCmb , 2 ).
             ELSE ASSIGN CcbDCaja.ImpTot = ROUND( CcbDCaja.ImpTot / B-CMVTO.TpoCmb , 2 ).
          END.
          ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CcbDCaja.ImpTot.
          IF CcbCDocu.SdoAct <= 0 THEN ASSIGN CcbCDocu.FlgEst = "C".
          RELEASE CcbDCaja.
       END.
       RELEASE CcbCDocu.
   END.
   RELEASE B-CMVTO.
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
FIND B-CMVTO WHERE 
     B-CMVTO.codcia = CcbCMvto.codcia AND
     B-CMVTO.Coddoc = CcbCMvto.coddoc AND
     B-CMVTO.NroDoc = CcbCMvto.nrodoc EXCLUSIVE-LOCK NO-ERROR.
     
IF AVAILABLE B-CMVTO THEN DO:
   ASSIGN  B-CMVTO.ImpDoc = 0
           B-CMVTO.ImpTot = 0.
   FOR EACH MVTO BREAK BY MVTO.CodDoc BY MVTO.NroDoc:
       ASSIGN B-CMVTO.ImpDoc = B-CMVTO.ImpDoc + MVTO.ImpTot
              B-CMVTO.ImpTot = B-CMVTO.ImpTot + MVTO.ImpTot.
   END.
END.
RELEASE B-CMVTO.
   
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
  DO WITH FRAME {&FRAME-NAME}:
     CB-NomOpe:SCREEN-VALUE  = ENTRY(1,CB-NomOpe:LIST-ITEMS).
     C-CTACJA = ENTRY(1,C-CTAOPER).
     X-CODOPE = SUBSTRING(CB-NomOpe:SCREEN-VALUE,1,3).
     
     FIND CB-CTAS WHERE 
          CB-CTAS.CODCIA = CB-CODCIA AND
          CB-CTAS.CODCTA = C-CTACJA NO-LOCK NO-ERROR.
     IF AVAILABLE CB-CTAS THEN S-CODMON = CB-CTAS.CODMON.
     CcbCMvto.CodMon:SCREEN-VALUE = STRING(S-CODMON).
     
     DISPLAY TODAY    @ CcbCMvto.FchDoc
             S-CODDIV @ CcbCMvto.CodDiv
             ""       @ CcbCMvto.CodCli
             C-CTACJA @ CcbCMvto.CodCta
             ""       @ CcbCMvto.NroRef .
     CB-NomOpe:SENSITIVE = YES.
    CcbCMvto.NroRef:SENSITIVE  = (C-CTACJA BEGINS "104").
     FIND LAST gn-tcmb WHERE 
               gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN S-TPOCMB = gn-tcmb.venta.
     DISPLAY S-TPOCMB @ CcbCMvto.TpoCmb.
  END.
  
  RUN Actualiza-Deta.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse2').
  
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
  
  IF L-CREA THEN DO WITH FRAME {&FRAME-NAME}:
     FIND FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
     ASSIGN I-NroDoc = FacCorre.Correlativo.
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
     RELEASE FacCorre.
     ASSIGN CcbCMvto.CodCia  = S-CODCIA
            CcbCMvto.FlgEst  = "P"
            CcbCMvto.CodDoc  = S-CODDOC
            CcbCMvto.NroDoc  = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            CcbCMvto.usuario = S-USER-ID
            CcbCMvto.CodDiv  = S-CODDIV
            CcbCMvto.CodMon  = S-CODMON
            CcbCMvto.CodCta  = C-CTACJA
            CcbCMvto.CodOpe  = X-CODOPE
            CcbCMvto.FchDoc  = TODAY.
  END.
  RUN Borra-Documento. 
  RUN Genera-Detalle.
  RUN Graba-Totales.
  RUN Genera-Egreso-de-Caja.
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
  DO WITH FRAME {&FRAME-NAME}:
     CB-NomOpe:SENSITIVE = NO.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
---,--------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
   IF CcbCMvto.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      RUN Borra-Documento.   
      /* ACTUALIZAMOS LA CONTABILIDAD */
      FIND cb-cmov WHERE 
           cb-cmov.Codcia  = CcbCMvto.Codcia  AND
           cb-cmov.Periodo = YEAR(CcbCMvto.FchDoc) AND
           cb-cmov.Nromes  = CcbCMvto.Nromes  AND
           cb-cmov.Codope  = CcbCMvto.Codope  AND
           cb-cmov.Nroast  = CcbCMvto.Nroast EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE cb-cmov THEN DO:
         FOR EACH cb-dmov WHERE 
                  cb-dmov.Codcia  = cb-cmov.Codcia  AND
                  cb-dmov.Periodo = cb-cmov.Periodo AND
                  cb-dmov.Nromes  = cb-cmov.Nromes  AND 
                  cb-dmov.Codope  = cb-cmov.Codope  AND
                  cb-dmov.Nroast  = cb-cmov.Nroast :
             RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
             DELETE cb-dmov.
         END.
         ASSIGN cb-cmov.FlgEst = "A".
      END.
      RELEASE cb-cmov.
      /*  ACTUALIZAMOS LA CUENTA CORRIENTE */
      FOR EACH CcbDCaja EXCLUSIVE-LOCK WHERE 
               CcbDCaja.CodCia = CcbCMvto.Codcia AND
               CcbDCaja.CodDoc = CcbCMvto.CodDoc AND
               CcbDCaja.NroDoc = CcbCMvto.NroDoc:
          FIND CcbCDocu WHERE 
               CcbCDocu.CodCia = CcbDCaja.CodCia AND
               CcbCDocu.CodDoc = CcbDCaja.CodRef AND 
               CcbCDocu.NroDoc = CcbDCaja.NroRef 
               EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE CcbCDocu THEN DO:
             CcbCDocu.SdoAct = CcbCDocu.SdoAct + CcbDCaja.ImpTot.
             CcbCDocu.FlgEst = "P".
          END.
          RELEASE CcbCDocu.
          DELETE CcbDCaja.
      END.
      /* ANULAMOS EL MOVIMIENTO DE CAJA */                          
      FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CMVTO THEN 
         ASSIGN B-CMvto.FlgEst = "A"
                B-CMvto.Glosa  = '**** Documento Anulado ****'
                B-CMvto.ImpTot = 0
                B-CMvto.ImpDoc = 0.
      RELEASE B-CMVTO.
   END.
   RUN Procesa-Handle IN lh_Handle ('Browse').
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
  IF AVAILABLE CcbCMvto THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = 0 AND
          gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli. 
     CB-NomOpe = ENTRY(LOOKUP(CcbCMvto.CodCta,C-CTAOPER),CB-NomOpe:LIST-ITEMS).
     DISPLAY CB-NomOpe.
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
  DEFINE VARIABLE x-impletra AS CHARACTER FORMAT "X(100)".
  DEFINE VARIABLE x-debe     AS DECIMAL   FORMAT "(ZZZ,ZZZ,ZZ9.99)".
  DEFINE VARIABLE x-haber    AS DECIMAL   FORMAT "(ZZZ,ZZZ,ZZ9.99)".
  DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(60)".
  DEFINE VARIABLE C-MON      AS CHARACTER FORMAT "X(4)" .
  DEFINE VARIABLE C-CTACJA LIKE Cb-ctas.nomcta.
  DEFINE VARIABLE x-nomope LIKE Cb-oper.nomope.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  IF CCBCMVTO.FLGEST =  "A" THEN RETURN ERROR.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  FIND cb-cmov WHERE 
       cb-cmov.Codcia  = CcbCMvto.Codcia  AND
       cb-cmov.Periodo = YEAR(CcbCMvto.FchDoc) AND
       cb-cmov.Nromes  = CcbCMvto.Nromes  AND
       cb-cmov.Codope  = CcbCMvto.Codope  AND
       cb-cmov.Nroast  = CcbCMvto.Nroast NO-LOCK NO-ERROR.
  IF AVAILABLE cb-cmov THEN DO:
      
      C-MON =  IF cb-cmov.codmon = 1 THEN "S/." ELSE "US$".
      
      RUN bin/_numero.p ( cb-cmov.impchq,2,1, OUTPUT x-impletra ).
      IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES".
      ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".
      
      C-CTACJA = "".
      FIND cb-ctas WHERE 
           cb-ctas.codcia = 0 AND
           cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
      IF avail cb-ctas THEN C-CTACJA = cb-ctas.nomcta.
          
      DEFINE FRAME F-Egreso
          "   "
          cb-dmov.coddiv LABEL "Divisi¢n"
          cb-dmov.codcta LABEL "Cuenta"
          cb-dmov.clfaux LABEL "Clf!Aux"
          cb-dmov.codaux LABEL "Auxiliar"
          cb-dmov.nroref LABEL "Referencia"
          cb-dmov.coddoc LABEL "Cod"
          cb-dmov.nrodoc LABEL "Nro!Documento"
          x-glodoc       LABEL "Detalle"
          x-debe         LABEL "Cargos"
          x-haber        LABEL "Abonos"
          HEADER 
          {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
          x-nomope "VOUCHER No: " AT 60  cb-cmov.codope "-" cb-cmov.nroast SKIP(17)
          C-MON  AT 63 cb-cmov.impchq FORMAT "**********9.99" SKIP(3)
          "PAGADO A   : " cb-cmov.girado SKIP
          "DOCUMENTO  : " cb-cmov.coddoc  cb-cmov.nrochq SKIP
          "CUENTA     : " C-CTACJA       SKIP
          "CONCEPTO   : " cb-cmov.notast FORMAT 'X(40)'      '---------------------' AT 62 SKIP
          "T.CAMBIO   : " cb-cmov.tpocmb FORMAT "ZZZ9.9999"     'RECIBI CONFORME'    AT 65 SKIP
          "FECHA      : " cb-cmov.fchast                        ' L.E.          '    AT 65 SKIP
          {&PRN4} SKIP
          FILL("_",160) FORMAT "X(160)" SKIP
          WITH WIDTH 160 NO-BOX STREAM-IO DOWN.
          
      OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. 
      PUT STREAM report CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN4}. 
      
      FOR EACH cb-dmov NO-LOCK WHERE 
               cb-dmov.codcia  = cb-cmov.codcia  AND  
               cb-dmov.periodo = cb-cmov.periodo AND 
               cb-dmov.nromes  = cb-cmov.NroMes  AND 
               cb-dmov.codope  = cb-cmov.codope  AND 
               cb-dmov.nroast  = cb-cmov.nroast
               BREAK BY (cb-dmov.nroast) 
               ON ERROR UNDO, LEAVE:
          
          IF CB-DMOV.TpoItm = "A" THEN NEXT.
          
          x-glodoc = FILL-IN_NomCli.
          
          IF cb-cmov.codmon = 2 THEN DO:
             SUBSTR(x-glodoc,( 55 - LENGTH(STRING(cb-dmov.ImpMn2)) ),51) = "(US$" + STRING(cb-dmov.ImpMn2) + ")".
          END.
          x-debe  = 0.
          x-haber = 0.
          IF cb-dmov.tpomov THEN  x-haber = ImpMn1.
          IF NOT cb-dmov.tpomov THEN  x-debe  = ImpMn1.
          IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
             ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
             ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
             DISPLAY STREAM report 
                      cb-dmov.coddiv
                      cb-dmov.codcta
                      cb-dmov.clfaux
                      cb-dmov.codaux
                      cb-dmov.nroref
                      cb-dmov.coddoc
                      cb-dmov.nrodoc
                      x-glodoc
                      x-debe   WHEN (x-debe  <> 0)
                      x-haber  WHEN (x-haber <> 0) 
                      WITH FRAME F-Egreso.
          END.
          IF LAST-OF (cb-dmov.nroast) THEN DO:
              x-glodoc = "                    TOTALES :".
              IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report) THEN PAGE stream report.
              DOWN STREAM report 1 WITH FRAME F-Egreso.
              UNDERLINE STREAM report 
                                x-glodoc
                                x-debe 
                                x-haber
                         WITH FRAME F-Egreso.    
              DOWN STREAM report with frame F-Egreso.
              DISPLAY STREAM report x-glodoc
                      ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                      ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                  WITH FRAME F-Egreso.
          END.
      END.
      PUT STREAM report CONTROL CHR(18) CHR(27) CHR(77).
      PUT STREAM report CONTROL CHR(27) CHR(71).
      PUT STREAM report "SON : " x-impletra SKIP.
      DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
          PUT STREAM report "" skip.
      END.
      PUT STREAM report "-----------------       -----------------        ----------------- "  AT 18 SKIP.
      PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia   "  AT 18 SKIP.
      PUT STREAM report CONTROL CHR(27) CHR(72).
      PAGE stream report.
      OUTPUT STREAM REPORT CLOSE.
  END.
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
     CB-NomOpe:LIST-ITEMS = C-NOMOPER.
     CB-NomOpe = ENTRY(1,C-NOMOPER).
     CB-NomOpe:SENSITIVE = NO.
     C-CTACJA = ENTRY(1,C-CTAOPER).
     X-CODOPE = SUBSTRING(CB-NomOpe,1,3).
     FIND CB-CTAS WHERE 
          CB-CTAS.CODCIA = CB-CODCIA AND
          CB-CTAS.CODCTA = C-CTACJA NO-LOCK NO-ERROR.
     IF AVAILABLE CB-CTAS THEN S-CODMON = CB-CTAS.CODMON.
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
  DO WITH FRAME {&FRAME-NAME}:
     CB-NomOpe:SENSITIVE = NO.
  END.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCMvto"}

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
DEFINE VAR I-Nro AS INTEGER INIT 0 NO-UNDO .
FOR EACH MVTO:
    I-Nro = I-Nro + 1.
END.
IF I-Nro = 0 THEN DO:
   MESSAGE 'No existen items a generar' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
RETURN 'ADM-ERROR'.   /* No debe permitir realizar modificaciones  */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Anulacion V-table-Win 
PROCEDURE Verifica-Anulacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR s-resp AS CHAR NO-UNDO.
s-resp = ''.

FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia AND
    CcbCDocu.CodRef = CcbCMvto.CodDoc AND
    CcbCDocu.NroRef = CcbCMvto.NroDoc:
    IF CcbCDocu.FlgEst <> 'P' OR CcbCDocu.FlgUbi <> 'C' OR
       CcbCDocu.SdoAct <> CcbCDocu.ImpTot THEN DO:
       s-resp = 'No'.
       LEAVE.
    END. 
END.
IF s-resp = 'No' THEN DO:
   MESSAGE 'Las letras registras amortizaciones' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


