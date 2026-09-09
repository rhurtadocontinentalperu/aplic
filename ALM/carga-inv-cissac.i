&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock'
      VIEW-AS ALERT-BOX WARNING.
END.

/*
RUN Carga-Data-Cissac.
*/

IF CONNECTED('cissac') THEN DISCONNECT 'cissac' NO-ERROR.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    
    FOR EACH tmp-cissac:
        DELETE tmp-cissac.
    END.

    /*Carga Materiales por División*/
    FOR EACH cissac.almmmatg WHERE cissac.almmmatg.codcia = 1 NO-LOCK,
        EACH cissac.almmmate OF cissac.Almmmatg 
        WHERE LOOKUP(TRIM(cissac.almmmate.codalm),cAlmacen) > 0 
        AND cissac.almmmate.stkact <> 0 NO-LOCK:
        
        IF cissac.almmmatg.tpoart <> "A" AND cissac.almmmate.stkact = 0 THEN NEXT.
        FIND FIRST tmp-cissac WHERE tmp-cissac.tt-codcia  = s-codcia 
            AND tmp-cissac.tt-almacen = cissac.almmmate.codalm 
            AND tmp-cissac.tt-codubi  = cissac.almmmate.codubi 
            AND tmp-cissac.tt-codmat  = cissac.almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-cissac THEN DO:
            CREATE tmp-cissac.
            ASSIGN
                tmp-cissac.tt-codcia  = s-codcia       
                tmp-cissac.tt-almacen = cissac.almmmate.codAlm
                tmp-cissac.tt-codubi  = cissac.almmmate.codubi
                tmp-cissac.tt-codmat  = cissac.almmmatg.codmat.
        END.
        ASSIGN
            tmp-cissac.tt-canfis  = cissac.almmmate.stkact
            tmp-cissac.tt-codusr  = s-user-id
            tmp-cissac.tt-fchcon  = txt-date.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        PAUSE 0.
    END.            
    HIDE FRAME f-Proceso.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data-Cissac Include 
PROCEDURE Carga-Data-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

