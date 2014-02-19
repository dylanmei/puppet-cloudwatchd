require 'spec_helper'

describe 'cloudwatchd' do

  let(:facts) {{
    :kernel => 'Linux',
    :operatingsystem => 'CentOS',
    :operatingsystemrelease => '6.2',
    :osfamily => 'RedHat',
    :architecture => 'x86_64'
  }}

  it {
    should contain_service('cloudwatchd').with_ensure('running')
  }

end