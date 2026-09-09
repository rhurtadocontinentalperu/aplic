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
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.
DEFINE        VAR F-ESTADO AS CHAR NO-UNDO.
DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE STREAM Reporte-PESO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

DEFINE VAR X-Actpeso AS LOGICAL NO-UNDO.
DEFINE VAR I         AS INTEGER NO-UNDO.
DEFINE VAR x-nrogui  AS CHAR    NO-UNDO.
DEFINE VAR x-pesmat  AS DECIMAL NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS Almcmov.CodPro Almcmov.Observ Almcmov.FchDoc ~
Almcmov.TpoCmb Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.NroFac Almcmov.CodMon 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.CodPro ~
Almcmov.Observ Almcmov.FchDoc Almcmov.TpoCmb Almcmov.NroRf1 Almcmov.NroRf2 ~
Almcmov.NroFac Almcmov.CodMon 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-STATUS FILL-IN-NomPro 

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
     SIZE 13.43 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.86 BY 4.04.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.72 BY .77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1.27 COL 13 COLON-ALIGNED
          LABEL "No. Ingreso"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          FONT 0
     F-STATUS AT ROW 1.27 COL 67.86 COLON-ALIGNED NO-LABEL
     Almcmov.CodPro AT ROW 2.04 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomPro AT ROW 2.04 COL 24.14 COLON-ALIGNED NO-LABEL
     Almcmov.Observ AT ROW 2.73 COL 13 COLON-ALIGNED FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 43.29 BY .69
     Almcmov.FchDoc AT ROW 1.92 COL 68 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     Almcmov.TpoCmb AT ROW 3.46 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     Almcmov.NroRf1 AT ROW 3.46 COL 13 COLON-ALIGNED
          LABEL "Guia Ing.Consig." FORMAT "x(150)"
          VIEW-AS FILL-IN 
          SIZE 43.14 BY .69
     Almcmov.NroRf2 AT ROW 4.19 COL 13 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     Almcmov.NroFac AT ROW 4.19 COL 42.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .69
     Almcmov.CodMon AT ROW 2.73 COL 70.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.43 BY .58
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 2.73 COL 63.29
     RECT-3 AT ROW 1 COL 1
     RECT-4 AT ROW 2.65 COL 70
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
         HEIGHT             = 4.04
         WIDTH              = 83.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-STATUS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME Almcmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodMon V-table-Win
ON ENTRY OF Almcmov.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF I-CODMON <> 3 THEN DO:
     ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(I-CODMON,'9').
     APPLY "ENTRY" TO Almcmov.TpoCmb.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodPro V-table-Win
ON LEAVE OF Almcmov.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF Almcmov.CodPro:VISIBLE THEN DO:
          FIND gn-prov WHERE 
               gn-prov.CodCia = pv-codcia AND 
               gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.FchDoc V-table-Win
ON LEAVE OF Almcmov.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT Almcmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.venta @ Almcmov.TpoCmb WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf1 V-table-Win
ON LEAVE OF Almcmov.NroRf1 IN FRAME F-Main /* Guia Ing.Consig. */
DO:
  DO WITH FRAME {&FRAME-NAME}:  
     x-nrogui = SELF:SCREEN-VALUE.
     DO I = 1 TO NUM-ENTRIES(x-nrogui):
        FIND CMOV WHERE 
             CMOV.codcia = s-codcia AND 
             CMOV.Codalm = s-codalm AND 
             CMOV.Tipmov = 'I'      AND 
             CMOV.Codmov = 90       AND 
             CMOV.Nrorf2 = ENTRY(i,x-nrogui) AND 
             CMOV.Codpro = Almcmov.CodPro:SCREEN-VALUE AND 
             CMOV.Flgest <> 'A' 
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CMOV THEN DO:
           MESSAGE 'Guia de Remision ' + ENTRY(i,x-nrogui) + ' no existe' VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY':U TO SELF.
           RETURN NO-APPLY.
        END.
     END.
     RUN Graba-Datos.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf2 V-table-Win
