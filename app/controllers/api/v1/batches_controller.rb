module Api::V1
  class BatchesController < ApplicationController
    def create
      orders = Order.where(id: batch_params[:order_ids], purchase_channel: batch_params[:purchase_channel], batch_id: nil)
      @batch = Batch.new(batch_params)

      if @batch.valid?
        @batch.save!
        orders&.update_all(batch_id: @batch.id, status: :production)

        render status: :created
      else
        render status: :bad_request, json: { errors: @batch.errors.messages }
      end
    end

    def index
      @batches = Batch.all.page(params[:page] || 1).per(10).order(id: :desc)

      render status: :ok
    end

    def show
      @batch = Batch.find(params[:id])

      render status: :ok
    end

    def produce
      orders_to_be_updated = Batch.find(params[:id]).orders.where(status: :production)
      orders_to_be_updated.update_all(status: :closing)

      render status: :no_content, json: {}
    end

    def close_by_delivery_service
      orders_to_be_updated = Batch.find(params[:id]).orders.by_delivery_service(params[:delivery_service]).where.not(status: :sent)
      orders_to_be_updated.update_all(status: :sent)

      render status: :no_content, json: {}
    end

    private

    def batch_params
      params.require(:batch).permit( :purchase_channel, order_ids: [])
    end
  end
end