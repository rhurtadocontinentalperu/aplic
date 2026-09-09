&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CMOV FOR Almcmov.
DEFINE TEMP-TABLE REPOSICIONES NO-UNDO LIKE Almcmov
       field OT as char
       field TotCosSol as dec
       field TotCosApro as dec
       field TotCosAte as dec
       field CodRechazo as char
       Field NomRechazo as char
       Field ObsRechazo as char
       field CostoProm as dec
       field hruta as char
       field TotVolSol as dec
       field TotVolApro as dec
       field TotVolAte as dec
       field NroGuia as char
       field totpesoapro as dec
       field fecact as date
       field horact as char
       field usract as char
       field almped as char
       field prehoja as char init "No"
       field nrophr as char
       field fecha as date
       field nroped as char
       field MotReposicion like almcrepo.MotReposicion
       INDEX Llave00 AS PRIMARY CodCia CodRef NroRef.
DEFINE SHARED TEMP-TABLE T-TRACKING LIKE VtaTrack04.



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
DEFINE SHARED VARIABLE s-nivel-acceso AS INT.
/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-codalm AS CHAR.
DEFINE SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE s-user-id AS CHAR.

DEF VAR x-estado AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-Detalle
    FIELD AlmPed LIKE almcrepo.almped COLUMN-LABEL "Alm. Despacho"
    FIELD AlmacenXD AS CHAR COLUMN-LABEL "Alm. XD"
    FIELD CodAlm LIKE almcrepo.codalm COLUMN-LABEL "Alm. Destino"
    FIELD FchDoc LIKE almcrepo.fchdoc COLUMN-LABEL "Emision"
    FIELD usuario AS CHAR COLUMN-LABEL "Usuario" FORMAT 'x(15)'
    FIELD NroSer LIKE almcrepo.nroser COLUMN-LABEL "Serie"
    FIELD NroDoc LIKE almcrepo.nrodoc COLUMN-LABEL "Numero"
    FIELD Fecha  LIKE almcrepo.fecha  COLUMN-LABEL 'Entrega'
    FIELD ImpMn1 LIKE Reposiciones.ImpMn1 COLUMN-LABEL 'Lead Times (dias)'
    FIELD OT LIKE Reposiciones.nrorf1 COLUMN-LABEL 'O/T'
    FIELD NewOT LIKE Reposiciones.nrorf1 COLUMN-LABEL 'Nva O/T'
    FIELD Libre_c05 LIKE Reposiciones.Libre_c05 FORMAT 'x(20)' COLUMN-LABEL 'Estado'
    FIELD Libre_f02 LIKE Reposiciones.Libre_f02 COLUMN-LABEL 'Fecha Estado'
    FIELD TotGuias  AS INTEGER COLUMN-LABEL 'Total Guias'
    FIELD Bultos    AS INTEGER COLUMN-LABEL 'Bultos'
    FIELD TotItm    LIKE Reposiciones.TotItm COLUMN-LABEL 'Total Items'
    FIELD Libre_d01 LIKE Reposiciones.Libre_d01 COLUMN-LABEL 'Total Peso Generado (kg)'
    FIELD Totpesoapro LIKE Reposiciones.Libre_d02 COLUMN-LABEL 'Total Peso Aprobado (kg)'
    FIELD Libre_d02 LIKE Reposiciones.Libre_d02 COLUMN-LABEL 'Total Peso Atendido (kg)'
    FIELD TotCosSol LIKE Reposiciones.TotCosSol COLUMN-LABEL "Total Costo Generado S/." INIT 0
    FIELD TotCosApro LIKE Reposiciones.TotCosAte COLUMN-LABEL "Total Costo Aprobado S/." INIT 0
    FIELD TotCosAte LIKE Reposiciones.TotCosAte COLUMN-LABEL "Total Costo Atendido S/." INIT 0
    FIELD TotVolSol LIKE Reposiciones.TotVolSol COLUMN-LABEL "Total m3 Generado" INIT 0
    FIELD TotVolApro LIKE Reposiciones.TotVolAte COLUMN-LABEL "Total m3 Aprobado" INIT 0
    FIELD TotVolAte LIKE Reposiciones.TotVolAte COLUMN-LABEL "Total m3 Atendido" INIT 0
    FIELD CrossDocking AS LOG COLUMN-LABEL "Cross Docking" INIT NO FORMAT "Si/No"
    FIELD VtaPuntual LIKE almcrepo.vtapuntual COLUMN-LABEL "Urgente"
    FIELD Motivo AS CHAR FORMAT 'x(20)' COLUMN-LABEL 'Motivo'
    FIELD Glosa LIKE almcrepo.glosa COLUMN-LABEL "Observaciones"
    FIELD FchApr LIKE almcrepo.fchapr COLUMN-LABEL 'Fecha de Aprobacion'
    FIELD UsrApr LIKE almcrepo.usrapr COLUMN-LABEL "Usuario de Aprobacion"
    FIELD hruta LIKE Reposiciones.hruta COLUMN-LABEL "No. Hoja Ruta" FORMAT 'x(15)'
    FIELD codrechazo LIKE reposiciones.codrechazo COLUMN-LABEL "Cod.Rechazo"
    FIELD nomrechazo LIKE reposiciones.nomrechazo COLUMN-LABEL "Nombre Rechazo"
    FIELD obsrechazo LIKE reposiciones.obsrechazo COLUMN-LABEL "Observ.Rechazo"
    FIELD NroPHR AS CHAR COLUMN-LABEL "Nro. Pre Hoja"
    .

DEFINE TEMP-TABLE T-Detalle-Item LIKE T-Detalle
    FIELD CodMat LIKE almdrepo.codmat COLUMN-LABEL 'Codigo'
    FIELD DesMat LIKE almmmatg.desmat COLUMN-LABEL 'Descripcion'
    FIELD DesMar LIKE almmmatg.desmar COLUMN-LABEL 'Marca'
    FIELD ClfGral AS CHAR             COLUMN-LABEL 'Clf. Gral.'
    FIELD ClfUtilex AS CHAR           COLUMN-LABEL 'Clf. Utilex'
    FIELD ClfMay AS CHAR              COLUMN-LABEL 'Clf. May.'
    FIELD UndBas LIKE almmmatg.undbas COLUMN-LABEL 'Unidad'
    FIELD CodFam LIKE almmmatg.codfam COLUMN-LABEL 'Familia'
    FIELD SubFam LIKE almmmatg.subfam COLUMN-LABEL 'Subfamilia'
    FIELD CanGen LIKE almdrepo.cangen COLUMN-LABEL 'Cantidad Generada'
    FIELD CanApro LIKE almdrepo.canreq COLUMN-LABEL 'Cantidad Aprobada'
    FIELD CanAte LIKE almdrepo.canate COLUMN-LABEL 'Cantidad Atendida'
    FIELD CosRepo LIKE almmmatg.libre_d02 COLUMN-LABEL 'Costo Reposicion' INIT 0
    FIELD PesMat LIKE almmmatg.pesmat COLUMN-LABEL 'Peso (kg)'
    FIELD Volumen LIKE almmmatg.libre_d02 COLUMN-LABEL 'Volumen (m3)'
    FIELD Origen LIKE almdrepo.origen COLUMN-LABEL 'Origen'
    FIELD NroGuia AS CHAR FORMAT 'x(60)' COLUMN-LABEL 'Guia de Remision'
.

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.


DEF VAR x-TotCosSol LIKE REPOSICIONES.TotCosSol NO-UNDO.
DEF VAR x-TotCosApro LIKE REPOSICIONES.TotCosAte NO-UNDO.
DEF VAR x-TotCosAte LIKE REPOSICIONES.TotCosAte NO-UNDO.
DEF VAR x-TotVolSol LIKE REPOSICIONES.TotVolSol NO-UNDO.
DEF VAR x-TotVolApro LIKE REPOSICIONES.TotVolSol NO-UNDO.
DEF VAR x-TotVolAte LIKE REPOSICIONES.TotVolAte NO-UNDO.

DEF VAR x-TotPesoApro LIKE REPOSICIONES.TotVolAte NO-UNDO.
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-NroPHR AS CHAR NO-UNDO.

/**/

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
&Scoped-define INTERNAL-TABLES REPOSICIONES almcrepo FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table REPOSICIONES.CrossDocking ~
REPOSICIONES.AlmPed @ REPOSICIONES.AlmPed REPOSICIONES.AlmacenXD ~
REPOSICIONES.CodAlm REPOSICIONES.FchDoc REPOSICIONES.usuario ~
REPOSICIONES.CodDoc REPOSICIONES.NroSer REPOSICIONES.NroDoc ~
REPOSICIONES.Fecha @ REPOSICIONES.Fecha REPOSICIONES.ImpMn1 ~
reposiciones.ot @ reposiciones.nrorf1 REPOSICIONES.Libre_c05 ~
REPOSICIONES.Libre_f02 REPOSICIONES.cco REPOSICIONES.FlgCbd ~
REPOSICIONES.TotItm REPOSICIONES.Libre_d01 ~
REPOSICIONES.TotPesoApro @ x-TotPesoApro REPOSICIONES.Libre_d02 ~
REPOSICIONES.TotCosSol @ x-TotCosSol REPOSICIONES.TotCosApro @ x-TotCosApro ~
REPOSICIONES.TotCosAte @ x-TotCosAte REPOSICIONES.TotVolSol @ x-TotVolSol ~
REPOSICIONES.TotVolApro @ x-TotVolApro REPOSICIONES.TotVolAte @ x-TotVolAte ~
almcrepo.Glosa almcrepo.FchApr almcrepo.UsrApr ~
reposiciones.hruta @ reposiciones.nrorf2 ~
reposiciones.codrechazo @ reposiciones.libre_c01 ~
reposiciones.nomrechazo @ reposiciones.libre_c02 ~
reposiciones.obsrechazo @ reposiciones.libre_c03 almcrepo.VtaPuntual ~
fMotivo() @ x-Motivo REPOSICIONES.NroPHR @ x-NroPHR 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH REPOSICIONES WHERE ~{&KEY-PHRASE} ~
      AND (x-Estado = 'Todos' OR LOOKUP(REPOSICIONES.Libre_c05, x-Estado) > 0) ~
 AND (COMBO-BOX-PreHoja = 'Todos' OR REPOSICIONES.PreHoja = COMBO-BOX-PreHoja) NO-LOCK, ~
      FIRST almcrepo OF REPOSICIONES OUTER-JOIN NO-LOCK, ~
      FIRST FacCPedi WHERE TRUE /* Join to REPOSICIONES incomplete */ ~
      AND FacCPedi.CodCia = REPOSICIONES.codcia ~
 AND FacCPedi.CodDoc = REPOSICIONES.coddoc ~
 AND FacCPedi.NroPed = REPOSICIONES.nroped OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH REPOSICIONES WHERE ~{&KEY-PHRASE} ~
      AND (x-Estado = 'Todos' OR LOOKUP(REPOSICIONES.Libre_c05, x-Estado) > 0) ~
 AND (COMBO-BOX-PreHoja = 'Todos' OR REPOSICIONES.PreHoja = COMBO-BOX-PreHoja) NO-LOCK, ~
      FIRST almcrepo OF REPOSICIONES OUTER-JOIN NO-LOCK, ~
      FIRST FacCPedi WHERE TRUE /* Join to REPOSICIONES incomplete */ ~
      AND FacCPedi.CodCia = REPOSICIONES.codcia ~
 AND FacCPedi.CodDoc = REPOSICIONES.coddoc ~
 AND FacCPedi.NroPed = REPOSICIONES.nroped OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table REPOSICIONES almcrepo FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table REPOSICIONES
&Scoped-define SECOND-TABLE-IN-QUERY-br_table almcrepo
&Scoped-define THIRD-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-22 BUTTON-Excel FILL-IN-AlmPed ~
BUTTON-19 SELECT-FlgEst BUTTON-18 BUTTON-3 FILL-IN-CodAlm BUTTON-1 ~
RADIO-SET-Excel FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-FchEnt-1 ~
FILL-IN-FchEnt-2 COMBO-BOX-Motivo BUTTON-20 FILL-IN-NroSer FILL-IN-NroDoc ~
txtUsuario txtSerOtr txtNroOtr TOGGLE-CrossDocking FILL-IN-CodMat ~
TOGGLE-VtaPuntual COMBO-BOX-PreHoja br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-AlmPed SELECT-FlgEst ~
FILL-IN-CodAlm RADIO-SET-Excel FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 COMBO-BOX-Motivo FILL-IN-NroSer ~
FILL-IN-NroDoc txtUsuario txtSerOtr txtNroOtr TOGGLE-CrossDocking ~
FILL-IN-CodMat TOGGLE-VtaPuntual COMBO-BOX-PreHoja txtPedAtrazados ~
FILL-IN-TotPedidos FILL-IN-TotPesSol FILL-IN-TotPesAte FILL-IN-TotCosSol ~
FILL-IN-TotCosAte FILL-IN-TotGuias FILL-IN-TotBultos FILL-IN-TotItm 

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
FchDoc|y||INTEGRAL.almcrepo.FchDoc|yes
Libre_c05|||REPOSICIONES.Libre_c05|yes
TotItm|||REPOSICIONES.TotItm|no
Libre_d01|||REPOSICIONES.Libre_d01|no
Libre_d02|||REPOSICIONES.Libre_d02|no
ImpMn1|||REPOSICIONES.ImpMn1|no
UsrApr|||INTEGRAL.almcrepo.UsrApr|yes
AlmPed|||INTEGRAL.almcrepo.AlmPed|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'FchDoc,Libre_c05,TotItm,Libre_d01,Libre_d02,ImpMn1,UsrApr,AlmPed' + '",
     SortBy-Case = ':U + 'FchDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAtendido B-table-Win 
FUNCTION fAtendido RETURNS DECIMAL
      ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfGral B-table-Win 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFlgSit B-table-Win 
