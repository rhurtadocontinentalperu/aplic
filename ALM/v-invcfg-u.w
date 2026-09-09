&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED TEMP-TABLE T-Ajuste
    FIELD CodMat LIKE Almmmatg.CodMat
    FIELD DesMat LIKE Almmmatg.CodMat
    FIELD UndStk LIKE Almmmatg.CodMat
    FIELD CodAlm LIKE Almdmov.Codalm
    FIELD StkSub LIKE Almdmov.CanDes
    FIELD Dife   LIKE Almdmov.CanDes
    FIELD TipMov LIKE Almdmov.TipMov
    FIELD TipInv LIKE Almdmov.TipMov
    INDEX Idx01 IS UNIQUE PRIMARY
          CodMat DESCENDING
    INDEX Idx02
          TipMov DESCENDING
          TipInv DESCENDING.

DEF FRAME F-Mensaje 
    "MATERIAL:" Almmmatg.codmat
    WITH 
    TITLE 'Procesando'
    VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS.

  DEF BUFFER CMOV FOR Almcmov.
  DEF BUFFER DMOV FOR Almdmov.

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
&Scoped-define EXTERNAL-TABLES InvConfig
&Scoped-define FIRST-EXTERNAL-TABLE InvConfig


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR InvConfig.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS InvConfig.CodAlm InvConfig.FchInv ~
InvConfig.TipInv 
&Scoped-define ENABLED-TABLES InvConfig
&Scoped-define FIRST-ENABLED-TABLE InvConfig
&Scoped-Define DISPLAYED-FIELDS InvConfig.CodAlm InvConfig.FchInv ~
InvConfig.TipInv 
&Scoped-define DISPLAYED-TABLES InvConfig
&Scoped-define FIRST-DISPLAYED-TABLE InvConfig
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesAlm 

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
DEFINE VARIABLE FILL-IN-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     InvConfig.CodAlm AT ROW 1.19 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DesAlm AT ROW 1.19 COL 19 COLON-ALIGNED NO-LABEL
     InvConfig.FchInv AT ROW 2.15 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     InvConfig.TipInv AT ROW 3.12 COL 15 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Total", "T":U,
"Parcial", "P":U
          SIZE 18 BY .77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.InvConfig
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 3.19
         WIDTH              = 66.
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

/* SETTINGS FOR FILL-IN FILL-IN-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  {src/adm/template/row-list.i "InvConfig"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "InvConfig"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-CodMov AS INT.

  DEF VAR x-CodMat LIKE Almmmatg.codmat.
  DEF VAR x-StkSub AS DEC.
  DEF VAR x-CanInv AS DEC.
  DEF VAR x-Dife AS DEC.
  DEF VAR x-TipInv AS CHAR.
  DEF VAR x-TipMov AS CHAR.

  FOR EACH T-AJUSTE:
      DELETE T-AJUSTE.
  END.
  FOR EACH ITEM:
      DELETE ITEM.
  END.
  
  FOR EACH Almmmatg WHERE Almmmatg.CodCia = InvConfig.CodCia USE-INDEX Matg01 NO-LOCK:
      DISPLAY Almmmatg.codmat WITH FRAME F-Mensaje.
      X-CodMat = Almmmatg.CodMat.
      FIND AlmDInv WHERE AlmDInv.CodCia = InvConfig.CodCia
          AND AlmDInv.CodAlm = InvConfig.CodAlm
          AND AlmDInv.NomCia = "CONTI"
          AND AlmDInv.CodMat = x-CodMat NO-LOCK NO-ERROR.
      X-StkSub = 0.
      X-CanInv = 0.
      IF AVAIL AlmDInv THEN DO:
          X-StkSub = AlmDInv.QtyFisico.
          X-CanInv = AlmDInv.Libre_d01.
          /*
          IF AlmDInv.QtyReconteo = 0 THEN X-CanInv = AlmDInv.QtyConteo.
          ELSE X-CanInv = AlmDInv.QtyReconteo.
          */
      END.
      
      X-Dife = X-CanInv - X-StkSub.
      IF X-CanInv =  0 THEN X-TipInv = 'C'.
      IF X-CanInv <> 0 THEN X-TipInv = 'N'.
      IF X-Dife > 0 THEN X-TipMov = 'I'.
      IF X-Dife < 0 THEN X-TipMov = 'S'.
      IF X-Dife <> 0 THEN DO:
          CREATE T-Ajuste.
          ASSIGN 
              T-Ajuste.CodMat = Almmmatg.CodMat
              T-Ajuste.DesMat = Almmmatg.DesMat
              T-Ajuste.UndStk = Almmmatg.UndStk
              T-Ajuste.CodAlm = InvConfig.CodAlm
              T-Ajuste.StkSub = X-StkSub
              T-Ajuste.Dife   = X-Dife
              T-Ajuste.TipMov = X-TipMov
              T-Ajuste.TipInv = X-TipInv.
      END.

      PAUSE 0.

