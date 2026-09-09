&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*******/

/* Local Variable Definitions ---                                       */
DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-resume 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA
                     NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-CFGPRO THEN DO:
   MESSAGE "Registro de Configuracion de Produccion no existe"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 F-Orden desdeF Btn_OK hastaF ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Orden desdeF hastaF 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Orden AS CHARACTER FORMAT "X(6)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 4.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Orden AT ROW 2.12 COL 7.43 COLON-ALIGNED
     desdeF AT ROW 2.92 COL 7.43 COLON-ALIGNED
     Btn_OK AT ROW 5.23 COL 15.43
     hastaF AT ROW 2.92 COL 27 COLON-ALIGNED
     Btn_Cancel AT ROW 5.23 COL 37.29
     RECT-62 AT ROW 1.08 COL 1.14
     RECT-60 AT ROW 5.12 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
         FONT 4.


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
         TITLE              = "Materiales Directos X Orden de Produccion"
         HEIGHT             = 5.88
         WIDTH              = 53.72
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
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

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Materiales Directos X Orden de Produccion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Materiales Directos X Orden de Produccion */
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
  ASSIGN DesdeF HastaF F-Orden.
 
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Orden W-Win
ON LEAVE OF F-Orden IN FRAME F-Main /* Orden */
DO:
   
  /* IF SELF:SCREEN-VALUE = "" THEN RETURN.*/
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

   F-ORDEN = SELF:SCREEN-VALUE .   

   FIND PR-ODPC WHERE PR-ODPC.CodCia = S-CODCIA 
                  AND PR-ODPC.NumOrd = F-Orden
                  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de produccion No existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-Orden.
      RETURN NO-APPLY.   
   END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF F-Orden .

  x-titulo2 = "ORDEN DE PRODUCCION No " + F-ORDEN.
  x-titulo1 = 'ANALISIS DE ORDEN DE PRODUCCION'.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY F-Orden desdeF hastaF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 F-Orden desdeF Btn_OK hastaF Btn_Cancel 
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
  FOR EACH T-resume:
      DELETE T-Resume.
  END.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X AS INTEGER.
    
  DEFINE FRAME FC4-REP
          T-resume.codmat COLUMN-LABEL "Articulo"
          T-resume.desmat FORMAT "X(35)" COLUMN-LABEL "Descripcion"
          T-resume.undbas FORMAT "X(5)"  COLUMN-LABEL "UM"
          T-resume.canrea FORMAT ">>,>>>,>>9.99" COLUMN-LABEL "Cantidad!Procesada"
          T-resume.cansis FORMAT ">>,>>>,>>9.99" COLUMN-LABEL "Cantidad!Calculada!Final"
          T-resume.Total FORMAT ">>,>>>,>>9.99" COLUMN-LABEL "Costo!Total "
        WITH WIDTH 250 NO-BOX NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME FC1-REP
          PR-ODPC.NumOrd 
          PR-ODPC.CodAlm  
          PR-ODPC.FchOrd  FORMAT "99/99/9999"
          PR-ODPCX.codart  FORMAT "X(6)"
          Almmmatg.DesMat FORMAT "X(35)"
          Almmmatg.UndBas FORMAT "X(5)"  
          PR-ODPCX.CodFor  FORMAT "X(3)"
          PR-ODPCX.CanPed  FORMAT ">>,>>>,>>9.99" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 


  DEFINE FRAME FC2-REP
         Almcmov.Nrodoc  AT 1
         Almcmov.Codalm  AT 10
         Almcmov.FchDoc  AT 16 FORMAT "99/99/9999"
         Almcmov.Usuario AT 65
         Almcmov.Nrorf1  AT 75
         X-Movi          AT 87 FORMAT 'X(33)' 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME FC3-REP
         Almcmov.Nrodoc  AT 1
         Almcmov.Codalm  AT 10
         Almcmov.FchDoc  AT 16 FORMAT "99/99/9999"
         Almcmov.Usuario AT 65
         Almcmov.Nrorf1  AT 75
         X-Movi          AT 87 FORMAT 'X(33)' 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME FD1-REP
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         Almmmatg.Desmat AT 28 FORMAT "X(40)"
         Almdmov.CodUnd  AT 70
         Almdmov.CanDes FORMAT "(>,>>>,>>9.99)" 
         F-PRECIO FORMAT "(>,>>>,>>9.99)" 
         F-TOTAL  FORMAT "(>,>>>,>>9.99)" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME FD2-REP
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         Almmmatg.Desmat AT 28 FORMAT "X(40)"
         Almdmov.CodUnd  AT 70
         Almdmov.CanDes FORMAT "(>,>>>,>>9.99)" 
         F-PRECIO FORMAT "(>,>>>,>>9.99)" 
         F-TOTAL  FORMAT "(>,>>>,>>9.99)"          
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 



  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         x-titulo1 AT 45 FORMAT "X(35)" 
         "Pag.  : " AT 115 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         x-titulo2 AT 45 FORMAT "X(35)"
         "Fecha : " AT 115 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
         "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         " Orden Alm.  Fecha  Articulo  Descripcion                        UM                                                                  " SKIP
         "                                                                                    Cantidad       Costo/Promedio     Total/Costo    " SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

       FOR EACH PR-ODPC NO-LOCK WHERE PR-ODPC.CodCia = S-CODCIA AND  
                                      PR-ODPC.NumOrd = F-Orden:
       
          
          DISPLAY PR-ODPC.NumOrd @ Fi-Mensaje LABEL "Numero de Movimiento"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.

          VIEW STREAM REPORT FRAME H-REP.

          X = 1.
          FOR EACH PR-ODPCX OF PR-ODPC:
            FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                Almmmatg.CodMat = PR-ODPCX.CodArt
                                NO-LOCK NO-ERROR.
                                
            DISPLAY STREAM REPORT
                  PR-ODPC.NumOrd WHEN X = 1
                  PR-ODPC.CodAlm WHEN X = 1
                  PR-ODPC.FchOrd   FORMAT "99/99/9999" WHEN X = 1
                  PR-ODPCX.codart  FORMAT "X(6)"
                  Almmmatg.DesMat  FORMAT "X(35)"
                  Almmmatg.UndBas  FORMAT "X(5)"  
                  PR-ODPCX.CodFor  FORMAT "X(3)"
                  PR-ODPCX.CanPed  FORMAT ">>,>>>,>>9.99" 
                  WITH FRAME FC1-REP.      

