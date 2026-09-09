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
DEFINE VARIABLE mes-i AS INTEGER.
DEFINE VARIABLE ano-i AS INTEGER.

mes-i = mes-actual.
ano-i = s-periodo.
DO var-i = 1 TO {1}:
    IF mes-i = 0 THEN
        ASSIGN
            mes-i = 12
            ano-i = ano-i - 1.
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ano-i             AND
        PL-MOV-MES.NroMes  = mes-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = {2}               AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV  >= {3}              AND
        PL-MOV-MES.CODMOV  <= {4} NO-LOCK:
        ASSIGN {5} = {5} + PL-MOV-MES.ValCal-Mes.
    END.
    mes-i = mes-i - 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


