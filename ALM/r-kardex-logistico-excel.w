&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
{lib/tt-file.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD CodMat        AS CHAR         FORMAT 'x(6)'       LABEL 'Codigo'
    FIELD DesMat        AS CHAR         FORMAT 'x(80)'      LABEL 'Descripcion'
    FIELD CatCon        AS CHAR         FORMAT 'x(4)'       LABEL 'Cat Contable'
    FIELD DesMar        AS CHAR         FORMAT 'x(20)'      LABEL 'Marca'
    FIELD UndStk        AS CHAR         FORMAT 'x(8)'       LABEL 'UM'
    FIELD CodAlm        AS CHAR         FORMAT 'x(3)'       LABEL 'Almacen'
    FIELD TipMov        AS CHAR         FORMAT 'x'          LABEL 'Tipo'
    FIELD CodMov        AS INT          FORMAT '99'         LABEL 'Mov'
    FIELD NroSer        AS INT          FORMAT '999'        LABEL 'Serie'
    FIELD NroDoc        AS INT          FORMAT '9999999999' LABEL 'Numero'
    FIELD AlmOri        AS CHAR         FORMAT 'x(7)'       LABEL 'Alm Origen'
    FIELD CodPro        AS CHAR         FORMAT 'x(11)'      LABEL 'Cliente/Proveedor'
    FIELD NroRf1        AS CHAR         FORMAT 'x(12)'      LABEL 'Nro. Documento'
    FIELD NroRf2        AS CHAR         FORMAT 'x(12)'      LABEL 'G/R'
    FIELD NroRf3        AS CHAR         FORMAT 'x(12)'      LABEL 'FAC'
    FIELD FchDoc        AS DATE         FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD Ingreso       AS DECI         FORMAT '>>>,>>9.99' LABEL 'Ingresos'
    FIELD Salida        AS DECI         FORMAT '>>>,>>9.99' LABEL 'Salidas'
    FIELD PreUni        AS DECI         FORMAT '>>>,>>9.9999'   LABEL 'Cto Ingreso'
    FIELD CtoUni        AS DECI         FORMAT '(>>>,>>9.99)'   LABEL 'Cto Promedio'
    FIELD Saldo         AS DECI         FORMAT '(>>>>,>>9.99)'  LABEL 'Saldo'
    FIELD ValCto        AS DECI         FORMAT '(>>>>>,>>9.99)' LABEL 'Cto Total'
    .
/*
    FIELD CodMat        AS CHAR         FORMAT 'x(6)'       COLUMN-LABEL 'Codigo'
    FIELD DesMat        AS CHAR         FORMAT 'x(80)'      COLUMN-LABEL 'Descripcion'
    FIELD CatCon        AS CHAR         FORMAT 'x(4)'       COLUMN-LABEL 'Cat Contable'
    FIELD DesMar        AS CHAR         FORMAT 'x(20)'      COLUMN-LABEL 'Marca'
    FIELD UndStk        AS CHAR         FORMAT 'x(8)'       COLUMN-LABEL 'UM'
    FIELD CodAlm        AS CHAR         FORMAT 'x(3)'       COLUMN-LABEL 'Almacen'
    FIELD TipMov        AS CHAR         FORMAT 'x'          COLUMN-LABEL 'Tipo'
    FIELD CodMov        AS INT          FORMAT '99'         COLUMN-LABEL 'Mov'
    FIELD NroSer        AS INT          FORMAT '999'        COLUMN-LABEL 'Serie'
    FIELD NroDoc        AS INT          FORMAT '9999999999' COLUMN-LABEL 'Numero'
    FIELD AlmOri        AS CHAR         FORMAT 'x(7)'       COLUMN-LABEL 'Alm Origen'
    FIELD CodPro        AS CHAR         FORMAT 'x(11)'      COLUMN-LABEL 'Cliente/Proveedor'
    FIELD NroRf1        AS CHAR         FORMAT 'x(12)'      COLUMN-LABEL 'Nro. Documento'
    FIELD NroRf2        AS CHAR         FORMAT 'x(12)'      COLUMN-LABEL 'G/R'
    FIELD NroRf3        AS CHAR         FORMAT 'x(12)'      COLUMN-LABEL 'FAC'
    FIELD FchDoc        AS DATE         FORMAT '99/99/9999' COLUMN-LABEL 'Fecha'
    FIELD Ingreso       AS DECI         FORMAT '>>>,>>9.99' COLUMN-LABEL 'Ingresos'
    FIELD Salida        AS DECI         FORMAT '>>>,>>9.99' COLUMN-LABEL 'Salidas'
    FIELD PreUni        AS DECI         FORMAT '>>>,>>9.9999'   COLUMN-LABEL 'Cto Ingreso'
    FIELD CtoUni        AS DECI         FORMAT '(>>>,>>9.99)'   COLUMN-LABEL 'Cto Promedio'
    FIELD Saldo         AS DECI         FORMAT '(>>>>,>>9.99)'  COLUMN-LABEL 'Saldo'
    FIELD ValCto        AS DECI         FORMAT '(>>>>>,>>9.99)' COLUMN-LABEL 'Cto Total'
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-8

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almacen

/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 Almacen.CodAlm Almacen.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH Almacen ~
      WHERE Almacen.CodCia = s-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH Almacen ~
      WHERE Almacen.CodCia = s-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 Almacen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BROWSE-8 ~
BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 3" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-8 FOR 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 W-Win _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      Almacen.CodAlm FORMAT "x(5)":U
      Almacen.Descripcion FORMAT "X(40)":U WIDTH 62.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 8.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchDoc-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FchDoc-2 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 6
     BROWSE-8 AT ROW 3.42 COL 3 WIDGET-ID 200
     BUTTON-3 AT ROW 12.31 COL 4 WIDGET-ID 8
     BtnDone AT ROW 12.31 COL 14 WIDGET-ID 10
     FILL-IN-Mensaje AT ROW 14.19 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 14.31
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "KARDEX VALORIZADO POR ALMACEN"
         HEIGHT             = 14.31
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-8 FILL-IN-FchDoc-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "INTEGRAL.Almacen"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Almacen.CodCia = s-codcia"
     _FldNameList[1]   = INTEGRAL.Almacen.CodAlm
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "62.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* KARDEX VALORIZADO POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* KARDEX VALORIZADO POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE 'Selecciona un almacén' VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Procedemos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  ASSIGN FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
  DEF VAR pArchivo AS CHAR NO-UNDO.
  DEF VAR pOptions AS CHAR NO-UNDO.
  RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE('GENERAL').
  IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
  RUN Carga-Temporal.
  SESSION:DATE-FORMAT = "dmy".
  SESSION:SET-WAIT-STATE('').
  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
  RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).
  SESSION:DATE-FORMAT = "dmy".
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-8
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
DEF VAR x-StkIni AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-CtoUni AS DEC NO-UNDO.

FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia NO-LOCK:
    /* Buscamos el saldo inicial */
    x-StkIni = 0.
    x-StkAct = 0.
    FIND LAST AlmStkal WHERE AlmStkal.CodCia = s-codcia AND
        AlmStkal.CodAlm = Almacen.codalm AND
        AlmStkal.codmat = Almmmatg.codmat AND 
        AlmStkal.Fecha < FILL-IN-FchDoc-1
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkal THEN
        ASSIGN
            x-StkIni = AlmStkal.StkAct
            x-StkAct = AlmStkal.StkAct.
    FOR EACH Almdmov USE-INDEX ALMD03 WHERE Almdmov.codcia = Almmmatg.codcia AND
            Almdmov.codalm = Almacen.codalm AND
            Almdmov.codmat = Almmmatg.codmat AND
            (Almdmov.fchdoc >= FILL-IN-FchDoc-1 AND Almdmov.fchdoc <= FILL-IN-FchDoc-2) NO-LOCK,
        FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
            AND Almtmovm.TipMov = Almdmov.TipMov 
            AND Almtmovm.Codmov = Almdmov.Codmov
            /*AND Almtmovm.Movtrf = No*/,   /* NO Transferencias */
        FIRST Almcmov OF Almdmov NO-LOCK:
        x-CtoUni = 0.
        FIND LAST AlmStkge WHERE AlmStkge.CodCia = s-codcia AND
            AlmStkge.codmat = Almdmov.codmat AND
            AlmStkge.Fecha <= Almdmov.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkge THEN x-CtoUni = AlmStkge.CtoUni.
        CREATE Detalle.
        ASSIGN
            Detalle.CodMat = Almmmatg.codmat
            Detalle.DesMat = Almmmatg.desmat
            Detalle.CatCon = Almmmatg.catconta[1]
            Detalle.DesMar = Almmmatg.desmar
            Detalle.UndStk = Almmmatg.undstk
            Detalle.CodAlm = Almdmov.codalm
            Detalle.TipMov = Almdmov.tipmov
            Detalle.CodMov = Almdmov.codmov
            Detalle.NroSer = Almdmov.nroser
            Detalle.NroDoc = Almdmov.nrodoc
            Detalle.NroRf1 = Almcmov.nrorf1
            Detalle.NroRf2 = Almcmov.nrorf2
            Detalle.NroRf3 = Almcmov.nrorf3
            Detalle.AlmOri = Almdmov.almori
            Detalle.CodPro = (Almcmov.codpro + Almcmov.codcli)
            Detalle.FchDoc = Almdmov.fchdoc
            Detalle.Ingreso= ( IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0 )
            Detalle.Salida = (IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0)
            Detalle.PreUni = 0
            Detalle.CtoUni = 0
            Detalle.ValCto  = 0.
        x-StkAct = x-StkAct + Detalle.Ingreso - Detalle.Salida.
        ASSIGN
            Detalle.Saldo  = x-StkAct.      /* Almdmov.stkact.*/
        /* Valorizacion: TODO A SOLES */
        IF Almdmov.Tipmov = 'I' THEN DO:
            Detalle.PreUni  = Almdmov.PreUni / Almdmov.Factor.
        END.
        ELSE DO:
            IF Almtmovm.TipMov = "S" AND Almtmov.MovCmp = YES THEN DO:
                Detalle.PreUni  = Almdmov.PreUni / Almdmov.Factor.
            END.
            ELSE DO:
                Detalle.PreUni  = 0.
            END.
        END.
        IF Almcmov.CodMon = 2 THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                Detalle.PreUni  = ROUND(Almdmov.PreUni * Almdmov.TpoCmb / Almdmov.Factor, 4).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                Detalle.PreUni  = 0.
            END.
            IF Almtmovm.TipMov = "S" AND Almtmov.MovCmp = YES THEN DO:
                Detalle.PreUni  = ROUND(Almdmov.PreUni * Almdmov.TpoCmb / Almdmov.Factor, 4).
            END.
        END.
        IF Almdmov.VctoMn1 = ?  THEN DO:
            Detalle.ValCto = 0.
            Detalle.CtoUni = 0.
        END.
        ELSE DO: 
            Detalle.ValCto = Detalle.Saldo * x-CtoUni.      /* Almdmov.StkAct * Almdmov.VctoMn1.*/
            Detalle.CtoUni = x-CtoUni.                      /* Almdmov.VctoMn1. */
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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BROWSE-8 BUTTON-3 BtnDone 
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
  FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1.
  FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Almacen"}

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

