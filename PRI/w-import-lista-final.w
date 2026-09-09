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

DEF TEMP-TABLE T-Precios
    FIELD Fila   AS INTE
    FIELD CodMat LIKE prilistapreciostemp.CodMat 
    FIELD Canal LIKE prilistapreciostemp.Canal 
    FIELD Grupo LIKE prilistapreciostemp.Grupo 
    FIELD PreUni LIKE prilistapreciostemp.PreUni 
    FIELD PreGrupo LIKE prilistapreciostemp.PreGrupo
    FIELD FactorGrupo LIKE prilistapreciostemp.FactorGrupo.

DEF TEMP-TABLE T-Resumen
    FIELD CodMat LIKE prilistapreciostemp.CodMat.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-11 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-import-lista-final AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-11 
     LABEL "IMPORTAR Y VALIDAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 90 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-11 AT ROW 1.27 COL 2 WIDGET-ID 2
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
         TITLE              = "IMPORTAR LISTA DE PRECIOS FINAL"
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
ON END-ERROR OF W-Win /* IMPORTAR LISTA DE PRECIOS FINAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR LISTA DE PRECIOS FINAL */
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
             INPUT  'PRI/b-import-lista-final.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-import-lista-final ).
       RUN set-position IN h_b-import-lista-final ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-import-lista-final ( 23.69 , 188.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-import-lista-final ,
             BUTTON-11:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
PROCEDURE Carga-Lista PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Margen AS DEC NO-UNDO.
DEF VAR F-FACTOR AS DEC NO-UNDO.
DEF VAR x-CtoTot AS DEC NO-UNDO.

DEF BUFFER B-MATG FOR Almmmatg.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro limpiamos todos los productos relacionados con el jefe de línea */
    FOR EACH Detalle NO-LOCK, FIRST Almmmatg OF Detalle NO-LOCK
        BREAK BY Almmmatg.CodFam BY Almmmatg.SubFam:
        IF FIRST-OF(Almmmatg.CodFam) OR FIRST-OF(Almmmatg.SubFam) THEN DO:
            FOR EACH PriListaPrecios EXCLUSIVE-LOCK,
                FIRST B-MATG OF PriListaPrecios WHERE B-MATG.CodFam = Almmmatg.CodFam AND
                B-MATG.SubFam = Almmmatg.SubFam NO-LOCK
                ON ERROR UNDO, THROW:
                DELETE PriListaPrecios.
            END.
        END.
    END.
    /* 2do. actualizamos la lista temporal */
    FOR EACH Detalle NO-LOCK, FIRST Almmmatg OF Detalle NO-LOCK:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CARGANDO: " + Detalle.CodMat.
        CREATE PriListaPrecios.
        BUFFER-COPY Detalle TO PriListaPrecios
            ASSIGN
            prilistaprecios.FchCreacion = TODAY
            prilistaprecios.HoraCreacion = STRING(TIME, 'HH:MM:SS')
            prilistaprecios.UsrCreacion = s-user-id
            NO-ERROR.
        /* Datos Adicionales */
        ASSIGN
            prilistaprecios.MrgUti-A = 0
            prilistaprecios.MrgUti-B = 0
            prilistaprecios.MrgUti-C = 0
            prilistaprecios.Precio-A = 0
            prilistaprecios.Precio-B = 0
            prilistaprecios.Precio-C = 0.
        ASSIGN
            prilistaprecios.UndA = Almmmatg.UndA 
            prilistaprecios.UndB = Almmmatg.UndB 
            prilistaprecios.UndC = Almmmatg.UndC.
        x-Margen = 0.
        IF prilistaprecios.CtoTot <> 0 THEN
            x-Margen = ROUND((prilistaprecios.PreUni - prilistaprecios.CtoTot) / prilistaprecios.CtoTot * 100, 6).
        ASSIGN
            prilistaprecios.MrgUti = x-Margen.
        x-Margen = 0.
        F-FACTOR = 1.
        x-CtoTot = prilistaprecios.CtoTot.
        /****   Busca el Factor de conversion   ****/
        IF x-CtoTot > 0 AND prilistaprecios.UndA > "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = prilistaprecios.UndBas
                AND  Almtconv.Codalter = prilistaprecios.UndA
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-CtoTot = prilistaprecios.CtoTot * F-FACTOR.
                prilistaprecios.Precio-A = prilistaprecios.PreUni * F-FACTOR.
                x-Margen = (prilistaprecios.Precio-A - x-CtoTot) / x-CtoTot * 100.
            END.
        END.
        ASSIGN
            prilistaprecios.MrgUti-B = x-Margen.
        x-Margen = 0.
        F-FACTOR = 1.
        x-CtoTot = prilistaprecios.CtoTot.
        /****   Busca el Factor de conversion   ****/
        IF x-CToTot > 0 AND prilistaprecios.UndB > "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = prilistaprecios.UndBas
                AND  Almtconv.Codalter = prilistaprecios.UndB
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-CtoTot = prilistaprecios.CtoTot * F-FACTOR.
                prilistaprecios.Precio-B = prilistaprecios.PreUni * F-FACTOR.
                x-Margen = (prilistaprecios.Precio-B - x-CtoTot) / x-CtoTot * 100.
            END.
        END.
        ASSIGN
            prilistaprecios.MrgUti-B = x-Margen.
        x-Margen = 0.
        F-FACTOR = 1.
        x-CtoTot = prilistaprecios.CtoTot.
        /****   Busca el Factor de conversion   ****/
        IF x-CtoTot > 0 AND prilistaprecios.UndC > "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = prilistaprecios.UndBas
                AND  Almtconv.Codalter = prilistaprecios.UndC
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-CtoTot = prilistaprecios.CtoTot * F-FACTOR.
                prilistaprecios.Precio-C = prilistaprecios.PreUni * F-FACTOR.
                x-Margen = (prilistaprecios.Precio-C - x-CtoTot) / x-CtoTot * 100.
            END.
        END.
        ASSIGN
            prilistaprecios.MrgUti-C = x-Margen.
    END.
END.
RELEASE PriListaPrecios.
RUN dispatch IN h_b-import-lista-final ('open-query':U).

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
  ENABLE BUTTON-11 
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
RUN Valida-Canal-Grupo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Canal-Grupo W-Win 
PROCEDURE Valida-Canal-Grupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-Precios.
EMPTY TEMP-TABLE t-Resumen.
/*EMPTY TEMP-TABLE T-Errores.*/

DEF VAR LocalFila AS INT NO-UNDO.

/* Cargamos Temporales */
SESSION:SET-WAIT-STATE('GENERAL').
LocalFila = 0.
FOR EACH Detalle:
    LocalFila = LocalFila + 1.
    FIND T-Resumen WHERE T-Resumen.codmat = Detalle.CodMat NO-ERROR.
    IF NOT AVAILABLE T-Resumen THEN CREATE T-Resumen.
    T-Resumen.CodMat = Detalle.CodMat.
    FIND PriCanal WHERE pricanal.CodCia = s-CodCia AND
        pricanal.Canal = Detalle.Canal 
        NO-LOCK.
    FIND PriCanalGrupo WHERE pricanalgrupo.CodCia = s-CodCia AND
        pricanalgrupo.Canal = Detalle.Canal AND
        pricanalgrupo.Grupo = Detalle.Grupo
        NO-LOCK.
    CREATE T-Precios.
    ASSIGN
        T-Precios.Fila = LocalFila
        T-Precios.CodMat = Detalle.CodMat 
        T-Precios.Canal = Detalle.Canal 
        T-Precios.Grupo = Detalle.Grupo 
        T-Precios.PreUni = Detalle.PreUni 
        T-Precios.PreGrupo = Detalle.PreGrupo
        T-Precios.FactorGrupo = (pricanal.Factor / 100) * (pricanalgrupo.Factor / 100).
END.
/* Validamos */
DEF VAR x-PreGrupo LIKE Detalle.PreGrupo NO-UNDO.
RLOOP:
FOR EACH T-Resumen NO-LOCK:
    x-PreGrupo = 0.
    FOR EACH T-Precios NO-LOCK WHERE T-Precios.CodMat = T-Resumen.CodMat
        BREAK BY T-Precios.CodMat BY T-Precios.FactorGrupo DESCENDING:
        IF FIRST-OF(T-Precios.CodMat) THEN x-PreGrupo = T-Precios.PreGrupo.
        IF x-PreGrupo < T-Precios.PreGrupo THEN DO:
            CREATE T-Errores.
            ASSIGN
                T-Errores.Fila   = T-Precios.Fila
                T-Errores.CodMat = T-Resumen.CodMat
                T-Errores.Glosa  = "Error Precio entre Canales de Negociación".
        END.
        x-PreGrupo = T-Precios.PreGrupo.
    END.
END.
SESSION:SET-WAIT-STATE('').

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

