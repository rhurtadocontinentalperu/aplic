&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF VAR x-Meses AS CHAR INIT 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,~
Setiembre,Octubre,Noviembre,Diciembre'.
DEF VAR x-CodPro LIKE dwh_Proveedor.codpro   NO-UNDO.
DEF VAR x-CodFam LIKE dwh_Productos.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE dwh_Productos.subfam  NO-UNDO.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE detalle LIKE dwh_ventas_mat
    FIELD codpro LIKE dwh_Proveedor.codpro
    INDEX llave01 AS PRIMARY codcia codmat coddiv.
DEF STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone COMBO-BOX-Mes-1 ~
FILL-IN-Ano-1 COMBO-BOX-Mes-2 FILL-IN-Ano-2 COMBO-BOX-CodFam ~
COMBO-BOX-SubFam FILL-IN-CodPro 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Mes-1 FILL-IN-Ano-1 ~
COMBO-BOX-Mes-2 FILL-IN-Ano-2 COMBO-BOX-CodFam COMBO-BOX-SubFam ~
FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde el periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Seleccione" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta el periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Seleccione" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ano-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ano-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 99 WIDGET-ID 24
     BtnDone AT ROW 1 COL 105 WIDGET-ID 28
     COMBO-BOX-Mes-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Ano-1 AT ROW 1.54 COL 49 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-Mes-2 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Ano-2 AT ROW 2.62 COL 49 COLON-ALIGNED WIDGET-ID 10
     COMBO-BOX-CodFam AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-SubFam AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-CodPro AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-NomPro AT ROW 5.85 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN-Mensaje AT ROW 8 COL 3 NO-LABEL WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.86 BY 8.73 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "VENTAS vs COMPRAS"
         HEIGHT             = 8.73
         WIDTH              = 111.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* VENTAS vs COMPRAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* VENTAS vs COMPRAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    ASSIGN
        COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 FILL-IN-Ano-1 FILL-IN-Ano-2
        COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-CodPro.
    RUN Carga-Temporal.
   FIND FIRST detalle NO-ERROR.
   IF NOT AVAILABLE detalle THEN DO:
       MESSAGE 'No hay registros' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH dwh_Lineas NO-LOCK WHERE dwh_Lineas.CodCia = s-codcia
            AND dwh_Lineas.CodFam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(dwh_Lineas.subfam + ' - '+ dwh_Lineas.NomSubFam).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro wWin
ON LEAVE OF FILL-IN-CodPro IN FRAME fMain /* Proveedor */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND dwh_Proveedor WHERE dwh_Proveedor.codcia = pv-codcia
        AND dwh_Proveedor.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE dwh_Proveedor THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomPro:SCREEN-VALUE = dwh_Proveedor.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Fecha-1 LIKE dwh_ventas_mat.Fecha NO-UNDO.
DEF VAR x-Fecha-2 LIKE dwh_ventas_mat.Fecha NO-UNDO.

ASSIGN
    x-Fecha-1 = FILL-IN-Ano-1 * 10000 + LOOKUP(COMBO-BOX-Mes-1, x-Meses) * 100 + 01
    x-Fecha-2 = FILL-IN-Ano-2 * 10000 + LOOKUP(COMBO-BOX-Mes-2, x-Meses) * 100 + 31.

EMPTY TEMP-TABLE detalle.

ASSIGN
    x-CodPro = ''
    x-CodFam = ''
    x-SubFam = ''.
IF NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').
x-CodPro = FILL-IN-CodPro.

/* 1ro las ventas */
FOR EACH dwh_ventas_mat NO-LOCK WHERE dwh_ventas_mat.codcia = s-codcia
    AND dwh_ventas_mat.Fecha >= x-Fecha-1 
    AND dwh_ventas_mat.Fecha <= x-Fecha-2,
    FIRST dwh_Productos OF dwh_ventas_mat NO-LOCK WHERE dwh_Productos.codfam BEGINS x-CodFam
    AND dwh_Productos.CodPro[1] BEGINS x-CodPro
    AND dwh_Productos.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' ** VENTAS ' + STRING(dwh_ventas_mat.codmat) + ' ' + STRING(dwh_ventas_mat.fecha).

    FIND detalle WHERE detalle.codcia = s-codcia
        AND detalle.codmat = dwh_ventas_mat.codmat
        AND detalle.coddiv = dwh_ventas_mat.coddiv
        NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codcia = dwh_ventas_mat.codcia
        detalle.CodMat = dwh_ventas_mat.codmat
        detalle.coddiv = dwh_ventas_mat.coddiv
        detalle.ImpNacSIGV = detalle.ImpNacSIGV + dwh_ventas_mat.ImpNacSIGV
        detalle.codpro = dwh_Productos.codpro[1].
END.
/* 2do las compras */
ASSIGN
    x-Fecha-1 = FILL-IN-Ano-1 * 100 + LOOKUP(COMBO-BOX-Mes-1, x-Meses) 
    x-Fecha-2 = FILL-IN-Ano-2 * 100 + LOOKUP(COMBO-BOX-Mes-2, x-Meses).
