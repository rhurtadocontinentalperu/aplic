&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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

/*DEF VAR s-codalm LIKE FAccpedi.codalm NO-UNDO.*/
DEF VAR S-TIPVTA   AS CHAR.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-CCOTI FOR Faccpedi.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

DEFINE BUFFER B-DPedi FOR FacDPedi.

DEFINE SHARED VAR s-user-id AS CHAR.

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
      Almmmatg.DesMat FORMAT "X(40)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXX":U
      Almmmate.CodUbi FORMAT "x(6)":U
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      PEDI.CanPick FORMAT ">,>>>,>>9.9999":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
"PEDI.CanPed" ? ? "decimal" 11 9 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.CanPick
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
  MESSAGE 'Está completamente seguro de cerrar la Orden de Despacho?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Cierra-Picking.
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  ASSIGN
      x-NroPed = ''
      x-NroPed:SENSITIVE = YES.
  RUN Borra-Temporal.
  DISPLAY x-NroPed WITH FRAME {&FRAME-NAME}.
  RUN adm-open-query.
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
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
      /*AND Faccpedi.coddiv = s-coddiv*/
      AND Faccpedi.codalm = s-codalm
      AND Faccpedi.coddoc = 'O/D'
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
  ASSIGN x-NroPed.
  x-NroPed:SENSITIVE = NO.
  s-FechaI = DATETIME(TODAY, MTIME).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Pedido B-table-Win 
PROCEDURE Carga-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

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
      /* Volvemos a crear el pedido y la orden de despacho */
      FOR EACH PEDI NO-LOCK WHERE PEDI.CanPick > 0, FIRST Almmmatg OF PEDI NO-LOCK:
          /* creamos detalle de la cotizacion */
          CREATE Facdpedi.
          BUFFER-COPY PEDI TO Facdpedi
              ASSIGN
                Facdpedi.canped = PEDI.canpick.
          ASSIGN 
              Facdpedi.ImpDto = ROUND( Facdpedi.PreUni * facdpedi.CanPed * (Facdpedi.Por_Dsctos[1] / 100),4 )
              Facdpedi.ImpLin = ROUND( Facdpedi.PreUni * Facdpedi.CanPed , 2 ) - Facdpedi.ImpDto.
          ASSIGN
              Facdpedi.ImpIsc = 0
              Facdpedi.Impigv = 0.
            IF Facdpedi.AftIsc THEN 
               Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            IF Facdpedi.AftIgv THEN  
               Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (FacCPedi.PorIgv / 100)),4).
            /* creamos detalle del pedido */
            CREATE B-DPEDI.
            BUFFER-COPY Facdpedi TO B-DPEDI
                ASSIGN
                    B-DPEDI.CodDoc = B-CPEDI.CodDoc
                    B-DPEDI.NroPed = B-CPEDI.NroPed
                    B-DPEDI.CodDiv = B-CPEDI.CodDiv
                    B-DPEDI.CanAte = B-DPEDI.CanPed
                    B-DPEDI.FlgEst = 'C'.
      END.
      /* Calculamos el total de la orden de despacho */
      RUN Graba-Totales.
      ASSIGN
          B-CPEDI.ImpBrt = Faccpedi.ImpBrt
          B-CPEDI.ImpExo = Faccpedi.ImpExo
          B-CPEDI.ImpVta = Faccpedi.ImpVta
          B-CPEDI.ImpDto = Faccpedi.ImpDto
          B-CPEDI.ImpTot = Faccpedi.ImpTot.

      FOR EACH facdPedi OF faccPedi NO-LOCK:
          /* actualizamos la cotizacion */
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = B-CCOTI.CodCia AND
               B-DPedi.CodDoc = B-CCOTI.CodDoc AND
               B-DPedi.NroPed = B-CCOTI.NroPed AND
               B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
             B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed
             B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
          RELEASE B-DPEDI.
      END.
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
            AND Facdpedi.coddoc = 'O/D'
            AND Facdpedi.nroped = x-NroPed:
    CREATE PEDI.
    BUFFER-COPY Facdpedi TO PEDI.               
  END.
  RUN adm-open-query.

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
          AND Faccpedi.coddoc = 'O/D'
          AND Faccpedi.nroped = x-nroped
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

      /* 1ra. PARTE: Extornamos la ORDEN DE DESPACHO ORIGINAL */
      RUN Descarga-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* 2da. PARTE: Generamos la NUEVA ORDEN DE DESPACHO CORREGIDA CON EL PICKING */
      RUN Carga-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN
          Faccpedi.flgsit = 'P'.    /* PICKEADO */

      /* TRACKING */
      s-FechaT = DATETIME(TODAY, MTIME).
      FIND Almacen OF Faccpedi NO-LOCK.
      RUN gn/pTracking (s-CodCia,
                        s-CodDiv,
                        Almacen.CodDiv,
                        'PED',
                        Faccpedi.NroRef,
                        s-User-Id,
                        'VODM',
                        'P',
                        'IO',
                        s-FechaI,
                        s-FechaT,
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RELEASE Faccpedi.
  END.

END PROCEDURE.

/*
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = 'O/D'
          AND Faccpedi.nroped = x-nroped
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

      /* 1ra. PARTE: Extornamos la ORDEN DE DESPACHO ORIGINAL */
      RUN Actualiza-Pedido (-1).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* eliminamos el detalle */
      FOR EACH Facdpedi OF Faccpedi:
          DELETE Facdpedi.
      END.
      /* 2da. PARTE: Generamos la NUEVA ORDEN DE DESPACHO CORREGIDA CON EL PICKING */
      FOR EACH PEDI NO-LOCK WHERE PEDI.CanPick > 0, FIRST Almmmatg OF PEDI NO-LOCK:
          CREATE Facdpedi.
          BUFFER-COPY PEDI TO Facdpedi
              ASSIGN
                Facdpedi.canped = PEDI.canpick.
          ASSIGN 
              Facdpedi.Implin = ROUND(Facdpedi.PreUni * Facdpedi.CanPed, 2)
              Facdpedi.ImpDto = ROUND( Facdpedi.PreBas * (Facdpedi.PorDto / 100) * Facdpedi.CanPed , 2 )
              /* RHC 22.06.06 */
              Facdpedi.ImpDto = Facdpedi.ImpDto + ROUND( Facdpedi.PreBas * Facdpedi.CanPed * (1 - Facdpedi.PorDto / 100) * (Facdpedi.Por_Dsctos[1] / 100),4 )
              /* ************ */
              Facdpedi.ImpIsc = 0
              Facdpedi.Impigv = 0.
            IF Facdpedi.AftIsc THEN 
               Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            IF Facdpedi.AftIgv AND S-Tipvta = 'CON IGV' THEN  
               Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (FacCPedi.PorIgv / 100)),4).
      END.
      ASSIGN
          Faccpedi.flgsit = 'P'.    /* PICKEADO */
      RUN Graba-Totales.
      RUN Actualiza-Pedido (1).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* TRACKING */
      s-FechaT = DATETIME(TODAY, MTIME).
      RUN vta/pFlujoPedido (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            'VODM',
                            s-User-Id,
                            'PED',
                            Faccpedi.NroRef,
                            'P',
                            'IO',
                            s-FechaI,
                            s-FechaT).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RELEASE Faccpedi.
  END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descarga-Pedido B-table-Win 
