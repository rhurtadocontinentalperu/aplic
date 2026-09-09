&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CMOV FOR Almcmov.
DEFINE TEMP-TABLE COMPROMETIDOS NO-UNDO LIKE Almdmov.
DEFINE TEMP-TABLE CUBIERTAS NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE NOCUBIERTAS NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE XTRANSFERIR NO-UNDO LIKE Almdmov.



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
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion (Faccpedi.codcia = s-CodCia AND ~
        Faccpedi.coddiv = s-CodDiv AND ~
        Faccpedi.coddoc = 'COT' AND ~
        Faccpedi.FchVen >= TODAY AND ~
        Faccpedi.flgest = "P")

/* ALMACENES DE TRABAJO */
DEF VAR x-AlmDes AS CHAR NO-UNDO.
DEF VAR x-AlmOri AS CHAR NO-UNDO.
DEF VAR x-NomAlmDes AS CHAR NO-UNDO.
DEF VAR x-NomAlmOri AS CHAR NO-UNDO.

FOR EACH VtaAlmDiv NO-LOCK WHERE VtaAlmDiv.CodCia = s-CodCia AND
    VtaAlmDiv.CodDiv = s-CodDiv BY VtaAlmDiv.Orden:  
    x-AlmDes = VtaAlmDiv.CodAlm.
    LEAVE.
END.
IF TRUE <> (x-AlmDes > '') THEN DO:
    MESSAGE 'La división' s-coddiv 'NO tiene definido una almacén de descarga' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND Almacen WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = x-AlmDes
    NO-LOCK.
x-NomAlmDes =  Almacen.Descripcion.
/* Buscamos el almacén principal que va a abastecer el almacén encontrado */
DEF BUFFER B-Almacen FOR Almacen.
FIND B-Almacen WHERE B-Almacen.codcia = s-CodCia AND
    B-Almacen.coddiv = Almacen.CodDiv AND
    B-Almacen.AlmPrincipal = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-Almacen THEN DO:
    MESSAGE 'La división' Almacen.coddiv 'NO tiene definido una almacén principal' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
x-AlmOri = B-Almacen.CodAlm.
x-NomAlmOri = B-Almacen.Descripcion.

/* CONSISTENCIA DE MOVIMIENTOS */
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
            AND Almtdocm.CodAlm = x-AlmDes
            AND Almtdocm.TipMov = 'I'
            AND Almtdocm.CodMov = 03
            NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de entrada03 NO configurado en el almacén' x-AlmDes
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = x-AlmOri
    AND Almtdocm.TipMov = 'S'
    AND Almtdocm.CodMov = 03
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de salida 03 NO configurado en el almacén' x-AlmOri
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-28 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-AlmDes FILL-IN-NomAlmDes ~
FILL-IN-AlmOri FILL-IN-NomAlmOri 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ecommerce-transf-artic AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-ecommerce-transf-cub AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-ecommerce-transf-nocub AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-ecommerce-transf-nocubdet AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "INICIO DEL PROCESO" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-TRANSFERIR 
     LABEL "PROCEDER CON LA TRANSFERENCIA AUTOMATICA" 
     SIZE 41 BY 1.12.

