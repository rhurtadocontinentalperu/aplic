&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-todas-lineas AS LOG INIT NO.

DEFINE VAR x-proceso AS CHAR.
DEFINE VAR x-motivo AS CHAR.

DEFINE VAR x-tabla AS CHAR.

x-tabla = "CYC-LINEA-VALIDA".


DEFINE BUFFER xtt-w-report FOR tt-w-report.
DEFINE TEMP-TABLE ytt-w-report LIKE w-report.

DEFINE VAR x-hay-cambios AS LOG INIT NO.

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
&Scoped-define INTERNAL-TABLES tt-w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tt-w-report
&Scoped-define QUERY-STRING-br_table FOR EACH tt-w-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-w-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-w-report


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
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Linea" FORMAT "X(6)":U
            WIDTH 5.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Descripcion de la Linea" FORMAT "X(50)":U
            WIDTH 32.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Sub-Linea" FORMAT "X(6)":U
            WIDTH 8
      tt-w-report.Campo-C[4] COLUMN-LABEL "Descripcion Sub-Linea" FORMAT "X(50)":U
            WIDTH 30.86
      tt-w-report.Campo-C[5] COLUMN-LABEL "Signo" FORMAT "X(1)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "+","-" 
                      DROP-DOWN-LIST 
  ENABLE
      tt-w-report.Campo-C[1]
      tt-w-report.Campo-C[2]
      tt-w-report.Campo-C[3]
      tt-w-report.Campo-C[4]
      tt-w-report.Campo-C[5]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 89 BY 13.46
         FONT 4.


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
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 14.08
         WIDTH              = 92.
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

ASSIGN 
       tt-w-report.Campo-C[2]:COLUMN-READ-ONLY IN BROWSE br_table = TRUE
       tt-w-report.Campo-C[4]:COLUMN-READ-ONLY IN BROWSE br_table = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Linea" "X(6)" "character" ? ? ? ? ? ? yes ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Descripcion de la Linea" "X(50)" "character" ? ? ? ? ? ? yes ? no no "32.43" yes no yes "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Sub-Linea" "X(6)" "character" ? ? ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Descripcion Sub-Linea" "X(50)" "character" ? ? ? ? ? ? yes ? no no "30.86" yes no yes "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Signo" "X(1)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "+,-" ? 5 no 0 no no
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


