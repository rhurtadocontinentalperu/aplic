
/**
 * UserInfoDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName UserInfo
&else
    &scoped xName {1}
&endif



{ttuserinfo.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
