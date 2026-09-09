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
&Scoped-Define ENABLED-OBJECTS txtCodAlm txtAlmacenes txtFechaGenMarbete ~
txtFechaStock rbEmpresas chbxDiaCerrado btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtCodAlm txtDesAlm txtAlmacenes ~
txtFechaGenMarbete txtFechaStock rbEmpresas chbxDiaCerrado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtAlmacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(4)":U 
     LABEL "Almacen Inventariado" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaGenMarbete AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de la toma inventarios" 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaStock AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha del Stock a Considerar" 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY 1 NO-UNDO.

DEFINE VARIABLE rbEmpresas AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo CONTI", 1,
"Solo CISSAC", 2,
"Ambos", 3
     SIZE 55 BY .96 NO-UNDO.

DEFINE VARIABLE chbxDiaCerrado AS LOGICAL INITIAL yes 
     LABEL "Considerar dia CERRADO ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCodAlm AT ROW 2.73 COL 21 COLON-ALIGNED WIDGET-ID 2
     txtDesAlm AT ROW 2.73 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtAlmacenes AT ROW 3.92 COL 21 COLON-ALIGNED WIDGET-ID 8
     txtFechaGenMarbete AT ROW 6.38 COL 27 COLON-ALIGNED WIDGET-ID 12
     txtFechaStock AT ROW 7.85 COL 27 COLON-ALIGNED WIDGET-ID 14
     rbEmpresas AT ROW 9.85 COL 12 NO-LABEL WIDGET-ID 16
     chbxDiaCerrado AT ROW 11.58 COL 23 WIDGET-ID 20
     btnProcesar AT ROW 14.46 COL 36 WIDGET-ID 22
     "carga inicial" VIEW-AS TEXT
          SIZE 9 BY .81 AT ROW 6.96 COL 55 WIDGET-ID 26
          FGCOLOR 1 FONT 7
     "Debe ser la misma que indico en el proceso de" VIEW-AS TEXT
          SIZE 32 BY .69 AT ROW 6.38 COL 45.14 WIDGET-ID 24
          FGCOLOR 1 FONT 7
     "(Individual / Consolidado)" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 2.92 COL 61 WIDGET-ID 6
     "(Separado por comas si son CONSOLIDADOS)" VIEW-AS TEXT
          SIZE 43 BY .62 AT ROW 5.19 COL 24 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85 BY 17 WIDGET-ID 100.


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
         TITLE              = "Actualizar saldos a Marbetes - Toma de Inventarios"
         HEIGHT             = 17
         WIDTH              = 85
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
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Actualizar saldos a Marbetes - Toma de Inventarios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Actualizar saldos a Marbetes - Toma de Inventarios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:
  
   /* DEFINE VAR rpta AS LOGICAL.*/

    ASSIGN txtCodAlm txtAlmacenes txtFechaGenMarbete txtFechaStock
        rbEmpresas chbxDiaCerrado txtDesAlm.

    IF txtCodAlm = "" THEN DO:
        MESSAGE 'Ingrese el almacen Inventariado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF txtAlmacenes = "" THEN DO:
        MESSAGE 'Ingrese los almacenes' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF txtDesAlm = "" THEN DO:
        MESSAGE 'Codigo de Almacen ERRADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    DEF VAR x-Claves AS CHAR INIT 'aura2013,auracontinental' NO-UNDO.
    DEF VAR x-rep AS CHAR INIT '' NO-UNDO.
    DEF VAR x-nivel-acceso AS INT INIT 0.

    RUN lib/_clave3 (x-claves, OUTPUT x-rep).
    x-nivel-acceso = LOOKUP(x-rep, x-Claves).
    IF x-nivel-acceso = 1 OR x-nivel-acceso  = 2  THEN DO :
        MESSAGE 'Desea ejecutar proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        RUN um-procesar.
    END.
    ELSE DO:
        MESSAGE 'Password erradoooo.....' VIEW-AS ALERT-BOX ERROR.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodAlm wWin
