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

DEFINE TEMP-TABLE tt-DataSurquillo
    FIELDS t-codubi AS CHAR
    FIELDS t-codbrr LIKE almmmatg.codbrr
    FIELDS t-nrosec AS INT.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Importa Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71.29 BY 1
     BGCOLOR 8 FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-mensaje AT ROW 3.35 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     BUTTON-1 AT ROW 4.5 COL 47 WIDGET-ID 2
     BUTTON-2 AT ROW 4.5 COL 62 WIDGET-ID 4
     "Esta opción le permite cargar la información del excel en las tablas de inventar" VIEW-AS TEXT
          SIZE 69 BY 1.08 AT ROW 1.81 COL 7 WIDGET-ID 6
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 5.38 WIDGET-ID 100.


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
         TITLE              = "Carga Información Gondolas"
         HEIGHT             = 5.38
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga Información Gondolas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga Información Gondolas */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Importa Excel */
DO:
  RUN Importa-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cancelar */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Datos W-Win 
PROCEDURE Borra-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Borra Datos del 10T*/
    FOR EACH almcinv WHERE almcinv.codcia = s-codcia 
        AND almcinv.codalm = '10X'
        AND almcinv.nomcia = 'UTILEX' :
        DELETE almcinv.
    END.
    FOR EACH almdinv WHERE almdinv.codcia = s-codcia 
        AND almdinv.codalm = '10X' 
        AND almdinv.nomcia = 'UTILEX' :
        DELETE almdinv.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crear-Tabla2 W-Win 
