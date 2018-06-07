# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

phase1 = RatingPhase.find_or_create_by!(name: 'I. Prípravná fáza')
phase1.rating_types.find_or_create_by!(name: 'Reforma VS')
phase1.rating_types.find_or_create_by!(name: 'Merateľné ciele (KPI)')
phase1.rating_types.find_or_create_by!(name: 'Postup dosiahnutia cieľov')
phase1.rating_types.find_or_create_by!(name: 'Súlad s KRIS')
phase1.rating_types.find_or_create_by!(name: 'Biznis prínos')
phase1.rating_types.find_or_create_by!(name: 'Príspevok v informatizácii')
phase1.rating_types.find_or_create_by!(name: 'Štúdia uskutočniteľnosti')
phase1.rating_types.find_or_create_by!(name: 'Alternatívy')
phase1.rating_types.find_or_create_by!(name: 'Kalkulácia efektívnosti')
phase1.rating_types.find_or_create_by!(name: 'Participácia na príprave projektu')

phase2 = RatingPhase.find_or_create_by!(name: 'II. Obstarávanie / nákup')
phase2.rating_types.find_or_create_by!(name: 'Predmet zákazky')
phase2.rating_types.find_or_create_by!(name: 'Dostupnosť podkladov')
phase2.rating_types.find_or_create_by!(name: 'Predbežná hodnota zákazky')
phase2.rating_types.find_or_create_by!(name: 'Vylučujúce podmienky')
phase2.rating_types.find_or_create_by!(name: 'Priestor na zapojenie sa')
phase2.rating_types.find_or_create_by!(name: 'Súťaživosť')
phase2.rating_types.find_or_create_by!(name: 'Úspora')
phase2.rating_types.find_or_create_by!(name: 'Vendor lock-in')
phase2.rating_types.find_or_create_by!(name: 'Autorské práva')
phase2.rating_types.find_or_create_by!(name: 'FOSS')
phase2.rating_types.find_or_create_by!(name: 'Sadzby za práce')
phase2.rating_types.find_or_create_by!(name: 'Ceny za komodity')
phase2.rating_types.find_or_create_by!(name: 'Modulárnosť / delenie projektu na časti')

ProjectStage.find_or_create_by!(name: 'Príprava projektu').update!(position: 1)
ProjectStage.find_or_create_by!(name: 'Obstarávanie').update!(position: 2)
ProjectStage.find_or_create_by!(name: 'Realizácia projektu').update!(position: 3)
ProjectStage.find_or_create_by!(name: 'Testovacia prevádzka').update!(position: 4)
ProjectStage.find_or_create_by!(name: 'Prevádzka').update!(position: 5)
ProjectStage.find_or_create_by!(name: 'Zastavený projekt').update!(position: 998)
ProjectStage.find_or_create_by!(name: 'Zrušený projekt').update!(position: 999)