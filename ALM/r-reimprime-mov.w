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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE STREAM Reporte.


DEFINE VAR lNomAlm AS CHAR.
DEFINE VAR S-Encargado   AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Movimiento  AS CHAR FORMAT "X(40)" INIT "".
DEFINE VAR S-Procedencia AS CHAR FORMAT "X(55)" INIT "".
DEFINE VAR S-Moneda      AS CHAR FORMAT "X(32)"  INIT "".
DEFINE VAR S-Mon         AS CHAR FORMAT "X(4)"  INIT "".
DEFINE VAR S-Referencia1 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia2 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia3 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-RUC         AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-TOTAL       AS DECIMAL INIT 0.
DEFINE VAR S-SUBTO       AS DECIMAL INIT 0.
DEFINE VAR S-Item        AS INTEGER INIT 0.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
    AND Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
S-Encargado = Almacen.EncAlm.
lNomAlm = almacen.descripcion.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
COMBO-BOX-TipMov FILL-IN-CodMov RADIO-SET-Formato BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 COMBO-BOX-TipMov FILL-IN-CodMov FILL-IN-DesMov ~
RADIO-SET-Formato 

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
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE COMBO-BOX-TipMov AS CHARACTER FORMAT "X(256)":U INITIAL "I" 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Ingreso","I",
                     "Salida","S"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Formato AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Almacén", 1,
"Contabilidad", 2
     SIZE 12 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.15
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Almacen AT ROW 1.19 COL 10 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchDoc-1 AT ROW 2.54 COL 15 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchDoc-2 AT ROW 2.54 COL 40 COLON-ALIGNED WIDGET-ID 10
     COMBO-BOX-TipMov AT ROW 3.5 COL 15 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-CodMov AT ROW 4.46 COL 15 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-DesMov AT ROW 4.46 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     RADIO-SET-Formato AT ROW 5.42 COL 17 NO-LABEL WIDGET-ID 24
     BUTTON-2 AT ROW 6.19 COL 62 WIDGET-ID 22
     BtnDone AT ROW 6.19 COL 69 WIDGET-ID 20
     "Formato para:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.62 COL 7 WIDGET-ID 28
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.29 BY 7.62
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
         TITLE              = "REIMPRESION DE MOVIMIENTOS DE ALMACEN"
         HEIGHT             = 7.62
         WIDTH              = 77.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         MAX-BUTTON         = no
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
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMov IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REIMPRESION DE MOVIMIENTOS DE ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REIMPRESION DE MOVIMIENTOS DE ALMACEN */
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
  ASSIGN COMBO-BOX-TipMov FILL-IN-CodMov FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 RADIO-SET-Formato.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-TipMov W-Win
ON VALUE-CHANGED OF COMBO-BOX-TipMov IN FRAME F-Main /* Movimiento */
DO:
  APPLY 'LEAVE':U TO FILL-IN-CodMov.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMov W-Win
ON LEAVE OF FILL-IN-CodMov IN FRAME F-Main /* Movimiento */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = s-codcia
      AND Almtmovm.Codmov = INPUT FILL-IN-CodMov
      AND Almtmovm.Tipmov = INPUT COMBO-BOX-TipMov
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN FILL-IN-DesMov:SCREEN-VALUE = Almtmovm.Desmov.

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
  DISPLAY FILL-IN-Almacen FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 COMBO-BOX-TipMov 
          FILL-IN-CodMov FILL-IN-DesMov RADIO-SET-Formato 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 COMBO-BOX-TipMov 
         FILL-IN-CodMov RADIO-SET-Formato BUTTON-2 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Ingreso-Almacen W-Win 
PROCEDURE Formato-Ingreso-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-FMT
         Almmmatg.ArtPro    FORMAT "X(12)"
         Almdmov.CodMat     AT  14 FORMAT "X(6)"
         Almdmov.CanDes     AT  22 FORMAT ">>>,>>9.9999" 
         Almdmov.CodUnd     AT  34 FORMAT "X(6)"          
         Almmmatg.DesMat    AT  41 FORMAT "X(50)"
         Almmmatg.Desmar    AT  91 FORMAT 'x(20)'
         Almmmatg.CatConta[1] AT 115 FORMAT 'x(3)'
         Almmmate.CodUbi    AT  124 FORMAT 'x(7)'
         HEADER
         {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN6B} FORMAT "X(45)" SKIP
         "( " + S-CODALM + " - " + lNomAlm + " )" AT 1 FORMAT "X(60)" 
         "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
         /*"( " + S-CODALM + " )" AT 5 FORMAT "X(20)" */
         S-Movimiento  AT 52 "Pag. " AT 108 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
