&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/logdate.i
    Purpose     : Provides date and time handling routines for LogRead

    Syntax      : {logread/logdate.i}

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* date format table */
DEF TEMP-TABLE ttdatefmt NO-UNDO
    FIELD ifmtix AS INT
    FIELD cformat AS CHAR
    FIELD ctype AS CHAR
    FIELD cord AS CHAR
    FIELD cdelim AS CHAR
    FIELD id1 AS INT
    FIELD id2 AS INT
    FIELD im1 AS INT
    FIELD im2 AS INT
    FIELD iy1 AS INT
    FIELD iy2 AS INT.

/* langauge table */
DEF TEMP-TABLE ttlang NO-UNDO
    FIELD clangname AS CHAR
    FIELD clang AS CHAR
    FIELD ilangix AS INT
    FIELD cmonth AS CHAR
    FIELD imonthix AS INT
    INDEX langmthix clang cmonth
    INDEX langix ilangix imonthix.

DEFINE VARIABLE ilangseq AS INTEGER    NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addLanguage Include 
PROCEDURE addLanguage :
/*------------------------------------------------------------------------------
  Purpose:     Adds a language to the table of languages.
  Parameters:  
    cLangName - [IN] description of language
    cLang     - [IN] identifier for the language
    cmonths   - [IN] list of month names/abbreviations, in this language
  Notes:       The language list is for interpreting ubroker log files that
               use localised date formats, which contain the month as text
               in the local language.
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLangName AS CHAR NO-UNDO.
    DEF INPUT PARAM cLang AS CHAR NO-UNDO.
    DEF INPUT PARAM cmonths AS CHAR NO-UNDO.

    DEFINE VARIABLE i AS INTEGER    NO-UNDO.

    DO i = 1 TO NUM-ENTRIES(cmonths):
        CREATE ttlang.
        ASSIGN 
            ttlang.clangname = clangname
            ttlang.clang = clang
            ttlang.ilangix = ilangseq
            ttlang.imonthix = i
            ttlang.cmonth = ENTRY(i,cmonths).
    END.
    ilangseq = ilangseq + 1.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustTime Include 
PROCEDURE adjustTime :
/*------------------------------------------------------------------------------
  Purpose:     Perform the given time adjustment on the date and time
  Parameters:  
    ddate    - [IN-OUT] the date of the current timestamp
    dtime    - [IN-OUT] the time of the current timestamp (seconds)
    dtimeadj - [IN] the amount to adjust the time by
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT-OUTPUT PARAM ddate AS DATE NO-UNDO.
  DEF INPUT-OUTPUT PARAM dtime AS DEC NO-UNDO.
  DEF INPUT PARAM dtimeadj AS DEC NO-UNDO.

  dtime = dtime + dtimeadj.
  /* if we wrapped the time, adjust the date */
  IF (dtime < 0) THEN
  DO WHILE (dtime < 0):
      /* went backwards */
      ASSIGN 
          ddate = ddate - 1
          dtime = dtime + 86400.
  END.
  ELSE IF (dtime >= 86400) THEN
  DO WHILE (dtime >= 86400):
      /* went forwards */
      ASSIGN 
          ddate = ddate + 1
          dtime = dtime - 86400.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDateRange Include 
PROCEDURE checkDateRange :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether a given timstamp is within the indicated 
               time and date range
  Parameters:  
    ddate      - [IN] date of the timestamp
    dtime      - [IN] time of the timestamp
    dstartdate - [IN] date of the start date of the date range
    dstarttime - [IN] time of the start date of the date range
    denddate   - [IN] date of the end date of the date range
    dendtime   - [IN] time of the end date of the date range
    iOK        - [OUT] 0 if timestamp is within date range
                       -1 if timestamp is before date range
                       1 if timestamp is after date range
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAM ddate AS DATE       NO-UNDO.
  DEFINE INPUT PARAM dtime AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAM dstartdate AS DATE       NO-UNDO.
  DEFINE INPUT PARAM dstarttime AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAM denddate AS DATE       NO-UNDO.
  DEFINE INPUT PARAM dendtime AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAM iOK AS INTEGER INIT 0 NO-UNDO.

  IF (ddate < dstartdate) OR 
     (ddate = dstartdate AND dtime < dstarttime) THEN
      iok = -1.
  ELSE IF (ddate > denddate) OR
      (ddate = denddate AND dtime > dendtime) THEN
      iok = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormat Include 
