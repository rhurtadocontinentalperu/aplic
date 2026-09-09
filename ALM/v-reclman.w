&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.
DEFINE SHARED TEMP-TABLE ITEM-1 LIKE Almdmov.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE s-FchDoc AS DATE.

DEFINE        VAR F-TPOCMB AS DECIMAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.Observ ~
Almcmov.Libre_l01 Almcmov.Libre_c01 Almcmov.Libre_d01 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.FchDoc Almcmov.usuario ~
Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.Observ Almcmov.Libre_l01 ~
Almcmov.Libre_c01 Almcmov.Libre_d01 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Entrada FILL-IN-Salida ~
FILL-IN-NroRf1 FILL-IN-NomPer 

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
DEFINE VARIABLE FILL-IN-Entrada AS CHARACTER FORMAT "XXX-XXXXXXX":U 
     LABEL "N° de INGRESO" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRf1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Salida AS CHARACTER FORMAT "XXX-XXXXXXX":U 
     LABEL "N° de SALIDA" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Entrada AT ROW 1 COL 13.14 COLON-ALIGNED WIDGET-ID 22
     Almcmov.FchDoc AT ROW 1 COL 79 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Salida AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 24
     Almcmov.usuario AT ROW 1.81 COL 79 COLON-ALIGNED WIDGET-ID 20
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.NroRf1 AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 26
          LABEL "Motivo" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-NroRf1 AT ROW 2.62 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     Almcmov.NroRf2 AT ROW 3.42 COL 13 COLON-ALIGNED WIDGET-ID 28
          LABEL "Autorización N°" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     Almcmov.Observ AT ROW 4.23 COL 13 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 56 BY .81
     Almcmov.Libre_l01 AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 32
          LABEL "Cuenta Contable 384102" FORMAT "Haber/Debe"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Yes","No" 
          DROP-DOWN-LIST
          SIZE 10 BY 1
     Almcmov.Libre_c01 AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 34
          LABEL "Aux. PE" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-NomPer AT ROW 6.12 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     Almcmov.Libre_d01 AT ROW 6.92 COL 19 COLON-ALIGNED WIDGET-ID 36
          LABEL "Soles" FORMAT ">,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almcmov,INTEGRAL.Almtdocm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
      TABLE: ITEM-1 T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 9.04
         WIDTH              = 98.86.
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

/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Entrada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRf1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Salida IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.Libre_d01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX Almcmov.Libre_l01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME Almcmov.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.Libre_c01 V-table-Win
ON LEAVE OF Almcmov.Libre_c01 IN FRAME F-Main /* Aux. PE */
DO:
  FILL-IN-NomPer:SCREEN-VALUE = "".
  FIND pl-pers WHERE PL-PERS.codper = self:SCREEN-VALUE and
      PL-PERS.CodCia = s-codcia NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN FILL-IN-NomPer:SCREEN-VALUE = PL-PERS.nomper + " " + 
      PL-PERS.patper + " " + 
      PL-PERS.matper.
