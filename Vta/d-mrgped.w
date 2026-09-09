&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-FacDPedi NO-UNDO LIKE FacDPedi.



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
DEF INPUT PARAMETER x-Rowid AS ROWID.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.

DEF VAR x-Margen AS DEC FORMAT '->,>>9.99' NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = x-ROWID NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-FacDPedi Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-FacDPedi.codmat Almmmatg.DesMat ~
t-FacDPedi.CanPed t-FacDPedi.UndVta t-FacDPedi.ImpLin t-FacDPedi.MrgUti 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-FacDPedi NO-LOCK, ~
      FIRST Almmmatg OF t-FacDPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-FacDPedi NO-LOCK, ~
      FIRST Almmmatg OF t-FacDPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f_Margen D-Dialog 
FUNCTION f_Margen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "SALIR" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Margen Global" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-FacDPedi, 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-FacDPedi.codmat COLUMN-LABEL "Codigo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      t-FacDPedi.CanPed FORMAT ">,>>>,>>9.9999":U
      t-FacDPedi.UndVta FORMAT "x(8)":U
      t-FacDPedi.ImpLin FORMAT "->>,>>>,>>9.99":U
      t-FacDPedi.MrgUti COLUMN-LABEL "Margen" FORMAT "->>>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 110 BY 7.69
         FONT 2
         TITLE "DETALLE" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.38 COL 3
     FILL-IN-1 AT ROW 9.35 COL 98 COLON-ALIGNED
     Btn_OK AT ROW 10.23 COL 4
     SPACE(101.71) SKIP(0.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "MARGEN GLOBAL Y POR ITEM"
         DEFAULT-BUTTON Btn_OK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-FacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-FacDPedi,INTEGRAL.Almmmatg OF Temp-Tables.t-FacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   > Temp-Tables.t-FacDPedi.codmat
"t-FacDPedi.codmat" "Codigo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   = Temp-Tables.t-FacDPedi.CanPed
     _FldNameList[4]   = Temp-Tables.t-FacDPedi.UndVta
     _FldNameList[5]   = Temp-Tables.t-FacDPedi.ImpLin
     _FldNameList[6]   > Temp-Tables.t-FacDPedi.MrgUti
"t-FacDPedi.MrgUti" "Margen" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* MARGEN GLOBAL Y POR ITEM */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY FILL-IN-1 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-2 Btn_OK 
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
  /* MARGEN GLOBAL */
  DEFINE VAR X-COSTO  AS DECI INIT 0.
  DEFINE VAR T-COSTO  AS DECI INIT 0.
  DEFINE VAR F-MARGEN AS DECI INIT 0.

  DEFINE VAR priMonVta AS INTE NO-UNDO.
  DEFINE VAR priTpoCmb AS DECI NO-UNDO.
  DEFINE VAR pPeldano  AS CHAR INIT '6' NO-UNDO.      /* Por defecto peldaño TIENDAS */
  DEFINE VAR pPreUni   AS DECI NO-UNDO.
  DEFINE VAR pError    AS CHAR NO-UNDO.

  FIND gn-divi WHERE gn-divi.codcia = FacCPedi.codcia AND
      gn-divi.coddiv = FacCPedi.Lista_de_Precios NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi AND GN-DIVI.Grupo_Divi_GG > '' THEN 
      ASSIGN pPeldano = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))) NO-ERROR.

  DEFINE VAR hLocalProc AS HANDLE NO-UNDO.
  
  RUN web/web-library.p PERSISTENT SET hLocalProc.

  SESSION:SET-WAIT-STATE('GENERAL').
  EMPTY TEMP-TABLE t-Facdpedi.

  DEFINE VAR FILL-IN-Lista AS CHAR NO-UNDO.
  DEFINE BUFFER COTIZACION FOR Faccpedi.

  FILL-IN-Lista = ''.
  FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
      AND COTIZACION.coddiv = Faccpedi.coddiv
      AND COTIZACION.coddoc = Faccpedi.codref
      AND COTIZACION.nroped = Faccpedi.nroref
      NO-LOCK NO-ERROR.
  IF AVAILABLE COTIZACION THEN FILL-IN-Lista = COTIZACION.Libre_c01.

  FOR EACH FacDPedi OF FacCPedi NO-LOCK :
      X-COSTO = 0.
      RUN web_api-pricing-margen IN hLocalProc (IF TRUE <> (FILL-IN-Lista > '') THEN Faccpedi.coddiv ELSE FILL-IN-Lista,
                                                Facdpedi.CodMat,
                                                pPeldano,
                                                "C",                    /* Clasificación C por defecto */
                                                Faccpedi.FmaPgo,        /* Condición de venta Contado por defecto */
                                                OUTPUT priMonVta,
                                                OUTPUT priTpoCmb,
                                                OUTPUT x-Costo,
                                                OUTPUT pPreUni,
                                                OUTPUT pError).
      IF TRUE <> (pError > '') THEN DO:
          IF x-Costo = ? OR x-Costo < 0 THEN x-Costo = 0.
          x-Costo = x-Costo * Facdpedi.factor.
          IF Faccpedi.CodMon <> priMonVta THEN DO:
              IF Faccpedi.CodMon = 1 THEN x-Costo = x-Costo * priTpoCmb.
              ELSE x-Costo = x-Costo / priTpoCmb.
          END.
          CREATE t-FacDPedi.
          BUFFER-COPY FacDPedi TO t-FacDPedi.
          t-FacDPedi.MrgUti = ROUND( (( FacDPedi.ImpLin / (X-COSTO * Facdpedi.CanPed) - 1 ) * 100 ), 2 ).
          T-COSTO = T-COSTO + (X-COSTO * FacDPedi.CanPed).
      END.
  END.
  DELETE PROCEDURE hLocalProc.
  SESSION:SET-WAIT-STATE('').
  
  F-MARGEN = ROUND(((( FacCPedi.ImpTot / T-COSTO ) - 1 ) * 100 ),2).

/* Dispatch standard ADM method.                             */
RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

/* Code placed here will execute AFTER standard behavior.    */
DISPLAY F-MARGEN @ FILL-IN-1 WITH FRAME {&FRAME-NAME}.

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
        WHEN "" THEN ASSIGN input-var-1 = "".
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
  {src/adm/template/snd-list.i "t-FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f_Margen D-Dialog 
FUNCTION f_Margen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /* Buscamos el margen del item */
  DEFINE VAR X-COSTO  AS DECI INIT 0.
  DEFINE VAR X-MARGEN AS DECI INIT 0.

  X-COSTO = 0.
  IF FacCPedi.CodMon = 1 THEN DO:
     IF Almmmatg.MonVta = 1 
     THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).
     ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) * FacCPedi.Tpocmb.
  END.        
  IF FacCPedi.CodMon = 2 THEN DO:
     IF Almmmatg.MonVta = 2 
     THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).
     ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) / FacCPedi.Tpocmb.
  END.      
  X-COSTO = X-COSTO * FacDPedi.CanPed * FacDPedi.Factor.
  X-MARGEN = ROUND( ((( FacDPedi.ImpLin / X-COSTO ) - 1 ) * 100 ), 2 ).
  /*
  FOR EACH FacTabla WHERE factabla.codcia = s-codcia
        AND factabla.tabla = 'MG' NO-LOCK:
    IF x-Margen >= factabla.valor[1] AND x-margen < factabla.valor[2]
    THEN RETURN factabla.codigo.
  END.          
  */
  RETURN X-MARGEN.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

