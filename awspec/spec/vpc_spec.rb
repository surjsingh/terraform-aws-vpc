require 'spec_helper'

describe vpc('myproduct-dev-vpc') do
  it { should exist }
  it { should be_available }
end

describe internet_gateway('dev IGW') do
  it { should exist }
  it { should be_attached_to('myproduct-dev-vpc') }
end


describe route_table('dev-public-route') do
  it { should have_subnet('dev-public-us-east-1a') }
  it { should have_subnet('dev-public-us-east-1b') }
  it { should have_subnet('dev-public-us-east-1c') }
end

describe route_table('dev-private-route-us-east-1a') do
  it { should have_subnet('dev-private-us-east-1a')}
end

describe route_table('dev-private-route-us-east-1b') do
  it { should have_subnet('dev-private-us-east-1b')}
end

describe route_table('dev-private-route-us-east-1c') do
  it { should have_subnet('dev-private-us-east-1c')}
end