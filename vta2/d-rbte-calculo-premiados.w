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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR S-CODDIV AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-clientes-calculo
    FIELD   tcodcli AS  CHAR    COLUMN-LABEL "Cod.Cliente"
    FIELD   tnomcli AS  CHAR    COLUMN-LABEL "Nombre del Cliente"
    FIELD   truc    AS  CHAR    COLUMN-LABEL "R.U.C."
    FIELD   tagrupador AS  CHAR    COLUMN-LABEL "Agrupador"
    FIELD   tmeta1  AS  DEC     FORMAT '->>,>>>,>>9.99'     COLUMN-LABEL "Meta 1"
    FIELD   tmeta2  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Meta 2"
    FIELD   tmeta3  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Meta 3"
    FIELD   tventas  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Meta"
    FIELD   tvta-premio  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Premio"
    FIELD   tcobros  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Cobranzas"
    FIELD   tventasgrp  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Grupo"
    FIELD   tcobrosgrp  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Cobranzas Grupo"
    FIELD   tpremio AS INT  FORMAT '->>9' COLUMN-LABEL "Premio"     INIT 0
    FIELD   tfactorpremio AS DEC  FORMAT '->>9.9999' COLUMN-LABEL "%Premio"     INIT 0
    FIELD   timppremio  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Premio"   INIT 0      /* Cuanto le corresponde de premio en S/ */
    FIELD   tpremiocalc  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Premio calculado"   INIT 0   /* La suma del calculado */
    FIELD   tvtaslinpremiadas  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Total Lineas Premiadas"   INIT 0.

/* Temporales de la PNC - Header */
DEFINE TEMP-TABLE pnc-ccbcdocu
    FIELD   codcia  LIKE    Ccbcdocu.codcia
    FIELD   coddiv  LIKE    Ccbcdocu.coddiv
    FIELD   coddoc  LIKE    Ccbcdocu.coddoc
    FIELD   nrodoc  LIKE    Ccbcdocu.nrodoc
    FIELD   fchdoc  LIKE    Ccbcdocu.fchdoc
    FIELD   horcie  LIKE    Ccbcdocu.horcie
    FIELD   fchvto  LIKE    Ccbcdocu.fchvto
    FIELD   codcli  LIKE    Ccbcdocu.codcli
    FIELD   ruccli  LIKE    Ccbcdocu.ruccli
    FIELD   nomcli  LIKE    Ccbcdocu.nomcli
    FIELD   dircli  LIKE    Ccbcdocu.dircli
    FIELD   porigv  LIKE    Ccbcdocu.porigv
    FIELD   codmon  LIKE    Ccbcdocu.codmon
    FIELD   usuario LIKE    Ccbcdocu.usuario
    FIELD   tpocmb  LIKE    Ccbcdocu.tpocmb
    FIELD   codref  LIKE    Ccbcdocu.codref
    FIELD   nroref  LIKE    Ccbcdocu.nroref
    FIELD   codven  LIKE    Ccbcdocu.codven
    FIELD   divori  LIKE    Ccbcdocu.divori
    FIELD   cndcre  LIKE    Ccbcdocu.cndcre
    FIELD   fmapgo  LIKE    Ccbcdocu.fmapgo
    FIELD   tpofac  LIKE    Ccbcdocu.tpofac
    FIELD   codcta  LIKE    Ccbcdocu.codcta          /*Concepto*/
    FIELD   tipo    LIKE    Ccbcdocu.tipo   /*"CREDITO"*/
    FIELD   codcaja LIKE    Ccbcdocu.codcaja
    FIELD   FlgEst  LIKE    Ccbcdocu.FlgEst
    FIELD   ImpBrt  LIKE    Ccbcdocu.ImpBrt
    FIELD   ImpExo  LIKE    Ccbcdocu.ImpExo
    FIELD   ImpDto  LIKE    Ccbcdocu.ImpDto
    FIELD   ImpIgv  LIKE    Ccbcdocu.ImpIgv
    FIELD   ImpTot  LIKE    Ccbcdocu.ImpTot
    FIELD   flgcie  LIKE    Ccbcdocu.flgcie
    FIELD   ImpVta  LIKE    Ccbcdocu.ImpVta
    FIELD   SdoAct  LIKE    Ccbcdocu.SdoAct
    FIELD   libre_c01 LIKE ccbcdocu.libre_c01
    FIELD   libre_c99 AS    CHAR    INIT ""               /* Para el correlativo correcto */
    FIELD   flg-num  AS  CHAR    INIT ""
    FIELD   tgrupo-docs AS    CHAR  INIT ""        /* El documento es de Campaña / No Campaña */.

