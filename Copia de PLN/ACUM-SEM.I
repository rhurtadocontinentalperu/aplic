&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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
    END.
    sem-i = sem-i - 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


