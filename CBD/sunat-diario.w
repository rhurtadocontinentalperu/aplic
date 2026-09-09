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

/* Local Variable Definitions ---                                       */

    DEFINE STREAM report.
    DEFINE BUFFER B-Cuentas FOR cb-ctas.
    DEFINE TEMP-TABLE t-w-report LIKE w-report.

    /* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
    DEFINE VARIABLE l-immediate-display AS LOGICAL NO-UNDO.
    DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(150)" NO-UNDO.

    DEFINE        SHARED VARIABLE s-user-id  LIKE _user._userid.
    DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
    DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
    DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
    DEFINE        VARIABLE x-con-reg    AS INTEGER NO-UNDO.
    DEFINE        VARIABLE x-smon       AS CHARACTER FORMAT "X(3)".

    DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO .


    /*VARIABLES PARTICULARES DE LA RUTINA */
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                    LABEL "Debe      ".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                    LABEL "Haber     ".
    DEFINE VARIABLE x-totdebe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
    DEFINE VARIABLE x-tothabe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
    DEFINE VARIABLE x-codope   LIKE cb-cmov.Codope.
    DEFINE VARIABLE x-nom-ope  LIKE cb-oper.nomope.
    DEFINE VARIABLE x-nroast   LIKE cb-cmov.Nroast.
    DEFINE VARIABLE x-fecha    LIKE cb-cmov.fchast.
    DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc.

    DEFINE SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 10.
    DEFINE SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
    DEFINE SHARED VARIABLE s-codcia AS INTEGER INITIAL 4.
    DEFINE SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".

    DEF SHARED VAR cb-codcia AS INT.
    DEF SHARED VAR cl-codcia AS INT.
    DEF SHARED VAR pv-codcia AS INT.


    def var t-d as decimal init 0.
    def var t-h as decimal init 0.

    DEF VAR s-task-no AS INT.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Mes-1 x-codmon COMBO-BOX-Mes-2 ~
BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Mes-1 x-codmon COMBO-BOX-Mes-2 ~
f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.73.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 12 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 9 BY 1.35 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Mes-1 AT ROW 1.19 COL 42 COLON-ALIGNED WIDGET-ID 48
     x-codmon AT ROW 1.38 COL 13 NO-LABEL WIDGET-ID 34
     COMBO-BOX-Mes-2 AT ROW 2.15 COL 42 COLON-ALIGNED WIDGET-ID 50
     BUTTON-1 AT ROW 3.69 COL 4 WIDGET-ID 46
     BtnDone AT ROW 3.69 COL 16 WIDGET-ID 56
     f-Mensaje AT ROW 4.46 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .65 AT ROW 1.38 COL 4 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.86 BY 5.46 WIDGET-ID 100.


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
         TITLE              = "Libro Diario Analítico (detallado)"
         HEIGHT             = 5.46
         WIDTH              = 72.86
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 164.57
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
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Libro Diario Analítico (detallado) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Libro Diario Analítico (detallado) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN 
        x-codmon
        COMBO-BOX-Mes-1 
        COMBO-BOX-Mes-2.

    RUN Texto.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Orden AS INT INIT 1.

ASSIGN
    t-d = 0
    t-h = 0
    x-totdebe = 0
    x-tothabe = 0.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST t-w-report WHERE t-w-report.task-no = s-task-no 
                    AND t-w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
END.

FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
    AND cb-cmov.periodo = s-periodo           
    AND cb-cmov.nromes  >= COMBO-BOX-Mes-1
    AND cb-cmov.nromes  <= COMBO-BOX-Mes-2:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "Mes: " + STRING(cb-cmov.nromes, '99') +
        " Libro: " + cb-cmov.codope + " Asiento: " + cb-cmov.nroast.
    FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND 
        cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
    ASSIGN
        x-codope = cb-oper.codope
        x-nom-ope = cb-oper.nomope.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
        AND cb-dmov.periodo = cb-cmov.periodo
        AND cb-dmov.nromes  = cb-cmov.nromes
        AND cb-dmov.codope  = cb-cmov.codope  
        AND cb-dmov.nroast  = cb-cmov.nroast  
        BREAK BY (cb-dmov.nroast):
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN RUN p-nom-aux.
        IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
        /* limpiamos la glosa */
