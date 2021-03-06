# == Class: mackerel_agent
#
# This class install and configure mackerel-agent
#
# === Parameters
#
# [*ensure*]
#   Passed to the mackerel_agent
#   Defaults to present
#
# [*apikey*]
#   Your mackerel API key
#   Defaults to undefined
#
# [*service_ensure*]
#   Whether you want to mackerel-agent daemon to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to mackerel-agent daemon to start up at boot
#   Defaults to true
#
# === Examples
#
#  class { 'mackerel_agent':
#    apikey => 'Your API Key'
#  }
#
# === Authors
#
# Tomohiro TAIRA <tomohiro.t@gmail.com>
#
# === Copyright
#
# Copyright 2014 Tomohiro TAIRA
#
class mackerel_agent(
  $ensure         = present,
  $apikey         = undef,
  $service_ensure = running,
  $service_enable = true
) {
  validate_re($::osfamily, '^(RedHat)$', 'This module only works on Red Hat based systems.')
  validate_string($apikey)
  validate_bool($service_enable)

  if $apikey == undef {
    crit('apikey must be specified in the class paramerter.')
  } else {
    class { 'mackerel_agent::install':
      ensure => $ensure
    }

    class { 'mackerel_agent::config':
      apikey  => $apikey,
      require => Class['mackerel_agent::install']
    }

    class { 'mackerel_agent::service':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Class['mackerel_agent::config']
    }
  }
}
