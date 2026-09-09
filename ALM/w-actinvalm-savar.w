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

/*THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.*/

IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar los stocks'
      VIEW-AS ALERT-BOX WARNING.
END.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEFINE TEMP-TABLE tmp-almdinv LIKE integral.almdinv.

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
&Scoped-Define ENABLED-OBJECTS x-fecha BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS x-codalm x-codalm-2 x-fecha x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 2" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 3" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE x-codalm AS CHARACTER FORMAT "X(256)":U INITIAL "45,45s" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-codalm-2 AS CHARACTER FORMAT "X(256)":U INITIAL "45,45s" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-fecha AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-codalm AT ROW 3.69 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     x-codalm-2 AT ROW 5.31 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     x-fecha AT ROW 6.92 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     BUTTON-2 AT ROW 8.54 COL 45.29 WIDGET-ID 8
     BUTTON-3 AT ROW 8.54 COL 58.72 WIDGET-ID 10
     x-mensaje AT ROW 8.81 COL 5 NO-LABEL WIDGET-ID 12
     "Solo para los almacenes (Cissac)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 5.5 COL 5 WIDGET-ID 22
          FGCOLOR 1 
     "Fecha Inv" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 7.04 COL 19 WIDGET-ID 20
     "Actualizacion de Stocks CONTINENTAL - STANDFORD" VIEW-AS TEXT
          SIZE 68 BY 1.35 AT ROW 2.08 COL 5 WIDGET-ID 6
     "Solo para los almacenes (Conti)" VIEW-AS TEXT
          SIZE 29 BY .62 AT ROW 3.88 COL 5 WIDGET-ID 14
          FGCOLOR 1 
     "w-actinvalm-savar" VIEW-AS TEXT
          SIZE 23 BY .62 AT ROW 10.15 COL 47 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.14 BY 9.88 WIDGET-ID 100.


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
         TITLE              = "Actualizacion de Stocks"
         HEIGHT             = 9.88
         WIDTH              = 73.14
         MAX-HEIGHT         = 9.88
         MAX-WIDTH          = 73.14
         VIRTUAL-HEIGHT     = 9.88
         VIRTUAL-WIDTH      = 73.14
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
/* SETTINGS FOR FILL-IN x-codalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-codalm-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Actualizacion de Stocks */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Actualizacion de Stocks */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN x-codalm x-fecha x-codalm-2.
    MESSAGE '  Este proceso se realiza solo una vez,' SKIP
            'ya que modifica datos de conteo y reconteo.'SKIP
            '             ¿Desea Continuar?             '
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE lchoice AS LOG.
    IF lchoice THEN
        RUN Actualiza-Stocks.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Almacen W-Win 
PROCEDURE Actualiza-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tmp-almdinv NO-LOCK
        BREAK BY tmp-almdinv.codalm
            BY tmp-almdinv.nropagina:
        FIND FIRST integral.almdinv WHERE integral.almdinv.codcia = s-codcia
            AND integral.almdinv.codalm = tmp-almdinv.codalm
            AND integral.almdinv.nomcia = tmp-almdinv.nomcia
            AND integral.almdinv.codmat = tmp-almdinv.codmat NO-ERROR.
        IF NOT AVAIL integral.almdinv THEN DO:
            IF FIRST-OF(tmp-almdinv.nropagina) THEN DO:
                CREATE integral.AlmCInv.
                ASSIGN
                    integral.almcinv.codcia    = tmp-almdinv.codcia
                    integral.almcinv.codalm    = tmp-almdinv.codalm    
                    integral.almcinv.nropagina = tmp-almdinv.nropagina
                    integral.almcinv.nomcia    = tmp-almdinv.nomcia
                    integral.almcinv.swconteo  = YES
                    integral.almcinv.coduser   = s-user-id
                    integral.almcinv.fecupdate = tmp-almdinv.libre_f01.            
            END.
            CREATE integral.almdinv.
            BUFFER-COPY tmp-almdinv TO integral.almdinv.
        END.
        ELSE DO:
            ASSIGN
                integral.almdinv.qtyconteo   = tmp-almdinv.qtyconteo
                integral.almdinv.qtyreconteo = tmp-almdinv.qtyreconteo
                integral.almdinv.libre_d01   = tmp-almdinv.libre_d01.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cissac W-Win 
