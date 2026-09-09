&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.

/* 10/06/2024 Juan Ponte: Solo ACTIVOS */
&SCOPED-DEFINE Condicion ( ~
    (TRUE <> (FILL-IN-CodMat-Desde > '') OR Almmmatg.codmat >= FILL-IN-CodMat-Desde) AND ~
    (TRUE <> (FILL-IN-CodMat-Hasta > '') OR Almmmatg.codmat <= FILL-IN-CodMat-Hasta) AND ~
    (COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = COMBO-BOX-Linea) AND ~
    (COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = COMBO-BOX-SubLinea) AND ~
    (TRUE <> (FILL-IN-CodPro > '') OR Almmmatg.CodPr1 = FILL-IN-CodPro) AND ~
    (TRUE <> (FILL-IN-CodMar > '') OR Almmmatg.DesMar BEGINS FILL-IN-CodMar) AND ~
    Almmmatg.TpoArt = "A" )

DEF VAR s-Vista-Previa AS LOG INIT NO NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.codfam Almmmatg.subfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almmmatg ~
      WHERE s-Vista-Previa and {&Condicion} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almmmatg ~
      WHERE s-Vista-Previa and {&Condicion} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-CodMat-Desde BUTTON-Refresh ~
FILL-IN-CodMat-Hasta BUTTON-Clean COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodPro FILL-IN-CodMar BROWSE-2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat-Desde FILL-IN-DesMat-Desde ~
FILL-IN-CodMat-Hasta FILL-IN-DesMat-Hasta COMBO-BOX-Linea ~
COMBO-BOX-Sublinea FILL-IN-CodPro FILL-IN-NomPro FILL-IN-CodMar ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "SALIR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 FONT 6.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "ASIGNAR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 FONT 6.

