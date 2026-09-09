&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ORDEN FOR FacCPedi.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR iBultos AS INTE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ORDEN

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH ORDEN SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH ORDEN SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main ORDEN
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main ORDEN


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-NroHPK COMBO-BOX_Zona FILL-IN-Bultos ~
BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroHPK COMBO-BOX_Zona ~
FILL-IN-Bultos FILL-IN_CodDoc FILL-IN_NroPed FILL-IN_FchPed FILL-IN_CodCli ~
FILL-IN_NomCli FILL-IN_Items 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 18 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 2" 
     SIZE 18 BY 2.15.

DEFINE VARIABLE COMBO-BOX_Zona AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "ZONA" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0
     DROP-DOWN-LIST
     SIZE 28 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "INGRESE EL # DE BULTOS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.38
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroHPK AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESCANEE EL CÓDIGO DE BARRAS" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.38
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.38.

DEFINE VARIABLE FILL-IN_CodDoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1.38.

DEFINE VARIABLE FILL-IN_FchPed AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha de Emisión" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.38.

DEFINE VARIABLE FILL-IN_Items AS INTEGER FORMAT ">,>>9" INITIAL 0 
     LABEL "# de Items" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY 1.38.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(100)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 86 BY 1.38.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(12)" 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      ORDEN SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroHPK AT ROW 1.27 COL 51 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX_Zona AT ROW 2.88 COL 51 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-Bultos AT ROW 4.23 COL 51 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_CodDoc AT ROW 6.12 COL 51 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_NroPed AT ROW 7.73 COL 51 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_FchPed AT ROW 9.35 COL 51 COLON-ALIGNED WIDGET-ID 12
     FILL-IN_CodCli AT ROW 10.96 COL 51 COLON-ALIGNED HELP
          "C¢digo del Cliente" WIDGET-ID 8
     FILL-IN_NomCli AT ROW 12.58 COL 51 COLON-ALIGNED HELP
          "Nombre del Cliente" WIDGET-ID 16
     FILL-IN_Items AT ROW 14.19 COL 51 COLON-ALIGNED WIDGET-ID 14
     BUTTON-2 AT ROW 16.62 COL 3 WIDGET-ID 26
     BtnDone AT ROW 16.62 COL 22 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.57 BY 18.35
         FONT 9 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RECEPCION DE BULTOS DE DISTRIBUCION"
         HEIGHT             = 18.35
         WIDTH              = 143.57
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
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "Temp-Tables.ORDEN"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RECEPCION DE BULTOS DE DISTRIBUCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RECEPCION DE BULTOS DE DISTRIBUCION */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
      COMBO-BOX_Zona FILL-IN-Bultos FILL-IN-NroHPK.
  
  IF TRUE <> (FILL-IN-NroHPK > '') THEN DO:
      MESSAGE 'Debe escanear el código de barras' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN-NroHPK.
      RETURN NO-APPLY.
  END.
  /* Control de bultos */
  IF iBultos <> FILL-IN-Bultos THEN DO:
      MESSAGE 'El # de bultos verificados no coinciden con los # de bultos chequeados' SKIP
          'Vuelva a contar los bultos por favor'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN-Bultos.
      RETURN NO-APPLY.
  END.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Envio-a-Distribucion (INPUT COMBO-BOX_Zona, OUTPUT pMensaje).
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
  FILL-IN-NroHPK:SENSITIVE = YES.
  FILL-IN-Bultos:SENSITIVE = NO.
  APPLY 'ENTRY':U TO FILL-IN-NroHPK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroHPK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroHPK W-Win