&Scoped-define SELF-NAME tt-w-report.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-w-report.Campo-C[1] IN BROWSE br_table /* Linea */
DO:
    DEFINE VAR x-linea AS CHAR.
    
    x-linea = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF NOT (TRUE >(x-linea > "") ) THEN DO:
        IF x-linea = '*' THEN DO:
            /*
            IF x-todas-lineas = YES THEN DO:
                MESSAGE "Todas la Lineas ya esta registrado" VIEW-AS ALERT-BOX INFORMATION.
                APPLY 'ENTRY':U TO tt-w-report.campo-c[1] IN BROWSE {&BROWSE-NAME}.
                RETURN NO-APPLY.
            END.
            ELSE DO:
            */
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[2]:SCREEN-VALUE IN BROWSE br_table = "Todas las Lineas".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[3]:SCREEN-VALUE IN BROWSE br_table = "*".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[4]:SCREEN-VALUE IN BROWSE br_table = "Todas las Sub-Lineas".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "+".

                {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES .
                /*{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[5]:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES .*/

                /*x-todas-lineas = YES.            */
            /*END.*/
        END.
        ELSE DO:
            FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND
                                        almtfami.codfam = x-linea NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almtfami THEN DO:
                MESSAGE "Linea no existe" VIEW-AS ALERT-BOX INFORMATION.
                /*APPLY 'ENTRY':U TO tt-w-report.campo-c[1] IN BROWSE {&BROWSE-NAME}.*/
                RETURN NO-APPLY.                
            END.

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[2]:SCREEN-VALUE IN BROWSE br_table = almtfam.desfam.        
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[3]:SCREEN-VALUE IN BROWSE br_table = "*".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[4]:SCREEN-VALUE IN BROWSE br_table = "Todas las Sub-Lineas".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "+".
            IF x-todas-lineas = YES THEN ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "-".


            /*APPLY 'ENTRY':U TO {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3] IN BROWSE {&BROWSE-NAME}.*/

            {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.        
            {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[5]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.

        END.
    END.
    ELSE DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[2]:SCREEN-VALUE IN BROWSE br_table = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-w-report.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-w-report.Campo-C[3] IN BROWSE br_table /* Sub-Linea */
DO:
    DEFINE VAR x-sublinea AS CHAR.
    DEFINE VAR x-linea AS CHAR.
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    
    x-sublinea = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-linea = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

     hColumn = BROWSE br_table:GET-BROWSE-COLUMN(5).    

    IF NOT (TRUE <> (x-sublinea > "")) THEN DO:
        IF x-sublinea = '*' THEN DO:

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[4]:SCREEN-VALUE IN BROWSE br_table = "Todas las Sub-Lineas".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "+".
            IF x-todas-lineas = YES THEN ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "-".

        END.
        ELSE DO:
            FIND FIRST almsfami WHERE almsfami.codcia = s-codcia AND
                                        almsfami.codfam = x-linea AND
                                        almsfami.subfam = x-sublinea NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almsfami THEN DO:
                MESSAGE "SubLinea no existe" VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.                
            END.

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[4]:SCREEN-VALUE IN BROWSE br_table = almsfami.dessub.
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "+".
            IF x-todas-lineas = YES THEN ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[5]:SCREEN-VALUE IN BROWSE br_table = "-".

        END.
    END.
    ELSE DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.campo-c[4]:SCREEN-VALUE IN BROWSE br_table = "".
    END.

    IF x-todas-lineas = YES OR x-linea = '*' THEN DO:
        /*hColumn:read-only = YES.*/
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

ON 'RETURN':U OF tt-w-report.campo-c[1], tt-w-report.campo-c[2], 
                tt-w-report.campo-c[3], tt-w-report.campo-c[4],
                tt-w-report.campo-c[5] IN BROWSE {&BROWSE-NAME} DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data B-table-Win 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  SESSION:SET-WAIT-STATE("GENERAL").

  DO WITH FRAME {&FRAME-NAME}:

      EMPTY TEMP-TABLE tt-w-report.

      x-todas-lineas = NO.

      FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                            vtatabla.tabla = x-tabla NO-LOCK:
          CREATE tt-w-report.
          ASSIGN    tt-w-report.campo-c[1] = vtatabla.llave_c1
                    tt-w-report.campo-c[3] = vtatabla.llave_c2
                    .
              
          /* FAMILIA */
          IF tt-w-report.campo-c[1] = "*" THEN DO:
             ASSIGN tt-w-report.campo-c[2] = "<Todas la lineas>".
             x-todas-lineas = YES.
          END.
          ELSE DO:
              ASSIGN tt-w-report.campo-c[2] = "LINEA ERRADA".
              FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                                            almtfam.codfam = tt-w-report.campo-c[1]
                                            NO-LOCK NO-ERROR.
              IF AVAILABLE almtfam THEN ASSIGN tt-w-report.campo-c[2] = almtfam.desfam.
          END.
          /* SUB-FAMILIA */
          IF tt-w-report.campo-c[3] = "*" THEN DO:
             ASSIGN tt-w-report.campo-c[4] = "<Todas la Sub-lineas>".
          END.
          ELSE DO:
              ASSIGN tt-w-report.campo-c[4] = "SUB-LINEA ERRADA".
              FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND
                                            almsfam.codfam = tt-w-report.campo-c[1] AND
                                            almsfam.subfam = tt-w-report.campo-c[3]
                                            NO-LOCK NO-ERROR.
              IF AVAILABLE almsfam THEN ASSIGN tt-w-report.campo-c[4] = almsfam.dessub.
          END.
          ASSIGN tt-w-report.campo-c[5] = vtatabla.llave_c4.
      END.

      {&open-query-br_table}

  END.

  SESSION:SET-WAIT-STATE("").



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-valores B-table-Win 
PROCEDURE carga-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pProceso AS CHAR.
DEFINE INPUT PARAMETER pMotivo AS CHAR.

x-proceso = pProceso.
x-motivo = pMotivo.

RUN carga-data.

x-hay-cambios = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-existen-cambios B-table-Win 
PROCEDURE get-existen-cambios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = x-hay-cambios.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar B-table-Win 
PROCEDURE grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    MESSAGE 'Seguro de GRABAR los datos ?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.


  SESSION:SET-WAIT-STATE("GENERAL").

  /*
    xtt-.... : Data que hemos modificado
    ytt-.... : Data como esta en la base de datos
  */

  DEFINE VAR x-msg AS CHAR INIT "OK".

  /* Cargar en memoria la data actual */
  EMPTY TEMP-TABLE ytt-w-report.

  FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND 
                                        rbte_linea_generan_nc.codrazon = x-motivo NO-LOCK:
      CREATE ytt-w-report.
      ASSIGN    ytt-w-report.campo-c[1] = rbte_linea_generan_nc.codlinea
                ytt-w-report.campo-c[3] = rbte_linea_generan_nc.codsublinea
                ytt-w-report.campo-c[5] = rbte_linea_generan_nc.signo
          .
  END.

  /* Seleccionamos aquellos que hay que eliminar */
  FOR EACH ytt-w-report :
      ASSIGN ytt-w-report.campo-c[10] = "".

      FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = ytt-w-report.campo-c[1] AND
                                    xtt-w-report.campo-c[3] = ytt-w-report.campo-c[3] NO-LOCK NO-ERROR.

      IF NOT AVAILABLE xtt-w-report THEN DO:
            /* Ya no existe en la actualizacion que estamos realizando, Marcado para su eliminacion */
            ASSIGN ytt-w-report.campo-c[10] = "X".
      END.
  END.


  GRABACION:
  DO TRANSACTION ON ERROR UNDO GRABACION, LEAVE GRABACION:  
      DO:
    
          /* Procedemos a eliminar*/
          FOR EACH ytt-w-report WHERE ytt-w-report.campo-c[10] = "X" :
              FIND FIRST rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                                        rbte_linea_generan_nc.codrazon = x-motivo AND
                                                        rbte_linea_generan_nc.codlinea = ytt-w-report.campo-c[1] AND
                                                        rbte_linea_generan_nc.codsublinea = ytt-w-report.campo-c[3]
                                                        EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE rbte_linea_generan_nc THEN DO:
                  DELETE rbte_linea_generan_nc NO-ERROR.
              END.

              IF ERROR-STATUS:ERROR THEN DO:
                  x-msg = ERROR-STATUS:GET-MESSAGE(1).
                  UNDO GRABACION, LEAVE GRABACION.
              END.
          END.
    
          /* Actualizacon/adicionamos el resto */
          FOR EACH xtt-w-report :
              FIND FIRST rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                                        rbte_linea_generan_nc.codrazon = x-motivo AND
                                                        rbte_linea_generan_nc.codlinea = xtt-w-report.campo-c[1] AND
                                                        rbte_linea_generan_nc.codsublinea = xtt-w-report.campo-c[3]
                                                        EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE rbte_linea_generan_nc THEN DO:
                  CREATE rbte_linea_generan_nc.
                    ASSIGN rbte_linea_generan_nc.codcia = s-codcia
                            rbte_linea_generan_nc.codproceso = x-proceso
                            rbte_linea_generan_nc.codrazon = x-motivo
                            rbte_linea_generan_nc.codlinea = xtt-w-report.campo-c[1]
                            rbte_linea_generan_nc.codsublinea = xtt-w-report.campo-c[3]
                            rbte_linea_generan_nc.campo-c[1] = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS")
                            NO-ERROR
                            .
              END.
              ASSIGN rbte_linea_generan_nc.signo = xtt-w-report.campo-c[5]
                        rbte_linea_generan_nc.campo-c[2] = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS")
                  NO-ERROR.
    
              IF ERROR-STATUS:ERROR THEN DO:
                  x-msg = ERROR-STATUS:GET-MESSAGE(1).
                  UNDO GRABACION, LEAVE GRABACION.
              END.

          END.
      END.
  END.

  RELEASE rbte_linea_generan_nc.

  IF x-msg = 'OK' THEN DO:
      MESSAGE "Se grabaron los datos CORRECTAMENTE" VIEW-AS ALERT-BOX INFORMATION.
      x-hay-cambios = NO.
  END.
  ELSE DO:
      MESSAGE "Problemas al grabar los datos" SKIP
            x-msg
           VIEW-AS ALERT-BOX INFORMATION.
  END.

  SESSION:SET-WAIT-STATE("").
*/

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*
  DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.

  hColumn = BROWSE br_table:GET-BROWSE-COLUMN(5).      /* Signo */

  IF x-todas-lineas = YES THEN DO:
      hColumn:READ-ONLY = YES.
  END.
  ELSE DO:
      hColumn:READ-ONLY = NO.
  END.
  */

END PROCEDURE.
/*
        DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.

  hColumn = BROWSE bCust:GET-BROWSE-COLUMN(INTEGER(cbColumns:SCREEN-VALUE)).
  hColumn:VISIBLE = (IF hColumn:VISIBLE EQ TRUE THEN FALSE ELSE TRUE).
*/

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

  
  DEFINE VAR x-linea AS CHAR.
  DEFINE VAR x-sublinea AS CHAR.
  DEFINE VAR x-signo AS CHAR.

  x-linea = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-sublinea = tt-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-signo = tt-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  IF x-linea = '*' THEN x-todas-lineas = YES.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = x-linea AND
                            vtatabla.llave_c2 = x-sublinea EXCLUSIVE-LOCK NO-ERROR.
  IF LOCKED vtatabla THEN DO:
      MESSAGE "La tabla esta bloqueada por otro Usuario".
      RETURN "ADM-ERROR".
  END.
  ELSE DO:
      IF NOT AVAILABLE vtatabla THEN DO:
          CREATE vtatabla.
          ASSIGN vtatabla.codcia = s-codcia 
                vtatabla.tabla = x-tabla
                vtatabla.llave_c1 = x-linea
                vtatabla.llave_c2 = x-sublinea
                vtatabla.libre_c01 = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
                vtatabla.libre_c02 = "".
      END.
      ASSIGN vtatabla.llave_c4 = x-signo
            vtatabla.libre_c02 = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").
  END.
      
  RELEASE vtatabla NO-ERROR.

  x-hay-cambios = YES.

END PROCEDURE.

/*
FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                xtt-w-report.campo-c[3] = x-sublinea NO-LOCK NO-ERROR.

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
  
  DEFINE VAR x-linea AS CHAR.
  DEFINE VAR x-sublinea AS CHAR.

  x-linea = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-sublinea = tt-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF x-linea = '*' THEN x-todas-lineas = NO.

  x-hay-cambios = YES.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = x-linea AND
                            vtatabla.llave_c2 = x-sublinea EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
      DELETE vtatabla.
  END.

  RELEASE vtatabla NO-ERROR.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN carga-data.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  {src/adm/template/snd-list.i "tt-w-report"}

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

DEFINE VAR x-linea AS CHAR.
DEFINE VAR x-sublinea AS CHAR.
DEFINE VAR x-signo AS CHAR.
DEFINE VAR x-marca AS CHAR.

x-sublinea = tt-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-linea = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-signo = tt-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

FIND FIRST almtfami WHERE almtfam.codcia = s-codcia AND
                            almtfam.codfam = x-linea NO-LOCK NO-ERROR.
IF x-linea <> '*' AND NOT AVAILABLE almtfami THEN DO:
    MESSAGE "Linea no existe" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
FIND FIRST almsfami WHERE almsfam.codcia = s-codcia AND
                            almsfam.codfam = x-linea AND
                            almsfam.subfam = x-sublinea NO-LOCK NO-ERROR.
IF x-sublinea <> "*" AND NOT AVAILABLE almsfami THEN DO:
    MESSAGE "La Sub-Linea no existe" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
/*
IF x-marca = '*' THEN DO:
    FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                    xtt-w-report.campo-c[5] = x-signo NO-LOCK NO-ERROR.

    IF AVAILABLE xtt-w-report THEN DO:
        MESSAGE "Existe inconsistencia de la linea y sublinea con respecto al signo(2)" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

IF x-marca = '*' THEN DO:
    FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                    xtt-w-report.campo-c[5] = x-signo NO-LOCK NO-ERROR.

    IF AVAILABLE xtt-w-report THEN DO:
        MESSAGE "Existe inconsistencia de la linea y sublinea con respecto al signo(2)" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.
*/

FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                xtt-w-report.campo-c[3] = x-sublinea NO-LOCK NO-ERROR.
IF AVAILABLE xtt-w-report THEN DO:
    MESSAGE "Ya existe la Linea/Sub-Linea" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                xtt-w-report.campo-c[3] = '*' NO-LOCK NO-ERROR.
IF AVAILABLE xtt-w-report THEN DO:
    IF xtt-w-report.campo-c[5] = x-signo THEN DO:
        MESSAGE "Existe inconsistencia de la linea y sublinea con respecto al signo(1)" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

IF x-sublinea = '*' THEN DO:
    FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[1] = x-linea AND
                                    xtt-w-report.campo-c[5] = x-signo NO-LOCK NO-ERROR.

    IF AVAILABLE xtt-w-report THEN DO:
        MESSAGE "Existe inconsistencia de la linea y sublinea con respecto al signo(2)" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.


IF x-linea = '*' THEN DO:
    FIND FIRST xtt-w-report WHERE xtt-w-report.campo-c[5] = "+" NO-LOCK NO-ERROR.

    IF AVAILABLE xtt-w-report THEN DO:
        MESSAGE "Primero debe eliminar los regitros con singo positivos (+)" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
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

MESSAGE "No habilitado!!!" VIEW-AS ALERT-BOX INFORMATION.

RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

