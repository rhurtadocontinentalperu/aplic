&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-DI-RutaC NO-UNDO LIKE DI-RutaC
       FIELD CuentaODS AS INT
       FIELD CuentaClientes AS INT
       FIELD Bultos AS INT.
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi
       FIELD Estado AS CHAR
       FIELD Bultos AS INT
       INDEX IDX00 AS PRIMARY coddoc nroped codref nroref.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-Task-No AS INT NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-3 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
BUTTON_FILTRAR COMBO-BOX_CodRef FILL-IN_NroRef BUTTON_LIMPIAR ~
FILL-IN_NroHPK BUTTON-18 TOGGLE_Solo_Pendientes 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
COMBO-BOX_CodRef FILL-IN_NroRef FILL-IN_NroHPK TOGGLE_Solo_Pendientes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPicador W-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-consulta-general-phr-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consulta-general-phr-det AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-18 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 18" 
     SIZE 7 BY 1.88 TOOLTIP "Impresión Total (Almacén)".

DEFINE BUTTON BUTTON_FILTRAR 
     LABEL "APLICAR FILTROS" 
     SIZE 19 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_LIMPIAR 
     LABEL "LIMPIAR FILTROS" 
     SIZE 19 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX_CodRef AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Pedido Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "ORDEN DE DESPACHO","O/D",
                     "ORDEN DE TRANSFERENCIA","OTR"
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Generadas desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroHPK AS CHARACTER FORMAT "X(15)":U 
     LABEL "# de HPK" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroRef AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro." 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 3.5.

