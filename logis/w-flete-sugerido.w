&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER Destino FOR almtabla.
DEFINE BUFFER Origen FOR almtabla.
DEFINE TEMP-TABLE t-flete_detallado_hr NO-UNDO LIKE flete_detallado_hr.
DEFINE TEMP-TABLE t-flete_resumen_hr NO-UNDO LIKE flete_resumen_hr.
DEFINE TEMP-TABLE t-flete_sugerido NO-UNDO LIKE flete_sugerido.



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
DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-Tabla AS CHAR INIT 'FLETE_HR'.
DEF NEW SHARED VAR s-Codigo AS CHAR INIT 'DIAS'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-flete_sugerido Origen Destino

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 t-flete_sugerido.Origen ~
Origen.Nombre t-flete_sugerido.Destino Destino.Nombre ~
t-flete_sugerido.Flete_Unitario_Peso ~
t-flete_sugerido.Flete_Unitario_Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH t-flete_sugerido NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = t-flete_sugerido.Origen ~
      AND Origen.Tabla = "ZG" OUTER-JOIN NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = t-flete_sugerido.Destino ~
      AND Destino.Tabla = "ZG" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH t-flete_sugerido NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = t-flete_sugerido.Origen ~
      AND Origen.Tabla = "ZG" OUTER-JOIN NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = t-flete_sugerido.Destino ~
      AND Destino.Tabla = "ZG" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 t-flete_sugerido Origen Destino
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 t-flete_sugerido
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Origen
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-3 Destino


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON_Calcular BUTTON_Enviar BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Dias 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Calcular 
     LABEL "CALCULAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Enviar 
     LABEL "ENVIAR AL SUPERVISOR" 
     SIZE 22 BY 1.12.

DEFINE VARIABLE FILL-IN_Dias AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Días a considerar para el cálculo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      t-flete_sugerido, 
      Origen
    FIELDS(Origen.Nombre), 
      Destino
    FIELDS(Destino.Nombre) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      t-flete_sugerido.Origen FORMAT "x(8)":U
      Origen.Nombre FORMAT "x(40)":U WIDTH 29.14
      t-flete_sugerido.Destino FORMAT "x(8)":U
      Destino.Nombre FORMAT "x(40)":U WIDTH 29.14
      t-flete_sugerido.Flete_Unitario_Peso COLUMN-LABEL "Flete Unitario x kg!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
      t-flete_sugerido.Flete_Unitario_Volumen COLUMN-LABEL "Flete Unitario x m3!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 12.38
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Calcular AT ROW 1.27 COL 50 WIDGET-ID 4
     BUTTON_Enviar AT ROW 1.27 COL 66 WIDGET-ID 6
     FILL-IN_Dias AT ROW 1.54 COL 29 COLON-ALIGNED WIDGET-ID 2
     BROWSE-3 AT ROW 2.62 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.29 BY 15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Destino B "?" ? INTEGRAL almtabla
      TABLE: Origen B "?" ? INTEGRAL almtabla
      TABLE: t-flete_detallado_hr T "?" NO-UNDO INTEGRAL flete_detallado_hr
      TABLE: t-flete_resumen_hr T "?" NO-UNDO INTEGRAL flete_resumen_hr
      TABLE: t-flete_sugerido T "?" NO-UNDO INTEGRAL flete_sugerido
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "FLETE UNITARIO SUGERIDO"
         HEIGHT             = 15
         WIDTH              = 110.29
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
/* BROWSE-TAB BROWSE-3 FILL-IN_Dias F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_Dias IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.t-flete_sugerido,Origen WHERE Temp-Tables.t-flete_sugerido ...,Destino WHERE Temp-Tables.t-flete_sugerido ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER USED, FIRST OUTER USED"
     _JoinCode[2]      = "Origen.Codigo = Temp-Tables.t-flete_sugerido.Origen"
     _Where[2]         = "Origen.Tabla = ""ZG"""
     _JoinCode[3]      = "Destino.Codigo = Temp-Tables.t-flete_sugerido.Destino"
     _Where[3]         = "Destino.Tabla = ""ZG"""
     _FldNameList[1]   = Temp-Tables.t-flete_sugerido.Origen
     _FldNameList[2]   > Temp-Tables.Origen.Nombre
"Origen.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "29.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.t-flete_sugerido.Destino
     _FldNameList[4]   > Temp-Tables.Destino.Nombre
"Destino.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "29.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-flete_sugerido.Flete_Unitario_Peso
"t-flete_sugerido.Flete_Unitario_Peso" "Flete Unitario x kg!S/ con IGV" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-flete_sugerido.Flete_Unitario_Volumen
"t-flete_sugerido.Flete_Unitario_Volumen" "Flete Unitario x m3!S/ con IGV" ? "decimal" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* FLETE UNITARIO SUGERIDO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* FLETE UNITARIO SUGERIDO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Calcular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Calcular W-Win
ON CHOOSE OF BUTTON_Calcular IN FRAME F-Main /* CALCULAR */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Enviar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Enviar W-Win
ON CHOOSE OF BUTTON_Enviar IN FRAME F-Main /* ENVIAR AL SUPERVISOR */
DO:
    IF CAN-FIND(FIRST flete_sugerido WHERE flete_sugerido.CodCia = s-CodCia
                AND flete_sugerido.FlgEst = "P" NO-LOCK)
        THEN DO:
        MESSAGE 'NO se puede enviar al Supervisor miestras no Apruebe o Rechaze una solicituda anterior'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
  MESSAGE 'Procedemos a enviar al Supervisor?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Envio-Supervisor (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-flete_sugerido.
