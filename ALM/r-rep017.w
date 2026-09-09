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

DEFINE TEMP-TABLE tt-datos LIKE INTEGRAL.AlmStkge
    FIELDS undbas AS CHAR
    FIELDS cancom AS DECIMAL
    FIELDS fchcmp AS DATE
    FIELDS coscis AS DECIMAL.
DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-OBJECTS x-familia x-fchcorte x-desde x-hasta ~
BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-familia x-desfam x-fchcorte x-desde ~
x-hasta x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE x-familia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .92 NO-UNDO.

DEFINE VARIABLE x-desfam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .92
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-fchcorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Corte" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .92 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .92 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-familia AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 22
     x-desfam AT ROW 2.08 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     x-fchcorte AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 4
     x-desde AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 8
     x-hasta AT ROW 5.85 COL 42 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 7.73 COL 58 WIDGET-ID 14
     BUTTON-2 AT ROW 7.73 COL 66 WIDGET-ID 16
     x-mensaje AT ROW 8 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     "Fecha Compra" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 5.04 COL 10 WIDGET-ID 12
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76.14 BY 9.85 WIDGET-ID 100.


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
         TITLE              = "Reporte Valorizado con Stock Contable"
         HEIGHT             = 9.85
         WIDTH              = 76.14
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
/* SETTINGS FOR FILL-IN x-desfam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Valorizado con Stock Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Valorizado con Stock Contable */
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
        x-familia
        x-fchcorte
        x-desde
        x-hasta.

    IF x-desde = ? THEN DO:
        MESSAGE "Ingresar Fecha Inicio de Compra".
        RETURN "adm-error".
        APPLY "entry" TO x-desde.
    END.

    IF x-hasta = ? THEN DO:
        MESSAGE "Ingresar Fecha Fin de Compra".
        RETURN "adm-error".
        APPLY "entry" TO x-hasta.
    END.

    RUN Excel.
  
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


&Scoped-define SELF-NAME x-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-familia W-Win
ON VALUE-CHANGED OF x-familia IN FRAME F-Main /* Familia */
DO:
    ASSIGN x-familia.
    FIND FIRST integral.almtfam WHERE integral.almtfam.codcia = s-codcia
        AND integral.almtfam.codfam = x-familia:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
        NO-LOCK NO-ERROR.
    IF AVAIL integral.almtfam THEN 
        DISPLAY integral.almtfam.desfam @ x-desfam WITH FRAME {&FRAME-NAME}.  
    ELSE DISPLAY "" @ x-desfam WITH FRAME {&FRAME-NAME}.  
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Costo-Cissac W-Win 
PROCEDURE Busca-Costo-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
     Ic - 21May2014 : Considerar las devoluciones.
*/

    /* nuevo cálculo: hasta agotar compras */
    DEF VAR x-CanCom LIKE tt-datos.cancom NO-UNDO.
    DEF VAR x-ImpCom LIKE tt-datos.coscis NO-UNDO.

    DEF VAR lSigno AS INT INIT 0.

    DISPLAY "PROCESANDO DATOS... "  @ x-mensaje WITH FRAME {&FRAME-NAME}.
    PAUSE 0.
    FOR EACH tt-datos WHERE tt-datos.codcia = s-codcia:
        /*x-CanCom = tt-datos.cancom.*/
        x-CanCom = tt-datos.stkact.
        x-ImpCom = 0.
        /* barremos las compras */
        FOR EACH integral.almdmov USE-INDEX Almd07 WHERE integral.almdmov.codcia = s-codcia
            AND integral.almdmov.codmat = tt-datos.codmat
            AND integral.almdmov.fchdoc >= x-desde
            AND integral.almdmov.fchdoc <= x-hasta
            AND ((integral.almdmov.tipmov = "I" AND integral.almdmov.codmov = 02) OR
                 (integral.almdmov.tipmov = "S" AND integral.almdmov.codmov = 09))
                  NO-LOCK,
            FIRST integral.almcmov OF integral.almdmov NO-LOCK 
            WHERE integral.almcmov.codpro = "51135890"
            BY integral.almdmov.fchdoc DESC:
            IF x-CanCom <= 0 THEN LEAVE.

            lSigno = IF (integral.almdmov.tipmov = "S") THEN -1 ELSE 1.

            FIND LAST cissac.AlmStkge WHERE cissac.AlmStkge.CodCia = tt-datos.codcia
                AND cissac.AlmStkge.codmat = tt-datos.codmat 
                AND cissac.AlmStkge.Fecha <= integral.almdmov.fchdoc NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cissac.Almstkge THEN NEXT.
            /* Ic - 21May2014
            x-ImpCom = x-ImpCom + cissac.AlmStkge.CtoUni * MINIMUM(x-CanCom, integral.almdmov.candes * integral.almdmov.factor).
            x-CanCom = x-CanCom - MINIMUM(x-CanCom, integral.almdmov.candes * integral.almdmov.factor).
            */            
            x-ImpCom = x-ImpCom + ((cissac.AlmStkge.CtoUni * MINIMUM(x-CanCom, integral.almdmov.candes * integral.almdmov.factor)) * lSigno).
            x-CanCom = x-CanCom - ((MINIMUM(x-CanCom, integral.almdmov.candes * integral.almdmov.factor)) * lSigno).

        END.
        IF x-CanCom > 0 THEN DO:
            FIND LAST cissac.AlmStkge WHERE cissac.AlmStkge.CodCia = tt-datos.codcia
                AND cissac.AlmStkge.codmat = tt-datos.codmat 
                AND cissac.AlmStkge.Fecha < x-hasta NO-LOCK NO-ERROR.
            IF AVAILABLE cissac.AlmStkge THEN x-ImpCom = x-ImpCom + cissac.AlmStkge.CtoUni * x-CanCom.
        END.
        tt-datos.coscis = x-ImpCom / tt-datos.stkact.
    END.

