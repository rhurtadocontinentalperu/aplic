&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATE2 FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE RepAutomDetail
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       .
DEFINE TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate
       FIELD DesStkMax AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkTra AS DEC.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF NEW SHARED VAR pCodDiv AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'R/A'.
DEF NEW SHARED VAR s-tipmov AS CHAR INIT 'A'.

DEF VAR x-Clasificaciones AS CHAR NO-UNDO.


DEF BUFFER MATE FOR Almmmate.

DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-Reposicion AS LOG.     /* Campaña Yes, No Campaña No */

DEF VAR X-REP AS CHAR NO-UNDO.
DEF VAR x-Claves AS CHAR INIT 'nivel1,nivel2' NO-UNDO.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-codalm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    MESSAGE 'Almacén:' s-codalm 'NO definido' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
pCodDiv = Almacen.coddiv.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEF TEMP-TABLE T-DREPO-2 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-3 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-4 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-5 LIKE T-DREPO.

DEF NEW SHARED VAR s-TipoCalculo AS CHAR.
DEF VAR pOk AS LOG NO-UNDO.
RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
IF pOk = YES THEN s-TipoCalculo = "GRUPO".
ELSE s-TipoCalculo = "TIENDA".

DEF VAR Stop-It AS LOG INIT FALSE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-27 txtFechaEntrega COMBO-BOX-Motivo ~
BUTTON-RAN BUTTON-5 BUTTON-2 FILL-IN-Glosa 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen FILL-IN-Tipo ~
FILL-IN-Temporada FILL-IN-CodRef FILL-IN-NroRef txtFechaEntrega ~
COMBO-BOX-Motivo FILL-IN-Glosa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ran-import AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR PEDIDO DE REPOSICION" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "GENERAR EXCEL" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-RAN 
     LABEL "IMPORTAR RAN" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un motivo" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un motivo","Seleccione un motivo"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY .81
     BGCOLOR 11 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "PRE-REPOSICION" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "NUMERO" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Temporada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-Tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 9 NO-UNDO.

DEFINE VARIABLE txtFechaEntrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 189 BY 2.96
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Almacen AT ROW 1.27 COL 2 NO-LABEL WIDGET-ID 38
     FILL-IN-Tipo AT ROW 1.27 COL 75 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     FILL-IN-Temporada AT ROW 1.27 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN-CodRef AT ROW 2.35 COL 18 COLON-ALIGNED WIDGET-ID 122
     FILL-IN-NroRef AT ROW 2.35 COL 32 COLON-ALIGNED WIDGET-ID 124
     txtFechaEntrega AT ROW 2.35 COL 59 COLON-ALIGNED WIDGET-ID 56
     COMBO-BOX-Motivo AT ROW 3.15 COL 18 COLON-ALIGNED WIDGET-ID 70
     BUTTON-RAN AT ROW 3.69 COL 81 WIDGET-ID 120
     BUTTON-5 AT ROW 3.69 COL 104 WIDGET-ID 34
     BUTTON-2 AT ROW 3.69 COL 126 WIDGET-ID 4
     FILL-IN-Glosa AT ROW 3.96 COL 18 COLON-ALIGNED WIDGET-ID 32
     RECT-27 AT ROW 2.08 COL 2 WIDGET-ID 130
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATE2 B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL RepAutomDetail
      ADDITIONAL-FIELDS:
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          
      END-FIELDS.
      TABLE: T-GENER T "?" NO-UNDO INTEGRAL TabGener
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: T-MATE-2 T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          FIELD DesStkMax AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkTra AS DEC
      END-FIELDS.
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO PARA REPOSICION AUTOMATICA"
         HEIGHT             = 26.12
         WIDTH              = 191.29
         MAX-HEIGHT         = 32.46
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.46
         VIRTUAL-WIDTH      = 205.72
         MAX-BUTTON         = no
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
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDO PARA REPOSICION AUTOMATICA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDO PARA REPOSICION AUTOMATICA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERAR PEDIDO DE REPOSICION */
DO:
    MESSAGE 'Continuamos con la GENERACION PEDIDO DE REPOSICION?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

  ASSIGN
      FILL-IN-Glosa txtFechaEntrega COMBO-BOX-Motivo 
      FILL-IN-CodRef FILL-IN-NroRef.


  /* RHC 04/10/2016 CONSISTENCIA DE FECHA DE ENTREGA */
  DEF VAR pMensaje AS CHAR NO-UNDO.
  pMensaje = "".
  DEF VAR pFchEnt AS DATE NO-UNDO.
  pFchEnt = txtFechaEntrega.
  /* OJO con la hora */
  /* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pPeso AS DEC NO-UNDO.
  DEF VAR pNroSKU AS INT NO-UNDO.

  RUN logis/p-datos-sede-auxiliar ("@ALM",
                                   s-CodAlm,
                                   "",                    /* Sede */
                                   OUTPUT pUbigeo,        /* Ej 150101 */
                                   OUTPUT pLongitud,
                                   OUTPUT pLatitud).
  RUN logis/p-fecha-entrega-ubigeo.p (
      s-CodAlm,
      TODAY,
      STRING(TIME,'HH:MM:SS'),      /* Hora base */
      "",
      s-CodDiv,
      pUbigeo,                      /* Ubigeo: CR es cuando el cliente recoje  */
      "R/A",
      "",
      pNroSKU,
      pPeso,
      INPUT-OUTPUT pFchEnt,
      OUTPUT pMensaje).
