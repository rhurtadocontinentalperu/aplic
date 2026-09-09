&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DMOV LIKE Almdmov
       INDEX LLAVE01 CodCia NroItm.
DEFINE TEMP-TABLE TT-DMOV LIKE Almdmov
       INDEX LLAVE01 CodCia NroItm.



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

DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VAR s-AlmDes LIKE  Almcmov.AlmDes.

DEF BUFFER CMOV FOR Almcmov.

DEFINE STREAM Reporte.

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
&Scoped-Define ENABLED-FIELDS Almcmov.AlmDes Almcmov.Observ Almcmov.NroRf3 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroSer Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.AlmDes Almcmov.FchAnu Almcmov.Observ Almcmov.NroRf1 ~
Almcmov.usuario Almcmov.NroRf2 Almcmov.HorSal Almcmov.NroRf3 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomDes 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroSer AT ROW 1.27 COL 13 COLON-ALIGNED WIDGET-ID 30
          LABEL "No. Documento"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     Almcmov.NroDoc AT ROW 1.27 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-Estado AT ROW 1.27 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     Almcmov.FchDoc AT ROW 1.27 COL 78 COLON-ALIGNED WIDGET-ID 12 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.AlmDes AT ROW 2.08 COL 13 COLON-ALIGNED WIDGET-ID 2
          LABEL "Almacen  Destino" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .81
     F-NomDes AT ROW 2.08 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Almcmov.FchAnu AT ROW 2.08 COL 78 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.Observ AT ROW 2.88 COL 13 COLON-ALIGNED WIDGET-ID 22
          LABEL "Observaciones" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     Almcmov.NroRf1 AT ROW 2.88 COL 78 COLON-ALIGNED WIDGET-ID 16
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.usuario AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 38
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almcmov.NroRf2 AT ROW 3.69 COL 78 COLON-ALIGNED WIDGET-ID 18
          LABEL "Referencia 2" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.HorSal AT ROW 4.5 COL 13 COLON-ALIGNED WIDGET-ID 34 FORMAT "X(5)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almcmov.NroRf3 AT ROW 4.5 COL 78 COLON-ALIGNED WIDGET-ID 20
          LABEL "O/Despacho" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
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
      TABLE: T-DMOV T "SHARED" ? INTEGRAL Almdmov
      ADDITIONAL-FIELDS:
          INDEX LLAVE01 CodCia NroItm
      END-FIELDS.
      TABLE: TT-DMOV T "?" ? INTEGRAL Almdmov
      ADDITIONAL-FIELDS:
          INDEX LLAVE01 CodCia NroItm
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.85
         WIDTH              = 103.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchAnu IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.HorSal IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroSer IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
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

