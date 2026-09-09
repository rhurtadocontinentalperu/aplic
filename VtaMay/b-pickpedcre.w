&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE Facdpedi.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/*DEF VAR s-codalm LIKE Faccpedi.codalm NO-UNDO.*/
DEFINE VARIABLE S-TIPVTA    AS CHAR.
DEFINE VARIABLE lDif        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lPrint      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE s-task-no   AS INTEGER .


DEF BUFFER B-CPEDI FOR Faccpedi.

    /* Variable para el Tracking */
    DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
    DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg Almmmate

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.codmat Almmmatg.DesMat ~
Almmmatg.DesMar PEDI.UndVta Almmmate.CodUbi PEDI.CanPed PEDI.CanPick 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.CanPick 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK, ~
      EACH Almmmate WHERE Almmmate.CodCia = PEDI.CodCia ~
  AND Almmmate.codmat = PEDI.codmat ~
      AND Almmmate.CodAlm = s-codalm NO-LOCK ~
    BY Almmmate.CodUbi ~
       BY Almmmate.codmat
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK, ~
      EACH Almmmate WHERE Almmmate.CodCia = PEDI.CodCia ~
  AND Almmmate.codmat = PEDI.codmat ~
      AND Almmmate.CodAlm = s-codalm NO-LOCK ~
    BY Almmmate.CodUbi ~
       BY Almmmate.codmat.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-NroPed br_table BUTTON-13 BUTTON-15 
&Scoped-Define DISPLAYED-OBJECTS x-NroPed 

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
DEFINE BUTTON BUTTON-13 
     LABEL "CIERRA PEDIDO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "NUEVO PEDIDO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "Pedido Mostrador" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg, 
      Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Codigo de!Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(40)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXX":U
      Almmmate.CodUbi FORMAT "x(6)":U
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U COLUMN-FGCOLOR 12 COLUMN-BGCOLOR 15
      PEDI.CanPick FORMAT ">,>>>,>>9.9999":U COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
  ENABLE
      PEDI.CanPick
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 93 BY 13.19
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NroPed AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 2.35 COL 2
     BUTTON-13 AT ROW 1 COL 51 WIDGET-ID 4
     BUTTON-15 AT ROW 1 COL 66 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL Facdpedi
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
         HEIGHT             = 14.92
         WIDTH              = 100.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table x-NroPed F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI,INTEGRAL.Almmmate WHERE Temp-Tables.PEDI ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "INTEGRAL.Almmmate.CodUbi|yes,INTEGRAL.Almmmate.codmat|yes"
     _JoinCode[3]      = "INTEGRAL.Almmmate.CodCia = Temp-Tables.PEDI.CodCia
  AND INTEGRAL.Almmmate.codmat = Temp-Tables.PEDI.codmat"
     _Where[3]         = "INTEGRAL.Almmmate.CodAlm = s-codalm"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Codigo de!Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Almmmate.CodUbi
     _FldNameList[6]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ? "decimal" 15 12 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.CanPick
"PEDI.CanPick" ? ? "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 B-table-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* CIERRA PEDIDO */
DO:

    DEFINE VARIABLE lchoice AS LOGICAL NO-UNDO INIT NO.
    RUN Busca-Diferencias.

    IF lDif THEN DO:
        MESSAGE ' El Pedido presenta diferencias ' SKIP
                ' Se imprimiran las diferencias  ' SKIP
                '        ¿Desea Continuar?       '
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                TITLE '' UPDATE lchoice.
    END.
    ELSE DO:
        RUN Cierra-Picking.
        SESSION:SET-WAIT-STATE('').
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
        ASSIGN
            x-NroPed = ''
            x-NroPed:SENSITIVE = YES.
        RUN Borra-Temporal.
        DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
        RUN dispatch IN THIS-PROCEDURE ('open-query').
    END.

    CASE lchoice:
        WHEN TRUE THEN DO:                    
            IF lDif THEN RUN Imprimir.      
            IF lPrint THEN DO:
                SESSION:SET-WAIT-STATE('GENERAL').
                RUN Cierra-Picking.
                SESSION:SET-WAIT-STATE('').
                IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
                ASSIGN
                    x-NroPed = ''
                    x-NroPed:SENSITIVE = YES
                    lDif     = NO.
                RUN Borra-Temporal.
                DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
                RUN dispatch IN THIS-PROCEDURE ('open-query').
            END.
            ELSE DO:
                MESSAGE 'Debe imprimir listado con diferencias' SKIP
                        '    para poder cerrar el Picking    '
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN NO-APPLY.
            END.
        END.
        WHEN FALSE THEN RETURN NO-APPLY.    
    END CASE.


  /*
  RUN Cierra-Picking.
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  ASSIGN
      x-NroPed = ''
      x-NroPed:SENSITIVE = YES.
  RUN Borra-Temporal.
  DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query').
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 B-table-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* NUEVO PEDIDO */
DO:
    ASSIGN
        x-NroPed = ''
        x-NroPed:SENSITIVE = YES.
    RUN Borra-Temporal.
    DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
    RUN adm-open-query.
    APPLY 'ENTRY':U TO x-NroPed IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroPed B-table-Win
