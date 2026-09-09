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
DEFINE        VAR  S-TPOMOV AS CHAR INIT 'I'.
DEFINE BUFFER TMOVM FOR AlmTMovm.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Confg. Mov. Ingreso".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

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
&Scoped-define EXTERNAL-TABLES Almtmovm
&Scoped-define FIRST-EXTERNAL-TABLE Almtmovm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almtmovm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almtmovm.Indicador[6] Almtmovm.Indicador[2] ~
Almtmovm.Indicador[1] Almtmovm.PidRef3 Almtmovm.TpoCto Almtmovm.MovVal ~
Almtmovm.Codmov Almtmovm.Desmov Almtmovm.PidRef1 Almtmovm.GloRf1 ~
Almtmovm.PidRef2 Almtmovm.GloRf2 Almtmovm.PidCli Almtmovm.PidPro ~
Almtmovm.MovCmp Almtmovm.MovTrf Almtmovm.ModCsM Almtmovm.PidPCo ~
Almtmovm.UndIng Almtmovm.CodMon Almtmovm.GloRf3 
&Scoped-define ENABLED-TABLES Almtmovm
&Scoped-define FIRST-ENABLED-TABLE Almtmovm
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-5 
&Scoped-Define DISPLAYED-FIELDS Almtmovm.Indicador[6] Almtmovm.Indicador[2] ~
Almtmovm.Indicador[1] Almtmovm.PidRef3 Almtmovm.TpoCto Almtmovm.MovVal ~
Almtmovm.Codmov Almtmovm.Desmov Almtmovm.PidRef1 Almtmovm.GloRf1 ~
Almtmovm.PidRef2 Almtmovm.GloRf2 Almtmovm.PidCli Almtmovm.PidPro ~
Almtmovm.MovCmp Almtmovm.MovTrf Almtmovm.ModCsM Almtmovm.PidPCo ~
Almtmovm.UndIng Almtmovm.CodMon Almtmovm.GloRf3 
&Scoped-define DISPLAYED-TABLES Almtmovm
&Scoped-define FIRST-DISPLAYED-TABLE Almtmovm


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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 9.96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.14 BY 1.04.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.29 BY 2.46.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 1.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almtmovm.Indicador[6] AT ROW 9.73 COL 11.86 WIDGET-ID 18
          LABEL "Desactivado"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .77
          FONT 6
     Almtmovm.Indicador[2] AT ROW 4.81 COL 52 WIDGET-ID 10
          LABEL "VºBº Administrador"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .69
          BGCOLOR 11 FGCOLOR 15 
     Almtmovm.Indicador[1] AT ROW 3.85 COL 52 WIDGET-ID 6
          LABEL "Movimiento RESERVADO"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .77
          BGCOLOR 12 FGCOLOR 15 
     Almtmovm.PidRef3 AT ROW 4 COL 11.57 WIDGET-ID 2
          LABEL "3ra referencia"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .77
     Almtmovm.TpoCto AT ROW 2.77 COL 50.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Cero", 0,