/*            DOWN STREAM REPORT 1 WITH FRAME FC1-REP.             */
            X = X + 1.      

            FIND T-resume WHERE T-resume.codmat = PR-ODPCX.CodArt
                                NO-ERROR.
            IF NOT AVAILABLE T-resume THEN DO:
               CREATE T-Resume.
               ASSIGN 
                  T-resume.Codmat = PR-ODPCX.CodArt
                  T-resume.Desmat = Almmmatg.desmat
                  T-resume.UndBas = Almmmatg.undbas.
            END.                         
            T-resume.Cansis = T-resume.Cansis + PR-ODPCX.CanPed.    
          END.

          FOR EACH PR-ODPD OF PR-ODPC:
            FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                Almmmatg.CodMat = PR-ODPD.Codmat
                                NO-LOCK NO-ERROR.
                                
  
            FIND T-resume WHERE T-resume.codmat = PR-ODPD.Codmat
                                NO-ERROR.
            IF NOT AVAILABLE T-resume THEN DO:
               CREATE T-Resume.
               ASSIGN 
                  T-resume.Codmat = PR-ODPD.Codmat
                  T-resume.Desmat = Almmmatg.desmat
                  T-resume.UndBas = Almmmatg.undbas.
            END.                         
            T-resume.Cansis = T-resume.Cansis + PR-ODPD.CanPed.    

          END.


            FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                           Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                           Almcmov.fchdoc >= desdef AND
                                           Almcmov.fchdoc <= hastaf AND
                                           Almcmov.TipMov = PR-CFGPRO.TipMov[1] AND
                                           Almcmov.Codmov = PR-CFGPRO.CodMov[1] AND
                                           Almcmov.CodRef = "OP" AND
                                           Almcmov.Nroref = PR-ODPC.NumOrd:
                                     
                                 
             X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.
             FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                            AND  Almtmovm.tipmov = Almcmov.tipmov 
                            AND  Almtmovm.codmov = Almcmov.CodMov 
                            NO-LOCK NO-ERROR.
             IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.
        
             DISPLAY STREAM REPORT
                     Almcmov.Nrodoc  
                     Almcmov.Codalm  
                     Almcmov.FchDoc  
                     Almcmov.Usuario 
                     Almcmov.Nrorf1  
                     X-Movi          
                     WITH FRAME FC2-REP.      
             FOR EACH Almdmov OF Almcmov:
    
                 F-STKGEN = AlmDMOV.StkActCbd .
                 F-VALCTO = AlmDMOV.Vctomn1Cbd .
                 F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
                 F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
                 F-TOTAL  = F-PRECIO * Almdmov.CanDes.
                 
                 FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                     Almmmatg.CodMat = Almdmov.Codmat
                                     NO-LOCK NO-ERROR.
              
                 DISPLAY STREAM REPORT
                        Almdmov.codmat  AT 16 FORMAT "X(8)"
                        Almmmatg.Desmat AT 28 FORMAT "X(40)"
                        Almdmov.CodUnd  AT 70
                        Almdmov.CanDes FORMAT "(>,>>>,>>9.99)" 
                        F-PRECIO     
                        F-TOTAL
                        WITH FRAME FD1-REP.      

                FIND T-resume WHERE T-resume.codmat = Almdmov.Codmat
                                    NO-ERROR.
                IF NOT AVAILABLE T-resume THEN DO:
                   CREATE T-Resume.
                   ASSIGN 
                      T-resume.Codmat = Almdmov.Codmat
                      T-resume.Desmat = Almmmatg.desmat
                      T-resume.UndBas = Almmmatg.undbas.
                END.                         
                T-resume.CanRea = T-resume.CanRea + Almdmov.CanDes.    
                T-resume.Total  = T-resume.Total  + F-TOTAL.    

             END.        
               DOWN STREAM REPORT 1 WITH FRAME FC2-REP.             
            END.

 END.  



  FOR EACH T-resume:
    DISPLAY STREAM REPORT
            T-resume.codmat  
            T-resume.desmat 
            T-resume.undbas 
            T-resume.canrea 
            T-resume.cansis 
            T-resume.Total
            
            WITH FRAME FC4-REP.      
  END.

  
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT  .    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF F-Orden.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY
            HastaF = TODAY .
      DISPLAY DesdeF HastaF .      
  
  END.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen W-Win 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME FC4-REP
          T-resume.codmat 
          T-resume.desmat FORMAT "X(35)" 
          T-resume.undbas FORMAT "X(5)"  
          T-resume.canrea FORMAT ">>,>>>,>>9.99" 
          T-resume.cansis FORMAT ">>,>>>,>>9.99" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME H-REP2
         HEADER
         "RESUMEN " AT 45 FORMAT "X(35)" 
         "---------------------------------------------------------------------------------------------------" SKIP
         " Articulo  Descripcion                        UM           Cantidad           Cantidad             " SKIP
         "                                                           Procesada       Requerida/Calculada     " SKIP
         "---------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  VIEW STREAM REPORT FRAME H-REP2.


  FOR EACH T-resume:
    DISPLAY STREAM REPORT
            T-resume.codmat  
            T-resume.desmat 
            T-resume.undbas 
            T-resume.canrea 
            T-resume.cansis 
            WITH FRAME FC4-REP.      
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