DEFINE VARIABLE TOGGLE_Solo_Pendientes AS LOGICAL INITIAL no 
     LABEL "Solo Pendientes por Trabajar" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchDoc-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchDoc-2 AT ROW 1.27 COL 37 COLON-ALIGNED WIDGET-ID 14
     BUTTON_FILTRAR AT ROW 1.27 COL 71 WIDGET-ID 22
     COMBO-BOX_CodRef AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_NroRef AT ROW 2.35 COL 52 COLON-ALIGNED WIDGET-ID 18
     BUTTON_LIMPIAR AT ROW 2.35 COL 71 WIDGET-ID 24
     FILL-IN_NroHPK AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 20
     BUTTON-18 AT ROW 4.5 COL 104 WIDGET-ID 26
     TOGGLE_Solo_Pendientes AT ROW 6.38 COL 104 WIDGET-ID 28
     RECT-3 AT ROW 1 COL 2 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 25.58
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD CuentaODS AS INT
          FIELD CuentaClientes AS INT
          FIELD Bultos AS INT
      END-FIELDS.
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          FIELD Estado AS CHAR
          FIELD Bultos AS INT
          INDEX IDX00 AS PRIMARY coddoc nroped codref nroref
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA GENERAL DE PHR"
         HEIGHT             = 26.15
         WIDTH              = 185
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
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA GENERAL DE PHR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA GENERAL DE PHR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 W-Win
ON CHOOSE OF BUTTON-18 IN FRAME F-Main /* Button 18 */
DO:
  MESSAGE 'Procedemos con la impresión?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.

  ASSIGN
      TOGGLE_Solo_Pendientes.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Reporte.
  SESSION:SET-WAIT-STATE('').
  GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
  RB-REPORT-NAME     = "Consulta General de Pedidos".
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_FILTRAR W-Win
ON CHOOSE OF BUTTON_FILTRAR IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN COMBO-BOX_CodRef FILL-IN_NroHPK FILL-IN_NroRef FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
  ASSIGN TOGGLE_Solo_Pendientes.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  RUN Importa-Temporal IN h_b-consulta-general-phr-cab
    ( INPUT TABLE t-DI-RutaC).
  RUN Importa-Temporal IN h_b-consulta-general-phr-det
    ( INPUT TABLE t-FacCPedi).
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_LIMPIAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_LIMPIAR W-Win
ON CHOOSE OF BUTTON_LIMPIAR IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
  ASSIGN
      FILL-IN-FchDoc-1 = ?
      FILL-IN-FchDoc-2 = ?
      FILL-IN_NroRef = ''.
  FILL-IN-FchDoc-1 = ADD-INTERVAL (TODAY, -15, 'days').
  FILL-IN-FchDoc-2 = TODAY.
  COMBO-BOX_CodRef = "O/D".
  
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN_NroRef COMBO-BOX_CodRef WITH FRAME {&FRAME-NAME}.
  APPLY 'CHOOSE':U TO BUTTON_FILTRAR.
  
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
             INPUT  'aplic/logis/b-consulta-general-phr-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-general-phr-cab ).
       RUN set-position IN h_b-consulta-general-phr-cab ( 4.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-general-phr-cab ( 6.69 , 101.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-consulta-general-phr-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-general-phr-det ).
       RUN set-position IN h_b-consulta-general-phr-det ( 11.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-general-phr-det ( 14.54 , 183.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-consulta-general-phr-det. */
       RUN add-link IN adm-broker-hdl ( h_b-consulta-general-phr-cab , 'Record':U , h_b-consulta-general-phr-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-general-phr-cab ,
             FILL-IN_NroHPK:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-general-phr-det ,
             TOGGLE_Solo_Pendientes:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte W-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

s-Task-No = 0.
FOR EACH t-Di-RutaC NO-LOCK, 
    EACH t-Faccpedi WHERE t-FacCPedi.CodOrigen = t-DI-RutaC.CodDoc AND t-FacCPedi.NroOrigen = t-DI-RutaC.NroDoc NO-LOCK:
    IF TOGGLE_Solo_Pendientes = YES THEN DO:
        IF LOOKUP(SUBSTRING(t-Faccpedi.Libre_c02,1,2), "PK,CK") = 0 THEN NEXT.
        IF t-Faccpedi.Libre_c02 = "CK_DI" THEN NEXT.
    END.

    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.Llave-C = t-Di-RutaC.NroDoc + " " + t-DI-RutaC.Observ
        .
    ASSIGN
        w-report.Campo-C[1] = t-Faccpedi.codref
        w-report.Campo-C[2] = t-Faccpedi.nroref
        w-report.Campo-C[9] = t-Faccpedi.coddoc
        w-report.Campo-C[10] = t-Faccpedi.nroped
        w-report.Campo-C[11] = t-Faccpedi.NomCli
        .
    ASSIGN
        w-report.Campo-F[1] = t-Faccpedi.Items
        w-report.Campo-F[2] = t-Faccpedi.Peso
        w-report.Campo-F[3] = t-Faccpedi.Volumen
        .
    ASSIGN
        w-report.Campo-D[1] = t-Faccpedi.fchent
         w-report.Campo-C[3] = t-Faccpedi.estado
        .
    /* 20/08/2025: Datos del tracking HPK */
    /*w-report.Campo-C[4] = t-FacCPedi.Libre_c01. */
    w-report.Campo-C[4] = STRING(t-Faccpedi.FchPed, '99/99/9999') + ' ' + STRING(t-Faccpedi.Hora).

    FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia
            AND LogTrkDocs.CodDoc = t-Faccpedi.codref
            AND LogTrkDocs.NroDoc = t-Faccpedi.nroref
            AND LogTrkDocs.Clave = "TRCKHPK",
        FIRST Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = s-codcia AND
            Vtacdocu.coddiv = s-coddiv AND
            Vtacdocu.codped = t-Faccpedi.codref AND
            Vtacdocu.nroped = t-Faccpedi.nroref,
        EACH TabTrkDocs NO-LOCK WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia
            AND TabTrkDocs.Clave = LogTrkDocs.Clave
            AND TabTrkDocs.Codigo = LogTrkDocs.Codigo
        BY LogTrkDocs.Fecha DESC:
/*         IF LogTrkDocs.Codigo = "PK_SEM" THEN   /* MRC 23/11/2020 */                       */
/*             ASSIGN w-report.Campo-C[4] = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS'). */
        ASSIGN
            w-report.Campo-C[5] =  VtaCDocu.CodTer      /* TIPO */
            w-report.Campo-C[6] = fPicador(VtaCDocu.UsrSac)
            .
        FIND FIRST ChkTareas WHERE ChkTareas.CodCia = s-CodCia
            AND ChkTareas.CodDiv = s-CodDiv
            AND ChkTareas.CodDoc = t-Faccpedi.codref
            AND ChkTareas.NroPed = t-Faccpedi.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE ChkTareas THEN w-report.Campo-C[7] = ChkTareas.Mesa.
        ELSE w-report.Campo-C[7] = ''.

        LEAVE.
    END.
    /* Bultos por HPK */
    ASSIGN
        w-report.Campo-F[4] = t-Faccpedi.bultos.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cargamos cabecera
------------------------------------------------------------------------------*/


EMPTY TEMP-TABLE t-DI-RutaC.
EMPTY TEMP-TABLE t-Faccpedi.

DEF VAR x-Ok AS LOG NO-UNDO.
DEF VAR x-CuentaODS AS INTE NO-UNDO.
DEF VAR x-CuentaClientes AS INTE NO-UNDO.
DEF VAR x-Bultos AS INTE NO-UNDO.
DEF VAR lx-Bultos AS INTE NO-UNDO.
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.

FOR EACH Di-RutaC NO-LOCK WHERE Di-RutaC.codcia = s-codcia AND
    Di-RutaC.coddoc = "PHR" AND
    Di-RutaC.fchdoc >= FILL-IN-FchDoc-1 AND
    Di-RutaC.fchdoc <= FILL-IN-FchDoc-2 AND
    Di-RutaC.coddiv = s-coddiv AND
    Di-RutaC.flgest BEGINS "P":
    /* ********************************************************************************* */
    /* FILTROS */
    /* ********************************************************************************* */
    /* Debe tener al menos 1 registro */
    IF NOT CAN-FIND(FIRST Di-RutaD OF Di-RutaC NO-LOCK) THEN NEXT.

    x-Ok = YES.
    CASE TRUE:
        WHEN FILL-IN_NroRef > "" AND TRUE <> (FILL-IN_NroHPK > "") THEN DO:
            x-Ok = NO.
            FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.codref = COMBO-BOX_CodRef AND
                Di-RutaD.nroref = FILL-IN_NroRef:
                x-Ok = YES.
                LEAVE.
            END.
        END.
        WHEN TRUE <> (FILL-IN_NroRef > "") AND FILL-IN_NroHPK > ""  THEN DO:
            x-Ok = NO.
            FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
                EACH Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = s-codcia AND
                Vtacdocu.codped = "HPK" AND
                Vtacdocu.nroped = FILL-IN_NroHPK AND
                Vtacdocu.codref = Di-RutaD.codref AND
                Vtacdocu.nroref = Di-RutaD.nroref:
                IF Vtacdocu.flgest = "A" THEN NEXT.
                x-Ok = YES.
                LEAVE.
            END.
        END.
        WHEN FILL-IN_NroRef > "" AND FILL-IN_NroHPK > "" THEN DO:
            x-Ok = NO.
            FIND FIRST Di-RutaD OF Di-RutaC WHERE Di-RutaD.codref = COMBO-BOX_CodRef AND
                Di-RutaD.nroref = FILL-IN_NroRef NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Di-RutaD THEN NEXT.
            FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND
                Vtacdocu.codped = "HPK" AND
                Vtacdocu.nroped = FILL-IN_NroHPK AND
                Vtacdocu.codref = Di-RutaD.codref AND
                Vtacdocu.nroref = Di-RutaD.nroref NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtacdocu THEN NEXT.
            x-Ok = YES.
        END.
    END CASE.

    IF x-Ok = NO THEN NEXT.
    /* ********************************************************************************* */
    /* Cargamos temporal */
    /* ********************************************************************************* */
    ASSIGN
        x-CuentaODS = 0
        x-CuentaClientes = 0
        x-Bultos = 0
        x-Clientes = "".
    CREATE t-DI-RutaC.
    BUFFER-COPY Di-RutaC TO t-DI-RutaC.
    /* Puede que una O/D u OTR NO tenga HPK */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK, 
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
            Faccpedi.coddoc = Di-RutaD.codref AND
            Faccpedi.nroped = Di-RutaD.nroref
        AND Faccpedi.flgest <> "C"      /* OJO 20/08/2025: Solicitado por Deysi Milian */
        :

        x-CuentaODS = x-CuentaODS + 1.
        IF TRUE <> (x-Clientes > '') THEN x-Clientes = Faccpedi.codcli.
        ELSE DO:
            IF INDEX(x-Clientes, Faccpedi.codcli) = 0 THEN DO:
                x-Clientes = x-Clientes + ',' + Faccpedi.codcli.
            END.
        END.
        lx-Bultos = 0.
        FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-codcia AND
            CcbCBult.CodDiv = s-coddiv AND
            CcbCBult.CodDoc = Faccpedi.coddoc AND
            CcbCBult.NroDoc = Faccpedi.nroped :
            x-Bultos = x-Bultos + CcbCBult.Bultos.
            lx-Bultos = lx-Bultos + CcbCBult.Bultos.
        END.

        IF CAN-FIND(FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND
                    Vtacdocu.codped = "HPK" AND
                    Vtacdocu.codref = Di-RutaD.codref AND
                    Vtacdocu.nroref = Di-RutaD.nroref AND
                    Vtacdocu.flgest <> "A" NO-LOCK)
            THEN DO:
            FOR EACH Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = s-codcia AND
                Vtacdocu.codped = "HPK" AND
                Vtacdocu.codref = Di-RutaD.codref AND
                Vtacdocu.nroref = Di-RutaD.nroref AND
                Vtacdocu.flgest <> "A":
                CREATE t-Faccpedi.
                BUFFER-COPY Faccpedi TO t-Faccpedi.
                ASSIGN
                    t-Faccpedi.codref = Vtacdocu.codped
                    t-Faccpedi.nroref = Vtacdocu.nroped
                    t-Faccpedi.codorigen = Di-RutaC.coddoc
                    t-Faccpedi.nroorigen = Di-RutaC.nrodoc.
                ASSIGN
                    t-FacCPedi.Items = Vtacdocu.Items
                    t-FacCPedi.Peso = Vtacdocu.Peso
                    t-FacCPedi.Volumen = Vtacdocu.Volumen.
/*                 ASSIGN                                                            */
/*                     t-FacCPedi.Estado = fEstado(Vtacdocu.codped,Vtacdocu.nroped). */
                /* ************************************************* */
                /* 20/08/2025: Necesitamos datos del tracking de HPK */
                DEF VAR pStatus AS CHAR NO-UNDO.
                t-FacCPedi.Estado = 'NO DEFINIDO'.
                FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-codcia AND
                        LogTrkDocs.CodDoc = Vtacdocu.codped AND
                        LogTrkDocs.NroDoc = Vtacdocu.nroped AND
                        LogTrkDocs.Clave = 'TRCKHPK'
                        BY LogTrkDocs.Orden DESC BY LogTrkDocs.Fecha DESC:
                    pStatus = LogTrkDocs.Codigo.
                    FIND FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = s-CodCia
                        AND TabTrkDocs.Clave = 'TRCKHPK'
                        AND TabTrkDocs.Codigo = pStatus NO-LOCK NO-ERROR.
                    IF AVAILABLE TabTrkDocs THEN DO:
                        t-FacCPedi.Estado = TabTrkDocs.NomCorto.
                        t-FacCPedi.Libre_C01 = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS').
                        t-FacCPedi.Libre_C02 = pStatus.
                        LEAVE.
                    END.
                END.
                /* ************************************************* */

                /* Bultos por HPK */
                lx-Bultos = 0.
                FOR EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = s-codcia AND
                    logisdchequeo.CodDiv = s-coddiv AND 
                    logisdchequeo.CodPed = Vtacdocu.codped AND
                    logisdchequeo.NroPed = Vtacdocu.nroped 
                    BREAK BY logisdchequeo.Etiqueta:
                    IF FIRST-OF(logisdchequeo.Etiqueta) THEN lx-Bultos = lx-Bultos + 1.
                END.
                ASSIGN
                    t-Faccpedi.Bultos = lx-Bultos.
            END.
        END.
        ELSE DO:
            CREATE t-Faccpedi.
            BUFFER-COPY Faccpedi EXCEPT Faccpedi.codref Faccpedi.nroref TO t-Faccpedi.
            ASSIGN
                t-Faccpedi.codorigen = Di-RutaC.coddoc
                t-Faccpedi.nroorigen = Di-RutaC.nrodoc
                t-FacCPedi.Bultos = lx-Bultos.
            RUN logis/p-logtrkdocs (INPUT t-Faccpedi.coddoc,
                                    INPUT t-Faccpedi.nroped,
                                    INPUT s-coddiv,
                                    OUTPUT x-Estado).
            ASSIGN
                t-Faccpedi.Estado = x-Estado.
        END.
    END.
    x-CuentaClientes = NUM-ENTRIES(x-Clientes).
    ASSIGN
        T-Di-RutaC.CuentaODS = x-CuentaODS
        T-Di-RutaC.CuentaClientes = x-CuentaClientes
        T-Di-RutaC.Bultos = x-Bultos.
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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 COMBO-BOX_CodRef FILL-IN_NroRef 
          FILL-IN_NroHPK TOGGLE_Solo_Pendientes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-3 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON_FILTRAR 
         COMBO-BOX_CodRef FILL-IN_NroRef BUTTON_LIMPIAR FILL-IN_NroHPK 
         BUTTON-18 TOGGLE_Solo_Pendientes 
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
  FILL-IN-FchDoc-1 = ADD-INTERVAL (TODAY, -15, 'days').
  FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY "ENTRY":U TO FILL-IN-FchDoc-1 IN FRAME {&FRAME-NAME}.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Status AS CHAR.
RUN gn/p-status-hpk(pCodDoc, pNroPed, OUTPUT x-Status).
RETURN x-Status.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPicador W-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni.p (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  RETURN pNombre.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

