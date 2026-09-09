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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo AS CHAR NO-UNDO.
DEFINE VARIABLE x-mes     AS integer NO-UNDO.
DEFINE VARIABLE x-valcal AS DECIMAL NO-UNDO.
DEFINE  VAr I AS INTEGER.
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


RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = ''
THEN DO:
    MESSAGE 'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE TEMP-TABLE tempo 
    FIELD t-codcia  LIKE pl-mov-mes.codcia
    FIELD t-codper  LIKE pl-pers.codper     FORMAT "X(6)"
    FIELD t-desafp  LIKE Pl-afps.desafp
    FIELD t-codafp  LIKE pl-flg-mes.codafp    
    FIELD t-nroafp  LIKE pl-flg-mes.nroafp  FORMAT "X(15)"
    FIELD t-patper  LIKE pl-pers.patper     FORMAT "X(20)"
    FIELD t-matper  LIKE pl-pers.matper     FORMAT "X(20)"
    FIELD t-nomper  LIKE pl-pers.nomper     FORMAT "X(30)"
    FIELD t-vcontr  LIKE pl-flg-mes.vcontr  FORMAT "99/99/9999"
    FIELD t-codmov  LIKE pl-mov-mes.codmov  FORMAT 999
    FIELD valcal AS DECI EXTENT 13          
    INDEX llave01 as primary t-codcia t-codafp t-codper.

DEFINE TEMP-TABLE tempoo
    FIELD t-codciaa  LIKE pl-mov-SEM.codcia
    FIELD t-codpera  LIKE pl-pers.codper
    FIELD t-desafp  LIKE Pl-afps.desafp
    FIELD t-codafpa  LIKE pl-flg-SEM.codafp    
    FIELD t-nroafpa  LIKE pl-flg-SEM.nroafp 
    FIELD t-patper  LIKE pl-pers.patper
    FIELD t-matper  LIKE pl-pers.matper
    FIELD t-nomper  LIKE pl-pers.nomper   
    FIELD t-vcontra  LIKE pl-flg-SEM.vcontr     
    FIELD valcala AS DECI EXTENT 13       
    INDEX llave01 as primary t-codciaa t-codafpa t-codpera.

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
&Scoped-Define ENABLED-OBJECTS r-afp BUTTON-1 COMBO-Periodo COMBO-mes1 ~
BUTTON-2 COMBO-mes2 
&Scoped-Define DISPLAYED-OBJECTS r-afp COMBO-Periodo COMBO-mes1 COMBO-mes2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Aceptar" 
     SIZE 13 BY 1.46.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 13 BY 1.46.

DEFINE VARIABLE COMBO-mes1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-mes2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE r-afp AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Horizonte", 1,
"Profuturo", 2,
"Integra", 3,
"Union Vida", 4,
"Prima", 5
     SIZE 12 BY 3.54 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r-afp AT ROW 1.77 COL 4 NO-LABEL
     BUTTON-1 AT ROW 1.81 COL 44
     COMBO-Periodo AT ROW 1.96 COL 27 COLON-ALIGNED
     COMBO-mes1 AT ROW 2.92 COL 27 COLON-ALIGNED
     BUTTON-2 AT ROW 3.69 COL 44
     COMBO-mes2 AT ROW 3.88 COL 27 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 5.15
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
         TITLE              = "Liquidación Anual de Aportes"
         HEIGHT             = 5.15
         WIDTH              = 60.14
         MAX-HEIGHT         = 5.15
         MAX-WIDTH          = 60.14
         VIRTUAL-HEIGHT     = 5.15
         VIRTUAL-WIDTH      = 60.14
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
ON END-ERROR OF W-Win /* Liquidación Anual de Aportes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Liquidación Anual de Aportes */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN COMBO-Periodo COMBO-Mes1 COMBO-Mes2 r-afp.
  RUN Imprimir2.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH tempo:
    DELETE tempo.
  END.


