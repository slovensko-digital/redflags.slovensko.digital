# == Schema Information
#
# Table name: pages
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  latest_revision_id    :integer
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

FactoryBot.define do
  factory :page do
    after :create do |p|
      create :revision, page: p
    end

    trait :published do
      after :create do |p|
        p.update! published_revision: p.revisions.first
      end
    end

    trait :unpublished do
      published_revision { nil }
    end

    trait :synced do
      after :create do |p|
        p.update! published_revision: p.latest_revision
      end
    end

    trait :unsynced do
      after :create do |p|
        create :revision, page: p if p.published?
      end
    end

    association :project, factory: :project
  end
end
