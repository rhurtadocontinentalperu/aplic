&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR. 

DEF VAR x-FechaIni AS DATE NO-UNDO.
DEF VAR X-FECINI AS DATE NO-UNDO.
DEF VAR X-FECFIN AS DATE NO-UNDO.
DEF VAR F-FECHA AS DATE NO-UNDO.
DEFINE VARIABLE X-CODDOC AS CHAR INIT "L/P".

DEFINE BUFFER B-DMOV FOR ALMDMOV.

FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-CFGPRO THEN DO:
    MESSAGE "Registro de Configuracion de Produccion no existe"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE TEMP-TABLE T-Prod 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Alm 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .


DEFINE TEMP-TABLE T-Merm 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Horas 
       FIELD CodPer LIKE Pl-PERS.CodPer
       FIELD DesPer AS CHAR FORMAT "X(45)"
       FIELD TotMin AS DECI FORMAT "->>>,>>9.99"
       FIELD TotHor AS DECI FORMAT "->>>,>>9.99"
       FIELD Factor AS DECI EXTENT 10 FORMAT "->>9.99" .

DEFINE TEMP-TABLE T-Gastos
       FIELD CodGas LIKE PR-ODPDG.CodGas
       FIELD CodPro LIKE PR-ODPDG.CodPro
       FIELD Total  LIKE Almdmov.CanDes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Factor Btn_OK FILL-IN-Fecha-1 ~
Btn_Cancel FILL-IN-Fecha-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Factor FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Factor AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Factor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Procesar desde el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-Factor AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 6
     Btn_OK AT ROW 1.54 COL 49
     FILL-IN-Fecha-1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 2
     Btn_Cancel AT ROW 2.77 COL 49
     FILL-IN-Fecha-2 AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 8
     f-Mensaje AT ROW 5.04 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     SPACE(13.13) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "REGNERACION D LIQUIDACIONES"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* REGNERACION D LIQUIDACIONES */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    ASSIGN fill-in-Fecha-1 fill-in-Fecha-2 FILL-IN-Factor.

    IF FILL-in-Factor <= 0 THEN DO:
        MESSAGE 'Ingrese el factor' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    FOR EACH PR-LIQC WHERE PR-LIQC.codcia = s-codcia
        AND PR-LIQC.flgest <> 'A'
        AND PR-LIQC.fchliq >= FILL-IN-Fecha-1
        AND PR-LIQC.fchliq <= FILL-IN-Fecha-2,
        FIRST PR-ODPC NO-LOCK WHERE PR-ODPC.codcia = s-codcia
        AND PR-ODPC.NumOrd = PR-LIQC.NumOrd:
        f-Mensaje:SCREEN-VALUE = '** PROCESANDO ' + PR-LIQC.NumLiq.
        ASSIGN
            X-FECINI = PR-LIQC.fecini
            X-FECFIN = PR-LIQC.fecfin
            F-FECHA  = PR-LIQC.fecfin.

        RUN Crea-Tempo-Prod.
        RUN Crea-Tempo-Alm.
        RUN Crea-Tempo-Merma.
        RUN Crea-Tempo-Horas.
        RUN Crea-Tempo-Gastos.
        RUN Genera-Totales.
        RUN Actualizar-Costos.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 gDialog
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME gDialog /* Procesar desde el */
DO:
    IF s-user-id <> 'ADMIN' THEN DO:
        IF INPUT {&self-name} < x-FechaIni THEN RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 gDialog
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME gDialog /* hasta el */
DO:
    IF s-user-id <> 'ADMIN' THEN DO:
        IF INPUT {&self-name} < x-FechaIni THEN RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACT-Alm gDialog 
PROCEDURE ACT-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACT-Gastos gDialog 
PROCEDURE ACT-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Horas gDialog 
PROCEDURE Act-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH PR-MOV-MES WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
                           PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
                           PR-MOV-MES.FchReg >= X-FECINI  AND  
                           PR-MOV-MES.FchReg <= X-FECFIN:
     PR-MOV-MES.Numliq = PR-LIQC.NumLiq.
 END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACT-Merma gDialog 
PROCEDURE ACT-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACT-Prod gDialog 
PROCEDURE ACT-Prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH PR-LIQCX OF PR-LIQC:
    ASSIGN
        PR-LIQCX.PreUni = PR-LIQC.PreUni
        PR-LIQCX.CtoMat = PR-LIQCX.CanFin * PR-LIQC.PreUni.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Costos gDialog 
