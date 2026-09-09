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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.


DEF TEMP-TABLE t-cdoc LIKE ccbcdocu.
DEF TEMP-TABLE t-ddoc LIKE ccbddocu        
    FIELDS CodFam   AS CHAR
    FIELDS SubFam   AS CHAR
    FIELDS clfcli   AS CHAR
    FIELDS clave    AS CHAR
    FIELDS porcom   AS DEC    
    FIELDS impadd   AS DEC
    FIELDS impcom   AS DEC
    FIELDS cllave   AS CHAR
    FIELDS NroPed   AS CHAR
    FIELDS CptoNC   AS CHAR.
DEF TEMP-TABLE t-comi LIKE vtatabla.
DEF BUFFER b-cdoc FOR ccbcdocu.
DEF BUFFER b-ddoc FOR ccbddocu.

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
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor ~
BUTTON-1 BUTTON-4 Btn_Done BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 5 BY .88.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 5" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE f-vendedor AS CHARACTER FORMAT "X(50)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .92 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .92 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .92 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.27 COL 16 COLON-ALIGNED WIDGET-ID 2
     x-FchDoc-1 AT ROW 2.35 COL 16 COLON-ALIGNED WIDGET-ID 4
     x-FchDoc-2 AT ROW 2.38 COL 39 COLON-ALIGNED WIDGET-ID 6
     f-vendedor AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 3.42 COL 57.86 WIDGET-ID 142
     BUTTON-4 AT ROW 5.31 COL 11.72 WIDGET-ID 10
     Btn_Done AT ROW 5.31 COL 21 WIDGET-ID 144
     x-mensaje AT ROW 5.31 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-5 AT ROW 5.35 COL 3 WIDGET-ID 146
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.35 WIDGET-ID 100.


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
         TITLE              = "Comisiones Provincias"
         HEIGHT             = 7.35
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Comisiones Provincias */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Comisiones Provincias */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Vendedores AS CHAR.
    x-Vendedores = f-vendedor:SCREEN-VALUE.
    RUN vta/d-lisven (INPUT-OUTPUT x-Vendedores).
    f-vendedor:SCREEN-VALUE = x-Vendedores.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN
        x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor.
    RUN Genera-Excel.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  ASSIGN
    x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor.
  RUN Imprimir.
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cClfCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dPorCom AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cCodFam AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSubFam AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
    
    Docs:
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc,'BOL,FAC,TCK,N/C') > 0
        AND (ccbcdocu.coddiv = x-CodDiv
             OR x-coddiv BEGINS 'Todas') 
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.fchdoc >= x-FchDoc-1
        AND ccbcdocu.fchdoc <= x-FchDoc-2 
        AND LOOKUP (ccbcdocu.tpofac, 'A,S') = 0     /* NO Facturas adelantadas ni servicios */
        AND LOOKUP(ccbcdocu.codven,f-vendedor) > 0 NO-LOCK,
        EACH ccbddocu OF ccbcdocu NO-LOCK:
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= ccbcdocu.fchdoc no-lock.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL almmmatg THEN 
            FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla = ccbcdocu.coddoc NO-LOCK NO-ERROR.
            IF NOT AVAIL CcbTabla THEN NEXT Docs.        
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cClfcli = gn-clie.clfcli.
        ELSE cClfCli = ''.

        FIND FIRST t-ddoc WHERE t-ddoc.codcia = s-codcia
            AND t-ddoc.coddiv = ccbddocu.coddiv
            AND t-ddoc.coddoc = ccbddocu.coddoc
            AND t-ddoc.nrodoc = ccbddocu.nrodoc
            AND t-ddoc.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL t-ddoc THEN DO:
            FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
                AND almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
            IF AVAIL almtfam THEN cCodFam = almtfam.codfam + '-' + almtfam.desfam.
            ELSE cCodFam = almmmatg.codfam.

            FIND FIRST almsfam WHERE almsfam.codcia = s-codcia
                AND almsfam.codfam = almmmatg.codfam
                AND almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
            IF AVAIL almsfam THEN cSubFam = almsfam.subfam + '-' + almsfam.dessub.
            ELSE cSubFam = almmmatg.subfam.

            CREATE t-ddoc.
            BUFFER-COPY ccbddocu TO t-ddoc
                ASSIGN 
                t-ddoc.clfcli = cClfCli
                t-ddoc.codfam = cCodFam
                t-ddoc.subfam = cSubFam.
            IF ccbcdocu.codmon = 2 THEN t-ddoc.implin = ccbddocu.implin * gn-tcmb.venta.
        END.
        
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
            AND vtatabla.tabla = 'comi'
            AND ccbddocu.codmat BEGINS vtatabla.llave_c2 
            AND almmmatg.codfam BEGINS vtatabla.llave_c3 
            AND almmmatg.subfam BEGINS vtatabla.llave_c4 
            AND (vtatabla.llave_c5 = cClfCli 
                 OR vtatabla.llave_c5 = '' ) NO-LOCK NO-ERROR.
            /*
            AND cClfCli BEGINS vtatabla.llave_c5 NO-LOCK NO-ERROR.
            */
        IF AVAIL vtatabla THEN DO: 
            dImpLin = ccbddocu.implin.
            IF ccbcdocu.codmon = 2 THEN dImpLin = ccbddocu.implin * gn-tcmb.venta.
            ASSIGN
                clave  = VtaTabla.Libre_c02
                porcom = VtaTabla.Valor[3]
                /*impcom = ccbddocu.implin * (VtaTabla.Valor[3] / 100)*/
                impcom = (dImpLin / (1 + ccbcdocu.porigv / 100)) * (VtaTabla.Valor[3] / 100)
                cllave = VtaTabla.Llave_c1.
            IF ccbcdocu.fmapgo = '002' AND ccbcdocu.coddoc <> 'N/C' 
                THEN impadd = ((dImpLin / (1 + ccbcdocu.porigv / 100)) * 0.1 / 100).
            ELSE impadd = 0.
        END.
        PAUSE 0.
        DISPLAY 'PROCESANDO INFORMACION .... ' @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos2 W-Win 
