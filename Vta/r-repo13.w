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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF TEMP-TABLE tmp-tempo
    FIELD t-codcia LIKE Almmmatg.codcia
    FIELD t-codmat LIKE Almmmatg.codmat
    FIELD t-desmat LIKE Almmmatg.desmat
    FIELD t-desmar LIKE Almmmatg.desmar
    FIELD t-codfam LIKE Almmmatg.codfam
    FIELD t-subfam LIKE Almmmatg.subfam
    FIELD t-undbas LIKE Almmmatg.undbas
    FIELD t-vta1 AS DEC
    FIELD t-vta2 AS DEC
    FIELD t-vta3 AS DEC
    FIELD t-vta14 AS DEC
    FIELD t-vta11 AS DEC
    FIELD t-vta15 AS DEC
    FIELD t-vta5 AS DEC
    FIELD t-vta8 AS DEC
    FIELD t-vta0 AS DEC
    FIELD t-vtasup AS DEC
    FIELD t-vtapro AS DEC
    FIELD t-vtaofi AS DEC
    FIELD t-vtaofi1 AS DEC
    FIELD t-vtaofi2 AS DEC
    FIELD t-can1 AS DEC
    FIELD t-can2 AS DEC
    FIELD t-can3 AS DEC
    FIELD t-can14 AS DEC
    FIELD t-can11 AS DEC
    FIELD t-can15 AS DEC
    FIELD t-can5 AS DEC
    FIELD t-can8 AS DEC
    FIELD t-can0 AS DEC
    FIELD t-cansup AS DEC
    FIELD t-canpro AS DEC
    FIELD t-canofi AS DEC
    FIELD t-canofi1 AS DEC
    FIELD t-canofi2 AS DEC
    INDEX llave01 t-codcia t-codmat.

DEFINE TEMP-TABLE tmp-cliente 
    FIELD t-codcli LIKE gn-clie.codcli
    FIELD t-nomcli LIKE gn-clie.nomcli
    FIELD t-codven LIKE gn-clie.codven
    FIELD t-canal  LIKE gn-clie.canal
    FIELD t-coddept LIKE gn-clie.coddept
    FIELD t-codprov LIKE gn-clie.codprov
    FIELD t-coddist LIKE gn-clie.coddist
    FIELD t-codmat LIKE Almmmatg.codmat
    FIELD t-desmat LIKE Almmmatg.desmat
    FIELD t-desmar LIKE Almmmatg.desmar
    FIELD t-codfam LIKE Almmmatg.codfam
    FIELD t-subfam LIKE Almmmatg.subfam
    FIELD t-undbas LIKE Almmmatg.undbas
    FIELD t-vta AS DEC
    FIELD t-can AS DEC
    FIELD t-clfcli LIKE gn-clie.clfcli.

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
&Scoped-Define ENABLED-OBJECTS f-CodFam f-SubFam DesdeF HastaF RADIO-SET-3 ~
RADIO-SET-2 nCodMon Btn_Excel Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS f-CodFam x-NomFam f-SubFam x-NomSub DesdeF ~
HastaF RADIO-SET-3 RADIO-SET-2 nCodMon f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE f-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-familia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cantidades", 1,
"Importes", 2
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-3 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumen por producto", 1,
"Resumen por producto y cliente ATE", 2,
"Resumen por cliente", 3
     SIZE 32 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-CodFam AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 12
     x-NomFam AT ROW 2.08 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     f-SubFam AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 18
     x-NomSub AT ROW 3.15 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     DesdeF AT ROW 4.23 COL 9 COLON-ALIGNED WIDGET-ID 20
     HastaF AT ROW 4.23 COL 28 COLON-ALIGNED WIDGET-ID 22
     RADIO-SET-3 AT ROW 4.23 COL 46 NO-LABEL WIDGET-ID 32
     RADIO-SET-2 AT ROW 5.31 COL 11 NO-LABEL WIDGET-ID 24
     nCodMon AT ROW 6.38 COL 11 NO-LABEL WIDGET-ID 6
     Btn_Excel AT ROW 7.46 COL 3 WIDGET-ID 2
     Btn_Cancel AT ROW 7.46 COL 16 WIDGET-ID 4
     f-Mensaje AT ROW 7.46 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 5.31 COL 7 WIDGET-ID 28
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6.38 COL 4 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.31
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "ESTADISTICA DE VENTAS X ARTICULO X DIVISION"
         HEIGHT             = 9.31
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
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomSub IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ESTADISTICA DE VENTAS X ARTICULO X DIVISION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ESTADISTICA DE VENTAS X ARTICULO X DIVISION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:                            
    ASSIGN
        DesdeF f-CodFam f-SubFam HastaF nCodMon RADIO-SET-2 RADIO-SET-3.
    SESSION:SET-WAIT-STATE('GENERAL').
    CASE RADIO-SET-3:
        WHEN 1 THEN RUN Excel. 
        WHEN 2 THEN RUN Excel-2. 
        WHEN 3 THEN RUN Excel-3. 
    END CASE.
    
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-CodFam W-Win
ON LEAVE OF f-CodFam IN FRAME F-Main /* Familia */
DO:
  x-nomfam:SCREEN-VALUE = ''.
  FIND almtfami WHERE almtfami.codcia = s-codcia
      AND almtfami.codfam = f-codfam:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE almtfami THEN x-nomfam:SCREEN-VALUE =  Almtfami.desfam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-SubFam W-Win