FUNCTION fFlgSit RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetBultos B-table-Win 
FUNCTION fGetBultos RETURNS INTEGER
  (INPUT pCoddoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMotivo B-table-Win 
FUNCTION fMotivo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNombreUsuario B-table-Win 
FUNCTION fNombreUsuario RETURNS CHARACTER
  (INPUT pCodUsuario AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion B-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-18 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-19 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BUTTON-20 
     LABEL "Tracking a Excel" 
     SIZE 15 BY 1.08.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 7" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Seleccione un motivo","Seleccione"
     DROP-DOWN-LIST
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-PreHoja AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "En Pre-Hoja" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Si","No" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmPed AS CHARACTER FORMAT "X(1000)":U 
     LABEL "Almacén Despacho" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(1000)":U 
     LABEL "Almacén Destino" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Entrega Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS INTEGER FORMAT "999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "N° Pedido Reposición" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotBultos AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotCosAte AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotCosSol AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotGuias AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotItm AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPedidos AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPesAte AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPesSol AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE txtNroOtr AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txtPedAtrazados AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txtSerOtr AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Nro OTR" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtUsuario AS CHARACTER FORMAT "X(15)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Excel AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera + Detalle", 2
     SIZE 16 BY 1.54 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.86 BY 4.85.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 7.

DEFINE VARIABLE SELECT-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "Todos","Emitido","Aprobado","Impreso","Picking","Chequeado","Documentado","En Ruta","Recepcionado","Cerrado Manualmente","Anulado","Rechazado" 
     SIZE 20 BY 6.46 TOOLTIP "Selecciona Estados" NO-UNDO.

DEFINE VARIABLE TOGGLE-CrossDocking AS LOGICAL INITIAL no 
     LABEL "Cross Docking?" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-VtaPuntual AS LOGICAL INITIAL no 
     LABEL "URGENTE" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      REPOSICIONES, 
      almcrepo, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      REPOSICIONES.CrossDocking COLUMN-LABEL "CrossDocking?" FORMAT "Sí/No":U
            WIDTH 11.43
      REPOSICIONES.AlmPed @ REPOSICIONES.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(5)":U
      REPOSICIONES.AlmacenXD COLUMN-LABEL "Almacen!XD" FORMAT "x(5)":U
      REPOSICIONES.CodAlm COLUMN-LABEL "Almacén!Destino" FORMAT "x(5)":U
      REPOSICIONES.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      REPOSICIONES.usuario COLUMN-LABEL "Usuario" FORMAT "x(15)":U
            WIDTH 10.29
      REPOSICIONES.CodDoc COLUMN-LABEL "Doc." FORMAT "x(5)":U
      REPOSICIONES.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      REPOSICIONES.NroDoc COLUMN-LABEL "Número" FORMAT "999999999":U
      REPOSICIONES.Fecha @ REPOSICIONES.Fecha COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
      REPOSICIONES.ImpMn1 COLUMN-LABEL "Lead Time!dias" FORMAT "->>>,>>9":U
      reposiciones.ot @ reposiciones.nrorf1 COLUMN-LABEL "O/T" FORMAT "x(15)":U
            WIDTH 9.86
      REPOSICIONES.Libre_c05 COLUMN-LABEL "Estado de la R/A" FORMAT "x(20)":U
            WIDTH 15.72
      REPOSICIONES.Libre_f02 COLUMN-LABEL "Fecha Estado" FORMAT "99/99/9999":U
            WIDTH 11.43
      REPOSICIONES.cco COLUMN-LABEL "Tot.Guias" FORMAT "x(7)":U
      REPOSICIONES.FlgCbd COLUMN-LABEL "Bultos" FORMAT "x(7)":U
      REPOSICIONES.TotItm COLUMN-LABEL "Total!Items" FORMAT ">>>>9":U
            WIDTH 4.72
      REPOSICIONES.Libre_d01 COLUMN-LABEL "Total Peso!Generado Kg" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.72
      REPOSICIONES.TotPesoApro @ x-TotPesoApro COLUMN-LABEL "Total Peso!Aprobado Kg" FORMAT "->>>,>>>,>>9.99":U
      REPOSICIONES.Libre_d02 COLUMN-LABEL "Total Peso!Atendido Kg" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.43
      REPOSICIONES.TotCosSol @ x-TotCosSol COLUMN-LABEL "Total Soles!Generado"
      REPOSICIONES.TotCosApro @ x-TotCosApro COLUMN-LABEL "Total Soles!Aprobado"
      REPOSICIONES.TotCosAte @ x-TotCosAte COLUMN-LABEL "Total Soles!Atendido"
      REPOSICIONES.TotVolSol @ x-TotVolSol COLUMN-LABEL "Total m3!Generado" FORMAT ">>>,>>>,>>9.99":U
      REPOSICIONES.TotVolApro @ x-TotVolApro COLUMN-LABEL "Total m3!Aprobado" FORMAT ">>>,>>>,>>9.99":U
      REPOSICIONES.TotVolAte @ x-TotVolAte COLUMN-LABEL "Total m3!Atendido" FORMAT ">>>,>>>,>>9.99":U
      almcrepo.Glosa FORMAT "x(60)":U WIDTH 16
      almcrepo.FchApr COLUMN-LABEL "Fecha de !Aprob." FORMAT "99/99/9999":U
      almcrepo.UsrApr COLUMN-LABEL "Usuario de!Aprob" FORMAT "x(8)":U
      reposiciones.hruta @ reposiciones.nrorf2 COLUMN-LABEL "H.Ruta" FORMAT "X(15)":U
            WIDTH 8.43
      reposiciones.codrechazo @ reposiciones.libre_c01 COLUMN-LABEL "Cod!Rechazo" FORMAT "x(3)":U
            WIDTH 7.14
      reposiciones.nomrechazo @ reposiciones.libre_c02 COLUMN-LABEL "Nombre Rechazo" FORMAT "x(40)":U
            WIDTH 19.86
      reposiciones.obsrechazo @ reposiciones.libre_c03 COLUMN-LABEL "Observacion Rechazo" FORMAT "x(60)":U
            WIDTH 22.14
      almcrepo.VtaPuntual COLUMN-LABEL "URGENTE" FORMAT "Si/No":U
            WIDTH 7.43
      fMotivo() @ x-Motivo COLUMN-LABEL "Motivo" FORMAT "x(20)":U
            WIDTH 20.43
      REPOSICIONES.NroPHR @ x-NroPHR COLUMN-LABEL "Nro. Pre Hoja" FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 8.35
         FONT 4 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Excel AT ROW 1.19 COL 132 WIDGET-ID 94
     FILL-IN-AlmPed AT ROW 1.27 COL 19 COLON-ALIGNED HELP
          "Separados por comas. Ejemplo: 11,10,10a,21" WIDGET-ID 14
     BUTTON-19 AT ROW 1.27 COL 75 WIDGET-ID 12
     SELECT-FlgEst AT ROW 1.27 COL 87 NO-LABEL WIDGET-ID 82
     BUTTON-18 AT ROW 1.27 COL 110 WIDGET-ID 62
     BUTTON-3 AT ROW 2.04 COL 75 WIDGET-ID 6
     FILL-IN-CodAlm AT ROW 2.08 COL 19 COLON-ALIGNED HELP
          "Separados por comas. Ejemplo: 11,10,10a,21" WIDGET-ID 4
     BUTTON-1 AT ROW 2.42 COL 110 WIDGET-ID 50
     RADIO-SET-Excel AT ROW 2.73 COL 127 NO-LABEL WIDGET-ID 96
     FILL-IN-FchDoc-1 AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchDoc-2 AT ROW 2.88 COL 43 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-FchEnt-1 AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 166
     FILL-IN-FchEnt-2 AT ROW 3.69 COL 43 COLON-ALIGNED WIDGET-ID 168
     COMBO-BOX-Motivo AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 136
     BUTTON-20 AT ROW 4.5 COL 127 WIDGET-ID 146
     FILL-IN-NroSer AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 86
     FILL-IN-NroDoc AT ROW 5.31 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     txtUsuario AT ROW 5.31 COL 43 COLON-ALIGNED WIDGET-ID 102
     txtSerOtr AT ROW 5.31 COL 63 COLON-ALIGNED WIDGET-ID 138
     txtNroOtr AT ROW 5.31 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     TOGGLE-CrossDocking AT ROW 6.12 COL 21 WIDGET-ID 164
     FILL-IN-CodMat AT ROW 6.12 COL 43 COLON-ALIGNED WIDGET-ID 88
     TOGGLE-VtaPuntual AT ROW 6.92 COL 21 WIDGET-ID 134
     COMBO-BOX-PreHoja AT ROW 6.92 COL 43 COLON-ALIGNED WIDGET-ID 188
     br_table AT ROW 8 COL 2
     txtPedAtrazados AT ROW 16.92 COL 2 NO-LABEL WIDGET-ID 142
     FILL-IN-TotPedidos AT ROW 16.92 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     FILL-IN-TotPesSol AT ROW 16.92 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     FILL-IN-TotPesAte AT ROW 16.92 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     FILL-IN-TotCosSol AT ROW 16.92 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FILL-IN-TotCosAte AT ROW 16.92 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     FILL-IN-TotGuias AT ROW 16.92 COL 94.43 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     FILL-IN-TotBultos AT ROW 16.92 COL 108.57 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     FILL-IN-TotItm AT ROW 16.92 COL 122.57 COLON-ALIGNED NO-LABEL WIDGET-ID 172
     "Total Soles Aprobado" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.35 COL 64 WIDGET-ID 124
          BGCOLOR 9 FGCOLOR 15 
     "    Total Bultos" VIEW-AS TEXT
          SIZE 13.14 BY .5 AT ROW 16.35 COL 110 WIDGET-ID 154
          BGCOLOR 9 FGCOLOR 15 
     "Total Peso Atendido" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.35 COL 48 WIDGET-ID 122
          BGCOLOR 9 FGCOLOR 15 
     "Total Soles Atendido" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.35 COL 80 WIDGET-ID 126
          BGCOLOR 9 FGCOLOR 15 
     "    Total Guias" VIEW-AS TEXT
          SIZE 13.14 BY .5 AT ROW 16.35 COL 95.86 WIDGET-ID 150
          BGCOLOR 9 FGCOLOR 15 
     "    Total Items" VIEW-AS TEXT
          SIZE 13.14 BY .5 AT ROW 16.35 COL 124 WIDGET-ID 174
          BGCOLOR 9 FGCOLOR 15 
     "Toral Peso Aprobado" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.35 COL 32 WIDGET-ID 120
          BGCOLOR 9 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Cuenta de Pedidos" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 16.35 COL 17 WIDGET-ID 118
          BGCOLOR 9 FGCOLOR 15 
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.27 COL 81 WIDGET-ID 84
     "Pedidos atrazados" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 16.35 COL 2 WIDGET-ID 144
          BGCOLOR 9 FGCOLOR 15 
     RECT-20 AT ROW 1 COL 126 WIDGET-ID 100
     RECT-22 AT ROW 1 COL 2 WIDGET-ID 170
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
      TABLE: CMOV B "?" ? INTEGRAL Almcmov
      TABLE: REPOSICIONES T "?" NO-UNDO INTEGRAL Almcmov
      ADDITIONAL-FIELDS:
          field OT as char
          field TotCosSol as dec
          field TotCosApro as dec
          field TotCosAte as dec
          field CodRechazo as char
          Field NomRechazo as char
          Field ObsRechazo as char
          field CostoProm as dec
          field hruta as char
          field TotVolSol as dec
          field TotVolApro as dec
          field TotVolAte as dec
          field NroGuia as char
          field totpesoapro as dec
          field fecact as date
          field horact as char
          field usract as char
          field almped as char
          field prehoja as char init "No"
          field nrophr as char
          field fecha as date
          field nroped as char
          field MotReposicion like almcrepo.MotReposicion
          INDEX Llave00 AS PRIMARY CodCia CodRef NroRef
      END-FIELDS.
      TABLE: T-TRACKING T "SHARED" ? INTEGRAL VtaTrack04
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
         HEIGHT             = 18.69
         WIDTH              = 143.72.
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
/* BROWSE-TAB br_table COMBO-BOX-PreHoja F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-TotBultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotCosAte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotCosSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotGuias IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotItm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPedidos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPesAte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPesSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPedAtrazados IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.REPOSICIONES,INTEGRAL.almcrepo OF Temp-Tables.REPOSICIONES,INTEGRAL.FacCPedi WHERE Temp-Tables.REPOSICIONES ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER"
     _Where[1]         = "(x-Estado = 'Todos' OR LOOKUP(REPOSICIONES.Libre_c05, x-Estado) > 0)
 AND (COMBO-BOX-PreHoja = 'Todos' OR REPOSICIONES.PreHoja = COMBO-BOX-PreHoja)"
     _Where[3]         = "INTEGRAL.FacCPedi.CodCia = REPOSICIONES.codcia
 AND INTEGRAL.FacCPedi.CodDoc = REPOSICIONES.coddoc
 AND INTEGRAL.FacCPedi.NroPed = REPOSICIONES.nroped"
     _FldNameList[1]   > Temp-Tables.REPOSICIONES.CrossDocking
"REPOSICIONES.CrossDocking" "CrossDocking?" "Sí/No" "logical" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"REPOSICIONES.AlmPed @ REPOSICIONES.AlmPed" "Almacén!Despacho" "x(5)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.REPOSICIONES.AlmacenXD
"REPOSICIONES.AlmacenXD" "Almacen!XD" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.REPOSICIONES.CodAlm
"REPOSICIONES.CodAlm" "Almacén!Destino" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.REPOSICIONES.FchDoc
"REPOSICIONES.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.REPOSICIONES.usuario
"REPOSICIONES.usuario" "Usuario" "x(15)" "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.REPOSICIONES.CodDoc
"REPOSICIONES.CodDoc" "Doc." "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.REPOSICIONES.NroSer
"REPOSICIONES.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.REPOSICIONES.NroDoc
"REPOSICIONES.NroDoc" "Número" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"REPOSICIONES.Fecha @ REPOSICIONES.Fecha" "Entrega" "99/99/9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.REPOSICIONES.ImpMn1
"REPOSICIONES.ImpMn1" "Lead Time!dias" "->>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"reposiciones.ot @ reposiciones.nrorf1" "O/T" "x(15)" ? ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.REPOSICIONES.Libre_c05
"REPOSICIONES.Libre_c05" "Estado de la R/A" "x(20)" "character" ? ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.REPOSICIONES.Libre_f02
"REPOSICIONES.Libre_f02" "Fecha Estado" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.REPOSICIONES.cco
"REPOSICIONES.cco" "Tot.Guias" "x(7)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.REPOSICIONES.FlgCbd
"REPOSICIONES.FlgCbd" "Bultos" "x(7)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.REPOSICIONES.TotItm
"REPOSICIONES.TotItm" "Total!Items" ? "integer" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.REPOSICIONES.Libre_d01
"REPOSICIONES.Libre_d01" "Total Peso!Generado Kg" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"REPOSICIONES.TotPesoApro @ x-TotPesoApro" "Total Peso!Aprobado Kg" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.REPOSICIONES.Libre_d02
"REPOSICIONES.Libre_d02" "Total Peso!Atendido Kg" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"REPOSICIONES.TotCosSol @ x-TotCosSol" "Total Soles!Generado" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"REPOSICIONES.TotCosApro @ x-TotCosApro" "Total Soles!Aprobado" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"REPOSICIONES.TotCosAte @ x-TotCosAte" "Total Soles!Atendido" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"REPOSICIONES.TotVolSol @ x-TotVolSol" "Total m3!Generado" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"REPOSICIONES.TotVolApro @ x-TotVolApro" "Total m3!Aprobado" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"REPOSICIONES.TotVolAte @ x-TotVolAte" "Total m3!Atendido" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > INTEGRAL.almcrepo.Glosa
"almcrepo.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > INTEGRAL.almcrepo.FchApr
"almcrepo.FchApr" "Fecha de !Aprob." "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > INTEGRAL.almcrepo.UsrApr
"almcrepo.UsrApr" "Usuario de!Aprob" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"reposiciones.hruta @ reposiciones.nrorf2" "H.Ruta" "X(15)" ? ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"reposiciones.codrechazo @ reposiciones.libre_c01" "Cod!Rechazo" "x(3)" ? ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"reposiciones.nomrechazo @ reposiciones.libre_c02" "Nombre Rechazo" "x(40)" ? ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"reposiciones.obsrechazo @ reposiciones.libre_c03" "Observacion Rechazo" "x(60)" ? ? ? ? ? ? ? no ? no no "22.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > INTEGRAL.almcrepo.VtaPuntual
"almcrepo.VtaPuntual" "URGENTE" "Si/No" "logical" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > "_<CALC>"
"fMotivo() @ x-Motivo" "Motivo" "x(20)" ? ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > "_<CALC>"
"REPOSICIONES.NroPHR @ x-NroPHR" "Nro. Pre Hoja" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "FchDoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchDoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_c05" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c05').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "TotItm" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'TotItm').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_d01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_d02" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d02').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "ImpMn1" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'ImpMn1').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "UsrApr" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'UsrApr').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "AlmPed" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'AlmPed').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

  IF AVAILABLE Faccpedi THEN RUN Pinta-Browse IN lh_handle (ROWID(Faccpedi), Faccpedi.coddoc).
  IF AVAILABLE Almcrepo THEN RUN Pinta-Browse IN lh_handle (ROWID(Almcrepo), "R/A").
  IF AVAILABLE REPOSICIONES THEN RUN Pinta-Tracking IN lh_handle (REPOSICIONES.codalm, REPOSICIONES.nroser, REPOSICIONES.nrodoc).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Limpiar Filtros */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      SELECT-FlgEst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos' .
      COMBO-BOX-Motivo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Seleccione'.
      ASSIGN
          FILL-IN-AlmPed = ''
          FILL-IN-CodAlm = ''
          FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
          FILL-IN-FchDoc-2 = TODAY
          SELECT-FlgEst = 'Todos'
          FILL-IN-CodMat = ''
          FILL-IN-NroDoc = 0
          FILL-IN-NroSer = 0.

      DISPLAY
          FILL-IN-AlmPed
          FILL-IN-CodAlm
          FILL-IN-FchDoc-1
          FILL-IN-FchDoc-2
          SELECT-FlgEst
          FILL-IN-CodMat
          FILL-IN-NroDoc
          FILL-IN-NroSer
          WITH FRAME {&FRAME-NAME}.

      /* Redefinimos SELECT LIST */
      DEF VAR pLista AS CHAR NO-UNDO.
      DEF VAR k AS INT NO-UNDO.

      pLista = SELECT-FlgEst:LIST-ITEMS.
      DO k = 1 TO SELECT-FlgEst:NUM-ITEMS:
          SELECT-FlgEst:DELETE(1).
      END.
      SELECT-FlgEst:LIST-ITEMS = pLista.
      SELECT-FlgEst = 'Todos'.
      DISPLAY SELECT-FlgEst.

      COMBO-BOX-Motivo = 'Seleccione'.
      DISPLAY COMBO-BOX-Motivo.


      EMPTY TEMP-TABLE REPOSICIONES.
      RUN dispatch IN THIS-PROCEDURE ('initialize':U).

      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      RUN Procesa-Handle IN lh_handle ('Open-Query':U).

      /*APPLY 'VALUE-CHANGED':U TO RADIO-SET-FlgEst.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 B-table-Win
ON CHOOSE OF BUTTON-18 IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN
      FILL-IN-AlmPed FILL-IN-CodAlm
      FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 SELECT-FlgEst 
      FILL-IN-CodMat FILL-IN-NroDoc FILL-IN-NroSer
      txtUsuario TOGGLE-VtaPuntual COMBO-BOX-Motivo txtSerOtr txtNroOtr
      .
  ASSIGN
      FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 TOGGLE-CrossDocking
      COMBO-BOX-PreHoja
      .

  IF s-user-id <> 'admin' AND FILL-IN-FchDoc-1 < ADD-INTERVAL(TODAY , -6, 'months') THEN DO:
      MESSAGE 'NO se puede solicitar información con una antiguedad mayor de 6 meses'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-FchDoc-1.
      RETURN NO-APPLY.
  END.
  x-Estado = TRIM(SELECT-FlgEst) .
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  /*RUN Totales.*/

  {&OPEN-QUERY-br_table}

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).

  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-19 B-table-Win
ON CHOOSE OF BUTTON-19 IN FRAME F-Main /* ... */
DO:
    IF s-nivel-acceso = 0 THEN DO:
        ASSIGN
            FILL-IN-CodAlm:SCREEN-VALUE = s-CodAlm
            FILL-IN-CodAlm:SENSITIVE = NO
            BUTTON-3:SENSITIVE = NO.
    END.
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-AlmPed:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 B-table-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* Tracking a Excel */
DO:
  RUN tracking-a-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    IF s-nivel-acceso = 0 THEN DO:
        ASSIGN
            FILL-IN-AlmPed:SCREEN-VALUE = s-CodAlm
            FILL-IN-AlmPed:SENSITIVE = NO
            BUTTON-19:SENSITIVE = NO.
    END.
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 7 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    ASSIGN RADIO-SET-Excel.

    /* Archivo de Salida */
    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
    DEF VAR rpta AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.

    DEFINE VAR hProc AS HANDLE NO-UNDO.
    SESSION:SET-WAIT-STATE('GENERAL').
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.
    CASE RADIO-SET-Excel:
        WHEN 1 THEN DO:
            RUN Solo-cabecera.
            /* Programas que generan el Excel */
            RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER T-Detalle:HANDLE,
                                              INPUT c-xls-file,
                                              OUTPUT c-csv-file) .
            RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER T-Detalle:handle,
                                              INPUT  c-csv-file,
                                              OUTPUT c-xls-file) .
        END.
        WHEN 2 THEN DO:
            RUN Solo-Cabecera-Detalle.
            /* Programas que generan el Excel */
            RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER T-Detalle-Item:HANDLE,
                                              INPUT c-xls-file,
                                              OUTPUT c-csv-file) .
            RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER T-Detalle-Item:handle,
                                              INPUT  c-csv-file,
                                              OUTPUT c-xls-file) .
        END.
    END CASE.
    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Motivo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Motivo IN FRAME F-Main /* Motivo */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-PreHoja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-PreHoja B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-PreHoja IN FRAME F-Main /* En Pre-Hoja */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat B-table-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Articulo */
