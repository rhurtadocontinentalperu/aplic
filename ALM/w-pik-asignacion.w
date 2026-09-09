&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE VtaCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( T-CDOCU.CodCia = s-codcia ~
AND T-CDOCU.CodPed = x-CodPed ~
AND ( TRUE <> (x-CodDiv > '') OR T-CDOCU.CodDiv = x-CodDiv ) )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CDOCU

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 T-CDOCU.Libre_d01 T-CDOCU.CodPed ~
T-CDOCU.NroPed T-CDOCU.FchEnt T-CDOCU.NomCli T-CDOCU.Items T-CDOCU.Peso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH T-CDOCU ~
      WHERE {&Condicion} NO-LOCK ~
    BY T-CDOCU.Libre_d01 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH T-CDOCU ~
      WHERE {&Condicion} NO-LOCK ~
    BY T-CDOCU.Libre_d01 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 T-CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 T-CDOCU


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Actualizar BUTTON-Asignar ~
SELECT-CodDoc BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS SELECT-CodDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Actualizar 
     LABEL "ACTUALIZAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Asignar 
     LABEL "ASIGNAR PEDIDO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE SELECT-CodDoc AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "Todos","Todos" 
     SIZE 48 BY 23.96
     BGCOLOR 14 FGCOLOR 0 FONT 10 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      T-CDOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      T-CDOCU.Libre_d01 COLUMN-LABEL "N°" FORMAT ">>9":U
      T-CDOCU.CodPed COLUMN-LABEL "Cod." FORMAT "x(3)":U WIDTH 4.29
      T-CDOCU.NroPed COLUMN-LABEL "N° Suborden" FORMAT "X(12)":U
            WIDTH 10.43
      T-CDOCU.FchEnt FORMAT "99/99/99":U WIDTH 11.29
      T-CDOCU.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U WIDTH 49.43
      T-CDOCU.Items FORMAT ">>>,>>9":U WIDTH 3.43
      T-CDOCU.Peso COLUMN-LABEL "Peso!Kg." FORMAT "->>>,>>9.99":U
            WIDTH 4.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 93 BY 23.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Actualizar AT ROW 1 COL 2 WIDGET-ID 6
     BUTTON-Asignar AT ROW 1 COL 18 WIDGET-ID 10
     SELECT-CodDoc AT ROW 2.35 COL 2 NO-LABEL WIDGET-ID 8
     BROWSE-5 AT ROW 2.35 COL 51 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DE PEDIDOS"
         HEIGHT             = 25.85
         WIDTH              = 144.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 SELECT-CodDoc F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.T-CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.T-CDOCU.Libre_d01|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > Temp-Tables.T-CDOCU.Libre_d01
"Libre_d01" "N°" ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CDOCU.CodPed
"CodPed" "Cod." ? "character" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CDOCU.NroPed
"NroPed" "N° Suborden" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CDOCU.FchEnt
"FchEnt" ? ? "date" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDOCU.NomCli
"NomCli" "Cliente" "x(50)" "character" ? ? ? ? ? ? no ? no no "49.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDOCU.Items
"Items" ? ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CDOCU.Peso
"Peso" "Peso!Kg." ? "decimal" ? ? ? ? ? ? no ? no no "4.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 1
       COLUMN          = 69
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 12
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BUTTON-Asignar:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE PEDIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Actualizar W-Win
ON CHOOSE OF BUTTON-Actualizar IN FRAME F-Main /* ACTUALIZAR */
DO:
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Asignar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Asignar W-Win
ON CHOOSE OF BUTTON-Asignar IN FRAME F-Main /* ASIGNAR PEDIDO */
DO:
   /* Determinamos los sectores seleccionados */
   DEF VAR cSectores AS CHAR NO-UNDO.
   DEF VAR k AS INT NO-UNDO.
   DEF VAR pPicador AS CHAR NO-UNDO.
   DEF VAR pPedidos AS CHAR NO-UNDO.
   DEF VAR pPrioridad AS CHAR NO-UNDO.

   DEF VAR pOk AS LOG NO-UNDO.

   DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
       IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
           pPedidos = pPedidos + (IF TRUE <> (pPedidos > '') THEN '' ELSE ',') +
                        T-CDOCU.CodPed + '|' + T-CDOCU.NroPed.
           IF INDEX(cSectores, ENTRY(2,T-CDOCU.NroPed,'-')) = 0 THEN DO:
               cSectores = cSectores + (IF TRUE <> (cSectores > '') THEN '' ELSE ',') +
                            ENTRY(2,T-CDOCU.NroPed,'-').
           END.
       END.
   END.
   IF TRUE <> (cSectores > '') THEN RETURN NO-APPLY.
   RUN alm/d-pik-asigna-personal (cSectores, OUTPUT pPicador, OUTPUT pPrioridad, OUTPUT pOk).
   IF pOk = NO THEN RETURN NO-APPLY.
   RUN alm/p-pik-asigna-tarea (s-CodDiv,
                               pPicador,
                               pPedidos,
                               pPrioridad).
   APPLY 'CHOOSE':U TO BUTTON-Actualizar.
   APPLY 'VALUE-CHANGED':U TO SELECT-CodDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'CHOOSE':U TO BUTTON-Actualizar IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CodDoc W-Win