ON LEAVE OF f-SubFam IN FRAME F-Main /* Sub-familia */
DO:
    x-nomsub:SCREEN-VALUE = ''.
    FIND almsfami WHERE almsfami.codcia = s-codcia
        AND almsfami.codfam = f-codfam:SCREEN-VALUE
        AND almsfami.subfam = f-subfam:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE almsfami THEN x-nomsub:SCREEN-VALUE =  Almsfami.dessub.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temp W-Win 
PROCEDURE Carga-Temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA: 
    FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = gn-divi.codcia
        AND Evtarti.CodDiv = Gn-Divi.Coddiv
        AND ( Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST Almmmatg OF EvtArti WHERE Almmmatg.codfam BEGINS F-CodFam
            AND Almmmatg.subfam BEGINS F-Subfam NO-LOCK:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.

        T-Vtamn   = 0.
        T-Vtame   = 0.
        T-Ctomn   = 0.
        T-Ctome   = 0.
        F-Salida  = 0.
        /*****************Capturando el Mes siguiente *******************/
        IF Evtarti.Codmes < 12 THEN DO:
          ASSIGN
          X-CODMES = Evtarti.Codmes + 1
          X-CODANO = Evtarti.Codano .
        END.
        ELSE DO: 
          ASSIGN
          X-CODMES = 01
          X-CODANO = Evtarti.Codano + 1 .
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
           X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
           IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
               FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) 
                   NO-LOCK NO-ERROR.
               IF AVAILABLE Gn-tcmb THEN DO: 
                   F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                   T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                   T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                   T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                   T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
               END.
           END.
       END.         
       /******************************************************************************/      
       FIND tmp-tempo WHERE t-codcia  = S-CODCIA
           AND  t-codmat  = Evtarti.codmat
           NO-ERROR.
       IF NOT AVAIL tmp-tempo THEN DO:
         CREATE tmp-tempo.
         ASSIGN t-codcia  = S-CODCIA
                t-codfam  = Almmmatg.codfam 
                t-subfam  = Almmmatg.subfam
                t-codmat  = Evtarti.codmat
                t-desmat  = Almmmatg.DesMat
                t-desmar  = Almmmatg.DesMar
                t-undbas  = Almmmatg.UndBas.
       END.
       CASE gn-divi.coddiv:
           WHEN '00001' THEN DO:
               ASSIGN
                   t-Vta1 = t-Vta1 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can1 = t-Can1 + f-Salida.
           END.
           WHEN '00002' THEN DO:
               ASSIGN
                   t-Vta2 = t-Vta2 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can2 = t-Can2 + f-Salida.
           END.
           WHEN '00003' THEN DO:
               ASSIGN
                   t-Vta3 = t-Vta3 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can3 = t-Can3 + f-Salida.
           END.
           WHEN '00014' THEN DO:
               ASSIGN
                   t-Vta14 = t-Vta14 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can14 = t-Can14 + f-Salida.
           END.
           WHEN '00011' THEN DO:
               ASSIGN
                   t-Vta11 = t-Vta11 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can11 = t-Can11 + f-Salida.
           END.
           WHEN '00015' THEN DO:
               ASSIGN
                   t-Vta15 = t-Vta15 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can15 = t-Can15 + f-Salida.
           END.
           WHEN '00005' THEN DO:
               ASSIGN
                   t-Vta5 = t-Vta5 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can5 = t-Can5 + f-Salida.
           END.
           WHEN '00008' THEN DO:
               ASSIGN
                   t-Vta8 = t-Vta8 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can8 = t-Can8 + f-Salida.
           END.
           WHEN '00000' THEN DO:
               ASSIGN
                   t-Vta0 = t-Vta0 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                   t-Can0 = t-Can0 + f-Salida.
           END.
       END CASE.
    END.
