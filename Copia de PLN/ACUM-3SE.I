&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
/* Procedure Description
"CALCULA PROMEDIOS DE LOS ULTIMOS N PERIDOS
PARA CALCULOS MENSUALES.
{1} MESES DE ACUMULADO
{2} DE QUE CALCULO
{3} DESDE EL CONCEPTO
{4} HASTA EL CONCEPTO
{5} VARIABLE DONDE ACUMULADOS
"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE var-i AS INTEGER.
DEFINE VARIABLE sem-i AS INTEGER.
DEFINE VARIABLE ano-i AS INTEGER.
DEFINE VARIABLE ano-ant  AS INTEGER.
DEFINE VARIABLE sem-ant  AS INTEGER.
DEFINE VARIABLE Primero  AS LOGICAL.
DEFINE VARIABLE x-ok     AS LOGICAL.
DEFINE VARIABLE n-meses  AS INTEGER.
DEFINE VARIABLE n-seman  AS INTEGER.
DEFINE VARIABLE x-ok-sem AS LOGICAL.
DEFINE VARIABLE mes-x    AS INTEGER.
DEFINE VARIABLE mes-ant  AS INTEGER.
sem-i = PL-FLG-SEM.NroSem.
ano-i = s-periodo.

DO var-i = 1 TO {1}:
    IF sem-i = 0 THEN
        ASSIGN
            sem-i = 53
            ano-i = ano-i - 1.
    FOR EACH PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia          AND
        PL-MOV-SEM.Periodo = ano-i             AND
        PL-MOV-SEM.NroSem  = sem-i             AND
        PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln AND
        PL-MOV-SEM.CodCal  = {2}               AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  >= {3}              AND
        PL-MOV-SEM.CodMov  <= {4} NO-LOCK:
        ASSIGN {5} = {5} + PL-MOV-SEM.ValCal-Sem.
        FIND PL-SEM WHERE PL-SEM.CodCia  = PL-MOV-SEM.codcia AND 
             PL-SEM.Periodo = PL-MOV-SEM.periodo AND 
             PL-SEM.NroSem  = PL-MOV-SEM.NroSem NO-LOCK NO-ERROR.
        IF AVAILABLE THEN ASSIGN mes-x = PL-SEM.NroMes.                   
        IF Primero THEN ASSIGN
              Primero = FALSE 
              sem-ant = sem-i
              ano-ant = ano-i
              mes-ant = mes-x
              n-seman = 1
              x-ok-mes = TRUE
              x-ok = TRUE.
        END.    
        ELSE DO:
            IF mes-x = mes-ant THEN DO:   /* Si estoy 
            
            END.
            ELSE DO:
            END. 
        END.        
    END.
    sem-i = sem-i - 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


