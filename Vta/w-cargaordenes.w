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

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR s-codalm  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE NEW SHARED VAR s-porigv  AS DECIMAL.
DEFINE NEW SHARED VAR s-coddoc  AS CHAR INIT "PNX".

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE OKpressed       AS LOGICAL NO-UNDO. 
DEFINE VARIABLE FILL-IN-file    AS CHAR NO-UNDO. 
DEFINE VARIABLE FILL-IN-file02  AS CHAR NO-UNDO. 

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE tt-cab
    FIELDS codped AS CHAR
    FIELDS codven AS CHAR
    FIELDS codcli AS CHAR
    FIELDS codcia AS CHAR
    FIELDS cndvta AS CHAR
    FIELDS imptot AS DEC
    FIELDS fchdoc AS CHAR.

DEFINE TEMP-TABLE tt-det
    FIELDS codped AS CHAR
    FIELDS codven AS CHAR
    FIELDS codcli AS CHAR
    FIELDS codcia AS CHAR
    FIELDS coddet AS CHAR
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS canmat AS DEC
    FIELDS implin AS DEC.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-12 FILL-IN-1 FILL-IN-2 BUTTON-13 ~
BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     LABEL "***" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-13 
     LABEL "***" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img/api-ve.ico":U
     LABEL "Button 14" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cabecera" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Detalle" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-12 AT ROW 2.04 COL 74 WIDGET-ID 8
     FILL-IN-1 AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-2 AT ROW 3.15 COL 15 COLON-ALIGNED WIDGET-ID 6
     BUTTON-13 AT ROW 3.15 COL 74 WIDGET-ID 10
     BUTTON-14 AT ROW 4.77 COL 66 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.14 BY 6.15 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 6.15
         WIDTH              = 85.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 103.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 103.72
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

{src/adm/method/viewer.i}
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
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* *** */
DO:

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS "Archivos Excel (*.txt)" "*.txt", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    DISPLAY fill-in-file @ fill-in-1 WITH FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* *** */
DO:
    SYSTEM-DIALOG GET-FILE FILL-IN-file02
        FILTERS "Archivos Texto (*.txt)" "*.txt", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    DISPLAY FILL-IN-file02 @ fill-in-2 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* Button 14 */
DO:
   
    RUN Asigna-Texto-Cab.  
    RUN Asigna-Texto-Det.
    RUN Carga.
    MESSAGE "Proceso Terminado".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Texto-Cab W-Win 
PROCEDURE Asigna-Texto-Cab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-CodMat LIKE VtaDDocu.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE VtaDDocu.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE VtaDDocu.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE VtaDDocu.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.


/*   SYSTEM-DIALOG GET-FILE x-Archivo       */
/*   FILTERS 'Archivo texto (.txt)' '*.txt' */
/*   RETURN-TO-START-DIR                    */
/*   TITLE 'Selecciona al archivo texto'    */
/*   MUST-EXIST                             */
/*   USE-FILENAME                           */
/*   UPDATE x-Ok.                           */
/*                                          */
/*   IF x-Ok = NO THEN RETURN.              */

  INPUT FROM VALUE(fill-in-file).
  REPEAT:
      CREATE tt-cab.
      IMPORT DELIMITER "|" tt-cab NO-ERROR.
  END.
  INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Texto-Det W-Win 
PROCEDURE Asigna-Texto-Det :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-CodMat LIKE VtaDDocu.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE VtaDDocu.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE VtaDDocu.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE VtaDDocu.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.


/*   SYSTEM-DIALOG GET-FILE x-Archivo       */
/*   FILTERS 'Archivo texto (.txt)' '*.txt' */
/*   RETURN-TO-START-DIR                    */
/*   TITLE 'Selecciona al archivo texto'    */
/*   MUST-EXIST                             */
/*   USE-FILENAME                           */
/*   UPDATE x-Ok.                           */
/*                                          */
/*   IF x-Ok = NO THEN RETURN.              */

  INPUT FROM VALUE(fill-in-file02).
  REPEAT:
      CREATE tt-det.
      IMPORT DELIMITER "|" tt-det NO-ERROR.
  END.
  INPUT CLOSE.

  FOR EACH tt-det NO-LOCK:
      DISPLAY tt-det WITH WIDTH 320.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga W-Win 
