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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cant     AS INT.


/* Local Variable Definitions ---                                       */

DEFINE VAR s-task-no    AS INTEGER NO-UNDO.
DEFINE VAR i-nro        AS INTEGER NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rs-coddoc txt-nroped txt-bultos BUTTON-1 ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS rs-coddoc txt-nroped txt-nomcli txt-bultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "IMPRIMIR" 
     SIZE 8 BY 1.69.

DEFINE VARIABLE txt-bultos AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Nro. Bultos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1
     BGCOLOR 7 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE txt-nroped AS CHARACTER FORMAT "999999999":U 
     LABEL "Nro Documento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rs-coddoc AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pedido", "PED",
"Pedido Mostrador", "P/M",
"Transferencia", "TRA",
"Guia Remisión", "G/R"
     SIZE 31 BY 3.23 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-coddoc AT ROW 1.46 COL 18 NO-LABEL WIDGET-ID 24
     txt-nroped AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 2
     txt-nomcli AT ROW 6.12 COL 16 COLON-ALIGNED WIDGET-ID 6
     txt-bultos AT ROW 7.19 COL 16 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 8.81 COL 56 WIDGET-ID 8
     BtnDone AT ROW 8.81 COL 65 WIDGET-ID 22
     "Documento:" VIEW-AS TEXT
          SIZE 11 BY .96 AT ROW 1.38 COL 5.86 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.57 BY 9.92 WIDGET-ID 100.


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
         TITLE              = "Rótulos por Documentos"
         HEIGHT             = 9.92
         WIDTH              = 77.57
         MAX-HEIGHT         = 10.42
         MAX-WIDTH          = 77.57
         VIRTUAL-HEIGHT     = 10.42
         VIRTUAL-WIDTH      = 77.57
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
/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Rótulos por Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Rótulos por Documentos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* IMPRIMIR */
DO:
    ASSIGN txt-nroped
           txt-bultos
           rs-coddoc.

    RUN Print.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-coddoc W-Win
ON VALUE-CHANGED OF rs-coddoc IN FRAME F-Main
DO:
  ASSIGN rs-coddoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-nroped
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-nroped W-Win
ON LEAVE OF txt-nroped IN FRAME F-Main /* Nro Documento */
DO:
    DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
    ASSIGN txt-nroped rs-coddoc.
    cNomCli = ''.
    CASE rs-coddoc:
        WHEN "PED" THEN DO:
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
                /*AND faccpedi.coddiv = s-coddiv*/
                AND faccpedi.coddoc = rs-coddoc
                AND faccpedi.nroped = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "entry" TO txt-nroped.
                RETURN "adm-error".
            END.
            cNomCli = faccpedi.nomcli.
        END.
        WHEN "P/M" THEN DO:
            FIND FIRST faccpedm WHERE faccpedm.codcia = s-codcia
                /*AND faccpedm.coddiv = s-coddiv*/
                AND faccpedm.coddoc = rs-coddoc
                AND faccpedm.nroped = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedm THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "entry" TO txt-nroped.
                RETURN "adm-error".
            END.
            cNomCli = faccpedm.nomcli.
        END.
        WHEN "TRA" THEN DO:
            FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
                FIND almcmov WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = Almacen.codalm
                    AND almcmov.tipmov = 'S'
                    AND almcmov.codmov = 03
                    AND almcmov.nroser = INTEGER(SUBSTRING (txt-nroped:SCREEN-VALUE, 1, 3) )
                    AND almcmov.nrodoc = INTEGER(SUBSTRING (txt-nroped:SCREEN-VALUE, 4) )
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almcmov THEN LEAVE.
            END.
            IF NOT AVAILABLE almcmov
            THEN DO:
                MESSAGE 'Guia de transferencia no encontrada'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
            cNomCli = almcmov.nomref.
        END.
        WHEN "G/R" THEN DO:
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                /*AND ccbcdocu.coddiv = s-coddiv*/
                AND ccbcdocu.coddoc = rs-coddoc
                AND ccbcdocu.nrodoc = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL ccbcdocu THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "entry" TO txt-nroped.
                RETURN "adm-error".
            END.
            cNomCli = ccbcdocu.nomcli.
        END.
    END CASE.

    DISPLAY cNomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargar-Datos W-Win 
