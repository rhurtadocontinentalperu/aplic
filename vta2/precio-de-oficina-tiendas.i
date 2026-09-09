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

MaxCat = 0.
MaxVta = 0.
fmot   = 0.
MrgMin = 5000.
MrgOfi = 0.
F-FACTOR = 1.
MaxCat = 4.
MaxVta = 3.

ASSIGN
    F-MrgUti-A = DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-PreVta-A = DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-MrgUti-B = DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-PreVta-B = DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-MrgUti-C = DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-PreVta-C = DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

/****   Busca el Factor de conversion   ****/
IF T-MATG.Chr__01 <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
        AND  Almtconv.Codalter = T-MATG.Chr__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
       MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN.
    END.
    F-FACTOR = Almtconv.Equival.
END.
/*******************************************/

/* **********************************************************************
    NOTA IMPORTANTE: Cualquier cambio debe hacerse también
                    en LOGISTICA -> LIsta de precios por proveedor
************************************************************************* */                    
/*MESSAGE t-matg.codmat t-matg.CHR__02.*/
CASE T-MATG.Chr__02 :
    WHEN "T" THEN DO:        
        /*  TERCEROS  */
        IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.
        IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.
        IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.
        fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
        IF F-MrgUti-A = 0 AND F-MrgUti-B = 0 AND F-MrgUti-C = 0 THEN fMot = 1.
        /*MESSAGE x-ctound fmot f-factor.*/
        pre-ofi = X-CTOUND * fmot * F-FACTOR .        
        MrgOfi = ROUND((fmot - 1) * 100, 6).
    END.
    WHEN "P" THEN DO:
        /* PROPIOS */
       pre-ofi = DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR.
       MrgOfi = ((DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / DECIMAL(T-MATG.Ctotot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )) - 1 ) * 100. 
        
    END. 
END.    


DO WITH FRAME {&FRAME-NAME}:
   DISPLAY 
       MrgOfi @ T-MATG.Dec__01
       pre-ofi @ T-MATG.PreOfi 
       WITH BROWSE {&BROWSE-NAME}.
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


