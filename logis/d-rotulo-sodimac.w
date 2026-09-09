&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE INPUT PARAMETER pCodOrden AS CHAR.
DEFINE INPUT PARAMETER pNroOrden AS CHAR.

/* Local Variable Definitions ---                                       */


FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = pCodOrden AND
                            faccpedi.nroped = pNroOrden NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "Orden " + pCodOrden + " - " + pNroOrden + " no existe".
    RETURN ERROR.
END.

DEFINE VAR iBultos AS INT.
DEF STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-bultos FILL-IN-tienda ~
FILL-IN-tiendanombre FILL-IN-proveedor FILL-IN-envios Btn_Cancel Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-bultos FILL-IN-tienda ~
FILL-IN-tiendanombre FILL-IN-proveedor FILL-IN-envios FILL-IN-codcli ~
FILL-IN-orden FILL-IN-oc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Imprimir" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-bultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codcli AS CHARACTER FORMAT "X(120)":U 
     LABEL "Cliente" 
      VIEW-AS TEXT 
     SIZE 53.72 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-envios AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Envios" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-oc AS CHARACTER FORMAT "X(15)":U 
     LABEL "O/C" 
      VIEW-AS TEXT 
     SIZE 16 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS CHARACTER FORMAT "X(25)":U 
     LABEL "Orden" 
      VIEW-AS TEXT 
     SIZE 16 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-proveedor AS CHARACTER FORMAT "X(15)":U INITIAL "3000003705" 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-tienda AS CHARACTER FORMAT "X(5)":U 
     LABEL "Tienda" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tiendanombre AS CHARACTER FORMAT "X(100)":U INITIAL "SODIMAC" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-bultos AT ROW 4.08 COL 35 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-tienda AT ROW 5.42 COL 8 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-tiendanombre AT ROW 6.58 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-proveedor AT ROW 8.12 COL 10 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-envios AT ROW 8.12 COL 40 COLON-ALIGNED WIDGET-ID 14
     Btn_Cancel AT ROW 10.04 COL 7
     Btn_Help AT ROW 10.04 COL 24
     Btn_OK AT ROW 10.04 COL 42
     FILL-IN-codcli AT ROW 1.35 COL 8.29 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-orden AT ROW 2.35 COL 8 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-oc AT ROW 4.08 COL 8 COLON-ALIGNED WIDGET-ID 8
     SPACE(39.13) SKIP(7.24)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Impresion rotulos SODIMAC" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-codcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-codcli:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-oc IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-oc:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-orden:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON END-ERROR OF FRAME D-Dialog /* Impresion rotulos SODIMAC */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Impresion rotulos SODIMAC */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Imprimir */
DO:
    btn_ok:AUTO-GO = NO.

    ASSIGN fill-in-oc fill-in-bultos fill-in-tienda fill-in-tiendanombre fill-in-envios fill-in-proveedor.

    DEFINE VAR cMsg AS CHAR.

    IF TRUE <> (fill-in-oc > "") THEN cMsg = "Falta O/C".
    IF fill-in-bultos <= 0 OR fill-in-bultos > iBultos THEN cMsg = "Los bultos deben ser mayor a cero ó menor/igual a " + STRING(iBultos).
    IF TRUE <> (fill-in-tienda > "") THEN cMsg = "Debe ingresar la tienda".
    IF TRUE <> (fill-in-tiendanombre > "") THEN cMsg = "Debe ingresar el nombre de tienda".
    IF TRUE <> (fill-in-proveedor > "") THEN cMsg = "Debe ingresar el proveedor".
    IF fill-in-envios <= 0 THEN cMsg = "Ingrese el numero de envios".

    IF cMsg > "" THEN DO:
        MESSAGE cMsg VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    MESSAGE 'Seguro de imprimir ' + string(fill-in-bultos) + ' rotulos?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = YES THEN DO:       
       btn_ok:AUTO-GO = YES.  

       RUN imprime_rotulo.  
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-tiendanombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-tiendanombre D-Dialog
ON LEAVE OF FILL-IN-tiendanombre IN FRAME D-Dialog
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE codigo-anterior D-Dialog 
PROCEDURE codigo-anterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/* formato con errores */
REPEAT iSec = 1 TO fill-in-bultos:
    PUT STREAM REPORTE UNFORMATTED "^XA" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^CI28^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^MCY^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^PON^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LH0,0^FS" SKIP.

    /* Ancho 10.1cm y Largo 7.7cm */
    PUT STREAM REPORTE UNFORMATTED "^PW816" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LL600" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LS0" SKIP.

    /* Pintamos textos */
    PUT STREAM REPORTE UNFORMATTED "^FT50,100^A0N,45,45^FD OC : " + STRING(fill-in-oc) + 
                                    " FECHA : " + STRING(TODAY,'99/99/9999') + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT50,170^A0N,45,45^FD TIENDA : " + STRING(fill-in-tienda)+ "^FS" SKIP.

    PUT STREAM REPORTE UNFORMATTED "^FT50,240^A0N,35,35^FD " + cNomb1 + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT50,290^A0N,35,35^FD " + cNomb2 + "^FS" SKIP.

    /* Ancho de la barra */
    PUT STREAM REPORTE UNFORMATTED "^BY3,3,160" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^^FO120,340" SKIP.
    /* Code 128 */
    PUT STREAM REPORTE UNFORMATTED "^BCN,160,Y,N,N,A" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FD" + cBarra + "^FS" SKIP.

    /* Fin */
    PUT STREAM REPORTE UNFORMATTED "^XZ" SKIP.