PROCEDURE Actualiza-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE s-codcia AS INTEGER    NO-UNDO INIT 1.
    DEFINE VARIABLE cAlmacen AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iInt     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lPag     AS LOGICAL    NO-UNDO.

    DEFINE BUFFER b-almdinv  FOR integral.almdinv.        
    
    IF NOT connected('cissac')
        THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
          'NO podemos capturar el stock'
          VIEW-AS ALERT-BOX WARNING.
    END.    
    cAlmacen = x-codalm-2.

    /*Carga Cissac*/
    DO iInt = 1 TO NUM-ENTRIES(cAlmacen):
        FOR EACH cissac.almcinv WHERE cissac.almcinv.codcia = s-codcia
            AND cissac.almcinv.codalm = ENTRY(iInt,cAlmacen,",")
            AND DATE(cissac.almcinv.fecupdate) = x-fecha
            AND cissac.almcinv.nomcia = "STAND"
            /*AND cissac.almcinv.swconteo = NO*/ EXCLUSIVE-LOCK:
            lPag = NO.
            FOR EACH cissac.almdinv OF cissac.almcinv EXCLUSIVE-LOCK:
                FIND FIRST integral.almdinv WHERE integral.almdinv.codcia = s-codcia
                    AND integral.almdinv.codalm    = "40x"
                    AND integral.almdinv.nomcia    = "CONTISTAND"
                    AND integral.almdinv.libre_f01 = x-fecha                    
                    AND integral.almdinv.nropagina < 9000
                    AND integral.almdinv.codmat    = cissac.almdinv.codmat                         
                    AND integral.almdinv.libre_d01 <> 0 NO-ERROR.
    
                IF AVAIL integral.almdinv THEN DO:
                    FIND FIRST integral.almcinv OF integral.almdinv NO-ERROR.
                    IF integral.almcinv.swconteo = NO THEN RETURN "adm-error".
                    
                    IF integral.almdinv.libre_d01 > 0 THEN DO:
                        IF cissac.almdinv.qtyfisico <= integral.almdinv.libre_d01 THEN
                            ASSIGN
                                cissac.almdinv.qtyconteo   = cissac.almdinv.qtyfisico
                                cissac.almdinv.qtyreconteo = cissac.almdinv.qtyfisico
                                cissac.almdinv.libre_d01   = cissac.almdinv.qtyfisico
                                lPag = YES.
                        ELSE 
                            ASSIGN
                                cissac.almdinv.qtyconteo   = integral.almdinv.libre_d01
                                cissac.almdinv.qtyreconteo = integral.almdinv.libre_d01
                                cissac.almdinv.libre_d01   = integral.almdinv.libre_d01
                                lPag = YES.

                        integral.almdinv.libre_d01 = 
                            (integral.almdinv.libre_d01 - cissac.almdinv.libre_d01).
                    END.
                    ELSE DO:
                        ASSIGN
                            cissac.almdinv.qtyconteo   = cissac.almdinv.qtyfisico
                            cissac.almdinv.qtyreconteo = cissac.almdinv.qtyfisico
                            cissac.almdinv.libre_d01   = cissac.almdinv.qtyfisico
                            lPag = YES.                        
                    END.
                    PAUSE 0.
                END.
            END.
            ASSIGN
                cissac.almcinv.swconteo   = YES
                cissac.almcinv.swreconteo = YES.       
            PAUSE 0.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Stocks W-Win 
