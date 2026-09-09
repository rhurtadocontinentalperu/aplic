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
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEF STREAM REPORTE.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE OKpressed       AS LOGICAL NO-UNDO. 
DEFINE VARIABLE FILL-IN-file    AS CHAR NO-UNDO. 

DEFINE TEMP-TABLE tt-detalle LIKE AlmCatVtaD
    FIELDS despag AS CHAR
    FIELDS prevta AS DEC.

DEFINE TEMP-TABLE tt-errores 
    FIELDS nrosec   AS INT
    FIELDS codmat   LIKE almmmatg.codmat
    FIELDS codprob  AS CHAR
    FIELDS desprob  AS CHAR
    INDEX Indice nrosec.

DEFINE TEMP-TABLE tt-lista LIKE VtaListaMay.

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
&Scoped-Define ENABLED-OBJECTS txt-codpro FILL-IN-1 BUTTON-1 rs-tipo ~
txt-nropag BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS txt-codpro txt-nompro FILL-IN-1 rs-tipo ~
txt-nropag txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "..." 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon/admin%.ico":U
     LABEL "Button 2" 
     SIZE 10.86 BY 1.88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62.57 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE txt-nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.57 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nropag AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Nº Páginas:" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Completa", "C"
     SIZE 14.43 BY 1.08 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codpro AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 12
     txt-nompro AT ROW 2.08 COL 26.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-1 AT ROW 3.15 COL 12 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 3.15 COL 73 WIDGET-ID 4
     rs-tipo AT ROW 4.35 COL 14.57 NO-LABEL WIDGET-ID 16
     txt-nropag AT ROW 5.31 COL 12 COLON-ALIGNED WIDGET-ID 24
     BUTTON-2 AT ROW 5.85 COL 69 WIDGET-ID 8
     txt-mensaje AT ROW 6.77 COL 3.43 NO-LABEL WIDGET-ID 6
     "Carga:" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 4.42 COL 5 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82 BY 7.15 WIDGET-ID 100.


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
         TITLE              = "Carga Catalogos por Proveedor"
         HEIGHT             = 7.15
         WIDTH              = 82
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 94.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 94.86
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

{src/adm-vm/method/vmviewer.i}
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
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga Catalogos por Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga Catalogos por Proveedor */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    
    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    DISPLAY fill-in-file @ fill-in-1 WITH FRAME {&FRAME-NAME}.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
    ASSIGN 
        txt-codpro
        rs-tipo
        txt-nropag.

    IF txt-codpro = '' THEN DO:
        MESSAGE "Debe ingresar código de proveedor"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY" TO txt-codpro.
        RETURN "ADM-ERROR".
    END.


    MESSAGE 
        "Este proceso reemplaza la información" SKIP
        "   Actual del catalogo de productos  " SKIP
        "           Desea Continuar??         "
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
            UPDATE lchoice AS LOGICAL.

    IF lchoice THEN DO:
        EMPTY TEMP-TABLE tt-detalle.
        DO iInt = 1 TO txt-nropag:
            IF txt-codpro = '51135890' THEN RUN Importar-Excel-Stand.
            ELSE RUN Importar-Excel-Otros (iint).
        END.

        RUN Busca-Errores.    
        FIND FIRST tt-errores NO-LOCK NO-ERROR.
        IF AVAIL tt-errores THEN RUN Excel-Errores.
        ELSE DO: 
            RUN Borra-Catalogo.
            RUN Actualiza-Catalogo.      
            MESSAGE "Proceso Terminado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        DISPLAY "" @ txt-mensaje WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codpro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codpro W-Win
ON LEAVE OF txt-codpro IN FRAME F-Main /* Proveedor */
DO:
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = txt-codpro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN 
        DISPLAY gn-prov.nompro @ txt-nompro WITH FRAME {&FRAME-NAME}.
    ELSE DISPLAY "" @ txt-nompro WITH FRAME {&FRAME-NAME}.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Catalogo W-Win 
PROCEDURE Actualiza-Catalogo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iNroSec  AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE x-CToTot AS DEC         NO-UNDO.
DEFINE VARIABLE f-Factor AS DEC         NO-UNDO.