do x-mes = combo-mes1 to combo-mes2:
    
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia  = s-codcia AND 
                                  PL-MOV-MES.periodo = COMBO-Periodo AND 
                                  PL-MOV-MES.nromes  = x-mes AND
                                  PL-MOV-MES.codpln  = 1 AND 
                                  (PL-MOV-MES.codcal  = 001 OR PL-MOV-MES.codcal  = 003
                                   OR PL-MOV-MES.codcal = 004 OR PL-MOV-MES.codcal = 005
                                   OR PL-MOV-MES.codcal = 008) AND
                                 (PL-MOV-MES.codmov  = 221 OR
                                  PL-MOV-MES.codmov  = 222 OR
                                  PL-MOV-MES.codmov  = 225),
                                  

        first pl-flg-mes of pl-mov-mes no-lock,
            first pl-pers of pl-flg-mes no-lock,
                first pl-afps of pl-flg-mes where pl-afps.desafp = 'horizonte' no-lock:
                   find tempo where t-codcia = s-codcia and
                                    t-codafp = pl-flg-mes.codafp and
                                    t-codper = pl-pers.codper exclusive-lock no-error.
        
        DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Codigo del Personal"
                          FORMAT "X(11)" 
                          WITH FRAME F-Proceso. 
                                                  
        if not available tempo then create tempo.
        assign 
                tempo.t-codcia                  = s-codcia
                tempo.t-codper                  = pl-pers.codper
                tempo.t-codafp                  = pl-flg-mes.codafp
                tempo.t-nroafp                  = pl-flg-mes.nroafp
                tempo.t-desafp                  = pl-afps.desafp
                tempo.t-patper                  = pl-pers.patper
                tempo.t-matper                  = pl-pers.matper
                tempo.t-nomper                  = pl-pers.nomper
                tempo.valcal[x-mes] = tempo.valcal[x-mes] + PL-MOV-MES.valcal-mes
                tempo.valcal[13] = tempo.valcal[1] + tempo.valcal[2] + tempo.valcal[3] + tempo.valcal[4] + 
                                   tempo.valcal[5] + tempo.valcal[6] + tempo.valcal[7] + tempo.valcal[8] +
                                   tempo.valcal[9] + tempo.valcal[10] + tempo.valcal[11] + tempo.valcal[12]
                tempo.t-vcontr                  = pl-flg-mes.vcontr.                                          
 
    end.
end.   

HIDE FRAME F-PROCESO. 
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal1 W-Win 
PROCEDURE carga-temporal1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH tempo:
    DELETE tempo.
  END.


    do x-mes = combo-mes1 to combo-mes2:
    
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia  = s-codcia AND 
                                  PL-MOV-MES.periodo = COMBO-Periodo AND 
                                  PL-MOV-MES.nromes  = x-mes AND
                                  PL-MOV-MES.codpln  = 1 AND 
        (PL-MOV-MES.codcal  = 001 OR PL-MOV-MES.codcal  = 003
         OR PL-MOV-MES.codcal = 004 OR PL-MOV-MES.codcal = 005
         OR PL-MOV-MES.codcal = 008) AND
                                 (PL-MOV-MES.codmov  = 221 OR
                                  PL-MOV-MES.codmov  = 222 OR
                                  PL-MOV-MES.codmov  = 225),
                                  

first pl-flg-mes of pl-mov-mes no-lock,
    first pl-pers of pl-flg-mes no-lock,
        first pl-afps of pl-flg-mes where pl-afps.desafp = 'Profuturo' no-lock:
           find tempo where t-codcia = s-codcia and
                         t-codafp = pl-flg-mes.codafp and
                         t-codper = pl-pers.codper exclusive-lock no-error.

DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Codigo del Personal"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso. 
                                          
if not available tempo then create tempo.
assign 
        tempo.t-codcia                  = s-codcia
        tempo.t-codper                  = pl-pers.codper
        tempo.t-codafp                  = pl-flg-mes.codafp
        tempo.t-nroafp                  = pl-flg-mes.nroafp
        tempo.t-desafp                  = pl-afps.desafp
        tempo.t-patper                  = pl-pers.patper
        tempo.t-matper                  = pl-pers.matper
        tempo.t-nomper                  = pl-pers.nomper
        tempo.valcal[x-mes] = tempo.valcal[x-mes] + PL-MOV-MES.valcal-mes
        tempo.valcal[13] = tempo.valcal[1] + tempo.valcal[2] + tempo.valcal[3] + tempo.valcal[4] + 
                           tempo.valcal[5] + tempo.valcal[6] + tempo.valcal[7] + tempo.valcal[8] +
                           tempo.valcal[9] + tempo.valcal[10] + tempo.valcal[11] + tempo.valcal[12]
        tempo.t-vcontr                  = pl-flg-mes.vcontr.                                          
 
end.
end.   

HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal2 W-Win 
PROCEDURE carga-temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tempo:
    DELETE tempo.
  END.


    do x-mes = combo-mes1 to combo-mes2:
    
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia  = s-codcia AND 
                                  PL-MOV-MES.periodo = COMBO-Periodo AND 
                                  PL-MOV-MES.nromes  = x-mes AND
                                  PL-MOV-MES.codpln  = 1 AND 
        (PL-MOV-MES.codcal  = 001 OR PL-MOV-MES.codcal  = 003
         OR PL-MOV-MES.codcal = 004 OR PL-MOV-MES.codcal = 005
         OR PL-MOV-MES.codcal = 008) AND
                                 (PL-MOV-MES.codmov  = 221 OR
                                  PL-MOV-MES.codmov  = 222 OR
                                  PL-MOV-MES.codmov  = 225),
                                  

first pl-flg-mes of pl-mov-mes no-lock,
    first pl-pers of pl-flg-mes no-lock,
        first pl-afps of pl-flg-mes where pl-afps.desafp = 'integra' no-lock:
           find tempo where t-codcia = s-codcia and
                         t-codafp = pl-flg-mes.codafp and
                         t-codper = pl-pers.codper exclusive-lock no-error.

DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Codigo del Personal"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso. 
                                          
if not available tempo then create tempo.
assign 
        tempo.t-codcia                  = s-codcia
        tempo.t-codper                  = pl-pers.codper
        tempo.t-codafp                  = pl-flg-mes.codafp
        tempo.t-nroafp                  = pl-flg-mes.nroafp
        tempo.t-desafp                  = pl-afps.desafp
        tempo.t-patper                  = pl-pers.patper
        tempo.t-matper                  = pl-pers.matper
        tempo.t-nomper                  = pl-pers.nomper
        tempo.valcal[x-mes] = tempo.valcal[x-mes] + PL-MOV-MES.valcal-mes
        tempo.valcal[13] = tempo.valcal[1] + tempo.valcal[2] + tempo.valcal[3] + tempo.valcal[4] + 
                           tempo.valcal[5] + tempo.valcal[6] + tempo.valcal[7] + tempo.valcal[8] +
                           tempo.valcal[9] + tempo.valcal[10] + tempo.valcal[11] + tempo.valcal[12]
        tempo.t-vcontr                  = pl-flg-mes.vcontr.                                          
 
end.
end.   

HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal3 W-Win 
PROCEDURE carga-temporal3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tempo:
    DELETE tempo.
  END.


    do x-mes = combo-mes1 to combo-mes2:
    
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia  = s-codcia AND 
                                  PL-MOV-MES.periodo = COMBO-Periodo AND 
                                  PL-MOV-MES.nromes  = x-mes AND
                                  PL-MOV-MES.codpln  = 1 AND 
        (PL-MOV-MES.codcal  = 001 OR PL-MOV-MES.codcal  = 003
         OR PL-MOV-MES.codcal = 004 OR PL-MOV-MES.codcal = 005
         OR PL-MOV-MES.codcal = 008) AND
                                 (PL-MOV-MES.codmov  = 221 OR
                                  PL-MOV-MES.codmov  = 222 OR
                                  PL-MOV-MES.codmov  = 225),
                                  

first pl-flg-mes of pl-mov-mes no-lock,
    first pl-pers of pl-flg-mes no-lock,
        first pl-afps of pl-flg-mes where pl-afps.desafp = 'union vida' no-lock:
           find tempo where t-codcia = s-codcia and
                         t-codafp = pl-flg-mes.codafp and
                         t-codper = pl-pers.codper exclusive-lock no-error.

DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Codigo del Personal"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso. 
                                          
if not available tempo then create tempo.
assign 
        tempo.t-codcia                  = s-codcia
        tempo.t-codper                  = pl-pers.codper
        tempo.t-codafp                  = pl-flg-mes.codafp
        tempo.t-nroafp                  = pl-flg-mes.nroafp
        tempo.t-desafp                  = pl-afps.desafp
        tempo.t-patper                  = pl-pers.patper
        tempo.t-matper                  = pl-pers.matper
        tempo.t-nomper                  = pl-pers.nomper
        tempo.valcal[x-mes] = tempo.valcal[x-mes] + PL-MOV-MES.valcal-mes
        tempo.valcal[13] = tempo.valcal[1] + tempo.valcal[2] + tempo.valcal[3] + tempo.valcal[4] + 
                           tempo.valcal[5] + tempo.valcal[6] + tempo.valcal[7] + tempo.valcal[8] +
                           tempo.valcal[9] + tempo.valcal[10] + tempo.valcal[11] + tempo.valcal[12]
        tempo.t-vcontr                  = pl-flg-mes.vcontr.                                          
 
