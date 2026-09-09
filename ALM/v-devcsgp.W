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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.
DEFINE        VAR F-ESTADO AS CHAR NO-UNDO.

DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE        VAR S-ITEM   AS INTEGER INIT 0.
DEFINE        VAR F-DIRTRA AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-RUCTRA AS CHAR FORMAT "X(8)"  INIT "". 
DEFINE        VAR F-DESCRI AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR F-EMISO1 AS CHAR FORMAT "X(12)" INIT "".
DEFINE        VAR F-EMISO2 AS CHAR FORMAT "X(12)" INIT "".
DEFINE        VAR C-RUCREF AS CHAR FORMAT "X(12)"  INIT "".
DEFINE        VAR C-DESALM AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRPRO AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRALM AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR F-NOMPRO AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR S-TOTPES AS DECIMAL.

DEFINE STREAM Reporte.
DEFINE VAR W-REFERENCIA AS CHAR INIT "DEVOLUCION".

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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.NroRf1 Almcmov.CodPro Almcmov.CodMon ~
Almcmov.Observ Almcmov.NroRf2 Almcmov.CodTra 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroRf1 Almcmov.FchDoc ~
Almcmov.CodPro Almcmov.CodMon Almcmov.Observ Almcmov.NroRf2 Almcmov.CodTra 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc F-STATUS FILL-IN-NomPro 

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
DEFINE VARIABLE F-STATUS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     FONT 0.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.96.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.72 BY .73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroDoc AT ROW 1.23 COL 13 COLON-ALIGNED
     F-STATUS AT ROW 1.23 COL 71.57 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf1 AT ROW 1.92 COL 13 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.FchDoc AT ROW 1.92 COL 74 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     Almcmov.CodPro AT ROW 2.65 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomPro AT ROW 2.65 COL 24.14 COLON-ALIGNED NO-LABEL
     Almcmov.CodMon AT ROW 2.73 COL 76.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .58
     Almcmov.Observ AT ROW 3.38 COL 13 COLON-ALIGNED FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .69
     Almcmov.NroRf2 AT ROW 3.38 COL 74 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.CodTra AT ROW 4.12 COL 13 COLON-ALIGNED
          LABEL "Transportista"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 2.73 COL 69
     RECT-3 AT ROW 1.04 COL 1
     RECT-4 AT ROW 2.65 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov,integral.Almtdocm
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
         HEIGHT             = 4
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN Almcmov.CodTra IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-STATUS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME Almcmov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodPro V-table-Win
ON LEAVE OF Almcmov.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF Almcmov.CodPro:VISIBLE THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = pv-CODCIA AND 
             gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN 
        DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodTra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodTra V-table-Win
ON LEAVE OF Almcmov.CodTra IN FRAME F-Main /* Transportista */
DO:

  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AdmRutas WHERE AdmRutas.CodPro = Almcmov.CodTra:SCREEN-VALUE
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AdmRutas THEN DO:
     MESSAGE " Código de Transportista no existe " VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
