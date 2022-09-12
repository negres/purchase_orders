json.batches do
  json.array! @batches do |batch|
    json.partial! 'batch', batch: batch
    json.orders do
      json.array! batch.orders do |order|
        json.partial! 'api/v1/orders/order', order: order
      end
    end
  end
end
