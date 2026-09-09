&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cb-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodDoc AS CHAR FORMAT 'x(8)'      LABEL 'Doc'
    FIELD NroDoc AS CHAR FORMAT 'x(15)'     LABEL 'Número'
    FIELD CodRef AS CHAR FORMAT 'x(8)'      LABEL 'Ref.'
    FIELD NroRef AS CHAR FORMAT 'x(15)'     LABEL 'Número'
    FIELD CodCli AS CHAR FORMAT 'x(15)'     LABEL 'Código'
    FIELD NomCli AS CHAR FORMAT 'x(100)'    LABEL 'Cliente'
    FIELD RucCli AS CHAR FORMAT 'x(15)'     LABEL 'RUC'
    FIELD FmaPgo AS CHAR FORMAT 'x(8)'      LABEL 'Cond. Vta.'
    FIELD CodVen AS CHAR FORMAT 'x(8)'      LABEL 'Vendedor'
    FIELD NomVen AS CHAR FORMAT 'x(100)'    LABEL 'Nombre del vendedor'
    FIELD FchDoc AS DATE FORMAT '99/99/9999'    LABEL 'Emisión'
    FIELD FchVto AS DATE FORMAT '99/99/9999'    LABEL 'Vencimiento'
    FIELD ImpMn  AS DECI FORMAT '->>>,>>>,>>9.99'    LABEL 'Importe S/.'
    FIELD SdoMn  AS DECI FORMAT '->>>,>>>,>>9.99'    LABEL 'Saldo S/.'
    FIELD ImpMe  AS DECI FORMAT '->>>,>>>,>>9.99'    LABEL 'Importe US$.'
    FIELD SdoMe  AS DECI FORMAT '->>>,>>>,>>9.99'    LABEL 'Saldo US$.'
    FIELD Estado AS CHAR FORMAT 'x(20)'     LABEL 'Estado'
    FIELD CodDiv AS CHAR FORMAT 'x(8)'      LABEL 'División'
    FIELD FchRep AS DATE FORMAT '99/99/9999'    LABEL 'Fecha Reporte'
    FIELD Ubicacion AS CHAR FORMAT 'x(15)'  LABEL 'Ubicación'
    FIELD Banco AS CHAR FORMAT 'x(8)'   LABEL 'Banco'
    FIELD Situacion AS CHAR FORMAT 'x(15)'  LABEL 'Situación'
    FIELD Canje AS CHAR FORMAT 'x(15)'  LABEL 'Canje'
    FIELD Departamento AS CHAR FORMAT 'x(30)'   LABEL 'Departamento'
    FIELD Provincia AS CHAR FORMAT 'x(30)'  LABEL 'Provincia'
    FIELD Distrito AS CHAR FORMAT 'x(30)'   LABEL 'Distrito'
    FIELD NroUnico AS CHAR FORMAT 'x(20)'   LABEL 'Nro. único'
    FIELD Fotocopia AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Papel Fotocopia (S/.)'
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
&Scoped-Define ENABLED-OBJECTS BtnDone BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 10 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 36 BY 2.69
     FONT 8.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.54 COL 66 WIDGET-ID 4
     BUTTON-1 AT ROW 3.69 COL 21 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.92 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE CUENTAS POR COBRAR"
         HEIGHT             = 9.92
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE CUENTAS POR COBRAR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE CUENTAS POR COBRAR */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
    /* Archivo de Salida */
    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
    DEF VAR rpta AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.
   
    SESSION:SET-WAIT-STATE('GENERAL').

    /* Variable de memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    /* Cargamos la informacion al temporal */
    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .

    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


EMPTY TEMP-TABLE Detalle.

DEF VAR cListaDocCargo AS CHAR NO-UNDO.
DEF VAR cListaDocAbono AS CHAR NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR cCodRef AS CHAR NO-UNDO.
DEF VAR cNroRef AS CHAR NO-UNDO.

ASSIGN
    cListaDocCargo = "FAC,BOL,N/D,LET,DCO,FAI"
    cListaDocAbono = "N/C,BD,A/R,A/C,LPA"
    .

DEF VAR iItem AS INTE NO-UNDO.

{ccb/i-rep-cta-x-cobrar.i &FlgEst = "P"}

{ccb/i-rep-cta-x-cobrar.i &FlgEst = "J"}

