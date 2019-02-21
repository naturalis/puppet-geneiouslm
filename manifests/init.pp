# == Class: geneiouslm
#
class geneiouslm(
  $licenseServerPort = 27001,
  $vendorDaemonPort  = 49630,
  $LMinstaller       = 'GeneiousFloatingLicenseManager_linux64_2_1_2_with_jre.sh',
  $license           = 'XXXX-XXXX-XXXX-XXXX-XXXX',
  $geneiousdir       = '/opt/GeneiousFloatingLicenseManager',
  $chkcritical       = 0,
  $chkwarning        = 1
) {

  package { 'lsb': ensure => "installed" }
  package { 'wget': ensure => "installed" }
  package { 'cul': ensure => "installed" }
  package { 'unzip': ensure => "installed" }

  wget::fetch { 'geneiouslm_installer':
    source      => "https://assets.geneious.com/installers/licensingUtility/2_1_2/GeneiousFloatingLicenseManager_linux64_2_1_2_with_jre.sh",
    destination => "/opt/GeneiousFloatingLicenseManager_linux64_2_1_2_with_jre.sh",
    timeout     => 0,
    verbose     => false
  }
  
  file { 'install_answers':
    path           => '/opt/install_answers',
    source         => 'puppet:///modules/geneiouslm/install_answers',
    ensure         => 'present',
    mode           => '0644',
    #require        => File['/opt/geneious']
  }

  exec { 'install_geneiouslm':
    cwd            => '/opt',
    command        => '/opt/GeneiousFloatingLicenseManager_linux64_2_1_2_with_jre.sh < /opt/install_answers',
    unless         => "${geneiousdir}/floatingLicenseManager -check | grep -c '${license}'",
    #returns        => [0,1,2,14],
    require        => [File['geneious_installer'],File['install_answers'],Package['lsb']]
  }

  service { 'geneiouslm':
    ensure         => 'running',
    enable         => 'true',
    require        => [Exec['install geneious license'],File['geneious dir']]
  }

# create licencemanager check script for usage with monitoring tools ( sensu )
  file {'/usr/local/sbin/chklicense.sh':
    ensure         => 'file',
    mode           => '0777',
    content        => template('geneiouslm/chklicense.sh.erb')
  }

# export check so sensu monitoring can make use of it
  @sensu::check { 'Check Geneious License server status' :
    command        => '/usr/local/sbin/chklicense.sh',
    tag            => 'central_sensu',
  }

}
