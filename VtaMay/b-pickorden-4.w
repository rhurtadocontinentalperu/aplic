&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.



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
DEF SHARED VAR s-coddoc AS CHAR.

DEF VAR S-TIPVTA   AS CHAR.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-CCOTI FOR Faccpedi.

DEFINE BUFFER B-DPedi FOR FacDPedi.

DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE lDif   AS LOGICAL NO-UNDO.
DEFINE VARIABLE lPrint AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-task-no AS INTEGER .

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
Almmmatg.DesMar PEDI.UndVta PEDI.AlmDes Almmmate.CodUbi PEDI.CanPed ~
PEDI.CanPick 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.CanPick 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK, ~
      EACH Almmmate WHERE Almmmate.CodCia = PEDI.CodCia ~
  AND Almmmate.codmat = PEDI.codmat ~
  AND Almmmate.CodAlm = PEDI.AlmDes NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK, ~
      EACH Almmmate WHERE Almmmate.CodCia = PEDI.CodCia ~
  AND Almmmate.codmat = PEDI.codmat ~
  AND Almmmate.CodAlm = PEDI.AlmDes NO-LOCK.
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
     LABEL "CIERRA ORDEN" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "NUEVA ORDEN" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "Orden de Despacho" 
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
            WIDTH 8.43
      Almmmatg.DesMat FORMAT "X(40)":U WIDTH 28.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXX":U
      PEDI.AlmDes FORMAT "x(3)":U
      Almmmate.CodUbi FORMAT "x(6)":U WIDTH 7.29
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U WIDTH 10.57 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      PEDI.CanPick FORMAT ">,>>>,>>9.9999":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
  ENABLE
      PEDI.CanPick
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 101 BY 13.19
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
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         WIDTH              = 109.14.
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
     _JoinCode[3]      = "INTEGRAL.Almmmate.CodCia = Temp-Tables.PEDI.CodCia
  AND INTEGRAL.Almmmate.codmat = Temp-Tables.PEDI.codmat
  AND INTEGRAL.Almmmate.CodAlm = Temp-Tables.PEDI.AlmDes"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Codigo de!Articulo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.PEDI.AlmDes
     _FldNameList[6]   > INTEGRAL.Almmmate.CodUbi
"Almmmate.CodUbi" ? ? "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ? "decimal" 11 9 ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI.CanPick
"PEDI.CanPick" ? ? "decimal" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* CIERRA ORDEN */
DO:
  DEFINE VARIABLE lchoice AS LOGICAL NO-UNDO.

  RUN Busca-Diferencias.

  IF lDif THEN DO:
      MESSAGE 'Está seguro de cerrar la Orden de Despacho?' SKIP
              ' La Orden de despacho presenta diferencias ' SKIP
              '      Se imprimiran las diferencias        ' SKIP
              '           ¿Desea Continuar?               '
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          TITLE '' UPDATE lchoice.
  END.
  ELSE DO:
      MESSAGE 'Está seguro de cerrar la Orden de Despacho?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          TITLE '' UPDATE lchoice.
  END.
  CASE lchoice:
    WHEN TRUE THEN DO:                
        IF lDif THEN DO: 
            RUN Imprimir.
            IF lPrint THEN DO:
                SESSION:SET-WAIT-STATE('GENERAL').
                RUN Paso-Previo.
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
        ELSE DO:            
            SESSION:SET-WAIT-STATE('GENERAL').
            RUN Paso-Previo.
            SESSION:SET-WAIT-STATE('').
            IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
            ASSIGN
                x-NroPed = ''
                x-NroPed:SENSITIVE = YES.
            RUN Borra-Temporal.
            DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
            RUN dispatch IN THIS-PROCEDURE ('open-query').
        END.
    END.
    WHEN FALSE THEN RETURN NO-APPLY.    
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 B-table-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* NUEVA ORDEN */
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
ON LEAVE OF x-NroPed IN FRAME F-Main /* Orden de Despacho */
OR RETURN OF x-NroPed
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /* NOTA: la Orden de Despacho debe despachar de almacenes pertenecientes a esta división */
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
      AND Faccpedi.coddoc = s-coddoc
      AND Faccpedi.nroped = x-NroPed:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Orden de Despacho NO registrada' VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  IF NOT (Faccpedi.flgest = 'P' AND Faccpedi.flgsit = '') THEN DO:
      MESSAGE 'Orden de Despacho NO se puede hacer picking' VIEW-AS ALERT-BOX ERROR.
      DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  IF Faccpedi.DivDes <> s-CodDiv THEN DO:
      MESSAGE "NO tiene almacenes de despacho pertenecientes a esta división"
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  /*
  FIND FIRST Vtatrack04 WHERE Vtatrack04.codcia = s-codcia
      AND VtaTrack04.CodAlm = s-codalm
      AND VtaTrack04.CodDoc = s-coddoc
      AND VtaTrack04.CodUbic = 'SMA'
      AND VtaTrack04.Libre_c01 <> 'C'
      AND VtaTrack04.NroPed = x-NroPed:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTrack04 THEN DO:
      MESSAGE 'Aún no se ha cerrado el sacador' VtaTrack04.codper SKIP
          'del almacén' s-codalm 'del día' DATE(VtaTrack04.FechaI)
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  */
  ASSIGN x-NroPed.
  x-NroPed:SENSITIVE = NO.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF  PEDI.CanPick
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido B-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE 
           B-CPedi.CodCia = Faccpedi.codcia AND
           B-CPedi.CodDiv = Faccpedi.coddiv AND
           B-CPedi.CodDoc = "PED"    AND
           B-CPedi.NroPed = FacCPedi.NroRef
           EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPedi THEN UNDO, RETURN 'ADM-ERROR'.
      FIND B-CCOTI WHERE B-CCOTI.codcia = B-CPEDI.codcia
          AND B-CCOTI.coddoc = 'COT'
          AND B-CCOTI.nroped = B-CPEDI.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CCOTI THEN RETURN 'ADM-ERROR'.
      FOR EACH facdPedi OF faccPedi NO-LOCK:
          /* actualizamos el pedido */
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = B-CPEDI.CodCia AND
               B-DPedi.CodDoc = B-CPEDI.CodDoc AND
               B-DPedi.NroPed = B-CPEDI.NroPed AND
               B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
             B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed * X-Tipo)
             B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
          RELEASE B-DPedi.
          /* actualizamos la cotizacion */
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = B-CCOTI.CodCia AND
               B-DPedi.CodDoc = B-CCOTI.CodDoc AND
               B-DPedi.NroPed = B-CCOTI.NroPed AND
               B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
             B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed * X-Tipo)
             B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
          RELEASE B-DPedi.
      END.
      /* estado del pedido */
