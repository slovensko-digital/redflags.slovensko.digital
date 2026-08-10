class DatahubRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :"#{Rails.env}_datahub"
end
