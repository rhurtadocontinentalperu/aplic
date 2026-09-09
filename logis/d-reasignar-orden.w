&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pCodPHR AS CHAR.     /* PHR Origen */
DEFINE INPUT PARAMETER pNroPHR AS CHAR.     /* Nro PHR Origen */
DEFINE INPUT PARAMETER pCodOrden AS CHAR.   /* O/D OTR */
DEFINE INPUT PARAMETER pNroOrden AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE BUFFER x-vtacdocu FOR vtacdocu.

DEF VAR x-msg AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-18

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DI-RutaC

/* Definitions for BROWSE BROWSE-18                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-18 DI-RutaC.FchDoc DI-RutaC.CodDoc ~
DI-RutaC.NroDoc DI-RutaC.CodDiv DI-RutaC.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-18 
&Scoped-define QUERY-STRING-BROWSE-18 FOR EACH DI-RutaC ~
      WHERE di-rutaC.codcia = s-codcia and ~
di-rutaC.coddiv = s-coddiv and ~
di-RutaC.coddoc = 'PHR' and ~
LOOKUP(di-rutaC.flgest, 'PX,PK,PF') > 0 ~
  NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-18 OPEN QUERY BROWSE-18 FOR EACH DI-RutaC ~
      WHERE di-rutaC.codcia = s-codcia and ~
di-rutaC.coddiv = s-coddiv and ~
di-RutaC.coddoc = 'PHR' and ~
LOOKUP(di-rutaC.flgest, 'PX,PK,PF') > 0 ~
  NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-18 DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-18 DI-RutaC


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-18}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-18 Btn_Cancel Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-orden FILL-IN-phr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Reasignar" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione la PHR destino!!!" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS CHARACTER FORMAT "X(20)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-18 FOR 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-18 gDialog _STRUCTURED
  QUERY BROWSE-18 NO-LOCK DISPLAY
      DI-RutaC.FchDoc COLUMN-LABEL "Generada" FORMAT "99/99/9999":U
            WIDTH 10.43
      DI-RutaC.CodDoc COLUMN-LABEL "Cod.Doc" FORMAT "x(3)":U WIDTH 8.43
      DI-RutaC.NroDoc FORMAT "X(15)":U
      DI-RutaC.CodDiv COLUMN-LABEL "Division" FORMAT "x(6)":U
      DI-RutaC.Observ COLUMN-LABEL "Glosa" FORMAT "x(60)":U WIDTH 36.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.86 BY 10.58
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-1 AT ROW 2.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BROWSE-18 AT ROW 3.54 COL 4.14 WIDGET-ID 200
     FILL-IN-orden AT ROW 3.96 COL 95.72 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-phr AT ROW 7.5 COL 90 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     Btn_Cancel AT ROW 14.46 COL 21
     Btn_OK AT ROW 14.54 COL 4
     "Origen de la Orden" VIEW-AS TEXT
          SIZE 30 BY 1.15 AT ROW 6.15 COL 92 WIDGET-ID 8
          BGCOLOR 15 FGCOLOR 9 FONT 9
     SPACE(1.71) SKIP(9.81)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reasignar Ordenes a una nueva PHR"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-18 FILL-IN-1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-phr IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-18
/* Query rebuild information for BROWSE BROWSE-18
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.DI-RutaC.NroDoc|no"
     _Where[1]         = "di-rutaC.codcia = s-codcia and
di-rutaC.coddiv = s-coddiv and
di-RutaC.coddoc = 'PHR' and
LOOKUP(di-rutaC.flgest, 'PX,PK,PF') > 0
 "
     _FldNameList[1]   > INTEGRAL.DI-RutaC.FchDoc
"DI-RutaC.FchDoc" "Generada" ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.DI-RutaC.CodDoc
"DI-RutaC.CodDoc" "Cod.Doc" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.DI-RutaC.CodDiv
"DI-RutaC.CodDiv" "Division" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Glosa" ? "character" ? ? ? ? ? ? no ? no no "36.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-18 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Reasignar Ordenes a una nueva PHR */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* Reasignar */
DO:

    
    btn_ok:AUTO-GO = NO.

    DEFINE VAR x-rowid AS ROWID.
    DEFINE VAR x-msg AS CHAR.

    IF AVAILABLE di-rutaC THEN DO:
        IF di-rutaC.nrodoc = pNroPHR THEN DO:
            MESSAGE "Las PHR deben ser difentes..Imposible reasignar" 
                VIEW-AS ALERT-BOX INFORMATIO.
        END.
        ELSE DO:
            MESSAGE 'Seguro de reasignar la Orden ' + pCodOrden + "-" + pNroOrden SKIP
                    "hacia la nueva PHR " + di-rutaC.nrodoc
                     VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN DO:
                btn_ok:AUTO-GO = YES.
                RETURN NO-APPLY.
            END.
        END.
        RUN Reasignar-Orden.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'NO se completó el proceso de reasignación' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    btn_ok:AUTO-GO = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-18
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-1 FILL-IN-orden FILL-IN-phr 
      WITH FRAME gDialog.
  ENABLE BROWSE-18 Btn_Cancel Btn_OK 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  fill-in-orden:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodOrden + "-" + pNroOrden.
  fill-in-phr:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodPHR + "-" + pNroPHR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reasignar-Orden gDialog 
