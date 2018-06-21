class SyncTopicJob < ApplicationJob
  queue_as :default

  def perform(topic_id)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))
    topic = client.topic(topic_id)

    Page.transaction do

      # TODO latest_revision_id should be not null on DB level

      page = Page.find_or_create_by!(id: topic_id)
      version = topic['post_stream']['posts'].first['version']

      revision = page.revisions.find_or_initialize_by(version: version)
      revision.title = topic['title']
      revision.tags = topic['tags']
      revision.raw = topic
      revision.save!

      page.latest_revision = revision
      page.save!
    end
  end
end
