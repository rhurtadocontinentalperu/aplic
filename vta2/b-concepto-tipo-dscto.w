&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-VtaTabla NO-UNDO LIKE VtaTabla.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-tabla-conceptos-nc AS CHAR INIT 'N/C'.
DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".
DEFINE VAR x-tabla-tipo-dscto AS CHAR INIT "TIPO_DSCTO".

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
&Scoped-define INTERNAL-TABLES tt-VtaTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-VtaTabla.Llave_c1 ~
tt-VtaTabla.Libre_c01 tt-VtaTabla.Llave_c2 tt-VtaTabla.Rango_valor[2] ~
tt-VtaTabla.Rango_valor[1] tt-VtaTabla.Rango_fecha[1] ~
tt-VtaTabla.Rango_fecha[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tt-VtaTabla.Llave_c2 ~
tt-VtaTabla.Rango_valor[2] tt-VtaTabla.Rango_valor[1] ~
tt-VtaTabla.Rango_fecha[1] tt-VtaTabla.Rango_fecha[2] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tt-VtaTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tt-VtaTabla
&Scoped-define QUERY-STRING-br_table FOR EACH tt-VtaTabla WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-VtaTabla WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-VtaTabla


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
      tt-VtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-VtaTabla.Llave_c1 COLUMN-LABEL "Concepto" FORMAT "x(8)":U
            WIDTH 7.14
      tt-VtaTabla.Libre_c01 COLUMN-LABEL "Descripcion" FORMAT "x(80)":U
            WIDTH 36.29
      tt-VtaTabla.Llave_c2 COLUMN-LABEL "Tipo Descuento" FORMAT "x(20)":U
            WIDTH 17.14
      tt-VtaTabla.Rango_valor[2] COLUMN-LABEL "Dias antigueda!Cmpte referenciado" FORMAT "->>,>>9":U
            WIDTH 13.86
      tt-VtaTabla.Rango_valor[1] COLUMN-LABEL "Max Articulos!x N/C" FORMAT "->>,>>9":U
            WIDTH 9.86
      tt-VtaTabla.Rango_fecha[1] COLUMN-LABEL "Desde" FORMAT "99/99/9999":U
      tt-VtaTabla.Rango_fecha[2] COLUMN-LABEL "Hasta" FORMAT "99/99/9999":U
            WIDTH 13
  ENABLE
      tt-VtaTabla.Llave_c2
      tt-VtaTabla.Rango_valor[2]
      tt-VtaTabla.Rango_valor[1]
      tt-VtaTabla.Rango_fecha[1]
      tt-VtaTabla.Rango_fecha[2]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 114.72 BY 14.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.29
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
      TABLE: tt-VtaTabla T "?" NO-UNDO INTEGRAL VtaTabla
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
         HEIGHT             = 14.5
         WIDTH              = 116.14.
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
     _TblList          = "Temp-Tables.tt-VtaTabla"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.tt-VtaTabla.Llave_c1
"tt-VtaTabla.Llave_c1" "Concepto" ? "character" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-VtaTabla.Libre_c01
"tt-VtaTabla.Libre_c01" "Descripcion" "x(80)" "character" ? ? ? ? ? ? no ? no no "36.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaTabla.Llave_c2
"tt-VtaTabla.Llave_c2" "Tipo Descuento" "x(20)" "character" ? ? ? ? ? ? yes ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaTabla.Rango_valor[2]
"tt-VtaTabla.Rango_valor[2]" "Dias antigueda!Cmpte referenciado" "->>,>>9" "decimal" ? ? ? ? ? ? yes ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-VtaTabla.Rango_valor[1]
"tt-VtaTabla.Rango_valor[1]" "Max Articulos!x N/C" "->>,>>9" "decimal" ? ? ? ? ? ? yes ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-VtaTabla.Rango_fecha[1]
"tt-VtaTabla.Rango_fecha[1]" "Desde" ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-VtaTabla.Rango_fecha[2]
"tt-VtaTabla.Rango_fecha[2]" "Hasta" ? "date" ? ? ? ? ? ? yes ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME tt-VtaTabla.Llave_c2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-VtaTabla.Llave_c2 br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF tt-VtaTabla.Llave_c2 IN BROWSE br_table /* Tipo Descuento */
DO:
  ASSIGN
    input-var-1 = x-tabla-tipo-dscto
    input-var-2 = 'N/C'
    input-var-3 = ''
    output-var-1 = ?            /* Rowid */
    output-var-2 = ''
    output-var-3 = ''.

    RUN LKUP\C-tipo-descuentos.r("Tipos de descuentos").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/*
  RUN LKUP\C-ABOCAR-3 ("Conceptos").
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data B-table-Win 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-vtatabla.    
    
FOR EACH ccbtabla WHERE ccbtabla.codcia = s-codcia AND
                        ccbtabla.tabla = x-tabla-conceptos-nc AND
                        ccbtabla.libre_l02 = YES NO-LOCK:

    CREATE tt-vtatabla.
        ASSIGN tt-vtatabla.codcia = s-codcia 
                tt-vtatabla.tabla = x-tabla
                tt-vtatabla.llave_c1 = ccbtabla.codigo
                tt-vtatabla.llave_c2 = ""
                tt-vtatabla.libre_c01 = ccbtabla.nombre.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND 
                                vtatabla.llave_c1 = ccbtabla.codigo NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        ASSIGN tt-vtatabla.llave_c2 =  vtatabla.llave_c2
                tt-vtatabla.rango_valor[1] = vtatabla.rango_valor[1]
                tt-vtatabla.rango_valor[2] = vtatabla.rango_valor[2]
                tt-vtatabla.rango_fecha[1] = vtatabla.rango_fecha[1]
                tt-vtatabla.rango_fecha[2] = vtatabla.rango_fecha[2].
    END.

END.

{&open-query-br_table}

END PROCEDURE.

/*
DEFINE VAR x-tabla-conceptos-nc AS CHAR INIT 'N/C'.
DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE "Opcion NO habilitada" VIEW-AS ALERT-BOX INFORMATION.
  RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  DEFINE VAR x-concepto AS CHAR.
  DEFINE VAR x-tipo-dscto AS CHAR.
  DEFINE VAR x-max-art-x-nc AS INT.
  DEFINE VAR x-max-antiguedad-cmpbte AS INT.
  DEFINE VAR x-vig-desde AS DATE.
  DEFINE VAR x-vig-hasta AS DATE.

  x-concepto = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c1:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-tipo-dscto = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-max-art-x-nc = INTEGER({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_valor[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
  x-max-antiguedad-cmpbte = INTEGER({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_valor[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
  
  x-vig-desde = DATE({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
  x-vig-hasta = DATE({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
  
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c1 = x-concepto EXCLUSIVE-LOCK NO-ERROR.
  IF LOCKED vtatabla THEN DO:
      MESSAGE "La tabla (Vtatabla) esta bloqueada por otro usuario".
      RETURN "ADM-ERROR".
  END.
  ELSE DO:
      IF NOT AVAILABLE vtatabla THEN DO:
          CREATE vtatabla.
            ASSIGN vtatabla.codcia = s-codcia 
                    vtatabla.tabla = x-tabla 
                    vtatabla.llave_c1 = x-concepto.
      END.

      ASSIGN vtatabla.llave_c2 = x-tipo-dscto
            vtatabla.rango_valor[1] = x-max-art-x-nc
            vtatabla.rango_valor[2] = x-max-antiguedad-cmpbte
            vtatabla.rango_fecha[1] = x-vig-desde
            vtatabla.rango_fecha[2] = x-vig-hasta NO-ERROR.
  END.

  RELEASE vtatabla NO-ERROR.

END PROCEDURE.


/*
DEFINE VAR x-tabla-conceptos-nc AS CHAR INIT 'N/C'.
DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".
DEFINE VAR x-tabla-tipo-dscto AS CHAR INIT "TIPO_DSCTO".

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE "Opcion NO habilitada" VIEW-AS ALERT-BOX INFORMATION.
  RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN carga-data.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "llave_c2" THEN DO:
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
        END.
        

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
  {src/adm/template/snd-list.i "tt-VtaTabla"}

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

DEFINE VAR x-tipo-descuento AS CHAR.

x-tipo-descuento = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

IF NOT (TRUE <> (x-tipo-descuento > "")) THEN DO:
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla-tipo-dscto AND 
                                vtatabla.llave_c1 = x-tipo-descuento NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        MESSAGE "Codigo de Tipo de Descuento NO EXISTE" .
        RETURN "ADM-ERROR".
    END.
END.

  DEFINE VAR x-max-art-x-nc AS INT.
  DEFINE VAR x-vig-desde AS DATE.
  DEFINE VAR x-vig-hasta AS DATE.
  DEFINE VAR x-antigueda-cmpte AS INT.

  DEFINE VAR x-dd AS INT.
  DEFINE VAR x-mm AS INT.
  DEFINE VAR x-aaaa AS INT.
  DEFINE VAR x-dateformat AS CHAR.

  x-dateformat = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = "dmy".

  x-max-art-x-nc = INTEGER({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_valor[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
  x-antigueda-cmpte = INTEGER({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_valor[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.

  x-dd = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,2)) NO-ERROR.
  x-mm = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4,2)) NO-ERROR.
  x-aaaa = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},7)) NO-ERROR.

  x-vig-desde = DATE(x-mm,x-dd,x-aaaa) NO-ERROR.

  x-dd = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,2)) NO-ERROR.
  x-mm = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4,2)) NO-ERROR.
  x-aaaa = INTEGER(SUBSTRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rango_fecha[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},7)) NO-ERROR.

  x-vig-hasta = DATE(x-mm,x-dd,x-aaaa) NO-ERROR.

  IF x-max-art-x-nc <= 0 THEN DO:
      MESSAGE "Maximo Articulos x N/C debe ser mayor a uno (1)" .
      RETURN "ADM-ERROR".
  END.
  IF x-antigueda-cmpte < 0 THEN DO:
      MESSAGE "Dias de antigueda del comprobante debe ser mayor a uno (1)" .
      RETURN "ADM-ERROR".
  END.

  IF x-vig-desde <> ? OR x-vig-hasta <> ? THEN DO:
    IF x-vig-desde = ? THEN DO:
        SESSION:DATE-FORMAT = x-dateformat.
        MESSAGE "Ingrese la vigencia DESDE" .
        RETURN "ADM-ERROR".
    END.
    IF x-vig-hasta = ? THEN DO:
        SESSION:DATE-FORMAT = x-dateformat.
        MESSAGE "Ingrese la vigencia HASTA" .
        RETURN "ADM-ERROR".
    END.
    IF x-vig-desde > x-vig-hasta THEN DO:
        SESSION:DATE-FORMAT = x-dateformat.
        MESSAGE "Vigencia DESDE debe ser menor/igual a HASTA" .
        RETURN "ADM-ERROR".
    END.
  END.

  SESSION:DATE-FORMAT = x-dateformat.


RETURN "OK".

END PROCEDURE.

/*
DEFINE VAR x-tabla-conceptos-nc AS CHAR INIT 'N/C'.
DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".
DEFINE VAR x-tabla-tipo-dscto AS CHAR INIT "TIPO_DSCTO".

*/

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

