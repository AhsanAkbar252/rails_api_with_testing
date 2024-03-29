require 'rails_helper'

RSpec.describe UpdateSkuJob, type: :job do
  it 'calls sku service with correct params' do
    allow(Net::HTTP).to receive(:start).and_return(true)
    described_class.perform_now('ruby')
  end
end
