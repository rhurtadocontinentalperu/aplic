&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle LIKE prilistapreciostemp
       FIELD Fila AS INTE.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF TEMP-TABLE T-Errores 
    FIELD Fila   AS INTE
    FIELD CodMat LIKE Detalle.codmat
    FIELD Glosa  AS CHAR FORMAT 'x(80)'
    .

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
&Scoped-Define ENABLED-OBJECTS BUTTON-11 BUTTON-13 BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-mantto-prebas-temp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-11 
     LABEL "IMPORTAR Y VALIDAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-13 
     LABEL "EXPORTAR A EXCEL" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-14 
     LABEL "VALIDAR PRECIO ENTRE CANALES" 
     SIZE 30 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 90 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-11 AT ROW 1.27 COL 36 WIDGET-ID 2
     BUTTON-13 AT ROW 1.27 COL 61 WIDGET-ID 6
     BUTTON-14 AT ROW 1.27 COL 81 WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 26.31 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Detalle T "?" ? INTEGRAL prilistapreciostemp
      ADDITIONAL-FIELDS:
          FIELD Fila AS INTE
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "MANTENIMIENTO DE LISTA DE PRECIOS TEMPORAL"
         HEIGHT             = 26.15
         WIDTH              = 191.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* MANTENIMIENTO DE LISTA DE PRECIOS TEMPORAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MANTENIMIENTO DE LISTA DE PRECIOS TEMPORAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* IMPORTAR Y VALIDAR EXCEL */
DO:
  RUN Import-Excel.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'Proceso Abortado' VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF NOT CAN-FIND(FIRST Detalle NO-LOCK) THEN DO:
      MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN Carga-Lista.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* EXPORTAR A EXCEL */
DO:
  RUN Genera-Excel-Plantilla IN h_b-mantto-prebas-temp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* VALIDAR PRECIO ENTRE CANALES */
DO:
  RUN Validar-Canales-Grupos IN h_b-mantto-prebas-temp.
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
             INPUT  'adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-mantto-prebas-temp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-mantto-prebas-temp ).
       RUN set-position IN h_b-mantto-prebas-temp ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-mantto-prebas-temp ( 23.69 , 188.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-mantto-prebas-temp. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_b-mantto-prebas-temp ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             BUTTON-11:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-mantto-prebas-temp ,
             BUTTON-14:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lista W-Win 
PROCEDURE Carga-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro limpiamos todos los productos relacionados con el jefe de línea */
    FOR EACH prilistapreciostemp WHERE prilistapreciostemp.CodCia = s-codcia EXCLUSIVE-LOCK,
        FIRST Almmmatg OF prilistapreciostemp NO-LOCK,
        FIRST Priuserlineasublin WHERE priuserlineasublin.CodCia = s-codcia AND
        priuserlineasublin.CodFam = Almmmatg.codfam AND
        priuserlineasublin.SubFam = Almmmatg.subfam AND 
        priuserlineasublin.USER-ID = s-user-id NO-LOCK:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "BORRANDO: " + Almmmatg.CodMat.
        DELETE PriListaPreciosTemp.
    END.
    /* 2do. actualizamos la lista temporal */
    FOR EACH Detalle:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CARGANDO: " + Detalle.CodMat.
        CREATE PriListaPreciosTemp.
        BUFFER-COPY Detalle TO PriListaPreciosTemp 
            ASSIGN
            prilistapreciostemp.FchCreacion = TODAY
            prilistapreciostemp.HoraCreacion = STRING(TIME, 'HH:MM:SS')
            prilistapreciostemp.UsrCreacion = s-user-id
            NO-ERROR.
    END.
END.
RELEASE PriListaPreciosTemp.
RUN dispatch IN h_b-mantto-prebas-temp ('open-query':U).

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
  DISPLAY FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-11 BUTTON-13 BUTTON-14 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Excel W-Win 
PROCEDURE Import-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Solicitamos el achivo excel */
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR rpta AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo FILTERS "*.xlsx" "*.xlsx" TITLE "Seleccione el archivo Excel" UPDATE rpta.
IF rpta = NO THEN RETURN 'ADM-ERROR'.

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFileXls AS CHAR NO-UNDO.

lNuevoFile = NO.
lFileXls = x-Archivo.

{lib/excel-open-file.i}

DEF VAR t-Row AS INTE NO-UNDO.
DEF VAR t-Column AS INTE NO-UNDO.
DEF VAR cValue AS CHAR NO-UNDO.

ASSIGN
    t-Row = 1.
EMPTY TEMP-TABLE Detalle.
EMPTY TEMP-TABLE T-Errores.
REPEAT:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    t-column = 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "IMPORTANDO: " + cValue.
    /* Codigo */
    CREATE Detalle.
    ASSIGN
        Detalle.Fila   = t-Row
        Detalle.USER-ID = s-user-id
        Detalle.CodCia = s-CodCia
        Detalle.CodMat = cValue.
    /* Unidad */
    t-column = 4.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.UndBas = cValue.
    /* Precio Base */
    t-column = 8.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.PreBas = ROUND(DECIMAL(cValue),4) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = t-Row
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el valor del PRECIO BASE: " + cValue.
        DELETE Detalle.
        NEXT.
    END.
    /* Canal */
    t-column = 10.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.Canal = ENTRY(1, cValue, " - ").
    /* Factor Canal */
    t-column = 11.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.FactorCanal = ROUND(DECIMAL(cValue),4) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = t-Row
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el valor decimal en el FACTOR CANAL: " + cValue.
        DELETE Detalle.
        NEXT.
    END.
    /* Grupo */
    t-column = 13.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.Grupo = ENTRY(1, cValue, " - ").
    /* Factor Grupo */
    t-column = 14.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        Detalle.FactorGrupo = ROUND(DECIMAL(cValue),4) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = t-Row
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el valor decimal en el FACTOR GRUPO: " + cValue.
        DELETE Detalle.
        NEXT.
    END.
END.
lCerrarAlTerminar = YES.
lMensajeAlTerminar = NO.
{lib/excel-close-file.i}

/* Depuramos Detalle */
RUN Valida-Detalle.
IF CAN-FIND(FIRST T-Errores NO-LOCK) THEN DO:
    RUN pri/d-errores.w (INPUT TABLE T-Errores).
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Detalle W-Win 
PROCEDURE Valida-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {pri/i-valida-detalle.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