DO:
  DEF VAR pCodMat AS CHAR NO-UNDO.
  pCodMat = SELF:SCREEN-VALUE.
  RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
  IF pCodMat = '' THEN RETURN.
  SELF:SCREEN-VALUE = pCodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchDoc-1 B-table-Win
ON LEAVE OF FILL-IN-FchDoc-1 IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchDoc-2 B-table-Win
ON LEAVE OF FILL-IN-FchDoc-2 IN FRAME F-Main /* Emitidos Hasta */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-FlgEst B-table-Win
ON VALUE-CHANGED OF SELECT-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'FchDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY almcrepo.FchDoc
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c05':U THEN DO:
      &Scope SORTBY-PHRASE BY REPOSICIONES.Libre_c05
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'TotItm':U THEN DO:
      &Scope SORTBY-PHRASE BY REPOSICIONES.TotItm DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d01':U THEN DO:
      &Scope SORTBY-PHRASE BY REPOSICIONES.Libre_d01 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d02':U THEN DO:
      &Scope SORTBY-PHRASE BY REPOSICIONES.Libre_d02 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpMn1':U THEN DO:
      &Scope SORTBY-PHRASE BY REPOSICIONES.ImpMn1 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'UsrApr':U THEN DO:
      &Scope SORTBY-PHRASE BY almcrepo.UsrApr
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'AlmPed':U THEN DO:
      &Scope SORTBY-PHRASE BY almcrepo.AlmPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Otros B-table-Win 
PROCEDURE Carga-Otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VAR lGGeneradas AS INT.
DEFINE VAR lBultos AS INT.
DEFINE VAR lNroOtr AS CHAR.

lNroOtr = "".
IF txtSerOtr > 0 OR txtNroOtr > 0  THEN DO:
    lNroOtr = STRING(txtSerotr,"999") + STRING(txtNroOtr,"999999").
END.

/* Seguimiento */
FOR EACH REPOSICIONES WHERE LOOKUP(REPOSICIONES.FlgEst, "A,R") = 0:
    /* ******************************************************************************** */
    /* SE PUEDE GENERAR MAS DE UNA ORDEN DE TRANSFERENCIA POR CADA PEDIDO DE REPOSICION */
    /* OJO: Tener cuidado con el Cross Docking                                          */
    /* ******************************************************************************** */
    lBultos = 0.
    lGGeneradas = 0.
    FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = 'OTR'
        AND faccpedi.codref = 'R/A'
        AND faccpedi.nroref = STRING (REPOSICIONES.NroSer, '999') + STRING(REPOSICIONES.NroDoc, '999999')
        AND faccpedi.flgest <> 'A'
        AND (lNroOtr = "" OR lNroOtr = faccpedi.nroped)
        AND Faccpedi.CodAlm = REPOSICIONES.AlmPed:  /* OJO >>> Por el Cross Docking */
        lBultos = lBultos + fGetBultos(INPUT faccpedi.coddoc, faccpedi.nroped).
        ASSIGN
            REPOSICIONES.flgcbd = STRING(lBultos,">>>,>>9").
        /* *********************************** */
        /* GUIAS DE REMISION POR TRANSFERENCIA */
        /* *********************************** */
        FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
            AND almcmov.codref = faccpedi.coddoc
            AND almcmov.nroref = faccpedi.nroped
            AND almcmov.tipmov = "S"
            AND (almcmov.codmov = 03 OR almcmov.codmov = 31)
            AND almcmov.flgest <> "A",
            FIRST Almdmov OF Almcmov NO-LOCK WHERE (FILL-IN-CodMat = '' OR Almdmov.codmat = FILL-IN-CodMat):
            lGGeneradas = lGGeneradas + 1.
            ASSIGN 
                REPOSICIONES.cco = STRING(lGGeneradas,">>>,>>9").
        END.
        /* ****************************************** */
        /* FIN DE GUIAS DE REMISION POR TRANSFERENCIA */
        /* ****************************************** */
    END.
END.

/* 15/12/2022: OTR por Crossdocking */
FOR EACH REPOSICIONES WHERE REPOSICIONES.coddoc = "OTR":
    lBultos = fGetBultos(INPUT REPOSICIONES.coddoc, REPOSICIONES.nroped).
    ASSIGN
        REPOSICIONES.flgcbd = STRING(lBultos,">>>,>>9").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-peso-vol-costo B-table-Win 
PROCEDURE carga-peso-vol-costo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Pesos, Costos y Volumenes */
DEFINE VAR lCantAtendido AS DEC.