/* Temporales de la PNC - Detail */
DEFINE TEMP-TABLE pnc-ccbddocu
    FIELD   codcia  LIKE    Ccbddocu.codcia
    FIELD   coddiv  LIKE    Ccbddocu.coddiv
    FIELD   coddoc  LIKE    Ccbddocu.coddoc
    FIELD   nrodoc  LIKE    Ccbddocu.nrodoc
    FIELD   fchdoc  LIKE    Ccbddocu.fchdoc
    FIELD   nroitm  LIKE    Ccbddocu.nroitm
    FIELD   codmat  LIKE    Ccbddocu.codmat
    FIELD   factor  LIKE    Ccbddocu.factor
    FIELD   candes  LIKE    Ccbddocu.candes
    FIELD   preuni  LIKE    Ccbddocu.preuni
    FIELD   implin  LIKE    Ccbddocu.implin
    FIELD   undvta  LIKE    Ccbddocu.undvta
    FIELD   flg_factor  LIKE Ccbddocu.flg_factor
    FIELD   aftigv  LIKE    Ccbddocu.aftigv
    FIELD   impigv  LIKE    Ccbddocu.impigv.

DEFINE OUTPUT PARAMETER pProcesado AS LOG.
DEFINE INPUT PARAMETER TABLE FOR tt-clientes-calculo.
DEFINE INPUT PARAMETER TABLE FOR pnc-ccbcdocu.
DEFINE INPUT PARAMETER TABLE FOR pnc-ccbddocu.

DEFINE VAR x-cliente AS CHAR.
DEFINE VAR x-coddoc AS CHAR INIT 'PNC'.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-col-monvta AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-11

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES pnc-ccbcdocu pnc-ccbddocu almmmatg ~
tt-clientes-calculo

/* Definitions for BROWSE BROWSE-11                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-11 pnc-ccbcdocu.coddoc pnc-ccbcdocu.nrodoc pnc-ccbcdocu.fchdoc fMoneda(pnc-ccbcdocu.codmon) @ x-col-monvta pnc-ccbcdocu.impvta pnc-ccbcdocu.impigv pnc-ccbcdocu.imptot pnc-ccbcdocu.codcta pnc-ccbcdocu.coddiv pnc-ccbcdocu.divori pnc-ccbcdocu.libre_c01 pnc-ccbcdocu.codref pnc-ccbcdocu.nroref /* FIELD codcia LIKE Ccbcdocu.codcia FIELD coddiv LIKE Ccbcdocu.coddiv FIELD coddoc LIKE Ccbcdocu.coddoc FIELD nrodoc LIKE Ccbcdocu.nrodoc FIELD fchdoc LIKE Ccbcdocu.fchdoc FIELD horcie LIKE Ccbcdocu.horcie FIELD fchvto LIKE Ccbcdocu.fchvto FIELD codcli LIKE Ccbcdocu.codcli FIELD ruccli LIKE Ccbcdocu.ruccli FIELD nomcli LIKE Ccbcdocu.nomcli FIELD dircli LIKE Ccbcdocu.dircli FIELD porigv LIKE Ccbcdocu.porigv FIELD codmon LIKE Ccbcdocu.codmon FIELD usuario LIKE Ccbcdocu.usuario FIELD tpocmb LIKE Ccbcdocu.tpocmb FIELD codref LIKE Ccbcdocu.codref FIELD nroref LIKE Ccbcdocu.nroref FIELD codven LIKE Ccbcdocu.codven FIELD divori LIKE Ccbcdocu.divori FIELD cndcre LIKE Ccbcdocu.cndcre FIELD fmapgo LIKE Ccbcdocu.fmapgo FIELD tpofac LIKE Ccbcdocu.tpofac FIELD codcta LIKE Ccbcdocu.codcta /*Concepto*/ FIELD tipo LIKE Ccbcdocu.tipo /*"CREDITO"*/ FIELD codcaja LIKE Ccbcdocu.codcaja FIELD FlgEst LIKE Ccbcdocu.FlgEst FIELD ImpBrt LIKE Ccbcdocu.ImpBrt FIELD ImpExo LIKE Ccbcdocu.ImpExo FIELD ImpDto LIKE Ccbcdocu.ImpDto FIELD ImpIgv LIKE Ccbcdocu.ImpIgv FIELD ImpTot LIKE Ccbcdocu.ImpTot FIELD flgcie LIKE Ccbcdocu.flgcie FIELD ImpVta LIKE Ccbcdocu.ImpVta FIELD SdoAct LIKE Ccbcdocu.SdoAct FIELD libre_c01 LIKE ccbcdocu.libre_c01. */   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-11   
&Scoped-define SELF-NAME BROWSE-11
&Scoped-define QUERY-STRING-BROWSE-11 FOR EACH pnc-ccbcdocu NO-LOCK                             WHERE pnc-ccbcdocu.codcli = x-cliente
&Scoped-define OPEN-QUERY-BROWSE-11 OPEN QUERY {&SELF-NAME} FOR EACH pnc-ccbcdocu NO-LOCK                             WHERE pnc-ccbcdocu.codcli = x-cliente.
&Scoped-define TABLES-IN-QUERY-BROWSE-11 pnc-ccbcdocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-11 pnc-ccbcdocu


