&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almacen FOR Almacen.
DEFINE BUFFER B-PERS FOR PL-PERS.
DEFINE TEMP-TABLE t-AlmCIncidencia NO-UNDO LIKE AlmCIncidencia
       FIELD Transportista AS CHAR FORMAT 'x(15)'
       FIELD Conductor AS CHAR FORMAT 'x(15)'
       FIELD Placa AS CHAR FORMAT 'x(15)'
       FIELD GuiaRem AS CHAR FORMAT 'x(15)'
       FIELD HRuta AS CHAR FORMAT 'x(15)'.



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

DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-NroOTR AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR pv-codcia AS INTE.

/*
&SCOPED-DEFINE Condicion ( AlmCIncidencia.CodCia = s-CodCia ~
AND (FILL-IN-FchDoc-1 = ? OR AlmCIncidencia.Fecha >=  FILL-IN-FchDoc-1) ~
AND (FILL-IN-FchDoc-2 = ? OR AlmCIncidencia.Fecha <=  FILL-IN-FchDoc-2) ~
AND (RADIO-SET-FlgEst = 'Todos' OR AlmCIncidencia.FlgEst = RADIO-SET-FlgEst) ~
AND (TRUE <> (FILL-IN-AlmDes > '') OR AlmCIncidencia.AlmDes = FILL-IN-AlmDes) ~
AND (TRUE <> (FILL-IN-AlmOri > '') OR AlmCIncidencia.AlmOri = FILL-IN-AlmOri) ) 
*/

&SCOPED-DEFINE Condicion ( AlmCIncidencia.CodCia = s-CodCia ~
AND (TRUE <> (FILL-IN-AlmDes > '') OR AlmCIncidencia.AlmDes = FILL-IN-AlmDes) ~
AND (TRUE <> (FILL-IN-AlmOri > '') OR AlmCIncidencia.AlmOri = FILL-IN-AlmOri) ~
AND (FILL-IN-FchDoc-1 = ? OR AlmCIncidencia.Fecha >=  FILL-IN-FchDoc-1) ~
AND (FILL-IN-FchDoc-2 = ? OR AlmCIncidencia.Fecha <=  FILL-IN-FchDoc-2) ~
AND (RADIO-SET-FlgEst = 'Todos' OR AlmCIncidencia.FlgEst = RADIO-SET-FlgEst)) 

    DEF TEMP-TABLE Cabecera
        FIELD NroControl    AS CHAR FORMAT 'x(12)'  LABEL 'Incidencia'
        FIELD CodDoc        AS CHAR FORMAT 'x(3)'   LABEL 'Ref'
        FIELD NroDoc        AS CHAR FORMAT 'x(12)'  LABEL 'Numero'
        FIELD Estado        AS CHAR FORMAT 'x(15)'  LABEL 'Estado'
        FIELD Fecha         AS DATE                 LABEL 'Fecha Emision'
        FIELD Hora          AS CHAR FORMAT 'x(5)'   LABEL 'Hora Emision'
        FIELD AlmOri        AS CHAR FORMAT 'x(8)'   LABEL 'Alm. Origen'
        FIELD DesOri        AS CHAR FORMAT 'x(40)'  LABEL 'Descripcion'
        FIELD AlmDes        AS CHAR FORMAT 'x(8)'   LABEL 'Alm. Destino'
        FIELD DesDes        AS CHAR FORMAT 'x(40)'  LABEL 'Descripcion'
        FIELD Usuario       AS CHAR FORMAT 'x(12)'  LABEL 'Usuario Generacion'
        FIELD ChkAlmOri     AS CHAR FORMAT 'x(8)'   LABEL 'Cheq. Alm. Orig.'
        FIELD NomChkAlmOri  AS CHAR FORMAT 'x(40)'  LABEL 'Nom. Cheq. Alm. Orig.'
        FIELD ChkAlmDes     AS CHAR FORMAT 'x(8)'   LABEL 'Cheq. Alm. Des.'
        FIELD NomChkAlmDes  AS CHAR FORMAT 'x(40)'  LABEL 'Nom. Cheq. Alm. Des.'
        FIELD Motivo        AS CHAR FORMAT 'x(40)'  LABEL 'Motivo'
        FIELD Glosa         AS CHAR FORMAT 'x(100)' LABEL 'Glosa'
        FIELD CodPro        AS CHAR FORMAT 'x(15)'  LABEL 'Transportista'
        FIELD NomPro        AS CHAR FORMAT 'x(60)'  LABEL 'Nombre del transportista'
        FIELD Conductor     AS CHAR FORMAT 'x(15)'  LABEL 'Conductor'
        FIELD NomConductor  AS CHAR FORMAT 'x(60)'  LABEL 'Nombre del conductor'
        FIELD Placa         AS CHAR FORMAT 'x(15)'  LABEL 'Placa'
        FIELD GuiaRem       AS CHAR FORMAT 'x(20)'  LABEL 'GR Transportista'
        FIELD HRuta         AS CHAR FORMAT 'x(15)'  LABEL 'Hoja de Ruta'
        .

    DEF TEMP-TABLE Detalle LIKE Cabecera
        FIELD CodMat        AS CHAR FORMAT 'x(6)'   COLUMN-LABEL 'Codigo'
        FIELD DesMat        AS CHAR FORMAT 'x(80)'  COLUMN-LABEL 'Descripcion'
        FIELD DesMar        AS CHAR FORMAT 'x(20)'  COLUMN-LABEL 'Marca'
        FIELD UndVta        AS CHAR FORMAT 'x(8)'   COLUMN-LABEL 'Und'
        FIELD Indicencia    AS CHAR FORMAT 'x(8)'   COLUMN-LABEL 'Incidencia'
        FIELD CanInc        AS DEC FORMAT '>,>>>,>>9.9999'  COLUMN-LABEL 'Cantidad Incidencia'
        FIELD NroRA         AS CHAR FORMAT 'x(12)'  COLUMN-LABEL 'R/A'
        FIELD NroOTR        AS CHAR FORMAT 'x(12)'  COLUMN-LABEL 'OTR'
        FIELD Salida        AS CHAR FORMAT 'x(12)'  COLUMN-LABEL 'Salida'
        FIELD Ingreso       AS CHAR FORMAT 'x(12)'  COLUMN-LABEL 'Ingreso'
            .

    DEF VAR x-NomChkOri AS CHAR NO-UNDO.
    DEF VAR x-NomChkDes AS CHAR NO-UNDO.


