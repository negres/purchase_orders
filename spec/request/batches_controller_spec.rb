require 'rails_helper'

RSpec.describe 'batches API', type: :request do
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  describe 'POST /batches' do
    context 'success' do
      let(:order) { create(:order) }

      let(:body) do
        {
          batch: {
            purchase_channel: 'Site BR',
            order_ids: [order.id]
          }
        }
      end

      before do
        post '/api/v1/batches', headers: headers, params: body.to_json
      end

      it 'does return status 201' do
        expect(response).to have_http_status :created
      end

      it 'does create a batch' do
        expect(Batch.all.count).to be 1
      end

      it 'does update batch_id on batch orders' do
        expect(Batch.last.orders.count).to be 1
      end
    end
  end

  describe 'GET /batches' do
    context 'get all batches' do
      before do
        get '/api/v1/batches', headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /batches/:id' do
    context 'get an batch' do
      let(:order) { create(:order) }
      let(:batch) { create(:batch, order_ids: [order.id]) }

      before do
        get "/api/v1/batches/#{batch.id}", headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'PATCH /batches/:id/produce' do
    context 'pass a batch from production to closing' do
      let(:order) { create(:order, status: :production) }
      let(:batch) { create(:batch, order_ids: [order.id]) }

      before do
        patch "/api/v1/batches/#{batch.id}/produce", headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :no_content
      end

      it 'does update batch orders status to closing' do
        expect(batch.orders.reload.pluck(:status).uniq).to eq ["closing"]
      end
    end
  end

  describe 'PATCH /batches/:id/close_by_delivery_service' do
    context 'those batch orders should be marked as sent' do
      let(:order) { create(:order, status: :sent, delivery_service: 'Sedex') }
      let(:batch) { create(:batch, order_ids: [order.id]) }

      before do
        patch "/api/v1/batches/#{batch.id}/close_by_delivery_service?delivery_service=Sedex", headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :no_content
      end

      it 'does update batch orders status to sent' do
        expect(batch.orders.reload.pluck(:status).uniq).to eq ["sent"]
      end
    end
  end
end