END.


/* VENTAS POR CANAL */
Head:
FOR EACH EvtClArti NO-LOCK WHERE EvtClArti.CodCia = S-CODCIA
    AND EvtClArti.CodDiv = '00000'
    /*AND EvtClArti.Codmat = Almmmatg.codmat*/
    AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
    FIRST Almmmatg OF EvtClArti WHERE Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.subfam BEGINS F-Subfam NO-LOCK:
    
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.

    FIND FIRST Gn-Clie WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Clie THEN NEXT Head.

    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    F-Salida  = 0.
    /*****************Capturando el Mes siguiente *******************/
    IF EvtClArti.Codmes < 12 THEN DO:
        ASSIGN
            X-CODMES = EvtClArti.Codmes + 1
            X-CODANO = EvtClArti.Codano .
    END.
    ELSE DO: 
        ASSIGN
            X-CODMES = 01
            X-CODANO = EvtClArti.Codano + 1 .
    END.
    /*********************** Calculo Para Obtener los datos diarios ************/
   DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
        X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
        IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
            FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-tcmb THEN DO: 
                F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
            END.
        END.
   END.         
   /******************************************************************************/      
   FIND tmp-tempo WHERE t-codcia  = S-CODCIA
       AND  t-codmat  = EvtClArti.codmat NO-ERROR.
   IF NOT AVAIL tmp-tempo THEN DO:
     CREATE tmp-tempo.
     ASSIGN t-codcia  = S-CODCIA
            t-codfam  = Almmmatg.codfam 
            t-subfam  = Almmmatg.subfam
            t-codmat  = EvtClArti.codmat
            t-desmat  = Almmmatg.DesMat
            t-desmar  = Almmmatg.DesMar
            t-undbas  = Almmmatg.UndBas.
   END.
   CASE Gn-clie.canal:
       WHEN '0005' THEN DO:
           ASSIGN
               t-VtaPro = t-VtaPro + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
               t-CanPro = t-CanPro + f-Salida.
       END.
       WHEN '0008' THEN DO:
           ASSIGN
               t-VtaSup = t-VtaSup + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
               t-CanSup = t-CanSup + f-Salida.
       END.
       WHEN '0001' THEN DO:
           ASSIGN
               t-VtaOfi1 = t-VtaOfi1 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
               t-CanOfi1 = t-CanOfi1 + f-Salida.
       END.
       WHEN '0003' THEN DO:
           ASSIGN
               t-VtaOfi2 = t-VtaOfi2 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
               t-CanOfi2 = t-CanOfi2 + f-Salida.
       END.
       OTHERWISE DO:
           ASSIGN
               t-VtaOfi = t-VtaOfi + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
               t-CanOfi = t-CanOfi + f-Salida.
       END.
   END CASE.
END.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temp-2 W-Win 
PROCEDURE Carga-Temp-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-cliente :
  DELETE tmp-cliente.
END.

