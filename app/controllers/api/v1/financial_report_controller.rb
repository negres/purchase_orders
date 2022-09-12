module Api::V1
  class FinancialReportController < ApplicationController
    def index
      @orders = Order.all
      @purchase_channels = @orders.pluck(:purchase_channel).uniq

      render status: :ok
    end
  end
end