ON VALUE-CHANGED OF SELECT-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  ASSIGN
      x-CodPed = ''
      x-CodDiv = ''.
  x-CodPed = ENTRY(1, SELECT-CodDoc, '|').
  IF NUM-ENTRIES(SELECT-CodDoc, '|') > 1 THEN x-CodDiv = ENTRY(2, SELECT-CodDoc, '|').
  /*MESSAGE SELF:SCREEN-VALUE SKIP x-codped x-coddiv.*/
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Tarea W-Win 
PROCEDURE Asigna-Tarea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pPicador AS CHAR.
  DEF INPUT PARAMETER pPedidos AS CHAR.
  DEF INPUT PARAMETER pPrioridad AS CHAR.

  DEF VAR pCodPed AS CHAR NO-UNDO.
  DEF VAR pNroPed AS CHAR NO-UNDO.
  DEF VAR LocalItem AS INT NO-UNDO.
  DEF VAR x-ordenes-ori AS CHAR NO-UNDO.
  DEF VAR x-codori AS CHAR NO-UNDO.
  DEF VAR x-nroori AS CHAR NO-UNDO.
  DEF VAR x-sec AS INT NO-UNDO.
  DEF BUFFER x-vtacdocu FOR Vtacdocu.
  DEF VAR lItems AS INT NO-UNDO.
  DEF VAR lImporte AS DEC NO-UNDO.
  DEF VAR lPeso AS DEC NO-UNDO.
  DEF VAR lVolumen AS DEC NO-UNDO.

  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i 
          &Tabla="PikSacadores"
          &Alcance="FIRST"
          &Condicion="PikSacadores.CodCia = s-codcia
          AND PikSacadores.CodDiv = s-coddiv
          AND PikSacadores.CodPer = pPicador
          AND pikSacadores.FlgEst = 'A'"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
          &Accion="RETRY"
          &Mensaje="YES"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      DO LocalItem = 1 TO NUM-ENTRIES(pPedidos) 
          ON ERROR UNDO CICLO, RETURN 'ADM-ERROR' ON STOP UNDO CICLO, RETURN 'ADM-ERROR':
          pCodPed = ENTRY(1,ENTRY(LocalItem,pPedidos),'|').
          pNroPed = ENTRY(2,ENTRY(LocalItem,pPedidos),'|').
          FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE Vtacdocu.codcia = s-codcia
              AND Vtacdocu.divdes = s-CodDiv
              AND Vtacdocu.codped = pCodPed
              AND Vtacdocu.nroped = pNroPed:
              /* Volvemos a chequear las condiciones */
              IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
                  MESSAGE  'ERROR en la Sub-Orden ' + pCodPed + ' ' + pNroPed + CHR(10) + 
                  'Ya NO está pendiente de Pickeo'.
                  UNDO CICLO, RETURN 'ADM-ERROR'.
              END.
              ASSIGN 
                  Vtacdocu.usrsac = PikSacadores.CodPer
                  Vtacdocu.fecsac = TODAY
                  Vtacdocu.horsac = STRING(TIME,'HH:MM:SS')
                  Vtacdocu.ubigeo[4] = PikSacadores.CodPer
                  Vtacdocu.usrsacasign   = s-user-id
                  Vtacdocu.fchinicio = NOW
                  Vtacdocu.usuarioinicio = s-user-id
                  Vtacdocu.FlgSit    = "P".     /* En Proceso de Picking (APOD) */
              ASSIGN
                  Vtacdocu.Libre_c02 = pPrioridad.
              ASSIGN 
                  Vtacdocu.items     = 0
                  Vtacdocu.peso      = 0
                  Vtacdocu.volumen   = 0.
              IF vtacdocu.codped = 'ODC' OR vtacdocu.codped = 'OTC' OR vtacdocu.codped = 'OTM' THEN DO:
                  /* Ordenes consolidadas */
                  x-ordenes-ori = TRIM(vtacdocu.nroori).
                  x-codori = TRIM(vtacdocu.codori).
                  REPEAT x-sec = 1 TO NUM-ENTRIES(x-ordenes-ori,","):
                      x-nroori = ENTRY(x-sec,x-ordenes-ori,",").
                      FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                          x-vtacdocu.codped = x-codori AND 
                          x-vtacdocu.nroped = x-nroori NO-ERROR.
                      IF AVAILABLE x-vtacdocu THEN DO:
                          ASSIGN 
                              x-Vtacdocu.usrsac = Vtacdocu.usrsac
                              x-Vtacdocu.fecsac = Vtacdocu.fecsac
                              x-Vtacdocu.horsac = Vtacdocu.horsac
                              x-Vtacdocu.ubigeo[4] = Vtacdocu.ubigeo[4]
                              x-Vtacdocu.usrsacasign = Vtacdocu.usrsacasign
                              x-Vtacdocu.fchinicio = Vtacdocu.fchinicio
                              x-Vtacdocu.usuarioinicio = Vtacdocu.usuarioinicio
                              x-Vtacdocu.FlgSit    = Vtacdocu.FlgSit.     /* En Proceso de Picking (APOD) */
                          /* Importes */
                          RUN ue-get-cantidades(INPUT x-VtaCDocu.codped, INPUT x-VtaCDocu.nroped,
                                                OUTPUT lItems, OUTPUT lImporte,
                                                OUTPUT lPeso, OUTPUT lVolumen).

                          /* SubOrden */ 
                          ASSIGN  
                              x-Vtacdocu.items     = lItems
                              x-Vtacdocu.peso      = lPeso
                              x-Vtacdocu.volumen   = lVolumen.
                          /* Consolidada ??? */
                          ASSIGN  
                              Vtacdocu.items     = Vtacdocu.items + lItems
                              Vtacdocu.peso      = Vtacdocu.peso + lPeso
                              Vtacdocu.volumen   = Vtacdocu.volumen + lVolumen.
                          /* TRACKING */
                          RUN vtagn/pTracking-04 (s-CodCia,
                                                  s-CodDiv,
                                                  x-Vtacdocu.CodRef,
                                                  x-Vtacdocu.NroRef,
                                                  s-User-Id,
                                                  'APOD',
                                                  'P',
                                                  DATETIME(TODAY, MTIME),
                                                  DATETIME(TODAY, MTIME),
                                                  x-Vtacdocu.CodPed,
                                                  x-Vtacdocu.NroPed,
                                                  x-Vtacdocu.CodPed,
                                                  ENTRY(1,x-Vtacdocu.NroPed,'-')).
                      END.
                  END.
              END.
              ELSE DO:
                  /* Importes */
                  RUN ue-get-cantidades(INPUT VtaCDocu.codped, INPUT VtaCDocu.nroped,
                                        OUTPUT lItems, OUTPUT lImporte,
                                        OUTPUT lPeso, OUTPUT lVolumen).
                  ASSIGN  
                      Vtacdocu.items     = lItems
                      Vtacdocu.peso      = lPeso
                      Vtacdocu.volumen   = lVolumen.
                  /* TRACKING */
                  RUN vtagn/pTracking-04 (s-CodCia,
                                          s-CodDiv,
                                          Vtacdocu.CodRef,
                                          Vtacdocu.NroRef,
                                          s-User-Id,
                                          'APOD',
                                          'P',
                                          DATETIME(TODAY, MTIME),
                                          DATETIME(TODAY, MTIME),
                                          Vtacdocu.CodPed,
                                          Vtacdocu.NroPed,
                                          Vtacdocu.CodPed,
                                          ENTRY(1,Vtacdocu.NroPed,'-')).
              END.
              /* Pickeador ocupado */
              ASSIGN  
                  PikSacadores.FlgTarea = 'O'.    /* OCUPADO */
          END.
      END.
  END.
  RELEASE PikSacadores.
  RELEASE Vtacdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CDOCU.

FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
    AND VtaCDocu.DivDes = s-coddiv
    AND VtaCDocu.FlgEst = "P"
    AND VtaCDocu.FlgSit = "T"
    AND LOOKUP(VtaCDocu.CodPed, "O/D,OTR,O/M") > 0:
    IF Vtacdocu.UsrSac > '' THEN NEXT.
    CREATE T-CDOCU.
    BUFFER-COPY Vtacdocu TO T-CDOCU ASSIGN T-CDOCU.Items = 0 T-CDOCU.Peso = 0.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK, FIRST Almmmatg OF Vtaddocu NO-LOCK:
        T-CDOCU.Items = T-CDOCU.Items + 1.
        T-CDOCU.Peso  = T-CDOCU.Peso + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.PesMat).
    END.
END.
DEF VAR k AS INT NO-UNDO.
DEF VAR n AS INT NO-UNDO.
DEF VAR m AS INT NO-UNDO.
DEF BUFFER BT-CDOCU FOR T-CDOCU.
DO WITH FRAME {&FRAME-NAME}:
    SELECT-CodDoc:DELETE(SELECT-CodDoc:LIST-ITEM-PAIRS).
    FOR EACH T-CDOCU NO-LOCK BREAK BY T-CDOCU.CodPed BY T-CDOCU.CodDiv BY ENTRY(2,T-CDOCU.NroPed,'-'):
        IF FIRST-OF(T-CDOCU.CodPed) THEN DO:
            n = 0.
            FOR EACH BT-CDOCU NO-LOCK WHERE BT-CDOCU.CodPed = T-CDOCU.CodPed:
                n = n + 1.
            END.
            SELECT-CodDoc:ADD-LAST( T-CDOCU.CodPed + ' (' + STRING(n) + ')' , T-CDOCU.CodPed).
        END.
        IF FIRST-OF(T-CDOCU.CodPed) OR FIRST-OF(T-CDOCU.CodDiv) THEN DO:
            k = 0.
            m = 0.
        END.
        k = k + 1.
        m = m + 1.
        T-CDOCU.Libre_d01 = k.
        IF /*LAST-OF(T-CDOCU.CodPed) OR*/ LAST-OF(T-CDOCU.CodDiv) THEN DO:
            FIND FIRST GN-DIVI OF T-CDOCU NO-LOCK.
            SELECT-CodDoc:ADD-LAST( T-CDOCU.CodDiv + ' - ' + GN-DIVI.DesDiv + '(' + STRING(m) + ')', T-CDOCU.CodPed + '|' + T-CDOCU.CodDiv ).
        END.
    END.
    DISPLAY SELECT-CodDoc.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-pik-asignacion.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-pik-asignacion.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY SELECT-CodDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Actualizar BUTTON-Asignar SELECT-CodDoc BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-CDOCU"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

