&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */

{CBD/CBGLOBAL.I}

DEFINE TEMP-TABLE DMOV NO-UNDO LIKE cb-dmov
    FIELD t-flgest1 AS CHAR.

DEFINE TEMP-TABLE DMOV-2 NO-UNDO LIKE cb-dmov
    FIELD t-periodo AS CHAR
    FIELD t-codprio AS CHAR
    FIELD t-indicador AS CHAR.

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE BUFFER DETALLE FOR cb-dmov.

DEFINE VAR x-ImpMn1  AS DECIMAL.
DEFINE VAR x-ImpMn2  AS DECIMAL.
DEFINE VAR x-dol LIKE DMOV.ImpMn2.
DEFINE VAR x-sol LIKE DMOV.ImpMn1.
/*DEFINE VAR pv-codcia AS INT.
 * 
 * FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
 * IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.*/

DEFINE STREAM report.

/* CARGAMOS LAS SEMANAS POSIBLES */
FIND LAST Evtsemana WHERE TODAY >= FecIni AND TODAY <= FecFin NO-LOCK NO-ERROR.
IF NOT AVAILABLE Evtsemana THEN DO:
    MESSAGE 'Debe configurar primero la tabla de semanas para estadísticas'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
DEF VAR x-Sem1-1 AS DATE NO-UNDO.
DEF VAR x-Sem1-2 AS DATE NO-UNDO.
DEF VAR x-Sem2-1 AS DATE NO-UNDO.
DEF VAR x-Sem2-2 AS DATE NO-UNDO.
DEF VAR x-Sem3-1 AS DATE NO-UNDO.
DEF VAR x-Sem3-2 AS DATE NO-UNDO.
DEF VAR x-Sem4-1 AS DATE NO-UNDO.
DEF VAR x-Sem4-2 AS DATE NO-UNDO.
DEF VAR x-Sem5-1 AS DATE NO-UNDO.
DEF VAR x-Sem5-2 AS DATE NO-UNDO.
DEF VAR x-Sem6-1 AS DATE NO-UNDO.
DEF VAR x-Sem6-2 AS DATE NO-UNDO.
DEF VAR x-Label-1 AS CHAR NO-UNDO.
DEF VAR x-Label-2 AS CHAR NO-UNDO.
DEF VAR x-Label-3 AS CHAR NO-UNDO.
DEF VAR x-Label-4 AS CHAR NO-UNDO.
DEF VAR x-Label-5 AS CHAR NO-UNDO.
DEF VAR x-Label-6 AS CHAR NO-UNDO.

DEF VAR x-TpoCmbCmp AS DEC NO-UNDO.
DEF VAR x-TpoCmbVta AS DEC NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.

ASSIGN
    x-Sem1-1 = EvtSemana.FecIni - 7
    x-Sem1-2 = EvtSemana.FecFin - 7
    x-Sem2-1 = EvtSemana.FecIni
    x-Sem2-2 = EvtSemana.FecFin
    x-Sem3-1 = EvtSemana.FecIni + 7
    x-Sem3-2 = EvtSemana.FecFin + 7
    x-Sem4-1 = EvtSemana.FecIni + 7 * 2
    x-Sem4-2 = EvtSemana.FecFin + 7 * 2
    x-Sem5-1 = EvtSemana.FecIni + 7 * 3
    x-Sem5-2 = EvtSemana.FecFin + 7 * 3
    x-Sem6-1 = EvtSemana.FecIni + 7 * 4
    x-Sem6-2 = EvtSemana.FecFin + 7 * 4.
x-Label-2 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND PREV EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-1 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-3 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-4 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-5 = "Sem " + STRING(EvtSemana.NroSem, '99').
x-Label-6 = "Por Vencer".

/* DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5. */
/*                                                          */
/* DEFINE FRAME F-Proceso                                   */
/*      IMAGE-1 AT ROW 1.5 COL 5                            */
/*      "Espere un momento" VIEW-AS TEXT                    */
/*           SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6          */
/*      "por favor ...." VIEW-AS TEXT                       */
/*           SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6          */
/*           SKIP                                           */
/*      Fi-Mensaje NO-LABEL FONT 6                          */
/*      SKIP                                                */
/*      WITH CENTERED OVERLAY KEEP-TAB-ORDER                */
/*           SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE    */
/*           BGCOLOR 15 FGCOLOR 0                           */
/*           TITLE "Procesando ..." FONT 7.                 */

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS fi-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE fi-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 4.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-3 AT ROW 1.54 COL 51 WIDGET-ID 10
     Btn_Done AT ROW 1.54 COL 59 WIDGET-ID 12
     fi-Mensaje AT ROW 3.96 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     RECT-1 AT ROW 1.23 COL 2 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.29 BY 5.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Proyeccion de Pagos"
         HEIGHT             = 5.08
         WIDTH              = 72.29
         MAX-HEIGHT         = 18.96
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 18.96
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
/* SETTINGS FOR FILL-IN fi-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Proyeccion de Pagos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Proyeccion de Pagos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    /*ASSIGN x-coddiv .*/
    RUN Genera-Excel.
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

DEF VAR c-Doc AS CHAR INIT "Todos" NO-UNDO.     
DEF VAR x-CodAux AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-CodBco AS CHAR NO-UNDO.
DEF VAR x-CodMon AS INT INIT 1 NO-UNDO.
DEF VAR f-ImpMn1 AS DEC NO-UNDO.
DEF VAR f-ImpMn2 AS DEC NO-UNDO.

DEFINE VARIABLE dImpMn1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE dImpMn2 AS DECIMAL NO-UNDO.


/* DO WITH FRAME {&FRAME-NAME}:                           */
/*    ASSIGN                                              */
/*     C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas */
/*     F-ExcDoc x-codbco x-Codmon.                        */
/*     d-FchEmi-1 d-FchEmi-2d                             */
/*    IF C-doc = "Todos" THEN C-doc = "".                 */
/* END.                                                   */
IF C-doc = "Todos" THEN C-doc = "".

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
DO TRANSACTION:
    FOR EACH DMOV:
        DELETE DMOV.
    END.
    FOR EACH DMOV-2:
        DELETE DMOV-2.
    END.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.

/* RHC PARCHE: Corregimos las fechas de vencimiento */
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN WITH FRAME {&FRAME-NAME}:
    FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
             Cp-tpro.CodDoc BEGINS C-doc AND
             /*LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND*/
             /*CP-TPRO.CODDOC = "34" AND   */
             Cp-tpro.CORRELATIVO = YES:
        IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
        IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.
        FOR EACH DETALLE WHERE DETALLE.CODCIA  = S-CODCIA  AND
                 DETALLE.PERIODO = S-PERIODO      AND
                 DETALLE.CODOPE  = CP-TPRO.CODOPE AND
                 DETALLE.CODCTA  = CP-TPRO.CODCTA AND
                 DETALLE.CodAux BEGINS ""   AND
                 DETALLE.CODDOC  = CP-TPRO.CODDOC AND
                 DETALLE.NroDoc BEGINS x-NroDoc   AND
                 DETALLE.FCHVTO = ?               AND
                 DETALLE.TPOITM NE "N"            AND
                 /*DETALLE.CODDIV BEGINS x-CodDiv   AND*/
                 DETALLE.Codbco BEGINS x-codbco :
            FI-MENSAJE:SCREEN-VALUE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                         " No. : " + DETALLE.NroDoc.
            DETALLE.FchVto = DETALLE.FchDoc.            
        END.
    END.
END.

