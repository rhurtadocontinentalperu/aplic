&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE B-CPEDI NO-UNDO LIKE FacCPedi
       INDEX Llave01 AS PRIMARY Libre_d01.
DEFINE NEW SHARED TEMP-TABLE B-DPEDI NO-UNDO LIKE FacDPedi.



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

DEF NEW SHARED VAR lh_Handle  AS HANDLE.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PPD' NO-UNDO.        /* Pre PeDido */

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
&Scoped-Define ENABLED-OBJECTS BUTTON-12 BtnDone FILL-IN_FchEnt BUTTON-1 ~
RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchEnt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-preped-03a-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-preped-03b AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "(1) FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 12" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-5 
     LABEL "(3) GENERAR PRE-PEDIDOS" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "(2) PROYECCION" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN_FchEnt AS DATE FORMAT "99/99/99":U 
     LABEL "Entregar hasta el" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66 BY 1.62
     BGCOLOR 11 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 67 BY 1.62
     BGCOLOR 11 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-12 AT ROW 1 COL 135 WIDGET-ID 22
     BtnDone AT ROW 1 COL 141 WIDGET-ID 16
     FILL-IN_FchEnt AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.27 COL 31 WIDGET-ID 6
     BUTTON-5 AT ROW 1.27 COL 111 WIDGET-ID 14
     BUTTON-8 AT ROW 1.27 COL 69 WIDGET-ID 2
     RECT-3 AT ROW 1 COL 2 WIDGET-ID 18
     RECT-4 AT ROW 1 COL 68 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 147.14 BY 22.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI T "NEW SHARED" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY Libre_d01
      END-FIELDS.
      TABLE: B-DPEDI T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PREPARACION DE LOS PRE-PEDIDOS DEL DIA"
         HEIGHT             = 22.08
         WIDTH              = 147.14
         MAX-HEIGHT         = 22.85
         MAX-WIDTH          = 173.29
         VIRTUAL-HEIGHT     = 22.85
         VIRTUAL-WIDTH      = 173.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-8 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PREPARACION DE LOS PRE-PEDIDOS DEL DIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.

  /* RHC 21.12.09 Rutina que vuelve el FlgEst a "P" en las cotizaciones */
  RUN Eliminar-Todo IN h_b-preped-03a-1.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PREPARACION DE LOS PRE-PEDIDOS DEL DIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */

  /* RHC 21.12.09 Rutina que vuelve el FlgEst a "P" en las cotizaciones */
  RUN Eliminar-Todo IN h_b-preped-03a-1.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  /* RHC 21.12.09 Rutina que vuelve el FlgEst a "P" en las cotizaciones */
  RUN Eliminar-Todo IN h_b-preped-03a-1.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* (1) FILTRAR */
DO:
    /* CONSISTENCIA */
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.flgest = 'P'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN DO:
        MESSAGE 'Todavía hay PRE-PEDIDOS en trámite' SKIP
            'Si decide continuar TODOS los pre-pedidos en trámite serán ANULADOS' SKIP
            'Continuamos con el proceso (Si-No)?'
            VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    SESSION:SET-WAIT-STATE('GENERAL').
    ASSIGN FILL-IN_FchEnt.
    RUN Carga-Temporal IN h_b-preped-03a-1 ( INPUT FILL-IN_FchEnt).
    RUN dispatch IN h_b-preped-03a-1 ('open-query').
    button-1:SENSITIVE = NO.
    button-8:SENSITIVE = YES.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Button 12 */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel IN h_b-preped-03a-1.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* (3) GENERAR PRE-PEDIDOS */
DO:
    MESSAGE 'Generamos los Pre-Pedidos (S-N)?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    SESSION:SET-WAIT-STATE('GENERAL').
  RUN Generar-Pre-Pedidos.
  button-1:SENSITIVE = YES.
  button-8:SENSITIVE = YES.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* (2) PROYECCION */
DO:
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Proyeccion IN h_b-preped-03a-1.
   button-5:SENSITIVE = YES.
   SESSION:SET-WAIT-STATE('').
   RUN dispatch IN h_b-preped-03a-1 ('open-query').
   RUN dispatch IN h_b-preped-03b ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

