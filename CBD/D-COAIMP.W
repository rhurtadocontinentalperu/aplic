&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE        VAR X-TASK-NO AS INTEGER NO-UNDO.
DEFINE        VAR I-NroMes1 AS INTEGER NO-UNDO.
DEFINE        VAR I-NroMes2 AS INTEGER NO-UNDO.
DEFINE        VAR I-NroItm  AS INTEGER NO-UNDO.
DEFINE        VAR I-NroOpe  AS INTEGER NO-UNDO.
DEFINE        VAR L-Salir   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE        VAR x-lisope  AS CHAR    NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

FIND cb-cfgg WHERE cb-cfgg.CODCIA = 0 AND cb-cfgg.CODCFG = "R01" NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Compras" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.

x-lisope = cb-cfgg.codope.

DEFINE TEMP-TABLE T-X78COA LIKE integral.X78CPCOA.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-oper

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 cb-oper.Codope cb-oper.Nomope 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH cb-oper ~
      WHERE cb-oper.CodCia = 0 ~
 AND LOOKUP( cb-oper.Codope, x-lisope) > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH cb-oper ~
      WHERE cb-oper.CodCia = 0 ~
 AND LOOKUP( cb-oper.Codope, x-lisope) > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 cb-oper
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 cb-oper


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CB-Mes2 F-Coddiv CB-Mes1 Btn_OK Btn_Cancel ~
BROWSE-1 RECT-55 
&Scoped-Define DISPLAYED-OBJECTS CB-Mes2 F-Coddiv CB-Mes1 F-Proceso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE CB-Mes1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE CB-Mes2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-Coddiv AS CHARACTER FORMAT "X(6)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .81 NO-UNDO.

DEFINE VARIABLE F-Proceso AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesando" 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.43 BY 8.65.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      cb-oper SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 D-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      cb-oper.Codope FORMAT "xxx":U
      cb-oper.Nomope FORMAT "x(32)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 31.86 BY 4
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CB-Mes2 AT ROW 2.85 COL 8.57 COLON-ALIGNED
     F-Coddiv AT ROW 2.96 COL 32.57 COLON-ALIGNED
     CB-Mes1 AT ROW 1.73 COL 8.72 COLON-ALIGNED
     F-Proceso AT ROW 8.35 COL 14.29 COLON-ALIGNED
     Btn_OK AT ROW 3.23 COL 52.57
     Btn_Cancel AT ROW 5.46 COL 52.57
     BROWSE-1 AT ROW 4.08 COL 9.57
     RECT-55 AT ROW 1.08 COL 1.72
     SPACE(14.56) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "COA - POLIZAS DE IMPORTACION".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 Btn_Cancel D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-Proceso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "integral.cb-oper"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.cb-oper.CodCia = 0
 AND LOOKUP( integral.cb-oper.Codope, x-lisope) > 0"
     _FldNameList[1]   = integral.cb-oper.Codope
     _FldNameList[2]   > integral.cb-oper.Nomope
"cb-oper.Nomope" ? "x(32)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* COA - POLIZAS DE IMPORTACION */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  L-Salir = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN CB-Mes1 CB-Mes2 F-Coddiv.
  I-NroMes1 = LOOKUP(CB-MES1,CB-MES1:LIST-ITEMS).
  I-NroMes2 = LOOKUP(CB-MES2,CB-MES1:LIST-ITEMS).
  F-Proceso:VISIBLE = YES.
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
     MESSAGE 'Aun no se ha seleccionado Operaciones Contables' VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  RUN Carga-Tempo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo D-Dialog 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose: Carga archivo temporal segun parametros ingresados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR L-Ubica   AS LOGICAL INIT YES NO-UNDO. 
DEFINE VAR F-IMPORTE AS DECIMAL NO-UNDO.
DEFINE VAR ii        AS INTEGER NO-UNDO.
DEFINE VAR jj        AS INTEGER NO-UNDO.
DEFINE VAR C-OPER    AS CHAR    NO-UNDO.
I-NroItm = 0.

/* Limpia información para reproceso */
DO ii = I-NroMes1 TO I-NroMes2:
   FOR EACH integral.X78CPCOA WHERE X78CPCOA.X78Periodo = STRING(s-Periodo, '9999') AND
       X78CPCOA.X78F_PAGO BEGINS (STRING(s-Periodo, '9999') + STRING(ii, '99')) :
       DELETE integral.X78CPCOA.
   END.
END. 
  