/*          S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP */
         S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         " COD.PROV.   CODIGO    CANTIDAD    UND.                  DESCRIPCION                          M A R C A           CC      UBICACION" SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
        /*         1         2         3         4         5         6         7         8         9        10        11        12        13        14*/ 
        /*12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890*/
        /*123456789012 123456  >>>,>>9.9999 1234  1234567890123456789012345678901234567890123456789012345678901234567890    123      123 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           FIND Almmmate WHERE Almmmate.Codcia = Almdmov.CodCia AND
                Almmmate.CodAlm = S-CODALM AND
                Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           DISPLAY STREAM Reporte 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmate.CodUbi
                   Almmmatg.Desmar 
                   Almmmatg.CatConta[1]
                   WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01. 
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------            -----------------            -----------------            ----------------- " AT 10 SKIP.
  PUT STREAM Reporte "        Operador                      Recibido                      Vo. Bo.                   ADMINISTRADOR  " AT 10 SKIP.
  PUT STREAM Reporte  Almcmov.usuario AT 18 "JEFE ALMACEN         "  AT 75 SKIP.
  PUT STREAM Reporte " ** ALMACEN ** " AT 121 SKIP.
  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Ingreso-Contabilidad W-Win 
PROCEDURE Formato-Ingreso-Contabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-ImpMn1 AS DEC NO-UNDO.
  
  S-TOTAL = 0.
  DEFINE VAR F-MONEDA AS CHAR FORMAT "X(4)".
  
  DEFINE FRAME F-FMT
         Almmmatg.Artpro FORMAT "X(09)"
         Almdmov.CodMat     FORMAT "X(6)"
         Almdmov.CanDes     FORMAT ">>>,>>9.9999" 
         Almdmov.CodUnd     FORMAT "X(6)" 
         Almmmatg.DesMat    FORMAT "X(45)"
         Almmmatg.Desmar    FORMAT "X(20)"
         Almmmatg.CatConta[1] FORMAT 'X(3)'
         F-MONEDA           FORMAT "X(4)" 
         Almdmov.Prelis     FORMAT ">>,>>>.9999"
         x-ImpMn1           FORMAT ">,>>>,>>9.99"
         HEADER
         {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN6B} FORMAT "X(45)" SKIP
         "( " + S-CODALM + " - " + lNomAlm + " )" AT 1 FORMAT "X(60)" 
         "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
         /*"( " + S-CODALM + " )" AT 5 FORMAT "X(20)" */
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Reporte) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99 "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79  "Tpo.Cam : " AT 113 Almdmov.TpoCmb AT 123 FORMAT ">>9.9999" SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod.Pro.  CODIGO  CANTIDAD    UND.            DESCRIPCION                        M A R C A            CC  MON  VALOR VENTA  IMPORTE S/." SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        /*         1         2         3         4         5         6         7         8         9        10        11        12        13*/
        /*1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890*/
        /*123456789 123456 >>>,>>9.9999 1234 123456789012345678901234567890123456789012345 12345678901234567890 123 123 >>,>>>.9999 >,>>>,>>9.99 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
                           Almdmov.CodAlm = Almcmov.CodAlm AND
                           Almdmov.TipMov = Almcmov.TipMov AND
                           Almdmov.CodMov = Almcmov.CodMov AND
                           Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.

  IF AVAILABLE Almdmov THEN DO:  
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.  
     REPEAT WHILE  AVAILABLE  AlmDMov AND 
                   Almdmov.CodAlm = Almcmov.CodAlm AND
                   Almdmov.TipMov = Almcmov.TipMov AND 
                   Almdmov.CodMov = Almcmov.CodMov AND
                   Almdmov.NroDoc = Almcmov.NroDoc:

           FIND FIRST Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                      Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
            
           IF Almdmov.codmon = 1
           THEN x-ImpMn1 = Almdmov.ImpCto.
           ELSE x-ImpMn1 = Almdmov.ImpCto * Almdmov.TpoCmb.
           
           S-TOTAL = S-TOTAL + x-ImpMn1.        /*Almdmov.ImpMn1.*/
            
           IF ALMDMOV.CODMON = 1 THEN F-MONEDA = "S/.".
           ELSE F-MONEDA = "US$.".                 
           DISPLAY stream Reporte
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmatg.Desmar
                   Almmmatg.CatConta[1]
                   F-MONEDA
                   Almdmov.Prelis
                   /*Almdmov.ImpMn1*/
                   x-ImpMn1
                   WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
     PUT STREAM Reporte "------------" AT 120 skip.
     PUT STREAM Reporte S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Reporte "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Reporte Almcmov.usuario AT 18 "JEFE ALMACEN             CONTABILIDAD            GERENCIA     "  AT 40 SKIP.
  /*PUT STREAM Reporte " ** CONTABILIDAD ** " AT 119 SKIP.*/
  PUT STREAM Reporte " ** ADMINISTRACION ** " AT 110 SKIP.

  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Salida-Almacen W-Win 
