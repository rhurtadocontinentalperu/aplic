define temp-table tt
    field ii as int
    field cc as char initial ?
    .
define dataset ds for tt.
def var lcxml as longchar.

create tt. assign tt.ii = 1 tt.cc = 'one'.
create tt. assign tt.ii = 2. 

dataset ds:write-xml( 'longchar', lcxml, true, 'utf-8',  ?, ?, ?, true ).

message string( lcxml ).

/*
DEFINE TEMP-TABLE ttCust LIKE Customer.
DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted AS LOGICAL NO-UNDO.
DEFINE VARIABLE cEncoding AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSchemaLocation AS CHARACTER NO-UNDO.
DEFINE VARIABLE lWriteSchema AS LOGICAL NO-UNDO.
DEFINE VARIABLE lMinSchema AS LOGICAL NO-UNDO.
DEFINE VARIABLE retOK AS LOGICAL NO-UNDO. 
/*  code to populate the temp-table  */ 
ASSIGN     
cTargetType = "file"     
cFile = "ttCust.xml"      
lFormatted = YES     
cEncoding = ?     
cSchemaLocation = ?     
lWriteSchema = NO     
lMinSchema = NO. 
retOK = TEMP-TABLE ttCust:WRITE-XML(cTargetType,  
cFile,
lFormatted,                                    
cEncoding,                                    
cSchemaLocation,                                    
lWriteSchema,                                    
lMinSchema).
*/
