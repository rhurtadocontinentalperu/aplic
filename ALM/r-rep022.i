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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

FOR EACH {&Tabla}.almmmatg NO-LOCK WHERE {&Tabla}.almmmatg.codcia = s-codcia AND
    ( x-codfam = 'Todas' OR {&Tabla}.almmmatg.codfam = x-codfam ),
    FIRST {&Tabla}.almtfami OF {&Tabla}.almmmatg NO-LOCK,
    FIRST {&Tabla}.almsfami OF {&Tabla}.almmmatg NO-LOCK
    BY {&Tabla}.almmmatg.codmat:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** " + "{&Tabla}" + ' ' +
        {&Tabla}.almmmatg.codmat + ' ' + {&Tabla}.almmmatg.desmat.
    /* buscamos stocks al corte */
    x-StkAct = 0.
    FOR EACH {&Tabla}.almacen NO-LOCK WHERE {&Tabla}.almacen.codcia = s-codcia:
        FIND LAST {&Tabla}.almstkge WHERE {&Tabla}.almstkge.codcia = s-codcia AND
            {&Tabla}.almstkge.codmat = {&Tabla}.almmmatg.codmat AND
            {&Tabla}.almstkge.fecha <= FILL-IN-Fecha
            NO-LOCK NO-ERROR.
        FIND LAST {&Tabla}.almstkal WHERE {&Tabla}.almstkal.codcia = s-codcia AND
            {&Tabla}.almstkal.codalm = {&Tabla}.almacen.codalm AND
            {&Tabla}.almstkal.codmat = {&Tabla}.almmmatg.codmat AND
            {&Tabla}.almstkal.fecha <= FILL-IN-Fecha
            NO-LOCK NO-ERROR.
        IF AVAILABLE {&Tabla}.almstkal AND {&Tabla}.almstkal.stkact <> 0 
            THEN DO:
            CREATE detalle.
            ASSIGN
                detalle.codalm = {&Tabla}.almacen.codalm
                detalle.codmat = {&Tabla}.almmmatg.codmat
                detalle.desmat = {&Tabla}.almmmatg.desmat
                detalle.codfam = {&Tabla}.almmmatg.codfam + ' ' + {&Tabla}.Almtfami.desfam
                detalle.subfam = {&Tabla}.almmmatg.subfam + ' ' + {&Tabla}.AlmSFami.dessub
                detalle.stkact = {&Tabla}.almstkal.stkact.
            IF AVAILABLE {&Tabla}.almstkge THEN detalle.ctouni = {&Tabla}.almstkge.ctouni.
            IF "{&Tabla}" = "INTEGRAL" THEN detalle.codcia = "CONTINENTAL".
            IF "{&Tabla}" = "CISSAC"   THEN detalle.codcia = "CISSAC".
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