/*F-NomTra:SCREEN-VALUE = AdmRutas.NomTra.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle-Orden-Compra V-table-Win 
PROCEDURE Actualiza-Detalle-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER I-Factor AS INTEGER.
  FOR EACH Almdmov NO-LOCK WHERE 
           Almdmov.CodCia = Almcmov.CodCia AND
           Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND
           Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc
      ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND LG-DOCmp WHERE 
           LG-DOCmp.CodCia = Almdmov.CodCia AND
           LG-DOCmp.CodDiv = s-CodDiv AND
           LG-DOCmp.TpoDoc = "N"            AND
           LG-DOCmp.NroDoc = INTEGER(Almcmov.NroRf1) AND
           LG-DOCmp.Codmat = Almdmov.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE LG-DOCmp THEN 
         LG-DOCmp.CanAten = LG-DOCmp.CanAten + (Almdmov.CanDes * I-Factor).
      RELEASE LG-DOCmp.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ITEM V-table-Win 
PROCEDURE Actualiza-ITEM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ITEM:
    DELETE ITEM.
END.
IF NOT L-CREA THEN DO:
   FOR EACH Almdmov OF Almcmov NO-LOCK :
       CREATE ITEM.
       ASSIGN ITEM.CodCia    = Almdmov.CodCia 
              ITEM.CodAlm    = Almdmov.CodAlm 
              ITEM.codmat    = Almdmov.codmat 
              ITEM.PreUni    = Almdmov.PreUni 
              ITEM.CanDes    = Almdmov.CanDes 
              ITEM.CanDev    = Almdmov.CanDes 
              ITEM.Factor    = Almdmov.Factor 
              ITEM.CodUnd    = Almdmov.CodUnd 
              ITEM.ImpCto    = Almdmov.ImpCto 
              ITEM.PreLis    = Almdmov.PreLis 
              ITEM.Dsctos[1] = Almdmov.Dsctos[1] 
              ITEM.Dsctos[2] = Almdmov.Dsctos[2] 
              ITEM.Dsctos[3] = Almdmov.Dsctos[3] 
              ITEM.IgvMat    = Almdmov.IgvMat.
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
  {src/adm/template/row-list.i "Almcmov"}
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Compra V-table-Win 
PROCEDURE Asigna-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

input-var-1 = "G,A,X,V".  /* que LG-COCmp.FlgSit sea diferente de 'G' 0 'A' */

RUN LKUP\C-OCSGPEN("Consignaciones Pendientes").

IF output-var-1 = ? THEN RETURN.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM:
    DELETE ITEM.
END.
FIND LG-COCmp WHERE ROWID(LG-COCmp) = output-var-1 NO-LOCK NO-ERROR.
IF AVAILABLE LG-COCmp THEN DO WITH FRAME {&FRAME-NAME}:
   
   DISPLAY LG-COCmp.NroDoc @ Almcmov.NroRf1 
           LG-COCmp.CodPro @ Almcmov.CodPro 
           LG-COCmp.Observaciones @ Almcmov.Observ.
   Almcmov.CodMon:SCREEN-VALUE = STRING(LG-COCmp.Codmon).
   FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
        gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro.
   
   FOR EACH LG-DOCmp NO-LOCK WHERE
            LG-DOCmp.CodCia = LG-COCmp.CodCia AND
            LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc AND
            LG-DOCmp.NroDoc = LG-COCmp.NroDoc AND
            LG-DOCmp.CanAten > 0 :
       FIND ITEM WHERE ITEM.Codcia  = S-CODCIA AND
            ITEM.CodAlm = S-CODALM AND
            ITEM.CodMat = LG-DOCmp.Codmat NO-ERROR.
       IF NOT AVAILABLE ITEM THEN CREATE ITEM.
       ASSIGN ITEM.CodCia = S-CODCIA
              ITEM.CodAlm = S-CODALM
              ITEM.Codmat = LG-DOCmp.Codmat 
              ITEM.CodUnd = LG-DOCmp.UndCmp
              ITEM.CanDes = LG-DOCmp.CanAten
              ITEM.CanDev = LG-DOCmp.CanAten
              ITEM.PreLis = LG-DOCmp.PreUni
              ITEM.Dsctos[1] = LG-DOCmp.Dsctos[1]
              ITEM.Dsctos[2] = LG-DOCmp.Dsctos[2]
              ITEM.Dsctos[3] = LG-DOCmp.Dsctos[3]
              ITEM.IgvMat = LG-DOCmp.IgvMat
              ITEM.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                            (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                            (1 - (LG-DOCmp.Dsctos[3] / 100)),4)
              ITEM.ImpCto = ROUND(ITEM.CanDes * ITEM.PreUni,2).
       FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
            Almmmatg.codmat = ITEM.codmat  NO-LOCK NO-ERROR.
       FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
            Almtconv.Codalter = ITEM.CodUnd NO-LOCK NO-ERROR.
       ITEM.Factor = Almtconv.Equival / Almmmatg.FacEqu.
   END.
   RUN Procesa-Handle IN lh_Handle ('browse').