ON LEAVE OF FILL-IN-NroHPK IN FRAME F-Main /* ESCANEE EL CÓDIGO DE BARRAS */
OR RETURN OF FILL-IN-NroHPK DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  /* El código de barra está compuesto de lo siguiente:
    NNNCCCCCCCCC
        Donde: 
        NNN: es el número de control del documento del código de barras
        CCCCCCCCC: es el número de correlativo del documento
  */

  DEF VAR cCodDoc AS CHAR NO-UNDO.
  DEF VAR cNroDoc AS CHAR NO-UNDO.

  ASSIGN
      cCodDoc = SUBSTRING(SELF:SCREEN-VALUE,1,3)
      cNroDoc = SUBSTRING(SELF:SCREEN-VALUE,4).

  FIND FIRST FacDocum WHERE FacDocum.CodCia = s-codcia 
      AND FacDocum.CodCta[8] = cCodDoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum THEN DO:
      MESSAGE 'El prefijo del código de barras no coincide con ningún documento registrado'
          VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* Como estamos chequeando HPK's entonces: */
  IF FacDocum.CodDoc <> "HPK" THEN DO:
      MESSAGE 'El código de barras no pertenece a una HPK' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FIND Vtacdocu WHERE Vtacdocu.CodCia = s-codcia
      AND Vtacdocu.CodDiv = s-coddiv
      AND Vtacdocu.CodPed = "HPK"
      AND Vtacdocu.NroPed = cNroDoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Vtacdocu THEN DO:
      MESSAGE "No se pudo ubicar la HPK" cNroDoc
          VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* La O/D debe tener el chequeo totalmente cerrado */
  FIND FIRST ORDEN WHERE ORDEN.CodCia = s-codcia 
      AND ORDEN.CodDoc = Vtacdocu.CodRef
      AND ORDEN.NroPed = Vtacdocu.NroRef
      AND ORDEN.DivDes = s-CodDiv
      AND ORDEN.FlgEst = "P" 
      AND ORDEN.FlgSit = "PC" 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ORDEN THEN DO:
      MESSAGE 'La ' Vtacdocu.CodRef Vtacdocu.NroRef "NO se encuentra lista para facturar"
          VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* Contamos los bultos */
  iBultos = 0.
  FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-codcia
      AND CcbCBult.CodDoc = ORDEN.coddoc
      AND CcbCBult.NroDoc = ORDEN.nroped:
      iBultos = iBultos + CcbCBult.Bultos.
  END.

  /* Pintamos y habilitamos campos */
  FILL-IN-NroHPK:SENSITIVE = NO.
  FILL-IN-Bultos:SENSITIVE = YES.
  FILL-IN_CodCli:SCREEN-VALUE = ORDEN.codcli.
  FILL-IN_CodDoc:SCREEN-VALUE = ORDEN.coddoc.
  FILL-IN_FchPed:SCREEN-VALUE = STRING(ORDEN.fchped, '99/99/9999').
  FILL-IN_Items:SCREEN-VALUE = STRING(ORDEN.items).
  FILL-IN_NomCli:SCREEN-VALUE = ORDEN.nomcli.
  FILL-IN_NroPed:SCREEN-VALUE = ORDEN.nroped.
  /*APPLY 'ENTRY':U TO FILL-IN-Bultos.*/
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
  DISPLAY FILL-IN-NroHPK COMBO-BOX_Zona FILL-IN-Bultos FILL-IN_CodDoc 
          FILL-IN_NroPed FILL-IN_FchPed FILL-IN_CodCli FILL-IN_NomCli 
          FILL-IN_Items 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-NroHPK COMBO-BOX_Zona FILL-IN-Bultos BUTTON-2 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envio-a-Distribucion W-Win 
PROCEDURE Envio-a-Distribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Lógica principal
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pZona AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pCambios AS LOG NO-UNDO.
DEF VAR s-NroDec AS INTE NO-UNDO.
DEF VAR s-porigv AS DEC NO-UNDO.

DEF VAR x-articulo-ICBPER AS CHAR NO-UNDO.

/* Tomamos el puntero de la ORDEN */
ASSIGN
    pRowid = ROWID(ORDEN).