END.
*/
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-bultos FILL-IN-tienda FILL-IN-tiendanombre FILL-IN-proveedor 
          FILL-IN-envios FILL-IN-codcli FILL-IN-orden FILL-IN-oc 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-bultos FILL-IN-tienda FILL-IN-tiendanombre FILL-IN-proveedor 
         FILL-IN-envios Btn_Cancel Btn_OK 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime_rotulo D-Dialog 
PROCEDURE imprime_rotulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-papel AS LOG.

x-papel = YES.

/*
IF LOOKUP(USERID("DICTDB"),"ADMIN,MASTER") > 0 THEN DO:
    x-papel = NO.
END.
*/

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    MESSAGE "Se envia a Archivo".
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "sodimac.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.

DEFINE VAR cNomb1 AS CHAR.
DEFINE VAR cNomb2 AS CHAR.
DEFINE VAR cBarra AS CHAR.
DEFINE VAR iSec AS INT.

/* cNomb1 = trim(fill-in-tiendanombre).                */
/* IF LENGTH(TRIM(fill-in-tiendanombre)) > 25 THEN DO: */
/*     cNomb1 = SUBSTR(fill-in-tiendanombre,1,25).     */
/*     cNomb2 = SUBSTR(fill-in-tiendanombre,26,25).    */
/* END.                                                */

FILL-IN-tiendanombre = REPLACE(FILL-IN-tiendanombre, ",", " ").

DEFINE VARIABLE v-Resultado AS CHARACTER NO-UNDO.

RUN lib/SplitTextBySpace (
    INPUT FILL-IN-tiendanombre, 
    INPUT 25, 
    OUTPUT v-Resultado
).
cNomb1 = ENTRY(1,v-Resultado).
IF NUM-ENTRIES(v-Resultado ) > 1 THEN cNomb2 = ENTRY(2,v-Resultado).

cBarra = fill-in-proveedor + STRING(fill-in-envios,"99999999").

DEF VAR cTitulo1 AS CHAR NO-UNDO.
DEF VAR cTitulo2 AS CHAR NO-UNDO.
DEF VAR cTitulo3 AS CHAR NO-UNDO.
DEF VAR cTitulo4 AS CHAR NO-UNDO.
DEF VAR cTitulo5 AS CHAR NO-UNDO.

cTitulo1 = "OC " + TRIM(STRING(fill-in-oc)).
cTitulo2 = "FECHA " + STRING(TODAY,'99/99/9999').

cTitulo3 = "TIENDA: " + TRIM(FILL-IN-tienda).
cTitulo4 = TRIM(cNomb1).
cTitulo5 = TRIM(cNomb2).