/*
    FIND LAST AlmStkal WHERE AlmStkal.CodCia =  InvConfig.CodCia
        AND   AlmStkal.CodAlm =  InvConfig.CodAlm
        AND   AlmStkal.CodMat =  X-CodMat
        AND   AlmStkal.Fecha <= InvConfig.FchInv
        NO-LOCK NO-ERROR.
    IF AVAIL AlmStkal THEN X-StkSub = AlmStkal.Stkact.
    IF NOT AVAIL AlmStkal THEN X-StkSub = 0.
    FIND LAST InvRecont WHERE InvRecont.CodCia =  InvConfig.CodCia
        AND   InvRecont.CodAlm =  InvConfig.CodAlm
        AND   InvRecont.FchInv =  InvConfig.FchInv         
        AND   InvRecont.CodMat =  X-CodMat
        USE-INDEX Invcn01 NO-LOCK NO-ERROR.
    /* De acuerdo si el inventario es total o parcial */
    IF InvConfig.TipInv = 'P' AND NOT AVAILABLE InvRecont THEN NEXT.
    /* ********************************************* */
    IF AVAIL InvRecont THEN X-CanInv = InvRecont.CanInv.
    IF NOT AVAIL InvRecont THEN X-CanInv = 0.
    X-Dife = X-CanInv - X-StkSub.
    IF X-CanInv =  0 THEN X-TipInv = 'C'.
    IF X-CanInv <> 0 THEN X-TipInv = 'N'.
    IF X-Dife > 0 THEN X-TipMov = 'I'.
    IF X-Dife < 0 THEN X-TipMov = 'S'.
    IF X-Dife <> 0 
    THEN DO:
        CREATE T-Ajuste.
        ASSIGN 
            T-Ajuste.CodMat = Almmmatg.CodMat
            T-Ajuste.DesMat = Almmmatg.DesMat
            T-Ajuste.UndStk = Almmmatg.UndStk
            T-Ajuste.CodAlm = InvConfig.CodAlm
            T-Ajuste.StkSub = X-StkSub
            T-Ajuste.Dife   = X-Dife
            T-Ajuste.TipMov = X-TipMov
            T-Ajuste.TipInv = X-TipInv.
    END.
