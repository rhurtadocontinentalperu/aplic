&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-FINAL NO-UNDO LIKE CcbCDocu
       INDEX IDX00 AS PRIMARY FchVto.
DEFINE TEMP-TABLE T-INICIAL NO-UNDO LIKE CcbCDocu
       INDEX IDX00 AS PRIMARY FchVto.



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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-Final

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-FINAL T-INICIAL

/* Definitions for BROWSE BROWSE-Final                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Final T-FINAL.CodDoc T-FINAL.FchVto ~
T-FINAL.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Final 
&Scoped-define QUERY-STRING-BROWSE-Final FOR EACH T-FINAL NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-Final OPEN QUERY BROWSE-Final FOR EACH T-FINAL NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-Final T-FINAL
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Final T-FINAL


/* Definitions for BROWSE BROWSE-Inicial                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Inicial T-INICIAL.CodDoc ~
T-INICIAL.FchVto T-INICIAL.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Inicial 
&Scoped-define QUERY-STRING-BROWSE-Inicial FOR EACH T-INICIAL NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Inicial OPEN QUERY BROWSE-Inicial FOR EACH T-INICIAL NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Inicial T-INICIAL
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Inicial T-INICIAL


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-Final}~
    ~{&OPEN-QUERY-BROWSE-Inicial}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-Inicial BROWSE-Final BUTTON-7 ~
FILL-IN-NroLetras BUTTON-9 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroLetras FILL-IN_ImpTot ~
FILL-IN_ImpFinal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/forward.ico":U
     LABEL "Button 7" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-9 
     LABEL "DESHACER TODO" 
     SIZE 24 BY 1.12.

DEFINE VARIABLE FILL-IN-NroLetras AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "¿Cuántas Letras?" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpFinal AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe Acumulado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Final FOR 
      T-FINAL SCROLLING.

DEFINE QUERY BROWSE-Inicial FOR 
      T-INICIAL SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Final D-Dialog _STRUCTURED
  QUERY BROWSE-Final NO-LOCK DISPLAY
      T-FINAL.CodDoc FORMAT "x(3)":U
      T-FINAL.FchVto COLUMN-LABEL "Fecha de Vencimiento" FORMAT "99/99/9999":U
            WIDTH 16.29
      T-FINAL.ImpTot FORMAT "ZZ,ZZZ,ZZ9.99":U WIDTH 13
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 14.54
         FONT 4
         TITLE "LETRAS FINALES" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-Inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Inicial D-Dialog _STRUCTURED
  QUERY BROWSE-Inicial NO-LOCK DISPLAY
      T-INICIAL.CodDoc FORMAT "x(3)":U
      T-INICIAL.FchVto COLUMN-LABEL "Fecha de Vencimiento" FORMAT "99/99/9999":U
            WIDTH 16.29
      T-INICIAL.ImpTot FORMAT "-ZZ,ZZZ,ZZ9.99":U WIDTH 13
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 14.54
         FONT 4
         TITLE "SELECCIONE UNA O MAS LETRAS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-Inicial AT ROW 1.27 COL 2 WIDGET-ID 200
     BROWSE-Final AT ROW 1.27 COL 74 WIDGET-ID 300
     BUTTON-7 AT ROW 2.62 COL 66 WIDGET-ID 4
     FILL-IN-NroLetras AT ROW 2.88 COL 59 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_ImpTot AT ROW 4.23 COL 59 COLON-ALIGNED WIDGET-ID 8
     BUTTON-9 AT ROW 7.46 COL 48 WIDGET-ID 6
     FILL-IN_ImpFinal AT ROW 16.08 COL 98 COLON-ALIGNED WIDGET-ID 10
     Btn_OK AT ROW 16.35 COL 45
     Btn_Cancel AT ROW 16.35 COL 61
     SPACE(43.71) SKIP(0.48)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DOCU T "SHARED" ? INTEGRAL CcbCDocu
      TABLE: T-DOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-FINAL T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX IDX00 AS PRIMARY FchVto
      END-FIELDS.
      TABLE: T-INICIAL T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX IDX00 AS PRIMARY FchVto
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
/* BROWSE-TAB BROWSE-Inicial 1 D-Dialog */
/* BROWSE-TAB BROWSE-Final BROWSE-Inicial D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_ImpFinal IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Final
/* Query rebuild information for BROWSE BROWSE-Final
     _TblList          = "Temp-Tables.T-FINAL"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.T-FINAL.CodDoc
     _FldNameList[2]   > Temp-Tables.T-FINAL.FchVto
"FchVto" "Fecha de Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-FINAL.ImpTot
"ImpTot" ? "ZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Final */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Inicial
/* Query rebuild information for BROWSE BROWSE-Inicial
     _TblList          = "Temp-Tables.T-INICIAL"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-INICIAL.CodDoc
     _FldNameList[2]   > Temp-Tables.T-INICIAL.FchVto
"T-INICIAL.FchVto" "Fecha de Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-INICIAL.ImpTot
"T-INICIAL.ImpTot" ? "-ZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Inicial */
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
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Final
&Scoped-define SELF-NAME BROWSE-Final
&Scoped-define SELF-NAME T-FINAL.ImpTot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-FINAL.ImpTot BROWSE-Final _BROWSE-COLUMN D-Dialog
ON LEAVE OF T-FINAL.ImpTot IN BROWSE BROWSE-Final /* Importe Total */
DO:
  RUN Suma-Final.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-FINAL.ImpTot BROWSE-Final _BROWSE-COLUMN D-Dialog
