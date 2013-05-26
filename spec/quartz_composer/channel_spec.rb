require 'spec_helper'

describe QuartzComposer::Channel do
  let(:channel) { QuartzComposer::Channel.new(50999) }
  let(:socket) { double(:socket) }

  before do
    channel.stub(:create_socket).and_return(socket)
  end

  describe ".new" do
    it { expect(channel.port).to eq 50999 }
    it { expect(channel.address).to eq '225.0.0.0' }
  end

  describe '<<' do
    before do
      socket.should_receive(:send).with('test'.encode('UTF-32BE'), 0)
    end

    specify { channel << 'test' }
  end
end
