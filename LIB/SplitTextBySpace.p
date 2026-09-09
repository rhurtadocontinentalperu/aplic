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

    DEFINE INPUT  PARAMETER ip-Texto      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ip-Longitud   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER op-ListaTexto AS CHARACTER NO-UNDO.

    DEFINE VARIABLE v-TextoRestante AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-Corte         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE v-Fragmento     AS CHARACTER NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*******************************************************************************
 * Procedimiento: SplitTextBySpace
 * Objetivo: Cortar un texto por longitud sin romper palabras (Compatible 10.1C)
 *******************************************************************************/

    /* Limpieza inicial */
    v-TextoRestante = TRIM(ip-Texto).
    op-ListaTexto   = "".

    /* Validar longitud para evitar bucles infinitos */
    IF ip-Longitud <= 0 THEN RETURN.

    REPEAT WHILE LENGTH(v-TextoRestante) > 0:
        
        /* 1. Si lo que queda ya cabe en la longitud, terminar */
        IF LENGTH(v-TextoRestante) <= ip-Longitud THEN DO:
            v-Fragmento = v-TextoRestante.
            v-TextoRestante = "".
        END.
        ELSE DO:
            /* 2. Buscar el último espacio en blanco dentro del rango permitido */
            /* SUBSTRING en 10.1C es estable para esta operación */
            v-Corte = R-INDEX(SUBSTRING(v-TextoRestante, 1, ip-Longitud + 1), " ").

            /* 3. Si no hay espacios (palabra muy larga), forzar corte al límite */
            IF v-Corte = 0 THEN v-Corte = ip-Longitud.

            v-Fragmento = SUBSTRING(v-TextoRestante, 1, v-Corte).
            
            /* 4. Reemplazo de LTRIM: Usamos TRIM simple sobre el remanente */
            v-TextoRestante = TRIM(SUBSTRING(v-TextoRestante, v-Corte + 1)).
        END.

        /* 5. Acumular en la lista de salida */
        v-Fragmento = TRIM(v-Fragmento).
        
        IF v-Fragmento <> "" THEN DO:
            IF op-ListaTexto = "" THEN 
                op-ListaTexto = v-Fragmento.
            ELSE 
                op-ListaTexto = op-ListaTexto + "," + v-Fragmento.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


