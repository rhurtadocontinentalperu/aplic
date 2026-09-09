************************************************************
*
*  Production Version Release
*  Graphics Driver for Intelr 810/810E/815/815E/815EM Chipsets                   
*  Microsoft Windows* 95 (all versions)                                          
*  Microsoft Windows* 98                                                         
*  Microsoft Windows* 98 Second Edition                                          
*  Microsoft Windows* Millennium                                                 
*  Driver Revision: 4.13.01.2843
*  Package: 9107 
*
*  6.4 Production Version                                                        
*
*
*  August 1, 2001
*              
*	NOTE:  This document refers to systems containing the 
*         following Intel products:   
*
*	 Intel(R) 810 Chipset                                 
*	 Intel(R) 810E Chipset                                
*	 Intel(R) 815 Chipset                                 
*	 Intel(R) 815E Chipset                                
*	 Intel(R) 815EM Chipset                               
*	
*
*
*  Installation Information
*             
*  This document makes references to products developed by 
*  Intel. There are some restrictions on how these products 
*  may be used and what information may be disclosed to 
*  others. Please read the Disclaimer section and contact 
*  your Intel field representative if you would like more 
*  information.
* 
************************************************************
************************************************************
*  DISCLAIMER: Intel is making no claims of usability, 
*  efficacy or warranty.  The INTEL SOFTWARE LICENSE AGREEMENT 
*  contained herein completely defines the license and use of 
*  this software.

************************************************************
************************************************************

*  CONTENTS OF THIS DOCUMENT
************************************************************

This document contains the following sections:

1.  System Requirements
2.  Localized Language Abbreviations
3.  Installing the Software
4.  Verifying Installation of the Software
5.  Identifying the Software Version Number
6.  Uninstalling the Software
7.  Installation Switches Available

************************************************************
* 1.  SYSTEM REQUIREMENTS
************************************************************

1.  The system must contain one of the following Intel 
    Chipsets:

          Intel(R) 810 chipset
          Intel(R) 810E chipset
          Intel(R) 810E2 chipset
          Intel(R) 815 chipset
          Intel(R) 815E chipset
          Intel(R) 815EM chipset
      
2.  The software should be installed on systems with at
    least 64 MB of system memory.

3.  There should be sufficient hard disk space in the <TEMP>
    directory (typically C:\WINDOWS\TEMP or C:\TEMP) on the
    system in order to install this software.

    The drivers included with this distribution package are
    designed to function with all released versions of
    Microsoft Windows 95, Microsoft Windows 98, and
    Microsoft Windows Millennium Edition.
    
4.  Windows* 95 must have DCOM95 installed prior to
    installing these drivers.  This is not necessary for
    later versions of Windows.  DCOM95 is available from
    Microsoft at the following location:
    http://www.microsoft.com/com/dcom/dcom95/dcom1_3.asp

Please check with your system provider to determine the
operating system and Intel Chipset used in your system.

************************************************************
* 2.  LOCALIZED LANGUAGE ABBREVIATIONS
************************************************************

The following list is the abbreviations of all languages
that the driver has been localized in.  You may have to
reference this section while using this document.

chs -> Mainland Chinese
cht -> Traditional Chinese
dan -> Danish
deu -> German
eng -> International English
enu -> English
esp -> Spanish
fin -> Finnish
fra -> French
frc -> French Canadian
ita -> Italian
jpn -> Japanese
kor -> Korean
nld -> Dutch
nor -> Norwegian
plk -> Polish
ptb -> Brazilian Portuguese
ptg -> Portuguese
rus -> Russian
sve -> Swedish
tha -> Thai

************************************************************
* 3.  INSTALLING THE SOFTWARE
************************************************************

General Installation Notes:

1.  The operating system must be installed prior to the
    installation of the driver.

2.  This installation procedure is specific only to the 
    version of driver and installation file included in this 
    release.
    
3.  If a previous version of an Intel(R) Graphics Driver
    is installed, remove it before proceeding with the
    installation procedure.  Please refer to Section 6,
    UNINSTALLING THE SOFTWARE for removal instructions.