/*     FOR EACH tt-datos WHERE tt-datos.codcia = s-codcia                      */
/*         AND tt-datos.cancom > 0 ,                                           */
/*         LAST cissac.AlmStkge WHERE cissac.AlmStkge.CodCia = tt-datos.codcia */
/*             AND cissac.AlmStkge.codmat = tt-datos.codmat                    */
/*             AND cissac.AlmStkge.Fecha <= x-fchcorte NO-LOCK:                */
/*         tt-datos.coscis = cissac.AlmStkge.CtoUni.                           */
/*         DISPLAY "PROCESANDO DATOS... "  @ x-mensaje                         */
/*             WITH FRAME {&FRAME-NAME}.                                       */
/*         PAUSE 0.                                                            */
/*     END.                                                                    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Cantidad-Comprada W-Win 
PROCEDURE Calcula-Cantidad-Comprada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dCanTot AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dFactor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE fFecha  AS DATE        NO-UNDO.
    
    DEFINE VAR lSigno   AS INT INIT 0.  /* Ic */

    /*
       Ic - 21/05/2014 : Considerar Salidas x devoluciones (09)
    */

    FOR EACH integral.almcmov WHERE integral.almcmov.codcia = s-codcia
        AND integral.almcmov.codpro = "51135890"
        AND integral.almcmov.fchdoc >= x-desde
        AND integral.almcmov.fchdoc <= x-hasta
        AND ((integral.almcmov.tipmov = "I" AND integral.almcmov.codmov = 02) OR 
                (integral.almcmov.tipmov = "S" AND integral.almcmov.codmov = 09))
              NO-LOCK,
        EACH integral.almdmov OF integral.almcmov NO-LOCK:

        /*Calculando unidades*/
        FIND FIRST tt-datos WHERE tt-datos.codcia = s-codcia
            AND tt-datos.codmat = integral.almdmov.codmat NO-ERROR.
        IF AVAIL tt-datos THEN DO:
            FIND integral.Almtconv WHERE integral.Almtconv.CodUnid  = tt-datos.UndBas 
                AND integral.Almtconv.Codalter = integral.almdmov.codund NO-LOCK NO-ERROR.
            IF AVAILABLE integral.Almtconv THEN dFactor = Almtconv.Equival.
            ELSE dFactor = 1.             
            /*tt-datos.cancom = tt-datos.cancom + (integral.almdmov.CanDes * dFactor).*/
            lSigno = IF (integral.almcmov.tipmov = "S") THEN -1 ELSE 1.
            tt-datos.cancom = tt-datos.cancom + ((integral.almdmov.CanDes * dFactor) * lSigno).
        END.
        PAUSE 0.            
        DISPLAY "CARGANDO INFORMACION " @ x-mensaje WITH FRAME {&FRAME-NAME}.
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

    FOR EACH tt-datos:
        DELETE tt-datos.
    END.

    Head:
    FOR EACH integral.almmmatg WHERE integral.almmmatg.codcia = s-codcia
        AND integral.almmmatg.codfam BEGINS x-familia NO-LOCK,
        LAST integral.AlmStkge WHERE integral.AlmStkge.CodCia = integral.almmmatg.codcia
            AND integral.AlmStkge.codmat = integral.almmmatg.codmat
            AND integral.AlmStkge.Fecha <= x-fchcorte NO-LOCK: 
        IF integral.AlmStkge.StkAct = 0  THEN NEXT Head.
        CREATE tt-datos.
        BUFFER-COPY integral.AlmStkge TO tt-datos.        
        ASSIGN tt-datos.undbas = almmmatg.undbas.
        DISPLAY "CARGANDO: " + integral.Almmmatg.desmat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.
    RUN Calcula-Cantidad-Comprada.
    RUN Fecha-Compra.

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
  DISPLAY x-familia x-desfam x-fchcorte x-desde x-hasta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-familia x-fchcorte x-desde x-hasta BUTTON-1 BUTTON-2 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iInt    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cVar    AS CHARACTER   NO-UNDO INIT "...".
    DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.

    RUN Carga-Temporal.
    RUN Busca-Costo-Cissac.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*Formato de Celda*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE CONTABLE VALORIZADO TOTAL".
    
    iCount = iCount + 2.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Sub Familia".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Stock Actual".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Unit Conti".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad comprada".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Unit Cissac".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Ultima Compra".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total".    
    

    FOR EACH tt-datos WHERE tt-datos.codcia = s-codcia,
        FIRST integral.almmmatg WHERE integral.almmmatg.codcia = tt-datos.codcia
            AND integral.almmmatg.codmat = tt-datos.codmat NO-LOCK:

        IF tt-datos.StkAct >= tt-datos.CanCom THEN 
            dImpTot = (tt-datos.CanCom * tt-datos.coscis) + (tt-datos.StkAct - tt-datos.CanCom) * tt-datos.ctouni.
        ELSE dImpTot = (tt-datos.StkAct * tt-datos.coscis).
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.almmmatg.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.almmmatg.desmar.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.almmmatg.codfam.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.almmmatg.subfam.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.StkAct .
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.CtoUni.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.CanCom.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.coscis.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-datos.fchcmp.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = dImpTot.

        iInt = iInt + 1.
        IF iInt MOD 30 = 0 THEN cVar = "...".
        ELSE cVar = cVar + "..".

        DISPLAY "CARGANDO EXCEL " + cVar @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.
    
    DISPLAY ""  @ x-mensaje WITH FRAME {&FRAME-NAME}.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Compra W-Win 
