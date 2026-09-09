&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almacen FOR Almacen.
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.
DEFINE TEMP-TABLE T-ITEM LIKE Almdmov.



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
DEFINE NEW SHARED VAR S-CODALM  AS CHAR.    /* >>> OJO >>>> */

/* Parameters Definitions ---                                           */
DEFINE SHARED VAR s-acceso-total  AS LOG.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VAR s-CodRef  AS CHAR.
DEFINE SHARED VAR s-Reposicion AS LOG.
DEFINE SHARED VAR s-OrdenDespacho AS LOG.
DEFINE SHARED VAR s-AlmDes LIKE  Almcmov.AlmDes.
DEFINE SHARED VAR s-seguridad AS CHAR.
DEFINE SHARED VAR s-status-almacen AS LOG.

DEF BUFFER CMOV FOR Almcmov.

DEFINE STREAM Reporte.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.

DEFINE VAR x-cotizacion-ok AS LOG.

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
&Scoped-Define ENABLED-FIELDS Almcmov.CodAlm Almcmov.AlmDes Almcmov.CodRef ~
Almcmov.NroRef Almcmov.NroRf2 Almcmov.Observ Almcmov.CrossDocking ~
Almcmov.NroRf3 Almcmov.AlmacenXD 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroSer Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.CodAlm Almcmov.usuario Almcmov.AlmDes Almcmov.HorSal ~
Almcmov.CodRef Almcmov.NroRef Almcmov.NroRf2 Almcmov.FchAnu Almcmov.Observ ~
Almcmov.CrossDocking Almcmov.NroRf3 Almcmov.AlmacenXD 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomAlm F-NomDes FILL-IN-Motivo ~
FILL-IN-AlmacenXD 

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

DEFINE VARIABLE F-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmacenXD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Motivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo" 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Urgente AS CHARACTER FORMAT "X(256)":U INITIAL "URGENTE" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroSer AT ROW 1 COL 13 COLON-ALIGNED WIDGET-ID 30
          LABEL "No. Documento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     Almcmov.NroDoc AT ROW 1 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 28 FORMAT "9999999"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     F-Estado AT ROW 1 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-Urgente AT ROW 1 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     Almcmov.FchDoc AT ROW 1 COL 78 COLON-ALIGNED WIDGET-ID 12 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.CodAlm AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 54
          LABEL "Almacén Origen" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-NomAlm AT ROW 1.81 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     Almcmov.usuario AT ROW 1.81 COL 78 COLON-ALIGNED WIDGET-ID 38
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almcmov.AlmDes AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 2
          LABEL "Almacen  Destino" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-NomDes AT ROW 2.62 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Almcmov.HorSal AT ROW 2.62 COL 78 COLON-ALIGNED WIDGET-ID 34 FORMAT "X(5)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almcmov.CodRef AT ROW 3.42 COL 13 COLON-ALIGNED WIDGET-ID 40
          LABEL "Reposición" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     Almcmov.NroRef AT ROW 3.42 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 42 FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     Almcmov.NroRf2 AT ROW 3.42 COL 49 COLON-ALIGNED WIDGET-ID 60
          LABEL "Recepción" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     Almcmov.FchAnu AT ROW 3.42 COL 78 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.Observ AT ROW 4.23 COL 13 COLON-ALIGNED WIDGET-ID 22
          LABEL "Observaciones" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     Almcmov.CrossDocking AT ROW 4.23 COL 80 WIDGET-ID 48
          LABEL "Cross Docking"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .77
     FILL-IN-Motivo AT ROW 5.04 COL 13 COLON-ALIGNED WIDGET-ID 44
     Almcmov.NroRf3 AT ROW 5.04 COL 78 COLON-ALIGNED WIDGET-ID 58
          LABEL "Pedido Comercial" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     Almcmov.AlmacenXD AT ROW 5.85 COL 13 COLON-ALIGNED WIDGET-ID 50
          LABEL "Destino Final" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN-AlmacenXD AT ROW 5.85 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 52
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
      TABLE: B-Almacen B "?" ? INTEGRAL Almacen
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
      TABLE: T-ITEM T "?" ? INTEGRAL Almdmov
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
         HEIGHT             = 7.42
         WIDTH              = 105.29.
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

