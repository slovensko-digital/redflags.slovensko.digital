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
          score: 2,
          name: 'Reforma VS',
          html: '<p>Projekt deklaruje optimalizáciu procesov priamo súvisiacich s Obchodným registrom.<br>
    Konkrétne bola identifikovaná zmena v rozsahu subjektov ktoré môžu zapísať spoločnosť do OR.</p>
<p>Projekt nerieši komplexne životné situácie súvisiace s podnikaním.<br>
    Napr. celkový priemerný čas na založenie obchodnej spoločnosti je 45 dní (viď. RZ kap. 1). Tento projekt nerieši
    situáciu komplexne, ale iba časť týkajúcu sa zapísania do OR - z 2 dní na “obratom”. Aj v prípade uskutočnenia
    cieľov projektu sa výsledný celkový čas teda zlepší najviac o 5%.</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 3,
          name: 'Merateľné ciele (KPI)',
          html: '<p>Podľa Reformného zámeru:</p>
<p>
<div class="lightbox-wrapper">
    <a href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/9/9d20430e2999f9b8b4213e379807a55c882df401.PNG"
       class="lightbox" title="Capture.PNG">
        <img src="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/optimized/2X/9/9d20430e2999f9b8b4213e379807a55c882df401_1_690x311.PNG"
             alt="Capture" width="690" height="311">
        <div class="meta">
            <span class="filename">Capture.PNG</span>
            <span class="informations">757x342 47.5 KB</span>
            <span class="expand"/>
        </div>
    </a>
</div>
<br>
<div class="lightbox-wrapper">
    <a href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/2/2f03dd98d3c8fdd5ad13f26a7a1d56811b9dc2f6.PNG"
       class="lightbox" title="Capture.PNG">
        <img src="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/optimized/2X/2/2f03dd98d3c8fdd5ad13f26a7a1d56811b9dc2f6_1_690x393.PNG"
             alt="Capture" width="690" height="393">
        <div class="meta">
            <span class="filename">Capture.PNG</span>
            <span class="informations">717x409 46.9 KB</span>
            <span class="expand"/>
        </div>
    </a>
</div>
</p>
<p>“Termínom “obratom” sa v podmienkach Obchodného registra rozumie do konca dňa, obchodný register bude aktualizovaný
    na dennej báze.” (podľa Štúdie uskutočniteľnosti)</p>
<p>Štúdia uskutočniteľnosti:</p>
<ul>
    <li>Dôležitým výstupovým ukazovateľom projektu je zabezpečenie 100% kvality a integrity dát v obchodnom registry.
        (kap. 1.1)
    </li>
    <li>Dáta z obchodného registra budú použiteľné na právne účely on-line, čím sa eliminuje potreba výpisov z
        obchodného registra. (kap 1.1)
    </li>
</ul>
<p>Nie sú známe merateľné ciele súvisiace s optimalizáciou vnútorného prostredia verejnej správy súvisiacej s agendou
    OR, čo je jeden z deklarovaných zámerov projektu.</p>'
        ),
        OpenStruct.new(
          phase: 1,
          score: 2,
          name: 'Postup dosiahnutia cieľov',
          html: '<p>Projekt je rozdelený na dve etapy, prvá etapa sú funkcie pre ktoré nie je vyžadovaná legislatívna zmena (podľa štúdie
    uskutočniteľnosti). Štúdia uskutočniteľnosti obsahuje detailný harmonogram činností.<br>
    Od iných subjektov je pri realizácii projektu závislá iba integrácia na referenčné údaje.</p>
<p>Nie je známe, akým spôsobom bude realizované dosiahnutie cieľa “100% kvality dát v registri”, ktoré bude náročné aj
    vzhľadom na historické skúsenosti v tejto oblasti.</p>'
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
