require 'rails_helper'

RSpec.describe SyncRevisionJob, type: :job do
  before(:example) do
    p = create(:rating_phase, name: 'I. Prípravná fáza')
    create(:rating_type, name: 'Reforma VS', rating_phase: p)
    create(:rating_type, name: 'Participácia na príprave projektu', rating_phase: p)
  end

  it 'parses project metadata from revision' do
    revision = create(:revision)

    subject.perform(revision)

    snapshot = ProjectRevision.first

    expect(snapshot).to have_attributes(
      title: 'IS Obchodného registra',
      full_name: 'Informačný systém Obchodného registra (IS OR)',
      guarantor: 'Ministerstvo spravodlivosti SR',
      description: 'Implementovanť nový IS pre správu Obchodného registra a súvisiace opatrenia na zafektívnenie jeho procesov.',
      budget: '13 250 000 EUR (s DPH, podľa vyzvania na národný projekt)',
      status: 'Výzva na národný projekt v OPII'
    )

    ratings = snapshot.ratings.index_by { |r| r.rating_type.name }

    expect(ratings['Reforma VS'].score).to eq(2)
    expect(ratings['Participácia na príprave projektu'].score).to eq(4)
  end

  it 'ignores pages from unknown category' do
    revision = create(:revision)
    revision.raw['category_id'] = 123
    revision.save!

    subject.perform(revision)

    expect(ProjectRevision.count).to eq(0)
  end
end
