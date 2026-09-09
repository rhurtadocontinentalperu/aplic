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
         HEIGHT             = 4.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
FOR EACH tmp-detalle:
    i-Campo = 1.
    x-LLave = ''.
    x-Campo = ''.
    x-Titulo = ''.
    IF RADIO-SET-Tipo = 2 THEN DO:
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'CAMPAÑA' + '|'.
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'PERIODO' + '|'.
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'MES' + '|'.
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'CAMPAÑA' + '|'.
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'DIA' + '|'.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        /* DIVISION */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'DIVISION' + '|'.
        /* CANAL VENTA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-LLave = x-LLave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'CANAL-VENTA' + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        /* CLIENTE */
        IF TOGGLE-Resumen-Depto = NO THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'CLIENTE' + '|'. ELSE x-Titulo = x-Titulo + 'CLIENTE' + '|'.
        END.
        /* CANAL DEL CLIENTE */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-LLave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'CANAL-CLIENTE' + '|'. ELSE x-Titulo = x-Titulo + 'CANAL-CLIENTE' + '|'.
        /* TARJETA CLIENTE EXCLUSIVO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-LLave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'TARJETA-CLIENTE' + '|'. ELSE x-Titulo = x-Titulo + 'TARJETA-CLIENTE' + '|'.
        /* DEPARTAMENTO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'DEPARTAMENTO' + '|'. ELSE x-Titulo = x-Titulo + 'DEPARTAMENTO' + '|'.
        /* PROVINCIA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'PROVINCIA' + '|'. ELSE x-Titulo = x-Titulo + 'PROVINCIA' + '|'.
        /* DISTRITO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        IF x-Titulo = '' THEN x-Titulo = 'DISTRITO' + '|'. ELSE x-Titulo = x-Titulo + 'DISTRITO' + '|'.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        /* ZONA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'ZONA' + '|'. ELSE x-Titulo = x-Titulo + 'ZONA' + '|'.
        /* CLASIFICACION */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        IF x-Titulo = '' THEN x-Titulo = 'CLASIFICACION' + '|'. ELSE x-Titulo = x-Titulo + 'CLASIFICACION' + '|'.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        /* CICLO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        IF x-Titulo = '' THEN x-Titulo = 'CICLO' + '|'. ELSE x-Titulo = x-Titulo + 'CICLO' + '|'.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        /* ARTICULO */
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO AND TOGGLE-Resumen-Solo-Linea = NO) THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'ARTICULO' + '|'. ELSE x-Titulo = x-Titulo + 'ARTICULO' + '|'.

            /* LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'LINEA' + '|'.
            /* SUB-LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'SUB-LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'SUB-LINEA' + '|'.
            /* MARCA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'MARCA' + '|'. ELSE x-Titulo = x-Titulo + 'MARCA' + '|'.
            /* UNIDAD */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'UNIDAD' + '|'. ELSE x-Titulo = x-Titulo + 'UNIDAD' + '|'.
            /* SUBTIPO Y ASOCIADO */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-Llave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'SUBTIPO' + '|'. ELSE x-Titulo = x-Titulo + 'SUBTIPO' + '|'.
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-Llave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'ASOCIADO' + '|'. ELSE x-Titulo = x-Titulo + 'ASOCIADO' + '|'.
        END.
        ELSE DO:
            IF TOGGLE-Resumen-Linea = YES THEN DO:
                /* LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'LINEA' + '|'.
                /* SUB-LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'SUB-LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'SUB-LINEA' + '|'.
            END.
            IF TOGGLE-Resumen-Solo-Linea = YES THEN DO:
                /* LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'LINEA' + '|'.
            END.
            IF TOGGLE-Resumen-Marca = YES THEN DO:
                /* MARCA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'MARCA' + '|'. ELSE x-Titulo = x-Titulo + 'MARCA' + '|'.
            END.
        END.
        /* LICENCIA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'LICENCIA' + '|'. ELSE x-Titulo = x-Titulo + 'LICENCIA' + '|'.
        /* PROVEEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'PROVEEDOR' + '|'. ELSE x-Titulo = x-Titulo + 'PROVEEDOR' + '|'.
    END.
    IF TOGGLE-CodVen = YES THEN DO:
        /* VENDEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'VENDEDOR' + '|'. ELSE x-Titulo = x-Titulo + 'VENDEDOR' + '|'.
    END.
    x-Titulo = x-Titulo + 'CANTIDAD' + '|' + 'VENTA-DOLARES' + '|' + 'VENTA-SOLES'.
    x-Llave = x-Llave + STRING(tmp-detalle.CanxMes, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(tmp-detalle.VtaxMesMe, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(tmp-detalle.VtaxMesMn, '->>>>>>>>9.99').
    IF pParametro = '+COSTO' THEN DO:
        x-Titulo = x-Titulo + '|'.
        x-Llave = x-Llave + '|'.
        x-Titulo = x-Titulo + 'COSTO-DOLARES' + '|' + 'COSTO-SOLES' + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.CtoxMesMe, '->>>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.CtoxMesMn, '->>>>>>>>9.99') + '|'.
        x-Titulo = x-Titulo + 'PROMEDIO-DOLARES' + '|' + 'PROMEDIO-SOLES'.
        x-Llave = x-Llave + STRING(tmp-detalle.ProxMesMe, '->>>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.ProxMesMn, '->>>>>>>>9.99').
    END.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
    IF l-Titulo = NO THEN DO:
        PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
        l-Titulo = YES.
    END.
    PUT STREAM REPORTE UNFORMATTED x-LLave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
    IF x-Cuenta-Registros > iLimite THEN DO:
        MESSAGE 'Se ha llegado al tope de' iLimite 'registros que soporta el Excel' SKIP
            'Carga abortada' VIEW-AS ALERT-BOX WARNING.
        LEAVE.
    END.
END.
OUTPUT STREAM REPORTE CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


