require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'create order' do
    let(:order) { create(:order) }

    it 'does generate reference' do
      expect(order.reference).not_to be nil
    end
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:purchase_channel) }
    it { is_expected.to validate_presence_of(:client_name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:delivery_service) }
    it { is_expected.to validate_presence_of(:total_value) }
    it { is_expected.to validate_presence_of(:line_items) }
  end
end
