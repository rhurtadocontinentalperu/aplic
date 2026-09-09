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

IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock'
      VIEW-AS ALERT-BOX WARNING.
END.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle LIKE integral.Almmmatg
    FIELD StockConti   AS DEC EXTENT 50
    FIELD StockCissac  AS DEC EXTENT 50
    FIELD CtoUniConti  AS DEC 
    FIELD CtoUniCissac AS DEC    
/*RD01- Stock Comprometido*/
    FIELD StockComp    AS DEC EXTENT 20
    FIELD MndCosto     AS CHAR
    FIELD CtoLista     LIKE integral.almmmatg.ctolis.

DEF VAR x-AlmConti AS CHAR NO-UNDO.
DEF VAR x-AlmCissac AS CHAR NO-UNDO.

ASSIGN
    /*
    x-AlmConti = '10,10a,11,11e,11t,21,21e,21s,21f,22,17,18,03,03a,04,04a,05,05a,27,28,83b,35,35a,500,501,502,85,34,34e,35e'
    x-AlmCissac = '11,21,21s,21f,22,27,85'.
    */
    x-AlmConti = '11,11e,34,34e,32,38,39,35,35e,21,21d,21e,21s,03,04,05,11t,17,18,28,83b,22,10,10a,27,501,502,503,504,505,506,85,21f,21t,60,61'
    x-AlmCissac = '11,21,21d,21s,21f,85,21t'.

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
&Scoped-Define ENABLED-OBJECTS x-CodFam BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-CodFam f-Mensaje 

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
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.35.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodFam AT ROW 2.08 COL 22 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.08 COL 51 WIDGET-ID 4
     BtnDone AT ROW 2.08 COL 57 WIDGET-ID 12
     f-Mensaje AT ROW 4.23 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.69 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE STOCKS CONSOLIDADES CONTI Y CISSAC"
         HEIGHT             = 6.69
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
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE STOCKS CONSOLIDADES CONTI Y CISSAC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE STOCKS CONSOLIDADES CONTI Y CISSAC */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
   ASSIGN x-CodFam.
   RUN Excel.
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
  DEF VAR x-Orden AS INT NO-UNDO INIT 1.
  DEF VAR x-CanPed AS DEC NO-UNDO.

  DEF VAR pComprometido AS DECIMAL NO-UNDO.
  DEF VAR cCodAlm1 AS CHAR NO-UNDO.
  DEF VAR cCodAlm2 AS CHAR NO-UNDO.
  DEF VAR cCodAlm3 AS CHAR NO-UNDO.
  DEF VAR cCodAlm4 AS CHAR NO-UNDO.
  DEF VAR cCodAlm5 AS CHAR NO-UNDO.
  DEF VAR cCodAlm6 AS CHAR NO-UNDO.
  DEF VAR cCodAlm7 AS CHAR NO-UNDO.
  DEF VAR cCodAlm8 AS CHAR NO-UNDO.  /* Comas */
  DEF VAR cCodAlm9 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm10 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm11 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm12 AS CHAR NO-UNDO.  

  /*Caso expolibreria*/
  cCodAlm1 = "11".
  cCodAlm2 = "11e".
  cCodAlm3 = "34".
  cCodAlm4 = "34e".
  cCodAlm5 = "35".
  cCodAlm6 = "35e".
  cCodAlm7 = "21".
  cCodAlm8 = "21e".
  cCodAlm9 = "22".
  cCodAlm10 = "40".
  cCodAlm11 = "45".
  cCodAlm12 = "35a".

  IF NOT connected('cissac')
      THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
        'NO podemos capturar el stock'
        VIEW-AS ALERT-BOX WARNING.
  END.
  
  EMPTY TEMP-TABLE detalle.
  /* STOCKS CONTI */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmConti):
      FOR EACH integral.almmmate NO-LOCK WHERE integral.almmmate.codcia = s-codcia
          AND integral.almmmate.codalm = ENTRY(x-Orden, x-AlmConti)
          AND integral.almmmate.stkact <> 0,
          FIRST integral.almmmatg OF integral.almmmate NO-LOCK WHERE integral.almmmatg.codfam = x-codfam:
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
              integral.almmmatg.codmat + ' ' +
              integral.almmmatg.desmat.
          FIND detalle OF integral.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO: 
              CREATE detalle.
              BUFFER-COPY integral.almmmatg TO detalle.
              FIND integral.gn-prov WHERE integral.gn-prov.codcia = pv-codcia
                  AND integral.gn-prov.codpro = integral.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE integral.gn-prov THEN detalle.codpr1 = integral.gn-prov.codpro + ' ' + integral.gn-prov.nompro.
          END.
          ASSIGN 
          Detalle.StockConti[x-Orden] = integral.Almmmate.stkact + Detalle.StockConti[x-Orden]
          Detalle.CtoLista            = integral.Almmmatg.CtoLis.
          IF integral.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
          ELSE Detalle.MndCosto = "$".
      END.
  END.
  /* STOCKS CISSAC */
  /*
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmCissac):
      FOR EACH cissac.almmmate NO-LOCK WHERE cissac.almmmate.codcia = s-codcia
          AND cissac.almmmate.codalm = ENTRY(x-Orden, x-AlmCissac)
          AND cissac.almmmate.stkact <> 0,
          FIRST cissac.almmmatg OF cissac.almmmate NO-LOCK WHERE cissac.almmmatg.codfam = x-codfam:
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
              cissac.almmmatg.codmat + ' ' +
              cissac.almmmatg.desmat.
          FIND detalle OF cissac.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              BUFFER-COPY cissac.almmmatg TO detalle.
              FIND cissac.gn-prov WHERE cissac.gn-prov.codcia = pv-codcia
                  AND cissac.gn-prov.codpro = cissac.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE cissac.gn-prov THEN detalle.codpr1 = cissac.gn-prov.codpro + ' ' + cissac.gn-prov.nompro.
          END.
          ASSIGN 
              Detalle.StockCissac[x-Orden] = cissac.Almmmate.stkact + Detalle.StockCissac[x-Orden] .

          IF Detalle.CtoLista <= 0 THEN DO:
              ASSIGN Detalle.CtoLista  = cissac.Almmmatg.CtoLis.
              IF cissac.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
              ELSE Detalle.MndCosto = "$".
          END.
      END.
  END.
  */
  /* COSTO PROMEDIO */
  FOR EACH Detalle:
      FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia
          AND integral.almstkge.codmat = detalle.codmat
          AND integral.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE integral.almstkge THEN detalle.ctouniconti = INTEGRAL.AlmStkge.CtoUni.
      /*
      FIND LAST cissac.almstkge WHERE cissac.almstkge.codcia = s-codcia
          AND cissac.almstkge.codmat = detalle.codmat
          AND cissac.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE cissac.almstkge THEN detalle.ctounicissac = cissac.AlmStkge.CtoUni.
      */
      /*
      DEF INPUT PARAMETER pCodMat AS CHAR.
      DEF INPUT PARAMETER pCodAlm AS CHAR.
      DEF INPUT PARAMETER pContado AS LOG.
      DEF OUTPUT PARAMETER pComprometido AS DEC.

      stock-comprometido-v2.p
      */

      /*Calculo Stock Comprometido*/      
      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm1.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm1, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm1, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[1] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm2.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm2, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm2, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[2] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm3.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm3, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm3, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[3] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm4.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm4, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm4, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[4] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm5.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm5, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm5, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[5] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm6.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm6, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm6, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[6] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm7.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm7, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm7, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[7] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm8.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm8, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm8, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[8] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm9.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm9, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm9, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[9] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm10.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm10, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm10, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[10] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm11.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm11, OUTPUT pComprometido).*/
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm11, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[11] = pComprometido.

      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stk Comprometido  Art : ' + Detalle.codmat + ", Alm : " + cCodAlm12.
      /*RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm12, OUTPUT pComprometido).     */
      RUN gn/stock-comprometido-v2.r(Detalle.codmat, cCodAlm12, NO, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[12] = pComprometido.


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
  DISPLAY x-CodFam f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodFam BUTTON-1 BtnDone 
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
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Material".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Linea".
chWorkSheet:Range("F2"):Value = "Sub-linea".
chWorkSheet:Range("G2"):Value = "Proveedor".
chWorkSheet:Range("H2"):Value = "Peso".
chWorkSheet:Range("I2"):Value = "Volumen".
chWorkSheet:Range("H2"):Value = "Peso".
chWorkSheet:Range("I2"):Value = "Volumen".

t-Letra = ASC('J').
t-column = 2.
cLetra2 = ''.

DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmConti).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.
cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Conti".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmCissac).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.
cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Cissac".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/* ------------------------------------------------ */
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 11".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 11e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 34".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 34e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 21".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 21e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 22".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 40".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 45".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35a".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Mnd".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Costo (Sin I.G.V)".

loopREP:
FOR EACH Detalle BY Detalle.CodMat:
    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.SubFam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodPr1.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.pesmat.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.libre_d02.

    /* Almacenes CONTI */
    t-Letra = ASC('J').
    cLetra2 = ''.
    xOrden = 1.
    DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockConti[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.
    /* Cto.Prom. Conti */
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniConti.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /* Almacenes CISSAC */
    DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockCissac[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.
    /* Cto.Prom.Cissac */
    cColumn = STRING(t-Column).    
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniCissac.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    
    /* Stock Comprometidos */
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[1].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[2].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[3].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[4].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[5].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[6].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[7].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[8].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[9].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[10].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[11].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[12].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MndCosto.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoLista.


END.    
iCount = iCount + 2.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy W-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF CONNECTED('cissac') THEN DISCONNECT 'cissac' NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  IF CONNECTED('cissac') THEN DISCONNECT 'cissac' NO-ERROR.
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
  FOR EACH integral.almtfami NO-LOCK:
      x-codfam:ADD-LAST(integral.almtfami.codfam) IN FRAME {&FRAME-NAME}.
  END.
  x-codfam = '010'.

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