PROCEDURE Carga-Datos2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cClfCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dPorCom AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cCodFam AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSubFam AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dPorVal AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE t-ddoc.
    
    Docs:
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc,'BOL,FAC,TCK,N/C') > 0
        AND (ccbcdocu.coddiv = x-CodDiv
             OR x-coddiv BEGINS 'Todas') 
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.fchdoc >= x-FchDoc-1
        AND ccbcdocu.fchdoc <= x-FchDoc-2 
        AND LOOKUP (ccbcdocu.tpofac, 'A,S') = 0     /* NO Facturas adelantadas ni servicios */
        AND LOOKUP(ccbcdocu.codven,f-vendedor) > 0 NO-LOCK,
        EACH ccbddocu OF ccbcdocu NO-LOCK:

        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= ccbcdocu.fchdoc no-lock.

        IF ccbcdocu.coddoc = 'N/C' AND ccbcdocu.cndcre = 'N' 
            AND ccbddocu.codmat = '00014' THEN NEXT Docs.
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cClfcli = gn-clie.clfcli.
        ELSE cClfCli = ''.

        /*Busca Documentos*/
        FIND FIRST t-ddoc WHERE t-ddoc.codcia = s-codcia
            AND t-ddoc.coddiv = ccbddocu.coddiv
            AND t-ddoc.coddoc = ccbddocu.coddoc
            AND t-ddoc.nrodoc = ccbddocu.nrodoc
            AND t-ddoc.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL t-ddoc THEN DO:
            /*Busca Detalle Documento*/
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN DO:
                /*Crea Tabla*/
                CREATE t-ddoc.
                BUFFER-COPY ccbddocu TO t-ddoc
                    ASSIGN 
                    t-ddoc.clfcli = cClfCli
                    t-ddoc.nroped = ccbcdocu.nroped.
                IF Ccbcdocu.codmon = 2 THEN t-ddoc.implin = ccbddocu.implin * gn-tcmb.venta.
            END.
            ELSE DO:
                FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                    AND CcbTabla.Tabla  = ccbcdocu.coddoc
                    AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAIL CcbTabla THEN DO:
                    FIND FIRST b-cdoc WHERE b-cdoc.codcia = ccbcdocu.codcia
                        AND b-cdoc.coddiv = ccbcdocu.coddiv
                        AND b-cdoc.codcli = ccbcdocu.codcli
                        AND b-cdoc.coddoc = ccbcdocu.codref
                        AND b-cdoc.nrodoc = ccbcdocu.nroref
                        AND b-cdoc.flgest <> 'A' NO-LOCK NO-ERROR.
                    IF AVAIL b-cdoc THEN DO:
                        IF b-cdoc.fchdoc < x-FchDoc-1 THEN NEXT Docs.
                        IF b-cdoc.fchdoc > x-FchDoc-2 THEN NEXT Docs.
                        FOR EACH b-ddoc OF b-cdoc NO-LOCK:
                            dImpTot = ccbcdocu.imptot.
                            IF ccbcdocu.codmon = 2 THEN dImpTot = ccbcdocu.imptot * gn-tcmb.venta.
                            dPorVal = (b-ddoc.ImpLin / b-cdoc.imptot).
                            /*Crea Tabla*/
                            CREATE t-ddoc.
                            BUFFER-COPY b-ddoc TO t-ddoc
                                ASSIGN
                                t-ddoc.coddoc = ccbcdocu.coddoc 
                                t-ddoc.nrodoc = ccbcdocu.nrodoc                             
                                t-ddoc.clfcli = cClfCli
                                t-ddoc.implin = dImpTot * dPorVal
                                t-ddoc.nroped = b-cdoc.nroped
                                t-ddoc.CptoNC = CcbTabla.Codigo + '-' + CcbTabla.Nombre.
                        END.
                    END.
                END.
            END.
        END.
        DISPLAY 'PROCESANDO INFORMACION .... ' @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.
    END.

    FOR EACH t-ddoc NO-LOCK,
        FIRST ccbcdocu OF t-ddoc NO-LOCK,
            FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = t-ddoc.codmat NO-LOCK:

        /*Familia*/
        FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
            AND almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
        IF AVAIL almtfam THEN cCodFam = almtfam.codfam + '-' + almtfam.desfam.
        ELSE cCodFam = almmmatg.codfam.
        /*SubFamilia*/
        FIND FIRST almsfam WHERE almsfam.codcia = s-codcia
            AND almsfam.codfam = almmmatg.codfam
            AND almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
        IF AVAIL almsfam THEN cSubFam = almsfam.subfam + '-' + almsfam.dessub.
        ELSE cSubFam = almmmatg.subfam.

        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
            AND vtatabla.tabla = 'comi'
            AND t-ddoc.codmat BEGINS vtatabla.llave_c2 
            AND almmmatg.codfam BEGINS vtatabla.llave_c3 
            AND almmmatg.subfam BEGINS vtatabla.llave_c4 
            AND (vtatabla.llave_c5 = t-ddoc.clfcli 
                 OR vtatabla.llave_c5 = '' ) NO-LOCK NO-ERROR.
        IF AVAIL vtatabla THEN DO: 
            ASSIGN
                t-ddoc.clave  = VtaTabla.Libre_c02
                t-ddoc.porcom = VtaTabla.Valor[3]
                /*impcom = ccbddocu.implin * (VtaTabla.Valor[3] / 100)*/
                t-ddoc.impcom = (t-ddoc.implin / (1 + ccbcdocu.porigv / 100)) * (VtaTabla.Valor[3] / 100)
                t-ddoc.cllave = VtaTabla.Llave_c1
                t-ddoc.codfam = cCodFam
                t-ddoc.subfam = cSubFam.

            IF ccbcdocu.fmapgo = '002' AND ccbcdocu.coddoc <> 'N/C' 
                THEN impadd = ((t-ddoc.implin / (1 + ccbcdocu.porigv / 100)) * 0.1 / 100).
            ELSE impadd = 0.
        END.
        PAUSE 0.
        DISPLAY 'CALCULANDO COMISIONES .... ' @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/**
    DEFINE VARIABLE cClfCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dPorCom AS DECIMAL     NO-UNDO.

    MESSAGE x-coddiv.
    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = 'PED'
        AND faccpedi.coddiv = x-CodDiv       
        AND faccpedi.flgest <> 'A'
        AND faccpedi.fchped >= x-FchDoc-1
        AND faccpedi.fchped <= x-FchDoc-2
        AND faccpedi.codven = '015' NO-LOCK,
        EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = facdpedi.codmat NO-LOCK:
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cClfcli = gn-clie.clfcli.
        ELSE cClfCli = ''.

        FIND FIRST t-ddoc WHERE t-ddoc.codcia = s-codcia
            AND t-ddoc.coddiv = facdpedi.coddiv
            AND t-ddoc.coddoc = facdpedi.coddoc
            AND t-ddoc.nroped = facdpedi.nroped
            AND t-ddoc.codmat = facdpedi.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL t-ddoc THEN DO:
            CREATE t-ddoc.
            BUFFER-COPY facdpedi TO t-ddoc
                ASSIGN t-ddoc.clfcli = cClfCli.
        END.

        
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
            AND vtatabla.tabla = 'comi'
            AND facdpedi.codmat BEGINS vtatabla.llave_c2 
            AND almmmatg.codfam BEGINS vtatabla.llave_c3 
            AND almmmatg.subfam BEGINS vtatabla.llave_c4 
            AND cClfCli BEGINS vtatabla.llave_c5 NO-LOCK NO-ERROR.
        IF AVAIL vtatabla THEN DO: 
            ASSIGN
                clave  = VtaTabla.Libre_c02
                porcom = VtaTabla.Valor[3]
                impcom = facdpedi.implin * (VtaTabla.Valor[3] / 100).
        END.
        PAUSE 0.
    END.
**/    
    
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
  DISPLAY x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-FchDoc-1 x-FchDoc-2 f-vendedor BUTTON-1 BUTTON-4 Btn_Done 
         BUTTON-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dComi AS DECIMAL     NO-UNDO.

  DEFINE FRAME FC-REP
      vtatabla.llave_c1    COLUMN-LABEL "Orden"
      vtatabla.libre_c01   COLUMN-LABEL "Descripcion"
      vtatabla.llave_c2    COLUMN-LABEL "Producto" 
      vtatabla.llave_c3    COLUMN-LABEL "Familia"  
      vtatabla.llave_c4    COLUMN-LABEL "Sub Familia" 
      vtatabla.llave_c5    COLUMN-LABEL "Clasificacion"   
      vtatabla.valor[3]    COLUMN-LABEL "Comision" 
      vtatabla.libre_c02   COLUMN-LABEL "Clave"
      dComi                COLUMN-LABEL "Importe comision"
    WITH WIDTH 160 NO-BOX STREAM-IO DOWN.

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + x-CODDIV + ")"  FORMAT "X(15)"
    "REPORTE DE COMISIONES" AT 40
    "Pag.  : " AT 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 100 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Division(es):" x-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} SKIP
    "Emitidos desde:" x-FchDoc-1
    "hasta:" x-FchDoc-2 SKIP    
    WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS STREAM-IO /*CENTERED*/ NO-UNDERLINE DOWN.


  FOR EACH t-ddoc NO-LOCK
      BREAK BY t-ddoc.cllave :
      ACCUMULATE t-ddoc.impcom (SUB-TOTAL BY t-ddoc.cllave).

      IF LAST-OF(t-ddoc.cLlave) THEN DO:
          FIND FIRST vtatabla WHERE vtatabla.tabla = 'COMI' 
              AND vtatabla.llave_c1 = t-ddoc.cllave NO-LOCK NO-ERROR.
          IF AVAIL vtatabla THEN DO:
              DISPLAY STREAM Report
                  vtatabla.llave_c1
                  vtatabla.libre_c01
                  vtatabla.llave_c2
                  vtatabla.llave_c3
                  vtatabla.llave_c4
                  vtatabla.llave_c5
                  vtatabla.valor[3] 
                  vtatabla.libre_c02
                  ACCUM SUB-TOTAL BY t-ddoc.cLlave t-ddoc.impcom @ dComi
                  WITH FRAME fc-rep.
          END.
      END.
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
DEFINE VAR x-ImpLin1 AS DEC  NO-UNDO.
DEFINE VAR x-ImpLin2 AS DEC  NO-UNDO.
DEFINE VAR x-ImpCom1 AS DEC  NO-UNDO.
DEFINE VAR x-ImpCom2 AS DEC  NO-UNDO.
DEFINE VAR x-Vend    AS CHAR NO-UNDO.
DEFINE VAR iFactor   AS INT  NO-UNDO.
DEFINE VAR cConVta   AS CHAR NO-UNDO.

