require 'rails_helper'

RSpec.describe SyncRevisionJob, type: :job do
  before(:example) do
    create(:rating_type, name: 'Reforma VS')
    create(:rating_type, name: 'Participácia na príprave projektu')
    create(:rating_type, name: 'Biznis prínos')
    create(:project_stage, name: 'Výzva na národný projekt v OPII')
  end

  it 'parses project metadata from revision' do
    project = create(:project)
    page = create(:page, project: project)
    revision = create(:revision, page: page)

    subject.perform(revision)

    snapshot = ProjectRevision.first

    expect(snapshot).to have_attributes(
      title: 'IS Obchodného registra',
      full_name: 'Informačný systém Obchodného registra (IS OR)',
      guarantor: 'Ministerstvo spravodlivosti SR',
      description: 'Implementovanť nový IS pre správu Obchodného registra a súvisiace opatrenia na zafektívnenie jeho procesov.',
      budget: '13 250 000 EUR (s DPH, podľa vyzvania na národný projekt)',
      stage: ProjectStage.find_by!(name: 'Výzva na národný projekt v OPII'),
      current_status: "<ul>\n<li>Nie sú známe žiadne plánované aktivity</li>\n<li>Ani v ďalšej odrážke nie sú aktivity</li>\n</ul>\n",
      summary: 'Najvýraznejším nedostatkom projektu EDUNET je nedostatočná príprava projektu, chýbajúce zhodnotenie alternatív a ekonomické zhodnotenie rôznych modelov nákupu a budovania školskej siete. Projekt je nastavený tak, že na trhu s viac ako 300 dodávateľmi sa obstarávania zúčastnili len štyria. Ministerstvo taktiež odmieta odbornú diskusiu k projektu, čo výrazne zvyšuje obavu o jeho kvalitu.',
      recommendation: 'Odporúčame projekt pozastaviť a dôkladne zanalyzovať rôzne alternatívy budovania siete aj s ohľadom na podmienky na telekomunikačnom trhu.'
    )

    ratings = snapshot.ratings.index_by { |r| r.rating_type.name }

    expect(ratings['Reforma VS'].score).to eq(2)
    expect(ratings['Participácia na príprave projektu'].score).to eq(4)
    expect(ratings['Biznis prínos'].score).to eq(0)
  end

  it 'adds calculated total and max score to revision' do
    project = create(:project)
    page = create(:page, project: project)
    revision = create(:revision, page: page)

    subject.perform(revision)

    snapshot = ProjectRevision.first

    expect(snapshot.revision.total_score).to eq(6)
    expect(snapshot.revision.maximum_score).to eq(12)
  end
end
