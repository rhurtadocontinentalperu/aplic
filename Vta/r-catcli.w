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
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

&SCOPED-DEFINE CONDICX ( TRUE ) 
&SCOPED-DEFINE CONDICY ( gn-clie.CodDept = "15" )   
&SCOPED-DEFINE CONDICION ( gn-clie.CodDept <> "15" )


/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-48 RECT-72 cb-divi F-DEPTO F-CATE ~
F-PROVI F-GIRO F-DISTRITO r-sortea BUTTON-5 BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS cb-divi F-DEPTO D-DEPTO F-CATE F-PROVI ~
D-PROVI F-GIRO D-GIRO F-DISTRITO D-DISTR r-sortea txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE cb-divi AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE D-DEPTO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .81 NO-UNDO.

DEFINE VARIABLE D-DISTR AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .81 NO-UNDO.

DEFINE VARIABLE D-GIRO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .81 NO-UNDO.

DEFINE VARIABLE D-PROVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-CATE AS CHARACTER FORMAT "X(1)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE F-DEPTO AS CHARACTER FORMAT "X(3)":U 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-DISTRITO AS CHARACTER FORMAT "X(3)":U 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-GIRO AS CHARACTER FORMAT "X(4)":U 
     LABEL "Giro" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE F-PROVI AS CHARACTER FORMAT "X(3)":U 
     LABEL "Provincia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Nombre", 2
     SIZE 24.29 BY .77
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 7.08.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-divi AT ROW 1.88 COL 11 COLON-ALIGNED WIDGET-ID 144
     F-DEPTO AT ROW 2.96 COL 2.71 WIDGET-ID 126
     D-DEPTO AT ROW 2.96 COL 16.43 COLON-ALIGNED NO-LABEL WIDGET-ID 116
     F-CATE AT ROW 3.96 COL 50.29 COLON-ALIGNED WIDGET-ID 124
     F-PROVI AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 132
     D-PROVI AT ROW 4 COL 16.29 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     F-GIRO AT ROW 5.04 COL 50.14 COLON-ALIGNED WIDGET-ID 130
     D-GIRO AT ROW 5.04 COL 56.57 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     F-DISTRITO AT ROW 5.12 COL 11.14 COLON-ALIGNED WIDGET-ID 128
     D-DISTR AT ROW 5.12 COL 16.43 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     r-sortea AT ROW 6.12 COL 25.57 NO-LABEL WIDGET-ID 136
     txt-msj AT ROW 7.19 COL 3 NO-LABEL WIDGET-ID 90
     BUTTON-5 AT ROW 8.54 COL 33.72 WIDGET-ID 142
     BUTTON-3 AT ROW 8.54 COL 49 WIDGET-ID 92
     BUTTON-4 AT ROW 8.54 COL 64 WIDGET-ID 94
     "Ordenado x" VIEW-AS TEXT
          SIZE 10 BY .69 AT ROW 6.15 COL 13 WIDGET-ID 140
          FONT 6
     RECT-48 AT ROW 1.27 COL 2 WIDGET-ID 80
     RECT-72 AT ROW 8.35 COL 2 WIDGET-ID 98
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.29 BY 9.88
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Catalogo de Clientes"
         HEIGHT             = 9.88
         WIDTH              = 80.29
         MAX-HEIGHT         = 9.88
         MAX-WIDTH          = 80.29
         VIRTUAL-HEIGHT     = 9.88
         VIRTUAL-WIDTH      = 80.29
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
/* SETTINGS FOR FILL-IN D-DEPTO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-DISTR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-GIRO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-PROVI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DEPTO IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       RECT-48:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Catalogo de Clientes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Clientes */
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
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN r-sortea f-depto f-distrito f-provi f-giro f-cate.
    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN r-sortea f-depto f-distrito f-provi f-giro f-cate cb-divi.
    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    CASE R-SORTEA :
        WHEN 1 THEN RUN Excel_gen.
        WHEN 2 THEN RUN Excel_ge1.     
    END CASE. 
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CATE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CATE W-Win
ON LEAVE OF F-CATE IN FRAME F-Main /* Categoria */
DO:
    IF F-cate:screen-value <> "" THEN DO:
     FIND clfclie WHERE clfclie.categoria = F-CATE:screen-value NO-LOCK NO-ERROR.
     IF NOT AVAILABLE clfclie THEN DO:
       MESSAGE "Categoria No Existe ..., Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       F-cate:screen-value = "".
       ASSIGN F-cate.
       APPLY "ENTRY" TO F-CATE.
     END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DEPTO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DEPTO W-Win
