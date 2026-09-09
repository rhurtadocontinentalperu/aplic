&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER Destino FOR almtabla.
DEFINE BUFFER Origen FOR almtabla.
DEFINE TEMP-TABLE t-flete_tarifario NO-UNDO LIKE flete_tarifario.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-Tipo AS CHAR INIT 'Peso' NO-UNDO.

&SCOPED-DEFINE Condicion (flete_tarifario.CodCia = s-codcia AND flete_tarifario.Tipo = x-Tipo)

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
&Scoped-define INTERNAL-TABLES flete_tarifario Origen Destino

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table flete_tarifario.Origen ~
Origen.Nombre flete_tarifario.Destino Destino.Nombre flete_tarifario.Minimo ~
flete_tarifario.Maximo flete_tarifario.Flete_Unitario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH flete_tarifario WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = flete_tarifario.Origen ~
      AND Origen.Tabla = "ZG" NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = flete_tarifario.Destino ~
      AND Destino.Tabla = "ZG" NO-LOCK ~
    BY flete_tarifario.Origen ~
       BY flete_tarifario.Destino ~
        BY flete_tarifario.Minimo ~
         BY flete_tarifario.Maximo
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH flete_tarifario WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = flete_tarifario.Origen ~
      AND Origen.Tabla = "ZG" NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = flete_tarifario.Destino ~
      AND Destino.Tabla = "ZG" NO-LOCK ~
    BY flete_tarifario.Origen ~
       BY flete_tarifario.Destino ~
        BY flete_tarifario.Minimo ~
         BY flete_tarifario.Maximo.
&Scoped-define TABLES-IN-QUERY-br_table flete_tarifario Origen Destino
&Scoped-define FIRST-TABLE-IN-QUERY-br_table flete_tarifario
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Origen
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Destino


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      flete_tarifario, 
      Origen
    FIELDS(Origen.Nombre), 
      Destino
    FIELDS(Destino.Nombre) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      flete_tarifario.Origen FORMAT "x(8)":U
      Origen.Nombre FORMAT "x(40)":U
      flete_tarifario.Destino FORMAT "x(8)":U
      Destino.Nombre FORMAT "x(40)":U
      flete_tarifario.Minimo COLUMN-LABEL "Minimo en kg!>=" FORMAT ">>>,>>9.99":U
      flete_tarifario.Maximo COLUMN-LABEL "Maximo en kg!<" FORMAT ">>>,>>9.99":U
      flete_tarifario.Flete_Unitario COLUMN-LABEL "Flete Unitario!S/. con IGV!por kg" FORMAT ">>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 106 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
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
      TABLE: Destino B "?" ? INTEGRAL almtabla
      TABLE: Origen B "?" ? INTEGRAL almtabla
      TABLE: t-flete_tarifario T "?" NO-UNDO INTEGRAL flete_tarifario
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
         HEIGHT             = 16.23
         WIDTH              = 106.86.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.flete_tarifario,Origen WHERE INTEGRAL.flete_tarifario ...,Destino WHERE INTEGRAL.flete_tarifario ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _OrdList          = "INTEGRAL.flete_tarifario.Origen|yes,INTEGRAL.flete_tarifario.Destino|yes,INTEGRAL.flete_tarifario.Minimo|yes,INTEGRAL.flete_tarifario.Maximo|yes"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "Origen.Codigo = flete_tarifario.Origen"
     _Where[2]         = "Origen.Tabla = ""ZG"""
     _JoinCode[3]      = "Destino.Codigo = flete_tarifario.Destino"
     _Where[3]         = "Destino.Tabla = ""ZG"""
     _FldNameList[1]   = INTEGRAL.flete_tarifario.Origen
     _FldNameList[2]   = Temp-Tables.Origen.Nombre
     _FldNameList[3]   = INTEGRAL.flete_tarifario.Destino
     _FldNameList[4]   = Temp-Tables.Destino.Nombre
     _FldNameList[5]   > INTEGRAL.flete_tarifario.Minimo