FOR EACH tt-detalle NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = tt-detalle.codcia
        AND Almmmatg.CodMat = tt-detalle.CodMat NO-LOCK
        BREAK BY tt-detalle.codpro
            BY tt-detalle.nropag:
    FIND almcatvtad WHERE almcatvtad.codcia = tt-detalle.codcia
        AND almcatvtad.coddiv = tt-detalle.coddiv
        AND almcatvtad.codpro = tt-detalle.codpro
        AND almcatvtad.codmat = tt-detalle.codmat NO-LOCK NO-ERROR.
    IF NOT AVAIL almcatvtad THEN DO:
        iNroSec = iNroSec + 1.
        CREATE almcatvtad.
        ASSIGN
            INTEGRAL.AlmCatVtaD.CodCia      = INT(tt-detalle.codcia)
            INTEGRAL.AlmCatVtaD.CodDiv      = tt-detalle.coddiv
            INTEGRAL.AlmCatVtaD.codmat      = tt-detalle.codmat
            INTEGRAL.AlmCatVtaD.DesMat      = almmmatg.desmat
            INTEGRAL.AlmCatVtaD.CodPro      = tt-detalle.codpro
            INTEGRAL.AlmCatVtaD.NroPag      = INT(tt-detalle.nropag)
            INTEGRAL.AlmCatVtaD.NroSec      = tt-detalle.NroSec
            INTEGRAL.AlmCatVtaD.UndBas      = almmmatg.undbas
            INTEGRAL.AlmCatVtaD.Libre_c01   = almmmatg.undbas
            INTEGRAL.AlmCatVtaD.Libre_c02   = tt-detalle.libre_c02   /*Sub Titulo*/
            INTEGRAL.AlmCatVtaD.CodProv     = tt-detalle.CodProv
            INTEGRAL.AlmCatVtaD.CanEmp      = tt-detalle.CanEmp      /*Cantidad Minima Empaque*/
            /*INTEGRAL.AlmCatVtaD.Libre_d04  = tt-detalle.libre_d04 Cantidad Minima Empaque*/
            INTEGRAL.AlmCatVtaD.Libre_d05   = tt-detalle.libre_d05.  /*Cantidad Maxima Empaque*/

        IF tt-detalle.DesMat <> '' THEN AlmCatVtaD.DesMat = tt-detalle.desmat.

        DISPLAY "<<<  ACTUALIZANDO CATALOGO  >>>" @ txt-mensaje WITH FRAME {&FRAME-NAME}.

        IF LAST-OF(tt-detalle.nropag) THEN DO:
            CREATE almcatvtac.
            ASSIGN 
                INTEGRAL.AlmCatVtaC.CodCia  = tt-detalle.codcia
                INTEGRAL.AlmCatVtaC.CodDiv  = tt-detalle.coddiv
                INTEGRAL.AlmCatVtaC.CodPro  = tt-detalle.codpro
                INTEGRAL.AlmCatVtaC.NroPag  = tt-detalle.nropag
                INTEGRAL.AlmCatVtaC.DesPag  = tt-detalle.despag.     
            /*iNroSec = 0.*/
        END.

        FIND tt-lista WHERE tt-lista.codcia = almcatvtad.codcia
            AND tt-lista.coddiv = almcatvtad.coddiv
            AND tt-lista.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-lista THEN DO:
            CREATE tt-lista.
            ASSIGN 
                tt-lista.CodCia  = almcatvtad.codcia
                tt-lista.CodDiv  = almcatvtad.coddiv
                tt-lista.codfam  = almmmatg.codfam
                tt-lista.codmat  = almcatvtad.codmat
                tt-lista.DesMar  = almmmatg.desmar
                tt-lista.DesMat  = almmmatg.desmat
                tt-lista.FchIng  = TODAY
                tt-lista.FchAct  = TODAY
                tt-lista.MonVta  = 1
                tt-lista.PreOfi  = tt-detalle.prevta
                tt-lista.subfam  = almmmatg.subfam
                tt-lista.TpoCmb  = Almmmatg.TpoCmb
                tt-lista.CanEmp  = tt-detalle.canemp
                tt-lista.Chr__01 = almmmatg.undbas
                tt-lista.usuario = s-user-id.
  
            IF ALmmmatg.monvta = tt-lista.monvta THEN x-CtoTot = Almmmatg.CtoTot.
            ELSE IF tt-lista.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
            ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
                 
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = tt-lista.Chr__01 NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.  
            ASSIGN
                tt-lista.Dec__01 = ( (tt-lista.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
        END.
    END.
    ELSE DO:
        MESSAGE "Crea Tabla Errores".
        iInt = iInt + 1.
        CREATE tt-errores.
        ASSIGN 
            tt-errores.nrosec  = iint
            tt-errores.codmat  = tt-detalle.codmat
            tt-errores.desprob = 'Articulo registrado en la pagina ' + STRING(almcatvtad.nropag) + 
                                    ', secuencia ' + STRING(almcatvtad.nrosec).        
    END.
END.

FIND FIRST tt-errores NO-LOCK NO-ERROR.
IF AVAIL tt-errores THEN DO: 
    RUN Excel-Errores.
END.
/*ELSE RUN Actualiza-Precios.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Precios W-Win 
PROCEDURE Actualiza-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Borra Precios Anteriores*/
    FOR EACH tt-lista NO-LOCK:
        FIND FIRST vtalistamay WHERE vtalistamay.codcia = tt-lista.codcia
            AND vtalistamay.coddiv = tt-lista.coddiv
            AND vtalistamay.codmat = tt-lista.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL vtalistamay THEN DELETE vtalistamay.
    END.
    
    /*Copia Nuevos Precios*/
    FOR EACH tt-lista NO-LOCK:
        FIND FIRST vtalistamay WHERE vtalistamay.codcia = tt-lista.codcia
            AND vtalistamay.coddiv = tt-lista.coddiv
            AND vtalistamay.codmat = tt-lista.codmat NO-ERROR.
        IF NOT AVAIL vtalistamay THEN DO:
            CREATE vtalistamay.
            BUFFER-COPY tt-lista TO vtalistamay.
            DISPLAY "<<<  ACTUALIZANDO PRECIOS  >>>" @ txt-mensaje WITH FRAME {&FRAME-NAME}.
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Catalogo W-Win 
PROCEDURE Borra-Catalogo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE rs-tipo:
        WHEN "C" THEN DO:
            /*Cabecera*/                                                     
            FOR EACH AlmCatVtaC WHERE AlmCatVtaC.CodCia = s-codcia
                AND AlmCatVtaC.CodDiv = s-coddiv
                AND AlmCatVTaC.CodPro = txt-codpro EXCLUSIVE-LOCK:
                DELETE AlmCatVtaC.
            END.

            /*Detalle*/
            FOR EACH AlmCatVtaD WHERE AlmCatVtaD.CodCia = s-codcia
                AND AlmCatVtaD.CodDiv = s-coddiv
                AND AlmCatVtaD.CodPro = txt-codpro EXCLUSIVE-LOCK:
                DELETE AlmCatVtaD.
            END.
        END.
        WHEN "P" THEN DO:
            FOR EACH tt-detalle NO-LOCK
                BREAK BY tt-detalle.nropag :

                IF LAST-OF(tt-detalle.nropag) THEN DO:
                    /*Cabecera*/                                                     
                    FOR EACH AlmCatVtaC WHERE AlmCatVtaC.CodCia = s-codcia
                        AND AlmCatVtaC.CodDiv = s-coddiv
                        AND AlmCatVTaC.CodPro = txt-codpro
                        AND AlmCatVTaC.NroPag = tt-detalle.nropag
                        EXCLUSIVE-LOCK:
                        DELETE AlmCatVtaC.
                    END.

                    /*Detalle*/
                    FOR EACH AlmCatVtaD WHERE AlmCatVtaD.CodCia = s-codcia
                        AND AlmCatVtaD.CodDiv = s-coddiv
                        AND AlmCatVtaD.CodPro = txt-codpro 
                        AND AlmCatVtaD.NroPag = tt-detalle.NroPag EXCLUSIVE-LOCK:
                        DELETE AlmCatVtaD.
                    END.
                END.
            END.

        END.
    END CASE.
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Errores W-Win 
PROCEDURE Busca-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO INIT 0.
    DEFINE VARIABLE iVal AS INTEGER     NO-UNDO INIT 1.
    DEFINE VARIABLE iIni AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFin AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iSec AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-errores.
    
    FOR EACH tt-detalle WHERE tt-detalle.codcia = s-codcia
        AND tt-detalle.coddiv = s-coddiv NO-LOCK
        BREAK BY tt-detalle.nropag:

        /*Que exista*/
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = tt-detalle.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL almmmatg THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'Código no Existe en Catalogo'.
        END.

             

        IF FIRST(tt-detalle.nropag) THEN iIni = tt-detalle.nropag.
        IF LAST-OF(tt-detalle.nropag) AND tt-detalle.nropag <> ?
            THEN iFin = tt-detalle.nropag.

        /*Proveedor*/
        IF tt-detalle.codpro = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Proveedor'.
        END.
            
        /*Número Página*/
        IF tt-detalle.nropag = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Pagina'.
        END.
            
        /*Descripción Página*/
        IF tt-detalle.despag = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Descripcion de Pagina'.        
        END.

        /*Descripción Secuencia*/
        IF tt-detalle.nrosec = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Secuencia'.        
        END.

        /*Sub Titulo*/
        IF tt-detalle.libre_c03 = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Sub Titulo'.        
        END.

/*         /*Codigo Proveedor*/                                      */
/*         IF tt-detalle.codprov = ? THEN DO:                        */
/*             iInt = iInt + 1.                                      */
/*             CREATE tt-errores.                                    */
/*             ASSIGN                                                */
/*                 tt-errores.nrosec  = tt-detalle.nrosec            */
/*                 tt-errores.codmat  = tt-detalle.codmat            */
/*                 tt-errores.desprob = 'No tiene Código Proveedor'. */
/*         END. */

        /*Cantidad Empaque*/
        IF tt-detalle.CanEmp = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Cantidad Empaque'.        
        END.

        /*Código Interno*/
        IF tt-detalle.CodMat = ? THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = tt-detalle.nrosec
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'No tiene Código Interno'.        
        END.

/*         /*Precio Final*/                                      */
/*         IF tt-detalle.PreVta = ? THEN DO:                     */
/*             iInt = iInt + 1.                                  */
/*             CREATE tt-errores.                                */
/*             ASSIGN                                            */
/*                 tt-errores.nrosec  = tt-detalle.nrosec        */
/*                 tt-errores.codmat  = tt-detalle.codmat        */
/*                 tt-errores.desprob = 'No tiene Precio Venta'. */
/*         END.                                                  */
    END.

    /*Valida Secuencias*/
    iSec = 0.
    FOR EACH tt-detalle NO-LOCK
        BREAK BY tt-detalle.nropag            
            BY tt-detalle.nrosec :
        iSec = iSec + 1.
        IF tt-detalle.nrosec <> iSec THEN DO:
            CREATE tt-errores.
            ASSIGN 
                tt-errores.nrosec  = iint
                tt-errores.codmat  = tt-detalle.codmat
                tt-errores.desprob = 'Secuencia incorrecta en la línea ' + 
                    STRING(tt-detalle.nrosec).        
            LEAVE.
        END.
        IF LAST-OF(tt-detalle.nropag) AND txt-codpro <> '51135890' THEN iSec = 0.
    END.


    /*Valida Páginas*/
    DO iVal = iIni TO iFin:
        FIND FIRST tt-detalle WHERE tt-detalle.codcia = s-codcia
            AND tt-detalle.codpro = txt-codpro
            AND tt-detalle.nropag = iVal NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-detalle THEN DO:
            iInt = iInt + 1.
            CREATE tt-errores.
            ASSIGN
                tt-errores.nrosec  = iint
                tt-errores.codmat  = '999999'
                tt-errores.desprob = 'No existe la pagina ' + STRING(iVal).            
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
  DISPLAY txt-codpro txt-nompro FILL-IN-1 rs-tipo txt-nropag txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codpro FILL-IN-1 BUTTON-1 rs-tipo txt-nropag BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Errores W-Win 
PROCEDURE Excel-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

/* Generamos el archivo texto */
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Llave AS CHAR FORMAT 'x(500)' NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Llave = ''.
x-Llave = x-Llave + "Nro." + CHR(9).
x-Llave = x-Llave + "Codigo" + CHR(9).
x-Llave = x-Llave + "Descripcion" + CHR(9).
x-LLave = x-Llave + "Marca" + CHR(9).
x-Llave = x-Llave + "Unidad" + CHR(9).
x-LLave = x-LLave + "Detalle Problema" + CHR(9).
x-Llave = x-Llave + "".

PUT STREAM REPORTE x-LLave SKIP.
FOR EACH tt-errores NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = tt-errores.codmat NO-LOCK NO-ERROR.
    IF AVAIL almmmatg  THEN DO:
        x-Llave = "".
        x-Llave = x-Llave + STRING(tt-errores.nrosec, "999") + CHR(9).
        x-Llave = x-Llave + STRING(tt-errores.codmat, "999999") + CHR(9).
        x-Llave = x-Llave + almmmatg.desmat + CHR(9).
        x-Llave = x-Llave + almmmatg.desmar + CHR(9).
        x-LLave = x-LLave + almmmatg.undbas + CHR(9).
        x-Llave = x-LLave + tt-errores.desprob + CHR(9).
        x-Llave = x-Llave + "".
    END.
    ELSE DO:
        x-Llave = "".
        x-Llave = x-Llave + STRING(tt-errores.nrosec, "999") + CHR(9).
        x-Llave = x-Llave + STRING(tt-errores.codmat, "999999") + CHR(9).
        x-Llave = x-LLave + tt-errores.desprob + CHR(9).
        x-Llave = x-Llave + "".
    END.
    PUT STREAM REPORTE x-LLave SKIP.
END.            
OUTPUT STREAM REPORTE CLOSE.

MESSAGE 
    "El archivo no se ha podido cargar" SKIP
    "debido a presentar algunos errores" SKIP    
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Por Almacen', YES).

SESSION:SET-WAIT-STATE('').



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DEFINE VARIABLE OKpressed       AS LOGICAL NO-UNDO. */
/* DEFINE VARIABLE FILL-IN-file    AS CHAR NO-UNDO.    */
DEFINE VARIABLE F-CTOLIS        AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-CTOTOT        AS DECIMAL NO-UNDO.

/* SYSTEM-DIALOG GET-FILE FILL-IN-file                               */
/*     FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*" */
/*     TITLE "Archivo(s) de Carga..."                                */
/*     MUST-EXIST                                                    */
/*     USE-FILENAME                                                  */
/*     UPDATE OKpressed.                                             */
/* IF OKpressed = FALSE THEN RETURN.                                 */
/* DISPLAY fill-in-file @ fill-in-1 WITH FRAME {&FRAME-NAME}.        */

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iNroSec         AS INTEGER      NO-UNDO INIT 0.

EMPTY TEMP-TABLE tt-detalle.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
iNroSec = 0.
REPEAT:
    iNroSec = iNroSec + 1.
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN cValue = STRING(INTEGER (cValue), '999999') NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Código' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    DISPLAY "** ACTUALIZANDO **" + cValue @ txt-mensaje WITH FRAME {&FRAME-NAME}.
    /* REGISTRAMOS EL PRODUCTO */
    FIND FIRST tt-detalle WHERE tt-detalle.codcia = s-codcia
        AND tt-detalle.codmat = cValue EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL tt-detalle THEN DO:
        CREATE tt-detalle.
        ASSIGN 
            tt-detalle.codcia = s-codcia
            tt-detalle.coddiv = s-coddiv
            tt-detalle.codmat = cValue
            tt-detalle.codpro = txt-codpro
            tt-detalle.nrosec = iNroSec.
    END.

/*     /* PROVEEDOR */                                             */
/*     cRange = "E" + TRIM(STRING(iCountLine)).                    */
/*     cValue = chWorkSheet:Range(cRange):VALUE .                  */
/*     cValue = STRING(INT(cValue)).                               */
/*     ASSIGN tt-detalle.CodPro = STRING(cValue,"X(11)") NO-ERROR. */
/*     IF ERROR-STATUS:ERROR THEN DO:                              */
/*         MESSAGE 'Valor no reconocido:' cValue SKIP              */
/*             'Campo: Proveedor' VIEW-AS ALERT-BOX ERROR.         */
/*         /*NEXT.*/                                               */
/*     END.                                                        */


    /* DESCRIPCION MATERIAL SEGUN PROVEEDOR */
    cRange = "B" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.NroPag = INTEGER (cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Pagina' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.

/*     /* PAGINA */                                          */
/*     cRange = "E" + TRIM(STRING(iCountLine)).              */
/*     cValue = chWorkSheet:Range(cRange):VALUE.             */
/*     ASSIGN tt-detalle.NroPag = INTEGER (cValue) NO-ERROR. */
/*     IF ERROR-STATUS:ERROR THEN DO:                        */
/*         MESSAGE 'Valor no reconocido:' cValue SKIP        */
/*             'Campo: Pagina' VIEW-AS ALERT-BOX ERROR.      */
/*         /*NEXT.*/                                         */
/*     END.                                                  */


    /* PAGINA */
    cRange = "E" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.NroPag = INTEGER (cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Pagina' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.


    /* DESCRIPCION PAGINA */
    cRange = "F" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.DesPag = cValue NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Descripcion Pagina' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.

    /* SUB AGRUPACION PAGINA */
    cRange = "G" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.libre_c02 = cValue NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Descripcion de Sub-Agrupacion' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.

    /* CANTIDAD EMPAQUE */
    cRange = "H" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.libre_d04 = DEC(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Cantidad Empaque' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.

    /* CANTIDAD EMPAQUE */
    cRange = "I" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN tt-detalle.libre_d05 = DEC(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Cantidad Empaque' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
    END.


END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

HIDE FRAME f-Proceso.

/*****
FOR EACH tt-detalle NO-LOCK:
    MESSAGE 
        tt-detalle.codmat SKIP
        tt-detalle.codpro SKIP 
        tt-detalle.nropag SKIP
        tt-detalle.despag.
END.
*****/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Otros W-Win 
PROCEDURE Importar-Excel-Otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iInt     AS INTEGER .
DEFINE VARIABLE F-CTOLIS        AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-CTOTOT        AS DECIMAL NO-UNDO.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO EXTENT 25.
DEFINE VARIABLE iNroSec         AS INTEGER      NO-UNDO INIT 0.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 7.

DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(iint).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
iNroSec = 0.

REPEAT:
    iNroSec = iNroSec + 1.
    iCountLine = iCountLine + 1.
    
    t-column = 0.
    t-Row    = t-Row + 1 .
/*     /* NRO. PAGINA */                                                                  */
/*     cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.                       */
/*     IF cValue[t-Column] = "" OR cValue[t-Column] = ? THEN LEAVE.    /* FIN DE DATOS */ */
/*     /* DESCRIPCIÓN PÁGINA */                                                           */
/*     t-column = t-column + 1.                                                           */
/*     cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.                       */

    /* SECUENCIA */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue[t-Column] = "" OR cValue[t-Column] = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* SUB TITULO */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CODIGO PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /*cValue[t-Column] = STRING(INTEGER (cValue[t-Column]), '999999'). */
    /* DESCRIPCION PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* MARCA */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* UNIDAD */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CANTIDAD EMPAQUE */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CAJON */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.

    
    /* PRECIO PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CODIGO INTERNO */
    t-column = t-column + 1.
    i-Column = t-column.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN 
        cValue[t-Column] = STRING(INTEGER (cValue[t-Column]), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue[t-Column] SKIP
            'Campo: Código Interno' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
        RETURN "ADM-ERROR".
    END.

    /* MARGEN */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* PRECIO FINAL */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.

    DISPLAY "** CARGANDO EXCEL HOJA: " + STRING(iInt,"99") + " SECUENCIA: " + cValue[1] + "**" @ txt-mensaje WITH FRAME {&FRAME-NAME}.

    /* REGISTRAMOS EL PRODUCTO */
    FIND FIRST tt-detalle WHERE tt-detalle.codcia = s-codcia
        AND tt-detalle.codmat = cValue[i-Column] EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL tt-detalle THEN DO:
        CREATE tt-detalle.
        ASSIGN 
            tt-detalle.CodCia       = s-codcia
            tt-detalle.CodDiv       = s-coddiv
            tt-detalle.NroPag       = iInt
            tt-detalle.DesPag       = "Pagina " + STRING(iInt,"99")
            tt-detalle.NroSec       = INTEGER(cValue[1])
            tt-detalle.Libre_c02    = cValue[2]         
            tt-detalle.codprov      = cValue[3]
            tt-detalle.DesMat       = cValue[4]
            tt-detalle.UndBas       = cValue[6]
            tt-detalle.Libre_c01    = cValue[6]
            tt-detalle.CanEmp       = DEC(cValue[7])
            tt-detalle.Libre_d05    = DEC(cValue[8])
            tt-detalle.codmat       = STRING(cValue[10],"999999")
            tt-detalle.prevta       = DEC(cValue[12]) 
            tt-detalle.CodPro       = txt-codpro.
        IF tt-detalle.codprov = '' THEN tt-detalle.codprov = STRING(cValue[10],"999999").
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

HIDE FRAME f-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Stand W-Win 
PROCEDURE Importar-Excel-Stand :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-CTOLIS        AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-CTOTOT        AS DECIMAL NO-UNDO.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO EXTENT 25.
DEFINE VARIABLE iNroSec         AS INTEGER      NO-UNDO INIT 0.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

EMPTY TEMP-TABLE tt-detalle.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
iNroSec = 0.

REPEAT:
    iNroSec = iNroSec + 1.
    iCountLine = iCountLine + 1.
    
    t-column = 1.
    t-Row    = t-Row + 1 .
    /* NRO. PAGINA */
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue[t-Column] = "" OR cValue[t-Column] = ? THEN LEAVE.    /* FIN DE DATOS */
    /* DESCRIPCIÓN PÁGINA */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* SECUENCIA */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* SUB TITULO */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CODIGO PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    cValue[t-Column] = STRING(INTEGER (cValue[t-Column]), '999999'). 
    /* DESCRIPCION PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* MARCA */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* UNIDAD */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CANTIDAD EMPAQUE */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CAJON */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    
    /* PRECIO PROV */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* CODIGO INTERNO */
    t-column = t-column + 1.
    i-Column = t-column.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN 
        cValue[t-Column] = STRING(INTEGER (cValue[t-Column]), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue[t-Column] SKIP
            'Campo: Código Interno' VIEW-AS ALERT-BOX ERROR.
        /*NEXT.*/
        RETURN.
    END.

    /* MARGEN */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* PRECIO FINAL */
    t-column = t-column + 1.
    cValue[t-Column] = chWorkSheet:Cells(t-Row, t-Column):VALUE.

    DISPLAY "** ACTUALIZANDO ** " @ txt-mensaje WITH FRAME {&FRAME-NAME}.

    /* REGISTRAMOS EL PRODUCTO */
    FIND FIRST tt-detalle WHERE tt-detalle.codcia = s-codcia
        AND tt-detalle.codmat = cValue[i-Column] EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL tt-detalle THEN DO:
        CREATE tt-detalle.
        ASSIGN 
            tt-detalle.CodCia       = s-codcia
            tt-detalle.CodDiv       = s-coddiv
            tt-detalle.NroPag       = INTEGER(cValue[1])
            tt-detalle.DesPag       = cValue[2]
            tt-detalle.NroSec       = INTEGER(cValue[3])
            tt-detalle.Libre_c02    = cValue[4]         
            tt-detalle.codprov      = cValue[5]
            tt-detalle.DesMat       = cValue[6]
            tt-detalle.UndBas       = cValue[8]
            tt-detalle.Libre_c01    = cValue[8]
            tt-detalle.CanEmp       = DEC(cValue[9])
            tt-detalle.Libre_d05    = DEC(cValue[10])
            tt-detalle.codmat       = STRING(cValue[12],"999999")
            tt-detalle.prevta       = DEC(cValue[14]) 
            tt-detalle.CodPro       = txt-codpro.
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

HIDE FRAME f-Proceso.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "x-subfam" THEN
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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