RUN Carga-Datos2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* chWorkSheet:COLUMNS("A"):ColumnWidth = 14. */
/* chWorkSheet:COLUMNS("B"):ColumnWidth = 30. */
/* chWorkSheet:COLUMNS("C"):ColumnWidth = 30. */
/* chWorkSheet:COLUMNS("D"):ColumnWidth = 30. */
/* chWorkSheet:COLUMNS("E"):ColumnWidth = 30. */
/* chWorkSheet:COLUMNS("F"):ColumnWidth = 30. */
/* chWorkSheet:COLUMNS("G"):ColumnWidth = 30. */

chWorkSheet:Range("A1: Z2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Cliente".
chWorkSheet:Range("B2"):VALUE = "Articulo".
chWorkSheet:Range("C2"):VALUE = "Documento".
chWorkSheet:Range("D2"):VALUE = "Pedido".
chWorkSheet:Range("E2"):VALUE = "Fecha Documento".
chWorkSheet:Range("F2"):VALUE = "Familia".
chWorkSheet:Range("G2"):VALUE = "Sub Familia".
chWorkSheet:Range("H2"):VALUE = "Clasificacion".

chWorkSheet:Range("I2"):VALUE = "Clave".
chWorkSheet:Range("J2"):VALUE = "% Comision".
chWorkSheet:Range("K2"):VALUE = "Importe".
chWorkSheet:Range("L2"):VALUE = "Importe sin IGV".
chWorkSheet:Range("M2"):VALUE = "Importe Comision".
chWorkSheet:Range("N2"):VALUE = "Importe Com x A/C".
chWorkSheet:Range("O2"):VALUE = "Total Comision".
chWorkSheet:Range("P2"):VALUE = "Cond. Venta".
chWorkSheet:Range("Q2"):VALUE = "Vendedor".
chWorkSheet:Range("R2"):VALUE = "Orden".
chWorkSheet:Range("S2"):VALUE = "Referencia".
chWorkSheet:Range("T2"):VALUE = "Concepto N/C".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Temporal.

FOR EACH t-ddoc NO-LOCK,
    FIRST ccbcdocu OF t-ddoc NO-LOCK,
        FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = t-ddoc.codmat NO-LOCK:

    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven NO-LOCK NO-ERROR.
    IF AVAIL gn-ven THEN x-Vend = gn-ven.codven + '-' + gn-ven.nomven.
    ELSE x-Vend = ccbcdocu.codven.

    IF ccbcdocu.coddoc = 'N/C' THEN iFactor = -1.
    ELSE iFactor = 1.

    /*Busca Condicion de Venta*/
    FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo 
        NO-LOCK NO-ERROR.
    IF AVAIL gn-convt THEN cConVta = gn-convt.codig + '-' + gn-convt.nombr.
    ELSE cConVta = ccbcdocu.fmapgo .

    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = ccbcdocu.codcli + '-' + ccbcdocu.nomcli.
    cRange = "B" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.codmat + '-' + almmmatg.desmat .
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = ccbcdocu.coddoc + '-' + ccbcdocu.nrodoc.
    cRange = "D" + cColumn.   
    chWorkSheet:Range(cRange):Value = "'" + t-ddoc.nroped.
    cRange = "E" + cColumn.   
    chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
    cRange = "F" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.codfam.
    cRange = "G" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.subfam.
    cRange = "H" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.clfcli.

    cRange = "I" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.clave.
    cRange = "J" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.porcom.
    cRange = "K" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.implin * iFactor.
    cRange = "L" + cColumn.   
    chWorkSheet:Range(cRange):Value = (t-ddoc.implin * iFactor) / ( 1 + ccbcdocu.porigv / 100).
    cRange = "M" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.impcom * iFactor.
    IF t-ddoc.impadd <> 0 THEN DO:
        cRange = "N" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-ddoc.impadd.
    END.
    cRange = "O" + cColumn.   
    chWorkSheet:Range(cRange):Value = (t-ddoc.impcom * iFactor) + t-ddoc.impadd.
    cRange = "P" + cColumn.   
    chWorkSheet:Range(cRange):Value = cConVta.
    cRange = "Q" + cColumn.   
    chWorkSheet:Range(cRange):Value = x-Vend.

    cRange = "R" + cColumn.   
    chWorkSheet:Range(cRange):Value = t-ddoc.cLlave.

    IF ccbcdocu.coddoc = 'N/C' THEN DO:
        cRange = "S" + cColumn.   
        chWorkSheet:Range(cRange):Value = CcbCDocu.CodRef + '-' + CcbCDocu.NroRef.
        cRange = "T" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-ddoc.CptoNc.
    END.


    DISPLAY 'GENERANDO EXCEL .... ' @ x-mensaje 
        WITH FRAME {&FRAME-NAME}.

    PAUSE 0.

END.



/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Datos.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        x-CodDiv:ADD-LAST(Gn-divi.coddiv).
    END.
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