/*       I-NRO = 0.                                              */
/*       FOR EACH B-DPedi OF B-CPEDI NO-LOCK:                    */
/*           IF (B-DPedi.CanPed - B-DPedi.CanAte) > 0 THEN DO:   */
/*              I-NRO = 1.                                       */
/*              LEAVE.                                           */
/*           END.                                                */
/*       END.                                                    */
/*       ASSIGN B-CPedi.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P". */
     /* estado de la cotizacion */
     I-NRO = 0.
     FOR EACH B-DPedi OF B-CCOTI NO-LOCK:
         IF (B-DPedi.CanPed - B-DPedi.CanAte) > 0 THEN DO:
            I-NRO = 1.
            LEAVE.
         END.
     END.
     ASSIGN B-CCOTI.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P".

     RELEASE B-CPEDI.
     RELEASE B-CCOTI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Orden B-table-Win 
PROCEDURE Carga-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  DEFINE VARIABLE x-Item AS INT NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE 
           B-CPedi.CodCia = Faccpedi.codcia AND
           B-CPedi.CodDoc = "PED"    AND
           B-CPedi.NroPed = FacCPedi.NroRef
           EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPedi THEN UNDO, RETURN 'ADM-ERROR'.
      FIND B-CCOTI WHERE B-CCOTI.codcia = B-CPEDI.codcia
          AND B-CCOTI.coddoc = 'COT'
          AND B-CCOTI.nroped = B-CPEDI.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CCOTI THEN RETURN 'ADM-ERROR'.
      /* Volvemos a crear la Orden de Despacho */
      FOR EACH PEDI NO-LOCK WHERE PEDI.CanPick > 0, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm:
          CREATE Facdpedi.
          BUFFER-COPY PEDI TO Facdpedi.
          IF Facdpedi.CanPed <> Facdpedi.CanPick THEN DO:
              ASSIGN
                Facdpedi.canped = PEDI.canpick.     /* OJO: Con lo pickeado */
              ASSIGN 
                  Facdpedi.ImpDto = ROUND( Facdpedi.PreUni * Facdpedi.CanPed * (Facdpedi.Por_Dsctos[1] / 100),4 )
                  Facdpedi.ImpLin = ROUND( Facdpedi.PreUni * Facdpedi.CanPed , 2 ) - Facdpedi.ImpDto.
              IF Facdpedi.AftIsc THEN ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
              IF Facdpedi.AftIgv THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (Faccpedi.PorIgv / 100)),4).
          END.
      END.
      x-Item = 1.
      FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
          ASSIGN 
              Facdpedi.NroItm = x-Item
              x-Item = x-Item + 1.
      END.
      /* Calculamos el total de la Orden de Despacho */
      RUN Graba-Totales-Lima.

      /* Actualizamos la Cotizacion */
      FOR EACH facdPedi OF faccPedi NO-LOCK:
          FIND B-DPedi WHERE B-DPedi.CodCia = B-CCOTI.CodCia 
              AND B-DPedi.CodDoc = B-CCOTI.CodDoc 
              AND B-DPedi.NroPed = B-CCOTI.NroPed 
              AND B-DPedi.CodMat = FacDPedi.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
             B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed
             B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
      END.
     /* Actualizamos el estado de la Cotizacion */
     I-NRO = 0.
     FOR EACH B-DPedi OF B-CCOTI NO-LOCK:
         IF (B-DPedi.CanPed - B-DPedi.CanAte) > 0 THEN DO:
            I-NRO = 1.
            LEAVE.
         END.
     END.
     ASSIGN B-CCOTI.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P".

     RELEASE B-CPEDI.
     RELEASE B-CCOTI.
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
/*   s-codalm = Faccpedi.codalm. */
  S-TIPVTA = FacCPedi.Tipvta.
  FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
            AND Facdpedi.coddoc = s-coddoc
            AND Facdpedi.nroped = x-NroPed:
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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':  
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = x-nroped
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN "ADM-ERROR".
    ASSIGN
        Faccpedi.flgsit = 'P'.    /* PICKEADO */
    /* REVISAR TAMBIEN LA GENERACION DE LA ORDEN DE DESPACHO */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi AND gn-divi.FlgBarras = NO THEN Faccpedi.flgsit = "C".

    /* 1ra. PARTE: Extornamos la ORDEN DE DESPACHO ORIGINAL */
    RUN Descarga-Orden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* 2da. PARTE: Generamos la NUEVA ORDEN DE DESPACHO CORREGIDA CON EL PICKING */
    RUN Carga-Orden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* 4ta. PARTE: TRACKING */
    /* OJO >>> Primero el tracking porque el paso 5 cambia el puntero de la tabla FACCPEDI */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'VODM',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed).
    
    /* 5ta. PARTE: Regeneramos el Pedido */
    RUN Regenera-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RELEASE Faccpedi.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Picking-2 B-table-Win 
