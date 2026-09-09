DEFINE VARIABLE txt AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE i   AS INTEGER NO-UNDO.

DEFINE BUTTON b_int  LABEL "Integer".
DEFINE BUTTON b_date LABEL "Date".
DEFINE BUTTON b_dec  LABEL "Decimal".
DEFINE BUTTON b_log  LABEL "Logical".
DEFINE BUTTON b_quit LABEL "Quit" AUTO-ENDKEY. 
  
DEFINE FRAME butt-frame
  b_int b_date b_dec b_log b_quit
  WITH CENTERED ROW SCREEN-LINES - 2.
    DEFINE FRAME get-info
  txt LABEL "Enter Data To Convert"
  WITH ROW 2 CENTERED SIDE-LABELS TITLE "Data Conversion - Error Check".
  
ON CHOOSE OF b_int, b_date, b_dec, b_log IN FRAME butt-frame
DO:
  IF txt:MODIFIED IN FRAME get-info THEN
  DO:
    ASSIGN txt.
    RUN convert(txt).
    IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN
    DO:
      MESSAGE ERROR-STATUS:NUM-MESSAGES 
       " errors occurred during conversion." SKIP 
       "Do you want to view them?" 
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
       UPDATE view-errs AS LOGICAL.
       
      IF view-errs THEN
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        MESSAGE ERROR-STATUS:GET-NUMBER(i)
                ERROR-STATUS:GET-MESSAGE(i).
      END.
    END.
  END. /* IF txt:MODIFIED... */
  ELSE
    MESSAGE "Please enter data to be convert and then choose the type"
            "of conversion to perform."
      VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.           
END.
  
ENABLE ALL WITH FRAME butt-frame.
ENABLE txt WITH FRAME get-info.
WAIT-FOR CHOOSE OF b_quit IN FRAME butt-frame FOCUS txt IN FRAME get-info.
/***** Internal Procedure "convert" *****/
PROCEDURE convert:
  DEFINE INPUT PARAMETER x AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE d  AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dd AS DATE      NO-UNDO.
  DEFINE VARIABLE l  AS LOGICAL   NO-UNDO.
  
  message self:label.
  
  CASE SELF:LABEL:
    WHEN "Integer" THEN DO:
      ASSIGN i = INTEGER(x) NO-ERROR.
      MESSAGE "Converted value:" i.
    END.
    WHEN "Date" THEN DO:
      ASSIGN dd = DATE(INTEGER(SUBSTR(x,1,2)),
                       INTEGER(SUBSTR(x,4,2)),
                       INTEGER(SUBSTR(x,7)) ) NO-ERROR.
      MESSAGE "Converted value:" dd.
    END. 
    WHEN "Decimal" THEN DO:
      ASSIGN d = DEC(x) NO-ERROR.
      MESSAGE "Converted value:" d.
    END.
    WHEN "Logical" THEN DO:
      ASSIGN l = x = "yes" OR x = "true" NO-ERROR.
      MESSAGE "Converted value:" l.
    END.
  END.    
END.