/* VENTAS POR CANAL */
Head:
FOR EACH EvtClArti NO-LOCK USE-INDEX Llave04
    WHERE EvtClArti.CodCia = S-CODCIA
    AND EvtClArti.CodDiv = '00000'
    AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
          AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
    FIRST Almmmatg OF EvtClArti NO-LOCK
        WHERE Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.subfam BEGINS F-Subfam:

    FIND FIRST Gn-Clie WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli NO-LOCK NO-ERROR.

    IF NOT AVAIL Gn-Clie THEN NEXT Head.

    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.

    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    F-Salida  = 0.
    /*****************Capturando el Mes siguiente *******************/
    IF EvtClArti.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = EvtClArti.Codmes + 1
      X-CODANO = EvtClArti.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = EvtClArti.Codano + 1 .
    END.
    /*********************** Calculo Para Obtener los datos diarios ************/
    DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
        X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
        IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
            FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-tcmb THEN DO: 
                F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
            END.
        END.
    END.         

    /******************************************************************************/      
    FIND tmp-cliente WHERE t-codcli  = EvtClArti.codcli 
        AND t-codmat = Evtclarti.codmat NO-ERROR.
    IF NOT AVAIL tmp-cliente THEN DO:
        CREATE tmp-cliente.
        ASSIGN 
            tmp-cliente.t-codcli = Evtclarti.codcli
            tmp-cliente.t-nomcli = gn-clie.nomcli
            tmp-cliente.t-codven = gn-clie.codven
            tmp-cliente.t-canal  = gn-clie.canal
            tmp-cliente.t-coddept = gn-clie.coddept
            tmp-cliente.t-codprov = gn-clie.codprov
            tmp-cliente.t-coddist = gn-clie.coddist
            tmp-cliente.t-codmat = almmmatg.codmat
            tmp-cliente.t-desmat = almmmatg.desmat
            tmp-cliente.t-desmar = almmmatg.desmar
            tmp-cliente.t-codfam = almmmatg.codfam
            tmp-cliente.t-subfam = almmmatg.subfam
            tmp-cliente.t-undbas = almmmatg.undbas
            tmp-cliente.t-clfcli = gn-clie.clfcli.
    END.
    ASSIGN
        tmp-cliente.t-Vta = tmp-cliente.t-Vta + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
        tmp-cliente.t-Can = tmp-cliente.t-Can + f-Salida.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temp-3 W-Win 
PROCEDURE Carga-Temp-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-cliente :
  DELETE tmp-cliente.
END.

/* VENTAS POR CANAL */
Head:
FOR EACH EvtClArti NO-LOCK USE-INDEX Llave04
    WHERE EvtClArti.CodCia = S-CODCIA
    AND EvtClArti.CodDiv = '00000'
    AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
          AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
    FIRST Almmmatg OF EvtClArti WHERE Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.subfam BEGINS F-Subfam NO-LOCK:

    FIND FIRST Gn-Clie WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Clie THEN NEXT Head.

    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    F-Salida  = 0.
    /*****************Capturando el Mes siguiente *******************/
    IF EvtClArti.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = EvtClArti.Codmes + 1
      X-CODANO = EvtClArti.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = EvtClArti.Codano + 1 .
    END.
    /*********************** Calculo Para Obtener los datos diarios ************/
   DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
        X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
        IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
            FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-tcmb THEN DO: 
                F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
            END.
        END.
   END.         
   /******************************************************************************/      
   FIND tmp-cliente WHERE t-codcli  = EvtClArti.codcli 
       NO-ERROR.
   IF NOT AVAIL tmp-cliente THEN DO:
     CREATE tmp-cliente.
     ASSIGN 
         tmp-cliente.t-codcli = Evtclarti.codcli
         tmp-cliente.t-nomcli = gn-clie.nomcli
         tmp-cliente.t-codven = gn-clie.codven
         tmp-cliente.t-canal  = gn-clie.canal
         tmp-cliente.t-coddept = gn-clie.coddept
         tmp-cliente.t-codprov = gn-clie.codprov
         tmp-cliente.t-coddist = gn-clie.coddist
         tmp-cliente.t-codmat = almmmatg.codmat
         tmp-cliente.t-desmat = almmmatg.desmat
         tmp-cliente.t-desmar = almmmatg.desmar
         tmp-cliente.t-codfam = almmmatg.codfam
         tmp-cliente.t-subfam = almmmatg.subfam
         tmp-cliente.t-undbas = almmmatg.undbas
         tmp-cliente.t-clfcli = gn-clie.clfcli.
   END.
   ASSIGN
       tmp-cliente.t-Vta = tmp-cliente.t-Vta + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
       tmp-cliente.t-Can = tmp-cliente.t-Can + f-Salida.
END.


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

