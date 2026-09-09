/*===============================================================*/
/*                   Coe Press Equipment, Corp.                  */
/* smtpmail.p       Created: 03/27/01  Author: Paul C. Keary */
/*                                 plk@cpec.com  */
/* Credits:                                                      */
/* This program was adapted from a combination of the work of    */
/* Scott Auge and distributed as part of his mailsdk             */
/* Scott had laid the groundwork for sending an email with       */
/* attachments. But his original code did not verify the servers */
/* response to make sure the data was being sent properly.       */
/*                                                               */
/* Mario Paranhos @ United Systems, Inc (770)449-9696            */
/* Mario's original work smtpmail.p was a big help in developing */
/* an understanding of how SMTP works.  His program was very     */
/* elegant in the way it deals with Sockets however Scott's work */
/* had done much more in the area of including attachments.      */
/*                                                               */
/* Sam Schrieder - sschroeder@mn.rr.com                          */
/* Changed "~n" to CHR(13) + CHR(10) as RFC821 calls for         */
/* commands to end in <CRLF>, as carriage return and line feed.  */
/* NOTE: This is not fixed in the MIME section as I was not able */
/*       to test this section.                                   */
/*                                                               */
/* Disclaimer: This program is not fully tested especially with  */
/* regard to the Reading of the Server Responses, and encoding   */
/* of the MIME message body . Also the logging and server params */
/* are not completely developed.                                 */
/*                                                               */
/* 6/20/01 Geoff Crawford - for most robustness, it is           */
/*         necessary to loop through the WRITE() on the          */
/*         socket in case if the underlying transport            */
/*         does the write in more than one step.  A              */
/*         simple loop was added.                                */
/* 6/28/01 Steven Lichtenberg - Added checks for server response */
/*         to ensure the conversation happens.  On initial       */
/*         connection, there may be a significant lag before the */
/*         server responds. Looping through to recheck for       */
/*         response was necessary                                */
/* 7/3/01  Steven Lichtenberg - Modifications to more fully      */
/*         incorporate Mario's original code andto make the      */
/*         routine more modular.  Added robustness features to   */
/*         ensure the complete/correct delivery of binary        */
/*         attachments through the use of MEMPTR.  Also added    */
/*         the ability to use either                             */
/*         a file or passed text for the message body.  This     */
/*         allows for the options of sending a file as an        */
/*         attachment or as the message body.  Reworked to use   */
/*         event driven principles for cleaner code and easier   */
/*         maintenance.                                          */
/*                                                               */
/*===============================================================*/
/* Desc: Opens up an SMTP connection and sends an email message  */
/*       to multiple recipients.                                 */
/* SMTP Protocols taken from RFC821                              */
/* MIME Protocols taken from RFC1521                             */
/* Parameters:                                                   */
/* MailHub   - settable SMTP server name/IP address              */
/* EmailFrom - email address of user originating the email, the  */
/*             SMTP server should require that this user is real */
/* EmailTo,CC - list of email addresses separated by semicolons  */
/*             or commas (All semicolons will be replaced by     */
/*             commas so don't include stuff like Smith, John    */
/* Attachments - Comma separated list of attachment descriptions */
/*             Format looks like:                                */
/* file[:type=<mimetype>][:charset=<charset>][:filetype=<filetype] */
/* LocalFiles  - comma separated list of filenames to the files  */
/*             described in Attachments.  The filenames in this  */
/*             parameter must either be in the Progress path or  */
/*             have the entire path specified.  In contrast to   */
/*             filenames in the Attachments are the filenames to */
/*             show for the Attachments.                         */
/* Subject     - No explaination necessary                       */
/* Body        - Actual text of the message can be whatever you  */
/*             want as long as you include the correct Header    */
/*             information in the MIMEHeader.                    */
/*             If you are just sending plaintext you can leave   */
/*             the MIMEHeader blank, this is default setting     */
/*             If you wanted to send HTML you might use:         */
/*             type=text/html:charset=us-ascii:filetype=ascii    */
/* MIMEHeader [type=<mimetype>][:charset=<chrset>][:filetype=<type>] */
/* BodyType    - File/text.  Determines whether a file or text   */
/*               goes into the message body.                     */
/*                                                               */
/* oSuccessful - Yes the message was succesfully generated       */
/*               No there was some error that prevented message  */
/*                  from being successful generated.             */
/*               ? there may have been a problem with a recipient*/
/*                 or format of the email.                       */
/*===============================================================*/
/********** forward declare functions ***********/