/* SETTINGS FOR FILL-IN Almcmov.AlmacenXD IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.CodAlm IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.CodRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX Almcmov.CrossDocking IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchAnu IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-AlmacenXD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Motivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Urgente IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-Urgente:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.HorSal IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME Almcmov.AlmacenXD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmacenXD V-table-Win
ON LEAVE OF Almcmov.AlmacenXD IN FRAME F-Main /* Destino Final */
DO:
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia AND
        Almacen.CodAlm = SELF:SCREEN-VALUE  NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FILL-IN-AlmacenXD:SCREEN-VALUE = Almacen.Descripcion.
    ELSE FILL-IN-AlmacenXD:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen  Destino */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF SELF:SCREEN-VALUE = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia AND
       Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen Destino no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  /* RHC 26.04.2012 BLOQUEADO PARA TODOS MENOS PARA CONTABILIDAD */
  IF INDEX(s-Seguridad, 'Contabilidad') > 0 OR
      INDEX(s-Seguridad, 'Contador') > 0
      THEN .
  ELSE DO:
      IF SELF:SCREEN-VALUE = '11T' THEN DO:
          /*
          MESSAGE 'Almacén NO válido' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
          */
      END.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
  Almcmov.AlmDes:SENSITIVE = FALSE.
  s-AlmDes = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodAlm V-table-Win
ON LEAVE OF Almcmov.CodAlm IN FRAME F-Main /* Almacén Origen */
DO:
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia AND
         Almacen.CodAlm = Almcmov.CodAlm:SCREEN-VALUE  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen Origen no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    F-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
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

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = Almcmov.codref
        AND Faccpedi.nroped = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Faccpedi THEN DO:
        pMensaje = 'No se pudo bloquear la Orden de Transferencia'.
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE Facdpedi THEN DO:
            pMensaje = 'No se pudo bloquear el detalle de la Orden de Transferencia'.
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
        ASSIGN
            Facdpedi.CanAte = Facdpedi.CanAte + Almdmov.candes.
    END.
    FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi 
    THEN Faccpedi.FlgEst = 'C'.     /* Atendido */
    ELSE Faccpedi.FlgEst = 'P'.     /* Pendiente */
    /* RHC 08/07/2104 La G/R hereda el chequeo */
    ASSIGN
        Almcmov.Libre_c02 = 'C'
        Almcmov.Libre_c03 = Faccpedi.usrchq + '|' + 
        STRING(Faccpedi.fchchq, '99/99/9999') + '|' +
        STRING(Faccpedi.horchq,'HH:MM:SS') + '|' +
        STRING(Faccpedi.fecsac, '99/99/9999') + '|' + Faccpedi.horsac.
END.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
RETURN "OK".

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

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Eliminamos el detalle para el almacen de Origen */
    FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK:
        ASSIGN 
            R-ROWID = ROWID(Almdmov).
        RUN alm/almacstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        /* RHC 30.03.04 REACTIVAMOS RUTINA */
        RUN alm/almacpr1 (R-ROWID, "D").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        DELETE Almdmov.
    END.
END.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
RETURN 'OK'.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Pedido V-table-Win 
PROCEDURE Captura-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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
    CREATE ITEM.
    BUFFER-COPY Almdmov TO ITEM.
    RELEASE ITEM.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control-por-almacen V-table-Win 
PROCEDURE control-por-almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      {lib\lock-genericov3.i ~
          &Tabla="Almacen" ~
          &Condicion="Almacen.CodCia = Almtdocm.CodCia ~
          AND Almacen.CodAlm = s-CodAlm" ~
          &Bloqueo= "EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="RETURN 'ADM-ERROR'" ~
          }

      REPEAT:
          ASSIGN
              x-NroDoc = Almacen.CorrSal
              Almacen.CorrSal = Almacen.CorrSal + 1.
          IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                          AND Almcmov.codalm = s-CodAlm     /*Almtdocm.CodAlm*/
                          AND Almcmov.tipmov = Almtdocm.TipMov
                          AND Almcmov.codmov = Almtdocm.CodMov
                          AND Almcmov.nroser = s-NroSer
                          AND Almcmov.nrodoc = x-NroDoc
                          NO-LOCK)
              THEN LEAVE.
      END.
      RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control-por-guias V-table-Win 