/*   ASSIGN                                                                  */
/*       SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '99999999')  */
/*       NO-ERROR.                                                           */
/*   FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia                           */
/*       AND cb-auxi.Clfaux = 'PE'                                           */
/*       AND cb-auxi.Codaux = SELF:SCREEN-VALUE                              */
/*       NO-LOCK NO-ERROR.                                                   */
/*   IF AVAILABLE cb-auxi THEN FILL-IN-NomPer:SCREEN-VALUE = cb-auxi.NomAux. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.Libre_c01 V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almcmov.Libre_c01 IN FRAME F-Main /* Aux. PE */
OR F8 OF Almcmov.Libre_c01 DO:
  ASSIGN
      input-var-1 = ""
      input-var-2 = ""
      input-var-3 = ""
      output-var-1 = ?.
  RUN lkup/c-pl-pers-v2 ("PERSONAL").
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf1 V-table-Win
ON LEAVE OF Almcmov.NroRf1 IN FRAME F-Main /* Motivo */
DO:
    FILL-IN-NroRf1:SCREEN-VALUE = ''.
    FIND Almtabla WHERE almtabla.Codigo = SELF:SCREEN-VALUE
        AND almtabla.Tabla = 'RM'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN FILL-IN-NroRf1:SCREEN-VALUE = almtabla.Nombre.
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
  {src/adm/template/row-list.i "Almcmov"}
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* INGRESO */
      FOR EACH Almdmov OF Almcmov:
          ASSIGN 
              R-ROWID = ROWID(Almdmov).
          RUN ALM\ALMDCSTK (R-ROWID).      /* Descarga del Almacen */
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          RUN ALM\ALMACPR1 (R-ROWID,"D").        
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     
          /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
          RUN ALM\ALMACPR2 (R-ROWID,"D").
          *************************************************** */
          DELETE Almdmov.
      END.
      /* SALIDA */
      FOR EACH Almdmov OF B-CMOV:
          ASSIGN 
              R-ROWID = ROWID(Almdmov).
          /* RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen */ */
          RUN alm/almacstk (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          RUN ALM\ALMACPR1 (R-ROWID,"D").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
          RUN ALM\ALMACPR2 (R-ROWID,"D").
          *************************************************** */
          DELETE Almdmov.
      END.
  END.
                                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ITEM-1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.              
EMPTY TEMP-TABLE ITEM-1.              
FOR EACH Almdmov OF Almcmov NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Almdmov TO ITEM.
END.
FIND B-CMOV WHERE B-CMOV.codcia = Almcmov.codcia
    AND B-CMOV.codalm = Almcmov.codalm
    AND B-CMOV.tipmov = "S" 
    AND B-CMOV.codmov = Almcmov.codmov
    AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nroref,1,3))
    AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nroref,4))
    NO-LOCK NO-ERROR.
