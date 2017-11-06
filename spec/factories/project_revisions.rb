# == Schema Information
#
# Table name: project_revisions
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  revision_id   :integer          not null
#  title         :string           not null
#  full_name     :string
#  guarantor     :string
#  description   :string
#  budget        :string
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  body_html     :string
#  total_score   :integer
#  maximum_score :integer
#
# Indexes
#
#  index_project_revisions_on_project_id   (project_id)
#  index_project_revisions_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (revision_id => revisions.id)
#

FactoryBot.define do
  factory :project_revision do
    project
    revision

    title 'Red Flags: IS Obchodného registra'
    full_name 'Národný projekt IS Obchodného registra'
    guarantor ''
    description ''
    budget ''
    status ''
    body_html { revision.body_html }
    total_score 75
    maximum_score 100
  end
end