ON LEAVE OF txtCodAlm IN FRAME fMain /* Almacen Inventariado */
DO:
  DEFINE VAR lCodAlm AS CHAR.

  txtDesAlm:SCREEN-VALUE = "".
  lCodAlm = txtCodAlm:SCREEN-VALUE.

  FIND integral.almacen WHERE integral.almacen.codcia = 1 AND integral.almacen.codalm = lCodAlm NO-LOCK NO-ERROR.
  IF AVAILABLE almacen THEN txtDesAlm:SCREEN-VALUE = integral.almacen.descripcion.
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
  DISPLAY txtCodAlm txtDesAlm txtAlmacenes txtFechaGenMarbete txtFechaStock 
          rbEmpresas chbxDiaCerrado 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCodAlm txtAlmacenes txtFechaGenMarbete txtFechaStock rbEmpresas 
         chbxDiaCerrado btnProcesar 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  txtFechaGenMarbete:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  txtFechaStock:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 1,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR calm AS CHARACTER.
 DEFINE VAR calmX AS CHARACTER.
 DEFINE VAR calmacenes AS CHARACTER.
 DEFINE VAR lDiaCerrado AS LOGICAL. 
 DEFINE VAR lDiaQueSeGeneroElMarbetete AS DATE.
 DEFINE VAR lDiaDelStock_a_jalar AS DATE.
 DEFINE VARIABLE iInt      AS INTEGER NO-UNDO.

 DEFINE VARIABLE lEmpresas AS INT.

 SESSION:SET-WAIT-STATE('GENERAL').

 DEFINE BUFFER buff_almdinv FOR integral.almdinv.

 /* La fecha es mm/dd/yyyy */
 /* Para el 11X, cAlm = "11X", cAlmacenes = "11,22" */
 /* Para cualquier otro almacen, cAlm = "03", cAlmacenes = "03" */
 cAlm        = txtCodAlm.          
 cAlmX       = ''.       /* Solo es una variable temporal */         
 calmacenes    = txtAlmacenes.     
 /*
 cAlm        = '10A'.          
 cAlmX       = ''.          
 calmacenes    = "10A".   
 */
 lDiaCerrado = chbxDiaCerrado.     /* NO = Stocks en Linea */
 lDiaQueSeGeneroElMarbetete = txtFechaGenMarbete.     /* mm/dd/yyyy*/
 lDiaDelStock_a_jalar = txtFechaStock .

 /* CUIDADO AQUIIIIIII  */
 lEmpresas = rbEmpresas.                  /*   1:Solo Conti,  2:SOlo Cissac,  3:Ambas   */

 /* Fecha cuando se cargo los datos para el marbete  */    
 FOR EACH integral.almdinv WHERE integral.almdinv.codcia = 1 AND 
     (integral.almdinv.codalm = cAlm ) AND libre_f01 = lDiaQueSeGeneroElMarbetete :

     ASSIGN integral.almdinv.qtyfisico = 0
             /*
             almdinv.qtyconteo = 0
             almdinv.qtyreconteo = 0
             almdinv.libre_d01 = 0*/ .        

     /* Si los inventarios se hacen en dias cerrados 
         coger los saldos del ALMSTKAL almstkal de lo contrario de ALMMMATE
     */
     /* Las paginas 8000 son de aquellos articulos que se ingresaron antes de 
         empezar el conteo.
        Las paginas 9000 son aquellas que lo ingresaron en el conteo
     */
     IF integral.almdinv.NroPagina < 10000 THEN DO:
         /* Solo los Items generados x la carga inicial */
         DO iInt = 1 TO NUM-ENTRIES(calmacenes):                  
             cAlmX = ENTRY(iInt,calmacenes,",").
             /* Fecha del dia del stock que deseamos cargar */
             /* Dia Cerrado */
             IF lDiaCerrado = YES THEN DO:        
                 IF lEmpresas = 1 OR lEmpresas = 3  THEN DO:
                     /* CONTINENTAL */
                     FIND LAST integral.almstkal WHERE integral.almstkal.codcia = 1 AND 
                         integral.almstkal.codalm = cAlmX
                         AND integral.almstkal.codmat = integral.almdinv.codmat AND 
                         integral.almstkal.fecha <= lDiaDelStock_a_jalar NO-LOCK NO-ERROR.
                     IF AVAILABLE integral.almstkal THEN DO:
                         /* x el Almacen Virtual */
                         ASSIGN integral.almdinv.qtyfisico = integral.almdinv.qtyfisico + integral.almstkal.stkact.
                         /* x el Almacen Individual */
                         FIND buff_almdinv WHERE buff_almdinv.codcia = 1 AND buff_almdinv.codalm = cAlmx AND 
                             buff_almdinv.codmat = integral.almdinv.codmat EXCLUSIVE NO-ERROR.
                         IF AVAILABLE buff_almdinv THEN DO:
                             ASSIGN buff_almdinv.qtyfisico = integral.almstkal.stkact.
                         END.
                     END.
                     ELSE DO:
                         /*MESSAGE 'Articulo NO EXISTE (' + integral.almdinv.codmat + ")" VIEW-AS ALERT-BOX INFORMATION.*/
                     END.
                 END.

                 /* CISSAC */                           
                 /*
                 IF lEmpresas = 2 OR lEmpresas = 3 THEN DO:
                     FIND LAST cissac.almstkal WHERE cissac.almstkal.codcia = 1 AND cissac.almstkal.codalm = cAlmX
                         AND cissac.almstkal.codmat = integral.almdinv.codmat AND 
                         cissac.almstkal.fecha <= lDiaDelStock_a_jalar NO-LOCK NO-ERROR.
                     IF AVAILABLE cissac.almstkal THEN DO:
                         /* x el Almacen Virtual */
                         ASSIGN integral.almdinv.qtyfisico = integral.almdinv.qtyfisico + cissac.almstkal.stkact.
                         /* x el Almacen Individual */
                         /* El stock individual seria el total menos Continental */
                     END.
                     ELSE DO:
                         /*MESSAGE "Articulo NO EXISTE en CISSAC(" + integral.almdinv.codmat + ")" VIEW-AS ALERT-BOX INFORMATION.*/
                     END.
                 END.    
                 */
             END.
             ELSE DO:        
                 /* Stock en Linea */
                 IF lEmpresas = 1 OR lEmpresas = 3  THEN DO:
                     /* CONTINENTAL */
                     FIND LAST integral.almmmate WHERE integral.almmmate.codcia = 1 AND integral.almmmate.codalm = cAlmX
                         AND integral.almmmate.codmat = integral.almdinv.codmat NO-LOCK NO-ERROR.
                     IF AVAILABLE integral.almmmate THEN DO:
                         /* x el Almacen Virtual */
                         ASSIGN integral.almdinv.qtyfisico = integral.almdinv.qtyfisico + integral.almmmate.stkact.
                         /* x el Almacen Individual */
                         FIND buff_almdinv WHERE buff_almdinv.codcia = 1 AND buff_almdinv.codalm = cAlmx AND buff_almdinv.codmat = integral.almdinv.codmat EXCLUSIVE NO-ERROR.
                         IF AVAILABLE buff_almdinv THEN DO:
                             ASSIGN buff_almdinv.qtyfisico = integral.almmmate.stkact.
                         END.
                     END.
                     ELSE DO:
                         /*MESSAGE 'Articulo NO EXISTE (' + integral.almdinv.codmat + ")" VIEW-AS ALERT-BOX INFORMATION.*/
                     END.
                 END.

                 /* CISSAC */         
                 /*
                 IF lEmpresas = 2 OR lEmpresas = 3  THEN DO:
                     FIND LAST cissac.almmmate WHERE cissac.almmmate.codcia = 1 AND cissac.almmmate.codalm = cAlmX
                         AND cissac.almmmate.codmat = integral.almdinv.codmat NO-LOCK NO-ERROR.
                     IF AVAILABLE cissac.almmmate THEN DO:
                         /* x el Almacen Virtual */
                         ASSIGN integral.almdinv.qtyfisico = integral.almdinv.qtyfisico + cissac.almmmate.stkact.
                     END.
                     ELSE DO:
                         /*MESSAGE 'Articulo NO EXISTE en CISSAC (' + integral.almdinv.codmat + ")" VIEW-AS ALERT-BOX INFORMATION.*/
                     END.
                 END.      
                 */
             END.
         END.
     END.
 END.

 SESSION:SET-WAIT-STATE('').

 MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

