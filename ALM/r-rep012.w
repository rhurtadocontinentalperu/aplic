&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.


DEF VAR p AS LOGICAL.
DEF VAR q AS LOGICAL.

DEF VAR PR-CODCIA AS INT NO-UNDO.
DEF VAR desalm    LIKE Almacen.Descripcion.
DEF VAR almacen   LIKE Almacen.codalm.
DEF VAR almdes    AS CHARACTER.
DEF VAR clistalm  AS CHARACTER NO-UNDO.



FIND FIRST EMPRESAS WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN PR-CODCIA = S-CODCIA.

DEFINE TEMP-TABLE Reporte  
    FIELDS CodAlm   LIKE Almcmov.CodAlm
    FIELDS CodMat   LIKE Almmmatg.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELD  UndMed   AS CHAR FORMAT 'x(7)'   /*LIKE Almmmatg.UndBas*/
    FIELDS TpoArt   LIKE Almmmatg.TpoArt
    FIELDS StkAct   LIKE Almmmate.StkAct
    FIELDS StkMin   LIKE Almmmate.StkMin
    FIELDS StkMax   LIKE Almmmate.StkMax
    FIELDS Saldos   AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    /*INDEX Llave01 IS PRIMARY CodMat*/   .
    /*FIELDS Saldo35a AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS Saldo04  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS Saldo03  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS Saldo05  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS Saldo17  AS DECIMAL FORMAT "->>>,>>>,>>9.99"*/   

DEFINE TEMP-TABLE Reporte1 
    FIELDS CodAlm   LIKE Almmmate.CodAlm
    FIELDS CodMat   LIKE Almmmatg.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELD  UndMed   AS CHAR FORMAT 'x(7)'   /*LIKE Almmmatg.UndBas*/
    FIELDS StkAct   LIKE Almmmate.StkAct
    FIELDS StkMin   LIKE Almmmate.StkMin
    FIELDS StkMax   LIKE Almmmate.StkMax
    FIELDS Saldos   AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS CodAl2   LIKE Almmmate.CodAlm
    FIELD  StkTra   LIKE Almmmate.StkMax
    INDEX Llave01 IS PRIMARY CodAlm CodMat CodAl2.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Mensajes
     /*IMAGE-1 AT ROW 1.5 COL 5*/
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".

ASSIGN clistalm = "03,04,05,17,35a".

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
&Scoped-Define ENABLED-OBJECTS RECT-57 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-almacen f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén Destino" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "35a","04","03","05","17" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.86 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-almacen AT ROW 1.81 COL 14 COLON-ALIGNED
     f-Mensaje AT ROW 3.42 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     Btn_OK AT ROW 5.58 COL 39
     Btn_Cancel AT ROW 5.58 COL 51
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1 COL 6.43
          FONT 6
     RECT-57 AT ROW 1.19 COL 2
     RECT-46 AT ROW 5.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.14 BY 6.65
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Traslados Sugeridos"
         HEIGHT             = 6.65
         WIDTH              = 62.14
         MAX-HEIGHT         = 6.65
         MAX-WIDTH          = 62.14
         VIRTUAL-HEIGHT     = 6.65
         VIRTUAL-WIDTH      = 62.14
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
/* SETTINGS FOR COMBO-BOX COMBO-BOX-almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Traslados Sugeridos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Traslados Sugeridos */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    
    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE s-codalm:
    WHEN "35a" THEN ASSIGN almacen = "35a".
    WHEN "04"  THEN ASSIGN almacen = "04".
    WHEN "03"  THEN ASSIGN almacen = "03".
    WHEN "05"  THEN ASSIGN almacen = "05".
    WHEN "17"  THEN ASSIGN almacen = "17".
      OTHERWISE DO:
          MESSAGE "Usted no se encuentra en el" SKIP
                  "     Almacen correcto      " SKIP
                  "      35a,04,03,05,17      " 
                  VIEW-AS ALERT-BOX ERROR.
          RETURN "NO-APPLY".
          END.    
END CASE.
 FIND FIRST almacen WHERE Almacen.CodCia = s-CodCia 
     AND Almacen.CodAlm = almacen
     NO-LOCK NO-ERROR.
 IF AVAILABLE almacen THEN desalm = Almacen.Descripcion.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH Reporte:
        DELETE Reporte.
    END.

    FOR EACH Reporte1:
        DELETE Reporte1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
