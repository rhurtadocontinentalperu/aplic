&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE cc-AlmDPInv NO-UNDO LIKE INTEGRAL.AlmDPInv.
DEFINE TEMP-TABLE tt-AlmDPInv NO-UNDO LIKE INTEGRAL.AlmDPInv
       field desmat like almmmatg.desmat
       field codmar like almmmatg.codmar
       field undstk like almmmatg.undstk.



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

DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VARIABLE pRCID AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-AlmDPInv INTEGRAL.Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-AlmDPInv.codmat ~
tt-AlmDPInv.Libre_d01[2] INTEGRAL.Almmmatg.UndStk INTEGRAL.Almmmatg.DesMat ~
INTEGRAL.Almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-AlmDPInv NO-LOCK, ~
      EACH INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  tt-AlmDPInv.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  tt-AlmDPInv.codmat NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-AlmDPInv NO-LOCK, ~
      EACH INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  tt-AlmDPInv.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  tt-AlmDPInv.codmat NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-AlmDPInv INTEGRAL.Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-AlmDPInv
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 INTEGRAL.Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCodUbi txtCodMatAdd txtConteo BROWSE-2 ~
ChkBxConfirmar BtnGrabar 
&Scoped-Define DISPLAYED-OBJECTS txtCodUbi txtCodAlm txtDesAlm txtCodMatAdd ~
txtConteo ChkBxConfirmar txtDesMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnGrabar 
     LABEL "Grabar el RECONTEO de la ZONA" 
     SIZE 34 BY 1.12.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCodMatAdd AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodUbi AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ubicacion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txtConteo AS DECIMAL FORMAT "->,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1
     FONT 14 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtDesMat AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE ChkBxConfirmar AS LOGICAL INITIAL yes 
     LABEL "No pedir confirmacion" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-AlmDPInv, 
      INTEGRAL.Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-AlmDPInv.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
      tt-AlmDPInv.Libre_d01[2] COLUMN-LABEL "Re-Conteo" FORMAT "->>>,>>>,>>9.9999":U
      INTEGRAL.Almmmatg.UndStk COLUMN-LABEL "U.M." FORMAT "X(4)":U
      INTEGRAL.Almmmatg.DesMat FORMAT "X(45)":U WIDTH 42
      INTEGRAL.Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
            WIDTH 19.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94.72 BY 16.92 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCodUbi AT ROW 3 COL 77 COLON-ALIGNED WIDGET-ID 6
     txtCodAlm AT ROW 2.92 COL 9 COLON-ALIGNED WIDGET-ID 2
     txtDesAlm AT ROW 2.92 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtCodMatAdd AT ROW 23.15 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 18 AUTO-RETURN 
     txtConteo AT ROW 23.15 COL 44.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     BROWSE-2 AT ROW 4.81 COL 2.29 WIDGET-ID 200
     ChkBxConfirmar AT ROW 24.31 COL 10 WIDGET-ID 22
     txtDesMat AT ROW 24.31 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BtnGrabar AT ROW 26.38 COL 59 WIDGET-ID 30
     "Cantidad" VIEW-AS TEXT
          SIZE 9.43 BY .62 AT ROW 22.58 COL 46.29 WIDGET-ID 26
          FGCOLOR 4 
     "Codigo de Articulo del Conteo" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 22.5 COL 7.86 WIDGET-ID 20
          FGCOLOR 4 
     "    RE-CONTEO - Pre inventarios" VIEW-AS TEXT
          SIZE 43 BY .96 AT ROW 1.35 COL 26 WIDGET-ID 32
          BGCOLOR 6 FGCOLOR 15 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97.57 BY 26.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: cc-AlmDPInv T "?" NO-UNDO INTEGRAL AlmDPInv
      TABLE: tt-AlmDPInv T "?" NO-UNDO INTEGRAL AlmDPInv
      ADDITIONAL-FIELDS:
          field desmat like almmmatg.desmat
          field codmar like almmmatg.codmar
          field undstk like almmmatg.undstk
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 26.88
         WIDTH              = 97.57
         MAX-HEIGHT         = 27.65
         MAX-WIDTH          = 97.57
         VIRTUAL-HEIGHT     = 27.65
         VIRTUAL-WIDTH      = 97.57
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 txtConteo F-Main */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-AlmDPInv,INTEGRAL.Almmmatg WHERE Temp-Tables.tt-AlmDPInv ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia =  Temp-Tables.tt-AlmDPInv.CodCia and
 INTEGRAL.Almmmatg.codmat =  Temp-Tables.tt-AlmDPInv.codmat"
     _FldNameList[1]   > Temp-Tables.tt-AlmDPInv.codmat
