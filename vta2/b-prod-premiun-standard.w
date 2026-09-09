&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER tAlmmmatg1 FOR Almmmatg.
DEFINE BUFFER tAlmmmatg2 FOR Almmmatg.



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
DEFINE VAR x-tabla AS CHAR INIT "PROD.PREM.STAND".

DEFINE BUFFER x-vtatabla FOR vtatabla.

DEFINE VAR x-pto-vta-listaexpress AS CHAR.

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = 'CONFIG-VTAS' AND
                            vtatabla.llave_c1 = 'LISTAEXPRESS' AND
                            vtatabla.llave_c2 = 'DIVISION' NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN DO:
    MESSAGE "No esta configurado la division para la venta de ListaExpress Utilex Escolares"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

x-pto-vta-listaexpress = vtatabla.llave_c3.

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
&Scoped-define INTERNAL-TABLES VtaTabla tAlmmmatg1 tAlmmmatg2

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaTabla.Llave_c1 tAlmmmatg1.DesMat ~
tAlmmmatg1.DesMar VtaTabla.Llave_c2 tAlmmmatg2.DesMat tAlmmmatg2.DesMar ~
VtaTabla.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaTabla.Llave_c1 ~
VtaTabla.Llave_c2 VtaTabla.Libre_c01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaTabla WHERE ~{&KEY-PHRASE} ~
      AND vtatabla.codcia = s-codcia and ~
vtatabla.tabla = x-tabla NO-LOCK, ~
      FIRST tAlmmmatg1 WHERE tAlmmmatg1.CodCia = s-codcia and ~
tAlmmmatg1.codmat = VtaTabla.llave_c1 OUTER-JOIN NO-LOCK, ~
      FIRST tAlmmmatg2 WHERE tAlmmmatg2.CodCia = s-codcia and ~
tAlmmmatg2.codmat = VtaTabla.llave_c2 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaTabla WHERE ~{&KEY-PHRASE} ~
      AND vtatabla.codcia = s-codcia and ~
vtatabla.tabla = x-tabla NO-LOCK, ~
      FIRST tAlmmmatg1 WHERE tAlmmmatg1.CodCia = s-codcia and ~
tAlmmmatg1.codmat = VtaTabla.llave_c1 OUTER-JOIN NO-LOCK, ~
      FIRST tAlmmmatg2 WHERE tAlmmmatg2.CodCia = s-codcia and ~
tAlmmmatg2.codmat = VtaTabla.llave_c2 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaTabla tAlmmmatg1 tAlmmmatg2
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table tAlmmmatg1
&Scoped-define THIRD-TABLE-IN-QUERY-br_table tAlmmmatg2


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
      VtaTabla, 
      tAlmmmatg1, 
      tAlmmmatg2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaTabla.Llave_c1 COLUMN-LABEL "Cod.Art!Premiun" FORMAT "x(8)":U
            WIDTH 7
      tAlmmmatg1.DesMat FORMAT "X(45)":U WIDTH 20.86
      tAlmmmatg1.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 16.43
      VtaTabla.Llave_c2 COLUMN-LABEL "Cod.Art!Standard" FORMAT "x(8)":U
      tAlmmmatg2.DesMat FORMAT "X(45)":U WIDTH 25.86
      tAlmmmatg2.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 19.29
      VtaTabla.Libre_c01 COLUMN-LABEL "Estado" FORMAT "x(8)":U
            WIDTH 10.72 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "ACTIVO","INACTIVO" 
                      DROP-DOWN-LIST 
  ENABLE
      VtaTabla.Llave_c1
      VtaTabla.Llave_c2
      VtaTabla.Libre_c01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 116.57 BY 15.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.12 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tAlmmmatg1 B "?" ? INTEGRAL Almmmatg
      TABLE: tAlmmmatg2 B "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 15.5
         WIDTH              = 117.72.
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
     _TblList          = "INTEGRAL.VtaTabla,Temp-Tables.tAlmmmatg1 WHERE INTEGRAL.VtaTabla ...,Temp-Tables.tAlmmmatg2 WHERE INTEGRAL.VtaTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER"
     _Where[1]         = "vtatabla.codcia = s-codcia and
vtatabla.tabla = x-tabla"
     _JoinCode[2]      = "tAlmmmatg1.CodCia = s-codcia and
tAlmmmatg1.codmat = VtaTabla.llave_c1"
     _JoinCode[3]      = "tAlmmmatg2.CodCia = s-codcia and
