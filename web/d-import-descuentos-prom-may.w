&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DPROM NO-UNDO LIKE VtaDctoProm.
DEFINE TEMP-TABLE T-DPROM2 NO-UNDO LIKE VtaDctoProm.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat FchPrmD.
DEFINE TEMP-TABLE t-VtaDctoProm NO-UNDO LIKE VtaDctoProm.



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
DEFINE INPUT PARAMETER RADIO-SET-1 AS INTE.
DEFINE INPUT PARAMETER pReemplazar AS LOG.
DEFINE INPUT PARAMETER x-MetodoActualizacion AS INTE.
DEFINE INPUT PARAMETER f-Division AS CHAR.
DEFINE INPUT PARAMETER TABLE FOR T-DPROM2.
DEFINE INPUT PARAMETER TABLE FOR T-MATG.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE BUFFER b-Vtadctoprom FOR t-Vtadctoprom.

/* Solo divisiones afectas */
DEF VAR x-Divisiones AS CHAR NO-UNDO.
FOR EACH T-DPROM2 NO-LOCK BREAK BY T-DPROM2.CodDiv:
    IF FIRST-OF(T-DPROM2.CodDiv) THEN DO:
        X-Divisiones = x-Divisiones + (IF TRUE <> (x-Divisiones > '') THEN '' ELSE ',') + T-DPROM2.CodDiv.
    END.
