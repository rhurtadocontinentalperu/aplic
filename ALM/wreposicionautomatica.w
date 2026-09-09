&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE almdrepo.



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

DEF VAR s-coddoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'A' NO-UNDO.


DEF BUFFER MATE FOR Almmmate.

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
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-1 BUTTON-4 BUTTON-1 BUTTON-5 ~
FILL-IN-CodPro BUTTON-2 FILL-IN-Marca FILL-IN-Glosa 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen FILL-IN-CodFam ~
FILL-IN-CodAlm FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Marca FILL-IN-Glosa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-pedrepaut AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CARGAR HOJA DE TRABAJO" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR PEDIDO DE REPOSICION" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-5 
     LABEL "GENERAR EXCEL" 
     SIZE 33 BY 1.12.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Considerar stock de" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familias" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 138 BY 1.73
     BGCOLOR 11 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 138 BY 5.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Almacen AT ROW 1.38 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     BUTTON-4 AT ROW 3.27 COL 68 WIDGET-ID 12
     BUTTON-1 AT ROW 3.31 COL 105 WIDGET-ID 2
     FILL-IN-CodFam AT ROW 3.46 COL 16 COLON-ALIGNED WIDGET-ID 14
     BUTTON-3 AT ROW 4.35 COL 68 WIDGET-ID 16
     BUTTON-5 AT ROW 4.46 COL 105 WIDGET-ID 34
     FILL-IN-CodAlm AT ROW 4.54 COL 16 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-CodPro AT ROW 5.58 COL 16 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 5.58 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     BUTTON-2 AT ROW 5.62 COL 105 WIDGET-ID 4
     FILL-IN-Marca AT ROW 6.5 COL 16 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-Glosa AT ROW 7.31 COL 16 COLON-ALIGNED WIDGET-ID 32
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.73 COL 5 WIDGET-ID 20
          BGCOLOR 1 FGCOLOR 15 
     RECT-9 AT ROW 3 COL 2 WIDGET-ID 26
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.14 BY 24.54
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL almdrepo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO PARA REPOSICION AUTOMATICA"
         HEIGHT             = 24.62
         WIDTH              = 140.57
         MAX-HEIGHT         = 24.96
         MAX-WIDTH          = 143.14
         VIRTUAL-HEIGHT     = 24.96
         VIRTUAL-WIDTH      = 143.14
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
/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CARGAR HOJA DE TRABAJO */
DO:        
  ASSIGN
    FILL-IN-CodAlm FILL-IN-CodFam FILL-IN-CodPro FILL-IN-Marca FILL-IN-Glosa.
  ASSIGN
      BUTTON-3:SENSITIVE = NO
      BUTTON-4:SENSITIVE = NO
      FILL-IN-CodPro:SENSITIVE = NO.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal (FILL-IN-CodPro, 
                      FILL-IN-Marca, 
                      FILL-IN-CodFam, 
                      FILL-IN-CodAlm).
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERAR PEDIDO DE REPOSICION */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  ASSIGN
    FILL-IN-Glosa.
  RUN Generar-Pedidos.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-Familias AS CHAR NO-UNDO.
    x-Familias = FILL-IN-CodFam:SCREEN-VALUE.
    RUN alm/d-familias (INPUT-OUTPUT x-familias).
    FILL-IN-CodFam:SCREEN-VALUE = x-familias.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GENERAR EXCEL */