4.  You can choose four different methods of installation
    for this release. The files that must be downloaded for
    each are indicated in the appropriate section.

        1) InstallShield* (automated) install from CD-ROM
           See Section 3.1.
        2) InstallShield* (automated) install from web download
           See Section 3.1.
	3) Manual install from hard drive
           See Section 3.2.
	4) Manual install from CD-ROM
	   see Section 3.2.

3.1  INSTALLSHIELD (AUTOMATED) INSTALL FROM CD-ROM or WEB DOWNLOAD

1.  To install from a CD, insert the CD-ROM.  If autorun is
    enabled, the installer will begin automatically.
    Otherwise, enter the "Graphics" directory on the CD-ROM
    and double-click "SETUP.EXE".  Continue on to step 3.

2.  To install from a Web download, you will download either a 
    ZIP file or an EXE file from the Web.
    a. If it is an EXE file, double-click the file you downloaded
       and the installation will begin automatically.  Continue on
       to step 3.
    b. If it is a ZIP file, you must unzip it using a
       utility such as WinZip* or PKZip*, then enter the
       directory into which you unzipped the files.  Enter
       the "Graphics" subdirectory and double-click
       "SETUP.EXE".  Continue on to step 3.

3.  Click "Next" on the Welcome screen.

4.  Read the license agreement and click "Yes" to continue.

5.  The driver files will now be installed. When the install
    finishes, choose the "Yes" to reboot option, and click
    "Finish" to restart your computer. The driver should
    now be loaded. To determine if the driver has been loaded
    correctly, refer to the Verifying Installation section
    below.


3.2 MANUAL INSTALL FROM CD-ROM OR HARD DRIVE 

1.  Download "WIN9X.ZIP" from the Web.  You must unzip it
    using a utility such as WinZip* or PKZip*.  Transfer the
    files to a CD if you wish to install from the CD-ROM.

2.  Select the "My Computer" icon, the "Control Panel" icon,
    and then the "Display" icon.

3.  You should now be in the "Display Properties" window. 
    Select the "Settings" tab, and click on the "Advanced"
    button. 

4.  In the "Advanced Display Properties" window, select the 
    "Adapter" tab, and click the "Change..." button.

5.  The "Update Device Driver Wizard" window appears. 
    Click on the "Next" button to continue.

6.  A new window appears, prompting either for Windows to 
    search for a device driver or for manual selection.
    Click the following option: "Display a list of all the
    drivers in a specific location, so you can select the
    driver you want." After this, click on the "Next"
    button.

7.  From the new window, click on the "Have Disk" button and
    then the "Browse" button.

8.  Enter the directory where you unzipped WIN9X.ZIP and 
    then enter the "Graphics" subdirectory. Next enter the
    "Win9X" subdirectory. At this point, the "I81XW9X.INF"
    file should be highlighted. Click "OK".

9.  Click "OK". The "Select Device" screen should open and
    it may it may have several options to choose from. If a
    warning appears saying that the driver chosen was not
    written specifically for the selected hardware, click
    "Yes". Select the display adapter that your system
    contains. Click "OK".

10. Click "Next". The driver should install. If you are
    installing an older version of the driver after having
    previously installed a newer version, several "Version
    Conflict" windows may appear asking if you want to keep
    the newer driver files. If you do want to continue
    installing the older drivers, click "No" on each of
    these screens. Click "Finish" when done.

11. Close all open windows and click "Yes" to reboot. The 
    driver should now be loaded. To determine if the driver
    has been loaded correctly, refer to the Verifying
    Installation section below.


************************************************************
* 4.  VERIFYING INSTALLATION OF THE SOFTWARE
************************************************************

1.  From the desktop, click on "My Computer", then "Control 
    Panel", and finally, "System".

2.  You should be in the "System Properties" window. Click 
    on the "Device Manager" tab. From here, go down to
    "Display Adapter" and click. The Intel(R) Graphics
    Driver should be listed.  If not, the driver is not
    installed correctly. To check the version of the driver,
    refer to the section below.