PROCEDURE Actualizar-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FOR EACH Almcmov WHERE Almcmov.Codcia = S-CODCIA 
        AND Almcmov.CodAlm = PR-ODPC.CodAlm 
        AND Almcmov.TipMov = PR-CFGPRO.TipMov[2] 
        AND Almcmov.Codmov = PR-CFGPRO.CodMov[2] 
        AND Almcmov.CodRef = "OP" 
        AND Almcmov.Nroref = PR-ODPC.NumOrd 
        AND Almcmov.FchDoc >= PR-LIQC.FecIni 
        AND Almcmov.FchDoc <= PR-LIQC.FecFin:
        ASSIGN
            Almcmov.ImpMn1 = 0
            Almcmov.ImpMn2 = 0
            Almcmov.CodMon = 1.
        FOR EACH Almdmov OF Almcmov:
            /*
            IF pr-liqc.numliq = '001606' THEN MESSAGE almcmov.codalm almcmov.tipmov almcmov.codmov almcmov.nrodoc almdmov.codmat.
            */
            ASSIGN
                Almdmov.Codmon = Almcmov.CodMon
                Almdmov.ImpCto = PR-LIQC.PreUni * Almdmov.CanDes 
                Almdmov.PreLis = PR-LIQC.PreUni 
                Almdmov.PreUni = PR-LIQC.PreUni 
                Almdmov.Dsctos[1] = 0
                Almdmov.Dsctos[2] = 0
                Almdmov.Dsctos[3] = 0           
                Almdmov.ImpMn1    = PR-LIQC.PreUni * Almdmov.CanDes  
                Almdmov.ImpMn2    = PR-LIQC.PreUni * Almdmov.CanDes / Almcmov.TpoCmb.
            IF Almcmov.codmon = 1 THEN Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.ImpMn1.
            ELSE Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.ImpMn2.
        END.        
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Alm gDialog 
PROCEDURE Crea-Tempo-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  
  FOR EACH T-Alm:
      DELETE T-Alm.
  END.
  
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = PR-ODPC.CodAlm AND
                               Almcmov.TipMov = PR-CFGPRO.TipMov[1] AND
                               Almcmov.Codmov = PR-CFGPRO.CodMov[1] AND
                               Almcmov.CodRef = "OP" AND
                               Almcmov.Nroref = PR-ODPC.NumOrd AND
                               Almcmov.FchDoc >= X-FECINI AND
                               Almcmov.FchDoc <= X-FECFIN:
      FOR EACH Almdmov OF Almcmov NO-LOCK:
          F-STKGEN = 0.
          F-VALCTO = 0.
          F-PRECIO = 0.
          F-TOTAL  = 0.
          FIND B-DMOV WHERE ROWID(B-DMOV) = ROWID(almdmov) NO-LOCK NO-ERROR.
          REPEAT:           
             FIND PREV B-DMOV WHERE B-DMOV.Codcia = S-CODCIA AND
                                    B-DMOV.CodMat = Almdmov.CodMat AND
                                    B-DMOV.FchDoc <= Almdmov.FchDoc 
                                    USE-INDEX Almd02
                                    NO-LOCK NO-ERROR.
             IF ERROR-STATUS:ERROR THEN LEAVE.
             IF B-DMOV.StkAct > 0 THEN LEAVE.
          END.      
          IF AVAILABLE B-DMOV THEN DO:
             F-PRECIO = B-DMOV.Vctomn1 .
             F-TOTAL  = F-PRECIO * Almdmov.CanDes.
          END.
          FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                              Almmmatg.CodMat = Almdmov.Codmat
                              NO-LOCK NO-ERROR.

         FIND T-Alm WHERE T-Alm.codmat = Almdmov.Codmat
                             NO-ERROR.
         IF NOT AVAILABLE T-Alm THEN DO:
            CREATE T-Alm.
            ASSIGN 
               T-Alm.Codmat = Almdmov.Codmat
               T-Alm.Desmat = Almmmatg.desmat
               T-Alm.UndBas = Almmmatg.undbas.
         END.                         
         T-Alm.CanRea = T-Alm.CanRea + Almdmov.CanDes.    
         T-Alm.Total  = T-Alm.Total  + F-TOTAL.    
      END.        
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Gastos gDialog 
PROCEDURE Crea-Tempo-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR X-UNIDADES AS DECI INIT 0.
    DEFINE VAR X-PRECIo AS DECI INIT 0.

    FOR EACH T-Gastos:
        DELETE T-Gastos.
    END.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha NO-LOCK NO-ERROR.  

    FOR EACH T-Prod:    
        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                            Almmmatg.CodMat = T-Prod.CodMat 
                            NO-LOCK NO-ERROR.
                                
        FOR EACH PR-ODPDG OF PR-ODPC NO-LOCK:
            FIND T-Gastos WHERE T-Gastos.CodGas = PR-ODPDG.CodGas AND
                                T-Gastos.CodPro = PR-ODPDG.CodPro
                                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-Gastos THEN DO:
                CREATE T-Gastos.
                ASSIGN
                T-Gastos.CodGas = PR-ODPDG.CodGas
                T-Gastos.CodPro = PR-ODPDG.CodPro .
            END.
            X-PRECIO = 0.
            FIND PR-PRESER WHERE PR-PRESER.Codcia = PR-ODPDG.Codcia AND
                                 PR-PRESER.CodPro = PR-ODPDG.CodPro AND
                                 PR-PRESER.CodGas = PR-ODPDG.CodGas AND
                                 PR-PRESER.CodMat = T-Prod.CodMat
                                 NO-LOCK NO-ERROR.
            IF AVAILABLE PR-PRESER THEN DO:  
                IF PR-ODPC.CodMon = 1 THEN DO:
                   IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1].
                   IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1] * Gn-Tcmb.Venta .
                END.
                IF PR-ODPC.CodMon = 2 THEN DO:
                   IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1] /  Gn-Tcmb.Venta.
                   IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1]  .
                END.
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                               AND  Almtconv.Codalter = PR-PRESER.UndA 
                               NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                   T-Gastos.Total  = T-Gastos.Total + (X-PRECIO * T-Prod.CanRea) / (PR-PRESER.CanDes[1] * Almtconv.Equival).                    
                END.                    
            END.            
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas gDialog 
PROCEDURE Crea-Tempo-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT "->>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT "->>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.
  
  FOR EACH T-Horas:
      DELETE T-Horas.
  END.
  
FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
                                    PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
                                    PR-MOV-MES.FchReg >= X-FECINI  AND  
                                    PR-MOV-MES.FchReg <= X-FECFIN
                                    BREAK BY PR-MOV-MES.NumOrd
                                          BY PR-MOV-MES.FchReg
                                          BY PR-MOV-MES.CodPer :
     FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer NO-LOCK NO-ERROR.
     X-DESPER = "".
     IF AVAILABLE Pl-PERS THEN X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
     X-HORAI  = PR-MOV-MES.HoraI.
     X-HORA   = 0.
     X-IMPHOR = 0.
     X-TOTA   = 0.
     X-BASE   = 0.
     X-HORMEN = 0.
     X-FACTOR = 0.

     FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
                              PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
                              PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
                              PL-MOV-MES.CodPln  = 01 AND
                              PL-MOV-MES.Codcal  = 0 AND
                              PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
                              (PL-MOV-MES.CodMov = 101 OR
                               PL-MOV-MES.CodMov = 103)  :
         X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
     END.

   FIND LAST PL-VAR-MES WHERE
             PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
             PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes 
             NO-ERROR.

   IF AVAILABLE PL-VAR-MES 
   THEN ASSIGN
       X-HORMEN = PL-VAR-MES.ValVar-MES[11]
       X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].
   X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.


   FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA:
       IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
          IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
             X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
             X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
             X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
             X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
             X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
             LEAVE.
          END.
          IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
             X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
             X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
             X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
             X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
             X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
             X-HORAI = PR-CFGPL.HoraF.
          END.
       END.
   END.               
   X-IMPHOR = X-IMPHOR * 60 .         
   X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
   X-SEGI = TRUNCATE(PR-MOV-MES.HoraI,0) * 60 + (PR-MOV-MES.HoraI - TRUNCATE(PR-MOV-MES.HoraI,0)) * 100 . 

   FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer 
                      NO-ERROR.
   IF NOT AVAILABLE T-Horas THEN DO:
      CREATE T-Horas.
      ASSIGN 
      T-Horas.CodPer = PR-MOV-MES.CodPer
      T-Horas.DesPer = X-DESPER .
   END.
   ASSIGN
   T-Horas.TotMin = T-Horas.TotMin +  X-SEGF - X-SEGI .
   T-Horas.TotHor = T-Horas.TotHor + X-TOTA[10] .
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Merma gDialog 
PROCEDURE Crea-Tempo-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR I AS INTEGER.
DEFINE VAR F-STKGEN AS DECI .
DEFINE VAR F-VALCTO AS DECI .
DEFINE VAR F-PRECIO AS DECI.
DEFINE VAR F-TOTAL AS DECI.

