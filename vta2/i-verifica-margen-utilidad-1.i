&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Verifica los margenes de utilidad de la venta
                    y si es muy bajo debe ser aprobado por sercretaria de GG (W)

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

    DEF VAR dDscto AS DEC.
    DEF VAR f-DtoMax AS DEC.
    DEF VAR s-Tipo AS CHAR.
    DEF VAR s-Nivel AS CHAR.

    /* Buscamos la cotizacion de origen */
    FIND FIRST B-CPedi WHERE B-CPedi.CodCia = Faccpedi.CodCia 
        AND B-CPedi.CodDiv = Faccpedi.CodDiv
        AND B-CPedi.CodDoc = Faccpedi.CodRef
        AND B-CPedi.NroPed = Faccpedi.NroRef   
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-CPedi THEN DO:
        FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
            AND  FacUsers.Usuario = B-CPEDI.UsrDscto
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacUsers THEN DO:
            s-Nivel = SUBSTRING(FacUsers.Niveles,1,2).
            FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, 
                FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = B-DPEDI.codmat:
                /*Busca en lista de excepciones*/
                /*  Ic - 19Set2024, coordinacion con Ruben se deja sin efecto
                RUN vta\p-parche-precio-uno (s-codDiv, B-CPEDI.UsrDscto, B-DPEDI.CodMat, OUTPUT dDscto).        
                IF B-DPEDI.Por_Dscto[1] <= dDscto THEN NEXT.
                */
                /*Descuentos Permitidos*/
                /* 22/02/2023 Esta tabla solo le da mantenimento S00*/
                FIND gn-clieds WHERE gn-clieds.CodCia = cl-CodCia 
                    AND gn-clieds.CodCli = B-CPEDI.CodCli 
                    AND ((gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) OR
                         (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) OR
                         (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) OR
                         (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY)) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clieds THEN DO:
                    f-DtoMax = gn-clieds.dscto.
                    IF DECIMAL(B-DPEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.        
                END.
                ELSE DO:
                    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
                    FIND Almtabla WHERE almtabla.Tabla =  "NA" 
                        AND almtabla.Codigo = s-nivel NO-LOCK NO-ERROR.
                    CASE almtabla.Codigo:
                        WHEN "D1" THEN f-DtoMax = FacCfgGn.DtoMax.
                        WHEN "D2" THEN f-DtoMax = FacCfgGn.DtoDis.
                        WHEN "D3" THEN f-DtoMax = FacCfgGn.DtoMay.
                        WHEN "D4" THEN f-DtoMax = FacCfgGn.DtoPro.
                    END CASE.
                    IF DEC(B-DPEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.
                END.
                /*Validando Margen*/        
                IF B-DPEDI.Libre_d01 <= 0 THEN s-tipo = 'Si'.
            END.
            IF s-Tipo = "SI" THEN DO:
                ASSIGN
                    FacCPedi.Flgest = 'W'
                    FacCPedi.Libre_c05 = "MARGENES DE UTILIDAD BAJOS".
            END.
        END.
    END.

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
         HEIGHT             = 3.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


