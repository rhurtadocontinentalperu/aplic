&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE CDocu LIKE VtaCDocu.
DEFINE NEW SHARED TEMP-TABLE DDocu LIKE VtaDDocu.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodPed AS CHAR INIT 'PNX'.    /* Pedidos por Nextel */

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone BUTTON-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cdocu AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-ddocu AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 7 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/tbldat.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62 TOOLTIP "Importar Texto".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/tbldef.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62 TOOLTIP "Generar COTIZACIONES".

DEFINE BUTTON BUTTON-4 
     LABEL "ELIMINAR" 
     SIZE 12 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 3 WIDGET-ID 2
     BUTTON-2 AT ROW 1 COL 10 WIDGET-ID 4
     BtnDone AT ROW 1 COL 17 WIDGET-ID 6
     BUTTON-4 AT ROW 5.31 COL 109 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121 BY 16.15 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CDocu T "NEW SHARED" ? INTEGRAL VtaCDocu
      TABLE: DDocu T "NEW SHARED" ? INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR VENTAS POR NEXTEL"
         HEIGHT             = 16.15
         WIDTH              = 121
         MAX-HEIGHT         = 16.15
         MAX-WIDTH          = 121
         VIRTUAL-HEIGHT     = 16.15
         VIRTUAL-WIDTH      = 121
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR VENTAS POR NEXTEL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR VENTAS POR NEXTEL */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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
   RUN Carga-Temporales.
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   ASSIGN
       BUTTON-1:SENSITIVE = NO
       BUTTON-2:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Genera-Cotizaciones.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  EMPTY TEMP-TABLE CDocu.
  EMPTY TEMP-TABLE DDocu.
  RUN dispatch IN h_b-cdocu ('open-query':U).
  RUN dispatch IN h_b-ddocu ('open-query':U).
  ASSIGN
      BUTTON-1:SENSITIVE = YES
      BUTTON-2:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ELIMINAR */
