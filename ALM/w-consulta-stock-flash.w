&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR s-pagina-actual AS INTE INIT 1 NO-UNDO.

DEF VAR LocalCadena AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 FILL-IN-DesMat ~
RADIO-SET-TpoArt BUTTON-3 COMBO-BOX-CodFam BUTTON-4 FILL-IN-CodPro ~
FILL-IN-Marca FILL-IN-codigo 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesMat RADIO-SET-TpoArt ~
COMBO-BOX-CodFam FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Marca FILL-IN-codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-consulta-stock-flash-p1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consulta-stock-flash-p2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "APLICAR FILTROS" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-4 
     LABEL "LIMPIAR FILTROS" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(14)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(15)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TpoArt AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activado", "A",
"Desactivado", "D"
     SIZE 24 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123 BY 3.77.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-DesMat AT ROW 1.54 COL 14 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET-TpoArt AT ROW 1.54 COL 71 NO-LABEL WIDGET-ID 42
     BUTTON-3 AT ROW 1.54 COL 102 WIDGET-ID 14
     COMBO-BOX-CodFam AT ROW 2.35 COL 14 COLON-ALIGNED WIDGET-ID 12
     BUTTON-4 AT ROW 2.62 COL 102 WIDGET-ID 28
     FILL-IN-CodPro AT ROW 3.15 COL 14 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 3.15 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Marca AT ROW 3.96 COL 14 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-codigo AT ROW 5.42 COL 14 COLON-ALIGNED WIDGET-ID 2
     "  Buscar el codigo en los registros que se muestran en pantalla" VIEW-AS TEXT
          SIZE 43 BY .5 AT ROW 4.77 COL 3 WIDGET-ID 34
          BGCOLOR 4 FGCOLOR 15 
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1 COL 3 WIDGET-ID 18
          BGCOLOR 1 FGCOLOR 15 
     RECT-2 AT ROW 1.27 COL 2 WIDGET-ID 16
     RECT-3 AT ROW 5.04 COL 2 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 25.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE STOCK POR ALMACEN"
         HEIGHT             = 25.77
         WIDTH              = 126
         MAX-HEIGHT         = 26.04
         MAX-WIDTH          = 126
         VIRTUAL-HEIGHT     = 26.04
         VIRTUAL-WIDTH      = 126
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
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE STOCK POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE STOCK POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* APLICAR FILTROS */
DO:
    ASSIGN
        COMBO-BOX-CodFam FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro FILL-IN-Marca .
    ASSIGN
        RADIO-SET-TpoArt.

    RUN Selecciona-Pagina.
    
    /*IF RETURN-VALUE = '1' THEN RETURN NO-APPLY.*/

    CASE RETURN-VALUE:
        WHEN "1" THEN DO:
            RUN Aplicar-Filtro IN h_b-consulta-stock-flash-p1
                ( INPUT RADIO-SET-TpoArt ).
        END.
        WHEN "2" THEN DO:
            DEF VAR LocalOrden AS INTE NO-UNDO.

            LocalCadena = "".
            DO LocalOrden = 1 TO NUM-ENTRIES(FILL-IN-DesMat, " "):
                LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                    TRIM(ENTRY(LocalOrden,FILL-IN-DesMat, " ")) + "*".
            END.

            RUN Aplicar-Filtro IN h_b-consulta-stock-flash-p2
                ( INPUT FILL-IN-DesMat /* CHARACTER */,
                  INPUT COMBO-BOX-CodFam /* CHARACTER */,
                  INPUT FILL-IN-CodPro /* CHARACTER */,
                  INPUT FILL-IN-Marca,
                  INPUT RADIO-SET-TpoArt).
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
  /*CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.*/
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-CodPro = ''.
      FILL-IN-DesMat = ''.
      FILL-IN-NomPro = ''.
      FILL-IN-Marca = ''.
      COMBO-BOX-CodFam:SCREEN-VALUE = 'Todos'.
      LocalCadena = "".
      RADIO-SET-TpoArt = "A".
      DISPLAY FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro FILL-IN-Marca RADIO-SET-TpoArt.
      APPLY 'CHOOSE':U TO BUTTON-3.
  END.
  RUN Selecciona-Pagina.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME F-Main /* Línea */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo W-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Código */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        
    SELF:SCREEN-VALUE = pCodMat.

    IF INPUT FILL-IN-codigo = "" THEN RETURN.

    /* Si tiene datos y está en la página 1 => limpiamos filtros */
    IF s-pagina-actual = 1 THEN DO:
       COMBO-BOX-CodFam = 'Todos'.
       FILL-IN-CodPro = ''.
       FILL-IN-DesMat = ''.
       FILL-IN-NomPro = ''.
       FILL-IN-Marca = ''.
       DISPLAY COMBO-BOX-CodFam FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro
           FILL-IN-Marca WITH FRAME {&FRAME-NAME}.
    END.
    /* Seleccionar página activa */
    RUN Selecciona-Pagina.
    CASE TRUE:
        WHEN RETURN-VALUE = '1' THEN RUN Busca-Codigo IN h_b-consulta-stock-flash-p1
    ( INPUT pCodMat /* CHARACTER */).
        WHEN RETURN-VALUE = '2' THEN RUN Busca-Codigo IN h_b-consulta-stock-flash-p2
    ( INPUT pCodMat /* CHARACTER */).
    END CASE.

    SELF:SCREEN-VALUE = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = '' THEN FILL-IN-NomPro:SCREEN-VALUE = ''.
  FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia AND
      gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE =  gn-prov.NomPro.
  ELSE FILL-IN-NomPro:SCREEN-VALUE = ''.

       ASSIGN {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat W-Win
ON LEAVE OF FILL-IN-DesMat IN FRAME F-Main /* Descripción */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca W-Win
ON LEAVE OF FILL-IN-Marca IN FRAME F-Main /* Marca */
DO:
    ASSIGN {&self-name}.
  
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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-consulta-stock-flash-p1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-stock-flash-p1 ).
       RUN set-position IN h_b-consulta-stock-flash-p1 ( 6.38 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-stock-flash-p1 ( 20.15 , 123.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-stock-flash-p1 ,
             FILL-IN-codigo:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-consulta-stock-flash-p2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-stock-flash-p2 ).
       RUN set-position IN h_b-consulta-stock-flash-p2 ( 6.38 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-stock-flash-p2 ( 20.15 , 123.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-stock-flash-p2 ,
             FILL-IN-codigo:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY FILL-IN-DesMat RADIO-SET-TpoArt COMBO-BOX-CodFam FILL-IN-CodPro 
          FILL-IN-NomPro FILL-IN-Marca FILL-IN-codigo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 FILL-IN-DesMat RADIO-SET-TpoArt BUTTON-3 
         COMBO-BOX-CodFam BUTTON-4 FILL-IN-CodPro FILL-IN-Marca FILL-IN-codigo 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-CodCia:
          COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' ' + Almtfami.desfam, Almtfami.codfam).
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Selecciona-Pagina W-Win 
PROCEDURE Selecciona-Pagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Si hay datos => página 2
   caso contrario => página 1
*/

CASE TRUE:
    WHEN TRUE <> ((FILL-IN-CodPro + FILL-IN-DesMat + FILL-IN-Marca) > '') AND COMBO-BOX-CodFam = 'Todos' 
        THEN DO:
        s-pagina-actual = 1.
        RUN select-page('1').
        RETURN '1'.
    END.
    OTHERWISE DO:
        s-pagina-actual = 2.
        RUN select-page('2').
        RETURN '2'.
    END.
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