IF AVAILABLE B-CMOV THEN DO:
    FOR EACH Almdmov OF B-CMOV NO-LOCK:
        CREATE ITEM-1.
        BUFFER-COPY Almdmov TO ITEM-1.
    END.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE N-Itm AS INTEGER NO-UNDO.
  DEF VAR r-Rowid AS ROWID NO-UNDO.
  DEF VAR pComprometido AS DEC.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* INGRESO */
      N-Itm = 0.
      FOR EACH ITEM WHERE ITEM.codmat <> "" BY ITEM.NroItm:
          N-Itm = N-Itm + 1.
          CREATE almdmov.
          BUFFER-COPY ITEM TO Almdmov
              ASSIGN 
              Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.CodMov = Almcmov.CodMov 
              Almdmov.NroSer = Almcmov.NroSer 
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb
              Almdmov.NroItm = N-Itm
              Almdmov.CodAjt = ''
              Almdmov.HraDoc = almcmov.HorSal
              R-ROWID = ROWID(Almdmov).
          FIND Almmmatg OF Almdmov NO-LOCK.
          ASSIGN
              Almdmov.CodUnd = Almmmatg.UndStk.
          FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almdmov.CodCia 
              AND  Almtmovm.Tipmov = Almdmov.TipMov 
              AND  Almtmovm.Codmov = Almdmov.CodMov 
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtmovm AND Almtmovm.PidPCo AND Almtmovm.TipMov = "I"
              THEN ASSIGN Almdmov.CodAjt = "A".
          ELSE ASSIGN Almdmov.CodAjt = ''.

          /* ************************************************ */
          RUN ALM\ALMACSTK (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          RUN ALM\ALMACPR1 (R-ROWID,"U").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 
      END.
      /* SALIDA */
      N-Itm = 0.
      FOR EACH ITEM-1 BY ITEM-1.NroItm:
          N-Itm = N-Itm + 1.
          CREATE almdmov.
          BUFFER-COPY ITEM-1 TO Almdmov
              ASSIGN 
              Almdmov.CodCia = B-CMOV.CodCia 
              Almdmov.CodAlm = B-CMOV.CodAlm 
              Almdmov.TipMov = B-CMOV.TipMov 
              Almdmov.CodMov = B-CMOV.CodMov 
              Almdmov.NroSer = B-CMOV.NroSer 
              Almdmov.NroDoc = B-CMOV.NroDoc 
              Almdmov.CodMon = B-CMOV.CodMon 
              Almdmov.FchDoc = B-CMOV.FchDoc 
              Almdmov.TpoCmb = B-CMOV.TpoCmb
              Almdmov.NroItm = N-Itm
              Almdmov.CodAjt = ''
              Almdmov.HraDoc = B-CMOV.HorRcp
              R-ROWID = ROWID(Almdmov).
          FIND Almmmatg OF Almdmov NO-LOCK.
          ASSIGN
              Almdmov.CodUnd = Almmmatg.UndStk.
          FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almdmov.CodCia 
              AND  Almtmovm.Tipmov = Almdmov.TipMov 
              AND  Almtmovm.Codmov = Almdmov.CodMov 
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtmovm AND Almtmovm.PidPCo AND Almtmovm.TipMov = "I"
              THEN ASSIGN Almdmov.CodAjt = "A".
          ELSE ASSIGN Almdmov.CodAjt = ''.
          /* RHC 11.01.10 nueva rutina */
/*           FIND Almmmate WHERE Almmmate.codcia = Almdmov.codcia                             */
/*               AND Almmmate.codalm = Almdmov.codalm                                         */
/*               AND Almmmate.codmat = Almdmov.codmat                                         */
/*               NO-LOCK.                                                                     */
/*           RUN gn/stock-comprometido-v2.p(Almmmate.CodMat,                                  */
/*                                          Almmmate.CodAlm,                                  */
/*                                          YES,                                              */
/*                                          OUTPUT pComprometido).                            */
/*           /* CONSISTENCIA NORMAL */                                                        */
/*           IF ( Almdmov.CanDes * Almdmov.Factor ) > ( Almmmate.stkact - pComprometido )     */
/*               THEN DO:                                                                     */
/*               MESSAGE 'NO se puede sacar mas de' (Almmmate.stkact - pComprometido) SKIP(1) */
/*                   'Producto:' Almdmov.codmat SKIP                                          */
/*                   'Cantidad solicitada:' ( Almdmov.CanDes * Almdmov.Factor )               */
/*                   'Stock actual:' Almmmate.StkAct SKIP                                     */
/*                   'Stock comprometido:' pComprometido SKIP                                 */
/*                   VIEW-AS ALERT-BOX ERROR.                                                 */
/*               UNDO, RETURN "ADM-ERROR".                                                    */
/*           END.                                                                             */
          /* ************************* */
          RUN alm/almdcstk (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          RUN ALM\ALMACPR1 (R-ROWID,"U").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
          AND Almacen.CodAlm = Almtdocm.CodAlm 
          NO-LOCK NO-ERROR.
      ASSIGN
          FILL-IN-Salida = STRING(s-NroSer,"999") + STRING(Almacen.CorrSal,"9999999")
          FILL-IN-Entrada = STRING(s-NroSer,"999") + STRING(Almacen.CorrIng,"9999999").
      DISPLAY 
          TODAY @ Almcmov.FchDoc
          FILL-IN-Salida
          FILL-IN-Entrada.
      FIND LAST gn-tcmb NO-LOCK.
      f-TPOCMB = gn-tcmb.compra.
      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_handle ('Pagina2').
      s-adm-new-record = 'YES'.
      s-FchDoc = TODAY.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       NO HAY MODIFICACION 
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-NroDoc AS INT NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
      AND Almacen.CodAlm = Almtdocm.CodAlm 
      EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN 
      x-Nrodoc  = Almacen.CorrIng.
  REPEAT:
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                      AND Almcmov.CodAlm = Almtdocm.CodAlm 
                      AND Almcmov.TipMov = Almtdocm.TipMov
                      AND Almcmov.CodMov = Almtdocm.CodMov
                      AND Almcmov.NroSer = s-NroSer
                      AND Almcmov.NroDoc = x-NroDoc
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          x-NroDoc = x-NroDoc + 1.
  END.
  /* MOVIMIENTO ORIGEN */
  ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      Almcmov.CodAlm = Almtdocm.CodAlm 
      Almcmov.TipMov = Almtdocm.TipMov
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.NroSer = S-NROSER
      Almcmov.Nrodoc = x-NroDoc
      Almcmov.HorSal = STRING(TIME,"HH:MM:SS")
      Almcmov.CodMon = 1        /* SOLES */
      Almcmov.TpoCmb  = F-TPOCMB.
  ASSIGN
      Almacen.CorrIng = x-NroDoc + 1.
  /* MOVIMIENTO REFLEJO */
  ASSIGN 
      x-Nrodoc  = Almacen.CorrSal.
  REPEAT:
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                      AND Almcmov.CodAlm = Almtdocm.CodAlm 
                      AND Almcmov.TipMov = "S"
                      AND Almcmov.CodMov = Almtdocm.CodMov
                      AND Almcmov.NroSer = s-NroSer
                      AND Almcmov.NroDoc = x-NroDoc
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          x-NroDoc = x-NroDoc + 1.
  END.
  CREATE B-CMOV.
  BUFFER-COPY Almcmov TO B-CMOV
      ASSIGN
      B-CMOV.TipMov = "S"
      B-CMOV.Nrodoc = x-NroDoc
      B-CMOV.NroRef = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999')
      B-CMOV.NroRf1 = Almcmov.NroRf1
      B-CMOV.usuario = S-USER-ID
      .
      /*B-CMOV.NroRf2 = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999').*/
  ASSIGN
      Almacen.CorrSal = x-NroDoc + 1.
  ASSIGN 
      Almcmov.NroRef = STRING(B-CMOV.nroser, '999') + STRING(B-CMOV.nrodoc, '9999999').
/*       Almacen.CorrSal = Almacen.CorrSal + 1  */
/*       Almacen.CorrIng = Almacen.CorrIng + 1. */
  ASSIGN 
      Almcmov.usuario = S-USER-ID.

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* DESBLOQUEA CORRELATIVOS */
  IF AVAILABLE(Almacen) THEN RELEASE Almacen.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  s-adm-new-record = 'NO'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-adm-new-record = 'NO'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
  END.

/* BLOQUEADO 
/* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
****************** */  

  /* Code placed here will execute AFTER standard behavior.    */
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          Almcmov.FlgEst = 'A'
          Almcmov.Observ = "      A   N   U   L   A   D   O       "
          Almcmov.Usuario = S-USER-ID.
      FIND B-CMOV WHERE B-CMOV.codcia = Almcmov.codcia
          AND B-CMOV.codalm = Almcmov.codalm
          AND B-CMOV.tipmov = "S"
          AND B-CMOV.codmov = Almcmov.codmov
          AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nroref,1,3))
          AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nroref,4))
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CMOV.FlgEst = 'A'
          B-CMOV.Observ = "      A   N   U   L   A   D   O       "
          B-CMOV.Usuario = S-USER-ID.
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.  
      FIND CURRENT Almcmov NO-LOCK.
      RELEASE B-CMOV.
      /* refrescamos los datos del viewer */
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
      /* refrescamos los datos del browse */
      RUN Procesa-Handle IN lh_Handle ('browse').
  END.

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
  IF AVAILABLE almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(almcmov.nroser, '999') + STRING(almcmov.nrodoc, '9999999') @ FILL-IN-Entrada
          almcmov.nroref @ FILL-IN-Salida.
      FIND Almtabla WHERE almtabla.Codigo = Almcmov.NroRf1
          AND almtabla.Tabla = 'RM'
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN DISPLAY almtabla.Nombre @ FILL-IN-NroRf1.

      FILL-IN-NomPer:SCREEN-VALUE = "".
      FIND pl-pers WHERE PL-PERS.codper = Almcmov.Libre_c01 AND
          PL-PERS.CodCia = s-codcia NO-LOCK NO-ERROR.
      IF AVAILABLE pl-pers THEN 
          DISPLAY PL-PERS.nomper + " " + PL-PERS.patper + " " + PL-PERS.matper
          @ FILL-IN-NomPer.

