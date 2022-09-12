json.array! @purchase_channels do |puchase_channel|
  json.puchase_channel puchase_channel
  json.orders_total_count @orders.by_purchase_channel(puchase_channel).count
  json.orders_total_value @orders.by_purchase_channel(puchase_channel).sum(:total_value).to_f
end