function newstate returns int(input newstate as integer,
    input pstring as character,
    input hSocket as handle) forward.
function getfile returns memptr(input filnm as char) forward.

/******************** Variable definitions **************/
def input parameter mailhub         as char no-undo.
DEF INPUT PARAMETER EmailTo         AS CHAR NO-UNDO.
DEF INPUT PARAMETER EmailFrom       AS CHAR NO-UNDO.
DEF INPUT PARAMETER EmailCC         AS CHAR NO-UNDO.
DEF INPUT PARAMETER Attachments     AS CHAR NO-UNDO.
DEF INPUT PARAMETER LocalFiles      AS CHAR NO-UNDO.
DEF INPUT PARAMETER Subject         AS CHAR NO-UNDO.
DEF INPUT PARAMETER Body            AS CHAR NO-UNDO.
DEF INPUT PARAMETER MIMEHeader      AS CHAR NO-UNDO.
DEF INPUT PARAMETER  BodyType        as char no-undo.

DEF OUTPUT PARAMETER oSuccessful    AS LOGICAL NO-UNDO.
DEF OUTPUT PARAMETER vMessage       AS CHAR NO-UNDO.

/* Configure These Parameters per your specific needs */
DEF VAR loglevel                        AS INTEGER NO-UNDO.
DEF VAR LogFile             AS CHARACTER NO-UNDO.
DEF VAR EncodeDirectory         AS CHARACTER NO-UNDO.
DEF VAR xtimezone                AS CHARACTER NO-UNDO.

DEF VAR cLocalFile                      AS CHARACTER NO-UNDO.
DEF VAR cBinaryFile                     AS CHARACTER NO-UNDO.

/* Used to communicate with SMTP Socket */
DEF VAR hSocket           AS HANDLE NO-UNDO.

DEF VAR ServResponse      AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEF VAR ServerCode        AS INTEGER NO-UNDO.
DEFINE VARIABLE vState  AS INTEGER  NO-UNDO.


/* SWL 07/03/2001 counter for looping */
DEF VAR icnt                            as integer   no-undo.
def var icnt1                           as integer   no-undo.
def var filcnt                          as integer   no-undo.
def var rcptcnt                         as integer   no-undo.
def var rspcnt                          as integer   no-undo.
DEF VAR AttachBinlist                   as character no-undo.
/****************************************************************/
/* Only Log attachments if debug level = 1                      */
/*   modify log locations as required                           */
/****************************************************************/

on u1 of this-procedure
do:
    apply "close" to this-procedure.
end. /* on u1 */
assign
    loglevel = 1  /* Minimal logging = 3.  Verbose logging = 1 */
    EncodeDirectory = "d:/progress/wrk/"
    LogFile = "d:/progress/wrk/socketemail.log".


/* Make sure EncodeDirectory ends in a /  */
IF SUBSTRING(EncodeDirectory,LENGTH(EncodeDirectory),1) <> "/" THEN
  EncodeDirectory = EncodeDirectory + "/".

/* Determine which timezone we are in so that the Mail will have the
   correct SENT Time */
&IF OPSYS = "UNIX"
&THEN
  INPUT THROUGH date +%Z NO-ECHO.
  SET xtimezone.
  INPUT CLOSE.
&ELSE xtimezone = "EST".
&ENDIF

DEFINE STREAM sLogfile.
&GLOBAL-DEFINE Stream STREAM sLogFile
&GLOBAL-DEFINE LOGGER PUT {&Stream} UNFORMATTED TODAY " " STRING (TIME, "hh:mm:ss") " "

/* No Point in doing anything if EmailFrom and EmailTo Not Known */
IF EmailFrom = "" or
   EmailTo = "" THEN
do:
    vmessage = "From or To is blank".
    RETURN.