FOR EACH dwh_Compras_ProvMat NO-LOCK WHERE dwh_Compras_ProvMat.CodCia = s-codcia
    AND dwh_Compras_ProvMat.Nrofch >= x-Fecha-1
    AND dwh_Compras_ProvMat.Nrofch <= x-Fecha-2,
    FIRST dwh_Productos OF dwh_Compras_ProvMat NO-LOCK WHERE dwh_Productos.codfam BEGINS x-CodFam
    AND dwh_Productos.CodPro[1] BEGINS x-CodPro
    AND dwh_Productos.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' ** VENTAS ' + STRING(dwh_Compras_ProvMat.codmat) + ' ' + STRING(dwh_Compras_ProvMat.nrofch).
    FIND detalle WHERE detalle.codcia = s-codcia
        AND detalle.codmat = dwh_Compras_ProvMat.codmat
        AND detalle.coddiv = dwh_Compras_ProvMat.coddiv
        NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.CodCia = dwh_Compras_ProvMat.CodCia
        detalle.CodDiv = dwh_Compras_ProvMat.CodDiv 
        detalle.CodMat = dwh_Compras_ProvMat.codmat 
        detalle.CodPro = dwh_Compras_ProvMat.CodProv 
        detalle.CostoNacSIGV = detalle.CostoNacSIGV + dwh_Compras_ProvMat.CmpxMesMn.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Mes-1 FILL-IN-Ano-1 COMBO-BOX-Mes-2 FILL-IN-Ano-2 
          COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-CodPro FILL-IN-NomPro 
          FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-1 BtnDone COMBO-BOX-Mes-1 FILL-IN-Ano-1 COMBO-BOX-Mes-2 
         FILL-IN-Ano-2 COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-CodPro 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR i-Campo AS INT INIT 1 NO-UNDO.
DEF VAR x-Campo AS CHAR NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(500)' NO-UNDO.
DEF VAR l-Titulo AS LOG INIT NO NO-UNDO.
DEF VAR x-Cuenta-Registros AS INT INIT 0 NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
FOR EACH detalle:
    i-Campo = 1.
    x-LLave = ''.
    x-Campo = ''.
    x-Titulo = ''.

    /* DIVISION */
    x-Llave = x-Llave + detalle.coddiv.
    FIND dwh_Division WHERE dwh_Division.codcia = s-codcia
        AND dwh_Division.coddiv = detalle.coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE dwh_Division THEN x-Llave = TRIM(x-Llave) + ' - ' + TRIM(dwh_Division.DesDiv).
    ELSE x-Llave = TRIM(x-Llave) + ' - '.
    x-Llave = x-LLave + '|'.
    x-Titulo = x-Titulo + 'DIVISION' + '|'.

    /* ARTICULO */
    x-Llave = x-Llave + detalle.codmat.
    FIND dwh_Productos WHERE dwh_Productos.codcia = s-codcia
        AND dwh_Productos.codmat = detalle.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE dwh_Productos THEN x-Llave = x-LLave + ' - ' + TRIM(dwh_Productos.desmat).
    ELSE x-Llave = x-LLave + ' - '.
    x-Llave = x-LLave + '|'.
    IF x-Titulo = '' THEN x-Titulo = 'ARTICULO' + '|'. ELSE x-Titulo = x-Titulo + 'ARTICULO' + '|'.
    /* PROVEEDOR */
    x-Llave = x-Llave + detalle.codpro.
    FIND dwh_Proveedor WHERE dwh_Proveedor.codcia = pv-codcia
        AND dwh_Proveedor.codpro = detalle.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE dwh_Proveedor THEN x-Llave = x-LLave + ' - ' + TRIM(dwh_Proveedor.NomPro).
    ELSE x-Llave = x-LLave + ' - '.
    x-Llave = x-LLave + '|'.
    IF x-Titulo = '' THEN x-Titulo = 'PROVEEDOR' + '|'. ELSE x-Titulo = x-Titulo + 'PROVEEDOR' + '|'.

    x-Titulo = x-Titulo + 'VENTAS-SOLES SIN IGV' + '|' + 'COMPRAS-SOLES SIN IGV' + '|'+ ' '.
    x-Llave = x-Llave + STRING(detalle.ImpNacSIGV, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(detalle.CostoNacSIGV, '->>>>>>>>9.99') + '|'.

    x-Llave = x-Llave + ' ' .
    x-Titulo = x-Titulo + ' '.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
    IF l-Titulo = NO THEN DO:
        PUT STREAM REPORTE x-Titulo SKIP.
        l-Titulo = YES.
    END.
    PUT STREAM REPORTE x-LLave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
    IF x-Cuenta-Registros > 65000 THEN DO:
        MESSAGE 'Se ha llegado al tope de 65000 registros que soporta el Excel' SKIP
            'Carga abortada' VIEW-AS ALERT-BOX WARNING.
        LEAVE.
    END.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Ano-1 = YEAR(TODAY)
      FILL-IN-Ano-2 = YEAR(TODAY).
  FOR EACH dwh_Lineas NO-LOCK WHERE dwh_Lineas.CodCia = s-codcia
      BREAK BY dwh_Lineas.codfam:
      IF FIRST-OF(dwh_Lineas.codfam) THEN
      COMBO-BOX-CodFam:ADD-LAST(dwh_Lineas.codfam + ' - ' + dwh_Lineas.NomFam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      COMBO-BOX-Mes-1:LIST-ITEMS IN FRAME {&FRAME-NAME} = x-Meses
      COMBO-BOX-Mes-2:LIST-ITEMS IN FRAME {&FRAME-NAME} = x-Meses
      COMBO-BOX-Mes-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Enero'
      COMBO-BOX-Mes-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Diciembre'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

