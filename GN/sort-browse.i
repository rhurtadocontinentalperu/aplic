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

    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VARIABLE hColumnIndex AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.
    DEFINE VAR x-sort-command AS CHAR.
    DEFINE VAR x-sort-column AS CHAR.

    DEFINE VAR x-field-calculates AS CHAR.
    DEFINE VAR x-pos-field AS INT.

    hSortColumn = {&ThisBrowse}:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF hSortColumn:INDEX > 0 THEN DO:
        /* Campo ARRAY */
        lColumName = lColumName + "[" + STRING(hSortColumn:INDEX) + "]".
    END.
    IF hSortColumn:TABLE = ? THEN DO:
        /* Campo Calculado - Temp-Tables : Additional Fields */

        /* Private Data : 
            tFieldCampoTempo@x-field-display @ tFieldCampoTempo@x-field-display
            
            /* Como esto, no funciona el sort va salir error */
            get-fentrega(T-CcbCDocu.codped, T-ccbcdocu.nroped) @ x-col-fentrega 
        */
        x-field-calculates = CAPS(REPLACE(TRIM( {&ThisBrowse}:PRIVATE-DATA)," ","")).
        IF TRUE <> (x-field-calculates > "") THEN DO:
            lColumName = "".    /* No hacer nada */
        END.
        ELSE DO:
            lColumName = CAPS(lColumName).

            x-pos-field = LOOKUP(lColumName,x-field-calculates,"@").
            lColumName = "".
            IF x-pos-field > 1  THEN DO:
                lColumName = ENTRY(x-pos-field - 1,x-field-calculates,"@") NO-ERROR.
            END.
        END.
        IF TRUE <> (lColumName > "") THEN DO:
            RETURN.
        END.        
    END.
    
    {&ThisBrowse}:HELP = lColumName + "|" + hSortColumn:LABEL.

    IF lColumName = x-sort-column-current THEN DO:
        x-sort-command = {&ThisSQL} + " BY " + lColumName + " DESC".
        x-sort-column-current = "".
    END.
    ELSE DO:
        x-sort-command = {&ThisSQL} + " BY " + lColumName.
        x-sort-column-current = lColumName.
    END.
    

    /* Clear Sort Imagen */
    BROWSE {&ThisBrowse}:CLEAR-SORT-ARROWS().

    DO n_cols_browse = 1 TO {&ThisBrowse}:NUM-COLUMNS.
        hColumnIndex = {&ThisBrowse}:GET-BROWSE-COLUMN(n_cols_browse).
        IF hSortColumn = hColumnIndex  THEN DO:
            IF INDEX(x-sort-command," DESC") > 0 THEN DO:
                BROWSE {&ThisBrowse}:SET-SORT-ARROW(n_cols_browse,TRUE).
            END.
            ELSE DO:
                BROWSE {&ThisBrowse}:SET-SORT-ARROW(n_cols_browse,FALSE).
            END.            
        END.
    END.

    hQueryHandle = BROWSE {&ThisBrowse}:QUERY.
    hQueryHandle:QUERY-CLOSE().

    hQueryHandle:QUERY-PREPARE(x-sort-command).
    hQueryHandle:QUERY-OPEN().
    
    /*
    /* Color normal */    
    DO n_cols_browse = 1 TO {&ThisBrowse}:NUM-COLUMNS.
        n_celda = {&ThisBrowse}:GET-BROWSE-COLUMN(n_cols_browse).
        n_celda:COLUMN-BGCOLOR = 15.
    END.        
    
    /* Color SortCol */
    hSortColumn:COLUMN-BGCOLOR = 8.

    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


