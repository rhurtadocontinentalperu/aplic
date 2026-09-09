
/**
 * LoginResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName LoginResponse
&else
    &scoped xName {1}
&endif



{LoginResponseTT.i  {&xName}}
{UserInfoTT.i       {&xName}_UserInfo}

define dataset ds{&xName} 

    for tt{&xName}, tt{&xName}_UserInfo

        data-relation tuserId for tt{&xName}, tt{&xName}_UserInfo relation-fields ( tuserId, tuserId ).