************************************************************
* 5.  IDENTIFYING THE SOFTWARE VERSION NUMBER
************************************************************

1.  Select the "My Computer" icon, the "Control Panel" icon,
    and then the "Display" icon.

2.  You should now be in the "Display Properties" window. 
    Select the "Settings" tab and click the "Advanced"
    button.

3.  Select the "Intel(R) Graphics Technology" tab. The
    graphics driver version should be listed on this screen.

************************************************************
* 6.  UNINSTALLING THE SOFTWARE
************************************************************

NOTE: This procedure assumes the above installation process
was successful. This uninstallation procedure is specific
only to the version of the driver and installation files
included in this package.

1.  From the desktop, click on "My Computer", "Control
    Panel", and then "Display".

2.  You should be in the "Display Properties" window. Click 
    on the "Settings" tab. Next, click the "Advanced"
    button. 

3.  Select the "Adapter" tab. The driver information will 
    appear. Click on the "Change" button. 

4.  The "Update Device Driver Wizard" window should open. 
    For Windows* Me only, select the "Specify the location
    of the driver (Advanced)" option.  Click "Next".

5.  In the next window, select the "Display a list..." option
    and click the "Next" button. Next, click on "Show all 
    hardware".

6.  In the split screen window under "Manufacturers:", select 
    "(Standard display types)". In the other half of the split 
    window, select "Standard PCI Graphics Adapter (VGA)", then 
    click on the "Next" button.  Click the "Next" button
    again.

7.  Click on "Finish," then close all open windows.  When
    asked to restart, click on "Yes."

8.  To verify that the VGA driver was installed correctly, 
    refer to Section 4 and look for "Standard PCI Graphics 
    Adapter (VGA)," instead of the Intel(R) Graphics Driver.

************************************************************
* 7.  INSTALLATION SWITCHES AVAILABLE
************************************************************

The switches in the SETUP.EXE file will have the following 
syntax.  Switches are not case sensitive and may be 
specified in any order (except for the -s switch).  Switches 
must be separated by spaces.

SETUP [-b] [-g{xx[x]}] [ [ -nocuidlg{xxxx}, [-nocuidlg{xxxx}]...] 
| -nodiag | -basic] [-overwrite] [-nolic] 
[-bits x x_pixels x y_pixels x vert_refresh] [-l{lang_value}] 
[-s] [-f2<path\logfile>]

GFX-INSTALL CUSTOMER SWITCHES
-b  Forces a system reboot after the installation completes.  
In non-silent mode, the absence of this switch will prompt the 
user to reboot. In silent mode, the absence of this switch forces 
the Setup.exe to complete without rebooting (the user must 
manually reboot to conclude the installation process).

-g{xx[x]}  Forces the configuration of a specific language 
version of the driver during the install.  The absence of this 
switch will cause the installation to utilize the language of 
the OS locale as its default.

-overwrite  Installs the graphics driver regardless of the 
version of previously installed driver.  In non-silent mode, the 
absence of this switch will prompt the user to confirm overwrite 
of a newer Intel Graphics driver. In silent mode, the absence of 
this switch means that the installation will abort any attempts 
to regress the revision of the Intel Graphics driver.

-nolic	Suppresses the display of the license agreement screen.  
In non-silent mode, the absence of this switch will only prompt 
the user to view and accept the license agreement. The 
functionality of this switch is automatically included during 
silent installations.

-bits x x_pixels x y_pixels x vert_refresh  Sets the four default 
display parameters: bits per pixel, pixels per line, pixels per 
column and vertical refresh rate 

INSTALLSHIELD(TM) STANDARD SWITCHES

-l{lang_value}  The switch provided by InstallShieldTM specifies 
the language used for the Gfx-Install user interface.  The absence 
of this switch will cause the installation to utilize the language 
of the OS as its default. Detailed requirements for the Install 
Dialog language settings are given in the Install Dialog Language 
section.

