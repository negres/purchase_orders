require 'rails_helper'

RSpec.describe 'financial_report API', type: :request do
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  describe 'GET /financial_report' do
    context 'get financial report' do
      before do
        get '/api/v1/financial_report', headers: headers
      end

      it 'does return status 200' do
        expect(response).to have_http_status :ok
      end
    end
  end
end
