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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
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
DEFINE VAR x-titu2 AS CHAR NO-UNDO.
DEFINE VAR x-titu3 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.
DEFINE VAR X-nombre AS CHAR NO-UNDO.
DEFINE VAR X-TOT AS DECI INIT 0 NO-UNDO.

DEFINE VAR S-CODMON AS CHAR FORMAT "X(10)".

DEFINE TEMP-TABLE T-Prod 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes 
       FIELD Nroref LIKE Almcmov.NroRef
       FIELD Fchdoc LIKE Almcmov.Fchdoc
       FIELD nrodoc LIKE Almcmov.Nrodoc
       FIELD codpro LIKE Gn-Prov.Codpro
       FIELD Codalm LIKE Almcmov.Codalm.

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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 F-Provee F-Gasto desdeF ~
hastaF nCodMon Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Provee F-Gasto desdeF hastaF nCodMon 

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

DEFINE VARIABLE F-Gasto AS CHARACTER FORMAT "X(11)":U 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-Provee AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Provee AT ROW 1.77 COL 7.86 COLON-ALIGNED
     F-Gasto AT ROW 2.69 COL 7.86 COLON-ALIGNED
     desdeF AT ROW 3.77 COL 8 COLON-ALIGNED
     hastaF AT ROW 3.77 COL 27.29 COLON-ALIGNED
     nCodMon AT ROW 4.69 COL 9.72 NO-LABEL
     Btn_OK AT ROW 5.85 COL 15.29
     Btn_Cancel AT ROW 5.85 COL 37.14
     RECT-62 AT ROW 1.08 COL 1.14
     RECT-60 AT ROW 5.73 COL 1
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
         TITLE              = "Liquidacion Servicios Terceros"
         HEIGHT             = 6.5
         WIDTH              = 53.57
         MAX-HEIGHT         = 11.15
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 11.15
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

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Liquidacion Servicios Terceros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Liquidacion Servicios Terceros */
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
 
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Gasto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Gasto W-Win
ON LEAVE OF F-Gasto IN FRAME F-Main /* Concepto */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN .
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

   /* Valida Maestro Proveedores */
   FIND PR-Gastos WHERE 
        PR-Gastos.Codcia = S-CODCIA AND  
        PR-Gastos.CodGas = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-Gastos THEN DO:
      MESSAGE "Codigo de Gastos no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
/*
   DISPLAY PR-Gastos.DesGas @ FILL-IN-2   
           WITH FRAME {&FRAME-NAME}.
*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Provee
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Provee W-Win
ON LEAVE OF F-Provee IN FRAME F-Main /* Proveedor */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND  
        Gn-Prov.CodPro = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Prov THEN DO:
      MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   /*DISPLAY Gn-Prov.NomPro @ FILL-IN-1 WITH FRAME {&FRAME-NAME}.*/
  
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
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN F-Provee F-Gasto DesdeF HastaF ncodmon.

  x-titulo1 = 'LIQUIDACION SERVICIOS TERCEROS'.
  X-TITU2 = "PERIODO DEL " + STRING(DESDEF,"99/99/9999") + " AL " + STRING(HASTAF,"99/99/9999").
  IF NCODMON = 2 THEN X-TITU3 = "EXPRESADO EN DOLARES AMERICANOS ".
  ELSE X-TITU3 = "EXPRESADO EN NUEVOS SOLES ".

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Gastos W-Win 
PROCEDURE Crea-Tempo-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR X-UNIDADES AS DECI INIT 0.
  DEFINE VAR X-PRECIo AS DECI INIT 0.

  FOR EACH T-Prod:    
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= T-Prod.FchDoc
        NO-LOCK NO-ERROR.  
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA 
        AND Almmmatg.CodMat = T-Prod.CodMat 
        NO-LOCK NO-ERROR.
    FIND PR-ODPC WHERE PR-ODPC.Codcia = S-CODCIA 
        AND PR-ODPC.NumOrd = T-Prod.NroRef
        NO-LOCK NO-ERROR.
    IF AVAILABLE PR-ODPC 
    THEN DO:                                            
        FOR EACH PR-ODPDG OF PR-ODPC:
            T-prod.Codpro = PR-ODPDG.CodPro.
            FIND PR-PRESER WHERE PR-PRESER.Codcia = PR-ODPDG.Codcia AND
                                     PR-PRESER.CodPro = PR-ODPDG.CodPro AND
                                     PR-PRESER.CodGas = PR-ODPDG.CodGas AND
                                     PR-PRESER.CodMat = T-Prod.CodMat
                                     NO-LOCK NO-ERROR.
            X-PRECIO = 0.
            IF AVAILABLE PR-PRESER 
            THEN DO:  
                   IF nCodMon = 1 THEN DO:
                      IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1].
                      IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1] * Gn-Tcmb.Venta .
                   END.
                   IF nCodMon = 2 THEN DO:
                      IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1] /  Gn-Tcmb.Venta.
                      IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1]  .
                   END.
                   FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                  AND  Almtconv.Codalter = PR-PRESER.UndA 
                                  NO-LOCK NO-ERROR.
                   IF AVAILABLE Almtconv THEN DO:
                      T-Prod.Precio = (X-PRECIO ) / (PR-PRESER.CanDes[1] * Almtconv.Equival).                    
                      T-Prod.Total  = /* T-Prod.Total + */ (X-PRECIO * T-Prod.CanRea) / (PR-PRESER.CanDes[1] * Almtconv.Equival).                    
                   END.                    
            END.            
        END.
    END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Prod W-Win 
PROCEDURE Crea-Tempo-Prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-Prod:
    DELETE T-Prod.
