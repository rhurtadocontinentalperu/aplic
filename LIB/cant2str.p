&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : Cant2Str.p
    Purpose     : Convierte en letras una cantidad, hasta 999,999,999,999.99

    Syntax      : Run Func\Cant2Str.p(INPUT cantidad OUTPUT letras).

    Description : 

    Author(s)   :  Jorge Octavio Olguin Avalos
    Created     : JOA original desde 1997
                  
    Notes       : Se convirtió a structured procedure en 19/03/01
                  
                  Puede ser utilizado en tu aplicación, solo hazmelo saber.
                  Esto es con el fin de engrandecer la labor de nosotros.
                  
                  (c) Jorge Olguin   jorge@olguin.info         México
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT  PARAMETER A AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER B AS CHAR NO-UNDO.

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

RUN MILLoneS(INPUT A, OUTPUT B).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Centenas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Centenas Procedure 
PROCEDURE Centenas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAMETER CEN AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER CENSTR AS CHAR NO-UNDO.
DEF VAR T AS CHAR NO-UNDO.

    IF CEN >= 100 THEN DO:
      IF CEN = 100  
      THEN   CENSTR = "CIEN".
      ELSE   CENSTR = ENTRY(INDEX("123456789", SUBSTRING(STRING(CEN, "999"),1,1)),"CIENTO,DOSCIENTOS,TRESCIENTOS,CUATROCIENTOS,QUINIENTOS,SEISCIENTOS,SETECIENTOS,OCHOCIENTOS,NOVECIENTOS").
    END.
    
    RUN DECENAS(INPUT INTEGER(SUBSTRING(STRING(CEN,"999"),2,2)), OUTPUT T).
    
    IF CENSTR <> ""
    THEN  CENSTR = CENSTR + " " + T.
    ELSE CENSTR = T.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Decenas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Decenas Procedure 
PROCEDURE Decenas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER DEC AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER DECSTR AS CHAR NO-UNDO.
DEF VAR T AS CHAR NO-UNDO.
    
    IF DEC <= 9 THEN DO:
      RUN DIGITOS(INPUT DEC, OUTPUT DECSTR).
      RETURN.
    END.
    
    IF DEC > 10 AND DEC < 16 THEN DO:
      DECSTR = ENTRY(LOOKUP(STRING(DEC,"99"),"11,12,13,14,15"), "ONCE,DOCE,TRECE,CATORCE,QUINCE").
      RETURN.
    END.
    
    IF (DEC MODULO 10) = 0 THEN DO:
      DECSTR = ENTRY(LOOKUP(STRING(DEC,"99"),"10,20,30,40,50,60,70,80,90"),"DIEZ,VEINTE,TREINTA,CUARENTA,CINCUENTA,SESENTA,SETENTA,OCHENTA,NOVENTA").
      RETURN.
    END.
    
    IF DEC > 15 AND DEC < 20 THEN DO:
      RUN DIGITOS(DEC MODULO 10, OUTPUT DECSTR).
      DECSTR = "DIECI" + DECSTR.
      RETURN.
    END.
    
    IF DEC > 20 AND DEC < 30 THEN DO:
      RUN DIGITOS(DEC MODULO 10, OUTPUT DECSTR).
      DECSTR = "VEINTI" + DECSTR.
      RETURN.
    END.
    
    DECSTR = ENTRy(INTEGER(SUBSTRING(STRING(DEC,"99"),1,1)) - 1, ",TREINTA,CUARENTA,CINCUENTA,SESENTA,SETENTA,OCHENTA,NOVENTA").
    RUN DIGITOS(INTEGER(SUBSTRING(STRING(DEC,"99"),2,1)), OUTPUT T).
    
    IF T <> "" THEN  DECSTR = DECSTR + " y " + T.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Digitos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Digitos Procedure 
PROCEDURE Digitos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER DIG AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER DIGSTR AS CHAR NO-UNDO.

  DIGSTR = ENTRY(INDEX("1234567890", string(DIG,"9")), "UN,DOS,TRES,CUATRO,CINCO,SEIS,SIETE,OCHO,NUEVE,,").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Millares) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Millares Procedure 
PROCEDURE Millares :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER MIL AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER MILSTR AS CHAR NO-UNDO.
DEF VAR T AS CHAR NO-UNDO.
DEF VAR TERCETO AS INTEGER NO-UNDO.

    /* el  n£mero se divide en "999,999" (tercetos)*/
    /* XXX,YYY:*/
    
    
    /*XXX*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999"),1,3)).
    
    IF TERCETO  >= 1 THEN DO:
       RUN CENTENAS(INPUT TERCETO, OUTPUT T).
       T = T + " MIL".
       IF MILSTR <> "" 
         THEN MILSTR = MILSTR + " " + T.
         ELSE MILSTR = T.
    END.
    T = "".
    
    /*YYY*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999"),4)).
    IF TERCETO  >= 1 
    THEN  RUN CENTENAS(INPUT TERCETO, OUTPUT T).
    IF MILSTR <> "" 
      THEN MILSTR = MILSTR + " " + T.
      ELSE MILSTR = T.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Millones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Millones Procedure 
PROCEDURE Millones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER MIL AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER MILSTR AS CHAR NO-UNDO.
DEF VAR T AS CHAR NO-UNDO.
DEF VAR TERCETO AS INTEGER NO-UNDO.

    /* el  n£mero se divide en "999,999,999,999" (tercetos)*/
    /* WWW,XXX,YYY,ZZZ:*/
    
    
    /*WWW*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999999999"),1,3)).
    
    IF TERCETO  >= 1 THEN DO:
       RUN CENTENAS(INPUT TERCETO, OUTPUT T).
       T = T + " mil".
           /* preguntar si va a haber decenas de millones, sino, para poner desde ahora "millones" */
           IF INTEGER(SUBSTRING(STRING(MIL,"999999999999"),4,3)) = 0
            THEN T = T + " MILLONES".
         
       IF MILSTR <> "" 
         THEN MILSTR = MILSTR + " " + T.
         ELSE MILSTR = T.
    END.
    T = "".
    
    /*XXX*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999999999"),4,3)).
    IF TERCETO  >= 1 THEN DO: 
       RUN CENTENAS(INPUT TERCETO, OUTPUT T).
       T = T + IF TERCETO = 1 THEN " MILLON" ELSE " MILLONES".
    
       IF MILSTR <> "" 
         THEN MILSTR = MILSTR + " " + T.
         ELSE MILSTR = T.
    END.
    
    
    /*YYY*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999999999"),7,3)).
    
    IF TERCETO  >= 1 THEN DO:
       RUN CENTENAS(INPUT TERCETO, OUTPUT T).
    
       T = T + " MIL".                                
    
       IF MILSTR <> "" 
         THEN MILSTR = MILSTR + " " + T.
         ELSE MILSTR = T.
    END.
    T = "".
    
    /*ZZZ*/
    TERCETO = INTEGER(SUBSTRING(STRING(MIL,"999999999999"),10)).
    IF TERCETO  >= 1 
    THEN  RUN CENTENAS(INPUT TERCETO, OUTPUT T).
    IF MILSTR <> "" 
    THEN MILSTR = MILSTR + " " + T.
    ELSE MILSTR = T.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

