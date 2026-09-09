&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE ITEM LIKE Almdmov.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR X-NOMCOS AS CHARACTER.
DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 RECT-13 FILL-IN-Periodo C-mes ~
B-Ver-Costos BUTTON-5 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS R-TipMov FILL-IN-Periodo C-mes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-astcbd AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Corr-Costos 
     LABEL "Corregir Costo-Cero" 
     SIZE 15.57 BY .85.

DEFINE BUTTON B-Ver-Costos 
     LABEL "Verificar Costos" 
     SIZE 15.57 BY .85.

DEFINE BUTTON BUTTON-4 
     LABEL "Salir" 
     SIZE 15.57 BY .85.

DEFINE BUTTON BUTTON-5 
     LABEL "Imprimir" 
     SIZE 15.57 BY .85.

DEFINE VARIABLE C-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-TipMov AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingreso", "I",
"Salida", "S"
     SIZE 11.57 BY 1.65 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15 BY 2.08.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-TipMov AT ROW 1.58 COL 5.57 NO-LABEL
     FILL-IN-Periodo AT ROW 1.54 COL 23.72 COLON-ALIGNED
     C-mes AT ROW 2.42 COL 23.72 COLON-ALIGNED
     B-Ver-Costos AT ROW 1.42 COL 34.72
     B-Corr-Costos AT ROW 2.38 COL 34.72
     BUTTON-5 AT ROW 1.38 COL 51.57
     BUTTON-4 AT ROW 2.42 COL 51.72
     RECT-17 AT ROW 1.35 COL 18.29
     RECT-13 AT ROW 1.35 COL 3.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.57 BY 17
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
         TITLE              = "Verificacion Costos de Ingreso"
         HEIGHT             = 10.69
         WIDTH              = 87.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.43
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR BUTTON B-Corr-Costos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET R-TipMov IN FRAME F-Main
   NO-ENABLE                                                            */
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
ON END-ERROR OF W-Win /* Verificacion Costos de Ingreso */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Verificacion Costos de Ingreso */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Corr-Costos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Corr-Costos W-Win
ON CHOOSE OF B-Corr-Costos IN FRAME F-Main /* Corregir Costo-Cero */
DO:
/*
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = FILL-IN-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[C-mes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
*/
  MESSAGE  "Se Actualizaran Los Costos de Tipo cero"
           "Realmente Desea Continuar "
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
           TITLE "" UPDATE W-RPTA AS LOGICAL.
           IF NOT W-RPTA THEN RETURN.
            
  RUN Corregir-Costos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Ver-Costos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Ver-Costos W-Win
ON CHOOSE OF B-Ver-Costos IN FRAME F-Main /* Verificar Costos */
DO:
  ASSIGN
     FILL-IN-Periodo 
     C-mes 
     R-TipMov.

  IF C-mes = 0 THEN DO:
     MESSAGE 'Mes no asignado' VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO C-mes.
     RETURN NO-APPLY.
  END.

  RUN Verifica-Costos.
  
  RUN Abrir-browse IN h_b-astcbd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Salir */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Imprimir */
DO:
  RUN Pre-impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-TipMov W-Win
ON LEAVE OF R-TipMov IN FRAME F-Main
DO:
    ASSIGN R-TipMov.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-vercos.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-astcbd ).
       RUN set-position IN h_b-astcbd ( 3.62 , 1.72 ) NO-ERROR.
       /* Size in UIB:  ( 7.92 , 86.86 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-astcbd ,
             R-TipMov:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Corregir-Costos W-Win 
PROCEDURE Corregir-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ITEM WHERE ITEm.PreBas = 0:
/*
    FIND Almtmovm WHERE Almtmovm.Codcia = S-CODCIA AND
                        Almtmovm.TipMov = ITEM.TipMov AND
                        Almtmovm.CodMov = ITEM.CodMov
                        NO-LOCK NO-ERROR.
*/
   FIND Almdmov WHERE Almdmov.Codcia = ITEM.Codcia AND
                      ALmdmov.CodAlm = ITEM.CodAlm AND
                      Almdmov.TipMov = ITEM.TipMov AND
                      Almdmov.CodMov = ITEm.CodMov AND
                      Almdmov.Nrodoc = ITEM.NroDoc AND
                      Almdmov.CodMat = ITEM.CodMat
                      EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE Almdmov THEN DO:
      ASSIGN
      Almdmov.PreUni = 0
      Almdmov.ImpCto = 0.
   END.                                          
                            
                                        
    
END.


MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.

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
  DISPLAY R-TipMov FILL-IN-Periodo C-mes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-17 RECT-13 FILL-IN-Periodo C-mes B-Ver-Costos BUTTON-5 BUTTON-4 
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

DEFINE VAR I-nroitm AS INTEGER NO-UNDO.
DEFINE VAR x-debe   AS DECIMAL NO-UNDO.
DEFINE VAR x-haber  AS DECIMAL NO-UNDO.

FIND FIRST Almacen WHERE Almacen.codcia = s-codcia NO-LOCK NO-ERROR.
FIND FIRST Almtmovm WHERE Almtmovm.codcia = s-codcia NO-LOCK NO-ERROR.
   
DEFINE FRAME F-Header
    HEADER
    S-NOMCIA FORMAT "X(45)" 
    "Fecha  : " AT 110 TODAY SKIP(1)
    "VERIFICACION DE COSTOS" AT 50 FORMAT "X(45)" SKIP(1)
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                     CODIGO                         " SKIP
    "ALM TIPO CODMOV  NRODOC    FECHA     ARTICULO    UM  CANTIDAD PRECIO" SKIP
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
   
DEFINE FRAME F-Detalle
    ITEM.codalm
    ITEM.tipmov
    ITEM.codmov
    ITEM.nrodoc
    ITEM.fchdoc
    ITEM.codmat
    ITEM.CodUnd
    ITEM.CanDes
    ITEM.PreUni
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 


/*MLR* 07/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
*/

I-NroItm = 0.
FOR EACH ITEM BREAK BY ITEM.codalm 
                    BY ITEM.tipmov
                    BY ITEM.codmov
                    BY ITEM.nrodoc 
                    BY ITEM.codmat:
    VIEW FRAME F-Header.

    DISPLAY 
        ITEM.codalm
        ITEM.tipmov
        ITEM.codmov
        ITEM.nrodoc
        ITEM.fchdoc
        ITEM.codmat
        ITEM.CodUnd
        ITEM.CanDes
        ITEM.PreUni
        WITH FRAME F-Detalle.
END.    
OUTPUT CLOSE.

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
     FILL-IN-Periodo = YEAR(TODAY).
     DISPLAY FILL-IN-Periodo .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-impresion W-Win 
PROCEDURE Pre-impresion :
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
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
        RUN imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
        WHEN "" THEN
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Costos W-Win 
PROCEDURE Verifica-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ITEM:
  DELETE ITEM.
END.

FOR EACH Almacen NO-LOCK WHERE Almacen.Codcia = S-CODCIA :
    X-NOMCOS = "".
    FOR EACH Almtmovm NO-LOCK WHERE Almtmovm.Codcia = S-CODCIA AND
                                    Almtmov.TipMov  = R-TipMov:
        IF Almtmovm.MovTrf THEN NEXT.                                    
        CASE Almtmovm.TpoCto:
              WHEN 0 THEN X-NOMCOS = "Cto.Cero".
              WHEN 1 THEN X-NOMCOS = "Cto.Manual".
              WHEN 2 THEN X-NOMCOS = "Cto.Automa".
              
        END.
        FOR EACH Almcmov WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = ALmacen.CodAlm AND
                               Almcmov.TipMov = Almtmovm.TipMov AND
                               Almcmov.CodMov = Almtmovm.CodMov AND
                          YEAR(Almcmov.FchDoc) = FILL-IN-PERIODO AND
                         MONTH(Almcmov.FchDoc) = C-MES :
             IF Almtmovm.TpoCto = 3 THEN NEXT.
             DISPLAY 'Mvto ' + Almcmov.Codalm + '-' + STRING(Almcmov.CodMov, '99') + STRING(Almcmov.NroDoc, '999999')  @ Fi-Mensaje LABEL "MOVIMIENTOS"
             FORMAT "X(16)" WITH FRAME F-Proceso.

             FOR EACH ALmdmov OF Almcmov:
                 IF (Almdmov.PreUni = 0 AND Almtmovm.TpoCto = 1) OR
                    (Almdmov.PreUni > 0 AND Almtmovm.TpoCto = 0)
                 THEN DO:
                    CREATE ITEM.
                    RAW-TRANSFER Almdmov TO ITEM.
                    ASSIGN
                    ITEM.PreBas = Almtmovm.TpoCto
                    ITEM.CodAnt = X-NOMCOS.

                 END.
                                  
             END.
        END.                 
    END.                                                        
END.


HIDE FRAME F-Proceso.


DO WITH FRAME {&FRAME-NAME}:
   B-Corr-Costos:SENSITIVE = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