PROCEDURE Reasignar-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-CodOri  AS CHAR.
DEFINE VAR x-nroori AS CHAR.


GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, RETURN 'ADM-ERROR' ON STOP UNDO GRABAR_DATOS, RETURN 'ADM-ERROR':
    /* Cambiar el NROORI de las HPK relacionadas con la O/D */            
    FOR EACH x-vtacdocu EXCLUSIVE-LOCK WHERE x-vtacdocu.codcia = s-codcia AND
        x-vtacdocu.codref = pCodOrden AND       /* O/D */
        x-vtacdocu.nroref = pNroOrden AND
        /*x-vtacdocu.coddiv = s-coddiv AND*/
        x-vtacdocu.codped = "HPK" AND
        x-vtacdocu.flgest <> "A"  ON ERROR UNDO, THROW:

        x-codori = x-vtacdocu.CodOri .
        x-nroori = x-vtacdocu.nroOri .
        /* ********************************** */
/*         MESSAGE 'cambiando el origen a' x-vtacdocu.codped x-vtacdocu.nroped x-vtacdocu.codref x-vtacdocu.nroref */
/*             SKIP 'nuevo origen' di-rutaC.nrodoc.                                                                */
        ASSIGN 
            x-vtacdocu.nroori = di-rutaC.nrodoc.
        /* RHC Log de Control de REASIGNACION por HPK*/
        CREATE LogisLogControl.
        ASSIGN
            LogisLogControl.CodCia = s-CodCia
            LogisLogControl.CodDiv = s-CodDiv
            LogisLogControl.CodDoc = x-Vtacdocu.CodPed      /* HPK */
            LogisLogControl.NroDoc = x-Vtacdocu.NroPed
            LogisLogControl.Usuario = s-User-Id
            LogisLogControl.Evento = "PHR_REASIGN"
            LogisLogControl.Fecha = TODAY
            LogisLogControl.Hora = STRING(TIME, 'HH:MM:SS').
        ASSIGN
            LogisLogControl.Libre_c01 = pCodPHR             /* Origen */
            LogisLogControl.Libre_c02 = pNroPHR
            LogisLogControl.Libre_c03 = x-Vtacdocu.CodOri   /* Destino */
            LogisLogControl.Libre_c04 = x-Vtacdocu.NroOri.
        RELEASE LogisLogControl.
    END.
    /*  */
    FOR EACH di-rutaD EXCLUSIVE-LOCK WHERE di-rutaD.codcia = s-codcia AND
        di-rutad.coddiv = s-coddiv AND
        di-rutaD.coddoc = pCodPHR AND
        di-rutaD.nrodoc = pNroPHR AND
        di-rutaD.codref = pCodOrden AND     /* O/D */
        di-rutaD.nroref = pNroOrden ON ERROR UNDO, THROW:
        ASSIGN 
            di-rutaD.nrodoc = di-rutaC.nrodoc.
        /* RHC Log de Control de REASIGNACION por HPK*/
        CREATE LogisLogControl.
        ASSIGN
            LogisLogControl.CodCia = s-CodCia
            LogisLogControl.CodDiv = s-CodDiv
            LogisLogControl.CodDoc = pCodOrden              /*O/D OTR */
            LogisLogControl.NroDoc = pNroOrden
            LogisLogControl.Usuario = s-User-Id
            LogisLogControl.Evento = "PHR_REASIGN"
            LogisLogControl.Fecha = TODAY
            LogisLogControl.Hora = STRING(TIME, 'HH:MM:SS').
        ASSIGN
            LogisLogControl.Libre_c01 = pCodPHR             /* Origen */
            LogisLogControl.Libre_c02 = pNroPHR
            LogisLogControl.Libre_c03 = x-CodOri   /* Destino */
            LogisLogControl.Libre_c04 = x-NroOri.
        RELEASE LogisLogControl.
    END.
END.
RELEASE x-vtacdocu.
RELEASE di-rutaD.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

