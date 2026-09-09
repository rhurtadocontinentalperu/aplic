&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-clie FOR gn-clie.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Frame-Win 
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

  Description: from cntnrfrm.w - ADM SmartFrame Template

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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-fmapgo AS CHAR.
DEF SHARED VAR s-codven AS CHAR.

DEF VAR pBajaSunat AS LOG NO-UNDO.
DEF VAR pName AS CHAR NO-UNDO.
DEF VAR pAddress AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pResultado AS CHAR NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pDateInscription AS DATE NO-UNDO.

DEFINE VAR F-CodCli AS CHAR NO-UNDO.
DEFINE VAR x-data AS CHAR NO-UNDO.
DEFINE VAR x-Libre_c01 LIKE gn-clie.Libre_C01 INIT "N" NO-UNDO.

DEFINE VAR f-RucCli AS CHAR NO-UNDO.
DEFINE VAR f-DNICli AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_TipDoc FILL-IN_NroDoc ~
FILL-IN_ApePat FILL-IN_ApeMat FILL-IN_Nombre EDITOR_DirCli FILL-IN_e-mail-1 ~
FILL-IN_e-mail-2 COMBO-BOX_Canal COMBO-BOX_GirCli COMBO-BOX_ClfCom ~
COMBO-BOX_CodDept COMBO-BOX_CodProv COMBO-BOX_CodDist 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_TipDoc FILL-IN_NroDoc ~
FILL-IN_ApePat FILL-IN_ApeMat FILL-IN_Nombre EDITOR_NomCli EDITOR_DirCli ~
FILL-IN_e-mail-1 FILL-IN_e-mail-2 COMBO-BOX_Canal COMBO-BOX_GirCli ~
COMBO-BOX_ClfCom COMBO-BOX_CodDept COMBO-BOX_CodProv COMBO-BOX_CodDist 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX_Canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_ClfCom AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sector Economico" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodDept AS CHARACTER FORMAT "X(256)":U 
     LABEL "Departamento" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodDist AS CHARACTER FORMAT "X(256)":U 
     LABEL "Distrito" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodProv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Provincia" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_GirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Giro" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_TipDoc AS CHARACTER FORMAT "X(256)":U INITIAL "DNI" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "DNI","RUC","CARNET EXTRANJERIA" 
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_DirCli AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 120
     SIZE 40 BY 2 NO-UNDO.

DEFINE VARIABLE EDITOR_NomCli AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 120
     SIZE 40 BY 2 NO-UNDO.

DEFINE VARIABLE FILL-IN_ApeMat AS CHARACTER FORMAT "X(40)":U 
     LABEL "Ape. Materno" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_ApePat AS CHARACTER FORMAT "X(40)":U 
     LABEL "Ape. Paterno" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_e-mail-1 AS CHARACTER FORMAT "X(40)":U 
     LABEL "e-mail fact. electr." 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_e-mail-2 AS CHARACTER FORMAT "X(40)":U 
     LABEL "e-mail de contacto" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Nombre AS CHARACTER FORMAT "X(40)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "X(11)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_TipDoc AT ROW 1 COL 20 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_NroDoc AT ROW 2.08 COL 20 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_ApePat AT ROW 3.15 COL 20 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_ApeMat AT ROW 4.23 COL 20 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Nombre AT ROW 5.31 COL 20 COLON-ALIGNED WIDGET-ID 10
     EDITOR_NomCli AT ROW 6.38 COL 22 NO-LABEL WIDGET-ID 12
     EDITOR_DirCli AT ROW 8.54 COL 22 NO-LABEL WIDGET-ID 16
     FILL-IN_e-mail-1 AT ROW 10.69 COL 20 COLON-ALIGNED WIDGET-ID 22
     FILL-IN_e-mail-2 AT ROW 11.77 COL 20 COLON-ALIGNED WIDGET-ID 46
     COMBO-BOX_Canal AT ROW 12.85 COL 20 COLON-ALIGNED WIDGET-ID 26
     COMBO-BOX_GirCli AT ROW 13.92 COL 20 COLON-ALIGNED WIDGET-ID 48
     COMBO-BOX_ClfCom AT ROW 15 COL 20 COLON-ALIGNED WIDGET-ID 50
     COMBO-BOX_CodDept AT ROW 16.08 COL 20 COLON-ALIGNED WIDGET-ID 40
     COMBO-BOX_CodProv AT ROW 17.15 COL 20 COLON-ALIGNED WIDGET-ID 42
     COMBO-BOX_CodDist AT ROW 18.23 COL 20 COLON-ALIGNED WIDGET-ID 44
     "Dirección:" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 8.54 COL 12 WIDGET-ID 18
     "Razón Social:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 6.38 COL 8 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.72 BY 18.31
         BGCOLOR 15 FGCOLOR 0 FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 5
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-clie B "?" ? INTEGRAL gn-clie
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
  CREATE WINDOW F-Frame-Win ASSIGN
         HEIGHT             = 20.23
         WIDTH              = 64.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB F-Frame-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW F-Frame-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR EDITOR EDITOR_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME COMBO-BOX_Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Canal F-Frame-Win
