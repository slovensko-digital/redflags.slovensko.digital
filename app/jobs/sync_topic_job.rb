class SyncTopicJob < ApplicationJob
  queue_as :default

  def perform(topic_id)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))
    topic = client.topic(topic_id)

    Page.transaction do
      page = Page.find_or_create_by!(id: topic_id)
      first_post = topic['post_stream']['posts'].first

      revision = page.revisions.find_or_initialize_by(version: first_post['version'])
      revision.raw = first_post
      revision.save!
    end
  end
end