END.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    ASSIGN R-ROWID = ROWID(Almdmov).
    /* RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen */ */
    RUN alm/almacstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN ALM\ALMACPR1 (R-ROWID,"D").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* RHC 06.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
    RUN ALM\ALMACPR2 (R-ROWID,"D").
    *************************************************** */
    DELETE Almdmov.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH ITEM WHERE ITEM.codmat <> "" ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE almdmov.
       ASSIGN Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.CodMov = Almcmov.CodMov 
              Almdmov.NroSer = Almcmov.NroSer 
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb
              Almdmov.codmat = ITEM.codmat
              Almdmov.CanDes = ITEM.CanDes
              Almdmov.CodUnd = ITEM.CodUnd
              Almdmov.Factor = ITEM.Factor
              Almdmov.PreUni = ITEM.PreUni
              Almdmov.ImpCto = ROUND(ITEM.CanDes * ITEM.PreUni,2)
              Almdmov.PreLis = ITEM.PreLis
              Almdmov.Dsctos[1] = ITEM.Dsctos[1]
              Almdmov.Dsctos[2] = ITEM.Dsctos[2]
              Almdmov.Dsctos[3] = ITEM.Dsctos[3]
              Almdmov.IgvMat = ITEM.IgvMat
              Almdmov.CodAjt = ' '
              Almdmov.HraDoc = Almcmov.HorRcp
                     R-ROWID = ROWID(Almdmov).
       /* RUN ALM\ALMDGSTK (R-ROWID). */
       RUN alm/almdcstk (R-ROWID).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       /* RHC 06.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       *************************************************** */
       
       IF AlmDMov.CodMon = 1 THEN DO:
            Almcmov.ImpIgv  = Almcmov.ImpIgv  + ROUND(AlmDMov.ImpCto * Almdmov.IgvMat / 100 ,2).
            ASSIGN Almcmov.ImpMn1  = Almcmov.ImpMn1 + AlmDMov.ImpCto.
            IF AlmDMov.TpoCmb > 0 THEN 
               ASSIGN  Almcmov.ImpMn2  = Almcmov.ImpMn2 + ROUND(AlmDMov.ImpCto / AlmDMov.TpoCmb,2).
         END.
       ELSE  DO:
         ASSIGN Almcmov.ImpMn1  = Almcmov.ImpMn1 + ROUND(AlmDMov.ImpCto * AlmDMov.TpoCmb,2)
                Almcmov.ImpMn2  = Almcmov.ImpMn2 + AlmDMov.ImpCto
                Almcmov.ImpIgv  = Almcmov.ImpIgv  + ROUND(AlmDMov.ImpCto * AlmDMov.TpoCmb * Almdmov.IgvMat / 100 ,2).
       END.
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
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = "G/R" AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN 
        FILL-IN_NroDoc:SCREEN-VALUE = STRING(S-NROSER,"999") +  STRING(FacCorre.Correlativo,"999999").
     DISPLAY TODAY @ Almcmov.FchDoc.
     Almcmov.NroRf1:SENSITIVE = NO.
     Almcmov.CodMon:SENSITIVE = NO.
  END.
  RUN Actualiza-ITEM.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').
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
  IF L-CREA THEN DO:
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
            Almcmov.CodAlm  = Almtdocm.CodAlm 
            Almcmov.TipMov  = Almtdocm.TipMov 
            Almcmov.CodMov  = Almtdocm.CodMov 
            Almcmov.NroSer = S-NROSER
            Almcmov.FchDoc  = TODAY 
            Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
            Almcmov.NomRef  = Fill-in-nompro:screen-value in frame {&FRAME-NAME}.
     FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Almcmov.FchDoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN Almcmov.TpoCmb = gn-tcmb.venta.
            
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = "G/R" AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
        Almcmov.NroDoc = FacCorre.Correlativo.
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
     RELEASE FacCorre.
     FILL-IN_NroDoc = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999").
     DISPLAY FILL-IN_NroDoc WITH FRAME {&FRAME-NAME}.
  END.
  ASSIGN Almcmov.usuario = S-USER-ID
         Almcmov.ImpIgv  = 0
         Almcmov.ImpMn1  = 0
         Almcmov.ImpMn2  = 0.
  
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
     RUN Actualiza-Detalle-Orden-Compra(1).
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Actualiza-Detalle-Orden-Compra(-1).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
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
   RUN valida-update.
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.

  /* Eliminamos el detalle */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     RUN Actualiza-Detalle-Orden-Compra(1).
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     /* Solo marcamos el FlgEst como Anulado */
     FIND CMOV WHERE 
          CMOV.CodCia = Almcmov.CodCia AND
          CMOV.CodAlm = Almcmov.CodAlm AND
          CMOV.TipMov = Almcmov.TipMov AND
          CMOV.CodMov = Almcmov.CodMov AND
          CMOV.NroSer = Almcmov.NroSer AND
          CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
     ASSIGN CMOV.FlgEst = 'A'
            CMOV.Observ = "      A   N   U   L   A   D   O       "
            CMOV.Usuario = S-USER-ID.
     RELEASE CMOV.
  END.

  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
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

  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  FIND FIRST Almtmovm WHERE
             Almtmovm.CodCia = Almtdocm.CodCia AND
             Almtmovm.Tipmov = Almtdocm.TipMov AND 
             Almtmovm.Codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN Almcmov.CodPro:VISIBLE = Almtmovm.PidPro
            Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
            Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
                          I-CODMON = Almtmovm.CodMon.
     IF Almtmovm.CodMon <> 3 THEN DO:
        ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
     END.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
     IF Almtdocm.TipMov = "S" THEN DO:
        ASSIGN Almcmov.CodMon:SCREEN-VALUE = '1'.
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_NroDoc:SCREEN-VALUE = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999").
     IF Almcmov.CodPro:VISIBLE THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
                           gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
        ELSE DO:
             FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                  gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
             IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
        END.
     END.
     CASE Almcmov.FlgEst:
          WHEN "A" THEN DISPLAY "ANULADO" @ F-Status WITH FRAME {&FRAME-NAME}.
          WHEN "D" THEN DISPLAY "DESACTIVADO" @ F-Status WITH FRAME {&FRAME-NAME}.
          WHEN ""  THEN DISPLAY "ACTIVO" @ F-Status WITH FRAME {&FRAME-NAME}.
     END CASE.          
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

  IF AlmCmov.FlgEst <> "A" THEN RUN ALM\R-ImpConv.R(ROWID(Almcmov)).