RegCmp:
DO WITH FRAME {&FRAME-NAME}:
  DO ii = I-NroMes1 TO I-NroMes2:
    DO jj = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
       IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(jj) THEN 
          FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.Codcia = S-CODCIA AND
                   cb-cmov.Periodo = S-PERIODO      AND
                   cb-cmov.Nromes =  ii             AND
                   cb-cmov.Codope =  cb-oper.codope AND 
                   NOT L-Salir:
              IF F-CodDiv NE "" AND F-CodDiv NE cb-cmov.CodDiv THEN NEXT.
              F-Proceso = "VOUCHER : " + cb-cmov.Codope + "-" + cb-cmov.NroAst.
              DISPLAY F-Proceso WITH FRAME {&FRAME-NAME}.
              RegDet:
              FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.Codcia = cb-cmov.Codcia AND
                   cb-dmov.Periodo = cb-cmov.Periodo AND
                   cb-dmov.Nromes = cb-cmov.Nromes  AND
                   cb-dmov.Codope = cb-cmov.Codope AND
                   cb-dmov.NroAst = cb-cmov.NroAst 
                   BREAK BY cb-dmov.NroAst:
                   IF FIRST-OF(cb-dmov.NroAst) THEN DO:
                      CREATE T-X78COA. 
                      ASSIGN T-X78COA.X78NORDEN  = cb-dmov.NroAst
                             T-X78COA.X78PERIODO = STRING(cb-dmov.periodo,"9999") + STRING(cb-dmov.NroMes,"99")
                             T-X78COA.X78CODIGO  = "001".
                   END.
                   /* IF cb-dmov.TpoItm = "A" OR cb-dmov.TpoItm = "N" THEN NEXT. */
                   IF cb-dmov.TpoItm <> "" THEN NEXT.
                   I-NroItm = I-NroItm + 1.
                   L-Ubica = NO.
/*                 F-IMPORTE = IF cb-dmov.codmon = 1 THEN cb-dmov.ImpMn1 ELSE cb-dmov.ImpMn2.*/
                   F-IMPORTE = cb-dmov.ImpMn1.
                   IF cb-dmov.codcta = '60110201' THEN
                      ASSIGN 
                         T-X78COA.X78M_IMPOR = F-IMPORTE.
                   IF cb-dmov.codcta = '60910101' THEN
                      ASSIGN 
                         T-X78COA.X78ADVALOR = F-IMPORTE.
                   IF cb-dmov.CodCta BEGINS "40" AND 
                      cb-dmov.CodCta BEGINS "4011" THEN DO:
                      ASSIGN 
                         T-X78COA.X78IGV = F-IMPORTE.
                      L-Ubica = YES.
                   END.
      
                   IF NOT L-Ubica AND (cb-dmov.CodCta BEGINS "42" OR cb-dmov.CodCta BEGINS "46") AND
                      (cb-dmov.CodCta NE "42130101" AND cb-dmov.CodCta NE "42130102") THEN DO:
                      IF NOT cb-dmov.TpoMov THEN F-IMPORTE = F-IMPORTE * -1.
                      ASSIGN /*T-X78COA.X78BASE     = F-IMPORTE*/
                             T-X78COA.X78F_PAGO   = string(YEAR(cb-dmov.FchDoc),"9999") + string(MONTH(cb-dmov.FchDoc),"99") + STRING(DAY(cb-dmov.FchDoc),"99")
                             T-X78COA.X78TIPO     = cb-dmov.CodDoc
                             T-X78COA.X78NUMPOL   = cb-dmov.NroDoc.
      
                      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                           gn-prov.CodPro = cb-dmov.CodAux NO-LOCK NO-ERROR.
                      L-Ubica = YES.
                   END.
              END.
              PROCESS EVENTS.
          END.
    END.  
  END.
END.

/** LIMPIA DATOS ***/
I-NroItm = 0.
FOR EACH T-X78COA BREAK BY T-X78COA.X78PERIODO:
    IF LOOKUP(T-X78COA.X78TIPO, 'DUI') = 0 THEN DO:
       DELETE T-X78COA.
       NEXT.
    END.
    I-NroItm = I-NroItm + 1.
    ASSIGN 
       T-X78COA.X78NROREG = I-NroItm
       T-X78COA.X78ESTADO = '0'.
    RELEASE T-X78COA.
END.

/* Carga a la Base integral */
FOR EACH T-X78COA:
   CREATE integral.X78CPCOA.
   RAW-TRANSFER T-X78COA TO integral.X78CPCOA.
   ASSIGN 
      X78CPCOA.X78TIPO = '50'.
END.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY CB-Mes2 F-Coddiv CB-Mes1 F-Proceso 
      WITH FRAME D-Dialog.
  ENABLE CB-Mes2 F-Coddiv CB-Mes1 Btn_OK Btn_Cancel BROWSE-1 RECT-55 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
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
     CB-Mes1:SCREEN-VALUE = ENTRY(S-NroMes,CB-Mes1:LIST-ITEMS).
     CB-Mes2:SCREEN-VALUE = ENTRY(S-NroMes,CB-Mes2:LIST-ITEMS).
     F-Proceso:VISIBLE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "F-CodDoc" THEN ASSIGN input-var-1 = "02".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-oper"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

