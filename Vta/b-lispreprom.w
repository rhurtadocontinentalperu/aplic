&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Promociones LIKE Almmmatg.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg
       INDEX Llave01 AS PRIMARY CodMat.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEF FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Un momento por favor " SKIP
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX WIDTH 30 TITLE "Mensaje".

DEF VAR s-Button-1 AS LOGICAL INIT TRUE.
DEF VAR s-Button-2 AS LOGICAL INIT FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-MATG Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat Almmmatg.DesMat ~
Almmmatg.DesMar T-MATG.PromDivi[1] T-MATG.PromFchD[1] T-MATG.PromFchH[1] ~
T-MATG.PromDto[1] T-MATG.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-3 RADIO-SET-1 br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\proces":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73 TOOLTIP "Importar EXCEL".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\rbuild%":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Actualizar Promociones".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 3" 
     SIZE 11 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NO BORRAR las promociones anteriores y actualizar con las nuevas", 1,
"BORRAR las promociones anteriores y actualizar con las nuevas", 2
     SIZE 61 BY 1.62
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-MATG, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      T-MATG.PromDivi[1] COLUMN-LABEL "Division" FORMAT "x(5)":U
      T-MATG.PromFchD[1] COLUMN-LABEL "Desde" FORMAT "99/99/9999":U
      T-MATG.PromFchH[1] COLUMN-LABEL "Hasta" FORMAT "99/99/9999":U
      T-MATG.PromDto[1] COLUMN-LABEL "% Dcto" FORMAT ">>9.99":U
      T-MATG.PreOfi COLUMN-LABEL "Precio S/." FORMAT ">,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 106 BY 13.19
         FONT 4 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 1 WIDGET-ID 2
     BUTTON-2 AT ROW 1 COL 13 WIDGET-ID 4
     BUTTON-3 AT ROW 1 COL 25 WIDGET-ID 6
     RADIO-SET-1 AT ROW 1 COL 47 NO-LABEL WIDGET-ID 8
     br_table AT ROW 2.88 COL 1
     "Método:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1 COL 39 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: Promociones T "?" ? INTEGRAL Almmmatg
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY CodMat
      END-FIELDS.
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 16.54
         WIDTH              = 115.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table RADIO-SET-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"Temp-Tables.T-MATG.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATG.PromDivi[1]