DO:
   RUN Excel IN h_b-pedrepaut.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FILL-IN-NomPro:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-prov WHERE codcia = pv-codcia
      AND codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
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
             INPUT  'aplic/alm/b-pedrepaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Codigo':U ,
             OUTPUT h_b-pedrepaut ).
       RUN set-position IN h_b-pedrepaut ( 8.65 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pedrepaut ( 15.04 , 138.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv08.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 24.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       /* Links to SmartBrowser h_b-pedrepaut. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_b-pedrepaut ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pedrepaut ,
             FILL-IN-Glosa:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             h_b-pedrepaut , 'AFTER':U ).
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
        RUN adm-open-query-cases IN h_b-pedrepaut.
        /*RUN adm-row-available IN h_b-pedrepaut.*/

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

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca  AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

EMPTY TEMP-TABLE t-drepo.
/* EL CALCULO DEPENDE DEL TIPO DE REPOSICION DEL ALMACEN */
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-codalm
    NO-LOCK.
CASE Almacen.Campo[7]:
    WHEN "" THEN RUN Por-Rotacion (pCodPro, pMarca, pCodFam, pCodAlm).
    WHEN "REU" THEN RUN Por-Reposicion (Almacen.Campo[7], pCodPro, pMarca, pCodFam, pCodAlm).
    WHEN "REE" THEN RUN Por-Reposicion (Almacen.Campo[7], pCodPro, pMarca, pCodFam, pCodAlm).
    WHEN "RUT" THEN RUN Por-Utilex (pCodPro, pMarca, pCodFam, pCodAlm).
END CASE.
RUN dispatch IN h_b-pedrepaut ('open-query':U).

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
  DISPLAY FILL-IN-Almacen FILL-IN-CodFam FILL-IN-CodAlm FILL-IN-CodPro 
          FILL-IN-NomPro FILL-IN-Marca FILL-IN-Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-9 RECT-1 BUTTON-4 BUTTON-1 BUTTON-5 FILL-IN-CodPro BUTTON-2 
         FILL-IN-Marca FILL-IN-Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pedidos W-Win 
PROCEDURE Generar-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.flgest = YES
        AND Faccorre.codalm = s-codalm
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        MESSAGE 'No se encuentra el correlativo para el almacen' s-coddoc s-codalm
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    FOR EACH T-DREPO BREAK BY T-DREPO.AlmPed:
        IF FIRST-OF(AlmPed) THEN DO:
            CREATE Almcrepo.
            ASSIGN
                almcrepo.AlmPed = T-DREPO.Almped
                almcrepo.CodAlm = s-codalm
                almcrepo.CodCia = s-codcia
                almcrepo.FchDoc = TODAY
                almcrepo.FchVto = TODAY + 7
                almcrepo.Fecha = TODAY
                almcrepo.Hora = STRING(TIME, 'HH:MM')
                almcrepo.NroDoc = Faccorre.correlativo
                almcrepo.NroSer = Faccorre.nroser
                almcrepo.TipMov = s-tipmov
                almcrepo.Usuario = s-user-id
                almcrepo.Glosa = fill-in-Glosa.
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
        END.
        CREATE Almdrepo.
        BUFFER-COPY T-DREPO TO Almdrepo
            ASSIGN
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen.
        DELETE T-DREPO.
    END.
    RELEASE Faccorre.
END.
RUN adm-open-query IN h_b-pedrepaut.

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Reposicion W-Win 
PROCEDURE Por-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Puede ser en Unidades o en Empaques
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTipRot AS CHAR.
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.*/

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm
    AND Almmmate.StkRep > 0:
    /*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.*/

    /* Stock Minimo */
    ASSIGN
        x-StockMinimo = Almmmate.StkRep
        x-StkAct = Almmmate.StkAct.
    IF x-StkAct >= x-StockMinimo THEN NEXT.
    /* Cantidad de Reposicion */
    pReposicion = x-StockMinimo - x-StkAct.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF pTipRot = "REE" AND Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                /*T-DREPO.CanGen = pReposicion*/
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Rotacion W-Win 
PROCEDURE Por-Rotacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pVentaDiaria AS DEC NO-UNDO.
DEF VAR pDiasMinimo AS INT.
DEF VAR pDiasUtiles AS INT.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.*/

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm:
    /*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.*/
    /* Venta Diaria */
    ASSIGN
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND gn-prov.StkMin > 0 THEN pDiasMinimo = gn-prov.StkMin.

    /* VA A HABER 2 FORMAS DE CALCULARLO:
        MANUAL: SIEMPRE Y CUANDO EL CAMPO ALMMMATE.STKMIN > 0 
        POR HISTORICOS: CUANDO EL CAMPO ALMMMATE.STKMIN = 0
        */
    IF Almmmate.StkMin = 0 THEN DO:     /* DEL HISTORICO */
        ASSIGN
            pRowid = ROWID(Almmmate)
            pVentaDiaria = DECIMAL(Almmmate.Libre_c04).
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = pDiasMinimo * pVentaDiaria
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        RUN gn/cantidad-de-reposicion (pRowid, pVentaDiaria, OUTPUT pReposicion).
        IF pReposicion <= 0 THEN NEXT.
        /* RHC 05/12/2012 NO tiene histórico */
        IF Almmmate.Libre_C01 = "SIN HISTORICO" THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "997"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = pReposicion
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
            NEXT.
        END.
    END.
    IF Almmmate.StkMin > 0 THEN DO:     /* MANUAL */
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = Almmmate.StkMin
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        pReposicion = x-StockMinimo - x-StkAct.
    END.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            /*x-CanReq = TRUNCATE(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.*/
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                /*T-DREPO.CanGen = pReposicion*/
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Utilex W-Win 
PROCEDURE Por-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pVentaDiaria AS DEC NO-UNDO.
DEF VAR pDiasMinimo AS INT.
DEF VAR pDiasUtiles AS INT.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockMaximo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR pAReponer   AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.

PRINCIPAL:
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    FIRST Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm
    AND Almmmate.StkMin > 0
    AND Almmmate.StkMax > 0
    AND Almmmate.StkAct < Almmmate.StkMin:
    /* Stock Minimo */
    ASSIGN
        x-StockMinimo = Almmmate.StkMin
        x-StockMaximo = Almmmate.StkMax
        x-StkAct = Almmmate.StkAct.
    /* DESCONTAMOS LOS PEDIDOS POR REPOSICION EN TRANSITO */
    RUN alm/pedidoreposicionentransito (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).
    x-StkAct = x-StkAct + pComprometido.
    /* ************************************************** */
    IF x-StkAct >= x-StockMinimo THEN NEXT.
    /* ********************* Cantidad de Reposicion ******************* */
    /* Definimos el stock maximo */
/*     FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.codcia = s-codcia                                                    */
/*         AND VtaTabla.Tabla = "%REPOSICION"                                                                        */
/*         AND VtaTabla.Llave_c1 = s-coddiv                                                                          */
/*         BY VtaTabla.Rango_Fecha[1]:                                                                               */
/*         IF TODAY >= VtaTabla.Rango_Fecha[1] THEN x-StockMaximo = Almmmate.StkMax * VtaTabla.Rango_Valor[1] / 100. */
/*     END.                                                                                                          */
    /* RHC 05/06/2014 Cambio de filosofía, ahora es el % del stock mínimo */
    FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.Tabla = "%REPOSICION"
        AND VtaTabla.Llave_c1 = s-coddiv
        BY VtaTabla.Rango_Fecha[1]:
        IF TODAY >= VtaTabla.Rango_Fecha[1] THEN 
            IF x-StkAct >= (x-StockMinimo * VtaTabla.Rango_Valor[1] / 100) THEN NEXT PRINCIPAL.
    END.
    /* Se va a reponer en cantidades múltiplo del valor Almmmate.StkMax */
    pAReponer = x-StockMinimo - x-StkAct.
    pReposicion = ROUND(pAReponer / x-StockMaximo, 0) * x-StockMaximo.
    IF pReposicion <= 0 THEN NEXT.
    pAReponer = pReposicion.    /* OJO */
    /* ************************************************/
    /*MESSAGE 'a reponer' preposicion.*/
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        /*MESSAGE 'buscamos en el almacen' almrepos.almped.*/
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codalm = Almrepos.almped
            AND B-MATE.codmat = Almmmate.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - B-MATE.StkMin - pComprometido.
        /*MESSAGE 'comprometido' b-mate.stkact b-mate.stkmin pcomprometido SKIP 'disponible' x-stockdisponible.*/
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        x-CanReq = ROUND(x-CanReq / Almmmate.StkMax, 0) * Almmmate.StkMax.
        /* No debe superar el stock disponible */
        REPEAT WHILE x-CanReq > x-StockDisponible:
            x-CanReq = x-CanReq - Almmmate.StkMax.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* ******************** RHC 18/02/2014 FILTRO POR IMPORTE DE REPOSICION ********************* */
/*         IF LOOKUP(s-coddiv, '00023,00027,00501,00502,00503,00504') > 0 THEN DO: */
/*             /* UTILEX */                                                        */
/*             IF Almmmatg.monvta = 2 THEN DO:                                     */
/*                 IF x-CanReq * Almmmatg.CtoTot * Almmmatg.TpoCmb < 50 THEN NEXT. */
/*             END.                                                                */
/*             ELSE DO:                                                            */
/*                 IF x-CanReq * Almmmatg.CtoTot < 50 THEN NEXT.                   */
/*             END.                                                                */
/*         END.                                                                    */
/*         ELSE DO:                                                                */
/*             /* OTROS ALMACENES */                                               */
/*             IF Almmmatg.monvta = 2 THEN DO:                                     */
/*                 IF x-CanReq * Almmmatg.CtoTot * Almmmatg.TpoCmb < 80 THEN NEXT. */
/*             END.                                                                */
/*             ELSE DO:                                                            */
/*                 IF x-CanReq * Almmmatg.CtoTot < 80 THEN NEXT.                   */
/*             END.                                                                */
/*         END.                                                                    */
        /*MESSAGE 'grabamos almacen' b-mate.codalm.*/
        /* ****************************************************************************************** */
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = pAReponer
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmate.StkMax > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmate.StkMax, 0) * Almmmate.StkMax.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = pAReponer
                T-DREPO.CanGen = x-CanReq
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.

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

