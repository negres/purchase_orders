require 'rails_helper'

RSpec.describe Batch, type: :model do
  context 'create batch' do
    let(:order) { create(:order) }
    let(:batch) { create(:batch, order_ids: [order.id]) }

    it 'does generate reference' do
      expect(batch.reference).not_to be nil
    end
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:purchase_channel) }
  end
end