PROCEDURE control-por-guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      {lib\lock-genericov3.i &Tabla="FacCorre" ~
          &Alcance="FIRST" ~
          &Condicion="FacCorre.CodCia = s-CodCia ~
          AND FacCorre.CodDiv = s-CodDiv ~
          AND FacCorre.CodDoc = 'G/R' ~
          AND FacCorre.NroSer = s-NroSer" ~
          &Bloqueo= "EXCLUSIVE-LOCK no-error" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="RETURN 'ADM-ERROR'" ~
          }

      REPEAT:
          ASSIGN
              x-NroDoc = FacCorre.Correlativo
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
          IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                          AND Almcmov.codalm = s-CodAlm     /*Almtdocm.CodAlm*/
                          AND Almcmov.tipmov = Almtdocm.TipMov
                          AND Almcmov.codmov = Almtdocm.CodMov
                          AND Almcmov.nroser = s-NroSer
                          AND Almcmov.nrodoc = x-NroDoc
                          NO-LOCK)
              THEN LEAVE.
      END.
      RETURN 'OK'.

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
DEFINE        VAR S-ITEM   AS INTEGER INIT 0.
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
      S-ITEM = 0.
             
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

FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH ITEM EXCLUSIVE-LOCK BY ITEM.NroItm :
        /* Solo en caso de G/R se controla el # de items */
        IF s-NroSer <> 000 AND x-Item >= FacCfgGn.Items_Guias THEN LEAVE.
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
               Almdmov.codmat = ITEM.codmat
               Almdmov.CanDes = ITEM.CanDes
               Almdmov.CodUnd = ITEM.CodUnd
               Almdmov.Factor = ITEM.Factor
               Almdmov.ImpCto = ITEM.ImpCto
               Almdmov.PreUni = ITEM.PreUni
               Almdmov.AlmOri = Almcmov.AlmDes 
               Almdmov.CodAjt = ''
               Almdmov.HraDoc = HorSal
               Almdmov.NroItm = x-Item
               R-ROWID = ROWID(Almdmov).
        x-Item = x-Item + 1.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, "U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        /* Se anulan los items que se pueden descargar */
        DELETE ITEM.
    END.
