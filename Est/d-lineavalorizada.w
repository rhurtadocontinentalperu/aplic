&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FAMI NO-UNDO LIKE Almtfami.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.

DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

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
&Scoped-define INTERNAL-TABLES Almtfami T-FAMI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-FAMI.codfam T-FAMI.desfam ~
T-FAMI.Libre_d01 T-FAMI.Libre_d02 T-FAMI.TpoCmb 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almtfami ~
      WHERE Almtfami.CodCia = s-codcia ~
 AND Almtfami.SwComercial = TRUE NO-LOCK, ~
      EACH T-FAMI OF Almtfami ~
      WHERE t-fami.CodCia = s-codcia ~
 AND t-fami.SwComercial = TRUE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almtfami ~
      WHERE Almtfami.CodCia = s-codcia ~
 AND Almtfami.SwComercial = TRUE NO-LOCK, ~
      EACH T-FAMI OF Almtfami ~
      WHERE t-fami.CodCia = s-codcia ~
 AND t-fami.SwComercial = TRUE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almtfami T-FAMI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almtfami
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 T-FAMI


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Mes-1 COMBO-BOX-Periodo-1 BUTTON-8 ~
COMBO-BOX-Mes-2 COMBO-BOX-Periodo-2 BROWSE-2 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Mes-1 COMBO-BOX-Periodo-1 ~
COMBO-BOX-Mes-2 COMBO-BOX-Periodo-2 FILL-IN-1 FILL-IN-2 

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
     BGCOLOR 8 FONT 6.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/proces.bmp":U
     LABEL "Button 8" 
     SIZE 15 BY 1.92.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Ventas desde el mes de" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",         1,
                     "Febrero",         2,
                     "Marzo",         3,
                     "Abril",         4,
                     "Mayo",         5,
                     "Junio",         6,
                     "Julio",         7,
                     "Agosto",         8,
                     "Setiembre",         9,
                     "Octubre",         10,
                     "Noviembre",         11,
                     "Diciembre",         12
     DROP-DOWN-LIST
     SIZE 16 BY .92 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Hasta el mes de" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY .92 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY .92 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY .92 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT "(Z,ZZZ,ZZZ,ZZZ.99)":U INITIAL 0 
     LABEL "Total General" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS DECIMAL FORMAT "(Z,ZZZ,ZZZ,ZZZ.99)":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almtfami, 
      T-FAMI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-FAMI.codfam FORMAT "X(3)":U
      T-FAMI.desfam FORMAT "X(40)":U
      T-FAMI.Libre_d01 COLUMN-LABEL "Valor Reposición con IGV!S/." FORMAT "->>>,>>>,>>9.99":U
            WIDTH 24
      T-FAMI.Libre_d02 COLUMN-LABEL "Ventas con IGV!S/." FORMAT "->>>,>>>,>>9.99":U
            WIDTH 18.72
      T-FAMI.TpoCmb COLUMN-LABEL "Factor!(Ventas / Stock)" FORMAT "(Z,ZZZ,ZZ9.9999)":U
            WIDTH 18.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 13.27 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-Mes-1 AT ROW 1.19 COL 27 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-Periodo-1 AT ROW 1.19 COL 54 COLON-ALIGNED WIDGET-ID 6
     BUTTON-8 AT ROW 1.19 COL 65 WIDGET-ID 12
     COMBO-BOX-Mes-2 AT ROW 2.15 COL 27 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-Periodo-2 AT ROW 2.15 COL 54 COLON-ALIGNED WIDGET-ID 10
     BROWSE-2 AT ROW 3.5 COL 2 WIDGET-ID 200
     FILL-IN-1 AT ROW 16.96 COL 56 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-2 AT ROW 16.96 COL 76 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     Btn_OK AT ROW 18.5 COL 78
     SPACE(23.56) SKIP(0.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "RESUMEN VALORIZADO POR ALMACENES COMERCIALES"
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FAMI T "?" NO-UNDO INTEGRAL Almtfami
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-Periodo-2 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almtfami,Temp-Tables.T-FAMI OF INTEGRAL.Almtfami"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.Almtfami.CodCia = s-codcia
 AND INTEGRAL.Almtfami.SwComercial = TRUE"
     _Where[2]         = "t-fami.CodCia = s-codcia
 AND t-fami.SwComercial = TRUE"
     _FldNameList[1]   = Temp-Tables.T-FAMI.codfam
     _FldNameList[2]   > Temp-Tables.T-FAMI.desfam
"Temp-Tables.T-FAMI.desfam" ? "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-FAMI.Libre_d01
"Temp-Tables.T-FAMI.Libre_d01" "Valor Reposición con IGV!S/." "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "24" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-FAMI.Libre_d02
"Temp-Tables.T-FAMI.Libre_d02" "Ventas con IGV!S/." "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "18.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-FAMI.TpoCmb
"Temp-Tables.T-FAMI.TpoCmb" "Factor!(Ventas / Stock)" "(Z,ZZZ,ZZ9.9999)" "decimal" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* RESUMEN VALORIZADO POR ALMACENES COMERCIALES */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 D-Dialog
ON CHOOSE OF BUTTON-8 IN FRAME D-Dialog /* Button 8 */
DO:
  ASSIGN
      COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 COMBO-BOX-Periodo-1 COMBO-BOX-Periodo-2.
  RUN Carga-Ventas.
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

EMPTY TEMP-TABLE T-FAMI.
FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
    AND Almtfami.SwComercial = YES:
    CREATE T-FAMI.
    BUFFER-COPY Almtfami EXCEPT Almtfami.TpoCmb
        TO T-FAMI.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas D-Dialog 
PROCEDURE Carga-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Desde AS DATE NO-UNDO.
DEF VAR x-Hasta AS DATE NO-UNDO.    

ASSIGN
    x-Desde = DATE(COMBO-BOX-Mes-1, 01, COMBO-BOX-Periodo-1)
    x-Hasta = DATE(COMBO-BOX-Mes-2, 31, COMBO-BOX-Periodo-2).

SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH T-FAMI:
    ASSIGN
        T-FAMI.Libre_D02 = 0.
    FOR EACH VentasxLinea NO-LOCK WHERE VentasxLinea.CodFam = T-FAMI.codfam
        AND VentasxLinea.DateKey >= x-Desde
        AND VentasxLinea.DateKey <= x-Hasta:
        T-FAMI.Libre_D02 = T-FAMI.Libre_D02 + VentasxLinea.ImpNacCIGV.
        IF T-FAMI.Libre_D01 <> 0 THEN T-FAMI.TpoCmb = T-FAMI.Libre_D02 / T-FAMI.Libre_D01.
        ELSE T-FAMI.Libre_D02 = 0.
    END.
END.
RUN Pinta-Totales.
{&OPEN-QUERY-{&BROWSE-NAME}}

SESSION:SET-WAIT-STATE("").


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
  DISPLAY COMBO-BOX-Mes-1 COMBO-BOX-Periodo-1 COMBO-BOX-Mes-2 
          COMBO-BOX-Periodo-2 FILL-IN-1 FILL-IN-2 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-Mes-1 COMBO-BOX-Periodo-1 BUTTON-8 COMBO-BOX-Mes-2 
         COMBO-BOX-Periodo-2 BROWSE-2 Btn_OK 
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          COMBO-BOX-Periodo-1:LIST-ITEMS = p-list
          COMBO-BOX-Periodo-2:LIST-ITEMS = p-list
          COMBO-BOX-Mes-1 = 01
          COMBO-BOX-Mes-2 = MONTH(TODAY)
          COMBO-BOX-Periodo-1 = YEAR(TODAY)
          COMBO-BOX-Periodo-2 = YEAR(TODAY).
      RUN Carga-Temporal.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Pinta-Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Totales D-Dialog 
PROCEDURE Pinta-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-1 = 0.
FILL-IN-2 = 0.
FOR EACH T-Fami NO-LOCK:
    FILL-IN-1 = FILL-IN-1 + t-fami.Libre_d01.
    FILL-IN-2 = FILL-IN-2 + t-fami.Libre_d02.
END.
DISPLAY FILL-IN-1 FILL-IN-2 WITH FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "T-FAMI"}

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