/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 pnc-ccbddocu.nroitm pnc-ccbddocu.codmat pnc-ccbddocu.candes pnc-ccbddocu.undvta pnc-ccbddocu.preuni pnc-ccbddocu.impigv pnc-ccbddocu.implin almmmatg.desmat almmmatg.desmar /* DEFINE TEMP-TABLE pnc-ccbddocu FIELD codcia LIKE Ccbddocu.codcia FIELD coddiv LIKE Ccbddocu.coddiv FIELD coddoc LIKE Ccbddocu.coddoc FIELD nrodoc LIKE Ccbddocu.nrodoc FIELD fchdoc LIKE Ccbddocu.fchdoc FIELD nroitm LIKE Ccbddocu.nroitm FIELD codmat LIKE Ccbddocu.codmat FIELD factor LIKE Ccbddocu.factor FIELD candes LIKE Ccbddocu.candes FIELD preuni LIKE Ccbddocu.preuni FIELD implin LIKE Ccbddocu.implin FIELD undvta LIKE Ccbddocu.undvta FIELD flg_factor LIKE Ccbddocu.flg_factor FIELD aftigv LIKE Ccbddocu.aftigv FIELD impigv LIKE Ccbddocu.impigv. */   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12   
&Scoped-define SELF-NAME BROWSE-12
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH pnc-ccbddocu NO-LOCK                         WHERE pnc-ccbddocu.coddoc = x-coddoc AND                                 pnc-ccbddocu.nrodoc = x-nrodoc, ~
                           FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND                                             almmmatg.codmat = pnc-ccbddocu.codmat NO-LOCK.
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY {&SELF-NAME} FOR EACH pnc-ccbddocu NO-LOCK                         WHERE pnc-ccbddocu.coddoc = x-coddoc AND                                 pnc-ccbddocu.nrodoc = x-nrodoc, ~
                           FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND                                             almmmatg.codmat = pnc-ccbddocu.codmat NO-LOCK.                                         .
&Scoped-define TABLES-IN-QUERY-BROWSE-12 pnc-ccbddocu almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 pnc-ccbddocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-12 almmmatg


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 tt-clientes-calculo.tcodcli tt-clientes-calculo.tnomcli tt-clientes-calculo.truc tt-clientes-calculo.tagrupador tt-clientes-calculo.tventas tt-clientes-calculo.tcobros tt-clientes-calculo.tfactorpremio tt-clientes-calculo.timppremio tt-clientes-calculo.tpremiocalc tt-clientes-calculo.tventasgrp tt-clientes-calculo.tcobrosgrp tt-clientes-calculo.tmeta1 tt-clientes-calculo.tmeta2 tt-clientes-calculo.tmeta3   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9   
&Scoped-define SELF-NAME BROWSE-9
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH tt-clientes-calculo NO-LOCK     WHERE tt-clientes-calculo.timppremio > 0     BY tt-clientes-calculo.tagrupador DESC BY tt-clientes-calculo.tvtaslinpremiadas DESC      /*     */
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY {&SELF-NAME} FOR EACH tt-clientes-calculo NO-LOCK     WHERE tt-clientes-calculo.timppremio > 0     BY tt-clientes-calculo.tagrupador DESC BY tt-clientes-calculo.tvtaslinpremiadas DESC      /*     */.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 tt-clientes-calculo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 tt-clientes-calculo


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-11}~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-9 BROWSE-11 BROWSE-12 Btn_OK ~
Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda D-Dialog 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     LABEL "Grabar las PRE-NOTAS DE CREDITO" 
     SIZE 27.86 BY 1.15
     BGCOLOR 2 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-11 FOR 
      pnc-ccbcdocu SCROLLING.

