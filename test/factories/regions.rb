FactoryGirl.define do
  factory :region, class: 'ESP::Region' do
    skip_create

    sequence(:id) { |n| n }
    type "services"
    code "us_east_test_1"
  end
end
