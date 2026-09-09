&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-DINCI NO-UNDO LIKE AlmDIncidencia.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT 'INC' NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmCIncidencia

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH AlmCIncidencia SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH AlmCIncidencia SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main AlmCIncidencia
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main AlmCIncidencia


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Aplicar FILL-IN_NroDoc BUTTON-Filtrar ~
BUTTON-Generar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc FILL-IN_ChkAlmOri ~
FILL-IN_NomChkAlmOri FILL-IN_FchChkAlmOri FILL-IN_HorChkAlmOri ~
FILL-IN_ChkAlmDes FILL-IN_NomChkAlmDes FILL-IN_FchChkAlmDes ~
FILL-IN_HorChkAlmDes FILL-IN_CrossDocking FILL-IN_ResponAlmacen ~
FILL-IN_NomResponAlmacen COMBO-BOX-ResponDistribucion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-reg-incidencia AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Aplicar 
     LABEL "Aplicar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "Mostrar Solo Indicencias" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-Generar 
     LABEL "Generar Incidencia" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "Nueva Incidencia" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-ResponDistribucion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Responsable Distribucion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_ChkAlmDes AS CHARACTER FORMAT "x(8)" 
     LABEL "Chequeador OTR Destino" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

DEFINE VARIABLE FILL-IN_ChkAlmOri AS CHARACTER FORMAT "x(8)" 
     LABEL "Chequeador OTR Despacho" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

DEFINE VARIABLE FILL-IN_CrossDocking AS LOGICAL FORMAT "SI/NO" INITIAL NO 
     LABEL "CrossDocking" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81.

