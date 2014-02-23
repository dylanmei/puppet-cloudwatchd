class cloudwatchd(
  $ensure         = $cloudwatchd::params::ensure,
  $period         = $cloudwatchd::params::period,
  $config         = $cloudwatchd::params::config,
  $backends       = $cloudwatchd::params::backends,
  $aws_access_key = $cloudwatchd::params::aws_access_key,
  $aws_secret_key = $cloudwatchd::params::aws_secret_key,
  $aws_region     = $cloudwatchd::params::aws_region,
  $aws_metrics    = $cloudwatchd::params::aws_metrics,
  $max_retries    = $cloudwatchd::params::max_retries,
  $cloudwatchjs   = $cloudwatchd::params::cloudwatchjs,
  $init_script    = $cloudwatchd::params::init_script,
) inherits cloudwatchd::params {

  require nodejs

  package { 'cloudwatchd':
    ensure    => $ensure,
    provider  => 'npm',
    notify    => Service['cloudwatchd'],
  }

  $logfile    = '/var/log/cloudwatchd/cloudwatchd.log'
  $configfile = '/etc/cloudwatchd/localConfig.js'

  file { '/etc/cloudwatchd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  } ->

  file { $configfile:
    content => template('cloudwatchd/localConfig.js.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Service['cloudwatchd'],
  }

  file { '/etc/init.d/cloudwatchd':
    source  => $init_script,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service['cloudwatchd'],
  }

  file { '/etc/default/cloudwatchd':
    content => template('cloudwatchd/cloudwatchd-defaults.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service['cloudwatchd'],
  }

  file { '/var/log/cloudwatchd':
    ensure  => directory,
    owner   => 'nobody',
    group   => 'root',
    mode    => '0770',
  }

  file { '/usr/local/sbin/cloudwatchd':
    source  => 'puppet:///modules/cloudwatchd/cloudwatchd-wrapper.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service['cloudwatchd'],
  }

  service { 'cloudwatchd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    pattern   => 'node .*cloudwatchd.js',
    require   => File['/var/log/cloudwatchd'],
  }
}