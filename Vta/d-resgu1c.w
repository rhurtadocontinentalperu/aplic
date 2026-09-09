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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
DEFINE VARIABLE l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

/*TEMPORALES*/
DEFINE TEMP-TABLE tmp-Ccbcdocu NO-UNDO
    FIELDS nrodoc LIKE CcbcDocu.NroDoc 
    FIELDS FchDoc LIKE CcbcDocu.FchDoc 
    FIELDS NomCli LIKE CcbcDocu.NomCli 
    FIELDS RucCli LIKE CcbcDocu.RucCli 
    FIELDS Codven LIKE CcbcDocu.Codven
    FIELDS CodMon AS   CHARACTER
    FIELDS ImpVta LIKE CcbcDocu.ImpVta 
    FIELDS ImpDto LIKE CcbcDocu.ImpDto 
    FIELDS ImpBrt LIKE CcbcDocu.ImpBrt 
    FIELDS ImpIgv LIKE CcbcDocu.ImpIgv 
    FIELDS ImpTot LIKE CcbcDocu.ImpTot 
    FIELDS FlgEst AS   CHARACTER
    FIELDS FlgSit LIKE CcbcDocu.FlgSit.

DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.

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
&Scoped-Define ENABLED-OBJECTS x-coddiv f-serie f-clien f-nomcli f-vende ~
f-nomven f-desde f-hasta BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-coddiv f-serie f-clien f-nomcli f-vende ~
f-nomven f-desde f-hasta txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 13 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 13 BY 1.62.

