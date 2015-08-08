class java::home {
  exec { 'Set JAVA_HOME':
    command => '/bin/echo JAVA_HOME="$(jrunscript -e \'java.lang.System.out.println(java.lang.System.getProperty("java.home"));\')" >> /etc/environment',
    unless  => '/bin/grep JAVA_HOME /etc/environment',
    require => Package['java-jdk'],
  }
}
