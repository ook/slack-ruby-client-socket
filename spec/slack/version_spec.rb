require 'spec_helper'

RSpec.describe Slack do
  it 'has a version' do
    expect(Slack::VERSION).not_to be_nil
  end
end