EMPTY TEMP-TABLE t-flete_resumen_hr.
EMPTY TEMP-TABLE t-flete_detallado_hr.

/* Por defecto se tomará la fecha del intervalo
Si ya ha habido un cálculo anterior se toma la fecha siguiente siempre y cuando
sea menor al intervalo */

DEF VAR x-FchSal AS DATE NO-UNDO.
DEF VAR x-Promedio AS LOG NO-UNDO.

/* Barremos las Zonas de Despacho */
/* Por cada origen */
FOR EACH Origen NO-LOCK WHERE Origen.Tabla = "ZG":
    /* Por cada destino */
    FOR EACH Destino NO-LOCK WHERE Destino.Tabla = "ZG":
        /* Buscamos última fecha de actualización */
        x-Promedio = NO.
        x-FchSal = ADD-INTERVAL(TODAY, (-1 * FILL-IN_Dias), 'days').    /* Por defecto */
        FIND LAST flete_sugerido USE-INDEX Idx02 WHERE flete_sugerido.CodCia = s-CodCia
            AND flete_sugerido.FlgEst = "A"
            AND flete_sugerido.Origen = Origen.Codigo
            AND flete_sugerido.Destino = Destino.Codigo
            NO-LOCK NO-ERROR.
        IF AVAILABLE flete_sugerido THEN 
            ASSIGN 
                x-Promedio = YES
                x-FchSal = MAXIMUM(x-FchSal,flete_sugerido.FchAprobacion) + 1.
        /*MESSAGE x-fchsal.*/
        /* Calculamos */
        FOR EACH flete_resumen_hr NO-LOCK WHERE flete_resumen_hr.CodCia = s-CodCia
            AND flete_resumen.Origen = Origen.Codigo
            AND flete_resumen.Destino = Destino.Codigo
            AND flete_resumen_hr.FchSal >= x-FchSal:
            FIND FIRST t-flete_sugerido WHERE t-flete_sugerido.CodCia = s-Codcia
                AND t-flete_sugerido.Origen = flete_resumen_hr.Origen
                AND t-flete_sugerido.Destino = flete_resumen_hr.Destino
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE t-flete_sugerido THEN CREATE t-flete_sugerido.
            ASSIGN
                t-flete_sugerido.CodCia = s-Codcia
                t-flete_sugerido.Origen = flete_resumen_hr.Origen
                t-flete_sugerido.Destino = flete_resumen_hr.Destino.
            CASE flete_resumen_hr.Tipo:
                WHEN "Peso" THEN DO:
                    ASSIGN
                        t-flete_sugerido.Peso = t-flete_sugerido.Peso + flete_resumen_hr.Cantidad
                        t-flete_sugerido.Flete_Total_Peso = t-flete_sugerido.Flete_Total_Peso + flete_resumen_hr.Importe
                        t-flete_sugerido.Flete_Unitario_Peso = t-flete_sugerido.Flete_Total_Peso / t-flete_sugerido.Peso
                        t-flete_sugerido.Flete_Promedio_Peso = t-flete_sugerido.Flete_Total_Peso / t-flete_sugerido.Peso.
                END.
                WHEN "Volumen" THEN DO:
                    ASSIGN
                        t-flete_sugerido.Volumen = t-flete_sugerido.Volumen + flete_resumen_hr.Cantidad
                        t-flete_sugerido.Flete_Total_Volumen = t-flete_sugerido.Flete_Total_Volumen + flete_resumen_hr.Importe
                        t-flete_sugerido.Flete_Unitario_Volumen = t-flete_sugerido.Flete_Total_Volumen / t-flete_sugerido.Volumen
                        t-flete_sugerido.Flete_Promedio_Volumen = t-flete_sugerido.Flete_Total_Volumen / t-flete_sugerido.Volumen.
                END.
            END CASE.
            CREATE t-flete_resumen_hr.
            BUFFER-COPY flete_resumen_hr TO t-flete_resumen_hr.
            FOR EACH flete_detallado_hr NO-LOCK WHERE flete_detallado_hr.CodCia = s-codcia
                AND flete_detallado_hr.FchSal = flete_resumen_hr.FchSal 
                AND flete_detallado_hr.Origen = flete_resumen_hr.Origen 
                AND flete_detallado_hr.Destino = flete_resumen_hr.Destino:
                CREATE t-flete_detallado_hr.
                BUFFER-COPY flete_detallado_hr TO t-flete_detallado_hr.
            END.
        END.    /* EACH flete_resumen_hr */
        FIND FIRST t-flete_sugerido WHERE t-flete_sugerido.CodCia = s-Codcia
            AND t-flete_sugerido.Origen = Origen.Codigo
            AND t-flete_sugerido.Destino = Destino.Codigo
            NO-ERROR.
        IF AVAILABLE t-flete_sugerido AND x-Promedio = YES THEN DO:
            /* Promediamos el Valor del Flete ACTUAL con el Promedio Calculado */
            t-flete_sugerido.Flete_Unitario_Peso = (t-flete_sugerido.Flete_Promedio_Peso + flete_sugerido.Flete_Sugerido_Peso) / 2.
            t-flete_sugerido.Flete_Unitario_Volumen = (t-flete_sugerido.Flete_Promedio_Volumen + flete_sugerido.Flete_Sugerido_Volumen) / 2.
        END.
    END.    /* EACH Destino */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Old W-Win 