PROCEDURE Formato-Salida-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-FMT
         S-Item             AT  1   FORMAT "ZZZ9"
         Almdmov.CodMat     AT  6   FORMAT "X(6)"
         Almmmatg.DesMat    AT  14  FORMAT "X(50)"
         Almmmatg.Desmar    AT  65  FORMAT "X(15)"
         Almdmov.CodUnd     AT  82  FORMAT "X(6)"          
         Almmmatg.CanEmp    AT  88  FORMAT ">>,>>9.99"
         Almdmov.CanDes     AT  99  FORMAT ">>>,>>9.99" 
         "__________"       AT  111  
         Almmmate.CodUbi    AT  125 FORMAT "X(6)"
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + S-DESALM + " )" FORMAT "X(50)" 
         S-Movimiento  AT 52  /*"Pag. " AT 108 PAGE-NUMBER(REPORTE) FORMAT ">>9"*/ SKIP
         "( PRE - DESPACHO )" AT 58 SKIP
         "Nro Documento : " AT 105 Almcmov.Nroser AT 121 "-" AT 124 Almcmov.NroDoc AT 125 FORMAT "9999999" SKIP         
         S-PROCEDENCIA AT 1 FORMAT "X(70)" 
         "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 
         "Almacen Salida  : " AT 79 S-CODALM AT 99       
         "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO                DESCRIPCION                             M A R C A     UND.    EMPAQUE    CANTIDAD  DESPACHADO  UBICACION" SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
/*           99  999999 12345678901234567890123456789012345678901234567890 123456789012345  81                                       
               6      13                                                  65 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           FIND Almmmate WHERE Almmmate.Codcia = Almdmov.CodCia AND
                Almmmate.CodAlm = S-CODALM AND
                Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           S-Item = S-Item + 1.     
           DISPLAY STREAM Reporte 
                   S-Item 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmatg.CanEmp
                   Almmmate.CodUbi
                   Almmmatg.Desmar WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------            -----------------             -----------------       "  AT 10 SKIP.
  PUT STREAM Reporte "        Operador                    Despachador                     Vo. Bo.            "  AT 10 SKIP.
  PUT STREAM Reporte  Almcmov.usuario AT 18 "JEFE ALMACEN         "  AT 75 SKIP.
  PUT STREAM Reporte " ** ALMACEN ** " AT 121 SKIP.
  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Salida-Contabilidad W-Win 
PROCEDURE Formato-Salida-Contabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-ImpMn1 AS DEC NO-UNDO.
  
  S-TOTAL = 0.
  DEFINE VAR F-MONEDA AS CHAR FORMAT "X(4)".
  
  DEFINE FRAME F-FMT
         Almmmatg.Artpro FORMAT "X(09)"
         Almdmov.CodMat     FORMAT "X(6)"
         Almdmov.CanDes     FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     FORMAT "X(6)" 
         Almmmatg.DesMat    FORMAT "X(47)"
         Almmmatg.Desmar    FORMAT "X(20)"
         Almmmatg.CatConta[1] FORMAT 'X(3)'
         F-MONEDA           FORMAT "X(4)" 
         Almdmov.Prelis     FORMAT ">>,>>>.9999"
         /*Almdmov.ImpMn1     FORMAT ">,>>>,>>9.99"*/
         x-ImpMn1           FORMAT ">,>>>,>>9.99"
         HEADER
         {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN6B} FORMAT "X(45)" SKIP
         "SALIDA No. : " AT 96 Almcmov.NroDoc AT 114 FORMAT "9999999" SKIP
         "( " + S-CODALM + " )" AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Reporte) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Salida : " AT 79 S-CODALM AT 99 "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79  "Tpo.Cam : " AT 113 Almdmov.TpoCmb AT 123 FORMAT ">>9.9999" SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod.Pro.  CODIGO  CANTIDAD  UND.              DESCRIPCION                        M A R C A            CC  MON  VALOR VENTA  IMPORTE S/." SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        /*         1         2         3         4         5         6         7         8         9        10        11        12        13*/
        /*1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890*/
        /*123456789 123456 >>>,>>9.99 1234 12345678901234567890123456789012345678901234567 12345678901234567890 123 123 >>,>>>.9999 >,>>>,>>9.99 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
                           Almdmov.CodAlm = Almcmov.CodAlm AND
                           Almdmov.TipMov = Almcmov.TipMov AND
                           Almdmov.CodMov = Almcmov.CodMov AND
                           Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.

  IF AVAILABLE Almdmov THEN DO:  
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.  
     REPEAT WHILE  AVAILABLE  AlmDMov AND 
                   Almdmov.CodAlm = Almcmov.CodAlm AND
                   Almdmov.TipMov = Almcmov.TipMov AND 
                   Almdmov.CodMov = Almcmov.CodMov AND
                   Almdmov.NroDoc = Almcmov.NroDoc:

           FIND FIRST Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                      Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
            
           IF Almdmov.codmon = 1
           THEN x-ImpMn1 = Almdmov.ImpCto.
           ELSE x-ImpMn1 = Almdmov.ImpCto * Almdmov.TpoCmb.
           
           S-TOTAL = S-TOTAL + x-ImpMn1.        /*Almdmov.ImpMn1.*/
            
           IF ALMDMOV.CODMON = 1 THEN F-MONEDA = "S/.".
           ELSE F-MONEDA = "US$.".                 
           DISPLAY stream Reporte
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmatg.Desmar
                   Almmmatg.CatConta[1]
                   F-MONEDA
                   Almdmov.Prelis
                   /*Almdmov.ImpMn1*/
                   x-ImpMn1
                   WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
     PUT STREAM Reporte "------------" AT 120 skip.
     PUT STREAM Reporte S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Reporte "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Reporte Almcmov.usuario AT 18 "JEFE ALMACEN             CONTABILIDAD            GERENCIA     "  AT 40 SKIP.
  PUT STREAM Reporte " ** CONTABILIDAD ** " AT 119 SKIP.

  OUTPUT STREAM Reporte CLOSE.

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