/* AHORA SI CARGAMOS LOS SALDOS POR DOCUMENTO */
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN WITH FRAME {&FRAME-NAME}:
    FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
             Cp-tpro.CodDoc BEGINS C-doc AND
             /*LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND*/
             /*CP-TPRO.CODDOC = "34" AND   */
             Cp-tpro.CORRELATIVO = YES:
        IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
        IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.
        FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
                 DETALLE.PERIODO = S-PERIODO      AND
                 DETALLE.CODOPE  = CP-TPRO.CODOPE AND
                 DETALLE.CODCTA  = CP-TPRO.CODCTA AND
                 DETALLE.CodAux BEGINS ""   AND
                 DETALLE.CODDOC  = CP-TPRO.CODDOC AND
                 DETALLE.NroDoc BEGINS x-NroDoc   AND
                 DETALLE.TPOITM NE "N"            AND
                 /*DETALLE.CODDIV BEGINS x-CodDiv   AND*/
                 DETALLE.Codbco BEGINS x-codbco
                 BREAK BY DETALLE.CODDOC BY DETALLE.NRODOC :
            FI-MENSAJE:SCREEN-VALUE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                         " No. : " + DETALLE.NroDoc.
            X-IMPORT[1] = 0.
            X-IMPORT[2] = 0.
            FOR EACH cb-dmov NO-LOCK WHERE
                cb-dmov.CodCia = DETALLE.CODCIA AND
                cb-dmov.Periodo = DETALLE.PERIODO AND
                cb-dmov.Codcta  = DETALLE.CODCTA  AND
                cb-dmov.Codaux  = DETALLE.codaux  AND
                cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                cb-dmov.NroDoc  = DETALLE.NroDoc:
                IF NOT cb-dmov.tpomov THEN 
                    CASE x-codmon:
                        WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1.
                        WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
                    END CASE.
                ELSE 
                    CASE x-codmon:
                        WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1.
                        WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
                    END CASE.

            END.
            IF X-IMPORT[1] = 0 AND X-IMPORT[2] = 0 THEN NEXT.
            IF x-codmon = 1 THEN ASSIGN dImpMn1 = DETALLE.ImpMn1.
            ELSE ASSIGN dImpMn1 = DETALLE.ImpMn2.

            /* SOLO PASAN LAS 422 ACREEDORA */
            IF DETALLE.Codcta BEGINS "422" AND 
               NOT ( X-IMPORT[1] < 0 OR X-IMPORT[2] < 0 ) THEN NEXT.

            IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
               (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
               IF c-doc = 'LP' AND x-codmon <> 3 THEN
                   IF x-codmon <> DETALLE.CodMon THEN NEXT.

               CREATE DMOV.
               ASSIGN DMOV.CODCIA = S-CODCIA
                      DMOV.NroAst = DETALLE.NroAst
                      DMOV.CodOpe = DETALLE.CodOpe
                      DMOV.cco    = DETALLE.cco   
                      DMOV.Clfaux = DETALLE.Clfaux
                      DMOV.CndCmp = DETALLE.CndCmp
                      DMOV.Codaux = DETALLE.Codaux
                      DMOV.Codcta = DETALLE.Codcta
                      DMOV.CodDiv = DETALLE.CodDiv
                      DMOV.Coddoc = DETALLE.Coddoc
                      DMOV.Codmon = DETALLE.Codmon
                      DMOV.Codref = DETALLE.Codref
                      DMOV.DisCCo = DETALLE.DisCCo
                      DMOV.Fchdoc = DETALLE.Fchdoc
                      DMOV.Fchvto = DETALLE.Fchvto
                      DMOV.flgact = DETALLE.flgact
                      DMOV.Glodoc = DETALLE.Glodoc
                      DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                      DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)
                      DMOV.Nrodoc = DETALLE.Nrodoc
                      DMOV.Nroref = DETALLE.NroRef
                      DMOV.Nroruc = DETALLE.Nroruc
                      DMOV.OrdCmp = DETALLE.OrdCmp
                      DMOV.tm     = DETALLE.tm
                      DMOV.Tpocmb = DETALLE.Tpocmb
                      DMOV.TpoMov = IF DETALLE.Codcta BEGINS "422" THEN DETALLE.TpoMov ELSE NOT DETALLE.TpoMov
                      DMOV.CodBco = DETALLE.CodBco.

               IF DMOV.TpoMov THEN DO:
                   IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.                     
                   ELSE F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1.           
               END.                 
               ELSE DO:
                   IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
                   ELSE F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1.
               END.

               /* RHC 24.08.06 CALCULAMOS EL VENCIMIENTO PROYECTADO */
               CREATE DMOV-2.
               BUFFER-COPY DMOV TO DMOV-2.           

               /**RD01 - Modifica criterio de prioridad
               FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
                   AND GN-PROV.codpro = DMOV-2.CodAux NO-LOCK NO-ERROR.
               IF AVAILABLE GN-PROV AND GN-PROV.PrioridadPago <> '' THEN DO:
                   DMOV-2.t-codprio = GN-PROV.PrioridadPago.
                   FIND FacTabla WHERE FacTabla.codcia = s-codcia
                       AND FacTabla.Tabla = 'PP'
                       AND FacTabla.Codigo = GN-PROV.PrioridadPago
                       NO-LOCK NO-ERROR.
                   IF AVAILABLE FacTabla 
                       THEN CASE DMOV-2.CodDoc:
                            WHEN '01' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                            WHEN '37' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[2].
                            OTHERWISE DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                       END CASE.
               END.                

               ****RD01 - Fin***/

               FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
                   AND GN-PROV.codpro = DMOV-2.CodAux NO-LOCK NO-ERROR.
               IF AVAILABLE GN-PROV AND GN-PROV.PrioridadPago <> '' THEN DO:
                   DMOV-2.t-codprio = GN-PROV.PrioridadPago.
                   FIND FacTabla WHERE FacTabla.codcia = s-codcia
                       AND FacTabla.Tabla = 'PP'
                       AND FacTabla.Codigo = GN-PROV.PrioridadPago
                       NO-LOCK NO-ERROR.
                   IF AVAILABLE FacTabla 
                       THEN CASE DMOV-2.CodDoc:
                            WHEN '01' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                            WHEN '37' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[2].
                            OTHERWISE DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[3].
                       END CASE.
               END.                
               ELSE DO:
                   FIND FacTabla WHERE FacTabla.codcia = s-codcia
                       AND FacTabla.Tabla = 'PP'
                       AND FacTabla.Codigo = "4" NO-LOCK NO-ERROR.
                   IF AVAILABLE FacTabla 
                       THEN CASE DMOV-2.CodDoc:
                            WHEN '01' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                            WHEN '37' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[2].
                            OTHERWISE DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[3].
                       END CASE.
               END.
               
               /* ************************************************* */
               /* CARGAMOS EL PERIODO */
               IF DMOV-2.FchVto <= x-Sem1-2 THEN DMOV-2.t-periodo = x-Label-1.
               IF DMOV-2.FchVto >= x-Sem2-1 AND dmov-2.FchVto <= x-Sem2-2
                   THEN DMOV-2.t-periodo = x-Label-2.
               IF DMOV-2.FchVto >= x-Sem3-1 AND DMOV-2.FchVto <= x-Sem3-2
                   THEN DMOV-2.t-periodo = x-Label-3.
               IF DMOV-2.FchVto >= x-Sem4-1 AND DMOV-2.FchVto <= x-Sem4-2
                   THEN DMOV-2.t-periodo = x-Label-4.
               IF DMOV-2.FchVto >= x-Sem5-1 AND DMOV-2.FchVto <= x-Sem5-2
                   THEN DMOV-2.t-periodo = x-Label-5.
               IF DMOV-2.FchVto >= x-Sem6-1 THEN DMOV-2.t-periodo = x-Label-6.
               IF YEAR(DMOV-2.FchVto) < YEAR(TODAY) THEN DMOV-2.t-periodo = x-Label-1.
               IF YEAR(DMOV-2.FchVto) > YEAR(TODAY) THEN DMOV-2.t-periodo = x-Label-5.
               /* ************************************************* */

               /******************************************/
               DEF VAR x-Dias AS INT NO-UNDO.
               x-Dias = ABSOLUTE(TODAY - DMOV-2.FchVto).
               IF x-Dias <= 15 THEN DMOV-2.t-Indicador = "00-15".
               IF x-Dias > 15 AND x-Dias <= 30 THEN DMOV-2.t-Indicador = "16-30".
               IF x-Dias > 30 AND x-Dias <= 60 THEN DMOV-2.t-Indicador = "31-60".
               IF x-Dias > 60 AND x-Dias <= 90 THEN DMOV-2.t-Indicador = "61-90".
               IF x-Dias > 90 THEN DMOV-2.t-Indicador = "91-**".
               /******************************************/
                           
            END.
        END.
    END.
