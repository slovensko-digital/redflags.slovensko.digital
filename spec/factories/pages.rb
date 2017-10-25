FactoryGirl.define do
  factory :page do
    after :create do |p|
      create :revision, page: p
    end

    trait :published do
      after :create do |p|
        p.update! published_revision_id: p.revisions.first.id
      end
    end

    trait :unpublished do
      published_revision_id nil
    end

    trait :synced do
      after :create do |p|
        p.update! published_revision_id: p.latest_revision.id
      end
    end

    trait :unsynced do
      after :create do |p|
        create :revision, page: p if p.published?
      end
    end
  end
end
