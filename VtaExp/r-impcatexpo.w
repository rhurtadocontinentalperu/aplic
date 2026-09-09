&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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

DEFINE VARIABLE s-task-no   AS INT.
DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-clientes
    FIELDS codcli LIKE gn-clie.codcli.


DEFINE BUFFER b-report FOR w-report.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division fill-in-campana ~
txt-codpro BUTTON-1 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division fill-in-campana ~
txt-codpro txt-nompro txt-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 4" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE fill-in-campana AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Año de campaña" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.19 COL 11 COLON-ALIGNED WIDGET-ID 32
     fill-in-campana AT ROW 2.38 COL 16.14 COLON-ALIGNED WIDGET-ID 76
     txt-codpro AT ROW 3.54 COL 16.14 COLON-ALIGNED WIDGET-ID 12
     txt-nompro AT ROW 4.62 COL 11 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-1 AT ROW 5.69 COL 64 WIDGET-ID 2
     BUTTON-4 AT ROW 5.69 COL 73 WIDGET-ID 8
     txt-Mensaje AT ROW 6.5 COL 4 NO-LABEL WIDGET-ID 74
     "(Solo para proposito de titulo del reporte)" VIEW-AS TEXT
          SIZE 37 BY .62 AT ROW 2.58 COL 27 WIDGET-ID 78
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.86 BY 7.73 WIDGET-ID 100.


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
         TITLE              = "Imprime Catálogo Expolibreria"
         HEIGHT             = 7.73
         WIDTH              = 80.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80.86
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Imprime Catálogo Expolibreria */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Imprime Catálogo Expolibreria */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN txt-codpro COMBO-BOX-Division fill-in-campana.

    IF fill-in-campana < YEAR(TODAY) THEN DO:
        MESSAGE "Año de la campaña no debe ser menor al año actual" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    RUN Imprimir.
    DISPLAY "" @ txt-Mensaje WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
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


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division W-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* División */
DO:
  ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codpro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codpro W-Win