END.

/* HIDE FRAME F-PROCESO.                               */
/*                                                     */
/* RUN dispatch IN THIS-PROCEDURE ('open-query':U).    */
/* DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos W-Win 
PROCEDURE Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/*                       
DEFINE VARIABLE dImpMn1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE dImpMn2 AS DECIMAL NO-UNDO.
*/
DEFINE VARIABLE c-doc       AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-codaux    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-NroDoc    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-codbco    AS CHARACTER NO-UNDO.
DEFINE VARIABLE D-FchDes    AS DATE      NO-UNDO.
DEFINE VARIABLE D-FchHas    AS DATE      NO-UNDO.
DEFINE VARIABLE d-FchEmi-1  AS DATE      NO-UNDO.
DEFINE VARIABLE d-FchEmi-2  AS DATE      NO-UNDO.

ASSIGN 
    c-doc    = "" 
    x-codaux = ""
    x-NroDoc = ""
    x-codbco = "".
    /*
    D-FchDes = 01/01/2010
    D-FchHas = TODAY
    d-FchEmi-1 = 01/01/2010
    d-FchEmi-2 = TODAY.
    */

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 3 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.
FOR EACH DMOV-2:
    DELETE DMOV-2.
END.

/* RHC PARCHE: Corregimos las fechas de vencimiento */

FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
    Cp-tpro.CodDoc BEGINS C-doc AND
    /*LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND*/
    Cp-tpro.CORRELATIVO = YES :   
    IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
    IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.
    FOR EACH DETALLE WHERE DETALLE.CODCIA  = S-CODCIA  AND
        DETALLE.PERIODO = S-PERIODO      AND
        DETALLE.CODOPE  = CP-TPRO.CODOPE AND
        DETALLE.CODCTA  = CP-TPRO.CODCTA AND
        DETALLE.CodAux BEGINS x-codaux   AND
        DETALLE.CODDOC  = CP-TPRO.CODDOC AND
        DETALLE.NroDoc BEGINS x-NroDoc   AND
        DETALLE.FCHVTO = ?               AND
        DETALLE.TPOITM NE "N"            AND
        /*DETALLE.CODDIV BEGINS x-CodDiv   AND*/
        DETALLE.Codbco BEGINS x-codbco:

        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
            " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE @ fi-mensaje WITH FRAME {&FRAME-NAME}.
        DETALLE.FchVto = DETALLE.FchDoc.
    END.
END.


/* AHORA SI CARGAMOS LOS SALDOS POR DOCUMENTO */

FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
    Cp-tpro.CodDoc BEGINS C-doc AND
    /*LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND*/
    Cp-tpro.CORRELATIVO = YES :
    IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
    IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.

    FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS x-codaux   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroDoc BEGINS x-NroDoc   AND
        /*
             DETALLE.FCHVTO >= D-FchDes       AND
             DETALLE.FCHVTO <= D-FchHas       AND
             DETALLE.FCHDOC >= d-FchEmi-1     AND
             DETALLE.FCHDOC <= d-FchEmi-2     AND
        */             
             DETALLE.TPOITM NE "N"            AND
             /*DETALLE.CODDIV BEGINS x-CodDiv   AND*/
             DETALLE.Codbco BEGINS x-codbco
             BREAK BY DETALLE.CODDOC BY DETALLE.NRODOC :
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                     " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE @ fi-mensaje WITH FRAME {&FRAME-NAME}.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.

        FOR EACH cb-dmov NO-LOCK WHERE
            cb-dmov.CodCia = DETALLE.CODCIA AND
            cb-dmov.Periodo = DETALLE.PERIODO AND
            cb-dmov.Codcta  = DETALLE.CODCTA  AND
            cb-dmov.Codaux  = DETALLE.codaux  AND
            cb-dmov.CodDoc  = DETALLE.CodDoc  AND
            cb-dmov.NroDoc  = DETALLE.NroDoc:
            /*
            IF NOT cb-dmov.tpomov THEN 
                CASE x-codmon:
                    WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1.
                    WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
                END CASE.
            ELSE 
                CASE x-codmon:
                    WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1.
                    WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
                END CASE.
            */
            IF NOT cb-dmov.tpomov THEN DO:
                X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1.
                X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
            END.
            ELSE DO:
                X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1.
                X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
            END.
        END.
        IF X-IMPORT[1] = 0 AND X-IMPORT[2] = 0 THEN NEXT.
        /*
        ASSIGN 
            dImpMn1 = DETALLE.ImpMn1
            dImpMn2 = DETALLE.ImpMn2.
        */
        /* SOLO PASAN LAS 422 ACREEDORA */
        IF DETALLE.Codcta BEGINS "422" AND 
           NOT ( X-IMPORT[1] < 0 OR X-IMPORT[2] < 0 ) THEN NEXT.

