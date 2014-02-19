class cloudwatchd::params {
  $ensure   = 'present'
  $interval = 60
  $config   = {}
  $backends = ['./backends/syslog']
  $aws_access_key = ''
  $aws_secret_key = ''
  $aws_region     = ''
  $aws_metrics    = []

  case $::osfamily {
    'RedHat': {
      $init_script = 'puppet:///modules/cloudwatchd/cloudwatchd-init.sh'
      $cloudwatchjs = '/usr/lib/node_modules/cloudwatchd/cloudwatch.js'
    }
    default: {
      fail('Unsupported OS Family')
    }
  }
}