*/    
  END.
  FOR EACH T-Ajuste USE-INDEX Idx02 NO-LOCK 
        BREAK BY T-Ajuste.TipMov BY T-Ajuste.TipInv:
    CREATE ITEM.
    ASSIGN
        ITEM.CodCia = InvConfig.codcia
        ITEM.CodAlm = InvConfig.CodAlm
        ITEM.TipMov = T-Ajuste.TipMov
        /*ITEM.CodMov = 01*/
        ITEM.CodMov = x-CodMov
        ITEM.FchDoc = InvConfig.FchInv
        ITEM.CodMon = 1
        ITEM.TpoCmb = 0
        ITEM.codmat = T-Ajuste.CodMat
        ITEM.CanDes = ABSOLUTE(T-Ajuste.Dife)
        ITEM.CodUnd = T-Ajuste.UndStk
        ITEM.Factor = 1
        ITEM.PreUni = 0
        ITEM.ImpCto = 0
        ITEM.CodAjt = ''
        ITEM.Flg_Factor = T-Ajuste.TipInv.
  END.
  HIDE FRAME F-Mensaje.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 V-table-Win 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-CodMov AS INT.

  DEF VAR x-CodMat LIKE Almmmatg.codmat.
  DEF VAR x-StkSub AS DEC.
  DEF VAR x-CanInv AS DEC.
  DEF VAR x-Dife AS DEC.
  DEF VAR x-TipInv AS CHAR.
  DEF VAR x-TipMov AS CHAR.

  FOR EACH T-AJUSTE:
      DELETE T-AJUSTE.
  END.
  FOR EACH ITEM:
      DELETE ITEM.
  END.

  FOR EACH AlmDInv WHERE AlmDInv.CodCia = InvConfig.CodCia
      AND AlmDInv.CodAlm = InvConfig.CodAlm
      AND AlmDInv.NomCia = "CONTI" NO-LOCK,
      FIRST almmmatg WHERE almmmatg.codcia = almdinv.codcia
        AND almmmatg.codmat = almdinv.codmat
        NO-LOCK:

      DISPLAY Almmmatg.codmat WITH FRAME f-mensaje.
      X-StkSub = 0.
      X-CanInv = 0.
      IF AVAIL AlmDInv THEN DO:
          X-StkSub = AlmDInv.QtyFisico.
          X-CanInv = AlmDInv.Libre_d01.
      END.
      
      X-Dife = X-CanInv - X-StkSub.
      
      /*X-Dife = X-StkSub - X-CanInv.*/

      IF X-CanInv =  0 THEN X-TipInv = 'C'.
      IF X-CanInv <> 0 THEN X-TipInv = 'N'.
      IF X-Dife > 0 THEN X-TipMov = 'I'.
      IF X-Dife < 0 THEN X-TipMov = 'S'.
      IF X-Dife <> 0 THEN DO:
          CREATE T-Ajuste.
          ASSIGN 
              T-Ajuste.CodMat = Almmmatg.CodMat
              T-Ajuste.DesMat = Almmmatg.DesMat
              T-Ajuste.UndStk = Almmmatg.UndStk
              T-Ajuste.CodAlm = InvConfig.CodAlm
              T-Ajuste.StkSub = X-StkSub
              T-Ajuste.Dife   = X-Dife
              T-Ajuste.TipMov = X-TipMov
              T-Ajuste.TipInv = X-TipInv.
      END.
      PAUSE 0.
  END.
  
  FOR EACH T-Ajuste USE-INDEX Idx02 NO-LOCK 
        BREAK BY T-Ajuste.TipMov BY T-Ajuste.TipInv:
    CREATE ITEM.
    ASSIGN
        ITEM.CodCia = InvConfig.codcia
        ITEM.CodAlm = InvConfig.CodAlm
        ITEM.TipMov = T-Ajuste.TipMov
        /*ITEM.CodMov = 01*/
        ITEM.CodMov = x-CodMov
        ITEM.FchDoc = InvConfig.FchInv
        ITEM.CodMon = 1
        ITEM.TpoCmb = 0
        ITEM.codmat = T-Ajuste.CodMat
        ITEM.CanDes = ABSOLUTE(T-Ajuste.Dife)
        ITEM.CodUnd = T-Ajuste.UndStk
        ITEM.Factor = 1
        ITEM.PreUni = 0
        ITEM.ImpCto = 0
        ITEM.CodAjt = ''
        ITEM.Flg_Factor = T-Ajuste.TipInv.
  END.
  HIDE FRAME F-Mensaje.
  

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
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