end. /* if emailfrom = "" or emailto = "" */
OUTPUT {&Stream} TO VALUE(LogFile) UNBUFFERED APPEND.
IF loglevel <= 2 THEN
  {&Logger} "Socket email started" SKIP
          "Input Parameters" SKIP
          "EmailFrom = " EmailFrom SKIP
          "EmailTo = " EmailTo SKIP
          "EmailCC = " EmailCC SKIP
          "Attachments = " Attachments SKIP
          "LocalFiles = " LocalFiles SKIP
          "Subject = " Subject SKIP
          "Body = " Body SKIP
          "MIMEHeader = " MIMEHeader SKIP.
ELSE {&Logger} "Send Mail From " EmailFrom " to " EmailTo SKIP.
/* process attachments and generate a comma separated list of
   file names for the output of base64encode.p . This is done prior
   to opening the socket to minimize the impact on resources
   (you do not need to have a socket open doing nothing for hours */
if localfiles <> "" then do filcnt =  1 to num-entries(localfiles):
    if loglevel <= 2 then
        {&logger} " processing Attachement " entry(filcnt,localfiles) skip.
    run dofiles(input entry(filcnt,localfiles),
        input entry(filcnt,attachments),
        input-output attachbinlist) no-error.
    if RETURN-VALUE <> "" then
    do:
        vMessage = return-value.
        run cleanup.
        return.
    end. /* if return value <> "" then */
end. /* do icnt = 1 to num-entries(attachments) */
/****************************************************************/
/* Create the socket, log in the log file that it was succes-   */
/* ful or not.                                                  */
/****************************************************************/
if loglevel <= 2 then {&logger} "opening socket" skip.
run getsocket(input loglevel,
    input mailhub,
    output hSocket).
if RETURN-VALUE <> "" then
do:
    vMessage = return-value.
    run cleanup.
    return.
end. /* if return value <> "" then */
if not this-procedure:persistent then
    wait-for close of this-procedure.
