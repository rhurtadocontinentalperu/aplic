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

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE VARIABLE s-task-no AS INTEGER     NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE VAR cCodDoc  AS CHAR INIT "VAL".

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 cboProvProd txt-fecha txt-importe ~
txt-nrototal txt-codcli txt-nomcli 
&Scoped-Define DISPLAYED-OBJECTS txt-codpro cboProvProd txt-fecha txtProd ~
txt-importe txt-nrototal txt-codcli txt-nomcli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print (2).ico":U NO-FOCUS FLAT-BUTTON
     LABEL "*" 
     SIZE 13 BY 2.69.

DEFINE VARIABLE cboProvProd AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor (Producto)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Continental-CON Textos Escolares ","10003814-0001",
                     "Continental-SIN Texto Escolares","10003814-0002",
                     "Continental-Personal Continental","10003814-0003",
                     "EdenRed","50763447-02",
                     "Dodexho","50785254-730"
     DROP-DOWN-LIST
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nrototal AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 50 
     LABEL "Valor Nominal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "     10.00","     20.00","     25.00","     30.00","     50.00","    100.00" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 8 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(256)":U INITIAL "50763447" 
     LABEL "Prov." 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 8 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-importe AS DECIMAL FORMAT ">>,>>>99.99":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(30)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE txtProd AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prod." 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 8.5 COL 30 WIDGET-ID 2
     txt-codpro AT ROW 1.46 COL 72.29 COLON-ALIGNED WIDGET-ID 10
     cboProvProd AT ROW 1.5 COL 25.14 COLON-ALIGNED WIDGET-ID 22
     txt-fecha AT ROW 2.62 COL 25 COLON-ALIGNED WIDGET-ID 4
     txtProd AT ROW 3.31 COL 62 COLON-ALIGNED WIDGET-ID 24
     txt-importe AT ROW 3.69 COL 25 COLON-ALIGNED WIDGET-ID 6
     txt-nrototal AT ROW 4.77 COL 25 COLON-ALIGNED WIDGET-ID 20
     txt-codcli AT ROW 5.85 COL 25 COLON-ALIGNED WIDGET-ID 16
     txt-nomcli AT ROW 6.88 COL 25 COLON-ALIGNED WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.57 BY 10.69 WIDGET-ID 100.


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
         TITLE              = "Tickets Utilex"
         HEIGHT             = 10.69
         WIDTH              = 89.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 92.29
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
/* SETTINGS FOR FILL-IN txt-codpro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProd IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Tickets Utilex */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Tickets Utilex */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* * */
DO:
    ASSIGN 
        txt-codpro
        txt-fecha
        txt-importe
        txt-nrototal
        txt-codcli
        txt-nomcli
        cboProvProd.

    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboProvProd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboProvProd W-Win
