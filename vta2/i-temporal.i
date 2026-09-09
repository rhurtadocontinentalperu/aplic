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

    IF TODAY <= DATE(03,31,2016) THEN DO:
        DEF VAR x-74765 AS DEC NO-UNDO.
        DEF VAR x-64031 AS DEC NO-UNDO.
        DEF VAR x-72660 AS DEC NO-UNDO.
        DEF VAR x-63232 AS DEC NO-UNDO.
        FOR EACH {1}:
            CASE {1}.codmat:
                WHEN '074765' THEN x-74765 = X-74765 + {1}.canped.
                WHEN '064031' THEN x-64031 = X-64031 + {1}.canped.
                WHEN '072660' THEN x-72660 = X-72660 + {1}.canped.
                WHEN '063232' THEN x-63232 = X-63232 + {1}.canped.
            END CASE.
        END.
        IF x-74765 > 20 THEN DO:
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = '074765'
                NO-LOCK.
            MESSAGE 'Como máximo 20 PAQ' SKIP
                'Producto:' Almmmatg.codmat Almmmatg.desmat
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        IF x-64031 > 20 THEN DO:
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = '064031'
                NO-LOCK.
            MESSAGE 'Como máximo 20 PAQ' SKIP
                'Producto:' Almmmatg.codmat Almmmatg.desmat
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        IF x-72660 > 100 THEN DO:
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = '072660'
                NO-LOCK.
            MESSAGE 'Como máximo 100 MLL' SKIP
                'Producto:' Almmmatg.codmat Almmmatg.desmat
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        IF x-63232 > 100 THEN DO:
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = '063232'
                NO-LOCK.
            MESSAGE 'Como máximo 100 MLL' SKIP
                'Producto:' Almmmatg.codmat Almmmatg.desmat
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
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
         HEIGHT             = 3.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


