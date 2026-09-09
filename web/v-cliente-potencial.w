&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-clie FOR gn-cliente-potencial.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

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
DEFINE SHARED VARIABLE S-CODCIA  AS INT.
DEFINE SHARED VARIABLE CL-CODCIA  AS INT.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR pBajaSunat AS LOG NO-UNDO.
DEF VAR pName AS CHAR NO-UNDO.
DEF VAR pAddress AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pResultado AS CHAR NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pDateInscription AS DATE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-cliente-potencial
&Scoped-define FIRST-EXTERNAL-TABLE gn-cliente-potencial


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-cliente-potencial.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-cliente-potencial.CodCli ~
gn-cliente-potencial.TipPersona gn-cliente-potencial.DateInscription ~
gn-cliente-potencial.Ruc gn-cliente-potencial.DNI ~
gn-cliente-potencial.ApePat gn-cliente-potencial.ApeMat ~
gn-cliente-potencial.Nombre gn-cliente-potencial.NomCli ~
gn-cliente-potencial.DirCli gn-cliente-potencial.Telfnos[1] ~
gn-cliente-potencial.e-mail-contacto ~
gn-cliente-potencial.e-mail-facturacion gn-cliente-potencial.Canal ~
gn-cliente-potencial.GirCli gn-cliente-potencial.SecEco ~
gn-cliente-potencial.CodDept gn-cliente-potencial.CodProv ~
gn-cliente-potencial.CodDist 
&Scoped-define ENABLED-TABLES gn-cliente-potencial
&Scoped-define FIRST-ENABLED-TABLE gn-cliente-potencial
&Scoped-Define DISPLAYED-FIELDS gn-cliente-potencial.CodCli ~
gn-cliente-potencial.TipPersona gn-cliente-potencial.DateInscription ~
gn-cliente-potencial.Ruc gn-cliente-potencial.DNI ~
gn-cliente-potencial.ApePat gn-cliente-potencial.ApeMat ~
gn-cliente-potencial.Nombre gn-cliente-potencial.NomCli ~
gn-cliente-potencial.DirCli gn-cliente-potencial.Telfnos[1] ~
gn-cliente-potencial.e-mail-contacto ~
gn-cliente-potencial.e-mail-facturacion gn-cliente-potencial.Canal ~
gn-cliente-potencial.GirCli gn-cliente-potencial.SecEco ~
gn-cliente-potencial.CodDept gn-cliente-potencial.CodProv ~
gn-cliente-potencial.CodDist 
&Scoped-define DISPLAYED-TABLES gn-cliente-potencial
&Scoped-define FIRST-DISPLAYED-TABLE gn-cliente-potencial
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado F-NomCanal F-giro f-Sector ~
FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomCanal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE f-Sector AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1.08
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-cliente-potencial.CodCli AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 42
          LABEL "Código del Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-Estado AT ROW 1.27 COL 89 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     gn-cliente-potencial.TipPersona AT ROW 2.08 COL 31 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U,