/*
        /* CARGAMOS EL PERIODO */
        IF Detalle.FchCobranza <= x-Sem1-2 THEN Detalle.Periodo = x-Label-1.
        IF Detalle.FchCobranza >= x-Sem2-1 AND Ccbcdocu.FchCobranza <= x-Sem2-2
            THEN Detalle.Periodo = x-Label-2.
        IF Detalle.FchCobranza >= x-Sem3-1 AND Detalle.FchCobranza <= x-Sem3-2
            THEN Detalle.Periodo = x-Label-3.
        IF Detalle.FchCobranza >= x-Sem4-1 AND Detalle.FchCobranza <= x-Sem4-2
            THEN Detalle.Periodo = x-Label-4.
        IF Detalle.FchCobranza >= x-Sem5-1 AND Detalle.FchCobranza <= x-Sem5-2
            THEN Detalle.Periodo = x-Label-5.
        IF Detalle.FchCobranza >= x-Sem6-1 THEN Detalle.Periodo = x-Label-6.

*/
        IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
           (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
        /*IF ABSOLUTE(X-IMPORT[1]) > 0 OR ABSOLUTE(X-IMPORT[2]) > 0 THEN DO:*/
            /*
           IF c-doc = 'LP' AND x-codmon <> 3 THEN
              IF x-codmon <> DETALLE.CodMon THEN NEXT.
           */
           /*Busca Cabecera*/
           FIND FIRST cb-cmov OF Detalle NO-LOCK NO-ERROR.

           CREATE DMOV.
           ASSIGN DMOV.CODCIA = S-CODCIA
                  DMOV.NroAst = DETALLE.NroAst
                  DMOV.CodOpe = DETALLE.CodOpe
                  DMOV.cco    = DETALLE.cco   
                  DMOV.Clfaux = DETALLE.Clfaux
                  DMOV.CndCmp = DETALLE.CndCmp
                  DMOV.Codaux = DETALLE.Codaux
                  DMOV.Codcta = DETALLE.Codcta
                  DMOV.CodDiv = DETALLE.CodDiv
                  DMOV.Coddoc = DETALLE.Coddoc
                  DMOV.Codmon = DETALLE.Codmon
                  DMOV.Codref = DETALLE.Codref
                  DMOV.DisCCo = DETALLE.DisCCo
                  DMOV.Fchdoc = DETALLE.Fchdoc
                  DMOV.Fchvto = DETALLE.Fchvto
                  DMOV.flgact = DETALLE.flgact
                  DMOV.Glodoc = DETALLE.Glodoc
                  DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                  DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)                  
                  DMOV.Nrodoc = DETALLE.Nrodoc
                  DMOV.Nroref = DETALLE.NroRef
                  DMOV.Nroruc = DETALLE.Nroruc
                  DMOV.OrdCmp = DETALLE.OrdCmp
                  DMOV.tm     = DETALLE.tm
                  DMOV.Tpocmb = DETALLE.Tpocmb
                  DMOV.TpoMov = IF DETALLE.Codcta BEGINS "422" THEN DETALLE.TpoMov ELSE NOT DETALLE.TpoMov
                  DMOV.CodBco = DETALLE.CodBco
                  DMOV.t-FlgEst = cb-cmov.FlgEst.

            /* RHC 24.08.06 CALCULAMOS EL VENCIMIENTO PROYECTADO */
            CREATE DMOV-2.
            BUFFER-COPY DMOV TO DMOV-2.            
            FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
                AND GN-PROV.codpro = DMOV-2.CodAux NO-LOCK NO-ERROR.
            IF AVAILABLE GN-PROV AND GN-PROV.PrioridadPago <> '' THEN DO:
                FIND FacTabla WHERE FacTabla.codcia = s-codcia
                    AND FacTabla.Tabla = 'PP'
                    AND FacTabla.Codigo = GN-PROV.PrioridadPago
                    NO-LOCK NO-ERROR.
                IF AVAILABLE FacTabla 
                THEN CASE DMOV-2.CodDoc:
                        WHEN '01' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                        WHEN '37' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[2].
                        OTHERWISE DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                    END CASE.
            END.
            /* ************************************************* */
            /* CARGAMOS EL PERIODO */
            IF DMOV-2.FchVto <= x-Sem1-2 THEN DMOV-2.t-periodo = x-Label-1.
            IF DMOV-2.FchVto >= x-Sem2-1 AND dmov-2.FchVto <= x-Sem2-2
                THEN DMOV-2.t-periodo = x-Label-2.
            IF DMOV-2.FchVto >= x-Sem3-1 AND DMOV-2.FchVto <= x-Sem3-2
                THEN DMOV-2.t-periodo = x-Label-3.
            IF DMOV-2.FchVto >= x-Sem4-1 AND DMOV-2.FchVto <= x-Sem4-2
                THEN DMOV-2.t-periodo = x-Label-4.
            IF DMOV-2.FchVto >= x-Sem5-1 AND DMOV-2.FchVto <= x-Sem5-2
                THEN DMOV-2.t-periodo = x-Label-5.
            IF DMOV-2.FchVto >= x-Sem6-1 THEN DMOV-2.t-periodo = x-Label-6.
            /* ************************************************* */
        END.
    END.
