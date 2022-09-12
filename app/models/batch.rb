# == Schema Information
#
# Table name: batches
#
#  id               :bigint           not null, primary key
#  reference        :string
#  purchase_channel :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Batch < ApplicationRecord
  has_many :orders, class_name: 'Order'

  validate :duplicated_orders?, on: :create
  validate :orders_have_same_purchase_channel?, on: :create
  validates :reference, uniqueness: true
  validates :purchase_channel, :order_ids, presence: true

  after_create :generate_reference

  def self.create_batch(params, orders)
    batch = Batch.create!(
      purchase_channel: params[:purchase_channel]
    )

    batch.save!
    orders.update_all(batch_id: batch.id, status: :production)

    batch
  end

  def generate_reference
    self.reference = "BATCH-#{created_at.strftime('%d%m%Y')}-#{id}"
    save
  end

  def orders_have_same_purchase_channel?
    orders = Order.where(id: self.order_ids)
    orders.each do |order|
      if order.purchase_channel != self.purchase_channel
        errors.add :orders, 'The order must have the same purchase channel'
      end
    end
  end

  def duplicated_orders?
    duplicated_orders = Order.where(id: self.order_ids).where.not(batch_id: nil)
    errors.add :orders, 'One or more orders are already placed in a batch' unless duplicated_orders.empty?
  end
end