FOR EACH REPOSICIONES:
    ASSIGN
        REPOSICIONES.TotItm    = 0
        REPOSICIONES.Libre_d01 = 0
        REPOSICIONES.TotVolApro = 0
        REPOSICIONES.Libre_d02 = 0
        REPOSICIONES.TotCosSol = 0
        REPOSICIONES.TotCosApro = 0
        REPOSICIONES.TotCosAte = 0
        REPOSICIONES.TotVolSol = 0
        REPOSICIONES.TotVolApro = 0
        REPOSICIONES.TotVolAte = 0.

    lCantAtendido = 0.
        
    FOR EACH almdrepo NO-LOCK WHERE almdrepo.codcia = REPOSICIONES.codcia
        AND almdrepo.codalm = REPOSICIONES.codalm
        AND almdrepo.tipmov = REPOSICIONES.tipmov
        AND almdrepo.nroser = REPOSICIONES.nroser
        AND almdrepo.nrodoc = REPOSICIONES.nrodoc,
        FIRST almcrepo OF almdrepo NO-LOCK,
        FIRST Almmmatg OF almdrepo NO-LOCK:
        FIND LAST almstkge WHERE almstkge.codcia = almmmatg.codcia 
            AND almstkge.codmat = almmmatg.codmat 
            AND almstkge.fecha <= TODAY NO-LOCK NO-ERROR.

        lCantAtendido = fAtendido(almcrepo.almped,almdrepo.codmat,'R/A',STRING(almdrepo.nroser,"999") + 
                                  STRING(almdrepo.nrodoc,"999999")).

        ASSIGN
            REPOSICIONES.TotItm    = REPOSICIONES.TotItm + 1
            REPOSICIONES.Libre_d01 = REPOSICIONES.Libre_d01 + (almdrepo.cangen * almmmatg.pesmat)
            REPOSICIONES.TotPesoApro = REPOSICIONES.TotPesoApro + (almdrepo.canapro * almmmatg.pesmat)
            REPOSICIONES.Libre_d02 = REPOSICIONES.Libre_d02 + (lCantAtendido * almmmatg.pesmat).
        /* Costos */
        IF AVAILABLE Almstkge THEN
            ASSIGN
                REPOSICIONES.TotCosSol = REPOSICIONES.TotCosSol + (almdrepo.cangen * almstkge.CtoUni)
                REPOSICIONES.TotCosApro = REPOSICIONES.TotCosApro + (almdrepo.canapro * almstkge.CtoUni)
                REPOSICIONES.TotCosAte = REPOSICIONES.TotCosAte + (lCantAtendido * almstkge.CtoUni).
        /* Volumen */
        ASSIGN
            REPOSICIONES.TotVolSol = REPOSICIONES.TotVolSol + (almdrepo.cangen * almmmatg.libre_d02 / 1000000)
            REPOSICIONES.TotVolApro = REPOSICIONES.TotVolApro + (almdrepo.canapro * almmmatg.libre_d02 / 1000000)
            REPOSICIONES.TotVolAte = REPOSICIONES.TotVolAte + (lCantAtendido * almmmatg.libre_d02 / 1000000).
    END.
    
    IF REPOSICIONES.CodDoc = "OTR" THEN DO:
        FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = REPOSICIONES.codcia
            AND Facdpedi.coddoc = REPOSICIONES.coddoc
            AND Facdpedi.nroped = REPOSICIONES.nroped,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
            FIND LAST almstkge WHERE almstkge.codcia = almmmatg.codcia 
                AND almstkge.codmat = almmmatg.codmat 
                AND almstkge.fecha <= TODAY NO-LOCK NO-ERROR.

            lCantAtendido = Facdpedi.canate.

            ASSIGN
                REPOSICIONES.TotItm    = REPOSICIONES.TotItm + 1
                REPOSICIONES.Libre_d01 = REPOSICIONES.Libre_d01 + (Facdpedi.canped * almmmatg.pesmat)
                REPOSICIONES.TotPesoApro = REPOSICIONES.TotPesoApro + (Facdpedi.canped * almmmatg.pesmat)
                REPOSICIONES.Libre_d02 = REPOSICIONES.Libre_d02 + (lCantAtendido * almmmatg.pesmat).
            /* Costos */
            IF AVAILABLE Almstkge THEN
                ASSIGN
                    REPOSICIONES.TotCosSol = REPOSICIONES.TotCosSol + (Facdpedi.canped * almstkge.CtoUni)
                    REPOSICIONES.TotCosApro = REPOSICIONES.TotCosApro + (Facdpedi.canped * almstkge.CtoUni)
                    REPOSICIONES.TotCosAte = REPOSICIONES.TotCosAte + (lCantAtendido * almstkge.CtoUni).
            /* Volumen */
            ASSIGN
                REPOSICIONES.TotVolSol = REPOSICIONES.TotVolSol + (Facdpedi.canped * almmmatg.libre_d02 / 1000000)
                REPOSICIONES.TotVolApro = REPOSICIONES.TotVolApro + (Facdpedi.canped * almmmatg.libre_d02 / 1000000)
                REPOSICIONES.TotVolAte = REPOSICIONES.TotVolAte + (lCantAtendido * almmmatg.libre_d02 / 1000000).
        END.

    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
DEF VAR xNroSer LIKE almcrepo.nroser NO-UNDO.
DEF VAR xNroDoc LIKE almcrepo.nrodoc NO-UNDO.

DEFINE VAR cFiler1 AS CHAR.

DEFINE VAR x-Por-FchEnt AS LOG NO-UNDO.

EMPTY TEMP-TABLE REPOSICIONES.
EMPTY TEMP-TABLE T-TRACKING.

DEFINE VAR lNroOtr AS CHAR.

lNroOtr = "".
IF txtSerOtr > 0 OR txtNroOtr > 0  THEN DO:
    lNroOtr = STRING(txtSerotr,"999") + STRING(txtNroOtr,"999999").
END.

/* DEF BUFFER ORDEN FOR Faccpedi.  /* Buffer para repetir la R/A si tiene mas de una OTR */ */
FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
        AND (FILL-IN-CodAlm = '' OR LOOKUP(almacen.codalm, FILL-IN-CodAlm) > 0),
    EACH almcrepo NO-LOCK WHERE almcrepo.codcia = s-codcia
        AND almcrepo.codalm = almacen.codalm
        AND (almcrepo.tipmov = "A" OR almcrepo.tipmov = "M")
        AND (FILL-IN-AlmPed = '' OR LOOKUP(almcrepo.almped, FILL-IN-AlmPed) > 0)
        AND (almcrepo.FchDoc >= FILL-IN-FchDoc-1 AND almcrepo.FchDoc <= FILL-IN-FchDoc-2)
        AND (FILL-IN-NroSer = 0 OR almcrepo.nroser = FILL-IN-NroSer)
        AND (FILL-IN-NroDoc = 0 OR almcrepo.nrodoc = FILL-IN-NroDoc):
    IF NOT (txtUsuario = '' OR almcrepo.usuario = txtUsuario) THEN NEXT.
    IF NOT (COMBO-BOX-Motivo = 'Seleccione' OR almcrepo.MotReposicion = COMBO-BOX-Motivo) THEN NEXT.
    /* En caso de filtro por OTR */
/*     IF lNroOtr > '' THEN DO:                                                                          */
/*         FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia                                          */
/*             AND faccpedi.coddoc = 'OTR'                                                               */
/*             AND faccpedi.codref = 'R/A'                                                               */
/*             AND faccpedi.nroref = STRING (Almcrepo.NroSer, '999') + STRING(Almcrepo.NroDoc, '999999') */
/*             AND faccpedi.flgest <> 'A'                                                                */
/*             AND faccpedi.nroped = lNroOtr                                                             */
/*             NO-LOCK NO-ERROR.                                                                         */
/*         IF NOT AVAILABLE Faccpedi THEN NEXT.                                                          */
/*     END.                                                                                              */
    /* En caso de fecha de entrega */
    IF FILL-IN-FchEnt-1 <> ? OR FILL-IN-FchEnt-2 <> ? THEN DO:
        x-Por-FchEnt = NO.
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = 'OTR'
            AND Faccpedi.codref = 'R/A'
            AND Faccpedi.nroref = STRING(Almcrepo.nroser,'999') + STRING(Almcrepo.nrodoc,'999999')
            AND Faccpedi.flgest <> 'A':
            IF FILL-IN-FchEnt-1 <> ? AND FacCPedi.FchEnt < FILL-IN-FchEnt-1 THEN NEXT.
            IF FILL-IN-FchEnt-2 <> ? AND FacCPedi.FchEnt > FILL-IN-FchEnt-2 THEN NEXT.
            x-Por-FchEnt = YES.
            LEAVE.
        END.
        IF x-Por-FchEnt = NO THEN NEXT.
    END.
    /* En caso de Cross Docking */
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'OTR'
        AND Faccpedi.codref = 'R/A'
        AND Faccpedi.nroref = STRING(Almcrepo.nroser,'999') + STRING(Almcrepo.nrodoc,'999999')
        AND Faccpedi.flgest <> 'A'
        AND Faccpedi.crossdocking = YES
        NO-LOCK NO-ERROR.
    IF TOGGLE-CrossDocking = YES THEN DO:
        IF NOT AVAILABLE Faccpedi THEN NEXT.
    END.
    IF x-Estado = 'Rechazado' AND almcrepo.flgest <> 'R' THEN NEXT.
    IF TOGGLE-VtaPuntual = YES AND almcrepo.VtaPuntual = NO THEN NEXT.

    CREATE REPOSICIONES.
    BUFFER-COPY almcrepo TO REPOSICIONES
        ASSIGN
        REPOSICIONES.CodDoc = "R/A"
        REPOSICIONES.AlmPed = almcrepo.almped
        REPOSICIONES.Libre_f01 = almcrepo.fchapr
        REPOSICIONES.Libre_c01 = almcrepo.usrapr
        REPOSICIONES.usuario = almcrepo.usuario
        REPOSICIONES.libre_c05 = almcrepo.hora
        REPOSICIONES.libre_c04 = almcrepo.horapr
        REPOSICIONES.codven = ""    /* OTR a filtrar */
        REPOSICIONES.cco = ""    /* Guias generadas */
        REPOSICIONES.flgcbd = ""    /* Bultos */
        REPOSICIONES.codrechazo = ""
        REPOSICIONES.nomrechazo = ""
        REPOSICIONES.obsrechazo = "".
    IF AVAILABLE Faccpedi THEN
        ASSIGN 
            REPOSICIONES.CrossDocking = YES 
            REPOSICIONES.AlmacenXD = Faccpedi.CodCli.
    /* Rechazos */
    IF almcrepo.libre_c02 <> ? THEN DO:
        IF NUM-ENTRIES(almcrepo.libre_c02,"|") > 1 THEN DO:
            cFiler1 = ENTRY(1,almcrepo.libre_c02,"|").
            ASSIGN REPOSICIONES.codrechazo = cFiler1
                    REPOSICIONES.obsrechazo = ENTRY(2,almcrepo.libre_c02,"|").
            FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                        factabla.tabla = 'OTRDELETE' AND 
                                        factabla.codigo = cFiler1
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE factabla THEN DO:
                ASSIGN REPOSICIONES.nomrechazo = factabla.nombre.
            END.
        END.
    END.
END.
/* ************************************************ */
/* 15/12/2022: Incluir los CrossDocking por Compras */
/* ************************************************ */
FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
        AND (FILL-IN-CodAlm = '' OR LOOKUP(almacen.codalm, FILL-IN-CodAlm) > 0),
    EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.codcli = almacen.codalm
        AND Faccpedi.coddoc = "OTR"
        AND Faccpedi.codref = "OPEN"
        AND (Faccpedi.FchPed >= FILL-IN-FchDoc-1 AND Faccpedi.FchPed <= FILL-IN-FchDoc-2)
        AND Faccpedi.flgest <> "A" 
        AND (TRUE <> (FILL-IN-AlmPed > '') OR LOOKUP(Faccpedi.codalm, FILL-IN-AlmPed) > 0):
    IF NOT (TRUE <> (txtUsuario > '') OR Faccpedi.usuario = txtUsuario) THEN NEXT.
    CREATE REPOSICIONES.
    BUFFER-COPY Faccpedi TO REPOSICIONES
        ASSIGN
        REPOSICIONES.CodDoc    = Faccpedi.CodDoc
        REPOSICIONES.NroSer    = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
        REPOSICIONES.NroDoc    = INTEGER(SUBSTRING(Faccpedi.nroref,4))
        REPOSICIONES.OT        = Faccpedi.NroPed
        REPOSICIONES.FchDoc    = Faccpedi.fchped
        REPOSICIONES.AlmPed    = Faccpedi.codalm
        REPOSICIONES.CodAlm    = Faccpedi.codcli
        REPOSICIONES.Libre_f01 = DATE(ENTRY(1,ENTRY(2,Faccpedi.Libre_c01,'|'),' '))
        REPOSICIONES.Libre_c01 = ENTRY(1,Faccpedi.Libre_c01,'|')
        REPOSICIONES.usuario   = Faccpedi.usuario
        REPOSICIONES.libre_c05 = "Aprobado"
        REPOSICIONES.libre_c04 =  ENTRY(2,ENTRY(2,Faccpedi.Libre_c01,'|'),' ')
        REPOSICIONES.codven    = ""    /* OTR a filtrar */
        REPOSICIONES.cco       = ""    /* Guias generadas */
        REPOSICIONES.flgcbd    = ""    /* Bultos */
        REPOSICIONES.codrechazo = ""
        REPOSICIONES.nomrechazo = ""
        REPOSICIONES.obsrechazo = ""
        REPOSICIONES.fecha      = faccpedi.fchent.
END.
/* ************************************************ */
/* 01/02/2023: Aplicar filtros finales */
/* ************************************************ */
FOR EACH REPOSICIONES EXCLUSIVE-LOCK:
    /* Filtro por código de artículo */
    IF FILL-IN-CodMat > '' THEN DO:
        FIND FIRST Almcrepo WHERE almcrepo.CodCia = REPOSICIONES.codcia AND
            almcrepo.CodAlm = REPOSICIONES.codalm AND
            almcrepo.TipMov = REPOSICIONES.tipmov AND
            almcrepo.NroSer = REPOSICIONES.nroser AND 
            almcrepo.NroDoc = REPOSICIONES.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE almcrepo AND NOT CAN-FIND(FIRST Almdrepo OF Almcrepo 
                                               WHERE Almdrepo.codmat = FILL-IN-CodMat NO-LOCK)
            THEN DO:
            DELETE REPOSICIONES.
            NEXT.
        END.
        FIND FIRST Faccpedi WHERE FacCPedi.CodCia = REPOSICIONES.codcia AND
            FacCPedi.CodDoc = REPOSICIONES.coddoc AND
            FacCPedi.NroPed = REPOSICIONES.ot
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi AND NOT CAN-FIND(FIRST Facdpedi OF Faccpedi
                                               WHERE Facdpedi.codmat = FILL-IN-CodMat NO-LOCK)
            THEN DO:
            DELETE REPOSICIONES.
            NEXT.
        END.
    END.
    /* Por # R/A */
    IF FILL-IN-NroSer > 0 AND REPOSICIONES.nroser <> FILL-IN-NroSer THEN DO:
        DELETE REPOSICIONES.
        NEXT.
    END.
    IF FILL-IN-NroDoc > 0 AND REPOSICIONES.nrodoc <> FILL-IN-NroDoc THEN DO:
        DELETE REPOSICIONES.
        NEXT.
    END.
    /* Por Motivo */
    IF NOT (COMBO-BOX-Motivo = 'Seleccione' OR REPOSICIONES.MotReposicion = COMBO-BOX-Motivo) THEN DO:
        DELETE REPOSICIONES.
        NEXT.
    END.
END.
/* ************************************************ */

/**/
RUN carga-peso-vol-costo.
RUN Carga-Tracking.
RUN Carga-Otros.

FOR EACH REPOSICIONES:
    /* Por # OTR */
    IF lNroOtr > '' THEN DO:
        IF REPOSICIONES.ot <> lNroOtr THEN DO:
            DELETE REPOSICIONES.
            NEXT.
        END.
    END.
END.

DEFINE VAR cEstados AS CHAR NO-UNDO.