"Temp-Tables.T-MATG.PromDivi[1]" "Division" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATG.PromFchD[1]
"Temp-Tables.T-MATG.PromFchD[1]" "Desde" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.PromFchH[1]
"Temp-Tables.T-MATG.PromFchH[1]" "Hasta" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.PromDto[1]
"Temp-Tables.T-MATG.PromDto[1]" "% Dcto" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.PreOfi
"Temp-Tables.T-MATG.PreOfi" "Precio S/." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  IF s-Button-1 = YES
  THEN DO:
    RUN Carga-Temporal.
    BUTTON-1:LOAD-IMAGE-UP('adeicon/stop-u').
    ASSIGN
        BUTTON-2:SENSITIVE = YES
        s-Button-1 = NO
        s-Button-2 = YES.

  END.
  ELSE DO:
    BUTTON-1:LOAD-IMAGE-UP('img/proces').
    ASSIGN
        BUTTON-2:SENSITIVE = NO
        s-Button-1 = YES
        s-Button-2 = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN RADIO-SET-1.
  RUN Importa.
  IF RETURN-VALUE = 'ADM-ERROR':U
  THEN RETURN NO-APPLY.
  ASSIGN
    BUTTON-2:SENSITIVE = NO
    s-Button-1 = YES
    s-Button-2 = NO.
  BUTTON-1:LOAD-IMAGE-UP('img/proces').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Cab AS CHAR NO-UNDO.
    DEF VAR x-Linea AS CHAR FORMAT 'x(100)'.
    DEF VAR Rpta AS LOG NO-UNDO.

    /* SOLICITAMOS ARCHIVO */
    SYSTEM-DIALOG GET-FILE x-Cab 
        FILTERS 'Excel (*.xls)' '*.xls' INITIAL-FILTER 1
        RETURN-TO-START-DIR 
        TITLE 'Archivo de Descuentos Promocionales'
        UPDATE Rpta.
    IF Rpta = NO THEN RETURN.

    VIEW FRAME F-Mensaje.

    EMPTY TEMP-TABLE T-MATG.

    /*  ********************************* EXCEL ***************************** */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
    DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(x-Cab).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* EL FORMATO DEBE TENER 6 COLUMNAS
        CODIGO Desde Hasta Division  % Dcto Precio
        */
    iCountLine = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        iCountLine = iCountLine + 1.
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
        /* CODIGO */
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            cValue = STRING(INTEGER (cValue), '999999')
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Código' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        CREATE T-MATG.
        ASSIGN
            T-MATG.CodCia = s-codcia
            T-MATG.CodMat = cValue.
        /* FECHAS */
        cRange = "B" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MATG.PromFchD[1] = DATE (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Fecha Desde' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        cRange = "C" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MATG.PromFchH[1] = DATE (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Fecha Hasta' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* DIVISION */
        cRange = "D" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MATG.PromDivi[1] = STRING (INTEGER (cValue) , '99999')
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: División' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* DESCUENTO */
        cRange = "E" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MATG.PromDto[1] = DECIMAL (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: % Descuento' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        IF T-MATG.PromDto[1] = ? THEN T-MATG.PromDto[1] = 0.
        /* PRECIO */
        cRange = "F" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MATG.PreOfi = DECIMAL (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Precio' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        IF T-MATG.PreOfi = ? THEN T-MATG.PreOfi = 0.
    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* ********************************************************************** */
    HIDE FRAME F-Mensaje.           
    FIND FIRST T-MATG NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATG THEN DO:
        MESSAGE 'Error en el archivo EXCEL' SKIP
            'Haga una copia del archivo y vuelva a intentarlo'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* DEPURACION */
    FOR EACH T-MATG:
        FIND Almmmatg OF T-MATG NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            DELETE T-MATG.
            NEXT.
        END.
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = T-MATG.PromDivi[1]
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-divi THEN DO:
            DELETE T-MATG.
            NEXT.
        END.
        IF T-MATG.PreOfi <= 0 AND T-MATG.PromDto[1] <= 0 THEN DO:
            DELETE T-MATG.
            NEXT.
        END.
        IF T-MATG.PromFchD[1] > T-MATG.PromFchH[1] OR T-MATG.PromFchD[1] = ? OR T-MATG.PromFchH[1] = ? THEN DO:
            DELETE T-MATG.
            NEXT.
        END.

    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importa B-table-Win 
PROCEDURE Importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR j AS INT NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  FIND FIRST T-MATG NO-ERROR.
  IF NOT AVAILABLE T-MATG THEN RETURN 'ADM-ERROR':U.
  MESSAGE 'Confirme Inicio de la Actualización de los Descuentos Promocionales'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOGICAL.
  IF rpta-1 = NO THEN RETURN 'ADM-ERROR':U.

  EMPTY TEMP-TABLE Promociones.

  VIEW FRAME F-Mensaje.
  /* cargamos los productos */
  FOR EACH T-MATG BREAK BY T-MATG.CodMat:
      IF FIRST-OF(T-MATG.codmat) THEN DO:
          FIND Almmmatg OF T-MATG NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmatg THEN NEXT.
          CREATE Promociones.
          BUFFER-COPY Almmmatg TO Promociones.
      END.
  END.
  /* cargamos los descuentos promocionales */
  FOR EACH Promociones:
      CASE RADIO-SET-1:
          WHEN 2 THEN DO:
              /* borramos las promociones anteriores */
              DO j = 1 TO 10:
                  ASSIGN
                      Promociones.PromDivi[j] = ''
                      Promociones.PromDto[j] = 0
                      Promociones.PromFchD[j] = ?
                      Promociones.PromFchH[j] = ?.
              END.
              /* cargamos las nuevas promociones */
              k = 1.
              FOR EACH T-MATG WHERE T-MATG.CodMat = Promociones.CodMat BY T-MATG.PromDivi[1]:
                  ASSIGN
                      Promociones.PromDivi[k] = T-MATG.PromDivi[1] 
                      Promociones.PromDto[k]  = T-MATG.PromDto[1] 
                      Promociones.PromFchD[k] = T-MATG.PromFchD[1] 
                      Promociones.PromFchH[k] = T-MATG.PromFchH[1].
                  IF T-MATG.PreOfi > 0 THEN DO:
                      IF Promociones.MonVta = 1 
                        THEN Promociones.PromDto[k] = ROUND ( ( 1 - ( T-MATG.PreOfi / Promociones.Prevta[1] ) ) * 100, 2).
                        ELSE Promociones.PromDto[k] = ROUND ( ( 1 - ( T-MATG.PreOfi / Promociones.TpoCmb / Promociones.Prevta[1] ) ) * 100, 2).
                  END.
                  k = k + 1.
                  IF k > 10 THEN LEAVE.
              END.
          END.
          WHEN 1 THEN DO:
              /* actualizamos las promociones */
              FOR EACH T-MATG WHERE T-MATG.CodMat = Promociones.CodMat BY T-MATG.PromDivi[1]:
                  k = 1.
                  PRIMERA:
                  DO j = 1 TO 10:
                      IF Promociones.PromDivi[j] = '' THEN DO:
                          k = j.
                          LEAVE PRIMERA.
                      END.
                  END.
                  SEGUNDA:
                  DO j = 1 TO 10:
                      IF Promociones.PromDivi[j] = T-MATG.PromDivi[1] THEN DO:
                          k = j.
                          LEAVE SEGUNDA.
                      END.
                  END.
                  IF k < 10 THEN DO:
                      ASSIGN
                          Promociones.PromDivi[k] = T-MATG.PromDivi[1] 
                          Promociones.PromDto[k]  = T-MATG.PromDto[1] 
                          Promociones.PromFchD[k] = T-MATG.PromFchD[1] 
                          Promociones.PromFchH[k] = T-MATG.PromFchH[1].
                      IF T-MATG.PreOfi > 0 THEN DO:
                          IF Promociones.MonVta = 1 
                            THEN Promociones.PromDto[k] = ROUND ( ( 1 - ( T-MATG.PreOfi / Promociones.Prevta[1] ) ) * 100, 2).
                            ELSE Promociones.PromDto[k] = ROUND ( ( 1 - ( T-MATG.PreOfi / Promociones.TpoCmb / Promociones.Prevta[1] ) ) * 100, 2).
                      END.
                  END.
              END.
          END.
      END CASE.
  END.
  /* Grabamos las promociones */
  FOR EACH Promociones:
      FIND Almmmatg OF Promociones EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Promociones THEN NEXT.
      DO j = 1 TO 10:
          ASSIGN
              Almmmatg.PromDivi[j] = Promociones.PromDivi[j] 
              Almmmatg.PromDto[j]  = Promociones.PromDto[j] 
              Almmmatg.PromFchD[j] = Promociones.PromFchD[j] 
              Almmmatg.PromFchH[j] = Promociones.PromFchH[j].
      END.
      RELEASE Almmmatg.
  END.



  EMPTY TEMP-TABLE T-MATG.
  RELEASE Almmmatg.

  HIDE FRAME F-Mensaje.
  MESSAGE "Importación Completa" VIEW-AS ALERT-BOX INFORMATION.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-MATG"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

