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

DEFINE INPUT  PARAMETER Numero    AS DECIMAL.
DEFINE INPUT  PARAMETER Decimales AS INTEGER.
DEFINE INPUT  PARAMETER TpoPre    AS INTEGER.
DEFINE OUTPUT PARAMETER NumTexto  AS CHARACTER.

DEFINE VARIABLE Texto   AS CHARACTER.
DEFINE VARIABLE Texto1  AS CHARACTER.
DEFINE VARIABLE Entero  AS CHARACTER.
DEFINE VARIABLE Decimal AS CHARACTER.
DEFINE VARIABLE Unidades  AS CHARACTER EXTENT 20
    INITIAL [ "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", 
                "nueve", "diez", "once", "doce", "trece", "catorce", "quince",
                "dieciseis", "diecisiete", "dieciocho", "diecinueve", "veinte" ].

DEFINE VARIABLE Decenas   AS CHARACTER EXTENT 10
    INITIAL [ "diez", "veint", "treint", "cuarent", "cincuent", "sesent", 
              "setent", "ochent", "novent", "cien" ].
   
DEFINE VARIABLE Centenas  AS CHARACTER EXTENT 10
    INITIAL [ "cien", "docientos", "trecientos", "cuatrocientos", "quinientos",
             "seiscientos", "setecientos", "ochocientos", "novecientos", "mil" ].                  

DEFINE VARIABLE Digito1 AS CHARACTER.
DEFINE VARIABLE Digito2 AS CHARACTER.
DEFINE VARIABLE Digito3 AS CHARACTER.
DEFINE VARIABLE i       AS INTEGER.
DEFINE VARIABLE x       AS INTEGER.

Decimal  = SUBSTRING( STRING(Numero,">>>>>>>>>>>>>>>9.999999"), 18, Decimales).
Entero   = LEFT-TRIM( SUBSTRING( STRING(Numero,">>>>>>>>>>>>>>>9.9999"), 1, 16) ).
NumTexto = "".
i        = LENGTH(Entero).
x        = 0.


REPEAT WHILE i > 0 : 

    IF i > 3 
    THEN  Texto1 = SUBSTRING(Entero, i - 2, 3).
    ELSE  Texto1 = SUBSTRING(Entero, 1, i).
       
    Digito1   = " ". 
    Digito2   = " ".
    Digito3   = " ".
    Texto     = "".
    
    CASE LENGTH(Texto1):
        WHEN 1 THEN Digito1 = Texto1.
        WHEN 2 THEN DO: 
                    Digito1   = SUBSTRING(Texto1, 2, 1).        /* El Ultimo D¡gito */
                    Digito2   = SUBSTRING(Texto1, 1, 1).        /* Pen£ltimo D¡gito */
                    END.
        OTHERWISE   DO:
                    Digito1   = SUBSTRING(Texto1, 3, 1).        /* El Ultimo D¡gito */
                    Digito2   = SUBSTRING(Texto1, 2, 1).        /* Pen£ltimo D¡gito */
                    Digito3   = SUBSTRING(Texto1, 1, 1).        /* Antepen£ltimo D¡gito */
                    END.
    END CASE.
    
    IF Digito1 > "0" THEN Texto = Unidades[ INTEGER(Digito1) ].

    CASE Digito2:
        WHEN " " THEN .
        WHEN "0" THEN .
        WHEN "1" THEN Texto = Unidades[ INTEGER( Digito2 + Digito1 ) ].
        WHEN "2" THEN IF Digito1 = "0" THEN Texto = Decenas[ INTEGER(Digito2) ] + "e". 
                                       ELSE Texto = Decenas[ INTEGER(Digito2) ] + "i" + Texto.
        OTHERWISE     IF Digito1 = "0" THEN Texto = Decenas[ INTEGER(Digito2) ] + "a". 
                                       ELSE Texto = Decenas[ INTEGER(Digito2) ] + "a y " + Texto.
    END CASE.

    CASE Digito3:
        WHEN " " THEN .
        WHEN "0" THEN .
        WHEN "1" THEN IF LENGTH( Texto ) = 0 THEN Texto = "cien" .
                                             ELSE Texto = "ciento " + Texto.
        OTHERWISE Texto = Centenas[ INTEGER(Digito3) ] + " " + Texto.
    END CASE.                                          

    IF i > 0 AND LENGTH(Texto) > 2 AND SUBSTRING(Texto, LENGTH(Texto) - 2) = "uno"
    THEN Texto = SUBSTRING(Texto, 1, LENGTH(Texto) - 1).

    CASE x:
        WHEN 0 THEN NumTexto = TRIM(Texto).
        WHEN 1 OR WHEN 3 OR WHEN 5 THEN
           IF INTEGER(Texto1) > 0 THEN  NumTexto = TRIM(Texto) + " mil " + NumTexto.
        WHEN 2 THEN 
           IF Texto = "un" THEN NumTexto = TRIM(Texto) + " millon " + NumTexto.
                           ELSE NumTexto = TRIM(Texto) + " millones " + NumTexto.
        WHEN 4 THEN 
            DO:
                IF NumTexto = "millones"  THEN NumTexto = "".
                IF Texto = "un" THEN NumTexto = TRIM(Texto) + " billon " + NumTexto.
                                ELSE NumTexto = TRIM(Texto) + " billones " + NumTexto.
            END.
    END CASE.    

    x = x + 1.
    i = i - 3.

END.

IF LENGTH(NumTexto) = 0 THEN  NumTexto = "cero".
IF LENGTH(NUmTexto) = 2 AND NumTexto = 'un' THEN NumTexto = 'uno'.

IF Decimales > 0 THEN NumTexto = NumTexto + " con " + Decimal + "/100".


CASE TpoPre:
    WHEN 1 THEN NumTexto = CAPS(NumTexto).
    WHEN 3 THEN NumTexto = CAPS( SUBSTRING(NumTexto, 1, 1) ) + SUBSTRING(NumTexto, 2).
END CASE.

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
         HEIGHT             = 4.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


