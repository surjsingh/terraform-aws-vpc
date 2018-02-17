require 'spec_helper'

describe vpc('myproduct-dev-vpc'), region: 'us-east-1' do
  it { should exist }
  it { should be_available }
end

describe internet_gateway('dev IGW'), region: 'us-east-1' do
  it { should exist }
  it { should be_attached_to('myproduct-dev-vpc') }
end


describe route_table('dev-public-route'), region: 'us-east-1'do
  it { should have_subnet('dev-public-us-east-1a') }
  it { should have_subnet('dev-public-us-east-1b') }
  it { should have_subnet('dev-public-us-east-1c') }
end

describe route_table('dev-private-route-us-east-1a'), region: 'us-east-1' do
  it { should have_subnet('dev-private-us-east-1a')}
end

describe route_table('dev-private-route-us-east-1b'), region: 'us-east-1' do
  it { should have_subnet('dev-private-us-east-1b')}
end

describe route_table('dev-private-route-us-east-1c'), region: 'us-east-1' do
  it { should have_subnet('dev-private-us-east-1c')}
end