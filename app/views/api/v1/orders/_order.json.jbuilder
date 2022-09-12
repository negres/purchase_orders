json.call(order, :id, :reference, :client_name, :address, :line_items, :status, :purchase_channel, :delivery_service)
json.total_value order.total_value.to_f
