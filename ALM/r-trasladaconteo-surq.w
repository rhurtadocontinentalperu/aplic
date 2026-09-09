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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE VARIABLE cPaginas AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-datos
    FIELDS t-codmat LIKE almmmatg.codmat
    FIELDS t-codbrr LIKE almmmatg.codbrr
    FIELDS t-codubi AS CHAR FORMAT 'X(20)'
    FIELDS t-cancon AS DEC    
    FIELDS t-codcon AS CHAR 
    FIELDS t-codsup AS CHAR 
    FIELDS t-codusr AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "Trasladar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70.29 BY .88
     FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-msj AT ROW 3.15 COL 3.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-3 AT ROW 4.58 COL 47 WIDGET-ID 2
     BUTTON-4 AT ROW 4.58 COL 63 WIDGET-ID 6
     "Traslada la información al las tablas de inventario" VIEW-AS TEXT
          SIZE 43 BY .81 AT ROW 2.08 COL 6 WIDGET-ID 4
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.43 BY 5.15 WIDGET-ID 100.


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
         TITLE              = "Traslada información Conteo"
         HEIGHT             = 5.15
         WIDTH              = 78.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Traslada información Conteo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Traslada información Conteo */
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
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Trasladar */
DO:
  
    RUN Valida-Conteo.
    IF cPaginas = '' THEN RUN Carga-Datos.
    ELSE DO:
        MESSAGE 'Debe completarse el conteo para ejecutar ' SKIP
                'esta opción Faltan las siguientes páginas' SKIP
                cPaginas
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "adm-error".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tabla W-Win 
PROCEDURE Actualiza-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDif    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lCrea   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE iNroPag AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroSec AS INTEGER     NO-UNDO.

    FOR EACH tt-datos NO-LOCK:
        lCrea = NO.
        /*Buca Articulo en master*/
        FIND FIRST almdinv WHERE almdinv.codcia = s-codcia
            AND almdinv.codalm = '10'
            AND almdinv.nomcia = 'CONTI'
            AND almdinv.codmat = tt-datos.t-codmat NO-ERROR.
        IF AVAIL almdinv THEN DO:
            ASSIGN 
                AlmDInv.QtyConteo  = t-cancon
                AlmDInv.Libre_d01  = t-cancon
                AlmDInv.CodUserCon = t-codcon
                AlmDInv.FecCon     = DATETIME(TODAY,MTIME)
                AlmDInv.Libre_c01  = t-codubi.      /*Gondolas*/
            IF (AlmDInv.QtyConteo - AlmDInv.QtyFisico) <> 0 AND lDif = NO 
                THEN lDif = YES.

            /****Actualiza Cabecera****/
            FIND FIRST almcinv OF almdinv NO-ERROR.
            IF AVAIL almcinv THEN DO:
                ASSIGN
                    AlmCInv.SwConteo     = YES
                    AlmCInv.CodUser      = t-codusr
                    AlmCInv.CodAlma      = t-codsup         /*supervisado por*/
                    AlmCInv.CodUserCon   = t-codcon         /*contado por */ .
                IF lDif = NO THEN AlmCInv.SwDiferencia = lDif.
            END.
        END.
        /****************/
        ELSE DO:
            /*Busca Ultimo ingreso manual*/
            FIND LAST AlmDInv WHERE AlmDInv.CodCia = s-codcia
                AND AlmDInv.Codalm = '10'
                AND AlmDInv.NomCia = 'CONTI'
                AND AlmDInv.NroPag >= 9000 NO-LOCK NO-ERROR.
            IF NOT AVAIL AlmDInv THEN 
                ASSIGN 
                    iNroPag = 9000
                    iNroSec = 1
                    lCrea = YES.
            ELSE DO:
                IF AlmDInv.NroSec = 25 THEN DO:
                    ASSIGN 
                        iNroPag = AlmDInv.NroPagina + 1
                        iNroSec = AlmDInv.NroSec + 1
                        lCrea = YES.
                END.
                ELSE DO:
                    ASSIGN 
                        iNroPag = AlmDInv.NroPagina
                        iNroSec = AlmDInv.NroSec + 1
                        lCrea = YES.
                END.
            END.
            
            IF lCrea THEN DO:
                FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-codcia
                    AND AlmCInv.CodAlm = '10'
                    AND AlmCInv.NomCia = 'CONTI'
                    AND AlmCInv.NroPagina = iNroPag NO-LOCK NO-ERROR.
                IF NOT AVAIL AlmCInv THEN DO:
                    /*CAbecera*/
                    CREATE AlmCInv.
                    ASSIGN
                        AlmCInv.CodCia    = s-CodCia
                        AlmcInv.CodAlm    = "10"
                        AlmcInv.NroPagina = iNroPag
                        AlmcInv.NomCia    = "CONTI"
                        AlmCInv.SwConteo  = YES
                        AlmCInv.CodUser   = t-codusr
                        AlmCInv.FecUpdate = TODAY
                        AlmCInv.CodUserCon = t-codcon
                        AlmCInv.CodAlma    = t-codsup
                        AlmCInv.CodUser    = t-codusr. 
                END.
                
                /*Detalle*/
                CREATE AlmDInv.
                ASSIGN
                    AlmDInv.Codcia       = s-codcia
                    AlmDInv.CodAlm       = '10'
                    AlmDInv.NomCia       = "CONTI"
                    AlmDInv.CodMat       = t-codmat
                    /*AlmDInv.CodUbi       = t-codubi*/
                    AlmDInv.CodUserCon   = t-codcon
                    AlmDInv.Libre_c01    = t-codubi
                    AlmDInv.NroPagina    = iNroPag
                    AlmDInv.NroSecuencia = iNroSec
                    AlmDInv.QtyFisico    = 0
                    AlmDInv.FecCon       = TODAY
                    AlmDInv.Libre_f01    = TODAY
                    AlmDInv.QtyConteo    = t-cancon
                    AlmDInv.Libre_d01    = t-cancon.
            END.
        END.
        DISPLAY "ACTUALIZANDO " + t-codmat @ txt-msj
            WITH FRAME {&FRAME-NAME}.
    END.

    /*Actualiza Hojas Conteo*/
    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
        AND AlmCInv.CodAlm = '10'
        AND AlmCInv.NomCia = 'CONTI'
        AND AlmCInv.SwConteo = NO :
        ASSIGN AlmCInv.SwConteo = YES. 
    END.

    RELEASE AlmCInv.
    RELEASE AlmDInv.

    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-datos.

    FOR EACH almcinv WHERE almcinv.codcia = s-codcia
        AND almcinv.codalm = '10x'
        AND almcinv.nomcia = 'UTILEX'
        AND almcinv.swconteo NO-LOCK,
        EACH almdinv OF almcinv NO-LOCK:
        FIND FIRST tt-datos WHERE t-codmat = almdinv.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            CREATE tt-datos.
            ASSIGN 
                t-codmat = almdinv.codmat
                t-codbrr = almdinv.libre_c01
                t-codubi = almdinv.codubi
                t-cancon = almdinv.qtyconteo
                t-codcon = almCinv.CodUserCon 
                t-codsup = AlmCInv.CodAlma
                t-codusr = AlmCInv.CodUser.
        END.
        ELSE DO:
            ASSIGN 
                t-codubi = t-codubi + ',' + almdinv.codubi
                t-cancon = t-cancon + almdinv.qtyconteo.
        END.

        DISPLAY "CARGANDO " + t-codmat @ txt-msj
            WITH FRAME {&FRAME-NAME}.

    END.

    RUN Actualiza-Tabla.

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
  DISPLAY txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-3 BUTTON-4 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Conteo W-Win 
PROCEDURE Valida-Conteo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH almcinv WHERE almcinv.codcia = s-codcia
        AND almcinv.codalm = '10x'
        AND almcinv.nomcia = 'UTILEX'
        AND almcinv.swconteo = NO NO-LOCK:
        IF cPaginas = ''  THEN cPaginas = STRING(AlmCInv.NroPagina).
        ELSE cPaginas = cPaginas + "," + STRING(AlmCInv.NroPagina).
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