/****************************************************************/
/*  used a readhandler to avoid timing ut issues with running   */
/*  in a non-event driven mode.  Also more fully complies with  */
/*  Mario's original program design.                            */
/****************************************************************/
procedure readhandler:
   DEFINE VARIABLE vlength     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE str         AS CHARACTER NO-UNDO.
 /*  define variable icnt        as integer   no-undo.
   define variable icnt1       as integer   no-undo. */
   DEFINE VARIABLE v           AS INTEGER   NO-UNDO.
   DEFine VARiable idx         AS INTEGER   NO-UNDO.
   DEFine VARiable mData       AS MEMPTR    NO-UNDO.
   DEFINE VARIABLE vbuffer     AS MEMPTR    NO-UNDO.

   /* Used to Build MIME Message Body */
   DEF VAR cTempValue                      AS CHARACTER NO-UNDO.
   DEF VAR cBoundary                       AS CHARACTER NO-UNDO.
   DEF VAR cMimeType                       AS CHARACTER NO-UNDO.
   DEF VAR cCharSet                        AS CHARACTER NO-UNDO.
   DEF VAR cFileType                       AS CHARACTER NO-UNDO.
   DEF VAR cFile                           AS CHARACTER NO-UNDO.
   DEF VAR cImportData                     AS CHARACTER NO-UNDO.

   DEF VAR smtpcmd         AS CHARACTER FORMAT "x(90)" NO-UNDO.
   def var teststr                         as character no-undo.

   DEF VAR cMonth                          AS CHARACTER NO-UNDO
         INIT "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".

   vlength = hSocket:GET-BYTES-AVAILABLE().
   IF vlength > 0 THEN DO:
      SET-SIZE(vbuffer) = vlength + 1.
      hSocket:READ(vbuffer, 1, vlength, 1).
      str = GET-STRING(vbuffer,1).
      if loglevel <= 2 then {&logger} "vstate " vstate skip "str " str skip.
      SET-SIZE(vbuffer) = 0.
      v = INTEGER(ENTRY(1, str," ")).

      CASE vState:
          /********************** Build message ***************/
          WHEN 1 THEN
          do:
              if loglevel <= 2 then {&logger} vstate " " v " "  "HELO" skip.
              IF v = 220 THEN  /* send helo */
               vstate = newState(2, "HELO how are you?" + chr(10) + CHR(13),hsocket).
               ELSE vState = -1.
          end. /* when 1 */
          /************************ build From **************/
          WHEN 2 THEN
          do:
             if loglevel <= 2 then {&logger} vstate " " v " "  "Mail From" skip.
              IF v = 250 THEN
              do:
               assign
                   EmailTo = REPLACE(EmailTo,";",",").
                   EmailCC = REPLACE(EmailCC,";",",").
                   vstate =  newState(3, "MAIL From: " + EmailFrom +
                                          CHR(13) + CHR(10),hsocket).
               end. /* if v = 250 */
               ELSE vState = -1.
          end. /* when 2 */
          /********************assign to and cc **************/
          WHEN 3 THEN
          do:
              assign
                  icnt    = if icnt = 0 then 1 else
                            if icnt = ? then 1 else icnt
                  icnt1   = if icnt1 = 0 then 1 else
                            if icnt1 = ? then 1 else icnt1
                  rcptcnt = num-entries(emailto) + num-entries(emailcc)
                  smtpcmd = "".
              /*****************************************************************
              ***       in case we get multiple responses back in the same packet,
              ***       we need to parse the return string to determine how many
              ***       responses we get back
              **********************************************************************/

              if loglevel <= 2 then {&logger} vstate " " v " "  "Mail to/CC" skip "rcptcnt " rcptcnt skip
              "rspcnt " rspcnt " emailto " num-entries(emailto) " cc " num-entries(emailcc) skip.
              IF v = 250 THEN 
              do:       /* loop through all to's and cc's  */
                  do icnt = icnt to num-entries(EmailTo):
                   /*   smtpcmd = smtpcmd + "RCPT TO: " + entry(icnt,EmailTo) + chr(13) + chr(10). */
                      if loglevel <= 2 then  {&logger} icnt "email to " entry(icnt,emailto) skip.
                      vstate = newState(3, "RCPT TO: " + entry(icnt,EmailTo) + chr(13) + chr(10),hsocket). 
                  end.  /*  do icnt = 1 to num-entries(EmailTo): */
                  if emailcc <> "" then do icnt1 = icnt1 to num-entries(Emailcc):
                    /*  smtpcmd = smtpcmd + "RCPT TO: " + entry(icnt1,Emailcc) + chr(13) + chr(10). */
                      if loglevel <= 2 then  {&logger} icnt1 " email to " entry(icnt1,emailcc) skip.
                      vstate = newState(3, "RCPT TO: " + entry(icnt1,EmailCC) + chr(13) + chr(10),hsocket). 
                  end. /* if emailcc <> "" then do*/
              end. /*  IF v = 250 THEN */
              /* set-size(mData) = length(smtpcmd) + 1.
              put-string(mData,1) = smtpcmd.
              RUN WriteData(input mData,
                            input hsocket).
              set-size(mData) = 0.  */
              teststr = str.
              rpt-bl:
              repeat:
                  if index(teststr,"Recipient") = 0 then leave rpt-bl.
                  else rspcnt = rspcnt + 1.
                  teststr = substr(teststr,index(teststr,"Recipient") + 9).
              end. /* repeat */
              if loglevel <= 2 then  {&logger} "end of 3: " str skip  "rspcnt " rspcnt "rcptcnt " rcptcnt skip.
              if rspcnt = rcptcnt then  vstate = newstate(5,"DATA" + chr(13) + chr(10),hsocket).

          end. /* when 3 */
          /*************** build header ********************/
          WHEN 4 THEN
          do:
             if loglevel <= 2 then {&logger} vstate " " v " "  "Data" skip.
              IF v = 250 THEN
              vstate = newState(5, "DATA" + chr(13) + chr(10),hsocket).
                      ELSE vState = -1.
          end. /* when 4 */
          WHEN 5 THEN
          do:
             if loglevel <= 2 then {&logger} vstate " " v " "  "build header/send data" skip.
              IF v = 354 THEN
              do:
                  /* Build Email Header */
                smtpcmd = "From: " + EmailFrom +  CHR(13) + CHR(10).

                        /**************************************/
                        /* Loop through all To's              */
                        /**************************************/
                IF EmailTo <> "" THEN
                DO idx = 1 TO NUM-ENTRIES(EmailTo):
                    smtpcmd = smtpcmd + "To: " + ENTRY(idx,EmailTo) +  CHR(13) + CHR(10).
                END.  /* IF EmailTo <> "" THEN DO idx = 1 */

                            /*****************************/
                            /* Loop through all CC's     */
                            /*****************************/
                IF EmailCC <> "" THEN
                DO idx = 1 TO NUM-ENTRIES(EmailCC):
                    smtpcmd = smtpcmd + "Cc: " + ENTRY(idx,EmailCC) +  CHR(13) + CHR(10).
                END.  /* IF EmailCC <> "" THEN  */
                assign
                    smtpcmd = smtpcmd + "Subject: " + Subject +  CHR(13) + CHR(10)
                      /* Sample format    Date: 27 March 2001 10:30:00 EST */
                    smtpcmd = smtpcmd + "Date: " + STRING(DAY(TODAY)) + " " +
                       entry(MONTH(TODAY),cMonth) + " " +
                       STRING(YEAR(TODAY),"9999") + " " +
                       STRING(TIME,"hh:mm:ss") + " " + xtimezone +  CHR(13) + CHR(10).
                vstate = newState(5,smtpcmd,hsocket).
                /****************************************************************/
                /* Begin sending message                                        */
                /****************************************************************/
                /* Done building Email Header, Now do the body of the message */
                /** Set up a boundary value if we have file attachments **/
                /** Create multi mime header for email **/
                IF Attachments <> "" THEN DO:
                  assign
                    cBoundary = "MAIL_BOUNDARY"
                    smtpcmd = "MIME-Version: 1.0" + chr(13) + chr(10) +
                         'Content-type: multipart/mixed; boundary="' +
                     cBoundary + chr(13) + chr(10) + "Content-Transfer-Encoding: 7bit" +
                          chr(13) + chr(10).

                      .
                     smtpcmd = smtpcmd + "This is a multi-part MIME Encoded message" +
                          chr(13) + chr(10) + chr(13) + chr(10) +
                          "--" + cBoundary + chr(13) + chr(10).
                  set-size(mData) = length(smtpcmd) + 1.
                  put-string(mData,1) = smtpcmd.
                  RUN WriteData(input mData,
                      input hsocket).
                  set-size(mData) = 0.
                END. /* IF Attachments <> "" THEN DO: */

                /** Do we have a MIME Type for this messsage **/
                IF MIMEHeader <> "" THEN DO:
                  RUN ParseParm(input MIMEHeader,
                      output cMimetype,
                      output cCharset,
                      output cfiletype).
                  smtpcmd = IF Attachments <> "" THEN "Mime-Version: 1.0~n"
                                      ELSE "".
                  smtpcmd = smtpcmd + "Content-Type: " + cMimeType +
                         "; charset=" + cCharSet + "~n" +
                                 "Content-Transfer-Encoding: 7bit~n".
                  set-size(mData) = length(smtpcmd) + 1.
                  put-string(mData,1) = smtpcmd.
                  RUN WriteData(input mData,
                      input hsocket).
                  set-size(mData) = 0.
                END.  /* IF MIMEHeader <> "" THEN DO: */

                /****************************************************************/
                /* Output the Message                                           */
                /****************************************************************/
                smtpcmd = chr(13) + chr(10).
                if bodytype = "file" then
                do:
                    if loglevel <= 2 then   {&logger} "before getfile " get-size(mdata) skip.
                    mData = getfile(body).
                    if loglevel <= 2 then  {&logger} "after getfile " get-size(mdata) skip.
                    run WriteData(input mData,
                        input hsocket).
                    set-size(mData) = 0.
                end. /* if bodytype = "file" */
                else
                do:
                    smtpcmd = smtpcmd + Body + chr(13) + chr(10).
                    set-size(mData) = length(smtpcmd) + 1.
                    put-string(mData,1) = smtpcmd.
                    RUN WriteData(input mData,
                        input hsocket).
                    set-size(mData) = 0.
                END.  /*  else */
                /****************************************************************/
                /* Process any files attachments.                               */
                /****************************************************************/
                /* LocalFiles holds comma separated list of files that are in the
                   Progress path or contain an fullpath
                   Attachments holds colon separated list of parameters of
                   to use in sending file. The 1st parameter is the name of file to
                   use in generating a temporary file, the remaining parameters are
                   all optional: Type=text/plain   Charset=US-ASCII   FileType=ASCII
                */

                DO idx = 1 TO NUM-ENTRIES(LocalFiles):
                    ASSIGN
                        cFile = ENTRY(1,ENTRY(idx,Attachments),":")
                        cLocalFile = ENTRY(idx,LocalFiles).

                  /** set up the mime header **/
                  /* Content-Type: <mimetype>; charset=<charset> */
                  run parseParm(input entry(idx,attachments),
                      output cMimetype,
                      output cCharset,
                      output cfiletype).

                  smtpcmd = chr(13) + chr(10) + "--" + cBoundary + chr(13) + chr(10) +
                                 "Content-type: " + cMimeType + "; ".
                  IF cFileType <> "Binary" THEN
                    smtpcmd = smtpcmd + cCharSet.

                  smtpcmd = smtpcmd + chr(13) + chr(10) + '        name="' + cFile + '"' + chr(13) + chr(10).


                  IF cFileType = "Binary" THEN
                    smtpcmd = smtpcmd + 'Content-Transfer-Encoding: base64' + chr(13) + chr(10).

                  smtpcmd = smtpcmd + 'Content-Disposition: attachment;' +  chr(13) + chr(10) +
                                 '        filename="' + cFile + '"' +  chr(13) + chr(10) +  chr(13) + chr(10).
                  set-size(mData) = length(smtpcmd) + 1.
                  put-string(mData,1) = smtpcmd.
                  RUN WriteData(input mData,
                      input hsocket).
                  set-size(mData) = 0.

                  /** now do the file **/
                  mData = getfile(entry(idx,attachbinlist)).
                  run WriteData(input mData,
                      input hsocket).
                  set-size(mData) = 0.
                  IF cFileType = "Binary" THEN

                  /** if we have a "Binary" file then try to delete the encoded version **/
                    OS-DELETE VALUE(entry(idx,attachbinlist)) NO-ERROR.
                END. /** process each file attachment  do idx - 1 to num-entries **/

                IF Attachments <> "" THEN DO:
                  smtpcmd = chr(13) + chr(10) + '--' + cBoundary + '--' + chr(13) + chr(10) + chr(13) + chr(10).
                  set-size(mData) = length(smtpcmd) + 1.
                  put-string(mData,1) = smtpcmd.
                  RUN WriteData(input mData,
                      input hsocket).
                  set-size(mData) = 0.
                end. /* IF Attachments <> "" THEN DO: */
                vstate = newstate(6,chr(13) + chr(10) + "." + chr(13) + chr(10),hsocket).
             end. /* if v = 354 */
             ELSE vState = -1.
          end. /* when 5 */
          WHEN 6 THEN
          do:
              if loglevel <= 2 then {&logger} vstate " " v " "  "send quit" skip.
              IF v = 250 THEN
                  vstate = newState(7,"QUIT" + chr(13) + chr(10),hsocket).
              ELSE vState = -1.
          end. /* when 6 */
      END CASE. /* vstate */
   END. /* IF vlength > 0 THEN DO: */
   if loglevel <= 2 then {&logger}   "Finish up " vstate skip.
   IF vState = 7 THEN vMESSAGE = "Email has been accepted for delivery.".
   IF vState < 0 THEN vMESSAGE = "Email has been aborted.".
   IF vstate < 0 OR vstate = 7 THEN DO:
      RUN cleanup.
      if vstate = 7 then oSuccessful = YES.
      APPLY 'CLOSE' TO THIS-PROCEDURE.
      apply "u1" to this-procedure.
   END.  /* IF vstate < 0 OR vstate = 7 THEN DO: */
