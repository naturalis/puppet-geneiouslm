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

```


Classes
-------------
geneiouslm


Dependencies
-------------


Result
-------------
Working license server for geneious.


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 14.04LTS 


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>