cEstados = SELECT-FlgEst.
FOR EACH REPOSICIONES:
    REPOSICIONES.ImpMn1 = TODAY - REPOSICIONES.FchDoc. /* Correo Max Ramos 16Dic2016 */
    /* Ic - Correo Max Ramos, 20Dic2016 */
    REPOSICIONES.ImpMn1 = 0.
    IF LOOKUP(REPOSICIONES.Libre_c05,cEstados) > 0 THEN REPOSICIONES.ImpMn1 = TODAY - REPOSICIONES.FchDoc.
END.
/* RHC 20/04/2017 Igualar de horas */
FOR EACH T-TRACKING:
    T-TRACKING.libre_c04 = TRIM(T-TRACKING.libre_c04).
    IF LENGTH(T-TRACKING.libre_c04) = 5 THEN T-TRACKING.libre_c04 = T-TRACKING.libre_c04 + ":00".
    T-TRACKING.libre_c04 = SUBSTRING(T-TRACKING.libre_c04,1,8).
END.
DEF VAR x-Orden AS INT NO-UNDO.
x-Orden = 1.
FOR EACH T-TRACKING BY DATE(T-TRACKING.FechaI) BY T-TRACKING.Libre_c04:
    T-TRACKING.coddiv = STRING(x-Orden, '999999').
    x-Orden = x-Orden + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tracking B-table-Win 
PROCEDURE Carga-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DEFINE VAR lGGeneradas AS INT. */
/* DEFINE VAR lBultos AS INT.     */
DEFINE VAR lNroOtr AS CHAR.

DEFINE VAR x-almdes AS CHAR.

lNroOtr = "".
IF txtSerOtr > 0 OR txtNroOtr > 0  THEN DO:
    lNroOtr = STRING(txtSerotr,"999") + STRING(txtNroOtr,"999999").
END.

/* Seguimiento */
FOR EACH REPOSICIONES:
    /* FILTROS */
    IF REPOSICIONES.flgest = "A" THEN DO:
        REPOSICIONES.Libre_c05 = "Anulado".
        CREATE T-TRACKING.
        ASSIGN
            T-TRACKING.CodCia = s-codcia
            T-TRACKING.CodAlm = REPOSICIONES.codalm
            T-TRACKING.CodDoc = "R/A"
            T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
            T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
            T-TRACKING.FechaI = REPOSICIONES.FecAct
            T-TRACKING.usuario= REPOSICIONES.UsrAct
            T-TRACKING.Libre_c01 = "Anulación"
            T-TRACKING.Libre_c04 = REPOSICIONES.HorAct
            T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.UsrAct).
        NEXT.
    END.

    /* 15/12/2022: Dos casos R/A y OTR */

    CASE REPOSICIONES.CodDoc:
        WHEN "OTR" THEN DO:
            RUN Carga-Tracking-OTR.
        END.
        OTHERWISE DO:
            RUN Carga-Tracking-RA.
        END.
    END CASE.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tracking-OTR B-table-Win 
PROCEDURE Carga-Tracking-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-almdes AS CHAR.

FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddoc = REPOSICIONES.coddoc AND
    Faccpedi.nroped = REPOSICIONES.nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

CREATE T-TRACKING.
ASSIGN
    T-TRACKING.CodCia = s-codcia
    T-TRACKING.CodAlm = REPOSICIONES.codalm
    T-TRACKING.CodDoc = REPOSICIONES.CodDoc
    T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
    T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
    T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
    T-TRACKING.FechaI = faccpedi.fchped
    T-TRACKING.usuario= faccpedi.usuario
    T-TRACKING.Libre_c01 = "Generación de la Orden de Transferencia"
    T-TRACKING.Libre_c05 = fNombreUsuario(faccpedi.usuario)
    T-TRACKING.Libre_c04 = SUBSTRING(ENTRY(2,faccpedi.libre_c01,"|"),12) NO-ERROR.            
ASSIGN
    REPOSICIONES.Libre_f02 = T-TRACKING.FechaI
    REPOSICIONES.OT = faccpedi.nroped
    /*REPOSICIONES.codven = lNroOtr*/
    .
/* RHC 18/01/2016 Cerrado Manualmente */
IF Faccpedi.FlgEst = "E" THEN DO:
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
        T-TRACKING.FechaI = FacCPedi.Libre_f01
        T-TRACKING.usuario= FacCPedi.UsrChq
        T-TRACKING.Libre_c01 = "Orden Cerrada Manualmente"
        T-TRACKING.Libre_c05 = fNombreUsuario(FacCPedi.UsrChq)
        T-TRACKING.Libre_c04 = "".
    ASSIGN
        REPOSICIONES.Libre_c05 = "Cerrado Manualmente"
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
    RETURN.
END.
/* RHC 29/08/2016 Impreso */
IF faccpedi.flgimpod = YES THEN DO:
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
        T-TRACKING.FechaI = faccpedi.fchimpod 
        T-TRACKING.usuario= faccpedi.usrimpod
        T-TRACKING.Libre_c01 = "Impresión Orden de Transferencia"
        T-TRACKING.Libre_c05 = fNombreUsuario(faccpedi.usrimpod)
        T-TRACKING.libre_c04= SUBSTRING(STRING(FacCPedi.FchImpOD),12,8)
        NO-ERROR.
    ASSIGN                  
        REPOSICIONES.Libre_c05 = "Impreso"
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
END.

/* Ic - 24Ene2017, sacado de subordenes */
RUN picking-sacadores.
/* Ic - 24Ene2017, sacado de subordenes - FIN */

/* Chequeo - Barras */
IF faccpedi.flgsit = "C" THEN DO:
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
        T-TRACKING.FechaI = FacCPedi.FchChq
        T-TRACKING.usuario= FacCPedi.UsrChq
        T-TRACKING.Libre_c01 = "Chequeo Orden de Transferencia"
        T-TRACKING.Libre_c05 = fNombreUsuario(FacCPedi.UsrChq)
        T-TRACKING.libre_c04 = SUBSTRING(FacCPedi.HorChq,1,8).
    ASSIGN
        REPOSICIONES.Libre_c05 = "Chequeado"
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
END.

/* *********************************** */
/* GUIAS DE REMISION POR TRANSFERENCIA */
/* *********************************** */
FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
    AND almcmov.codref = faccpedi.coddoc
    AND almcmov.nroref = faccpedi.nroped
    AND almcmov.tipmov = "S"
    AND (almcmov.codmov = 03 OR almcmov.codmov = 31)
    AND almcmov.flgest <> "A",
    FIRST Almdmov OF Almcmov NO-LOCK WHERE (FILL-IN-CodMat = '' OR Almdmov.codmat = FILL-IN-CodMat):
    ASSIGN 
        REPOSICIONES.Libre_c05 = "Documentado"
        REPOSICIONES.Libre_f02 = Almcmov.fchdoc
        /*REPOSICIONES.cco = STRING(lGGeneradas,">>>,>>9")*/
        .
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = "G/R: " + STRING(almcmov.nroser,'999') + '-' + STRING(almcmov.nrodoc, '9999999')
        T-TRACKING.FechaI = almcmov.fchdoc
        T-TRACKING.usuario= almcmov.usuario
        T-TRACKING.Libre_c01 = "Generación Guia de Remisión"
        T-TRACKING.Libre_c05 = fNombreUsuario(almcmov.usuario)
        T-TRACKING.Libre_c04 = SUBSTRING(almcmov.hradoc,1,8).
    /* ************ */
    /* HOJA DE RUTA */
    /* ************ */
    FOR EACH di-rutag NO-LOCK WHERE di-rutag.codcia = s-codcia
        AND di-rutag.coddoc = 'H/R'
        AND di-rutag.codalm = almcmov.codalm
        AND di-rutag.tipmov = almcmov.tipmov
        AND di-rutag.codmov = almcmov.codmov
        AND di-rutag.serref = almcmov.nroser
        AND di-rutag.nroref = almcmov.nrodoc,
        FIRST di-rutac OF di-rutag NO-LOCK WHERE di-rutac.flgest <> "A"
        BREAK BY di-rutag.nrodoc:
        IF FIRST-OF(di-rutag.nrodoc) THEN DO:
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = REPOSICIONES.CodDoc
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = "H/R: " + DI-RutaC.NroDoc
                T-TRACKING.FechaI = DI-RutaC.FchDoc
                T-TRACKING.usuario= DI-RutaC.usuario
                T-TRACKING.Libre_c05 = fNombreUsuario(DI-RutaC.usuario)
                T-TRACKING.Libre_c01 = "G/R " + STRING(almcmov.nroser) + '-' +
                STRING(almcmov.nrodoc, '999999') + " en Hoja de Ruta"
                T-TRACKING.Libre_c04 = STRING(DI-RutaC.HorSal,"99:99:99").
            ASSIGN
                REPOSICIONES.Libre_f02 = T-TRACKING.FechaI
                REPOSICIONES.HRUTA = DI-RutaC.NroDoc.
            REPOSICIONES.Libre_c05 = "En Ruta".
        END.
    END.
    /* **************** */
    /* FIN HOJA DE RUTA */
    /* **************** */
    /* GUIA DE REMISION RECEPCIONADA */
    IF almcmov.flgsit = "R" THEN DO:
        ASSIGN REPOSICIONES.Libre_c05 = "Recepcionado"

        x-almdes = almcmov.almdes.
        IF REPOSICIONES.CrossDocking = YES THEN x-almdes = x-almdes + "xD".

        FIND FIRST CMOV WHERE CMOV.codcia = s-codcia
            AND CMOV.codalm = x-almdes /*almcmov.almdes*/
            AND CMOV.tipmov = 'I'
            AND (CMOV.codmov = 03 OR CMOV.codmov = 32)
            AND CMOV.nroser = 000
            AND CMOV.nrodoc = INTEGER(almcmov.nrorf2)
            AND CMOV.flgest <> "A"
            NO-LOCK NO-ERROR.
        IF AVAILABLE CMOV THEN DO:
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = REPOSICIONES.CodDoc
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = "G/R: " + STRING(almcmov.nroser,'999') + '-' + STRING(almcmov.nrodoc, '9999999')
                T-TRACKING.Libre_c01 = "Guía de Remisión Recepcionada"
                T-TRACKING.libre_c04 = SUBSTRING(almcmov.horrcp,1,8).

            ASSIGN
                T-TRACKING.FechaI = CMOV.FchDoc
                T-TRACKING.usuario= CMOV.usuario
                T-TRACKING.Libre_c05 = fNombreUsuario(CMOV.usuario)
                REPOSICIONES.Libre_c05 = "Recepcionado"
                REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.                        
        END.
    END.
END.
/* ****************************************** */
/* FIN DE GUIAS DE REMISION POR TRANSFERENCIA */
/* ****************************************** */
/* PRE HOJA DE RUTA */
FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-codcia
    AND DI-RutaD.CodDoc = "PHR"
    AND DI-RutaD.CodRef = Faccpedi.coddoc
    AND DI-RutaD.NroRef = Faccpedi.nroped
    AND CAN-FIND(FIRST Di-RutaC OF Di-RutaD WHERE Di-RutaC.FlgEst <> "A" NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE Di-RutaD THEN 
    ASSIGN 
    REPOSICIONES.PreHoja = "Si" 
    REPOSICIONES.NroPHR = DI-RutaD.NroDoc.

/* CERRADO MANUALMENTE */
IF REPOSICIONES.flgest = "M" THEN DO:
    REPOSICIONES.Libre_c05 = "Cerrado Manualmente".
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.FechaI = REPOSICIONES.Libre_f01
        T-TRACKING.usuario= REPOSICIONES.Libre_c01
        T-TRACKING.Libre_c01 = "Cierre Manual del Pedido de Reposición"
        T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.Libre_c01)
        T-TRACKING.libre_c04 = "".
    ASSIGN
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tracking-RA B-table-Win 
PROCEDURE Carga-Tracking-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lNroOtr AS CHAR.
DEFINE VAR x-almdes AS CHAR.

    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = "R/A"
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.FechaI = REPOSICIONES.FchDoc
        T-TRACKING.usuario= REPOSICIONES.usuario
        T-TRACKING.Libre_c01 = "Generación de Pedido de Reposición"
        T-TRACKING.Libre_c04 = reposiciones.libre_c05 /* Hora */
        T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.usuario).

    ASSIGN
        REPOSICIONES.Libre_c05 = "Emitido"
        REPOSICIONES.Libre_f02 = REPOSICIONES.FchDoc.

    IF REPOSICIONES.flgest = "R" THEN DO:
        CREATE T-TRACKING.
        ASSIGN
            T-TRACKING.CodCia = s-codcia
            T-TRACKING.CodAlm = REPOSICIONES.codalm
            T-TRACKING.CodDoc = "R/A"
            T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
            T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
            T-TRACKING.FechaI = REPOSICIONES.Libre_f01
            T-TRACKING.usuario= REPOSICIONES.Libre_c01
            T-TRACKING.Libre_c01 = "Rechazo del Pedido de Reposición"
            T-TRACKING.Libre_c04 = reposiciones.libre_c04 /* Hora aproba */
            T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.libre_c01).
        ASSIGN
            REPOSICIONES.Libre_c05 = "Rechazado"
            REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
        NEXT.
    END.

    IF REPOSICIONES.FlgSit = "G" THEN NEXT.     /* Emitido */

    /* FIN DE FILTROS */
    IF REPOSICIONES.FlgEst = "C" THEN DO:
        CREATE T-TRACKING.
        ASSIGN
            T-TRACKING.CodCia = s-codcia
            T-TRACKING.CodAlm = REPOSICIONES.codalm
            T-TRACKING.CodDoc = "R/A"
            T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
            T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
            T-TRACKING.FechaI = REPOSICIONES.Libre_f01
            T-TRACKING.usuario= REPOSICIONES.Libre_c01
            T-TRACKING.Libre_c01 = "Aprobación del Pedido de Reposición"
            T-TRACKING.Libre_c04 = reposiciones.libre_c04 /* Hora aproba */
            T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.libre_c01).
        ASSIGN
            REPOSICIONES.Libre_c05 = "Aprobado"
            REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
    END.
    /* ******************************************************************************** */
    /* SE PUEDE GENERAR MAS DE UNA ORDEN DE TRANSFERENCIA POR CADA PEDIDO DE REPOSICION */
    /* ******************************************************************************** */