PROCEDURE Actualiza-Stocks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE s-codcia AS INTEGER NO-UNDO INIT 1.
    DEFINE BUFFER b-almcinv  FOR integral.almcinv.    
    DEFINE BUFFER b-almdinv  FOR integral.almdinv.    
    DEFINE BUFFER bbalmdinv  FOR integral.almdinv.    
    DEFINE VARIABLE iInt     AS INTEGER NO-UNDO.
    DEFINE VARIABLE cAlmacen AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lPag     AS LOGICAL     NO-UNDO.

    IF NOT connected('cissac')
        THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
            'NO podemos capturar el stock'
            VIEW-AS ALERT-BOX WARNING.
    END.
  
    /*Carga Cissac*/
    RUN Actualiza-cissac.
    
    cAlmacen = x-codalm.
    /*Carga Cissac*/
    DO iInt = 1 TO NUM-ENTRIES(cAlmacen):
        FOR EACH integral.almcinv WHERE integral.almcinv.codcia = s-codcia
            AND integral.almcinv.codalm = ENTRY(iInt,cAlmacen,",")
            AND DATE(integral.almcinv.fecupdate) = x-fecha
            AND integral.almcinv.nomcia = "CONTI"
            /*AND integral.almcinv.swconteo = NO*/ EXCLUSIVE-LOCK:
            lPag = NO.
            FOR EACH integral.almdinv OF integral.almcinv EXCLUSIVE-LOCK:
                FIND FIRST b-almdinv WHERE b-almdinv.codcia = s-codcia
                    AND b-almdinv.codalm    = "40x"
                    AND b-almdinv.nomcia    = "CONTISTAND"
                    AND b-almdinv.libre_f01 = x-fecha                    
                    AND b-almdinv.nropagina < 9000
                    AND b-almdinv.codmat    = integral.almdinv.codmat                         
                    AND b-almdinv.libre_d01 <> 0 NO-ERROR.
    
                IF AVAIL b-almdinv THEN DO:
                    FIND FIRST b-almcinv OF b-almdinv NO-ERROR.
                    IF b-almcinv.swconteo = NO THEN RETURN "adm-error".

                    DISPLAY "PROCESANDO: " + b-almdinv.codmat @ x-mensaje
                        WITH FRAME {&FRAME-NAME}.
                    IF b-almdinv.libre_d01 > 0 THEN DO:
                        IF integral.almdinv.qtyfisico <= b-almdinv.libre_d01 THEN
                            ASSIGN
                                integral.almdinv.qtyconteo   = integral.almdinv.qtyfisico
                                integral.almdinv.qtyreconteo = integral.almdinv.qtyfisico
                                integral.almdinv.libre_d01   = integral.almdinv.qtyfisico
                                lPag = YES.
                        ELSE 
                            ASSIGN
                                integral.almdinv.qtyconteo   = b-almdinv.libre_d01
                                integral.almdinv.qtyreconteo = b-almdinv.libre_d01
                                integral.almdinv.libre_d01   = b-almdinv.libre_d01
                                lPag = YES.
                        b-almdinv.libre_d01 = 
                            (b-almdinv.libre_d01 - integral.almdinv.libre_d01).
                    END.
                    ELSE DO:
                        ASSIGN
                            integral.almdinv.qtyconteo   = integral.almdinv.qtyfisico
                            integral.almdinv.qtyreconteo = integral.almdinv.qtyfisico
                            integral.almdinv.libre_d01   = integral.almdinv.qtyfisico
                            lPag = YES.
                    END.
                    PAUSE 0.
                END.
            END.
            ASSIGN 
                integral.almcinv.swconteo   = YES
                integral.almcinv.swreconteo = YES.
            PAUSE 0.
        END.
    END.

/***********
    cAlmacen = x-codalm.
    DO iInt = 1 TO NUM-ENTRIES(cAlmacen):
        FOR EACH integral.almcinv WHERE integral.almcinv.codcia = s-codcia
            AND integral.almcinv.codalm = ENTRY(iInt,cAlmacen,",")
            AND integral.almcinv.nomcia = "CONTI"
            AND DATE(integral.almcinv.fecupdate) = x-fecha NO-LOCK:
            FOR EACH bbalmdinv OF integral.almcinv EXCLUSIVE-LOCK:
                FIND FIRST b-almdinv WHERE b-almdinv.codcia = s-codcia
                    AND b-almdinv.codalm    = "40x"
                    AND b-almdinv.nomcia    = "CONTISTAND"  
                    AND b-almdinv.libre_f01 = x-fecha
                    AND b-almdinv.nropagina < 9000
                    AND b-almdinv.codmat    = bbalmdinv.codmat
                    AND b-almdinv.libre_d01 <> 0  NO-ERROR.
                IF AVAIL b-almdinv THEN DO:
                    FIND FIRST b-almcinv OF b-almdinv NO-LOCK NO-ERROR.
                    IF b-almcinv.swconteo = NO THEN RETURN "adm-error".
                    IF integral.almcinv.swconteo = NO THEN RETURN "adm-error".
                    IF bbalmdinv.qtyfisico <= b-almdinv.qtyreconteo THEN DO:
                        ASSIGN 
                            bbalmdinv.qtyconteo   = bbalmdinv.qtyfisico
                            bbalmdinv.qtyreconteo = bbalmdinv.qtyfisico
                            bbalmdinv.libre_d01   = bbalmdinv.qtyfisico.
                    END.
                    ELSE DO:
                        ASSIGN 
                            bbalmdinv.qtyconteo   = b-almdinv.libre_d01
                            bbalmdinv.qtyreconteo = b-almdinv.libre_d01
                            bbalmdinv.libre_d01   = b-almdinv.libre_d01.   
                    END.
                    /*
                    b-almdinv.qtyconteo = (b-almdinv.qtyconteo - bbalmdinv.qtyconteo).
                    b-almdinv.qtyreconteo = (b-almdinv.qtyreconteo - bbalmdinv.qtyreconteo).
                    */
                    b-almdinv.libre_d01   = (b-almdinv.libre_d01 - bbalmdinv.libre_d01).                    
                END.
                DISPLAY "Asignando... " + bbalmdinv.codmat @ x-mensaje WITH FRAME {&FRAME-NAME}.
            END.
            FIND FIRST b-almcinv WHERE ROWID(b-almcinv) = ROWID(almcinv) NO-ERROR.
            b-almcinv.swconteo   = YES.
            b-almcinv.swreconteo = YES.        
        END.
    END.

    RELEASE integral.almdinv.