DEFINE VARIABLE x-coddiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE f-serie AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-coddiv AT ROW 1.54 COL 10 COLON-ALIGNED WIDGET-ID 2
     f-serie AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 16
     f-clien AT ROW 3.69 COL 10 COLON-ALIGNED WIDGET-ID 4
     f-nomcli AT ROW 3.69 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     f-vende AT ROW 4.77 COL 10 COLON-ALIGNED WIDGET-ID 8
     f-nomven AT ROW 4.77 COL 25 COLON-ALIGNED WIDGET-ID 10
     f-desde AT ROW 5.85 COL 10 COLON-ALIGNED WIDGET-ID 12
     f-hasta AT ROW 5.85 COL 39 COLON-ALIGNED WIDGET-ID 14
     txt-mensaje AT ROW 7.15 COL 2.86 NO-LABEL WIDGET-ID 20
     BUTTON-1 AT ROW 8.27 COL 49 WIDGET-ID 18
     BUTTON-2 AT ROW 8.27 COL 63 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.72 BY 9.19 WIDGET-ID 100.


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
         TITLE              = "Resumen de Guías"
         HEIGHT             = 9.19
         WIDTH              = 77.72
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
/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Guías */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Guías */
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

    ASSIGN f-Desde f-hasta f-vende f-clien x-coddiv f-serie.

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

    RUN Imprimir.
    DISPLAY "" @ txt-mensaje WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.   
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

    DEFINE VAR X-SIT    AS CHARACTER NO-UNDO. 
    DEFINE VAR DesAlm   AS CHARACTER NO-UNDO.
    DEFINE BUFFER b-almc FOR Almacen.

    EMPTY TEMP-TABLE tmp-Ccbcdocu.

    FOR EACH CcbcDocu NO-LOCK WHERE
        CcbcDocu.CodCia = S-CODCIA AND
        CcbcDocu.CodDiv BEGINS x-CodDiv AND
        CcbcDocu.CodDoc = "G/R"    AND
        CcbcDocu.FchDoc >= F-desde AND
        CcbcDocu.FchDoc <= F-hasta AND 
        CcbcDocu.NroDoc BEGINS f-serie AND
        CcbcDocu.Codcli BEGINS f-clien AND
        CcbcDocu.CodVen BEGINS f-vende
        BY CcbcDocu.NroDoc:

        IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

        X-EST = "".

        CASE CcbcDocu.FlgEst :
            WHEN "P" THEN X-EST = "PEN".   
            WHEN "C" THEN X-EST = "CAN".
            WHEN "F" THEN X-EST = "FAC".   
            WHEN "A" THEN X-EST = "ANU".
        END.

        CREATE tmp-Ccbcdocu.
        ASSIGN
            tmp-Ccbcdocu.nrodoc = CcbcDocu.NroDoc   
            tmp-Ccbcdocu.FchDoc = CcbcDocu.FchDoc   
            tmp-Ccbcdocu.NomCli = CcbcDocu.NomCli   
            tmp-Ccbcdocu.RucCli = CcbcDocu.RucCli   
            tmp-Ccbcdocu.Codven = CcbcDocu.Codven   
            tmp-Ccbcdocu.CodMon = X-MON             
            tmp-Ccbcdocu.FlgEst = X-EST. 

        DISPLAY "Cargando Información " @ txt-mensaje 
            WITH FRAME {&FRAME-NAME}.
    END.

    FOR EACH Almacen WHERE Almacen.CodCia = s-CodCia
        AND Almacen.CodDiv = x-CodDiv
        AND Almacen.CodAlm BEGINS s-CodAlm NO-LOCK:
        FOR EACH AlmcMov WHERE AlmcMov.CodCia = Almacen.CodCia
            AND AlmcMov.CodAlm = Almacen.CodAlm
            AND AlmcMov.TipMov = "S"
            AND AlmcMov.CodMov = 03
            AND Almcmov.FchDoc >= F-desde 
            AND Almcmov.FchDoc <= F-hasta  
            AND Almcmov.CodCli BEGINS f-clien
            AND Almcmov.CodVen BEGINS f-vende NO-LOCK
            BY AlmcMov.NroDoc:

            IF f-serie <> '' AND Almcmov.NroSer <> INT(f-serie) THEN NEXT.
            
            IF Almcmov.Codmon = 1 THEN X-MON = "S/.".
            ELSE X-MON = "US$.".

            FIND FIRST b-almc WHERE b-almc.CodCia = AlmcMov.CodCia
                AND b-almc.CodAlm = AlmcMov.AlmDes NO-LOCK NO-ERROR.
            IF AVAILABLE b-almc THEN DesAlm = b-almc.Descripcion.

            X-EST = "".
            CASE Almcmov.FlgEst :
                WHEN "P" THEN X-EST = "PEN".
                WHEN "C" THEN X-EST = "CAN".
                WHEN "A" THEN X-EST = "ANU".       
            END.
            
            IF Almcmov.FlgSit  = "T" THEN X-SIT = "TRANSFERIDO ".
            IF Almcmov.FlgSit  = "R" THEN X-SIT = "RECEPCIONADO".
            IF Almcmov.FlgSit  = "R" AND Almcmov.FlgEst =  "D" THEN X-SIT = "RECEPCIONADO(*)".
            IF Almcmov.FlgEst  = "A" THEN X-SIT = "ANULADO".

            CREATE tmp-Ccbcdocu.
            ASSIGN
                tmp-Ccbcdocu.nrodoc = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")
                tmp-Ccbcdocu.FchDoc = Almcmov.FchDoc
                tmp-Ccbcdocu.NomCli = Desalm
                tmp-Ccbcdocu.Codven = Almcmov.CodVen   
                tmp-Ccbcdocu.CodMon = X-MON             
                tmp-Ccbcdocu.FlgEst = X-EST
                tmp-Ccbcdocu.FlgSit = X-SIT. 

            DISPLAY "Cargando Información " @ txt-mensaje 
                WITH FRAME {&FRAME-NAME}.
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
  DISPLAY x-coddiv f-serie f-clien f-nomcli f-vende f-nomven f-desde f-hasta 
          txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-coddiv f-serie f-clien f-nomcli f-vende f-nomven f-desde f-hasta 
         BUTTON-1 BUTTON-2 
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
    
 DEFINE FRAME f-cab
        tmp-CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"                
        tmp-CcbcDocu.FchDoc                                    
        tmp-CcbcDocu.NomCli FORMAT "X(27)"                     
        tmp-CcbcDocu.RucCli FORMAT "X(11)"                     
        tmp-CcbcDocu.Codven FORMAT "X(4)"                      
        tmp-CcbCDocu.CodMon FORMAT "X(4)"                                
        tmp-CcbCDocu.FlgEst FORMAT "X(5)"                      
        tmp-CcbCDocu.FlgSit FORMAT "X(15)"                      
        HEADER                                             
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + x-CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN DE GUIAS "  AT 30 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 71 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 15 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 71 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 50 FORMAT "X(20)" "Hora  : " AT 71 STRING(TIME,"HH:MM:SS") SKIP
        "DIVISION:" STRING(x-CodDiv, 'x(5)') SKIP
        "---------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                                                 " SKIP
        "   GUIA     EMISION   C L I E N T E                   R.U.C.  VEND MON.  EST    SIT                " SKIP
        "---------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 140 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 FOR EACH tmp-CcbCDocu BREAK BY tmp-CcbCDocu.NroDoc:
     DISPLAY STREAM REPORT
         tmp-CcbCDocu.NroDoc
         tmp-CcbCDocu.FchDoc
         tmp-CcbCDocu.NomCli
         tmp-CcbCDocu.RucCli
         tmp-CcbCDocu.Codven
         tmp-CcbCDocu.CodMon
         tmp-CcbCDocu.FlgEst
         tmp-CcbCDocu.FlgSit 
         WITH FRAME F-Cab.

     DISPLAY "Procesando Información " @ txt-mensaje 
         WITH FRAME {&FRAME-NAME}.
 END.
 /*OUTPUT STREAM REPORT CLOSE. */

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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
        
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) /*PAGED PAGE-SIZE 62*/ .
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Formato.
        PAGE STREAM report.
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
      FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
          x-CodDiv:ADD-LAST(Gn-divi.coddiv).
      END.

      ASSIGN x-CodDiv  = S-CODDIV
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

