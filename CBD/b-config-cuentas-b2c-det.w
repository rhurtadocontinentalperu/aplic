&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-cb-ctas FOR cb-ctas.



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
DEFINE BUFFER x-vtadtabla FOR vtadtabla.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-col-nom-user AS CHAR.
DEFINE VAR x-tabla AS CHAR INIT "CONCILIACION-B2C".

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaCTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCTabla.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaDTabla cb-ctas

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaDTabla.Tipo ~
VtaDTabla.LlaveDetalle VtaDTabla.Libre_c01 VtaDTabla.Libre_c02 ~
VtaDTabla.Libre_c03 cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaDTabla.Tipo ~
VtaDTabla.LlaveDetalle VtaDTabla.Libre_c01 VtaDTabla.Libre_c02 ~
VtaDTabla.Libre_c03 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaDTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaDTabla OF VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaDTabla.CodCia = s-codcia and ~
vtadtabla.tabla = x-tabla NO-LOCK, ~
      FIRST cb-ctas WHERE cb-ctas.codcia = 0 and ~
cb-ctas.codcta = vtadtabla.llavedetalle OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaDTabla OF VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaDTabla.CodCia = s-codcia and ~
vtadtabla.tabla = x-tabla NO-LOCK, ~
      FIRST cb-ctas WHERE cb-ctas.codcia = 0 and ~
