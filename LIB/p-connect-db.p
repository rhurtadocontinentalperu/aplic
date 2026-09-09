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

DEFINE INPUT PARAMETER p-DBname AS CHAR.
DEFINE INPUT PARAMETER p-LDname AS CHAR.
DEFINE INPUT PARAMETER p-IP     AS CHAR.
DEFINE INPUT PARAMETER p-PORT   AS CHAR.
DEFINE INPUT PARAMETER p-User   AS CHAR.
DEFINE INPUT PARAMETER p-Pass   AS CHAR.
DEFINE OUTPUT PARAMETER p-Conexion-OK AS LOG.

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

p-Conexion-OK = NO.

IF TRUE <> (p-DBname > "") THEN DO:
    RETURN.
END.
IF TRUE <> (p-IP > "") THEN DO:
    RETURN.
END.
IF TRUE <> (p-Port > "") THEN DO:  
    RETURN.
END. 
IF TRUE <> (p-User > "") THEN DO:
    RETURN.
END.
IF TRUE <> (p-Pass > "") THEN DO:
    RETURN.
END.
IF TRUE <> (p-LDname > "") THEN DO:
    p-LDname = p-DBname.
END.

DEFINE VAR x-str-connect AS CHAR.

x-str-connect = "-db " + p-DBname + " -H " + p-IP + " -S " + p-PORT + " -ld " + p-LDname + " -U " +
                    p-User + " -P " + p-Pass.

IF CONNECTED(p-LDName) THEN DO:
    DISCONNECT VALUE(p-LDname) NO-ERROR.
END.

CONNECT VALUE(x-str-connect) NO-ERROR.

IF CONNECTED(p-LDName) THEN DO:
    /*
    MESSAGE "Conexion OK".        
    DISCONNECT VALUE(p-LDname) NO-ERROR.
    */
    p-Conexion-OK = YES.
END.
ELSE DO:
    /*MESSAGE ERROR-STATUS:GET-MESSAGE(1).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