ON LEAVE OF F-DEPTO IN FRAME F-Main /* Departamento */
DO:
    IF F-DEPTO:screen-value <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = F-DEPTO:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN
       D-DEPTO:screen-value = TabDepto.NomDepto.
    ELSE 
       D-DEPTO:screen-value = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DISTRITO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DISTRITO W-Win
ON LEAVE OF F-DISTRITO IN FRAME F-Main /* Distrito */
DO:
  IF F-DISTRITO:screen-value <> "" THEN DO:
  FIND Tabdistr WHERE Tabdistr.CodDepto = F-DEPTO:screen-value AND
                      Tabdistr.Codprovi = F-PROVI:screen-value AND
                      Tabdistr.Coddistr = F-DISTRITO:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN 
        D-DISTR:screen-value = Tabdistr.Nomdistr .
    ELSE
        D-DISTR:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-GIRO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-GIRO W-Win
ON LEAVE OF F-GIRO IN FRAME F-Main /* Giro */
DO:
    IF F-GIRO:screen-value <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = F-GIRO:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        D-Giro:screen-value = almtabla.nombre.
     ELSE 
        D-Giro:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PROVI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PROVI W-Win
ON LEAVE OF F-PROVI IN FRAME F-Main /* Provincia */
DO:
    IF F-PROVI:screen-value <> "" THEN DO:
    FIND  Tabprovi WHERE Tabprovi.CodDepto = F-DEPTO:screen-value AND
    Tabprovi.Codprovi = F-PROVI:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN 
        D-PROVI:screen-value = Tabprovi.Nomprovi.
    ELSE
        D-PROVI:screen-value = "".
   
   END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatGe1 W-Win 