"Temp-Tables.tt-AlmDPInv.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-AlmDPInv.Libre_d01[2]
"Temp-Tables.tt-AlmDPInv.Libre_d01[2]" "Re-Conteo" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndStk
"INTEGRAL.Almmmatg.UndStk" "U.M." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
  
    IF AVAILABLE tt-AlmDPInv THEN DO:
        MESSAGE 'Seguro de eliminar (' + tt-AlmDPInv.desmat + ')' VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO UPDATE rpta AS LOG.

      IF rpta = NO THEN RETURN NO-APPLY.

      DELETE tt-AlmDPInv.


      {&OPEN-QUERY-BROWSE-2}

    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnGrabar W-Win
ON CHOOSE OF BtnGrabar IN FRAME F-Main /* Grabar el RECONTEO de la ZONA */
DO:
        MESSAGE 'Seguro de Grabar?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.

        IF rpta = NO THEN RETURN NO-APPLY.  

    DEFINE VAR lExistenRegs AS LOG.
    DEFINE VAR lEsNuevo AS LOG.

    lExistenRegs = NO.

    /* Detalle de Articulos */
    FOR EACH cc-AlmDPInv NO-LOCK :        
        FIND FIRST AlmDPInv WHERE AlmDPInv.codcia = s-codcia 
            AND AlmDPInv.codalm = s-codalm 
            AND AlmDPInv.codubi = cc-AlmDPInv.codubi 
            AND AlmDPInv.codmat = cc-AlmDPInv.codmat EXCLUSIVE NO-ERROR.

        lEsNuevo = NO.

        IF NOT AVAILABLE AlmDPInv THEN DO:
            /* Se esta haciendo RECONTEO de un articulo que no tiene CONTEO */
            CREATE AlmDPInv.
            ASSIGN AlmDPInv.codcia      = s-codcia
                    AlmDPInv.codalm     = s-codalm
                    AlmDPInv.codubi     = cc-AlmDPInv.codubi
                    AlmDPInv.codmat     = cc-AlmDPInv.codmat
                    AlmDPInv.fchcrea    = TODAY
                    AlmDPInv.HorCrea    = STRING(TIME,"HH:MM:SS")
                    AlmDPInv.PRID-crea  = PRCID
                    AlmDPInv.stkinv = 0
                    almDPinv.libre_d01[1]  = ?  /* Conteo */
                    AlmDPInv.libre_d01[2]  = ?  /* Reconteo */
                    almDPinv.libre_d01[3]  = 0  /* Stock al conteo */
                    AlmDPInv.libre_d01[4]  = 0.  /* Stock al reconteo */

            lEsNuevo = YES.            
        END.
        /*
        ASSIGN  almDPinv.libre_d01[1]  = tt-AlmDPInv.stkinv
                AlmDPInv.stkinv     = tt-AlmDPInv.stkinv
                AlmDPInv.fchmod    = TODAY
                AlmDPInv.Hormod    = STRING(TIME,"HH:MM:SS")
                AlmDPInv.PRID-mod  = PRCID.
        */
        IF AVAILABLE AlmDPInv THEN DO:
            lExistenRegs = YES.
            ASSIGN  almDPinv.libre_d01[2]  = cc-AlmDPInv.libre_d01[2]
                    AlmDPInv.stkinv    =  IF (cc-AlmDPInv.libre_d01[2] = ?) THEN AlmDPInv.stkinv ELSE cc-AlmDPInv.libre_d01[2]
                    AlmDPInv.fchmod    = TODAY
                    AlmDPInv.Hormod    = STRING(TIME,"HH:MM:SS")
                    AlmDPInv.PRID-mod  = PRCID.
    
            /* Stock del Sistema */
            FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                    almmmate.codalm = s-codalm AND almmmate.codmat = cc-AlmDPInv.codmat
                    NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate THEN DO:
                IF lEsNuevo = YES THEN DO:
                    almDPinv.libre_d01[3] = almmmate.stkact.
                END.
                almDPinv.libre_d01[4]  = almmmate.stkact.
            END.
         END.
    END.

    IF lExistenRegs = YES THEN DO:
        /* Ubicaciones */
        FIND FIRST AlmUPInv WHERE AlmUPInv.codcia = s-codcia 
            AND AlmUPInv.codalm = s-codalm 
            AND AlmUPInv.codubi = txtCodUbi EXCLUSIVE NO-ERROR.

        IF NOT AVAILABLE AlmUPInv THEN DO:
            CREATE AlmUPInv.
            ASSIGN AlmUPInv.codcia      = s-codcia
                    AlmUPInv.codalm     = s-codalm
                    AlmUPInv.codubi     = txtCodUbi
                    AlmUPInv.fchcrea    = TODAY
                    AlmUPInv.PRID-crea  = PRCID.                    
        END.
        ASSIGN  AlmUPInv.fchmod    = TODAY
                AlmUPInv.PRID-mod  = PRCID
                AlmUPinv.libre_c01[4] = STRING(PRCID,"999999999999999")
                AlmUPinv.libre_f01[2] = TODAY
                AlmUPinv.libre_c01[2] = USERID("DICTDB").
            
    END.

    EMPTY TEMP-TABLE tt-AlmDPInv.
    EMPTY TEMP-TABLE cc-AlmDPInv.

    {&OPEN-QUERY-BROWSE-2}
    APPLY 'ENTRY':U TO txtCodUbi.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodMatAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodMatAdd W-Win