end.
end.   

HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal4 W-Win 
PROCEDURE carga-temporal4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH tempo:
    DELETE tempo.
  END.


    do x-mes = combo-mes1 to combo-mes2:
    
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia  = s-codcia AND 
                                  PL-MOV-MES.periodo = COMBO-Periodo AND 
                                  PL-MOV-MES.nromes  = x-mes AND
                                  PL-MOV-MES.codpln  = 1 AND 
        (PL-MOV-MES.codcal  = 001 OR PL-MOV-MES.codcal  = 003
         OR PL-MOV-MES.codcal = 004 OR PL-MOV-MES.codcal = 005
         OR PL-MOV-MES.codcal = 008) AND
                                 (PL-MOV-MES.codmov  = 221 OR
                                  PL-MOV-MES.codmov  = 222 OR
                                  PL-MOV-MES.codmov  = 225),
                                  

first pl-flg-mes of pl-mov-mes no-lock,
    first pl-pers of pl-flg-mes no-lock,
        first pl-afps of pl-flg-mes where pl-afps.desafp = 'Prima' no-lock:
           find tempo where t-codcia = s-codcia and
                         t-codafp = pl-flg-mes.codafp and
                         t-codper = pl-pers.codper exclusive-lock no-error.

DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Codigo del Personal"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso. 
                                          
if not available tempo then create tempo.
assign 
        tempo.t-codcia                  = s-codcia
        tempo.t-codper                  = pl-pers.codper
        tempo.t-codafp                  = pl-flg-mes.codafp
        tempo.t-nroafp                  = pl-flg-mes.nroafp
        tempo.t-desafp                  = pl-afps.desafp
        tempo.t-patper                  = pl-pers.patper
        tempo.t-matper                  = pl-pers.matper
        tempo.t-nomper                  = pl-pers.nomper
        tempo.valcal[x-mes] = tempo.valcal[x-mes] + PL-MOV-MES.valcal-mes
        tempo.valcal[13] = tempo.valcal[1] + tempo.valcal[2] + tempo.valcal[3] + tempo.valcal[4] + 
                           tempo.valcal[5] + tempo.valcal[6] + tempo.valcal[7] + tempo.valcal[8] +
                           tempo.valcal[9] + tempo.valcal[10] + tempo.valcal[11] + tempo.valcal[12]
        tempo.t-vcontr                  = pl-flg-mes.vcontr.                                          
 
end.
end.   

HIDE FRAME F-PROCESO.
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
  DISPLAY r-afp COMBO-Periodo COMBO-mes1 COMBO-mes2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE r-afp BUTTON-1 COMBO-Periodo COMBO-mes1 BUTTON-2 COMBO-mes2 
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
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal.
  DEFINE FRAME F-cab
         tempo.t-nroafp  
         tempo.t-desafp  
         tempo.t-patper    
         tempo.t-matper    
         tempo.t-nomper   
         tempo.valcal[1]
         tempo.valcal[2]
         tempo.valcal[3]
         tempo.valcal[4]
         tempo.valcal[5]
         tempo.valcal[6]
         tempo.valcal[7]
         tempo.valcal[8]
         tempo.valcal[9]
         tempo.valcal[10]
         tempo.valcal[11]
         tempo.valcal[12]
         tempo.valcal[13]  FORMAT "ZZ,ZZZ,ZZ9.99"
         tempo.t-vcontr    

        WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 150  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 150  X-TEL 
         "Pag.  : " AT 250 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 250 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"    Nro.        Nombre                         Apellido             Apellido                                                                                                             "+ string(combo-periodo, "9999") format "x(235)"  "                              FECHA DE " SKIP