DEF VAR x-Transportista LIKE t-AlmCIncidencia.Transportista NO-UNDO.
DEF VAR x-Conductor LIKE t-AlmCIncidencia.Conductor NO-UNDO.
DEF VAR x-Placa LIKE t-AlmCIncidencia.Placa NO-UNDO.
DEF VAR x-GuiaRem LIKE t-AlmCIncidencia.GuiaRem NO-UNDO.
DEF VAR x-HRuta LIKE t-AlmCIncidencia.HRuta NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-AlmCIncidencia AlmCIncidencia Almacen ~
B-Almacen PL-PERS

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmCIncidencia.NroControl ~
AlmCIncidencia.CodDoc AlmCIncidencia.NroDoc fEstado() @ x-Estado ~
AlmCIncidencia.Fecha AlmCIncidencia.Hora AlmCIncidencia.AlmOri ~
Almacen.Descripcion AlmCIncidencia.AlmDes B-Almacen.Descripcion ~
AlmCIncidencia.Usuario AlmCIncidencia.ChkAlmOri ~
fNomPer(AlmCIncidencia.ChkAlmOri) @ x-NomChkOri AlmCIncidencia.ChkAlmDes ~
fNomPer(AlmCIncidencia.ChkAlmDes) @ x-NomChkDes ~
fMotivo()  @ AlmCIncidencia.MotivoRechazo AlmCIncidencia.GlosaRechazo ~
t-AlmCIncidencia.Transportista @ x-Transportista ~
t-AlmCIncidencia.Conductor @ x-Conductor t-AlmCIncidencia.Placa @ x-Placa ~
t-AlmCIncidencia.GuiaRem @ x-GuiaRem t-AlmCIncidencia.HRuta @ x-HRuta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-AlmCIncidencia WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST AlmCIncidencia OF t-AlmCIncidencia NO-LOCK, ~
      FIRST Almacen WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND Almacen.CodCia = AlmCIncidencia.CodCia ~
  AND Almacen.CodAlm = AlmCIncidencia.AlmOri OUTER-JOIN NO-LOCK, ~
      FIRST B-Almacen WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND B-Almacen.CodCia = AlmCIncidencia.CodCia ~
  AND B-Almacen.CodAlm = AlmCIncidencia.AlmDes OUTER-JOIN NO-LOCK, ~
      FIRST PL-PERS WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND PL-PERS.CodCia = AlmCIncidencia.CodCia ~
  AND PL-PERS.codper = AlmCIncidencia.ChkAlmOri OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-AlmCIncidencia WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST AlmCIncidencia OF t-AlmCIncidencia NO-LOCK, ~
      FIRST Almacen WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND Almacen.CodCia = AlmCIncidencia.CodCia ~
  AND Almacen.CodAlm = AlmCIncidencia.AlmOri OUTER-JOIN NO-LOCK, ~
      FIRST B-Almacen WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND B-Almacen.CodCia = AlmCIncidencia.CodCia ~
  AND B-Almacen.CodAlm = AlmCIncidencia.AlmDes OUTER-JOIN NO-LOCK, ~
      FIRST PL-PERS WHERE TRUE /* Join to AlmCIncidencia incomplete */ ~
      AND PL-PERS.CodCia = AlmCIncidencia.CodCia ~
  AND PL-PERS.codper = AlmCIncidencia.ChkAlmOri OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-AlmCIncidencia AlmCIncidencia ~