-s  Run in silent mode. The absence of this switch causes the 
install to be performed in verbose mode.

-f2<path\logfile>  Specifies an alternate location and name 
of the log file created by a silent install. By default, Setup.log 
log file is created and stored during a silent install in the same 
directory as that of Setup.ins.
************************************************************
* INTEL SOFTWARE LICENSE AGREEMENT
*   (OEM/IHV/ISV Distribution & Single User)
************************************************************
IMPORTANT - READ BEFORE COPYING, INSTALLING OR USING. 
Do not use or load this software and any associated
materials (collectively, the "Software") until you have
carefully read the following terms and conditions. By
loading or using the Software, you agree to the terms of
this Agreement. If you do not wish to so agree, do not
install or use the Software.

Please Also Note:
* If you are an Original Equipment Manufacturer (OEM),
  Independent Hardware Vendor (IHV), or Independent
  Software Vendor (ISV) this complete LICENSE AGREEMENT 
  applies;
* If you are an End-User, then only Exhibit A, the INTEL
  SOFTWARE LICENSE AGREEMENT, applies.

---------------------------------------------------------
For OEMs, IHVs, and ISVs:

LICENSE.  This Software is licensed for use only in conjunction
with Intel component products.  Use of the Software in 
conjunction with non-Intel component products is not licensed
hereunder.  Subject to the terms of this Agreement, Intel
grants to You a nonexclusive, nontransferable, worldwide,
fully paid-up license under Intel's copyrights to:
  a) use, modify, and copy Software internally for Your own
     development and maintenance purposes; and
  b) modify, copy and distribute Software, including derivative
     works of the Software, to Your end-users, but only
     under a license agreement with terms at least as
     restrictive as those contained in Intel's Final,
     Single-User License Agreement, attached as Exhibit A;
     and
  c) modify, copy and distribute the end-user documentation
     that may accompany the Software, but only in
     association with the Software.
If You are not the final manufacturer or vendor of a
computer system or software program incorporating the
Software, then You may transfer a copy of the Software,
including derivative works of the Software (and related
end-user documentation), to Your recipient for use in
accordance with the terms of this Agreement, provided such
recipient agrees to be fully bound by the terms hereof. You
shall not otherwise assign, sublicense, lease or in any
other way transfer or disclose Software to any third party.
You shall not reverse-compile, disassemble or otherwise
reverse-engineer the Software.

Except as expressly stated in this Agreement, no license or
right is granted to You directly or by implication,
inducement, estoppel or otherwise. Intel shall have the
right to inspect or have an independent auditor inspect
Your relevant records to verify Your compliance with the
terms and conditions of this Agreement.

CONFIDENTIALITY.  If You wish to have a third-party
consultant or subcontractor ("Contractor") perform work on
Your behalf that involves access to or use of Software,
You shall obtain a written confidentiality agreement from
the Contractor that contains terms and obligations with
respect to access to or use of Software no less restrictive
than those set forth in this Agreement and excluding any
distribution rights, and use for any other purpose.
Otherwise, You shall not disclose the terms or existence of
this Agreement or use Intel's name in any publications,
advertisements or other announcements without Intel's
prior written consent. You do not have any rights to use
any Intel trademarks or logos.

OWNERSHIP OF SOFTWARE AND COPYRIGHTS.  Title to all copies
of the Software remains with Intel or its suppliers. The
Software is copyrighted and protected by the laws of the
United States and other countries, and by international
treaty provisions. You may not remove any copyright notices
from the Software. Intel may make changes to the Software,
or to items referenced therein, at any time without notice,
but is not obligated to support or update the Software.
Except as otherwise expressly provided, Intel grants no
express or implied right under Intel patents, copyrights,
trademarks or other intellectual property rights. You may
transfer the Software only if the recipient agrees to be
fully bound by these terms and if you retain no copies of
the Software.

LIMITED MEDIA WARRANTY.  If the Software has been delivered
by Intel on physical media, Intel warrants the media to be
free from material, physical defects for a period of ninety(90)
days after delivery by Intel. If such a defect is found,
return the media to Intel for replacement or alternate
delivery of the Software as Intel may select.