PROCEDURE Crear-Tabla2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAlmacen AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCia  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNroPag  AS INTEGER INIT 1  NO-UNDO.
    DEFINE VARIABLE iNroSec  AS INTEGER INIT 1  NO-UNDO.
    DEFINE VARIABLE lFlag    AS LOGICAL     NO-UNDO.

    RUN Borra-Datos.

    ASSIGN 
        cAlmacen = '10X'
        cNomCia  = 'UTILEX'.

    Datos:
    FOR EACH tt-DataSurquillo NO-LOCK
        BREAK BY t-codubi 
            BY t-nrosec:

        IF LENGTH(t-codbrr) <= 6 THEN DO:
            FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia
                AND Almmmatg.CodMat = t-codbrr NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia
                AND Almmmatg.CodBrr = t-codbrr NO-LOCK NO-ERROR.
        END.
        
        IF AVAIL Almmmatg THEN DO:
            /*********Creando Cabecera**********/
            FIND FIRST AlmCInv WHERE 
                AlmCInv.CodCia    = s-codcia AND
                AlmCInv.CodAlm    = cAlmacen AND
                AlmCInv.NroPagina = iNroPag AND
                AlmCInv.NomCia    = cNomCia NO-LOCK NO-ERROR.
            IF NOT AVAILABLE AlmCInv THEN DO:
                CREATE AlmCInv.
                ASSIGN
                    AlmCInv.CodCia    = s-CodCia
                    AlmCInv.CodAlm    = cAlmacen
                    AlmCInv.NroPagina = iNroPag
                    AlmCInv.NomCia    = cNomCia
                    AlmCInv.FecUpdate = TODAY.
            END.
            /****************************************/
        
            /********Creando Detalle Tabla***********/
            FIND FIRST almdinv WHERE AlmDInv.CodCia = s-CodCia
                AND AlmDInv.CodAlm       = cAlmacen
                AND AlmDInv.CodUbi       = t-CodUbi
                AND AlmDInv.NroPagina    = iNroPag
                /*AND AlmDInv.NroSecuencia = iNroSec*/
                AND AlmDInv.NomCia       = cNomcia   
                AND AlmDInv.CodMat       = Almmmatg.CodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE AlmDInv THEN DO:
                CREATE AlmDInv.
                ASSIGN
                    AlmDInv.CodCia       = s-codcia
                    AlmDInv.CodAlm       = cAlmacen
                    AlmDInv.CodUbi       = t-CodUbi
                    AlmDInv.NroPagina    = iNroPag
                    AlmDInv.NroSecuencia = iNroSec
                    AlmDInv.NomCia       = cNomCia
                    AlmDInv.CodMat       = Almmmatg.CodMat
                    AlmDInv.Libre_c01    = t-codbrr
                    AlmDInv.Libre_f01    = TODAY.
                iNroSec = iNroSec + 1.            
            END.   
            lFlag = YES.
        END.

        /*Salto por Ubicacion*/
        IF lFlag THEN DO:
            IF LAST-OF(t-codubi) THEN DO:            
                ASSIGN
                    iNroPag = iNroPag + 1       
                    iNroSec = 1
                    lFlag   = NO.
            END.
            ELSE DO:
                IF (iNroSec - 1) MOD 25 = 0 THEN DO: 
                    iNroPag = iNroPag + 1.       
                    iNroSec = 1.
                END.
            END.
        END.
        
        DISPLAY "CARGANDO TABLA DE INVENTARIOS" @ txt-mensaje
            WITH FRAME {&FRAME-NAME}.

        PAUSE 0.
    END.

    /*Actualiza tabla InvConfig*/
    FIND InvConfig WHERE InvConfig.CodCia = s-CodCia
        AND InvConfig.CodAlm = cAlmacen
        AND InvConfig.FchInv = TODAY NO-LOCK NO-ERROR.
    IF NOT AVAIL InvConfig THEN DO:
            CREATE InvConfig.
            ASSIGN
                InvConfig.CodCia  =  s-CodCia
                InvConfig.CodAlm  =  cAlmacen
                InvConfig.FchInv  =  TODAY
                InvConfig.TipInv  =  'T'
                InvConfig.Usuario =  s-user-id.    
    END.

    MESSAGE 'Proceso Terminado'
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    DISPLAY "" @ txt-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importa-Excel W-Win 
PROCEDURE Importa-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE OKpressed       AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file    AS CHAR NO-UNDO.
DEFINE VAR F-CTOLIS             AS DECIMAL NO-UNDO.
DEFINE VAR F-CTOTOT             AS DECIMAL NO-UNDO.
DEFINE VAR iInt                 AS INT.
DEFINE VAR cCeros               AS CHAR.
DEFINE VAR iSec                 AS INT     NO-UNDO INIT 1.  

EMPTY TEMP-TABLE tt-DataSurquillo.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCountLine   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValue       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE dValue       AS DECIMAL     NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        cValue = STRING(INTEGER (cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Código' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    ELSE DO:
        CREATE tt-DataSurquillo.
        ASSIGN t-codubi = cValue.
    END.
    /* CODIGO BARRAS */
    cRange = "B" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.

    /***RDP - Completa Digitos *****
    cCeros = "0".
    IF LENGTH(STRING(cValue)) >= 6 THEN DO:
        DO iint = 2 TO (13 - LENGTH(cValue)): 
            cCeros = cCeros + "0".
        END.
    END.
    ELSE DO:
        DO iint = 2 TO (6 - LENGTH(cValue)): 
            cCeros = cCeros + "0".
       END.
    END.
    IF LENGTH(cValue) = 13 THEN ASSIGN t-codbrr = STRING(cValue).
    ELSE ASSIGN t-codbrr = cCeros + STRING(cValue).
    ****RDP *****************/
    dValue = DEC(cValue).
    cValue = STRING(TRUNCATE(dValue,0)).
    ASSIGN t-codbrr = cValue.
    
    /* NUMERO SECUENCIA */
    cRange = "C" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN t-nrosec = INT(iSec).
    iSec = iSec + 1.

    DISPLAY "CARGANDO LA INFORMACIÓN DEL EXCEL..." @ txt-mensaje
        WITH FRAME {&FRAME-NAME}.
END.

RUN Crear-Tabla2.

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