ON LEAVE OF txtCodMatAdd IN FRAME F-Main
OR RETURN OF txtcodmatadd
    DO:
    
    ASSIGN txtCodMatAdd txtCodUbi.

    DEFINE VAR lCodMat AS CHAR.
    DEFINE VAR lMsg AS CHAR.

    IF txtCodUbi <> "" AND txtCodMatAdd <> "" THEN DO:
        /* Obtener el Codigo del Articulo a 6 Digitos */
        RUN ue-validar(INPUT txtCodMatAdd, OUTPUT lCodMat).

        IF lCodMat <> "" AND lCodMat <> "ERROR" THEN DO:
            lMsg = "".
            RUN ue-codigo-valido(INPUT lCodMat, OUTPUT lMsg).
            IF lMsg <> "OK" THEN DO:
                txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
                MESSAGE lMsg VIEW-AS ALERT-BOX.
                RETURN NO-APPLY.
            END.
        END.
        ELSE DO:
            IF lCodMat <> "" THEN DO:
                txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
                MESSAGE "Codigo ERRADO" VIEW-AS ALERT-BOX.
                RETURN NO-APPLY.
            END.
        END.

    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON LEAVE OF txtCodUbi IN FRAME F-Main /* Ubicacion */
OR RETURN OF txtCodUbi
   
DO:
    txtcodubi:SCREEN-VALUE = REPLACE(txtcodubi:SCREEN-VALUE,"'","-").

    ASSIGN txtCodUbi.

    IF txtCodUbi <> "" THEN DO:            

        FIND FIRST AlmUPinv WHERE AlmUPinv.codcia = s-codcia AND 
                AlmUPinv.codalm = s-codalm AND AlmUPinv.codubi = txtCodUbi
                NO-LOCK NO-ERROR.
        IF AVAILABLE AlmUPInv THEN DO:
            IF AlmUPinv.scerrado = YES THEN DO:
                MESSAGE "Almacen/Ubicacion ya fue CERRADO" VIEW-AS ALERT-BOX.
                RETURN NO-APPLY.
            END.
            IF almUPinv.libre_f01[2] <> ? THEN DO:
                MESSAGE "Zona ya tiene RE-CONTEO" VIEW-AS ALERT-BOX.
                RETURN NO-APPLY.
            END.
        END.

        FIND FIRST AlmCPInv WHERE AlmCPInv.codcia = s-codcia AND 
                AlmCPInv.codalm = s-codalm NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmCPInv THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Almacen/Ubicacion no esta en PRE-INVENTARIO" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        IF NOT (TODAY >= AlmCPInv.fchdesde AND TODAY <= AlmCPInv.FchHasta) THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Pre-Inventario fuera de FECHA" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        IF AlmCPInv.suspe = YES THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Esta suspendido la Realizacion del PRE-Inventario para este Almacen" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
    
        EMPTY TEMP-TABLE tt-AlmDPInv.
        EMPTY TEMP-TABLE cc-AlmDPInv.
        /* Guardo el Conteo */
        FOR EACH AlmDPInv WHERE AlmDPInv.codcia = s-codcia 
                AND AlmDPInv.codalm = s-codalm AND AlmDPInv.codubi = txtCodUbi
                NO-LOCK:
            FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
                    Almmmatg.codmat = AlmDPInv.codmat NO-LOCK NO-ERROR.
            CREATE cc-AlmDPInv.
                ASSIGN cc-AlmDPInv.codcia = s-codcia
                        cc-AlmDPInv.codalm = s-codalm
                        cc-AlmDPInv.codubi = txtCodUbi
                        cc-AlmDPInv.codmat = AlmDPInv.codmat
                        /*tt-AlmDPInv.stkinv = AlmDPInv.stkinv*/
                        cc-AlmDPInv.libre_d01[2] = ?.
        END.
    
        {&OPEN-QUERY-BROWSE-2}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtConteo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtConteo W-Win