EXCLUSION OF OTHER WARRANTIES. EXCEPT AS PROVIDED ABOVE,
THE SOFTWARE IS PROVIDED "AS IS," WITHOUT ANY EXPRESS OR
IMPLIED WARRANTY OF ANY KIND, INCLUDING WARRANTIES OF
MERCHANTABILITY, NONINFRINGEMENT OR FITNESS FOR A
PARTICULAR PURPOSE.  Intel does not warrant or assume
responsibility for the accuracy or completeness of any
information, text, graphics, links or other items
contained within the Software.

LIMITATION OF LIABILITY. IN NO EVENT SHALL INTEL OR ITS
SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING,
WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION OR
LOST INFORMATION) ARISING OUT OF THE USE OF OR INABILITY TO
USE THE SOFTWARE, EVEN IF INTEL HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS PROHIBIT
EXCLUSION OR LIMITATION OF LIABILITY FOR IMPLIED WARRANTIES
OR CONSEQUENTIAL OR INCIDENTAL DAMAGES, SO THE ABOVE
LIMITATION MAY NOT APPLY TO YOU. YOU MAY ALSO HAVE OTHER
LEGAL RIGHTS THAT VARY FROM JURISDICTION TO JURISDICTION. 

TERMINATION OF THIS AGREEMENT.  Intel may terminate this
Agreement at any time if you violate its terms. Upon
termination, you will immediately destroy the Software or
return all copies of the Software to Intel.
 
APPLICABLE LAWS.  Claims arising under this Agreement shall
be governed by the laws of California, excluding its
principles of conflict of laws and the United Nations
Convention on Contracts for the Sale of Goods. You may not
export the Software in violation of applicable export laws
and regulations. Intel is not obligated under any other
agreements unless they are in writing and signed by an
authorized representative of Intel.

GOVERNMENT RESTRICTED RIGHTS.  The Software is provided
with "RESTRICTED RIGHTS." Use, duplication or disclosure
by the Government is subject to restrictions as set forth
in FAR52.227-14 and DFAR252.227-7013 et seq. or their
successors. Use of the Software by the Government
constitutes acknowledgment of Intel's proprietary rights
therein. Contractor or Manufacturer is Intel Corporation,
2200 Mission College Blvd., Santa Clara, CA 95052.

---------------------------------------------------------
EXHIBIT "A"
INTEL SOFTWARE LICENSE AGREEMENT (Final, Single User)

IMPORTANT - READ BEFORE COPYING, INSTALLING OR USING. 
Do not use or load this software and any associated
materials (collectively, the "Software") until you have
carefully read the following terms and conditions. By
loading or using the Software, you agree to the terms of
this Agreement. If you do not wish to so agree, do not
install or use the Software.

LICENSE.  You may copy the Software onto a single computer
for your personal, non-commercial use, and you may make one
back-up copy of the Software, subject to these conditions: 
1. This Software is licensed for use only in conjunction
   with Intel component products.  Use of the Software in
   conjunction with non-Intel components is not licensed
   hereunder.
2. You may not copy, modify, rent, sell, distribute or
   transfer any part of the Software except as provided in
   this Agreement, and you agree to prevent unauthorized
   copying of the Software.
3. You may not reverse-engineer, decompile or disassemble
   the Software. 
4. You may not sublicense or permit simultaneous use of the
   Software by more than one user.
5. The Software may contain the software or other property
   of third-party suppliers, some of which may be identified
   in, and licensed in accordance with, any enclosed
   "license.txt" file or other text or file. 

OWNERSHIP OF SOFTWARE AND COPYRIGHTS.  Title to all copies
of the Software remains with Intel or its suppliers. The
Software is copyrighted and protected by the laws of the
United States and other countries, and international treaty
provisions. You may not remove any copyright notices from
the Software. Intel may make changes to the Software, or to
items referenced therein, at any time without notice, but
is not obligated to support or update the Software. Except
as otherwise expressly provided, Intel grants no express or
implied right under Intel patents, copyrights, trademarks
or other intellectual property rights. You may transfer the
Software only if the recipient agrees to be fully bound by
these terms and if you retain no copies of the Software.