ON LEAVE OF x-NroPed IN FRAME F-Main /* Pedido Mostrador */
OR RETURN OF x-NroPed
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
      /*AND Faccpedi.coddiv = s-coddiv*/
      AND Faccpedi.coddoc = s-coddoc
      AND Faccpedi.nroped = x-NroPed:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Pedido Crédito NO registrado' VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  IF NOT Faccpedi.flgest = 'F' THEN DO:
      MESSAGE 'Pedido Crédito NO se puede hacer picking' SKIP
          'Debe facturar el pedido primero'
          VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  FIND FIRST Facdpedi OF Faccpedi  WHERE Facdpedi.almdes = s-codalm NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi THEN DO:
      MESSAGE 'No hay mercadería en el pedido correspondiente a este almacén'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Facdpedi.FlgEst = 'A' THEN DO:
      MESSAGE 'La factura ha sido anulada' SKIP
          'Solicitar un nuevo pedido'
          VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  IF Facdpedi.Libre_c01 = 'B' THEN DO:
      MESSAGE 'El pedido al crédito YA ha pasado por BARRAS'
          VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  ASSIGN x-NroPed.
  x-NroPed:SENSITIVE = NO.
  RUN Carga-Temporal.
  s-FechaI = DATETIME(TODAY, MTIME).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH PEDI:
      DELETE PEDI.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Diferencias B-table-Win 
PROCEDURE Busca-Diferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR L-Ubica AS LOGICAL INIT YES.    

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.
    
    lDif = NO.
    FOR EACH PEDI NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no
            w-report.Llave-C    = PEDI.codmat
            w-report.Campo-I[1] = PEDI.codcia
            w-report.Campo-C[1] = PEDI.NroPed
            w-report.Campo-C[2] = PEDI.UndVta
            w-report.Campo-F[1] = PEDI.CanPed
            w-report.Campo-F[2] = PEDI.CanPick
            w-report.Campo-F[3] = (PEDI.CanPed - PEDI.CanPick).
        IF (PEDI.CanPed - PEDI.CanPick) <> 0 THEN lDif = YES.
    END.

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
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  S-TIPVTA = Faccpedi.Tipvta.
  FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
            AND Facdpedi.coddoc = s-coddoc
            AND Facdpedi.nroped = x-NroPed
            AND Facdpedi.almdes = s-codalm:
    CREATE PEDI.
    BUFFER-COPY Facdpedi TO PEDI.               
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Picking B-table-Win 
PROCEDURE Cierra-Picking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cFlgEst AS CHAR INIT 'P' NO-UNDO.

  /* verificamos si hay diferencia con el picking */
  REVISA:
  FOR EACH PEDI NO-LOCK, Facdpedi OF PEDI NO-LOCK WHERE Facdpedi.codmat = PEDI.codmat:
      IF Facdpedi.canped <> PEDI.canpick THEN DO:
/*           MESSAGE 'El producto' PEDI.codmat 'no cubre el pedido' SKIP */
/*               'Continuamos con el CIERRE?' SKIP(1)                    */
/*               'En caso de continuar con el cierre debe avisar a' SKIP */
/*               'ventas que anule la factura'                           */
/*               VIEW-AS ALERT-BOX WARNING                               */
/*               BUTTONS YES-NO UPDATE rpta AS LOG.                      */
/*           IF rpta = NO THEN RETURN 'ADM-ERROR'.                       */
/*           cFlgEst = 'S'.    /* suspendo el ciclo */                   */
/*           LEAVE REVISA.                                               */
          MESSAGE 'El producto' PEDI.codmat 'no cubre el pedido' SKIP
              'En caso de continuar con el problema debe avisar a' SKIP
              'ventas que anule la factura'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = s-coddoc
          AND Faccpedi.nroped = x-nroped
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