DEFINE QUERY BROWSE-12 FOR 
      pnc-ccbddocu, 
      almmmatg SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      tt-clientes-calculo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-11 D-Dialog _FREEFORM
  QUERY BROWSE-11 DISPLAY
      pnc-ccbcdocu.coddoc     FORMAT 'x(5)'   COLUMN-LABEL "Doc"
pnc-ccbcdocu.nrodoc     FORMAT 'x(15)'  COLUMN-LABEL "Nro.Doc"
pnc-ccbcdocu.fchdoc     FORMAT '99/99/9999' COLUMN-LABEL "F.Emision"
fMoneda(pnc-ccbcdocu.codmon) @ x-col-monvta     FORMAT 'x(5)'    COLUMN-LABEL "Moneda"
pnc-ccbcdocu.impvta     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp.VVta"
pnc-ccbcdocu.impigv     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp. IGV"
pnc-ccbcdocu.imptot     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp. Total"
pnc-ccbcdocu.codcta     FORMAT 'x(5)'   COLUMN-LABEL "Concepto"
pnc-ccbcdocu.coddiv     FORMAT 'x(6)'   COLUMN-LABEL "Division"
pnc-ccbcdocu.divori     FORMAT 'x(6)'   COLUMN-LABEL "Origen"
pnc-ccbcdocu.libre_c01  FORMAT 'x(25)'  COLUMN-LABEL "Lineas"
pnc-ccbcdocu.codref     FORMAT 'x(5)'   COLUMN-LABEL "Cod.Ref"
pnc-ccbcdocu.nroref     FORMAT 'x(15)'   COLUMN-LABEL "Nro.Ref"


/* 
FIELD   codcia  LIKE    Ccbcdocu.codcia
FIELD   coddiv  LIKE    Ccbcdocu.coddiv
FIELD   coddoc  LIKE    Ccbcdocu.coddoc
FIELD   nrodoc  LIKE    Ccbcdocu.nrodoc
FIELD   fchdoc  LIKE    Ccbcdocu.fchdoc
FIELD   horcie  LIKE    Ccbcdocu.horcie
FIELD   fchvto  LIKE    Ccbcdocu.fchvto
FIELD   codcli  LIKE    Ccbcdocu.codcli
FIELD   ruccli  LIKE    Ccbcdocu.ruccli
FIELD   nomcli  LIKE    Ccbcdocu.nomcli
FIELD   dircli  LIKE    Ccbcdocu.dircli
FIELD   porigv  LIKE    Ccbcdocu.porigv
FIELD   codmon  LIKE    Ccbcdocu.codmon
FIELD   usuario LIKE    Ccbcdocu.usuario
FIELD   tpocmb  LIKE    Ccbcdocu.tpocmb
FIELD   codref  LIKE    Ccbcdocu.codref
FIELD   nroref  LIKE    Ccbcdocu.nroref
FIELD   codven  LIKE    Ccbcdocu.codven
FIELD   divori  LIKE    Ccbcdocu.divori
FIELD   cndcre  LIKE    Ccbcdocu.cndcre
FIELD   fmapgo  LIKE    Ccbcdocu.fmapgo
FIELD   tpofac  LIKE    Ccbcdocu.tpofac
FIELD   codcta  LIKE    Ccbcdocu.codcta          /*Concepto*/
FIELD   tipo    LIKE    Ccbcdocu.tipo   /*"CREDITO"*/
FIELD   codcaja LIKE    Ccbcdocu.codcaja
FIELD   FlgEst  LIKE    Ccbcdocu.FlgEst
FIELD   ImpBrt  LIKE    Ccbcdocu.ImpBrt
FIELD   ImpExo  LIKE    Ccbcdocu.ImpExo
FIELD   ImpDto  LIKE    Ccbcdocu.ImpDto
FIELD   ImpIgv  LIKE    Ccbcdocu.ImpIgv
FIELD   ImpTot  LIKE    Ccbcdocu.ImpTot
FIELD   flgcie  LIKE    Ccbcdocu.flgcie
FIELD   ImpVta  LIKE    Ccbcdocu.ImpVta
FIELD   SdoAct  LIKE    Ccbcdocu.SdoAct
FIELD   libre_c01 LIKE ccbcdocu.libre_c01.
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63.43 BY 5.42
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 D-Dialog _FREEFORM
  QUERY BROWSE-12 DISPLAY
      pnc-ccbddocu.nroitm     FORMAT '>,>>9'      COLUMN-LABEL "Itm"
