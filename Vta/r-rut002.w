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

DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF VAR s-coddoc AS CHAR INIT 'H/R'.

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
&Scoped-Define ENABLED-OBJECTS f-clien f-vende f-desde f-hasta BUTTON-3 ~
BUTTON-4 RECT-70 RECT-71 
&Scoped-Define DISPLAYED-OBJECTS f-clien f-nomcli f-vende f-nomven f-desde ~
f-hasta txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 68 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.57 BY 6.23.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.43 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-clien AT ROW 1.81 COL 9 COLON-ALIGNED WIDGET-ID 4
     f-nomcli AT ROW 1.81 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     f-vende AT ROW 2.92 COL 9 COLON-ALIGNED WIDGET-ID 14
     f-nomven AT ROW 2.92 COL 13.86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     f-desde AT ROW 4.92 COL 9 COLON-ALIGNED WIDGET-ID 6
     f-hasta AT ROW 4.81 COL 29 COLON-ALIGNED WIDGET-ID 8
     txt-msj AT ROW 6.38 COL 3 NO-LABEL WIDGET-ID 30
     BUTTON-3 AT ROW 7.73 COL 41.14 WIDGET-ID 24
     BUTTON-4 AT ROW 7.73 COL 56.14 WIDGET-ID 26
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 4 COL 11 WIDGET-ID 16
          FONT 6
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 7.5 COL 1.72 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.72 BY 9.04
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Reporte Hoja de Ruta Resumen"
         HEIGHT             = 9.04
         WIDTH              = 71.72
         MAX-HEIGHT         = 9.04
         MAX-WIDTH          = 71.72
         VIRTUAL-HEIGHT     = 9.04
         VIRTUAL-WIDTH      = 71.72
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
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Hoja de Ruta Resumen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Hoja de Ruta Resumen */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN f-Desde f-hasta f-vende f-clien.
    
    IF f-desde = ? then do:
        MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U to f-desde.
        RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
        MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U to f-hasta.
        RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
        MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U to f-desde.
        RETURN NO-APPLY.
    END.

    IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
    IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
    
    DISPLAY "Cargando Informacion..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Excel2.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende W-Win
ON LEAVE OF f-vende IN FRAME F-Main /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
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
  DISPLAY f-clien f-nomcli f-vende f-nomven f-desde f-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-clien f-vende f-desde f-hasta BUTTON-3 BUTTON-4 RECT-70 RECT-71 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE cEstado  AS CHARACTER NO-UNDO .
DEFINE VARIABLE cEstDoc  AS CHARACTER NO-UNDO .
DEFINE VARIABLE cFlgEstD AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodPro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dImpCto  AS DECIMAL     NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Range("A2"):Value = "RESUMEN HOJA DE RUTA POR VENDEDOR".
chWorkSheet:Range("H2"):Value = "Formato Hora: 24 Horas".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "@".
chWorkSheet:Columns("M"):NumberFormat = "@".

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Hoja Ruta".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha Salida".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Vehiculo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado Hoja Ruta".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "CodDoc".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Motivo".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe".
/*
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Margen".
*/
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora Llegada".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora Partida".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma Pago".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Proveedor".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado Documento".


