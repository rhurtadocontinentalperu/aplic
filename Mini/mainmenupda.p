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

{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE S-CODALM AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-DESALM AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-CODDIV AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-MOVUSR AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-STATUS-ALMACEN AS LOG INIT YES.

DEFINE VARIABLE s-ok AS LOGICAL INITIAL NO NO-UNDO.

/* VERIFICAMOS MOVIMIENTOS VALIDOS POR USUARIO */
/* Ej I,03|I,13|S,03 */
FOR EACH AlmUsrMov NO-LOCK WHERE AlmUsrMov.CodCia = s-codcia
  AND AlmUsrMov.User-Id = s-user-id:
  IF s-MovUsr = ''
      THEN s-MovUsr = TRIM(AlmUsrMov.TipMov) + ',' + TRIM(STRING(AlmUsrMov.CodMov)).
  ELSE s-MovUsr = s-MovUsr + '|' + TRIM(AlmUsrMov.TipMov) + ',' + TRIM(STRING(AlmUsrMov.CodMov)).
END.


/*MESSAGE s-user-id VIEW-AS ALERT-BOX.*/

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
         HEIGHT             = 5.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


/* Definimos variables para manejar el menú */
DEFINE VARIABLE hMenu     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSubMenu  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hMenuItem AS WIDGET-HANDLE NO-UNDO.
 
/*
The MENU widget is the top level, the next level is the SUB-MENU widget, 
and the bottom level is the MENU-ITEM widget. 
The MENU widget must be related to the window widget using the property MENUBAR:
ASSIGN CURRENT-WINDOW:MENUBAR = hMenu:HANDLE.
*/

/* Definimos variables del menú */
DEFINE VARIABLE cSubMenues AS CHARACTER INITIAL "Aplicaciones" NO-UNDO.
/*DEFINE VARIABLE cMenuItem1 AS CHARACTER INITIAL "Consulta de Stock,Picking x O/D,Salir" NO-UNDO.*/
DEFINE VARIABLE cMenuItem1 AS CHARACTER INITIAL "Consulta de Stock,Zonificacion,Salir" NO-UNDO.

DEFINE VARIABLE iAuxlr1 AS INTEGER NO-UNDO.
DEFINE VARIABLE iAuxlr2 AS INTEGER NO-UNDO.
DEFINE VARIABLE iItems  AS INTEGER NO-UNDO.
DEFINE VARIABLE cItems  AS CHARACTER NO-UNDO.

/* Definimos el tamaño de la ventana en carateres */
ASSIGN 
    CURRENT-WINDOW:HEIGHT-CHARS = 6
    CURRENT-WINDOW:WIDTH-CHARS = 35.

/* Armamos el Menú */
CREATE MENU hMenu.
DO iAuxlr1 = 1 TO NUM-ENTRIES(cSubMenues):
    /* Creamos cada opción del menu horizontal */
    CREATE SUB-MENU hSubMenu 
        ASSIGN 
        PARENT = hMenu 
        NAME   = ENTRY(iAuxlr1, cSubMenues)
        LABEL  = ENTRY(iAuxlr1, cSubMenues).

    /* Creamos los módulos en forma vertical */
    CASE hSubMenu:NAME: 
        WHEN "Aplicaciones" THEN DO:
            ASSIGN  iItems = NUM-ENTRIES(cMenuItem1) 
                    cItems = cMenuItem1.
        END.
    END. /*CASE hSubMenu:NAME:*/ 
    DO iAuxlr2 = 1 TO iItems: 
        CREATE MENU-ITEM hMenuItem 
            ASSIGN PARENT = hSubMenu
            NAME = ENTRY(iAuxlr2, cItems)
            LABEL = ENTRY(iAuxlr2, cItems) 
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN MenuItemChoose IN THIS-PROCEDURE (INPUT hMenuItem:NAME).
            END TRIGGERS. 
    END. /*DO iAuxlr2 = 1 TO iItems:*/
END. /*DO iAuxlr1 = 1 TO NUM-ENTRIES(cSubMenues):*/
 
ASSIGN CURRENT-WINDOW:MENUBAR = hMenu:HANDLE.
 
RUN MINI/d-ingalm (OUTPUT s-ok).
IF s-ok = NO THEN RETURN.

DEFINE FRAME F1 WITH SIZE 35 BY 6 THREE-D NO-LABELS.
ENABLE ALL WITH FRAME F1.
WAIT-FOR CLOSE OF CURRENT-WINDOW.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-MenuItemChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuItemChoose Procedure 
PROCEDURE MenuItemChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER cMenuItemName AS CHARACTER NO-UNDO.

   DEF VAR s-Ok AS LOG.
   CASE cMenuItemName:
       WHEN "Consulta de Stock" THEN  DO:
           RUN mini/d-consustocks.
       END.
       WHEN "Picking x O/D" THEN  DO:
           RUN mini/d-picking-od.
       END.
   END CASE.
   
   IF cMenuItemName = 'Salir' THEN QUIT.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

