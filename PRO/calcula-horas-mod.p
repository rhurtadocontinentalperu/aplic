&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE T-Horas 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD CodPer LIKE Pl-PERS.CodPer
       FIELD DesPer AS CHAR FORMAT "X(45)"
       FIELD TotMin AS DECI FORMAT "->>>,>>9.99"
       FIELD TotHor AS DECI FORMAT "->>>,>>9.99"
       FIELD Factor AS DECI EXTENT 10 FORMAT "->>9.99" .

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-Horas.
DEFINE INPUT PARAMETER pRowid AS ROWID.
DEFINE INPUT PARAMETER x-FecIni AS DATE.
DEFINE INPUT PARAMETER x-FecFin AS DATE.

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR X-DIAS AS INTEGER INIT 208.
DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
DEFINE VAR X-HORAI AS DECI .
DEFINE VAR X-SEGI AS DECI .
DEFINE VAR X-SEGF AS DECI .
DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
DEFINE VAR X-BASE   AS DECI .
DEFINE VAR X-HORMEN AS DECI .
DEFINE VAR X-FACTOR AS DECI .

FIND PR-ODPC WHERE ROWID(PR-ODPC) = pRowid NO-LOCK.
EMPTY TEMP-TABLE t-Horas.
FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA 
    AND PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  
    AND PR-MOV-MES.FchReg >= X-FECINI  
    AND PR-MOV-MES.FchReg <= X-FECFIN
    BREAK BY PR-MOV-MES.CodPer BY PR-MOV-MES.Periodo BY PR-MOV-MES.NroMes BY PR-MOV-MES.FchReg:
    /* Quiebre por Personal, Periodo y Mes trabajado */
    IF FIRST-OF(PR-MOV-MES.CodPer) OR FIRST-OF(PR-MOV-MES.Periodo) OR FIRST-OF(PR-MOV-MES.NroMes) THEN DO:
        ASSIGN
            X-DESPER = ""
            x-HorMen = 0.
        FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-PERS THEN X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
    END.
    /* Acumulamos las horas trabajadas según producción */
    ASSIGN
        X-HORAI  = PR-MOV-MES.HoraI.
    FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA:
        IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
            IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
               X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
               X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
               x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * (IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).
               LEAVE.
            END.
            IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
               X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
               X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
               x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * ( IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).
               X-HORAI = PR-CFGPL.HoraF.
            END.
        END.
    END.               
    IF LAST-OF(PR-MOV-MES.CodPer) OR LAST-OF(PR-MOV-MES.Periodo) OR LAST-OF(PR-MOV-MES.NroMes) THEN DO:
        ASSIGN
            x-Base = 0
            x-Dias = 0
            x-ImpHor = 0.
        /* Calculamos el Valor Hora de acuerdo a la planilla */
        FIND PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
            PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
            PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND
            PL-MOV-MES.CodPln  = 01 AND
            PL-MOV-MES.Codcal  = 01 AND
            PL-MOV-MES.CodMov  = 100    /* DIAS TRABAJADOS */
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN x-Dias = PL-MOV-MES.ValCal-Mes.
        /* BOLETA DE SUELDOS 101 Sueldo 103 Asig. fam 117 Alimentacion 125 HHEE 25% 126 HHEE 100% 127 HHEE 35% 301 ESSALUD 
        113 Refrigerio 306 Senati*/
        FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
            PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
            PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND
            PL-MOV-MES.CodPln  = 01 AND
            PL-MOV-MES.Codcal  = 01 AND
            LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"101,103,117,113,125,126,127,301,306") > 0 NO-LOCK:          
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
        END.
        /* BOLETA DE GRATIFICACIONES 144 Asig, Extr Grat. 9% */
        FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
            PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
            PL-MOV-MES.CodPln  = 01 AND
            PL-MOV-MES.Codcal  = 04 AND
            PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
            LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"144") > 0 NO-LOCK:          
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
        END.
        /* BOLETAS DE PROVISIONES - Calculo 09,10,11 */
        FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
            PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
            PL-MOV-MES.CodPln  = 01 AND
            LOOKUP(STRING(PL-MOV-MES.Codcal,"99"),"09,10,11") > 0  AND
            PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND
            PL-MOV-MES.CodMov  = 403 NO-LOCK:          
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
        END.
        IF x-Dias > 0 THEN x-ImpHor = x-Base / x-Dias / 8.  /* IMPORTE HORA */
        /* Acumulamos por cada trabajador */
        FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.
        IF NOT AVAILABLE T-Horas THEN DO:
           CREATE T-Horas.
           ASSIGN 
               T-Horas.CodCia = s-codcia
               T-Horas.CodPer = PR-MOV-MES.CodPer
               T-Horas.DesPer = X-DESPER .
        END.
        ASSIGN
            T-Horas.TotMin = T-Horas.TotMin +  x-HorMen
            T-Horas.TotHor = T-Horas.TotHor + ( ( x-HorMen / 60 ) * x-ImpHor ).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