ON LEAVE OF txtConteo IN FRAME F-Main
DO:
  ASSIGN txtConteo ChkBxConfirmar.

  IF txtConteo > 0 THEN DO:
      ASSIGN txtCodMatAdd txtCodUbi.

      DEFINE VAR lCodMat AS CHAR.
      DEFINE VAR lMsg AS CHAR.

      IF txtCodUbi <> "" AND txtCodMatAdd <> "" THEN DO:

          RUN ue-validar(INPUT txtCodMatAdd, OUTPUT lCodMat).

          IF lCodMat <> "" AND lCodMat <> "ERROR" THEN DO:
              lMsg = "".
              RUN ue-codigo-valido(INPUT lCodMat, OUTPUT lMsg).
              IF lMsg <> "OK" THEN DO:
                  txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
                  MESSAGE lMsg VIEW-AS ALERT-BOX.
                  RETURN NO-APPLY.
              END.
              /* Addicionar */
              RUN ue-registra-conteo-art.

              txtConteo:SCREEN-VALUE = '0'.
              APPLY 'ENTRY':U TO txtCodMatAdd.
              txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
              RETURN NO-APPLY.
          END.
          ELSE DO:
              IF lCodMat <> "" THEN DO:
                  MESSAGE "Codigo ERRADO(" + lCodMat + ")" VIEW-AS ALERT-BOX.
                  txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
                  RETURN NO-APPLY.
              END.
          END.
      END.

  END.
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
  DISPLAY txtCodUbi txtCodAlm txtDesAlm txtCodMatAdd txtConteo ChkBxConfirmar 
          txtDesMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtCodUbi txtCodMatAdd txtConteo BROWSE-2 ChkBxConfirmar BtnGrabar 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST Almacen WHERE almacen.codcia = s-codcia AND 
      almacen.codalm = s-codalm NO-LOCK NO-ERROR.

  txtCodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm .
  txtDesAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE "".


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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-AlmDPInv"}
  {src/adm/template/snd-list.i "INTEGRAL.Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-buscar-en-browse W-Win 
PROCEDURE ue-buscar-en-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ptxtCodMatBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pMsgBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER ptxtCodMat AS CHAR    NO-UNDO.

pMsgBuscar = "".

IF ptxtCodMatBuscar = "" THEN DO:
    RETURN NO-APPLY.
END.

DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lCodEan AS CHAR.
DEFINE VAR s-Registro-Actual AS ROWID.

lCodMat = trim(ptxtCodMatBuscar).
lCodEan = "".
ptxtCodMat = lCodMat.

IF LENGTH(lCodMat) > 6 THEN DO:
    lCodEan = lCodMat.
    /* Lo Busco como EAN13 */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codbrr = lCodEan NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN lCodMat = almmmatg.codmat.

    IF lCodEan = lCodMat THEN DO:
        /* Lo busco como EAN14 */
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
            almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
        IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.

        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
    END.
    ptxtCodMat = lCodMat.
    IF lCodEan = lCodMat THEN DO:
        /*MESSAGE "Codigo EAN no existe" VIEW-AS ALERT-BOX.*/
        pMsgBuscar = "Codigo EAN no existe".
        RETURN NO-APPLY.
    END.
END.

FIND FIRST tt-AlmDPInv WHERE tt-AlmDPInv.codmat = lCodMat 
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE tt-AlmDPInv THEN DO:
    pMsgBuscar = "No existe Codigo".
    /*MESSAGE "No existe Codigo" VIEW-AS ALERT-BOX.*/
    RETURN NO-APPLY.
END.

ptxtCodMat = lCodMat.
pMsgBuscar = "OK".  /* Existe en el Browse */

s-Registro-Actual = ROWID(tt-AlmDPInv).

REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-codigo-valido W-Win 
PROCEDURE ue-codigo-valido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER lpCodMat AS CHAR.
DEFINE OUTPUT PARAMETER lpMsg AS CHAR.

txtDesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
        almmmatg.codmat = lpCodMat NO-LOCK NO-ERROR.

IF NOT AVAILABLE almmmatg THEN DO:
    lpMsg = "Codigo de Articulo INEXISTENTE".
    RETURN NO-APPLY.
END.
txtDesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.desmat.

FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
        almmmate.codalm = s-codalm AND almmmate.codmat = lpCodmat
        NO-LOCK NO-ERROR.
IF NOT AVAILABLE almmmate THEN DO:
   MESSAGE "Codigo de Articulo no existe en el ALMACEN (" + s-codalm + ")" VIEW-AS ALERT-BOX.
   RETURN NO-APPLY.
END.
/*
IF almmmate.codubi <> txtCodUbi THEN DO:
    lpMsg = "Codigo de Articulo no existe en esa UBICACION".
    RETURN NO-APPLY.
END.
*/

/* Ya tiene reconteo */
FIND FIRST tt-AlmDPInv WHERE tt-AlmDPInv.codmat = lpCodMat 
    NO-LOCK NO-ERROR.
IF AVAILABLE tt-AlmDPInv THEN DO:
    lpMsg = "Codigo YA tiene RECONTEO!!!".
    RETURN NO-APPLY.
END.

/* Esta en el conteo ?*/
FIND FIRST cc-AlmDPInv WHERE cc-AlmDPInv.codmat = lpCodMat 
    EXCLUSIVE NO-ERROR.
IF NOT AVAILABLE cc-AlmDPInv THEN DO:
    /* No tiene conteo pero SI pertenece a la ZONA */
    IF almmmate.codubi = txtCodUbi THEN DO:
        /* Se esta recontando un articulo que no tuvo CONTEO */
    END.
    ELSE DO:
        /* No tiene conteo NI TAMPOCO pertence a la ZONA */
        lpMsg = "Codigo NO tiene CONTEO y Pertenece a otra ZONA!!!".
        RETURN NO-APPLY.
    END.
END.

lpMsg = 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-registra-conteo-art W-Win 
PROCEDURE ue-registra-conteo-art :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lRowid AS ROWID.

IF ChkBxConfirmar = YES THEN DO:
        MESSAGE 'Desea Grabarlo ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
END.
CREATE tt-AlmDPInv.
            ASSIGN tt-AlmDPInv.codcia = s-codcia
                    tt-AlmDPInv.codalm = s-codalm
                    tt-AlmDPInv.codubi = txtCodUbi
                    tt-AlmDPInv.codmat = Almmmatg.codmat
                    tt-AlmDPInv.libre_d01[2] = txtConteo
                    tt-AlmDPInv.DesMat = IF(AVAILABLE Almmmatg) THEN Almmmatg.desmat ELSE ""
                    tt-AlmDPInv.UndStk = IF(AVAILABLE Almmmatg) THEN Almmmatg.undstk ELSE ""
                    tt-AlmDPInv.Codmar = IF(AVAILABLE Almmmatg) THEN Almmmatg.desmar ELSE "".

ASSIGN lRowid = ROWID(tt-AlmDPinv).

/* Si es que no tuvo Conteo  */
FIND FIRST cc-AlmDPInv WHERE cc-AlmDPInv.codmat = Almmmatg.codmat EXCLUSIVE NO-ERROR.
IF NOT AVAILABLE cc-AlmDPInv THEN DO:
    CREATE cc-AlmDPInv.
    ASSIGN cc-AlmDPInv.codcia = s-codcia
            cc-AlmDPInv.codalm = s-codalm
            cc-AlmDPInv.codubi = txtCodUbi
            cc-AlmDPInv.codmat = Almmmatg.codmat
            cc-AlmDPInv.libre_d01[2] = ?.
END.
ASSIGN cc-AlmDPInv.libre_d01[2] = txtConteo.

{&OPEN-QUERY-BROWSE-2}

REPOSITION {&BROWSE-NAME} TO ROWID lROwId.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-validar W-Win 
PROCEDURE ue-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER lCodigo AS CHAR.                                          
  DEFINE OUTPUT PARAMETER lCodMat AS CHAR.

  DEFINE VAR lCodEan AS CHAR.

  lCodMat = "".

  IF lCodigo = "" THEN DO:
      RETURN NO-APPLY.
  END.

  lCodMat = trim(lCodigo).
  lCodEan = "".

  IF LENGTH(lCodMat) > 6 THEN DO:
      lCodEan = lCodMat.
      /* Lo Busco como EAN13 */
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
          almmmatg.codbrr = lCodEan NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN lCodMat = almmmatg.codmat.

      IF lCodEan = lCodMat THEN DO:
          /* Lo busco como EAN14 */
          FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
              almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
          IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.

          IF lCodEan = lCodMat THEN DO:
              FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                  almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
              IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
          END.
          IF lCodEan = lCodMat THEN DO:
              FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                  almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
              IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
          END.
      END.
      IF lCodEan = lCodMat THEN DO:
          lCodMat = "ERROR".
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