ON VALUE-CHANGED OF COMBO-BOX_Canal IN FRAME F-Main /* Canal */
DO:
    DEF VAR iCount AS INTE NO-UNDO.

    COMBO-BOX_GirCli:DELETE(COMBO-BOX_GirCli:LIST-ITEM-PAIRS).
    iCount = 0.
    FOR EACH Vtatabla NO-LOCK WHERE VtaTabla.CodCia = s-CodCia 
        AND VtaTabla.Tabla = 'CN-GN'
        AND VtaTabla.Llave_c1 = COMBO-BOX_Canal:SCREEN-VALUE,
        FIRST almtabla WHERE almtabla.Codigo = VtaTabla.Llave_c2
        AND almtabla.Tabla = 'GN':
        COMBO-BOX_GirCli:ADD-LAST(Almtabla.nombre, Vtatabla.llave_c2).
        COMBO-BOX_GirCli:SCREEN-VALUE = Vtatabla.llave_c2.
        iCount = iCount + 1.
        /*IF iCount = 1 THEN COMBO-BOX_GirCli:SCREEN-VALUE = Vtatabla.llave_c2.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodDept F-Frame-Win
ON VALUE-CHANGED OF COMBO-BOX_CodDept IN FRAME F-Main /* Departamento */
DO:
    DEF VAR iCount AS INTE NO-UNDO.

    COMBO-BOX_CodProv:DELETE(COMBO-BOX_CodProv:LIST-ITEM-PAIRS).
    iCount = 0.
    FOR EACH TabProvi NO-LOCK WHERE TabProvi.CodDepto = COMBO-BOX_CodDept:SCREEN-VALUE:
        COMBO-BOX_CodProv:ADD-LAST(TabProvi.NomProvi, TabProvi.CodProvi).
        iCount = iCount + 1.
        IF iCount = 1 THEN COMBO-BOX_CodProv:SCREEN-VALUE = TabProvi.CodProvi.
    END.
    COMBO-BOX_CodDist:DELETE(COMBO-BOX_CodDist:LIST-ITEM-PAIRS).
    iCount = 0.
    FOR EACH TabDistr NO-LOCK WHERE TabDistr.CodDepto = COMBO-BOX_CodDept:SCREEN-VALUE AND
        TabDistr.CodProvi = COMBO-BOX_CodProv:SCREEN-VALUE:
        COMBO-BOX_CodDist:ADD-LAST(TabDistr.NomDistr, TabDistr.CodDistr).
        iCount = iCount + 1.
        IF iCount = 1 THEN COMBO-BOX_CodDist:SCREEN-VALUE = TabDistr.CodDistr.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodProv F-Frame-Win
ON VALUE-CHANGED OF COMBO-BOX_CodProv IN FRAME F-Main /* Provincia */
DO:
    DEF VAR iCount AS INTE NO-UNDO.

    COMBO-BOX_CodDist:DELETE(COMBO-BOX_CodDist:LIST-ITEM-PAIRS).
    iCount = 0.
    FOR EACH TabDistr NO-LOCK WHERE TabDistr.CodDepto = COMBO-BOX_CodDept:SCREEN-VALUE AND
        TabDistr.CodProvi = COMBO-BOX_CodProv:SCREEN-VALUE:
        COMBO-BOX_CodDist:ADD-LAST(TabDistr.NomDistr, TabDistr.CodDistr).
        iCount = iCount + 1.
        IF iCount = 1 THEN COMBO-BOX_CodDist:SCREEN-VALUE = TabDistr.CodDistr.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_TipDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_TipDoc F-Frame-Win
