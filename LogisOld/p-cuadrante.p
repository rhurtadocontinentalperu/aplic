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

/* RUTINA QUE PERMITE DETERMINAR SI UNA COORDNEDAD PERTENECE A ALGUN CUADRANTE */

DEF INPUT PARAMETER pLongitud AS DEC.
DEF INPUT PARAMETER pLatitud AS DEC.
DEF OUTPUT PARAMETER pCuadrante AS CHAR.

DEF SHARED VAR s-CodCia AS INT.

DEF VAR x-EjeX AS DEC EXTENT 250 NO-UNDO.
DEF VAR x-EjeY AS DEC EXTENT 250 NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR x-MinX AS DEC NO-UNDO.
DEF VAR x-MaxX AS DEC NO-UNDO.
DEF VAR x-MinY AS DEC NO-UNDO.
DEF VAR x-MaxY AS DEC NO-UNDO.
DEF VAR X0 AS DEC NO-UNDO.
DEF VAR Y0 AS DEC NO-UNDO.
DEF VAR X1 AS DEC NO-UNDO.
DEF VAR Y1 AS DEC NO-UNDO.
DEF VAR Punto-X AS DEC NO-UNDO.
DEF VAR x-Intersecciones AS INT NO-UNDO.

/* Barremos todos los cuadrantes configurados */
pCuadrante = ''.
FOR EACH rut-cuadrante-cab NO-LOCK WHERE rut-cuadrante-cab.CodCia = s-CodCia:
    x-EjeX = 0.
    x-EjeY = 0.
    k = 0.
    /* Cargamos los puntos */
    FOR EACH rut-cuadrante-det OF rut-cuadrante-cab NO-LOCK BY rut-cuadrante-det.punto:
        /* Cada punto es una coordenada el el eje cartesiano */
        k = k + 1 .
        x-EjeX[k] = rut-cuadrante-deta.Longitud.
        x-EjeY[k] = rut-cuadrante-deta.Latitud.
    END.
    IF k <= 2 THEN NEXT.    /* Debe tener al menos 3 puntos definidos */
    /* Veamos si está dentro del cuadrante */
    x-MinX = x-EjeX[1].
    x-MaxX = x-EjeX[1].
    x-MinY = x-EjeY[1].
    x-MaxY = x-EjeY[1].
    DO j = 2 TO k:
        x-MinX = MINIMUM(x-MinX,x-EjeX[j]).
        x-MaxX = MAXIMUM(x-MaxX,x-EjeX[j]).
        x-MinY = MINIMUM(x-MinY,x-EjeY[j]).
        x-MaxY = MAXIMUM(x-MaxY,x-EjeY[j]).
    END.
    /* Si se sale del rango está fuera del polígono */
    IF pLongitud < x-MinX OR pLongitud > x-MaxX THEN NEXT.
    IF pLatitud < x-MinY OR pLatitud > x-MaxY THEN NEXT.
    /* Si la ubicación pertenece a algún vértice => está dentro */
    DO j = 1 TO k:
        IF pLongitud = x-EjeX[j] AND pLatitud = x-EjeY[j] THEN DO:
            pCuadrante = rut-cuadrante-cab.Cuadrante.
            RETURN.
        END.
    END.
    /* Veamos si la ubicación está en los límites del polígono */
    ASSIGN
        X0 = x-EjeX[1]
        Y0 = x-EjeY[1].
    DO j = 2 TO (k + 1):
        IF j = k + 1 THEN   /* Cerrando el polígono: retornamos al punto de inicio */
            ASSIGN
                X0 = x-EjeX[1]
                Y0 = x-EjeY[1].
        ELSE ASSIGN
                X1 = x-EjeX[j]
                Y1 = x-EjeY[j].
        IF (pLatitud >= Y0 AND pLatitud <= Y1) OR (pLatitud >= Y1 AND pLatitud <= Y0) THEN DO:
            IF (pLongitud >= X0 AND pLongitud <= X1) OR (pLongitud >= X1 AND pLongitud <= X0) THEN DO:
                /* Método de triángulos proporcionales */
                IF (Y1 - Y0) / (X1 - X0) = (pLatitud - Y0) / (pLongitud - X0) THEN DO:
                    pCuadrante = rut-cuadrante-cab.Cuadrante.
                    RETURN.
                END.
            END.
        END.
        ASSIGN
            X0 = x-EjeX[j]
            Y0 = x-EjeY[j].
    END.
    /* Punto de interseccion: Método de la línea horizontal */
    ASSIGN
        x-Intersecciones = 0
        X0 = x-EjeX[1]
        Y0 = x-EjeY[1].
    DO j = 2 TO (k + 1):
        IF j = k + 1 THEN   /* Cerrando el polígono: retornamos al punto de inicio */
            ASSIGN
                X1 = x-EjeX[1]
                Y1 = x-EjeY[1].
        ELSE ASSIGN
                X1 = x-EjeX[j]
                Y1 = x-EjeY[j].
        /*MESSAGE 'punto 0' x0 y0 SKIP 'punto 1' x1 y1.*/
        IF (pLatitud >= Y0 AND pLatitud <= Y1) OR (pLatitud >= Y1 AND pLatitud <= Y0) THEN DO:
            /* Determinamos la ecuacion de la recta sabiendo el valor de Y */
            /* X = X0 + (X1 - X0) / (Y1 - Y0) * (Y - Y0) */
            Punto-X = X0 + ( (X1 - X0) / (Y1 - Y0) * (pLatitud - Y0) ).
            /*MESSAGE punto-x plongitud.*/
            IF Punto-X <= pLongitud THEN x-Intersecciones = x-Intersecciones + 1.
        END.
        ASSIGN
            X0 = x-EjeX[j]
            Y0 = x-EjeY[j].
    END.
    /* SI x-Intersecciones es impar => ese está dentro cuadrante */
    IF x-Intersecciones = 1 OR (x-Intersecciones MODULO 2 ) > 0 THEN DO:
        pCuadrante = rut-cuadrante-cab.Cuadrante.
        LEAVE.
    END.
END.

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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