PROCEDURE CatGe1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab
        gn-clie.ruc        AT 1   FORMAT "X(11)"
        gn-clie.clfcli     AT 13  FORMAT "X(1)"
        gn-clie.nomcli     AT 15  FORMAT "X(40)"
        gn-clie.Dircli     AT 56  FORMAT "X(50)"
        D-Distrito         AT 107  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 123 FORMAT "X(13)"
        gn-clie.faxcli     AT 137 FORMAT "X(10)"
        /*gn-clie.E-mail     AT 128 FORMAT "X(20)"*/
        HEADER
        S-NOMCIA  FORMAT "X(45)"
        "Pag.  : " AT 105 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODDIV + " )"  AT 3 FORMAT "X(20)"
        T-TITULO  AT 54 FORMAT "X(45)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999")  FORMAT "X(12)" SKIP
        "Hora  : " AT 105 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.          CL       C L I E N T E                 DIRECCION                                           DISTRITO        TELEFONO      F A X   " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 260 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 


 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND gn-clie.GirCli  BEGINS F-GIRO
                  AND gn-clie.CodDept BEGINS F-DEPTO 
                  AND gn-clie.CodProv BEGINS F-PROVI
                  AND gn-clie.CodDist BEGINS F-DISTRITO
          BY gn-clie.nomcli:

     IF F-CATE <> "" AND Gn-clie.clfcli <> F-CATE THEN NEXT. 

     /*{&NEW-PAGE}.   */        

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                         AND Tabdistr.Codprovi =gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.clfcli
        gn-clie.nomcli
        gn-clie.Dircli
        D-Distrito
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        /*gn-clie.E-mail*/
        WITH FRAME F-Cab.
        
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatGen W-Win 
PROCEDURE CatGen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab
        gn-clie.ruc        AT 1   FORMAT "X(11)"
        gn-clie.clfcli     AT 13  FORMAT "X(1)"
        gn-clie.nomcli     AT 15  FORMAT "X(40)"
        gn-clie.Dircli     AT 56  FORMAT "X(60)"
        D-Distrito         AT 117  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 133 FORMAT "X(13)"
        gn-clie.faxcli     AT 147 FORMAT "X(10)"
        /*gn-clie.E-mail     AT 128 FORMAT "X(20)"*/
        HEADER
        S-NOMCIA FORMAT "X(45)"
        "Pag.  : " AT 105 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODDIV + " )" AT 3 FORMAT "X(20)"
        T-TITULO AT 54 FORMAT "X(45)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 105 STRING(TIME,"HH:MM:SS") SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.          CL       C L I E N T E                 DIRECCION                                                     DISTRITO        TELEFONO      F A X    " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 260 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 
 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND gn-clie.GirCli  BEGINS F-GIRO
                  AND gn-clie.CodDept BEGINS F-DEPTO 
                  AND gn-clie.CodProv BEGINS F-PROVI
                  AND gn-clie.CodDist BEGINS F-DISTRITO
          BY gn-clie.ruc:

     IF F-CATE <> "" AND Gn-clie.clfcli <> F-CATE THEN NEXT. 

     /*{&NEW-PAGE}.           */

     FIND Tabdistr WHERE Tabdistr.CodDepto     = gn-clie.CodDept
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.clfcli
        gn-clie.nomcli
        gn-clie.Dircli
        D-Distrito
        gn-clie.Telfnos[1]
        gn-clie.faxcli
/*        gn-clie.E-mail*/
        WITH FRAME F-Cab.
        
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
  DISPLAY cb-divi F-DEPTO D-DEPTO F-CATE F-PROVI D-PROVI F-GIRO D-GIRO 
          F-DISTRITO D-DISTR r-sortea txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-48 RECT-72 cb-divi F-DEPTO F-CATE F-PROVI F-GIRO F-DISTRITO 
         r-sortea BUTTON-5 BUTTON-3 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_ge1 W-Win 
PROCEDURE Excel_ge1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.


DEFINE VARIABLE d-distrito AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-provi    AS CHARACTER   NO-UNDO.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Cabecera*/

cColumn = STRING(t-Column).                                           
chWorkSheet:Range("D2"):Value = 'CATALOGO DE CLIENTES'. 

/*Cabecera de Listado*/
cColumn = STRING(t-Column).
chWorkSheet:Range("A3"):Value = "RUC".
chWorkSheet:Range("B3"):Value = "CL".
chWorkSheet:Range("C3"):Value = "CLIENTE".
chWorkSheet:Range("D3"):Value = "DIRECCION".
chWorkSheet:Range("E3"):Value = "DISTRITO".
chWorkSheet:Range("F3"):Value = "PROVINCIA".
chWorkSheet:Range("G3"):Value = "TELEFONO".
chWorkSheet:Range("H3"):Value = "FAX".