DEFINE VARIABLE FILL-IN_FchChkAlmDes AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha de Chequeo OTR Destino" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_FchChkAlmOri AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha de Chequeo OTR Despacho" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_HorChkAlmDes AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_HorChkAlmOri AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_NomChkAlmDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomChkAlmOri AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomResponAlmacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "x(12)" 
     LABEL "Nro. OTR" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_ResponAlmacen AS CHARACTER FORMAT "x(8)" 
     LABEL "Responsable Almacén" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      AlmCIncidencia SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Aplicar AT ROW 1 COL 43 WIDGET-ID 70
     BUTTON-Limpiar AT ROW 1 COL 58 WIDGET-ID 84
     FILL-IN_NroDoc AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 64
     FILL-IN_ChkAlmOri AT ROW 2.35 COL 29 COLON-ALIGNED WIDGET-ID 52
     FILL-IN_NomChkAlmOri AT ROW 2.35 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     FILL-IN_FchChkAlmOri AT ROW 2.35 COL 116 COLON-ALIGNED WIDGET-ID 58
     FILL-IN_HorChkAlmOri AT ROW 2.35 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN_ChkAlmDes AT ROW 3.42 COL 29 COLON-ALIGNED WIDGET-ID 50
     FILL-IN_NomChkAlmDes AT ROW 3.42 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     FILL-IN_FchChkAlmDes AT ROW 3.42 COL 116 COLON-ALIGNED WIDGET-ID 56
     FILL-IN_HorChkAlmDes AT ROW 3.42 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     FILL-IN_CrossDocking AT ROW 4.5 COL 29 COLON-ALIGNED WIDGET-ID 54
     FILL-IN_ResponAlmacen AT ROW 5.58 COL 29 COLON-ALIGNED WIDGET-ID 66
     FILL-IN_NomResponAlmacen AT ROW 5.58 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     COMBO-BOX-ResponDistribucion AT ROW 6.65 COL 29 COLON-ALIGNED WIDGET-ID 78
     BUTTON-Filtrar AT ROW 23.88 COL 101 WIDGET-ID 80
     BUTTON-Generar AT ROW 23.88 COL 121 WIDGET-ID 82
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 24.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DINCI T "NEW SHARED" NO-UNDO INTEGRAL AlmDIncidencia
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REGISTRO DE INCIDENCIAS"
         HEIGHT             = 24.69
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-Limpiar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-ResponDistribucion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ChkAlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ChkAlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CrossDocking IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchChkAlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchChkAlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_HorChkAlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_HorChkAlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomChkAlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomChkAlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomResponAlmacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ResponAlmacen IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.AlmCIncidencia"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REGISTRO DE INCIDENCIAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REGISTRO DE INCIDENCIAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aplicar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aplicar W-Win
ON CHOOSE OF BUTTON-Aplicar IN FRAME F-Main /* Aplicar */
DO:
  ASSIGN  FILL-IN_NroDoc.
  /* Consistencia de OTR */
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
      AND Faccpedi.coddoc = 'OTR'
      AND Faccpedi.nroped = FILL-IN_NroDoc
      AND CAN-FIND(Almacen WHERE Almacen.codcia = s-CodCia AND
                   Almacen.codalm = Faccpedi.CodCli AND
                   Almacen.coddiv = s-CodDiv NO-LOCK)
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'OTR no registrada' VIEW-AS ALERT-BOX ERROR.
      FILL-IN_NroDoc:SCREEN-VALUE = ''.
      APPLY 'ENTRY':U TO FILL-IN_NroDoc.
      RETURN NO-APPLY.
  END.
  IF NOT (Faccpedi.flgest = "C" AND         /* Ya se generaron las G/R */
          LOOKUP(Faccpedi.flgsit, "R,C") > 0)
      THEN DO:
      MESSAGE 'OTR no válido' VIEW-AS ALERT-BOX ERROR.
      FILL-IN_NroDoc:SCREEN-VALUE = ''.
      APPLY 'ENTRY':U TO FILL-IN_NroDoc.
      RETURN NO-APPLY.
  END.
  IF CAN-FIND(FIRST AlmCIncidencia WHERE AlmCIncidencia.CodCia = s-CodCia AND
              AlmCIncidencia.CodDiv = s-CodDiv AND 
              AlmCIncidencia.CodDoc = Faccpedi.CodDoc AND 
              AlmCIncidencia.NroDoc = Faccpedi.NroPed AND
              AlmCIncidencia.FlgEst <> 'A' NO-LOCK)
      THEN DO:
      MESSAGE 'Ya fue registrada en otra incidencia' VIEW-AS ALERT-BOX ERROR.
      FILL-IN_NroDoc:SCREEN-VALUE = ''.
      APPLY 'ENTRY':U TO FILL-IN_NroDoc.
      RETURN NO-APPLY.
  END.
  IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = s-codcia AND
                  Almcmov.CodRef = Faccpedi.coddoc AND
                  Almcmov.NroRef = Faccpedi.nroped AND
                  Almcmov.TipMov = "S" AND
                  Almcmov.FlgEst <> 'A' AND 
                  Almcmov.FlgSit = "R" NO-LOCK)
        THEN DO:
        MESSAGE 'NO tiene ninguna G/R recepcionada' VIEW-AS ALERT-BOX ERROR.
        FILL-IN_NroDoc:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO FILL-IN_NroDoc.
        RETURN NO-APPLY.
  END.
  /* Pintamos información */
  DISPLAY 
      Faccpedi.usrchq @ FILL-IN_ChkAlmOri 
      Faccpedi.fchchq @ FILL-IN_FchChkAlmOri 
      Faccpedi.horchq @ FILL-IN_HorChkAlmOri
      FacCPedi.CrossDocking @ FILL-IN_CrossDocking
      WITH FRAME {&FRAME-NAME}
      .
  FIND logtabla WHERE logtabla.codcia = s-codcia AND
      logtabla.Tabla = "FACCPEDI" AND
      logtabla.Evento = "CHKDESTINO" AND
      logtabla.ValorLlave BEGINS (s-coddiv + '|' + faccpedi.coddoc + '|' + faccpedi.nroped)
      NO-LOCK NO-ERROR.
  IF AVAILABLE LogTabla THEN DO:
      DISPLAY
          LogTabla.Usuario @ FILL-IN_ChkAlmDes 
          ENTRY(4, LogTabla.ValorLlave, '|') @ FILL-IN_FchChkAlmDes 
          ENTRY(5, LogTabla.ValorLlave, '|') @ FILL-IN_HorChkAlmDes
          WITH FRAME {&FRAME-NAME}
          .
  END.
  /* Habilitamos y deshabilitamos campos */
  ASSIGN
      BUTTON-Aplicar:SENSITIVE = NO
      BUTTON-Limpiar:SENSITIVE = YES
      FILL-IN_NroDoc:SENSITIVE = NO
      FILL-IN_ResponAlmacen:SENSITIVE = YES
      COMBO-BOX-ResponDistribucion:SENSITIVE = YES.
  FIND gn-users WHERE gn-users.CodCia = s-CodCia AND
      gn-users.User-Id = s-user-id
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-users THEN DISPLAY gn-users.CodPer @ FILL-IN_ResponAlmacen WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN_ChkAlmOri.
  APPLY 'LEAVE':U TO FILL-IN_ResponAlmacen.
  APPLY 'ENTRY':U TO FILL-IN_ResponAlmacen.

  DEF VAR x-NroItem AS INT NO-UNDO.

  EMPTY TEMP-TABLE T-DINCI.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      CREATE T-DINCI.
      ASSIGN
          T-DINCI.AlmOri = Faccpedi.CodAlm
          T-DINCI.CanInc = 0
          T-DINCI.CanPed = Facdpedi.CanPed
          T-DINCI.CodCia = s-CodCia
          T-DINCI.CodDiv = s-CodDiv
          T-DINCI.CodMat = Facdpedi.CodMat
          T-DINCI.Factor = Facdpedi.Factor
          T-DINCI.NroItem = x-NroItem + 1
          T-DINCI.UndVta = Facdpedi.UndVta.
      x-NroItem = x-NroItem + 1.
      /* En cuál G/R está? */
      FOR EACH Almcmov WHERE Almcmov.codcia = s-codcia AND
          Almcmov.CodRef = Faccpedi.coddoc AND
          Almcmov.NroRef = Faccpedi.nroped AND
          Almcmov.TipMov = "S" AND
          Almcmov.FlgEst <> 'A' AND 
          Almcmov.FlgSit = "R", 
          EACH Almdmov OF Almcmov NO-LOCK WHERE Almdmov.CodMat = Facdpedi.CodMat:
          T-DINCI.NroGR = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '99999999').
      END.
  END.
  COMBO-BOX-ResponDistribucion:DELETE(COMBO-BOX-ResponDistribucion:LIST-ITEM-PAIRS).
  /* Barremos todas la G/R relacionadas */
  DEF VAR x-NomPer AS CHAR NO-UNDO.
  RLOOP:
  FOR EACH Almcmov WHERE Almcmov.codcia = s-codcia AND
      Almcmov.CodRef = Faccpedi.coddoc AND
      Almcmov.NroRef = Faccpedi.nroped AND
      Almcmov.TipMov = "S" AND
      Almcmov.FlgEst <> 'A' AND 
      Almcmov.FlgSit = "R" NO-LOCK WITH FRAME {&FRAME-NAME}:
      /* Buscamos las H/R relacionadas */
      FOR EACH Di-RutaG NO-LOCK WHERE Di-RutaG.CodCia = s-CodCia AND 
          Di-RutaG.CodDiv = Faccpedi.CodDiv AND
          Di-RutaG.CodDoc = "H/R" AND
          Di-RutaG.serref = Almcmov.nroser AND
          Di-RutaG.nroref = Almcmov.nrodoc AND
          Di-RutaG.Tipmov = Almcmov.tipmov AND 
          Di-RutaG.Codmov = Almcmov.codmov AND
          Di-RutaG.CodAlm = Almcmov.codalm,
          FIRST Di-RutaC OF Di-RutaG NO-LOCK WHERE Di-RutaC.FlgEst = "C":
          COMBO-BOX-ResponDistribucion = DI-RutaC.responsable.
          RUN gn/nombre-personal (s-codcia, DI-RutaC.responsable, OUTPUT x-NomPer).
          COMBO-BOX-ResponDistribucion:ADD-LAST('Responsable: ' + DI-RutaC.responsable + ' ' + x-NomPer, DI-RutaC.responsable).
          RUN gn/nombre-personal (s-codcia, DI-RutaC.ayudante-1, OUTPUT x-NomPer).
          COMBO-BOX-ResponDistribucion:ADD-LAST('Ayudante 1: ' + DI-RutaC.ayudante-1 + ' ' + x-NomPer, DI-RutaC.ayudante-1).
          RUN gn/nombre-personal (s-codcia, DI-RutaC.ayudante-2, OUTPUT x-NomPer).
          COMBO-BOX-ResponDistribucion:ADD-LAST('Ayudante 2: ' + DI-RutaC.ayudante-2 + ' ' + x-NomPer, DI-RutaC.ayudante-2).
          LEAVE RLOOP.
      END.
  END.
  DISPLAY COMBO-BOX-ResponDistribucion  WITH FRAME {&FRAME-NAME}.
  RUN dispatch IN h_t-reg-incidencia ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* Mostrar Solo Indicencias */
