&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorContadoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codmon AS INTE.
DEF SHARED VAR s-tpocmb AS DECI.
DEF SHARED VAR s-flgsit AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-nrodec AS INTE.
DEF SHARED VAR s-porigv AS DECI.
DEF SHARED VAR s-FlgEmpaque AS LOG.
DEF SHARED VAR s-FlgMinVenta AS LOG.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-NroPed AS CHAR.
DEF SHARED VAR s-CodDoc AS CHAR.

DEF VAR x-CodAlm AS CHAR NO-UNDO.

DEF VAR LocalCadena AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( Almmmatg.CodCia = s-CodCia AND ~
( TRUE <> (LocalCadena > '') OR Almmmatg.DesMat CONTAINS LocalCadena ) ) AND ~
    Almmmatg.tpoart = "A" AND ~
    (TRUE <> (Almmmatg.TpoMrg > '') OR Almmmatg.TpoMrg = '1')

DEF VAR x-Texto AS CHAR FORMAT 'x(10)' NO-UNDO.

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


DEF VAR x-Detalle AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF BUFFER B-ITEM FOR ITEM.

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.

DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.

DEFINE VAR x-StkDis AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-Almmmatg Almmmatg Almmmate ITEM

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ITEM.UndVta ITEM.AlmDes ITEM.CanPed ITEM.Libre_d02 ~
ITEM.PreUni ITEM.Por_Dsctos[1] ITEM.Por_Dsctos[2] ITEM.Por_Dsctos[3] ~
ITEM.ImpDto ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.UndVta ITEM.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH t-Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF t-Almmmatg NO-LOCK, ~
      FIRST Almmmate OF t-Almmmatg ~
      WHERE Almmmate.CodAlm = x-CodAlm ~
 AND Almmmate.StkAct > 0 NO-LOCK, ~
      FIRST ITEM OF t-Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF t-Almmmatg NO-LOCK, ~
      FIRST Almmmate OF t-Almmmatg ~
      WHERE Almmmate.CodAlm = x-CodAlm ~
 AND Almmmate.StkAct > 0 NO-LOCK, ~
      FIRST ITEM OF t-Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-Almmmatg Almmmatg Almmmate ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table ITEM


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm BUTTON_Filtrar ~
FILL-IN-DesMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm FILL-IN-DesMat ~
FILL-IN_ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 27 BY 1.35
     FONT 9.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 70 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1.19
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.35
     FONT 8 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-Almmmatg
    FIELDS(), 
      Almmmatg, 
      Almmmate
    FIELDS(), 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 8.43
      Almmmatg.DesMat FORMAT "X(100)":U WIDTH 75
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 15.43
      ITEM.UndVta FORMAT "x(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ITEM.AlmDes COLUMN-LABEL "Alm!Desp" FORMAT "x(5)":U
      ITEM.CanPed FORMAT ">,>>>,>>9.9999":U WIDTH 7.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ITEM.Libre_d02 COLUMN-LABEL "Flete!Unitario" FORMAT "->>>,>>9.9999":U
            WIDTH 8.43
      ITEM.PreUni COLUMN-LABEL "Precio Unitario!Calculado" FORMAT ">>,>>9.999999":U
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Admins" FORMAT "->>9.9999":U
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Otros" FORMAT "->>9.9999":U
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.9999":U
      ITEM.ImpDto COLUMN-LABEL "Importe!Dcto." FORMAT "->>>,>>9.99":U
      ITEM.ImpLin COLUMN-LABEL "Importe!con IGV" FORMAT ">,>>>,>>9.99":U
            WIDTH 9.43
  ENABLE
      ITEM.UndVta
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 184 BY 15.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 148
     BUTTON_Filtrar AT ROW 1.81 COL 92 WIDGET-ID 154
     FILL-IN-DesMat AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 128
     br_table AT ROW 3.96 COL 2
     FILL-IN_ImpTot AT ROW 19.58 COL 163 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     "F7: Información adicional" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 19.58 COL 3 WIDGET-ID 152
     "TOTAL S/:" VIEW-AS TEXT
          SIZE 17 BY 1.35 AT ROW 19.58 COL 148 WIDGET-ID 6
          FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: t-Almmmatg T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 21.23
         WIDTH              = 190.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-DesMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-Almmmatg,INTEGRAL.Almmmatg OF Temp-Tables.t-Almmmatg,INTEGRAL.Almmmate OF Temp-Tables.t-Almmmatg,Temp-Tables.ITEM OF Temp-Tables.t-Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = "USED, FIRST, FIRST USED, FIRST"
     _Where[3]         = "Almmmate.CodAlm = x-CodAlm
 AND Almmmate.StkAct > 0"
     _FldNameList[1]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" ? ? "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.AlmDes