END.
RETURN "OK".

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
  DEF VAR x-Stock-Disponible AS DEC NO-UNDO.
  DEF VAR pComprometido AS DEC.
  
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = "G/R"    
      AND FacCorre.CodDiv = S-CODDIV 
      AND FacCorre.NroSer = S-NROSER 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Faccorre AND FacCorre.FlgEst = No THEN DO:
      MESSAGE 'La serie se encuentra INACTIVA' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF NOT AVAILABLE Almtdocm THEN DO:
      MESSAGE 'NO está configurado el movimiento de transferecias en este almacén' SKIP
          'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      s-CodRef = "OTR"
      s-Reposicion = YES
      s-OrdenDespacho = NO
      s-AlmDes = ''.
  ASSIGN
      input-var-1 = s-codref        /* coddoc */
      input-var-2 = 'P'             /* flgest */
      input-var-3 = 'C'             /* flgsit Cheque Barras SALIDA OK */
      output-var-1 = ?.
  RUN lkup/c-otr-v2 ("Ordenes de Transferencia").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Ic - 26Set2018 */
  x-cotizacion-ok = YES.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Faccpedi WHERE ROWID(Faccpedi) = output-var-1 NO-LOCK NO-ERROR.
      DISPLAY 
          Faccpedi.codalm @ Almcmov.CodAlm
          Faccpedi.codcli @ Almcmov.AlmDes 
          Faccpedi.coddoc @ Almcmov.CodRef
          Faccpedi.nroped @ Almcmov.NroRef
          FacCPedi.Glosa  @ Almcmov.Observ
          Faccpedi.AlmacenXD @ Almcmov.AlmacenXD
          Faccpedi.Libre_c03 @ Almcmov.NroRf3
          .      
      ASSIGN
          s-CodAlm = Faccpedi.CodAlm    /* OJO: Asignamos el almacén de trabajo */
          s-AlmDes = Almcmov.AlmDes:SCREEN-VALUE
          Almcmov.CrossDocking:SCREEN-VALUE = STRING(Faccpedi.CrossDocking)
          .
      /* Motivo */
      FIND FacTabla WHERE FacTabla.CodCia = Faccpedi.codcia
          AND FacTabla.Tabla = 'REPOMOTIVO'
          AND FacTabla.Codigo = FacCPedi.MotReposicion
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla THEN DISPLAY FacTabla.Nombre @ FILL-IN-Motivo.
      /* Urgente */
      IF FacCPedi.VtaPuntual = YES THEN DO:
          FILL-IN-Urgente:VISIBLE = YES.
          FILL-IN-Urgente:SCREEN-VALUE = 'URGENTE'.
      END.
      ELSE FILL-IN-Urgente:VISIBLE = NO.
      
      EMPTY TEMP-TABLE ITEM.
      FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE ( Facdpedi.CanPed - Facdpedi.CanAte > 0 ):
          FIND Almmmatg WHERE Almmmatg.CodCia = Facdpedi.CodCia  
              AND Almmmatg.CodMat = Facdpedi.CodMat 
              NO-LOCK NO-ERROR. 

          /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
          CREATE ITEM.
          ASSIGN 
              ITEM.CodCia = Almtdocm.CodCia
              ITEM.CodAlm = Almtdocm.CodAlm
              ITEM.CodMat = Facdpedi.CodMat
              ITEM.CodAjt = ""
              ITEM.Factor = 1
              ITEM.CodUnd = Almmmatg.UndStk
              ITEM.AlmOri = Faccpedi.CodAlm
              ITEM.CanDes = (Facdpedi.CanPed - Facdpedi.CanAte)
              ITEM.StkAct = (Facdpedi.CanPed - Facdpedi.CanAte)              
              .  /* OJO: TOPE */

          /* Ic - 26Set2018, correo sr juan ponte/harold segura, no permitir articulos sin pesos ni volumenes */
          FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.
          IF AVAILABLE almtfami AND almtfami.swcomercial = YES THEN DO:
              IF almmmatg.pesmat <= 0 OR almmmatg.libre_d02 <= 0  THEN DO:
                  ITEM.CodAjt = "SIN PESO Y/O VOL.".
                  x-cotizacion-ok = NO.
              END.
          END.
    
      END.
      DISPLAY
          s-NroSer @ Almcmov.NroSer
          TODAY    @ Almcmov.FchDoc.
      IF AVAILABLE Faccorre THEN DISPLAY Faccorre.correlativo @ Almcmov.nrodoc.
      ELSE DO:
          FIND Almacen OF Almtdocm NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DISPLAY Almacen.CorrSal @ Almcmov.NroDoc.
      END.
   END.
   APPLY 'LEAVE':U TO Almcmov.CodAlm.
   APPLY 'LEAVE':U TO Almcmov.AlmDes.
   APPLY 'LEAVE':U TO Almcmov.AlmacenXD.
   RUN Procesa-Handle IN lh_Handle ('Pagina2').

   /* Ic - 26Set2018 */
   IF x-cotizacion-ok = NO THEN DO:
       MESSAGE "La transferencia tiene articulos sin pesos y volumenes, no procede la transferencia".
   END.

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
  IF x-cotizacion-ok = NO THEN DO:
      pMensaje =  "La transferencia tiene articulos sin pesos y volumenes, no procede la transferencia".
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Buscamos el correlativo de Guias de Remision */
  IF s-NroSer <> 000 THEN DO:
      RUN control-por-guias.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ELSE DO:
      RUN control-por-almacen.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      /*Almcmov.CodAlm = Almtdocm.CodAlm */     /* OJO */
      Almcmov.TipMov = Almtdocm.TipMov
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
      Almcmov.FchDoc = TODAY
      Almcmov.HorSal = STRING(TIME,"HH:MM")
      Almcmov.HraDoc = STRING(TIME,"HH:MM")
      Almcmov.NroSer = s-nroser
      Almcmov.NroDoc = x-NroDoc
      Almcmov.CodRef = s-CodRef
      Almcmov.NomRef = F-nomdes:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almcmov.usuario = S-USER-ID.
  /* RHC 01/09/16: Marca de URGENTE */
  ASSIGN 
      Almcmov.Libre_l02 = Faccpedi.VtaPuntual
      Almcmov.Libre_c05 = FacCPedi.MotReposicion.
                
  FOR EACH ITEM WHERE ITEM.codmat = '':
      DELETE ITEM.
  END.

  EMPTY TEMP-TABLE T-ITEM.
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "No hay stock suficiente" + CHR(10) +
          "Proceso abortado".
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* RHC 29.01.10 consistencia extra */
  FIND FIRST Almdmov OF Almcmov NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almdmov THEN DO:
      pMensaje = 'NO hay items que transferir'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Actualiza-Pedido.     /* Actualizamos pedido automático */
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* RHC 01/12/17 Log para e-Commerce */
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                              "C",      /* CREATE */
                              OUTPUT pOk).
  IF pOk = NO THEN DO:
      pMensaje = "NO se pudo actualizar el log de e-Commerce" + CHR(10) +
          "Proceso Abortado".
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ******************************** */
  /* *********************************************************************** */
  /* RHC 12/10/2020 CONTROL MR */
  /* *********************************************************************** */
  DEFINE VAR hMaster AS HANDLE NO-UNDO.
  RUN gn/master-library PERSISTENT SET hMaster.
  RUN ML_Actualiza-TRF-Control IN hMaster (INPUT ROWID(Almcmov),     /* S-03 */
                                           OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hMaster.
  /* *********************************************************************** */
  /* DAMOS MAS VUELTAS EN CASO QUEDEN ITEMS POR GENERAR */
  FIND FIRST ITEM NO-ERROR.
  REPEAT WHILE AVAILABLE ITEM:
      IF s-NroSer <> 000 THEN DO:
          REPEAT:
              ASSIGN
                  x-NroDoc = FacCorre.Correlativo
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
              IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                              AND Almcmov.codalm = Almtdocm.CodAlm
                              AND Almcmov.tipmov = Almtdocm.TipMov
                              AND Almcmov.codmov = Almtdocm.CodMov
                              AND Almcmov.nroser = s-NroSer
                              AND Almcmov.nrodoc = x-NroDoc
                              NO-LOCK)
                  THEN LEAVE.
          END.
      END.
      ELSE DO:
          REPEAT:
              ASSIGN
                  x-NroDoc = Almacen.CorrSal
                  Almacen.CorrSal = Almacen.CorrSal + 1.
              IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                              AND Almcmov.codalm = Almtdocm.CodAlm
                              AND Almcmov.tipmov = Almtdocm.TipMov
                              AND Almcmov.codmov = Almtdocm.CodMov
                              AND Almcmov.nroser = s-NroSer
                              AND Almcmov.nrodoc = x-NroDoc
                              NO-LOCK)
                  THEN LEAVE.
          END.
      END.
      CREATE CMOV.
      BUFFER-COPY Almcmov TO CMOV
          ASSIGN 
            CMOV.NroDoc  = x-NroDoc
            CMOV.usuario = S-USER-ID.

      FIND Almcmov WHERE ROWID(Almcmov) = ROWID(CMOV) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
          pMensaje = "Error al tratar de generar más de una G/R".
          UNDO, RETURN 'ADM-ERROR'.
      END.

      RUN Genera-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "No hay stock suficiente" + CHR(10) +
              "Proceso abortado".
          UNDO, RETURN 'ADM-ERROR'.
      END.

      /* Verificamos si genera pedido automatico */
      RUN Actualiza-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* RHC 01/12/17 Log para e-Commerce */
      RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                  "C",      /* CREATE */
                                  OUTPUT pOk).
      IF pOk = NO THEN DO:
          pMensaje = "NO se pudo actualizar el log de e-Commerce" + CHR(10) +
              "Proceso Abortado".
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* ******************************** */
      /* *********************************************************************** */
      /* RHC 12/10/2020 CONTROL MR */
      /* *********************************************************************** */
      RUN gn/master-library PERSISTENT SET hMaster.
      RUN ML_Actualiza-TRF-Control IN hMaster (INPUT ROWID(Almcmov),     /* S-03 */
                                               OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hMaster.
      /* *********************************************************************** */
      FIND FIRST ITEM NO-ERROR.
  END.
  /* ************************************************** */
  FOR EACH T-ITEM:
      CREATE ITEM.
      BUFFER-COPY T-ITEM TO ITEM.
  END.
  /* DESBLOQUEAMOS LOS CORRELATIVOS */
  IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
  IF AVAILABLE(Almacen) THEN RELEASE Almacen.
  IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
  IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
  IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
  IF AVAILABLE(Almdrepo) THEN RELEASE Almdrepo.

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
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  
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
     MESSAGE "Transferencia recepcionada, no puede ser modificada" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

   /* **************************************************************************** */
   /* RHC 30/&06/2020 F.O.V. NO anular la G/R si está en una H/R */
   /* **************************************************************************** */
  DEF VAR pHojRut   AS CHAR.
  DEF VAR pFlgEst-1 AS CHAR.
  DEF VAR pFlgEst-2 AS CHAR.
  DEF VAR pFchDoc   AS DATE.

  RUN dist/p-rut002 ( "TRF",
                      "",
                      "",
                      almcmov.CodAlm,
                      almcmov.TipMov,
                      almcmov.CodMov,
                      almcmov.NroSer,
                      almcmov.NroDoc,
                      OUTPUT pHojRut,
                      OUTPUT pFlgEst-1,     /* de Di-RutaC */
                      OUTPUT pFlgEst-2,     /* de Di-RutaG */
                      OUTPUT pFchDoc).
  IF pHojRut > '' AND pFlgEst-1 <> 'A' THEN DO:
       MESSAGE "NO se puede anular" SKIP "Revisar la Hoja de Ruta:" pHojRut
           VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   /* **************************************************************************** */
  DEF VAR dFchCie AS DATE.
  dFchCie = TODAY.
  IF s-acceso-total = NO THEN DO:
       IF almcmov.fchdoc <> dFchCie THEN DO:
           MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie)
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.
   END.
   ELSE DO:
       RUN gn/fFchCieCbd ('ALMACEN', OUTPUT dFchCie).
       IF almcmov.fchdoc < dFchCie THEN DO:
           MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie)
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.
   END.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  /* Solo marcamos el FlgEst como Anulado */
  pMensaje = "".
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* RHC 01/12/17 Log para e-Commerce */
      DEF VAR pOk AS LOG NO-UNDO.
      RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                  "D",      /* DELETE */
                                  OUTPUT pOk).
      IF pOk = NO THEN DO:
          pMensaje = "NO se pudo actualizar el log de e-Commerce" + CHR(10) + 
              "Proceso Abortado".
          UNDO, LEAVE.
      END.
      /* ******************************** */
      RUN Restaura-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo extornar la orden de transferencia" + CHR(10) + 
              "Proceso Abortado".
          UNDO, LEAVE.
      END.
      /*Valida almacenes*/
      IF almcmov.codalm <> '11T' THEN DO:
          IF almcmov.almdes <> '11T' THEN DO:
              RUN alm/ing-trf-vir-del (ROWID(Almcmov), '999').
              IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                  pMensaje = "NO se pudo actualizar la trasnferencia virtual" + CHR(10) + 
                      "Proceso Abortado".
                  UNDO, LEAVE.
              END.
          END.
      END.
      /* *********************************************************************** */
      /* RHC 12/10/2020 CONTROL MR */
      /* *********************************************************************** */
      DEFINE VAR hMaster AS HANDLE NO-UNDO.
      RUN gn/master-library PERSISTENT SET hMaster.
      RUN ML_Extorna-TRF-Control IN hMaster (INPUT ROWID(Almcmov),     /* TRF Almcmov */
                                             OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          UNDO, LEAVE.
      END.
      DELETE PROCEDURE hMaster.
      /* *********************************************************************** */
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo eliminar el detalle" + CHR(10) + 
              "Proceso Abortado".
          UNDO, LEAVE.
      END.
      
      FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE Almcmov THEN DO:
          pMensaje = "NO se pudo anular la salida por transferencia " + CHR(10) + 
              "Proceso Abortado".
          UNDO, LEAVE.
      END.
      ASSIGN 
          Almcmov.FlgEst = 'A'
          Almcmov.Observ = "      A   N   U   L   A   D   O       "
          Almcmov.usuario = S-USER-ID
          Almcmov.FchAnu = TODAY.
      FIND CURRENT Almcmov NO-LOCK NO-ERROR.
  END.
  IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
  IF AVAILABLE(Almdrepo) THEN RELEASE Almdrepo.

  IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  DEFINE VAR cEstadoFlgSit AS CHAR NO-UNDO.

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
          AND  Almacen.CodAlm = Almcmov.CodAlm
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen 
      THEN F-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
      ELSE F-NomAlm:SCREEN-VALUE = "".

      FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
          AND  Almacen.CodAlm = Almcmov.AlmDes  
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen 
          THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
      ELSE F-NomDes:SCREEN-VALUE = "".

     F-Estado:SCREEN-VALUE = "".
     /* Ic - 28Ago2023 */
     /*
     CASE Almcmov.FlgSit:
         WHEN "T" THEN F-Estado:SCREEN-VALUE = "EN TRANSITO ".
         WHEN "R" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO".
     END CASE.
     */

     RUN gn/almcmov-otr-flgsit.r(Almcmov.FlgSit, OUTPUT cEstadoFlgSit).
     F-Estado:SCREEN-VALUE = cEstadoFlgSit.
     /* Fin 28Ago2023 */

     IF Almcmov.FlgSit = "R" AND Almcmov.FlgEst = "D" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO(*)".
     IF Almcmov.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     /* Motivo */
     FIND FacTabla WHERE FacTabla.CodCia = Almcmov.codcia
         AND FacTabla.Tabla = 'REPOMOTIVO'
         AND FacTabla.Codigo = Almcmov.Libre_c05
         NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla THEN DISPLAY FacTabla.Nombre @ FILL-IN-Motivo.
     /* Urgente */
     IF Almcmov.Libre_L02 = YES THEN DO:
         FILL-IN-Urgente:VISIBLE = YES.
         FILL-IN-Urgente:SCREEN-VALUE = 'URGENTE'.
     END.
     ELSE FILL-IN-Urgente:VISIBLE = NO.
     FIND Almacen WHERE Almacen.CodCia = s-CodCia 
         AND Almacen.CodAlm = Almcmov.AlmacenXD
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN FILL-IN-AlmacenXD:SCREEN-VALUE = Almacen.Descripcion.
     ELSE DO:
         FILL-IN-AlmacenXD:SCREEN-VALUE = "".
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
             AND gn-clie.codcli = Almcmov.AlmacenXD
             NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN FILL-IN-AlmacenXD:SCREEN-VALUE = gn-clie.NomCli.
     END.
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
          Almcmov.CodAlm:SENSITIVE = NO
          Almcmov.AlmDes:SENSITIVE = NO
          Almcmov.CodRef:SENSITIVE = NO
          Almcmov.NroRef:SENSITIVE = NO
          Almcmov.Observ:SENSITIVE = NO
          Almcmov.AlmacenXD:SENSITIVE = NO
          Almcmov.CrossDocking:SENSITIVE = NO
          Almcmov.NroRf3:SENSITIVE = NO
          .
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
  ELSE IF AlmCmov.FlgEst <> "A" THEN DO:
      RUN ALM\R-ImpGui-v2.R (ROWID(Almcmov)). 

      /* Falló la impresión 21/10/2020, queda pendiente de revisar
      RUN gn/p-impresion-gral-gr (INPUT "TRF",
                                  INPUT ROWID(Almcmov),
                                  INPUT 1).
                                  
                                  */
                                  
  END.

  /*R-ImpGui*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-Urgente = "URGENTE".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* *************************************** */
  FIND B-Almacen WHERE B-Almacen.codcia = s-codcia
      AND B-Almacen.codalm = Almcmov.AlmDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN s-NroSer = 000 THEN DO:
          IF AVAILABLE B-Almacen AND s-coddiv <> B-Almacen.coddiv THEN DO:
              MESSAGE 'Número de serie:' s-nroser SKIP
                  'Almacén de salida  :' s-codalm SKIP
                  'Almacén de destino :' B-Almacen.codalm SKIP
                  'Continuamos con la grabación?' 
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  UPDATE rpta-1 AS LOG.
              IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN s-NroSer <> 000 THEN DO:
          IF AVAILABLE B-Almacen AND s-coddiv = B-Almacen.coddiv THEN DO:
              MESSAGE 'Número de serie:' s-nroser SKIP
                  'Almacén de salida  :' s-codalm SKIP
                  'Almacén de destino :' B-Almacen.codalm SKIP
                  'Continuamos con la grabación?' 
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  UPDATE rpta-2 AS LOG.
              IF rpta-2 = NO THEN RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.
  /* *************************************** */

  /* Dispatch standard ADM method.                             */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST ITEM NO-LOCK NO-ERROR.
  IF AVAILABLE ITEM THEN RUN alm/d-trfsal-01.
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reasigna-Pedidos V-table-Win 
PROCEDURE Reasigna-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF Faccpedi.CodRef <> "PED" THEN RETURN "OK".
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER ORDENES FOR Faccpedi.

DEF VAR k AS INT NO-UNDO.
DO k = 1 TO NUM-ENTRIES(Faccpedi.NroRef) ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = ENTRY(k, Faccpedi.nroref)
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        IF LOCKED(PEDIDO) OR AMBIGUOUS(PEDIDO) THEN RETURN 'ADM-ERROR'.
        RETURN 'OK'.
    END.
    ASSIGN
        PEDIDO.flgest = "C"
        PEDIDO.codalm = "11e"
        PEDIDO.divdes = "00000".
    FOR EACH Facdpedi OF PEDIDO:
        ASSIGN Facdpedi.almdes = PEDIDO.codalm.
    END.
    FOR EACH ORDENES WHERE ORDENES.codcia = PEDIDO.codcia
        AND ORDENES.coddiv = PEDIDO.coddiv
        AND ORDENES.coddoc = "O/D"
        AND ORDENES.codref = PEDIDO.coddoc
        AND ORDENES.nroref = PEDIDO.nroped:
        ASSIGN
            ORDENES.FlgSit = "T".   /* Falta Pre-Picking */
        ASSIGN
            ORDENES.codalm = "11e"
            ORDENES.divdes = "00000".
        FOR EACH Facdpedi OF ORDENES:
            ASSIGN Facdpedi.almdes = ORDENES.codalm.
        END.
    END.
END.
IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
IF AVAILABLE(ORDENES) THEN RELEASE ORDENES.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reposicion-Automatica V-table-Win 
PROCEDURE Reposicion-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    input-var-1 = 'R/A'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?.
RUN lkup/c-pedrepaut ('Reposciones Automaticas').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Pedido V-table-Win 
PROCEDURE Restaura-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="Faccpedi.codcia = s-codcia ~
        AND Faccpedi.coddoc = Almcmov.codref ~
        AND Faccpedi.nroped = Almcmov.nroref" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Almdmov.codmat 
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE Facdpedi THEN DO:
            pMensaje = 'No se pudo bloquear el detalle del Pedido por Reposicion Automatica'.
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
        ASSIGN
            Facdpedi.CanAte = Facdpedi.CanAte - Almdmov.candes.
    END.
    ASSIGN
        Faccpedi.FlgEst = 'P'.
END.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
RETURN "OK".

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
       AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen Destino no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almcmov.AlmDes.
       RETURN "ADM-ERROR".   
   END.
   IF Almcmov.AlmDes:SCREEN-VALUE = Almtdocm.CodAlm THEN DO:
       MESSAGE "Almacen no puede transferirse a si mismo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almcmov.AlmDes.
       RETURN "ADM-ERROR".   
   END.
   I-NRO = 0.
   FOR EACH ITEM WHERE ITEM.CanDes > 0:
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "No existen articulos a transferir" VIEW-AS ALERT-BOX ERROR.
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

IF s-status-almacen = NO THEN DO:
    MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.                 
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

