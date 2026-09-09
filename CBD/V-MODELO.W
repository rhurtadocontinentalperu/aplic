&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-cmdlo FOR cb-cmdlo.
DEFINE BUFFER b-dmdlo FOR cb-dmdlo.



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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE BUFFER CMDLO FOR cb-cmdlo.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR s-copia-registro AS LOG.
DEF VAR s-registro-a-copiar AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cb-cmdlo
&Scoped-define FIRST-EXTERNAL-TABLE cb-cmdlo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cmdlo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cmdlo.CodMod cb-cmdlo.DesMod ~
cb-cmdlo.TpoMod cb-cmdlo.CodOpe cb-cmdlo.Clfaux cb-cmdlo.Notast ~
cb-cmdlo.CodMon cb-cmdlo.Referencia[7] cb-cmdlo.Referencia[9] ~
cb-cmdlo.Referencia[8] cb-cmdlo.Referencia[10] cb-cmdlo.Referencia[1] ~
cb-cmdlo.Referencia[2] cb-cmdlo.Referencia[3] cb-cmdlo.Referencia[4] ~
cb-cmdlo.Referencia[5] cb-cmdlo.Referencia[6] cb-cmdlo.Concepto[1] ~
cb-cmdlo.Concepto[2] cb-cmdlo.Concepto[3] cb-cmdlo.Concepto[4] ~
cb-cmdlo.Concepto[5] cb-cmdlo.Concepto[6] cb-cmdlo.Concepto[7] ~
cb-cmdlo.Concepto[8] cb-cmdlo.Concepto[9] cb-cmdlo.Concepto[10] 
&Scoped-define ENABLED-TABLES cb-cmdlo
&Scoped-define FIRST-ENABLED-TABLE cb-cmdlo
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 RECT-3 
&Scoped-Define DISPLAYED-FIELDS cb-cmdlo.CodMod cb-cmdlo.DesMod ~
cb-cmdlo.TpoMod cb-cmdlo.CodOpe cb-cmdlo.Clfaux cb-cmdlo.Notast ~
cb-cmdlo.CodMon cb-cmdlo.Referencia[7] cb-cmdlo.Referencia[9] ~
cb-cmdlo.Referencia[8] cb-cmdlo.Referencia[10] cb-cmdlo.Referencia[1] ~
cb-cmdlo.Referencia[2] cb-cmdlo.Referencia[3] cb-cmdlo.Referencia[4] ~
cb-cmdlo.Referencia[5] cb-cmdlo.Referencia[6] cb-cmdlo.Concepto[1] ~
cb-cmdlo.Concepto[2] cb-cmdlo.Concepto[3] cb-cmdlo.Concepto[4] ~
cb-cmdlo.Concepto[5] cb-cmdlo.Concepto[6] cb-cmdlo.Concepto[7] ~
cb-cmdlo.Concepto[8] cb-cmdlo.Concepto[9] cb-cmdlo.Concepto[10] 
&Scoped-define DISPLAYED-TABLES cb-cmdlo
&Scoped-define FIRST-DISPLAYED-TABLE cb-cmdlo
&Scoped-Define DISPLAYED-OBJECTS F-DesOpe 

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
DEFINE VARIABLE F-DesOpe AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.77.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cmdlo.CodMod AT ROW 1.23 COL 9 COLON-ALIGNED
          LABEL "Modelo"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .69
     cb-cmdlo.DesMod AT ROW 1.23 COL 16 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 44 BY .69
     cb-cmdlo.TpoMod AT ROW 1.23 COL 70 COLON-ALIGNED
          LABEL "Tipo Mod."
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     cb-cmdlo.CodOpe AT ROW 2 COL 9 COLON-ALIGNED
          LABEL "Operacion"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .69
     F-DesOpe AT ROW 2 COL 16 COLON-ALIGNED NO-LABEL
     cb-cmdlo.Clfaux AT ROW 2 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     cb-cmdlo.Notast AT ROW 2.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .69
     cb-cmdlo.CodMon AT ROW 2.96 COL 65 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .69
     cb-cmdlo.Referencia[7] AT ROW 4.04 COL 11 COLON-ALIGNED
          LABEL "Cod.Auxiliar" FORMAT "X(13)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[9] AT ROW 4.04 COL 57 COLON-ALIGNED
          LABEL "Cod.Referencia" FORMAT "X(13)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[8] AT ROW 4.77 COL 11 COLON-ALIGNED
          LABEL "Centro de Costo" FORMAT "X(13)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[10] AT ROW 4.77 COL 57 COLON-ALIGNED
          LABEL "Orden de Compra" FORMAT "X(13)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[1] AT ROW 5.46 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[2] AT ROW 5.46 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[3] AT ROW 6.12 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[4] AT ROW 6.12 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[5] AT ROW 6.77 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Referencia[6] AT ROW 6.77 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[1] AT ROW 7.88 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[2] AT ROW 7.88 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[3] AT ROW 8.54 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[4] AT ROW 8.54 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[5] AT ROW 9.19 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[6] AT ROW 9.19 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[7] AT ROW 9.85 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[8] AT ROW 9.85 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     cb-cmdlo.Concepto[9] AT ROW 10.46 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     cb-cmdlo.Concepto[10] AT ROW 10.46 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 3.08 COL 58
     RECT-2 AT ROW 7.65 COL 1
     RECT-1 AT ROW 3.85 COL 1
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-cmdlo
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-cmdlo B "?" ? INTEGRAL cb-cmdlo
      TABLE: b-dmdlo B "?" ? INTEGRAL cb-dmdlo
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
         HEIGHT             = 10.42
         WIDTH              = 79.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cb-cmdlo.CodMod IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.CodOpe IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-DesOpe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[7] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[8] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[9] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cmdlo.TpoMod IN FRAME F-Main
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