/*     lGGeneradas = 0. */
/*     lBultos = 0.     */

    FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = 'OTR'
        AND faccpedi.codref = 'R/A'
        AND faccpedi.nroref = STRING (REPOSICIONES.NroSer, '999') + STRING(REPOSICIONES.NroDoc, '999999')
        AND faccpedi.flgest <> 'A'
        AND (lNroOtr = "" OR lNroOtr = faccpedi.nroped),
        FIRST Facdpedi OF Faccpedi NO-LOCK:
        CREATE T-TRACKING.
        ASSIGN
            T-TRACKING.CodCia = s-codcia
            T-TRACKING.CodAlm = REPOSICIONES.codalm
            T-TRACKING.CodDoc = "R/A"
            T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
            T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
            T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
            T-TRACKING.FechaI = faccpedi.fchped
            T-TRACKING.usuario= faccpedi.usuario
            T-TRACKING.Libre_c01 = "Generación de la Orden de Transferencia"
            T-TRACKING.Libre_c05 = fNombreUsuario(faccpedi.usuario)
            T-TRACKING.Libre_c04 = SUBSTRING(ENTRY(2,faccpedi.libre_c01,"|"),12) NO-ERROR.            

        /*lBultos = lBultos + fGetBultos(INPUT faccpedi.coddoc, faccpedi.nroped).*/

        ASSIGN
            REPOSICIONES.Libre_f02 = T-TRACKING.FechaI
            REPOSICIONES.OT = faccpedi.nroped
            REPOSICIONES.codven = lNroOtr
            /*REPOSICIONES.flgcbd = STRING(lBultos,">>>,>>9")*/
            .

        /* RHC 18/01/2016 Cerrado Manualmente */
        IF Faccpedi.FlgEst = "E" THEN DO:
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = "R/A"
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
                T-TRACKING.FechaI = FacCPedi.Libre_f01
                T-TRACKING.usuario= FacCPedi.UsrChq
                T-TRACKING.Libre_c01 = "Orden Cerrada Manualmente"
                T-TRACKING.Libre_c05 = fNombreUsuario(FacCPedi.UsrChq)
                T-TRACKING.Libre_c04 = "".
            ASSIGN
                REPOSICIONES.Libre_c05 = "Cerrado Manualmente"
                REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
            NEXT.
        END.
        /* ********************************** */
        /* RHC 29/08/2016 Impreso */
        IF faccpedi.flgimpod = YES THEN DO:
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = "R/A"
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
                T-TRACKING.FechaI = faccpedi.fchimpod 
                T-TRACKING.usuario= faccpedi.usrimpod
                T-TRACKING.Libre_c01 = "Impresión Orden de Transferencia"
                T-TRACKING.Libre_c05 = fNombreUsuario(faccpedi.usrimpod)
                T-TRACKING.libre_c04= SUBSTRING(STRING(FacCPedi.FchImpOD),12,8)
                NO-ERROR.
            ASSIGN                  
                REPOSICIONES.Libre_c05 = "Impreso"
                REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
        END.

        /* Ic - 24Ene2017, sacado de subordenes */
        RUN picking-sacadores.
        /* Ic - 24Ene2017, sacado de subordenes - FIN */

        /* Chequeo - Barras */
        IF faccpedi.flgsit = "C" THEN DO:
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = "R/A"
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
                T-TRACKING.FechaI = FacCPedi.FchChq
                T-TRACKING.usuario= FacCPedi.UsrChq
                T-TRACKING.Libre_c01 = "Chequeo Orden de Transferencia"
                T-TRACKING.Libre_c05 = fNombreUsuario(FacCPedi.UsrChq)
                T-TRACKING.libre_c04 = FacCPedi.HorChq.
            ASSIGN
                REPOSICIONES.Libre_c05 = "Chequeado"
                REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
        END.
        /* *********************************** */
        /* GUIAS DE REMISION POR TRANSFERENCIA */
        /* *********************************** */
        FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
            AND almcmov.codref = faccpedi.coddoc
            AND almcmov.nroref = faccpedi.nroped
            AND almcmov.tipmov = "S"
            AND (almcmov.codmov = 03 OR almcmov.codmov = 31)
            AND almcmov.flgest <> "A",
            FIRST Almdmov OF Almcmov NO-LOCK WHERE (FILL-IN-CodMat = '' OR Almdmov.codmat = FILL-IN-CodMat):

            /*lGGeneradas = lGGeneradas + 1.*/

            ASSIGN 
                REPOSICIONES.Libre_c05 = "Documentado"
                REPOSICIONES.Libre_f02 = Almcmov.fchdoc
                /*REPOSICIONES.cco = STRING(lGGeneradas,">>>,>>9")*/
                .
            CREATE T-TRACKING.
            ASSIGN
                T-TRACKING.CodCia = s-codcia
                T-TRACKING.CodAlm = REPOSICIONES.codalm
                T-TRACKING.CodDoc = "R/A"
                T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                T-TRACKING.NroPed = "G/R: " + STRING(almcmov.nroser,'999') + '-' + STRING(almcmov.nrodoc, '9999999')
                T-TRACKING.FechaI = almcmov.fchdoc
                T-TRACKING.usuario= almcmov.usuario
                T-TRACKING.Libre_c01 = "Generación Guia de Remisión"
                T-TRACKING.Libre_c05 = fNombreUsuario(almcmov.usuario)
                T-TRACKING.Libre_c04 = almcmov.hradoc.
            /* ************ */
            /* HOJA DE RUTA */
            /* ************ */
            FOR EACH di-rutag NO-LOCK WHERE di-rutag.codcia = s-codcia
                AND di-rutag.coddoc = 'H/R'
                AND di-rutag.codalm = almcmov.codalm
                AND di-rutag.tipmov = almcmov.tipmov
                AND di-rutag.codmov = almcmov.codmov
                AND di-rutag.serref = almcmov.nroser
                AND di-rutag.nroref = almcmov.nrodoc,
                FIRST di-rutac OF di-rutag NO-LOCK WHERE di-rutac.flgest <> "A"
                BREAK BY di-rutag.nrodoc:
                IF FIRST-OF(di-rutag.nrodoc) THEN DO:
                    CREATE T-TRACKING.
                    ASSIGN
                        T-TRACKING.CodCia = s-codcia
                        T-TRACKING.CodAlm = REPOSICIONES.codalm
                        T-TRACKING.CodDoc = "R/A"
                        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                        T-TRACKING.NroPed = "H/R: " + DI-RutaC.NroDoc
                        T-TRACKING.FechaI = DI-RutaC.FchDoc
                        T-TRACKING.usuario= DI-RutaC.usuario
                        T-TRACKING.Libre_c05 = fNombreUsuario(DI-RutaC.usuario)
                        T-TRACKING.Libre_c01 = "G/R " + STRING(almcmov.nroser) + '-' +
                        STRING(almcmov.nrodoc, '999999') + " en Hoja de Ruta"
                        T-TRACKING.Libre_c04 = STRING(DI-RutaC.HorSal,"99:99").
                    ASSIGN
                        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI
                        REPOSICIONES.HRUTA = DI-RutaC.NroDoc.
                    REPOSICIONES.Libre_c05 = "En Ruta".
                END.
            END.
            /* **************** */
            /* FIN HOJA DE RUTA */
            /* **************** */
            /* GUIA DE REMISION RECEPCIONADA */
            IF almcmov.flgsit = "R" THEN DO:
                /*
                CREATE T-TRACKING.
                ASSIGN
                    T-TRACKING.CodCia = s-codcia
                    T-TRACKING.CodAlm = REPOSICIONES.codalm
                    T-TRACKING.CodDoc = "R/A"
                    T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                    T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                    T-TRACKING.NroPed = "G/R: " + STRING(almcmov.nroser,'999') + '-' + STRING(almcmov.nrodoc, '9999999')
                    T-TRACKING.Libre_c01 = "Guía de Remisión Recepcionada"
                    T-TRACKING.libre_c04 = almcmov.horrcp.
                */

                ASSIGN REPOSICIONES.Libre_c05 = "Recepcionado"

                x-almdes = almcmov.almdes.
                IF REPOSICIONES.CrossDocking = YES THEN x-almdes = x-almdes + "xD".

                FIND FIRST CMOV WHERE CMOV.codcia = s-codcia
                    AND CMOV.codalm = x-almdes /*almcmov.almdes*/
                    /*AND CMOV.almdes = almcmov.codalm*/
                    AND CMOV.tipmov = 'I'
                    AND (CMOV.codmov = 03 OR CMOV.codmov = 32)
                    AND CMOV.nroser = 000
                    AND CMOV.nrodoc = INTEGER(almcmov.nrorf2)
                    AND CMOV.flgest <> "A"
                    NO-LOCK NO-ERROR.
                IF AVAILABLE CMOV THEN DO:
                    CREATE T-TRACKING.
                    ASSIGN
                        T-TRACKING.CodCia = s-codcia
                        T-TRACKING.CodAlm = REPOSICIONES.codalm
                        T-TRACKING.CodDoc = "R/A"
                        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
                        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
                        T-TRACKING.NroPed = "G/R: " + STRING(almcmov.nroser,'999') + '-' + STRING(almcmov.nrodoc, '9999999')
                        T-TRACKING.Libre_c01 = "Guía de Remisión Recepcionada"
                        T-TRACKING.libre_c04 = almcmov.horrcp.

                    ASSIGN
                        T-TRACKING.FechaI = CMOV.FchDoc
                        T-TRACKING.usuario= CMOV.usuario
                        T-TRACKING.Libre_c05 = fNombreUsuario(CMOV.usuario)
                        REPOSICIONES.Libre_c05 = "Recepcionado"
                        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.                        
                END.
            END.
        END.
        /* ****************************************** */
        /* FIN DE GUIAS DE REMISION POR TRANSFERENCIA */
        /* ****************************************** */

        /* PRE HOJA DE RUTA */
        FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-codcia
            AND DI-RutaD.CodDoc = "PHR"
            AND DI-RutaD.CodRef = Faccpedi.coddoc
            AND DI-RutaD.NroRef = Faccpedi.nroped
            AND CAN-FIND(FIRST Di-RutaC OF Di-RutaD WHERE Di-RutaC.FlgEst <> "A" NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaD THEN 
            ASSIGN 
            REPOSICIONES.PreHoja = "Si" 
            REPOSICIONES.NroPHR = DI-RutaD.NroDoc.
    END.
    /* ******************************************************************************** */
    /* FIN DE ORDENES DE TRANSFERENCIA                                                  */
    /* ******************************************************************************** */
    /* CERRADO MANUALMENTE */
    IF REPOSICIONES.flgest = "M" THEN DO:
        REPOSICIONES.Libre_c05 = "Cerrado Manualmente".
        CREATE T-TRACKING.
        ASSIGN
            T-TRACKING.CodCia = s-codcia
            T-TRACKING.CodAlm = REPOSICIONES.codalm
            T-TRACKING.CodDoc = "R/A"
            T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
            T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
            T-TRACKING.FechaI = REPOSICIONES.Libre_f01
            T-TRACKING.usuario= REPOSICIONES.Libre_c01
            T-TRACKING.Libre_c01 = "Cierre Manual del Pedido de Reposición"
            T-TRACKING.Libre_c05 = fNombreUsuario(REPOSICIONES.Libre_c01)
            T-TRACKING.libre_c04 = "".
        ASSIGN
            REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Faccpedi THEN RUN Pinta-Browse IN lh_handle (ROWID(Faccpedi), Faccpedi.coddoc).
  IF AVAILABLE Almcrepo THEN RUN Pinta-Browse IN lh_handle (ROWID(Almcrepo), "R/A").
  IF AVAILABLE REPOSICIONES THEN RUN Pinta-Tracking IN lh_handle (REPOSICIONES.codalm, REPOSICIONES.nroser, REPOSICIONES.nrodoc).

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
  ASSIGN
      FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchDoc-2 = TODAY.
/*   CASE s-Nivel-Acceso:                       */
/*       WHEN 0 THEN FILL-IN-AlmPed = s-codalm. */
/*       WHEN 1 THEN FILL-IN-AlmPed = "".       */
/*   END CASE.                                  */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN BUTTON-19:SENSITIVE = YES BUTTON-3:SENSITIVE = YES.
      CASE s-Nivel-Acceso:
          WHEN 0 THEN ASSIGN FILL-IN-AlmPed:SENSITIVE = NO FILL-IN-CodAlm:SENSITIVE = NO.
      END CASE.
/*       CASE s-Nivel-Acceso:                                                             */
/*           WHEN 0 THEN ASSIGN FILL-IN-AlmPed:SENSITIVE = NO BUTTON-19:SENSITIVE = NO.   */
/*           WHEN 1 THEN ASSIGN FILL-IN-AlmPed:SENSITIVE = YES BUTTON-19:SENSITIVE = YES. */
/*       END CASE.                                                                        */
      /* Motivos */
      COMBO-BOX-Motivo:DELIMITER= '|'.
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
           COMBO-BOX-MOtivo:ADD-LAST(FacTabla.Nombre,FacTabla.Codigo).
      END.
  END.

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
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Parametros-Tracking B-table-Win 
PROCEDURE Parametros-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pNroSer AS INTE.
DEF OUTPUT PARAMETER pNroDoc AS INTE.

IF AVAILABLE REPOSICIONES THEN DO:
    pCodAlm = REPOSICIONES.codalm.
    pNroSer = REPOSICIONES.nroser.
    pNroDoc = REPOSICIONES.nrodoc.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE picking-sacadores B-table-Win 
PROCEDURE picking-sacadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cInicio AS CHAR INIT "".
DEFINE VAR cTermino AS CHAR INIT "".
FOR EACH vtadtrkped WHERE vtadtrkped.codcia = s-codcia AND 
                            vtadtrkped.coddoc = faccpedi.coddoc AND 
                            vtadtrkped.nroped = faccpedi.nroped NO-LOCK
                            BY vtadtrkped.fechaI :
    IF cInicio = "" THEN cInicio = STRING(vtadtrkped.fechaI,"99/99/9999 hh:mm:ss").
    IF vtadtrkped.codubic = 'VODP' THEN DO:
        cTermino = STRING(vtadtrkped.fechaI,"99/99/9999 hh:mm:ss").
    END.
END.
IF cInicio <> "" THEN DO:
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
        T-TRACKING.FechaI = DATETIME(cInicio)
        T-TRACKING.usuario= "" /*ENTRY(1,faccpedi.libre_c03,"|")*/
        T-TRACKING.Libre_c01 = "Inicio - Picking Orden de Transferencia"
        T-TRACKING.Libre_c05 = "" /*fNombreUsuario(ENTRY(1,faccpedi.libre_c03,"|"))*/
        T-TRACKING.libre_c04 = SUBSTRING(cInicio,12) NO-ERROR.
    ASSIGN                  
        REPOSICIONES.Libre_c05 = "Picking"
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
END.
IF cTermino <> "" THEN DO:
    CREATE T-TRACKING.
    ASSIGN
        T-TRACKING.CodCia = s-codcia
        T-TRACKING.CodAlm = REPOSICIONES.codalm
        T-TRACKING.CodDoc = REPOSICIONES.CodDoc
        T-TRACKING.Libre_d01 = REPOSICIONES.NroSer
        T-TRACKING.Libre_d02 = REPOSICIONES.NroDoc
        T-TRACKING.NroPed = faccpedi.coddoc + ' ' + faccpedi.nroped
        T-TRACKING.FechaI = DATETIME(cTermino)
        T-TRACKING.usuario= "" /*ENTRY(1,faccpedi.libre_c03,"|")*/
        T-TRACKING.Libre_c01 = "Termino - Picking Orden de Transferencia"
        T-TRACKING.Libre_c05 = "" /*fNombreUsuario(ENTRY(1,faccpedi.libre_c03,"|"))*/
        T-TRACKING.libre_c04= SUBSTRING(cTermino,12).
    ASSIGN                  
        REPOSICIONES.Libre_c05 = "Picking"
        REPOSICIONES.Libre_f02 = T-TRACKING.FechaI.
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
  {src/adm/template/snd-list.i "REPOSICIONES"}
  {src/adm/template/snd-list.i "almcrepo"}
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solo-Cabecera B-table-Win 
PROCEDURE Solo-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    EMPTY TEMP-TABLE T-Detalle.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE REPOSICIONES:
        CREATE T-Detalle.
        ASSIGN
            T-Detalle.AlmPed    = REPOSICIONES.AlmPed
            T-Detalle.AlmacenXD = REPOSICIONES.AlmacenXD
            T-Detalle.CodAlm    = REPOSICIONES.CodAlm
            T-Detalle.FchDoc    = REPOSICIONES.FchDoc
            T-Detalle.usuario   = REPOSICIONES.usuario
            T-Detalle.NroSer    = REPOSICIONES.NroSer
            T-Detalle.NroDoc    = REPOSICIONES.NroDoc
            T-Detalle.Fecha     = REPOSICIONES.Fecha
            T-Detalle.ImpMn1    = Reposiciones.ImpMn1
            T-Detalle.OT        = Reposiciones.OT
            T-Detalle.NewOT     = REPOSICIONES.NroRf1
            T-Detalle.Libre_c05 = Reposiciones.Libre_c05 
            T-Detalle.Libre_f02 = Reposiciones.Libre_f02
            T-Detalle.TotGuias  = INTEGER(Reposiciones.Cco)
            T-Detalle.Bultos    = INTEGER(Reposiciones.FlgCbd )
            T-Detalle.TotItm    = Reposiciones.TotItm 
            T-Detalle.Libre_d01 = Reposiciones.Libre_d01 
            T-Detalle.TotPesoApro = REPOSICIONES.TotPesoApro
            T-Detalle.Libre_d02 = Reposiciones.Libre_d02 
            T-Detalle.TotCosSol = Reposiciones.TotCosSol 
            T-Detalle.TotCosApro = REPOSICIONES.TotCosApro
            T-Detalle.TotCosAte = Reposiciones.TotCosAte 
            T-Detalle.TotVolSol = Reposiciones.TotVolSol 
            T-Detalle.TotVolApro = REPOSICIONES.TotVolApro
            T-Detalle.TotVolAte = Reposiciones.TotVolAte 
            T-Detalle.CrossDocking = Reposiciones.CrossDocking
            T-Detalle.Motivo    = fMotivo()
            T-Detalle.Glosa     = (IF AVAILABLE Almcrepo THEN almcrepo.Glosa ELSE '')
            T-Detalle.FchApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.FchApr ELSE ?)
            T-Detalle.UsrApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.UsrApr ELSE ?)
            T-Detalle.hruta     = REPOSICIONES.hruta
            T-Detalle.codrechazo     = REPOSICIONES.codrechazo
            T-Detalle.nomrechazo     = REPOSICIONES.nomrechazo
            T-Detalle.obsrechazo     = REPOSICIONES.obsrechazo
            T-Detalle.NroPHR = REPOSICIONES.NroPHR
            .
        GET NEXT {&browse-name}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solo-Cabecera-Detalle B-table-Win 
