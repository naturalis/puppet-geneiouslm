# == Class: geneiouslm
#
#
class geneiouslm(
  $licenseServerPort        = 27001,
  $vendorDaemonPort         = 49630,
  $LMinstaller              = 'GeneiousFloatingLicenseManager_linux64_2_0_5.sh',
  $license                  = 'XXXX-XXXX-XXXX-XXXX-XXXX'
)
{

  package { 'lsb':
    ensure          => "installed"
  }

  package { 'openjdk-7-jre':
    ensure          => "installed"
  }

  file { "/opt/geneious":
    ensure         => 'directory',
    mode           => '0755'
  }

  file { 'geneious-installer':
    path           => "/opt/geneious/geneious-installer.sh",
    source         => "puppet:///modules/geneiouslm/${LMinstaller}",
    ensure         => "present",
    mode           => '0755',
    require        => File['/opt/geneious']
  }
  
  file { 'install-answers':
    path           => "/opt/geneious/install-answers",
    source         => "puppet:///modules/geneiouslm/install-answers",
    ensure         => "present",
    mode           => '0644',
    require        => File['/opt/geneious']
  }

  exec { 'install geneious':
    cwd            => "/opt/geneious",
    command        => "/opt/geneious/geneious-installer.sh < /opt/geneious/install-answers",
    unless         => "/usr/bin/test -d /opt/GeneiousFloatingLicenseManager",
    returns        => [0,1,2,14],
    require        => [File['geneious-installer'],File['install-answers'],Package['lsb'],Package['openjdk-7-jre']],
  }

  file { 'geneious dir':
    path           => "/opt/GeneiousFloatingLicenseManager",
    ensure         => "present",
    mode           => '0777',
    require        => Exec['install geneious']
  }

  
  exec { 'install geneious service':
    command        => "/opt/GeneiousFloatingLicenseManager/linux64/InstallService.sh",
    unless         => "/usr/bin/test -f /etc/init.d/geneiouslm",
    require        => Exec['install geneious']
  }

  exec { 'check geneious':
    command        => "/opt/GeneiousFloatingLicenseManager/floatingLicenseManager -check",
    unless         => "/opt/GeneiousFloatingLicenseManager/floatingLicenseManager -check | grep -c '${license}'",
    require        => Exec['install geneious']
  }->
  exec { 'activate geneious':
    command        => "/opt/GeneiousFloatingLicenseManager/floatingLicenseManager -activate -activationID ${license}",
    unless         => "/opt/GeneiousFloatingLicenseManager/floatingLicenseManager -check | grep -c '${license}'",
  }->
  exec { 'install geneious license':
    command        => "/opt/GeneiousFloatingLicenseManager/floatingLicenseManager -install -licenseServerPort ${licenseServerPort} -vendorDaemonPort ${vendorDaemonPort} -activationID ${license}",
    unless         => "/usr/bin/test -f /opt/GeneiousFloatingLicenseManager/geneious.lic",
    require        => File['geneious dir']
  }


  service { 'geneiouslm':
    ensure         => "running",
    enable         => "true",
    require        => [Exec['install geneious license'],File['geneious dir']]
  }
}