Almacen B-Almacen PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-AlmCIncidencia
&Scoped-define SECOND-TABLE-IN-QUERY-br_table AlmCIncidencia
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almacen
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table B-Almacen
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table PL-PERS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-FlgEst FILL-IN-AlmDes ~
FILL-IN-CodMat FILL-IN-AlmOri FILL-IN-FchDoc-1 BUTTON-2 BUTTON-3 ~
FILL-IN-FchDoc-2 br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-FlgEst FILL-IN-AlmDes ~
FILL-IN-CodMat FILL-IN-DesMat FILL-IN-AlmOri FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fIngreso B-table-Win 
FUNCTION fIngreso RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMotivo B-table-Win 
FUNCTION fMotivo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer B-table-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroOTR B-table-Win 
FUNCTION fNroOTR RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroRA B-table-Win 
FUNCTION fNroRA RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSalida B-table-Win 
FUNCTION fSalida RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Aplicar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Limpiar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén Incidencia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmOri AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén Observado" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(14)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "Todos",
"Por Aprobar", "P",
"Regularizado", "C",
"Rechazado", "A"
     SIZE 15 BY 4.04 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-AlmCIncidencia, 
      AlmCIncidencia, 
      Almacen
    FIELDS(Almacen.Descripcion), 
      B-Almacen
    FIELDS(B-Almacen.Descripcion), 
      PL-PERS
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmCIncidencia.NroControl COLUMN-LABEL "Incidencia" FORMAT "x(12)":U
            WIDTH 9.43
      AlmCIncidencia.CodDoc COLUMN-LABEL "Ref." FORMAT "x(3)":U
            WIDTH 5.43
      AlmCIncidencia.NroDoc COLUMN-LABEL "Número" FORMAT "x(12)":U
      fEstado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 12.43
      AlmCIncidencia.Fecha COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      AlmCIncidencia.Hora FORMAT "x(8)":U
      AlmCIncidencia.AlmOri COLUMN-LABEL "Alm.!Origen" FORMAT "x(8)":U
      Almacen.Descripcion FORMAT "X(40)":U
      AlmCIncidencia.AlmDes COLUMN-LABEL "Alm.!Destino" FORMAT "x(8)":U
      B-Almacen.Descripcion FORMAT "X(40)":U
      AlmCIncidencia.Usuario FORMAT "x(12)":U
      AlmCIncidencia.ChkAlmOri COLUMN-LABEL "Cheq. Alm. Orig." FORMAT "x(8)":U
      fNomPer(AlmCIncidencia.ChkAlmOri) @ x-NomChkOri COLUMN-LABEL "Nombre" FORMAT "x(30)":U
      AlmCIncidencia.ChkAlmDes COLUMN-LABEL "Cheq. Alm. Des." FORMAT "x(8)":U
      fNomPer(AlmCIncidencia.ChkAlmDes) @ x-NomChkDes COLUMN-LABEL "Nombre" FORMAT "x(30)":U
      fMotivo()  @ AlmCIncidencia.MotivoRechazo COLUMN-LABEL "Motivo Rechazo" FORMAT "x(40)":U
      AlmCIncidencia.GlosaRechazo FORMAT "x(100)":U
      t-AlmCIncidencia.Transportista @ x-Transportista
      t-AlmCIncidencia.Conductor @ x-Conductor
      t-AlmCIncidencia.Placa @ x-Placa
      t-AlmCIncidencia.GuiaRem @ x-GuiaRem
      t-AlmCIncidencia.HRuta @ x-HRuta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 9.42
         FONT 4
         TITLE "INCIDENCIAS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-FlgEst AT ROW 1.27 COL 11 NO-LABEL WIDGET-ID 2
     FILL-IN-AlmDes AT ROW 1.27 COL 49 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-CodMat AT ROW 1.27 COL 69 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-DesMat AT ROW 1.27 COL 83 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-AlmOri AT ROW 2.35 COL 49 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchDoc-1 AT ROW 3.42 COL 49 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 3.42 COL 71 WIDGET-ID 14
     BUTTON-3 AT ROW 3.42 COL 86 WIDGET-ID 16
     FILL-IN-FchDoc-2 AT ROW 4.5 COL 49 COLON-ALIGNED WIDGET-ID 12
     br_table AT ROW 5.58 COL 1.43
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
      TABLE: B-Almacen B "?" ? INTEGRAL Almacen
      TABLE: B-PERS B "?" ? INTEGRAL PL-PERS
      TABLE: t-AlmCIncidencia T "?" NO-UNDO INTEGRAL AlmCIncidencia
      ADDITIONAL-FIELDS:
          FIELD Transportista AS CHAR FORMAT 'x(15)'
          FIELD Conductor AS CHAR FORMAT 'x(15)'
          FIELD Placa AS CHAR FORMAT 'x(15)'
          FIELD GuiaRem AS CHAR FORMAT 'x(15)'
          FIELD HRuta AS CHAR FORMAT 'x(15)'
      END-FIELDS.
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
         HEIGHT             = 17.19
         WIDTH              = 141.14.
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
/* BROWSE-TAB br_table FILL-IN-FchDoc-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-AlmCIncidencia,INTEGRAL.AlmCIncidencia OF Temp-Tables.t-AlmCIncidencia,INTEGRAL.Almacen WHERE INTEGRAL.AlmCIncidencia ...,B-Almacen WHERE INTEGRAL.AlmCIncidencia ...,INTEGRAL.PL-PERS WHERE INTEGRAL.AlmCIncidencia ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _Where[3]         = "Almacen.CodCia = AlmCIncidencia.CodCia
  AND Almacen.CodAlm = AlmCIncidencia.AlmOri"
     _Where[4]         = "B-Almacen.CodCia = AlmCIncidencia.CodCia
  AND B-Almacen.CodAlm = AlmCIncidencia.AlmDes"
     _Where[5]         = "INTEGRAL.PL-PERS.CodCia = AlmCIncidencia.CodCia
  AND INTEGRAL.PL-PERS.codper = AlmCIncidencia.ChkAlmOri"
     _FldNameList[1]   > INTEGRAL.AlmCIncidencia.NroControl
"AlmCIncidencia.NroControl" "Incidencia" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmCIncidencia.CodDoc
"AlmCIncidencia.CodDoc" "Ref." ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AlmCIncidencia.NroDoc
"AlmCIncidencia.NroDoc" "Número" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fEstado() @ x-Estado" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmCIncidencia.Fecha
"AlmCIncidencia.Fecha" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.AlmCIncidencia.Hora
     _FldNameList[7]   > INTEGRAL.AlmCIncidencia.AlmOri
"AlmCIncidencia.AlmOri" "Alm.!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.Almacen.Descripcion
     _FldNameList[9]   > INTEGRAL.AlmCIncidencia.AlmDes
"AlmCIncidencia.AlmDes" "Alm.!Destino" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.B-Almacen.Descripcion
     _FldNameList[11]   = INTEGRAL.AlmCIncidencia.Usuario
     _FldNameList[12]   > INTEGRAL.AlmCIncidencia.ChkAlmOri
"AlmCIncidencia.ChkAlmOri" "Cheq. Alm. Orig." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fNomPer(AlmCIncidencia.ChkAlmOri) @ x-NomChkOri" "Nombre" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.AlmCIncidencia.ChkAlmDes
"AlmCIncidencia.ChkAlmDes" "Cheq. Alm. Des." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"fNomPer(AlmCIncidencia.ChkAlmDes) @ x-NomChkDes" "Nombre" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"fMotivo()  @ AlmCIncidencia.MotivoRechazo" "Motivo Rechazo" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   = INTEGRAL.AlmCIncidencia.GlosaRechazo
     _FldNameList[18]   > "_<CALC>"
"t-AlmCIncidencia.Transportista @ x-Transportista" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"t-AlmCIncidencia.Conductor @ x-Conductor" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"t-AlmCIncidencia.Placa @ x-Placa" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"t-AlmCIncidencia.GuiaRem @ x-GuiaRem" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"t-AlmCIncidencia.HRuta @ x-HRuta" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* INCIDENCIAS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* INCIDENCIAS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* INCIDENCIAS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Aplicar */
DO:
    ASSIGN FILL-IN-AlmDes FILL-IN-AlmOri FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 RADIO-SET-FlgEst.
    ASSIGN FILL-IN-CodMat FILL-IN-DesMat.

    IF FILL-IN-FchDoc-1 = ? THEN DO:
        MESSAGE "Ingrese la fecha Desde"
        VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    IF FILL-IN-FchDoc-2 = ? THEN DO:
        MESSAGE "Ingrese la fecha Hasta"
        VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    /*
    IF TRUE <> (FILL-IN-AlmDes > "") THEN DO:
        MESSAGE "Ingrese el almacen de Incidencia"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.        
    */

    RUN Carga-Temporal.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Limpiar */
