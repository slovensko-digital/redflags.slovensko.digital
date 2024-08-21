# == Schema Information
#
# Table name: combined_projects
#
#  id                    :integer          not null, primary key
#  metais_project_id     :integer          not null
#  evaluation_id         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class CombinedProject < ApplicationRecord
  belongs_to :metais_project, class_name: 'Metais::Project', foreign_key: 'metais_project_id'
  belongs_to :evaluation, class_name: 'Project', foreign_key: 'evaluation_id', optional: true
end
