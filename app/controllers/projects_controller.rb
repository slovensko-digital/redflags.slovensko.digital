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

      ],

      activities_html: '<ul>
    <li>14.7.2016 Reformný zámer <a href="https://www.minv.sk/?schvalene-rz&amp;subor=245880">schválený</a> HK OP EVS
    </li>
    <li>2.6.2017 Štúdia uskutočniteľnosti schválená RV OPII PO 7</li>
    <li>18.7.2017 v OPII PO 7 <a
            href="http://www.informatizacia.sk/aktuality-tlacova-sprava-k-vyzvaniu-na-narodny-projekt-informacny-system-obchodneho-registra/25472c">zverejnená
        výzva</a> na Národný projekt IS Obchodného registra
    </li>
</ul>',

      documents_html: '<ul>
    <li>
        <p>Reformný zámer: <a class="attachment"
                              href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/1/15854e70f13904751d2c879945bafaf435440b32.pdf">12.RZ-MSSR-Zlepsenie
            podnikatelskeho prostredia a odbremenenie sudneho systemu.pdf</a> (986.3 KB)</p>
    </li>
    <li>
        <p>pripomienky k Reformnému zámeru a ich zapracovanie: potrebné získať od MV SR /EVS</p>
    </li>
    <li>
        <p>Štúdia uskutočniteľnosti:</p>
        <ul>
            <li>
                <a href="https://metais.finance.gov.sk/studia/detail/67cab118-1a08-e9dc-a136-a2f3a51811dd?tab=basicForm">online</a>
            </li>
            <li>(vybrané z príloh vyzvania) <a class="attachment"
                                               href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/e/e351d6d3c5cc79222275f78d0774aa96483f1c5f.pdf">SU_IS
                OR SR_su47.pdf</a> (1.7 MB)
            </li>
        </ul>
    </li>
    <li>
        <p>Vyzvanie na národný projekt:</p>
        <ul>
            <li>
                <a href="https://www.opii.gov.sk/opiiapp.php/Vyzvania/show?id=369">online</a>
            </li>
            <li>
                <a class="attachment"
                   href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/a/a34b54a00960e3af7fa92b736115b9e4620e5e83.PDF">vyzvanie
                    č. OPII-201773-NP Národného projektu Informačný systém Obchodného registra SR (2).PDF</a> (515.5 KB)
            </li>
            <li>
                <a class="attachment"
                   href="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/5/52f2f45c3668014320214a9926ce30d98978536e.zip">Prilohy_vyzvania_ISOR
                    (1).zip</a> (3.0 MB)
            </li>
        </ul>
    </li>
    <li>
        <p>pripomienky k Štúdii uskutočniteľnosti a ich zapracovanie: potrebné získať od MSSR alebo ÚPVII</p>
    </li>
    <li>
        <p>Procesno organizačný audit rezortu spravodlivosti (zameraná na registráciu obchodných spoločností): potrebné
            získať od MSSR - podľa RZ bol vypracovaný v prvom kvartáli 2017</p>
    </li>
</ul>',
    )
    @ranking_phases = ['I. Prípravná fáza', 'II. Obstarávanie / nákup', 'III. Realizácia', 'IV. Produkt', 'V. Prevádzka']
  end
end