/*
IF AVAILABLE Almcmov AND Almcmov.FlgEst <> "A" THEN DO :
     
   S-ITEM = 0.    
   FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia AND
        Almacen.CodAlm = Almcmov.CodAlm NO-LOCK NO-ERROR.
  
   IF AVAILABLE Almacen THEN DO:
      C-DIRPRO = Almacen.Descripcion.
   END. 
  
   FIND GN-PROV WHERE GN-PROV.Codcia = 0 AND 
                       gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
     
   IF AVAILABLE GN-PROV THEN DO:
        F-DESCRI = gn-prov.NomPro.   
        C-DIRALM = gn-prov.DirPro.   
        C-RUCREF = gn-prov.Ruc.
   END.  

   FIND GN-PROV WHERE GN-PROV.Codcia = 0 AND 
                      gn-prov.CodPro = Almcmov.CodTra NO-LOCK NO-ERROR.
   IF AVAILABLE GN-PROV THEN DO:
      F-NomPro = gn-prov.NomPro.   
      F-DIRTRA = gn-prov.DirPro. 
      F-RUCTRA = gn-prov.Ruc.
   END.
    
  DEFINE FRAME F-FMT
         S-Item             AT  1   FORMAT "ZZ9"
         Almdmov.CodMat     AT  6   FORMAT "X(8)"
         Almmmatg.DesMat    AT  18  FORMAT "X(50)"
         Almmmatg.Desmar    AT  70  FORMAT "X(20)"
         Almdmov.CanDes     AT  92  FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     AT  103 FORMAT "X(4)"          
         HEADER
         SKIP(9)
         F-DESCRI AT 15 FORMAT "X(60)"  Almcmov.FchDoc AT 106 SKIP
         C-DIRALM AT 15 FORMAT "X(60)"  Almcmov.NroRf1 AT 106 SKIP
         C-RUCREF AT 15 FORMAT "X(12)"  SKIP
         {&PRN2} + {&PRN7A} + {&PRN6A} + W-REFERENCIA + {&PRN7B} + {&PRN3} + {&PRN6B} AT 90 FORMAT "X(40)"
         {&PRND} + Almcmov.Observ + {&PRN6B} AT 15 FORMAT "X(55)"  
         " Partida : " + C-DIRPRO AT 75 FORMAT "X(60)" SKIP(2)
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
         
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 60.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           S-TOTPES = S-TOTPES + ( Almdmov.Candes * Almmmatg.Pesmat ).
           S-Item = S-Item + 1.
           DISPLAY STREAM Reporte 
                   S-Item 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.DesMat 
                   Almmmatg.Desmar WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte f-nompro  AT 15 "X" AT 80 SKIP.
  PUT STREAM Reporte f-dirtra  AT 15 SKIP.
  PUT STREAM Reporte f-ructra  AT 15 SKIP.
  PUT STREAM Reporte f-emiso1  AT 93 SKIP.
  PUT STREAM Reporte f-emiso2  AT 93 SKIP(1).
  PUT STREAM Reporte "HORA : " + STRING(TIME,"HH:MM:SS") AT 1 FORMAT "X(20)" 
  "TOTAL KILOS :" AT 30 S-TOTPES AT 44 FORMAT ">>,>>9.99" 
  " ** ALMACEN ** " AT 100 SKIP.
  OUTPUT STREAM Reporte CLOSE.

END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
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
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "Almtdocm"}

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

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     Almcmov.NroRf1:SENSITIVE = NO.
     Almcmov.CodMon:SENSITIVE = NO.
     L-CREA = NO.
     RUN Actualiza-ITEM.
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
DEFINE VARIABLE F-CANT AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-ASIG AS LOGICAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
   IF Almcmov.CodPro:VISIBLE THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia  AND
              gn-prov.CodPro = Almcmov.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Almcmov.CodPro.
            RETURN "ADM-ERROR".   
         END.
   END.
   /* CONSISTENCIA DE LA GUIA DE REMISION DEL PROVEEDOR */
   IF Almcmov.NroRf2:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Digite el Nro. de Guia" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf2.
      RETURN "ADM-ERROR".
   END.
   FIND LAST CMOV WHERE cmov.codcia = s-codcia
        AND cmov.codalm = s-codalm
        AND cmov.tipmov = 'I'
        AND cmov.codmov = almtmovm.codmov
        AND cmov.codpro = almcmov.codpro:SCREEN-VALUE
        AND cmov.nrorf2 = almcmov.nrorf2:SCREEN-VALUE 
        AND cmov.flgest <> 'A'
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almcmov THEN DO:
      MESSAGE "Guia de Remisión del Proveedor no registrada" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf2.
      RETURN "ADM-ERROR".
   END.
   
   F-CANT = 0. 
   L-ASIG = YES.
   FOR EACH ITEM:
       F-CANT = F-CANT + ITEM.CanDes.
       FIND Almmmate WHERE
            Almmmate.CodCia = S-CODCIA AND
            Almmmate.CodAlm = S-CODALM AND
            Almmmate.codmat = ITEM.CodMat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          L-ASIG = NO.
          LEAVE.
       END.
   END.
   IF NOT L-ASIG THEN DO:
      MESSAGE "Existen articulos no asignados al almacen" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.Observ.
      RETURN "ADM-ERROR".   
   END.
   IF F-CANT = 0 THEN DO:
      MESSAGE "No existen ITEMS por procesar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.Observ.
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
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE Almcmov THEN DO:
   MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF Almcmov.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

    /*FIND AlmCierr WHERE 
     *      AlmCierr.CodCia = S-CODCIA AND 
     *      AlmCierr.FchCie = Almcmov.FchDoc 
     *      NO-LOCK NO-ERROR.
     * IF AVAILABLE AlmCierr AND
     *    AlmCierr.FlgCie THEN DO:
     *    MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
     *            "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
     *    RETURN "ADM-ERROR".
     * END.*/
    RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND
     Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

