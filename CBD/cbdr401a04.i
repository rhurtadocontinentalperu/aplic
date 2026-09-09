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
        FOR EACH T-REPORT NO-LOCK 
               BREAK BY T-REPORT.CODCIA BY T-REPORT.FCHVTO:
             K = K + 1.
             IF K = 1 THEN DO:
                hide frame f-auxiliar .
                VIEW FRAME F-Mensaje.   
                PAUSE 0.           
             END.          
            {&NEW-PAGE}.
            ACCUMULATE T-REPORT.T-Debe  (TOTAL BY T-REPORT.CodCia).
            ACCUMULATE T-REPORT.T-Haber (TOTAL BY T-REPORT.CodCia).
            DISPLAY STREAM REPORT 
                    T-REPORT.fchdoc 
                    T-REPORT.codcta
                    T-REPORT.coddiv 
                    T-REPORT.cco    
                    T-REPORT.nroast 
                    T-REPORT.codope 
                    T-REPORT.nromes 
                    T-REPORT.coddoc 
                    T-REPORT.nrodoc 
                    T-REPORT.fchvto 
                    T-REPORT.codaux
                    /*T-REPORT.NroRef*/
                    T-REPORT.glodoc 
                    T-REPORT.T-importe  WHEN T-IMPORTE <> 0
                    T-REPORT.T-debe     WHEN T-DEBE    <> 0 
                    T-REPORT.T-haber    WHEN T-HABER   <> 0
                    WITH FRAME T-CAB-4.
            DOWN STREAM REPORT WITH FRAME T-CAB-4.
            IF LAST-OF(T-REPORT.CODCIA)
            THEN DO:
                UNDERLINE STREAM REPORT 
                          T-REPORT.T-debe
                          T-REPORT.T-haber  
                          WITH FRAME T-CAB-4.
                DOWN STREAM REPORT WITH WITH FRAME T-CAB-4.
                DISPLAY STREAM REPORT
                        "T o t a l   G e n e r a l" @ t-report.glodoc
                        ACCUM TOTAL BY T-REPORT.CODCIA T-debe  @ t-debe 
                        ACCUM TOTAL BY T-REPORT.CODCIA T-haber @ t-haber
                        WITH FRAME T-CAB-4.
                DOWN STREAM REPORT WITH FRAME T-CAB-4.    
            END.
        END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