/*   RUN gn/p-fchent-v3.p (                                                          */
/*       s-CodAlm,                                                                   */
/*       TODAY,                        /* Fecha base */                              */
/*       STRING(TIME,'HH:MM:SS'),      /* Hora base */                               */
/*       "",              /* Cliente */                                              */
/*       s-CodDiv,              /* División solicitante */                           */
/*       pUbigeo,                      /* Ubigeo: CR es cuando el cliente recoje  */ */
/*       "R/A",              /* Documento actual */                                  */
/*       "",                                                                         */
/*       pNroSKU,                                                                    */
/*       pPeso,                                                                      */
/*       INPUT-OUTPUT pFchEnt,                                                       */
/*       OUTPUT pMensaje).                                                           */

  IF pMensaje <> '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO txtFechaEntrega.
      RETURN NO-APPLY.
  END.

  IF txtFechaEntrega < TODAY THEN DO:
      MESSAGE "Fecha de Entrega no puede ser anterior a la Actual" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-Motivo = "Seleccione un motivo" THEN DO:
      MESSAGE 'Debe seleccionar un motivo' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO COMBO-BOX-Motivo.
      RETURN NO-APPLY.
  END.
  
  RUN Generar-Pedidos IN h_b-ran-import
    ( INPUT txtFechaEntrega /* DATE */,
      INPUT FILL-IN-Glosa /* CHARACTER */,
      INPUT NO /* LOGICAL */,
      INPUT COMBO-BOX-Motivo /* CHARACTER */,
      INPUT FILL-IN-CodRef,
      INPUT FILL-IN-NroRef,
      OUTPUT pMensaje
      ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GENERAR EXCEL */
DO:
   RUN Excel IN h_b-ran-import.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-RAN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-RAN W-Win
ON CHOOSE OF BUTTON-RAN IN FRAME F-Main /* IMPORTAR RAN */
DO:
  RUN select-page('2').
  ASSIGN
      input-var-1 = 'RAN'
      input-var-2 = s-codalm
      input-var-3 = 'P'
      output-var-1 = ?.
  RUN lkup/c-repautnoc.w('REPOSICIONES AUTOMATICAS NOCTURNAS').
  IF output-var-1 <> ? THEN DO:
      FIND Almcrepo WHERE ROWID(Almcrepo) = output-var-1 NO-LOCK NO-ERROR.
      FIND FIRST RepAutomParam WHERE RepAutomParam.CodCia = s-codcia
          AND RepAutomParam.CodAlm = Almcrepo.codalm
          AND RepAutomParam.TipMov = Almcrepo.tipmov
          AND RepAutomParam.NroSer = Almcrepo.nroser
          AND RepAutomParam.NroDoc = Almcrepo.nrodoc
          AND RepAutomParam.TipMov = Almcrepo.tipmov
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE RepAutomParam THEN RETURN NO-APPLY.
      RUN Limpiar-Filtros.
      SESSION:SET-WAIT-STATE('GENERAL').
      FOR EACH Almdrepo NO-LOCK WHERE almdrepo.CodCia = almcrepo.CodCia
          AND almdrepo.CodAlm = almcrepo.CodAlm 
          AND almdrepo.TipMov = almcrepo.TipMov 
          AND almdrepo.NroSer = almcrepo.NroSer 
          AND almdrepo.NroDoc = almcrepo.NroDoc
          AND almdrepo.CanReq > almdrepo.CanAten,
          FIRST RepAutomDetail NO-LOCK WHERE RepAutomDetail.CodCia = s-codcia
          AND RepAutomDetail.CodAlm = Almdrepo.codalm
          AND RepAutomDetail.TipMov = Almdrepo.tipmov
          AND RepAutomDetail.NroSer = Almdrepo.nroser
          AND RepAutomDetail.NroDoc = Almdrepo.nrodoc
          AND RepAutomDetail.CodMat = Almdrepo.codmat:
          CREATE T-DREPO.
          BUFFER-COPY RepAutomDetail 
              TO T-DREPO
              ASSIGN
              T-DREPO.CanReq = almdrepo.CanReq - almdrepo.CanAten
              T-DREPO.CanApro = almdrepo.CanApro - almdrepo.CanAten
              T-DREPO.CanGen = almdrepo.CanGen - almdrepo.CanAten.
          ASSIGN
              T-DREPO.CodMat = CAPS(T-DREPO.CodMat) NO-ERROR.
      END.
      SESSION:SET-WAIT-STATE('').
      COMBO-BOX-Motivo = RepAutomParam.Motivo.
      DISPLAY
          Almcrepo.TipMov @ FILL-IN-CodRef
          STRING(Almcrepo.NroSer,'999') + STRING(Almcrepo.NroDoc,'99999999') @ FILL-IN-NroRef
          RepAutomParam.Glosa @ FILL-IN-Glosa
          COMBO-BOX-Motivo
          WITH FRAME {&FRAME-NAME}.
      /* ******************************************************************************** */
      /* 01-09-2023: Separa los artículos en Master y Saldos */
      /* ******************************************************************************** */
      RUN Separa-Articulos.
      /* ******************************************************************************** */
      /* ******************************************************************************** */
      RUN Carga-Filtros IN h_b-ran-import.
      RUN dispatch IN h_b-ran-import ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Motivo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Motivo IN FRAME F-Main /* Motivo */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Glosa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Glosa W-Win
ON LEAVE OF FILL-IN-Glosa IN FRAME F-Main /* Glosa */
DO:
    ASSIGN {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtFechaEntrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtFechaEntrega W-Win
ON LEAVE OF txtFechaEntrega IN FRAME F-Main /* Fecha Entrega */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


/*{alm/i-reposicionautomaticav51.i}*/
{alm/i-ra-ran-rutinas.i}

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
             INPUT  'alm/b-ran-import.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Codigo':U ,
             OUTPUT h_b-ran-import ).
       RUN set-position IN h_b-ran-import ( 5.31 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ran-import ( 21.31 , 190.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 25.50 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ran-import. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_b-ran-import ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ran-import ,
             FILL-IN-Glosa:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             h_b-ran-import , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-1-Registro W-Win 
PROCEDURE Carga-1-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = 1
            T-DREPO.AlmPed = '11'
            T-DREPO.CodMat = '000150'
            T-DREPO.CanReq = 100
            T-DREPO.CanGen = 100
            T-DREPO.StkAct = 100.
        RUN adm-open-query-cases IN h_b-ran-import.

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
  DISPLAY FILL-IN-Almacen FILL-IN-Tipo FILL-IN-Temporada FILL-IN-CodRef 
          FILL-IN-NroRef txtFechaEntrega COMBO-BOX-Motivo FILL-IN-Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-27 txtFechaEntrega COMBO-BOX-Motivo BUTTON-RAN BUTTON-5 BUTTON-2 
         FILL-IN-Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-OTR W-Win 
PROCEDURE Genera-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 30.07.2014 Se va a limitar a 52 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.

EMPTY TEMP-TABLE T-DREPO-2.     /* Acumula temporalmente los items */
EMPTY TEMP-TABLE T-DREPO-3.     /* Acumula los que #Items >= 10 */
EMPTY TEMP-TABLE T-DREPO-4.     /* Acumula los que #Items < 10  */
DEF BUFFER B-MATG FOR Almmmatg.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.flgest = YES
        AND Faccorre.coddiv = pCodDiv
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        MESSAGE 'No se encuentra el correlativo para la división' s-coddoc pCodDiv
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    /* Depuramos el temporal */
    FOR EACH T-DREPO WHERE T-DREPO.AlmPed = '998':
        DELETE T-DREPO.
    END.

    /* RHC 12/05/2017 SI UNA MARCA ESPECIFICA TIENE IGUAL O MAS DE 10 ITEMS => GENERA UN REPOSICION */
    RUN Resumimos-por-Marca.

    /* Parte 1: Los resumidos por MARCA */
    EMPTY TEMP-TABLE T-DREPO.
    FOR EACH T-DREPO-3 NO-LOCK:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-3 TO T-DREPO.
    END.
    RUN Graba-OTR-Marca (INPUT 52).   /* Tope de pedidos */

    /* Parte 2: El resto */
    EMPTY TEMP-TABLE T-DREPO.
    FOR EACH T-DREPO-4 NO-LOCK:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-4 TO T-DREPO.
    END.
    RUN Graba-OTR (INPUT 52).   /* Tope de pedidos */
END.
EMPTY TEMP-TABLE T-DREPO.
RELEASE Faccorre.
RELEASE almcrepo.
RELEASE almdrepo.

RUN adm-open-query IN h_b-ran-import.

END PROCEDURE.

/*
PROCEDURE Graba-OTR:
/* ************** */

    {alm/i-reposicionautomatica-genotr.i ~
        &Orden="T-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat" ~
        &Quiebre="FIRST-OF(T-DREPO.AlmPed) OR n-Items >= pTope"}
        
END PROCEDURE.

PROCEDURE Graba-OTR-Marca:
/* ******************** */

    {alm/i-reposicionautomatica-genotr.i ~
    &Orden="T-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat" ~
    &Quiebre="FIRST-OF(T-DREPO.AlmPed) OR FIRST-OF(Almmmatg.DesMar) OR n-Items >= pTope"}

END PROCEDURE.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtros W-Win 
PROCEDURE Limpiar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-Glosa  = ''
        COMBO-BOX-Motivo = 'Seleccione un motivo'
        FILL-IN-CodRef = ''
        FILL-IN-NroRef = ''
        .
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
    EMPTY TEMP-TABLE T-DREPO.
    RUN dispatch IN h_b-ran-import ('open-query':U).
    DISPLAY
        FILL-IN-Glosa 
        COMBO-BOX-Motivo 
        FILL-IN-CodRef
        FILL-IN-NroRef
        .
    ASSIGN
        COMBO-BOX-Motivo = 'Seleccione un motivo'.
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
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
  FILL-IN-Almacen = "ALMACÉN: " + Almacen.codalm + " " + CAPS(Almacen.Descripcion).

  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN NOT AVAILABLE Almcfggn OR AlmCfgGn.Temporada = '' THEN FILL-IN-Temporada = "NO DEFINIDA".
      WHEN Almcfggn.Temporada = "C" THEN ASSIGN FILL-IN-Temporada = "CAMPAÑA" s-Reposicion = YES.
      WHEN Almcfggn.Temporada = "NC" THEN ASSIGN FILL-IN-Temporada = "NO CAMPAÑA" s-Reposicion = NO.
  END CASE.
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
  IF pOk = YES THEN FILL-IN-Tipo = "CALCULO DE GRUPO".
  ELSE FILL-IN-Tipo = "CALCULO DE TIENDA".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      txtFechaEntrega:SCREEN-VALUE  = STRING(TODAY + 2,"99/99/9999").
      COMBO-BOX-Motivo:DELIMITER = '|'.
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          COMBO-BOX-Motivo:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAMETER pParametro AS CHAR.

CASE ENTRY(1,pParametro,'|'):
    WHEN 'Totales' THEN DO:
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumimos-por-Marca W-Win 
PROCEDURE Resumimos-por-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR n-Items AS INT NO-UNDO.

    FOR EACH T-DREPO, FIRST Almmmatg OF T-DREPO NO-LOCK
        BREAK BY T-DREPO.AlmPed BY Almmmatg.DesMar:
        IF FIRST-OF(T-DREPO.AlmPed) OR FIRST-OF(Almmmatg.DesMar) 
            THEN DO:
            /* Inicializamos */
            EMPTY TEMP-TABLE T-DREPO-2.
        END.
        CREATE T-DREPO-2.
        BUFFER-COPY T-DREPO TO T-DREPO-2.
        IF LAST-OF(T-DREPO.AlmPed) OR LAST-OF(Almmmatg.DesMar) 
            THEN DO:
                /* Contamos */
                n-Items = 0.
                FOR EACH T-DREPO-2:
                    n-Items = n-Items + 1.
                END.
                /* Grabamos en tablas diferentes */
                IF n-Items >= 10 THEN DO:
                    FOR EACH T-DREPO-2 NO-LOCK:
                        CREATE T-DREPO-3.
                        BUFFER-COPY T-DREPO-2 TO T-DREPO-3.
                    END.
                END.
                ELSE DO:
                    FOR EACH T-DREPO-2 NO-LOCK:
                        CREATE T-DREPO-4.
                        BUFFER-COPY T-DREPO-2 TO T-DREPO-4.
                    END.
                END.
        END.
    END.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Separa-Articulos W-Win 
PROCEDURE Separa-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DREPO-2.

FOR EACH T-DREPO:
    CREATE T-DREPO-2.
    BUFFER-COPY T-DREPO TO T-DREPO-2.
END.
EMPTY TEMP-TABLE T-DREPO.

DEF VAR x-CanGen AS DECI NO-UNDO.
DEF VAR x-CanMaster AS DECI NO-UNDO.

FOR EACH T-DREPO-2 WHERE NO-LOCK, FIRST Almmmatg OF T-DREPO-2 NO-LOCK:
    IF Almmmatg.CanEmp <= 0 OR T-DREPO-2.CanGen < Almmmatg.CanEmp THEN DO:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-2 TO T-DREPO
            ASSIGN T-DREPO.Origen = "Saldo".
    END.
    ELSE DO:
        x-CanGen = T-DREPO-2.CanGen.
        /* Se va a fraccionar en 2 partes: Una en Master y lo que queda en Saldo */
        x-CanMaster = TRUNCATE(x-CanGen / Almmmatg.CanEmp, 0).
        /* Primero el Master */
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-2 TO T-DREPO
            ASSIGN 
            T-DREPO.CanGen = x-CanMaster * Almmmatg.CanEmp
            T-DREPO.Origen = "Master".
        x-CanGen = x-CanGen - T-DREPO.CanGen.
        /* Segundo el Saldo */
        IF x-CanGen > 0 THEN DO:
            /* Marcamos el anterior */
            T-DREPO.Sector = "*".
            CREATE T-DREPO.
            BUFFER-COPY T-DREPO-2 TO T-DREPO
                ASSIGN 
                T-DREPO.CanGen = x-CanGen
                T-DREPO.Origen = "Saldo".
            /* Marcamos el actual */
            T-DREPO.Sector = "*".
        END.
    END.
END.
EMPTY TEMP-TABLE T-DREPO-2.

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