DO iItem = 1 TO NUM-ENTRIES(cListaDocAbono):
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "P" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocAbono) AND
        Ccbcdocu.sdoact > 0:
        CREATE Detalle.
        ASSIGN
            Detalle.coddoc = Ccbcdocu.coddoc
            Detalle.nrodoc = Ccbcdocu.nrodoc
            Detalle.codref = Ccbcdocu.codref
            Detalle.nroref = Ccbcdocu.nroref
            Detalle.codcli = Ccbcdocu.codcli
            Detalle.nomcli = Ccbcdocu.nomcli
            Detalle.ruccli = Ccbcdocu.ruccli
            Detalle.fmapgo = Ccbcdocu.fmapgo
            Detalle.codven = Ccbcdocu.codven
            Detalle.fchdoc = Ccbcdocu.fchdoc
            Detalle.fchvto = Ccbcdocu.fchvto
            Detalle.Fotocopia = 0
            .
        CASE Ccbcdocu.codmon:
            WHEN 1 THEN ASSIGN Detalle.ImpMn = Ccbcdocu.imptot Detalle.SdoMn = Ccbcdocu.sdoact.
            WHEN 2 THEN ASSIGN Detalle.ImpMe = Ccbcdocu.imptot Detalle.SdoMe = Ccbcdocu.sdoact.
        END CASE.
        ASSIGN
            Detalle.coddiv = Ccbcdocu.divori.
        IF TRUE <> (Detalle.coddiv > "") THEN Detalle.coddiv = Ccbcdocu.coddiv.
        /* Fotocopias: N/C por Devolución de mercadería */
        IF Ccbcdocu.CodDoc = "N/C" AND Ccbcdocu.CndCre = "D" THEN DO:
            FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
                FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam = '011':
                Detalle.Fotocopia = Detalle.Fotocopia + Ccbddocu.implin.
            END.
            IF Detalle.Fotocopia > 0 AND Ccbcdocu.codmon = 2 THEN DO:
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE gn-tcmb THEN
                    ASSIGN
                    x-TpoCmbCmp = gn-tcmb.compra 
                    x-TpoCmbVta = gn-tcmb.venta.
                ASSIGN Detalle.Fotocopia = Detalle.Fotocopia * x-TpoCmbVta.
            END.
        END.
        /* Estado */
        Detalle.Estado = "PENDIENTE".
        IF Detalle.coddoc = "BD" THEN Detalle.Estado = "AUTORIZADO".
        /* TODOS LOS VALORES EN NEGATIVO */
        ASSIGN
            Detalle.ImpMn   = -1 * Detalle.ImpMn
            Detalle.SdoMn   = -1 * Detalle.SdoMn
            Detalle.ImpMe   = -1 * Detalle.ImpMe
            Detalle.SdoMe   = -1 * Detalle.SdoMe
            Detalle.Fotocopia = -1 * Detalle.Fotocopia
            .
    END.
END.

/* Datos finales */
DEF VAR cTexto AS CHAR NO-UNDO.
FOR EACH Detalle EXCLUSIVE-LOCK:
    /* Clientes */
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = Detalle.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN Detalle.nomcli = gn-clie.NomCli.
    /* Limpiamos textos */
    RUN lib/limpiar-texto-abc (Detalle.nomcli,
                               " ",
                               OUTPUT cTexto).
    Detalle.nomcli = cTexto.
    /* Importes */
/*     FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Detalle.fchdoc NO-LOCK NO-ERROR.                                                       */
/*     IF AVAILABLE gn-tcmb THEN                                                                                                       */
/*         ASSIGN                                                                                                                      */
/*         x-TpoCmbCmp = gn-tcmb.compra                                                                                                */
/*         x-TpoCmbVta = gn-tcmb.venta.                                                                                                */
/*     CASE TRUE:                                                                                                                      */
/*         WHEN Detalle.ImpMn > 0 THEN ASSIGN Detalle.ImpMe = Detalle.ImpMN / x-TpoCmbCmp Detalle.SdoMe = Detalle.SdoMN / x-TpoCmbCmp. */
/*         WHEN Detalle.ImpMe > 0 THEN ASSIGN Detalle.ImpMn = Detalle.ImpMe * x-TpoCmbVta Detalle.SdoMn = Detalle.SdoMe * x-TpoCmbVta. */
/*     END CASE.                                                                                                                       */
    /* Vendedor */
    FIND gn-ven WHERE gn-ven.CodCia = s-codcia AND
        gn-ven.CodVen = Detalle.codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN Detalle.nomven = gn-ven.NomVen.
    /* Limpiamos textos */
    RUN lib/limpiar-texto-abc (Detalle.nomven,
                               " ",
                               OUTPUT cTexto).
    Detalle.nomven = cTexto.

    Detalle.FchRep = TODAY.
    /* Ubigeo */
    FIND FIRST gn-clied WHERE Gn-ClieD.CodCia = cl-codcia AND
        Gn-ClieD.CodCli = Detalle.codcli AND
        Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        FIND TabDepto WHERE TabDepto.CodDepto = Gn-ClieD.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
        FIND TabProvi WHERE TabProvi.CodDepto = Gn-ClieD.CodDept AND
            TabProvi.CodProvi = Gn-ClieD.CodProv NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN Detalle.Provincia = TabProvi.NomProvi.
        FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
            TabDistr.CodProvi = Gn-ClieD.CodProv AND 
            TabDistr.CodDistr = Gn-ClieD.CodDist NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN Detalle.Distrito = TabDistr.NomDistr.
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
  ENABLE BtnDone BUTTON-1 
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

