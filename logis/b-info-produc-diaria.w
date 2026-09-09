&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR FILL-IN-Fecha AS DATE NO-UNDO.

DEF TEMP-TABLE detalle
    FIELD codref LIKE vtacdocu.codref
    FIELD nroref LIKE vtacdocu.nroref
    FIELD dni AS CHAR.

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
&Scoped-define INTERNAL-TABLES t-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-report.Campo-C[1] ~
t-report.Campo-F[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

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
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 76 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-report.Campo-C[1] COLUMN-LABEL "Rubro" FORMAT "X(30)":U
      t-report.Campo-F[1] COLUMN-LABEL "Datos" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 42 BY 9.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-1 AT ROW 1.54 COL 44 WIDGET-ID 4
     FILL-IN-1 AT ROW 10.42 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 6
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
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 10.92
         WIDTH              = 88.72.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-report"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.t-report.Campo-C[1]
"t-report.Campo-C[1]" "Rubro" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report.Campo-F[1]
"t-report.Campo-F[1]" "Datos" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    IF AVAILABLE t-report THEN DO:
        IF t-report.Campo-C[1] BEGINS "Items" THEN DO:
            t-report.Campo-C[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
            t-report.Campo-F[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
            t-report.Campo-C[1]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
            t-report.Campo-F[1]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
  RUN Captura-Fecha IN lh_handle (OUTPUT FILL-IN-Fecha).
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN First-Process.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  SESSION:SET-WAIT-STATE('').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE First-Process B-table-Win 
PROCEDURE First-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE t-report.
  /* ********************************************************************************* */
  /* 1ro PICADOS */
  /* ********************************************************************************* */
  DEF VAR x-Item AS INTE NO-UNDO.
  DEF VAR x-Peso AS DECI NO-UNDO.
  DEF VAR x-Volumen AS DECI NO-UNDO.
  DEF VAR x-Contador AS INTE NO-UNDO.

  DEFINE VAR x-desde AS DATETIME.
  DEFINE VAR x-hasta AS DATETIME.

  x-desde = DATETIME(MONTH(FILL-IN-Fecha),DAY(FILL-IN-Fecha),YEAR(FILL-IN-Fecha),0,0,0).
  x-hasta = DATETIME(MONTH(FILL-IN-Fecha),DAY(FILL-IN-Fecha),YEAR(FILL-IN-Fecha),23,59,59).

 /* 
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.Clave = 'TRCKHPK' AND 
      LogTrkDocs.CodDiv = s-CodDiv AND
      LogTrkDocs.CodDoc = "HPK" AND
      LogTrkDocs.Codigo = 'PK_COM' AND
      DATE(LogTrkDocs.Fecha) = FILL-IN-Fecha,
      FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
      VtaCDocu.CodDiv = s-CodDiv AND 
      VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
      VtaCDocu.NroPed = LogTrkDocs.NroDoc:
      /*FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CHEQUEADOS :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.*/
      x-Item = x-Item + VtaCDocu.Items.
      x-Peso = x-Peso + VtaCDocu.Peso.
      x-Volumen = x-Volumen + VtaCDocu.Volumen.
      x-Contador = x-Contador + 1.
  END.
*/
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
          LogTrkDocs.Clave = 'TRCKHPK' AND 
          LogTrkDocs.CodDiv = s-CodDiv AND
          (LogTrkDocs.Fecha >= x-desde AND LogTrkDocs.Fecha <= x-hasta),
      FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
      VtaCDocu.CodDiv = s-CodDiv AND 
      VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
      VtaCDocu.NroPed = LogTrkDocs.NroDoc:

     IF LogTrkDocs.CodDoc = "HPK" AND LogTrkDocs.Codigo = 'PK_COM' THEN DO:
         x-Item = x-Item + VtaCDocu.Items.
         x-Peso = x-Peso + VtaCDocu.Peso.
         x-Volumen = x-Volumen + VtaCDocu.Volumen.

         x-Contador = x-Contador + 1.
     END.
          
  END.

  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Items Picados'
      t-report.Campo-F[1] = x-Item.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Peso Picado'
      t-report.Campo-F[1] = x-Peso.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Volumen Picado'
      t-report.Campo-F[1] = x-Volumen.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Pedidos Picados'
      t-report.Campo-F[1] = x-Contador.
  /* ********************************************************************************* */
  /* 2do CHEQUEADOS */
  /* ********************************************************************************* */
  x-Item = 0.
  x-Peso = 0.
  x-Volumen = 0.
  x-Contador = 0.
  DEF VAR x-Bultos AS INTE NO-UNDO.
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
           LogTrkDocs.Clave = 'TRCKHPK' AND 
           LogTrkDocs.CodDiv = s-CodDiv AND
           (LogTrkDocs.Fecha >= x-desde AND LogTrkDocs.Fecha <= x-hasta),
       FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
       VtaCDocu.CodDiv = s-CodDiv AND 
       VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
       VtaCDocu.NroPed = LogTrkDocs.NroDoc:
      IF LogTrkDocs.CodDoc = "HPK" AND LogTrkDocs.Codigo = 'CK_CH' THEN DO:
          x-Item = x-Item + VtaCDocu.Items.
          x-Peso = x-Peso + VtaCDocu.Peso.
          x-Volumen = x-Volumen + VtaCDocu.Volumen.
          x-Contador = x-Contador + 1.
          /* Suma de bultos */
          FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Vtacdocu.codcia
              AND CcbCBult.CodDoc = Vtacdocu.codref
              AND CcbCBult.NroDoc = Vtacdocu.nroref:
              ASSIGN
                  x-Bultos = x-Bultos + CcbCBult.Bultos.
          END.
      END.
  END.

  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Items Chequeados'
      t-report.Campo-F[1] = x-Item.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Peso Chequeado'
      t-report.Campo-F[1] = x-Peso.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Volumen Chequeado'
      t-report.Campo-F[1] = x-Volumen.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Pedidos Chequeados'
      t-report.Campo-F[1] = x-Contador.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Bultos'
      t-report.Campo-F[1] = x-Bultos.
  /* ********************************************************************************* */
  /* ********************************************************************************* */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE First-Process-Old B-table-Win 
PROCEDURE First-Process-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report.
  /* Items chequeados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Item chequeado :" + VtaCDocu.Libre_c04 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.
  /* Items picados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Items Picados :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.

  /* Peso chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Peso chequeados :" + VtaCDocu.Libre_c04 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.
  /* Peso picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Peso Picado :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.

  /* Volumen chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Volumen Chequeado :" + VtaCDocu.Libre_c04 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.
  /* Volumen picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Volumen Picados?? :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.

  /* Pedidos chequeados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pedido chequeados :" + VtaCDocu.Libre_c04 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          ASSIGN
              t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
/*           FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref */
/*               AND detalle.nroref = vtacdocu.nroref                  */
/*               NO-LOCK NO-ERROR.                                     */
/*           IF NOT AVAILABLE detalle THEN DO:                         */
/*               CREATE detalle.                                       */
/*               ASSIGN                                                */
/*                   detalle.codref = vtacdocu.codref                  */
/*                   detalle.nroref = vtacdocu.nroref.                 */
/*           END.                                                      */
          /* Suma de bultos */
          FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Vtacdocu.codcia
              AND CcbCBult.CodDoc = Vtacdocu.codref
              AND CcbCBult.NroDoc = Vtacdocu.nroref:
              ASSIGN
                  t-report.Campo-F[2] = t-report.Campo-F[2] + CcbCBult.Bultos.
          END.
      END.
  END.
/*   FOR EACH detalle:                                      */
/*       ASSIGN                                             */
/*           t-report.Campo-F[1] = t-report.Campo-F[1] + 1. */
/*   END.                                                   */
  /* Pedidos picados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pedidos Picados :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          ASSIGN
              t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
/*           FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref */
/*               AND detalle.nroref = vtacdocu.nroref                  */
/*               NO-LOCK NO-ERROR.                                     */
/*           IF NOT AVAILABLE detalle THEN DO:                         */
/*               CREATE detalle.                                       */
/*               ASSIGN                                                */
/*                   detalle.codref = vtacdocu.codref                  */
/*                   detalle.nroref = vtacdocu.nroref.                 */
/*           END.                                                      */
      END.
  END.
/*   FOR EACH detalle:                                      */
/*       ASSIGN                                             */
/*           t-report.Campo-F[1] = t-report.Campo-F[1] + 1. */
/*   END.                                                   */

  /* Pedidos chequeados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Bultos'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pedido chequeados :" + VtaCDocu.Libre_c04 + " " + VtaCDocu.nroped.
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          /* Suma de bultos */
          FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Vtacdocu.codcia
              AND CcbCBult.CodDoc = Vtacdocu.codref
              AND CcbCBult.NroDoc = Vtacdocu.nroref:
              ASSIGN
                  t-report.Campo-F[1] = t-report.Campo-F[1] + CcbCBult.Bultos.
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE First-Process-old-cin B-table-Win 
PROCEDURE First-Process-old-cin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report.
  /* ********************************************************************************* */
  /* 1ro PICADOS */
  /* ********************************************************************************* */
  DEF VAR x-Item AS INTE NO-UNDO.
  DEF VAR x-Peso AS DECI NO-UNDO.
  DEF VAR x-Volumen AS DECI NO-UNDO.
  DEF VAR x-Contador AS INTE NO-UNDO.
  
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.Clave = 'TRCKHPK' AND 
      LogTrkDocs.CodDiv = s-CodDiv AND
      LogTrkDocs.CodDoc = "HPK" AND
      LogTrkDocs.Codigo = 'PK_COM' AND
      DATE(LogTrkDocs.Fecha) = FILL-IN-Fecha,
      FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
      VtaCDocu.CodDiv = s-CodDiv AND 
      VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
      VtaCDocu.NroPed = LogTrkDocs.NroDoc:
      /*FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CHEQUEADOS :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.*/
      x-Item = x-Item + VtaCDocu.Items.
      x-Peso = x-Peso + VtaCDocu.Peso.
      x-Volumen = x-Volumen + VtaCDocu.Volumen.
      x-Contador = x-Contador + 1.
  END.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Items Picados'
      t-report.Campo-F[1] = x-Item.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Peso Picado'
      t-report.Campo-F[1] = x-Peso.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Volumen Picado'
      t-report.Campo-F[1] = x-Volumen.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Pedidos Picados'
      t-report.Campo-F[1] = x-Contador.
  /* ********************************************************************************* */
  /* 2do CHEQUEADOS */
  /* ********************************************************************************* */
  x-Item = 0.
  x-Peso = 0.
  x-Volumen = 0.
  x-Contador = 0.
  DEF VAR x-Bultos AS INTE NO-UNDO.
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.Clave = 'TRCKHPK' AND 
      LogTrkDocs.CodDiv = s-CodDiv AND
      LogTrkDocs.CodDoc = "HPK" AND
      LogTrkDocs.Codigo = 'CK_CH' AND
      DATE(LogTrkDocs.Fecha) = FILL-IN-Fecha,
      FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
      VtaCDocu.CodDiv = s-CodDiv AND 
      VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
      VtaCDocu.NroPed = LogTrkDocs.NroDoc:
      /*FILL-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PICADOS :" + VtaCDocu.Libre_c03 + " " + VtaCDocu.nroped.*/
      x-Item = x-Item + VtaCDocu.Items.
      x-Peso = x-Peso + VtaCDocu.Peso.
      x-Volumen = x-Volumen + VtaCDocu.Volumen.
      x-Contador = x-Contador + 1.
      /* Suma de bultos */
      FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Vtacdocu.codcia
          AND CcbCBult.CodDoc = Vtacdocu.codref
          AND CcbCBult.NroDoc = Vtacdocu.nroref:
          ASSIGN
              x-Bultos = x-Bultos + CcbCBult.Bultos.
      END.
  END.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Items Chequeados'
      t-report.Campo-F[1] = x-Item.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Peso Chequeado'
      t-report.Campo-F[1] = x-Peso.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Volumen Chequeado'
      t-report.Campo-F[1] = x-Volumen.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Pedidos Chequeados'
      t-report.Campo-F[1] = x-Contador.
  CREATE t-report.
  ASSIGN 
      t-report.Campo-C[1] = 'Bultos'
      t-report.Campo-F[1] = x-Bultos.
  /* ********************************************************************************* */
  /* ********************************************************************************* */

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
  {src/adm/template/snd-list.i "t-report"}

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

