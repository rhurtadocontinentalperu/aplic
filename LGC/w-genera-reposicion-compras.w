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
define stream REPORT.

DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt-articulo
    FIELDS tt-codmat LIKE almmmatg.codmat
    FIELDS tt-desmat LIKE almmmatg.desmat
    FIELDS tt-marca  LIKE almmmatg.desmar
    FIELDS tt-undbas LIKE almmmatg.undbas
    FIELDS tt-qfaltante AS DEC INIT 0
    FIELDS tt-qcomprar AS DEC INIT 0
    FIELDS tt-qinner AS DEC INIT 0
    FIELDS tt-qventas AS DEC INIT 0
    FIELDS tt-factor AS DEC INIT 0

    INDEX idx01 IS PRIMARY tt-codmat.

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
&Scoped-Define ENABLED-OBJECTS txtFamilias btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtArticulo txtArticulo-2 txtArticulo-3 ~
txtFamilias txtinicio txtfinal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtArticulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE txtArticulo-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE txtArticulo-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE txtFamilias AS CHARACTER FORMAT "X(256)":U INITIAL "000,001,002,010,011,012,013,014" 
     LABEL "Familias a considerar" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE txtfinal AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtinicio AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtArticulo AT ROW 1.54 COL 18 COLON-ALIGNED WIDGET-ID 6
     txtArticulo-2 AT ROW 2.5 COL 18 COLON-ALIGNED WIDGET-ID 8
     txtArticulo-3 AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 10
     txtFamilias AT ROW 5.42 COL 20 COLON-ALIGNED WIDGET-ID 2
     txtinicio AT ROW 7.23 COL 5.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     txtfinal AT ROW 7.23 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     btnProcesar AT ROW 7.23 COL 65 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.14 BY 7.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reposicion - Compras"
         HEIGHT             = 7.62
         WIDTH              = 96.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 97.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 97.29
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
/* SETTINGS FOR FILL-IN txtArticulo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtArticulo-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtArticulo-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtfinal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtinicio IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reposicion - Compras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reposicion - Compras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar W-Win
ON CHOOSE OF btnProcesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtFamilias.
  RUN ue-procesar.
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
  DISPLAY txtArticulo txtArticulo-2 txtArticulo-3 txtFamilias txtinicio txtfinal 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtFamilias btnProcesar 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-Archivo = STRING(NOW,"99-99-9999 hh:mm:ss").
x-Archivo = REPLACE(x-Archivo,"-","").
x-Archivo = REPLACE(x-Archivo,":","").
x-Archivo = "TXT-" + REPLACE(x-Archivo," ","") + ".txt".
/*x-Archivo = 'PagSinIngreso.txt'.*/
SYSTEM-DIALOG GET-FILE x-Archivo
FILTERS 'Texto' '*.txt'
ASK-OVERWRITE
CREATE-TEST-FILE
DEFAULT-EXTENSION '.txt'
INITIAL-DIR 'c:\tmp'
RETURN-TO-START-DIR 
USE-FILENAME
SAVE-AS
UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.

DEFINE VAR lStockAlmFantante AS DEC.        
DEFINE VAR lStockComprar AS DEC.
DEFINE VAR lDoctosVta AS CHAR.
DEFINE VAR lDocto AS CHAR.
DEFINE VAR lFam AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR ldoc AS INT.
DEFINE VAR lsec AS INT.
DEFINE VAR lSigno AS INT.
DEFINE VAR lImpteVta AS DEC.

EMPTY TEMP-TABLE tt-articulo.
        
SESSION:SET-WAIT-STATE('GENERAL').

txtFamilias = TRIM(txtFamilias).

txtInicio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NOW,"99-99-9999 hh:mm:ss").

