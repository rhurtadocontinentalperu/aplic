&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi.



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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta    LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-DiasVtoCot     LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasVtoPed     LIKE GN-DIVI.DiasVtoPed.
DEF NEW SHARED VAR s-TpoPed AS CHAR.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-CodDiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-VentaMayorista = GN-DIVI.VentaMayorista
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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-FacCPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-FacCPedi.FchPed t-FacCPedi.NroPed ~
t-FacCPedi.CodCli t-FacCPedi.NomCli t-FacCPedi.RucCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-FacCPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-FacCPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "ACTUALIZAR DESCUENTOS" 
     SIZE 26 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-FacCPedi.FchPed COLUMN-LABEL "Fecha Emisión" FORMAT "99/99/9999":U
      t-FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      t-FacCPedi.CodCli COLUMN-LABEL "Codigo Cliente" FORMAT "x(11)":U
      t-FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(100)":U
      t-FacCPedi.RucCli FORMAT "x(20)":U WIDTH 14.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 22.88
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 2 WIDGET-ID 2
     BUTTON-2 AT ROW 1.27 COL 17 WIDGET-ID 4
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.14 BY 25.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 25.04
         WIDTH              = 143.14
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
/* BROWSE-TAB BROWSE-2 BUTTON-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-FacCPedi.FchPed
"FchPed" "Fecha Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-FacCPedi.NroPed
"NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-FacCPedi.CodCli
"CodCli" "Codigo Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-FacCPedi.NomCli
"NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-FacCPedi.RucCli
"RucCli" ? ? "character" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* REFRESCAR */
DO:
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ACTUALIZAR DESCUENTOS */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN MASTER-TRANSACTION (OUTPUT pMensaje).
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  END.
  APPLY 'CHOOSE':U TO BUTTON-1.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

EMPTY TEMP-TABLE t-faccpedi.
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = s-coddiv AND
    Faccpedi.coddoc = "PLE" AND
    Faccpedi.flgest = "X":
    CREATE t-faccpedi.
    BUFFER-COPY Faccpedi TO t-faccpedi.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES W-Win 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT Faccpedi.TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT Faccpedi.TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                      INPUT Faccpedi.TpoPed,
                                      INPUT s-CodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_PRONTO_DESPACHO IN hProc (INPUT ROWID(Faccpedi),
                                     INPUT s-CodDiv,
                                     OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                              INPUT s-CodDiv,
                              OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  DELETE PROCEDURE hProc.

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
  ENABLE BUTTON-1 BUTTON-2 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR s-NroDec AS INTE NO-UNDO.
DEF VAR s-PorIgv AS DECI NO-UNDO.
DEF VAR s-CodCli AS CHAR NO-UNDO.
DEF VAR s-Cmpbnte AS CHAR NO-UNDO.
DEF VAR hProc AS HANDLE NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion= "FacCPedi.CodCia = t-FacCPedi.CodCia AND ~
        FacCPedi.CodDiv = t-FacCPedi.CodDiv AND ~
        FacCPedi.CodDoc = t-FacCPedi.CodDoc AND ~
        FacCPedi.NroPed = t-FacCPedi.NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje= "NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        &Intentos="5"}
    IF Faccpedi.FlgEst <> "X" THEN NEXT.

    ASSIGN
        Faccpedi.FlgEst = "PV"
        s-nroDec = Faccpedi.Libre_d01
        s-PorIgv = Faccpedi.PorIgv
        s-CodCli = Faccpedi.CodCli
        s-Cmpbnte = FacCPedi.Cmpbnte
        s-TpoPed = Faccpedi.TpoPed.
    FOR EACH B-DPEDI OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF B-DPEDI NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        FIND Facdpedi WHERE ROWID(Facdpedi) = ROWID(B-DPEDI) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE Facdpedi THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        END.
        s-UndVta = Facdpedi.UndVta.
        RUN {&precio-venta-general} (
            Faccpedi.TpoPed,
            (IF Faccpedi.Libre_c01 > '' THEN Faccpedi.Libre_c01 ELSE Faccpedi.CodDiv),
            Faccpedi.CodCli,
            Faccpedi.CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            Facdpedi.CodMat,
            Faccpedi.FmaPgo,
            Facdpedi.CanPed,
            Faccpedi.Libre_d01,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
            OUTPUT f-FleteUnitario,
            "",
            YES,
            OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            Facdpedi.Factor = f-Factor
            Facdpedi.UndVta = s-UndVta
            Facdpedi.PreUni = F-PREVTA
            Facdpedi.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
            Facdpedi.PreBas = F-PreBas 
            Facdpedi.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
            Facdpedi.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
            Facdpedi.PorDto2 = 0            /* el precio unitario */
            Facdpedi.Por_Dsctos[2] = z-Dsctos
            Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
            Facdpedi.AftIgv = Almmmatg.AftIgv
            Facdpedi.AftIsc = Almmmatg.AftIsc
            Facdpedi.ImpIsc = 0
            Facdpedi.ImpIgv = 0
            Facdpedi.Libre_c04 = x-TipDto.
        {vtagn/CalculoDetalleMayorCredito.i &Tabla="Facdpedi" }
    END.
    /* ************************************************************************ */
    /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
    /* ************************************************************************ */
    &IF {&ARITMETICA-SUNAT} = NO &THEN
        RUN impuesto-icbper. 
    &ENDIF
    /* ******************************************** */
    /* ************************************************************************************** */
    /* 02/08/2022: Anulamos log de descuentos finales */
    /* ************************************************************************************** */
    FOR EACH logdsctosped EXCLUSIVE-LOCK WHERE logdsctosped.CodCia = Faccpedi.codcia AND
        logdsctosped.CodPed = Faccpedi.coddoc AND
        logdsctosped.NroPed = Faccpedi.nroped:
        DELETE logdsctosped.
    END.
    /* 02/08/2022: Log de descuentos básicos */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c04 > '':
        CREATE logdsctosped.
        BUFFER-COPY Facdpedi TO logdsctosped
            ASSIGN
            logdsctosped.CodPed = Facdpedi.coddoc
            logdsctosped.NroPed = Facdpedi.nroped
            logdsctosped.CodCli = Faccpedi.CodCli
            logdsctosped.CodMon = Faccpedi.CodMon
            logdsctosped.Fecha = TODAY
            logdsctosped.Hora = STRING(TIME,'HH:MM:SS')
            logdsctosped.TipDto = Facdpedi.Libre_c04
            logdsctosped.PorDto = Facdpedi.Por_Dsctos[3]
            logdsctosped.Usuario = FacCPedi.usuario.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************************** */

    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    &IF {&ARITMETICA-SUNAT} &THEN
      {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* ****************************************************************************************** */
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ELSE
      {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* NO actualiza importes Progress */
      /* ****************************************************************************************** */
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
END.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FOR EACH t-FacCPedi NO-LOCK:
    RUN FIRST-TRANSACTION (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

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
  {src/adm/template/snd-list.i "t-FacCPedi"}

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

