    # == Schema Information
    #
    # Table name: phases
    #
    #  id              :integer          not null, primary key
    #  created_at      :datetime         not null
    #  updated_at      :datetime         not null
    #

    class Phase < ApplicationRecord
      belongs_to :project
      belongs_to :phase_type

      has_many :pages
      has_many :revisions, class_name: 'PhaseRevision'

      has_one :published_revision, -> { where(published: true) }, class_name: 'PhaseRevision'

      def phase_type_label
        case phase_type.name
        when "Prípravná fáza"
          "Hodnotenie prípravy"
        when "Fáza produkt"
          "Hodnotenie produktu"
        else
          phase_type
        end
      end
    end