DO:
  RUN Solo-Incidencias IN h_t-reg-incidencia (SELF:LABEL).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  SELF:LABEL = (IF SELF:LABEL = 'Mostrar Solo Incidencias' THEN 'Mostrar Todo' ELSE 'Mostrar Solo Incidencias').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* Generar Incidencia */
DO:
  ASSIGN 
      COMBO-BOX-ResponDistribucion 
      FILL-IN_ChkAlmDes 
      FILL-IN_ChkAlmOri 
      FILL-IN_CrossDocking 
      FILL-IN_FchChkAlmDes 
      FILL-IN_FchChkAlmOri 
      FILL-IN_HorChkAlmDes 
      FILL-IN_HorChkAlmOri 
      FILL-IN_NomChkAlmDes 
      FILL-IN_NomChkAlmOri 
      FILL-IN_NomResponAlmacen 
      FILL-IN_NroDoc 
      FILL-IN_ResponAlmacen
      .
  /* Consistencias */
  IF NOT CAN-FIND(FIRST PL-PERS WHERE PL-PERS.CodCia = s-CodCia AND
                  PL-PERS.codper = FILL-IN_ResponAlmacen NO-LOCK)
      THEN DO:
      MESSAGE 'Código del Responsable del Almacén no registrado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_ResponAlmacen.
      RETURN NO-APPLY.
  END.

  RUN MASTER-TRANSACTION.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  APPLY 'CHOOSE':U TO BUTTON-Limpiar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* Nueva Incidencia */