DO:
  RUN Borra-Registro IN h_b-cdocu.
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
             INPUT  'aplic/nxtl/b-cdocu.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cdocu ).
       RUN set-position IN h_b-cdocu ( 2.88 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-cdocu ( 6.69 , 105.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/nxtl/b-ddocu.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ddocu ).
       RUN set-position IN h_b-ddocu ( 9.88 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-ddocu ( 6.69 , 79.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ddocu. */
       RUN add-link IN adm-broker-hdl ( h_b-cdocu , 'Record':U , h_b-ddocu ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cdocu ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ddocu ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

/* solicitamos el archivo texto */
DEF VAR x-Pedido AS CHAR INIT 'pedido.txt'.
DEF VAR x-Detalle AS CHAR INIT 'detalle_pedido.txt'.
DEF VAR x-Ok AS LOG.

SYSTEM-DIALOG GET-FILE x-Pedido
    FILTERS 'Texto' '*.txt' 
    DEFAULT-EXTENSION '.txt' 
    MUST-EXIST 
    TITLE 'SELECCIONE EL ARCHIVO QUE CONTIENE LA CABECERA'
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN 'ADM-ERROR'.
SYSTEM-DIALOG GET-FILE x-Detalle
    FILTERS 'Texto' '*.txt' 
    DEFAULT-EXTENSION '.txt' 
    MUST-EXIST 
    TITLE 'SELECCIONE EL ARCHIVO QUE CONTIENE EL DETALLE'
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN 'ADM-ERROR'.

/* cargamos los temporales */
EMPTY TEMP-TABLE CDOCU.
EMPTY TEMP-TABLE DDOCU.

DEF VAR x-Linea AS CHAR FORMAT 'x(100)'.
DEF VAR x-Fecha AS DATETIME.


INPUT FROM VALUE(x-Pedido).
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea <> '' THEN DO:
        /* verificamos que no se halla migrado antes */
        FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia
            AND Vtacdocu.codped = s-codped
            AND Vtacdocu.nroped = ENTRY(1, x-linea, '|')
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtacdocu THEN DO:
            IF Vtacdocu.FlgEst = "P" THEN DO:
                MESSAGE 'El Pedido' ENTRY(1, x-linea, '|') 'tiene una COTIZACION activa' SKIP
                    'Importación abortada' VIEW-AS ALERT-BOX WARNING.
                NEXT.
            END.
            MESSAGE 'YA se ha importado el pedido' ENTRY(1, x-linea, '|') SKIP
                'Lo volvemos a importar?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN NEXT.
        END.
        CREATE CDOCU.
        ASSIGN
            CDOCU.codcia = s-codcia
            CDOCU.coddiv = s-coddiv
            CDOCU.codped = s-codped
            CDOCU.nroped = ENTRY(1, x-linea, '|')
            CDOCU.codven = ENTRY(2, x-linea, '|')
            CDOCU.codcli = ENTRY(3, x-linea, '|')
            CDOCU.fmapgo = ENTRY(5, x-linea, '|')
            CDOCU.imptot = DECIMAL ( ENTRY(6, x-linea, '|') )
            CDOCU.fchped = DATE( INTEGER (SUBSTRING (ENTRY(7, x-linea, '|'), 5, 2)),
                                 INTEGER (SUBSTRING (ENTRY(7, x-linea, '|'), 7, 2)),
                                 INTEGER (SUBSTRING (ENTRY(7, x-linea, '|'), 1, 4)) ).
    END.
END.
INPUT CLOSE.

INPUT FROM VALUE(x-Detalle).
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea <> '' THEN DO:
        CREATE DDOCU.
        ASSIGN
            DDOCU.codcia = s-codcia
            DDOCU.codped = 'PNX'
            DDOCU.coddiv = s-coddiv
            DDOCU.nroped = ENTRY(1, x-linea, '|')
            DDOCU.codmat = ENTRY(6, x-linea, '|')
            DDOCU.canped = DECIMAL (ENTRY(7, x-linea, '|'))
            DDOCU.implin = DECIMAL ( ENTRY(8, x-linea, '|') ).
    END.
END.
INPUT CLOSE.

RUN dispatch IN h_b-cdocu ('open-query':U).

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
  ENABLE BUTTON-1 BtnDone BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cotizaciones W-Win 
PROCEDURE Genera-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Procedemos a generar las cotizaciones?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN 'ADM-ERROR'.

DEF VAR s-coddoc AS CHAR INIT 'COT'.
DEF VAR s-nroser AS INT.
DEF VAR S-CODIGV AS INTEGER INITIAL 1.
DEF VAR s-PorIgv LIKE Ccbcdocu.PorIgv.
DEF VAR s-TpoPed AS CHAR INIT 'NXTL'.       /* Pedidos por NEXTEL */
DEF VAR I-NITEM  AS INTEGER INIT 0.
DEF VAR f-Factor AS DEC INIT 1.
DEF VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDoc = s-CodDoc 
    AND FacCorre.CodDiv = s-CodDiv
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está definido el correlativo para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.nroser
    s-PorIgv = FacCfgGn.PorIgv.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH CDocu, FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = CDocu.codcli NO-LOCK:
        FIND gn-convt WHERE gn-convt.Codig = SUBSTRING(CDocu.FmaPgo,2) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN DO:
            MESSAGE "Condicion Venta no existe para el pedido" CDocu.nroped SKIP
                "Generación abortada" VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN "ADM-ERROR".   
        END.

        /* CABECERA */
        {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
        CREATE FacCPedi.
        BUFFER-COPY CDocu TO FacCPedi.
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = S-CODDOC 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodAlm = s-CodAlm
            FacCPedi.FchPed = TODAY 
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FchEnt = TODAY
            FacCPedi.FchVen  = (TODAY + s-DiasVtoCot)
            FacCPedi.FlgIgv = YES
            FacCPedi.PorIgv = s-PorIgv
            FacCPedi.TpoPed = s-TpoPed
            FacCPedi.CodRef = CDocu.CodPed
            FacCPedi.NroRef = CDocu.NroPed
            FacCPedi.FmaPgo = SUBSTRING(CDocu.FmaPgo,2).
            /*
            FacCPedi.FlgEst = "X".    /* POR APROBAR */
            */
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN 
            FacCPedi.NomCli = gn-clie.nomcli
            FacCPedi.RucCli = gn-clie.ruc
            FacCPedi.DirCli = gn-clie.dircli
            FacCPedi.NroCard = gn-clie.NroCard
            FacCPedi.CodPos = gn-clie.Codpos
            FacCPedi.CodMon = 1
            FacCPedi.Usuario = S-USER-ID.
        IF FacCPedi.RucCli = '' THEN Faccpedi.Cmpbnte = 'BOL'.
        ELSE Faccpedi.Cmpbnte = 'FAC'.
        FIND TcmbCot WHERE  TcmbCot.Codcia = 0
            AND (TcmbCot.Rango1 <= gn-convt.totdias
                 AND  TcmbCot.Rango2 >= gn-convt.totdias)
            NO-LOCK NO-ERROR.
        IF AVAIL TcmbCot THEN FacCPedi.TpoCmb = TcmbCot.TpoCmb.

        /* DETALLE */
        I-NITEM = 0.
        FOR EACH DDocu OF CDocu, FIRST Almmmatg OF DDocu NO-LOCK:
            I-NITEM = I-NITEM + 1.
            ASSIGN 
                DDocu.CodCia = S-CODCIA
                DDocu.Factor = F-FACTOR
                DDocu.UndVta = Almmmatg.Chr__01
                DDocu.PreBas = DDocu.ImpLin / DDocu.CanPed
                DDocu.AftIgv = Almmmatg.AftIgv 
                DDocu.AftIsc = Almmmatg.AftIsc 
                DDocu.PreUni = DDocu.ImpLin / DDocu.CanPed
                DDocu.NroItm = I-NITEM.
            IF DDocu.AftIgv 
            THEN DDocu.ImpIgv = DDocu.ImpLin - ROUND( DDocu.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
            
            CREATE FacDPedi.
            BUFFER-COPY DDocu TO FacDPedi
                ASSIGN
                    FacDPedi.CodCia = FacCPedi.CodCia
                    FacDPedi.CodDiv = FacCPedi.CodDiv
                    FacDPedi.coddoc = FacCPedi.coddoc
                    FacDPedi.NroPed = FacCPedi.NroPed
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.AlmDes = FacCPedi.CodAlm
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst.
        END.
        {vta2/graba-totales-ped.i}

        /* Guardamos un control de las migraciones */
        FIND Vtacdocu OF CDocu EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtacdocu THEN CREATE Vtacdocu.
        BUFFER-COPY CDocu TO Vtacdocu
            ASSIGN
                VtaCDocu.CodRef = FacCPedi.CodDoc
                VtaCDocu.NroRef = FacCPedi.NroPed
                VtaCDocu.NomCli = gn-clie.nomcli
                Vtacdocu.usuario = s-user-id
                VtaCDocu.FchCre = DATETIME(TODAY, MTIME)
                VtaCDocu.FlgEst = "P".  /* Con cotización */
        FOR EACH Vtaddocu OF Vtacdocu:
            DELETE Vtaddocu.
        END.
        FOR EACH DDocu OF CDocu:
            CREATE Vtaddocu.
            BUFFER-COPY DDocu TO Vtaddocu.
        END.

    END.
END.
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE FacCPedi.
IF AVAILABLE(Facdpedi) THEN RELEASE FacDPedi.
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.

RETURN 'OK'.

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