"Extranjera", "E":U
          SIZE 28 BY .81
     gn-cliente-potencial.DateInscription AT ROW 2.81 COL 70 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-cliente-potencial.Ruc AT ROW 2.88 COL 29 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-cliente-potencial.DNI AT ROW 3.69 COL 29 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-cliente-potencial.ApePat AT ROW 4.5 COL 29 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     gn-cliente-potencial.ApeMat AT ROW 5.31 COL 29 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     gn-cliente-potencial.Nombre AT ROW 6.12 COL 29 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     gn-cliente-potencial.NomCli AT ROW 6.92 COL 15.14 WIDGET-ID 26
          LABEL "Nombre/Razón Social"
          VIEW-AS FILL-IN 
          SIZE 100.72 BY .81
     gn-cliente-potencial.DirCli AT ROW 7.73 COL 29 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-cliente-potencial.Telfnos[1] AT ROW 8.54 COL 29 COLON-ALIGNED WIDGET-ID 32
          LABEL "Teléfono"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-cliente-potencial.e-mail-contacto AT ROW 9.35 COL 29 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-cliente-potencial.e-mail-facturacion AT ROW 10.15 COL 29 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-cliente-potencial.Canal AT ROW 10.96 COL 29 COLON-ALIGNED WIDGET-ID 6
          LABEL "Grupo de cliente (Canal)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-NomCanal AT ROW 10.96 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 172
     gn-cliente-potencial.GirCli AT ROW 11.77 COL 29 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-giro AT ROW 11.77 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     gn-cliente-potencial.SecEco AT ROW 12.58 COL 29 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     f-Sector AT ROW 12.58 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     gn-cliente-potencial.CodDept AT ROW 13.38 COL 29 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DEP AT ROW 13.38 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     gn-cliente-potencial.CodProv AT ROW 14.19 COL 29 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-PROV AT ROW 14.19 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     gn-cliente-potencial.CodDist AT ROW 15 COL 29 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-DIS AT ROW 15 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     "Persona:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.08 COL 24 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-cliente-potencial
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-clie B "?" ? INTEGRAL gn-cliente-potencial
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 15.81
         WIDTH              = 132.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-cliente-potencial.Canal IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-cliente-potencial.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCanal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Sector IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-Estado:AUTO-RESIZE IN FRAME F-Main      = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-cliente-potencial.NomCli IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN gn-cliente-potencial.Telfnos[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gn-cliente-potencial.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.ApeMat V-table-Win
ON LEAVE OF gn-cliente-potencial.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-cliente-potencial.NomCli:SCREEN-VALUE = TRIM (gn-cliente-potencial.ApePat:SCREEN-VALUE) + " " +
        TRIM (gn-cliente-potencial.ApePat:SCREEN-VALUE) + ", " +
        gn-cliente-potencial.Nombre:SCREEN-VALUE.
    IF gn-cliente-potencial.ApePat:SCREEN-VALUE = '' AND gn-cliente-potencial.ApeMat:SCREEN-VALUE = '' 
    THEN gn-cliente-potencial.NomCli:SCREEN-VALUE = gn-cliente-potencial.Nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.ApePat V-table-Win
ON LEAVE OF gn-cliente-potencial.ApePat IN FRAME F-Main /* Ap. Paterno / Razón Social */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-cliente-potencial.NomCli:SCREEN-VALUE = TRIM (gn-cliente-potencial.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-cliente-potencial.apemat:SCREEN-VALUE) + ", " +
        gn-cliente-potencial.nombre:SCREEN-VALUE.
    IF gn-cliente-potencial.apepat:SCREEN-VALUE = '' AND gn-cliente-potencial.apemat:SCREEN-VALUE = '' 
    THEN gn-cliente-potencial.nomcli:SCREEN-VALUE = gn-cliente-potencial.nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.Canal V-table-Win
ON LEAVE OF gn-cliente-potencial.Canal IN FRAME F-Main /* Grupo de cliente (Canal) */
DO:
  F-NomCanal:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.

  FIND Almtabla WHERE Almtabla.Tabla = "CN" AND 
      Almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN F-NomCanal:SCREEN-VALUE = Almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.Canal V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.Canal IN FRAME F-Main /* Grupo de cliente (Canal) */
OR F8 OF gn-cliente-potencial.Canal DO:
    ASSIGN
      input-var-1 = 'CN'
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?            /* Rowid */
      output-var-2 = ''
      output-var-3 = ''.

    RUN lkup/C-ALMTAB ('Grupos de Cliente').
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
    SELF:SCREEN-VALUE  = output-var-2 .
    f-nomcanal:SCREEN-VALUE = output-var-3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodCli V-table-Win
ON LEAVE OF gn-cliente-potencial.CodCli IN FRAME F-Main /* Código del Cliente */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  /* OJO */
  IF CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
              gn-clie.codcli = gn-cliente-potencial.CodCli:SCREEN-VALUE NO-LOCK)
      THEN DO:
      MESSAGE 'Código del cliente potencial ya registrado en el Maestro de Clientes' 
          VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.


  /* Verificar la Longitud */
  DEFINE VAR x-data AS CHAR.

  x-data = TRIM(SELF:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.
  SELF:SCREEN-VALUE = x-data.

  DEFINE VAR x-valor AS INT64.
  DEFINE VAR x-dni AS CHAR.

  ASSIGN 
      x-valor = INT64(TRIM(SELF:SCREEN-VALUE))
      NO-ERROR.
  CASE TRUE:
      WHEN LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,15,17,20') > 0 AND LENGTH(SELF:SCREEN-VALUE) = 11 THEN DO:
          gn-cliente-potencial.Ruc:SCREEN-VALUE = SELF:SCREEN-VALUE.
          CASE SUBSTRING(SELF:SCREEN-VALUE,1,2):
              WHEN "20" THEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "J".
              WHEN "10" OR WHEN "15" THEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "N".
              WHEN "17" THEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "E".
          END CASE.
          gn-cliente-potencial.Ruc:SCREEN-VALUE = SELF:SCREEN-VALUE.
      END.
  END CASE.
  RUN habilitar-campos(INPUT gn-cliente-potencial.TipPersona:SCREEN-VALUE).
  APPLY 'LEAVE':U TO gn-cliente-potencial.Ruc IN FRAME {&FRAME-NAME}.

  {&SELF-NAME}:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodDept V-table-Win
ON LEAVE OF gn-cliente-potencial.CodDept IN FRAME F-Main /* Departamento */
DO:
  Fill-in-dep:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  FIND  TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN Fill-in-dep:SCREEN-VALUE = TabDepto.NomDepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodDept V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.CodDept IN FRAME F-Main /* Departamento */
OR F8 OF gn-cliente-potencial.CodDept DO:
  input-var-1 = ''.
  input-var-2 = ''.
  input-var-3 = ''.
  output-var-1 = ?.
  RUN lkup/c-depart.w ('Seleccione el Departamento').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
      FILL-IN-DEP:SCREEN-VALUE = output-var-3.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodDist V-table-Win
ON LEAVE OF gn-cliente-potencial.CodDist IN FRAME F-Main /* Distrito */
DO:
  Fill-in-dis:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.

  FIND Tabdistr WHERE Tabdistr.CodDepto = gn-cliente-potencial.CodDept:SCREEN-VALUE AND
      Tabdistr.Codprovi = gn-cliente-potencial.CodProv:SCREEN-VALUE AND
      Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Tabdistr THEN Fill-in-dis:SCREEN-VALUE = Tabdistr.Nomdistr .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodDist V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.CodDist IN FRAME F-Main /* Distrito */
OR F8 OF gn-cliente-potencial.CodDist DO:
  input-var-1 = gn-cliente-potencial.CodDept:SCREEN-VALUE.
  input-var-2 = gn-cliente-potencial.CodProv:SCREEN-VALUE.
  input-var-3 = ''.
  output-var-1 = ?.
  RUN lkup/c-distri.w ('Seleccione el Distrito').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
      FILL-IN-DIS:SCREEN-VALUE = output-var-3.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodProv V-table-Win
ON LEAVE OF gn-cliente-potencial.CodProv IN FRAME F-Main /* Provincias */
DO:
  fill-in-prov:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.

  FIND Tabprovi WHERE Tabprovi.CodDepto = gn-cliente-potencial.CodDept:SCREEN-VALUE AND
      Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Tabprovi THEN fill-in-prov:SCREEN-VALUE = Tabprovi.Nomprovi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.CodProv V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.CodProv IN FRAME F-Main /* Provincias */
OR F8 OF gn-cliente-potencial.CodProv DO:
  input-var-1 = gn-cliente-potencial.CodDept:SCREEN-VALUE.
  input-var-2 = ''.
  input-var-3 = ''.
  output-var-1 = ?.
  RUN lkup/c-provin.w ('Seleccione la Provincia').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
      FILL-IN-PROV:SCREEN-VALUE = output-var-3.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.DNI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.DNI V-table-Win
ON LEAVE OF gn-cliente-potencial.DNI IN FRAME F-Main /* DNI */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    DEF VAR x-Integer AS INT NO-UNDO.
    /* Dígito Verificador */
    ASSIGN 
        x-Integer = INTEGER(SELF:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR LENGTH(SELF:SCREEN-VALUE) < 8 THEN DO:
        MESSAGE 'Debe tener 8 caracteres numéricos como mínimo' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /**/
    DEFINE VAR x-valor AS INT.

    x-valor = INT(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF TRUE <> (gn-cliente-potencial.Ruc:SCREEN-VALUE > '') THEN DO:
        /* Solo en caso de no tener un RUC  registrado en SUNAT, es decir, que sea una persona sin negocio */
        IF LENGTH(SELF:SCREEN-VALUE) = 8 
            THEN gn-cliente-potencial.TipPersona:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'N'.
            ELSE gn-cliente-potencial.TipPersona:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'E'.
    END.
    APPLY 'VALUE-CHANGED':U TO gn-cliente-potencial.TipPersona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.GirCli V-table-Win
ON LEAVE OF gn-cliente-potencial.GirCli IN FRAME F-Main /* Giro */
DO:
  F-giro:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.

  FIND Vtatabla WHERE Vtatabla.codcia = s-codcia AND
      Vtatabla.tabla = "CN-GN" AND
      Vtatabla.llave_c1 = gn-cliente-potencial.Canal:SCREEN-VALUE AND
      Vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Vtatabla THEN DO:
      FIND Almtabla WHERE Almtabla.codigo = SELF:SCREEN-VALUE AND
          Almtabla.tabla = "GN"
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN F-giro:SCREEN-VALUE = Almtabla.Nombre.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.GirCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.GirCli IN FRAME F-Main /* Giro */
OR f8 OF gn-cliente-potencial.GirCli DO:
    DEFINE VAR x-grupo AS CHAR.

    ASSIGN
      input-var-1 = 'CN-GN'
      input-var-2 = gn-cliente-potencial.Canal:SCREEN-VALUE
      input-var-3 = 'GN'
      output-var-1 = ?            /* Rowid */
      output-var-2 = ''
      output-var-3 = ''.

    RUN lkup/c-grupo-giro-clientes ("TABLA DE CONTROL GRUPO GIRO").
    IF output-var-1 = ? THEN RETURN "ADM-ERROR".
    SELF:SCREEN-VALUE   = output-var-2 .
    F-giro:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.Nombre V-table-Win
ON LEAVE OF gn-cliente-potencial.Nombre IN FRAME F-Main /* Nombres */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-cliente-potencial.NomCli:SCREEN-VALUE = TRIM (gn-cliente-potencial.apepat:SCREEN-VALUE) + " " +
        TRIM(gn-cliente-potencial.apemat:SCREEN-VALUE) + ", " +
        gn-cliente-potencial.nombre:SCREEN-VALUE.
    IF gn-cliente-potencial.apepat:SCREEN-VALUE = '' AND gn-cliente-potencial.apemat:SCREEN-VALUE = '' 
    THEN gn-cliente-potencial.nomcli:SCREEN-VALUE = gn-cliente-potencial.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.NomCli V-table-Win
ON LEAVE OF gn-cliente-potencial.NomCli IN FRAME F-Main /* Nombre/Razón Social */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.Ruc V-table-Win
ON LEAVE OF gn-cliente-potencial.Ruc IN FRAME F-Main /* RUC */
DO:
    DEFINE VAR x-manual AS LOG INIT NO.
    DEFINE VAR x-requiere-validacion-sunat AS LOG.

    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    RUN requiere-validar-con-sunat(INPUT 'RUC', OUTPUT x-requiere-validacion-sunat).
    pBajaSunat = NO.
    IF x-requiere-validacion-sunat = YES THEN DO:
        /* Verificamos Información SUNAT */
        RUN gn/datos-sunat-clientes.r (
            INPUT SELF:SCREEN-VALUE,
            OUTPUT pBajaSunat,
            OUTPUT pName,
            OUTPUT pAddress,
            OUTPUT pUbigeo,
            OUTPUT pDateInscription,
            OUTPUT pError ).
        IF pError > '' THEN DO:
            pBajaSunat = NO.
            x-manual = YES.
        END.
    END.
    ELSE x-manual = YES.
    IF x-manual = NO THEN DO:
        DISPLAY 
            pName @ gn-cliente-potencial.Nombre
            pName @ gn-cliente-potencial.NomCli
            pAddress @ gn-cliente-potencial.DirCli
            WITH FRAME {&FRAME-NAME}.
        DISPLAY
            SUBSTRING(pUbigeo,1,2) @  gn-cliente-potencial.CodDept
            SUBSTRING(pUbigeo,3,2) @  gn-cliente-potencial.CodProv
            SUBSTRING(pUbigeo,5,2) @  gn-cliente-potencial.CodDist
            pDateInscription @ gn-cliente-potencial.DateInscription
            WITH FRAME {&FRAME-NAME}.
        IF x-manual = NO THEN DO:
            APPLY 'LEAVE':U TO gn-cliente-potencial.CodDept.
            APPLY 'LEAVE':U TO gn-cliente-potencial.CodProv.
            APPLY 'LEAVE':U TO gn-cliente-potencial.CodDist.
            DISABLE gn-cliente-potencial.CodDept gn-cliente-potencial.CodProv gn-cliente-potencial.CodDist WITH FRAME {&FRAME-NAME}.
        END.
        /* ****************************************************************************************** */
        /* Hay o no hay data de sunat? */
        /* ****************************************************************************************** */
        IF TRUE <> (gn-cliente-potencial.CodDept > '') OR
            TRUE <> (gn-cliente-potencial.CodProv > '') OR
            TRUE <> (gn-cliente-potencial.CodDist > '')
            THEN ENABLE gn-cliente-potencial.CodDept gn-cliente-potencial.CodProv gn-cliente-potencial.CodDist WITH FRAME {&FRAME-NAME}.
        IF TRIM(pAddress) = "-" THEN ENABLE gn-cliente-potencial.DirCli WITH FRAME {&FRAME-NAME}.
        /* ****************************************************************************************** */
        /* ****************************************************************************************** */
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.SecEco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.SecEco V-table-Win
ON LEAVE OF gn-cliente-potencial.SecEco IN FRAME F-Main /* Sector Económico */
DO:
  F-sector:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.

  FIND Almtabla WHERE Almtabla.Tabla = "SE" AND 
      Almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN F-sector:SCREEN-VALUE = Almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.SecEco V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-cliente-potencial.SecEco IN FRAME F-Main /* Sector Económico */
OR F8 OF gn-cliente-potencial.SecEco DO:
    ASSIGN
      input-var-1 = 'SE'
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?            /* Rowid */
      output-var-2 = ''
      output-var-3 = ''.

    RUN lkup/C-ALMTAB ('Sector Económico').
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
    SELF:SCREEN-VALUE  = output-var-2 .
    f-Sector:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-cliente-potencial.TipPersona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-cliente-potencial.TipPersona V-table-Win
ON VALUE-CHANGED OF gn-cliente-potencial.TipPersona IN FRAME F-Main /* TipPersona */
DO:
  RUN habilitar-campos(INPUT SELF:SCREEN-VALUE).
  APPLY 'LEAVE':U TO gn-cliente-potencial.ApePat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "gn-cliente-potencial"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-cliente-potencial"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitar-campos V-table-Win 
PROCEDURE habilitar-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoPersona AS CHAR.

DO WITH FRAME {&FRAME-NAME} :
    IF pTipoPersona = "J"
        THEN ASSIGN
        gn-cliente-potencial.ApeMat:SENSITIVE = NO
        gn-cliente-potencial.ApePat:SENSITIVE = NO
        gn-cliente-potencial.Nombre:SENSITIVE = NO
        gn-cliente-potencial.NomCli:SENSITIVE = YES
        gn-cliente-potencial.DNI:SENSITIVE = NO
        gn-cliente-potencial.ApeMat:SCREEN-VALUE = ''
        gn-cliente-potencial.ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        gn-cliente-potencial.DirCli:SENSITIVE = YES
        gn-cliente-potencial.ApeMat:SENSITIVE = YES
        gn-cliente-potencial.ApePat:SENSITIVE = YES
        gn-cliente-potencial.Nombre:SENSITIVE = YES
        gn-cliente-potencial.NomCli:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      ASSIGN
          gn-cliente-potencial.User_Update = s-user-id
          gn-cliente-potencial.Date_Update = TODAY
          gn-cliente-potencial.Hour_Update = STRING(TIME,'HH:MM:SS')
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      gn-cliente-potencial.User_Create = s-user-id
      gn-cliente-potencial.Date_Create = TODAY
      gn-cliente-potencial.Hour_Create = STRING(TIME,'HH:MM:SS')
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE gn-cliente-potencial THEN DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-Estado:SCREEN-VALUE = ''.
      CASE gn-cliente-potencial.Estado:
          WHEN "P" THEN FILL-IN-Estado:SCREEN-VALUE = "REGISTRADO".
          WHEN "C" THEN FILL-IN-Estado:SCREEN-VALUE = "EN MAESTRO DE CLIENTES".
      END CASE.

      F-NomCanal:SCREEN-VALUE = "".
      FIND Almtabla WHERE Almtabla.Tabla = "CN" AND 
          Almtabla.Codigo = gn-cliente-potencial.Canal NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN F-NomCanal:SCREEN-VALUE = Almtabla.Nombre.

      F-giro:SCREEN-VALUE = "".
      FIND Vtatabla WHERE Vtatabla.codcia = s-codcia AND
          Vtatabla.tabla = "CN-GN" AND
          Vtatabla.llave_c1 = gn-cliente-potencial.Canal AND
          Vtatabla.llave_c2 = gn-cliente-potencial.GirCli NO-LOCK NO-ERROR.
      IF AVAILABLE Vtatabla THEN DO:
          FIND Almtabla WHERE Almtabla.codigo = gn-cliente-potencial.GirCli AND
              Almtabla.tabla = "GN"
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtabla THEN F-giro:SCREEN-VALUE = Almtabla.Nombre.
      END.

      F-sector:SCREEN-VALUE = "".
      FIND Almtabla WHERE Almtabla.Tabla = "SE" AND 
          Almtabla.Codigo = gn-cliente-potencial.SecEco NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN F-sector:SCREEN-VALUE = Almtabla.Nombre.

      Fill-in-dep:SCREEN-VALUE = "".
      FIND  TabDepto WHERE TabDepto.CodDepto = gn-cliente-potencial.CodDept NO-LOCK NO-ERROR.
      IF AVAILABLE TabDepto THEN Fill-in-dep:SCREEN-VALUE = TabDepto.NomDepto.

      fill-in-prov:SCREEN-VALUE = "".
      FIND Tabprovi WHERE Tabprovi.CodDepto = gn-cliente-potencial.CodDept AND
          Tabprovi.Codprovi = gn-cliente-potencial.CodProv NO-LOCK NO-ERROR.
      IF AVAILABLE Tabprovi THEN fill-in-prov:SCREEN-VALUE = Tabprovi.Nomprovi.

      Fill-in-dis:SCREEN-VALUE = "".
      FIND Tabdistr WHERE Tabdistr.CodDepto = gn-cliente-potencial.CodDept AND
          Tabdistr.Codprovi = gn-cliente-potencial.CodProv AND
          Tabdistr.Coddistr = gn-cliente-potencial.CodDist NO-LOCK NO-ERROR.
      IF AVAILABLE Tabdistr THEN Fill-in-dis:SCREEN-VALUE = Tabdistr.Nomdistr .

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /* Por defecto */
      gn-cliente-potencial.TipPersona:SENSITIVE = NO.
      gn-cliente-potencial.Ruc:SENSITIVE = NO.
      gn-cliente-potencial.NomCli:SENSITIVE = NO.
      gn-cliente-potencial.DateInscription:SENSITIVE = NO.

      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN gn-cliente-potencial.CodCli:SENSITIVE = YES.
      ELSE gn-cliente-potencial.CodCli:SENSITIVE = NO.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requiere-validar-con-sunat V-table-Win 
PROCEDURE requiere-validar-con-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCampo AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

pRetVal = YES.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'VALIDAR_SUNAT' AND
                            factabla.codigo = pCampo NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN pRetVal = factabla.campo-l[1].


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "gn-cliente-potencial"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* VALIDACIONES GENERICAS */
DO WITH FRAME {&FRAME-NAME} :
    IF TRUE <> (gn-cliente-potencial.CodCli:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código del cliente el blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    IF LENGTH(TRIM(gn-cliente-potencial.CodCli:SCREEN-VALUE)) <> 11 THEN DO:
        MESSAGE "Codigo de Cliente debe ser de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO gn-cliente-potencial.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    /* Poner consistencia de registro duplicado o ya registrador en el maestro de clientes */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        IF CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
                    gn-clie.codcli = gn-cliente-potencial.CodCli:SCREEN-VALUE NO-LOCK)
            THEN DO:
            MESSAGE 'Código del cliente potencial ya registrado en el Maestro de Clientes' 
                VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO gn-cliente-potencial.CodCli.
            RETURN 'ADM-ERROR'.
        END.
        IF CAN-FIND(FIRST gn-cliente-potencial WHERE gn-cliente-potencial.CodCia = cl-codcia AND
                    gn-cliente-potencial.CodCli = gn-cliente-potencial.CodCli:SCREEN-VALUE NO-LOCK)
            THEN DO:
            MESSAGE 'Cliente potencila YA registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO gn-cliente-potencial.CodCli.
            RETURN 'ADM-ERROR'.
        END.
    END.

    IF TRUE <> (gn-cliente-potencial.NomCli:SCREEN-VALUE > "") THEN DO:
        MESSAGE "Nombre de Cliente en blanco" VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO gn-cliente-potencial.NomCli.
        RETURN 'ADM-ERROR'.
    END.

    /* Direccion Vacio */
    IF TRUE <> (gn-cliente-potencial.DirCli:SCREEN-VALUE > "") THEN DO:
        gn-cliente-potencial.DirCli:SCREEN-VALUE = TRIM(CAPS(fill-in-dep:SCREEN-VALUE)) + " - " + 
            TRIM(CAPS(fill-in-prov:SCREEN-VALUE)) + " - " + 
            TRIM(CAPS(fill-in-dis:SCREEN-VALUE)).
    END.

    IF TRUE <> (gn-cliente-potencial.e-mail-contacto:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el e-mail del contacto en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.e-mail-contacto.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.e-mail-facturacion:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el e-mail fac. Electr. en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.e-mail-facturacion.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.Telfnos[1]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Teléfono #1 en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.Telfnos[1].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.Canal:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Grupo de cliente (Canal) en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.Canal.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.GirCli:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Giro en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.GirCli.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.SecEco:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Sector Económico en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.SecEco.
        RETURN 'ADM-ERROR'.
    END.

    IF TRUE <> (gn-cliente-potencial.CodDept:SCREEN-VALUE > "") THEN DO:
        MESSAGE 'Debe ingresar el Departamento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.CodDept.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.CodProv:SCREEN-VALUE > "") THEN DO:
        MESSAGE 'Debe ingresar el Departamento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.CodProv.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-cliente-potencial.CodDist:SCREEN-VALUE > "") THEN DO:
        MESSAGE 'Debe ingresar el Departamento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.CodDist.
        RETURN 'ADM-ERROR'.
    END.

END.
/* VALIDACIONES ESPECIALES DEL CLIENTE */
DO WITH FRAME {&FRAME-NAME}:
    CASE TRUE:
        WHEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(gn-cliente-potencial.Ruc:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(gn-cliente-potencial.Ruc:SCREEN-VALUE,1,2), '20') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 20' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-cliente-potencial.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "N" THEN DO:
            IF gn-cliente-potencial.Ruc:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(gn-cliente-potencial.Ruc:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(gn-cliente-potencial.Ruc:SCREEN-VALUE,1,2), '10,15') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 10 o 15' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (gn-cliente-potencial.Ruc:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF TRUE <> (gn-cliente-potencial.DNI:SCREEN-VALUE > '') OR LENGTH(gn-cliente-potencial.DNI:SCREEN-VALUE) <> 8 THEN DO:
                MESSAGE 'Ingrese un DNI válido de 8 caracteres' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.DNI.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "E" THEN DO:
            /* 03/07/2023 Carnet de Extranjería actualmente 9 dígitos Gianella Chirinos S.Leon */
            IF gn-cliente-potencial.Ruc:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(gn-cliente-potencial.Ruc:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(gn-cliente-potencial.Ruc:SCREEN-VALUE,1,2), '17') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 17' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (gn-cliente-potencial.Ruc:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF TRUE <> (gn-cliente-potencial.DNI:SCREEN-VALUE > '') THEN DO:
                MESSAGE 'Ingrese un DNI válido' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.DNI.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
    IF gn-cliente-potencial.Ruc > '' THEN DO:
        DEF VAR x-requiere-validacion-sunat AS LOG INIT NO NO-UNDO.

        RUN requiere-validar-con-sunat (INPUT 'RUC', OUTPUT x-requiere-validacion-sunat).
        pBajaSunat = NO.
        IF x-requiere-validacion-sunat = YES THEN DO:
            /* Verificamos Información SUNAT */
            RUN gn/datos-sunat-clientes.r (
                INPUT gn-cliente-potencial.Ruc,
                OUTPUT pBajaSunat,
                OUTPUT pName,
                OUTPUT pAddress,
                OUTPUT pUbigeo,
                OUTPUT pDateInscription,
                OUTPUT pError ).
            IF pError > '' THEN pBajaSunat = NO.
        END.
        IF pBajaSunat = YES THEN DO:
            MESSAGE 'El RUC está de baja en SUNAT' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO gn-cliente-potencial.Ruc.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.

/* VALIDACIONES ESPECIALES DE E-MAILS */
DO WITH FRAME {&FRAME-NAME}:
    DEF VAR x-Nro-EMails AS INT NO-UNDO.
    DEF VAR x-Item AS INT NO-UNDO.

    IF gn-cliente-potencial.e-mail-contacto:SCREEN-VALUE > '' THEN DO:
        x-Nro-EMails = NUM-ENTRIES(gn-cliente-potencial.e-mail-contacto:SCREEN-VALUE,';').
        DO x-Item = 1 TO x-Nro-EMails:
            RUN gn/valida-email (ENTRY(x-Item,gn-cliente-potencial.e-mail-contacto:SCREEN-VALUE,';'), 
                                 OUTPUT pError).
            IF pError > '' THEN DO:
                MESSAGE 'e-mail mal registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.e-mail-contacto.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.

    IF gn-cliente-potencial.e-mail-facturacion:SCREEN-VALUE > '' THEN DO:
        x-Nro-EMails = NUM-ENTRIES(gn-cliente-potencial.e-mail-facturacion:SCREEN-VALUE,';').
        DO x-Item = 1 TO x-Nro-EMails:
            RUN gn/valida-email (ENTRY(x-Item,gn-cliente-potencial.e-mail-facturacion:SCREEN-VALUE,';'), 
                                 OUTPUT pError).
            IF pError > '' THEN DO:
                MESSAGE 'e-mail mal registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.e-mail-facturacion.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.

END.

/* VALIDACIONES UBIGEO */
DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST Tabdistr WHERE Tabdistr.CodDepto = gn-cliente-potencial.CodDept:SCREEN-VALUE 
        AND Tabdistr.Codprovi = gn-cliente-potencial.CodProv:SCREEN-VALUE
        AND Tabdistr.Coddistr = gn-cliente-potencial.CodDist:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN DO:
        MESSAGE 'Código de Distrito no Registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-cliente-potencial.CodDept.
        RETURN 'ADM-ERROR'.
    END.
END.

/* VALIDACIONES NOMBRES */
DO WITH FRAME {&FRAME-NAME}:
    /* Mostramos los clientes con ruc similares */
    DEF VAR x-Mensaje AS CHAR NO-UNDO.
    IF gn-cliente-potencial.Ruc:SCREEN-VALUE > '' THEN DO:
        RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
        IF RETURN-VALUE = "YES" THEN DO:
            x-Mensaje = ''.
            FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia AND
                b-clie.ruc = gn-cliente-potencial.Ruc:SCREEN-VALUE:
                x-Mensaje = x-Mensaje + (IF x-Mensaje <> '' THEN CHR(10) ELSE '') +
                    b-clie.codcli + ' ' + b-clie.nomcli.
            END.
            IF x-Mensaje <> '' THEN DO:
                MESSAGE 'Los siguientes clientes potenciales tienen el mismo RUC:' SKIP
                    x-Mensaje SKIP(1)
                    'Continuamos con la grabación?'
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    /* Validar Razon Social y Nombres */
    CASE TRUE:
        WHEN gn-cliente-potencial.TipPersona:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(TRIM(gn-cliente-potencial.NomCli:SCREEN-VALUE)) < 5  THEN DO:
                MESSAGE 'Ingrese la razón social correctamente' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.Nombre.
                RETURN 'ADM-ERROR'.
            END.
        END.
        OTHERWISE DO:
            IF LENGTH(TRIM(gn-cliente-potencial.ApePat:SCREEN-VALUE)) < 2  THEN DO:
                MESSAGE 'Ingrese el apellido paterno correctamente' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.ApePat.
                RETURN 'ADM-ERROR'.
            END.
            IF LENGTH(TRIM(gn-cliente-potencial.Nombre:SCREEN-VALUE)) < 2  THEN DO:
                MESSAGE 'Ingrese el nombre correctamente' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-cliente-potencial.Nombre.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.

    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
    DEFINE VAR x-retval AS CHAR.

    RUN gn\master-library.r PERSISTENT SET hProc.

    /**/
    IF LOOKUP(gn-cliente-potencial.TipPersona:SCREEN-VALUE, "N,E") > 0 THEN DO:        /* Apellido Paterno */        
        x-retval = "".
        RUN VALIDA_AP_PATERNO IN hProc (INPUT gn-cliente-potencial.ApePat:SCREEN-VALUE, OUTPUT x-RetVal).
        IF x-RetVal <> "OK" THEN DO:
            DELETE PROCEDURE hProc.
            MESSAGE x-retval VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO gn-cliente-potencial.ApePat.
            RETURN 'ADM-ERROR'.
        END.
        x-retval = "".
        RUN VALIDA_NOMBRE IN hProc (INPUT gn-cliente-potencial.Nombre:SCREEN-VALUE, OUTPUT x-RetVal).
        IF x-RetVal <> "OK" THEN DO:
            DELETE PROCEDURE hProc.
            MESSAGE x-retval VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO gn-cliente-potencial.Nombre.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/* Otras validaciones */
FIND Almtabla WHERE Almtabla.Tabla = "CN" AND 
    Almtabla.Codigo = gn-cliente-potencial.Canal:SCREEN-VALUE NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtabla THEN DO:
    MESSAGE 'Grupo de cliente errado' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO gn-cliente-potencial.Canal.
    RETURN 'ADM-ERROR'.
END.

FIND Vtatabla WHERE Vtatabla.codcia = s-codcia AND
    Vtatabla.tabla = "CN-GN" AND
    Vtatabla.llave_c1 = gn-cliente-potencial.Canal:SCREEN-VALUE AND
    Vtatabla.llave_c2 = gn-cliente-potencial.GirCli:SCREEN-VALUE NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtatabla THEN DO:
    MESSAGE 'Giro del cliente errado' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO gn-cliente-potencial.GirCli.
    RETURN 'ADM-ERROR'.
END.
FIND Almtabla WHERE Almtabla.codigo = gn-cliente-potencial.GirCli:SCREEN-VALUE AND
    Almtabla.tabla = "GN"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtabla THEN DO:
    MESSAGE 'Giro del cliente errado' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO gn-cliente-potencial.GirCli.
    RETURN 'ADM-ERROR'.
END.

FIND Almtabla WHERE Almtabla.Tabla = "SE" AND 
      Almtabla.Codigo = gn-cliente-potencial.SecEco:SCREEN-VALUE NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtabla THEN DO:
    MESSAGE 'Sector Económico errado' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO gn-cliente-potencial.SecEco.
    RETURN 'ADM-ERROR'.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE gn-cliente-potencial AND gn-cliente-potencial.Estado <> "P"
    THEN DO:
    MESSAGE 'Cliente Potencial YA migrado al MAESTRO DE CLIENTES' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