FOR EACH Di-RutaC NO-LOCK
    WHERE Di-RutaC.CodCia = s-codcia
    AND Di-RutaC.CodDiv = s-coddiv
    AND Di-RutaC.CodDoc = s-coddoc
    AND Di-RutaC.FchDoc >= f-Desde
    AND Di-RutaC.FchDoc <= f-Hasta
    BY DI-RutaC.NroDoc DESCENDING:    
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK /*,
        FIRST CcbCDocu WHERE CcbCDocu.CodCia = Di-RutaC.CodCia
        /*AND CcbcDocu.CodDiv = Di-RutaC.CodDiv*/
        AND CcbcDocu.CodDoc = Di-RutaD.CodRef
        AND CcbcDocu.NroDoc = Di-RutaD.NroRef
        AND CcbCDocu.CodCli BEGINS f-clien
        AND CcbCDocu.CodVen BEGINS f-vende NO-LOCK*/ :

        IF Di-RutaD.CodRef <> "G/R" THEN DO:
            FIND LAST CcbCDocu WHERE CcbCDocu.CodCia = Di-RutaC.CodCia
                AND CcbcDocu.CodDoc = Di-RutaD.CodRef
                AND CcbcDocu.NroDoc = Di-RutaD.NroRef
                /*AND CcbcDocu.FlgEst <> "A" */
                AND CcbCDocu.CodCli BEGINS f-clien
                AND CcbCDocu.CodVen BEGINS f-vende NO-LOCK NO-ERROR.            
        END.
        ELSE DO:
            FIND LAST CcbCDocu WHERE CcbCDocu.CodCia = Di-RutaC.CodCia
                AND CcbcDocu.CodRef = Di-RutaD.CodRef
                AND CcbcDocu.NroRef = Di-RutaD.NroRef
                /*AND CcbcDocu.FlgEst <> "A"*/
                AND CcbCDocu.CodCli BEGINS f-clien
                AND CcbCDocu.CodVen BEGINS f-vende NO-LOCK NO-ERROR.
        END.

        IF NOT AVAIL CcbCDocu THEN NEXT.
        dImpCto = 0.
        FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
            dImpCto = dImpCto + CcbDDocu.ImpCto.
        END.

        
        cCodPro = "".
        FIND FIRST gn-vehic WHERE gn-vehic.CodCia = s-codcia
            AND gn-vehic.Placa = DI-RutaC.CodVeh NO-LOCK NO-ERROR.
        IF AVAIL gn-vehic THEN DO:
            FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = gn-vehic.codpro NO-LOCK NO-ERROR.
            IF AVAIL gn-prov THEN DO:
                cCodPro = gn-prov.codpro + "-" + gn-prov.NomPro .
            END.
        END.

        FIND FIRST gn-convt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
        cFlgEstD = "".
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaC.NroDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaC.FchSal.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaC.CodVeh.
        CASE DI-RutaC.FlgEst:
            WHEN "P" THEN cEstado = "Pendiente".
            WHEN "C" THEN cEstado = "Cerrado".
            WHEN "A" THEN cEstado = "Anulado".
        END CASE.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = cEstado.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaD.CodRef.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaD.NroRef.
        CASE DI-RutaD.FlgEst:
            WHEN "C" THEN cEstDoc = "Entregado".
            WHEN "P" THEN cEstDoc = "Por Entregar".
            WHEN "D" THEN cEstDoc = "Devolucion Parcial".
            WHEN "X" THEN cEstDoc = "Devolucion Total".
            WHEN "N" THEN DO: 
                cEstDoc = "No Entregado".
                FIND FIRST almtabla WHERE almtabla.Tabla = "HR"
                    AND almtabla.codigo = Di-RutaD.FlgEstD NO-LOCK NO-ERROR.
                IF AVAIL almtabla THEN cFlgEstD = almtabla.nombre.
                ELSE cFlgEstD = "".

            END.
            WHEN "NR" THEN cEstDoc = "No Recibido".
            WHEN "R" THEN cEstDoc = "Error de Documento".
        END CASE.

        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = cEstDoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cFlgEstD.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.ImpTot.
        /*
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = (CcbCDocu.ImpTot - dImpCto).
        */
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaD.HorLle.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = DI-RutaD.HorPar.
        IF AVAIL gn-convt THEN DO:
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-ConVt.Nombr.
        END.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = cCodPro.

        cRange = "O" + cColumn.
        CASE CcbCDocu.FlgEst :
            WHEN "A" THEN chWorkSheet:Range(cRange):Value = "ANULADO".
            WHEN "C" THEN chWorkSheet:Range(cRange):Value = "CERRADO".
            WHEN "P" THEN chWorkSheet:Range(cRange):Value = "PENDIENTE".
        END CASE.
    END.
END.

MESSAGE 'Proceso Terminado!!!'.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.
   
    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        RUN prn-gui.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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
  
  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN 
           F-DESDE   = TODAY
           F-HASTA   = TODAY.
  END.

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

