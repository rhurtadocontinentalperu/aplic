&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-VtaDDocu NO-UNDO LIKE VtaDDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-Dni    AS CHAR NO-UNDO.

ASSIGN
    x-CodDoc = 'HPK'.

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
&Scoped-Define ENABLED-OBJECTS BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Picador FILL-IN_NomCli ~
FILL-IN_NroPed FILL-IN_CodMat FILL-IN_CanPick 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-picking-tab-corrige AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-picking-tab-hpk AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-picking-tab-picador AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-picking-tab-resumen AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-cierre AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-corregir AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-nuevo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-picador AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-regresar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-picking-tablet-si-hpk AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON_Aceptar 
     LABEL "ACEPTAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN_CanPick AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de HPK" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Picador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1
     BGCOLOR 12 FGCOLOR 14 FONT 9 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_Picador AT ROW 1.27 COL 3 NO-LABEL WIDGET-ID 16
     FILL-IN_NomCli AT ROW 2.35 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN_NroPed AT ROW 2.35 COL 10 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_CodMat AT ROW 3.42 COL 10 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_CanPick AT ROW 4.5 COL 10 COLON-ALIGNED WIDGET-ID 6
     BUTTON_Aceptar AT ROW 3.42 COL 32 WIDGET-ID 8
     BtnDone AT ROW 23.35 COL 58 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65 BY 23.96
         FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-VtaDDocu T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PICKING PDA"
         HEIGHT             = 23.96
         WIDTH              = 65
         MAX-HEIGHT         = 27.15
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 27.15
         VIRTUAL-WIDTH      = 194.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         FONT               = 11
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img/api-cb.ico":U) THEN
    MESSAGE "Unable to load icon: img/api-cb.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON BUTTON_Aceptar IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON_Aceptar:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CanPick IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Picador IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PICKING PDA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PICKING PDA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Aceptar W-Win
ON CHOOSE OF BUTTON_Aceptar IN FRAME F-Main /* ACEPTAR */
DO:
  IF TRUE <> (FILL-IN_CodMat:SCREEN-VALUE > '')
      OR DECIMAL(FILL-IN_CanPick:SCREEN-VALUE) = 0 THEN DO:
      APPLY 'ENTRY':U TO FILL-IN_CodMat.
      RETURN NO-APPLY.
  END.

  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Registra-Picking IN h_b-picking-tab-resumen
    ( INPUT FILL-IN_CodMat:SCREEN-VALUE /* CHARACTER */,
      INPUT DECIMAL(FILL-IN_CanPick:SCREEN-VALUE) /* DECIMAL */,
      OUTPUT pMensaje /* CHARACTER */).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FILL-IN_CanPick:SCREEN-VALUE = '0.00'.
  FILL-IN_CodMat:SCREEN-VALUE = ''.
  APPLY 'ENTRY':U TO FILL-IN_CodMat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CanPick
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CanPick W-Win
ON LEAVE OF FILL-IN_CanPick IN FRAME F-Main /* Cantidad */
/*OR RETURN OF FILL-IN_CanPick*/
DO:
/*   BUTTON_Aceptar:SENSITIVE = NO.                                            */
/*   IF INPUT {&self-name} > 0 AND FILL-IN_CodMat:SCREEN-VALUE > ''            */
/*       THEN  BUTTON_Aceptar:SENSITIVE = YES.                                 */
/*   IF BUTTON_Aceptar:SENSITIVE = YES THEN APPLY 'ENTRY':U TO BUTTON_Aceptar. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat W-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Artículo */
OR RETURN OF FILL-IN_CodMat
DO:
    /*BUTTON_Aceptar:SENSITIVE = NO.*/
    IF SELF:SCREEN-VALUE = "" THEN DO:
        RETURN.
    END.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    DEF VAR pFactor AS DECI NO-UNDO.

    pCodMat = SELF:SCREEN-VALUE.
    pFactor = 1.
    /*RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).*/
    RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
    IF TRUE <> (pCodMat > '') THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    /* Verificamos si el producto está registrado en la HPK */
    IF NOT CAN-FIND(FIRST Vtaddocu WHERE VtaDDocu.CodCia = s-CodCia
                    AND VtaDDocu.CodPed = "HPK"
                    AND VtaDDocu.NroPed = FILL-IN_NroPed:SCREEN-VALUE
                    AND VtaDDocu.CodMat = pCodMat NO-LOCK)
        THEN DO:
        MESSAGE 'Artículo NO registrado en la HPK' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN_CanPick:SCREEN-VALUE = STRING(pFactor).
    /*IF DECIMAL(FILL-IN_CanPick) > 0 THEN BUTTON_Aceptar:SENSITIVE = YES.*/
    APPLY 'CHOOSE':U TO BUTTON_Aceptar.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroPed W-Win
ON LEAVE OF FILL-IN_NroPed IN FRAME F-Main /* # de HPK */
OR RETURN OF FILL-IN_NroPed
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