"ITEM.AlmDes" "Alm!Desp" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" ? ? "decimal" 11 0 ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.Libre_d02
"ITEM.Libre_d02" "Flete!Unitario" "->>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio Unitario!Calculado" ">>,>>9.999999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto.!Admins" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Otros" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.ImpDto
"ITEM.ImpDto" "Importe!Dcto." "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" "Importe!con IGV" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F7 OF br_table IN FRAME F-Main
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN web/d-uniabc (Almmmatg.codmat,
                      x-codalm,
                      s-coddiv,
                      s-codcli,
                      s-tpocmb,
                      s-flgsit,
                      s-nrodec,
                      x-codalm,
                      OUTPUT output-var-2
                      ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE Almmmatg THEN DO:
      DEFINE VAR X-PROMO AS CHAR INIT "".
      FIND FIRST VtaDctoProm WHERE VtaDctoProm.CodCia = s-CodCia AND 
          VtaDctoProm.CodDiv = s-CodDiv AND 
          VtaDctoProm.CodMat = Almmmatg.CodMat AND 
          VtaDctoProm.FlgEst = "A" AND
          (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin)
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaDctoProm THEN X-PROMO = "Promocional ".
      /************************************************/
      /***************Descuento Volumen****************/                    
      DEFINE VAR X-VOLU AS CHAR INIT "".
      DEFINE VAR J AS INTE NO-UNDO.

      DO J = 1 TO 10 :
          IF  Almmmatg.DtoVolD[J] > 0  THEN X-VOLU = "Volumen " .                 
      END.
      IF (X-VOLU + X-PROMO) > '' THEN DO:
         Almmmatg.codmat:BGCOLOR IN BROWSE {&browse-name} = 12.
         Almmmatg.codmat:FGCOLOR IN BROWSE {&browse-name} = 15.
      END.
      ELSE DO:
      END.
      /************************************************/
/*       DO WITH FRAME {&FRAME-NAME}:                                                                                  */
/*          F-DESCUENTO = "".                                                                                          */
/*          IF X-PROMO <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-PROMO.                                   */
/*          IF X-VOLU  <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-VOLU.                                    */
/*          IF X-PROMO <> "" AND X-VOLU <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-PROMO + " y " + X-VOLU. */
/*          F-DESCUENTO:BGCOLOR = 8 .                                                                                  */
/*          F-DESCUENTO:FGCOLOR = 8 .                                                                                  */
/*                                                                                                                     */
/*          IF F-DESCUENTO <> "" THEN DO WITH FRAME {&FRAME-NAME}:                                                     */
/*             F-DESCUENTO:BGCOLOR = 12 .                                                                              */
/*             F-DESCUENTO:FGCOLOR = 15 .                                                                              */
/*             DISPLAY F-DESCUENTO @ F-DESCUENTO.                                                                      */
/*          END.                                                                                                       */
/*       END.                                                                                                          */

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:

  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.UndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.UndVta IN BROWSE br_table /* Und */
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN web/d-uniabc (t-Almmmatg.codmat,
                      x-codalm,
                      s-coddiv,
                      s-codcli,
                      s-tpocmb,
                      s-flgsit,
                      s-nrodec,
                      x-codalm,
                      OUTPUT output-var-2
                      ).
    IF output-var-2 > '' THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.UndVta IN BROWSE br_table /* Und */
OR RETURN OF ITEM.UndVta DO:
    IF SELF:SCREEN-VALUE = "?" OR TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    IF ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = ? THEN RETURN.

    FIND FIRST ITEM WHERE ITEM.CodMat = Almmmatg.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM.
    FIND CURRENT ITEM EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodMat = Almmmatg.codmat
        ITEM.UndVta = SELF:SCREEN-VALUE.

    IF TRUE <> (ITEM.UndVta > '') THEN DO:
        ITEM.UndVta = Almmmatg.UndA.
        DISPLAY ITEM.UndVta WITH BROWSE {&browse-name}.
    END.

/*     RUN {&precio-venta-general} (s-CodCia,                                               */
/*                                  s-CodDiv,                                               */
/*                                  s-CodCli,                                               */
/*                                  s-CodMon,                                               */
/*                                  s-TpoCmb,                                               */
/*                                  OUTPUT f-Factor,                                        */
/*                                  Almmmatg.codmat,                                        */
/*                                  s-FlgSit,                                               */
/*                                  ITEM.undvta,                                            */
/*                                  DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}), */
/*                                  s-NroDec,                                               */
/*                                  x-CodAlm,       /* Necesario para REMATES */            */
/*                                  OUTPUT f-PreBas,                                        */
/*                                  OUTPUT f-PreVta,                                        */
/*                                  OUTPUT f-Dsctos,                                        */
/*                                  OUTPUT y-Dsctos,                                        */
/*                                  OUTPUT x-TipDto,                                        */
/*                                  OUTPUT f-FleteUnitario,                                 */
/*                                  OUTPUT pMensaje                                         */
/*                                  ).                                                      */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                               */
/*         MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                        */
/*         RETURN NO-APPLY.                                                                 */
/*     END.                                                                                 */
/*     DISPLAY                                                                              */
/*         F-PREVTA @ ITEM.PreUni                                                           */
/*         z-Dsctos @ ITEM.Por_Dsctos[2]                                                    */
/*         y-Dsctos @ ITEM.Por_Dsctos[3]                                                    */
/*         WITH BROWSE {&BROWSE-NAME}.                                                      */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.UndVta IN BROWSE br_table /* Und */
OR F8 OF ITEM.UndVta DO:
    /****    Selecciona las unidades de medida   ****/
    RUN web/d-uniabc (Almmmatg.codmat,
                      x-CodAlm,
                      s-coddiv,
                      s-codcli,
                      s-tpocmb,
                      s-flgsit,
                      s-nrodec,
                      x-CodAlm,
                      OUTPUT output-var-2
                      ).
    SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CanPed IN BROWSE br_table /* Cantidad */
OR RETURN OF ITEM.CanPed DO:
    IF SELF:SCREEN-VALUE = ? OR DECIMAL(self:SCREEN-VALUE) = 0 THEN RETURN.
    IF ITEM.CanPed = DECIMAL(SELF:SCREEN-VALUE) THEN RETURN.

    FIND FIRST ITEM WHERE ITEM.CodMat = Almmmatg.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM.
    FIND CURRENT ITEM EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodMat = Almmmatg.codmat.
    IF TRUE <> (ITEM.UndVta > '') THEN DO:
        ITEM.UndVta = Almmmatg.UndA.
        DISPLAY ITEM.UndVta WITH BROWSE {&browse-name}.
    END.
    /* Stock disponible */
    /* *********************************************************************************** */
    /* STOCK COMPROMETIDO */
    /* *********************************************************************************** */
/*     DEF VAR s-StkComprometido AS DEC NO-UNDO.                                                                         */
/*     DEF VAR x-StkAct AS DEC NO-UNDO.                                                                                  */
/*                                                                                                                       */
/*     ASSIGN                                                                                                            */
/*         x-StkAct = Almmmate.StkAct.                                                                                   */
/*     IF x-StkAct > 0 THEN DO:                                                                                          */
/*         RUN gn/Stock-Comprometido-v2 (Almmmatg.CodMat,                                                                */
/*                                       x-CodAlm,                                                                       */
/*                                       YES,    /* Tomar en cuenta venta contado */                                     */
/*                                       OUTPUT s-StkComprometido).                                                      */
/*         IF s-NroPed > '' THEN DO:                                                                                     */
/*             FIND Facdpedi WHERE Facdpedi.codcia = s-codcia                                                            */
/*                 AND Facdpedi.coddoc = s-coddoc                                                                        */
/*                 AND Facdpedi.nroped = s-nroped                                                                        */
/*                 AND Facdpedi.codmat = Almmmatg.CodMat                                                                 */
/*                 NO-LOCK NO-ERROR.                                                                                     */
/*             IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ). */
/*         END.                                                                                                          */
/*     END.                                                                                                              */
/*     x-StkDis = STRING(x-StkAct - s-StkComprometido, '->>>,>>9.9999') + Almmmatg.UndBas.                               */
/*     DISPLAY x-StkDis @ x-StkDis WITH BROWSE {&browse-name}.                                                           */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar B-table-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN FILL-IN-DesMat.
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacén */
DO:
  ASSIGN {&self-name}.
  x-CodAlm = SELF:SCREEN-VALUE.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON ANY-PRINTABLE OF FILL-IN-DesMat IN FRAME F-Main /* Descripción */
DO:
/*   ASSIGN {&self-name}.                                                               */
/*                                                                                      */
/*   /* Armamos la cadena */                                                            */
/*   DEF VAR LocalOrden AS INTE NO-UNDO.                                                */
/*                                                                                      */
/*   LocalCadena = "".                                                                  */
/*   DO LocalOrden = 1 TO NUM-ENTRIES(SELF:SCREEN-VALUE, " "):                          */
/*       LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + */
/*           TRIM(ENTRY(LocalOrden,SELF:SCREEN-VALUE, " ")) + "*".                      */
/*   END.                                                                               */
/*   LocalCadena = REPLACE(LocalCadena, 'z*', '*').                                     */
/*   IF Localcadena > '' THEN RUN dispatch IN THIS-PROCEDURE ('open-query':U).          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON LEAVE OF FILL-IN-DesMat IN FRAME F-Main /* Descripción */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON RETURN OF ITEM.UndVta DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Armamos la cadena */
DEF VAR LocalOrden AS INTE NO-UNDO.

LocalCadena = "".
DO LocalOrden = 1 TO NUM-ENTRIES(FILL-IN-DesMat, " "):
    LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") +
        TRIM(ENTRY(LocalOrden,FILL-IN-DesMat, " ")) + "*".
END.
LocalCadena = REPLACE(LocalCadena, 'z*', '*').

IF Localcadena > '' THEN DO:
    EMPTY TEMP-TABLE t-Almmmatg.
    FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}:
        CREATE t-Almmmatg.
        BUFFER-COPY Almmmatg TO t-Almmmatg.
        FIND FIRST ITEM WHERE ITEM.codcia = Almmmatg.codcia AND
            ITEM.codmat = Almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ITEM THEN DO:
            CREATE ITEM.
            ASSIGN
                ITEM.codcia = Almmmatg.codcia 
                ITEM.codmat = Almmmatg.codmat.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    IF NOT CAN-FIND(FIRST t-Almmmatg NO-LOCK) THEN DO:
        MESSAGE 'NO hay stock para este filtro' VIEW-AS ALERT-BOX WARNING.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Temp-Table B-table-Win 