FIND FIRST t-ajuste NO-LOCK NO-ERROR.
IF NOT AVAIL t-ajuste THEN DO:
    MESSAGE "Generar Movimientos Previamente"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "ADM-ERROR".
END.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header*/
cRange = "D" + '2'.
chWorkSheet:Range(cRange):Value = "TRANSFERENCIA TEMPORAL".
/* chWorkSheet:FONT:Bold = TRUE. */

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".

/* set the column names for the Worksheet */
 t-Column = t-Column + 1.
 cColumn = STRING(t-Column).
 cRange = "A" + cColumn.
 chWorkSheet:Range(cRange):Value = "Almacen".
 cRange = "B" + cColumn.
 chWorkSheet:Range(cRange):Value = "Movim.".
 cRange = "C" + cColumn.
 chWorkSheet:Range(cRange):Value = "Código".
 cRange = "D" + cColumn.
 chWorkSheet:Range(cRange):Value = "Descripción".
 cRange = "E" + cColumn.
 chWorkSheet:Range(cRange):Value = "Unidad".
 cRange = "F" + cColumn.
 chWorkSheet:Range(cRange):Value = "Diferencia".

 FOR EACH t-Ajuste NO-LOCK
     BREAK BY T-Ajuste.TipMov:
     t-Column = t-Column + 1.
     cColumn = STRING(t-Column).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.CodAlm.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.TipMov.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.CodMat.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.DesMat.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.UndStk.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = T-Ajuste.Dife.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Movimiento V-table-Win 
PROCEDURE Genera-Movimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Glosa AS CHAR.
  
  /* Consistencia de Movimientos */
  FOR EACH ITEM NO-LOCK BREAK BY ITEM.codcia BY ITEM.tipmov:
    IF FIRST-OF(ITEM.tipmov) THEN DO:
        FIND Almtdocm OF ITEM NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtdocm
        THEN DO:
            MESSAGE 'NO esta configurado el movimiento' ITEM.codmov 'en el almacen' ITEM.codalm
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
    END.
  END.

  /* Ahora si */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = InvConfig.CodAlm
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN UNDO, RETURN "ADM-ERROR".

      FOR EACH ITEM NO-LOCK 
          BREAK BY ITEM.codcia 
          BY ITEM.TipMov 
          BY ITEM.Flg_Factor 
          BY ITEM.CodMat:
        IF FIRST-OF(ITEM.TipMov) OR FIRST-OF(ITEM.Flg_Factor) THEN DO:
            IF ITEM.Flg_Factor = 'C' 
            THEN X-Glosa = 'AjusteAutomaticoxCero' + STRING(TODAY,'99/99/99') + STRING(TIME,'HH:MM:SS') + s-User-id.
            IF ITEM.Flg_Factor = 'N' 
            THEN X-Glosa = 'AjusteAutomaticoxInve' + STRING(TODAY,'99/99/99') + STRING(TIME,'HH:MM:SS') + s-User-id.
            /*
            FIND Almtdocm OF ITEM EXCLUSIVE-LOCK NO-ERROR.
            */
            CREATE Almcmov.
            ASSIGN 
                Almcmov.CodCia = s-CodCia
                Almcmov.CodAlm = ITEM.CodAlm                        
                Almcmov.TipMov = ITEM.TipMov
                Almcmov.CodMov = ITEM.CodMov
                Almcmov.Observ = X-Glosa
                Almcmov.Usuario = s-User-id
                Almcmov.FchDoc = InvConfig.FchInv
                Almcmov.CodMon = 1
                Almcmov.TpoCmb = 0.
            /*
                Almcmov.NroDoc = AlmtDocm.NroDoc
                AlmtDocm.NroDoc = AlmtDocm.NroDoc + 1
                */
            IF ITEM.TipMov = 'S' 
                THEN ASSIGN
                        Almcmov.nrodoc = Almacen.CorrSal
                        Almacen.CorrSal = Almacen.CorrSal + 1.
            IF ITEM.TipMov = 'I' 
                THEN ASSIGN
                        Almcmov.nrodoc = Almacen.CorrIng
                        Almacen.CorrIng = Almacen.CorrIng + 1.
            /*RELEASE AlmtDocm.*/
        END.
        CREATE Almdmov.
        BUFFER-COPY ITEM TO Almdmov
            ASSIGN
                Almdmov.NroDoc = Almcmov.NroDoc
                Almdmov.CodMon = Almcmov.CodMov
                Almdmov.FchDoc = Almcmov.FchDoc
                Almdmov.TpoCmb = Almcmov.TpoCmb.
        DELETE ITEM.
      END.
      RELEASE Almacen.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Movimiento-Transferencia V-table-Win 
