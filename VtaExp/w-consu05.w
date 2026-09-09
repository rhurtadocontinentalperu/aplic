&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-FILE-01 NO-UNDO LIKE w-report.
DEFINE NEW SHARED TEMP-TABLE T-FILE-02 NO-UNDO LIKE w-report.
DEFINE NEW SHARED TEMP-TABLE T-FILE-03 NO-UNDO LIKE w-report.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 BUTTON-4 BUTTON-3 ~
FILL-IN-Fecha-2 BUTTON-5 COMBO-BOX-Lista 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-art-prov W-Win 
FUNCTION fget-art-prov RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGet-nom-prov W-Win 
FUNCTION fGet-nom-prov RETURNS CHARACTER
  ( INPUT pCodProv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-consu05-equipo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consu05-promotor AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consu05-prov-promotor AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "APLICAR FILTROS" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 5" 
     SIZE 4 BY .96.

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha-1 AT ROW 1.19 COL 18 COLON-ALIGNED WIDGET-ID 22
     BUTTON-4 AT ROW 1.19 COL 34 WIDGET-ID 26
     BUTTON-3 AT ROW 1.19 COL 43 WIDGET-ID 24
     FILL-IN-Fecha-2 AT ROW 2.35 COL 18 COLON-ALIGNED WIDGET-ID 6
     BUTTON-5 AT ROW 2.35 COL 34 WIDGET-ID 28
     COMBO-BOX-Lista AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.29 BY 18.23 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FILE-01 T "NEW SHARED" NO-UNDO INTEGRAL w-report
      TABLE: T-FILE-02 T "NEW SHARED" NO-UNDO INTEGRAL w-report
      TABLE: T-FILE-03 T "NEW SHARED" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Proveedor-Equipo-Promotor"
         HEIGHT             = 18.23
         WIDTH              = 89.29
         MAX-HEIGHT         = 18.23
         MAX-WIDTH          = 89.29
         VIRTUAL-HEIGHT     = 18.23
         VIRTUAL-WIDTH      = 89.29
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
ON END-ERROR OF W-Win /* Proveedor-Equipo-Promotor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Proveedor-Equipo-Promotor */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  IF h_b-consu05-equipo <> ? THEN  RUN dispatch IN h_b-consu05-equipo ('open-query':U).
  IF h_b-consu05-promotor <> ? THEN  RUN dispatch IN h_b-consu05-promotor ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN src/bin/_calenda NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  FILL-IN-Fecha-1:SCREEN-VALUE = RETURN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN src/bin/_calenda NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  FILL-IN-Fecha-2:SCREEN-VALUE = RETURN-VALUE.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Prov-Equipos|Prov-Promoto|Prov-Eqpo-Pro' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 4.65 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 14.42 , 86.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             COMBO-BOX-Lista:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-consu05-prov-equipo.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consu05-equipo ).
       RUN set-position IN h_b-consu05-equipo ( 6.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consu05-equipo ( 12.69 , 81.72 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consu05-equipo ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-consu05-prov-promotor.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consu05-promotor ).
       RUN set-position IN h_b-consu05-promotor ( 6.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consu05-promotor ( 12.69 , 81.72 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consu05-promotor ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-consu05-prov-equipo-promotor.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consu05-prov-promotor ).
       RUN set-position IN h_b-consu05-prov-promotor ( 5.81 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-consu05-prov-promotor ( 12.69 , 81.72 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consu05-prov-promotor ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-FILE-01.
EMPTY TEMP-TABLE T-FILE-02.
EMPTY TEMP-TABLE T-FILE-03.

DEF VAR x-Promotor AS CHAR NO-UNDO.
DEF VAR x-Equipo   AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.

DEF VAR x-NomProveedor AS CHAR NO-UNDO.
DEF VAR x-NomPromotor AS CHAR NO-UNDO.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddiv = s-coddiv
    AND Faccpedi.coddoc = 'COT'
    AND Faccpedi.fchped >= FILL-IN-Fecha-1
    AND Faccpedi.fchped <= FILL-IN-Fecha-2
    AND Faccpedi.flgest <> "A"
    AND FacCPedi.Libre_C01 = COMBO-BOX-Lista,
    EACH Facdpedi OF Faccpedi NO-LOCK:
    /* Capturamos info */
    IF NUM-ENTRIES(Facdpedi.Libre_C03,'|') >= 3 THEN DO:
        ASSIGN
            x-Proveedor = ENTRY(1, Facdpedi.Libre_C03, '|')
            x-Promotor  = ENTRY(2, Facdpedi.Libre_C03, '|')
            x-Equipo    = ENTRY(3, Facdpedi.Libre_C03, '|').

            x-NomProveedor = fGet-nom-prov(x-Proveedor).

            /* Buscamos datos del promotor */
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Tabla = "EXPOPROMOTOR"
                AND VtaTabla.Llave_c1 = x-Proveedor
                AND VtaTabla.Llave_c2 = x-Promotor
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN x-NomPromotor = VtaTabla.Libre_c01.

        /* POR PROVEEDOR-EQUIPOS */
        FIND T-FILE-01 WHERE T-FILE-01.Campo-C[1] = x-Proveedor AND 
                                T-FILE-01.Campo-C[2] = x-Equipo NO-ERROR.
        IF NOT AVAILABLE T-FILE-01 THEN CREATE T-FILE-01.
        ASSIGN
            T-FILE-01.Campo-C[1] = x-Proveedor
            T-FILE-01.Campo-C[2] = x-Equipo            
            T-FILE-01.Campo-C[3] = x-NOmProveedor            
            T-FILE-01.Campo-F[1] = T-FILE-01.Campo-F[1] + Facdpedi.ImpLin.


        /* POR PROVEEDOR-EQUIPOS-PROMOTOR */
        FIND T-FILE-02 WHERE T-FILE-02.Campo-C[1] = x-Proveedor AND 
                                T-FILE-02.Campo-C[2] = x-Equipo AND
                                T-FILE-02.Campo-C[3] = x-promotor NO-ERROR.
        IF NOT AVAILABLE T-FILE-02 THEN CREATE T-FILE-02.
        ASSIGN
            T-FILE-02.Campo-C[1] = x-Proveedor
            T-FILE-02.Campo-C[2] = x-Equipo            
            T-FILE-02.Campo-C[3] = x-Promotor
            T-FILE-02.Campo-C[4] = x-NOmProveedor            
            T-FILE-02.Campo-C[5] = x-NomPromotor
            T-FILE-02.Campo-F[1] = T-FILE-02.Campo-F[1] + Facdpedi.ImpLin.

        /* POR PROVEEDOR-PROMOTOR */
        FIND T-FILE-03 WHERE T-FILE-03.Campo-C[1] = x-Proveedor AND 
                                T-FILE-03.Campo-C[2] = x-promotor NO-ERROR.
        IF NOT AVAILABLE T-FILE-03 THEN CREATE T-FILE-03.
        ASSIGN
            T-FILE-03.Campo-C[1] = x-Proveedor
            T-FILE-03.Campo-C[2] = x-Promotor
            T-FILE-03.Campo-C[3] = x-NOmProveedor            
            T-FILE-03.Campo-C[4] = x-NomPromotor
            T-FILE-03.Campo-F[1] = T-FILE-03.Campo-F[1] + Facdpedi.ImpLin.

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha-1 BUTTON-4 BUTTON-3 FILL-IN-Fecha-2 BUTTON-5 
         COMBO-BOX-Lista 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  ASSIGN
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY.     

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Lista:DELETE(COMBO-BOX-Lista:LIST-ITEM-PAIRS).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia 
          AND GN-DIVI.CanalVenta = "FER"
          WITH FRAME {&FRAME-NAME}:
          COMBO-BOX-Lista:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv, gn-divi.coddiv) NO-ERROR.
      END.
      COMBO-BOX-Lista:SCREEN-VALUE  = s-coddiv.
  END.


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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-art-prov W-Win 
FUNCTION fget-art-prov RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR INIT ''.

FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.codmat = pCodmat NO-LOCK NO-ERROR.
IF AVAILABLE almmmatg THEN lRetVal = almmmatg.codpr1.

RELEASE almmmatg.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGet-nom-prov W-Win 
FUNCTION fGet-nom-prov RETURNS CHARACTER
  ( INPUT pCodProv AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR INIT ''.

FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND 
                        gn-prov.codpro = pCodProv NO-LOCK NO-ERROR.

IF AVAILABLE gn-prov THEN lRetVal = gn-prov.nompro.

RELEASE gn-prov.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

