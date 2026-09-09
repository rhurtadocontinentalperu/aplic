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

{src/bin/_prns.i}   /* Para la impresion */

/* Local Variable Definitions ---                                       */

DEF STREAM REPORTE.
DEF SHARED VAR s-codalm LIKE almacen.codalm.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-desmat  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-desmat2 AS CHAR NO-UNDO FORMAT 'X(20)'.
DEF VAR x-desmar  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-preuni  AS CHAR NO-UNDO FORMAT 'X(12)'.

DEFINE TEMP-TABLE tt-articulos 
    FIELDS t-codmat   LIKE almmmatg.codmat
    FIELDS t-desmat   LIKE almmmatg.desmat
    FIELDS t-desmat2  LIKE almmmatg.desmat
    FIELDS t-desmar   LIKE almmmatg.desmat
    FIELDS t-PreUni   AS CHAR
    FIELDS t-Observa  AS CHAR
    FIELDS t-DtoVol   AS CHAR
    FIELDS t-DtoVo2   AS CHAR
    FIELDS t-Valida   AS LOGICAL  INIT YES.

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
&Scoped-Define ENABLED-OBJECTS fill-in-codmat FILL-IN-file BUTTON-5 x-Desde ~
x-Hasta rs-Tipo BUTTON-9 BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS fill-in-codmat FILL-IN-file x-Desde ~
x-Hasta rs-Tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 8" 
     SIZE 10 BY 2.15.

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "Button 9" 
     SIZE 10 BY 2.15.

DEFINE VARIABLE fill-in-codmat AS CHARACTER FORMAT "X(13)":U 
     LABEL "Codigo Interno / EAN 13" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Por Lista de Articulos" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1
     BGCOLOR 6  NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rs-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Impresión por Articulos", 1,
"Impresión por Rango de fechas", 2
     SIZE 38 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fill-in-codmat AT ROW 2.08 COL 28 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-file AT ROW 3.15 COL 28 COLON-ALIGNED WIDGET-ID 4
     BUTTON-5 AT ROW 3.15 COL 81 WIDGET-ID 66
     x-Desde AT ROW 4.23 COL 28 COLON-ALIGNED WIDGET-ID 68
     x-Hasta AT ROW 5.31 COL 28 COLON-ALIGNED WIDGET-ID 70
     rs-Tipo AT ROW 6.38 COL 30 NO-LABEL WIDGET-ID 72
     BUTTON-9 AT ROW 9.62 COL 31 WIDGET-ID 76
     BUTTON-8 AT ROW 9.62 COL 41 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.86 BY 11.46 WIDGET-ID 100.


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
         TITLE              = "Impresión Precio Gondolas"
         HEIGHT             = 11.46
         WIDTH              = 87.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 114.14
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresión Precio Gondolas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresión Precio Gondolas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Excel (*.csv)" "*.csv",
            "Archivos Texto (*.txt)" "*.txt",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  RUN local-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
  
    ASSIGN fill-in-codmat fill-in-file x-desde x-hasta rs-tipo.

    RUN Imprime-Etiqueta.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Articulos W-Win 
PROCEDURE Carga-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-articulos.

    CASE rs-tipo:
        WHEN 1 THEN DO:
            /* Carga de Excel */
            IF SEARCH(FILL-IN-file) <> ? THEN DO:
                OUTPUT TO VALUE(FILL-IN-file) APPEND.
                PUT UNFORMATTED "?" CHR(10) SKIP.
                OUTPUT CLOSE.
                INPUT FROM VALUE(FILL-IN-file).
                REPEAT:
                    CREATE tt-articulos.
                    IMPORT t-codmat.
                    IF t-codmat = '' THEN ASSIGN t-codmat = "?".        
                END.
                INPUT CLOSE.
            END.
        END.
        WHEN 2 THEN DO:            
            FOR EACH vtalistamin WHERE vtalistamin.codcia = s-codcia
                AND vtalistamin.coddiv = s-coddiv
                AND vtalistamin.fchact >= x-desde
                AND vtalistamin.fchact <= x-hasta NO-LOCK:
                CREATE tt-articulos.
                ASSIGN tt-articulos.t-codmat = vtalistamin.codmat.
            END.
        END.
    END CASE.

    FOR EACH tt-articulos:
        IF t-codmat = '' THEN DELETE tt-articulos.
    END.
    
    FIND FIRST tt-articulos NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-articulos THEN DO:
        CREATE tt-articulos.        
        ASSIGN t-codmat = fill-in-codmat.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Precios W-Win 
