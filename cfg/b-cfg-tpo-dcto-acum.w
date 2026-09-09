&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEF VAR s-Tabla AS CHAR INIT 'TIPDTOPED' NO-UNDO.

DEF TEMP-TABLE t-FacTabla LIKE FacTabla 
    FIELD fRowid AS ROWID
    INDEX Idx00 AS PRIMARY CodCia.

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
&Scoped-define INTERNAL-TABLES FacTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Codigo FacTabla.Nombre ~
FacTabla.Campo-C[1] FacTabla.Campo-C[2] FacTabla.Campo-L[1] ~
FacTabla.Campo-L[2] FacTabla.Campo-L[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Campo-C[2] ~
FacTabla.Campo-L[1] FacTabla.Campo-L[2] FacTabla.Campo-L[3] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK ~
    BY FacTabla.Valor[1]
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK ~
    BY FacTabla.Valor[1].
&Scoped-define TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacTabla


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
      FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacTabla.Codigo COLUMN-LABEL "CODIGO" FORMAT "x(20)":U WIDTH 19.43
      FacTabla.Nombre COLUMN-LABEL "DESCRIPCION" FORMAT "x(40)":U
            WIDTH 45.43
      FacTabla.Campo-C[1] COLUMN-LABEL "TIPO 1" FORMAT "x(20)":U
            WIDTH 15.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "UNICO","ACUMULATIVO" 
                      DROP-DOWN-LIST 
      FacTabla.Campo-C[2] COLUMN-LABEL "TIPO 2" FORMAT "x(20)":U
            WIDTH 12.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "EXCLUYENTE","ACUMULADO" 
                      DROP-DOWN-LIST 
      FacTabla.Campo-L[1] COLUMN-LABEL "Ventas!Mayorista!Crédito" FORMAT "yes/no":U
            WIDTH 8.14 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[2] COLUMN-LABEL "Venta!Mayorista!Contado" FORMAT "yes/no":U
            WIDTH 9.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[3] COLUMN-LABEL "Venta!Mayorista!Eventos" FORMAT "yes/no":U
            WIDTH 9.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS TOGGLE-BOX
  ENABLE
      FacTabla.Campo-C[2]
      FacTabla.Campo-L[1]
      FacTabla.Campo-L[2]
      FacTabla.Campo-L[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 128 BY 15.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     "Leyenda:" VIEW-AS TEXT
          SIZE 17 BY .88 AT ROW 16.88 COL 3 WIDGET-ID 2
          FONT 8
     "TIPO 1: FUNCIONALIDAD CON OTROS DESCUENTOS QUE NO SEAN ACUMULADOS" VIEW-AS TEXT
          SIZE 71 BY .62 AT ROW 17.96 COL 3 WIDGET-ID 4
          FONT 6
     "UNICO: Cualquier descuento por Volumen o Promocional SE VUELVE CERO" VIEW-AS TEXT
          SIZE 70 BY .62 AT ROW 18.77 COL 8 WIDGET-ID 6
     "ACUMULATIVO: Se mantiene el descuento por Volumen o Promocional" VIEW-AS TEXT
          SIZE 70 BY .62 AT ROW 19.58 COL 8 WIDGET-ID 8
     "TIPO 2: FUNCIONALIDAD CON OTROS DESCUENTOS ACUMULADOS" VIEW-AS TEXT
          SIZE 70 BY .62 AT ROW 20.38 COL 3 WIDGET-ID 10
          FONT 6
     "EXCLUYENTE: Descuento único, no se suma con otros DESCUENTOS ACUMULADOS" VIEW-AS TEXT
          SIZE 80 BY .62 AT ROW 21.19 COL 8 WIDGET-ID 12
     "ACUMULADO: Se suma con otros DESCUENTOS ACUMULADOS" VIEW-AS TEXT
          SIZE 70 BY .62 AT ROW 22 COL 8 WIDGET-ID 14
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
         HEIGHT             = 21.88
         WIDTH              = 136.72.
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
     _TblList          = "INTEGRAL.FacTabla"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.FacTabla.Valor[1]|yes"
     _Where[1]         = "FacTabla.CodCia = s-codcia
 AND FacTabla.Tabla = s-tabla"
     _FldNameList[1]   > INTEGRAL.FacTabla.Codigo
"Codigo" "CODIGO" "x(20)" "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacTabla.Nombre
"Nombre" "DESCRIPCION" ? "character" ? ? ? ? ? ? no ? no no "45.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacTabla.Campo-C[1]
"Campo-C[1]" "TIPO 1" "x(20)" "character" 14 0 ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "UNICO,ACUMULATIVO" ? 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacTabla.Campo-C[2]
"Campo-C[2]" "TIPO 2" "x(20)" "character" 11 0 ? ? ? ? yes ? no no "12.72" yes no no "U" "" "" "DROP-DOWN-LIST" "," "EXCLUYENTE,ACUMULADO" ? 5 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacTabla.Campo-L[1]
"Campo-L[1]" "Ventas!Mayorista!Crédito" ? "logical" 11 0 ? ? ? ? yes ? no no "8.14" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacTabla.Campo-L[2]
"Campo-L[2]" "Venta!Mayorista!Contado" ? "logical" 11 0 ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacTabla.Campo-L[3]
"Campo-L[3]" "Venta!Mayorista!Eventos" ? "logical" 11 0 ? ? ? ? yes ? no no "8.72" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tabla B-table-Win 
PROCEDURE Actualiza-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro update registros */
DEF BUFFER b-FacTabla FOR FacTabla.

FOR EACH b-FacTabla NO-LOCK WHERE b-FacTabla.codcia = s-codcia AND
    b-FacTabla.tabla = "KEY_TPO_DCTO_ACUM":
    FIND FacTabla WHERE FacTabla.codcia = s-codcia AND 
        FacTabla.tabla = s-Tabla AND
        FacTabla.Codigo = b-FacTabla.Codigo
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN CREATE FacTabla.
    ELSE DO:
        FIND CURRENT FacTabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN RETURN.
    END.
    ASSIGN
        FacTabla.codcia = s-codcia 
        FacTabla.tabla = s-Tabla
        FacTabla.Codigo = b-FacTabla.Codigo
        FacTabla.nombre = b-FacTabla.nombre
        FacTabla.Campo-C[1] = b-FacTabla.Campo-C[1].
    IF TRUE <> (FacTabla.Campo-C[2] > '') THEN FacTabla.Campo-C[2] = "EXCLUYENTE".
    RELEASE FacTabla.
END.

/* 2do. delete registros */
FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.codcia = s-codcia AND FacTabla.tabla = s-Tabla:
    IF NOT CAN-FIND(FIRST b-FacTabla WHERE b-FacTabla.codcia = s-codcia AND
                    b-FacTabla.tabla = "KEY_TPO_DCTO_ACUM" AND
                    b-FacTabla.Codigo = FacTabla.Codigo NO-LOCK)
        THEN DELETE FacTabla.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DownRow B-table-Win 
PROCEDURE DownRow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE FacTabla THEN RETURN.

DEF BUFFER b-FacTabla FOR FacTabla.

/* Se va a ordenar de 10 en 10 */
DEF VAR rRowid AS ROWID NO-UNDO.

rRowid  = ROWID(FacTabla).

EMPTY TEMP-TABLE t-FacTabla.

DEF VAR iOrden AS INTE INIT 10 NO-UNDO.
DEF VAR k AS INTE NO-UNDO INIT 0.

FOR EACH b-FacTabla WHERE b-FacTabla.CodCia = s-codcia AND b-FacTabla.Tabla = s-tabla:
    k = k + 1.
END.
iOrden = k * 10.

FOR EACH b-FacTabla WHERE b-FacTabla.CodCia = s-codcia AND b-FacTabla.Tabla = s-tabla
    BY b-FacTabla.Valor[1] DESC:
    CREATE t-FacTabla.
    BUFFER-COPY b-FacTabla TO t-FacTabla 
        ASSIGN 
            t-FacTabla.fRowid = ROWID(b-FacTabla)
            t-FacTabla.Valor[1] = iOrden.
    IF t-FacTabla.fRowid = rRowid THEN t-FacTabla.Valor[1] = t-FacTabla.Valor[1] + 15.
    iOrden = iOrden - 10.
END.

iOrden = 10.
FOR EACH t-FacTabla NO-LOCK,
    FIRST b-FacTabla EXCLUSIVE-LOCK WHERE ROWID(b-FacTabla) = t-FacTabla.fRowid
    BY t-FacTabla.Valor[1]:
    ASSIGN
        b-FacTabla.Valor[1] = iOrden.
    iOrden = iOrden + 10.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

REPOSITION {&browse-name} TO ROWID rRowid NO-ERROR.

  RUN lib/logtabla ('FACTABLA',
                     FacTabla.Tabla + '|' +
                    FacTabla.Codigo + '|' +
                    STRING(FacTabla.Valor[1],'>>9') + '|' +
                    FacTabla.Campo-C[1] + '|' +
                    FacTabla.Campo-C[2] + '|' +
                    STRING(FacTabla.Campo-L[1]) + '|' +
                    STRING(FacTabla.Campo-L[2]) + '|' +
                    STRING(FacTabla.Campo-L[3]) + '|' +
                    STRING(FacTabla.Campo-L[4]) 
                    ,
                    'UPDATE').

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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

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
  RUN lib/logtabla ('FACTABLA',
                     FacTabla.Tabla + '|' +
                    FacTabla.Codigo + '|' +
                    STRING(FacTabla.Valor[1],'>>9') + '|' +
                    FacTabla.Campo-C[1] + '|' +
                    FacTabla.Campo-C[2] + '|' +
                    STRING(FacTabla.Campo-L[1]) + '|' +
                    STRING(FacTabla.Campo-L[2]) + '|' +
                    STRING(FacTabla.Campo-L[3]) + '|' +
                    STRING(FacTabla.Campo-L[4]) 
                    ,
                    'UPDATE').

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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

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
  RUN Actualiza-Tabla.

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
  {src/adm/template/snd-list.i "FacTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpRow B-table-Win 
PROCEDURE UpRow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE FacTabla THEN RETURN.

DEF BUFFER b-FacTabla FOR FacTabla.

/* Se va a ordenar de 10 en 10 */
DEF VAR rRowid AS ROWID NO-UNDO.

rRowid  = ROWID(FacTabla).

EMPTY TEMP-TABLE t-FacTabla.

DEF VAR iOrden AS INTE INIT 10 NO-UNDO.

FOR EACH b-FacTabla WHERE b-FacTabla.CodCia = s-codcia AND b-FacTabla.Tabla = s-tabla
    BY b-FacTabla.Valor[1]:
    CREATE t-FacTabla.
    BUFFER-COPY b-FacTabla TO t-FacTabla 
        ASSIGN 
            t-FacTabla.fRowid = ROWID(b-FacTabla)
            t-FacTabla.Valor[1] = iOrden.
    IF t-FacTabla.fRowid = rRowid THEN t-FacTabla.Valor[1] = t-FacTabla.Valor[1] - 15.
    iOrden = iOrden + 10.
END.

iOrden = 10.
FOR EACH t-FacTabla NO-LOCK,
    FIRST b-FacTabla EXCLUSIVE-LOCK WHERE ROWID(b-FacTabla) = t-FacTabla.fRowid
    BY t-FacTabla.Valor[1]:
    ASSIGN
        b-FacTabla.Valor[1] = iOrden.
    iOrden = iOrden + 10.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

REPOSITION {&browse-name} TO ROWID rRowid NO-ERROR.

  RUN lib/logtabla ('FACTABLA',
                     FacTabla.Tabla + '|' +
                    FacTabla.Codigo + '|' +
                    STRING(FacTabla.Valor[1],'>>9') + '|' +
                    FacTabla.Campo-C[1] + '|' +
                    FacTabla.Campo-C[2] + '|' +
                    STRING(FacTabla.Campo-L[1]) + '|' +
                    STRING(FacTabla.Campo-L[2]) + '|' +
                    STRING(FacTabla.Campo-L[3]) + '|' +
                    STRING(FacTabla.Campo-L[4]) 
                    ,
                    'UPDATE').


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