END procedure.   /* readhandler */

PROCEDURE Cleanup.
  {&Logger} "End SMTP Session" SKIP.
  OUTPUT {&Stream} CLOSE. 

  IF hSocket:CONNECTED() THEN hSocket:DISCONNECT() NO-ERROR.
  DELETE OBJECT hSocket.
END procedure. /* cleanup */

PROCEDURE WriteData:
    define input parameter mdata as memptr no-undo.
    define input parameter hsocket as handle no-undo.
    DEFINE VARIABLE DataBytesWritten AS INTEGER NO-UNDO.
    DEFINE VARIABLE WriteSuccess AS LOGICAL NO-UNDO.
    DEFINE VARIABLE MessageSize AS INTEGER NO-UNDO.

    ASSIGN
        MessageSize = GET-SIZE(mdata)
        DataBytesWritten = 0.
    if messagesize = 0 then return.

  /* 6/20/01 GC - Loop continuously until the number of bytes
                  written is greater or equal to the message size */
  if loglevel <= 2 then  {&logger} "writedata = before loop" DataBytesWritten " " MessageSize " " hSocket:BYTES-WRITTEN skip
  .
  DO WHILE DataBytesWritten < MessageSize:
  if loglevel <= 2 then  {&logger} "writedata = in loop loop" DataBytesWritten " " MessageSize " " hSocket:BYTES-WRITTEN skip
  .
    WriteSuccess = hSocket:WRITE(mdata, DataBytesWritten + 1, MessageSize - DataBytesWritten).
    /*IF NOT WriteSuccess THEN LEAVE. */
    if writesuccess then DataBytesWritten = DataBytesWritten + hSocket:BYTES-WRITTEN.
  END. /* DO WHILE */
  if loglevel <= 2 then  {&logger} "after loop" DataBytesWritten " " hSocket:BYTES-WRITTEN " " MessageSize skip.
  SET-SIZE(mData) = 0.