ON RETURN OF T-FINAL.ImpTot IN BROWSE BROWSE-Final /* Importe Total */
DO:
  APPLY 'TAB':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  /* Verificamos Importes */
    ASSIGN FILL-IN_ImpTot FILL-IN_ImpFinal.
    IF FILL-IN_ImpTot <> FILL-IN_ImpFinal THEN DO:
        MESSAGE 'El importe de las letras finales no coincide con el importe acumulado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CAN-FIND(FIRST T-FINAL WHERE T-FINAL.ImpTot <= 0) THEN DO:
        MESSAGE 'Una letra final tiene importe cero' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* Actualizamos Temporal */
    FOR EACH DOCU:
        DELETE DOCU.
    END.
    FOR EACH T-INICIAL NO-LOCK:
        CREATE DOCU.
        BUFFER-COPY T-INICIAL TO DOCU.
    END.
    FOR EACH T-FINAL NO-LOCK:
        CREATE DOCU.
        BUFFER-COPY T-FINAL TO DOCU.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 D-Dialog
ON CHOOSE OF BUTTON-7 IN FRAME D-Dialog /* Button 7 */
DO:
  RUN Carga-Final.
  {&OPEN-QUERY-BROWSE-Inicial}
  {&OPEN-QUERY-BROWSE-Final}
  RUN Suma-Final.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 D-Dialog
ON CHOOSE OF BUTTON-9 IN FRAME D-Dialog /* DESHACER TODO */
DO:
  RUN Carga-Inicial.
  {&OPEN-QUERY-BROWSE-Inicial}
  {&OPEN-QUERY-BROWSE-Final}
  DISPLAY FILL-IN_ImpTot FILL-IN-NroLetras WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Final D-Dialog 
PROCEDURE Carga-Final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-FchVto AS DATE NO-UNDO.
DEF VAR x-Saldo AS DEC NO-UNDO.
DEF VAR x-Linea AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS INT INIT 1 NO-UNDO.

FOR EACH DOCU NO-LOCK BY DOCU.NroDoc:
    x-NroDoc = INTEGER(DOCU.NroDoc) + 1.
END.
FOR EACH T-FINAL NO-LOCK BY T-FINAL.NroDoc:
    x-NroDoc = INTEGER(T-FINAL.NroDoc) + 1.
END.
EMPTY TEMP-TABLE T-DOCU.
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-NroLetras FILL-IN_ImpTot.
    IF BROWSE-Inicial:NUM-SELECTED-ROWS = 0 OR FILL-IN-NroLetras = 0 THEN RETURN.

    x-ImpTot = 0.
    DO k = 1 TO BROWSE-Inicial:NUM-SELECTED-ROWS:
        IF BROWSE-Inicial:FETCH-SELECTED-ROW(k) THEN DO:
            CREATE T-DOCU.
            BUFFER-COPY T-INICIAL TO T-DOCU.
            x-ImpTot = x-ImpTot + T-INICIAL.ImpTot.
            DELETE T-INICIAL.
        END.
    END.

    x-Saldo = x-ImpTot.
    DO k = 1 TO FILL-IN-NroLetras:
        j = 0.
        FOR EACH T-DOCU NO-LOCK BY T-DOCU.FchVto:
            x-FchVto = T-DOCU.FchVto.
            x-Linea  = T-DOCU.Libre_c02.
            j = j + 1.
            IF j <= k THEN LEAVE.
        END.
        CREATE T-FINAL.
        ASSIGN
            T-FINAL.Libre_c02 = x-Linea
            T-FINAL.CodDoc = "LET"
            T-FINAL.NroDoc = STRING(x-NroDoc, '999999')
            T-FINAL.FchVto = x-FchVto
            T-FINAL.ImpTot = ROUND(x-ImpTot / FILL-IN-NroLetras, 2).
        x-Saldo = x-Saldo - T-FINAL.ImpTot.
        x-NroDoc = x-NroDoc + 1.
        IF k = FILL-IN-NroLetras THEN T-FINAL.ImpTot = T-FINAL.ImpTot + x-Saldo.
    END.
    FILL-IN_ImpTot = FILL-IN_ImpTot + x-ImpTot.
    DISPLAY FILL-IN_ImpTot.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Inicial D-Dialog 
PROCEDURE Carga-Inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-INICIAL.
EMPTY TEMP-TABLE T-FINAL.
EMPTY TEMP-TABLE T-DOCU.

FOR EACH DOCU NO-LOCK:
    CREATE T-INICIAL.
    BUFFER-COPY DOCU TO T-INICIAL.
END.
ASSIGN
    FILL-IN_ImpTot = 0
    FILL-IN-NroLetras = 0.

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
  DISPLAY FILL-IN-NroLetras FILL-IN_ImpTot FILL-IN_ImpFinal 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-Inicial BROWSE-Final BUTTON-7 FILL-IN-NroLetras BUTTON-9 Btn_OK 
         Btn_Cancel 
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
  RUN Carga-Inicial.

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
  {src/adm/template/snd-list.i "T-INICIAL"}
  {src/adm/template/snd-list.i "T-FINAL"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Suma-Final D-Dialog 
PROCEDURE Suma-Final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-FINAL FOR T-FINAL.    
FILL-IN_ImpFinal = 0.
DO WITH FRAME {&FRAME-NAME}:
    FOR EACH B-FINAL NO-LOCK:
        FILL-IN_ImpFinal = FILL-IN_ImpFinal + B-FINAL.ImpTot.
    END.
    DISPLAY FILL-IN_ImpFinal.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