"flete_tarifario.Minimo" "Minimo en kg!>=" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.flete_tarifario.Maximo
"flete_tarifario.Maximo" "Maximo en kg!<" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.flete_tarifario.Flete_Unitario
"flete_tarifario.Flete_Unitario" "Flete Unitario!S/. con IGV!por kg" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME flete_tarifario.Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL flete_tarifario.Origen br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF flete_tarifario.Origen IN BROWSE br_table /* Origen */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    FIND AlmTabla WHERE AlmTabla.Tabla = "ZG"
        AND AlmTabla.Codigo = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN DISPLAY AlmTabla.Nombre @ Origen.Nombre WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME flete_tarifario.Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL flete_tarifario.Destino br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF flete_tarifario.Destino IN BROWSE br_table /* Destino */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    FIND AlmTabla WHERE AlmTabla.Tabla = "ZG"
        AND AlmTabla.Codigo = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN DISPLAY AlmTabla.Nombre @ Destino.Nombre WITH BROWSE {&browse-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Consistencia B-table-Win 
PROCEDURE Importar-Consistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* 1ro ver cuantas zonas hay */
DEF VAR x-OrigenDestino AS CHAR NO-UNDO.                           
FOR EACH t-flete_tarifario BREAK BY t-flete_tarifario.Origen BY t-flete_tarifario.Destino:
    IF FIRST-OF(t-flete_tarifario.Origen) OR FIRST-OF(t-flete_tarifario.Destino) THEN DO:
        x-OrigenDestino = x-OrigenDestino + (IF TRUE <> (x-OrigenDestino > '') THEN '' ELSE ',') +
            (t-flete_tarifario.Origen + '|' + t-flete_tarifario.Destino).
    END.
END.

/* 2do evaluamos por origen-destino */
DEF VAR x-Origen AS CHAR NO-UNDO.
DEF VAR x-Destino AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR x-Minimo AS DECI NO-UNDO.
DEF VAR x-Maximo AS DECI NO-UNDO.
DEF VAR x-Flete  AS DECI NO-UNDO.
DEF VAR x-Item   AS INTE NO-UNDO.

DO k = 1 TO NUM-ENTRIES(x-OrigenDestino):
    x-Origen  = ENTRY(1,ENTRY(k,x-OrigenDestino),'|').
    x-Destino = ENTRY(2,ENTRY(k,x-OrigenDestino),'|').
    x-Minimo = 0.
    x-Maximo = 0.
    x-Item = 1.
    IF NOT CAN-FIND(FIRST AlmTabla WHERE almtabla.Tabla = "ZG"
                    AND almtabla.Codigo = x-Origen NO-LOCK)
        THEN DO: 
        pMensaje = "ORIGEN NO registrado" + CHR(10) + 
            "Origen: " + x-Origen.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT CAN-FIND(FIRST AlmTabla WHERE almtabla.Tabla = "ZG"
                    AND almtabla.Codigo = x-Destino NO-LOCK)
        THEN DO: 
        pMensaje = "DESTINO NO registrado" + CHR(10) + 
            "Destino: " + x-Origen.
        RETURN 'ADM-ERROR'.
    END.
    FOR EACH t-flete_tarifario WHERE t-flete_tarifario.CodCia = s-CodCia
        AND t-flete_tarifario.Origen = x-Origen
        AND t-flete_tarifario.Destino = x-Destino
        BY t-flete_tarifario.Minimo BY t-flete_tarifario.Maximo:
        IF x-Item = 1 AND t-flete_tarifario.Minimo <> 0 THEN DO:
            pMensaje = "Debe comenzar como mínimo en cero" + CHR(10) +
                "Origen: " + x-Origen + "    Destino: " + x-Destino.
            RETURN "ADM-ERROR".
        END.
        IF x-Item > 1 AND t-flete_tarifario.Minimo <> x-Maximo THEN DO:
            pMensaje = "Hay un rango en blanco" + CHR(10) +
                "Origen: " + x-Origen + "    Destino: " + x-Destino.
            RETURN "ADM-ERROR".
        END.
        ASSIGN
            x-Minimo = t-flete_tarifario.Minimo
            x-Maximo = t-flete_tarifario.Maximo.
        x-Item = x-Item + 1.
    END.
END.

/* 3ro si no hay incosistenacias entonces procedemos a grabar la información */
DO k = 1 TO NUM-ENTRIES(x-OrigenDestino):
    x-Origen  = ENTRY(1,ENTRY(k,x-OrigenDestino),'|').
    x-Destino = ENTRY(2,ENTRY(k,x-OrigenDestino),'|').
    FOR EACH flete_tarifario EXCLUSIVE-LOCK WHERE flete_tarifario.CodCia = s-CodCia
        AND flete_tarifario.Tipo = x-Tipo 
        AND flete_tarifario.Origen = x-Origen
        AND flete_tarifario.Destino = x-Destino:
        DELETE flete_tarifario.
    END.
END.
FOR EACH t-flete_tarifario:
    CREATE flete_tarifario.
    BUFFER-COPY t-flete_tarifario TO flete_tarifario ASSIGN flete_tarifario.Tipo = x-Tipo.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR lFileXls AS CHAR NO-UNDO.
    DEF VAR OKpressed AS LOG NO-UNDO.

    SYSTEM-DIALOG GET-FILE lFileXls
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    DEF VAR lNuevoFile AS LOG NO-UNDO.
    DEF VAR cValue AS CHAR NO-UNDO.
    DEF VAR fValue AS DECI NO-UNDO.

    lNuevoFile = NO.
    {lib/excel-open-file.i}
        
    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE t-flete_tarifario.

    ASSIGN
        iRow = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            iColumn = 0
            iRow    = iRow + 1.
        iColumn = iColumn + 1.
        cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        /* ORIGEN */
        CREATE t-flete_tarifario.
        ASSIGN
            t-flete_tarifario.codcia = s-codcia
            t-flete_tarifario.Origen = cValue.
        /* DESTINO */
        iColumn = iColumn + 1.
        cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
        ASSIGN
            t-flete_tarifario.Destino = cValue.
        /* MINIMO */
        iColumn = iColumn + 1.
        fValue = DECIMAL(chWorkSheet:Cells(iRow, iColumn):VALUE).
        ASSIGN
            t-flete_tarifario.Minimo = fValue.
        /* MAXIMO */
        iColumn = iColumn + 1.
        fValue = DECIMAL(chWorkSheet:Cells(iRow, iColumn):VALUE).
        ASSIGN
            t-flete_tarifario.Maximo = fValue.
        /* FLETE */
        iColumn = iColumn + 1.
        fValue = DECIMAL(chWorkSheet:Cells(iRow, iColumn):VALUE).
        ASSIGN
            t-flete_tarifario.Flete_Unitario = fValue.
    END.
    SESSION:SET-WAIT-STATE('').
    lCerrarAlTerminar = YES.
    lMensajeAlTerminar = NO.
    {lib/excel-close-file.i} 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Plantilla B-table-Win 
PROCEDURE Importar-Plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pMensaje AS CHAR NO-UNDO.
 
RUN Importar-Excel.
RUN Importar-Consistencia (OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      flete_tarifario.CodCia = s-codcia
      flete_tarifario.Tipo = x-tipo
      flete_tarifario.DateUpdate = TODAY
      flete_tarifario.HourUpdate = STRING(TIME,'HH:MM:SS')
      flete_tarifario.UserUpdate = s-user-id.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      flete_tarifario.Destino:READ-ONLY IN BROWSE {&browse-name} = NO.
      flete_tarifario.Origen:READ-ONLY IN BROWSE {&browse-name} = NO.
  END.
  ELSE DO:
      flete_tarifario.Destino:READ-ONLY IN BROWSE {&browse-name} = YES.
      flete_tarifario.Origen:READ-ONLY IN BROWSE {&browse-name} = YES.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Plantilla-Excel B-table-Win 
PROCEDURE Plantilla-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Confirmar la generación de la plantilla en formato EXCEL'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFileXls AS CHAR NO-UNDO.

lNuevoFile = YES.       /* Nueva hoja */

{lib/excel-open-file.i}

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = "ORIGEN"
    chWorkSheet:Range("B1"):Value = "DESTINO"
    chWorkSheet:Range("C1"):Value = "MINIMO"
    chWorkSheet:Range("D1"):Value = "MAXIMO"
    chWorkSheet:Range("E1"):Value = "FLETE UNITARIO".
chWorksheet:COLUMNS("A"):NumberFormat = "@".
chWorksheet:COLUMNS("B"):NumberFormat = "@".

ASSIGN
    iRow = 1.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE flete_tarifario:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = flete_tarifario.Origen.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = flete_tarifario.Destino.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = flete_tarifario.Minimo.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = flete_tarifario.Maximo.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = flete_tarifario.Flete_Unitario.
    GET NEXT {&BROWSE-name}.
END.

lCerrarAlTerminar = NO.         /* NO: permanece abierto el Excel luego de concluir el proceso */
lMensajeAlTerminar = YES.       /* Muestra el mensaje de "proceso terminado" al finalizar */

{lib/excel-close-file.i}


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
  {src/adm/template/snd-list.i "flete_tarifario"}
  {src/adm/template/snd-list.i "Origen"}
  {src/adm/template/snd-list.i "Destino"}

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

IF NOT CAN-FIND(AlmTabla WHERE AlmTabla.Tabla = "ZG"
                AND AlmTabla.Codigo = flete_tarifario.Origen:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK) THEN DO:
    MESSAGE 'NO registrada la zona geográfica origen' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO flete_tarifario.Origen.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(AlmTabla WHERE AlmTabla.Tabla = "ZG"
                AND AlmTabla.Codigo = flete_tarifario.Destino:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK) THEN DO:
    MESSAGE 'NO registrada la zona geográfica destino' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO flete_tarifario.Destino.
    RETURN 'ADM-ERROR'.
END.

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