&Scoped-define SELF-NAME cb-cmdlo.CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmdlo.CodOpe V-table-Win
ON LEAVE OF cb-cmdlo.CodOpe IN FRAME F-Main /* Operacion */
DO:
  cb-cmdlo.CodMon:SENSITIVE = YES.
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-oper WHERE cb-oper.CodCia = S-CODCIA AND
       cb-oper.Codope = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper THEN 
     FIND cb-oper WHERE cb-oper.CodCia = 0 AND
          cb-oper.Codope = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper THEN DO:
     MESSAGE "Codigo de Operacion no registrado" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  F-DesOpe:SCREEN-VALUE = cb-oper.Nomope .
  IF cb-oper.Codmon < 3 THEN DO:
     cb-cmdlo.CodMon:SCREEN-VALUE = STRING(cb-oper.Codmon).
     cb-cmdlo.CodMon:SENSITIVE = NO.
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
  {src/adm/template/row-list.i "cb-cmdlo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cmdlo"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-copia-registro = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     FIND LAST CMDLO USE-INDEX CMDLO01 NO-LOCK NO-ERROR. 
     IF AVAILABLE CMDLO THEN DISPLAY CMDLO.CodMod + 1 @ cb-cmdlo.CodMod.
     ELSE DISPLAY 1 @ cb-cmdlo.CodMod.
     cb-cmdlo.Referencia[7]:SCREEN-VALUE = cb-cmdlo.Referencia[7]:LABEL.
     cb-cmdlo.Referencia[8]:SCREEN-VALUE = cb-cmdlo.Referencia[8]:LABEL.
     cb-cmdlo.Referencia[9]:SCREEN-VALUE = cb-cmdlo.Referencia[9]:LABEL.
     cb-cmdlo.Referencia[10]:SCREEN-VALUE = cb-cmdlo.Referencia[10]:LABEL.
  END.
  
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
     IF cb-cmdlo.Referencia[7] = "" THEN cb-cmdlo.Referencia[7] = cb-cmdlo.Referencia[7]:LABEL.
     IF s-copia-registro = YES THEN DO:
         /* copiamos el detalle */
         FIND b-cmdlo WHERE ROWID(b-cmdlo) = s-registro-a-copiar NO-LOCK.
         FOR EACH b-dmdlo OF b-cmdlo:
             CREATE cb-dmdlo.
             BUFFER-COPY b-dmdlo 
                 TO cb-dmdlo
                 ASSIGN cb-dmdlo.codmod = cb-cmdlo.codmod.
         END.
     END.
  END.

  
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
  ASSIGN
      s-copia-registro = YES
      s-registro-a-copiar = ROWID(cb-cmdlo).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     FIND LAST CMDLO USE-INDEX CMDLO01 NO-LOCK NO-ERROR. 
     IF AVAILABLE CMDLO THEN DISPLAY CMDLO.CodMod + 1 @ cb-cmdlo.CodMod.
     ELSE DISPLAY 1 @ cb-cmdlo.CodMod.
  END.

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
  FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod:
      DELETE cb-dmdlo.
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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

  IF AVAILABLE cb-cmdlo THEN DO WITH FRAME {&FRAME-NAME}:
     FIND cb-oper WHERE cb-oper.CodCia = S-CODCIA AND
          cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-oper THEN 
        FIND cb-oper WHERE cb-oper.CodCia = 0 AND
             cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF AVAILABLE cb-oper THEN 
        F-DesOpe:SCREEN-VALUE = cb-oper.Nomope.
     ELSE
        F-DesOpe:SCREEN-VALUE = "".
     F-DesOpe = F-DesOpe:SCREEN-VALUE.
     IF cb-cmdlo.Referencia[7] = "" THEN 
        cb-cmdlo.Referencia[7]:SCREEN-VALUE = cb-cmdlo.Referencia[7]:LABEL.
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
  DEFINE VARIABLE S-MON AS CHAR NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
  IF NOT answer THEN RETURN.

  /************************  DEFINICION DE FRAMES  *******************************/
  S-MON = IF cb-cmdlo.CodMon = 1 THEN "S/." ELSE "US$".
  DEFINE FRAME F-Modelo
      cb-dmdlo.Codcta COLUMN-LABEL "CUENTA"
      cb-dmdlo.Clfaux COLUMN-LABEL "CLF"
      cb-dmdlo.Codaux COLUMN-LABEL "AUXILIAR"
      cb-dmdlo.Coddoc COLUMN-LABEL "COD!DOC"
      cb-dmdlo.Nrodoc COLUMN-LABEL "DOCUMENTO"
      cb-dmdlo.TpoItm COLUMN-LABEL "TIPO"
      cb-dmdlo.TpoMov COLUMN-LABEL "T"
      cb-dmdlo.Importe COLUMN-LABEL "IMPORTE"
      cb-dmdlo.Codref COLUMN-LABEL "COD!REF"
      cb-dmdlo.Nroref COLUMN-LABEL "REFERENCIA"
      cb-dmdlo.cco COLUMN-LABEL "C.COSTO"
      cb-dmdlo.DisCCo COLUMN-LABEL "DISTRB!C.C."
      cb-dmdlo.tm COLUMN-LABEL "TIPO!GASTO"
      HEADER
      S-NOMCIA FORMAT "X(35)"  "CONFIGURACION DE ASIENTOS TIPO"   AT 45 "FECHA : " TO 110 TODAY SKIP
      "   MODELO : " cb-cmdlo.CodMod cb-cmdlo.DesMod       "TIPO MOD.: " TO 110 cb-cmdlo.TpoMod SKIP
      "OPERACION : " cb-cmdlo.CodOpe F-DesOpe         "CLF. AUXILIAR : " TO 110 cb-cmdlo.Clfaux SKIP
      "  DETALLE : " cb-cmdlo.Notast                        " MONEDA : " TO 110 S-MON SKIP
      "COD.AUXILIAR : " cb-cmdlo.Referencia[7]       "COD.REFERENCIA : " TO 110 cb-cmdlo.Referencia[9] SKIP
      "CENTRO COSTO : " cb-cmdlo.Referencia[8]      "ORDEN DE COMPRA : " TO 110 cb-cmdlo.Referencia[10] SKIP
      "REFERENCIA(1) : " cb-cmdlo.Referencia[1]       "REFERENCIA(2) : " TO 110 cb-cmdlo.Referencia[2] SKIP
      "REFERENCIA(3) : " cb-cmdlo.Referencia[3]       "REFERENCIA(4) : " TO 110 cb-cmdlo.Referencia[4] SKIP
      "REFERENCIA(5) : " cb-cmdlo.Referencia[5]       "REFERENCIA(6) : " TO 110 cb-cmdlo.Referencia[6] SKIP
      "  CONCEPTO(1) : " cb-cmdlo.Concepto[1]         "  CONCEPTO(2) : " TO 110 cb-cmdlo.Concepto[2] SKIP
      "  CONCEPTO(3) : " cb-cmdlo.Concepto[3]         "  CONCEPTO(4) : " TO 110 cb-cmdlo.Concepto[4] SKIP
      "  CONCEPTO(5) : " cb-cmdlo.Concepto[5]         "  CONCEPTO(6) : " TO 110 cb-cmdlo.Concepto[6] SKIP
      "  CONCEPTO(7) : " cb-cmdlo.Concepto[7]         "  CONCEPTO(8) : " TO 110 cb-cmdlo.Concepto[8] SKIP
      "  CONCEPTO(9) : " cb-cmdlo.Concepto[9]        "  CONCEPTO(10) : " TO 110 cb-cmdlo.Concepto[10] SKIP
      WITH WIDTH 200 STREAM-IO DOWN.
  
  OUTPUT TO PRINTER PAGE-SIZE 62.
  PUT CONTROL CHR(27) "@".
  PUT CONTROL CHR(27) "C" CHR(66).
  PUT CONTROL CHR(27) CHR(120) 0.
  PUT CONTROL CHR(15).
  FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod:
      DISPLAY
            cb-dmdlo.Codcta 
            cb-dmdlo.Clfaux 
            cb-dmdlo.Codaux 
            cb-dmdlo.Coddoc 
            cb-dmdlo.Nrodoc 
            cb-dmdlo.TpoItm 
            cb-dmdlo.TpoMov
            cb-dmdlo.Importe 
            cb-dmdlo.Codref 
            cb-dmdlo.Nroref 
            cb-dmdlo.cco 
            cb-dmdlo.DisCCo 
            cb-dmdlo.tm WITH FRAME F-Modelo.
  END.
  OUTPUT CLOSE.
  
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
        WHEN "Clfaux" THEN ASSIGN input-var-1 = "01".
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "cb-cmdlo"}

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
   IF cb-cmdlo.CodOpe:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de operacion no debe ser blanco"  VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO cb-cmdlo.CodOpe.
       RETURN "ADM-ERROR".   
   END.
   FIND cb-oper WHERE cb-oper.CodCia = S-CODCIA AND
        cb-oper.Codope = cb-cmdlo.CodOpe:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-oper THEN 
      FIND cb-oper WHERE cb-oper.CodCia = 0 AND
           cb-oper.Codope = cb-cmdlo.CodOpe:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-oper THEN DO:
       MESSAGE "Codigo de operacion no existe"  VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO cb-cmdlo.CodOpe.
       RETURN "ADM-ERROR".   
   END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Update V-table-Win 
PROCEDURE Valida-Update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
s-copia-registro = NO.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

