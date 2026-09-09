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

DEF STREAM REPORTE.
DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR cl-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS txt-codcli txt-codmat txt-canped btn-print ~
BUTTON-8 txt-canemp 
&Scoped-Define DISPLAYED-OBJECTS txt-codcli txt-nomcli txt-codmat ~
txt-desmat txt-canped txt-canemp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-print 
     IMAGE-UP FILE "IMG/print-2.ico":U
     LABEL "Button 7" 
     SIZE 9 BY 2.15.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 8" 
     SIZE 9 BY 2.15.

DEFINE VARIABLE txt-canemp AS INTEGER FORMAT ">>>>>>99":U INITIAL 0 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-canped AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-desmat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codcli AT ROW 1.81 COL 12 COLON-ALIGNED WIDGET-ID 2
     txt-nomcli AT ROW 1.81 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txt-codmat AT ROW 2.88 COL 12 COLON-ALIGNED WIDGET-ID 8
     txt-desmat AT ROW 2.88 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     txt-canped AT ROW 3.96 COL 12 COLON-ALIGNED WIDGET-ID 20
     btn-print AT ROW 4.5 COL 63 WIDGET-ID 10
     BUTTON-8 AT ROW 4.5 COL 72 WIDGET-ID 18
     txt-canemp AT ROW 5.04 COL 12 COLON-ALIGNED WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.43 BY 6.69 WIDGET-ID 100.


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
         TITLE              = "IMPRESION CODIGO SAP POR ARTICULO"
         HEIGHT             = 6.69
         WIDTH              = 83.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* SETTINGS FOR FILL-IN txt-desmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPRESION CODIGO SAP POR ARTICULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPRESION CODIGO SAP POR ARTICULO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-print W-Win
ON CHOOSE OF btn-print IN FRAME F-Main /* Button 7 */
DO:
    ASSIGN
        txt-codcli txt-codmat txt-canped txt-canemp.

    IF txt-codcli = '' THEN DO:
        MESSAGE "Debe Ingresar Cliente"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO txt-codcli.
        RETURN "adm-error".
    END.

    IF txt-codmat = '' THEN DO:
        MESSAGE "Debe Ingresar Articulo"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO txt-codmat.
        RETURN "adm-error".
    END.

    IF txt-canped = 0 THEN DO:
        MESSAGE "Debe Ingresar Cantidad de productos"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO txt-canped.
        RETURN "adm-error".
    END.


    RUN Imprime-Etiqueta.
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


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli W-Win
ON LEAVE OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
  
    ASSIGN txt-codcli.
    IF txt-codcli <> '' THEN DO:
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = txt-codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN 
            DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
        ELSE DO:
            MESSAGE "No existe Cliente"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "entry" TO txt-codcli.
            RETURN "adm-error".
        END.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codmat W-Win
ON LEAVE OF txt-codmat IN FRAME F-Main /* Articulo */
DO:
  
    ASSIGN txt-codmat.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = txt-codmat NO-LOCK NO-ERROR.
    IF AVAIL almmmatg THEN 
        DISPLAY 
            almmmatg.desmat @ txt-desmat 
            almmmatg.canemp @ txt-canemp
            WITH FRAME {&FRAME-NAME}.

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
  DISPLAY txt-codcli txt-nomcli txt-codmat txt-desmat txt-canped txt-canemp 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codcli txt-codmat txt-canped btn-print BUTTON-8 txt-canemp 
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

    DEF VAR rpta AS LOG.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.        
        RUN Print.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Print W-Win 
PROCEDURE Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE x-nomcia AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-codmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desma2 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-undemp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-numcop AS INTEGER     NO-UNDO.

    DEFINE VARIABLE d-undemp AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.

    FIND FIRST VtaProxCli WHERE VtaProxCli.CodCia = s-codcia
            AND VtaProxCli.CodCli = txt-codcli
            AND VtaProxCli.CodMat = txt-codmat NO-LOCK NO-ERROR.
    IF NOT AVAIL VtaProxCli THEN RETURN "adm-error".

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = VtaProxCli.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAIL almmmatg THEN DO:
        MESSAGE "No Existe el Articulo Ingresado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "adm-error".
        APPLY "entry" TO txt-codmat IN FRAME {&FRAME-NAME}.
    END.

    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = VtaProxCli.CodCli NO-LOCK NO-ERROR.
    
    ASSIGN 
        x-nomcia = gn-clie.nomcli
        x-codmat = VtaProxCli.CodEqui
        x-desmat = SUBSTRING(Almmmatg.desmat,1,30)
        x-desma2 = SUBSTRING(Almmmatg.desmat,31)
        x-undemp = STRING(VtaProxCli.CanEmp) + " " + VtaProxCli.UndStk.
    IF (DEC(INT(txt-canped) / VtaProxCli.CanEmp) - INT(INT(txt-canped) / VtaProxCli.CanEmp))  > 0 THEN 
        x-numcop = INT(INT(txt-canped) / VtaProxCli.CanEmp) + 1.
    ELSE x-numcop = DEC(INT(txt-canped) / VtaProxCli.CanEmp).

    MESSAGE "Se imprimirá " + STRING(x-numcop) + " Copias"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    d-undemp = txt-canemp.
    DO iInt = 1 TO x-numcop:
        IF txt-canped > d-undemp THEN 
            x-undemp = STRING(txt-canemp) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
        ELSE 
            x-undemp = STRING(txt-canped - (d-undemp - txt-canemp)) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
        
        d-undemp = d-undemp + txt-canemp.
        

        PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
        {alm/codigoxbultos.i}
        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */    
    END.


/*                                                                                                        */
/*     OUTPUT STREAM REPORTE TO PRINTER.                                                                  */
/*         PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */                   */
/*         {alm/codigoxbultos.i}                                                                          */
/*                                                                                                        */
/*         PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-numcop)) SKIP.  /* Cantidad a imprimir */             */
/*         PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */ */
/*         PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */                  */
/*     OUTPUT STREAM reporte CLOSE.                                                                       */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
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