PROCEDURE Carga-Temporal-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-flete_sugerido.
EMPTY TEMP-TABLE t-flete_resumen_hr.
EMPTY TEMP-TABLE t-flete_detallado_hr.

FOR EACH flete_resumen_hr NO-LOCK WHERE flete_resumen_hr.CodCia = s-CodCia
    AND flete_resumen_hr.FchSal >= ADD-INTERVAL(TODAY, (-1 * FILL-IN_Dias), 'days'):
    FIND FIRST t-flete_sugerido WHERE t-flete_sugerido.CodCia = s-Codcia
        AND t-flete_sugerido.Origen = flete_resumen_hr.Origen
        AND t-flete_sugerido.Destino = flete_resumen_hr.Destino
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-flete_sugerido THEN CREATE t-flete_sugerido.
    ASSIGN
        t-flete_sugerido.CodCia = s-Codcia
        t-flete_sugerido.Origen = flete_resumen_hr.Origen
        t-flete_sugerido.Destino = flete_resumen_hr.Destino.
    CASE flete_resumen_hr.Tipo:
        WHEN "Peso" THEN DO:
            ASSIGN
                t-flete_sugerido.Peso = t-flete_sugerido.Peso + flete_resumen_hr.Cantidad
                t-flete_sugerido.Flete_Total_Peso = t-flete_sugerido.Flete_Total_Peso + flete_resumen_hr.Importe
                t-flete_sugerido.Flete_Unitario_Peso = t-flete_sugerido.Flete_Total_Peso / t-flete_sugerido.Peso.
        END.
        WHEN "Volumen" THEN DO:
            ASSIGN
                t-flete_sugerido.Volumen = t-flete_sugerido.Volumen + flete_resumen_hr.Cantidad
                t-flete_sugerido.Flete_Total_Volumen = t-flete_sugerido.Flete_Total_Volumen + flete_resumen_hr.Importe
                t-flete_sugerido.Flete_Unitario_Volumen = t-flete_sugerido.Flete_Total_Volumen / t-flete_sugerido.Volumen.
        END.
    END CASE.
    CREATE t-flete_resumen_hr.
    BUFFER-COPY flete_resumen_hr TO t-flete_resumen_hr.
    FOR EACH flete_detallado_hr NO-LOCK WHERE flete_detallado_hr.CodCia = s-codcia
        AND flete_detallado_hr.FchSal = flete_resumen_hr.FchSal 
        AND flete_detallado_hr.Origen = flete_resumen_hr.Origen 
        AND flete_detallado_hr.Destino = flete_resumen_hr.Destino:
        CREATE t-flete_detallado_hr.
        BUFFER-COPY flete_detallado_hr TO t-flete_detallado_hr.
    END.
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
  DISPLAY FILL-IN_Dias 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON_Calcular BUTTON_Enviar BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envio-Supervisor W-Win 