DEF VAR rpta AS LOG NO-UNDO.                                        
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
    AND Almcmov.codalm = s-codalm
    AND Almcmov.tipmov = COMBO-BOX-TipMov
    AND Almcmov.codmov = FILL-IN-CodMov
    AND Almcmov.fchdoc >= FILL-IN-FchDoc-1
    AND Almcmov.fchdoc <= FILL-IN-FchDoc-2
    AND Almcmov.flgest <> 'A':
    CASE COMBO-BOX-TipMov:
        WHEN "I" THEN RUN Imprimir-Ingreso.
        WHEN "S" THEN RUN Imprimir-Salida.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Ingreso W-Win 
PROCEDURE Imprimir-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
  END.
  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
             Almtmovm.Tipmov = Almcmov.TipMov AND 
             Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO:
     S-Movimiento = Almcmov.TipMov + STRING(Almcmov.CodMov,"99") + "-" + CAPS(Almtmovm.Desmov).
     IF Almtmovm.PidCli THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO: 
            S-Procedencia = "Cliente          : " + gn-clie.NomCli.
            S-RUC = "R.U.C.          :   " + gn-clie.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO: 
            S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
            S-RUC = "R.U.C.          :   " + gn-prov.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodPro.

     END.
     IF Almtmovm.Movtrf THEN DO:
        S-Moneda = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
             Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
           IF Almcmov.TipMov = "I" THEN
              S-Procedencia = "Procedencia      : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.
           ELSE 
              S-Procedencia = "Destino          : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.   
           END.            
     END.   
     IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
     IF Almtmovm.PidRef3 THEN ASSIGN S-Referencia3 = Almtmovm.GloRf3.
  END.

  CASE RADIO-SET-Formato:
      WHEN 1 THEN RUN Formato-Ingreso-Almacen.
      WHEN 2 THEN RUN Formato-Ingreso-Contabilidad.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Salida W-Win 
PROCEDURE Imprimir-Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
  END.
  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
             Almtmovm.Tipmov = Almcmov.TipMov AND 
             Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO:
     S-Movimiento = Almcmov.TipMov + STRING(Almcmov.CodMov,"99") + "-" + CAPS(Almtmovm.Desmov).
     IF Almtmovm.PidCli THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO: 
            S-Procedencia = "Cliente          : " + gn-clie.NomCli.
            S-RUC = "R.U.C.          :   " + gn-clie.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO: 
            S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
            S-RUC = "R.U.C.          :   " + gn-prov.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodPro.

     END.
     IF Almtmovm.Movtrf THEN DO:
        S-Moneda = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
             Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
           IF Almcmov.TipMov = "I" THEN
              S-Procedencia = "Procedencia      : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.
           ELSE 
              S-Procedencia = "Destino          : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.   
           END.            
     END.   
     IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
     IF Almtmovm.PidRef3 THEN ASSIGN S-Referencia3 = Almtmovm.GloRf3.
  END.
  CASE RADIO-SET-Formato:
      WHEN 1 THEN RUN Formato-Salida-Almacen.
      WHEN 2 THEN RUN Formato-Salida-Contabilidad.
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
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN FILL-IN-Almacen = Almacen.codalm + ' - ' + Almacen.Descripcion.
  FILL-IN-FchDoc-2 = TODAY.
  FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1.

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

