# == Schema Information
#
# Table name: metais.supplier_types
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::SupplierType < ApplicationRecord
end