ON VALUE-CHANGED OF COMBO-BOX_TipDoc IN FRAME F-Main /* Documento */
DO:
  IF SELF:SCREEN-VALUE = "RUC" 
      THEN ASSIGN
      FILL-IN_ApeMat:SENSITIVE = NO
      FILL-IN_ApePat:SENSITIVE = NO
      FILL-IN_Nombre:SENSITIVE = NO
      EDITOR_NomCli:SENSITIVE = YES.
  ELSE ASSIGN
      FILL-IN_ApeMat:SENSITIVE = YES
      FILL-IN_ApePat:SENSITIVE = YES
      FILL-IN_Nombre:SENSITIVE = YES
      EDITOR_NomCli:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR_DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR_DirCli F-Frame-Win
ON LEAVE OF EDITOR_DirCli IN FRAME F-Main
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR_NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR_NomCli F-Frame-Win
ON LEAVE OF EDITOR_NomCli IN FRAME F-Main
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApeMat F-Frame-Win
ON LEAVE OF FILL-IN_ApeMat IN FRAME F-Main /* Ape. Materno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    EDITOR_NomCli:SCREEN-VALUE = TRIM (FILL-IN_ApePat:SCREEN-VALUE) + " " +
        TRIM (FILL-IN_ApeMat:SCREEN-VALUE) + ", " +
        FILL-IN_Nombre:SCREEN-VALUE.
    IF TRUE <> (FILL-IN_ApePat:SCREEN-VALUE > '') AND 
        TRUE <> (FILL-IN_ApeMat:SCREEN-VALUE > '')
        THEN EDITOR_NomCli:SCREEN-VALUE = FILL-IN_Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApePat F-Frame-Win
ON LEAVE OF FILL-IN_ApePat IN FRAME F-Main /* Ape. Paterno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    EDITOR_NomCli:SCREEN-VALUE = TRIM (FILL-IN_ApePat:SCREEN-VALUE) + " " +
        TRIM (FILL-IN_ApeMat:SCREEN-VALUE) + ", " +
        FILL-IN_Nombre:SCREEN-VALUE.
    IF TRUE <> (FILL-IN_ApePat:SCREEN-VALUE > '') AND 
        TRUE <> (FILL-IN_ApeMat:SCREEN-VALUE > '')
        THEN EDITOR_NomCli:SCREEN-VALUE = FILL-IN_Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Nombre F-Frame-Win
ON LEAVE OF FILL-IN_Nombre IN FRAME F-Main /* Nombre */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    EDITOR_NomCli:SCREEN-VALUE = TRIM (FILL-IN_ApePat:SCREEN-VALUE) + " " +
        TRIM (FILL-IN_ApeMat:SCREEN-VALUE) + ", " +
        FILL-IN_Nombre:SCREEN-VALUE.
    IF TRUE <> (FILL-IN_ApePat:SCREEN-VALUE > '') AND 
        TRUE <> (FILL-IN_ApeMat:SCREEN-VALUE > '')
        THEN EDITOR_NomCli:SCREEN-VALUE = FILL-IN_Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroDoc F-Frame-Win
