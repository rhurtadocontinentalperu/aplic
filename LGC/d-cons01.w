&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pCodMat AS CHAR.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEFINE VAR F-PRETOT AS DECIMAL NO-UNDO.
DEFINE VAR X-MONEDA AS CHAR NO-UNDO.
DEFINE VAR x-Estado AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LG-dmatpr LG-cmatpr gn-prov

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 LG-cmatpr.nrolis ~
fEstado() @ x-Estado gn-prov.NomPro LG-cmatpr.FchEmi LG-cmatpr.FchVto ~
X-MONEDA @ X-MONEDA LG-dmatpr.PreAct LG-dmatpr.IgvMat LG-dmatpr.Dsctos[1] ~
LG-dmatpr.Dsctos[2] LG-dmatpr.Dsctos[3] LG-dmatpr.PreCos ~
F-PRETOT @ F-PRETOT 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH LG-dmatpr ~
      WHERE LG-dmatpr.CodCia = s-codcia ~
 AND LG-dmatpr.codmat = pcodmat NO-LOCK, ~
      EACH LG-cmatpr OF LG-dmatpr NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = pv-codcia  ~
  AND gn-prov.CodPro = LG-cmatpr.CodPro NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH LG-dmatpr ~
      WHERE LG-dmatpr.CodCia = s-codcia ~
 AND LG-dmatpr.codmat = pcodmat NO-LOCK, ~
      EACH LG-cmatpr OF LG-dmatpr NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = pv-codcia  ~
  AND gn-prov.CodPro = LG-cmatpr.CodPro NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 LG-dmatpr LG-cmatpr gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 LG-dmatpr
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 LG-cmatpr
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 gn-prov


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado gDialog 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      LG-dmatpr, 
      LG-cmatpr, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      LG-cmatpr.nrolis FORMAT "999999":U
      fEstado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(10)":U
            WIDTH 9.29
      gn-prov.NomPro FORMAT "x(50)":U WIDTH 33.43
      LG-cmatpr.FchEmi FORMAT "99/99/9999":U
      LG-cmatpr.FchVto FORMAT "99/99/9999":U
      X-MONEDA @ X-MONEDA COLUMN-LABEL "Mon" FORMAT "X(4)":U
      LG-dmatpr.PreAct COLUMN-LABEL "Precio Lista !    Actual" FORMAT ">>,>>9.9999":U
      LG-dmatpr.IgvMat FORMAT ">>9.99":U
      LG-dmatpr.Dsctos[1] COLUMN-LABEL "%Dscto!1" FORMAT "->>9.99":U
      LG-dmatpr.Dsctos[2] COLUMN-LABEL "%Dscto!2" FORMAT "->>9.99":U
      LG-dmatpr.Dsctos[3] COLUMN-LABEL "%Dscto!3" FORMAT "->>9.99":U
            WIDTH 7
      LG-dmatpr.PreCos COLUMN-LABEL "Valor Compra! Neto      .!   Sin IGV    ." FORMAT ">>,>>9.9999":U
            WIDTH 12.43
      F-PRETOT @ F-PRETOT COLUMN-LABEL "Precio    !Compra Neto!   Incl. IGV   ." FORMAT ">>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 130 BY 10.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 1.27 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 12.04 COL 2
     Btn_Cancel AT ROW 12.04 COL 17
     SPACE(100.85) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "LISTAS DE PRECIOS"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.LG-dmatpr,INTEGRAL.LG-cmatpr OF INTEGRAL.LG-dmatpr,INTEGRAL.gn-prov WHERE INTEGRAL.LG-cmatpr ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "LG-dmatpr.CodCia = s-codcia
 AND LG-dmatpr.codmat = pcodmat"
     _JoinCode[3]      = "gn-prov.CodCia = pv-codcia 
  AND gn-prov.CodPro = LG-cmatpr.CodPro"
     _FldNameList[1]   = INTEGRAL.LG-cmatpr.nrolis
     _FldNameList[2]   > "_<CALC>"
"fEstado() @ x-Estado" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-prov.NomPro
"gn-prov.NomPro" ? ? "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.LG-cmatpr.FchEmi
     _FldNameList[5]   = INTEGRAL.LG-cmatpr.FchVto
     _FldNameList[6]   > "_<CALC>"
"X-MONEDA @ X-MONEDA" "Mon" "X(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.LG-dmatpr.PreAct
"LG-dmatpr.PreAct" "Precio Lista !    Actual" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.LG-dmatpr.IgvMat
     _FldNameList[9]   > INTEGRAL.LG-dmatpr.Dsctos[1]
"LG-dmatpr.Dsctos[1]" "%Dscto!1" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.LG-dmatpr.Dsctos[2]
"LG-dmatpr.Dsctos[2]" "%Dscto!2" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.LG-dmatpr.Dsctos[3]
"LG-dmatpr.Dsctos[3]" "%Dscto!3" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.LG-dmatpr.PreCos
"LG-dmatpr.PreCos" "Valor Compra! Neto      .!   Sin IGV    ." ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"F-PRETOT @ F-PRETOT" "Precio    !Compra Neto!   Incl. IGV   ." ">>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* LISTAS DE PRECIOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
ON FIND OF LG-dmatpr
DO:
  F-PRETOT = ROUND(LG-dmatpr.PreAct * 
             (1 - (LG-dmatpr.Dsctos[1] / 100)) *
             (1 - (LG-dmatpr.Dsctos[2] / 100)) *
             (1 - (LG-dmatpr.Dsctos[3] / 100)) *
             (1 + (LG-dmatpr.IgvMat / 100)) , 4).
  
     X-MONEDA = IF LG-dmatpr.CodMon = 1 THEN "S/." ELSE "US$".

END.

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  ENABLE BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado gDialog 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE LG-cmatpr.FlgEst:
        WHEN "A" THEN RETURN "ACTIVO".
        WHEN "D" THEN RETURN "DESACTIVADO".
        WHEN ""  THEN RETURN "PENDIENTE".
    END CASE.        
    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