pnc-ccbddocu.codmat     FORMAT 'x(8)'       COLUMN-LABEL "Articulo"
pnc-ccbddocu.candes     FORMAT '->>,>>9.99' COLUMN-LABEL "Cant."
pnc-ccbddocu.undvta     FORMAT 'x(5)'       COLUMN-LABEL "Und.Vta"
pnc-ccbddocu.preuni     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio"
pnc-ccbddocu.impigv     FORMAT '->>,>>9.99' COLUMN-LABEL "I.G.V"
pnc-ccbddocu.implin     FORMAT '->>,>>9.99' COLUMN-LABEL "Imp.Fila"
almmmatg.desmat         FORMAT 'x(60)'   COLUMN-LABEL "Descripcion Articulo"
almmmatg.desmar         FORMAT 'x(50)'  COLUMN-LABEL "Marca"
                   
 /*
 DEFINE TEMP-TABLE pnc-ccbddocu
    FIELD   codcia  LIKE    Ccbddocu.codcia
    FIELD   coddiv  LIKE    Ccbddocu.coddiv
    FIELD   coddoc  LIKE    Ccbddocu.coddoc
    FIELD   nrodoc  LIKE    Ccbddocu.nrodoc
    FIELD   fchdoc  LIKE    Ccbddocu.fchdoc
    FIELD   nroitm  LIKE    Ccbddocu.nroitm
    FIELD   codmat  LIKE    Ccbddocu.codmat
    FIELD   factor  LIKE    Ccbddocu.factor
    FIELD   candes  LIKE    Ccbddocu.candes
    FIELD   preuni  LIKE    Ccbddocu.preuni
    FIELD   implin  LIKE    Ccbddocu.implin
    FIELD   undvta  LIKE    Ccbddocu.undvta
    FIELD   flg_factor  LIKE Ccbddocu.flg_factor
    FIELD   aftigv  LIKE    Ccbddocu.aftigv
    FIELD   impigv  LIKE    Ccbddocu.impigv.

 */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63.29 BY 12.19
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 D-Dialog _FREEFORM
  QUERY BROWSE-9 DISPLAY
      tt-clientes-calculo.tcodcli FORMAT 'x(15)'  COLUMN-LABEL "Codigo"
