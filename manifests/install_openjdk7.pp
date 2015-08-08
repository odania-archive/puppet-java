class java::install_openjdk7 {
  include java::home

  package { 'java-jdk':
    ensure => latest,
    name => 'openjdk-7-jdk',
  }
}
