# == Schema Information
#
# Table name: pages
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  latest_revision_id    :integer
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

class Page < ApplicationRecord
  belongs_to :phase

  has_many :revisions

  belongs_to :published_revision, class_name: 'Revision', optional: true
  belongs_to :latest_revision, class_name: 'Revision', optional: true

  delegate :title, to: :latest_revision

  def publishable?
    true
  end

  def published?
    published_revision.present?
  end

  def synced?
    published_revision == latest_revision
  end

  def publish_and_enqueue_jobs(revision)
    new_revision = update_associated_phase_revision(revision)

    if new_revision
      updates = build_publish_updates(new_revision)
      UpdateMultipleSheetColumnsJob.perform_later(id, updates)
      ExportTopicIntoSheetJob.perform_later(new_revision)
    end
  end

  def update_associated_phase_revision(revision)
    related_revisions = PhaseRevision.where(revision_id: revisions.ids).where.not(revision_id: revision.id)
    related_revisions.update_all(published: false) if revision

    new_revision = PhaseRevision.find_by(revision_id: revision.id)
    if new_revision
      new_revision.update!(published: true, was_published: true, published_at: Time.now)
      new_revision
    end
  end

  def build_publish_updates(revision)
    [
      {
        column_names: { "Prípravná fáza" => "Príprava publikovaná?", "Fáza produkt" => "Produkt publikovaný?" },
        page_type: revision.phase.phase_type.name,
        published_value: "Áno"
      },
      {
        column_names: { "Prípravná fáza" => "Dátum publikácie prípravy", "Fáza produkt" => "Dátum publikácie produktu" },
        page_type: revision.phase.phase_type.name,
        published_value: revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: { "project" => "Dátum poslednej aktualizácie" },
        page_type: "project",
        published_value: revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: { "Prípravná fáza" => "RF web príprava", "Fáza produkt" => "RF web produkt" },
        page_type: revision.phase.phase_type.name,
        published_value: %(=HYPERLINK("https://redflags.slovensko.digital/admin/pages/#{id}"; "Admin link"))
      }
    ]
  end

  def unpublish_and_enqueue_jobs(revision_id)
    PhaseRevision.where(revision_id: revision_id).update_all(published: false, published_at: nil) if revision_id

    updates = build_unpublish_updates
    UpdateMultipleSheetColumnsJob.perform_later(id, updates)
  end

  def build_unpublish_updates
    [
      {
        column_names: { "Prípravná fáza" => "Príprava publikovaná?", "Fáza produkt" => "Produkt publikovaný?" },
        page_type: phase.phase_type.name,
        published_value: "Nie"
      },
      {
        column_names: { "Prípravná fáza" => "Dátum publikácie prípravy", "Fáza produkt" => "Dátum publikácie produktu" },
        page_type: phase.phase_type.name,
        published_value: ""
      },
      {
        column_names: { "Prípravná fáza" => "RF web príprava", "Fáza produkt" => "RF web produkt" },
        page_type: phase.phase_type.name,
        published_value: ""
      }
    ]
  end
end
