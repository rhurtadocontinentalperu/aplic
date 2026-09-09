&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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

/* RHC 20/07/2015 definimos s-codcia s-codalm y s-coddiv SOLO para ALMACENES */
{alm/windowalmacen.i}
/* ************************************************************************* */

/* Local Variable Definitions ---                                       */
/* DEFINE SHARED VAR S-CODALM AS CHAR.    */
/* DEFINE SHARED VAR S-DESALM AS CHAR.    */
/* DEFINE SHARED VAR S-CODCIA AS INTEGER. */
/* DEFINE SHARED VAR S-CODDIV AS CHAR.    */
DEFINE SHARED VAR S-MOVUSR AS CHAR.

DEFINE NEW SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE NEW SHARED VARIABLE S-MOVVAL  AS LOGICAL.
DEFINE NEW SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE NEW SHARED VARIABLE ORDTRB    AS CHAR.

DEFINE NEW SHARED VARIABLE S-TPOMOV AS CHAR INIT 'S'.   /* Salidas */
DEFINE NEW SHARED VARIABLE C-CODMOV AS CHAR.    /* Mov Válidos */
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */

/* UBICAMOS LOS MOVIMIENTOS VALIDOS */
FOR EACH Almtmovm NO-LOCK WHERE Almtmovm.codcia = s-codcia
        AND Almtmovm.tipmov =  s-TpoMov
        AND Almtmovm.Indicador[1] = NO:
    IF c-CodMov = ''
    THEN c-CodMov = TRIM(STRING(Almtmovm.codmov)).
    ELSE c-CodMov = c-CodMov + ',' + TRIM(STRING(Almtmovm.codmov)).
END.        

/* CHEQUEAMOS LA CONFIGURACION DE MOVIENTOS POR ALMACEN */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA AND
     Almtdocm.CodAlm = S-CODALM AND
     Almtdocm.TipMov = S-TPOMOV AND
     LOOKUP(TRIM(STRING(Almtdocm.CodMov)), c-CodMov) > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
   MESSAGE "No existen movimientos asignados al almacen" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

/* UBICAMOS EL CORRELATIVO POR DIVISION Y ALMACEN Y DOCUMENTO = G/R */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDiv = S-CODDIV 
    AND FacCorre.CodDoc = "G/R" 
    /*AND FacCorre.CodAlm = S-CODALM */
    NO-LOCK NO-ERROR.
/* IF NOT AVAILABLE FacCorre THEN DO:                                                        */
/*    MESSAGE "Correlativo de Guia de Remision no esta configurado" VIEW-AS ALERT-BOX ERROR. */
/*    RETURN ERROR.                                                                          */
/* END.                                                                                      */
IF AVAILABLE Faccorre THEN S-NROSER = FacCorre.NroSer.

/* CHEQUEAMOS LOS MOVIMIENTOS VALIDOS DEL USUARIO */
DEF VAR j AS INT.
DEF VAR x-Ok AS LOG INIT YES.
DEF VAR x-CodMov LIKE c-CodMov.

IF s-MovUsr <> '' THEN DO:
    x-Ok = NO.
    x-CodMov = ''.
    DO  j = 1 TO NUM-ENTRIES(c-CodMov):
        IF LOOKUP(TRIM(s-TpoMov) + ',' + ENTRY(j, c-CodMov), s-MovUsr, '|') > 0 THEN DO:
            IF x-CodMov = '' THEN x-CodMov = ENTRY(j, c-CodMov).
            ELSE x-CodMov = x-CodMov + ',' + ENTRY(j, c-CodMov).
            x-Ok = YES.
        END.
    END.
    c-CodMov = x-CodMov.
