# == Schema Information
#
# Table name: metais.project_documents
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  value                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::ProjectDocument < ApplicationRecord
  self.table_name = "metais.project_documents"

  belongs_to :project_origin, class_name: 'Metais::ProjectOrigin'
  belongs_to :origin_type, class_name: 'Metais::OriginType'
end