ON LEAVE OF FILL-IN_NroDoc IN FRAME F-Main /* Número */
OR RETURN OF FILL-IN_NroDoc OR TAB OF FILL-IN_NroDoc  DO:
  DEFINE VAR x-manual AS LOG INIT NO.
  DEFINE VAR x-requiere-validacion-sunat AS LOG.
  DEF VAR x-Integer AS INT64 NO-UNDO.

  DEF VAR pRpta AS LOG NO-UNDO.

  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  CASE COMBO-BOX_TipDoc:SCREEN-VALUE:
      WHEN "RUC" THEN DO:
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
              DISPLAY pName @ FILL-IN_Nombre WITH FRAME {&FRAME-NAME}.
              EDITOR_NomCli:SCREEN-VALUE = pName.
              EDITOR_DirCli:SCREEN-VALUE = pAddress.
              COMBO-BOX_CodDept:SCREEN-VALUE = SUBSTRING(pUbigeo,1,2).
              COMBO-BOX_CodProv:SCREEN-VALUE = SUBSTRING(pUbigeo,3,2).
              COMBO-BOX_CodDist:SCREEN-VALUE = SUBSTRING(pUbigeo,5,2).
              IF x-manual = NO THEN DO:
                  APPLY 'LEAVE':U TO COMBO-BOX_CodDept.
                  APPLY 'LEAVE':U TO COMBO-BOX_CodProv.
                  APPLY 'LEAVE':U TO COMBO-BOX_CodDist.
                  DISABLE COMBO-BOX_CodDept COMBO-BOX_CodProv COMBO-BOX_CodDist WITH FRAME {&FRAME-NAME}.
              END.
              /* ****************************************************************************************** */
              /* Hay o no hay data de sunat? */
              /* ****************************************************************************************** */
              IF TRUE <> (COMBO-BOX_CodDept > '') OR
                  TRUE <> (COMBO-BOX_CodProv > '') OR
                  TRUE <> (COMBO-BOX_CodDist > '')
                  THEN ENABLE COMBO-BOX_CodDept COMBO-BOX_CodProv COMBO-BOX_CodDist WITH FRAME {&FRAME-NAME}.
              IF TRIM(pAddress) = "-" THEN ENABLE EDITOR_DirCli WITH FRAME {&FRAME-NAME}.
              /* ****************************************************************************************** */
              /* ****************************************************************************************** */
          END.
          IF LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '20') > 0
              THEN DO:
              ASSIGN
                  FILL-IN_ApeMat:SENSITIVE = NO
                  FILL-IN_ApePat:SENSITIVE = NO
                  FILL-IN_Nombre:SENSITIVE = NO
                  EDITOR_NomCli:SENSITIVE = YES.
              APPLY 'ENTRY':U TO EDITOR_NomCli.
          END.
          ELSE DO:
              ASSIGN
                  FILL-IN_ApeMat:SENSITIVE = YES
                  FILL-IN_ApePat:SENSITIVE = YES
                  FILL-IN_Nombre:SENSITIVE = YES
                  EDITOR_NomCli:SENSITIVE = NO.
              APPLY 'ENTRY':U TO FILL-IN_ApePat.
          END.
      END.
      WHEN "DNI" THEN DO:
          /* Dígito Verificador */
          ASSIGN 
              x-Integer = DECIMAL(SELF:SCREEN-VALUE) NO-ERROR.
          IF ERROR-STATUS:ERROR = YES OR LENGTH(TRIM(SELF:SCREEN-VALUE)) <> 8 THEN DO:
              RUN pda/d-message ('Debe tener 8 caracteres numéricos', "ERROR", "", OUTPUT pRpta).
              /*MESSAGE 'Debe tener 8 caracteres numéricos' VIEW-AS ALERT-BOX ERROR.*/
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
      OTHERWISE DO:
          /* Dígito Verificador */
          ASSIGN 
              x-Integer = DECIMAL(SELF:SCREEN-VALUE) NO-ERROR.
          IF ERROR-STATUS:ERROR = YES OR LENGTH(TRIM(SELF:SCREEN-VALUE)) < 8 THEN DO:
              RUN pda/d-message ('Debe tener 8 caracteres numéricos como mínimo', "ERROR", "", OUTPUT pRpta).
              /*MESSAGE 'Debe tener 8 caracteres numéricos como mínimo' VIEW-AS ALERT-BOX ERROR.*/
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Frame-Win 