"    AFP         AFP                            Paterno              Materno              N O M B R E S                     ENE          FEB        MAR        ABR         MAY       JUN         JUL        AGO        SEP        OCT        NOV       DIC         TOTAL     CESE   " SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tempo break BY tempo.t-codcia BY tempo.t-patper BY tempo.t-desafp:
    ACCUMULATE tempo.valcal[1] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[2] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[3] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[4] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[5] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[6] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[7] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[8] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[9] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[10] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[11] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[12] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[13] (TOTAL BY tempo.t-codcia).
                  
                DISPLAY STREAM REPORT
                  tempo.t-nroafp 
                  tempo.t-desafp
                  tempo.t-patper  
                  tempo.t-matper  
                  tempo.t-nomper  
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
                  tempo.t-vcontr   
                  WITH FRAME F-cab.   
    IF LAST-OF(tempo.t-codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ tempo.t-nomper
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[1]) @ tempo.valcal[1]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[2]) @ tempo.valcal[2]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[3]) @ tempo.valcal[3]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[4]) @ tempo.valcal[4]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[5]) @ tempo.valcal[5]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[6]) @ tempo.valcal[6]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[7]) @ tempo.valcal[7]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[8]) @ tempo.valcal[8]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[9]) @ tempo.valcal[9]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[10]) @ tempo.valcal[10]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[11]) @ tempo.valcal[11]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[12]) @ tempo.valcal[12]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[13]) @ tempo.valcal[13]
            WITH FRAME F-Cab.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal1.
  DEFINE FRAME F-cab
         tempo.t-nroafp  
         tempo.t-desafp  
         tempo.t-patper    
         tempo.t-matper    
         tempo.t-nomper   
         tempo.valcal[1]
         tempo.valcal[2]
         tempo.valcal[3]
         tempo.valcal[4]
         tempo.valcal[5]
         tempo.valcal[6]
         tempo.valcal[7]
         tempo.valcal[8]
         tempo.valcal[9]
         tempo.valcal[10]
         tempo.valcal[11]
         tempo.valcal[12]
         tempo.valcal[13]  FORMAT "ZZ,ZZZ,ZZ9.99"
         tempo.t-vcontr    

        WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 150  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 150  X-TEL 
         "Pag.  : " AT 250 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 250 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"    Nro.        Nombre                         Apellido             Apellido                                                                                                             "+ string(combo-periodo, "9999") format "x(235)"  "                              FECHA DE " SKIP
"    AFP         AFP                            Paterno              Materno              N O M B R E S                     ENE          FEB        MAR        ABR         MAY       JUN         JUL        AGO        SEP        OCT        NOV       DIC         TOTAL     CESE   " SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tempo break BY tempo.t-codcia BY tempo.t-patper BY tempo.t-desafp:
    ACCUMULATE tempo.valcal[1] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[2] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[3] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[4] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[5] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[6] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[7] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[8] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[9] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[10] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[11] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[12] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[13] (TOTAL BY tempo.t-codcia).

           
                  
                DISPLAY STREAM REPORT
                  tempo.t-nroafp 
                  tempo.t-desafp
                  tempo.t-patper  
                  tempo.t-matper  
                  tempo.t-nomper  
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
                  tempo.t-vcontr   
                  WITH FRAME F-cab.   
    IF LAST-OF(tempo.t-codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ tempo.t-nomper
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[1]) @ tempo.valcal[1]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[2]) @ tempo.valcal[2]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[3]) @ tempo.valcal[3]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[4]) @ tempo.valcal[4]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[5]) @ tempo.valcal[5]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[6]) @ tempo.valcal[6]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[7]) @ tempo.valcal[7]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[8]) @ tempo.valcal[8]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[9]) @ tempo.valcal[9]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[10]) @ tempo.valcal[10]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[11]) @ tempo.valcal[11]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[12]) @ tempo.valcal[12]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[13]) @ tempo.valcal[13]
            WITH FRAME F-Cab.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal2.
  DEFINE FRAME F-cab
         tempo.t-nroafp  
         tempo.t-desafp  
         tempo.t-patper    
         tempo.t-matper    
         tempo.t-nomper   
         tempo.valcal[1]
         tempo.valcal[2]
         tempo.valcal[3]
         tempo.valcal[4]
         tempo.valcal[5]
         tempo.valcal[6]
         tempo.valcal[7]
         tempo.valcal[8]
         tempo.valcal[9]
         tempo.valcal[10]
         tempo.valcal[11]
         tempo.valcal[12]
         tempo.valcal[13]  FORMAT "ZZ,ZZZ,ZZ9.99"
         tempo.t-vcontr    

        WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 150  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 150  X-TEL 
         "Pag.  : " AT 250 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 250 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"    Nro.        Nombre                         Apellido             Apellido                                                                                                             "+ string(combo-periodo, "9999") format "x(235)"  "                              FECHA DE " SKIP