DO:
  CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
  EMPTY TEMP-TABLE T-DINCI.
  RUN dispatch IN h_t-reg-incidencia ('open-query':U).
  /* Habilitamos y deshabilitamos campos */
  ASSIGN
      BUTTON-Aplicar:SENSITIVE = YES
      BUTTON-Limpiar:SENSITIVE = NO
      FILL-IN_NroDoc:SENSITIVE = YES
      FILL-IN_ResponAlmacen:SENSITIVE = NO
      COMBO-BOX-ResponDistribucion:SENSITIVE = NO.
  APPLY 'ENTRY':U TO FILL-IN_NroDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ChkAlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ChkAlmDes W-Win
ON LEAVE OF FILL-IN_ChkAlmDes IN FRAME F-Main /* Chequeador OTR Destino */
DO:
    RUN gn/nombre-personal (s-codcia, FILL-IN_ChkAlmDes:SCREEN-VALUE, OUTPUT  FILL-IN_NomChkAlmDes).
    DISPLAY FILL-IN_NomChkAlmDes WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ChkAlmOri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ChkAlmOri W-Win
ON LEAVE OF FILL-IN_ChkAlmOri IN FRAME F-Main /* Chequeador OTR Despacho */
DO:
  RUN gn/nombre-personal (s-codcia, FILL-IN_ChkAlmOri:SCREEN-VALUE, OUTPUT  FILL-IN_NomChkAlmOri).
  DISPLAY FILL-IN_NomChkAlmOri WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ResponAlmacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ResponAlmacen W-Win