/*
DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codfam BEGINS F-CodFam
    AND Almmmatg.subfam BEGINS F-Subfam
    USE-INDEX matg09:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA: 
        FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
            AND Evtarti.CodDiv = Gn-Divi.Coddiv
            AND Evtarti.Codmat = Almmmatg.codmat
            AND ( Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
            AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
            T-Vtamn   = 0.
            T-Vtame   = 0.
            T-Ctomn   = 0.
            T-Ctome   = 0.
            F-Salida  = 0.
            /*****************Capturando el Mes siguiente *******************/
            IF Evtarti.Codmes < 12 THEN DO:
              ASSIGN
              X-CODMES = Evtarti.Codmes + 1
              X-CODANO = Evtarti.Codano .
            END.
            ELSE DO: 
              ASSIGN
              X-CODMES = 01
              X-CODANO = Evtarti.Codano + 1 .
            END.
            /*********************** Calculo Para Obtener los datos diarios ************/
           DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
                IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                    FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) 
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Gn-tcmb THEN DO: 
                        F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                        T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                        T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                        T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                        T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                    END.
                END.
           END.         
           /******************************************************************************/      
           FIND tmp-tempo WHERE t-codcia  = S-CODCIA
               AND  t-codmat  = Evtarti.codmat
               NO-ERROR.
           IF NOT AVAIL tmp-tempo THEN DO:
             CREATE tmp-tempo.
             ASSIGN t-codcia  = S-CODCIA
                    t-codfam  = Almmmatg.codfam 
                    t-subfam  = Almmmatg.subfam
                    t-codmat  = Evtarti.codmat
                    t-desmat  = Almmmatg.DesMat
                    t-desmar  = Almmmatg.DesMar
                    t-undbas  = Almmmatg.UndBas.
           END.
           CASE gn-divi.coddiv:
            WHEN '00001' THEN DO:
                ASSIGN
                    t-Vta1 = t-Vta1 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can1 = t-Can1 + f-Salida.
            END.
            WHEN '00002' THEN DO:
                ASSIGN
                    t-Vta2 = t-Vta2 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can2 = t-Can2 + f-Salida.
            END.
            WHEN '00003' THEN DO:
                ASSIGN
                    t-Vta3 = t-Vta3 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can3 = t-Can3 + f-Salida.
            END.
            WHEN '00014' THEN DO:
                ASSIGN
                    t-Vta14 = t-Vta14 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can14 = t-Can14 + f-Salida.
            END.
            WHEN '00011' THEN DO:
                ASSIGN
                    t-Vta11 = t-Vta11 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can11 = t-Can11 + f-Salida.
            END.
            WHEN '00015' THEN DO:
                ASSIGN
                    t-Vta15 = t-Vta15 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can15 = t-Can15 + f-Salida.
            END.
            WHEN '00005' THEN DO:
                ASSIGN
                    t-Vta5 = t-Vta5 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can5 = t-Can5 + f-Salida.
            END.
            WHEN '00008' THEN DO:
                ASSIGN
                    t-Vta8 = t-Vta8 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can8 = t-Can8 + f-Salida.
            END.
            WHEN '00000' THEN DO:
                ASSIGN
                    t-Vta0 = t-Vta0 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                    t-Can0 = t-Can0 + f-Salida.
            END.
           END CASE.
        END.
    END.
END.

/* VENTAS POR CANAL */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codfam BEGINS F-CodFam
    AND Almmmatg.subfam BEGINS F-Subfam
    USE-INDEX matg09:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    FOR EACH EvtClArti NO-LOCK WHERE EvtClArti.CodCia = S-CODCIA
        AND EvtClArti.CodDiv = '00000'
        AND EvtClArti.Codmat = Almmmatg.codmat
        AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST Gn-Clie NO-LOCK WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli:
        T-Vtamn   = 0.
        T-Vtame   = 0.
        T-Ctomn   = 0.
        T-Ctome   = 0.
        F-Salida  = 0.
        /*****************Capturando el Mes siguiente *******************/
        IF EvtClArti.Codmes < 12 THEN DO:
          ASSIGN
          X-CODMES = EvtClArti.Codmes + 1
          X-CODANO = EvtClArti.Codano .
        END.
        ELSE DO: 
          ASSIGN
          X-CODMES = 01
          X-CODANO = EvtClArti.Codano + 1 .
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
       /******************************************************************************/      
       FIND tmp-tempo WHERE t-codcia  = S-CODCIA
           AND  t-codmat  = EvtClArti.codmat
           NO-ERROR.
       IF NOT AVAIL tmp-tempo THEN DO:
         CREATE tmp-tempo.
         ASSIGN t-codcia  = S-CODCIA
                t-codfam  = Almmmatg.codfam 
                t-subfam  = Almmmatg.subfam
                t-codmat  = EvtClArti.codmat
                t-desmat  = Almmmatg.DesMat
                t-desmar  = Almmmatg.DesMar
                t-undbas  = Almmmatg.UndBas.
       END.
       CASE Gn-clie.canal:
        WHEN '0005' THEN DO:
            ASSIGN
                t-VtaPro = t-VtaPro + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanPro = t-CanPro + f-Salida.
        END.
        WHEN '0008' THEN DO:
            ASSIGN
                t-VtaSup = t-VtaSup + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanSup = t-CanSup + f-Salida.
        END.
        WHEN '0001' THEN DO:
            ASSIGN
                t-VtaOfi1 = t-VtaOfi1 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanOfi1 = t-CanOfi1 + f-Salida.
        END.
        WHEN '0003' THEN DO:
            ASSIGN
                t-VtaOfi2 = t-VtaOfi2 + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanOfi2 = t-CanOfi2 + f-Salida.
        END.
        OTHERWISE DO:
            ASSIGN
                t-VtaOfi = t-VtaOfi + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanOfi = t-CanOfi + f-Salida.
        END.
       END CASE.
    END.