tAlmmmatg2.codmat = VtaTabla.llave_c2"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c1
"VtaTabla.Llave_c1" "Cod.Art!Premiun" ? "character" ? ? ? ? ? ? yes ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tAlmmmatg1.DesMat
"tAlmmmatg1.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "20.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tAlmmmatg1.DesMar
"tAlmmmatg1.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Llave_c2
"VtaTabla.Llave_c2" "Cod.Art!Standard" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tAlmmmatg2.DesMat
"tAlmmmatg2.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "25.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tAlmmmatg2.DesMar
"tAlmmmatg2.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaTabla.Libre_c01
"VtaTabla.Libre_c01" "Estado" ? "character" ? ? ? ? ? ? yes ? no no "10.72" yes no no "U" "" "" "DROP-DOWN-LIST" "," "ACTIVO,INACTIVO" ? 5 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT NO-UNDO.
    DEFINE VAR codProd AS CHAR NO-UNDO.
    
    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.
    
    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */
    
    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).

    /* Si tiene activo la barra de titulo en el browse */
    addRow = 0.
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
           iRow = iRow + addRow.     
        END.
    END.
    ELSE DO:
        /* No esta activo la barra del titulo */
        iRow = iRow + addRow.
    END.
    
    
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).

        codProd = vtatabla.llave_c1.

        RUN vta2/w-prod-premiun-standard-sugeridos.r(INPUT codProd).

    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/
    
      RETURN NO-APPLY.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF vtatabla.llave_c1, vtatabla.llave_c2,vtatabla.libre_c01 IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
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
  ASSIGN vtatabla.codcia = s-codcia
        vtatabla.tabla = x-tabla.

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
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:    
   /* Esta MODIFICANDO */
      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c1:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  END.
  ELSE DO:
      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c1:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
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
  {src/adm/template/snd-list.i "VtaTabla"}
  {src/adm/template/snd-list.i "tAlmmmatg1"}
  {src/adm/template/snd-list.i "tAlmmmatg2"}

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
  
  DEFINE VAR cod1 AS CHAR.
  DEFINE VAR cod2 AS CHAR.
  DEFINE VAR estado AS CHAR.
  DEFINE VAR x-es-nuevo AS LOG INIT NO.

  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:    
   /* Esta MODIFICANDO */
  END.
  ELSE DO:
      x-es-nuevo = YES.
  END.

  cod1 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c1:SCREEN-VALUE IN BROWSE {&browse-name}.
  cod2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.llave_c2:SCREEN-VALUE IN BROWSE {&browse-name}.
  estado = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01:SCREEN-VALUE IN BROWSE {&browse-name}.

  IF TRUE <> (cod1 > "") AND TRUE <> (cod2 > "") THEN DO:
      MESSAGE "Ingrese los codigos de articulos correctamente" VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO vtatabla.llave_c1 IN BROWSE {&BROWSE-NAME}.
      RETURN "ADM-ERROR".
  END.

  IF TRUE <> (cod1 > "") THEN DO:
      MESSAGE "Debe ingresar el codigo PREMIUN" VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO vtatabla.llave_c1 IN BROWSE {&BROWSE-NAME}.
      RETURN "ADM-ERROR".
  END.

  IF TRUE <> (estado > "") THEN DO:
      MESSAGE "Debe seleccionar un estado" VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO vtatabla.libre_c01 IN BROWSE {&BROWSE-NAME}.
      RETURN "ADM-ERROR".

  END.

  FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = cod1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almmmatg THEN DO:
      MESSAGE "El codigo " cod1 " no existe en el maestro" VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO vtatabla.llave_c1 IN BROWSE {&BROWSE-NAME}.
      RETURN "ADM-ERROR".
  END.
  IF NOT (TRUE <> (cod2 > "")) THEN DO:
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = cod2 NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almmmatg THEN DO:
          MESSAGE "El codigo " cod2 " no existe en el maestro" VIEW-AS ALERT-BOX INFORMATION.
          APPLY 'ENTRY':U TO vtatabla.llave_c2 IN BROWSE {&BROWSE-NAME}.
          RETURN "ADM-ERROR".
      END.
  END.

  /* Validar que los codigos no esten repetidos */
  IF x-es-nuevo THEN DO:
      FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                    x-vtatabla.tabla = x-tabla AND
                                    x-vtatabla.llave_c1 = cod1 NO-LOCK NO-ERROR.
      IF AVAILABLE x-vtatabla THEN DO:
          MESSAGE "El codigo " cod1 " ya esta registrado como PREMIUN" VIEW-AS ALERT-BOX INFORMATION.
          APPLY 'ENTRY':U TO vtatabla.llave_c1 IN BROWSE {&BROWSE-NAME}.
          RETURN "ADM-ERROR".
      END.
      FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                    x-vtatabla.tabla = x-tabla AND
                                    x-vtatabla.llave_c2 = cod1 NO-LOCK NO-ERROR.
      IF AVAILABLE x-vtatabla THEN DO:
          MESSAGE "El codigo " cod1 " ya esta registrado como STANDARD" VIEW-AS ALERT-BOX INFORMATION.
          APPLY 'ENTRY':U TO vtatabla.llave_c1 IN BROWSE {&BROWSE-NAME}.
          RETURN "ADM-ERROR".
      END.
      IF NOT (TRUE <> (cod2 > "")) THEN DO:
          /* STANDARD */
          FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                        x-vtatabla.tabla = x-tabla AND
                                        x-vtatabla.llave_c1 = cod2 NO-LOCK NO-ERROR.
          IF AVAILABLE x-vtatabla THEN DO:
              MESSAGE "El codigo " cod2 " esta registrado como PREMIUM " VIEW-AS ALERT-BOX INFORMATION.
              APPLY 'ENTRY':U TO vtatabla.llave_c2 IN BROWSE {&BROWSE-NAME}.
              RETURN "ADM-ERROR".
          END.
          FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                        x-vtatabla.tabla = x-tabla AND
                                        x-vtatabla.llave_c2 = cod2 NO-LOCK NO-ERROR.
          IF AVAILABLE x-vtatabla THEN DO:
              MESSAGE "El codigo " cod2 " ya esta registrado como STANDARD " VIEW-AS ALERT-BOX INFORMATION.
              APPLY 'ENTRY':U TO vtatabla.llave_c2 IN BROWSE {&BROWSE-NAME}.
              RETURN "ADM-ERROR".
          END.
      END.
  END.

  /* Validar los codigos con el API */
  DEFINE VAR x-retval AS CHAR.
  RUN valida-peldaño(INPUT cod1, INPUT x-pto-vta-listaexpress, OUTPUT x-retval).

  IF x-retval <> "OK" THEN DO:
      MESSAGE x-retval VIEW-AS ALERT-BOX INFORMATION TITLE "INCONSISTENCIA ENCONTRADA " + cod1.
      RETURN "ADM-ERROR".
  END.

  IF NOT (TRUE <> (cod2 > "")) THEN DO:
      RUN valida-peldaño(INPUT cod2, INPUT x-pto-vta-listaexpress, OUTPUT x-retval).
    
      IF x-retval <> "OK" THEN DO:
          MESSAGE x-retval VIEW-AS ALERT-BOX INFORMATION TITLE "INCONSISTENCIA ENCONTRADA " + cod2.
          RETURN "ADM-ERROR".
      END.
  END.