PROCEDURE Genera-Movimiento-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* consistencia de la configuración general */  
FIND Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN DO:
    MESSAGE 'NO configurado los items por Guia de Remisión'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* consistencia de almacen temporal */
FIND almacen WHERE almacen.codcia = s-codcia
    AND almacen.codalm = '10'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    MESSAGE 'Almacén Temporal 10 NO está configurado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
MESSAGE almacen.codalm.

/* Consistencia de Movimientos */
FOR EACH ITEM NO-LOCK BREAK BY ITEM.codcia BY ITEM.tipmov:
  IF FIRST-OF(ITEM.tipmov) THEN DO:
      FIND Almtdocm OF ITEM NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtdocm
      THEN DO:
          MESSAGE 'NO esta configurado el movimiento' ITEM.tipmov ITEM.codmov 'en el almacen' ITEM.codalm
              VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
      FIND Almtdocm WHERE Almtdocm.codcia = ITEM.codcia
          AND Almtdocm.codalm = '10' 
          AND Almtdocm.tipmov = ITEM.tipmov
          AND Almtdocm.codmov = ITEM.codmov
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtdocm
      THEN DO:
          MESSAGE 'NO esta configurado el movimiento' ITEM.tipmov ITEM.codmov 'en el almacen 10'
              VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
/*       IF ITEM.TipMov = 'S' THEN DO:                                             */
/*           FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA                  */
/*               AND FacCorre.CodDoc = "G/R"                                       */
/*               AND FacCorre.CodDiv = S-CODDIV                                    */
/*               AND FacCorre.FlgEst = YES                                         */
/*               AND FacCorre.CodAlm = ITEM.CodAlm                                 */
/*               AND FacCorre.TipMov = ITEM.TipMov                                 */
/*               AND FacCorre.CodMov = ITEM.CodMov                                 */
/*               NO-LOCK NO-ERROR.                                                 */
/*           IF NOT AVAILABLE Faccorre                                             */
/*           THEN DO:                                                              */
/*               MESSAGE 'NO esta configurada la G/R el el almacén' ITEM.codalm    */
/*                   VIEW-AS ALERT-BOX ERROR.                                      */
/*               RETURN "ADM-ERROR".                                               */
/*           END.                                                                  */
/*       END.                                                                      */
/*       IF ITEM.TipMov = 'I' THEN DO:                                             */
/*           FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA                  */
/*               AND FacCorre.CodDoc = "G/R"                                       */
/*               AND FacCorre.CodDiv = almacen.coddiv                              */
/*               AND FacCorre.FlgEst = YES                                         */
/*               AND FacCorre.CodAlm = almacen.codalm                              */
/*               AND FacCorre.TipMov = 'S'                                         */
/*               AND FacCorre.CodMov = ITEM.CodMov                                 */
/*               NO-LOCK NO-ERROR.                                                 */
/*           IF NOT AVAILABLE Faccorre                                             */
/*           THEN DO:                                                              */
/*               MESSAGE 'NO esta configurada la G/R el el almacén' almacen.codalm */
/*                   VIEW-AS ALERT-BOX ERROR.                                      */
/*               RETURN "ADM-ERROR".                                               */
/*           END.                                                                  */
/*       END.                                                                      */
  END.
END.


DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Primero generamos la salida por transferencia hacia el almacen temporal 10 */
    RUN Salida-por-Transferencia.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    
    /* Segundo vamos a generar la salida por transferencia desde el almacén temporal 10 */
    FOR EACH ITEM WHERE ITEM.codalm = InvConfig.CodAlm AND ITEM.tipmov = 'I':
        ASSIGN
            ITEM.codalm = '10'
            ITEM.tipmov = 'S'.        
    END.
    RUN Salida-por-Transferencia.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

    FOR EACH ITEM:
        DELETE ITEM.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Movimientos V-table-Win 
PROCEDURE Graba-Movimientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Glosa AS CHAR.
  DEF VAR r-Rowid AS ROWID.
  DEF VAR x-Item AS INT INIT 1.
  MESSAGE "Genera Movimientos".

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH ITEM NO-LOCK BREAK BY ITEM.codcia BY ITEM.TipMov BY ITEM.Flg_Factor BY ITEM.CodMat:
        IF ( FIRST-OF(ITEM.TipMov) OR FIRST-OF(ITEM.Flg_Factor) )
            OR ( ITEM.TipMov = 'S' AND x-Item > FacCfgGn.Items_Guias ) THEN DO:
            x-Item = 1.     /* <<< OJO <<< */
            IF ITEM.Flg_Factor = 'C' 
            THEN X-Glosa = 'AjusteAutomaticoxCero' + STRING(TODAY,'99/99/99') + STRING(TIME,'HH:MM:SS') + s-User-id.
            IF ITEM.Flg_Factor = 'N' 
            THEN X-Glosa = 'AjusteAutomaticoxInve' + STRING(TODAY,'99/99/99') + STRING(TIME,'HH:MM:SS') + s-User-id.
            CASE ITEM.TipMov:
                WHEN 'I' THEN DO:
                    FIND Almtdocm WHERE Almtdocm.CodCia = ITEM.CodCia
                        AND Almtdocm.CodAlm = ITEM.CodAlm
                        AND Almtdocm.TipMov = ITEM.TipMov
                        AND Almtdocm.CodMov = ITEM.CodMov
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.          
                    CREATE Almcmov.
                    ASSIGN 
                        Almcmov.CodCia = s-CodCia
                        Almcmov.CodAlm = ITEM.CodAlm  
                        Almcmov.AlmDes = (IF ITEM.CodAlm = '10' THEN InvConfig.CodAlm ELSE '10')
                        Almcmov.TipMov = ITEM.TipMov
                        Almcmov.CodMov = ITEM.CodMov
                        Almcmov.Observ = X-Glosa
                        Almcmov.Usuario = s-User-id
                        Almcmov.FchDoc = InvConfig.FchInv
                        Almcmov.CodMon = 1
                        Almcmov.TpoCmb = 0
                        Almcmov.NroDoc = AlmtDocm.NroDoc
                        AlmtDocm.NroDoc = AlmtDocm.NroDoc + 1.
                    RELEASE AlmtDocm.
                END.
                WHEN 'S' THEN DO:       /* SALIDA POR TRANSFERENCIA */
                    FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                        AND FacCorre.CodDoc = "G/R" 
                        AND FacCorre.CodDiv = S-CODDIV 
                        AND FacCorre.FlgEst = YES
                        AND FacCorre.CodAlm = ITEM.CodAlm
                        AND FacCorre.TipMov = ITEM.TipMov
                        AND FacCorre.CodMov = ITEM.CodMov
                        EXCLUSIVE-LOCK NO-ERROR.
                   IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
                   CREATE Almcmov.
                   ASSIGN 
                       Almcmov.CodCia = s-CodCia
                       Almcmov.CodAlm = ITEM.CodAlm                        
                       Almcmov.AlmDes = (IF ITEM.CodAlm = '10' THEN InvConfig.CodAlm ELSE '10')
                       Almcmov.TipMov = ITEM.TipMov
                       Almcmov.CodMov = ITEM.CodMov
                       Almcmov.Observ = X-Glosa
                       Almcmov.Usuario = s-User-id
                       Almcmov.FchDoc = InvConfig.FchInv
                       Almcmov.CodMon = 1
                       Almcmov.TpoCmb = 0
                       Almcmov.FlgSit = 'R'     /* <<< OJO: RECEPCIONADO */
                       Almcmov.NroSer = Faccorre.nroser
                       Almcmov.NroDoc = Faccorre.correlativo
                       Faccorre.correlativo = Faccorre.correlativo + 1.
                   RELEASE Faccorre.
                END.
            END CASE.
        END.
        CREATE Almdmov.
        BUFFER-COPY ITEM TO Almdmov
            ASSIGN
                Almdmov.AlmOri = Almcmov.AlmDes
                Almdmov.NroSer = Almcmov.NroSer
                Almdmov.NroDoc = Almcmov.NroDoc
                Almdmov.CodMon = Almcmov.CodMov
                Almdmov.FchDoc = Almcmov.FchDoc
                Almdmov.TpoCmb = Almcmov.TpoCmb.
        R-ROWID = ROWID(Almdmov).
        CASE Almdmov.TipMov:
            WHEN 'I' THEN DO:
                RUN ALM\ALMACSTK (R-ROWID).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.
            WHEN 'S' THEN DO:       /* SALIDA POR TRANSFERENCIA */
                ASSIGN
                    Almdmov.NroItm = x-Item     /* <<< OJO <<< */
                    x-Item = x-Item + 1.        /* <<< OJO <<< */
                RUN alm/almdcstk (R-ROWID).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.
        END CASE.
    END.
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
  DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-DesAlm:SCREEN-VALUE = ''.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND codalm = InvConfig.CodAlm:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen
    THEN FILL-IN-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salida-por-Transferencia V-table-Win 
