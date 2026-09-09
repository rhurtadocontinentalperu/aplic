&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[14] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-C[13] tt-w-report.Campo-C[5] ~
tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] tt-w-report.Campo-C[10] ~
tt-w-report.Campo-I[1] tt-w-report.Campo-F[2] tt-w-report.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodPed FILL-IN-NroPed BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodPed FILL-IN-NroPed ~
FILL-IN-NroRef FILL-IN-Cliente txtLeyenda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-Tiempo W-Win 
FUNCTION fget-Tiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-CodPed AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "SUB-ORDEN DE DESPACHO","O/D",
                     "SUB-ORDEN DE TRANSFERENCIA","OTR",
                     "SUB-ORDEN MOSTRADOR","O/M",
                     "SUB-ORDEN CONSOLIDADA","ODC"
     DROP-DOWN-LIST
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Orden" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "# Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE txtLeyenda AS CHARACTER FORMAT "X(150)":U 
     VIEW-AS FILL-IN 
     SIZE 109.86 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 10 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Sec!Tor" FORMAT "X(3)":U
            WIDTH 5
      tt-w-report.Campo-C[2] COLUMN-LABEL "Pickeador" FORMAT "X(10)":U
            WIDTH 9.43
      tt-w-report.Campo-C[14] COLUMN-LABEL "Impresion" FORMAT "X(25)":U
            WIDTH 19.86
      tt-w-report.Campo-C[3] COLUMN-LABEL "Fec/Hora!Sacado" FORMAT "X(25)":U
            WIDTH 16.86
      tt-w-report.Campo-C[4] COLUMN-LABEL "Fec/Hora!Recep." FORMAT "X(25)":U
            WIDTH 17.43
      tt-w-report.Campo-C[13] COLUMN-LABEL "Tiempo" FORMAT "X(25)":U
            WIDTH 17.29
      tt-w-report.Campo-C[5] COLUMN-LABEL "Zona!Pickeo" FORMAT "X(4)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "User!Asigna" FORMAT "X(10)":U
            WIDTH 8.72
      tt-w-report.Campo-C[7] COLUMN-LABEL "User!Recepc." FORMAT "X(10)":U
            WIDTH 8.43
      tt-w-report.Campo-C[10] COLUMN-LABEL "Nombre Pickeador" FORMAT "X(30)":U
      tt-w-report.Campo-I[1] COLUMN-LABEL "Itms" FORMAT ">,>>9":U
      tt-w-report.Campo-F[2] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 7.43
      tt-w-report.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 7.96
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodPed AT ROW 1.15 COL 13 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NroPed AT ROW 2.12 COL 13 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-NroRef AT ROW 3.08 COL 13 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-Cliente AT ROW 4.12 COL 13 COLON-ALIGNED WIDGET-ID 14
     BROWSE-5 AT ROW 5.23 COL 2 WIDGET-ID 200
     txtLeyenda AT ROW 13.5 COL 3 NO-LABEL WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 14.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 14.23
         WIDTH              = 144.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-5 FILL-IN-Cliente F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtLeyenda IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Sec!Tor" "X(3)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Pickeador" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[14]
"tt-w-report.Campo-C[14]" "Impresion" "X(25)" "character" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Fec/Hora!Sacado" "X(25)" "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Fec/Hora!Recep." "X(25)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[13]
"tt-w-report.Campo-C[13]" "Tiempo" "X(25)" "character" ? ? ? ? ? ? no ? no no "17.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Zona!Pickeo" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "User!Asigna" "X(10)" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "User!Recepc." "X(10)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Nombre Pickeador" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "Itms" ">,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Volumen" ? "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
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