RETURN "OK".

END PROCEDURE.
/*
&FieldName=DiscountedPriceCategoryCustomerAndConditionSale,ExchangeRate,CurrencySale,PercentageDiscountSalesCondition,PercentageDiscountCategoryCustomer,CurrencyRepositionCost,AmountRepositionCost&ArtCode=000602&SalesChannel=10&CategoryCustomer=C&SalesCondition=001
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-peldaño B-table-Win 
PROCEDURE valida-peldaño :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodmat AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN lib\API_consumo.r PERSISTENT SET hProc.

DEFINE VAR x-api AS LONGCHAR.
DEFINE VAR x-resultado AS LONGCHAR.
DEFINE VAR x-division AS CHAR.

x-division = x-pto-vta-listaexpress.

/* Procedimientos */
RUN API_tabla IN hProc (INPUT "ARTICULO.PELDAÑO", OUTPUT x-api).

IF TRUE<>(x-api > "") THEN DO:
    pRetVal = "NO se pudo ubicar la API para validar el peldaño del articulo".
    DELETE PROCEDURE hProc.
    RETURN "ADM-ERROR".
END.

x-api = x-api + "&FieldName=SalesChannel&ArtCode=" + pCodMat + "&Code=" + pCodDiv.

RUN API_consumir IN hProc (INPUT x-api, OUTPUT x-resultado).
IF x-resultado BEGINS "ERROR:" THEN DO:
    pRetVal = STRING(x-resultado).
    DELETE PROCEDURE hProc.
    RETURN "ADM-ERROR".
END.
IF index(lower(x-resultado),"not content") > 0 THEN DO:
    pRetVal = "El articulo " + pCodMat + " no se comercializa en el punto de venta " + pCodDiv.
    DELETE PROCEDURE hProc.
    RETURN "ADM-ERROR".
END.

pRetVal = "OK".

    /*&ArtCode=000602&SalesChannel=10&CategoryCustomer=C&SalesCondition=001*/

DELETE PROCEDURE hProc.                 /* Release Libreria */


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

