&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    PL-MOV-MES.CodCal = 01 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 101 OR                                 /* Basico */
    PL-MOV-MES.CodMov = 103 OR                                  /* Asig. Familiar */
    PL-MOV-MES.CodMov = 106 OR                                  /* Vacacional */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones Trabajadas*/
    PL-MOV-MES.CodMov = 108 OR                                  /* Vacaciones Truncas */
    PL-MOV-MES.CodMov = 118 OR                                  /* Descanso medico */
    PL-MOV-MES.CodMov = 125 OR                                  /* HE 25% */
    PL-MOV-MES.CodMov = 126 OR                                  /* HE 100% */
    PL-MOV-MES.CodMov = 127 OR                                  /* HE 35% */
    PL-MOV-MES.CodMov = 131 OR                                  /* Bonificacion Incentivo */
    PL-MOV-MES.CodMov = 134 OR                                  /* Bonificacion Especial */
    PL-MOV-MES.CodMov = 136 OR                                  /* Reintegro */
    PL-MOV-MES.CodMov = 138 OR                                  /* Asignación Extraordinaria */
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 100)                                    /* Dias Calendarios */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