ON LEAVE OF txt-codpro IN FRAME F-Main /* Proveedor */
DO:
  
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = txt-codpro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN 
        DISPLAY gn-prov.nompro @ txt-nompro WITH FRAME {&FRAME-NAME}.
    ELSE DISPLAY "" @ txt-nompro WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iInt    AS INTEGER     NO-UNDO INIT 1.
    DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDesPag AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cImagen AS CHAR NO-UNDO.
    DEFINE VARIABLE cImagenConti AS CHAR NO-UNDO.
    DEFINE VARIABLE cImagenLogo AS CHAR NO-UNDO.

    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
        THEN LEAVE.
    END.

    cImagen = SEARCH("\test\" + TRIM(txt-codpro) + ".jpg").       
    IF cImagen = ?  THEN cImagen = SEARCH("\test\" + TRIM(txt-codpro) + ".bmp").
    IF cImagen = ?  THEN cImagen = SEARCH("d:\test\" + TRIM(txt-codpro) + ".JPG").
    IF cImagen = ?  THEN cImagen = SEARCH("c:\test\" + TRIM(txt-codpro) + ".bmp").
    /*
    cImagenLogo = SEARCH("\test\logo-evento.jpg").       
    IF cImagenLogo = ?  THEN cImagenLogo = SEARCH("\test\logo-evento.bmp").
    IF cImagenLogo = ?  THEN cImagenLogo = SEARCH("d:\test\logo-evento.jpg").
    IF cImagenLogo = ?  THEN cImagenLogo = SEARCH("c:\test\logo-evento.bmp").
    */
    cImagenLogo  = "\test\img" + combo-box-division + ".jpg".
    IF cImagenLogo = ?  THEN cImagenLogo = SEARCH("c:\test\no_logoeven.bmp").
  /*
    MESSAGE cImagenLogo SKIP
            cImagen.
*/
    /*
    cImagenConti = "c:\test\continental-sac.jpg".
    */
    
    /*
    IF cImagen = ?  THEN cImagen = "o:\on_in_co\test\" + TRIM(txt-codpro) + ".jpg".
    IF cImagen = ?  THEN cImagen = "o:\on_in_co\test\" + TRIM(txt-codpro) + ".bmp".
    IF cImagen = ?  THEN cImagen = "c:\sie\test\" + TRIM(txt-codpro) + ".jpg".
    IF cImagen = ?  THEN cImagen = "d:\sie\test\" + TRIM(txt-codpro) + ".jpg".
    */
    /*
    cImagen = SEARCH(".\test\" + TRIM(txt-codpro) + ".bmp").
    IF cImagen = ?  THEN cImagen = "o:\on_in_co\test\" + TRIM(txt-codpro) + ".bmp".
    */
    
    FOR EACH almcatvtac WHERE almcatvtac.codcia = s-codcia
        /*AND almcatvtac.coddiv = s-coddiv */
        AND almcatvtac.coddiv = COMBO-BOX-Division
        AND almcatvtac.codpro = txt-codpro NO-LOCK,
        EACH almcatvtad WHERE almcatvtad.codcia = s-codcia
            AND almcatvtad.coddiv = almcatvtac.coddiv
            AND almcatvtad.codpro = almcatvtac.codpro
            AND almcatvtad.nropag = almcatvtac.nropag NO-LOCK:

        FIND FIRST w-report WHERE task-no = s-task-no
            AND w-report.llave-c = tt-clientes.codcli
            AND w-report.Campo-C[1]= almcatvtac.codpro 
            AND w-report.Campo-C[2] = STRING(almcatvtac.nropag,"999")
            AND w-report.Campo-C[4] = STRING(almcatvtad.nrosec,"999") NO-LOCK NO-ERROR.
        IF NOT AVAIL w-report THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN cDesMar = almmmatg.desmar.
            ELSE cDesMar = ''.

            /*
            IF almcatvtac.codpro = '51135890' THEN cDesPag = almcatvtac.despag.
            ELSE cDesPag = ''.
            */
            cDesPag = almcatvtac.despag.

            /* Buscamos los archivos */
            /*
            cImagen = SEARCH(".\test\" + TRIM(txt-codpro) + "-" + STRING(almcatvtac.nropag,"99") + ".bmp").
            cImagen = "o:\on_in_co\test\" + TRIM(txt-codpro) + "-" + STRING(almcatvtac.nropag,"99") + ".bmp".
            cImagen = "o:\on_in_co\test\" + TRIM(txt-codpro) + ".bmp".

            cImagen = SEARCH(".\test\" + TRIM(txt-codpro) + ".JPG").
            */

            CREATE w-report.
            ASSIGN 
                task-no = s-task-no
                llave-c = '11111111111'
                w-report.Campo-C[1] = almcatvtac.codpro
                w-report.Campo-C[2] = AlmCatVtaD.Libre_C04  /*STRING(almcatvtac.nropag,"999")*/
                w-report.Campo-C[3] = STRING(almcatvtac.nropag,"999") /*cDesPag*/
                w-report.Campo-C[4] = STRING(almcatvtad.nrosec,"999")
                w-report.Campo-C[5] = almcatvtad.codmat
                w-report.Campo-C[6] = AlmCatVtaD.DesMat 
                w-report.Campo-C[7] = AlmCatVtaD.UndBas
                w-report.Campo-C[8] = cDesMar
                w-report.Campo-C[9] = AlmCatVtaD.Libre_C04 + " - " + AlmCatVtaD.Libre_C05
                w-report.Campo-C[10] = cNomCli
                /*w-report.Campo-C[11] = "o:\on_in_co\test\" + TRIM(txt-codpro) + "-" + STRING(almcatvtac.nropag,"99") + ".bmp"*/
                w-report.Campo-C[11] = cImagen  /*cImagen*/
                w-report.Campo-c[12] = cImagenConti
                w-report.Campo-c[13] = cImagenLogo
                w-report.Campo-F[1] = AlmCatVtaD.libre_d02   /*AlmCatVtaD.CanEmp */
                w-report.Campo-F[2] = AlmCatVtaD.libre_d03.  /*AlmCatVtaD.Libre_d05.*/
            DISPLAY "****  Carga Catalogo  ****" @ txt-Mensaje WITH FRAME {&FRAME-NAME}.
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
  DISPLAY COMBO-BOX-Division fill-in-campana txt-codpro txt-nompro txt-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Division fill-in-campana txt-codpro BUTTON-1 BUTTON-4 
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
    
    RUN Carga-Temporal.
    
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
        
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
    
    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    RB-REPORT-NAME = 'Imprime Catalogo Ventas v2'.
    /*RB-REPORT-NAME = 'xxx'.*/
    RB-INCLUDE-RECORDS = "O".
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    RB-OTHER-PARAMETERS = "pYearCampana = " + "NOTA DE PEDIDO DE CAMPAÑA " + STRING(fill-in-campana).

    
    /*RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.*/
    
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).

    
    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND GN-DIVI.VentaMayorista = 2
          BREAK BY gn-divi.codcia:
          COMBO-BOX-Division:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
/*           IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Division = gn-divi.coddiv. */
      END.
      COMBO-BOX-Division = s-coddiv.
      
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-in-campana:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),"9999").

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
    DEFINE VAR OUTPUT-var-1 AS ROWID.


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
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    DEFINE VAR OUTPUT-var-1 AS ROWID.


    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
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

