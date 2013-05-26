require 'spec_helper'

describe TwYM::Channel::MessageChannel do
  let(:channel) { TwYM::Channel::MessageChannel.new }
  let(:message) {
    TwYM::Message::Post.new(nickname, text, image_url)
  }

  describe '#<<' do
    before do
      channel.qc_channels[:name].stub(:<<).with('test-nickname')
      channel.qc_channels[:line0].stub(:<<).with('test for echo')
      channel.qc_channels[:line1].stub(:<<).with(' ')
      channel.qc_channels[:line2].stub(:<<).with(' ')
      channel.qc_channels[:line3].stub(:<<).with(' ')
      channel.qc_channels[:line4].stub(:<<).with(' ')
      channel.qc_channels[:face].stub(:<<).with('http://example.com/test.png')
      channel.qc_channels[:display_sec].stub(:<<).with('10')
    end

    let(:nickname) { 'test-nickname' }
    let(:text) { 'test for echo' }
    let(:image_url) { 'http://example.com/test.png' }

    specify do
      channel << message
    end
  end
end