END procedure. /* writeData */

/*******************************************************************/
/** Parse mime type and char set out of header                    **/
/** If nothing there, return the default                          **/
/*******************************************************************/
PROCEDURE ParseParm:
    DEF INPUT PARAMETER cString         AS CHARACTER NO-UNDO.
    def output parameter cMimetype      as character no-undo.
    def output parameter cCharset       as character no-undo.
    def output parameter cFiletype      as character no-undo.

    DEF VAR c               AS CHARACTER NO-UNDO.
    DEF VAR i               AS INTEGER  NO-UNDO.

    ASSIGN
        cMimeType = "text/plain"
        cCharSet  = "US-ASCII"
        cFileType = "ASCII".

    DO i = 1 TO NUM-ENTRIES(cString,":"):
      c = ENTRY(i,cString,":").
      CASE ENTRY(1,c,"="):
        WHEN "Type" THEN DO:
          cMimeType = ENTRY(2,c,"=").
        END.  /*  WHEN "Type" THEN DO: */
        WHEN "CharSet" THEN DO:
          cCharSet = ENTRY(2,c,"=").
        END.  /*   WHEN "CharSet" THEN DO: */
        WHEN "FileType" THEN DO:
          cFileType = ENTRY(2,c,"=").
        END.  /* WHEN "FileType" THEN DO: */
      END CASE. /*  CASE ENTRY(1,c,"="): */
    END.  /* DO i = 1 TO NUM-ENTRIES(cString,":"): */