PROCEDURE Cargar-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.
    
    cNomCHq = "".
    CASE rs-coddoc:
        WHEN "PED" THEN DO:
            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                /*AND faccpedi.coddiv = s-coddiv*/
                AND faccpedi.coddoc = rs-coddoc
                AND faccpedi.nroped = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH facdpedi OF faccpedi NO-LOCK,
                FIRST almmmatg OF facdpedi NO-LOCK:

                /*Busca Factor de Venta */
                FIND almtconv WHERE almtconv.codunid = almmmatg.undbas
                    AND almtconv.codalter = facdpedi.undvta NO-LOCK NO-ERROR.
                IF AVAIL almtconv THEN dfactor = almtconv.equival.
                ELSE dfactor = 1.
                /************************/
              dPeso = dPeso + (facdpedi.canped * almmmatg.pesmat * dFactor).
            END.
            
            IF FacCPedi.UsrChq <> "" THEN DO:
                FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
                    AND Pl-pers.codper = FacCPedi.UsrChq NO-LOCK NO-ERROR.
                IF AVAILABLE Pl-pers 
                    THEN cNomCHq = FacCPedi.UsrChq + "-" + TRIM(Pl-pers.patper) + ' ' +
                        TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
            END.

            /*Datos Punto de Partida*/
            FIND FIRST almacen WHERE almacen.codcia = s-codcia
                AND almacen.codalm = faccpedi.codalm NO-LOCK NO-ERROR.
            IF AVAIL almacen THEN 
                ASSIGN 
                    cDir = Almacen.DirAlm
                    cSede = Almacen.Descripcion.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = faccpedi.nroped
                w-report.Campo-C[1] = faccpedi.ruc
                w-report.Campo-C[2] = faccpedi.nomcli
                w-report.Campo-C[3] = faccpedi.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = faccpedi.fchchq
                w-report.Campo-C[5] = STRING(txt-bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = faccpedi.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede.
        END.
        WHEN "P/M" THEN DO:
            FIND faccpedm WHERE faccpedm.codcia = s-codcia
                /*AND faccpedm.coddiv = s-coddiv*/
                AND faccpedm.coddoc = rs-coddoc
                AND faccpedm.nroped = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedm THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH facdpedm OF faccpedm NO-LOCK,
                FIRST almmmatg OF facdpedm NO-LOCK:

                /*Busca Factor de Venta */
                FIND almtconv WHERE almtconv.codunid = almmmatg.undbas
                    AND almtconv.codalter = facdpedm.undvta NO-LOCK NO-ERROR.
                IF AVAIL almtconv THEN dfactor = almtconv.equival.
                ELSE dfactor = 1.
                /************************/

                dPeso = dPeso + (facdpedm.canped * almmmatg.pesmat * dFactor).
            END.            

            IF faccpedm.UsrChq <> "" THEN DO:
                FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
                    AND Pl-pers.codper = faccpedm.UsrChq NO-LOCK NO-ERROR.
                IF AVAILABLE Pl-pers THEN 
                    ASSIGN 
                        cNomCHq = faccpedm.UsrChq + "-" + TRIM(Pl-pers.patper) + ' ' +
                            TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).            
            END.

            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = faccpedm.nroped
                w-report.Campo-C[1] = faccpedm.ruc
                w-report.Campo-C[2] = faccpedm.nomcli
                w-report.Campo-C[3] = faccpedm.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = faccpedm.fchchq
                w-report.Campo-C[5] = STRING(txt-bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = faccpedm.nroped
                w-report.Campo-I[1] = i-nro.

        END.
        WHEN "TRA" THEN DO:
            FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
                FIND almcmov WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = Almacen.codalm
                    AND almcmov.tipmov = 'S'
                    AND almcmov.codmov = 03
                    AND almcmov.nroser = INTEGER(SUBSTRING (txt-nroped, 1, 3) )
                    AND almcmov.nrodoc = INTEGER(SUBSTRING (txt-nroped, 4) )
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almcmov THEN LEAVE.
            END.
            IF NOT AVAILABLE almcmov
            THEN DO:
                MESSAGE 'Guia de transferencia no encontrada'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            dPeso = 0.
            FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
              dPeso = dPeso + (almdmov.candes * almdmov.factor * almmmatg.pesmat).
            END.
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = "03" + STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                w-report.Campo-C[1] = ""
                w-report.Campo-C[2] = Almacen.Descripcion
                w-report.Campo-C[3] = Almacen.DirAlm
                w-report.Campo-C[4] = ""
                w-report.Campo-D[1] = almcmov.fchdoc
                w-report.Campo-C[5] = STRING(txt-bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = ""
                w-report.Campo-I[1] = i-nro.
        END.
        WHEN "G/R" THEN DO:
            FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddoc = rs-coddoc
                AND ccbcdocu.nrodoc = txt-nroped NO-LOCK NO-ERROR.
            IF NOT AVAIL ccbcdocu THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:

                /*Busca Factor de Venta */
                FIND almtconv WHERE almtconv.codunid = almmmatg.undbas
                    AND almtconv.codalter = ccbddocu.undvta NO-LOCK NO-ERROR.
                IF AVAIL almtconv THEN dfactor = almtconv.equival.
                ELSE dfactor = 1.
                /************************/
              dPeso = dPeso + (CcbDDocu.CanDes * almmmatg.pesmat * dFactor).
            END.
            
            IF ccbcdocu.libre_c05 <> "" THEN DO:
                FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
                    AND Pl-pers.codper = ccbcdocu.libre_c05 NO-LOCK NO-ERROR.
                IF AVAILABLE Pl-pers 
                    THEN cNomCHq = ccbcdocu.libre_c05 + "-" + TRIM(Pl-pers.patper) + ' ' +
                        TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
            END.

            /*Datos Punto de Partida*/
            FIND FIRST almacen WHERE almacen.codcia = s-codcia
                AND almacen.codalm = ccbcdocu.codalm NO-LOCK NO-ERROR.
            IF AVAIL almacen THEN 
                ASSIGN 
                    cDir = Almacen.DirAlm
                    cSede = Almacen.Descripcion.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = ccbcdocu.nroped
                w-report.Campo-C[1] = ccbcdocu.ruc
                w-report.Campo-C[2] = ccbcdocu.nomcli
                w-report.Campo-C[3] = ccbcdocu.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = ccbcdocu.libre_f02
                w-report.Campo-C[5] = STRING(txt-bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = ccbcdocu.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede.
        END.
    END CASE.
   


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
  DISPLAY rs-coddoc txt-nroped txt-nomcli txt-bultos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rs-coddoc txt-nroped txt-bultos BUTTON-1 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Print W-Win 
PROCEDURE Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
  DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

  REPEAT WHILE L-Ubica:
         s-task-no = RANDOM(900000,999999).
         FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
         IF NOT AVAILABLE w-report THEN L-Ubica = NO.
  END.

  DO iint = 1 TO txt-bultos:
      i-nro = iint.
      RUN Cargar-Datos.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
  RB-REPORT-NAME = 'RotuloxPedidos'.
  RB-INCLUDE-RECORDS = 'O'.

  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dPeso AS DECIMAL     NO-UNDO.

  FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
      AND faccpedi.coddiv = s-coddiv
      AND faccpedi.coddoc = 'PED'
      AND faccpedi.nroped = txt-nroped NO-LOCK,
      EACH facdpedi OF faccpedi NO-LOCK,
      FIRST almmmatg OF facdpedi NO-LOCK:
      dPeso = dPeso + (facdpedi.canped * almmmatg.libre_d02).
  END.

  RETURN dPeso.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

