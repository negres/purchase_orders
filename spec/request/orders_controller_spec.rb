require 'rails_helper'

RSpec.describe 'orders API', type: :request do
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  describe 'POST /orders' do
    context 'success' do
      let(:body) do
        {
          order: {
            client_name: 'Test Name',
            address: '282 Kevin Brook, Imogeneborough, CA 58517',
            total_value: 100,
            line_items: [{ "sku": "case-my-best-friend", "model": "iPhone X", "case type": "Rose Leather" }],
            purchase_channel: 'Site BR',
            delivery_service: 'Sedex'
          }
        }
      end

      before do
        post '/api/v1/orders', headers: headers, params: body.to_json
      end

      it 'does return status 201' do
        expect(response).to have_http_status :created
      end

      it 'does create a order' do
        expect(Order.all.count).to be 1
      end
    end
  end

  describe 'GET /orders' do
    context 'get all orders' do
      before do
        get '/api/v1/orders', headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /orders/:id' do
    context 'get an order' do
      let(:order) { create(:order) }

      before do
        get "/api/v1/orders/#{order.id}", headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :ok
      end
    end
  end
end