/*         x-glodoc = REPLACE(x-glodoc, CHR(13), " " ). */
/*         x-glodoc = REPLACE(x-glodoc, CHR(10), " " ). */
/*         x-glodoc = REPLACE(x-glodoc, CHR(12), " " ). */
        DEF VAR pGloDoc AS CHAR.
        RUN lib/limpiar-texto (x-glodoc," ",OUTPUT pGloDoc).
        x-GloDoc = pGloDoc.
        x-GloDoc = REPLACE(x-GloDoc, '?', ' ').
        /* ****************** */
        IF NOT tpomov THEN 
            CASE x-codmon:
                WHEN 1 THEN DO:
                    x-debe  = ImpMn1.
                    x-haber = 0.
                END.
                WHEN 2 THEN DO:
                    x-debe  = ImpMn2.
                    x-haber = 0.
                END.
                WHEN 3 THEN DO:
                    x-debe  = ImpMn3.
                    x-haber = 0.
                END.
            END CASE.
        ELSE 
            CASE x-codmon:
                WHEN 1 THEN DO:
                    x-debe  = 0.
                    x-haber = ImpMn1.
                END.
                WHEN 2 THEN DO:
                    x-debe  = 0.
                    x-haber = ImpMn2.
                END.
                WHEN 3 THEN DO:
                    x-debe  = 0.
                    x-haber = ImpMn3.
                END.
           END CASE.            
            
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
            x-totdebe = x-totdebe + x-debe.
            x-tothabe = x-tothabe + x-haber.
            t-d       = t-d       + x-debe.
            t-h       = t-h       + x-haber.
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0) THEN DO:
                x-glodoc = SUBSTRING(x-glodoc,1,11).
                IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
            END.
            CREATE t-w-report.
            ASSIGN
                t-w-report.task-no = s-task-no
                t-w-report.llave-c = s-user-id
                t-w-report.llave-i = s-codcia
                t-w-report.campo-c[1] = cb-cmov.codope
                t-w-report.campo-d[1] = cb-cmov.fchast
                t-w-report.campo-c[2] = cb-cmov.nroast
                t-w-report.campo-d[2] = cb-dmov.fchdoc
                t-w-report.campo-c[3] = cb-dmov.coddoc
                t-w-report.campo-c[4] = cb-dmov.nrodoc
                t-w-report.campo-d[3] = cb-dmov.fchvto
                t-w-report.campo-c[5] = cb-dmov.clfaux
                t-w-report.campo-c[6] = cb-dmov.codaux
                t-w-report.campo-c[7] = cb-dmov.cco
                t-w-report.campo-c[8] = cb-dmov.coddiv
                t-w-report.campo-c[9] = cb-dmov.codcta
                t-w-report.campo-c[10] = x-glodoc
                t-w-report.campo-f[1] = x-debe
                t-w-report.campo-f[2] = x-haber
                t-w-report.campo-c[20] = x-nom-ope
                t-w-report.campo-i[1] = x-orden
                t-w-report.campo-i[2] = cb-cmov.nromes.
            x-con-reg = x-con-reg + 1.
            x-orden = x-orden + 1.
        END.    
    END.  /* FIN DEL FOR EACH cb-dmov */
    IF cb-cmov.flgest = "A" THEN DO:
        CREATE t-w-report.
        ASSIGN
            t-w-report.task-no = s-task-no
            t-w-report.llave-c = s-user-id
            t-w-report.campo-c[1] = cb-cmov.codope
            t-w-report.campo-d[1] = cb-cmov.fchast
            t-w-report.campo-c[2] = cb-cmov.nroast
            t-w-report.campo-c[10] = "******* A N U L A D O *******"
            t-w-report.campo-c[20] = x-nom-ope
            t-w-report.campo-i[1] = x-orden
            t-w-report.campo-i[2] = cb-cmov.nromes.
        x-orden = x-orden + 1.
    END.      
    IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN DO:
        CREATE t-w-report.
        ASSIGN
            t-w-report.task-no = s-task-no
            t-w-report.llave-c = s-user-id
            t-w-report.campo-c[1] = cb-cmov.codope
            t-w-report.campo-d[1] = cb-cmov.fchast
            t-w-report.campo-c[2] = cb-cmov.nroast
            t-w-report.campo-c[10] = cb-cmov.notast
            t-w-report.campo-c[20] = x-nom-ope
            t-w-report.campo-i[1] = x-orden
            t-w-report.campo-i[2] = cb-cmov.nromes.
        x-orden = x-orden + 1.
    END.    
    x-con-reg = 0.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY COMBO-BOX-Mes-1 x-codmon COMBO-BOX-Mes-2 f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Mes-1 x-codmon COMBO-BOX-Mes-2 BUTTON-1 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-nom-aux W-Win 