PROCEDURE Cierra-Picking-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

tmploop:        
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':  
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = x-nroped
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN "ADM-ERROR".

    IF LDif = NO THEN DO:
        ASSIGN
            Faccpedi.flgsit = 'P'.    /* PICKEADO */
        /* REVISAR TAMBIEN LA GENERACION DE LA ORDEN DE DESPACHO */
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = s-coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi AND gn-divi.FlgBarras = NO THEN Faccpedi.flgsit = "C".
        /* TRACKING */
        RUN vtagn/pTracking-04 (s-CodCia,
                                s-CodDiv,
                                Faccpedi.CodRef,
                                Faccpedi.NroRef,
                                s-User-Id,
                                'VODM',
                                'P',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                Faccpedi.CodDoc,
                                Faccpedi.NroPed,
                                Faccpedi.CodDoc,
                                Faccpedi.NroPed).

    END.
    IF LDif = YES THEN DO:
        ASSIGN
            Faccpedi.flgest = 'S'.    /* SUSPENDIDO */
        FOR EACH PEDI:
            /* la orden de despacho */
            FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN UNDO tmploop, RETURN "ADM-ERROR".
            ASSIGN
                Facdpedi.CanPick = PEDI.CanPick.
            /* el pedido mostrador */
            FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
                AND Facdpedi.coddoc = Faccpedi.codref
                AND Facdpedi.nroped = Faccpedi.nroref
                AND Facdpedi.codmat = PEDI.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN UNDO tmploop, RETURN "ADM-ERROR".
            ASSIGN
                Facdpedi.CanPick = PEDI.CanPick.
        END.
        /* TRACKING */
        RUN vtagn/pTracking-04 (s-CodCia,
                                s-CodDiv,
                                Faccpedi.CodRef,
                                Faccpedi.NroRef,
                                s-User-Id,
                                'GOD',
                                'S',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                Faccpedi.CodDoc,
                                Faccpedi.NroPed,
                                Faccpedi.CodDoc,
                                Faccpedi.NroPed).
        MESSAGE 'Comunique al vendedor que el pedido' Faccpedi.codref Faccpedi.nroref SKIP
            'NO puede ser atentido en su totalidad' SKIP
            'Hay que anular las facturas y hacer un nuevo pedido'
            VIEW-AS ALERT-BOX WARNING.
    END.
    RELEASE Faccpedi.
    RELEASE Facdpedi.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descarga-Orden B-table-Win 