PROCEDURE Solo-Cabecera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroGuia AS CHAR NO-UNDO.
DEF BUFFER ORDENES FOR Faccpedi.

DEFINE VAR lCantAtendida AS DEC.

    EMPTY TEMP-TABLE T-Detalle-Item.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE REPOSICIONES:
        CASE REPOSICIONES.CodDoc:
            WHEN "OTR" THEN DO:
                FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                    /* *************************** */
                    /* RHC 01/03/2017 Buscamos G/R */
                    /* *************************** */
                    x-NroGuia = ''.
                    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
                        AND Almcmov.codref = Faccpedi.coddoc
                        AND Almcmov.nroref = Faccpedi.nroped
                        AND Almcmov.flgest <> 'A',
                        FIRST Almdmov OF Almcmov NO-LOCK WHERE Almdmov.codmat = Almdrepo.codmat:
                        x-NroGuia = x-NroGuia + (IF TRUE <> (x-NroGuia > '') THEN '' ELSE ',') + 
                                    STRING(Almcmov.nroser, '999') + '-' + STRING(Almcmov.nrodoc, '999999999').
                    END.
                    /* *************************** */
                    CREATE T-Detalle-Item.
                    ASSIGN
                        T-Detalle-Item.AlmPed    = REPOSICIONES.AlmPed
                        T-Detalle-Item.AlmacenXD = REPOSICIONES.AlmacenXD
                        T-Detalle-Item.CodAlm    = REPOSICIONES.CodAlm
                        T-Detalle-Item.FchDoc    = REPOSICIONES.FchDoc
                        T-Detalle-Item.usuario   = REPOSICIONES.usuario
                        T-Detalle-Item.NroSer    = REPOSICIONES.NroSer
                        T-Detalle-Item.NroDoc    = REPOSICIONES.NroDoc
                        T-Detalle-Item.Fecha     = REPOSICIONES.Fecha
                        T-Detalle-Item.ImpMn1    = Reposiciones.ImpMn1
                        T-Detalle-Item.OT        = Reposiciones.OT
                        T-Detalle-Item.NewOT     = REPOSICIONES.NroRf1
                        T-Detalle-Item.Libre_c05 = Reposiciones.Libre_c05 
                        T-Detalle-Item.Libre_f02 = Reposiciones.Libre_f02
                        T-Detalle-Item.TotGuias  = INTEGER(Reposiciones.Cco)
                        T-Detalle-Item.Bultos    = INTEGER(Reposiciones.FlgCbd )
                        T-Detalle-Item.TotItm    = Reposiciones.TotItm 
                        T-Detalle-Item.Libre_d01 = Reposiciones.Libre_d01 
                        T-Detalle-Item.TotPesoApro = REPOSICIONES.TotPesoApro
                        T-Detalle-Item.Libre_d02 = Reposiciones.Libre_d02 
                        T-Detalle-Item.TotCosSol = Reposiciones.TotCosSol 
                        T-Detalle-Item.TotCosApro = REPOSICIONES.TotCosApro
                        T-Detalle-Item.TotCosAte = Reposiciones.TotCosAte 
                        T-Detalle-Item.TotVolSol = Reposiciones.TotVolSol 
                        T-Detalle-Item.TotVolApro = REPOSICIONES.TotVolApro
                        T-Detalle-Item.TotVolAte = Reposiciones.TotVolAte 
                        T-Detalle-Item.CrossDocking = Reposiciones.CrossDocking
                        T-Detalle-Item.Motivo    = fMotivo()
                        T-Detalle-Item.Glosa     = (IF AVAILABLE Almcrepo THEN almcrepo.Glosa ELSE '')
                        T-Detalle-Item.FchApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.FchApr ELSE ?)
                        T-Detalle-Item.UsrApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.UsrApr ELSE ?)
                        T-Detalle-Item.hruta     = REPOSICIONES.hruta
                        T-Detalle-Item.codrechazo     = REPOSICIONES.codrechazo
                        T-Detalle-Item.nomrechazo     = REPOSICIONES.nomrechazo
                        T-Detalle-Item.obsrechazo     = REPOSICIONES.obsrechazo
                        T-Detalle-Item.NroPHR = REPOSICIONES.NroPHR
                        .
                    ASSIGN
                        T-Detalle-Item.CodMat = Facdpedi.codmat 
                        T-Detalle-Item.DesMat = almmmatg.desmat 
                        T-Detalle-Item.DesMar = almmmatg.desmar 
                        T-Detalle-Item.UndBas = almmmatg.undbas 
                        T-Detalle-Item.CodFam = almmmatg.codfam 
                        T-Detalle-Item.SubFam = almmmatg.subfam 
                        T-Detalle-Item.CanGen = Facdpedi.canped
                        T-Detalle-Item.Canapro = Facdpedi.canped
                        T-Detalle-Item.CanAte = Facdpedi.canate
                        T-Detalle-Item.CosRepo = almmmatg.ctolis
                        T-Detalle-Item.PesMat = almmmatg.pesmat 
                        T-Detalle-Item.Volumen = almmmatg.libre_d02 / 1000000
                        /*T-Detalle-Item.Origen = almdrepo.origen */
                        T-Detalle-Item.NroGuia = x-NroGuia.
                    T-Detalle-Item.ClfGral = fClfGral('GENERAL').
                    T-Detalle-Item.ClfUtilex = fClfGral('UTILEX').
                    T-Detalle-Item.ClfMay = fClfGral('MAYORISTA').
                    IF almmmatg.monvta <> 1 THEN DO:
                        T-Detalle-Item.CosRepo  = T-Detalle-Item.CosRepo * almmmatg.tpocmb.
                    END.
                END.
            END.
            OTHERWISE DO:
                FOR EACH almdrepo OF almcrepo NO-LOCK, FIRST Almmmatg OF Almdrepo NO-LOCK:
                    /* *************************** */
                    /* RHC 01/03/2017 Buscamos G/R */
                    /* *************************** */
                    x-NroGuia = ''.
                    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
                        AND Faccpedi.coddoc = 'OTR'
                        AND Faccpedi.flgest <> 'A'
                        AND Faccpedi.codref = "R/A"
                        AND Faccpedi.nroref = STRING(Almcrepo.nroser,'999') + STRING(Almcrepo.nrodoc,'999999'),
                        FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = Almdrepo.codmat:
                        FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
                            AND Almcmov.codref = Faccpedi.coddoc
                            AND Almcmov.nroref = Faccpedi.nroped
                            AND Almcmov.flgest <> 'A',
                            FIRST Almdmov OF Almcmov NO-LOCK WHERE Almdmov.codmat = Almdrepo.codmat:
                            x-NroGuia = x-NroGuia + (IF TRUE <> (x-NroGuia > '') THEN '' ELSE ',') + 
                                        STRING(Almcmov.nroser, '999') + '-' + STRING(Almcmov.nrodoc, '999999999').
                        END.
                    END.

                    lCantAtendida = fAtendido(almcrepo.almped, 
                                              almdrepo.codmat,
                                              'R/A',
                                              STRING(almdrepo.nroser,"999") + STRING(almdrepo.nrodoc,"999999")
                                              ).

                    /* *************************** */
                    CREATE T-Detalle-Item.
                    ASSIGN
                        T-Detalle-Item.AlmPed    = REPOSICIONES.AlmPed
                        T-Detalle-Item.AlmacenXD = REPOSICIONES.AlmacenXD
                        T-Detalle-Item.CodAlm    = REPOSICIONES.CodAlm
                        T-Detalle-Item.FchDoc    = REPOSICIONES.FchDoc
                        T-Detalle-Item.usuario   = REPOSICIONES.usuario
                        T-Detalle-Item.NroSer    = REPOSICIONES.NroSer
                        T-Detalle-Item.NroDoc    = REPOSICIONES.NroDoc
                        T-Detalle-Item.Fecha     = REPOSICIONES.Fecha
                        T-Detalle-Item.ImpMn1    = Reposiciones.ImpMn1
                        T-Detalle-Item.OT        = Reposiciones.OT
                        T-Detalle-Item.NewOT     = REPOSICIONES.NroRf1
                        T-Detalle-Item.Libre_c05 = Reposiciones.Libre_c05 
                        T-Detalle-Item.Libre_f02 = Reposiciones.Libre_f02
                        T-Detalle-Item.TotGuias  = INTEGER(Reposiciones.Cco)
                        T-Detalle-Item.Bultos    = INTEGER(Reposiciones.FlgCbd )
                        T-Detalle-Item.TotItm    = Reposiciones.TotItm 
                        T-Detalle-Item.Libre_d01 = Reposiciones.Libre_d01 
                        T-Detalle-Item.TotPesoApro = REPOSICIONES.TotPesoApro
                        T-Detalle-Item.Libre_d02 = Reposiciones.Libre_d02 
                        T-Detalle-Item.TotCosSol = Reposiciones.TotCosSol 
                        T-Detalle-Item.TotCosApro = REPOSICIONES.TotCosApro
                        T-Detalle-Item.TotCosAte = Reposiciones.TotCosAte 
                        T-Detalle-Item.TotVolSol = Reposiciones.TotVolSol 
                        T-Detalle-Item.TotVolApro = REPOSICIONES.TotVolApro
                        T-Detalle-Item.TotVolAte = Reposiciones.TotVolAte 
                        T-Detalle-Item.CrossDocking = Reposiciones.CrossDocking
                        T-Detalle-Item.Motivo    = fMotivo()
                        T-Detalle-Item.Glosa     = (IF AVAILABLE Almcrepo THEN almcrepo.Glosa ELSE '')
                        T-Detalle-Item.FchApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.FchApr ELSE ?)
                        T-Detalle-Item.UsrApr    = (IF AVAILABLE Almcrepo THEN Almcrepo.UsrApr ELSE ?)
                        T-Detalle-Item.hruta     = REPOSICIONES.hruta
                        T-Detalle-Item.codrechazo     = REPOSICIONES.codrechazo
                        T-Detalle-Item.nomrechazo     = REPOSICIONES.nomrechazo
                        T-Detalle-Item.obsrechazo     = REPOSICIONES.obsrechazo
                        T-Detalle-Item.NroPHR = REPOSICIONES.NroPHR
                        .
                    ASSIGN
                        T-Detalle-Item.CodMat = almdrepo.codmat 
                        T-Detalle-Item.DesMat = almmmatg.desmat 
                        T-Detalle-Item.DesMar = almmmatg.desmar 
                        T-Detalle-Item.UndBas = almmmatg.undbas 
                        T-Detalle-Item.CodFam = almmmatg.codfam 
                        T-Detalle-Item.SubFam = almmmatg.subfam 
                        T-Detalle-Item.CanGen = almdrepo.cangen 
                        T-Detalle-Item.Canapro = almdrepo.canapro
                        T-Detalle-Item.CanAte = lCantAtendida /*almdrepo.canate */
                        T-Detalle-Item.CosRepo = almmmatg.ctolis
                        T-Detalle-Item.PesMat = almmmatg.pesmat 
                        T-Detalle-Item.Volumen = almmmatg.libre_d02 / 1000000
                        T-Detalle-Item.Origen = almdrepo.origen 
                        T-Detalle-Item.NroGuia = x-NroGuia.
                    T-Detalle-Item.ClfGral = fClfGral('GENERAL').
                    T-Detalle-Item.ClfUtilex = fClfGral('UTILEX').
                    T-Detalle-Item.ClfMay = fClfGral('MAYORISTA').
                    IF almmmatg.monvta <> 1 THEN DO:
                        T-Detalle-Item.CosRepo  = T-Detalle-Item.CosRepo * almmmatg.tpocmb.
                    END.
                END.
            END.
        END CASE.
        GET NEXT {&browse-name}.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER B-REPOSICIONES FOR REPOSICIONES.