t-column = 3.
FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND (gn-clie.coddiv  BEGINS cb-divi
         OR cb-divi = 'Todos')
    AND gn-clie.GirCli  BEGINS F-GIRO
    AND gn-clie.CodDept BEGINS F-DEPTO 
    AND gn-clie.CodProv BEGINS F-PROVI
    AND gn-clie.CodDist BEGINS F-DISTRITO
        BY gn-clie.nomcli:

    IF F-CATE <> "" AND Gn-clie.clfcli <> F-CATE THEN NEXT. 

    FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAIL TabDepto THEN d-provi = TabDepto.NomDepto .
    ELSE d-provi = ''.
    
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
        AND Tabdistr.Codprovi =gn-clie.codprov
        AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr .
    ELSE D-Distrito = "".     
    t-column = t-column + 1.                                                                                  
    cColumn = STRING(t-Column).                                           
    cRange = "A" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.ruc. 
    cRange = "B" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.clfcli.                                                                  
    cRange = "C" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.             
    cRange = "D" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.Dircli.             
    cRange = "E" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = D-Distrito.             
    cRange = "F" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = d-provi.             
    cRange = "G" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.Telfnos[1].             
    cRange = "H" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.faxcli.

    PAUSE 0.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_gen W-Win 
PROCEDURE Excel_gen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.


DEFINE VARIABLE d-distrito AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-PROVI    AS CHARACTER   NO-UNDO.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Cabecera*/

cColumn = STRING(t-Column).                                           
chWorkSheet:Range("D2"):Value = 'CATALOGO DE CLIENTES'. 

/*Cabecera de Listado*/
cColumn = STRING(t-Column).
chWorkSheet:Range("A3"):Value = "RUC".
chWorkSheet:Range("B3"):Value = "CL".
chWorkSheet:Range("C3"):Value = "CLIENTE".
chWorkSheet:Range("D3"):Value = "DIRECCION".
chWorkSheet:Range("E3"):Value = "DISTRITO".
chWorkSheet:Range("F3"):Value = "PROVINCIA".
chWorkSheet:Range("G3"):Value = "TELEFONO".
chWorkSheet:Range("H3"):Value = "FAX".

t-column = 3.
FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND (gn-clie.coddiv BEGINS cb-divi
         OR cb-divi = 'Todos')
    AND gn-clie.GirCli  BEGINS F-GIRO
    AND gn-clie.CodDept BEGINS F-DEPTO 
    AND gn-clie.CodProv BEGINS F-PROVI
    AND gn-clie.CodDist BEGINS F-DISTRITO
        BY gn-clie.ruc:

    IF F-CATE <> "" AND Gn-clie.clfcli <> F-CATE THEN NEXT. 
    
    FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAIL TabDepto THEN d-provi = TabDepto.NomDepto .
    ELSE d-provi = ''.

    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
        AND Tabdistr.Codprovi =gn-clie.codprov
        AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr .
    ELSE D-Distrito = "".     

    t-column = t-column + 1.                                                                                  
    cColumn = STRING(t-Column).                                           
    cRange = "A" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.ruc. 
    cRange = "B" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.clfcli.                                                                  
    cRange = "C" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.             
    cRange = "D" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.Dircli.             
    cRange = "E" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = D-Distrito.             
    cRange = "F" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = D-Provi.             
    cRange = "G" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.Telfnos[1].             
    cRange = "H" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = gn-clie.faxcli.

    PAUSE 0.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.
   
    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".    

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.    
        CASE R-SORTEA :
            WHEN 1 THEN DO:    
                T-TITULO = "  CATALOGO GENERAL DE CLIENTES Por R.U.C. ".         
                RUN CatGen.
            END.  
            WHEN 2 THEN DO:    
                T-TITULO = "  CATALOGO GENERAL DE CLIENTES Por Nombre ".         
                RUN CatGe1.                 
            END.         
        END CASE. 
        PAGE STREAM REPORT.
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
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          cb-divi:ADD-LAST(gn-divi.coddiv).          
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
    DO with frame {&FRAME-NAME} :        
    CASE HANDLE-CAMPO:name:
         WHEN "F-GIRO"  THEN ASSIGN input-var-1 = "GN".
         WHEN "F-PROVI" THEN ASSIGN input-var-1 = F-DEPTO:screen-value.
         WHEN "F-DISTRITO" THEN DO:
               input-var-1 = F-DEPTO:screen-value.
               input-var-2 = F-PROVI:screen-value.
          END.


    END CASE.
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