DO lSec = 1 TO NUM-ENTRIES(txtFamilias):
    lFam = ENTRY(lSec,txtFamilias,",").
    FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
            /*LOOKUP(almmmatg.codfam,txtFamilias) > 0 AND*/
            almmmatg.codfam = lFam NO-LOCK :
        txtArticulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.codmat.
        txtArticulo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        txtArticulo-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        IF  almmmatg.tpoart = 'A' THEN DO:
            lStockAlmFantante = 0.
            FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = Almmmatg.codcia
                AND (Almmmatg.TpoMrg = "" OR Almacen.Campo-C[2] = Almmmatg.TpoMrg)  /* Tipo Almacén */
                AND Almacen.Campo-C[6] = "Si"       /* Comercial */
                AND Almacen.Campo-C[3] <> "Si"      /* No Remates */
                AND Almacen.Campo-C[9] <> "I"       /* No Inactivo */
                AND Almacen.AlmCsg = NO,            /* No de Consignación */
                EACH Almmmate NO-LOCK WHERE Almmmate.codcia = Almmmatg.codcia
                AND Almmmate.codalm = Almacen.codalm
                AND Almmmate.codmat = Almmmatg.codmat :
                txtArticulo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.codmat + " / " + Almmmate.codalm.
                /*
                FIND FIRST VtaAlmDiv WHERE VtaAlmDiv.CodCia = Almacen.codcia
                    AND VtaAlmDiv.CodDiv = Almacen.coddiv
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE VtaAlmDiv THEN NEXT.
                IF VtaAlmDiv.codalm <> Almacen.codalm THEN NEXT.
                */        
                IF (almmmate.stkmin - almmmate.stkact) <= 0 THEN NEXT.
                lStockAlmFantante = lStockAlmFantante + (almmmate.stkmin - almmmate.stkact).        
            END.

           IF almmmatg.stkrep <= 0 THEN DO:
               lStockComprar = lStockAlmFantante.
           END.
           ELSE DO:
                lStockComprar = ROUND(lStockAlmFantante / almmmatg.stkrep , 0) * almmmatg.stkrep.
           END.
           /* Ventas */
           lImpteVta = 0.
           /*
           lDoctosVta = "FAC,BOL,TCK,N/C".           
           FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
                DO lsec = 0 TO 30:
                    lfecha = TODAY - lsec.
                     DO ldoc = 1 TO NUM-ENTRIES(lDoctosVta):
                        lDocto = ENTRY(ldoc,lDoctosVta,",").

                        FOR EACH ccbddocu USE-INDEX llave03 WHERE ccbddocu.codcia = s-codcia AND
                                        ccbddocu.coddiv = gn-divi.coddiv AND 
                                        ccbddocu.codmat = almmmatg.codmat AND 
                                        ccbddocu.fchdoc = lfecha AND
                                        ccbddocu.coddoc = lDocto NO-LOCK:
                            lsigno = IF(lDocto = 'N/C') THEN -1 ELSE 1.
                            lImpteVta = lImpteVta + ((ccbddocu.Candes * ccbddocu.factor) * lSigno).                       

                            txtArticulo-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.codmat + " / " + 
                                STRING(lFecha,"99/99/9999") + " / " +
                                gn-divi.coddiv + " / " + lDocto.
                        END.
                        
                     END.
                END.
           END.
           */
           DO lsec = 0 TO 30:
                lfecha = TODAY - lsec.
                txtArticulo-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.codmat + " / " + 
                    STRING(lFecha,"99/99/9999") + " / ".
                FOR EACH estavtas.ventasxproducto WHERE estavtas.ventasxproducto.datekey = lFecha AND
                        estavtas.ventasxproducto.codmat = almmmatg.codmat NO-LOCK:
                    lImpteVta = lImpteVta + estavtas.ventasxproducto.cantidad.
                END.
           END.
           /* Guardar los datos */
           CREATE tt-articulo.
            ASSIGN tt-codmat = almmmatg.codmat
                    tt-desmat = almmmatg.desmat
                    tt-marca = almmmatg.desmar
                    tt-undbas = almmmatg.undbas
                    tt-qfaltante = lStockAlmFantante
                    tt-qcomprar = lStockComprar
                    tt-qinner = almmmatg.stkrep
                    tt-qventas = lImpteVta
                    tt-factor = if( almmmatg.stkrep <> 0) THEN lImpteVta / almmmatg.stkrep ELSE 0.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').
txtFinal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NOW,"99-99-9999 hh:mm:ss").

RUN ue-texto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-texto W-Win 
PROCEDURE ue-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OUTPUT STREAM REPORT TO VALUE(x-Archivo).

PUT STREAM REPORT
  "Codigo|" 
  "Descripcion|"      
  "Marca|"      
  "Unidad|"
  "Cant.Faltante|"
  "Cant.Comprar|"      
  "Inner|"      
  "Cant.Ventas|"      
  "Veces Compradas" SKIP.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH tt-articulo :
        PUT STREAM REPORT
            tt-articulo.tt-codmat "|"
            tt-articulo.tt-desmat "|"
            tt-articulo.tt-marca "|"
            tt-articulo.tt-undbas "|"
            tt-articulo.tt-qfaltante "|"
            tt-articulo.tt-qcomprar "|"
            tt-articulo.tt-qinner "|"
            tt-articulo.tt-qventas "|"
            tt-articulo.tt-factor SKIP.
END.

SESSION:SET-WAIT-STATE('').

OUTPUT STREAM REPORT CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