ON VALUE-CHANGED OF cboProvProd IN FRAME F-Main /* Proveedor (Producto) */
DO:
  ASSIGN cboProvProd.
  txt-codpro:SCREEN-VALUE = substring(cboProvProd,1,8).
  txtProd:SCREEN-VALUE = substring(cboProvProd,10,4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli W-Win
ON LEAVE OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
    ASSIGN {&SELF-NAME}.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = txt-codcli NO-LOCK NO-ERROR.
    IF AVAIL gn-clie THEN 
        DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Tipo de fuente C39HrP48DhTt      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iInt      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iLin      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cVar01    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cVar02    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cVar03    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec01 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec02 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec03 AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cLlave    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFecha    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cImpTot   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iDigVer   AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cNroTck   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cCodPrd   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodPrv   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE iNroVls   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iCol      AS INTEGER     NO-UNDO.

  DEFINE VARIABLE lNroTck AS INT.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  /*Busca Cliente*/
  cNomCli = txt-nomcli.

  /* Datos del Proveedor */
  cCodPrv = substring(cboProvProd,1,8).
  cCodPrd = substring(cboProvProd,10,4).
/*
   FIND FIRST VtaCTickets WHERE VtaCTickets.CodCia = s-codcia
      AND VtaCTickets.CodPro = txt-codpro NO-LOCK NO-ERROR.
*/      
  FIND FIRST VtaCTickets WHERE VtaCTickets.CodCia = s-codcia
     AND VtaCTickets.CodPro = cCodPrv AND VtaCTickets.Producto = cCodPrd NO-LOCK NO-ERROR.

  IF NOT AVAIL VtaCTickets THEN DO:
      MESSAGE "Producto y/o Proveedor no tiene registrado" SKIP
              "    Estructura de Ticket     "
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN "adm-error".
  END.

  ASSIGN 
      cLlave  = VtaCTickets.Producto
      cFecha  = SUBSTRING(STRING(YEAR(txt-fecha),"9999"),3) + 
                STRING(MONTH(txt-fecha),"99") + STRING(DAY(txt-fecha),"99")
      cImptot = STRING((txt-nrototal * 100),"9999999").
      
  IF (txt-importe MODULO txt-nrototal) > 0 THEN DO:
      MESSAGE "Importe Total debe ser multipo de Valor Nominal"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry" TO txt-importe IN FRAME {&FRAME-NAME}.
      RETURN "adm-error".
  END.
  ELSE DO:
      ASSIGN 
          iLin = 1
          iCol = 1. 

      /*lNroTck = 114677.  /*114984 114969.*/*/

      DO iInt = 1 TO (txt-importe / txt-nrototal):

          lNroTck = lNroTck + 1.

          FIND LAST FacCorre WHERE 
              FacCorre.CodCia = S-CODCIA AND
              FacCorre.CodDoc = cCodDoc AND
              FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE FacCorre THEN DO: 
              
              ASSIGN 
                  cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
                         
          END.
          /*cNroTck = "000" + STRING(lNroTck,"999999").*/
          cVar01 = cLlave + cFecha + cNroTck + cImptot.
          /*MESSAGE 'CodBarras ' cVar01 VIEW-AS ALERT-BOX ERROR.*/
          RUN vtagn\edenred-01 (cVar01,OUTPUT iDigVer).
          
          cVar01 = cVar01 + STRING(iDigVer,"9") + "0".
          cNroSec01 = cNroTck.

          IF ((iInt - 1) MODULO 3) = 0 THEN
              ASSIGN 
                iLin = iLin + 1
                iCol = 1.
            
          FIND FIRST w-report WHERE w-report.task-no = s-task-no 
              AND w-report.llave-i = iLin NO-ERROR.
          IF NOT AVAIL w-report THEN DO:
              CREATE w-report.
              ASSIGN
                  task-no    = s-task-no
                  llave-i    = iLin
                  campo-c[5] = cNomCli
                  campo-d[1] = txt-fecha            /*Fecha Vencimiento*/
                  campo-f[1] = txt-nrototal.         /*Importe Vale*/ 
          END.
          campo-c[14 + iCol] = cVar01.         /* Cod Barra antes de la encriptacion */

          RUN lib\_strto128c(cVar01, OUTPUT cVar01).
          
          ASSIGN 
              campo-c[iCol] = cVar01
              campo-i[iCol] = INTEGER(cNroSec01)
              iCol          = iCol + 1.      
      END.
  END.

  

  /***
  DO iInt = 1 TO INT(txt-nrototal) :
      /*Primera Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      cVar01 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar01,OUTPUT iDigVer).
      cVar01 = cVar01 + STRING(iDigVer,"9") + "0".
      cNroSec01 = cNroTck.

      /*Segunda Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      iInt = iInt + 1.
      cVar02 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar02,OUTPUT iDigVer).
      cVar02 = cVar02 + STRING(iDigVer,"9") + "0".
      cNroSec02 = cNroTck.


      /*Tercera Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      iInt = iInt + 1.
      cVar03 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar03,OUTPUT iDigVer).
      cVar03 = cVar03 + STRING(iDigVer,"9") + "0".
      cNroSec03 = cNroTck.


      RUN lib\_strto128c(cVar01, OUTPUT cVar01).
      RUN lib\_strto128c(cVar02, OUTPUT cVar02).
      RUN lib\_strto128c(cVar03, OUTPUT cVar03).

      FIND FIRST w-report WHERE w-report.task-no = s-task-no 
          AND w-report.llave-i = iLin NO-LOCK NO-ERROR.
      IF NOT AVAIL w-report THEN DO:
          CREATE w-report.
          ASSIGN
              task-no    = s-task-no
              llave-i    = iLin
              campo-c[1] = cVar01
              campo-i[1] = INTEGER(cNroSec01)
              campo-c[2] = cVar02
              campo-i[2] = INTEGER(cNroSec02)
              campo-c[3] = cVar03
              campo-i[3] = INTEGER(cNroSec03)
              campo-c[5] = cNomCli
              campo-d[1] = txt-fecha            /*Fecha Vencimiento*/
              campo-f[1] = txt-importe.         /*Importe Vale*/ 
      END.
      iLin = iLin + 1.
  END.
         
         *****/   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chr_to_asc W-Win 
PROCEDURE chr_to_asc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER tcCodBarra AS CHAR.
DEF OUTPUT PARAMETER lcRetASc AS CHAR.
    
DEFINE VAR lLen AS INT.
DEFINE VAR lValores AS CHAR.
DEFINE VAR lChar AS CHAR.
DEFINE VAR lAsc AS INT.
DEFINE VAR lStr AS CHAR.
DEFINE VAR i AS INT.
DEFINE VAR lGuion AS CHAR.

lLen = LENGTH(tcCodBarra).
lGuion = "".
lValores = "".
REPEAT i = 1 TO lLen :
    lChar = SUBSTRING(tcCodBarra,i,1).
    lAsc = ASC(lChar).
    lStr = STRING(lAsc).
    lValores = lValores + lGuion + lStr.
    lGuion = "_".
END.

lcRetASc = lValores.

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
  DISPLAY txt-codpro cboProvProd txt-fecha txtProd txt-importe txt-nrototal 
          txt-codcli txt-nomcli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 cboProvProd txt-fecha txt-importe txt-nrototal txt-codcli 
         txt-nomcli 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

  RUN Carga-Datos.

  IF RETURN-VALUE = 'adm-error' THEN RETURN "adm-error".

  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta\rbvta.prl'       
    RB-REPORT-NAME = 'Vales Utilex 02'       /* A LA MONEDA DEL DOCUMENTO */
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no).