cb-ctas.codcta = vtadtabla.llavedetalle OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaDTabla cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table cb-ctas


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNomUser B-table-Win 
FUNCTION getNomUser RETURNS CHARACTER
  ( pCodUser AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaDTabla, 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaDTabla.Tipo COLUMN-LABEL "Tipo!Doc" FORMAT "x(5)":U VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "FAC","FAC",
                                      "BOL","BOL"
                      DROP-DOWN-LIST 
      VtaDTabla.LlaveDetalle COLUMN-LABEL "Cuenta!Soles" FORMAT "x(12)":U
      VtaDTabla.Libre_c01 COLUMN-LABEL "Debe!Haber" FORMAT "x(8)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "DEBE","HABER" 
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_c02 COLUMN-LABEL "Que!Importe" FORMAT "x(30)":U
            WIDTH 21.43 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Importe Total","IMP-TOTAL",
                                      "Comision","IMP-COMISION",
                                      "Total menos la comision","IMP-TOTAL-MENOS-COMI"
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_c03 COLUMN-LABEL "Cuenta!Dolares" FORMAT "x(15)":U
      cb-ctas.Nomcta COLUMN-LABEL "Descripcion de la cuenta SOLES" FORMAT "x(60)":U
            WIDTH 47.43
  ENABLE
      VtaDTabla.Tipo
      VtaDTabla.LlaveDetalle
      VtaDTabla.Libre_c01
      VtaDTabla.Libre_c02
      VtaDTabla.Libre_c03
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 96 BY 11.31
         FONT 4
         TITLE "TIPO DOCUMENTO CUENTAS" ROW-HEIGHT-CHARS .42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.VtaCTabla
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-cb-ctas B "?" ? INTEGRAL cb-ctas
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
         HEIGHT             = 11.5
         WIDTH              = 97.43.
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
     _TblList          = "INTEGRAL.VtaDTabla OF INTEGRAL.VtaCTabla,INTEGRAL.cb-ctas WHERE INTEGRAL.VtaDTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "VtaDTabla.CodCia = s-codcia and
vtadtabla.tabla = x-tabla"
     _JoinCode[2]      = "cb-ctas.codcia = 0 and
cb-ctas.codcta = vtadtabla.llavedetalle"
     _FldNameList[1]   > INTEGRAL.VtaDTabla.Tipo
"VtaDTabla.Tipo" "Tipo!Doc" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "FAC,FAC,BOL,BOL" 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaDTabla.LlaveDetalle
"VtaDTabla.LlaveDetalle" "Cuenta!Soles" "x(12)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaDTabla.Libre_c01
"VtaDTabla.Libre_c01" "Debe!Haber" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "DEBE,HABER" ? 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDTabla.Libre_c02
"VtaDTabla.Libre_c02" "Que!Importe" "x(30)" "character" ? ? ? ? ? ? yes ? no no "21.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Importe Total,IMP-TOTAL,Comision,IMP-COMISION,Total menos la comision,IMP-TOTAL-MENOS-COMI" 5 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDTabla.Libre_c03
"VtaDTabla.Libre_c03" "Cuenta!Dolares" "x(15)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.cb-ctas.Nomcta
"cb-ctas.Nomcta" "Descripcion de la cuenta SOLES" "x(60)" "character" ? ? ? ? ? ? no ? no no "47.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* TIPO DOCUMENTO CUENTAS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* TIPO DOCUMENTO CUENTAS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* TIPO DOCUMENTO CUENTAS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN DO:
        DO WITH FRAME {&FRAME-NAME} :
            vtadtabla.tipo:SCREEN-VALUE IN BROWSE {&browse-name} = "BOL".
            vtadtabla.libre_c01:SCREEN-VALUE IN BROWSE {&browse-name} = "DEBE".
            vtadtabla.libre_c02:SCREEN-VALUE IN BROWSE {&browse-name} = "IMP-TOTAL".
        END.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDTabla.Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDTabla.Tipo br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDTabla.Tipo IN BROWSE br_table /* Tipo!Doc */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDTabla.LlaveDetalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDTabla.LlaveDetalle br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF VtaDTabla.LlaveDetalle IN BROWSE br_table /* Cuenta!Soles */
DO:
    DO WITH FRAME {&FRAME-NAME} :
        DEF VAR T-ROWID AS ROWID.
        RUN CBD/H-CTAS01.W(s-codcia, 0,OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            find FIRST cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
            IF avail cb-ctas
            THEN DO:
                vtadtabla.llavedetalle:SCREEN-VALUE IN BROWSE {&browse-name} = cb-ctas.CodCta.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDTabla.Libre_c03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDTabla.Libre_c03 br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF VtaDTabla.Libre_c03 IN BROWSE br_table /* Cuenta!Dolares */
DO:
    DO WITH FRAME {&FRAME-NAME} :
        DEF VAR T-ROWID AS ROWID.
        RUN CBD/H-CTAS01.W(s-codcia, 0,OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            find FIRST cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
            IF avail cb-ctas
            THEN DO:
                vtadtabla.libre_c03:SCREEN-VALUE IN BROWSE {&browse-name} = cb-ctas.CodCta.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

        ON 'RETURN':U OF  vtadtabla.tipo
        DO:
            APPLY 'TAB'.
            RETURN NO-APPLY.
        END.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaCTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT (AVAILABLE vtactabla) THEN DO:
      MESSAGE "Debe registrar de antemano una OPERACION" VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*
  DO WITH FRAME {&FRAME-NAME} :
      vtadtabla.tipo:SCREEN-VALUE IN BROWSE {&browse-name} = "BOL".
      vtadtabla.libre_c01:SCREEN-VALUE IN BROWSE {&browse-name} = "DEBE".
      vtadtabla.libre_c02:SCREEN-VALUE IN BROWSE {&browse-name} = "IMP-TOTAL".
  END.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry B-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
  ASSIGN vtadtabla.codcia = vtactabla.codcia 
        vtadtabla.tabla = vtactabla.tabla
        vtadtabla.llave = vtactabla.llave.

   CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM:SS')
    logtabla.Tabla = 'VTADTABLA'
    logtabla.Usuario = USERID("DICTDB")
    logtabla.ValorLlave = "TABLA:" + TRIM(vtadtabla.tabla) + '|' +
                            "CUENTA SOLES:" + TRIM(vtadtabla.llave) + "|" +
                            "TIPODOC:" + TRIM(vtadtabla.tipo).
 RELEASE LogTabla. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT (AVAILABLE vtactabla) THEN DO:
      MESSAGE "Debe registrar un perfil de antemano" VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.
  IF NOT (AVAILABLE vtadtabla) THEN DO:
      MESSAGE "No existen usuarios para eliminar" VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  IF RETURN-VALUE = 'NO' THEN DO:
      ASSIGN 
          VtaDTabla.tipo:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.
  ELSE DO:
      ASSIGN 
          VtaDTabla.tipo:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record B-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

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
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "VtaDTabla"}
  {src/adm/template/snd-list.i "cb-ctas"}

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

DEFINE VAR x-tipodoc AS CHAR.
DEFINE VAR x-tipomov AS CHAR.
DEFINE VAR x-tipoimp AS CHAR.
DEFINE VAR x-cta AS CHAR.
DEFINE VAR x-cta2 AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    x-tipodoc = vtadtabla.tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-tipomov = vtadtabla.libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-tipoimp = vtadtabla.libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-cta = vtadtabla.llavedetalle:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-cta2 = vtadtabla.libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
END.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    FIND FIRST x-vtadtabla WHERE x-vtadtabla.codcia = vtactabla.codcia AND
                                    x-vtadtabla.tabla = vtactabla.tabla AND
                                    x-vtadtabla.llave = vtactabla.llave AND
                                    x-vtadtabla.tipo = x-tipodoc AND 
                                    x-vtadtabla.llavedetalle = x-cta NO-LOCK NO-ERROR.
    IF AVAILABLE x-vtadtabla THEN DO:
        MESSAGE "Tipo Doc / Cuenta Soles Ya esta registrada" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

FIND FIRST facdocum WHERE facdocum.codcia = s-codcia AND
                            facdocum.coddoc = x-tipodoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE facdocum THEN DO:
    MESSAGE "Tipo documento NO EXISTE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND
                        cb-ctas.codcta = x-cta NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta Soles NO EXISTE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
IF LOOKUP(x-tipomov,"DEBE,HABER") = 0 THEN DO:
    MESSAGE "Seleccione DEBE o HABER" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

IF TRUE <> (x-tipoimp > "") THEN DO:
    MESSAGE "Seleccione TIPO DE IMPORTE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND
                        cb-ctas.codcta = x-cta2 NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta dolares NO EXISTE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
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

  
  IF NOT (AVAILABLE vtactabla) THEN DO:
      MESSAGE "Debe registrar un perfil de antemano" VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.
  IF NOT (AVAILABLE vtadtabla) THEN DO:
      MESSAGE "No hay usuarios para modificar" VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.  


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNomUser B-table-Win 
FUNCTION getNomUser RETURNS CHARACTER
  ( pCodUser AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR.

  FIND FIRST _user WHERE _user._userid = pCodUser NO-LOCK NO-ERROR.
  IF AVAILABLE _user THEN x-retval = _user._user-Name.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