/*     DEFINE VAR hProc AS HANDLE NO-UNDO.                                                  */
/*     /* Levantamos la libreria a memoria */                                               */
/*     RUN dist/chk-librerias PERSISTENT SET hProc.                                         */
/*                                                                                          */
/*     /* Consistencia */                                                                   */
/*     DEF VAR x-NroItems AS INT NO-UNDO.                                                   */
/*                                                                                          */
/*     RUN lee-barra-orden IN hProc (SELF:SCREEN-VALUE, OUTPUT x-CodDoc, OUTPUT x-NroPed) . */
/*                                                                                          */
/*     DELETE PROCEDURE hProc.                                                              */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                               */
/*         MESSAGE 'Código de Barra errado' VIEW-AS ALERT-BOX ERROR.                        */
/*         SELF:SCREEN-VALUE = ''.                                                          */
/*         RETURN NO-APPLY.                                                                 */
/*     END.                                                                                 */
/*                                                                                          */
/*     IF LOOKUP(x-CodDoc, 'HPK') = 0 THEN DO:                                              */
/*         MESSAGE 'Código de Barra errado' VIEW-AS ALERT-BOX ERROR.                        */
/*         SELF:SCREEN-VALUE = ''.                                                          */
/*         RETURN NO-APPLY.                                                                 */
/*     END.                                                                                 */

    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND
        vtacdocu.divdes = s-coddiv AND 
        vtacdocu.codped = x-coddoc AND
        vtacdocu.nroped = x-nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtacdocu THEN DO:
        MESSAGE 'NO registrada en el sistema' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF NOT (Vtacdocu.flgest = 'P' AND LOOKUP(Vtacdocu.flgsit, 'TP,TI') > 0 ) THEN DO:
        MESSAGE 'El documento NO está pendiente de cierre' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN_NomCli:SCREEN-VALUE = VtaCDocu.NomCli.
    /* Verificado la HPK bloqueamos el campo */