END.
DEFINE VAR I AS INTEGER.
DEFINE VAR F-STKGEN AS DECI .
DEFINE VAR F-VALCTO AS DECI .
DEFINE VAR F-PRECIO AS DECI.
DEFINE VAR F-TOTAL AS DECI.
DEFINE VAR X-LLAVE AS LOGICAL.
  
FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA :
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                 Almcmov.CodAlm = Almacen.Codalm AND
                                 Almcmov.TipMov = PR-CFGPRO.TipMov[2] AND
                                 Almcmov.Codmov = PR-CFGPRO.CodMov[2] AND
                                 Almcmov.FchDoc >= DesdeF AND
                                 Almcmov.FchDoc <= HastaF:
    /*                             
                                 Almcmov.CodRef = "OP" AND
                                 Almcmov.Nroref = PR-ODPC.NumOrd AND
    */                         
                         
     FIND PR-ODPC WHERE PR-ODPC.Codcia = S-CODCIA AND
                        PR-ODPC.NumOrd = Almcmov.NroRef
                        NO-LOCK NO-ERROR.
        
     X-LLAVE = FALSE. 
     IF AVAILABLE PR-ODPC THEN DO:                                            
        FOR EACH PR-ODPDG OF PR-ODPC:
            IF PR-ODPDG.Codpro BEGINS F-provee THEN X-LLAVE = TRUE.
        END.    
     END.
     IF X-LLAVE THEN DO:
        FOR EACH Almdmov OF Almcmov:
       
            FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                Almmmatg.CodMat = Almdmov.Codmat
                                NO-LOCK NO-ERROR.
         
              CREATE T-Prod.
              ASSIGN 
                 T-Prod.Codmat = Almdmov.Codmat
                 T-Prod.Desmat = Almmmatg.desmat
                 T-Prod.UndBas = Almmmatg.undbas
                 T-Prod.Nroref = Almcmov.NroRef
                 T-Prod.Fchdoc = Almcmov.Fchdoc
                 T-Prod.nrodoc = Almcmov.Nrodoc
                 T-Prod.Codalm = Almcmov.Codalm
                 T-Prod.CanRea = T-Prod.CanRea + Almdmov.CanDes.    
       
        END.        
     END.
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
  DISPLAY F-Provee F-Gasto desdeF hastaF nCodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 F-Provee F-Gasto desdeF hastaF nCodMon Btn_OK 
         Btn_Cancel 
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
  FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA 
                     NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PR-CFGPRO THEN RETURN.
  
  RUN Crea-tempo-prod.
  RUN Crea-tempo-Gastos.
  x-tot = 0.
  DEFINE FRAME FC-REP
         T-Prod.Fchdoc
         T-Prod.Nroref
         T-Prod.Codmat
         T-Prod.Desmat
         T-Prod.UndBas
         T-Prod.Canrea
         T-Prod.Precio
         T-Prod.Total
         T-Prod.Nrodoc
         T-Prod.Codalm
         WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 


  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         x-titulo1 AT 45 FORMAT "X(35)"
         "Pag.  : " AT 115 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-TITU2 FORMAT "X(60)" SKIP
         X-TITU3 FORMAT "X(60)" SKIP
         "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "        Orden                                                                                                                  Costo  Ingreso     " SKIP
         " Fecha  Trabajo          Producto                                           UM           Cantidad           Tarifa             Total  Prod.T.  Alm" SKIP
         "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

       FOR EACH T-Prod BREAK BY T-Prod.Codpro
                             BY T-Prod.Fchdoc:                             

          DISPLAY T-Prod.CodPro @ Fi-Mensaje LABEL "Proveedor         "
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.

          VIEW STREAM REPORT FRAME H-REP.
         
          IF FIRST-OF(T-prod.Codpro) THEN DO:                               
            x-nombre = "".
            FIND Gn-Prov WHERE 
                 Gn-Prov.Codcia = pv-codcia AND  
                 Gn-Prov.CodPro = T-prod.Codpro         
                 NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-Prov THEN x-nombre =  Gn-prov.NomPro .

            PUT STREAM REPORT "Proveedor : " FORMAT "X(10)" .
            PUT STREAM REPORT T-prod.Codpro  FORMAT "X(11)" AT 12 .
            PUT STREAM REPORT x-nombre       FORMAT "X(45)" AT 25 SKIP.
            PUT STREAM REPORT "------------------------------------------" FORMAT "X(50)" SKIP.
               
          END.     
       
          X-TOT = X-TOT + T-prod.Total.
          
          DISPLAY STREAM REPORT
                T-Prod.Fchdoc
                T-Prod.Nroref
                T-Prod.Codmat
                T-Prod.Desmat
                T-Prod.UndBas
                T-Prod.Canrea
                T-Prod.Precio
                T-Prod.Total
                T-Prod.Nrodoc
                T-Prod.Codalm
                WITH FRAME FC-REP.      
 
          IF LAST-OF(T-prod.Codpro) THEN DO:                               
            UNDERLINE STREAM REPORT 
                T-Prod.Total
            WITH FRAME FC-REP.
            DISPLAY STREAM REPORT 
                ("Total Proveedor : " + t-prod.codpro) @ t-prod.desmat
                X-TOT @ T-Prod.Total  
                WITH FRAME FC-REP.
               
          END.     

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
    ENABLE ALL /*EXCEPT  */.    
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
            RUN LIB/W-README.R(s-print-file).
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
  ASSIGN F-Provee F-Gasto DesdeF HastaF ncodmon.

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
   DISPLAY TODAY @ DESDEF
           TODAY @ HASTAF.
   
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

