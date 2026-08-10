# spec/factories/metais_projects.rb
FactoryBot.define do
  factory :metais_project, class: 'Metais::Project' do
    code { "project_code" }
    uuid { "project_uuid" }
  end
end