PROCEDURE Fecha-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    FOR EACH tt-datos WHERE tt-datos.codcia = s-codcia:
        FOR LAST  integral.almdmov USE-INDEX almd02
            WHERE integral.almdmov.codcia = 1
            AND integral.almdmov.codmat = tt-datos.codmat
            AND integral.almdmov.tipmov = "I"
            AND integral.almdmov.codmov = 02 NO-LOCK,
            EACH integral.almcmov OF integral.almdmov USE-INDEX almc04
                WHERE integral.almcmov.codpro = "51135890" NO-LOCK:
            tt-datos.fchcmp = integral.almcmov.fchdoc.
            DISPLAY "CARGANDO INFORMACION ... "  @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
*/

    FOR EACH integral.almcmov WHERE integral.almcmov.codcia = s-codcia
        AND integral.almcmov.codpro = "51135890"
        AND integral.almcmov.tipmov = "I"
        AND integral.almcmov.codmov = 02 NO-LOCK,
        EACH integral.almdmov OF integral.almcmov NO-LOCK:

        /*Calculando unidades*/
        FIND FIRST tt-datos WHERE tt-datos.codcia = s-codcia
            AND tt-datos.codmat = integral.almdmov.codmat NO-ERROR.
        IF AVAIL tt-datos THEN tt-datos.fchcmp = integral.almdmov.fchdoc.        
        PAUSE 0.            
        DISPLAY "CARGANDO INFORMACION " @ x-mensaje WITH FRAME {&FRAME-NAME}.
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
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          x-fchcorte = TODAY.

      FOR EACH integral.almtfami NO-LOCK:
          x-familia:ADD-LAST(integral.almtfami.codfam) IN FRAME {&FRAME-NAME}.
      END.
      x-familia = '010'.
      
      FIND FIRST integral.almtfam WHERE integral.almtfam.codcia = s-codcia
          AND integral.almtfam.codfam = x-familia NO-LOCK NO-ERROR.
      IF AVAIL integral.almtfam THEN x-desfam = integral.almtfam.desfam.
  END.

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

