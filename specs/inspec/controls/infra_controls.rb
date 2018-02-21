# encoding: utf-8
# copyright: 2018, Harmeet Singh, Surjeet Singh

title 'Testing Bastion host is up and has valid Unix file system in place'

# dummy test to identify /tmp as a directory on the Bastion host
describe file('/tmp') do
  it { should be_directory }
end

describe sshd_config do
  its('RSAAuthentication') { should_not eq 'no' }
end

describe command('echo $PATH') do
  its('stdout') { should include "/usr/local/bin:/bin:/usr/bin:/opt/aws/bin\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('uname -sm') do
  its('stdout') { should include "Linux x86_64" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end



# you add controls here
control 'tmp-folder-verifier' do            # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title 'Verify /tmp directory'             # A human-readable title
  desc 'This checks if the /tmp directory exists on the target machine'
  describe file('/tmp') do                  # The actual test
    it { should be_directory }
  end
end

# you add controls here
control 'etc-folder-verifier' do            # A unique ID for this control
  impact 0.9                                # The criticality, if this control fails.
  title 'Verify /etc directory'             # A human-readable title
  desc 'This checks if the /etc directory exists on the target machine'
  describe file('/etc') do                  # The actual test
    it { should be_directory }
  end
end
