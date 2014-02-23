## cloudwatchd puppet module

Install and manage [cloudwatchd](http://github.com/dylanmei/cloudwatchd), an AWS CloudWatch metric collection daemon.

## example

```

class { 'cloudwatchd':
  backends       => ['./backends/syslog'],
  period         => 60,
  config => {
    'syslog' => '{
      "host": "${splunk_host}",
      "port": "${splunk_port}",
    }'
  },
  aws_region     => $aws_region,
  aws_access_key => $aws_access_key,
  aws_secret_key => $aws_secret_key,
  aws_metrics => ['{
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
    "Dimensions": [{ "Name": "AutoScalingGroupName", "Value": "myAutoScalingGroupName" }]
  }']
}

```

The `aws_region` is required. The `config` map is optional. `aws_access_key` and `aws_secret_key` values are not required if the EC2 instance is configured with an instance-profile with permissions to read statistics from CloudWatch. `aws_metrics` is an array of strings that match the JSON *params* described in the [AWS CloudWatch JavaScript SDK](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudWatch.html#getMetricStatistics-property).

## notes

Tested on CentOS 6.
