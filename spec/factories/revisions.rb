FactoryGirl.define do
  factory :revision do
    page
    sequence(:version) { |n| n }
    title ''
    raw ''

    after :create do |r|
      r.page.update! latest_revision_id: r.id
    end
  end
end