&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen  Destino */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF SELF:SCREEN-VALUE = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = s-CodCia 
      /*AND Almacen.CodDiv = s-CodDiv*/
      AND Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen Destino no existe o no pertenece a esta división" 
         VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
  Almcmov.AlmDes:SENSITIVE = FALSE.
  s-AlmDes = SELF:SCREEN-VALUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    CASE Almcmov.codref:
        WHEN 'R/A' THEN DO:
            FIND Almcrepo WHERE Almcrepo.codcia = s-codcia
                AND Almcrepo.nroser = INTEGER(SUBSTRING(Almcmov.nrorf1,1,3))
                AND Almcrepo.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf1,4))
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Almcrepo THEN DO:
                MESSAGE 'No se pudo bloquear el Pedido por Reposicion Automatico'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            FOR EACH almdmov OF almcmov NO-LOCK:
                FIND Almdrepo OF Almcrepo WHERE Almdrepo.codmat = Almdmov.codmat
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Almdrepo THEN DO:
                    MESSAGE 'No se pudo bloquear el detalle del Pedido por Reposicion Automatico'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO, RETURN "ADM-ERROR".
                END.
                Almdrepo.CanAten = Almdrepo.CanAten + Almdmov.candes.
                RELEASE Almdrepo.
            END.
            FIND FIRST Almdrepo OF Almcrepo WHERE almdrepo.CanApro > almdrepo.CanAten
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almdrepo 
            THEN ASSIGN
                almcrepo.FlgEst = 'C'
                almcrepo.HorAct = STRING(TIME, 'HH:MM')
                almcrepo.FecAct = TODAY
                almcrepo.UsrAct = s-user-id.
            RELEASE Almcrepo.
        END.
        WHEN 'REP' THEN DO:
            FIND Almcrequ WHERE Almcrequ.CodCia = Almcmov.codcia 
                AND  Almcrequ.CodAlm = Almcmov.AlmDes 
                AND  Almcrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
                AND  Almcrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF NOT AVAILABLE Almcrepo THEN DO:
                MESSAGE 'No se pudo bloquear el Pedido por Reposicion Manual'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            FOR EACH Almdmov OF Almcmov NO-LOCK:
                FIND Almdrequ WHERE Almdrequ.CodCia = Almdmov.CodCia 
                    AND  Almdrequ.CodAlm = Almcmov.Almdes 
                    AND  Almdrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3))
                    AND  Almdrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6))
                    AND  Almdrequ.CodMat = almdmov.codmat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Almdrequ THEN DO:
                    MESSAGE 'No se pudo bloquear el detalle del Pedido por Reposicion Manual'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO, RETURN "ADM-ERROR".
                END.
                Almdrequ.CanDes = Almdrequ.CanDes + Almdmov.candes.
                RELEASE Almdrequ.
            END.
            FIND FIRST Almdrequ OF Almcrequ WHERE Almdrequ.CanReq > Almdrequ.CanDes NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almdrequ 
            THEN ASSIGN 
                    Almcrequ.FlgEst = "C"
                    Almcrequ.HorAte = STRING(TIME,"HH:MM").
            RELEASE Almcrequ.
        END.
        WHEN 'O/D' THEN DO:
            /* Actualiza Detalle de la Orden de Despacho */
            FOR EACH Almdmov OF Almcmov NO-LOCK:
                FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
                    AND Facdpedi.coddoc = Almcmov.codref
                    AND Facdpedi.nroped = Almcmov.nrorf3
                    AND Facdpedi.codmat = Almdmov.codmat
                    EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF NOT AVAILABLE Facdpedi THEN DO:
                    MESSAGE "NO se pudo bloquear el producto" almdmov.codmat "en la orden de despacho"
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO, RETURN "ADM-ERROR".
                END.
                ASSIGN 
                    FacDPedi.CanAte = FacDPedi.CanAte + Almdmov.CanDes.
                IF (FacDPedi.CanPed - FacDPedi.CanAte) <= 0 THEN FacDPedi.FlgEst = "C".
                ELSE FacDPedi.FlgEst = "P".
            END.
            /* Cierra la O/D */
            FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.coddoc = Almcmov.codref
                AND Faccpedi.nroped = Almcmov.nrorf3
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Faccpedi THEN DO:
                MESSAGE 'No se pudo actualizar la cabecera de Ordenes de Despacho:' ALmcmov.codref Almcmov.nroref
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed > Facdpedi.CanAte) NO-LOCK NO-ERROR.
            IF AVAILABLE Facdpedi THEN Faccpedi.FlgEst = "P".
            ELSE Faccpedi.FlgEst = "C".
        END.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    /* Eliminamos el detalle para el almacen de Origen */
    FOR EACH Almdmov OF Almcmov:
      ASSIGN R-ROWID = ROWID(Almdmov).
      RUN alm/almacstk (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* RHC 30.03.04 REACTIVAMOS RUTINA */
      RUN alm/almacpr1 (R-ROWID, "D").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
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

EMPTY TEMP-TABLE T-DMOV.

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

RUN Borra-Temporal.
FOR EACH almdmov OF almcmov NO-LOCK:
    CREATE T-DMOV.
    BUFFER-COPY Almdmov TO T-DMOV.
    RELEASE T-DMOV.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE        VAR C-DESALM AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRALM AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR C-DIRPRO AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR I-CODMON AS INTEGER  NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID    NO-UNDO.
DEFINE        VAR D-FCHDOC AS DATE     NO-UNDO.
DEFINE        VAR F-TPOCMB AS DECIMAL  NO-UNDO.
DEFINE        VAR I-NRO    AS INTEGER  NO-UNDO.
DEFINE        VAR S-OBSER  AS CHAR     NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL  NO-UNDO.
DEFINE        VAR S-Item   AS INTEGER INIT 0.
DEFINE        VAR F-NOMPRO AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-DIRTRA AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-RUCTRA AS CHAR FORMAT "X(8)"  INIT "". 
DEFINE        VAR S-TOTPES AS DECIMAL.
DEFINE        VAR I-MOVDES AS INTEGER NO-UNDO.
DEFINE        VAR I-NROSER AS INTEGER NO-UNDO.

  DEF VAR Rpta-1 AS LOG NO-UNDO.
  DEF VAR M AS INT NO-UNDO.

  SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta-1.
  IF Rpta-1 = NO THEN RETURN.
    
  FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
      AND  Almacen.CodAlm = Almcmov.CodAlm 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN C-DIRPRO = Almacen.Descripcion.
  FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
      AND  Almacen.CodAlm = Almcmov.AlmDes 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen 
  THEN ASSIGN 
         C-DESALM = Almacen.Descripcion
         C-DIRALM = Almacen.DirAlm.
  FIND GN-PROV WHERE GN-PROV.Codcia = pv-codcia
      AND  gn-prov.CodPro = Almcmov.CodTra 
      NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV 
  THEN ASSIGN
        F-NomPro = gn-prov.NomPro
        F-DIRTRA = gn-prov.DirPro
        F-RUCTRA = gn-prov.Ruc.

  DEFINE FRAME F-FMT
      S-Item             AT  1   FORMAT "ZZ9"
      Almdmov.CodMat     AT  6   FORMAT "X(8)"
      Almmmatg.DesMat    AT  18  FORMAT "X(50)"
      Almmmatg.Desmar    AT  70  FORMAT "X(20)"
      Almdmov.CanDes     AT  92  FORMAT ">>>>,>>9.99" 
      Almdmov.CodUnd     AT  104 FORMAT "X(4)" 
      Almmmate.CodUbi    AT  112     
      HEADER
      SKIP(1)
      {&PRN2} + {&PRN7A} + {&PRN6A} + "GUIA DE TRANSFERENCIA" + {&PRN7B} + {&PRN3} + {&PRN6B} AT 30 FORMAT "X(40)" 
      {&PRN2} + {&PRN6A} + STRING(Almcmov.NroDoc,"999999")  + {&PRN3} + {&PRN6B}  AT 80 FORMAT "X(20)" SKIP(1)
      "Almacen : " Almcmov.CodAlm + " - " + C-DIRPRO FORMAT "X(60)" 
       Almcmov.FchDoc AT 106 SKIP
      "Destino : " Almcmov.Almdes + " - " + C-DESALM AT 15 FORMAT "X(60)" SKIP
      "Observaciones    : "  Almcmov.Observ FORMAT "X(40)"  SKIP              
      "----------------------------------------------------------------------------------------------------------------------" SKIP
      "     CODIGO      DESCRIPCION                                                                    CANTIDAD UM           " SKIP
      "----------------------------------------------------------------------------------------------------------------------" SKIP
      WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.

  DO M = 1 TO 2:
      S-TOTPES = 0.
      I-NroSer = S-NROSER.
      S-Item = 0.
             
      OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
      PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(34) + {&PRN3}.     
      FOR EACH Almdmov OF Almcmov NO-LOCK BY Almdmov.NroItm:
          FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                         AND  Almmmatg.CodMat = Almdmov.CodMat 
                        NO-LOCK NO-ERROR.
          FIND Almmmate WHERE Almmmate.Codcia = Almdmov.Codcia AND 
                              Almmmate.Codalm = Almdmov.CodAlm AND
                              Almmmate.Codmat = Almdmov.Codmat
                              NO-LOCK NO-ERROR.
          S-TOTPES = S-TOTPES + ( Almdmov.Candes * Almmmatg.Pesmat ).
          S-Item = S-Item + 1.     
          DISPLAY STREAM Reporte 
              S-Item 
              Almdmov.CodMat 
              Almdmov.CanDes 
              Almdmov.CodUnd 
              Almmmatg.DesMat 
              Almmmatg.Desmar 
              Almmmate.CodUbi
              WITH FRAME F-FMT.
          DOWN STREAM Reporte WITH FRAME F-FMT.
      END.
      DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
         PUT STREAM Reporte "" skip.
      END.
      PUT STREAM Reporte "----------------------------------------------------------------------------------------------------------------------" SKIP .
      PUT STREAM Reporte SKIP(1).
      PUT STREAM Reporte "               ------------------------------                              ------------------------------             " SKIP.
      PUT STREAM Reporte "                      Jefe Almacen                                                  Recepcion                         ".

      OUTPUT STREAM Reporte CLOSE.
  END.

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
DEF VAR r-Rowid AS ROWID NO-UNDO.
DEF VAR pComprometido AS DEC.
DEF VAR x-Item AS INT INIT 0 NO-UNDO.

/* Primero Resumimos la informacion */
DO TRANSACTION:
    EMPTY TEMP-TABLE TT-DMOV.
    FOR EACH T-DMOV:
        FIND TT-DMOV WHERE TT-DMOV.codmat = T-DMOV.codmat NO-ERROR.
        IF NOT AVAILABLE TT-DMOV THEN CREATE TT-DMOV.
        BUFFER-COPY T-DMOV 
            TO TT-DMOV
            ASSIGN TT-DMOV.CanDes = TT-DMOV.CanDes + T-DMOV.CanDes.
    END.
    EMPTY TEMP-TABLE T-DMOV.
    FOR EACH TT-DMOV:
        CREATE T-DMOV.
        BUFFER-COPY TT-DMOV TO T-DMOV.
    END.
    EMPTY TEMP-TABLE TT-DMOV.
END.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    x-Item = 1.
    FOR EACH T-DMOV BY T-DMOV.NroItm:
        /* Consistencia final: Verificamos que aún exista stock disponible */
/*         FIND Almmmate WHERE Almmmate.codcia = s-codcia                                          */
/*             AND Almmmate.codalm = s-codalm                                                      */
/*             AND Almmmate.codmat = T-DMOV.codmat                                                 */
/*             NO-LOCK.                                                                            */
/*         RUN vtagn/stock-comprometido (T-DMOV.codmat, s-codalm, OUTPUT pComprometido).           */
/*         IF T-DMOV.CanDes > (Almmmate.stkact - pComprometido) THEN DO:                           */
/*             CREATE TT-DMOV.                                                                     */
/*             BUFFER-COPY T-DMOV TO TT-DMOV                                                       */
/*                 ASSIGN                                                                          */
/*                     TT-DMOV.StkAct = (Almmmate.stkact - pComprometido).  /* Stock Disponible */ */
/*             DELETE T-DMOV.                                                                      */
/*             NEXT.                                                                               */
/*         END.                                                                                    */
        CREATE almdmov.
        ASSIGN Almdmov.CodCia = Almcmov.CodCia 
               Almdmov.CodAlm = Almcmov.CodAlm 
               Almdmov.TipMov = Almcmov.TipMov 
               Almdmov.CodMov = Almcmov.CodMov 
               Almdmov.NroSer = Almcmov.NroSer
               Almdmov.NroDoc = Almcmov.NroDoc 
               Almdmov.CodMon = Almcmov.CodMon 
               Almdmov.FchDoc = Almcmov.FchDoc 
               Almdmov.HraDoc = Almcmov.HraDoc
               Almdmov.TpoCmb = Almcmov.TpoCmb
               Almdmov.codmat = T-DMOV.codmat
               Almdmov.CanDes = T-DMOV.CanDes
               Almdmov.CodUnd = T-DMOV.CodUnd
               Almdmov.Factor = T-DMOV.Factor
               Almdmov.ImpCto = T-DMOV.ImpCto
               Almdmov.PreUni = T-DMOV.PreUni
               Almdmov.AlmOri = Almcmov.AlmDes 
               Almdmov.CodAjt = ''
               Almdmov.HraDoc = HorSal
               Almdmov.NroItm = x-Item
               R-ROWID = ROWID(Almdmov).
        x-Item = x-Item + 1.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, "U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* Se anulan los items que se pueden descargar */
        DELETE T-DMOV.
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
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = "G/R"    
    AND FacCorre.CodDiv = S-CODDIV 
    AND FacCorre.NroSer = S-NROSER 
    NO-LOCK NO-ERROR.
  IF AVAILABLE Faccorre AND FacCorre.FlgEst = No THEN DO:
    MESSAGE 'La serie se encuentra INACTIVA' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  s-AlmDes = ''.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          s-NroSer @ Almcmov.NroSer
          TODAY    @ Almcmov.FchDoc.
      IF AVAILABLE Faccorre 
      THEN DISPLAY Faccorre.correlativo @ Almcmov.nrodoc.
      ELSE DO:
          FIND Almacen OF Almtdocm NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen 
          THEN DISPLAY Almacen.CorrSal @ Almcmov.NroDoc.
      END.
  END.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       SOLO se puede CREAR, NO se puede MODIFICAR
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Buscamos el correlativo de almacenes */
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
      AND Almacen.CodAlm = Almtdocm.CodAlm 
      EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO: 
      MESSAGE 'NO se pudo bloquer el correlativo por almacen' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      x-Nrodoc  = Almacen.CorrSal
      Almacen.CorrSal = Almacen.CorrSal + 1.
  ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      Almcmov.CodAlm = Almtdocm.CodAlm 
      Almcmov.TipMov = Almtdocm.TipMov
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.FlgSit = "R"      /* RECEPCIONADO AUTOMATICAMENTE */
      Almcmov.FchDoc = TODAY
      Almcmov.HorSal = STRING(TIME,"HH:MM")
      Almcmov.HraDoc = STRING(TIME,"HH:MM")
      Almcmov.NroSer = s-nroser
      Almcmov.NroDoc = x-NroDoc
      /*Almcmov.CodRef = s-CodRef*/
      Almcmov.NomRef = F-nomdes:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almcmov.NroRf1 = Almcmov.NroRf1:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almcmov.NroRf2 = Almcmov.NroRf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almcmov.NroRf3 = Almcmov.NroRf3:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almcmov.usuario = S-USER-ID.
                
  FOR EACH T-DMOV WHERE T-DMOV.codmat = '':
      DELETE T-DMOV.
  END.

  EMPTY TEMP-TABLE TT-DMOV.

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* RHC 29.01.10 consistencia extra */
  FIND FIRST Almdmov OF Almcmov NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almdmov THEN DO:
      MESSAGE 'NO hay items que transferir' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* ************************************************** */
  EMPTY TEMP-TABLE T-DMOV.
  FOR EACH TT-DMOV:
      CREATE T-DMOV.
      BUFFER-COPY TT-DMOV TO T-DMOV.
  END.

  /* RHC 01.06.2011 Generamos un movimiento de ingreso en el ALMACEN DESTINO */
  RUN alm/ing-trf-vir (ROWID(Almcmov), Almcmov.AlmDes).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* ******************************************************************* */

  /* DESBLOQUEAMOS LOS CORRELATIVOS */
  IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
  IF AVAILABLE(Almacen) THEN RELEASE Almacen.
  IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
  IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

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
  DEF VAR RPTA AS CHARACTER.

  IF NOT AVAILABLE Almcmov THEN DO:
     MESSAGE "No existe registros" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF Almcmov.FlgEst = 'A' THEN DO:
     MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF Almcmov.FlgSit  = "R" THEN DO:
     MESSAGE "Transferencia recepcionada, no puede se modificada" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

  /* RHC 09.07.08 CONTROL DE SERIES ACIVAS */
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
      AND  Almacen.CodAlm = S-CODALM 
      NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE (Almacen.Clave, OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF almcmov.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

     RUN alm/ing-trf-vir-del (ROWID(Almcmov), Almcmov.AlmDes).
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' 
     THEN DO:
        MESSAGE 'No se pudo eliminar el detalle'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
     END.

     FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAILABLE Almcmov
     THEN DO:
         RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
         UNDO, RETURN "ADM-ERROR".
     END.
     ASSIGN 
         Almcmov.FlgEst = 'A'
         Almcmov.Observ = "      A   N   U   L   A   D   O       "
         Almcmov.usuario = S-USER-ID
         Almcmov.FchAnu = TODAY.
     FIND CURRENT Almcmov NO-LOCK NO-ERROR.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VAR cEstadoFlgSit AS CHAR NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
          AND  Almtmovm.Tipmov = Almtdocm.TipMov 
          AND  Almtmovm.Codmov = Almtdocm.CodMov 
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm THEN DO:
         ASSIGN 
             Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
             Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2.
         IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
         IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
         AND  Almacen.CodAlm = Almcmov.AlmDes  
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen 
     THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
     ELSE F-NomDes:SCREEN-VALUE = "".


     F-Estado:SCREEN-VALUE = "".
     /*
     CASE Almcmov.FlgSit:
         WHEN "T" THEN F-Estado:SCREEN-VALUE = "TRANSFERIDO ".
         WHEN "R" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO".
     END CASE.
     */
     RUN gn/almcmov-otr-flgsit.r(Almcmov.FlgSit, OUTPUT cEstadoFlgSit).
     F-Estado:SCREEN-VALUE = cEstadoFlgSit.
     /* */

     IF Almcmov.FlgSit = "R" AND Almcmov.FlgEst = "D" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO(*)".
     IF Almcmov.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
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
      ASSIGN
          Almcmov.NroRf1:SENSITIVE = NO
          Almcmov.NroRf2:SENSITIVE = NO
          Almcmov.NroRf3:SENSITIVE = NO.
      RUN GET-ATTRIBUTE ("ADM-NEW-RECORD").
      IF RETURN-VALUE = "YES" 
      THEN Almcmov.AlmDes:SENSITIVE = YES.
      ELSE Almcmov.AlmDes:SENSITIVE = NO.
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
  IF NOT AVAILABLE Almcmov THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF Almcmov.NroSer = 0 THEN RUN Formato.
  ELSE IF AlmCmov.FlgEst <> "A" THEN RUN ALM\R-ImpGui (ROWID(Almcmov)).

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
  FIND FIRST T-DMOV NO-LOCK NO-ERROR.
  IF AVAILABLE T-DMOV THEN DO:
      RUN alm/d-trfsal-01.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
      RUN Carga-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
  END.

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
DEF VAR i-Nro AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
   /* Capturamos las modificaciones de fecha o tipo de cambio para revalorizar */
   IF Almcmov.AlmDes:SCREEN-VALUE = "" THEN DO:
         MESSAGE "No Ingreso el Almacen Destino" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.AlmDes.
         RETURN "ADM-ERROR".   
   END.
   FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
       /*AND Almacen.CodDiv = s-CodDiv*/
       AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE "Almacen Destino no existe o no pertenece a esta división" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.AlmDes.
      RETURN "ADM-ERROR".   
   END.
   IF Almcmov.AlmDes:SCREEN-VALUE = Almtdocm.CodAlm THEN DO:
         MESSAGE "Almacen no puede transferirse a si mismo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.AlmDes.
         RETURN "ADM-ERROR".   
   END.
   I-NRO = 0.
   FOR EACH T-DMOV WHERE T-DMOV.CanDes > 0:
       FIND Almmmate WHERE Almmmate.codcia = s-codcia
           AND Almmmate.codalm = Almcmov.AlmDes:SCREEN-VALUE
           AND Almmmate.codmat = T-DMOV.CodMat
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
           MESSAGE "Artículo" T-DMOV.codmat "no asignado en el almacén destino"
               VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO Almcmov.AlmDes.
           RETURN "ADM-ERROR".   
       END.
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "No existen articulos a transferir" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".
   END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     OJO >>> NO se puede modificar un documento generado, SOLO se puede anular
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.                 
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