DEFINE BUTTON BUTTON-Clean 
     LABEL "LIMPIAR FILTROS" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Refresh 
     LABEL "VISTA PREVIA" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "TODAS","TODAS"
     DROP-DOWN-LIST
     SIZE 87 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "TODAS","TODAS"
     DROP-DOWN-LIST
     SIZE 87 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMar AS CHARACTER FORMAT "X(8)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat-Desde AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat-Hasta AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat-Desde AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat-Hasta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 128 BY 7.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(12)":U
      Almmmatg.DesMat FORMAT "X(100)":U WIDTH 83.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 14.72
      Almmmatg.codfam COLUMN-LABEL "Línea" FORMAT "X(5)":U
      Almmmatg.subfam COLUMN-LABEL "SubLínea" FORMAT "X(5)":U WIDTH 6.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 16.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CodMat-Desde AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-DesMat-Desde AT ROW 1.54 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-Refresh AT ROW 1.54 COL 111 WIDGET-ID 26
     FILL-IN-CodMat-Hasta AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-DesMat-Hasta AT ROW 2.62 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     BUTTON-Clean AT ROW 2.62 COL 111 WIDGET-ID 32
     COMBO-BOX-Linea AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Sublinea AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodPro AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomPro AT ROW 5.85 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-CodMar AT ROW 6.92 COL 19 COLON-ALIGNED WIDGET-ID 16
     BROWSE-2 AT ROW 8.27 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 25.5 COL 2
     Btn_Cancel AT ROW 25.5 COL 17
     FILL-IN-Mensaje AT ROW 25.77 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "ttttt" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 5.04 COL 114 WIDGET-ID 34
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1 COL 3 WIDGET-ID 30
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 28
     SPACE(2.85) SKIP(18.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ASIGNACION AUTOMATICA DE ARTICULOS POR ALMACEN"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 FILL-IN-CodMar D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_OK IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat-Desde IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat-Hasta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK"
     _Where[1]         = "s-Vista-Previa and {&Condicion}"
     _FldNameList[1]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Codigo" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "83.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.codfam
"Almmmatg.codfam" "Línea" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.subfam
"Almmmatg.subfam" "SubLínea" "X(5)" "character" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* ASIGNACION AUTOMATICA DE ARTICULOS POR ALMACEN */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* ASIGNAR */
DO:
    MESSAGE 'Procedemos con la asignación automática de artículos por almacén?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    DEFINE VAR pMensaje AS CHAR NO-UNDO.
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN alm/almacen-library PERSISTENT SET hProc.

    GET FIRST {&browse-name}.
    DO WHILE NOT QUERY-OFF-END('{&browse-name}'):
        Fi-Mensaje = "ARTICULO: " + Almmmatg.codmat.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        RUN ALM_Materiales-por-Almacen IN hProc ("",                    /* Todos los almacenes */
                                                 INPUT Almmmatg.CodMat,
                                                 INPUT "A",
                                                 OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE pMensaje SKIP(2)
                'Se continuará con el siguiente artículo' VIEW-AS ALERT-BOX WARNING.
        END.
        GET NEXT {&browse-name}.
    END.
    DELETE PROCEDURE hProc.
    HIDE FRAME F-proceso.
    MESSAGE 'Asignación culminada' VIEW-AS ALERT-BOX INFORMATION.
    APPLY 'CHOOSE':U TO BUTTON-Clean.

    /*
    ASSIGN COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMat.
    ASSIGN FILL-IN-CodPro FILL-IN-CodMar.


    DEFINE VAR pMensaje AS CHAR NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN alm/almacen-library PERSISTENT SET hProc.

    CASE TRUE:
        WHEN FILL-IN-CodMat > '' THEN DO:
            RUN ALM_Materiales-por-Almacen IN hProc ("",
                                                     INPUT FILL-IN-CodMat,
                                                     INPUT "A",
                                                     OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
                RETURN NO-APPLY.
            END.
        END.
        OTHERWISE DO:
            FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = s-CodCia
                AND Almmmatg.TpoArt <> "D"      /* NO Desactivados */
                AND (COMBO-BOX-Linea = 'TODAS' OR Almmmatg.codfam = COMBO-BOX-Linea)
                AND (COMBO-BOX-Sublinea = 'TODAS' OR Almmmatg.subfam = COMBO-BOX-Sublinea)
                AND (TRUE <> (FILL-IN-CodPro > '') OR Almmmatg.CodPr1 = FILL-IN-CodPro)
                AND (TRUE <> (FILL-IN-CodMar > '') OR Almmmatg.CodMar = FILL-IN-CodMar):
                /*AND TRUE <> (Almmmatg.Almacenes > ''):*/
                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' + Almmmatg.codmat.
                RUN ALM_Materiales-por-Almacen IN hProc (INPUT "",      /* TODOS los almacenes */
                                                         INPUT Almmmatg.CodMat,
                                                         INPUT "A",     /* Solo automáticos */
                                                         OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    MESSAGE pMensaje SKIP(1)
                        'Se continuará el proceso con el siguiente artículo'
                        VIEW-AS ALERT-BOX WARNING.
                END.
            END.
        END.
    END CASE.
    DELETE PROCEDURE hProc.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Clean
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Clean D-Dialog
ON CHOOSE OF BUTTON-Clean IN FRAME D-Dialog /* LIMPIAR FILTROS */
DO:
    DEF VAR k AS INTE NO-UNDO.
    
    DO WITH FRAME {&FRAME-NAME}:
/*         DO k = 1 TO COMBO-BOX-Sublinea:NUM-ITEMS: */
/*             COMBO-BOX-Sublinea:DELETE(1).         */
/*         END.                                      */
        COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEM-PAIRS).
        COMBO-BOX-Sublinea:ADD-LAST("TODAS","TODAS").
        ASSIGN
            COMBO-BOX-Linea = 'Todas'
            COMBO-BOX-Sublinea = 'Todas'
            FILL-IN-CodMar = ''
            FILL-IN-CodMat-Desde = ''
            FILL-IN-CodMat-Hasta = ''
            FILL-IN-CodPro = ''
            /*FILL-IN-DesMar = ''*/
            FILL-IN-DesMat-Desde = ''
            FILL-IN-DesMat-Hasta = ''
            FILL-IN-NomPro = ''.
        DISPLAY COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMar FILL-IN-CodMat-Desde 
            FILL-IN-CodMat-Hasta FILL-IN-CodPro /*FILL-IN-DesMar*/ FILL-IN-DesMat-Desde 
            FILL-IN-DesMat-Hasta FILL-IN-NomPro
            WITH FRAME {&FRAME-NAME}.
        COMBO-BOX-Linea:SCREEN-VALUE = 'TODAS'.
        COMBO-BOX-Sublinea:SCREEN-VALUE = 'TODAS'.
        Btn_OK:SENSITIVE = NO.
        s-Vista-Previa = NO.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY 'ENTRY':U TO FILL-IN-CodMat-Desde.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refresh D-Dialog
ON CHOOSE OF BUTTON-Refresh IN FRAME D-Dialog /* VISTA PREVIA */
DO:
  ASSIGN
      COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMar FILL-IN-CodMat-Desde 
      FILL-IN-CodMat-Hasta FILL-IN-CodPro FILL-IN-DesMat-Desde FILL-IN-DesMat-Hasta.
  IF TRUE <> ((FILL-IN-CodMat-Desde + FILL-IN-CodMat-Hasta + FILL-IN-CodPro + FILL-IN-CodMar) > '') AND
      COMBO-BOX-Linea = 'Todas' AND COMBO-BOX-Sublinea = 'Todas'
      THEN DO:
      MESSAGE 'Debe configurar al menos un filtro' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  s-Vista-Previa = YES.
  Btn_OK:SENSITIVE = YES.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME D-Dialog /* Linea */
DO:
  ASSIGN COMBO-BOX-Linea.

  DEF VAR k AS INTE NO-UNDO.
  DO k = 1 TO COMBO-BOX-Sublinea:NUM-ITEMS:
      COMBO-BOX-Sublinea:DELETE(1).
  END.
  COMBO-BOX-Sublinea:ADD-LAST("TODAS","TODAS").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "TODAS".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = COMBO-BOX-Linea:
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub,AlmSFami.subfam).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME D-Dialog /* Sublinea */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMar D-Dialog
ON LEAVE OF FILL-IN-CodMar IN FRAME D-Dialog /* Marca */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
/*   FIND almtabla WHERE almtabla.Tabla = "MK" AND                    */
/*       almtabla.Codigo = SELF:SCREEN-VALUE                          */
/*       NO-LOCK NO-ERROR.                                            */
/*   IF NOT AVAILABLE Almtabla THEN DO:                               */
/*       MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR. */
/*       SELF:SCREEN-VALUE = ''.                                      */
/*       RETURN NO-APPLY.                                             */
/*   END.                                                             */
/*   FILL-IN-DesMar:SCREEN-VALUE = almtabla.Nombre.                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat-Desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat-Desde D-Dialog
ON LEAVE OF FILL-IN-CodMat-Desde IN FRAME D-Dialog /* Artículo Desde */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
      AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Artículo no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMat-Desde:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat-Desde D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodMat-Desde IN FRAME D-Dialog /* Artículo Desde */
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  
  RUN lkup/c-catart.w ('Artículos').
  IF output-var-1 <> ? THEN 
      ASSIGN 
      FILL-IN-CodMat-Desde:SCREEN-VALUE = output-var-2 
      FILL-IN-DesMat-Desde:SCREEN-VALUE = output-var-3.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat-Hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat-Hasta D-Dialog
ON LEAVE OF FILL-IN-CodMat-Hasta IN FRAME D-Dialog /* Artículo Hasta */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
      AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Artículo no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMat-Hasta:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat-Hasta D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodMat-Hasta IN FRAME D-Dialog /* Artículo Hasta */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.

    RUN lkup/c-catart.w ('Artículos').
    IF output-var-1 <> ? THEN 
        ASSIGN 
        FILL-IN-CodMat-Hasta:SCREEN-VALUE = output-var-2 
        FILL-IN-DesMat-Hasta:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro D-Dialog
ON LEAVE OF FILL-IN-CodPro IN FRAME D-Dialog /* Proveedor */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
      AND gn-prov.CodPro = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodPro IN FRAME D-Dialog /* Proveedor */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.

    RUN lkup/c-provee.w ('Proveedores').
    IF output-var-1 <> ? THEN 
        ASSIGN 
        FILL-IN-CodPro:SCREEN-VALUE = output-var-2 
        FILL-IN-NomPro:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY FILL-IN-CodMat-Desde FILL-IN-DesMat-Desde FILL-IN-CodMat-Hasta 
          FILL-IN-DesMat-Hasta COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodPro 
          FILL-IN-NomPro FILL-IN-CodMar FILL-IN-Mensaje 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 FILL-IN-CodMat-Desde BUTTON-Refresh FILL-IN-CodMat-Hasta 
         BUTTON-Clean COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodPro 
         FILL-IN-CodMar BROWSE-2 Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Linea:DELIMITER = '|'.
      COMBO-BOX-Sublinea:DELIMITER = '|'.
      FOR EACH Almtfami NO-LOCK WHERE ALmtfami.codcia = s-codcia:
          COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + " - " + Almtfami.desfam,Almtfami.codfam).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "FILL-IN-CodMar" THEN ASSIGN input-var-1 = "MK".
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