PROCEDURE Carga-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-dtovol  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR x-dtovo2  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR cNotita   AS CHAR NO-UNDO FORMAT 'X(35)'.

    DEFINE VARIABLE dPreUni  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDsctos  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo1 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo2 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPrecio  AS DECIMAL     NO-UNDO.


    Articulos:
    FOR EACH tt-articulos EXCLUSIVE-LOCK:
        IF LENGTH(TRIM(T-CodMat)) = 6 THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codmat) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
        ELSE IF LENGTH(TRIM(T-CodMat)) = 6 THEN DO:        
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codbrr) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            MESSAGE "Codigo " + STRING(T-CodMat) + " No Válido!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.      
            t-Valida = NO.
            NEXT Articulos.
        END.

        IF AVAIL almmmatg THEN DO:
            ASSIGN
                x-DtoVol = ''
                x-Dtovo2 = ''
                dPrecio  = 0
                cNotita  = ''.
            
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.

            /*Si gn-divi.VentaMinorista = 1 */
            IF gn-divi.VentaMinorista = 1 THEN DO:
                FIND FIRST vtalistaminGn WHERE vtalistaminGn.codcia = s-codcia
                    AND vtalistaminGn.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
                IF NOT AVAIL vtalistaminGn THEN DO:
                    MESSAGE 'Articulo ' + almmmatg.codmat + ' No tiene Precio' 
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                IF vtalistaminGn.MonVta = 2 THEN dPreUni = vtalistaminGn.PreOfi * vtalistaminGn.TpoCmb.
                ELSE dPreUni = vtalistaminGn.PreOfi.

                IF vtalistaminGn.DtoVolR[1] > 0 THEN DO:
                    cNotita = '*Prom.solo para pago con efectivo.'.
                    dDstoVo1 = ROUND(vtalistaminGn.PreOfi * ( 1 - ( DECI(vtalistaminGn.DtoVolD[1]) / 100 ) ),4).
                    IF vtalistaminGn.MonVta = 2 THEN dPrecio = dDstoVo1 * vtalistaminGn.TpoCmb.
                    ELSE dPrecio = dDstoVo1.                
                    x-DtoVol  = '*Precio x ' + STRING(vtalistaminGn.DtoVolR[1],'>>9') + '' + Almmmatg.undbas + '= S/.' + STRING(dPrecio,">>9.99") + 'c/u'. 
                END.
                IF vtalistaminGn.DtoVolR[2] > 0 THEN DO:
                    dDstoVo2 = ROUND(vtalistaminGn.PreOfi * ( 1 - ( DECI(vtalistaminGn.DtoVolD[2]) / 100 ) ),4).
                    IF vtalistaminGn.MonVta = 2 THEN dPrecio = dDstoVo2 * vtalistaminGn.TpoCmb.
                    ELSE dPrecio = dDstoVo2.                
                    x-DtoVo2  = '*Precio x ' + STRING(vtalistaminGn.DtoVolR[2],'>>9') + '' + Almmmatg.undbas + '= S/.' + STRING(dPrecio,">>9.99") + 'c/u'. 
                END.
            END.

            /*Si gn-divi.VentaMinorista = 2 */
            IF gn-divi.VentaMinorista = 2 THEN DO:
                FIND FIRST vtalistamin WHERE vtalistamin.codcia = s-codcia
                    AND vtalistamin.coddiv = s-coddiv
                    AND vtalistamin.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
                IF NOT AVAIL VtaListaMin THEN DO:
                    MESSAGE 'Articulo ' + almmmatg.codmat + ' No tiene Precio' 
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                IF VtaListaMin.MonVta = 2 THEN dPreUni = VtaListaMin.PreOfi * VtaListaMin.TpoCmb.
                ELSE dPreUni = VtaListaMin.PreOfi.
                IF VtaListaMin.DtoVolR[1] > 0 THEN DO:
                    cNotita = '*Prom.solo para pago con efectivo.'.
                    dDstoVo1 = ROUND(VtaListaMin.PreOfi * ( 1 - ( DECI(VtaListaMin.DtoVolD[1]) / 100 ) ),4).
                    IF VtaListaMin.MonVta = 2 THEN dPrecio = dDstoVo1 * VtaListaMin.TpoCmb.
                    ELSE dPrecio = dDstoVo1.                
                    x-DtoVol  = '*Precio x ' + STRING(VtaListaMin.DtoVolR[1],'>>9') + '' + Almmmatg.undbas + '= S/.' + STRING(dPrecio,">>9.99") + 'c/u'. 
                END.
                IF VtaListaMin.DtoVolR[2] > 0 THEN DO:
                    dDstoVo2 = ROUND(VtaListaMin.PreOfi * ( 1 - ( DECI(VtaListaMin.DtoVolD[2]) / 100 ) ),4).
                    IF VtaListaMin.MonVta = 2 THEN dPrecio = dDstoVo2 * VtaListaMin.TpoCmb.
                    ELSE dPrecio = dDstoVo2.                
                    x-DtoVo2  = '*Precio x ' + STRING(VtaListaMin.DtoVolR[2],'>>9') + '' + Almmmatg.undbas + '= S/.' + STRING(dPrecio,">>9.99") + 'c/u'. 
                END.
            END.
            
            ASSIGN 
                x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,30))
                x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,31))
                x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,30)
                x-PreUni  = 'S/.' + STRING(dPreUni,'>>>9.99').

            /*Graba en la tabla*/
            ASSIGN 
                t-desmat   = x-DesMat
                t-desmat2  = x-Desmat2
                t-desmar   = x-DesMar
                t-PreUni   = x-PreUni
                t-Observa  = cNotita
                t-DtoVol   = x-DtoVol
                t-DtoVo2   = x-DtoVo2.
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
  DISPLAY fill-in-codmat FILL-IN-file x-Desde x-Hasta rs-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE fill-in-codmat FILL-IN-file BUTTON-5 x-Desde x-Hasta rs-Tipo BUTTON-9 
         BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiqueta W-Win 
PROCEDURE Imprime-Etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dPreUni  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDsctos  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo1 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo2 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPrecio  AS DECIMAL     NO-UNDO.
    
    RUN Carga-Articulos.
    RUN Carga-Precios.

    FIND FIRST tt-articulos WHERE t-valida NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-articulos THEN DO:
        MESSAGE "No existe Articulos para Imprimir"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "adm-error".
    END.
    
    IF RETURN-VALUE = 'Adm-Error' THEN RETURN "adm-error".
    DEF VAR rpta AS LOG.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
    OUTPUT STREAM REPORTE TO PRINTER.
    FOR EACH tt-articulos NO-LOCK,
        FIRST Almmmatg WHERE Almmmatg.CodCia = s-CodCia
            AND Almmmatg.CodMat = t-codmat NO-LOCK:

        PUT STREAM REPORTE '^XA^LH50,012'                   SKIP.   /* Inicia formato */
        {alm/eti-gondolas03.i}

        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1))          SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                      SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                            SKIP.   /* Fin de formato */
        
    END.
    OUTPUT STREAM reporte CLOSE.

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

