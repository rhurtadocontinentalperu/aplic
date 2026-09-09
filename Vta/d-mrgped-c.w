&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg almmmatp

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacDPedi.codmat Almmmatg.DesMat ~
FacDPedi.CanPed FacDPedi.UndVta FacDPedi.ImpLin f_Margen() @ x-Margen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacDPedi ~
      WHERE FacDPedi.CodCia = faccpedi.codcia ~
 AND FacDPedi.CodDoc = faccpedi.coddoc ~
 AND FacDPedi.NroPed = faccpedi.nroped NO-LOCK, ~
      FIRST Almmmatg OF FacDPedi NO-LOCK, ~
      FIRST almmmatp OF FacDPedi NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacDPedi Almmmatg almmmatp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacDPedi


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

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Margen Global" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacDPedi, 
      Almmmatg, 
      almmmatp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacDPedi.codmat COLUMN-LABEL "Codigo"
      Almmmatg.DesMat
      FacDPedi.CanPed FORMAT ">>,>>9.9999"
      FacDPedi.UndVta
      FacDPedi.ImpLin FORMAT "->>>,>>9.99"
      f_Margen() @ x-Margen COLUMN-LABEL "Margen"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 93 BY 7.69
         FONT 2
         TITLE "DETALLE".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.38 COL 3
     Btn_OK AT ROW 10.23 COL 4
     FILL-IN-1 AT ROW 9.27 COL 82 COLON-ALIGNED
     SPACE(5.99) SKIP(1.84)
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
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
     _TblList          = "INTEGRAL.FacDPedi,INTEGRAL.Almmmatg OF INTEGRAL.FacDPedi,INTEGRAL.almmmatp OF INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST"
     _Where[1]         = "INTEGRAL.FacDPedi.CodCia = faccpedi.codcia
 AND INTEGRAL.FacDPedi.CodDoc = faccpedi.coddoc
 AND INTEGRAL.FacDPedi.NroPed = faccpedi.nroped"
     _FldNameList[1]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" ? ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   = INTEGRAL.FacDPedi.UndVta
     _FldNameList[5]   > INTEGRAL.FacDPedi.ImpLin
"FacDPedi.ImpLin" ? "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[6]   > "_<CALC>"
"f_Margen() @ x-Margen" "Margen" ? ? ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/* MARGEN GLOBAL */
   DEFINE VAR X-COSTO  AS DECI INIT 0.
   DEFINE VAR T-COSTO  AS DECI INIT 0.
   DEFINE VAR F-MARGEN AS DECI INIT 0.

   FOR EACH FacDPedi OF FacCPedi NO-LOCK :
       FIND Almmmatp WHERE Almmmatp.Codcia = S-CODCIA AND
                           Almmmatp.Codmat = FacDPedi.Codmat NO-LOCK NO-ERROR.
       X-COSTO = 0.
       IF AVAILABLE Almmmatp THEN DO:
          IF FacCPedi.CodMon = 1 THEN DO:
             IF Almmmatp.MonVta = 1 THEN 
                ASSIGN X-COSTO = (Almmmatp.Ctotot).
             ELSE
                ASSIGN X-COSTO = (Almmmatp.Ctotot) * FacCPedi.Tpocmb .
          END.        
          IF FacCPedi.CodMon = 2 THEN DO:
             IF Almmmatp.MonVta = 2 THEN
                ASSIGN X-COSTO = (Almmmatp.Ctotot).
             ELSE
                ASSIGN X-COSTO = (Almmmatp.Ctotot) / FacCPedi.Tpocmb .
          END.      
          T-COSTO = T-COSTO + X-COSTO * FacDPedi.CanPed * FacDPedi.Factor.          
       END.
   END.
   F-MARGEN = ROUND(((( FacCPedi.ImpTot / T-COSTO ) - 1 ) * 100 ),2).
   DISPLAY F-MARGEN @ FILL-IN-1 WITH FRAME {&FRAME-NAME}.
   
  /*
  FOR EACH FacTabla WHERE factabla.codcia = s-codcia
        AND factabla.tabla = 'MG' NO-LOCK:
    IF f-Margen >= factabla.valor[1] AND f-margen < factabla.valor[2]
    THEN FILL-IN-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.codigo.
  END.          
  */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "almmmatp"}

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
     IF Almmmatp.MonVta = 1 
     THEN ASSIGN X-COSTO = (Almmmatp.Ctotot).
     ELSE ASSIGN X-COSTO = (Almmmatp.Ctotot) * FacCPedi.Tpocmb.
  END.        
  IF FacCPedi.CodMon = 2 THEN DO:
     IF Almmmatp.MonVta = 2 
     THEN ASSIGN X-COSTO = (Almmmatp.Ctotot).
     ELSE ASSIGN X-COSTO = (Almmmatp.Ctotot) / FacCPedi.Tpocmb.
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


