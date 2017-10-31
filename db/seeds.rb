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