***********/    

    /*Completa Stocks*/
    Two:
    FOR EACH integral.almdinv WHERE integral.almdinv.codcia = s-codcia
        AND integral.almdinv.codalm = "40x"
        AND integral.almdinv.nomcia = "contistand"
        AND integral.almdinv.libre_d01 <> 0:

        FIND LAST b-almdinv WHERE b-almdinv.codcia = integral.almdinv.codcia
            AND LOOKUP(b-almdinv.codalm,"45s") > 0
            AND b-almdinv.nomcia    = "conti"
            AND b-almdinv.codmat    = integral.almdinv.codmat
            AND b-almdinv.qtyfisico < 0 NO-ERROR.
        IF AVAIL b-almdinv THEN DO:
            ASSIGN 
                b-almdinv.qtyconteo   = b-almdinv.qtyconteo   + integral.almdinv.libre_d01
                b-almdinv.qtyreconteo = b-almdinv.qtyreconteo + integral.almdinv.libre_d01
                b-almdinv.libre_d01   = b-almdinv.libre_d01   + integral.almdinv.libre_d01.
            integral.almdinv.libre_d01 = 0.
            NEXT Two.
        END.

        FIND FIRST b-almdinv WHERE b-almdinv.codcia = integral.almdinv.codcia
            AND b-almdinv.codalm = "45s"
            AND b-almdinv.nomcia = "conti"
            AND b-almdinv.codmat = integral.almdinv.codmat NO-ERROR.
        IF AVAIL b-almdinv THEN DO:
            ASSIGN 
                b-almdinv.qtyconteo   = b-almdinv.qtyconteo   + integral.almdinv.libre_d01
                b-almdinv.qtyreconteo = b-almdinv.qtyreconteo + integral.almdinv.libre_d01
                b-almdinv.libre_d01   = b-almdinv.libre_d01   + integral.almdinv.libre_d01.
            integral.almdinv.libre_d01 = 0.
        END.
    END.

    /*Carga Ingresos Manuales*/
    FOR EACH tmp-almdinv:
        DELETE tmp-almdinv.
    END.

    FOR EACH integral.almdinv WHERE integral.almdinv.codcia = s-codcia
        AND integral.almdinv.codalm    = "40x"
        AND integral.almdinv.nomcia    = "CONTISTAND"  
        AND integral.almdinv.libre_f01 = x-fecha 
        AND integral.almdinv.nropagina >= 9000:
        CREATE tmp-almdinv.
        BUFFER-COPY integral.almdinv TO tmp-almdinv.
        ASSIGN 
            tmp-almdinv.codalm = "11"
            tmp-almdinv.nomcia = "CONTI".             
        DISPLAY "PROCESA: " + integral.almdinv.codmat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.

    RUN Actualiza-Almacen.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}. 
    MESSAGE 'Proceso Terminado'
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY x-codalm x-codalm-2 x-fecha x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-fecha BUTTON-2 BUTTON-3 
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
  
    /*Actualiza tabla InvConfig*/
    
/*     FIND FIRST integral.almacen WHERE integral.almacen.codcia = s-codcia                       */
/*         AND integral.almacen.codalm = ENTRY(1,x-codalm,",") NO-LOCK NO-ERROR.                  */
/*     IF AVAIL integral.almacen THEN DO:                                                         */
/*         FIND LAST integral.invconfig WHERE integral.invconfig.codcia = integral.almacen.codcia */
/*             AND integral.invconfig.codalm = integral.almacen.codalm                            */
/*             AND integral.invconfig.tipinv = "T" NO-LOCK NO-ERROR.                              */
/*         IF AVAIL integral.invconfig THEN                                                       */
/*             x-fecha = integral.invconfig.fchInv.                                               */
/*                                                                                                */
/*     END.                                                                                       */

    ASSIGN x-fecha = 11/18/2011.
    
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

