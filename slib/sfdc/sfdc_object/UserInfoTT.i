
/**
 * UserInfoTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName UserInfo
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field taccessibilityMode            as log  init ?
    field tcurrencySymbol               as char init ?
    field torganizationId               as char init ?
    field torganizationMultiCurrency    as char init ?
    field torganizationName             as char init ?
    field tprofileId                    as char init ?
    field troleId                       as char init ?
    field tuserDefaultCurrencyIsoCode   as char init ?
    field tuserEmail                    as char init ?
    field tuserFullName                 as char init ?
    field tuserId                       as char init ?
    field tuserLanguage                 as char init ?
    field tuserLocale                   as char init ?
    field tuserName                     as char init ?
    field tuserTimeZone                 as char init ?
    field tuserType                     as char init ?
    field tuserUiSkin                   as char init ?

    index tuserId is primary
          tuserId.