DEFINE VARIABLE FILL-IN-AlmDes AS CHARACTER FORMAT "X(5)":U 
     LABEL "Almacén de Destino" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmOri AS CHARACTER FORMAT "X(5)":U 
     LABEL "Almacén de Origen" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAlmDes AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAlmOri AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 183 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-AlmDes AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomAlmDes AT ROW 1.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 1.81 COL 84 WIDGET-ID 12
     FILL-IN-AlmOri AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NomAlmOri AT ROW 2.62 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-TRANSFERIR AT ROW 24.15 COL 2 WIDGET-ID 14
     RECT-28 AT ROW 1 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 185.14 BY 24.92
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CMOV B "?" ? INTEGRAL Almcmov
      TABLE: COMPROMETIDOS T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: CUBIERTAS T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: NOCUBIERTAS T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: XTRANSFERIR T "?" NO-UNDO INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "TRANSFERENCIAS AUTOMATICAS"
         HEIGHT             = 24.92
         WIDTH              = 185.14
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* SETTINGS FOR BUTTON BUTTON-TRANSFERIR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-AlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-AlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRANSFERENCIAS AUTOMATICAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRANSFERENCIAS AUTOMATICAS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* INICIO DEL PROCESO */
DO:
  ASSIGN FILL-IN-AlmDes FILL-IN-AlmOri FILL-IN-NomAlmDes FILL-IN-NomAlmOri.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  SESSION:SET-WAIT-STATE('').
  RUN Captura-Temporal IN h_b-ecommerce-transf-cub
    ( INPUT TABLE CUBIERTAS).
  RUN dispatch IN h_b-ecommerce-transf-cub ('open-query':U).
  RUN Captura-Temporal IN h_b-ecommerce-transf-nocub
    ( INPUT TABLE NOCUBIERTAS).
  RUN dispatch IN h_b-ecommerce-transf-nocub ('open-query':U).

  RUN Captura-Temporal IN h_b-ecommerce-transf-artic
    ( INPUT TABLE XTRANSFERIR).
  RUN dispatch IN h_b-ecommerce-transf-artic ('open-query':U).

  RUN Captura-Temporal IN h_b-ecommerce-transf-nocubdet
    ( INPUT TABLE T-DPEDI).
  RUN dispatch IN h_b-ecommerce-transf-nocubdet ('open-query':U).

  IF CAN-FIND(FIRST XTRANSFERIR NO-LOCK) 
      THEN ENABLE BUTTON-TRANSFERIR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-TRANSFERIR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-TRANSFERIR W-Win