/*       FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia                      */
/*           AND cb-auxi.Clfaux = 'PE'                                      */
/*           AND cb-auxi.Codaux = Almcmov.Libre_c01                         */
/*           NO-LOCK NO-ERROR.                                              */
/*       IF AVAILABLE cb-auxi THEN DISPLAY cb-auxi.nomaux @ FILL-IN-NomPer. */

      RUN Carga-Temporal.
      RUN Procesa-Handle IN lh_handle ('browse').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN RUN ALM\R-IMPFMT-1.R(ROWID(almcmov), NO).
  ELSE RETURN.
  FIND B-CMOV WHERE B-CMOV.codcia = Almcmov.codcia
      AND B-CMOV.codalm = Almcmov.codalm
      AND B-CMOV.tipmov = "S"
      AND B-CMOV.codmov = Almcmov.codmov
      AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nroref,1,3))
      AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nroref,4))
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-CMOV THEN RUN ALM\R-IMPFMT (ROWID(B-CMOV)).

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
        WHEN "NroRf1" THEN 
            ASSIGN
                input-var-1 = "RM"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "Libre_c01" THEN 
            ASSIGN
                input-var-1 = "PE"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "Almtdocm"}

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
DO WITH FRAME {&FRAME-NAME} :
    FIND Almtabla WHERE almtabla.Codigo = Almcmov.NroRf1:SCREEN-VALUE
        AND almtabla.Tabla = 'RM'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtabla THEN DO:
        MESSAGE 'Ingrese el Motivo' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Almcmov.NroRf1.
        RETURN 'ADM-ERROR'.
    END.
    IF Almcmov.NroRf2:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el N° de Autorización' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Almcmov.NroRf2.
        RETURN 'ADM-ERROR'.
    END.

    FIND pl-pers WHERE PL-PERS.codper = Almcmov.Libre_c01:SCREEN-VALUE AND
        PL-PERS.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Código PE no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO Almcmov.Libre_c01.
        RETURN 'ADM-ERROR'.
    END.

