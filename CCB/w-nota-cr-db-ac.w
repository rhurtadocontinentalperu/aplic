&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Adelantos FOR CcbCDocu.
DEFINE BUFFER B-NC FOR CcbCDocu.
DEFINE TEMP-TABLE DOCU LIKE CcbCDocu.



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

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pParam AS CHAR.


/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-cndcre AS CHAR.
DEF NEW SHARED VAR s-tpofac AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR INIT "N/C".
DEF NEW SHARED VAR s-NroSer AS INT  INIT 000.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-Tipo   AS CHAR INIT "CREDITO".
DEF NEW SHARED VAR S-PORDTO AS DEC.
DEF NEW SHARED VAR S-PORIGV AS DEC.
/* 
Sintaxis: <TpoFac>,<CndCre>,<Tipo>

*/
ASSIGN
    s-tpofac = "SALDOAC"
    s-cndcre = "N".

IF pParam > '' THEN DO:
    s-tpofac = ENTRY(1,pParam).
    IF NUM-ENTRIES(pParam) > 1 THEN s-cndcre = ENTRY(2,pParam).
    IF NUM-ENTRIES(pParam) > 2 THEN s-tipo   = ENTRY(3,pParam).
END.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

/* Validación Primaria */
FIND FIRST Vtactabla WHERE Vtactabla.codcia = s-codcia AND
    Vtactabla.tabla = "CFG_TIPO_NC" AND
    Vtactabla.llave = s-TpoFac AND
    CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.tipo = "CONCEPTO" AND
             CAN-FIND(FIRST Ccbtabla WHERE Ccbtabla.codcia = s-codcia AND 
                      Ccbtabla.tabla = s-coddoc AND
                      Ccbtabla.codigo = Vtadtabla.llavedetalle
                      NO-LOCK)
             NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtactabla THEN DO:
    MESSAGE 'NO está configurado el sistema con el tipo: ' + s-TpoFac
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodCli BUTTON-1 RECT-1 RECT-2 ~
BUTTON-2 COMBO-NroSer COMBO-BOX-Concepto BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodCli FILL-IN-NomCli COMBO-NroSer ~
FILL-IN-NroDoc COMBO-BOX-Concepto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-nota-cr-db-ac AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "FILTRAR ANTICIPOS" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "NUEVO CLIENTE" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "GENERAR N/ CREDITO" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Concepto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione el Concepto" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Seleccione la serie de la N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Código del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 3.23.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodCli AT ROW 1.54 COL 15 COLON-ALIGNED WIDGET-ID 76
     BUTTON-1 AT ROW 1.27 COL 79 WIDGET-ID 70
     FILL-IN-NomCli AT ROW 2.35 COL 15 COLON-ALIGNED WIDGET-ID 78
     BUTTON-2 AT ROW 2.35 COL 79 WIDGET-ID 96
     COMBO-NroSer AT ROW 4.77 COL 6.43 WIDGET-ID 74
     FILL-IN-NroDoc AT ROW 4.77 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     COMBO-BOX-Concepto AT ROW 5.69 COL 25 COLON-ALIGNED WIDGET-ID 90
     BUTTON-3 AT ROW 4.5 COL 79 WIDGET-ID 72
     "Comprobante a Generar" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 3.96 COL 4 WIDGET-ID 86
          BGCOLOR 1 FGCOLOR 15 
     "Filtros" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1 COL 4 WIDGET-ID 88
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 92
     RECT-2 AT ROW 4.23 COL 2 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.86 BY 15.31
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Adelantos B "?" ? INTEGRAL CcbCDocu
      TABLE: B-NC B "?" ? INTEGRAL CcbCDocu
      TABLE: DOCU T "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CANJE DE ANTICIPOS DE CAMPAÑA"
         HEIGHT             = 15.31
         WIDTH              = 114.86
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CANJE DE ANTICIPOS DE CAMPAÑA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CANJE DE ANTICIPOS DE CAMPAÑA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* FILTRAR ANTICIPOS */
DO:
  ASSIGN
      FILL-IN-CodCli.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* NUEVO CLIENTE */
