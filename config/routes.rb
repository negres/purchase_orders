Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :orders, only: %i[create index show]

        resources :batches, only: %i[create index show] do
          member do
            patch 'close_by_delivery_service', action: 'close_by_delivery_service'
            patch 'produce', action: 'produce'
            get 'orders', action: 'orders'
          end
        end

        resources :financial_report, only: %i[index]
      end
    end
  end
end