CICLO:                
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /*
    {lib/lock-genericov3.i 
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        &Intentos=5 ~
        }
    */
    FIND FIRST faccpedi WHERE ROWID(faccpedi) = ROWID(ORDEN) EXCLUSIVE-LOCK NO-ERROR. 
    IF LOCKED faccpedi THEN DO:
        MESSAGE "La tabla FACCPEDI esta bloqueada por otro usuario" SKIP
                ERROR-STATUS:GET-MESSAGE(1)
            VIEW-AS ALERT-BOX INFORMATION.
        UNDO CICLO, RETURN "ADM-ERROR".
    END.
    IF NOT AVAILABLE faccpedi THEN DO:
        MESSAGE "No se encontro el registro en el FACCPEDI"
            VIEW-AS ALERT-BOX INFORMATION.
        UNDO CICLO, RETURN "ADM-ERROR".
    END.

    ASSIGN 
        s-NroDec = Faccpedi.Libre_d01 
        s-PorIgv = Faccpedi.PorIgv.
    /* Buscamos las HPK relacionadas */
    FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE VtaCDocu.CodCia = s-codcia
        AND VtaCDocu.CodRef = Faccpedi.coddoc       /* O/D */
        AND VtaCDocu.NroRef = Faccpedi.nroped
        AND VtaCDocu.CodDiv = s-coddiv
        AND VtaCDocu.CodPed = "HPK"
        AND VtaCDocu.FlgEst <> "A"  ON ERROR UNDO, THROW:

        FOR EACH ChkTareas EXCLUSIVE-LOCK WHERE ChkTareas.CodCia = VtaCDocu.CodCia
            AND ChkTareas.CodDiv = s-coddiv 
            AND ChkTareas.CodDoc = VtaCDocu.CodPed      /* HPK */
            AND ChkTareas.NroPed = VtaCDocu.NroPed:
            ASSIGN
                ChkTareas.FlgEst = "C".
        END.
        RELEASE ChkTareas.

        ASSIGN
            VtaCDocu.ZonaDistribucion = STRING(pZona)
            Vtacdocu.FlgSit = "C".
        /* **************************** */
        /* LOG de control para REPORTES */
        /* **************************** */
        RUN lib/logtabla ("VTACDOCU",
                          s-coddiv + ":" + Vtacdocu.codped + ":" + Vtacdocu.nroped + ":" + VtaCDocu.ZonaDistribucion,
                          "DIST_RECEP_BULTOS").

        /* *********************** */
        /* Corrección de despachos */
        /* *********************** */
        DEF VAR x-CanPed AS DEC NO-UNDO.

        pCambios = NO.
        FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK WHERE Vtaddocu.canped = 0,
            FIRST Almmmatg OF Vtaddocu NO-LOCK:
            FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN NEXT.
            FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
            /* *************************************** */
            /* RHC 11/03/2020 Control de modificaciones */
            /* *************************************** */
            ASSIGN
                x-CanPed = Facdpedi.CanPed.
            /* 1ro. Extornamos la cantidad base */
            ASSIGN
                Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor).
            /* 2do. Actualizamos la cantidad pickeada final */
            ASSIGN
                Facdpedi.CanPed = Facdpedi.CanPed + (Vtaddocu.CanPed / Facdpedi.Factor).
            /* *************************************** */
            /* RHC 11/03/2020 Control de modificaciones */
            /* *************************************** */
            IF x-CanPed <> Facdpedi.CanPed THEN DO:
                CREATE LogTabla.
                ASSIGN
                    logtabla.codcia = s-CodCia
                    logtabla.Dia = TODAY
                    logtabla.Evento = 'CORRECCION'
                    logtabla.Hora = STRING(TIME, 'HH:MM:SS')
                    logtabla.Tabla = 'FACDPEDI'
                    logtabla.Usuario = s-User-Id
                    logtabla.ValorLlave = Facdpedi.CodDoc + '|' +
                                            Facdpedi.NroPed + '|' +
                                            Facdpedi.CodMat + '|' +
                                            STRING(x-CanPed) + '|' +
                                            STRING(Facdpedi.CanPed).
                /*RUN Recalcular-Registro.*/
                {vtagn/CalculoDetalleMayorCredito.i &Tabla="Facdpedi"}
                /* OJO: Los items que están en cero se ELIMINAN */
                IF Facdpedi.CanPed <= 0 THEN DO:
                    DELETE Facdpedi.    /* OJO */
                END.
                /* ******************************************** */
                pCambios = YES.
            END.
            DELETE Vtaddocu.
        END.
        IF pCambios = YES THEN DO:
            {vta2/graba-totales-cotizacion-cred.i}
        END.
        /* *********************** */
        pMensaje = ''.
        /* La PHR se va a cerrar al FINALIZAR EL PICKING */
        RUN logis/p-cierra-pik-phr.r (Vtacdocu.CodPed,    /* HPK */
                                      Vtacdocu.CodDiv,
                                      Vtacdocu.CodRef,    /* O/D OTR */
                                      Vtacdocu.NroRef,
                                      Vtacdocu.CodOri,    /* PHR */
                                      Vtacdocu.NroOri,
                                      OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la PHR " + Vtacdocu.NroOri.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* *************************************************************************** */
    END.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_Zona:DELIMITER = "|".
      COMBO-BOX_Zona:DELETE(1).
      FOR EACH logiszonadist NO-LOCK WHERE logiszonadist.codcia = s-codcia
          AND logiszonadist.coddiv = s-coddiv
          BY logiszonadist.Zona DESC:
          COMBO-BOX_Zona:ADD-LAST(STRING(logiszonadist.Zona) + " - " + logiszonadist.Descripcion, logiszonadist.Zona).
          COMBO-BOX_Zona = logiszonadist.Zona.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-IN-Bultos:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Registro W-Win 
PROCEDURE Recalcular-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Recalculamos el importe del registro */
    ASSIGN
        Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                              ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
    IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
        THEN Facdpedi.ImpDto = 0.
    ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
    ASSIGN
        Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
        Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
    IF Facdpedi.AftIsc 
        THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE Facdpedi.ImpIsc = 0.
    IF Facdpedi.AftIgv 
        THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE Facdpedi.ImpIgv = 0.

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
  {src/adm/template/snd-list.i "ORDEN"}

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