/*     FILL-IN_NroPed:SCREEN-VALUE = x-NroPed. */
/*     FILL-IN_NroPed:SENSITIVE = NO.          */
/*     FILL-IN_CanPick:SENSITIVE = YES. */
    FILL-IN_CodMat:SENSITIVE = YES.
    /* Cargamos y pintamos el browse */
    RUN select-page('1').
    RUN Carga-Temporal IN h_b-picking-tab-resumen
    ( INPUT x-CodDoc /* CHARACTER */,
      INPUT x-NroPed /* CHARACTER */).
    RUN dispatch IN h_b-picking-tab-resumen ('open-query':U).

    APPLY 'ENTRY':U TO FILL-IN_CodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'RETURN':U OF FILL-IN_CanPick
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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
             INPUT  'aplic/logis/f-picking-tablet-cierre.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-cierre ).
       RUN set-position IN h_f-picking-tablet-cierre ( 23.35 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 18.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-picking-tab-resumen.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-picking-tab-resumen ).
       RUN set-position IN h_b-picking-tab-resumen ( 5.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-picking-tab-resumen ( 17.42 , 63.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-picking-tablet-nuevo.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-nuevo ).
       RUN set-position IN h_f-picking-tablet-nuevo ( 23.35 , 20.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 18.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-picking-tablet-corregir.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-corregir ).
       RUN set-position IN h_f-picking-tablet-corregir ( 23.35 , 38.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 18.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-cierre ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-tab-resumen ,
             h_f-picking-tablet-cierre , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-nuevo ,
             h_b-picking-tab-resumen , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-corregir ,
             h_f-picking-tablet-nuevo , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-picking-tab-corrige.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-picking-tab-corrige ).
       RUN set-position IN h_b-picking-tab-corrige ( 5.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-picking-tab-corrige ( 17.42 , 63.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-picking-tablet-regresar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-regresar ).
       RUN set-position IN h_f-picking-tablet-regresar ( 23.35 , 29.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 18.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 23.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-picking-tab-corrige. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_b-picking-tab-corrige ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-tab-corrige ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-regresar ,
             h_b-picking-tab-corrige , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_f-picking-tablet-regresar , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-picking-tab-picador.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-picking-tab-picador ).
       RUN set-position IN h_b-picking-tab-picador ( 5.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-picking-tab-picador ( 17.77 , 63.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-picking-tablet-picador.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-picador ).
       RUN set-position IN h_f-picking-tablet-picador ( 23.62 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 21.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-tab-picador ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-picador ,
             h_b-picking-tab-picador , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-picking-tab-hpk.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-picking-tab-hpk ).
       RUN set-position IN h_b-picking-tab-hpk ( 5.85 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-picking-tab-hpk ( 17.23 , 65.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-picking-tablet-si-hpk.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-picking-tablet-si-hpk ).
       RUN set-position IN h_f-picking-tablet-si-hpk ( 23.62 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 19.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-tab-hpk ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-picking-tablet-si-hpk ,
             h_b-picking-tab-hpk , 'AFTER':U ).
    END. /* Page 4 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 3 ).

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
  DISPLAY FILL-IN_Picador FILL-IN_NomCli FILL-IN_NroPed FILL-IN_CodMat 
          FILL-IN_CanPick 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone 
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
  /*BUTTON_Aceptar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nuevo-HPK W-Win 
PROCEDURE Nuevo-HPK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      /*BUTTON_Aceptar:SENSITIVE = NO.*/
      FILL-IN_CanPick:SENSITIVE = NO.
      FILL-IN_CodMat:SENSITIVE = NO.
      /*FILL-IN_NroPed:SENSITIVE = YES.*/
      FILL-IN_CanPick:SCREEN-VALUE = "0.00".
      FILL-IN_CodMat:SCREEN-VALUE = "".
      FILL-IN_NroPed:SCREEN-VALUE = "".
      FILL-IN_NomCli:SCREEN-VALUE = "".
      RUN Borra-Temporal IN h_b-picking-tab-resumen.
      RUN select-page('4').
      /*APPLY 'ENTRY':U TO FILL-IN_NroPed.*/
      RUN dispatch IN h_b-picking-tab-hpk ('open-query':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones W-Win 
PROCEDURE Procesa-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParam AS CHAR.

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR pSolicitado AS DECI NO-UNDO.

CASE pParam:
    WHEN 'Cierre-de-guia' THEN DO:
        DEF VAR pError AS CHAR NO-UNDO.
        RUN Cierre-de-guia IN h_b-picking-tab-resumen
          ( OUTPUT pError /* CHARACTER */).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        RUN Nuevo-HPK.
    END.
    WHEN 'Nuevo-HPK' THEN DO:
        RUN Nuevo-HPK.
    END.
    WHEN 'Corregir' THEN DO:
        /* Capturamos Articulo y otros datos */
        RUN Devuelve-Datos IN h_b-picking-tab-resumen
            ( OUTPUT pCodMat /* CHARACTER */,
              OUTPUT pSolicitado /* DECIMAL */).
        IF TRUE <> (pCodMat > '') THEN RETURN.

        /* Captura Tabla Temporal */
        RUN Entrega-Temporal IN h_b-picking-tab-resumen ( OUTPUT TABLE t-VtaDDocu).

        /* Pasamos a la segunda página  */
        /*BUTTON_Aceptar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/
        /*FILL-IN_CanPick:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/
        FILL-IN_CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        RUN select-page ('2').
        RUN Captura-Parametros IN h_b-picking-tab-corrige
            ( INPUT x-CodDoc /* CHARACTER */,
              INPUT x-NroPed /* CHARACTER */,
              INPUT pCodMat /* CHARACTER */,
              INPUT pSolicitado /* DECIMAL */,
              INPUT TABLE t-VtaDDocu).
    END.
    WHEN 'Regresar' THEN DO:
        RUN select-page ('1').
        /*BUTTON_Aceptar:SENSITIVE IN FRAME {&FRAME-NAME} = YES.*/
        /*FILL-IN_CanPick:SENSITIVE IN FRAME {&FRAME-NAME} = YES.*/
        FILL-IN_CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

        RUN Entrega-Temporal IN h_b-picking-tab-corrige ( OUTPUT TABLE t-VtaDDocu,
                                                          OUTPUT pCodMat).

        RUN Captura-Temporal IN h_b-picking-tab-resumen ( INPUT TABLE t-VtaDDocu, 
                                                          INPUT pCodMat).

    END.
    WHEN 'Picador' THEN DO:
        x-Dni = ''.
        RUN Devuelve-Picador IN h_b-picking-tab-picador ( OUTPUT x-Dni /* CHARACTER */).
        IF TRUE <> (x-Dni > '') THEN RETURN.
        /* Pedimos la HPK */
        RUN select-page ('4').
        RUN Captura-Parametros IN h_b-picking-tab-hpk ( INPUT x-Dni /* CHARACTER */).
        /* Pintamos nombre del picador */
        DEF VAR x-nombre-picador AS CHAR NO-UNDO.
        DEF VAR x-origen-picador AS CHAR NO-UNDO.

        RUN logis/p-busca-por-dni(INPUT x-Dni, 
                                  OUTPUT x-nombre-picador,
                                  OUTPUT x-origen-picador).
        RUN src/bin/_centrar (x-nombre-picador, 
                              35, 
                              OUTPUT x-nombre-picador ).
        FILL-IN_Picador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-nombre-picador.
    END.
    WHEN 'Aceptar-HPK' THEN DO:
        RUN Devuelve-HPK IN h_b-picking-tab-hpk ( OUTPUT x-NroPed /* CHARACTER */).
        FILL-IN_NroPed:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-NroPed.

        APPLY 'LEAVE':U TO FILL-IN_NroPed.
    END.
/*     WHEN 'Rechazar-HPK' THEN DO: */
/*         /* Pedimos Picador */    */
/*         RUN select-page ('3').   */
/*     END.                         */
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

