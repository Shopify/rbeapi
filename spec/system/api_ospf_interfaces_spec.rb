require 'spec_helper'

require 'rbeapi/client'
require 'rbeapi/api/ospf'

describe Rbeapi::Api::OspfInterfaces do
  subject { described_class.new(node) }

  let(:config) { Rbeapi::Client::Config.new(filename: get_fixture('dut.conf')) }
  let(:node) { Rbeapi::Client.connect_to('dut') }

  describe '#get' do
    before do
      node.config(['default interface Ethernet1', 'interface Ethernet1',
                   'no switchport', 'ip address 88.99.99.99/24', 'exit',
                   'default interface Ethernet2'])
    end

    it 'returns an ospf interface resource instance' do
      expect(subject.get('Ethernet1')).not_to be_nil
    end

    it 'returns nil for a switchport interface' do
      expect(subject.get('Ethernet2')).to be_nil
    end
  end

  describe '#getall' do
    before do
      node.config(['default interface Ethernet1', 'interface Ethernet1',
                   'no switchport', 'ip address 88.99.99.99/24', 'exit',
                   'default interface Ethernet2'])
    end

    it 'returns the ospf resource collection' do
      expect(subject.getall).to be_a_kind_of(Hash)
    end

    it 'includes an instance of Ethernet1' do
      expect(subject.getall).to include('Ethernet1')
    end

    it 'does not include an instance of Ethernet2' do
      expect(subject.getall).not_to include('Ethernet2')
    end
  end

  describe '#set_network_type' do
    before do
      node.config(['default interface Ethernet1', 'interface Ethernet1',
                   'no switchport', 'ip address 88.99.99.99/24', 'exit'])
    end

    it 'configures the ospf interface type to point-to-point' do
      expect(subject.get('Ethernet1')['network_type']).to eq('broadcast')
      expect(subject.set_network_type('Ethernet1', value: 'point-to-point'))
        .to be_truthy
      expect(subject.get('Ethernet1')['network_type']).to eq('point-to-point')
    end

    it 'negates the ospf interface type' do
      expect(subject.set_network_type('Ethernet1', value: 'point-to-point'))
        .to be_truthy
      expect(subject.get('Ethernet1')['network_type']).to eq('point-to-point')
      expect(subject.set_network_type('Ethernet1', enable: false)).to be_truthy
      expect(subject.get('Ethernet1')['network_type']).to eq('broadcast')
    end

    it 'defaults the ospf interface type' do
      expect(subject.set_network_type('Ethernet1', value: 'point-to-point'))
        .to be_truthy
      expect(subject.get('Ethernet1')['network_type']).to eq('point-to-point')
      expect(subject.set_network_type('Ethernet1', default: true)).to be_truthy
      expect(subject.get('Ethernet1')['network_type']).to eq('broadcast')
    end
  end
end