END PROCEDURE. /** ParseParm **/
/*****************************************************************/
/*  Generate base 64 encoded binary files                       **/
/*****************************************************************/
procedure dofiles:
    define input parameter localfile            as char no-undo.
    define input parameter cattachment           as char no-undo.
    define input-output parameter attachbinlist as char no-undo.

    define var cLocalFile                       as char no-undo.
    define var Mimetype                     as character no-undo.
    define var ccharset                      as character no-undo.
    DEF VAR cFileType                       AS CHARACTER NO-UNDO.

    file-info:file-name = localfile.
    /***** file-info returns "F" + "RW" if the file is read/writable etc)
           check to be sure it is a valid file    ************/
    if index(file-info:file-type,"F") = 0 then return localfile + " Not a valid file".


    RUN ParseParm(input cAttachment,
        output mimetype,
        output cCHARSET,
        output cfiletype).

    IF cFileType = "Binary" THEN
    DO:
        assign
            cBinaryFile = LocalFile
            cLocalFile  = EncodeDirectory + localfile + "." +
                STRING(RANDOM(1,99999),"99999")
            attachbinlist = if attachbinlist = "" then cLocalFile
                else attachbinlist + "<" + cLocalFile.
        RUN base64encode.p(cBinaryFile, cLocalFile).
    END.  /* IF cFileType = "Binary" THEN  */
    else attachbinlist = if attachbinlist = "" then localfile else
        attachbinlist + "," + localfile.
    return "".
