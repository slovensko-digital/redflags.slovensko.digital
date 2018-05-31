# == Schema Information
#
# Table name: project_stages
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectStage < ApplicationRecord
  def to_s
    name
  end
end
