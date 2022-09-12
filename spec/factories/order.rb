FactoryBot.define do
  factory :order do
    client_name { Faker::Name.unique.name }
    address { Faker::Address.full_address }
    total_value { 100 }
    line_items { [{ "sku": "case-my-best-friend", "model": "iPhone X", "case type": "Rose Leather" }] }
    purchase_channel { 'Site BR' }
    delivery_service { 'Sedex' }
  end
end
