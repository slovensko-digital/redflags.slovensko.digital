# == Schema Information
#
# Table name: metais.project_origins
#
#  id              :integer          not null, primary key
#  project_id      :integer          not null
#  origin_type_id  :integer          not null
#
#  title           :string           not null
#  status          :string
#  description     :text
#  guarantor       :string
#  project_manager :string
#  start_date      :datetime
#  end_date        :datetime
#
#  source          :string
#  investment      :decimal(15,2)
#  operation       :decimal(15,2)
#
#  supplier        :string
#
#  targets_text    :text
#  events_text     :text
#  documents_text  :text
#  links_text      :text
#
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_metais_project_origins_on_project_id      (project_id)
#  index_metais_project_origins_on_origin_type_id  (origin_type_id)
#
# Foreign key constraints
#
#  fk_metais_project_origins_project_id       (project_id => metais.projects.id)
#  fk_metais_project_origins_origin_type_id   (origin_type_id => metais.origin_types.id)

class Metais::ProjectOrigin < ApplicationRecord
  self.table_name = "metais.project_origins"

  belongs_to :project, :class_name => 'Metais::Project'
  belongs_to :origin_type, :class_name => 'Metais::OriginType'

  has_many :documents, class_name: 'Metais::ProjectDocument', foreign_key: 'project_origin_id'
  has_many :suppliers, class_name: 'Metais::ProjectSupplier', foreign_key: 'project_origin_id'
  has_many :events, class_name: 'Metais::ProjectEvent', foreign_key: 'project_origin_id'
  has_many :links, class_name: 'Metais::ProjectLink', foreign_key: 'project_origin_id'
end