/* Impresión a 203 DPI = 8.12 puntos x mm */
REPEAT iSec = 1 TO fill-in-bultos:
    PUT STREAM REPORTE UNFORMATTED "^XA" SKIP.      /* Inicio */
    PUT STREAM REPORTE UNFORMATTED "^LT10" SKIP.      /* Inicio */
    PUT STREAM REPORTE UNFORMATTED "^CI28" SKIP.    /* UTF-8 */
    PUT STREAM REPORTE UNFORMATTED "^PW820" SKIP.   /* 820 puntos = 10.1cm */
    PUT STREAM REPORTE UNFORMATTED "^LL609" SKIP.   /* 609 puntos = 7.5cm  (609 / 8.12 ~ 75mm)*/
    PUT STREAM REPORTE UNFORMATTED "^LH0,0" SKIP.   /* coordenada 0,0 punto de inicio */
    PUT STREAM REPORTE UNFORMATTED "^PR6,6" SKIP.   /* velocidad */
    PUT STREAM REPORTE UNFORMATTED "^MD10" SKIP.    /* tono impresión */
    PUT STREAM REPORTE UNFORMATTED "^PON" SKIP.     /* Orientación de impresión N (norma) */
    PUT STREAM REPORTE UNFORMATTED "^LS0" SKIP.     /* Todo a la izquierda */
    PUT STREAM REPORTE UNFORMATTED "^CFD,35" SKIP.  /* Font */

    /* Pintamos textos */
    PUT STREAM REPORTE UNFORMATTED "^FO56,40^FB640,1,0,L,0^FD" + TRIM(cTitulo1) + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FO56,100^FD" + TRIM(cTitulo2) + "^FS" SKIP.

    PUT STREAM REPORTE UNFORMATTED "^FO56,160^FD" + cTitulo3 + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FO56,220^FD" + cTitulo4 + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FO56,280^FD" + cTitulo5 + "^FS" SKIP.

    /* Ancho de la barra */
    /* Largo: 8.75cm (710 dots) alto 2.5 cm (203 dots) */
    PUT STREAM REPORTE UNFORMATTED "^BY3,2,160" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FO56,360" SKIP.
    /* Code 128 */
    PUT STREAM REPORTE UNFORMATTED "^BCN,160,Y,N,N" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FD" + cBarra + "^FS" SKIP.

    /* Fin */
    PUT STREAM REPORTE UNFORMATTED "^XZ" SKIP.
END.
/* FUNCIONANDO con 300 DPI 
    PUT STREAM REPORTE UNFORMATTED "^XA" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^CI28^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^MCY^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^PON^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LH0,0^FS" SKIP.

    /* Ancho 10.1cm y Largo 7.7cm */
    /* Con 300 DPI */
    PUT STREAM REPORTE UNFORMATTED "^PW1224" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LL900" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LS0" SKIP.

    /* Pintanmos un marco: 101 x 75 mm */
    /*PUT STREAM REPORTE UNFORMATTED "^FO6,6^GB800,600,3^FS" SKIP.*/

    /* Pintamos textos */
    PUT STREAM REPORTE UNFORMATTED "^FT60,120^A0N,68,68^FD OC : " + STRING(fill-in-oc) + 
                                    " FECHA : " + STRING(TODAY,'99/99/9999') + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT60,225^A0N,68,68^FD TIENDA : " + STRING(fill-in-tienda)+ "^FS" SKIP.

    PUT STREAM REPORTE UNFORMATTED "^FT60,330^A0N,52,52^FD " + cNomb1 + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT60,405^A0N,52,52^FD " + cNomb2 + "^FS" SKIP.

    /* Ancho de la barra */
    PUT STREAM REPORTE UNFORMATTED "^BY4,3,240" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^^FO120,510" SKIP.
    /* Code 128 */
    PUT STREAM REPORTE UNFORMATTED "^BCN,240,Y,N,N,A" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FD" + cBarra + "^FS" SKIP.

    /* Fin */
    PUT STREAM REPORTE UNFORMATTED "^XZ" SKIP.