FOR EACH T-Merm:
    DELETE T-Merm.
END.


  FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = PR-ODPC.CodAlm AND
                               Almcmov.TipMov = PR-CFGPRO.TipMov[3] AND
                               Almcmov.Codmov = PR-CFGPRO.CodMov[3]  AND
                               Almcmov.CodRef = "OP" AND
                               Almcmov.Nroref = PR-ODPC.NumOrd AND
                               Almcmov.FchDoc >= X-FECINI AND
                               Almcmov.FchDoc <= X-FECFIN:
      FOR EACH Almdmov OF Almcmov NO-LOCK:  
          FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                              Almmmatg.CodMat = Almdmov.Codmat
                              NO-LOCK NO-ERROR.
         FIND T-Merm WHERE T-Merm.codmat = Almdmov.Codmat NO-ERROR.
         IF NOT AVAILABLE T-Merm THEN DO:
            CREATE T-Merm.
            ASSIGN 
               T-Merm.Codmat = Almdmov.Codmat
               T-Merm.Desmat = Almmmatg.desmat
               T-Merm.UndBas = Almmmatg.undbas.
         END.                         
         T-Merm.CanRea = T-Merm.CanRea + Almdmov.CanDes.    
      END.        
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Prod gDialog 
PROCEDURE Crea-Tempo-Prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  
  FOR EACH T-Prod:
      DELETE T-Prod.
  END.

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = PR-ODPC.CodAlm AND
                               Almcmov.TipMov = PR-CFGPRO.TipMov[2] AND
                               Almcmov.Codmov = PR-CFGPRO.CodMov[2] AND
                               Almcmov.CodRef = "OP" AND
                               Almcmov.Nroref = PR-ODPC.NumOrd AND
                               Almcmov.FchDoc >= X-FECINI AND
                               Almcmov.FchDoc <= X-FECFIN:
      FOR EACH Almdmov OF Almcmov NO-LOCK:
          F-STKGEN = AlmDMOV.StkAct .
          F-PRECIO = AlmDMOV.Vctomn1 .
          F-TOTAL  = F-PRECIO * Almdmov.CanDes.
          FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                              Almmmatg.CodMat = Almdmov.Codmat
                              NO-LOCK NO-ERROR.
         FIND T-Prod WHERE T-Prod.codmat = Almdmov.Codmat NO-ERROR.
         IF NOT AVAILABLE T-Prod THEN DO:
            CREATE T-Prod.
            ASSIGN 
               T-Prod.Codmat = Almdmov.Codmat
               T-Prod.Desmat = Almmmatg.desmat
               T-Prod.UndBas = Almmmatg.undbas.
         END.                         
         T-Prod.CanRea = T-Prod.CanRea + Almdmov.CanDes.    
         T-Prod.Total  = T-Prod.Total  + F-TOTAL.    
      END.        
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Factor FILL-IN-Fecha-1 FILL-IN-Fecha-2 f-Mensaje 
      WITH FRAME gDialog.
  ENABLE FILL-IN-Factor Btn_OK FILL-IN-Fecha-1 Btn_Cancel FILL-IN-Fecha-2 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Totales gDialog 
PROCEDURE Genera-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha NO-LOCK NO-ERROR.  