PROCEDURE Salida-por-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     Genera la Salida por Transferencia en el almacen origen 
                y el Ingreso por transferencia en el almacen destino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Glosa AS CHAR.
  DEF VAR r-Rowid AS ROWID.
  DEF VAR x-Item AS INT INIT 1.
  DEF VAR x-CodDiv LIKE s-CodDiv NO-UNDO.

MESSAGE "salida x transferenia" .
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH ITEM NO-LOCK WHERE ITEM.CodMat <> '' AND ITEM.TipMov = 'S' BREAK BY ITEM.Flg_Factor BY ITEM.CodMat:
        x-CodDiv = (IF ITEM.CodAlm = '10' THEN '00000' ELSE S-CODDIV).
        IF FIRST-OF(ITEM.Flg_Factor) THEN DO:
            x-Item = 1.     /* <<< OJO <<< */
            IF ITEM.Flg_Factor = 'C' 
            THEN X-Glosa = 'AjusteAutomaticoxCero ' + STRING(InvConfig.FchInv,'99/99/99') + ' ' + STRING(TIME,'HH:MM:SS') + ' ' + s-User-id.
            IF ITEM.Flg_Factor = 'N' 
            THEN X-Glosa = 'AjusteAutomaticoxInve ' + STRING(InvConfig.FchInv,'99/99/99') + ' ' + STRING(TIME,'HH:MM:SS') + ' ' + s-User-id.
            FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = ITEM.codalm
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Almacen THEN DO:
               MESSAGE 'Error en el almacen' ITEM.codalm SKIP 
                   'NO se pudo realizar la salida por transferencia'
                   VIEW-AS ALERT-BOX ERROR.
               UNDO, RETURN 'ADM-ERROR'.
           END.
           CREATE Almcmov.
           ASSIGN 
               Almcmov.CodCia = s-CodCia
               Almcmov.CodAlm = ITEM.CodAlm                        
               Almcmov.AlmDes = (IF ITEM.CodAlm = '10' THEN InvConfig.CodAlm ELSE '10')
               Almcmov.TipMov = ITEM.TipMov
               Almcmov.CodMov = ITEM.CodMov
               Almcmov.NroSer = 000
               Almcmov.NroDoc = Almacen.CorrSal
               Almcmov.Observ = X-Glosa
               Almcmov.Usuario = s-User-id
               Almcmov.FchDoc = ITEM.fchdoc
               Almcmov.CodMon = 1
               Almcmov.TpoCmb = 0
               Almcmov.FlgSit = 'R'     /* <<< OJO: RECEPCIONADO */
               Almacen.CorrSal = Almacen.CorrSal + 1.
           /* Generamos el Ingreso por Transferencia en el almacén destino */
           FIND Almtdocm WHERE Almtdocm.CodCia = Almcmov.CodCia
               AND Almtdocm.CodAlm = Almcmov.AlmDes
               AND Almtdocm.TipMov = "I"
               AND Almtdocm.CodMov = Almcmov.CodMov
               EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE Almtdocm THEN DO:
               MESSAGE 'NO se encontro el correlativo para el ingreso por transferencia del almacén' Almcmov.almdes.
               UNDO, RETURN 'ADM-ERROR'.
           END.
           CREATE CMOV.
           ASSIGN 
               cmov.CodCia = Almcmov.CodCia
               cmov.CodAlm = Almcmov.AlmDes
               cmov.AlmDes = Almcmov.CodAlm
               cmov.TipMov = "I"
               cmov.CodMov = Almcmov.CodMov
               cmov.NroSer = 000
               cmov.NroDoc = AlmtDocm.NroDoc
               cmov.NroRf1 = STRING(Almcmov.NroSer, '999') + STRING(Almcmov.NroDoc, '999999')
               cmov.Observ = X-Glosa
               cmov.Usuario = s-User-id
               cmov.FchDoc = ITEM.fchdoc
               cmov.CodMon = 1
               cmov.TpoCmb = 0
               AlmtDocm.NroDoc = AlmtDocm.NroDoc + 1.
           /*
           MESSAGE almcmov.codalm almcmov.tipmov almcmov.codmov almcmov.nroser almcmov.nrodoc SKIP
               cmov.codalm cmov.tipmov cmov.codmov cmov.nroser cmov.nrodoc.
               */
        END.
        /* create el detalle de la salida */
        CREATE Almdmov.
        BUFFER-COPY ITEM TO Almdmov
            ASSIGN
                Almdmov.AlmOri = Almcmov.AlmDes
                Almdmov.NroSer = Almcmov.NroSer
                Almdmov.NroDoc = Almcmov.NroDoc
                Almdmov.CodMon = Almcmov.CodMov
                Almdmov.FchDoc = Almcmov.FchDoc
                Almdmov.TpoCmb = Almcmov.TpoCmb
                Almdmov.NroItm = x-Item.
        x-Item = x-Item + 1.        /* <<< OJO <<< */
        /* create el detalle del ingreso */
        CREATE DMOV.
        BUFFER-COPY ITEM TO dmov
            ASSIGN
                dmov.CodAlm = cmov.CodAlm
                dmov.TipMov = cmov.TipMov
                dmov.CodMov = cmov.CodMov
                dmov.NroSer = cmov.NroSer
                dmov.NroDoc = cmov.NroDoc
                dmov.AlmOri = cmov.AlmDes
                dmov.CodMon = cmov.CodMov
                dmov.FchDoc = cmov.FchDoc
                dmov.TpoCmb = cmov.TpoCmb.
        R-ROWID = ROWID(Almdmov).
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'El material' almdmov.codalm almdmov.codmat 'no ha podido descargarse del stock'.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        R-ROWID = ROWID(DMOV).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'El material' dmov.codalm dmov.codmat 'no ha podido cargar al stock'.
            UNDO, RETURN 'ADM-ERROR'.
        END.

        DELETE ITEM.
    END.
    RELEASE Almacen.
    RELEASE Almtdocm.
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
  {src/adm/template/snd-list.i "InvConfig"}

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
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
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

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