END.

/*
FOR EACH DMOV ,
    FIRST DMOV-2 WHERE DMOV-2.CodCia = DMOV.CodCia
        AND DMOV-2.CodDoc = DMOV.CodDoc
        AND DMOV-2.NroDoc = DMOV.NroDoc
        AND DMOV-2.CodAux = DMOV.CodAux
        AND DMOV-2.CodCta = DMOV.CodCta
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:
     DISPLAY
         "'" + DMOV.CodAux
         "'" + STRING(DMOV.Coddoc,"99")
         "'" + DMOV.nrodoc
         DMOV.Fchdoc
         DMOV.FchVto
         DMOV-2.FchVto.
END.
*/
HIDE FRAME F-PROCESO.



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
  DISPLAY fi-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-3 Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEF VAR x-Column    AS INT INIT 74 NO-UNDO.
DEF VAR x-Range     AS CHAR        NO-UNDO.
DEF VAR x-importe   AS DECIMAL     NO-UNDO.
DEF VAR x-importemn AS DECIMAL     NO-UNDO.
DEF VAR x-situ      AS CHARACTER   NO-UNDO.
DEF VAR x-tpocmb    LIKE cb-dmov.tpocmb NO-UNDO.
DEF VAR x-moneda    AS CHAR        NO-UNDO.
DEF VAR x-desdoc    AS CHAR        NO-UNDO.

/*RUN Datos.*/
RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("C1"):Font:Bold = TRUE.

