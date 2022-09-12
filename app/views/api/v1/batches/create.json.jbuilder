json.partial! 'batch', batch: @batch
json.total_orders  @batch.orders.count