"Manual", 1,
"Automatico", 2
          SIZE 25.29 BY .73
     Almtmovm.MovVal AT ROW 7.58 COL 35.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.14 BY .77
     Almtmovm.Codmov AT ROW 1.31 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .69
     Almtmovm.Desmov AT ROW 1.31 COL 23.29 COLON-ALIGNED NO-LABEL FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 38 BY .69
     Almtmovm.PidRef1 AT ROW 2.38 COL 11.57
          LABEL "1ra referencia"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .69
     Almtmovm.GloRf1 AT ROW 2.38 COL 23.29 COLON-ALIGNED NO-LABEL FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 18 BY .69
     Almtmovm.PidRef2 AT ROW 3.19 COL 11.57
          LABEL "2da referencia"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .69
     Almtmovm.GloRf2 AT ROW 3.19 COL 23.29 COLON-ALIGNED NO-LABEL FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 18 BY .69
     Almtmovm.PidCli AT ROW 4.92 COL 11.72
          LABEL "Registrar al cliente"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .69
     Almtmovm.PidPro AT ROW 5.73 COL 11.72
          LABEL "Registrar al proveedor"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .69
     Almtmovm.MovCmp AT ROW 5.62 COL 52
          LABEL "Ingreso por Compra"
          VIEW-AS TOGGLE-BOX
          SIZE 16.43 BY .69
     Almtmovm.MovTrf AT ROW 6.42 COL 52
          LABEL "Ingreso por Transferencia"
          VIEW-AS TOGGLE-BOX
          SIZE 20.57 BY .69
     Almtmovm.ModCsM AT ROW 6.58 COL 11.72
          LABEL "Control de Compras"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .69
     Almtmovm.PidPCo AT ROW 7.54 COL 11.72
          LABEL "Modificar Precio de Costo"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .69
     Almtmovm.UndIng AT ROW 8.54 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Stock ", "S":U,
"Compra", "C":U,
"Venta ", "V":U
          SIZE 22.86 BY .77
     Almtmovm.CodMon AT ROW 8.23 COL 61.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2,
"Selectivo", 3
          SIZE 11.86 BY 1.81
     Almtmovm.GloRf3 AT ROW 4 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 18 BY .69
     "Unidad de Ingreso :" VIEW-AS TEXT
          SIZE 13.43 BY .69 AT ROW 8.58 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 7.62 COL 60.72
     "Tipo de Costo" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 2.08 COL 50.72
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 8.46 COL 21.14
     RECT-3 AT ROW 7.81 COL 60
     RECT-5 AT ROW 2.62 COL 50.14 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almtmovm
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
         HEIGHT             = 10.19
         WIDTH              = 78.29.
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

/* SETTINGS FOR FILL-IN Almtmovm.Desmov IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almtmovm.GloRf1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almtmovm.GloRf2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almtmovm.GloRf3 IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.Indicador[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.Indicador[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.Indicador[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.ModCsM IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.MovCmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.MovTrf IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidPCo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidRef1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidRef2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almtmovm.PidRef3 IN FRAME F-Main
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

&Scoped-define SELF-NAME Almtmovm.GloRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.GloRf1 V-table-Win
ON ENTRY OF Almtmovm.GloRf1 IN FRAME F-Main /* Glosa 1 */
DO:
  IF Almtmovm.PidRef1:SCREEN-VALUE = 'No' THEN DO:
     APPLY "ENTRY" TO Almtmovm.PidRef2.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.GloRf2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.GloRf2 V-table-Win
ON ENTRY OF Almtmovm.GloRf2 IN FRAME F-Main /* Glosa 2 */
DO:
  IF Almtmovm.PidRef2:SCREEN-VALUE = 'No' THEN DO:
     APPLY "ENTRY" TO Almtmovm.PidCli.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.TpoCto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.TpoCto V-table-Win