PROCEDURE p-nom-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


                CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                    AND gn-clie.CodCia = cl-codcia
                                 NO-LOCK NO-ERROR. 
                    IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                    AND gn-prov.CodCia = pv-codcia
                                NO-LOCK NO-ERROR.                      
                    IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                                    AND cb-ctas.CodCia = cb-codcia
                                NO-LOCK NO-ERROR.                      
                   IF AVAILABLE cb-ctas THEN 
                        x-glodoc = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                    AND cb-auxi.codaux = cb-dmov.codaux
                                    AND cb-auxi.CodCia = cb-codcia
                                NO-LOCK NO-ERROR.                      
                    IF AVAILABLE cb-auxi THEN 
                        x-glodoc = cb-auxi.nomaux.
                END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Rpta    AS LOG  NO-UNDO.

x-Archivo = 'Diario.txt'.

SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Texto' '*.txt'
  ASK-OVERWRITE
  CREATE-TEST-FILE
  DEFAULT-EXTENSION '.txt'
  RETURN-TO-START-DIR 
  USE-FILENAME
  SAVE-AS
  UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.


RUN Carga-Temporal.
FIND FIRST t-w-report WHERE t-w-report.task-no = s-task-no 
    AND t-w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-w-report THEN DO:
    MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

OUTPUT STREAM REPORT TO VALUE(x-Archivo).
PUT STREAM REPORT UNFORMATTED
    "DMES|DNUMASIOPE|DNUMCTACON|DFECOPE|DGLOSA|DCCO|DDEBE|DHABER"
    SKIP.
FOR EACH t-w-report NO-LOCK WHERE t-w-report.task-no = s-task-no
    AND t-w-report.Llave-C = s-user-id
    BY t-w-report.Campo-i[1] BY t-w-report.Campo-c[1] BY t-w-report.Campo-c[2]:
    PUT STREAM REPORT 
        t-w-report.campo-i[2] FORMAT "99"     '|'
        t-w-report.campo-c[1] FORMAT "x(3)"
        t-w-report.campo-c[2] FORMAT 'X(6)'   '|'
        t-w-report.campo-c[9] FORMAT 'X(8)'   '|'
        t-w-report.campo-d[1] FORMAT "99/99/9999" '|'
        t-w-report.campo-c[10] FORMAT 'x(50)' '|'
        t-w-report.campo-c[7] FORMAT 'x(8)' '|'
        t-w-report.campo-f[1] FORMAT '->>>>>>>>>>>9.99' '|'
        t-w-report.campo-f[2] FORMAT '->>>>>>>>>>>9.99' '|'
        SKIP.
END.
OUTPUT STREAM REPORT CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

