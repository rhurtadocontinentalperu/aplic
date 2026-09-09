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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEFINE TEMP-TABLE tmp-tempo LIKE Almmmatg
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD t-rebate  AS DEC  FORMAT "->>>>>>>9.99".

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
&Scoped-Define ENABLED-OBJECTS BUTTON-4 DesdeF HastaF nCodMon x-Porcentaje ~
x-PorIgv BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS f-Licencias DesdeF HastaF nCodMon ~
x-Porcentaje x-PorIgv f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE f-Licencias AS CHARACTER FORMAT "X(256)":U 
     LABEL "Licencias" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Porcentaje AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "% de Regalia" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE x-PorIgv AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 19 
     LABEL "%IGV" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-Licencias AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 4
     BUTTON-4 AT ROW 1.81 COL 66 WIDGET-ID 6
     DesdeF AT ROW 2.88 COL 13 COLON-ALIGNED WIDGET-ID 8
     HastaF AT ROW 2.88 COL 32 COLON-ALIGNED WIDGET-ID 10
     nCodMon AT ROW 3.96 COL 15 NO-LABEL WIDGET-ID 14
     x-Porcentaje AT ROW 5.04 COL 13 COLON-ALIGNED WIDGET-ID 18
     x-PorIgv AT ROW 6.12 COL 13 COLON-ALIGNED WIDGET-ID 24
     BUTTON-1 AT ROW 7.35 COL 6 WIDGET-ID 20
     BUTTON-2 AT ROW 7.35 COL 15 WIDGET-ID 22
     f-Mensaje AT ROW 7.46 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.23 COL 6 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.19
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
         TITLE              = "REPORTE DE REGALIAS"
         HEIGHT             = 9.19
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-Licencias IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE REGALIAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE REGALIAS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
    f-Licencias DesdeF HastaF x-Porcentaje nCodMon x-PorIgv.
  IF f-Licencias = '' OR x-PorIgv <= 0
      OR x-Porcentaje <= 0 THEN DO:
      MESSAGE 'Complete la informaciñon solicitada' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Licencias AS CHAR.
  x-Licencias = f-Licencias:SCREEN-VALUE.
  RUN vta/d-repo09 (INPUT-OUTPUT x-Licencias).
  f-Licencias:SCREEN-VALUE = x-Licencias.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Regalias W-Win 
PROCEDURE Carga-Regalias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i      AS INTEGER NO-UNDO.
    DEFINE VARIABLE dTotMn AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTotMe AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTotRe AS DECIMAL NO-UNDO.
    DEFINE VAR X-FECHA AS DATE.
    DEFINE VAR X-CODDIA AS INTEGER INIT 1.
    DEFINE VAR X-CODANO AS INTEGER .
    DEFINE VAR X-CODMES AS INTEGER .    
    DEFINE VAR dTotPor AS DECIMAL NO-UNDO.

    /*Calcula Rebates*/                                                                 
    FOR EACH tmp-tempo NO-LOCK:                
        FOR EACH gn-clier WHERE gn-clier.codcia = cl-codcia NO-LOCK:      
            dTotRe = 0.
            FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:            
                FOR EACH evtclarti USE-INDEX Llave03 WHERE evtclarti.codcia = gn-divi.codcia
                    AND evtclarti.coddiv = gn-divi.coddiv 
                    AND evtclarti.codcli = gn-clier.codcli
                    AND evtclarti.codmat = tmp-tempo.codmat                
                    AND (evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                    AND evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ) NO-LOCK:

                    IF evtclarti.Codmes < 12 THEN DO:
                        ASSIGN
                            X-CODMES = evtclarti.Codmes + 1
                            X-CODANO = evtclarti.Codano.
                    END.
                    ELSE DO: 
                        ASSIGN
                            X-CODMES = 01
                            X-CODANO = evtclarti.Codano + 1 .
                    END.
                    dTotMn = 0.
                    dTotMe = 0.
                    DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                        X-FECHA = DATE(STRING(I,"99") + "/" + STRING(evtclarti.Codmes,"99") + "/" + STRING(evtclarti.Codano,"9999")).
                        IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                            FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(evtclarti.Codmes,"99") + "/" + STRING(evtclarti.Codano,"9999")) NO-LOCK NO-ERROR.
                            IF AVAILABLE Gn-tcmb THEN DO: 
                                dTotMn   = dTotmn   + EvtclArti.Vtaxdiamn[I] + EvtclArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                                dTotMe   = dTotme   + EvtclArti.Vtaxdiame[I] + EvtclArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                            END.
                        END.
                    END.  
                    dTotRe = dTotRe + IF ncodmon = 1 THEN dTotMn ELSE dTotMe.                                        
                END.                        
            END.
            /*
            t-Rebate = ((T-Venta[10] - dTotRe ) / ( 1 + x-PorIgv / 100) ) + 
                (( dTotRe  - (dTotRe * gn-clier.porrbt / 100)) / ( 1 + x-PorIgv / 100)).  
            */
            t-rebate = t-rebate + ((dTotRe / ( 1 + x-PorIgv / 100)) * gn-clier.porrbt / 100 ) .            
        END.
        /*t-Rebate = t-Rebate * x-Porcentaje / 100.*/
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR i AS INT NO-UNDO.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .

DEFINE VAR x-rebate AS DEC NO-UNDO.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/

    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
        AND  LOOKUP(Almmmatg.Licencia[1], f-Licencias) > 0:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando: ' + Almmmatg.codmat.
        FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
            FOR EACH EvtArti NO-LOCK WHERE EvtArti.CodCia = S-CODCIA
                AND   EvtArti.CodDiv = Gn-Divi.Coddiv
                AND   EvtArti.Codmat = Almmmatg.codmat                
                AND   (EvtArti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                AND   EvtArti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
                BREAK BY evtarti.codmat:
                T-Vtamn   = 0.
                T-Vtame   = 0.
                T-Ctomn   = 0.
                T-Ctome   = 0.
                F-Salida  = 0.
                /*****************Capturando el Mes siguiente *******************/
                IF EvtArti.Codmes < 12 THEN DO:
                  ASSIGN
                  X-CODMES = EvtArti.Codmes + 1
                  X-CODANO = EvtArti.Codano.
                END.
                ELSE DO: 
                  ASSIGN
                  X-CODMES = 01
                  X-CODANO = EvtArti.Codano + 1 .
                END.
                /*********************** Calculo Para Obtener los datos diarios ************/
                 DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                      X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtArti.Codmes,"99") + "/" + STRING(EvtArti.Codano,"9999")).
                      IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                          FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtArti.Codmes,"99") + "/" + STRING(EvtArti.Codano,"9999")) NO-LOCK NO-ERROR.
                          IF AVAILABLE Gn-tcmb THEN DO: 
                              F-Salida  = F-Salida  + EvtArti.CanxDia[I].
                              T-Vtamn   = T-Vtamn   + EvtArti.Vtaxdiamn[I] + EvtArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                              T-Vtame   = T-Vtame   + EvtArti.Vtaxdiame[I] + EvtArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                              T-Ctomn   = T-Ctomn   + EvtArti.Ctoxdiamn[I] + EvtArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                              T-Ctome   = T-Ctome   + EvtArti.Ctoxdiame[I] + EvtArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                          END.
                      END.
                 END.         
                /******************************************************************************/      
                FIND tmp-tempo OF Almmmatg NO-ERROR.
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  BUFFER-COPY Almmmatg TO tmp-tempo.
                END.
                ASSIGN 
                    T-Canti[10] = T-Canti[10] + F-Salida 
                    T-Venta[10] = T-Venta[10] + IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame 
                    T-Venta[9]  = T-Venta[10] / ( 1 + x-PorIgv / 100) * x-Porcentaje / 100.  
            END.
        END.
    END.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY f-Licencias DesdeF HastaF nCodMon x-Porcentaje x-PorIgv f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 DesdeF HastaF nCodMon x-Porcentaje x-PorIgv BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Moneda AS CHAR FORMAT 'x(10)'.
  DEF VAR x-Nombre AS CHAR FORMAT 'x(30)'.
  DEF VAR dRegReb  AS DEC  NO-UNDO.
  DEF VAR dRegFin  AS DEC  NO-UNDO.
  
  ASSIGN
    x-Moneda = IF nCodMon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES'.
    
  DEFINE FRAME F-Cab
      tmp-tempo.licencia[1]     COLUMN-LABEL 'Licencia'
      tmp-tempo.codmat          COLUMN-LABEL 'Producto'
      tmp-tempo.desmat          COLUMN-LABEL 'Descripción'
      tmp-tempo.desmar          COLUMN-LABEL 'Marca'
      tmp-tempo.undbas          COLUMN-LABEL 'Unidad'
      tmp-tempo.t-canti[10]     COLUMN-LABEL 'Cantidad'
      tmp-tempo.t-venta[10]     COLUMN-LABEL 'Ventas'
      x-Porcentaje              COLUMN-LABEL '% Regalias'
      tmp-tempo.t-venta[9]      COLUMN-LABEL 'Regalias'
      tmp-tempo.t-rebate        COLUMN-LABEL 'Rebate'
      dRegReb                   COLUMN-LABEL 'Rebate x Regalia'
      dRegFin                   COLUMN-LABEL 'Regalia Final'
      HEADER
      S-NOMCIA FORMAT 'X(50)' SKIP
      "REPORTE DE REGALIAS" AT 30
      "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
      "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
      "IGV: " x-PorIgv SKIP
      "DESDE EL: " DesdeF " HASTA EL: " HastaF  SKIP

      "EXPRESADO EN " x-Moneda SKIP(1)
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

  FOR EACH tmp-tempo BREAK BY tmp-tempo.codcia:
      dRegReb = tmp-tempo.t-rebate * x-porcentaje / 100.
      dRegFin = (tmp-tempo.t-venta[9] - dRegReb).

      ACCUMULATE tmp-tempo.t-canti[10] (TOTAL BY tmp-tempo.codcia).
      ACCUMULATE tmp-tempo.t-venta[10] (TOTAL BY tmp-tempo.codcia).
      ACCUMULATE tmp-tempo.t-venta[9]  (TOTAL BY tmp-tempo.codcia).
      ACCUMULATE tmp-tempo.t-Rebate    (TOTAL BY tmp-tempo.codcia).
      ACCUMULATE dRegReb               (TOTAL BY tmp-tempo.codcia).
      ACCUMULATE dRegFin               (TOTAL BY tmp-tempo.codcia).
      DISPLAY STREAM REPORT
          tmp-tempo.licencia[1]
          tmp-tempo.codmat
          tmp-tempo.desmat
          tmp-tempo.desmar
          tmp-tempo.undbas
          tmp-tempo.t-canti[10]
          tmp-tempo.t-venta[10]
          x-Porcentaje
          tmp-tempo.t-venta[9]
          tmp-tempo.t-rebate
          dRegReb
          dRegFin
          WITH FRAME F-Cab.
      IF LAST-OF(tmp-tempo.codcia) THEN DO:
          UNDERLINE STREAM REPORT 
              tmp-tempo.t-canti[10]
              tmp-tempo.t-venta[10]
              tmp-tempo.t-venta[9]
              tmp-tempo.t-rebate
              dRegReb
              dRegFin
              WITH FRAME F-Cab.
          DOWN STREAM REPORT WITH FRAME F-Cab.
          DISPLAY STREAM REPORT
              ACCUM TOTAL BY tmp-tempo.codcia tmp-tempo.t-canti[10] @ tmp-tempo.t-canti[10]
              ACCUM TOTAL BY tmp-tempo.codcia tmp-tempo.t-venta[10] @ tmp-tempo.t-venta[10]
              ACCUM TOTAL BY tmp-tempo.codcia tmp-tempo.t-venta[9]  @ tmp-tempo.t-venta[9]
              ACCUM TOTAL BY tmp-tempo.codcia tmp-tempo.t-rebate    @ tmp-tempo.t-Rebate
              ACCUM TOTAL BY tmp-tempo.codcia dRegReb               @ dRegReb
              ACCUM TOTAL BY tmp-tempo.codcia dRegFin               @ dRegFin
              WITH FRAME F-Cab.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   
       
    RUN Carga-Temporal.
    RUN Carga-Regalias.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

