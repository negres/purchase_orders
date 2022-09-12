module Api::V1
  class OrdersController < ApplicationController
    has_scope :by_client_name
    has_scope :by_purchase_channel
    has_scope :by_reference
    has_scope :by_status

    def create
      order = Order.new(order_params)

      if order.valid?
        order.save!

        render status: :created, json: { id: order.id }
      else
        render status: :bad_request
      end
    end

    def index
      @orders = apply_scopes(Order).all.page(params[:page] || 1).per(10).order(id: :desc)

      render status: :ok
    end

    def show
      @order = Order.find(params[:id])

      render status: :ok
    end

    private

    def order_params
      permitted_params = params.require(:order).permit(:client_name, :address, :purchase_channel, :delivery_service, :total_value, :line_items)
      permitted_params[:line_items] = params[:order][:line_items].to_a
      permitted_params.permit!
    end
  end
end