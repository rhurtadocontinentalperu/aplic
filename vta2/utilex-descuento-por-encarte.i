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
         HEIGHT             = 3.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
DEF VAR pPorDto2 AS DEC INIT 0 NO-UNDO.
DEF VAR pPreUni  AS DEC NO-UNDO.
DEF VAR x-Control AS LOG INIT NO NO-UNDO.

IF s-FlgSit = "CD" THEN DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = s-codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND TODAY >= VtaCTabla.FechaInicial 
        AND TODAY <= VtaCTabla.FechaFinal
        AND VtaCTabla.llave = s-NroVale    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCTabla THEN DO:
        pPreUni = {&Tabla}.PreUni.  /* Valor por defecto */
        /* Buscamos su porcentaje */
        /* Por articulo */
        FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "M" AND
            Vtadtabla.LlaveDetalle = {&Tabla}.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtabla THEN 
            ASSIGN
            pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01)
            x-Control = YES.
        /* Caso especial: Tiene definido el Precio Unitario */
        IF AVAILABLE Vtadtabla AND Vtadtabla.Libre_d02 > 0 THEN
            ASSIGN
            pPorDto2 = 0
            pPreUni = Vtadtabla.Libre_d02
            x-Control = YES.

        /* Por Proveedor */
        IF x-Control = NO THEN DO:
            FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "P" AND
                Vtadtabla.LlaveDetalle = Almmmatg.CodPr1
                NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtabla THEN 
                ASSIGN
                pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01)
                x-Control = YES.
        END.
        /* Por Linea y/o Sublinea */
        IF x-Control = NO THEN DO:
            FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "L" AND
                Vtadtabla.LlaveDetalle = Almmmatg.CodFam AND
                (Vtadtabla.Libre_c01 = "" OR Vtadtabla.Libre_c01 = Almmmatg.SubFam)
                NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtabla THEN pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01).
        END.
        /* Buscamos si es una excepción */
        /* Por Linea y/o Sublinea */
        FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
            AND Vtadtabla.Libre_c01 = Almmmatg.subfam
            AND Vtadtabla.Tipo = "XL"
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtadtabla THEN DO:
            FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
                AND Vtadtabla.Libre_c01 = ""
                AND Vtadtabla.Tipo = "XL"
                NO-LOCK NO-ERROR.
        END.
       /* Por Producto */
        IF NOT AVAILABLE Vtadtabla THEN DO:
            FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codmat
                AND Vtadtabla.Tipo = "XM"
                NO-LOCK NO-ERROR.
        END.
        IF NOT AVAILABLE Vtadtabla AND pPorDto2 > 0 THEN DO:
            ASSIGN
                {&Tabla}.Por_Dsctos[1] = 0
                {&Tabla}.Por_Dsctos[2] = 0
                {&Tabla}.Por_Dsctos[3] = 0
                {&Tabla}.PorDto2 = pPorDto2
                {&Tabla}.PreUni  = pPreUni
                {&Tabla}.Libre_c04 = "CD".  /* MARCA DESCUENTO POR ENCARTE */
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