/*     RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia +                  */
/*                             '~ns-codcli = ' + gn-clie.codcli +        */
/*                              '~ns-nomcli = ' + gn-clie.nomcli +       */
/*                              '~np-saldo-mn = ' + STRING(x-saldo-mn) + */
/*                              '~np-saldo-me = ' + STRING(x-saldo-me).  */


  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

  /*RUN to_excel (s-task-no).*/

  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.


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
  DO WITH FRAME {&FRAME-NAME} :
      ASSIGN txt-fecha = TODAY.
      DISPLAY txt-fecha.

  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE to_excel W-Win 
PROCEDURE to_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER tcTask AS INT.

DEFINE VAR lCodBarra AS CHAR.
DEFINE VAR lCodBarraAsc AS CHAR.

FOR EACH w-report WHERE task-no = tcTask:    
    lCodBarra = w-report.campo-c[1].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[11]=lCodBarraAsc.
    /**/
    lCodBarra = w-report.campo-c[2].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[12]=lCodBarraAsc.
    /**/
    lCodBarra = w-report.campo-c[3].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[13]=lCodBarraAsc.

END.

/* A excel */
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

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
FOR EACH w-report WHERE task-no = tcTask:    
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[15].

    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[1].

    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[11].

    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[16].

    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[2].

    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[12].

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[17].

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[3].

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[13].

END.

    chWorkSheet:SaveAs("c:\ciman\tickes_veri.xls").
        chExcelApplication:DisplayAlerts = False.
        chExcelApplication:Quit().

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