END.

/* ******************************************************************************************
/* VENTAS POR VENDEDOR */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codfam BEGINS F-CodFam
    AND Almmmatg.subfam BEGINS F-Subfam
    USE-INDEX matg09:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    FOR EACH EvtVend NO-LOCK WHERE EvtVend.CodCia = S-CODCIA
        AND EvtVend.CodDiv = '00000'
        AND EvtVend.Codmat = Almmmatg.codmat
        AND ( EvtVend.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND EvtVend.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
        T-Vtamn   = 0.
        T-Vtame   = 0.
        T-Ctomn   = 0.
        T-Ctome   = 0.
        F-Salida  = 0.
        /*****************Capturando el Mes siguiente *******************/
        IF EvtVend.Codmes < 12 THEN DO:
          ASSIGN
          X-CODMES = EvtVend.Codmes + 1
          X-CODANO = EvtVend.Codano .
        END.
        ELSE DO: 
          ASSIGN
          X-CODMES = 01
          X-CODANO = EvtVend.Codano + 1 .
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + EvtVend.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + EvtVend.Vtaxdiamn[I] + EvtVend.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + EvtVend.Vtaxdiame[I] + EvtVend.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + EvtVend.Ctoxdiamn[I] + EvtVend.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + EvtVend.Ctoxdiame[I] + EvtVend.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
       /******************************************************************************/      
       FIND tmp-tempo WHERE t-codcia  = S-CODCIA
           AND  t-codmat  = EvtVend.codmat
           NO-ERROR.
       IF NOT AVAIL tmp-tempo THEN DO:
         CREATE tmp-tempo.
         ASSIGN t-codcia  = S-CODCIA
                t-codfam  = Almmmatg.codfam 
                t-subfam  = Almmmatg.subfam
                t-codmat  = EvtVend.codmat
                t-desmat  = Almmmatg.DesMat
                t-desmar  = Almmmatg.DesMar
                t-undbas  = Almmmatg.UndBas.
       END.
       CASE EvtVend.CodVen:
        WHEN '151' THEN DO:
            ASSIGN
                t-VtaSup = t-VtaSup + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanSup = t-CanSup + f-Salida.
        END.
        WHEN '173' OR WHEN '015' THEN DO:
            ASSIGN
                t-VtaPro = t-VtaPro + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanPro = t-CanPro + f-Salida.
        END.
        OTHERWISE DO:
            ASSIGN
                t-VtaOfi = t-VtaOfi + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
                t-CanOfi = t-CanOfi + f-Salida.
        END.
       END CASE.
    END.
END.
**************************************************************************************** */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 W-Win 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-cliente :
  DELETE tmp-cliente.
END.

/* VENTAS POR CANAL */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codfam BEGINS F-CodFam
    AND Almmmatg.subfam BEGINS F-Subfam
    USE-INDEX matg09:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    FOR EACH EvtClArti NO-LOCK WHERE EvtClArti.CodCia = S-CODCIA
        AND EvtClArti.CodDiv = '00000'
        AND EvtClArti.Codmat = Almmmatg.codmat
        AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST Gn-Clie NO-LOCK WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli:
        T-Vtamn   = 0.
        T-Vtame   = 0.
        T-Ctomn   = 0.
        T-Ctome   = 0.
        F-Salida  = 0.
        /*****************Capturando el Mes siguiente *******************/
        IF EvtClArti.Codmes < 12 THEN DO:
          ASSIGN
          X-CODMES = EvtClArti.Codmes + 1
          X-CODANO = EvtClArti.Codano .
        END.
        ELSE DO: 
          ASSIGN
          X-CODMES = 01
          X-CODANO = EvtClArti.Codano + 1 .
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
       /******************************************************************************/      
       FIND tmp-cliente WHERE t-codcli  = EvtClArti.codcli 
           AND t-codmat = Evtclarti.codmat
           NO-ERROR.
       IF NOT AVAIL tmp-cliente THEN DO:
         CREATE tmp-cliente.
         ASSIGN 
             tmp-cliente.t-codcli = Evtclarti.codcli
             tmp-cliente.t-nomcli = gn-clie.nomcli
             tmp-cliente.t-codven = gn-clie.codven
             tmp-cliente.t-canal  = gn-clie.canal
             tmp-cliente.t-coddept = gn-clie.coddept
             tmp-cliente.t-codprov = gn-clie.codprov
             tmp-cliente.t-coddist = gn-clie.coddist
             tmp-cliente.t-codmat = almmmatg.codmat
             tmp-cliente.t-desmat = almmmatg.desmat
             tmp-cliente.t-desmar = almmmatg.desmar
             tmp-cliente.t-codfam = almmmatg.codfam
             tmp-cliente.t-subfam = almmmatg.subfam
             tmp-cliente.t-undbas = almmmatg.undbas
             tmp-cliente.t-clfcli = gn-clie.clfcli.
       END.
       ASSIGN
           tmp-cliente.t-Vta = tmp-cliente.t-Vta + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
           tmp-cliente.t-Can = tmp-cliente.t-Can + f-Salida.
    END.
END.

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-3 W-Win 
PROCEDURE Carga-Temporal-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*

DEFINE VAR I         AS INTEGER   NO-UNDO.

DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

FOR EACH tmp-cliente :
  DELETE tmp-cliente.
END.

/* VENTAS POR CANAL */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codfam BEGINS F-CodFam
    AND Almmmatg.subfam BEGINS F-Subfam
    USE-INDEX matg09:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CODIGO: ' + Almmmatg.codmat.
    FOR EACH EvtClArti NO-LOCK WHERE EvtClArti.CodCia = S-CODCIA
        AND EvtClArti.CodDiv = '00000'
        AND EvtClArti.Codmat = Almmmatg.codmat
        AND ( EvtClArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND EvtClArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST Gn-Clie NO-LOCK WHERE Gn-Clie.codcia = cl-codcia
        AND Gn-Clie.codcli = EvtClArti.codcli:
        T-Vtamn   = 0.
        T-Vtame   = 0.
        T-Ctomn   = 0.
        T-Ctome   = 0.
        F-Salida  = 0.
        /*****************Capturando el Mes siguiente *******************/
        IF EvtClArti.Codmes < 12 THEN DO:
          ASSIGN
          X-CODMES = EvtClArti.Codmes + 1
          X-CODANO = EvtClArti.Codano .
        END.
        ELSE DO: 
          ASSIGN
          X-CODMES = 01
          X-CODANO = EvtClArti.Codano + 1 .
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha < DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + EvtClArti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
       /******************************************************************************/      
       FIND tmp-cliente WHERE t-codcli  = EvtClArti.codcli 
           NO-ERROR.
       IF NOT AVAIL tmp-cliente THEN DO:
         CREATE tmp-cliente.
         ASSIGN 
             tmp-cliente.t-codcli = Evtclarti.codcli
             tmp-cliente.t-nomcli = gn-clie.nomcli
             tmp-cliente.t-codven = gn-clie.codven
             tmp-cliente.t-canal  = gn-clie.canal
             tmp-cliente.t-coddept = gn-clie.coddept
             tmp-cliente.t-codprov = gn-clie.codprov
             tmp-cliente.t-coddist = gn-clie.coddist
             tmp-cliente.t-codmat = almmmatg.codmat
             tmp-cliente.t-desmat = almmmatg.desmat
             tmp-cliente.t-desmar = almmmatg.desmar
             tmp-cliente.t-codfam = almmmatg.codfam
             tmp-cliente.t-subfam = almmmatg.subfam
             tmp-cliente.t-undbas = almmmatg.undbas
             tmp-cliente.t-clfcli = gn-clie.clfcli.
       END.
       ASSIGN
           tmp-cliente.t-Vta = tmp-cliente.t-Vta + ( IF nCodMon = 1 THEN t-VtaMn ELSE t-VtaMe )
           tmp-cliente.t-Can = tmp-cliente.t-Can + f-Salida.
    END.
END.
*/

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
  DISPLAY f-CodFam x-NomFam f-SubFam x-NomSub DesdeF HastaF RADIO-SET-3 
          RADIO-SET-2 nCodMon f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-CodFam f-SubFam DesdeF HastaF RADIO-SET-3 RADIO-SET-2 nCodMon 
         Btn_Excel Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
/*
RUN Carga-temporal.
*/
RUN Carga-Temp.

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "LINEA".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUB-LINEA".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND.".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UCAYALI".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ANDAHUAYLAS".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PARURO".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "HORIZONTAL".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SAN JUAN".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "EXPOLIBRERIA".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "OBRERO".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SATELITE".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ATE".
cRange = "P" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUPERMERCADOS".
cRange = "Q" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVINCIAS".
cRange = "R" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "OFICINA ATE-PUBLICA".
cRange = "S" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "OFICINA ATE-PRIVADA".
cRange = "T" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "OFICINA ATE-OTROS".
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00001".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00002".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00003".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00014".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00011".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00015".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00005".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00008".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "'00000".

FOR EACH tmp-tempo BY t-codcia BY t-codfam BY t-subfam BY t-codmat:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-tempo.t-codmat.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-desmat.                                                                                                     
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-desmar.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-tempo.t-codfam.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-tempo.t-subfam.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-undbas.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta1 ELSE tmp-tempo.t-Can1 ).
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta2 ELSE tmp-tempo.t-Can2 ).
    cRange = "I" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta3 ELSE tmp-tempo.t-Can3 ).
    cRange = "J" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta14 ELSE tmp-tempo.t-Can14 ).
    cRange = "K" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta11 ELSE tmp-tempo.t-Can11 ).
    cRange = "L" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta15 ELSE tmp-tempo.t-Can15 ).
    cRange = "M" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta5 ELSE tmp-tempo.t-Can5 ).
    cRange = "N" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta8 ELSE tmp-tempo.t-Can8 ).
    cRange = "O" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-Vta0 ELSE tmp-tempo.t-Can0 ).
    cRange = "P" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-VtaSup ELSE tmp-tempo.t-CanSup ).
    cRange = "Q" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-VtaPro ELSE tmp-tempo.t-CanPro ).
    cRange = "R" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-VtaOfi1 ELSE tmp-tempo.t-CanOfi1 ).
    cRange = "S" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-VtaOfi2 ELSE tmp-tempo.t-CanOfi2 ).
    cRange = "T" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = ( IF RADIO-SET-2 = 2 THEN tmp-tempo.t-VtaOfi ELSE tmp-tempo.t-CanOfi ).
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*
RUN Carga-temporal-2.
*/
RUN Carga-Temp-2.

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "LINEA".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUB-LINEA".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND.".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CLIENTE".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VENDEDOR".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CANAL".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DEPARTAMENTO".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVINCIA".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DISTRITO".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CLASIFICACION".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = (IF RADIO-SET-2 = 1 THEN 'CANTIDAD' ELSE 'IMPORTE').