"    AFP         AFP                            Paterno              Materno              N O M B R E S                     ENE          FEB        MAR        ABR         MAY       JUN         JUL        AGO        SEP        OCT        NOV       DIC         TOTAL     CESE   " SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tempo break BY tempo.t-codcia BY tempo.t-patper BY tempo.t-desafp:

    ACCUMULATE tempo.valcal[1] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[2] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[3] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[4] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[5] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[6] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[7] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[8] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[9] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[10] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[11] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[12] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[13] (TOTAL BY tempo.t-codcia).
           
                  
                DISPLAY STREAM REPORT
                  tempo.t-nroafp 
                  tempo.t-desafp
                  tempo.t-patper  
                  tempo.t-matper  
                  tempo.t-nomper  
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
                  tempo.t-vcontr   
                  WITH FRAME F-cab.   
    IF LAST-OF(tempo.t-codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ tempo.t-nomper
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[1]) @ tempo.valcal[1]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[2]) @ tempo.valcal[2]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[3]) @ tempo.valcal[3]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[4]) @ tempo.valcal[4]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[5]) @ tempo.valcal[5]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[6]) @ tempo.valcal[6]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[7]) @ tempo.valcal[7]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[8]) @ tempo.valcal[8]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[9]) @ tempo.valcal[9]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[10]) @ tempo.valcal[10]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[11]) @ tempo.valcal[11]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[12]) @ tempo.valcal[12]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[13]) @ tempo.valcal[13]
            WITH FRAME F-Cab.
    END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 W-Win 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal3.
  DEFINE FRAME F-cab
         tempo.t-nroafp  
         tempo.t-desafp  
         tempo.t-patper    
         tempo.t-matper    
         tempo.t-nomper   
         tempo.valcal[1]
         tempo.valcal[2]
         tempo.valcal[3]
         tempo.valcal[4]
         tempo.valcal[5]
         tempo.valcal[6]
         tempo.valcal[7]
         tempo.valcal[8]
         tempo.valcal[9]
         tempo.valcal[10]
         tempo.valcal[11]
         tempo.valcal[12]
         tempo.valcal[13]  FORMAT "ZZ,ZZZ,ZZ9.99"
         tempo.t-vcontr    

        WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 150  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 150  X-TEL 
         "Pag.  : " AT 250 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 250 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"    Nro.        Nombre                         Apellido             Apellido                                                                                                             "+ string(combo-periodo, "9999") format "x(235)"  "                              FECHA DE " SKIP
"    AFP         AFP                            Paterno              Materno              N O M B R E S                     ENE          FEB        MAR        ABR         MAY       JUN         JUL        AGO        SEP        OCT        NOV       DIC         TOTAL     CESE   " SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tempo break BY tempo.t-codcia BY tempo.t-patper BY tempo.t-desafp:

    ACCUMULATE tempo.valcal[1] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[2] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[3] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[4] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[5] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[6] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[7] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[8] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[9] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[10] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[11] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[12] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[13] (TOTAL BY tempo.t-codcia).
           
                  
                DISPLAY STREAM REPORT
                  tempo.t-nroafp 
                  tempo.t-desafp
                  tempo.t-patper  
                  tempo.t-matper  
                  tempo.t-nomper  
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
                  tempo.t-vcontr   
                  WITH FRAME F-cab.   
    IF LAST-OF(tempo.t-codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ tempo.t-nomper
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[1]) @ tempo.valcal[1]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[2]) @ tempo.valcal[2]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[3]) @ tempo.valcal[3]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[4]) @ tempo.valcal[4]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[5]) @ tempo.valcal[5]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[6]) @ tempo.valcal[6]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[7]) @ tempo.valcal[7]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[8]) @ tempo.valcal[8]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[9]) @ tempo.valcal[9]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[10]) @ tempo.valcal[10]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[11]) @ tempo.valcal[11]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[12]) @ tempo.valcal[12]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[13]) @ tempo.valcal[13]
            WITH FRAME F-Cab.
    END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4 W-Win 