tt-clientes-calculo.tnomcli FORMAT 'x(60)'  COLUMN-LABEL "Nombre del Cliente"
tt-clientes-calculo.truc FORMAT 'x(15)'  COLUMN-LABEL "R.U.C."
tt-clientes-calculo.tagrupador FORMAT 'x(25)'  COLUMN-LABEL "Agrupador"
tt-clientes-calculo.tventas FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp.Ventas"
tt-clientes-calculo.tcobros FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp. Cobrado"
tt-clientes-calculo.tfactorpremio FORMAT '->,>>9.99'  COLUMN-LABEL "% Premio"
tt-clientes-calculo.timppremio FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp. Premio"
tt-clientes-calculo.tpremiocalc FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Imp. Premio N/C"
tt-clientes-calculo.tventasgrp FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Vtas Grupo"
tt-clientes-calculo.tcobrosgrp FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Cobrado Grupo"
tt-clientes-calculo.tmeta1 FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Meta #1"
tt-clientes-calculo.tmeta2 FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Meta #2"
tt-clientes-calculo.tmeta3 FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Meta #3"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77.14 BY 16.62
         FONT 4 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-9 AT ROW 1.12 COL 1.72 WIDGET-ID 200
     BROWSE-11 AT ROW 1.15 COL 79.57 WIDGET-ID 300
     BROWSE-12 AT ROW 6.69 COL 79.72 WIDGET-ID 400
     Btn_OK AT ROW 18 COL 45.14
     Btn_Help AT ROW 17.96 COL 5.86
     Btn_Cancel AT ROW 17.96 COL 25.57
     SPACE(103.56) SKIP(0.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Clientes premiados" WIDGET-ID 100.


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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-9 1 D-Dialog */
/* BROWSE-TAB BROWSE-11 BROWSE-9 D-Dialog */
/* BROWSE-TAB BROWSE-12 BROWSE-11 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-11
/* Query rebuild information for BROWSE BROWSE-11
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH pnc-ccbcdocu NO-LOCK
                            WHERE pnc-ccbcdocu.codcli = x-cliente.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-11 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH pnc-ccbddocu NO-LOCK
                        WHERE pnc-ccbddocu.coddoc = x-coddoc AND
                                pnc-ccbddocu.nrodoc = x-nrodoc,
                    FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                            almmmatg.codmat = pnc-ccbddocu.codmat NO-LOCK.
                                        .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH tt-clientes-calculo NO-LOCK
    WHERE tt-clientes-calculo.timppremio > 0
    BY tt-clientes-calculo.tagrupador DESC BY tt-clientes-calculo.tvtaslinpremiadas DESC

    /*
    */
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
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
ON END-ERROR OF FRAME D-Dialog /* Clientes premiados */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Clientes premiados */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&Scoped-define SELF-NAME BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 D-Dialog
ON ENTRY OF BROWSE-11 IN FRAME D-Dialog
DO:
    x-coddoc = "".
    x-nrodoc = "".
    IF AVAILABLE pnc-ccbcdocu THEN DO:
        x-coddoc = pnc-ccbcdocu.coddoc.
        x-nrodoc = pnc-ccbcdocu.nrodoc.
    END.

    {&open-query-browse-12}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 D-Dialog
ON VALUE-CHANGED OF BROWSE-11 IN FRAME D-Dialog
DO:
    x-coddoc = "".
    x-nrodoc = "".
    IF AVAILABLE pnc-ccbcdocu THEN DO:
        x-coddoc = pnc-ccbcdocu.coddoc.
        x-nrodoc = pnc-ccbcdocu.nrodoc.
    END.

    {&open-query-browse-12}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
&Scoped-define SELF-NAME BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 D-Dialog
ON ENTRY OF BROWSE-9 IN FRAME D-Dialog
DO:
    x-cliente = "".
    IF AVAILABLE tt-clientes-calculo THEN DO:
        x-cliente = tt-clientes-calculo.tcodcli.
    END.

    {&open-query-browse-11}

    APPLY 'VALUE-CHANGED':U TO BROWSE-11.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 D-Dialog
ON VALUE-CHANGED OF BROWSE-9 IN FRAME D-Dialog
DO:
    x-cliente = "".
    IF AVAILABLE tt-clientes-calculo THEN DO:
        x-cliente = tt-clientes-calculo.tcodcli.
    END.

    {&open-query-browse-11}

    /**/
    APPLY 'VALUE-CHANGED':U TO BROWSE-11.
  
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Grabar las PRE-NOTAS DE CREDITO */
DO:

    DEFINE VAR x-msg AS CHAR.

    btn_ok:AUTO-GO = NO.    /* del Boton OK */      

    /*
    MESSAGE "Aun NO implementado" VIEW-AS ALERT-BOX INFORMATION.
    */
    
    btn_ok:AUTO-GO = NO.    /* del Boton OK */      
    pProcesado = NO.

    
    MESSAGE 'Seguro de grabar el proceso?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.

    IF rpta = YES THEN DO:
       x-msg = "".

       RUN grabar-pnc(OUTPUT x-msg).

       IF x-msg = 'OK' THEN DO:
           pProcesado = YES.            
           btn_ok:AUTO-GO = YES.
       END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
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
  ENABLE BROWSE-9 BROWSE-11 BROWSE-12 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-pnc D-Dialog 
PROCEDURE grabar-pnc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pExito AS CHAR.

DEFINE VAR x-serie AS INT.
DEFINE VAR x-numero AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

GRABAR:
DO TRANSACTION ON ERROR UNDO GRABAR, LEAVE GRABAR : 
    DO:
        /* El correlativo de la PNC */
        FIND FIRST Faccorre WHERE  Faccorre.CodCia = S-CODCIA 
            AND Faccorre.CodDoc = X-CODDOC 
            AND Faccorre.CodDiv = S-CODDIV 
            AND Faccorre.FlgEst = YES EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED faccorre THEN DO:
            pExito = "La tabla FACCORRE esta bloqueada por otro usuario".
            UNDO GRABAR, LEAVE GRABAR.
        END.                                  
        ELSE DO:
            IF NOT AVAILABLE faccorre THEN DO:
                pExito = 'Correlativo no asignado a la división (' + s-coddiv + ")".
                UNDO GRABAR, LEAVE GRABAR.
            END.
        END.
        /* --------------------------- */
        x-serie = FacCorre.nroser.
        x-numero = Faccorre.correlativo.

        /* Limpio valores */
        FOR EACH pnc-ccbcdocu :
            ASSIGN pnc-ccbcdocu.libre_c99 = ""
                    pnc-ccbcdocu.flg-num = "".
        END.

        /* Genero el correltativo correcto de las PNC */
        FOR EACH pnc-ccbcdocu :
            x-numero = x-numero + 1.
            ASSIGN pnc-ccbcdocu.libre_c99 = STRING(x-serie,"999") + STRING(x-numero,"99999999") NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                pExito = "0.- " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR, LEAVE GRABAR.
            END.

        END.

        /* Los renumero con el correcto */
        FOR EACH pnc-ccbcdocu WHERE pnc-ccbcdocu.flg-num = "":
            /* El detalle */
            FOR EACH pnc-ccbddocu WHERE pnc-ccbddocu.coddoc = pnc-ccbcdocu.coddoc AND
                                            pnc-ccbddocu.nrodoc = pnc-ccbcdocu.nrodoc :

                /* Correlativo Correcto */
                ASSIGN pnc-ccbddocu.nrodoc = pnc-ccbcdocu.libre_c99 NO-ERROR.

                IF ERROR-STATUS:ERROR THEN DO:
                    pExito = "1.- " + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR, LEAVE GRABAR.
                END.

            END.
            /* La cabecera */
            ASSIGN pnc-ccbcdocu.nrodoc = pnc-ccbcdocu.libre_c99
                    pnc-ccbcdocu.flg-num = 'X' NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                pExito = "2.- " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR, LEAVE GRABAR.
            END.

        END.

        /* Actualizo tabla de correlativos */
        ASSIGN Faccorre.correlativo = x-numero NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pExito = "3.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE GRABAR.
        END.
                
        /* Creo las PNC en las tablas de reales */
        FOR EACH pnc-ccbcdocu :
            /* La cabecera */
            CREATE ccbcdocu.
            BUFFER-COPY pnc-ccbcdocu TO ccbcdocu NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                pExito = "4.- " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR, LEAVE GRABAR.
            END.

            FOR EACH pnc-ccbddocu WHERE pnc-ccbddocu.coddoc = pnc-ccbcdocu.coddoc AND
                                            pnc-ccbddocu.nrodoc = pnc-ccbcdocu.nrodoc :
                /* El detalle */
                CREATE ccbddocu.
                BUFFER-COPY pnc-ccbddocu TO ccbddocu.

                IF ERROR-STATUS:ERROR THEN DO:
                    pExito = "5.- " + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR, LEAVE GRABAR.
                END.
            END.
        END.

        /* OK */
        pExito = 'OK'.
    END.
END.

RELEASE faccorre.
RELEASE ccbcdocu.
RELEASE ccbddocu.

SESSION:SET-WAIT-STATE("").

IF pExito = 'OK' THEN DO:
    MESSAGE "Los datos se Grabaron correctamente"
                VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE "ERROR al grabar los datos " SKIP
            pExito
            VIEW-AS ALERT-BOX INFORMATION.
END.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-clientes-calculo"}
  {src/adm/template/snd-list.i "pnc-ccbddocu"}
  {src/adm/template/snd-list.i "almmmatg"}
  {src/adm/template/snd-list.i "pnc-ccbcdocu"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda D-Dialog 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR.

  x-retval = 'S/'.
  IF pMoneda = 2 THEN x-retval = "USD".


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