DO:
/*     ASSIGN                       */
/*     PR-LIQC.Usuario = S-USER-ID. */

    ASSIGN
        PR-LIQC.CanFin = 0
        PR-LIQC.Factor = FILL-IN-Factor.
    FOR EACH PR-LIQCX OF PR-LIQC:
        DELETE PR-LIQCX.
    END.
    FOR EACH T-Prod:
        ASSIGN
            PR-LIQC.CanFin = PR-LIQC.CanFin + T-Prod.CanRea .
        CREATE PR-LIQCX.
        ASSIGN
            PR-LIQCX.Codcia = PR-LIQC.Codcia 
            PR-LIQCX.CanFin = T-Prod.CanRea
            PR-LIQCX.codart = T-Prod.Codmat
            PR-LIQCX.CodUnd = T-Prod.UndBas
            PR-LIQCX.CtoTot = T-Prod.Total
            PR-LIQCX.Numliq = PR-LIQC.NumLiq 
            PR-LIQCX.NumOrd = PR-LIQC.NumOrd
            PR-LIQCX.PreUni = T-Prod.Total / T-Prod.CanRea.
    END.
    
    ASSIGN
        PR-LIQC.CtoMat = 0.
    FOR EACH PR-LIQD1 OF PR-LIQC:
        DELETE PR-LIQD1.
    END.
    FOR EACH T-Alm:
        PR-LIQC.CtoMat = PR-LIQC.CtoMat + T-Alm.Total.
        CREATE PR-LIQD1.
        ASSIGN
            PR-LIQD1.Codcia = PR-LIQC.Codcia 
            PR-LIQD1.CanDes = T-Alm.CanRea
            PR-LIQD1.codmat = T-Alm.Codmat
            PR-LIQD1.CodUnd = T-Alm.UndBas
            PR-LIQD1.ImpTot = T-Alm.Total
            PR-LIQD1.Numliq = PR-LIQC.NumLiq 
            PR-LIQD1.NumOrd = PR-LIQC.NumOrd
            PR-LIQD1.PreUni = T-Alm.Total / T-Alm.CanRea.
    END.

    ASSIGN
        PR-LIQC.CtoHor = 0.
    FOR EACH PR-LIQD2 OF PR-LIQC:
        DELETE PR-LIQD2.
    END.
    FOR EACH T-Horas:
        CREATE PR-LIQD2.
        ASSIGN
            PR-LIQD2.CodCia = PR-LIQC.Codcia 
            PR-LIQD2.codper = T-Horas.CodPer
            PR-LIQD2.Horas  = TRUNCATE(T-Horas.Totmin / 60 ,0 ) + (( T-Horas.TotMin MOD 60 ) / 100 )
            PR-LIQD2.HorVal = T-Horas.TotHor
            PR-LIQD2.Numliq = PR-LIQC.NumLiq
            PR-LIQD2.NumOrd = PR-LIQC.NumOrd
            PR-LIQC.CtoHor = PR-LIQC.CtoHor + T-Horas.TotHor.
    END.

    ASSIGN
        PR-LIQC.CtoGas = 0.
    FOR EACH PR-LIQD3 OF PR-LIQC:
        DELETE PR-LIQD3.
    END.
    FOR EACH T-Gastos:
        CREATE PR-LIQD3.
        ASSIGN
            PR-LIQD3.CodCia = PR-LIQC.Codcia 
            PR-LIQD3.codGas = T-Gastos.CodGas
            PR-LIQD3.CodPro = T-Gastos.CodPro
            PR-LIQD3.ImpTot = T-Gastos.Total
            PR-LIQD3.Numliq = PR-LIQC.NumLiq
            PR-LIQD3.NumOrd = PR-LIQC.NumOrd
            PR-LIQC.CtoGas  = PR-LIQC.CtoGas + T-Gastos.Total.
    END.

    FOR EACH PR-LIQD4 OF PR-LIQC:
        DELETE PR-LIQD4.
    END.
    FOR EACH T-Merm:
        CREATE PR-LIQD4.
        ASSIGN
            PR-LIQD4.Codcia = PR-LIQC.Codcia 
            PR-LIQD4.CanDes = T-Merm.CanRea
            PR-LIQD4.codmat = T-Merm.Codmat
            PR-LIQD4.CodUnd = T-Merm.UndBas
            PR-LIQD4.ImpTot = T-Merm.Total
            PR-LIQD4.Numliq = PR-LIQC.NumLiq 
            PR-LIQD4.NumOrd = PR-LIQC.NumOrd.
    END.

    ASSIGN
        PR-LIQC.CtoFab = FILL-IN-Factor * PR-LIQC.CtoHor
        PR-LIQC.CtoTot = PR-LIQC.CtoMat + PR-LIQC.CtoHor + PR-LIQC.CtoGas + PR-LIQC.CtoFab
        PR-LIQC.PreUni = PR-LIQC.CtoTot / PR-LIQC.CanFin
        PR-LIQC.Factor = IF PR-LIQC.CtoFab > 0 THEN PR-LIQC.Factor ELSE 0.
        
    RUN ACT-Horas.
    RUN ACT-Alm.
    RUN ACT-Merma.
    RUN ACT-Gastos.

    RUN ACT-Prod.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA NO-LOCK NO-ERROR.
  IF AVAILABLE PR-CFGPRO THEN FILL-IN-Factor = PR-CFGPRO.Factor.

  RUN gn/fecha-de-cierre (OUTPUT x-FechaIni).
  ASSIGN
      FILL-IN-Fecha-1 = x-FechaIni
      FILL-IN-Fecha-1 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