chWorkSheet:Range("A4:Q4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "CODIGO".
chWorkSheet:Range("B4"):Value = "PROVEEDOR".
chWorkSheet:Range("C4"):Value = "COD.DOC".
chWorkSheet:Range("D4"):Value = "NUMERO".
chWorkSheet:Range("E4"):Value = "EMISION".
chWorkSheet:Range("F4"):Value = "VENCIMIENTO".
/*
chWorkSheet:Range("G4"):Value = "SOLES".
chWorkSheet:Range("H4"):Value = "DOLARES".
*/
chWorkSheet:Range("G4"):Value = "VCTO. PROYECTADO".
chWorkSheet:Range("H4"):Value = "PERIODO".

chWorkSheet:Range("I4"):Value = "MONEDA".
chWorkSheet:Range("J4"):Value = "SALDO DOC".
chWorkSheet:Range("K4"):Value = "TIPO CAMBIO".
chWorkSheet:Range("L4"):Value = "SALDO S/.".
chWorkSheet:Range("M4"):Value = "SITUACION".
chWorkSheet:Range("N4"):Value = "MORA".
chWorkSheet:Range("O4"):Value = "INDICADOR".
chWorkSheet:Range("P4"):Value = "PRIORIDAD".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 4.

 FOR EACH DMOV ,
    LAST DMOV-2 WHERE DMOV-2.CodCia = DMOV.CodCia
        AND DMOV-2.CodDoc = DMOV.CodDoc
        AND DMOV-2.NroDoc = DMOV.NroDoc
        AND DMOV-2.CodAux = DMOV.CodAux
        AND DMOV-2.CodCta = DMOV.CodCta
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:
     
     x-dol = DMOV.ImpMn2.
     x-sol = DMOV.ImpMn1.     

     IF DMOV.CodMon = 1 THEN 
         ASSIGN 
            x-importe   = x-sol
            x-tpocmb    = 0
            x-importemn = x-importe
            x-moneda    = "S/.".
     IF DMOV.CodMon = 2 THEN 
         ASSIGN 
            x-importe = x-dol
            x-tpocmb  = DMOV.TpoCmb
            x-importemn = x-importe * x-tpocmb
            x-moneda    = "$".

     IF DMOV-2.FchVto < TODAY THEN x-situ = "2. Vencido".
     ELSE x-situ = "1. Por Vencer".

     IF DMOV.TpoMov THEN 
       ASSIGN X-sol = x-sol * (-1)
              X-dol = x-dol * (-1).

     x-DesDoc = "".
     /*Tipo Documento*/
     FIND FIRST cb-tabl WHERE cb-tabl.Tabla = "02"
         AND cb-tabl.Codigo = STRING(DMOV.Coddoc,"99") NO-LOCK NO-ERROR.
     IF AVAIL cb-tabl THEN x-DesDoc = cb-tabl.Nombre.
     ELSE x-DesDoc = "".

     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.CodAux.
     FIND Gn-Prov WHERE Gn-Prov.codcia = pv-codcia
        AND Gn-Prov.codpro = DMOV.CodAux
        NO-LOCK NO-ERROR.
     IF AVAILABLE Gn-Prov THEN DO:
         cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = Gn-Prov.NomPro.
     END.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = STRING(DMOV.Coddoc,"99") + "-" + x-DesDoc.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.nrodoc.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.Fchdoc.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.FchVto.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV-2.FchVto.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV-2.t-periodo.
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = x-moneda.
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = x-importe.
     cRange = "K" + cColumn.
     chWorkSheet:Range(cRange):Value = x-TpoCmb.
     cRange = "L" + cColumn.
     chWorkSheet:Range(cRange):Value = x-importemn.
     cRange = "M" + cColumn.
     chWorkSheet:Range(cRange):Value = x-situ.
     cRange = "N" + cColumn.
     chWorkSheet:Range(cRange):Value = TODAY - DMOV-2.FchVto.
     cRange = "O" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV-2.t-indicador.
     cRange = "P" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV-2.t-codprio.

    FI-MENSAJE = "    Documento Nro: " + DMOV.nrodoc.
    DISPLAY Fi-Mensaje WITH FRAME {&FRAME-NAME}.

 end.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

DISPLAY "" @ fi-mensaje WITH FRAME {&FRAME-NAME}.

MESSAGE 'Proceso Terminado con Éxito' VIEW-AS ALERT-BOX INFORMATION.

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