PROCEDURE Formato4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal4.
  DEFINE FRAME F-cab
         tempo.t-nroafp  
         tempo.t-desafp  
         tempo.t-patper    
         tempo.t-matper    
         tempo.t-nomper   
         tempo.valcal[1]
         tempo.valcal[2]
         tempo.valcal[3]
         tempo.valcal[4]
         tempo.valcal[5]
         tempo.valcal[6]
         tempo.valcal[7]
         tempo.valcal[8]
         tempo.valcal[9]
         tempo.valcal[10]
         tempo.valcal[11]
         tempo.valcal[12]
         tempo.valcal[13]  FORMAT "ZZ,ZZZ,ZZ9.99"
         tempo.t-vcontr    

        WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 150  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 150  X-TEL 
         "Pag.  : " AT 250 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 250 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"    Nro.        Nombre                         Apellido             Apellido                                                                                                             "+ string(combo-periodo, "9999") format "x(235)"  "                              FECHA DE " SKIP
"    AFP         AFP                            Paterno              Materno              N O M B R E S                     ENE          FEB        MAR        ABR         MAY       JUN         JUL        AGO        SEP        OCT        NOV       DIC         TOTAL     CESE   " SKIP
"-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tempo break BY tempo.t-codcia BY tempo.t-patper BY tempo.t-desafp:

    ACCUMULATE tempo.valcal[1] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[2] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[3] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[4] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[5] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[6] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[7] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[8] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[9] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[10] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[11] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[12] (TOTAL BY tempo.t-codcia).
    ACCUMULATE tempo.valcal[13] (TOTAL BY tempo.t-codcia).
           
                  
                DISPLAY STREAM REPORT
                  tempo.t-nroafp 
                  tempo.t-desafp
                  tempo.t-patper  
                  tempo.t-matper  
                  tempo.t-nomper  
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
                  tempo.t-vcontr   
                  WITH FRAME F-cab.   
    IF LAST-OF(tempo.t-codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
                  tempo.valcal[1] 
                  tempo.valcal[2] 
                  tempo.valcal[3] 
                  tempo.valcal[4] 
                  tempo.valcal[5] 
                  tempo.valcal[6]
                  tempo.valcal[7]
                  tempo.valcal[8]
                  tempo.valcal[9]
                  tempo.valcal[10]
                  tempo.valcal[11]
                  tempo.valcal[12]
                  tempo.valcal[13]
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ tempo.t-nomper
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[1]) @ tempo.valcal[1]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[2]) @ tempo.valcal[2]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[3]) @ tempo.valcal[3]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[4]) @ tempo.valcal[4]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[5]) @ tempo.valcal[5]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[6]) @ tempo.valcal[6]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[7]) @ tempo.valcal[7]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[8]) @ tempo.valcal[8]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[9]) @ tempo.valcal[9]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[10]) @ tempo.valcal[10]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[11]) @ tempo.valcal[11]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[12]) @ tempo.valcal[12]
            (ACCUM TOTAL BY tempo.t-codcia tempo.valcal[13]) @ tempo.valcal[13]
            WITH FRAME F-Cab.
    END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN bin/_prnctr.p.

  IF s-salida-impresion = 0 THEN RETURN.
/*   case r-afp:                        */
/*     when 1 then RUN carga-temporal.  */
/*     when 2 then RUN carga-temporal1. */
/*     when 3 then RUN carga-temporal2. */
/*     when 4 then RUN carga-temporal3. */
/*     when 5 then RUN carga-temporal4. */
/*   end case.                          */
/*  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
 *     NO-LOCK NO-ERROR.
 *   IF NOT AVAILABLE w-report
 *   THEN DO:
 *       MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
 *       RETURN.
 *   END.
 *   s-Titulo = 'RESUMEN DE ENERO A DICIEMBRE DEL ' + STRING(COMBO-BOX-Periodo, '9999').*/

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 
  THEN s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
 
 case r-afp:
    when 1 then RUN Formato.
    when 2 then RUN Formato1.
    when 3 then RUN Formato2.
    when 4 then RUN Formato3.
     when 5 then RUN Formato4.
 end case. 
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir2 W-Win 
PROCEDURE Imprimir2 :
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE r-afp:
            WHEN 1 THEN RUN Formato.
            WHEN 2 THEN RUN Formato1.
            WHEN 3 THEN RUN Formato2.
            WHEN 4 THEN RUN Formato3.
            WHEN 5 THEN RUN Formato4.
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
    ASSIGN
        COMBO-Periodo:LIST-ITEMS = x-Periodo.
        COMBO-Periodo = s-periodo.
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