&Scoped-define SELF-NAME COMBO-BOX-CodPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodPed W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodPed IN FRAME F-Main /* Documento */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* # de Orden */
OR RETURN OF FILL-IN-NroPed DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").    

    EMPTY TEMP-TABLE tt-w-report.
    {&OPEN-QUERY-BROWSE-5}

    DEFINE VAR lNroOrden AS CHAR.

    ASSIGN {&SELF-NAME} COMBO-BOX-CodPed.    

    IF LENGTH(FILL-IN-NroPed) > 12 THEN DO:
        /* Transformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia AND 
            Facdocum.codcta[8] = SUBSTRING(FILL-IN-NroPed,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            COMBO-BOX-CodPed = Facdocum.coddoc.
            FILL-IN-NroPed = SUBSTRING(FILL-IN-NroPed,4).
            DISPLAY FILL-IN-NroPed COMBO-BOX-CodPed WITH FRAME {&FRAME-NAME}.            
        END.
    END.
    ASSIGN FILL-IN-NroPed COMBO-BOX-CodPed.

    lNroOrden = FILL-IN-nroped.
    lNroOrden = IF(NUM-ENTRIES(FILL-IN-nroped,"-") > 1) THEN ENTRY(1,FILL-IN-nroped,"-") ELSE lNroOrden.

    /* Buscamos Sub-Orden */
    FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codped = COMBO-BOX-CodPed
        AND ENTRY(1,VtaCDocu.nroped,"-") = lNroOrden
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Sub-Orden NO registrada ' COMBO-BOX-CodPed FILL-IN-NroPed lNroOrden VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    
    ASSIGN
        FILL-IN-Cliente:SCREEN-VALUE = Vtacdocu.codcli + ' ' + Vtacdocu.nomcli
        FILL-IN-NroRef:SCREEN-VALUE = Vtacdocu.nroref.

    /* Detalle de la ORDEN */
    DEFINE VAR lSectores AS CHAR.
    DEFINE VAR nSectores AS INT INIT 0.
    DEFINE VAR nSectoresImp AS INT  INIT 0.
    DEFINE VAR nSectoresAsig AS INT  INIT 0.
    DEFINE VAR nSectoresReto AS INT  INIT 0.
    DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

    txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    /*EMPTY TEMP-TABLE tt-w-report.*/

    SESSION:SET-WAIT-STATE('GENERAL').

    lSectores = "".
    FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                            VtaCDocu.CodPed = COMBO-BOX-Codped AND
                            ENTRY(1,VtaCDocu.nroped,"-") = lNroOrden
                            NO-LOCK:
        lSectores = lSectores + IF(lSectores <> "") THEN "," ELSE "".
        lSectores = lSectores + ENTRY(2,VtaCDocu.nroped,"-").
        nSectores = nSectores + 1.
        IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
            nSectoresImp = nSectoresImp + 1.
        END.
        IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
            nSectoresAsig = nSectoresAsig + 1.
        END.
        IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
            nSectoresReto = nSectoresReto + 1.
        END.

        /**/
        CREATE tt-w-report.
            ASSIGN  tt-w-report.campo-c[1] = ENTRY(2,VtaCDocu.nroped,"-")
                    tt-w-report.campo-c[2] = VtaCDocu.UsrSac
                    tt-w-report.campo-c[3] = STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac
                    tt-w-report.campo-c[4] = IF(NUM-ENTRIES(VtaCDocu.libre_c03,"|")>1) THEN ENTRY(2,VtaCDocu.libre_c03,"|") ELSE ""
                    tt-w-report.campo-c[5] = VtaCDocu.ZonaPickeo
                    tt-w-report.campo-c[6] = VtaCDocu.UsrSacAsign
                    tt-w-report.campo-c[7] = VtaCDocu.UsrSacRecep
                    tt-w-report.campo-c[13] = fget-tiempo()
                    tt-w-report.campo-c[14] = STRING(VtaCDocu.fchimpOD).

        /* Pickeador */
        FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSac NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN tt-w-report.campo-c[10] = TRIM(pl-pers.patper) + " " +
                                                            TRIM(pl-pers.matper) + " " +
                                                            TRIM(pl-pers.nomper) NO-ERROR.
        /* Supervisor Asignacion */
        FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSacAsign NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN tt-w-report.campo-c[11] = TRIM(pl-pers.patper) + " " +
                                                            TRIM(pl-pers.matper) + " " +
                                                            TRIM(pl-pers.nomper) NO-ERROR.
        /* Supervisor Recepcion */
        FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSacRecep NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN tt-w-report.campo-c[12] = TRIM(pl-pers.patper) + " " +
                                                            TRIM(pl-pers.matper) + " " +
                                                            TRIM(pl-pers.nomper) NO-ERROR.

        /* Detalle */
        FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
            FIRST almmmatg OF VtaDDocu NO-LOCK:
            ASSIGN tt-w-report.campo-i[1] = tt-w-report.campo-i[1] + 1
                    tt-w-report.campo-f[1] = tt-w-report.campo-f[1] + VtaDDocu.implin
                    tt-w-report.campo-f[2] = tt-w-report.campo-f[2] + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.pesmat)
                    tt-w-report.campo-f[3] = tt-w-report.campo-f[3] + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.libre_d02).
        END.
        tt-w-report.campo-f[3] = tt-w-report.campo-f[3] / 1000000.
    END.
    nSectoresSinAsig = nSectores - nSectoresAsig.

    txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(nSectores) + " Sector(es), " +
                        STRING(nSectoresImp) + " Impreso(s), " + 
                        STRING(nSectoresAsig) + " Asignado(s), " + 
                        STRING(nSectoresReto) + " Retornado(s), " + 
                        STRING(nSectoresSinAsig) + " NO asignados".

    {&OPEN-QUERY-BROWSE-5}

    SESSION:SET-WAIT-STATE('').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DISPLAY COMBO-BOX-CodPed FILL-IN-NroPed FILL-IN-NroRef FILL-IN-Cliente 
          txtLeyenda 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodPed FILL-IN-NroPed BROWSE-5 
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-w-report"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-Tiempo W-Win 
FUNCTION fget-Tiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-tiempo AS CHAR INIT "".
         
  IF AVAILABLE VtaCDocu THEN DO:
      IF VtaCDocu.fecsac <> ? THEN DO:
          IF NUM-ENTRIES(VtaCDocu.libre_c03,"|") > 1  THEN DO:
                RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(ENTRY(2,VtaCDocu.libre_c03,"|")), OUTPUT x-Tiempo).
          END.
          ELSE DO:
                RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).                
          END.
      END.
  END.

  RETURN x-Tiempo.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