PROCEDURE getDateFormat :
/*------------------------------------------------------------------------------
  Purpose:     Gets the date format string, based on the date index given.
  Parameters:  
    ifmtix   - [IN] index of requested date format
    cdatefmt - [OUT] text of requested date format
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ifmtix AS INT NO-UNDO.
  DEF OUTPUT PARAM cdatefmt AS CHAR NO-UNDO.

  FIND FIRST ttdatefmt WHERE
      ttdatefmt.ifmtix = ifmtix NO-ERROR.
  IF AVAILABLE ttdatefmt THEN
      cdatefmt = ttdatefmt.cformat.
  ELSE
      cdatefmt = "?".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormats Include 
PROCEDURE getDateFormats :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of date formats, separated by "|"
  Parameters:  
    lCombo - [IN] whether this list is for populating a combo-box or not.
             If so, then add the index to the list as well, for LIST-ITEM-PAIRS
    cFormats - [OUT] list of date formats
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM lCombo AS LOGICAL NO-UNDO.
  DEF OUTPUT PARAM cFormats AS CHAR NO-UNDO.
  
  FOR EACH ttdatefmt NO-LOCK:
      cFormats = cFormats + (IF ttdatefmt.ifmtix > 1 THEN "|" ELSE "") + 
          ttdatefmt.cformat + 
          (IF lcombo THEN "|" + STRING(ttdatefmt.ifmtix) ELSE "").
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFromFormatix Include 
PROCEDURE getDateFromFormatix :
/*------------------------------------------------------------------------------
  Purpose:     Returns a date, from a date character string, the date format 
               index, and the given language              
  Parameters:  
    cdate   - [IN] the date as a char string
    ifmtix  - [IN] index of the date format to use to parse this date
    clang   - [IN] language to use, if the date format uses a text-based month
    ddate   - [OUT] the date, parsed from the input parameters
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cdate AS CHAR NO-UNDO.
  DEF INPUT PARAM ifmtix AS INT NO-UNDO.
  DEF INPUT PARAM clang AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ddate AS DATE INIT ? NO-UNDO.

  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i3 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c3 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE id AS INTEGER    NO-UNDO.
  DEFINE VARIABLE im AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cd AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cm AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cy AS CHARACTER  NO-UNDO.

  /*
      "YYYY/MM/DD|YMD|/" + CHR(13) + /* 1 */
      "YY/MM/DD|YMD|/" + CHR(13) +   /* 2 */
      "YYYY-MM-DD|YMD|-" + CHR(13) + /* 3 */
      "YY-MM-DD|YMD|-" + CHR(13) +   /* 4 */
      "DD/MM/YY|DMY|/" + CHR(13) +   /* 5 */ 
      "DD/MM/YYYY|DMY|/" + CHR(13) + /* 6 */
      "DD-MM-YY|DMY|-" + CHR(13) +   /* 7 */
      "DD-MM-YYYY|DMY|-" + CHR(13) + /* 8 */
      "MM/DD/YY|MDY|/" + CHR(13) +   /* 9 */
      "MM/DD/YYYY|MDY|/" + CHR(13) + /* 10 */
      "MM-DD-YY|MDY|-" + CHR(13) +   /* 11 */
      "MM-DD-YYYY|MDY|-" + CHR(13) + /* 12 */
      "DD MMM, YYYY|DMY|?" + CHR(13) + /* 13 */
      "DD MMM, YY|DMY|?" + CHR(13) +   /* 14 */
      "MMM DD, YY|MDY|?" + CHR(13) +   /* 15 */
      "MMM DD, YYYY|MDY|?" + CHR(13) + /* 16 */
      "DD-MMM-YYYY|DMY|?" + CHR(13) +  /* 17 */
      "DD-MMM-YY|DMY|?" .     /* 18 */
      */
  FIND FIRST ttdatefmt NO-LOCK WHERE
      ttdatefmt.ifmtix = ifmtix NO-ERROR.
  IF NOT AVAILABLE ttdatefmt THEN RETURN.
  IF ttdatefmt.ctype = "D" THEN
  DO:
      ASSIGN 
          id = INT(ENTRY(ttdatefmt.id1,cdate,ttdatefmt.cdelim))
          im = INT(ENTRY(ttdatefmt.im1,cdate,ttdatefmt.cdelim))
          iy = INT(ENTRY(ttdatefmt.iy1,cdate,ttdatefmt.cdelim)) NO-ERROR.
  END.
  ELSE IF ttdatefmt.ctype = "M" THEN
  DO:
      /* set up a default language  as English */
      IF clang = ? OR clang = "" THEN
          clang = "en".
      ASSIGN 
          id = INT(ENTRY(ttdatefmt.id1,cdate,ttdatefmt.cdelim))
          cm = ENTRY(ttdatefmt.im1,cdate,ttdatefmt.cdelim)
          iy = INT(ENTRY(ttdatefmt.iy1,cdate,ttdatefmt.cdelim)) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
          RETURN ERROR "Cannot interpret date '" + cdate + "' in format " + 
          ttdatefmt.cformat + CHR(10) + 
          ERROR-STATUS:GET-MESSAGE(1).
      RUN getMonthFromString(INPUT cm, INPUT clang, OUTPUT im) NO-ERROR.
  END.
  ELSE IF ttdatefmt.ctype = "F" THEN
  DO:
      ASSIGN
          id = INT(SUBSTRING(cdate,ttdatefmt.id1,ttdatefmt.id2))
          im = INT(SUBSTRING(cdate,ttdatefmt.im1,ttdatefmt.im2))
          iy = INT(SUBSTRING(cdate,ttdatefmt.iy1,ttdatefmt.iy2)) NO-ERROR.
  END.

  /* check for any error status */
  IF (ERROR-STATUS:ERROR) THEN
      RETURN ERROR "Cannot interpret date '" + cdate + "' in format " + 
      ttdatefmt.cformat + CHR(10) + 
      ERROR-STATUS:GET-MESSAGE(1).

  /* check for 2 digit year, and set the year according to -yy setting */
  IF iy < 100 THEN
  DO:      
      IF iy < (SESSION:YEAR-OFFSET MOD 100) THEN
          ASSIGN 
          iy = iy + (TRUNCATE(SESSION:YEAR-OFFSET / 100,0) * 100) + 100 NO-ERROR.
      ELSE
          ASSIGN 
          iy = iy + (TRUNCATE(SESSION:YEAR-OFFSET / 100,0) * 100) NO-ERROR.
  END.

  ASSIGN ddate = DATE(im,id,iy) NO-ERROR.
  IF (ERROR-STATUS:ERROR) THEN
      RETURN ERROR "Date '" + cdate + "' cannot have year " + STRING(iy) +
      " month " + STRING(im) + " day " + STRING(id) + CHR(10) + 
      ERROR-STATUS:GET-MESSAGE(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLanguages Include 
PROCEDURE getLanguages :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of loaded languages for date formats using a 
               localised text month. Languages a separated by "|"
  Parameters:  
    lCombo     - [IN] Whether this is for a combo-box or not. If so, then 
                 add the langauge identifier as well, for LIST-ITEM-PAIRS
    clanguages - [OUT] list of languages
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM lCombo AS LOGICAL NO-UNDO.
  DEF OUTPUT PARAM clanguages AS CHAR NO-UNDO.

  DEFINE VARIABLE lfirst AS LOGICAL INIT YES NO-UNDO.

  FOR EACH ttlang NO-LOCK WHERE
      ttlang.imonthix = 1 
      BY ttlang.ilangix :
      ASSIGN 
      cLanguages = cLanguages + (IF NOT lfirst THEN "|" ELSE "") + 
          ttlang.clangname + 
          (IF lcombo THEN "|" + STRING(ttlang.clang) ELSE "")
      lfirst = FALSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMonthFromString Include 
PROCEDURE getMonthFromString :
/*------------------------------------------------------------------------------
  Purpose:     Returns the month as an integer, from a string containing the
               text of the month's localised name
  Parameters:  
    cmonth - [IN] text of the month's name
    clang  - [IN] language identifier, for the local language
    imon   - [OUT] month as an integer
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmonth AS CHAR NO-UNDO.
  DEF INPUT PARAM clang AS CHAR NO-UNDO.
  DEF OUTPUT PARAM imon AS INT INIT 0 NO-UNDO.

  /* remove commas and spaces */
  cmonth = REPLACE(cmonth," ","").
  cmonth = REPLACE(cmonth,",","").

  FIND FIRST ttlang WHERE
      ttlang.clang = clang AND 
      ttlang.cmonth = cmonth NO-ERROR.
  IF AVAILABLE ttlang THEN
      imon = ttlang.imonthix.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTimeFromString Include 
PROCEDURE getTimeFromString :
/*------------------------------------------------------------------------------
  Purpose:     Returns a decimal time value parsed from the given string
  Parameters:  
    ctime - [IN] the string representing the time
    dtime - [OUT] the parsed time
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ctime AS CHAR NO-UNDO.
  DEF OUTPUT PARAM dtime AS DEC NO-UNDO.

  /* check if time parts delimited by ":" */
  IF (INDEX(ctime,":":U) > 0) THEN
  DO:
      /* Time parts delimited by ":" or "." 
       * i.e. HH:MM:SS:mmm or HH:MM:SS.mmm */
      ASSIGN 
      dtime = (INT(SUBSTRING(ctime,1,2)) * 3600) + 
              (INT(SUBSTRING(ctime,4,2)) * 60) +
              (INT(SUBSTRING(ctime,7,2))) + 
              (INT(SUBSTRING(ctime,10,3)) / 1000) NO-ERROR.
     IF ERROR-STATUS:ERROR THEN
     DO:
         /* time parts delimited by :, but no mmm i.e. HH:MM:SS */
         IF NUM-ENTRIES(ctime,":":U) > 3 THEN
             dtime = (INT(ENTRY(1,ctime,":":U)) * 3600) + 
                     (INT(ENTRY(2,ctime,":":U)) * 60) +
                     (INT(ENTRY(3,ctime,":":U))) NO-ERROR.
         IF (NOT ERROR-STATUS:ERROR) AND (NUM-ENTRIES(ctime,":":U) > 4) THEN
             ASSIGN 
             dtime = dtime + 
                     (INT(ENTRY(4,ctime,":":U)) / 1000) NO-ERROR.
     END.
  END.
  ELSE
      /* time parts not delimited i.e. HHMMSS[mmm] */
      ASSIGN
      dtime = (INT(SUBSTRING(ctime,1,2)) * 3600) + 
              (INT(SUBSTRING(ctime,3,2)) * 60) +
              (INT(SUBSTRING(ctime,5,2))) + 
              (IF LENGTH(ctime) > 6 THEN
                  (INT(SUBSTRING(ctime,7,3)) / 1000) ELSE 0) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTimeString Include 
PROCEDURE getTimeString :
/*------------------------------------------------------------------------------
  Purpose:     Returns the time as a string
  Parameters:  
    dtime  - [IN] time to return as a string
    lDelim - [IN] whether to use delimiters or not in the string
             if TRUE, returned time is HH:MM:SS.mmm
             if FALSE, returned time is HHMMSSmmm
    ctime  - [OUT] string representation of the time
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM dtime  AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAM lDelim AS LOG NO-UNDO.
    DEFINE OUTPUT PARAM ctime AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE dtmp AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE ival AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cdelim AS CHARACTER  NO-UNDO.

    ASSIGN 
    cdelim = (IF ldelim THEN ":" ELSE "")
    ival = TRUNCATE(dtime / 3600,0)
    ctime = STRING(ival,"99") + cdelim.
    ASSIGN 
    dtime = dtime - (ival * 3600)
    ival = TRUNCATE(dtime / 60,0)
    ctime = ctime + STRING(ival,"99") + cdelim.
    ASSIGN 
    dtime = dtime - ival * 60
    ival = TRUNCATE(dtime,0)
    ctime = ctime + string(ival,"99") + (IF ldelim THEN "." ELSE "").
    ASSIGN 
    ival = (dtime - ival) * 1000.
    ctime = ctime + STRING(ival,"999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialiseDateFormats Include 
PROCEDURE initialiseDateFormats :
/*------------------------------------------------------------------------------
  Purpose:     Initialises the available date formats
  Parameters:  <none>
  Notes:       Dates are entered into a temp-table, and assigned and index.
               All handlers and programs refer to this index when extracting 
               dates from a string.
               The large string below contains all the information for parsing 
               the date appropriately. Each date format is separates by CHR(13), 
               and individual fields within the format are delimited by "|".
               The format of the fields in each date format is as follows:
               - Display text of date format
               - order of the date elements within the string
               - Whether format has a delimiter, a text month, or has fixed positions
                 - D means format uses a delimiter
                 - M means format has a localised text month
                 - F means format uses fixed positions
               - Delimiter, for D or M date formats               
               
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFormats AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ifmtix AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cformat AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE itmp AS INTEGER    NO-UNDO.
  DEFINE VARIABLE itmp2 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ctmp AS CHARACTER  NO-UNDO.

  cFormats = 
      "YYYY/MM/DD|YMD|D|/" + CHR(13) + /* 1 */
      "YY/MM/DD|YMD|D|/" + CHR(13) +   /* 2 */
      "YYYY-MM-DD|YMD|D|-" + CHR(13) + /* 3 */
      "YY-MM-DD|YMD|D|-" + CHR(13) +   /* 4 */
      "DD/MM/YY|DMY|D|/" + CHR(13) +   /* 5 */ 
      "DD/MM/YYYY|DMY|D|/" + CHR(13) + /* 6 */
      "DD-MM-YY|DMY|D|-" + CHR(13) +   /* 7 */
      "DD-MM-YYYY|DMY|D|-" + CHR(13) + /* 8 */
      "MM/DD/YY|MDY|D|/" + CHR(13) +   /* 9 */
      "MM/DD/YYYY|MDY|D|/" + CHR(13) + /* 10 */
      "MM-DD-YY|MDY|D|-" + CHR(13) +   /* 11 */
      "MM-DD-YYYY|MDY|D|-" + CHR(13) + /* 12 */
      "DD MMM, YYYY|DMY|M| " + CHR(13) + /* 13 */
      "DD MMM, YY|DMY|M| " + CHR(13) +   /* 14 */
      "MMM DD, YY|MDY|M| " + CHR(13) +   /* 15 */
      "MMM DD, YYYY|MDY|M| " + CHR(13) + /* 16 */
      "DD-MMM-YYYY|DMY|M|-" + CHR(13) +  /* 17 */
      "DD-MMM-YY|DMY|M|-" + CHR(13) +    /* 18 */
      "YYYYMMDD|YMD|F|?" + CHR(13) +     /* 19 */
      "YYMMDD|YMD|F|?" + CHR(13) +       /* 20 */
      "MMDDYYYY|MDY|F|?" + CHR(13) +     /* 21 */
      "MMDDYY|MDY|F|?" + CHR(13) +       /* 22 */
      "DDMMYYYY|DMY|F|?" + CHR(13) +     /* 23 */
      "DDMMYY|DMY|F|?"  + CHR(13) +      /* 24 */
      "DD.MM.YY|DMY|D|." + CHR(13) + 
      "YY.MM.DD|YMD|D|." + CHR(13) + 
      "DD.MMM.YYYY|DMY|M|." + CHR(13) + 
      "DD MMM YY|DMY|M| " + CHR(13) + 
      "DD MMM YYYY|DMY|M| " + CHR(13) + 
      "YYYY-MMM-DD|YMD|M|-" + CHR(13) + 
      "DD/MMM/YYYY|DMY|M|/"
       .


  DO ifmtix = 1 TO (NUM-ENTRIES(cFormats,CHR(13))):
      cformat = ENTRY(ifmtix,cFormats,CHR(13)).
      CREATE ttdatefmt.
      ASSIGN
          ttdatefmt.ifmtix = ifmtix
          ttdatefmt.cFormat = ENTRY(1,cFormat,"|")
          ttdatefmt.cord = ENTRY(2,cFormat,"|")
          ttdatefmt.ctype = ENTRY(3,cFormat,"|")
          ttdatefmt.cdelim = ENTRY(4,cFormat,"|").
      ASSIGN
              ttdatefmt.id1 = INDEX(ttdatefmt.cord,"D")
              ttdatefmt.im1 = INDEX(ttdatefmt.cord,"M")
              ttdatefmt.iy1 = INDEX(ttdatefmt.cord,"Y").
      /* fixed format types */
      IF ttdatefmt.ctype = "F" THEN
      DO:
          /* TO DO */
          ASSIGN 
              ttdatefmt.id1 = INDEX(ttdatefmt.cformat,"D")
              ttdatefmt.id2 = R-INDEX(ttdatefmt.cformat,"D") - ttdatefmt.id1
              ttdatefmt.im1 = INDEX(ttdatefmt.cformat,"M")
              ttdatefmt.im2 = R-INDEX(ttdatefmt.cformat,"M") - ttdatefmt.im1
              ttdatefmt.iy1 = INDEX(ttdatefmt.cformat,"Y")
              ttdatefmt.iy2 = R-INDEX(ttdatefmt.cformat,"Y") - ttdatefmt.iy1
              .
      END.
  END.

  RUN initialiseLanguages.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialiseLanguages Include 
PROCEDURE initialiseLanguages :
/*------------------------------------------------------------------------------
  Purpose:     Loads language-specific month text strings
  Parameters:  <none>
  Notes:       TODO: need to fully populate this list
------------------------------------------------------------------------------*/

  RUN addLanguage("English","en","Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
  RUN addLanguage("German","de","Jan,Feb,Mrz,Apr,Mai,Jun,Jul,Aug,Sep,Okt,Nov,Dez").
  RUN addLanguage("Spanish","es","ene,feb,mar,abr,may,jun,jul,ago,sep,oct,nov,dic").
  RUN addLanguage("French","fr","janv.,févr.,mars,avr.,mai,juin,juil.,août,sept.,oct.,nov.,déc.").
  RUN addLanguage("Dutch","nl","jan,feb,mrt,apr,mei,jun,jul,aug,sep,okt,nov,dec").
  RUN addLanguage("Portuguese","pt","Jan,Fev,Mar,Abr,Mai,Jun,Jul,Ago,Set,Out,Nov,Dez").
  RUN addLanguage("Swedish","sv","jan,feb,mar,apr,maj,jun,jul,aug,sep,okt,nov,dec").
  RUN addLanguage("Italian","it","gen,feb,mar,apr,mag,giu,lug,ago,set,ott,nov,dic").
  RUN addLanguage("Norwegian","no","jan,feb,mar,apr,mai,jun,jul,aug,sep,okt,nov,des").
  RUN addLanguage("Finnish","fi","tammi,helmi,maalis,huhti,touko,kesä,heinä,elo,syys,loka,marras,joulu").
  /* ISO8859-2 code pages. Not needed for the Czech or Polish date formats 
  RUN addLanguage("Czech","cs","I,II,III,IV,V,VI,VII,VIII,IX,X,XI,XII").
  RUN addLanguage("Polish","pl","sty,lut,mar,kwi,maj,cze,lip,sie,wrz,pa?,lis,gru").
  */
  /* Greek and Turkish months needed for UBroker and AdminServer dates */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTimeString Include 
PROCEDURE validateTimeString :
/*------------------------------------------------------------------------------
  Purpose:     Validate a time string
  Parameters:  
    ctime   - [IN] string representation of a time
    dtime   - [OUT] time as a decimal
    cerrtxt - [OUT] reason the string failed validation
  Notes:       Used by the Log Open window to validate the start and end times
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ctime AS CHAR NO-UNDO.
  DEF OUTPUT PARAM dtime AS DEC INIT ? NO-UNDO.
  DEF OUTPUT PARAM cerrtxt AS CHAR INIT "" NO-UNDO.

  DEFINE VARIABLE ihr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE imin AS INTEGER    NO-UNDO.
  DEFINE VARIABLE isec  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ims AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cdtime AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE chour AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cmin AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE csec AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cms AS CHARACTER  NO-UNDO.

  IF (INDEX(ctime,":") > 0) THEN
      ASSIGN 
      chour = SUBSTRING(ctime,1,2)
      cmin = SUBSTRING(ctime,4,2)
      csec = SUBSTRING(ctime,7,2)
      cms = (IF LENGTH(ctime) > 8 THEN 
             SUBSTRING(ctime,10,3) ELSE "0") 
      ihr = INT(chour)
      imin = INT(cmin)
      isec = INT(csec)
      ims = INT(cms)
      cdtime = ctime
      NO-ERROR.
  ELSE
      ASSIGN 
        chour = SUBSTRING(ctime,1,2)
        cmin = SUBSTRING(ctime,3,2)
        csec = SUBSTRING(ctime,5,2)
        cms = (IF LENGTH(ctime) > 6 THEN 
               SUBSTRING(ctime,7,3) ELSE "0") 
        ihr = INT(chour)
        imin = INT(cmin)
        isec = INT(csec)
        ims = INT(cms)
          cdtime = chour + ":" + cmin + ":" + csec + "." + cms
          NO-ERROR.  /* validate times */
  IF ihr < 0 OR ihr > 23 THEN
  DO:
      cerrtxt = "Invalid hour " + string(ihr) + " in " + cdtime.
      RETURN.
  END.
  IF imin < 0 OR imin > 59 THEN
  DO:
      cerrtxt = "Invalid minutes " + string(imin) + " in " + cdtime.
      RETURN.
  END.
  IF isec < 0 OR isec > 59 THEN
  DO:
      cerrtxt = "Invalid seconds " + string(isec) + " in " + cdtime.
      RETURN.
  END.
  /* get the time, as a convenience */
  dtime = (ihr * 3600) + (imin * 60) + isec + (ims / 1000).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

