&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE LT-DREPO NO-UNDO LIKE almdrepo.
DEFINE SHARED TEMP-TABLE T-DREPO LIKE almdrepo
       FIELD SolStkAct AS DEC
       FIELD SolStkCom AS DEC
       FIELD SolStkDis AS DEC
       FIELD SolStkMax AS DEC
       FIELD SolStkTra AS DEC
       FIELD DesStkAct AS DEC
       FIELD DesStkCom AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkMax AS DEC
       FIELD PorcReposicion AS DEC
       FIELD FSGrupo AS DEC
       FIELD GrpStkDis AS DEC
       FIELD ControlDespacho AS LOG INITIAL NO
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD DesCmpTra AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
           FIELD DesStkTra AS DEC
           FIELD ClfGral AS CHAR
           FIELD ClfMayo AS CHAR
           FIELD ClfUtil AS CHAR.
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF OUTPUT PARAMETER pParam AS CHAR.
/* Local Variable Definitions ---                                       */

pParam = "".

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
&Scoped-define INTERNAL-TABLES LT-DREPO

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 LT-DREPO.TipMov LT-DREPO.AlmPed ~
LT-DREPO.Item LT-DREPO.CanGen LT-DREPO.CanAten LT-DREPO.CanTran 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 LT-DREPO.TipMov 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 LT-DREPO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 LT-DREPO
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH LT-DREPO NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH LT-DREPO NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 LT-DREPO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 LT-DREPO


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 RECT-10 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Costo FILL-IN-Peso FILL-IN-Volumen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Cancel" 
     SIZE 19 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 19 BY 1.88
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Costo AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 81 BY 1.62
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      LT-DREPO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      LT-DREPO.TipMov COLUMN-LABEL "Estado" FORMAT "X(10)":U WIDTH 12.43
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "","ANULAR" 
                      DROP-DOWN-LIST 
      LT-DREPO.AlmPed FORMAT "x(3)":U
      LT-DREPO.Item COLUMN-LABEL "# Items" FORMAT ">,>>9":U
      LT-DREPO.CanGen COLUMN-LABEL "Costo de Reposición" FORMAT "ZZZ,ZZ9.99":U
      LT-DREPO.CanAten COLUMN-LABEL "Peso (Kg)" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 16.14
      LT-DREPO.CanTran COLUMN-LABEL "Volumen (m3)" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 14.72
  ENABLE
      LT-DREPO.TipMov
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 9.62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1 COL 2 WIDGET-ID 200
     FILL-IN-Costo AT ROW 10.96 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-Peso AT ROW 10.96 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-Volumen AT ROW 10.96 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 12.58 COL 2
     Btn_Cancel AT ROW 12.58 COL 21 WIDGET-ID 16
     "TOTALES" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 11.23 COL 20 WIDGET-ID 14
          FONT 6
     RECT-10 AT ROW 10.69 COL 2 WIDGET-ID 12
     SPACE(1.28) SKIP(2.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "RESUMEN POR ALMACEN DE DESPACHO" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: LT-DREPO T "?" NO-UNDO INTEGRAL almdrepo
      TABLE: T-DREPO T "SHARED" ? INTEGRAL almdrepo
      ADDITIONAL-FIELDS:
          FIELD SolStkAct AS DEC
          FIELD SolStkCom AS DEC
          FIELD SolStkDis AS DEC
          FIELD SolStkMax AS DEC
          FIELD SolStkTra AS DEC
          FIELD DesStkAct AS DEC
          FIELD DesStkCom AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkMax AS DEC
          FIELD PorcReposicion AS DEC
          FIELD FSGrupo AS DEC
          FIELD GrpStkDis AS DEC
          FIELD ControlDespacho AS LOG INITIAL NO
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD DesCmpTra AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
              FIELD DesStkTra AS DEC
              FIELD ClfGral AS CHAR
              FIELD ClfMayo AS CHAR
              FIELD ClfUtil AS CHAR.
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 TEXT-1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Costo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.LT-DREPO"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.LT-DREPO.TipMov
"LT-DREPO.TipMov" "Estado" "X(10)" "character" ? ? ? ? ? ? yes ? no no "12.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," ",ANULAR" ? 5 no 0 no no
     _FldNameList[2]   = Temp-Tables.LT-DREPO.AlmPed
     _FldNameList[3]   > Temp-Tables.LT-DREPO.Item
"LT-DREPO.Item" "# Items" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.LT-DREPO.CanGen
"LT-DREPO.CanGen" "Costo de Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.LT-DREPO.CanAten
"LT-DREPO.CanAten" "Peso (Kg)" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "16.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.LT-DREPO.CanTran
"LT-DREPO.CanTran" "Volumen (m3)" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* RESUMEN POR ALMACEN DE DESPACHO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pParam = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  pParam = "".
  FOR EACH LT-DREPO WHERE LT-DREPO.TipMov = "ANULAR":
      IF LOOKUP(LT-DREPO.AlmPed, pParam) = 0 
          THEN pParam = pParam + (IF TRUE <> (pParam > '') THEN '' ELSE ',') + LT-DREPO.AlmPed.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE LT-DREPO.

ASSIGN
    FILL-IN-Costo = 0
    FILL-IN-Peso = 0
    FILL-IN-Volumen = 0.
FOR EACH T-DREPO, FIRST Almmmatg OF T-DREPO NO-LOCK:
    FIND LT-DREPO WHERE LT-DREPO.AlmPed = T-DREPO.AlmPed NO-ERROR.
    IF NOT AVAILABLE LT-DREPO THEN CREATE LT-DREPO.
    ASSIGN
        LT-DREPO.AlmPed = T-DREPO.AlmPed
        LT-DREPO.CanAten = LT-DREPO.CanAten + (T-DREPO.CanGen * Almmmatg.Pesmat )
        LT-DREPO.CanGen = LT-DREPO.CanGen + T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot)
        LT-DREPO.CanTran = LT-DREPO.CanTran + (T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000)
        LT-DREPO.ITEM = LT-DREPO.ITEM + 1.
END.
FOR EACH LT-DREPO NO-LOCK:
    ASSIGN
        FILL-IN-Costo = FILL-IN-Costo + LT-DREPO.CanGen
        FILL-IN-Peso = FILL-IN-Peso + LT-DREPO.CanAten
        FILL-IN-Volumen = FILL-IN-Volumen + LT-DREPO.CanTran.
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
  DISPLAY FILL-IN-Costo FILL-IN-Peso FILL-IN-Volumen 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-2 RECT-10 Btn_OK Btn_Cancel 
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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
  {src/adm/template/snd-list.i "LT-DREPO"}

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