LIMITED MEDIA WARRANTY.  If the Software has been delivered
by Intel on physical media, Intel warrants the media to be
free from material, physical defects for a period of ninety(90)
days after delivery by Intel. If such a defect is found,
return the media to Intel for replacement or alternate
delivery of the Software as Intel may select.

EXCLUSION OF OTHER WARRANTIES. EXCEPT AS PROVIDED ABOVE,
THE SOFTWARE IS PROVIDED "AS IS," WITHOUT ANY EXPRESS OR
IMPLIED WARRANTY OF ANY KIND, INCLUDING WARRANTIES OF
MERCHANTABILITY, NONINFRINGEMENT OR FITNESS FOR A
PARTICULAR PURPOSE.  Intel does not warrant or assume
responsibility for the accuracy or completeness of any
information, text, graphics, links or other items contained
within the Software.

LIMITATION OF LIABILITY. IN NO EVENT SHALL INTEL OR ITS
SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING,
WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION OR
LOST INFORMATION) ARISING OUT OF THE USE OF OR INABILITY TO
USE THE SOFTWARE, EVEN IF INTEL HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS PROHIBIT
EXCLUSION OR LIMITATION OF LIABILITY FOR IMPLIED WARRANTIES
OR CONSEQUENTIAL OR INCIDENTAL DAMAGES, SO THE ABOVE
LIMITATION MAY NOT APPLY TO YOU. YOU MAY ALSO HAVE OTHER
LEGAL RIGHTS THAT VARY FROM JURISDICTION TO JURISDICTION. 

TERMINATION OF THIS AGREEMENT.  Intel may terminate this
Agreement at any time if you violate its terms. Upon
termination, you will immediately destroy the Software or
return all copies of the Software to Intel.
 
APPLICABLE LAWS.  Claims arising under this Agreement shall
be governed by the laws of California, excluding its
principles of conflict of laws and the United Nations
Convention on Contracts for the Sale of Goods. You may not
export the Software in violation of applicable export laws
and regulations. Intel is not obligated under any other
agreements unless they are in writing and signed by an
authorized representative of Intel.

GOVERNMENT RESTRICTED RIGHTS.  The Software is provided
with "RESTRICTED RIGHTS." Use, duplication or disclosure
by the Government is subject to restrictions as set forth
in FAR52.227-14 and DFAR252.227-7013 et seq. or their
successors. Use of the Software by the Government
constitutes acknowledgment of Intel's proprietary rights
therein. Contractor or Manufacturer is Intel Corporation,
2200 Mission College Blvd., Santa Clara, CA 95052.
 
SLAOEMISV1/RBK/January 21, 2000
************************************************************
************************************************************
Information in this document is provided in connection with
Intel products. Except as expressly stated in the INTEL
SOFTWARE LICENSE AGREEMENT contained herein, no license,
express or implied, by estoppel or otherwise, to any
intellectual property rights is granted by this document.
Except as provided in Intel's Terms and Conditions of Sale
for such products, Intel assumes no liability whatsoever,
and Intel disclaims any express or implied warranty,
relating to sale and/or use of Intel products, including
liability or warranties relating to fitness for a particular
purpose, merchantability or infringement of any patent,
copyright or other intellectual property right. Intel
products are not intended for use in medical, lifesaving,
or life-sustaining applications.

************************************************************
* Intel Corporation disclaims all warranties and liabilities
* for the use of this document, the software and the
* information contained herein, and assumes no
* responsibility for any errors which may appear in this
* document or the software, nor does Intel make a commitment
* to update the information or software contained herein.
* Intel reserves the right to make changes to this document
* or software at any time, without notice.
************************************************************

*Other names and brands may be claimed as the property of others

Copyright (c) Intel Corporation, 1998-2001