*/
/*  FUNCIONANDO CON 203 DPI
    PUT STREAM REPORTE UNFORMATTED "^XA" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^CI28^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^MCY^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^PON^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LH0,0^FS" SKIP.

    /* Ancho 10.1cm y Largo 7.7cm */
    PUT STREAM REPORTE UNFORMATTED "^PW816" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LL600" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LS0" SKIP.

    /* Pintanmos un marco: 101 x 75 mm */
    /*PUT STREAM REPORTE UNFORMATTED "^FO6,6^GB800,600,3^FS" SKIP.*/

    /* Pintamos textos */
    PUT STREAM REPORTE UNFORMATTED "^FT50,80^A0N,45,45^FD OC : " + STRING(fill-in-oc) + 
                                    " FECHA : " + STRING(TODAY,'99/99/9999') + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT50,150^A0N,45,45^FD TIENDA : " + STRING(fill-in-tienda)+ "^FS" SKIP.

    PUT STREAM REPORTE UNFORMATTED "^FT50,220^A0N,35,35^FD " + cNomb1 + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT50,270^A0N,35,35^FD " + cNomb2 + "^FS" SKIP.

    /* Ancho de la barra */
    PUT STREAM REPORTE UNFORMATTED "^BY3,3,160" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^^FO120,340" SKIP.
    /* Code 128 */
    PUT STREAM REPORTE UNFORMATTED "^BCN,160,Y,N,N,A" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FD" + cBarra + "^FS" SKIP.

    /* Fin */
    PUT STREAM REPORTE UNFORMATTED "^XZ" SKIP.
*/
OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.


/*
/* 01/04/2026: Correción a CODE 128 */
/* opción 1, reducción de letras y mejora en el código de barras */
REPEAT iSec = 1 TO fill-in-bultos:
    PUT STREAM REPORTE UNFORMATTED "^XA" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LH0,0" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^PW812" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^LL480" SKIP.

    /* Textos reducidos fuente A */
    PUT STREAM REPORTE UNFORMATTED "^FT56,50^A0N,35,35^FDO/C : " + STRING(fill-in-oc) + 
        "    FECHA : " + STRING(TODAY,'99/99/9999') + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT56,95^A0N,35,35^FDTIENDA : " + STRING(fill-in-tienda) + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT56,140^A0N,25,25^FD" + cNomb1  + "^FS" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FT56,170^A0N,25,25^FD" + cNomb2  SKIP.

    /* Configuración del Código de Barras 
       Margen izquierdo 0.7cm = 56 puntos
       Altura 2.5cm = 200 puntos
       Largo aproximado 8.75cm utilizando ^BY3 
    */
    PUT STREAM REPORTE UNFORMATTED "^BY3,3,200" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FO56,190" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^BCN,200,Y,N,N,A" SKIP.
    PUT STREAM REPORTE UNFORMATTED "^FD" + cBarra  + "^FS" SKIP.

    PUT STREAM REPORTE UNFORMATTED "^XZ" SKIP.
END.
*/

/* opción 2, casi similar al formato obsoleto 
REPEAT iSec = 1 TO fill-in-bultos:
    PUT STREAM REPORTE "^XA" SKIP.
    PUT STREAM REPORTE "^LH0,0" SKIP.
    PUT STREAM REPORTE "^FO05,10^GB790,580,3^FS" SKIP.

    PUT STREAM REPORTE "^FT20,150" SKIP.
    PUT STREAM REPORTE "^AUN^FDO/C : " + STRING(fill-in-oc) FORMAT 'x(25)' + "^FS" SKIP.

    PUT STREAM REPORTE "^FT20,220" SKIP.
    PUT STREAM REPORTE "^AUN^FDTIENDA : " + STRING(fill-in-tienda) FORMAT 'x(25)' + "^FS" SKIP.

    PUT STREAM REPORTE "^FT20,280" SKIP.
    PUT STREAM REPORTE "^AUN^FD" + cNomb1 FORMAT 'x(40)' + "^FS" SKIP.

    PUT STREAM REPORTE "^FT20,340" SKIP.
    PUT STREAM REPORTE "^AUN^FD" + cNomb2 FORMAT 'x(40)' SKIP.

    PUT STREAM REPORTE "^BY3" SKIP.
    PUT STREAM REPORTE "^FO70,400" SKIP.
    PUT STREAM REPORTE "^BCN,140,Y,N,N,A" SKIP.
    PUT STREAM REPORTE "^FD" + cBarra FORMAT 'x(30)' + "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime_rotulo_old D-Dialog 
PROCEDURE imprime_rotulo_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*ASSIGN fill-in-oc fill-in-bultos fill-in-tienda fill-in-tiendanombre fill-in-envios fill-in-proveedor.*/

DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF LOOKUP(USERID("DICTDB"),"ADMIN,MASTER") > 0 THEN DO:
    x-papel = NO.
END.

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    MESSAGE "Se envia a Archivo".
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "sodimac.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.

DEFINE VAR cNomb1 AS CHAR.
DEFINE VAR cNomb2 AS CHAR.
DEFINE VAR cBarra AS CHAR.
DEFINE VAR iSec AS INT.

cNomb1 = trim(fill-in-tiendanombre).
IF LENGTH(TRIM(fill-in-tiendanombre)) > 30 THEN DO:
    cNomb1 = SUBSTR(fill-in-tiendanombre,1,30).
    cNomb2 = SUBSTR(fill-in-tiendanombre,31,30).
END.

cBarra = fill-in-proveedor + STRING(fill-in-envios,"99999999").

REPEAT iSec = 1 TO fill-in-bultos:
    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    PUT STREAM REPORTE "^XA" SKIP.
    PUT STREAM REPORTE "^FO05,10^GB790,580,3^FS" SKIP.
    PUT STREAM REPORTE "^FT20,150" SKIP.
    PUT STREAM REPORTE "^AUN^FDO/C : " + STRING(fill-in-oc) FORMAT 'x(25)'  SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT20,220" SKIP.
    PUT STREAM REPORTE "^AUN^FDTIENDA : " + STRING(fill-in-tienda) FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT20,280" SKIP.
    PUT STREAM REPORTE "^AUN^FD" + cNomb1 FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT20,340" SKIP.
    PUT STREAM REPORTE "^AUN^FD" + cNomb2 FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT0070, 520" SKIP.
    PUT STREAM REPORTE "^BCN,150,Y,N,N" SKIP.
    PUT STREAM REPORTE "^FD" + cBarra FORMAT 'x(30)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.

/*
^XA^LH010,010
^XA
^FO05,10^GB790,580,3^FS

^FT20,150
^AUN^FDO/C :
^FS

^FT20,220
^AUN^FDTIENDA :
^FS

^FT20,280
^AUN^FDSODIMAC SAN JUAN DE LURIGANCHO
^FS

^FT20,340
^AUN^FDOFICINAS ADMINISTRATIVAS
^FS

^FT0120, 520
^BCN,150,Y,N,N
^FD300000370500000400
^FS
 */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  iBultos = 0.

  DO WITH FRAME {&FRAME-NAME}:
      fill-in-orden:SCREEN-VALUE = faccpedi.coddoc + " - " + faccpedi.nroped.
      fill-in-codcli:SCREEN-VALUE = faccpedi.codcli + " - " + faccpedi.nomcli.
      fill-in-oc:SCREEN-VALUE = faccpedi.ordcmp.

      FIND FIRST ccbcbult WHERE ccbcbult.codcia = 1 AND ccbcbult.coddoc = faccpedi.coddoc AND
                                ccbcbult.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
      IF AVAILABLE ccbcbult THEN DO:
          FILL-in-bultos:SCREEN-VALUE = STRING(ccbcbult.bultos).

          iBultos = ccbcbult.bultos.
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE posible-codigo D-Dialog 
PROCEDURE posible-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
^XA
^CI28
^PW820
^LL609
^LH0,0
^PR4,4
^MD15
^PON
^LS0

$ --- SECCIÓN DE TEXTO (Margen X=56) --- $
^FT56,100^A0N,50,50^FDOC: 1111111 FECHA: 27/04/2026^FS
^FT56,170^A0N,50,50^FDTIENDA: 12345^FS

$ --- NOMBRE DE TIENDA (Doble línea) --- $
^FT56,230^A0N,35,35^FDSODIMAC PUENTE DE PIEDRA Y VIL^FS
^FT56,280^A0N,35,35^FDLA EL SALVADOR^FS

$ --- CONFIGURACIÓN CÓDIGO DE BARRAS --- $
$ Largo: 8.75cm (~710 dots) | Alto: 2.5cm (203 dots) $
$ BY(ancho_barra, ratio, altura) $
^BY3,3,203
^FO56,330
^BCN,203,Y,N,N,B
^FD300000370500000001^FS

^XZ
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

