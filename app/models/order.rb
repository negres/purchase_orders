# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  reference        :string
#  client_name      :string
#  address          :string
#  total_value      :decimal(, )
#  line_items       :jsonb            is an Array
#  status           :integer          default("ready")
#  purchase_channel :string
#  delivery_service :string
#  batch_id         :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Order < ApplicationRecord
  belongs_to :batch, optional: true

  validates :purchase_channel, :client_name, :address, :delivery_service, :total_value, :line_items, presence: { on: :create }

  enum status: { ready: 1, production: 2, closing: 3, sent: 4 }

  scope :by_client_name, ->(client_name) { where('lower(client_name) = ?', client_name.downcase) }
  scope :by_purchase_channel, ->(purchase_channel) { where('lower(purchase_channel) = ?', purchase_channel.downcase) }
  scope :by_reference, ->(reference) { where('lower(reference) = ?', reference.downcase) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_delivery_service, ->(delivery_service) { where('lower(delivery_service) = ?', delivery_service.downcase) }

  after_create :generate_reference

  def generate_reference
    self.reference = "ORDER-#{created_at.strftime('%d%m%Y')}-#{id}"
    save
  end
end
