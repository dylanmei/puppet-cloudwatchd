include epel

file { '/etc/facter':
  ensure => directory,
} ->
file { '/etc/facter/facts.d':
  ensure => directory,
} ->
file { '/etc/facter/facts.d/cloudwatch.json':
  content => "{
      \"syslog_host\": \"${syslog_host}\"
    , \"syslog_port\": \"${syslog_port}\"
  }"
}

file { '/etc/sysconfig/cloudwatchd':
  content => "export SYSLOG_HOST=`facter syslog_host`\nexport SYSLOG_PORT=`facter syslog_port`\n"
}

class { 'nodejs': } ->
class { 'cloudwatchd':
  backends       => ['./backends/syslog'],
  require        => [
    File['/etc/sysconfig/cloudwatchd'],
  ],
  interval       => 60,
  aws_region     => 'us-west-2',
  aws_access_key => $aws_access_key,
  aws_secret_key => $aws_secret_key,
  config => {
    'syslog' => '{
      "host": process.env.SYSLOG_HOST,
      "port": process.env.SYSLOG_PORT,
    }'
  },
  metrics => ['{
    "Namespace": "AWS/DynamoDB",
    "MetricName": "ConsumedReadCapacityUnits",
    "Statistic": "Sum",
    "Unit": "Count",
    "Dimensions": [{ "Name": "TableName", "Value": "blah" }]
  }', '{
    "Namespace": "AWS/EC2",
    "MetricName": "CPUUtilization",
    "Statistic": "Average",
    "Unit": "Percent",
    "Dimensions": [{ "Name": "AutoScalingGroupName", "Value": "blah" }]
  }']
}