ON VALUE-CHANGED OF Almtmovm.TpoCto IN FRAME F-Main /* Tipo de Costo */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) = 2 THEN DO:
      MESSAGE  "El Costo Automático recalculará los Costos de Ingreso " SKIP
               "Por tal motivo, primero se igualaran a CERO " SKIP
               "Tenga cuidado al elegir esta opcion" SKIP
               "Consulte con el Dpto de Contabilidad" 
      VIEW-AS ALERT-BOX INFORMATION.
     
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
  {src/adm/template/row-list.i "Almtmovm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almtmovm"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR S-SUBTIT AS CHAR .
  DEFINE VAR X-TITU AS CHAR.

  X-TITU = "CONFIGURACION DE MOVIMIENTOS DE INGRESO".

  DEFINE FRAME F-REPORTE
        Almtmovm.CodMov  FORMAt "99"
        Almtmovm.DesMov  FORMAT "x(45)"
        Almtmovm.Pidref1 FORMAT "SI/NO" AT 55
        Almtmovm.Pidref2 FORMAT "SI/NO" AT 65
        Almtmovm.PidCli  FORMAT "SI/NO" AT 75 
        Almtmovm.PidPro  FORMAT "SI/NO" AT 85
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(50)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 110 FORMAT "X(15)" TODAY TO 122 FORMAT "99/99/9999" SKIP
        "-------------------------------------------------------------------------------------------" SKIP
        "                                                   1era      2da       Reg. al   Reg. al  " SKIP
        " CODIGO  D E S C R I P C I O N                     Ref       Ref       Cliente   Provee.  " SKIP
        "-------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH Almtmovm NO-LOCK WHERE Almtmovm.Codcia = S-CODCIA AND
                                  Almtmovm.Tipmov = S-TPOMOV:

      VIEW STREAM REPORT FRAME F-HEADER.
      
      DISPLAY STREAM REPORT 
        Almtmovm.CodMov  
        Almtmovm.DesMov  
        Almtmovm.Pidref1 
        Almtmovm.Pidref2 
        Almtmovm.PidCli  
        Almtmovm.PidPro  
      WITH FRAME F-REPORTE.

      DOWN STREAM REPORT WITH FRAME F-REPORTE.   

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
  ASSIGN Almtmovm.CodCia = S-CODCIA
         Almtmovm.Tipmov = S-TPOMOV.
  IF Almtmovm.MovCmp THEN DO:
     ASSIGN 
/*          Almtmovm.Desmov  = "Ingreso por Orden de Compra" */
         Almtmovm.GloRf1  = "Orden de Compra"
         Almtmovm.PidPCo  = YES
         Almtmovm.ModCsM  = YES
         Almtmovm.PidRef1 = YES
         Almtmovm.MovTrf  = NO
         Almtmovm.PidCli  = NO 
         Almtmovm.PidPro  = YES.
  END.
  IF Almtmovm.MovTrf THEN DO:
     ASSIGN 
         Almtmovm.PidRef1 = YES
         Almtmovm.PidRef2 = YES
         Almtmovm.GloRf1  = "No.Guia"
         Almtmovm.GloRf2  = "No.Pedido"
         Almtmovm.PidPCo  = NO
         Almtmovm.ModCsM  = NO
         Almtmovm.MovCmp  = NO
         Almtmovm.PidCli  = NO 
         Almtmovm.PidPro  = NO.
  END.
  IF Almtmovm.MovVal THEN ASSIGN Almtmovm.PidPCo = TRUE.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  DEFINE VARIABLE L-SiMov AS LOGICAL INIT NO.
  FOR EACH Almacen NO-LOCK WHERE 
           Almacen.CodCia = S-CODCIA :
      FIND FIRST Almcmov WHERE 
                 Almcmov.CodCia = Almtmovm.CodCia AND  
                 Almcmov.CodAlm = Almacen.CodAlm  AND
                 Almcmov.TipMov = Almtmovm.Tipmov AND  
                 Almcmov.CodMov = Almtmovm.Codmov 
                 NO-LOCK NO-ERROR.
      IF AVAILABLE Almcmov THEN DO:
         L-SiMov = YES.
         LEAVE.
      END.
  END.
  IF L-SiMov THEN DO:
     MESSAGE "Codigo tiene movimientos" SKIP "No se puede eliminar"
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  FOR EACH Almtdocm WHERE 
           Almtdocm.CodCia = Almtmovm.CodCia AND  
           Almtdocm.TipMov = Almtmovm.Tipmov AND  
           Almtdocm.CodMov = Almtmovm.Codmov:
      DELETE Almtdocm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  {src/adm/template/snd-list.i "Almtmovm"}

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
     IF Almtmovm.MovCmp THEN DO:
        ASSIGN 
/*             Almtmovm.Desmov:SCREEN-VALUE = "Ingreso por Orden de Compra" */
/*             Almtmovm.GloRf1:SCREEN-VALUE = "Orden de Compra"             */
            Almtmovm.Codmov:SENSITIVE  = NO
/*                Almtmovm.Desmov:SENSITIVE  = NO */
/*                Almtmovm.GloRf1:SENSITIVE  = NO */
/*                Almtmovm.ModCsM:SENSITIVE  = NO */
/*                Almtmovm.PidPCo:SENSITIVE  = NO */
/*                Almtmovm.PidRef1:SENSITIVE = NO */
/*                Almtmovm.MovTrf:SENSITIVE  = NO */
/*                Almtmovm.PidCli:SENSITIVE  = NO */
/*                Almtmovm.PidPro:SENSITIVE  = NO */
            .
     END.
     IF Almtmovm.MovTrf THEN DO:
        ASSIGN 
/*             Almtmovm.GloRf1:SCREEN-VALUE = "No.Guia"   */
/*             Almtmovm.GloRf2:SCREEN-VALUE = "No.Pedido" */
            Almtmovm.Codmov:SENSITIVE  = NO
/*                Almtmovm.PidRef1:SENSITIVE = NO */
/*                Almtmovm.GloRf1:SENSITIVE  = NO */
/*                Almtmovm.PidRef2:SENSITIVE = NO */
/*                Almtmovm.GloRf2:SENSITIVE  = NO */
/*                Almtmovm.PidPCo:SENSITIVE  = NO */
/*                Almtmovm.ModCsM:SENSITIVE  = NO */
/*                Almtmovm.MovCmp:SENSITIVE  = NO */
/*                Almtmovm.PidCli:SENSITIVE  = NO */
/*                Almtmovm.PidPro:SENSITIVE  = NO */
/*                Almtmovm.CodMon:SENSITIVE  = NO */
            .
     END.
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

DO WITH FRAME {&FRAME-NAME} :
   FIND TMOVM WHERE TMOVM.CodCia = S-CODCIA AND
        TMOVM.TipMov = S-TPOMOV AND
        TMOVM.CodMov = INTEGER(Almtmovm.Codmov:SCREEN-VALUE) NO-LOCK NO-ERROR.
   IF AVAILABLE TMOVM AND ROWID(TMOVM) <> ROWID(Almtmovm) THEN DO:
      MESSAGE "Codigo de Movimiento ya Existe"
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmovm.Codmov.
      RETURN "ADM-ERROR".   
   END.

/*   IF Almtmovm.MovCmp:SCREEN-VALUE = "Si" THEN DO:
 *       FIND FIRST TMOVM WHERE TMOVM.CodCia = S-CODCIA AND
 *            TMOVM.TipMov = S-TPOMOV AND
 *            TMOVM.MovCmp NO-LOCK NO-ERROR.
 *       IF AVAILABLE TMOVM AND ROWID(TMOVM) <> ROWID(Almtmovm) THEN DO:
 *          MESSAGE "El movimiento " TMOVM.CodMov SKIP
 *                  " esta asignado como ingreso por compra" VIEW-AS ALERT-BOX ERROR.
 *          APPLY "ENTRY" TO Almtmovm.Codmov.
 *          RETURN "ADM-ERROR".   
 *       END.
 *    END.*/
/*
   IF Almtmovm.MovTrf:SCREEN-VALUE = "Si" THEN DO:
      FIND FIRST TMOVM WHERE TMOVM.CodCia = S-CODCIA AND
           TMOVM.TipMov = S-TPOMOV AND
           TMOVM.MovTrf NO-LOCK NO-ERROR.
      IF AVAILABLE TMOVM AND ROWID(TMOVM) <> ROWID(Almtmovm) THEN DO:
         MESSAGE "El movimiento " TMOVM.CodMov SKIP 
                 " esta asignado como ingreso por Transferencia" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almtmovm.Codmov.
         RETURN "ADM-ERROR".   
      END.
   END.
 */  
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-UpDate V-table-Win 
PROCEDURE Valida-UpDate :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE Almtmovm THEN DO:
   MESSAGE "No existen registros" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