lh_Handle = THIS-PROCEDURE.

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
             INPUT  'vtaexp/b-preped-03b.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-preped-03b ).
       RUN set-position IN h_b-preped-03b ( 16.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-preped-03b ( 6.69 , 119.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-preped-03a-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-preped-03a-1 ).
       RUN set-position IN h_b-preped-03a-1 ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-preped-03a-1 ( 13.15 , 145.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-preped-03b. */
       RUN add-link IN adm-broker-hdl ( h_b-preped-03a-1 , 'Record':U , h_b-preped-03b ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-preped-03b ,
             BUTTON-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-preped-03a-1 ,
             h_b-preped-03b , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY FILL-IN_FchEnt 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-12 BtnDone FILL-IN_FchEnt BUTTON-1 RECT-3 RECT-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pre-Pedidos W-Win 
PROCEDURE Generar-Pre-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i-nItem AS INT INIT 0 NO-UNDO.
  DEF VAR I-NRO   AS INT INIT 0 NO-UNDO.
  DEF VAR f-Tot   AS DEC NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH B-CPEDI:
          FIND Faccpedi OF B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
          IF Faccpedi.FlgEst = 'T' THEN Faccpedi.FlgEst = 'P'.
          RELEASE Faccpedi.
          IF B-CPEDI.Libre_d02 <= 0 THEN NEXT.
          FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
              AND FacCorre.CodDoc = S-CODDOC 
              AND FacCorre.CodDiv = S-CODDIV
              AND Faccorre.Codalm = S-CodAlm
              AND Faccorre.FlgEst = YES
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE FacCorre THEN DO:
              MESSAGE 'NO existe o no se pudo bloquear el control de correlativos para el documento' s-coddoc
                  VIEW-AS ALERT-BOX ERROR.
              RETURN ERROR.
          END.
          CREATE Faccpedi.
          BUFFER-COPY B-CPEDI 
              EXCEPT B-CPEDI.Libre_d01 B-CPEDI.Libre_d02 B-CPEDI.Importe
              TO Faccpedi
              ASSIGN 
                FacCPedi.CodCia = s-codcia
                FacCPedi.CodDiv = s-coddiv
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                FacCPedi.FchPed = TODAY 
                FacCPedi.NroRef = B-CPEDI.NroPed
                FacCPedi.FlgEst = 'P'
                FacCPedi.TpoPed = '1'.
          ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.

          ASSIGN 
                FacCPedi.Hora = STRING(TIME,"HH:MM")
                FacCPedi.Usuario = S-USER-ID
                FacCPedi.CodAlm = s-CodAlm.

          i-nItem = 0.
          FOR EACH B-DPEDI WHERE B-DPEDI.codcia = B-CPEDI.codcia
                AND B-DPEDI.coddoc = B-CPEDI.coddoc
                AND B-DPEDI.nroped = B-CPEDI.nroped
                AND B-DPEDI.Libre_d02 > 0:
              I-NITEM = I-NITEM + 1.
              CREATE FacDPedi.
              BUFFER-COPY B-DPEDI 
                  EXCEPT B-DPEDI.Libre_d01 B-DPEDI.Libre_d02 B-DPEDI.Libre_c05 B-DPEDI.CanAte
                  TO FacDPedi
                  ASSIGN
                      FacDPedi.CodCia = FacCPedi.CodCia
                      FacDPedi.CodDiv = FacCPedi.CodDiv
                      FacDPedi.coddoc = FacCPedi.coddoc
                      FacDPedi.NroPed = FacCPedi.NroPed
                      FacDPedi.FchPed = FacCPedi.FchPed
                      FacDPedi.Hora   = FacCPedi.Hora 
                      FacDPedi.FlgEst = FacCPedi.FlgEst
                      FacDPedi.NroItm = I-NITEM
                      FacDPedi.CanPed = B-DPEDI.Libre_d02       /* Con la cantidad Proyectada */
                      FacDPedi.Libre_d01 = B-DPEDI.Libre_d01    /* Nuevo Saldo por Atender */
                      FacDPedi.Libre_d02 = FacDPedi.CanPed.     /* Nueva Cantidad Negociada */
          END.

          RUN Graba-Totales.
          ASSIGN
              FacCPedi.Libre_d02 = FacCPedi.ImpTot.

          /* Actualizamos la cotizacion */
          RUN gn/actualiza-cotizacion (ROWID(Faccpedi), +1).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          RELEASE Faccpedi.
          RELEASE FacCorre.
      END.
  END.


  /* borramos los temporales */
  FOR EACH B-CPEDI:
      DELETE B-CPEDI.
  END.
  FOR EACH B-DPEDI:
      DELETE B-DPEDI.
  END.

  RUN dispatch IN h_b-preped-03a-1 ('open-query').
  RUN dispatch IN h_b-preped-03b ('open-query').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales W-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales.i}

/*
{vtaexp/graba-totales.i}
*/

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
  FILL-IN_FchEnt = TODAY + 2.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Browse-2 W-Win 
PROCEDURE Pinta-Browse-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

RUN Pinta-Browse IN h_b-preped-03b
    ( INPUT pRowid /* ROWID */).

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