/* ***************************  Main Block  *************************** */
ON 'RETURN':U OF COMBO-BOX_Canal, COMBO-BOX_ClfCom, COMBO-BOX_CodDept, COMBO-BOX_CodDist, COMBO-BOX_CodProv,
    COMBO-BOX_GirCli, COMBO-BOX_TipDoc, EDITOR_DirCli, EDITOR_NomCli, FILL-IN_ApeMat, FILL-IN_ApePat,
    FILL-IN_e-mail-1, FILL-IN_e-mail-2, FILL-IN_Nombre, FILL-IN_NroDoc /*, FILL-IN_Telfnos*/
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects F-Frame-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available F-Frame-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cliente F-Frame-Win 
PROCEDURE Crea-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pRpta AS LOG NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DO TRANSACTION ON STOP UNDO, RETURN "ADM-ERROR":U ON ERROR UNDO, RETURN "ADM-ERROR":U
   WITH FRAME {&FRAME-NAME}:
   CREATE gn-clie.
   ASSIGN 
       gn-clie.CodCia     = cl-codcia
       gn-clie.CodCli     = F-CodCli 
       gn-clie.NomCli     = EDITOR_NomCli 
       gn-clie.DirCli     = EDITOR_DirCli 
       gn-clie.Ruc        = F-RucCli 
       gn-clie.DNI        = F-DNICli
       /*gn-clie.Telfnos[1] = FILL-IN_Telfnos*/
       gn-clie.clfCli     = "C" 
       gn-clie.CodDept    = COMBO-BOX_CodDept 
       gn-clie.CodProv    = COMBO-BOX_CodProv 
       gn-clie.CodDist    = COMBO-BOX_CodDist 
       gn-clie.CodPais    = "01" 
       gn-clie.CodVen     = s-codven
       gn-clie.CndVta     = s-fmapgo
       gn-clie.Fching     = TODAY 
       gn-clie.usuario    = S-USER-ID 
       gn-clie.TpoCli     = "1"
       gn-clie.CodDiv     = S-CODDIV
       gn-clie.apepat = FILL-IN_ApePat
       gn-clie.apemat = FILL-IN_ApeMat
       gn-clie.Nombre = FILL-IN_Nombre
       gn-clie.Rucold = "No"
       gn-clie.Libre_L01 = NO
       gn-clie.Libre_C01 = x-Libre_C01
       gn-clie.GirCli = COMBO-BOX_GirCli
       /*gn-clie.Libre_F01 = f-DateInscription*/
       NO-ERROR
       .
   IF ERROR-STATUS:ERROR = YES THEN DO:
       {lib/mensaje-de-error.i &MensajeError="pMensaje" }       
       RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).
       UNDO, RETURN "ADM-ERROR".
   END.

   /* 15/05/2023 */
   ASSIGN
       gn-clie.e-mail = FILL-IN_e-mail-2
       gn-clie.Transporte[4] = FILL-IN_e-mail-1
       gn-clie.Canal = COMBO-BOX_Canal
       gn-clie.ClfCom = COMBO-BOX_GirCli
       .

    /* RHC 07.03.05 valores de linea de credito por defecto */
    ASSIGN
        gn-clie.FlgSit = 'A'    /* Activo */
        gn-clie.FlagAut = 'A'   /* Autorizado */
        gn-clie.ClfCli = 'C'.   /* Regular / Malo */
        
   S-CODCLI = gn-clie.CodCli.
   RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                            STRING(gn-clie.codcli, 'x(11)'), "CREATE").
   RELEASE gn-clie.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Frame-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Frame-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX_TipDoc FILL-IN_NroDoc FILL-IN_ApePat FILL-IN_ApeMat 
          FILL-IN_Nombre EDITOR_NomCli EDITOR_DirCli FILL-IN_e-mail-1 
          FILL-IN_e-mail-2 COMBO-BOX_Canal COMBO-BOX_GirCli COMBO-BOX_ClfCom 
          COMBO-BOX_CodDept COMBO-BOX_CodProv COMBO-BOX_CodDist 
      WITH FRAME F-Main.
  ENABLE COMBO-BOX_TipDoc FILL-IN_NroDoc FILL-IN_ApePat FILL-IN_ApeMat 
         FILL-IN_Nombre EDITOR_DirCli FILL-IN_e-mail-1 FILL-IN_e-mail-2 
         COMBO-BOX_Canal COMBO-BOX_GirCli COMBO-BOX_ClfCom COMBO-BOX_CodDept 
         COMBO-BOX_CodProv COMBO-BOX_CodDist 
      WITH FRAME F-Main.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize F-Frame-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR iCount AS INTE NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_Canal:DELETE(1).
      FOR EACH Almtabla NO-LOCK WHERE Almtabla.tabla = 'CN':
          COMBO-BOX_Canal:ADD-LAST(almtabla.Codigo + " - " + almtabla.Nombre, almtabla.Codigo).
          IF almtabla.Codigo = "C004" THEN COMBO-BOX_Canal = almtabla.Codigo.
      END.

      COMBO-BOX_GirCli:DELETE(1).
      iCount = 0.
      FOR EACH Vtatabla NO-LOCK WHERE VtaTabla.CodCia = s-CodCia 
          AND VtaTabla.Tabla = 'CN-GN'
          AND VtaTabla.Llave_c1 = COMBO-BOX_Canal,
          FIRST almtabla WHERE almtabla.Codigo = VtaTabla.Llave_c2
          AND almtabla.Tabla = 'GN':
          COMBO-BOX_GirCli:ADD-LAST(Almtabla.nombre, Vtatabla.llave_c2).
          COMBO-BOX_GirCli = Vtatabla.llave_c2.
          iCount = iCount + 1.
          /*IF iCount = 1 THEN COMBO-BOX_GirCli = Vtatabla.llave_c2.*/
      END.

      COMBO-BOX_ClfCom:DELETE(1).
      iCount = 0.
      FOR EACH Almtabla NO-LOCK WHERE AlmTabla.Tabla = 'SE':
          COMBO-BOX_ClfCom:ADD-LAST(Almtabla.nombre, Almtabla.codigo).
          iCount = iCount + 1.
          IF iCount = 1 THEN COMBO-BOX_ClfCom = Almtabla.codigo.
          IF Almtabla.codigo = "SE040" THEN COMBO-BOX_ClfCom = "SE040".
      END.

      COMBO-BOX_CodDept:DELETE(1).
      FOR EACH TabDepto NO-LOCK:
          IF NOT CAN-FIND(FIRST TabProvi WHERE TabProvi.CodDepto = TabDepto.CodDepto NO-LOCK)
              THEN NEXT.
          COMBO-BOX_CodDept:ADD-LAST(TabDepto.NomDepto, TabDepto.CodDepto).
          IF TabDepto.CodDepto = "15" THEN COMBO-BOX_CodDept = TabDepto.CodDepto.
      END.
      COMBO-BOX_CodProv:DELETE(1).
      iCount = 0.
      FOR EACH TabProvi NO-LOCK WHERE TabProvi.CodDepto = COMBO-BOX_CodDept:
          COMBO-BOX_CodProv:ADD-LAST(TabProvi.NomProvi, TabProvi.CodProvi).
          iCount = iCount + 1.
          IF iCount = 1 THEN COMBO-BOX_CodProv = TabProvi.CodProvi.
      END.
      COMBO-BOX_CodDist:DELETE(1).
      iCount = 0.
      FOR EACH TabDistr NO-LOCK WHERE TabDistr.CodDepto = COMBO-BOX_CodDept AND
          TabDistr.CodProvi = COMBO-BOX_CodProv:
          COMBO-BOX_CodDist:ADD-LAST(TabDistr.NomDistr, TabDistr.CodDistr).
          iCount = iCount + 1.
          IF iCount = 1 THEN COMBO-BOX_CodDist = TabDistr.CodDistr.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requiere-validar-con-sunat F-Frame-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records F-Frame-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartFrame, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed F-Frame-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida F-Frame-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pRpta AS LOG NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX_Canal COMBO-BOX_CodDept COMBO-BOX_CodDist 
        COMBO-BOX_CodProv COMBO-BOX_TipDoc EDITOR_DirCli 
        EDITOR_NomCli FILL-IN_ApeMat FILL-IN_ApePat 
        FILL-IN_e-mail-1 FILL-IN_Nombre FILL-IN_NroDoc /*FILL-IN_Telfnos*/
        FILL-IN_e-mail-2 COMBO-BOX_GirCli COMBO-BOX_ClfCom.

    IF TRUE <> (FILL-IN_NroDoc > '') THEN DO:
        RUN pda/d-message ('NO puede dejar Número en blanco', "WARNING", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO FILL-IN_NroDoc.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (EDITOR_NomCli > '') THEN DO:
        RUN pda/d-message ('NO puede dejar la Razón Social en blanco', "WARNING", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO EDITOR_NomCli.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (EDITOR_DirCli > '') THEN DO:
        RUN pda/d-message ('NO puede dejar la Dirección en blanco', "WARNING", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO EDITOR_DirCli.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (FILL-IN_e-mail-1 > '') THEN DO:
        RUN pda/d-message ('NO puede dejar el e-mail Fact. Electr. en blanco', "WARNING", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO FILL-IN_e-mail-1.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (FILL-IN_e-mail-2 > '') THEN DO:
        RUN pda/d-message ('NO puede dejar el e-mail de contacto en blanco', "WARNING", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO FILL-IN_e-mail-2.
        RETURN 'ADM-ERROR'.
    END.

    /* ************************************************************************************* */
    /* Armamos el código del cliente */
    /* ************************************************************************************* */
    x-data = TRIM(FILL-IN_NroDoc).
    IF LENGTH(x-data) < 11 THEN DO:
        x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
    END.
    F-CodCli = x-data.

    FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = F-CodCli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        RUN pda/d-message ('Codigo de Cliente YA EXISTE', "ERROR", "", OUTPUT pRpta).
        APPLY 'ENTRY':U TO FILL-IN_NroDoc.
        RETURN 'ADM-ERROR'.
    END.

    /* Definimos el tipo de persona: J: jurídica, N: persona natural y E: extranjera */
    ASSIGN
        f-RucCli = ""
        f-DNICLI = "".
    CASE COMBO-BOX_TipDoc:
        WHEN "RUC" THEN ASSIGN x-Libre_c01 = "J" f-RucCli = FILL-IN_NroDoc.
        WHEN "DNI" THEN  ASSIGN x-Libre_c01 = "N" f-DNICli = FILL-IN_NroDoc.
        WHEN "CARNET EXTRANJERIA" THEN  ASSIGN x-Libre_c01 = "E" f-DNICli = FILL-IN_NroDoc.
    END CASE.
    /* Ajustes finales */
    IF COMBO-BOX_TipDoc = "RUC" AND f-RucCli BEGINS "10" THEN DO:
        x-Libre_c01 = "N".
        f-DNICli = SUBSTRING(f-RucCli,3,8).
    END.
    IF COMBO-BOX_TipDoc = "RUC" AND f-RucCli BEGINS "17" THEN DO:
        x-Libre_c01 = "E".
        f-DNICli = SUBSTRING(f-RucCli,3,8).
    END.

    DEF VAR pResultado AS CHAR.
    CASE TRUE:
        WHEN x-Libre_c01 = "J" THEN DO:
            IF LENGTH(FILL-IN_NroDoc) <> 11 OR LOOKUP(SUBSTRING(FILL-IN_NroDoc,1,2), '20,10,15,17') = 0 THEN DO:
                RUN pda/d-message ('Debe tener 11 dígitos y comenzar con 20, 10, 15 o 17', "ERROR", "", OUTPUT pRpta).
                APPLY 'ENTRY':U TO FILL-IN_NroDoc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (FILL-IN_NroDoc, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                RUN pda/d-message ('Código MAL registrado', "WARNING", "", OUTPUT pRpta).
                APPLY 'ENTRY':U TO FILL-IN_NroDoc.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.

    /* Mostramos los clientes con ruc similares */
    DEF VAR x-Mensaje AS CHAR NO-UNDO.

    IF f-RucCli > '' THEN DO:
        x-Mensaje = ''.
        FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia AND b-clie.ruc = f-RucCli:
            x-Mensaje = x-Mensaje + (IF x-Mensaje <> '' THEN CHR(10) ELSE '') +
                b-clie.codcli + ' ' + b-clie.nomcli.
        END.
        IF x-Mensaje <> '' THEN DO:
            RUN pda/d-message ('Los siguientes clientes tienen el mismo RUC: Continuamos?' + CHR(10) + x-mensaje, "QUESTION", "", OUTPUT pRpta).
/*             MESSAGE 'Los siguientes clientes tienen el mismo RUC:' SKIP */
/*                 x-Mensaje SKIP(1)                                       */
/*                 'Continuamos?'                                          */
/*                 VIEW-AS ALERT-BOX WARNING                               */
/*                 BUTTONS YES-NO UPDATE rpta AS LOG.                      */
            IF pRpta = NO THEN RETURN 'ADM-ERROR'.
        END.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