PROCEDURE Devuelve-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR ITEM.

FOR EACH ITEM WHERE ITEM.canped <= 0 OR ITEM.canped = ?:
    DELETE ITEM.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table B-table-Win 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR ITEM.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
/*{&OPEN-QUERY-{&BROWSE-NAME}}*/

RUN Pinta-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "?" THEN DO:
      /* REASEGURAMOS EL FACTOR DE EQUIVALENCIA */
      FIND Almtfami OF Almmmatg NO-LOCK.

      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
          AND Almtconv.Codalter = ITEM.UndVta
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtconv THEN DO:
          pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
              'Unidad de venta: ' + ITEM.UndVta + CHR(10) +
              'Grabación abortada'.
          APPLY 'ENTRY':U TO ITEM.CanPed IN BROWSE {&browse-name}.
          UNDO, RETURN "ADM-ERROR".
      END.
      F-FACTOR = Almtconv.Equival.
      ASSIGN
          ITEM.CodCia = S-CODCIA
          ITEM.AlmDes = x-CodAlm
          ITEM.Factor = F-FACTOR
          ITEM.PorDto = f-Dsctos
          ITEM.PreBas = F-PreBas
          ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
          ITEM.AftIgv = Almmmatg.AftIgv
          ITEM.AftIsc = Almmmatg.AftIsc
          ITEM.Libre_c04 = x-TipDto.
      ASSIGN
          ITEM.PreUni = f-PreVta
          /*ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})*/
          ITEM.Por_Dsctos[2] = z-Dsctos
          ITEM.Por_Dsctos[3] = y-Dsctos
          ITEM.Libre_d02     = f-FleteUnitario.
      /* ***************************************************************** */
      {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
      /* ***************************************************************** */
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      DEF VAR X AS CHAR NO-UNDO.
      DEF VAR i AS INTE NO-UNDO.
      DEF VAR j AS INTE NO-UNDO.

      COMBO-BOX-CodAlm:DELIMITER = CHR(9).
      COMBO-BOX-CodAlm:DELETE(1).
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          X = ENTRY(i, s-CodAlm).
          FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = X NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DO:
              COMBO-BOX-CodAlm:ADD-LAST(Almacen.CodAlm + " " + Almacen.Descripcion, Almacen.CodAlm).
              IF j = 0 THEN ASSIGN COMBO-BOX-CodAlm = Almacen.CodAlm x-CodAlm = Almacen.CodAlm.
              j = j + 1.
          END.
      END.
  END.
  x-codalm = ENTRY(1,s-CodAlm).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      /*IF AVAILABLE ITEM AND (ITEM.CanPed = ? OR ITEM.CanPed <= 0) THEN DELETE ITEM.*/
  END.
  FIND CURRENT ITEM NO-LOCK NO-ERROR.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Total B-table-Win 
PROCEDURE Pinta-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_ImpTot = 0.
     FOR EACH ITEM:
         FILL-IN_ImpTot = FILL-IN_ImpTot + ITEM.ImpLin.
     END.
     DISPLAY  FILL-IN_ImpTot.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

               
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR F-PREVTA AS DECI NO-UNDO.
DEF VAR F-PreBas AS DECI NO-UNDO.
DEF VAR F-DSCTOS AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR Y-DSCTOS AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

/* ARTIFICIO */
Fi-Mensaje = "RECALCULANDO PRECIOS".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

FOR EACH ITEM WHERE ITEM.CanPed > 0 AND ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat,
                                 s-FlgSit,
                                 ITEM.undvta,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 ITEM.almdes,   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.

    ASSIGN 
        ITEM.Libre_d02 = f-FleteUnitario. 
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).

          ASSIGN
              ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).
        END.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.

HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-Almmmatg"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "ITEM"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* *********************************************************************************** */
  /* UNIDAD */
  /* *********************************************************************************** */
  DEFINE VAR pCanPed AS DEC NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  DEFINE VAR x-codmat2 AS CHAR.   
  
  x-codmat2 = Almmmatg.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "?" THEN DO:
      /* *********************************************************************************** */
      /* FAMILIA DE VENTAS */
      /* *********************************************************************************** */
      FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
      IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
          MESSAGE 'Línea NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE = ?.
          ITEM.UndVta:SCREEN-VALUE = ?.
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
      FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
      IF AVAILABLE Almsfami AND 
          AlmSFami.SwDigesa = YES AND 
          Almmmatg.VtoDigesa <> ? AND 
          Almmmatg.VtoDigesa < TODAY THEN DO:
          MESSAGE 'Producto ' + x-codmat2 + ' con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE = ?.
          ITEM.UndVta:SCREEN-VALUE = ?.
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
          
      RUN vtagn/ventas-library PERSISTENT SET hProc.

      pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
      RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,
                                        INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                        INPUT-OUTPUT pCanPed,
                                        OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
      DELETE PROCEDURE hProc.
      /* ***************************************************************************************************** */
      /* ***************************************************************************************************** */
      /* ***************************************************************************************************************** */
      /* 22/05/2023 PRECIO UNITARIO */
      /* ***************************************************************************************************************** */
      RUN {&precio-venta-general} (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   Almmmatg.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                   s-FlgSit,
                                   ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                   DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                   s-NroDec,
                                   x-CodAlm,   /* Necesario para REMATES */
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto,
                                   OUTPUT f-FleteUnitario,
                                   OUTPUT pMensaje
                                   ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE = ?.
          ITEM.UndVta:SCREEN-VALUE = ?.
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
      DISPLAY 
          F-PREVTA @ ITEM.PreUni 
          z-Dsctos @ ITEM.Por_Dsctos[2]
          y-Dsctos @ ITEM.Por_Dsctos[3]
          WITH BROWSE {&BROWSE-NAME}.
      /* ***************************************************************************************************************** */
      /* ***************************************************************************************************************** */
      /* FACTOR DE EQUIVALENCIA */
      FIND FIRST Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          NO-LOCK.
      F-FACTOR = Almtconv.Equival.
      IF DECIMAL(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
          ITEM.CanPed:SCREEN-VALUE = ?.
          ITEM.UndVta:SCREEN-VALUE = ?.
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
      /* *********************************************************************************** */
      /* STOCK COMPROMETIDO */
      /* *********************************************************************************** */
      DEF VAR s-StkComprometido AS DEC NO-UNDO.
      DEF VAR x-StkAct AS DEC NO-UNDO.

      ASSIGN
          x-StkAct = Almmmate.StkAct.
      IF x-StkAct > 0 THEN DO:
          RUN gn/Stock-Comprometido-v2 (Almmmatg.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                        x-CodAlm, 
                                        YES,    /* Tomar en cuenta venta contado */
                                        OUTPUT s-StkComprometido).

      /*IF s-adm-new-record = 'NO' THEN DO:*/
      IF s-NroPed > '' THEN DO:
          FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
              AND Facdpedi.coddoc = s-coddoc
              AND Facdpedi.nroped = s-nroped
              AND Facdpedi.codmat = Almmmatg.CodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ).
      END.

      END.
      ASSIGN
          x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor.
      IF (x-StkAct - s-StkComprometido) < x-CanPed
          THEN DO:
            MESSAGE "No hay STOCK suficiente" SKIP(1)
                    "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP
                    "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
                    "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP
                    VIEW-AS ALERT-BOX ERROR.
            ITEM.CanPed:SCREEN-VALUE = ?.
            ITEM.UndVta:SCREEN-VALUE = ?.
            APPLY 'ENTRY':U TO ITEM.CanPed.
            RETURN "ADM-ERROR".
      END.
      /* *********************************************************************************** */
      /* *********************************************************************************** */
      /* *********************************************************************************** */
      /* RHC 09/11/2012 NO CONTINUAMOS SI ES UN ALMACEN DE REMATE */
      /* *********************************************************************************** */
      FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = x-CodAlm NO-LOCK.
      IF Almacen.Campo-C[3] = "Si" THEN RETURN "OK".
      /* *********************************************************************************** */
      /* *********************************************************************************** */
      /* *********************************************************************************** */
      /* EMPAQUE */
      /* *********************************************************************************** */
      DEF VAR pSugerido AS DEC NO-UNDO.
      DEF VAR pEmpaque AS DEC NO-UNDO.
      pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
      RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                        INPUT s-CodDiv,
                                        INPUT Almmmatg.codmat,
                                        INPUT pCanPed,
                                        INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                        INPUT s-CodCli,
                                        OUTPUT pSugerido,
                                        OUTPUT pEmpaque,
                                        OUTPUT pMensaje).
      IF pMensaje > '' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN "ADM-ERROR".
      END.
      /* ************************************************************************************* */
      /* ********************************* MARGEN DE UTILIDAD ******************************* */
      /* CONTRATO MARCO, REMATES, EXPOLIBRERIA, LISTA EXPRESS: NO TIENE MINIMO NI MARGEN DE UTILIDAD */
      /* ************************************************************************************* */
      IF LOOKUP(s-TpoPed, "M,R") > 0 THEN RETURN "OK".   

      /* 14/12/2022: El control es por Pricing */
      DEF VAR pError AS CHAR NO-UNDO.
      DEF VAR X-MARGEN AS DEC NO-UNDO.
      DEF VAR X-LIMITE AS DEC NO-UNDO.
      DEF VAR x-PreUni AS DEC NO-UNDO.

      CASE x-TipDto:
          WHEN "CONTRATO" THEN .
          OTHERWISE DO:
              x-PreUni = DECIMAL ( ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
                  ( 1 - DECIMAL (ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
                  ( 1 - DECIMAL (ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )/ 100 ) *
                  ( 1 - DECIMAL (ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .
              RUN pri/pri-librerias PERSISTENT SET hProc.
              RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                                       INPUT Almmmatg.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                                       INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                                       INPUT x-PreUni,
                                                       INPUT s-CodMon,
                                                       OUTPUT x-Margen,
                                                       OUTPUT x-Limite,
                                                       OUTPUT pError).
              IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                  /* Error crítico */
                  MESSAGE pError VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
                  ITEM.CanPed:SCREEN-VALUE = ?.
                  ITEM.UndVta:SCREEN-VALUE = ?.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN 'ADM-ERROR'.
              END.
              DELETE PROCEDURE hProc.
          END.
      END CASE.
  END.
  RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST ITEM WHERE ITEM.CodMat = Almmmatg.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM.
    FIND CURRENT ITEM EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodMat = Almmmatg.codmat.
    FIND CURRENT ITEM NO-LOCK NO-ERROR.


/* IF AVAILABLE Almmmatg THEN DO:                                                                                        */
/*     /* *********************************************************************************** */                         */
/*     /* STOCK COMPROMETIDO */                                                                                          */
/*     /* *********************************************************************************** */                         */
/*     DEF VAR s-StkComprometido AS DEC NO-UNDO.                                                                         */
/*     DEF VAR x-StkAct AS DEC NO-UNDO.                                                                                  */
/*                                                                                                                       */
/*     ASSIGN                                                                                                            */
/*         x-StkAct = Almmmate.StkAct.                                                                                   */
/*     IF x-StkAct > 0 THEN DO:                                                                                          */
/*         RUN gn/Stock-Comprometido-v2 (Almmmatg.CodMat,                                                                */
/*                                       x-CodAlm,                                                                       */
/*                                       YES,    /* Tomar en cuenta venta contado */                                     */
/*                                       OUTPUT s-StkComprometido).                                                      */
/*         IF s-NroPed > '' THEN DO:                                                                                     */
/*             FIND Facdpedi WHERE Facdpedi.codcia = s-codcia                                                            */
/*                 AND Facdpedi.coddoc = s-coddoc                                                                        */
/*                 AND Facdpedi.nroped = s-nroped                                                                        */
/*                 AND Facdpedi.codmat = Almmmatg.CodMat                                                                 */
/*                 NO-LOCK NO-ERROR.                                                                                     */
/*             IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ). */
/*         END.                                                                                                          */
/*     END.                                                                                                              */
/*     x-StkDis = STRING(x-StkAct - s-StkComprometido, '->>>,>>9.9999') + Almmmatg.UndBas.                               */
/*     DISPLAY x-StkDis @ x-StkDis WITH BROWSE {&browse-name}.                                                           */
/* END.                                                                                                                  */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