DO:
  FILL-IN-CodCli:SCREEN-VALUE = "".
  FILL-IN-NomCli:SCREEN-VALUE = "".
  EMPTY TEMP-TABLE DOCU.
  RUN Import-Temp-Table IN h_t-nota-cr-db-ac ( INPUT TABLE DOCU).
  FILL-IN-CodCli:SENSITIVE = YES.
  APPLY 'ENTRY':U TO FILL-IN-CodCli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* GENERAR N/ CREDITO */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.

  ASSIGN
      COMBO-NroSer COMBO-BOX-Concepto.
  RUN Genera-NC IN h_t-nota-cr-db-ac ( 
      INPUT s-CodDoc,
      INPUT INTEGER(COMBO-NroSer),
      INPUT ENTRY(1, COMBO-BOX-Concepto, ' - '),
      OUTPUT pMensaje 
      ).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Proceso exitoso' VIEW-AS ALERT-BOX INFORMATION.
  APPLY "VALUE-CHANGED" TO COMBO-NroSer.
  APPLY "CHOOSE":U TO BUTTON-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON RETURN OF COMBO-NroSer IN FRAME F-Main /* Seleccione la serie de la N/C */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Seleccione la serie de la N/C */
DO:
    /* Correlativo */
    FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) +
            STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')).
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Código del Cliente */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FILL-IN-NomCli:SCREEN-VALUE = "".
    FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie OR gn-clie.flgsit <> 'A' THEN DO:
        MESSAGE 'Cliente no válido' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NomCli:SCREEN-VALUE = gn-clie.NomCli.
    FILL-IN-CodCli:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME F-Main /* Código del Cliente */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
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
             INPUT  'aplic/ccb/t-nota-cr-db-ac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-nota-cr-db-ac ).
       RUN set-position IN h_t-nota-cr-db-ac ( 7.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-nota-cr-db-ac ( 7.54 , 109.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 14.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-nota-cr-db-ac. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_t-nota-cr-db-ac ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-nota-cr-db-ac ,
             COMBO-BOX-Concepto:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_t-nota-cr-db-ac , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE DOCU.
FOR EACH B-Adelantos NO-LOCK WHERE B-Adelantos.CodCia = s-codcia
    AND B-Adelantos.CodDoc = "A/C"
    AND B-Adelantos.FlgEst = "P"
    AND B-Adelantos.CodCli = FILL-IN-CodCli
    AND B-Adelantos.SdoAct > 0,
    FIRST CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = B-Adelantos.CodCia
    AND CcbCDocu.CodDoc = B-Adelantos.CodRef
    AND CcbCDocu.NroDoc = B-Adelantos.NroRef:
    CREATE DOCU.
    BUFFER-COPY B-Adelantos
        TO DOCU
        ASSIGN
        DOCU.FchVto    = CcbCDocu.FchVto
        DOCU.Libre_d01 = B-Adelantos.SdoAct.
END.
RUN Import-Temp-Table IN h_t-nota-cr-db-ac ( INPUT TABLE DOCU).

IF NOT CAN-FIND(FIRST DOCU) THEN DO:
    MESSAGE 'NO hay registros a mostrar' VIEW-AS ALERT-BOX WARNING.
    APPLY 'CHOOSE' TO BUTTON-2 IN FRAME {&FRAME-NAME}.
END.

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
  DISPLAY FILL-IN-CodCli FILL-IN-NomCli COMBO-NroSer FILL-IN-NroDoc 
          COMBO-BOX-Concepto 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodCli BUTTON-1 RECT-1 RECT-2 BUTTON-2 COMBO-NroSer 
         COMBO-BOX-Concepto BUTTON-3 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-NroDoc:FORMAT = x-Formato.
      /* CORRELATIVO DE FAC y BOL */
      {sunat\i-lista-series.i &CodCia=s-CodCia ~
          &CodDiv=s-CodDiv ~
          &CodDoc=s-CodDoc ~
          &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
          &Tipo=s-Tipo ~
          &ListaSeries=cListItems ~
          }

      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      /* Correlativo */
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')).
      /* Conceptos N/C */
      cListItems = "".
      FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = s-codcia AND
          Vtactabla.tabla = "CFG_TIPO_NC" AND
          Vtactabla.llave = s-TpoFac,
          EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.tipo = "CONCEPTO",
          FIRST Ccbtabla NO-LOCK WHERE Ccbtabla.codcia = s-codcia AND 
          Ccbtabla.tabla = s-coddoc AND
          Ccbtabla.codigo = Vtadtabla.llavedetalle:
          IF cListItems = "" THEN cListItems = CcbTabla.Codigo +  ' - ' + CcbTabla.Nombre.
          ELSE cListItems = cListItems + "|" + CcbTabla.Codigo +  ' - ' + CcbTabla.Nombre.
      END.
      ASSIGN
          COMBO-BOX-Concepto:DELIMITER = '|'
          COMBO-BOX-Concepto:LIST-ITEMS = cListItems
          COMBO-BOX-Concepto = ENTRY(1,COMBO-BOX-Concepto:LIST-ITEMS, '|').

  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

