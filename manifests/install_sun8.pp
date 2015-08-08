class java::install_sun8 {
  include apt
  include java::home

  exec { 'auto_accept_license':
    command => 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections',
    before  => Package['oracle-java8-installer'],
  }

  case $::operatingsystem {
    debian: {
      apt::source { 'debian_oraclejdk8':
        location          => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
        release           => 'trusty',
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => 'EEA14886',
        key_server        => 'keyserver.ubuntu.com',
        include_src       => true,
        before            => Package['oracle-java8-installer'],
      }
    }
    ubuntu: { apt::ppa { 'ppa:webupd8team/java': before => Package['oracle-java8-installer'] } }
    default: { fail('Installation only supported for Ubuntu or Debian') }
  }

# start the Oracle JDK8 installer (needs internet connection)
  package { 'java-jdk':
    ensure => latest,
    name   => 'oracle-java8-installer',
  }

# execute smoke tests after the installation
  exec { 'smoketest_java':
    command => 'java -version 2>&1 | grep 1.8',
    returns => 0,
    require => Package['oracle-java8-installer'],
  }
  exec { 'smoketest_javac':
    command => 'javac -version 2>&1 | grep 1.8',
    returns => 0,
    require => Package['oracle-java8-installer'],
  }

  package { 'oracle-java8-set-default':
    ensure  => installed,
    require => Package['oracle-java8-installer'],
  }
}