DO:
    ASSIGN
        FILL-IN-AlmDes = ''
        FILL-IN-AlmOri = ''
        FILL-IN-FchDoc-1 = ?
        FILL-IN-FchDoc-2 = ?.
    CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
    RADIO-SET-FlgEst = "Todos".
    DISPLAY RADIO-SET-FlgEst WITH FRAME {&FRAME-NAME}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat B-table-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Artículo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF Almcincidencia DO:
    IF FILL-IN-CodMat > '' AND 
        NOT CAN-FIND(FIRST Almdincidencia OF Almcincidencia WHERE Almdincidencia.codmat = FILL-IN-CodMat
                     NO-LOCK) THEN RETURN ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Cabecera B-table-Win 
PROCEDURE Carga-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER TABLE FOR Cabecera.

EMPTY TEMP-TABLE Cabecera.

GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE AlmCIncidencia:
    CREATE Cabecera.
    BUFFER-COPY AlmCIncidencia TO Cabecera
        ASSIGN
        Cabecera.Estado = fEstado()
        Cabecera.DesOri = (IF AVAILABLE Almacen THEN Almacen.Descripcion ELSE '')
        Cabecera.DesDes = (IF AVAILABLE B-Almacen THEN B-Almacen.Descripcion ELSE '')
        .
    Cabecera.NomChkAlmOri = fNomPer(AlmCIncidencia.ChkAlmOri).
    Cabecera.NomChkAlmDes = fNomPer(AlmCIncidencia.ChkAlmDes).
    Cabecera.Motivo = fMotivo().
    Cabecera.Glosa  = AlmCIncidencia.GlosaRechazo.

    /* 30/06/2023: S.León datos adicionales */
    ASSIGN
        Cabecera.codpro = t-AlmCIncidencia.Transportista
        Cabecera.conductor = t-AlmCIncidencia.Conductor
        Cabecera.placa = t-AlmCIncidencia.Placa
        Cabecera.guiarem = t-AlmCIncidencia.GuiaRem
        Cabecera.hruta = t-AlmCIncidencia.HRuta
        .
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Cabecera.codpro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN Cabecera.nompro = gn-prov.nompro.
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
        vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = Cabecera.conductor NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN Cabecera.NomConductor = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.


    GET NEXT {&BROWSE-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle B-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER TABLE FOR Detalle.

EMPTY TEMP-TABLE Detalle.

GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE AlmCIncidencia:
    FOR EACH AlmDIncidencia OF AlmCIncidencia NO-LOCK, FIRST Almmmatg OF AlmDIncidencia NO-LOCK:
        CREATE Detalle.
        BUFFER-COPY AlmCIncidencia TO Detalle
            ASSIGN
            Detalle.Estado = fEstado()
            Detalle.DesOri = (IF AVAILABLE Almacen THEN Almacen.Descripcion ELSE '')
            Detalle.DesDes = (IF AVAILABLE B-Almacen THEN B-Almacen.Descripcion ELSE '')
            .
        Detalle.NomChkAlmOri = fNomPer(AlmCIncidencia.ChkAlmOri).
        Detalle.NomChkAlmDes = fNomPer(AlmCIncidencia.ChkAlmDes).
        Detalle.Motivo = fMotivo().
        Detalle.Glosa  = AlmCIncidencia.GlosaRechazo.
        ASSIGN
            Detalle.CodMat       = AlmDIncidencia.CodMat 
            Detalle.DesMat       = Almmmatg.DesMat 
            Detalle.DesMar       = Almmmatg.DesMar
            Detalle.UndVta       = AlmDIncidencia.UndVta 
            Detalle.Indicencia   = AlmDIncidencia.Incidencia 
            Detalle.CanInc       = AlmDIncidencia.CanInc.
        ASSIGN
            Detalle.NroRA        = fNroRA().
        ASSIGN
            Detalle.NroOTR       = fNroOTR().
        x-NroOTR = Detalle.NroOTR.
        ASSIGN
            Detalle.Salida       = fSalida()
            Detalle.Ingreso       = fIngreso().
    END.
    GET NEXT {&BROWSE-NAME}.
END.

END PROCEDURE.

/*
    GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE AlmCIncidencia:
    CREATE Cabecera.
    BUFFER-COPY AlmCIncidencia TO Cabecera
        ASSIGN
        Cabecera.Estado = fEstado()
        Cabecera.DesOri = (IF AVAILABLE Almacen THEN Almacen.Descripcion ELSE '')
        Cabecera.DesDes = (IF AVAILABLE B-Almacen THEN B-Almacen.Descripcion ELSE '')
        .
    FIND Almacen WHERE Almacen.codcia = s-codcia AND
        Almacen.codalm = AlmCIncidencia.AlmDes
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN Cabecera.NomAlmDes = Almacen.Descripcion.
    GET NEXT {&BROWSE-NAME}.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-AlmCIncidencia.
FOR EACH AlmCIncidencia NO-LOCK WHERE {&Condicion}:
    CREATE t-AlmCIncidencia.
    BUFFER-COPY AlmCIncidencia TO t-AlmCIncidencia.
    /* Buscamos info en la HR */
    /* Solo he encontrado OTR */
    ASSIGN
        t-AlmCIncidencia.Transportista = ''
        t-AlmCIncidencia.Conductor = ''
        t-AlmCIncidencia.Placa = ''
        t-AlmCIncidencia.GuiaRem = ''
        t-AlmCIncidencia.HRuta = ''.
    RLOOP:
    FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia AND
        almcmov.codref = AlmCIncidencia.CodDoc AND
        almcmov.nroref = AlmCIncidencia.NroDoc AND
        almcmov.flgest <> 'A':
        FOR EACH di-rutag NO-LOCK WHERE di-rutag.codcia = s-codcia AND
            di-rutag.coddoc = "H/R" AND
            di-rutag.codalm = almcmov.codalm AND
            di-rutag.tipmov = almcmov.tipmov AND
            di-rutag.codmov = almcmov.codmov AND
            di-rutag.serref = almcmov.nroser AND
            di-rutag.nroref = almcmov.nrodoc,
            FIRST di-rutac OF di-rutag NO-LOCK WHERE di-rutac.flgest <> 'A':
            ASSIGN
                t-AlmCIncidencia.Transportista = di-rutac.codpro
                t-AlmCIncidencia.Conductor = di-rutac.libre_c01
                t-AlmCIncidencia.Placa = di-rutac.codveh
                t-AlmCIncidencia.GuiaRem = DI-RutaC.GuiaTransportista
                t-AlmCIncidencia.HRuta = di-rutac.nrodoc.
            LEAVE RLOOP.
        END.
    END.
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
  FILL-IN-AlmDes = s-codalm.
  FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1.
  FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "t-AlmCIncidencia"}
  {src/adm/template/snd-list.i "AlmCIncidencia"}
  {src/adm/template/snd-list.i "Almacen"}
  {src/adm/template/snd-list.i "B-Almacen"}
  {src/adm/template/snd-list.i "PL-PERS"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE AlmCIncidencia.FlgEst:
      WHEN "P" THEN RETURN "POR APROBAR".
      WHEN "C" THEN RETURN "REGULARIZADO".
      WHEN "A" THEN RETURN "RECHAZADO".
      OTHERWISE "???".
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fIngreso B-table-Win 
FUNCTION fIngreso RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
      Almcmov.tipmov = 'I' AND
      Almcmov.codmov = 03 AND
      Almcmov.codref = "OTR" AND
      Almcmov.nroref = x-NroOTR AND
      Almcmov.flgest <> "A",
      EACH Almdmov OF Almcmov NO-LOCK WHERE Almdmov.codmat = AlmDIncidencia.CodMat:
      RETURN STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999999').
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMotivo B-table-Win 
FUNCTION fMotivo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FacTabla WHERE FacTabla.codcia = s-codcia AND
      FacTabla.tabla = 'OTRDELETE' AND
      facTabla.codigo= AlmCIncidencia.MotivoRechazo
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN RETURN FacTabla.Nombre.
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer B-table-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR pNomPer AS CHAR NO-UNDO.
RUN gn/nombre-personal (s-CodCia,
                        pCodPer,
                        OUTPUT pNomPer).

RETURN pNomPer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroOTR B-table-Win 
FUNCTION fNroOTR RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = Almcrepo.codcia AND
      Faccpedi.coddoc = 'OTR' AND
      Faccpedi.codref = 'R/A' AND
      Faccpedi.TpoPed = 'INC' AND
      Faccpedi.FlgEst <> 'A' AND 
      Faccpedi.CodOrigen = "INC" AND
      Faccpedi.NroOrigen = AlmCIncidencia.NroControl,
      EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = AlmDIncidencia.CodMat:
      RETURN Faccpedi.nroped.
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroRA B-table-Win 
FUNCTION fNroRA RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH Almcrepo NO-LOCK WHERE almcrepo.CodCia = AlmCIncidencia.CodCia AND 
      almcrepo.CodRef = "INC" AND 
      almcrepo.NroRef = AlmCIncidencia.NroControl,
      EACH Almdrepo OF Almcrepo NO-LOCK WHERE almdrepo.CodMat = AlmDIncidencia.CodMat:
      RETURN STRING(almdrepo.NroSer,'999') + STRING(almdrepo.NroDoc, '9999999').
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSalida B-table-Win 
FUNCTION fSalida RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
      Almcmov.tipmov = 'S' AND
      Almcmov.codmov = 03 AND
      Almcmov.codref = "OTR" AND
      Almcmov.nroref = x-NroOTR AND
      Almcmov.flgest <> "A",
      EACH Almdmov OF Almcmov NO-LOCK WHERE Almdmov.codmat = AlmDIncidencia.CodMat:
      RETURN STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999999').
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

