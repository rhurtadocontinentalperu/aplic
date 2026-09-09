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

    ASSIGN
        x-VtaEva = 0
        x-VtaHis = 0
        x-HisPro = 0.
    /* Salidas por Ventas Periodo a Evaluar */
    FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
            AND Almdmov.codalm = Almmmate.codalm
            AND Almdmov.codmat = Almmmate.codmat
            AND Almdmov.tipmov = 'S'
            AND Almdmov.codmov = 02
            AND Almdmov.fchdoc >= x-fchdoc-1
            AND Almdmov.fchdoc <= x-fchdoc-2:
        x-VtaEva = x-VtaEva + (Almdmov.candes * Almdmov.factor).
    END.            
    /* Salidas por Ventas Periodo Historico */
    FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
            AND Almdmov.codalm = Almmmate.codalm
            AND Almdmov.codmat = Almmmate.codmat
            AND Almdmov.tipmov = 'S'
            AND Almdmov.codmov = 02
            AND Almdmov.fchdoc >= x-fchdoc-3
            AND Almdmov.fchdoc <= x-fchdoc-4:
        x-VtaHis = x-VtaHis + (Almdmov.candes * Almdmov.factor).
    END.            
    /* Salidas por Ventas Historico Proyectadas*/
    FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
            AND Almdmov.codalm = Almmmate.codalm
            AND Almdmov.codmat = Almmmate.codmat
            AND Almdmov.tipmov = 'S'
            AND Almdmov.codmov = 02
            AND Almdmov.fchdoc >= x-fchdoc-5
            AND Almdmov.fchdoc <= x-fchdoc-6:
        x-HisPro = x-HisPro + (Almdmov.candes * Almdmov.factor).
    END.            
    /* Factor */
    IF x-VtaHis = 0 
    THEN x-Factor = 1.
    ELSE x-Factor = x-VtaEva / x-VtaHis.
    /* Proyeccion de Ventas */
    x-ProVta = x-HisPro * x-Factor.
    /* Stock Minimo */
/*    if almmmate.codmat = '019050'
 *     then message 
 *         'factor' x-factor skip
 *         'histo proyc' x-hispro skip 
 *         'hist. poyectado' x-provta skip 
 *         'venta a evaluar' x-vtaeva skip 
 *         'venta histor.' x-vtahis skip 
 *         'proyeccion de venta' x-provta.*/
    
    x-StkMin = ROUND(x-ProVta / x-Dias * (x-Entrega + x-Tramites), 0).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


