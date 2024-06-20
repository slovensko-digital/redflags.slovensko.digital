class UpdateMultipleSheetColumnsJob < ApplicationJob
  queue_as :default

  def perform(page_id, updates)
    updates.each do |update|
      column_names = update[:column_names]
      page_type = update[:page_type]
      published_value = update[:published_value]

      UpdateSheetValueJob.perform_now(
        page_id,
        column_names,
        page_type,
        published_value
      )
    end
  end
end