PROCEDURE Descarga-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE B-CPedi.CodCia = Faccpedi.codcia 
          AND B-CPedi.CodDoc = "PED"    
          AND B-CPedi.NroPed = FacCPedi.NroRef
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPedi THEN UNDO, RETURN 'ADM-ERROR'.
      FIND B-CCOTI WHERE B-CCOTI.codcia = B-CPEDI.codcia
          AND B-CCOTI.coddoc = 'COT'
          AND B-CCOTI.nroped = B-CPEDI.nroref
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CCOTI THEN UNDO, RETURN 'ADM-ERROR'.

      FOR EACH Facdpedi OF Faccpedi:
          /* Extornamos el PEDIDO */
          FIND B-DPEDI WHERE B-DPEDI.codcia = B-CPEDI.codcia
              AND B-DPEDI.coddoc = B-CPEDI.coddoc
              AND B-DPEDI.nroped = B-CPEDI.nroped
              AND B-DPEDI.codmat = Facdpedi.codmat
              AND B-DPEDI.almdes = Facdpedi.almdes
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN "ADM-ERROR".
          DELETE B-DPEDI.
          /* Extornamos la COTIZACION */
          FIND B-DPEDI WHERE B-DPEDI.codcia = B-CCOTI.codcia
              AND B-DPEDI.coddoc = B-CCOTI.coddoc
              AND B-DPEDI.nroped = B-CCOTI.nroped
              AND B-DPEDI.codmat = Facdpedi.codmat
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN "ADM-ERROR".
          ASSIGN
              B-DPEDI.canate = B-DPEDI.canate - Facdpedi.canped
              B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".
          /* BORRAMOS DETALLE ORDEN DE DESPACHO */
          DELETE Facdpedi.
      END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-Ate B-table-Win 
PROCEDURE Graba-Totales-Ate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales.i}

/*
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
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-Expo B-table-Win 
PROCEDURE Graba-Totales-Expo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{vtaexp/graba-totales.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-Lima B-table-Win 
PROCEDURE Graba-Totales-Lima :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{vtamay/graba-totales.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-Previo B-table-Win 
PROCEDURE Paso-Previo :
/*------------------------------------------------------------------------------
  Purpose:     de acuerdo al origen de la orden de despacho se va a tomar una accion
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = s-coddoc
    AND Faccpedi.nroped = x-nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
CASE Faccpedi.CodRef:
    WHEN "PED" THEN DO:
        RUN Cierra-Picking.     /* VENTAS AL CREDITO */
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".
    END.
    WHEN "P/M" THEN DO:
        RUN Cierra-Picking-2.   /* VENTAS MOSTRADOR */
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".
    END.
END CASE.



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Regenera-Pedido B-table-Win 
PROCEDURE Regenera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Item AS INT INIT 1 NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE 
           B-CPedi.CodCia = Faccpedi.codcia AND
           B-CPedi.CodDoc = "PED"    AND
           B-CPedi.NroPed = FacCPedi.NroRef
           EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPedi THEN UNDO, RETURN 'ADM-ERROR'.
      /* Regeneramos detalle del Pedido */
      FOR EACH Facdpedi OF Faccpedi NO-LOCK BY Facdpedi.NroItm:
          CREATE B-DPEDI.
          BUFFER-COPY Facdpedi TO B-DPEDI
              ASSIGN
                B-DPEDI.CodDoc = B-CPEDI.CodDoc
                B-DPEDI.NroPed = B-CPEDI.NroPed
                B-DPEDI.CodDiv = B-CPEDI.CodDiv
                B-DPEDI.CanAte = B-DPEDI.CanPed
                B-DPEDI.FlgEst = 'C'
                B-DPEDI.NroItm = x-Item.
          x-Item = x-Item + 1.
      END.
      /* Actualizamos el total del Pedido */
      /* OJO >>> Cambiamos la posición del puntero de la tabla FACCPEDI */
      FIND Faccpedi WHERE ROWID(Faccpedi) = ROWID(B-CPEDI) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN "ADM-ERROR".
      RUN Graba-Totales-Lima.
  END.

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