ASSIGN
    FILL-IN-TotCosAte = 0
    FILL-IN-TotCosSol = 0
    FILL-IN-TotPedidos = 0
    FILL-IN-TotPesAte = 0
    FILL-IN-TotPesSol = 0
/*     FILL-IN-TotVolAte = 0 */
/*     FILL-IN-TotVolSol = 0 */
    txtPedAtrazados = 0
    FILL-IN-TotGuias = 0
    fill-in-TotBultos = 0
    FILL-IN-TotItm = 0
    .

DEFINE VAR cEstados AS CHAR.
cEstados = "Emitido,Aprobado,Impreso,Picking,Chequeado,Documentado,En Ruta".

FOR EACH B-REPOSICIONES NO-LOCK WHERE (x-Estado = 'Todos' OR LOOKUP(B-REPOSICIONES.Libre_c05, x-Estado) > 0)
    AND (COMBO-BOX-PreHoja = 'Todos' OR B-REPOSICIONES.PreHoja = COMBO-BOX-PreHoja)
    BREAK BY B-REPOSICIONES.NroSer BY B-REPOSICIONES.NroDoc:
    IF FIRST-OF(B-REPOSICIONES.NroSer) OR FIRST-OF(B-REPOSICIONES.NroDoc) 
        THEN FILL-IN-TotPedidos =  FILL-IN-TotPedidos + 1.
    ASSIGN
        FILL-IN-TotCosAte  =  FILL-IN-TotCosAte + B-REPOSICIONES.TotCosAte
        FILL-IN-TotCosSol  =  FILL-IN-TotCosSol + B-REPOSICIONES.TotCosApro
        FILL-IN-TotPesAte  =  FILL-IN-TotPesAte + B-REPOSICIONES.Libre_d02
        FILL-IN-TotPesSol  =  FILL-IN-TotPesSol + B-REPOSICIONES.TotPesoApro
        FILL-IN-TotGuias = FILL-IN-TotGuias + INTEGER(B-REPOSICIONES.cco)
        fill-in-TotBultos = fill-in-TotBultos + INTEGER(B-REPOSICIONES.flgcbd)
        FILL-IN-TotItm = FILL-IN-TotItm + B-REPOSICIONES.TotItm
        .
      /* Ic - Correo Max Ramos - 20Dic2016 */
      IF LOOKUP(B-REPOSICIONES.Libre_c05,cEstados) > 0 AND TODAY > B-REPOSICIONES.fecha 
                        THEN txtPedAtrazados = txtPedAtrazados + 1.
END.
DISPLAY
    FILL-IN-TotCosAte 
    FILL-IN-TotCosSol 
    FILL-IN-TotPedidos
    FILL-IN-TotPesAte 
    FILL-IN-TotPesSol 
    txtPedAtrazados
    fill-in-TotGuias
    fill-in-TotBultos
    FILL-IN-TotItm
    WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tracking-a-excel B-table-Win 
PROCEDURE tracking-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-repo FOR reposiciones.
DEFINE BUFFER b-track FOR t-tracking.
DEFINE BUFFER b-almcrepo FOR almcrepo.
DEFINE BUFFER b-TRACKING FOR T-TRACKING.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.


lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */


{lib\excel-open-file.i}

chExcelApplication:Visible = NO.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */

chWorkSheet = chExcelApplication:Sheets:Item(1).  
iRow = 1.

SESSION:SET-WAIT-STATE('GENERAL').

cRange = "A" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Urgente".
cRange = "B" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Motivo".
cRange = "C" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Alm. Despacho".
cRange = "D" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Alm. Destino".
cRange = "E" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Emision".
cRange = "F" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Usuario".
cRange = "G" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Serie".
cRange = "H" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "I" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Entrega".
cRange = "J" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Lead Time Dias".
cRange = "K" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "O/T".
cRange = "L" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "M" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Fecha Estado".
cRange = "N" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Total Guias".
cRange = "O" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Bultos".
cRange = "P" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Total Items".
cRange = "Q" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Peso Solicitado Kgrs".
cRange = "R" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Peso Atendido Kgrs".
cRange = "S" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Total Soles Solicitado".
cRange = "T" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Total Soles Atendido".
cRange = "U" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Total m3 Solicitado".
cRange = "V" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Toal m3 Atendido".
cRange = "W" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Observaciones".
cRange = "X" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Fecha Aprobacion".
cRange = "Y" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Usuario Aprobacion".
cRange = "Z" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "H. Ruta".
cRange = "AA" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Cod.Rechazo".
cRange = "AB" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Nombre Rechazo".
cRange = "AC" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Observacion Rechazo".

/* Detalle */
cRange = "AD" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Fecha Track".
cRange = "AE" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "AF" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Documento".
cRange = "AG" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Hora".
cRange = "AH" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Usuario".
cRange = "AI" + STRING(iRow).
chWorkSheet:Range(cRange):Value = "Nombre Usuario".

iRow = iRow + 1.

FOR EACH b-REPO NO-LOCK,
      FIRST b-almcrepo OF b-REPO NO-LOCK :

    FOR EACH b-TRACKING WHERE b-TRACKING.CodCia = b-almcrepo.CodCia
                                AND b-TRACKING.CodAlm = b-almcrepo.CodAlm
                                AND b-TRACKING.Libre_d01 = b-almcrepo.NroSer
                                AND b-TRACKING.Libre_d02 = b-almcrepo.NroDoc NO-LOCK:
        /* Cabecera */
        cRange = "A" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.vtapuntual.

        cRange = "B" + STRING(iRow).
        FIND FacTabla WHERE FacTabla.CodCia = s-codcia
              AND FacTabla.Codigo =  b-almcrepo.MotReposicion
              AND FacTabla.Tabla = 'REPOMOTIVO'
              NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN chWorkSheet:Range(cRange):VALUE = FacTabla.Nombre.
        cRange = "C" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-almcrepo.almped.
        cRange = "D" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-almcrepo.codalm.
        cRange = "E" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.fchdoc.
        cRange = "F" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-repo.usuario.
        cRange = "G" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.nroser.
        cRange = "H" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.nrodoc.
        cRange = "I" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.fecha.
        cRange = "J" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.impmn1.
        cRange = "K" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-repo.ot.
        cRange = "L" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.libre_c05.
        cRange = "M" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.libre_f02.
        cRange = "N" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.cco.
        cRange = "O" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.flgcbd.
        cRange = "P" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.totitm.
        cRange = "Q" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.libre_d01.
        cRange = "R" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.libre_d02.
        cRange = "S" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.totcossol.
        cRange = "T" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.totcosate.
        cRange = "U" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.totvolsol.
        cRange = "V" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.totvolate.
        cRange = "W" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.glosa.
        cRange = "X" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.fchapr.
        cRange = "Y" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-almcrepo.usrapr.
        cRange = "Z" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-repo.hruta.
        cRange = "AA" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-repo.codrechazo.
        cRange = "AB" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.nomrechazo.
        cRange = "AC" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-repo.obsrechazo.

        /* Detalle */
        cRange = "AD" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-tracking.fechaI.
        cRange = "AE" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-tracking.libre_c01.
        cRange = "AF" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-tracking.nroped.
        cRange = "AG" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-tracking.libre_c04.
        cRange = "AH" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = "'" + b-tracking.usuario.
        cRange = "AI" + STRING(iRow).
        chWorkSheet:Range(cRange):Value = b-tracking.libre_c05.

        iRow = iRow + 1.
    END.
END.

chExcelApplication:Visible = TRUE.
{lib\excel-close-file.i} 

SESSION:SET-WAIT-STATE('').


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAtendido B-table-Win 
FUNCTION fAtendido RETURNS DECIMAL
      ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

      DEF VAR fCanAte AS DEC NO-UNDO.
      FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = 'OTR'
          AND Faccpedi.codref = pCodDoc
          AND Faccpedi.nroref = pNroDoc
          AND Faccpedi.CodAlm = pCodAlm
          AND Faccpedi.flgest <> 'A',
          EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = pCodMat:
          fCanAte = fCanAte + Facdpedi.canped.
      END.
      RETURN fCanAte.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfGral B-table-Win 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pTipo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  /* Campaña o no campaña */
  FIND FIRST AlmCfgGn WHERE AlmCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AlmCfgGn THEN RETURN "".
  FIND FIRST factabla WHERE factabla.codcia = Almmmatg.codcia AND 
                            factabla.tabla = 'RANKVTA' AND 
                            factabla.codigo = almmmatg.codmat
                            NO-LOCK NO-ERROR.
  IF NOT AVAILABLE factabla THEN RETURN ''.

  CASE AlmCfgGn.Temporada:
      WHEN "C" THEN DO:
          CASE pTipo:
              WHEN "GENERAL"    THEN RETURN factabla.campo-c[1].
              WHEN "UTILEX"     THEN RETURN factabla.campo-c[2].
              WHEN "MAYORISTA"  THEN RETURN factabla.campo-c[3].
          END CASE.
      END.
      WHEN "NC" THEN DO:
          CASE pTipo:
              WHEN "GENERAL"    THEN RETURN factabla.campo-c[4].
              WHEN "UTILEX"     THEN RETURN factabla.campo-c[5].
              WHEN "MAYORISTA"  THEN RETURN factabla.campo-c[6].
          END CASE.
      END.
  END CASE.
  RETURN "".   /* Function return value. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

CASE pFlgEst:
    WHEN 'P' THEN pEstado = "EMITIDO".
    WHEN 'C' THEN pEstado = "CON OTR".
    WHEN 'A' THEN pEstado = "ANULADO".
    WHEN 'M' THEN pEstado = "CERRADA MANUALMENTE".
END CASE.
RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFlgSit B-table-Win 
FUNCTION fFlgSit RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

RUN gn/fFlgSitTracking(pFlgSIt, OUTPUT pEstado).

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetBultos B-table-Win 
FUNCTION fGetBultos RETURNS INTEGER
  (INPUT pCoddoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS INT.

lRetVal = 0.

DEFINE BUFFER b-ccbcbult FOR ccbcbult.

FOR EACH b-ccbcbult WHERE b-ccbcbult.codcia = s-codcia AND 
                        b-ccbcbult.coddoc = pCodDoc AND
                        b-ccbcbult.nrodoc = pNroDoc 
                        NO-LOCK:
    lRetval = lRetVal + b-ccbcbult.bultos.
END.

RELEASE b-ccbcbult.

RETURN lRetval.

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

DEFINE VAR x-codmotivo AS CHAR.

/*   IF AVAILABLE Almcrepo THEN DO:                                       */
/*       x-codmotivo = almcrepo.MotReposicion.                            */
/*   END.                                                                 */
/*   ELSE DO:                                                             */
/*       /* CrossDocking Compras */                                       */
/*       IF AVAILABLE faccpedi THEN x-codmotivo = faccpedi.MotReposicion. */
/*   END.                                                                 */

  x-codmotivo = REPOSICIONES.motreposicion.
  FIND FacTabla WHERE FacTabla.CodCia = s-codcia
      AND FacTabla.Codigo =  x-codmotivo
      AND FacTabla.Tabla = 'REPOMOTIVO'
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN RETURN FacTabla.Nombre.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNombreUsuario B-table-Win 
FUNCTION fNombreUsuario RETURNS CHARACTER
  (INPUT pCodUsuario AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = "".

if TRUE <> (lRetVal > "") THEN lRetVal.

IF SUBSTRING(pCodUsuario,1,1) = '0' THEN DO:
    /* Codigo de Trabajador */
    FIND FIRST pl-pers WHERE pl-pers.codper = pCodUsuario NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers  THEN DO:
        lRetVal = TRIM(pl-pers.nomper) + " " + TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper).
    END.
END.
ELSE DO:
    /* Usuario Progress */
    FIND FIRST dictdb._user WHERE _user._userid = pCodUsuario NO-LOCK NO-ERROR.
    IF AVAILABLE dictdb._user THEN DO:
        lRetVal = dictdb._user._user-name.
    END.
END.

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion B-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

CASE pFlgSit:
    WHEN 'P' THEN pEstado = "POR APROBAR".
    WHEN 'R' THEN pEstado = "RECHAZADO".
    WHEN 'A' THEN pEstado = "APROBADO".
END CASE.
RETURN pEstado.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

