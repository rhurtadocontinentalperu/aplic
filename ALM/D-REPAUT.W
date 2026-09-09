&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE TEMP-TABLE CREP LIKE Almcrequ.
DEFINE NEW SHARED TEMP-TABLE DREP LIKE Almdrequ.

DEFINE VARIABLE S-LISTNRO AS CHAR NO-UNDO.

DEFINE STREAM Reporte.


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


RUN Carga-Temporales.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 C-NroRep FILL-IN_Observ Btn_OK ~
Btn-Print Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-NroRep FILL-IN-NroDoc FILL-IN_Observ ~
FILL-IN-AlmDes FILL-IN-CodAlm F-DesAlm FILL-IN_FchDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-repaut AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Print 
     LABEL "Imprimir" 
     SIZE 10 BY .85.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     LABEL "Cancelar" 
     SIZE 10 BY .85
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK DEFAULT 
     LABEL "Generar" 
     SIZE 10 BY .85
     BGCOLOR 8 .

DEFINE VARIABLE C-NroRep AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Numero" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE F-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacha" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc AS DATE FORMAT "99/99/9999" INITIAL ? 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_Observ AS CHARACTER FORMAT "X(50)" 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 82.72 BY 2.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-NroRep AT ROW 1.23 COL 11 COLON-ALIGNED
     FILL-IN-NroDoc AT ROW 1.23 COL 11 COLON-ALIGNED
     FILL-IN_Observ AT ROW 2.15 COL 11 COLON-ALIGNED
     FILL-IN-AlmDes AT ROW 1.19 COL 35.86 COLON-ALIGNED
     FILL-IN-CodAlm AT ROW 1.19 COL 35.86 COLON-ALIGNED
     F-DesAlm AT ROW 1.23 COL 43.72 COLON-ALIGNED NO-LABEL
     FILL-IN_FchDoc AT ROW 2.15 COL 68.14 COLON-ALIGNED
     Btn_OK AT ROW 8.92 COL 73.57
     Btn-Print AT ROW 10.31 COL 73.57
     Btn_Cancel AT ROW 11.62 COL 73.57
     RECT-1 AT ROW 1 COL 1
     SPACE(0.84) SKIP(10.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reposicion Automatica".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Default                                                              */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-DesAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-AlmDes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reposicion Automatica */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Print D-Dialog
ON CHOOSE OF Btn-Print IN FRAME D-Dialog /* Imprimir */
DO:
  ASSIGN C-NroRep.
  RUN get-attribute ("CURRENT-PAGE").
  CASE INTEGER(RETURN-VALUE) :
       WHEN 1 THEN DO:
            RUN Imprime-Reposicion.
       END.
       WHEN 2 THEN DO:
            RUN Imprime-Requisicion.
       END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Generar */
DO:
  RUN get-attribute ("CURRENT-PAGE").
  CASE INTEGER(RETURN-VALUE) :
       WHEN 1 THEN DO:
            RUN Generar-Reposicion.
       END.
       WHEN 2 THEN DO:
            RUN Generar-Requisicion.
       END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-NroRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-NroRep D-Dialog
ON VALUE-CHANGED OF C-NroRep IN FRAME D-Dialog /* Numero */
DO:
  ASSIGN C-NroRep.
  RUN Pinta-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Observ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Observ D-Dialog
ON LEAVE OF FILL-IN_Observ IN FRAME D-Dialog /* Observaciones */
DO:
  ASSIGN FILL-IN_Observ
         CREP.Observ = FILL-IN_Observ.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " [ " + S-CODALM + 
                                   " - " + S-DESALM + " ]".

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-free/objects/tab95.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Pedidos de Reposicion|Requisiciones de Compra':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 3.23 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 10.73 , 71.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-repaut.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-repaut ).
       RUN set-position IN h_b-repaut ( 4.31 , 3.43 ) NO-ERROR.
       /* Size in UIB:  ( 9.08 , 67.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 4.04 , 72.72 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.50 , 11.29 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartBrowser h_b-repaut. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-repaut ).

    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales D-Dialog 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NroItm  AS INTE INIT 0 NO-UNDO.
   DEFINE VARIABLE I-NROREQ  AS INTE NO-UNDO.
   DEFINE VARIABLE F-CanPed  AS DECI NO-UNDO.
    
   /* PRIMERO CARGAMOS EL DETALLE GUARDANDO EL CODIGO DE ALMACEN */
   FOR EACH Almmmate NO-LOCK WHERE 
            Almmmate.CodCia = S-CODCIA AND
            Almmmate.CodAlm = S-CODALM AND 
            Almmmate.StkAct < Almmmate.StkMin:
       DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
               FORMAT "X(8)" WITH FRAME F-Proceso.
       FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND
            Almmmatg.codmat = Almmmate.codmat NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg THEN DO:
          IF Almmmate.AlmDes = "" OR Almmmate.AlmDes = Almmmate.CodAlm THEN 
                RUN Verificar-Requisicion.
          ELSE  RUN Verificar-Reposicion.
          IF RETURN-VALUE = "YES" THEN DO:
             F-CanPed = 0.
             IF Almmmate.StkMax > 0 AND Almmmate.StkMax > Almmmate.StkAct THEN DO:
                F-CanPed = (Almmmate.StkMax - Almmmate.StkAct).
             END.
             ELSE DO:
                IF Almmmate.StkMin > Almmmate.StkAct THEN 
                   F-CanPed = (Almmmate.StkMin - Almmmate.StkAct).
             END.
             IF F-CanPed <> 0 THEN DO:
                IF F-CanPed < 1 THEN F-CanPed = 1.
                ELSE F-CanPed = ROUND(F-CanPed,0).
                CREATE DREP.
                ASSIGN DREP.CodCia = Almmmate.CodCia
                       DREP.CodAlm = Almmmate.CodAlm
                       DREP.codmat = Almmmate.codmat
                       DREP.AlmDes = Almmmate.AlmDes
                       DREP.CanReq = F-CanPed.
                IF Almmmate.AlmDes = Almmmate.CodAlm THEN DREP.AlmDes = "".
                I-NroItm = I-NroItm + 1.
             END.
          END.
       END.
   END.
   HIDE FRAME F-PROCESO.
   IF I-NroItm = 0 THEN DO:
      MESSAGE "No hay articulos por reponer" VIEW-AS ALERT-BOX ERROR. 
      RETURN "ADM-ERROR".
   END.
   /* SEGUNDO CREAMOS LA CABECERA DE DE REQUISICION POR CADA ALMACEN ENCONTRADO 
      Y POR CADA 30 ITEMS POR ALMACEN   */
   I-NroItm = 1.
   FOR EACH DREP ,
       FIRST Almmmatg OF DREP NO-LOCK 
       BREAK BY DREP.AlmDes
             BY Almmmatg.CodFam
             BY Almmmatg.SubFam:
       IF FIRST-OF(DREP.AlmDes) OR ( I-NroItm > 30 AND DREP.AlmDes <> "" ) THEN DO:
          I-NROREQ = I-NROREQ + 1.
          I-NroItm = 1.
          CREATE CREP.
          ASSIGN CREP.CodCia  = S-CODCIA
                 CREP.CodAlm  = S-CODALM
                 CREP.NroSer  = 0
                 CREP.NroDoc  = I-NROREQ
                 CREP.Almdes  = DREP.AlmDes
                 CREP.FchDoc  = TODAY
                 CREP.Usuario = S-USER-ID
                 CREP.Observ  = "Reposion Automatica de almacen " + S-CODALM.
          IF DREP.AlmDes = "" THEN 
             CREP.Observ = "Requisicion de Compra Automatica de almacen " + S-CODALM.
          ELSE DO:
               IF S-LISTNRO = "" THEN S-LISTNRO = "000" + STRING(I-NROREQ,"999999").
               ELSE S-LISTNRO = S-LISTNRO + ",000" + STRING(I-NROREQ,"999999").
          END.
       END.
       DREP.NroDoc = I-NROREQ.
       I-NroItm = I-NroItm + 1.
   END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY C-NroRep FILL-IN-NroDoc FILL-IN_Observ FILL-IN-AlmDes FILL-IN-CodAlm 
          F-DesAlm FILL-IN_FchDoc 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 C-NroRep FILL-IN_Observ Btn_OK Btn-Print Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Reposicion D-Dialog 
PROCEDURE Generar-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE C-NRO         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE C-LISTA       AS CHARACTER NO-UNDO.
 
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  /* Primero creamos la cabecera */
  S-LISTNRO = "".
  FIND FIRST CREP WHERE 
       CREP.CodCia = S-CODCIA AND
       CREP.AlmDes <> "" NO-ERROR.
  IF AVAILABLE CREP AND CREP.NroSer = 0 THEN DO WITH FRAME {&FRAME-NAME}: 
     C-LISTA = C-NroRep:LIST-ITEMS.
     DO I = 1 TO NUM-ENTRIES(C-LISTA):
         C-NRO = ENTRY(I, C-LISTA).
         FOR EACH CREP WHERE 
                  CREP.CodCia = CREP.CodCia AND
                  CREP.CodAlm = S-CODALM    AND
                  CREP.NroSer = INTEGER(SUBSTRING(C-NRO,1,3)) AND 
                  CREP.NroDoc = INTEGER(SUBSTRING(C-NRO,5,6)):
             CREATE Almcrequ.
             ASSIGN Almcrequ.CodCia  = CREP.CodCia
                    Almcrequ.CodAlm  = CREP.CodAlm
                    Almcrequ.FchDoc  = CREP.FchDoc 
                    Almcrequ.Observ  = CREP.Observ
                    Almcrequ.Almdes  = CREP.AlmDes
                    Almcrequ.FlgEst  = "P"
                    Almcrequ.Usuario = S-USER-ID
                    Almcrequ.HorGen  = STRING(TIME,"HH:MM:SS").
             /*** CORRELATIVO AUTOMATICO  ***/
             FIND FIRST FacCorre WHERE 
                  FacCorre.CodCia = S-CODCIA AND
                  FacCorre.CodDiv = S-CODDIV AND
                  FacCorre.CodDoc = "REP"    AND
                  FacCorre.CodAlm = S-CODALM EXCLUSIVE-LOCK NO-ERROR.
             IF AVAILABLE FacCorre THEN DO:
                ASSIGN Almcrequ.NroSer = FacCorre.NroSer
                       Almcrequ.NroDoc = FacCorre.Correlativo
                       FacCorre.Correlativo = FacCorre.Correlativo + 1.
             END.
             RELEASE FacCorre.
             FOR EACH DREP WHERE 
                      DREP.CodCia = CREP.CodCia AND 
                      DREP.CodAlm = CREP.CodAlm AND 
                      DREP.NroSer = CREP.NroSer AND
                      DREP.NroDoc = CREP.NroDoc AND
                      DREP.AlmDes = CREP.AlmDes AND 
                      DREP.canreq > 0:
                 CREATE Almdrequ.
                 ASSIGN Almdrequ.CodCia = Almcrequ.CodCia 
                        Almdrequ.CodAlm = Almcrequ.CodAlm 
                        Almdrequ.NroSer = Almcrequ.NroSer 
                        Almdrequ.NroDoc = Almcrequ.NroDoc 
                        Almdrequ.AlmDes = Almcrequ.AlmDes 
                        Almdrequ.codmat = DREP.codmat 
                        Almdrequ.CanReq = DREP.canreq
                        DREP.NroSer     = Almcrequ.NroSer
                        DREP.NroDoc     = Almcrequ.NroDoc.
             END.
             CREP.NroSer = Almcrequ.NroSer.
             CREP.NroDoc = Almcrequ.NroDoc.
             IF S-LISTNRO = "" THEN S-LISTNRO = STRING(CREP.NroSer,"999") + STRING(CREP.NroDoc,"999999").
             ELSE S-LISTNRO = S-LISTNRO + "," + STRING(CREP.NroSer,"999") + STRING(CREP.NroDoc,"999999").
         END.
     END.
     C-NroRep:LIST-ITEMS = S-LISTNRO.
     C-NroRep:SCREEN-VALUE = ENTRY(1,S-LISTNRO).
     ASSIGN C-NroRep.
     RUN PINTA-DATOS.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Requisicion D-Dialog 
PROCEDURE Generar-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  /* Primero creamos la cabecera */
  FIND CREP WHERE 
       CREP.CodCia = S-CODCIA AND
       CREP.AlmDes = "" NO-ERROR.
  IF AVAILABLE CREP AND CREP.NroSer = 0 THEN DO WITH FRAME {&FRAME-NAME}:
     CREATE LG-CRequ.
     ASSIGN LG-CRequ.CodCia   = S-CODCIA
            LG-CRequ.HorEmi   = STRING(TIME,"HH:MM")
            LG-CRequ.TpoReq   = "N"
            LG-Crequ.Solicita = S-CODALM
            LG-CRequ.FlgSit   = "P"
            LG-CRequ.Observ   = CREP.Observ
            LG-CRequ.Userid-Sol = S-USER-ID.
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.CodDoc = "REQ"    AND
          FacCorre.CodAlm = S-CODALM  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN LG-CRequ.NroReq = FacCorre.Correlativo
               LG-CRequ.NroSer = FacCorre.NroSer 
               FacCorre.Correlativo = FacCorre.Correlativo + 1.
     END.
     RELEASE FacCorre.
     FOR EACH DREP WHERE 
              DREP.CodCia = CREP.CodCia AND 
              DREP.CodAlm = CREP.CodAlm AND 
              DREP.NroSer = CREP.NroSer AND
              DREP.NroDoc = CREP.NroDoc AND
              DREP.AlmDes = CREP.AlmDes AND 
              DREP.canreq > 0:
         FIND Almmmatg WHERE 
              Almmmatg.CodCia =  DREP.CodCia AND
              Almmmatg.codmat =  DREP.codmat  NO-LOCK NO-ERROR.
         CREATE LG-DRequ.
         ASSIGN LG-DRequ.CodCia  = LG-CRequ.CodCia
                LG-DRequ.NroSer  = LG-CRequ.NroSer
                LG-DRequ.NroReq  = LG-CRequ.NroReq
                LG-DRequ.Codmat  = DREP.codmat 
                LG-DRequ.CanPedi = DREP.canreq
                LG-DRequ.tpobien = 1
                LG-DRequ.UndCmp  = Almmmatg.UndStk
                DREP.NroSer      = LG-CRequ.NroSer
                DREP.NroDoc      = LG-CRequ.NroReq.
     END.
     CREP.NroSer = LG-CRequ.NroSer.
     CREP.NroDoc = LG-CRequ.NroReq.
     FILL-IN-NroDoc = STRING(CREP.NroSer,"999") + STRING(CREP.NroDoc,"999999").
     RUN Pinta-Datos.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Reposicion D-Dialog 
PROCEDURE Imprime-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST CREP WHERE 
             CREP.CodCia = CREP.CodCia AND
             CREP.CodAlm = S-CODALM    AND
             CREP.NroSer = INTEGER(SUBSTRING(C-NroRep,1,3)) AND 
             CREP.NroDoc = INTEGER(SUBSTRING(C-NroRep,4,6)) NO-ERROR.
  DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
  DEFINE VARIABLE S-Item AS INTEGER INIT 0.
  DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
  DEFINE VAR S-CODUBI AS CHAR NO-UNDO.
  DEFINE VAR F-STOCK AS DECIMAL NO-UNDO.
  DEFINE FRAME F-FMT
         S-Item AT 2 FORMAT "Z9"
         DREP.codmat AT 6   FORMAT "X(6)"
         S-CODUBI        AT 13  FORMAT "X(6)"
         Almmmatg.DesMat AT 21  FORMAT "X(40)"
         Almmmatg.DesMar AT 63  FORMAT "X(12)"
         Almmmatg.UndStk AT 76  FORMAT "X(4)"
         Almmmatg.CanEmp AT 81  FORMAT ">>,>>9.99"
         F-STOCK         AT 92  FORMAT ">>>,>>>.99"
         DREP.CanReq AT 104 FORMAT ">,>>>,>>9.99"
         "------------" AT 118
         HEADER
         S-NOMCIA AT 1 FORMAT "X(40)" "REPOSICION No. : " AT 103 C-NroRep VIEW-AS TEXT AT 123 SKIP
         "( " + S-CODALM + " )" AT 2 "SOLICITUD DE REPOSICION INTERNO" AT 50  "PAG. " AT 103 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 CREP.FchDoc AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 CREP.HorGen AT 105 SKIP
         "Observaciones   : "   AT 1 CREP.Observ  AT 21 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   EMPAQUE   STOCK ACTUAL  SOLICITADO    APROBADO  " SKIP    
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 60.
  FIND FIRST DREP WHERE 
             DREP.CodCia = CREP.CodCia AND
             DREP.CodAlm = CREP.CodAlm AND
             DREP.NroSer = CREP.NroSer AND 
             DREP.NroDoc = CREP.NroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE DREP THEN DO:
     S-DesSol = CREP.AlmDes.
     FIND Almacen WHERE Almacen.CodCia = DREP.CodCia AND
          Almacen.CodAlm = CREP.AlmDes NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN  S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(66).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH DREP NO-LOCK WHERE 
            DREP.CodCia = CREP.CodCia AND
            DREP.CodAlm = CREP.CodAlm AND
            DREP.NroSer = CREP.NroSer AND 
            DREP.NroDoc = CREP.NroDoc ,
         FIRST Almmmatg OF DREP NO-LOCK
         BREAK BY DREP.AlmDes  BY Almmmatg.DesMat:
         S-Item = S-Item + 1.     
         IF FIRST-OF ( DREP.AlmDes ) THEN DO:
            FIND Almacen WHERE almacen.CodCia = DREP.CodCia AND
                 almacen.CodAlm = DREP.Almdes NO-LOCK NO-ERROR.
            S-Tit = "Almacen de Despacho : " + DREP.Almdes.
         END.
         S-CODUBI = "".
         F-STOCK  = 0.
         FIND Almmmate OF DREP NO-LOCK NO-ERROR.
         IF AVAILABLE Almmmate THEN 
            ASSIGN S-CODUBI = Almmmate.CodUbi
                   F-STOCK  = Almmmate.StkAct.
         DISPLAY STREAM Reporte 
                   S-Item
                   DREP.Codmat 
                   S-CODUBI 
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmatg.CanEmp
                   F-STOCK  
                   DREP.CanReq WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte CREP.Usuario AT 24 " JEFE ALMACEN " AT 86 SKIP.     
  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Requisicion D-Dialog 
PROCEDURE Imprime-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST CREP WHERE 
             CREP.CodCia = CREP.CodCia AND
             CREP.CodAlm = S-CODALM    AND
             CREP.NroSer = INTEGER(SUBSTRING(FILL-IN-NroDoc,1,3)) AND 
             CREP.NroDoc = INTEGER(SUBSTRING(FILL-IN-NroDoc,4,6)) NO-ERROR.
   DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
   DEFINE VARIABLE S-Item AS INTEGER INIT 0.
   DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
   DEFINE FRAME F-FMT
         S-Item AT 1 FORMAT ">>9"
         DREP.codmat  AT 6   FORMAT "X(6)"
         Almmmate.CodUbi  AT 13  FORMAT "X(6)"        
         Almmmatg.DesMat  AT 21  FORMAT "X(40)"
         Almmmatg.DesMar  AT 63  FORMAT "X(12)"
         Almmmatg.UndStk  AT 76  FORMAT "X(4)"
         Almmmatg.CanEmp  AT 81  FORMAT ">>,>>9.99"
         Almmmate.StkAct  AT 91  FORMAT "->>>,>>>.99"  
         DREP.CanReq AT 104 FORMAT ">,>>>,>>9.99"
         "------------" AT 118
         HEADER
         S-NOMCIA AT 1 FORMAT "X(40)" "REQUISICION No. : " AT 103  FILL-IN-NroDoc AT 123 SKIP
         "( " + S-CODALM + " )" AT 2 "PRE - REQUISICION DE COMPRA" AT 53  "PAG. " AT 103 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 CREP.FchDoc AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 CREP.HorGen AT 105 SKIP
         "Observaciones   : "   AT 1 CREP.Observ  AT 21 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   EMPAQUE   STOCK ACTUAL  SOLICITADO    APROBADO  " SKIP    
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 62.
  FIND FIRST DREP WHERE 
             DREP.CodCia = CREP.CodCia AND
             DREP.NroSer = CREP.NroSer AND 
             DREP.NroDoc = CREP.NroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE DREP THEN DO:
     S-DesSol = S-CODALM.
     FIND Almacen WHERE 
          Almacen.CodCia = DREP.CodCia AND
          Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(66).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH DREP NO-LOCK WHERE AVAILABLE DREP AND
              DREP.CodCia = CREP.CodCia AND
              DREP.NroSer = CREP.NroSer AND 
              DREP.NroDoc = CREP.NroDoc: 
         S-Item = S-Item + 1.     
         
         FIND Almmmate WHERE Almmmate.CodCia = DREP.CodCia AND
                             Almmmate.CodAlm = S-CodAlm AND
                             Almmmate.CodMat = DREP.CodMat NO-LOCK NO-ERROR.
          
         FIND Almmmatg WHERE Almmmatg.CodCia = DREP.CodCia AND
              Almmmatg.CodMat = DREP.CodMat NO-LOCK NO-ERROR.
         DISPLAY STREAM Reporte 
                   S-Item
                   DREP.Codmat 
                   Almmmate.CodUbi
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmatg.CanEmp
                   Almmmate.StkAct
                   DREP.CanReq WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte CREP.Usuario AT 24 " JEFE ALMACEN " AT 86 SKIP.     
  OUTPUT STREAM Reporte CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page D-Dialog 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN get-attribute ("CURRENT-PAGE").
  DO WITH FRAME {&FRAME-NAME}:
      CASE INTEGER(RETURN-VALUE) :
           WHEN 1 THEN DO:
                C-NroRep:VISIBLE       = YES.
                FILL-IN-AlmDes:VISIBLE = YES.
                FILL-IN-NroDoc:VISIBLE = NO.
                FILL-IN-CodAlm:VISIBLE = NO.
                ASSIGN C-NroRep.
                RUN Pinta-Datos.
           END.
           WHEN 2 THEN DO:
                C-NroRep:VISIBLE       = NO.
                FILL-IN-AlmDes:VISIBLE = NO.
                FILL-IN-NroDoc:VISIBLE = YES.
                FILL-IN-CodAlm:VISIBLE = YES.
                F-DesAlm:SCREEN-VALUE = S-DESALM.
                RUN Pinta-Datos.
           END.
      END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
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
     IF S-LISTNRO = "" THEN S-LISTNRO = "000000000".
     C-NroRep:LIST-ITEMS = S-LISTNRO.
     C-NroRep:SCREEN-VALUE = ENTRY(1,S-LISTNRO).
     C-NroRep = ENTRY(1,S-LISTNRO).
     FILL-IN-CodAlm = S-CODALM.
     FILL-IN-NroDoc = "000000001".
     RUN PINTA-DATOS.
  END.
  
  RUN select-page(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos D-Dialog 
PROCEDURE Pinta-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-NROPED AS CHAR NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
  IF C-NroRep:VISIBLE THEN X-NROPED = C-NroRep.
  ELSE X-NROPED = FILL-IN-NroDoc.
  
  FIND FIRST CREP WHERE 
             CREP.CodCia = CREP.CodCia AND
             CREP.CodAlm = S-CODALM    AND
             CREP.NroSer = INTEGER(SUBSTRING(X-NROPED,1,3)) AND 
             CREP.NroDoc = INTEGER(SUBSTRING(X-NROPED,4,6)) NO-ERROR.
   IF AVAILABLE CREP THEN DO:
      DISPLAY CREP.FchDoc @ FILL-IN_FchDoc
              CREP.Observ @ FILL-IN_Observ.
      IF FILL-IN-AlmDes:VISIBLE THEN
           DISPLAY  CREP.AlmDes @ FILL-IN-AlmDes.
      ELSE DISPLAY FILL-IN-CodAlm  FILL-IN-NroDoc. 
      
      FIND Almacen WHERE 
           Almacen.CodCia = S-CODCIA AND
           Almacen.CodAlm = CREP.AlmDes NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN DISPLAY Almacen.Descripcion @ F-DesAlm.
      RUN Filtro-por-Pedido IN h_b-repaut (X-NROPED,CREP.AlmDes).
   END.
   ELSE RUN Filtro-por-Pedido IN h_b-repaut (X-NROPED,"").
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verificar-Reposicion D-Dialog 
PROCEDURE Verificar-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-REP AS INTEGER INIT 0 NO-UNDO.
FOR EACH Almcrequ NO-LOCK WHERE 
         Almcrequ.CodCia = Almmmate.CodCia AND
         Almcrequ.CodAlm = Almmmate.CodAlm AND
         Almcrequ.FlgEst <> "C" AND
         Almcrequ.FchDoc = TODAY:
    FIND Almdrequ WHERE 
         Almdrequ.CodCia = Almcrequ.CodCia AND
         Almdrequ.CodAlm = Almcrequ.CodAlm AND
         Almdrequ.NroSer = Almcrequ.NroSer AND
         Almdrequ.NroDoc = Almcrequ.NroDoc AND
         Almdrequ.CodMat = Almmmate.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almdrequ THEN DO:
       I-REP = 1.
       LEAVE.
    END.
END.
IF I-REP = 1 THEN RETURN "NO".
RETURN "YES".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verificar-Requisicion D-Dialog 
PROCEDURE Verificar-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-REP AS INTEGER INIT 0 NO-UNDO.
FOR EACH LG-CRequ NO-LOCK WHERE
         LG-CRequ.CodCia = Almmmate.CodCia AND
         LG-CRequ.Solicita = Almmmate.CodAlm AND
         LG-CRequ.FlgSit = "S" AND
         LG-CRequ.FchVto >= TODAY:
    FIND FIRST LG-DRequ WHERE 
         LG-DRequ.CodCia = LG-CRequ.CodCia AND
         LG-DRequ.NroSer = LG-CRequ.NroSer AND
         LG-DRequ.NroReq = LG-CRequ.NroReq AND
         LG-DRequ.CodMat = Almmmate.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE LG-DRequ THEN DO:
       I-REP = 1.
       LEAVE.
    END.
END.
IF I-REP = 1 THEN RETURN "NO".
FOR EACH LG-COCmp NO-LOCK WHERE 
         LG-COCmp.CodCia = Almmmate.CodCia AND 
         LG-COCmp.TpoDoc = "N"             AND
         LG-COCmp.CodAlm = Almmmate.CodAlm AND 
         LG-COCmp.FlgSit = "P"             AND
         LG-COCmp.FchVto >= TODAY:
    FIND FIRST LG-DOCmp WHERE 
         LG-DOCmp.CodCia  = LG-COCmp.CodCia AND 
         LG-DOCmp.TpoDoc  = LG-COCmp.TpoDoc AND 
         LG-DOCmp.NroDoc  = LG-COCmp.NroDoc AND 
         LG-DOCmp.TpoBien = 1               AND
         LG-DOCmp.CodMat  = Almmmate.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE LG-DOCmp AND (LG-DOCmp.CanPedi - LG-DOCmp.CanAten) > 0  THEN DO:
       I-REP = 1.
       LEAVE.
    END.
END.

RETURN "YES".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