PROCEDURE Descarga-Pedido :
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
      IF NOT AVAILABLE B-CPedi THEN RETURN 'ADM-ERROR'.
      FIND B-CCOTI WHERE B-CCOTI.codcia = B-CPEDI.codcia
          AND B-CCOTI.coddoc = 'COT'
          AND B-CCOTI.nroped = B-CPEDI.nroref
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CCOTI THEN RETURN 'ADM-ERROR'.
      /* Extornamos la cotizacion en base al pedido */
      FOR EACH FacdPedi OF B-CPEDI:
          FIND B-DPedi WHERE 
               B-DPedi.CodCia = B-CCOTI.CodCia AND
               B-DPedi.CodDoc = B-CCOTI.CodDoc AND
               B-DPedi.NroPed = B-CCOTI.NroPed AND
               B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN
             B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed
             B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P".               
          RELEASE B-DPedi.
      END.
      /* Borramos el pedido y la orden de despacho */
      FOR EACH FacdPedi OF B-CPEDI:
          DELETE Facdpedi.
      END.
      FOR EACH FacdPedi OF Faccpedi:
          DELETE Facdpedi.
      END.
/*       /* Extornamos el pedido y borramos la orden de despacho */                           */
/*       FOR EACH FacdPedi OF Faccpedi:                                                       */
/*           FIND B-DPedi WHERE                                                               */
/*                B-DPedi.CodCia = B-CPEDI.CodCia AND                                         */
/*                B-DPedi.CodDoc = B-CPEDI.CodDoc AND                                         */
/*                B-DPedi.NroPed = B-CPEDI.NroPed AND                                         */
/*                B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.                   */
/*           IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.                          */
/*           ASSIGN                                                                           */
/*              B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed                             */
/*              B-DPEDI.FlgEst = IF (B-DPedi.CanPed - B-DPedi.CanAte) <= 0 THEN "C" ELSE "P". */
/*           RELEASE B-DPedi.                                                                 */
/*           DELETE Facdpedi.                                                                 */
/*       END.                                                                                 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales B-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vtaexp/graba-totales.i}

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

