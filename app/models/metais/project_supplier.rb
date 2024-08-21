# == Schema Information
#
# Table name: metais.project_suppliers
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  value                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::ProjectSupplier < ApplicationRecord
  self.table_name = "metais.project_suppliers"

  belongs_to :project_origin, class_name: 'Metais::ProjectOrigin'
  belongs_to :origin_type, class_name: 'Metais::OriginType'
  belongs_to :supplier_type, class_name: 'Metais::SupplierType'
end
