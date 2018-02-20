require 'spec_helper'

describe iam_policy('bastionbox-instance-policy') do
  it { should exist }
end

describe iam_role('bastionbox-instance-role') do
  it { should exist }
  it { should have_iam_policy('bastionbox-instance-policy') }
  it { should be_allowed_action('ec2:AssociateAddress') }
  it { should be_allowed_action('ec2:DescribeAddresses') }
  it { should be_allowed_action('ec2:AllocateAddress') }
  it { should be_allowed_action('ec2:EIPAssociation') }
  it { should be_allowed_action('ec2:DisassociateAddress') }
end


describe iam_policy('serviceOne-instance-policy') do
  it { should exist }
end

describe iam_role('serviceOne-instance-role') do
  it { should exist }
  it { should have_iam_policy('serviceOne-instance-policy') }
  it { should be_allowed_action('s3:ListBucket') }
end