ON LEAVE OF Almcmov.NroRf2 IN FRAME F-Main /* Referencia 2 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> ' ' THEN DO:
        FIND FIRST CMov WHERE CMov.codcia = s-codcia AND
             CMov.Codpro = integral.Almcmov.CodPro:SCREEN-VALUE AND 
             CMov.NroRf2 = SELF:SCREEN-VALUE AND
             CMov.Flgest <> 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE CMov THEN DO:
           IF L-CREA = No THEN  DO:
              IF CMov.Nrodoc = Almcmov.Nrodoc THEN DO:
                 MESSAGE 'Numero de Guia se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
                 APPLY 'ENTRY':U TO SELF.
                 RETURN NO-APPLY.
              END.
              END.
           ELSE DO:
              MESSAGE 'Numero de Guia se encuentra registrada' SKIP
                      '      Documento  ' + STRING(CMov.Codmov,'99') + '-' STRING(Cmov.Nrodoc,'999999') VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO SELF.
              RETURN NO-APPLY.
           END.
        END.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.TpoCmb V-table-Win
ON ENTRY OF Almcmov.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
/*  Almcmov.TpoCmb:SENSITIVE = NO.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Guias-Consignacion V-table-Win 
PROCEDURE Actualiza-Guias-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ITEM:
      FIND CMOV WHERE 
           CMOV.codcia = s-codcia AND
           CMOV.codalm = s-codalm AND 
           CMOV.tipmov = 'I'      AND
           CMOV.codmov = 90       AND 
           CMOV.nrorf2 = ITEM.Codant NO-ERROR.
      IF AVAILABLE CMOV THEN DO:
         IF MONTH(Almcmov.fchdoc) = 12 THEN 
            ASSIGN CMOV.Fchdoc = DATE(01,01, YEAR(Almcmov.fchdoc) + 1).
         ELSE
            ASSIGN CMOV.Fchdoc = DATE(MONTH(Almcmov.fchdoc) + 1, 01, YEAR(Almcmov.fchdoc)).
         FOR EACH Almdmov OF CMOV :
             ASSIGN R-ROWID = ROWID(Almdmov).
             RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
             
             ASSIGN Almdmov.fchdoc = CMOV.fchdoc
                    R-ROWID = ROWID(Almdmov).
             IF Almdmov.codmat = ITEM.codmat THEN
                ASSIGN Almdmov.candes = Almdmov.candes - ITEM.candes.
                 
             IF Almdmov.candes = 0 THEN DELETE Almdmov.
             ELSE DO:
                  RUN ALM\ALMACSTK (R-ROWID). 
             END.
         END.
      END.
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
              ITEM.Pesmat    = Almdmov.Pesmat
              ITEM.ImpCto    = Almdmov.ImpCto 
              ITEM.PreLis    = Almdmov.PreLis 
              ITEM.Dsctos[1] = Almdmov.Dsctos[1] 
              ITEM.Dsctos[2] = Almdmov.Dsctos[2] 
              ITEM.Dsctos[3] = Almdmov.Dsctos[3] 
              ITEM.IgvMat    = Almdmov.IgvMat
              ITEM.Fchdoc    = Almdmov.Fchdoc
              ITEM.codant    = Almdmov.Codant.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias V-table-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
Almcmov.NroRf1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

input-var-1 = s-codalm.
input-var-2 = 'I'.
input-var-3 = '90'.

RUN LKUP\C-MOVCMP("Ingresos de Consignación").

IF output-var-1 = ? THEN RETURN.
x-nrogui = output-var-2.
DO WITH FRAME {&FRAME-NAME}:
   Almcmov.CodPro:SCREEN-VALUE = output-var-3.
   APPLY "LEAVE":U TO Almcmov.CodPro.
END.
RUN Graba-Datos.

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
  FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK
      ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
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
   DEFINE VAR F-PesUnd AS DECIMAL NO-UNDO.

   FOR EACH ITEM WHERE ITEM.codmat <> ""
       ON ERROR UNDO, RETURN "ADM-ERROR":
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
              Almdmov.Pesmat = ITEM.Pesmat
              Almdmov.ImpCto = ITEM.Impcto
              Almdmov.PreLis = ITEM.PreLis
              Almdmov.PreUni = ITEM.PreUni
              Almdmov.codant = ITEM.Codant
              Almdmov.Dsctos[1] = ITEM.Dsctos[1]
              Almdmov.Dsctos[2] = ITEM.Dsctos[2]
              Almdmov.Dsctos[3] = ITEM.Dsctos[3]
              Almdmov.IgvMat = ITEM.IgvMat
              Almdmov.CodAjt = 'A'
                     R-ROWID = ROWID(Almdmov).
       FIND Almmmatg WHERE 
            Almmmatg.CodCia = Almdmov.CodCia AND
            Almmmatg.CodMat = Almdmov.codmat NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg AND NOT Almmmatg.AftIgv THEN  Almdmov.IgvMat = 0.
       RUN ALM\ALMACSTK (R-ROWID).
        
       IF Almcmov.codmon = 1 THEN DO:
          Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.ImpMn1.
          /* IF AVAILABLE Almmmatg THEN 
             IF NOT Almmmatg.AftIgv THEN Almcmov.ExoMn1 = Almcmov.ExoMn1 + Almdmov.ImpMn1. */
          END.
       ELSE DO:
          Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.ImpMn2.
          /* IF AVAILABLE Almmmatg THEN 
             IF NOT Almmmatg.AftIgv THEN Almcmov.ExoMn2 = Almcmov.ExoMn2 + Almdmov.ImpMn2. */
       END.

   END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos V-table-Win 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM:
    DELETE ITEM.
END.