END.
f-Division = TRIM(f-Division).      /* Para que no falle el lookup o can-do */

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
&Scoped-define INTERNAL-TABLES t-VtaDctoProm Almmmatg GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-VtaDctoProm.CodMat ~
Almmmatg.DesMat t-VtaDctoProm.CodDiv GN-DIVI.DesDiv t-VtaDctoProm.FchIni ~
t-VtaDctoProm.FchFin t-VtaDctoProm.Descuento t-VtaDctoProm.Tipo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-VtaDctoProm ~
      WHERE t-VtaDctoProm.FlgEst = "A" ~
 AND (t-VtaDctoProm.FchIni >= TODAY OR  ~
t-VtaDctoProm.FchFin >= TODAY) NO-LOCK, ~
      FIRST Almmmatg OF t-VtaDctoProm NO-LOCK, ~
      FIRST GN-DIVI OF t-VtaDctoProm NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-VtaDctoProm ~
      WHERE t-VtaDctoProm.FlgEst = "A" ~
 AND (t-VtaDctoProm.FchIni >= TODAY OR  ~
t-VtaDctoProm.FchFin >= TODAY) NO-LOCK, ~
      FIRST Almmmatg OF t-VtaDctoProm NO-LOCK, ~
      FIRST GN-DIVI OF t-VtaDctoProm NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-VtaDctoProm Almmmatg GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-VtaDctoProm
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "REGRESAR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-VtaDctoProm, 
      Almmmatg
    FIELDS(Almmmatg.DesMat), 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-VtaDctoProm.CodMat COLUMN-LABEL "Articulo" FORMAT "X(10)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 51.86
      t-VtaDctoProm.CodDiv COLUMN-LABEL "División" FORMAT "x(8)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 31.86
      t-VtaDctoProm.FchIni FORMAT "99/99/9999":U
      t-VtaDctoProm.FchFin FORMAT "99/99/9999":U
      t-VtaDctoProm.Descuento COLUMN-LABEL "Descuento (%)" FORMAT ">>>,>>9.999999":U
      t-VtaDctoProm.Tipo FORMAT "x(15)":U WIDTH 14.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146 BY 16.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.54 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 18.23 COL 2
     SPACE(134.42) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DPROM T "?" NO-UNDO INTEGRAL VtaDctoProm
      TABLE: T-DPROM2 T "?" NO-UNDO INTEGRAL VtaDctoProm
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat FchPrmD
      END-FIELDS.
      TABLE: t-VtaDctoProm T "?" NO-UNDO INTEGRAL VtaDctoProm
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
/* BROWSE-TAB BROWSE-2 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-VtaDctoProm,INTEGRAL.Almmmatg OF Temp-Tables.t-VtaDctoProm,INTEGRAL.GN-DIVI OF Temp-Tables.t-VtaDctoProm"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _Where[1]         = "t-VtaDctoProm.FlgEst = ""A""
 AND (t-VtaDctoProm.FchIni >= TODAY OR 
t-VtaDctoProm.FchFin >= TODAY)"
     _FldNameList[1]   > Temp-Tables.t-VtaDctoProm.CodMat
"t-VtaDctoProm.CodMat" "Articulo" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "51.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-VtaDctoProm.CodDiv
"t-VtaDctoProm.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "31.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.t-VtaDctoProm.FchIni
     _FldNameList[6]   = Temp-Tables.t-VtaDctoProm.FchFin
     _FldNameList[7]   > Temp-Tables.t-VtaDctoProm.Descuento
"t-VtaDctoProm.Descuento" "Descuento (%)" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-VtaDctoProm.Tipo
"t-VtaDctoProm.Tipo" ? ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


{pri/PRI_Graba-Dscto-Prom.i &t-Tabla="T-DPROM" &b-Tabla="b-VtaDctoProm" &Tabla="t-VtaDctoProm"}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Div D-Dialog 
PROCEDURE Carga-Temporal-Div :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{pri/PRI_Graba-Dscto-Prom-Divi.i &b-Tabla="b-VtaDctoProm" &Tabla="t-VtaDctoProm"}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Utilex D-Dialog 
PROCEDURE Carga-Temporal-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{pri/PRI_Graba-Dscto-Prom-Utilex.i &t-Tabla="T-DPROM" &b-Tabla="b-VtaDctoProm" &Tabla="t-VtaDctoProm"}

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
  /* Cargamos los descuentos reales */
  DEF VAR pMensaje AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE t-Vtadctoprom.
  EMPTY TEMP-TABLE T-DPROM.

  FOR EACH T-DPROM2 NO-LOCK:
      CREATE T-DPROM.
      BUFFER-COPY T-DPROM2 TO T-DPROM.
  END.

  CASE RADIO-SET-1:
      WHEN 1 THEN DO:
          FOR EACH T-MATG NO-LOCK:
              FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = T-MATG.CodCia
                  AND CAN-DO(f-Division, VtaDctoProm.CodDiv) = YES
                  AND VtaDctoProm.CodMat = T-MATG.CodMat
                  AND (TODAY >= VtaDctoProm.FchIni OR TODAY <= VtaDctoProm.FchFin)
                  AND VtaDctoProm.FlgEst = "A":
                  CREATE t-VtaDctoProm.
                  BUFFER-COPY VtaDctoProm TO t-VtaDctoProm.
              END.
          END.
      END.
      WHEN 2 THEN DO:
          FOR EACH T-MATG NO-LOCK:
              FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = T-MATG.CodCia
                  AND CAN-DO(f-Division, VtaDctoPromMin.CodDiv) = YES
                  AND VtaDctoPromMin.CodMat = T-MATG.CodMat
                  AND (TODAY >= VtaDctoPromMin.FchIni OR TODAY <= VtaDctoPromMin.FchFin)
                  AND VtaDctoPromMin.FlgEst = "A":
                  CREATE t-VtaDctoProm.
                  BUFFER-COPY VtaDctoPromMin TO t-VtaDctoProm.
              END.
          END.
      END.
      WHEN 3 THEN DO:
          FOR EACH T-MATG NO-LOCK BREAK BY T-MATG.CodMat:
              IF FIRST-OF(T-MATG.CodMat) THEN DO:
                  FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = T-MATG.CodCia
                      AND CAN-DO(f-Division, VtaDctoProm.CodDiv) = YES
                      AND VtaDctoProm.CodMat = TRIM(T-MATG.CodMat)
                      AND (VtaDctoProm.FchIni <= TODAY OR VtaDctoProm.FchFin >= TODAY)
                      AND VtaDctoProm.FlgEst = "A":
                      CREATE t-VtaDctoProm.
                      BUFFER-COPY VtaDctoProm TO t-VtaDctoProm.
                  END.
              END.
          END.
      END.
  END CASE.
  CASE RADIO-SET-1:
      WHEN 1 THEN DO:
          FOR EACH T-MATG NO-LOCK:
              RUN Carga-Temporal (INPUT pReemplazar,
                                  INPUT T-MATG.CodMat,
                                  INPUT-OUTPUT TABLE T-DPROM,
                                  INPUT x-MetodoActualizacion,
                                  INPUT f-Division,
                                  OUTPUT pMensaje).
          END.
      END.
      WHEN 2 THEN DO:
          FOR EACH T-MATG NO-LOCK:
              RUN Carga-Temporal-Utilex (INPUT pReemplazar,
                                         INPUT T-MATG.CodMat,
                                         INPUT-OUTPUT TABLE T-DPROM,
                                         INPUT x-MetodoActualizacion,
                                         INPUT f-Division,
                                         OUTPUT pMensaje).
          END.
      END.
      WHEN 3 THEN DO:
          FOR EACH T-MATG NO-LOCK BREAK BY T-MATG.CodMat:
              IF FIRST-OF(T-MATG.CodMat) THEN DO:
                  FOR EACH T-DPROM EXCLUSIVE-LOCK WHERE T-DPROM.CodCia = T-MATG.CodCia
                      AND T-DPROM.CodDiv = f-Division
                      AND T-DPROM.CodMat = T-MATG.CodMat:
                      RUN Carga-Temporal-Div (INPUT pReemplazar,
                                              INPUT f-Division,
                                              INPUT T-MATG.CodMat,
                                              INPUT T-MATG.PreVta[1],
                                              INPUT T-DPROM.FchIni,
                                              INPUT T-DPROM.FchFin,
                                              INPUT T-DPROM.DescuentoVIP,
                                              INPUT T-DPROM.DescuentoMR,
                                              INPUT T-DPROM.Descuento,
                                              OUTPUT pMensaje).
                  END.
              END.
          END.
      END.
  END CASE.
  FOR EACH t-VtaDctoProm EXCLUSIVE-LOCK:
      IF CAN-DO(x-Divisiones, t-VtaDctoProm.CodDiv) = NO THEN DO:
          DELETE t-VtaDctoProm.
      END.
  END.

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
  {src/adm/template/snd-list.i "t-VtaDctoProm"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