FOR EACH tmp-cliente BY t-codcli BY t-codfam BY t-subfam BY t-codmat:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codmat.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-cliente.t-desmat.                                                                                                     
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-cliente.t-desmar.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codfam.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-subfam.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-cliente.t-undbas.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codcli.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-cliente.t-nomcli.
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codven.
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-canal.
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-coddept.
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codprov.
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-coddist.
    cRange = "N" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-clfcli.
    cRange = "O" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = (IF RADIO-SET-2 = 1 THEN tmp-cliente.t-Can ELSE tmp-cliente.t-Vta).
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-3 W-Win 
PROCEDURE Excel-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
/*
RUN Carga-temporal-3.
*/
RUN Carga-Temp-3.

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CLIENTE".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VENDEDOR".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CANAL".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DEPARTAMENTO".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVINCIA".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DISTRITO".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CLASIFICACION".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = (IF RADIO-SET-2 = 1 THEN 'CANTIDAD' ELSE 'IMPORTE').

FOR EACH tmp-cliente BY t-codcli:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codcli.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-cliente.t-nomcli.
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codven.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-canal.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-coddept.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-codprov.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-coddist.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + tmp-cliente.t-clfcli.
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = (IF RADIO-SET-2 = 1 THEN tmp-cliente.t-Can ELSE tmp-cliente.t-Vta).
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  ASSIGN
      DesdeF = TODAY - DAY(TODAY) + 1
      HastaF = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "x-subfam" THEN
            ASSIGN
                input-var-1 = f-codfam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = ""
                input-var-3 = "".
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