DEFINE VARIABLE dtotal AS DECIMAL NO-UNDO.
DEFINE VARIABLE totpos AS DECIMAL NO-UNDO.
DEFINE VARIABLE totneg AS DECIMAL NO-UNDO.
DEFINE VARIABLE cantidad AS DECIMAL NO-UNDO.
DEF BUFFER b-reporte FOR Reporte.

FOR EACH Reporte WHERE Reporte.CodAlm = almacen BREAK BY Reporte.CodMat:
    IF Reporte.Saldos >= 0 THEN NEXT.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Acumulando por material: ' + Reporte.codmat.
    totneg = 0.
    totpos = 0.
    cantidad = Reporte.Saldos * (-1).
      
    /*Calculando Totales positivos y negativos*/
    FOR EACH b-reporte NO-LOCK WHERE b-Reporte.CodMat = Reporte.CodMat :
        IF b-reporte.Saldos > 0 THEN DO:
           totpos = totpos + b-reporte.Saldos. 
        END.
        ELSE IF b-reporte.Saldos < 0 THEN DO:
           totneg = totneg + b-reporte.Saldos.
        END.
        IF totpos < totneg THEN ASSIGN cantidad = cantidad * (totneg / totpos).
    END.      
    
    /*Asignando Cantidades y almacenes*/
    FOR EACH b-Reporte NO-LOCK WHERE b-Reporte.CodMat = Reporte.CodMat 
        AND b-Reporte.CodAlm <> almacen
        AND cantidad <> 0:
        IF b-Reporte.Saldos < cantidad AND b-Reporte.Saldos > 0 THEN DO:
            CREATE Reporte1.
            ASSIGN 
                Reporte1.CodAlm = Reporte.CodAlm
                Reporte1.CodMat = Reporte.CodMat
                Reporte1.DesMat = Reporte.DesMat
                Reporte1.DesMar = Reporte.DesMar
                Reporte1.UndMed = Reporte.UndMed
                Reporte1.StkAct = Reporte.StkAct 
                Reporte1.StkMin = Reporte.StkMin 
                Reporte1.StkMax = Reporte.StkMax
                Reporte1.Saldos = Reporte.Saldos
                Reporte1.CodAl2 = b-Reporte.CodAlm
                Reporte1.StkTra = b-Reporte.Saldos.

                cantidad = cantidad - b-Reporte.Saldos.
        END.
        ELSE IF b-Reporte.Saldos > cantidad AND b-Reporte.Saldos > 0 THEN DO:
            CREATE Reporte1.
            ASSIGN 
                    Reporte1.CodAlm = Reporte.CodAlm
                    Reporte1.CodMat = Reporte.CodMat
                    Reporte1.DesMat = Reporte.DesMat
                    Reporte1.DesMar = Reporte.DesMar
                    Reporte1.UndMed = Reporte.UndMed
                    Reporte1.StkAct = Reporte.StkAct 
                    Reporte1.StkMin = Reporte.StkMin 
                    Reporte1.StkMax = Reporte.StkMax
                    Reporte1.Saldos = Reporte.Saldos
                    Reporte1.CodAl2 = b-Reporte.CodAlm
                    Reporte1.StkTra = cantidad.

                    cantidad = 0.
        END.
    END. /*FOR EACH b-Reporte....*/

    FIND FIRST Reporte1 WHERE Reporte1.CodAlm = almacen
         AND Reporte1.CodMat = Reporte.CodMat
         NO-ERROR.
    IF NOT AVAILABLE Reporte1 THEN DO:
       DELETE Reporte.
    END.
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
DEFINE VAR dsaldo AS DECIMAL NO-UNDO COLUMN-LABEL "Saldo".
DEFINE BUFFER B-Almmmate FOR Almmmate.
DEFINE BUFFER B-Almmmatg FOR Almmmatg.

RUN Borra-Temporal.

FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-CodCia AND
    LOOKUP(Almacen.CodAlm, clistalm) > 0,
    EACH Almmmate NO-LOCK WHERE 
        Almmmate.CodCia = s-CodCia AND
        Almmmate.CodAlm = Almacen.CodAlm AND
        Almmmate.StkAct <= Almmmate.StkMin AND 
        Almmmate.StkMin > 0 AND
        Almmmate.StkMax > 0 ,
        FIRST Almmmatg OF Almmmate NO-LOCK
            WHERE Almmmatg.TpoArt = "A"
            BREAK BY Almmmate.CodMat
                  BY Almmmate.CodAlm:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Material: ' + Almmmate.codmat + ' Almacén: ' + Almmmate.codalm.
        dsaldo = Almmmate.StkAct - Almmmate.StkMax.
            CREATE Reporte.
                ASSIGN 
                    Reporte.CodAlm = Almmmate.CodAlm 
                    Reporte.CodMat = Almmmate.codmat 
                    Reporte.DesMat = Almmmatg.DesMat
                    Reporte.DesMar = Almmmatg.DesMar
                    Reporte.UndMed = Almmmatg.UndBas
                    Reporte.TpoArt = Almmmatg.TpoArt
                    Reporte.StkAct = Almmmate.StkAct 
                    Reporte.StkMin = Almmmate.StkMin 
                    Reporte.StkMax = Almmmate.StkMax
                    Reporte.Saldos = dsaldo.
               
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
  DISPLAY COMBO-BOX-almacen f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 Btn_OK Btn_Cancel 
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
DEFINE FRAME F-REPORTE
        /*Reporte1.CodAlm   COLUMN-LABEL "Alm."*/
        Reporte1.CodMat   COLUMN-LABEL "Material"
        Reporte1.DesMat   COLUMN-LABEL "Descripción"
        Reporte1.DesMar   COLUMN-LABEL "Marca"  FORMAT "X(20)"
        Reporte1.UndMed   COLUMN-LABEL "Unidad!Medida"  FORMAT 'x(7)'
        Reporte1.StkAct   COLUMN-LABEL "Stock!Actual"
        Reporte1.StkMin   COLUMN-LABEL "Stock!Minimo"
        Reporte1.StkMax   COLUMN-LABEL "Stock!Máximo"
        Reporte1.Saldos   COLUMN-LABEL "Saldos " FORMAT "->>>,>>>,>>9.99"
        Reporte1.CodAl2   COLUMN-LABEL "Alm.!Transf." 
        Reporte1.StkTra   COLUMN-LABEL "Cantidad!Transf. " FORMAT "->>>,>>>,>>9.99" 
        HEADER
        "REPORTE DE TRANSFERENCIAS SUGERIDAS" AT 50 SKIP(1)
        "ALMACEN : " AT 1 almacen desalm SKIP(1)
        WITH STREAM-IO NO-BOX DOWN WIDTH 320.
loopRep:
FOR EACH Reporte1 BREAK BY Reporte1.CodMat:
    DISPLAY STREAM Report
       /* Reporte1.CodAlm   */
        Reporte1.CodMat WHEN FIRST-OF (Reporte1.CodMat)   
        Reporte1.DesMat WHEN FIRST-OF (Reporte1.CodMat)
        Reporte1.DesMar WHEN FIRST-OF (Reporte1.CodMat)
        Reporte1.UndMed WHEN FIRST-OF (Reporte1.CodMat)
        Reporte1.StkAct WHEN FIRST-OF (Reporte1.CodMat)   
        Reporte1.StkMin WHEN FIRST-OF (Reporte1.CodMat)   
        Reporte1.StkMax WHEN FIRST-OF (Reporte1.CodMat)   
        Reporte1.Saldos WHEN FIRST-OF (Reporte1.CodMat)  
        Reporte1.CodAl2   
        Reporte1.StkTra   
        WITH FRAME F-Reporte.
    DISPLAY
        Reporte1.CodMat
        FORMAT "X(15)" LABEL "   Procesando documento"
        WITH FRAME f-mensajes.
        READKEY PAUSE 0.
        IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
END.
HIDE FRAME f-mensajes.
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
    
    RUN Carga-Temporal.
    RUN Carga-Temp.
    
    IF not Can-find (First Reporte1) then do:
        message "No hay registros a imprimir" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
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
    RUN Asigna-Variables.
    COMBO-BOX-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almacen.

  /* Dispatch standard ADM method.                             */
    IF Almacen <> "" THEN DO:
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    END.                                                         

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
        WHEN "c-CodMov" THEN 
            ASSIGN
                input-var-1 = ""
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Trying W-Win 
PROCEDURE Trying :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH Reporte.
    MESSAGE "Almacen" Reporte.Codalm SKIP
        "Cantidad" Reporte.Saldos.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

