class ProjectsController < ApplicationController
  def show
    @project = OpenStruct.new(
      title: 'IS Obchodného registra',
      full_name: 'Informačný systém Obchodného registra (IS OR)',
      guarantor: 'Ministerstvo spravodlivosti SR',
      description: 'Implementovanť nový IS pre správu Obchodného registra a súvisiace opatrenia na zafektívnenie jeho procesov.',
      budget: '13 250 000 EUR (s DPH, podľa vyzvania na národný projekt)',
      status: 'Výzva na národný projekt v OPII',
      created_at: 2.weeks.ago,
      updated_at: 3.days.ago,
      editor_name: 'Ľubor Illek',
      editor_url: 'https://platforma.slovensko.digital/u/Lubor',
      editor_avatar_url: 'https://platforma.slovensko.digital/letter_avatar_proxy/v2/letter/l/96bed5/64.png',
      discourse_url: 'https://platforma.slovensko.digital/t/red-flags-is-obchodneho-registra/4228',
      permalink_url: 'http://localhost:3000/projekty/1',

      rankings: [
        OpenStruct.new(
          phase: 1,
          score: 4,
          name: 'Reforma VS',
          html: '<p>Projekt deklaruje optimalizáciu procesov priamo súvisiacich s Obchodným registrom. Konkrétne bola identifikovaná zmena v rozsahu subjektov ktoré môžu zapísať spoločnosť do OR.</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 3,
          name: 'Merateľné ciele (KPI)',
          html: '<p>Nejaké hodnotenie</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 2,
          name: 'Postup dosiahnutia cieľov',
          html: '<p>Nejaké hodnotenie</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 3,
          name: 'Súlad s KRIS',
          html: '<p>Nejaké hodnotenie</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 3,
          name: 'Biznis prínos',
          html: '<p>Nejaké hodnotenie</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: nil,
          name: 'Príspevok v informatizácii',
          html: nil
        ),

      ]
    )
    @ranking_phases = ['I. Prípravná fáza', 'II. Obstarávanie / nákup', 'III. Realizácia', 'IV. Produkt', 'V. Prevádzka']
  end
end
