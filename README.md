puppet-geneiouslm
==================

Puppet module for geneious licensemanager. 

Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by hiera or The foreman
place LMinstaller binary in the files directory.

```
  $licenseServerPort        = 27001,
  $vendorDaemonPort         = 49630,
  $LMinstaller              = 'GeneiousFloatingLicenseManager_linux64_2_0_5.sh',
  $license                  = '<licensenumber>'
  $geneiousdir              = '/opt/GeneiousFloatingLicenseManager'
  $chkcritical              = 0,  # return critical (errorlevel 2) on test script then less than x licenses free
  $chkwarning               = 1,  # return warning (errorlevel 1) on test script then less than x licenses free

```


Classes
-------------
geneiouslm


Dependencies
-------------


Result
-------------
Working license server for geneious.
includes license test script in /usr/local/sbin/chklicense.sh which returns status on condition of licenseserver using lmstat. 
This test script is usable for sensu montoring checks and will be included in monitoring when role_sensu::client is running on the client. (https://github.com/naturalis/puppet-role_sensu) 

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 14.04LTS 


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>