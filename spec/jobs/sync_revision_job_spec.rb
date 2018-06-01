require 'rails_helper'

RSpec.describe SyncRevisionJob, type: :job do
  before(:example) do
    p = create(:rating_phase, name: 'I. Prípravná fáza')
    create(:rating_type, name: 'Reforma VS', rating_phase: p)
    create(:rating_type, name: 'Participácia na príprave projektu', rating_phase: p)
    create(:rating_type, name: 'Biznis prínos', rating_phase: p)
    create(:project_stage, name: 'Výzva na národný projekt v OPII')
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
      stage: ProjectStage.find_by!(name: 'Výzva na národný projekt v OPII'),
      summary: 'Najvýraznejším nedostatkom projektu EDUNET je nedostatočná príprava projektu, chýbajúce zhodnotenie alternatív a ekonomické zhodnotenie rôznych modelov nákupu a budovania školskej siete. Projekt je nastavený tak, že na trhu s viac ako 300 dodávateľmi sa obstarávania zúčastnili len štyria. Ministerstvo taktiež odmieta odbornú diskusiu k projektu, čo výrazne zvyšuje obavu o jeho kvalitu.',
      recommendation: 'Odporúčame projekt pozastaviť a dôkladne zanalyzovať rôzne alternatívy budovania siete aj s ohľadom na podmienky na telekomunikačnom trhu.'
    )

    ratings = snapshot.ratings.index_by { |r| r.rating_type.name }

    expect(ratings['Reforma VS'].score).to eq(2)
    expect(ratings['Participácia na príprave projektu'].score).to eq(4)
    expect(ratings['Biznis prínos'].score).to eq(0)
  end

  it 'ignores pages from unknown category' do
    revision = create(:revision)
    revision.raw['category_id'] = 123
    revision.save!

    subject.perform(revision)

    expect(ProjectRevision.count).to eq(0)
  end

  it 'adds calculated total and max score to revision' do
    revision = create(:revision)

    subject.perform(revision)

    snapshot = ProjectRevision.first

    expect(snapshot.total_score).to eq(6)
    expect(snapshot.maximum_score).to eq(12)
  end
end
