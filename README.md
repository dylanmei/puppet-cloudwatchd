## cloudwatchd puppet module

Install and manage [cloudwatchd](http://github.com/dylanmei/cloudwatchd), an AWS CloudWatch metric collection daemon.

## example

```

class { 'cloudwatchd':
  backends       => ['./backends/syslog'],
  interval       => 120,
  aws_region     => $aws_region,
  aws_access_key => $aws_access_key,
  aws_secret_key => $aws_secret_key,
  config => {
    'syslog' => '{
      "host": "${splunk_host}",
      "port": "${splunk_port}",
    }'
  },
  metrics => ['{
    "Namespace": "AWS/DynamoDB",
    "MetricName": "ConsumedReadCapacityUnits",
    "Statistic": "Sum",
    "Unit": "Count",
    "Dimensions": [{ "Name": "TableName", "Value": "myTableName" }]
  }', '{
    "Namespace": "AWS/EC2",
    "MetricName": "CPUUtilization",
    "Statistic": "Average",
    "Unit": "Percent",
    "Dimensions": [{ "Name": "AutoScalingGroupName", "Value": "my AutoScalingGroupName" }]
  }']
}

```

## notes

Tested on CentOS 6.