/*     FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia                  */
/*         AND cb-auxi.Clfaux = 'PE'                                  */
/*         AND cb-auxi.Codaux = Almcmov.Libre_c01:SCREEN-VALUE        */
/*         NO-LOCK NO-ERROR.                                          */
/*     IF NOT AVAILABLE cb-auxi THEN DO:                              */
/*         MESSAGE 'Código PE no registrado' VIEW-AS ALERT-BOX ERROR. */
/*         APPLY 'entry' TO Almcmov.Libre_c01.                        */
/*         RETURN 'ADM-ERROR'.                                        */
/*     END.                                                           */

    FIND FIRST ITEM NO-LOCK NO-ERROR.
    FIND FIRST ITEM-1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM OR NOT AVAILABLE ITEM-1 THEN DO:
        MESSAGE 'NO hay items registrados' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* RHC 07/06/19 Jose Nieto */
    DEF VAR x-CanTot AS DEC NO-UNDO.
    DEF VAR x-ImpTot AS DEC NO-UNDO.
    FOR EACH ITEM:
        x-CanTot = x-CanTot + ITEM.CanDes.
        x-ImpTot = x-ImpTot + ITEM.ImpCto.
    END.
    FOR EACH ITEM-1:
        x-CanTot = x-CanTot - ITEM-1.CanDes.
        x-ImpTot = x-ImpTot - ITEM-1.ImpCto.
    END.
    IF almtabla.CodCta1 = "SI" AND almtabla.CodCta2 = "NO" AND  x-CanTot <> 0
        THEN DO:
        MESSAGE 'Hay diferencia en las cantidades' SKIP
            'Continuamos con la grabación?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
        IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
    END.
    IF almtabla.CodCta1 = "NO" AND almtabla.CodCta2 = "SI" AND  x-ImpTot <> 0
        THEN DO:
        MESSAGE 'Hay diferencia en los importes' SKIP
            'Continuamos con la grabación?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-2 AS LOG.
        IF rpta-2 = NO THEN RETURN 'ADM-ERROR'.
    END.
    IF almtabla.CodCta1 = "SI" AND almtabla.CodCta2 = "SI" AND  
        (x-CanTot <> 0 OR x-ImpTot <> 0)
        THEN DO:
        MESSAGE 'Hay diferencia en las cantidas y/o importes' SKIP
            'Continuamos con la grabación?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-3 AS LOG.
        IF rpta-3 = NO THEN RETURN 'ADM-ERROR'.
    END.
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

  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

