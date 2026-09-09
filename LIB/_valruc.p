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
         HEIGHT             = 4.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER mruc AS CHAR.
DEF OUTPUT PARAMETER resul AS CHAR.

DEF VAR mtot AS DEC.
DEF VAR mtotg AS DEC.
DEF VAR mcoc AS DEC.
DEF VAR mres AS DEC.
DEF VAR mdife AS DEC.
DEF VAR digch AS INT.
DEF VAR X AS INT.
DEF VAR mp AS CHAR INIT '54327654321'.

DEF VAR cChar AS CHARACTER.

IF LENGTH(TRIM(mruc)) = 11 THEN DO:
    /*MESSAGE "RuC " + mruc VIEW-AS ALERT-BOX.*/
      /* Ciman, validar que el RUC,solo tenga valores numericos */
      resul = "".
      DO x  = 1 TO 11:
          cChar = SUBSTRING(mRuc,X,1).
          IF cChar = ? THEN DO: 
              resul = "ERROR".
              RETURN.
          END.
          ELSE DO:
              IF LOOKUP(cChar,'1,2,3,4,5,6,7,8,9,0') = 0 THEN DO: 
                  resul = "ERROR".
                  RETURN.
              END.
          END.
          
      END.
      /* Debe comenzar con 10 11 0 17 */
      IF LOOKUP(SUBSTRING(mRuc, 1, 2), '10,20,15,17') = 0 THEN DO:
          resul = "ERROR".
          RETURN.
      END.
      /*  */
        resul = "".
        mtot  = 0.
        mtotg = 0.
        DO x  = 1 TO 10:
            mtot  = DECIMAL(SUBSTRING(mp,x,1)) * DECIMAL(SUBSTRING(mruc,x,1)).
            mtotg = mtotg + mtot.
        END.

        mcoc  = TRUNCATE(mtotg / 11, 0).
        mres  = mtotg - 11 * mcoc.
        mcoc  = mcoc * 11.
        mdife = mtotg - mcoc.
        digch = 11 - mdife.

        CASE digch:
            WHEN 10 THEN digch = 0.
            WHEN 11 THEN digch = 1.
        END CASE.

        IF  digch = DEC(SUBSTRING(mruc,11,1)) 
        THEN resul = 'OK'.
        ELSE resul = 'ERROR'.
  END.
  ELSE resul = 'ERROR'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