END.
IF x-Ok = NO THEN DO:
    MESSAGE 'El usuario NO tiene permiso para ejecutar estos movimientos en el almacén'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-salida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpsal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-import-excel-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-alcmov AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-salida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-movmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-salida AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 6.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RECT-4 AT ROW 2.35 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.72 BY 21.69
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Salidas de Almacen"
         HEIGHT             = 21.69
         WIDTH              = 111.72
         MAX-HEIGHT         = 23.19
         MAX-WIDTH          = 114.43
         VIRTUAL-HEIGHT     = 23.19
         VIRTUAL-WIDTH      = 114.43
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Salidas de Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Salidas de Almacen */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

  ASSIGN lh_Handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-movmto.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-movmto ).
       RUN set-position IN h_v-movmto ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 58.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 71.43 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.31 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-salida.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-salida ).
       RUN set-position IN h_v-salida ( 2.62 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.65 , 101.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 8.81 , 21.86 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 18.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 8.85 , 40.14 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.31 , 49.43 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/q-salida.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-salida ).
       RUN set-position IN h_q-salida ( 1.04 , 59.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 9.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/q-alcmov.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-alcmov ).
       RUN set-position IN h_q-alcmov ( 8.96 , 1.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-movmto. */
       RUN add-link IN adm-broker-hdl ( h_q-salida , 'Record':U , h_v-movmto ).

       /* Links to SmartViewer h_v-salida. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-salida ).
       RUN add-link IN adm-broker-hdl ( h_q-alcmov , 'Record':U , h_v-salida ).

       /* Links to SmartQuery h_q-salida. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-salida ).

       /* Links to SmartQuery h_q-alcmov. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-alcmov ).
       RUN add-link IN adm-broker-hdl ( h_q-salida , 'Record':U , h_q-alcmov ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-movmto , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-salida ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_v-salida , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-salida ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-alcmov ,
             h_q-salida , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-salida.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-salida ).
       RUN set-position IN h_b-salida ( 10.23 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-salida ( 11.92 , 103.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-salida. */
       RUN add-link IN adm-broker-hdl ( h_q-alcmov , 'Record':U , h_b-salida ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-salida ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/f-import-excel.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-import-excel-2 ).
       RUN set-position IN h_f-import-excel-2 ( 8.81 , 90.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 17.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-tmpsal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpsal ).
       RUN set-position IN h_b-tmpsal ( 10.15 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-tmpsal ( 12.54 , 98.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 10.15 , 100.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 5.23 , 11.57 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpsal. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpsal ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-import-excel-2 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpsal ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-tmpsal , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 2 ).

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
  ENABLE RECT-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Excel W-Win 
PROCEDURE Import-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pArchivo AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

RUN alm/d-import-excel-ingresos (OUTPUT pArchivo).
IF pArchivo = ? OR (TRUE <> (pArchivo > '') ) THEN RETURN.

/* Cargamos temporal */
EMPTY TEMP-TABLE ITEM.

DEF VAR lNuevoFile AS LOG INIT NO NO-UNDO.
DEF VAR lFIleXls AS CHAR NO-UNDO.
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fCanDes AS DECI NO-UNDO.

lFIleXls = pArchivo.
{lib\excel-open-file.i}
lCerrarAlTerminar = YES.

DEFINE VARIABLE t-Column AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE t-Row    AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE cValue   AS CHARACTER      NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
DO:
    ASSIGN
        t-Column = 0
        t-Row = 1.    
    /* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
    cValue = chWorkSheet:Cells(1,1):VALUE.
    IF cValue = "" OR cValue = ? THEN DO:
        pMensaje = 'Formato del archivo Excel errado' + CHR(10) + 'Proceso abortado'.
        LEAVE.
    END.

    REPEAT:
        ASSIGN
            t-Row    = t-Row + 1.
        t-column = 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        /* CODIGO */
        cCodMat = cValue.
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
            Almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
       /* Cantidad */
        t-column = 2.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        ASSIGN fCanDes = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN NEXT.
        /* Stock en el almacén */
        FIND Almmmate WHERE Almmmate.codcia = s-codcia AND
            Almmmate.codalm = s-codalm AND
            Almmmate.codmat = cCodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        /* Registro */
        CREATE ITEM.
        ASSIGN
            ITEM.codcia = s-codcia
            ITEM.codalm = s-codalm
            ITEM.codmat = cCodMat
            ITEM.candes = fCanDes
            ITEM.codund = Almmmatg.undstk
            .
    END.
END.
SESSION:SET-WAIT-STATE('').
/* Cerrar el Excel  */
{lib\excel-close-file.i}

IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
IF h_b-tmpsal <> ? THEN RUN dispatch IN h_b-tmpsal ('open-query':U).

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
  ASSIGN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " [ " + S-CODALM + " - " + S-DESALM + " ]".
  RUN Procesa-Handle("Pagina1").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones W-Win 
PROCEDURE Procesa-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN "Import-Excel" THEN DO:
        RUN Import-Excel.

    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "browse"   THEN DO:
          RUN dispatch IN h_b-salida ('open-query':U).
          RUN dispatch IN h_b-tmpsal ('open-query':U).
       END.
    WHEN "Inactiva" THEN RUN dispatch IN h_b-salida ('hide':U).
    WHEN "Activa"   THEN RUN dispatch IN h_b-salida ('view':U).
    WHEN "Pagina1"  THEN DO:
          RUN select-page(1).
          RUN dispatch IN h_b-salida ('open-query':U).
      END.
    WHEN "Pagina2"  THEN DO:
          RUN select-page(2).
          RUN dispatch IN h_b-tmpsal ('open-query':U).
      END.
    WHEN "Carga-Series" THEN RUN Carga-Series IN h_q-salida.
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