/*       /* TRACKING */                                               */
/*       s-FechaT = DATETIME(TODAY, MTIME).                           */
/*       RUN gn/pTracking (s-CodCia,                                  */
/*                         Faccpedi.CodDiv,                           */
/*                         s-CodDiv,                                  */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         s-User-Id,                                 */
/*                         'VODM',                                    */
/*                         cFlgEst,                                   */
/*                         'IO',                                      */
/*                         s-FechaI,                                  */
/*                         s-FechaT,                                  */
/*                         'COT',                                     */
/*                         Faccpedi.NroRef).                          */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

      FOR EACH PEDI NO-LOCK:
          FIND Facdpedi OF PEDI WHERE Facdpedi.codmat = PEDI.codmat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Facdpedi THEN NEXT.
          ASSIGN
              Facdpedi.canpick = PEDI.canpick
              Facdpedi.Libre_c01 = 'P'          /* Marca de picking */
              Facdpedi.Libre_c02 = s-user-id
              Facdpedi.Libre_c03 = STRING(TIME, 'HH:MM')
              Facdpedi.Libre_f01 = TODAY.
      END.

      /* actualizamos los comprobantes */
      FOR EACH ccbcdocu USE-INDEX Llave14 WHERE ccbcdocu.codcia = faccpedi.codcia
          AND ccbcdocu.coddiv = faccpedi.coddiv
          AND ccbcdocu.coddoc = Faccpedi.Cmpbnte
          AND ccbcdocu.codped = faccpedi.coddoc
          AND ccbcdocu.nroped = faccpedi.nroped
          AND ccbcdocu.codalm = s-codalm
          AND ccbcdocu.flgest <> 'A':
          ASSIGN
              CcbCDocu.Libre_c01 = 'P'        /* Marca de picking */
              CcbCDocu.Libre_c02 = s-user-id
              CcbCDocu.Libre_c03 = STRING(TIME, 'HH:MM')
              CcbCDocu.Libre_f01 = TODAY.
          /* TRACKING */
          s-FechaT = DATETIME(TODAY, MTIME).
          RUN gn/pTracking-01 (s-CodCia,
                            s-CodDiv,
                            Ccbcdocu.CodPed,
                            Ccbcdocu.NroPed,
                            s-User-Id,
                            'VODM',
                            'P',
                            s-FechaI,
                            s-FechaT,
                            Ccbcdocu.CodDoc,
                            Ccbcdocu.NroDoc,
                            Ccbcdocu.CodDoc,
                            Ccbcdocu.NroDoc).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  RELEASE Ccbcdocu.
  RELEASE Faccpedi.
  RELEASE Facdpedi.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales B-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
  Faccpedi.ImpDto = 0.
  Faccpedi.ImpIgv = 0.
  Faccpedi.ImpIsc = 0.
  Faccpedi.ImpTot = 0.
  Faccpedi.ImpExo = 0.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK: 
       F-Igv = F-Igv + Facdpedi.ImpIgv.
       F-Isc = F-Isc + Facdpedi.ImpIsc.
       Faccpedi.ImpTot = Faccpedi.ImpTot + Facdpedi.ImpLin.
       IF NOT Facdpedi.AftIgv THEN Faccpedi.ImpExo = Faccpedi.ImpExo + Facdpedi.ImpLin.
       IF Facdpedi.AftIgv = YES
       THEN Faccpedi.ImpDto = Faccpedi.ImpDto + ROUND(Facdpedi.ImpDto / (1 + Faccpedi.PorIgv / 100), 2).
       ELSE Faccpedi.ImpDto = Faccpedi.ImpDto + Facdpedi.ImpDto.
  END.
  Faccpedi.ImpIgv = ROUND(F-IGV,2).
  Faccpedi.ImpIsc = ROUND(F-ISC,2).
  Faccpedi.ImpVta = Faccpedi.ImpTot - Faccpedi.ImpExo - Faccpedi.ImpIgv.
  /* RHC 22.12.06 */
  IF Faccpedi.PorDto > 0 THEN DO:
    Faccpedi.ImpDto = Faccpedi.ImpDto + ROUND((Faccpedi.ImpVta + Faccpedi.ImpExo) * Faccpedi.PorDto / 100, 2).
    Faccpedi.ImpTot = ROUND(Faccpedi.ImpTot * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpVta = ROUND(Faccpedi.ImpVta * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpExo = ROUND(Faccpedi.ImpExo * (1 - Faccpedi.PorDto / 100),2).
    Faccpedi.ImpIgv = Faccpedi.ImpTot - Faccpedi.ImpExo - Faccpedi.ImpVta.
  END.  
  Faccpedi.ImpBrt = Faccpedi.ImpVta + Faccpedi.ImpIsc + Faccpedi.ImpDto + Faccpedi.ImpExo.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  RUN Vta\R-imppickdifod (s-task-no, OUTPUT lPrint).
  
  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
  s-task-no = 0.

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
  {src/adm/template/snd-list.i "PEDI"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}

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

  IF DECIMAL(PEDI.CanPick:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > PEDI.CanPed THEN DO:
      MESSAGE 'Cantidad errada' VIEW-AS ALERT-BOX ERROR.
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