DO I = 1 TO NUM-ENTRIES(x-nrogui) WITH FRAME {&FRAME-NAME} :
   FIND CMOV WHERE 
        CMOV.codcia = s-codcia AND
        CMOV.Codalm = s-codalm AND 
        CMOV.Tipmov = 'I'      AND
        CMOV.Codmov = 90       AND 
        CMOV.Nrorf2 = ENTRY(i,x-nrogui) AND
        CMOV.Codpro = Almcmov.CodPro:SCREEN-VALUE AND 
        CMOV.Flgest <> 'A' NO-LOCK NO-ERROR.
   IF AVAILABLE CMOV THEN DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almdmov OF CMOV,
          EACH Almmmatg WHERE Almmmatg.codcia = s-codcia AND
               Almmmatg.codmat = Almdmov.codmat NO-LOCK:
          CREATE ITEM.
          ASSIGN ITEM.Codcia = s-codcia
                 ITEM.Codmat = Almdmov.codmat
                 ITEM.codund = Almdmov.codund
                 ITEM.Candes = Almdmov.Candes
                 ITEM.Candev = Almdmov.Candes
                 ITEM.Factor = Almdmov.factor
                 ITEM.Pesmat = (Almdmov.candes * Almdmov.factor * Almmmatg.pesmat)
                 ITEM.Codant = CMOV.nrorf2.  /* GUIA DE ING.CONSIGNACION */
      END.
   END.
END.

DISPLAY x-nrogui @ integral.Almcmov.NroRf1 WITH FRAME {&FRAME-NAME}.
RUN Procesa-Handle IN lh_Handle ('browse').

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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
     DISPLAY TODAY @ Almcmov.FchDoc.
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.venta @ Almcmov.TpoCmb.
     Almcmov.NroRf1:SENSITIVE = YES.
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
            Almcmov.NroSer  = 000
            Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
            Almcmov.Nrorf1  = x-nrogui
            Almcmov.NomRef  = Fill-in-nompro:screen-value in frame {&FRAME-NAME}.
            
     FIND Almacen WHERE 
          Almacen.CodCia = S-CODCIA AND  
          Almacen.CodAlm = Almtdocm.CodAlm 
          EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN 
        ASSIGN Almcmov.NroDoc  = Almacen.CorrIng
               Almacen.CorrIng = Almacen.CorrIng + 1.
     RELEASE Almacen.
          
     DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
     
  END.
  ASSIGN Almcmov.usuario = S-USER-ID
         Almcmov.ImpIgv  = 0
         Almcmov.ImpMn1  = 0
         Almcmov.ImpMn2  = 0.
         
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
     RUN Borra-Detalle.
  END.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.
  
  IF Almcmov.codmon = 1 THEN 
     ASSIGN Almcmov.ImpMn2 = ROUND(Almcmov.ImpMn1 / Almcmov.tpocmb, 2)
          /*  Almcmov.ExoMn2 = ROUND(Almcmov.ExoMn1 / Almcmov.tpocmb, 2) */.
  ELSE 
     ASSIGN Almcmov.ImpMn1 = ROUND(Almcmov.ImpMn2 * Almcmov.tpocmb, 2)
           /* Almcmov.ExoMn1 = ROUND(Almcmov.ExoMn2 * Almcmov.tpocmb, 2) */.
           
  /* ACTUALIZA LAS GUIAS DE CONSIGNACION - I-90 */
  IF L-CREA THEN RUN Actualiza-Guias-Consignacion.
      
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
  Almcmov.NroRf1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
     RUN Borra-Detalle.
     /* Solo marcamos el FlgEst como Anulado */
     FIND CMOV WHERE 
          CMOV.CodCia = Almcmov.CodCia AND 
          CMOV.CodAlm = Almcmov.CodAlm AND 
          CMOV.TipMov = Almcmov.TipMov AND 
          CMOV.CodMov = Almcmov.CodMov AND 
          CMOV.NroSer = Almcmov.NroSer AND 
          CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR.
     ASSIGN CMOV.FlgEst = 'A'
            CMOV.Observ = "      A   N   U   L   A   D   O       ".
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
     
     /* IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.*/
     
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
     IF Almtdocm.TipMov = "S" THEN DO:
        ASSIGN Almcmov.TpoCmb:VISIBLE = NO
               Almcmov.CodMon:SCREEN-VALUE = '1'.
     END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     IF Almcmov.CodPro:VISIBLE THEN DO:
             FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                  gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
             IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
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
  
  RUN ALM\R-IMPFMT.R(ROWID(almcmov)).

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
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('browse').
  
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
   IF Almcmov.NroRf2:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Digite el Nro. de Guia" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf2.
      RETURN "ADM-ERROR".
   END.
   
   IF string(Almcmov.TpoCmb:SCREEN-VALUE,"Z9.9999") = "0.0000" THEN DO:
      MESSAGE "Ingrese el Tipo de Cambio " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.TpoCmb.
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