PROCEDURE Carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE L-INCREMENTA   AS LOGICAL.
    DEFINE VARIABLE iNroItm        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dPorIgv        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTpoCmb        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTotDias AS INTEGER     NO-UNDO.

    dPorIgv = FacCfgGn.PorIgv.
        
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        Cabe:
        FOR EACH tt-cab WHERE tt-cab.codped <> "" NO-LOCK BREAK BY tt-cab.codped:
            /*Cabecera*/
            FIND FIRST VtacDocu WHERE VtacDocu.Codcia = s-codcia
                AND VtacDocu.CodDiv = s-coddiv
                AND VtacDocu.Libre_c01 = tt-cab.codped NO-LOCK NO-ERROR.
            IF AVAIL VtacDocu THEN DO:
                MESSAGE "Pedido " tt-cab.codped + " ya fue cargado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                NEXT Cabe.
            END.
            
            /*Datos cliente*/
            FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = tt-cab.codcli NO-LOCK NO-ERROR.
            IF NOT AVAIL gn-clie THEN DO:
                MESSAGE 'Cliente No Registrado' SKIP
                        'Revisar Pedido ' + tt-cab.codped
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                NEXT Cabe.
            END.
            FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
                FacCorre.CodDoc = S-CODDOC AND
                FacCorre.CodDiv = S-CODDIV AND
                Faccorre.Codalm = S-CodAlm EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE FacCorre THEN DO:
                ASSIGN 
                    I-NroPed = FacCorre.Correlativo
                    I-NroSer = FacCorre.NroSer.
                ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
            END.
            ELSE DO:
                MESSAGE "No existe correlativo configurado"  SKIP
                        "    la división " + STRING(s-coddiv,"99999")
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN NO-APPLY.
            END.
            RELEASE FacCorre.

            /*Tipo Cambio*/
            /* Ubica la Condicion Venta */                
            dTpoCmb = 0.
            FIND FIRST gn-convt WHERE gn-convt.Codig = '000' NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt THEN DO:
                dTotDias = gn-convt.totdias.
                FIND FIRST TcmbCot WHERE  TcmbCot.Codcia = 0
                    AND  (TcmbCot.Rango1 <= gn-convt.totdias
                          AND   TcmbCot.Rango2 >= dtotdias)
                    NO-LOCK NO-ERROR.

                IF AVAIL TcmbCot THEN dTPOCMB = TcmbCot.TpoCmb.  
                ELSE MESSAGE "No pasa nada".

            END.  
    
            MESSAGE "Esta Creando el pedido " tt-cab.codped SKIP STRING(I-NroSer,"999") + STRING(I-NroPed,"999999").
            CREATE VtaCDocu.
            ASSIGN 
                INTEGRAL.VtaCDocu.CodCia  = INT(tt-cab.codcia)
                INTEGRAL.VtaCDocu.CodDiv  = s-coddiv
                INTEGRAL.VtaCDocu.CodPed  = s-coddoc
                INTEGRAL.VtaCDocu.NroPed  = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                INTEGRAL.VtaCDocu.CodCli  = tt-cab.codcli
                INTEGRAL.VtaCDocu.CodDept = gn-clie.CodDept
                INTEGRAL.VtaCDocu.CodDist = gn-clie.CodDist
                INTEGRAL.VtaCDocu.CodMon  = 1
                INTEGRAL.VtaCDocu.Cmpbnte = 'FAC'
                INTEGRAL.VtaCDocu.CodAlm  = s-codalm                
                INTEGRAL.VtaCDocu.CodPos  = gn-clie.Codpos
                INTEGRAL.VtaCDocu.CodProv = gn-clie.CodProv
                INTEGRAL.VtaCDocu.CodVen  = tt-cab.codven
                INTEGRAL.VtaCDocu.DirCli  = gn-clie.DirCli
                INTEGRAL.VtaCDocu.DniCli  = gn-clie.DNI
                INTEGRAL.VtaCDocu.FchAprobacion  = TODAY
                INTEGRAL.VtaCDocu.FchCre  =  TODAY
                INTEGRAL.VtaCDocu.FchEnt  = ?
                INTEGRAL.VtaCDocu.FchPed  = TODAY
                INTEGRAL.VtaCDocu.FlgEst  = 'X'
                INTEGRAL.VtaCDocu.FlgIgv  = YES
                INTEGRAL.VtaCDocu.FmaPgo  = '0' + tt-cab.cndvta
                INTEGRAL.VtaCDocu.Glosa   = ''
                /*INTEGRAL.VtaCDocu.Hora    = 0*/
                INTEGRAL.VtaCDocu.ImpTot  = tt-cab.imptot
                INTEGRAL.VtaCDocu.ImpVta  = tt-cab.imptot
                INTEGRAL.VtaCDocu.ImpIgv  = (tt-cab.imptot / 1 + (s-porigv / 100))
                INTEGRAL.VtaCDocu.ImpBrt  = (VtaCDocu.ImpTot - VtaCDocu.ImpIgv)
                INTEGRAL.VtaCDocu.ImpCto  = 0
                INTEGRAL.VtaCDocu.ImpDto  = 0
                INTEGRAL.VtaCDocu.ImpExo  = 0
                INTEGRAL.VtaCDocu.ImpFle  = 0                
                INTEGRAL.VtaCDocu.ImpInt  = 0
                INTEGRAL.VtaCDocu.ImpIsc  = 0                
                INTEGRAL.VtaCDocu.LugEnt  = ''
                INTEGRAL.VtaCDocu.NomCli  = gn-clie.nomcli
                INTEGRAL.VtaCDocu.NroCard = gn-clie.NroCard                
                INTEGRAL.VtaCDocu.Libre_c01 = tt-cab.codped
                INTEGRAL.VtaCDocu.PorIgv  = s-porigv
                INTEGRAL.VtaCDocu.RucCli  = gn-clie.Ruc
                INTEGRAL.VtaCDocu.TpoCmb  = dTpoCmb
                INTEGRAL.VtaCDocu.Usuario = s-user-id.


            Detalle:
            FOR EACH tt-det WHERE tt-det.codped = tt-cab.codped
                AND tt-det.codped <> '' NO-LOCK:
                /*Detalle*/
                MESSAGE "Crea Detalle del pedido " tt-det.codped SKIP STRING(I-NroSer,"999") + STRING(I-NroPed,"999999").
                FIND FIRST VtadDocu WHERE VtadDocu.Codcia = s-codcia
                    AND VtadDocu.CodDiv     = s-coddiv
                    AND VtadDocu.Libre_c01  = tt-det.codped
                    AND VtadDocu.CodMat     = tt-det.codmat NO-LOCK NO-ERROR.
                IF NOT AVAIL VtaDDocu THEN DO:
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                        AND almmmatg.codmat = tt-det.codmat NO-LOCK NO-ERROR.
                    IF NOT AVAIL almmmatg THEN DO:
                        MESSAGE " Articulo no registrado en el catalogo" SKIP
                                "El Articulo no sera cargado en el pedido"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        NEXT Detalle.
                    END.
                    MESSAGE "Crea el articulo " tt-det.codmat.
                    CREATE VtaDDocu.
                    ASSIGN
                        INTEGRAL.VtaDDocu.CodCia  = INT(tt-cab.codcia)
                        INTEGRAL.VtaDDocu.CodDiv  = s-coddiv
                        INTEGRAL.VtaDDocu.CodCli  = tt-cab.codcli
                        INTEGRAL.VtaDDocu.CodMat  = tt-det.codmat
                        INTEGRAL.VtaDDocu.CodPed  = s-coddoc
                        INTEGRAL.VtaDDocu.NroPed  = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                        INTEGRAL.VtaDDocu.Libre_c01 = tt-det.codped
                        INTEGRAL.VtaDDocu.AftIgv   = YES
                        INTEGRAL.VtaDDocu.AlmDes   = ''
                        INTEGRAL.VtaDDocu.CanPed   = tt-det.canmat
                        INTEGRAL.VtaDDocu.Factor   = 1
                        INTEGRAL.VtaDDocu.FchPed   = TODAY
                        INTEGRAL.VtaDDocu.FlgEst   = 'X'
                        INTEGRAL.VtaDDocu.ImpLin   = tt-det.implin
                        INTEGRAL.VtaDDocu.ImpVta   = tt-det.implin
                        INTEGRAL.VtaDDocu.ImpBrt   = (tt-det.implin / 1 + (s-porigv / 100))                
                        INTEGRAL.VtaDDocu.NroItm   = iNroItm
                        INTEGRAL.VtaDDocu.PesMat   = almmmatg.pesmat * tt-det.canmat
                        INTEGRAL.VtaDDocu.PorIgv   = s-porigv
                        INTEGRAL.VtaDDocu.PreUni   = tt-det.implin / tt-det.canmat
                        INTEGRAL.VtaDDocu.PreBas   = tt-det.implin / tt-det.canmat
                        INTEGRAL.VtaDDocu.UndVta   = almmmatg.undbas
                        INTEGRAL.VtaDDocu.Libre_c02 = tt-det.coddet.
                END.
            END.                        
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
  DISPLAY FILL-IN-1 FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-12 FILL-IN-1 FILL-IN-2 BUTTON-13 BUTTON-14 
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