ON CHOOSE OF BUTTON-TRANSFERIR IN FRAME F-Main /* PROCEDER CON LA TRANSFERENCIA AUTOMATICA */
DO:
  MESSAGE 'Procedemos con la transferencia automática?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN MASTER-TRANSACTION (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  RUN Limpia-Temporales.
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
             INPUT  'aplic/alm/b-ecommerce-transf-cub.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ecommerce-transf-cub ).
       RUN set-position IN h_b-ecommerce-transf-cub ( 3.96 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ecommerce-transf-cub ( 6.69 , 88.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-ecommerce-transf-nocub.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ecommerce-transf-nocub ).
       RUN set-position IN h_b-ecommerce-transf-nocub ( 3.96 , 97.00 ) NO-ERROR.
       RUN set-size IN h_b-ecommerce-transf-nocub ( 6.69 , 88.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-ecommerce-transf-nocubdet.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ecommerce-transf-nocubdet ).
       RUN set-position IN h_b-ecommerce-transf-nocubdet ( 10.96 , 97.00 ) NO-ERROR.
       RUN set-size IN h_b-ecommerce-transf-nocubdet ( 6.69 , 88.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-ecommerce-transf-artic.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ecommerce-transf-artic ).
       RUN set-position IN h_b-ecommerce-transf-artic ( 17.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ecommerce-transf-artic ( 6.69 , 88.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ecommerce-transf-nocubdet. */
       RUN add-link IN adm-broker-hdl ( h_b-ecommerce-transf-nocub , 'Record':U , h_b-ecommerce-transf-nocubdet ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ecommerce-transf-cub ,
             FILL-IN-NomAlmOri:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ecommerce-transf-nocub ,
             h_b-ecommerce-transf-cub , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ecommerce-transf-nocubdet ,
             h_b-ecommerce-transf-nocub , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ecommerce-transf-artic ,
             h_b-ecommerce-transf-nocubdet , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE COMPROMETIDOS.      /* Cubiertas */
EMPTY TEMP-TABLE XTRANSFERIR.      /* Para transferir */
EMPTY TEMP-TABLE CUBIERTAS.
EMPTY TEMP-TABLE NOCUBIERTAS.
EMPTY TEMP-TABLE T-DPEDI.   

/* Barremos las cotizaciones pendientes de atención */
DEF VAR x-Saldo-por-Atender AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-StkComprometido AS DEC NO-UNDO.
DEF VAR x-PorTransferir AS DEC NO-UNDO.
DEF VAR x-PorComprometer AS DEC NO-UNDO.

PRINCIPAL:
FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}:
    /* Barremos los que tienen saldo por atender */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        x-Saldo-por-Atender = (Facdpedi.CanPed - Facdpedi.CanAte) * Facdpedi.Factor.
        x-StkAct = 0.
        x-StkComprometido = 0.
        /* Veamos si lo cubre el almacén de despacho */
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia AND
            Almmmate.codalm = FILL-IN-AlmDes AND
            Almmmate.codmat = Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
        /* Restamos el stock comprometido */
        RUN gn/stock-comprometido-v2 (Facdpedi.CodMat, 
                                      FILL-IN-AlmDes, 
                                      YES, 
                                      OUTPUT x-StkComprometido).
        x-StkAct = x-StkAct - x-StkComprometido.
        /* Descargarmos el stock reservado para las cotizaciones en curso */
        FIND COMPROMETIDOS WHERE COMPROMETIDOS.codmat = Facdpedi.CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE COMPROMETIDOS THEN x-StkAct = x-StkAct - COMPROMETIDOS.CanDes.
        IF x-StkAct < 0 THEN x-StkAct = 0.
        /* Verificamos si cubre o no */
        x-PorComprometer = MINIMUM(x-StkAct, x-Saldo-por-Atender).
        IF x-PorComprometer > 0 THEN DO:
            /* Almacenamos la cantidad comprometida */
            FIND COMPROMETIDOS WHERE COMPROMETIDOS.CodMat = Facdpedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE COMPROMETIDOS THEN DO:
                CREATE COMPROMETIDOS.
                ASSIGN 
                    COMPROMETIDOS.CodCia = s-CodCia
                    COMPROMETIDOS.CodUnd = Almmmatg.UndStk
                    COMPROMETIDOS.Factor = 1
                    COMPROMETIDOS.CodMat = Facdpedi.CodMat.
            END.
            ASSIGN
                COMPROMETIDOS.CanDes = COMPROMETIDOS.CanDes + x-PorComprometer.
        END.
        IF x-StkAct >= x-Saldo-por-Atender THEN DO:     /* Stock SI cubre la cotización */
            NEXT.   /* Pasamos al siguiente registro */
        END.
        ELSE DO:    /* Stock NO cubre la cotización */
            /* Solo transferimos la diferencia */
            x-Saldo-por-Atender = x-Saldo-por-Atender - x-StkAct.
            x-StkAct = 0.
            x-StkComprometido = 0.
            /* Buscamos en el otro almacén */
            FIND Almmmate WHERE Almmmate.codcia = s-CodCia AND
                Almmmate.codalm = FILL-IN-AlmOri AND
                Almmmate.codmat = Facdpedi.CodMat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
            /* Restamos el stock comprometido */
            RUN gn/stock-comprometido-v2 (Facdpedi.CodMat, 
                                          FILL-IN-AlmOri, 
                                          YES, 
                                          OUTPUT x-StkComprometido).
            x-StkAct = x-StkAct - x-StkComprometido.
            /* Descargarmos el stock reservado para las transferencias en curso */
            FIND XTRANSFERIR WHERE XTRANSFERIR.codmat = Facdpedi.CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE XTRANSFERIR THEN x-StkAct = x-StkAct - XTRANSFERIR.CanDes.
            IF x-StkAct < 0 THEN x-StkAct = 0.
            /* Transferimos lo que se pueda */
            x-PorTransferir = MINIMUM(x-StkAct, x-Saldo-por-Atender).
            IF x-PorTransferir > 0 THEN DO:
                /* Almacenamos la cantidad a transferir */
                FIND XTRANSFERIR WHERE XTRANSFERIR.CodMat = Facdpedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE XTRANSFERIR THEN DO:
                    CREATE XTRANSFERIR.
                    ASSIGN 
                        XTRANSFERIR.CodCia = s-CodCia
                        XTRANSFERIR.CodUnd = Almmmatg.UndStk
                        XTRANSFERIR.Factor = 1
                        XTRANSFERIR.CodMat = Facdpedi.CodMat.
                END.
                ASSIGN
                    XTRANSFERIR.CanDes = XTRANSFERIR.CanDes + x-PorTransferir.
            END.
            x-Saldo-por-Atender = x-Saldo-por-Atender - x-PorTransferir.
            IF x-Saldo-por-Atender > 0 THEN DO:
                /* NO SE PUDO CUBRIR ESTE ARTICULO */
                CREATE T-DPEDI.
                BUFFER-COPY Facdpedi TO T-DPEDI.
                ASSIGN T-DPEDI.CanSol = x-Saldo-por-Atender.
            END.
        END.
    END.
    /* Verificamos que TODA la Cotización puede ser despachada */
    IF NOT CAN-FIND(FIRST T-DPEDI OF FacCPedi NO-LOCK) THEN DO:
        /* Control de Cotizaciones Cubiertas */
        CREATE CUBIERTAS.
        BUFFER-COPY Faccpedi TO CUBIERTAS.
    END.
    ELSE DO:
        /* Control de NO CUBIERTAS */
        CREATE NOCUBIERTAS.
        BUFFER-COPY Faccpedi TO NOCUBIERTAS.
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
  DISPLAY FILL-IN-AlmDes FILL-IN-NomAlmDes FILL-IN-AlmOri FILL-IN-NomAlmOri 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-28 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INGRESO-POR-TRANSFERENCIA W-Win 
PROCEDURE INGRESO-POR-TRANSFERENCIA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-CorrIng LIKE Almacen.CorrSal NO-UNDO.
DEF VAR N-Itm AS INTEGER NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
        Almtdocm.CodAlm = FILL-IN-AlmDes AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = 03" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        }
    FIND CMOV WHERE ROWID(CMOV) = pRowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        x-CorrIng  = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-CorrIng
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-CorrIng = x-CorrIng + 1.
    END.
    /* MOVIMIENTO DE SALIDA */
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = s-CodCia 
        Almcmov.CodAlm = FILL-IN-AlmDes
        Almcmov.AlmDes = FILL-IN-AlmOri
        Almcmov.NroRf1 = STRING(CMOV.NroSer, '999') + STRING(CMOV.NroDoc)
        Almcmov.TipMov = "I"
        Almcmov.CodMov = 03
        Almcmov.NroSer = 000
        Almcmov.Nrodoc  = x-CorrIng
        Almcmov.FlgSit  = ""
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.usuario = S-USER-ID.
    ASSIGN 
        Almtdocm.NroDoc = x-CorrIng + 1.
    FOR EACH XTRANSFERIR NO-LOCK:
        N-Itm = N-Itm + 1.
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = XTRANSFERIR.codmat
            Almdmov.CanDes = XTRANSFERIR.CanDes
            Almdmov.CodUnd = XTRANSFERIR.CodUnd
            Almdmov.Factor = XTRANSFERIR.Factor
            Almdmov.NroItm = N-Itm 
            Almdmov.ImpCto = XTRANSFERIR.ImpCto 
            Almdmov.PreUni = XTRANSFERIR.PreUni 
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = almcmov.HorRcp
            R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        RUN ALM\ALMACPR1 (R-ROWID,"U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 

    END.
    ASSIGN 
      CMOV.FlgSit  = "R" 
      CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
      CMOV.NroRf2  = STRING(Almcmov.NroDoc).

    RELEASE Almtdocm.
    RELEASE CMOV.
    RELEASE Almcmov.
    RELEASE Almdmov.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Temporales W-Win 
PROCEDURE Limpia-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE CUBIERTAS.
  EMPTY TEMP-TABLE NOCUBIERTAS.
  EMPTY TEMP-TABLE XTRANSFERIR.
  EMPTY TEMP-TABLE T-DPEDI.
  RUN Captura-Temporal IN h_b-ecommerce-transf-cub
    ( INPUT TABLE CUBIERTAS).
  RUN dispatch IN h_b-ecommerce-transf-cub ('open-query':U).
  RUN Captura-Temporal IN h_b-ecommerce-transf-nocub
    ( INPUT TABLE NOCUBIERTAS).
  RUN dispatch IN h_b-ecommerce-transf-nocub ('open-query':U).
  RUN Captura-Temporal IN h_b-ecommerce-transf-artic
    ( INPUT TABLE XTRANSFERIR).
  RUN dispatch IN h_b-ecommerce-transf-artic ('open-query':U).
  RUN Captura-Temporal IN h_b-ecommerce-transf-nocubdet
    ( INPUT TABLE T-DPEDI).
  RUN dispatch IN h_b-ecommerce-transf-nocubdet ('open-query':U).

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
  FILL-IN-AlmDes = x-AlmDes.
  FILL-IN-NomAlmDes = x-NomAlmDes.
  FILL-IN-AlmOri = x-AlmOri.
  FILL-IN-NomAlmOri = x-NomAlmOri.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pRowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN SALIDA-POR-TRANSFERENCIA (OUTPUT pRowid, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la salida por transferencia'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    RUN INGRESO-POR-TRANSFERENCIA (INPUT pRowid, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar el ingreso por transferencia'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SALIDA-POR-TRANSFERENCIA W-Win 
PROCEDURE SALIDA-POR-TRANSFERENCIA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
DEF VAR N-Itm AS INTEGER NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Almacen" ~
        &Condicion="Almacen.CodCia = s-CodCia AND ~
        Almacen.CodAlm = FILL-IN-AlmOri" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN 
        x-CorrSal  = Almacen.CorrSal.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = s-CodCia
                        AND Almcmov.CodAlm = FILL-IN-AlmOri 
                        AND Almcmov.TipMov = "S"
                        AND Almcmov.CodMov = 03
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-CorrSal
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN 
            x-CorrSal = x-CorrSal + 1.
    END.
    ASSIGN
        Almacen.CorrSal = x-CorrSal + 1.
    /* MOVIMIENTO DE SALIDA */
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = s-CodCia 
        Almcmov.CodAlm = FILL-IN-AlmOri
        Almcmov.AlmDes = FILL-IN-AlmDes
        Almcmov.TipMov = "S"
        Almcmov.CodMov = 03
        Almcmov.NroSer = 000
        Almcmov.Nrodoc = x-CorrSal
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.NomRef = FILL-IN-NomAlmDes
        Almcmov.FlgSit = "R"      /* Recepcionado */
        Almcmov.usuario = S-USER-ID.
    ASSIGN
        pRowid = ROWID(Almcmov).
    FOR EACH XTRANSFERIR NO-LOCK:
        N-Itm = N-Itm + 1.
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.HraDoc = almcmov.HorSal
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = XTRANSFERIR.codmat
            Almdmov.CanDes = XTRANSFERIR.CanDes
            Almdmov.CodUnd = XTRANSFERIR.CodUnd
            Almdmov.Factor = XTRANSFERIR.Factor
            Almdmov.ImpCto = XTRANSFERIR.ImpCto
            Almdmov.PreUni = XTRANSFERIR.PreUni
            Almdmov.AlmOri = Almcmov.AlmDes
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = HorSal
            Almdmov.NroItm = N-Itm
            R-ROWID = ROWID(Almdmov).
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        RUN ALM\ALMACPR1 (R-ROWID,"U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    RELEASE Almacen.
    RELEASE Almcmov.
    RELEASE Almdmov.
END.
RETURN 'OK'.

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

