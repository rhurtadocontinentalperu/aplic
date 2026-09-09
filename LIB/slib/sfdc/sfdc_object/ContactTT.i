
/**
 * ContactTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Contact
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                       as char     init ?
    field tAccountId                as char     init ?
    field tAssistantName            as char     init ?
    field tAssistantPhone           as char     init ?
    field tBirthdate                as date     init ?
    field tCanAllowPortalSelfReg    as log      init ?
    field tConnectionReceivedId     as char     init ?
    field tConnectionSentId         as char     init ?
    field tDepartment               as char     init ?
    field tDescription              as char     init ?
    field tEmail                    as char     init ?
    field tEmailBouncedDate         as date     init ?
    field tEmailBouncedReason       as char     init ?
    field tFax                      as char     init ?
    field tFirstName                as char     init ?
    field tHasOptedOutofEmail       as log      init ?
    field tHomePhone                as char     init ?
    field tIsDeleted                as log      init ?
    field tIsPersonAccount          as log      init ?
    field tLastActivityDate         as date     init ?
    field tLastCURequestDate        as datetime init ?
    field tLastCUUpdateDate         as datetime init ?
    field tLastName                 as char     init ?
    field tLeadSource               as char     init ?
    field tMailingDetails           as char     init ?  /* city, state, country, postal code */
    field tMailingStreet            as char     init ?
    field tMasterRecordId           as char     init ?
    field tMobilePhone              as char     init ?
    field tName                     as char     init ?
    field tOtherDetails             as char     init ? /* city, state, country, postal code */
    field tOtherPhone               as char     init ?
    field tOtherStreet              as char     init ?
    field tOwnerId                  as char     init ?
    field tPhone                    as char     init ?
    field tReportsToId              as char     init ?
    field tSalutation               as char     init ?
    field tTitle                    as char     init ?

    field tBoriaField__c            as char     init ?
    
    index tId is primary /* unique */
          tId.