PROCEDURE Envio-Supervisor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-NumControl AS INT64 NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Numeramos los registros relacionados */
    x-NumControl = NEXT-VALUE(flete_sugerido_control).
    FOR EACH t-flete_sugerido EXCLUSIVE-LOCK:
        CREATE flete_sugerido.
        ASSIGN
            flete_sugerido.CodCia = s-CodCia
            flete_sugerido.FlgEst = "P"                             /* Por Aprobar */
            flete_sugerido.Origen = t-flete_sugerido.Origen 
            flete_sugerido.Destino = t-flete_sugerido.Destino 
            flete_sugerido.Peso = t-flete_sugerido.Peso 
            flete_sugerido.Volumen = t-flete_sugerido.Volumen
            flete_sugerido.Flete_Total_Peso = t-flete_sugerido.Flete_Total_Peso 
            flete_sugerido.Flete_Total_Volumen = t-flete_sugerido.Flete_Total_Volumen 
            flete_sugerido.Flete_Unitario_Peso = t-flete_sugerido.Flete_Unitario_Peso 
            flete_sugerido.Flete_Unitario_Volumen = t-flete_sugerido.Flete_Unitario_Volumen 
            flete_sugerido.FchCreacion = TODAY
            flete_sugerido.HoraCreacion = STRING(TIME,'HH:MM:SS')
            flete_sugerido.UsrCreacion = s-user-id
            flete_sugerido.Flete_Sugerido_Peso = t-flete_sugerido.Flete_Unitario_Peso 
            flete_sugerido.Flete_Sugerido_Volumen = t-flete_sugerido.Flete_Unitario_Volumen 
            flete_sugerido.NumControl = x-NumControl
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            flete_sugerido.Flete_Promedio_Peso = t-flete_sugerido.Flete_Promedio_Peso 
            flete_sugerido.Flete_Promedio_Volumen = t-flete_sugerido.Flete_Promedio_Volumen.
    END.
    FOR EACH t-flete_resumen_hr NO-LOCK , 
        FIRST flete_resumen_hr EXCLUSIVE-LOCK WHERE flete_resumen_hr.CodCia = s-codcia
        AND flete_resumen_hr.FchSal = t-flete_resumen_hr.FchSal
        AND flete_resumen_hr.Origen = t-flete_resumen_hr.Origen
        AND flete_resumen_hr.Destino = t-flete_resumen_hr.Destino
        AND flete_resumen_hr.Tipo = t-flete_resumen_hr.Tipo:
        ASSIGN
            flete_resumen_hr.NumControl = x-NumControl.
    END.
    FOR EACH t-flete_detallado_hr NO-LOCK , 
        FIRST flete_detallado_hr EXCLUSIVE-LOCK WHERE flete_detallado_hr.CodCia = s-codcia
        AND flete_detallado_hr.Origen = t-flete_detallado_hr.Origen
        AND flete_detallado_hr.CodDoc = t-flete_detallado_hr.CodDoc
        AND flete_detallado_hr.NroDoc = t-flete_detallado_hr.NroDoc
        AND flete_detallado_hr.Tipo = t-flete_detallado_hr.Tipo:
        ASSIGN
            flete_detallado_hr.NumControl = x-NumControl.
    END.
END.
IF AVAILABLE flete_sugerido THEN RELEASE flete_sugerido.
EMPTY TEMP-TABLE t-flete_sugerido.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia
      AND FacTabla.Tabla = s-Tabla
      AND FacTabla.Codigo = s-Codigo
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN FILL-IN_Dias = FacTabla.Valor[1].

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-flete_sugerido"}
  {src/adm/template/snd-list.i "Origen"}
  {src/adm/template/snd-list.i "Destino"}

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

