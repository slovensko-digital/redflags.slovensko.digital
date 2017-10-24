class SyncCategoryTopicsJob < ApplicationJob
  queue_as :default

  def perform(category_slug, sync_topic_job = SyncTopicJob)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))

    topics = client.category_latest_topics(category_slug: category_slug)

    topics.each do |topic|
      sync_topic_job.perform_later(topic.fetch('id'))
    end
  end
end