end procedure. /* dofiles */
procedure getsocket:
    define input parameter loglevel as int no-undo.
    define input parameter mailhub  as char no-undo.
    define output parameter hSocket as handle no-undo.

    CREATE SOCKET hSocket.
    hSocket:SET-SOCKET-OPTION ("TCP-NODELAY", "FALSE").
    hSocket:SET-SOCKET-OPTION ("SO-LINGER", "FALSE").
    hSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler",THIS-PROCEDURE).

    hSocket:CONNECT("-H " + MailHub + " -S 25") NO-ERROR.

    IF hSocket:CONNECTED() = FALSE THEN
    DO:
        {&LOGGER} "Unable to Connect to " + Mailhub + "~n".
        RUN CleanUp.
        RETURN "No Connection".
    END.  /* Cannot make a connection to mail server */
    IF loglevel <= 2 THEN {&LOGGER} "Socket Connection Established.~n".
    vstate = 1.
    return "".
end procedure. /* getsocket */
/******************* Functions ********************************/
function newstate returns int(input newstate as integer,
    input pstring as character,
    input hSocket as handle):
    def var vState  as integer no-undo.
    def var vbuffer as memptr  no-undo.
    dEFINE VARIABLE DataBytesWritten AS INTEGER NO-UNDO.
    DEFINE VARIABLE WriteSuccess AS LOGICAL NO-UNDO.
    DEFINE VARIABLE MessageSize AS INTEGER NO-UNDO.
    if loglevel <= 2 then
         {&logger} "newstate " newstate " pstring " pstring skip .
    ASSIGN DataBytesWritten = 0
             MessageSize = LENGTH(pstring).
      SET-SIZE(vbuffer) = 0.
    vState = newState.
    IF pstring = "" THEN RETURN -1.
    SET-SIZE(vbuffer) = LENGTH(pstring) + 1.
    PUT-STRING(vbuffer,1) = pstring.
      /* 6/20/01 GC - Loop continuously until the number of bytes
                      written is greater or equal to the message size */
    if loglevel <= 2 then  {&logger} "newstate - before loop " DataBytesWritten " " MessageSize " " hSocket:BYTES-WRITTEN skip.
    DO WHILE DataBytesWritten < MessageSize:
        WriteSuccess = hSocket:WRITE(vbuffer, DataBytesWritten + 1, MessageSize - DataBytesWritten).
        IF NOT WriteSuccess THEN LEAVE.
        DataBytesWritten = DataBytesWritten + hSocket:BYTES-WRITTEN.
    END. /* DO WHILE */
   if loglevel <= 2 then  {&logger} "newstate - after loop " DataBytesWritten " " hSocket:BYTES-WRITTEN " " MessageSize skip.
    SET-SIZE(vbuffer) = 0.
    return vstate.
END function.  /* newstate */

function getfile returns memptr(input filnm as char):
    def var hdata as memptr no-undo.
    file-info:file-name = filnm.
    if loglevel <= 2 then  {&logger} "in getfile " file-info:file-name skip file-info:full-pathname skip file-info:file-type skip
    file-info:file-size skip.
    if index(file-info:file-type,"f") = 0 then
    do:
        set-size(hdata) = 0.
        return hdata.
    end. /*     if file-info:file-type <> "f" then */
    else
    do:
        set-size(hdata) = 0.
        input from value(file-info:file-name) binary no-map no-convert.
        set-size(hdata) = file-info:file-size + 1.
        import unformatted hdata no-error.
        if error-status:error then
            set-size(hdata) = 0.
        return hdata.
    end. /* else */
  /*  set-size(hdata) = 0. */
end function. /* getfile */