ON LEAVE OF FILL-IN_ResponAlmacen IN FRAME F-Main /* Responsable Almacén */
DO:
    RUN gn/nombre-personal (s-codcia, FILL-IN_ResponAlmacen:SCREEN-VALUE, OUTPUT  FILL-IN_NomResponAlmacen).
    DISPLAY FILL-IN_NomResponAlmacen WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/t-reg-incidencia.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-reg-incidencia ).
       RUN set-position IN h_t-reg-incidencia ( 7.73 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-reg-incidencia ( 16.15 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 23.88 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-reg-incidencia. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_t-reg-incidencia ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-reg-incidencia ,
             COMBO-BOX-ResponDistribucion:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_t-reg-incidencia , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY FILL-IN_NroDoc FILL-IN_ChkAlmOri FILL-IN_NomChkAlmOri 
          FILL-IN_FchChkAlmOri FILL-IN_HorChkAlmOri FILL-IN_ChkAlmDes 
          FILL-IN_NomChkAlmDes FILL-IN_FchChkAlmDes FILL-IN_HorChkAlmDes 
          FILL-IN_CrossDocking FILL-IN_ResponAlmacen FILL-IN_NomResponAlmacen 
          COMBO-BOX-ResponDistribucion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Aplicar FILL-IN_NroDoc BUTTON-Filtrar BUTTON-Generar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Incidencia W-Win 
PROCEDURE Genera-Incidencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pIncidencia AS CHAR.

/* Consistencia de correlativos */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia AND ~
            FacCorre.CodDiv = s-CodDiv AND ~
            FacCorre.CodDoc = s-CodDoc AND ~
            FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* GENERAMOS LA CABECERA Y DETALLE POR ESTE TIPO DE INCIDENCIA */
    CREATE AlmCIncidencia.
    ASSIGN
        AlmCIncidencia.CodCia = s-CodCia
        AlmCIncidencia.CodDiv = s-CodDiv
        AlmCIncidencia.NroControl = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
        AlmCIncidencia.CodDoc = FacCPedi.CodDoc
        AlmCIncidencia.NroDoc = FILL-IN_NroDoc
        AlmCIncidencia.ChkAlmDes = FILL-IN_ChkAlmDes
        AlmCIncidencia.ChkAlmOri = FILL-IN_ChkAlmOri
        AlmCIncidencia.CrossDocking = FILL-IN_CrossDocking
        AlmCIncidencia.FchChkAlmDes = FILL-IN_FchChkAlmDes
        AlmCIncidencia.FchChkAlmOri = FILL-IN_FchChkAlmOri
        AlmCIncidencia.Fecha = TODAY
        AlmCIncidencia.Hora = STRING(TIME, 'HH:MM:SS')
        AlmCIncidencia.HorChkAlmDes = FILL-IN_HorChkAlmDes
        AlmCIncidencia.HorChkAlmOri = FILL-IN_HorChkAlmOri
        AlmCIncidencia.ResponAlmacen = FILL-IN_ResponAlmacen
        AlmCIncidencia.ResponDistribucion = COMBO-BOX-ResponDistribucion
        AlmCIncidencia.Usuario = s-User-Id
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN  
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* GENERAMOS EL DETALLE */
    DEF VAR x-NroItem AS INT NO-UNDO.
    FOR EACH T-DINCI NO-LOCK WHERE T-DINCI.Incidencia = pIncidencia AND T-DINCI.CanInc > 0 
        BY T-DINCI.NroItem:
        CREATE AlmDIncidencia.
        BUFFER-COPY T-DINCI   
            TO AlmDIncidencia
            ASSIGN
            AlmDIncidencia.CodCia = AlmCIncidencia.CodCia 
            AlmDIncidencia.CodDiv = AlmCIncidencia.CodDiv 
            AlmDIncidencia.NroControl = AlmCIncidencia.NroControl
            AlmDIncidencia.NroItem = x-NroItem + 1.
            .
        x-NroItem = x-NroItem + 1.
    END.
    /* GENERACION DE LA R/A */
    DEF VAR pCodDiv AS CHAR NO-UNDO.
    DEF VAR pCodAlm AS CHAR NO-UNDO.
    DEF VAR pAlmPed AS CHAR NO-UNDO.
    CASE pIncidencia:
        WHEN 'S' THEN DO:   /* Sobrante */
            pCodDiv = s-CodDiv.
            pCodAlm = Faccpedi.CodCli.
            pAlmPed = Faccpedi.CodAlm.
            RUN Genera-RA (TODAY + 1,
                           pCodDiv,
                           pCodAlm,
                           pIncidencia,
                           pAlmPed
                           ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la R/A".
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN 'F' OR WHEN 'M'THEN DO:   /* Faltante o Mal Estado */
            FIND Almacen WHERE Almacen.codcia = s-CodCia 
                AND Almacen.CodAlm = Faccpedi.CodAlm
                NO-LOCK.
            pCodDiv = Almacen.CodDiv.
            pCodAlm = Faccpedi.CodAlm.
            pAlmPed = Faccpedi.CodCli.
            RUN Genera-RA (TODAY + 1,
                           pCodDiv,
                           pCodAlm,
                           pIncidencia,
                           pAlmPed
                           ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la R/A".
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(AlmCIncidencia) THEN RELEASE AlmCIncidencia.
IF AVAILABLE(AlmDIncidencia) THEN RELEASE AlmDIncidencia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-RA W-Win 
PROCEDURE Genera-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  RUN Generar-Pedidos IN h_b-pedrepautv51
    ( INPUT txtFechaEntrega /* DATE */,
      INPUT FILL-IN-Glosa /* CHARACTER */,
      INPUT TOGGLE-VtaPuntual /* LOGICAL */,
      INPUT COMBO-BOX-Motivo /* CHARACTER */,
      INPUT FILL-IN-CodRef,
      INPUT FILL-IN-NroRef
      ).
*/

DEF INPUT PARAMETER pFchEnt AS DATE.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Almacén solicitante */
DEF INPUT PARAMETER pCodAlm AS CHAR.    /* Almacén solicitante */
DEF INPUT PARAMETER pIncidencia AS CHAR.    /* Tipo de Incidencia */
DEF INPUT PARAMETER pAlmPed AS CHAR.    /* Almacén Despacho */        

DEF VAR s-CodDoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-TipMov AS CHAR INIT "INC" NO-UNDO.

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.flgest = YES
    AND Faccorre.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    pMensaje = 'No se encuentra el correlativo para la división ' + s-coddoc + ' ' + pCodDiv.
    RETURN "ADM-ERROR".
END.

/* OJO con la hora */
RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, pCodDiv, pCodAlm, OUTPUT pMensaje).
IF pMensaje <> '' THEN RETURN 'ADM-ERROR'.

/* RHC 30.07.2014 Se va a limitar a 52 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.
DEF BUFFER B-MATG FOR Almmmatg.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.flgest = YES ~
            AND Faccorre.coddiv = pCodDiv"
        &Bloqueo="EXCLUSIVE-LOCK"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    
    CREATE Almcrepo.
    ASSIGN
        almcrepo.CodCia = s-CodCia
        almcrepo.CodAlm = pCodAlm
        almcrepo.TipMov = s-TipMov          /* OJO: Manual Automático */
        almcrepo.NroSer = Faccorre.nroser
        almcrepo.NroDoc = Faccorre.correlativo
        almcrepo.AlmPed = pAlmPed
        almcrepo.FchDoc = TODAY
        almcrepo.FchVto = TODAY + 7
        almcrepo.Fecha = pFchEnt    /* Ic 13May2015*/
        almcrepo.Hora = STRING(TIME, 'HH:MM')
        almcrepo.Usuario = s-user-id
        almcrepo.CodRef = "INC"                         /* OJO */
        almcrepo.NroRef = AlmCIncidencia.NroControl     /* OJO */
        almcrepo.Incidencia = pIncidencia
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR el el correlativo de " + s-CodDoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1
        n-Items = 0.
    /* RHC 21/04/2016 Almacén de despacho CD? */
    ASSIGN
        Almcrepo.FlgSit = "G".   /* Por Autorizar por Abastecimientos */
    /* ************************************** */
    n-Items = 0.
    FOR EACH T-DINCI NO-LOCK WHERE T-DINCI.Incidencia = pIncidencia AND T-DINCI.CanInc > 0,
        FIRST Almmmatg OF T-DINCI NO-LOCK BY T-DINCI.NroItem:
        CREATE Almdrepo.
        ASSIGN
            almdrepo.ITEM   = n-Items + 1
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.AlmPed = almcrepo.almped
            almdrepo.Origen = "AUT"
            almdrepo.CodMat = T-DINCI.CodMat 
            almdrepo.CanGen = T-DINCI.CanInc * T-DINCI.Factor 
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen
            .
        n-Items = n-Items + 1.
    END.
    
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  COMBO-BOX-ResponDistribucion:DELIMITER IN FRAME {&FRAME-NAME} = '|'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.CodDoc = s-CodDoc AND
                FacCorre.FlgEst = YES NO-LOCK)
    THEN DO:
    MESSAGE 'NO hay ningún correlativo configurado para el documento' s-CodDoc VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF BUFFER BT-DINCI FOR T-DINCI.
IF NOT CAN-FIND(FIRST BT-DINCI WHERE BT-DINCI.CanInc > 0 NO-LOCK) THEN DO:
    MESSAGE 'NO ha registrado aún una incidencia' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    pMensaje = ''.
    /* Se va a generar un registro de incidencia por cada tipo de incidencia */
    FOR EACH BT-DINCI NO-LOCK WHERE BT-DINCI.CanInc > 0 BREAK BY BT-DINCI.Incidencia:
        IF FIRST-OF(BT-DINCI.Incidencia) THEN DO:
            RUN Genera-Incidencia (BT-DINCI.Incidencia).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar las Incidencias'.
                UNDO RLOOP, LEAVE RLOOP.
            END.
        END.
    END.
END.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
  {src/adm/template/snd-list.i "AlmCIncidencia"}

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

