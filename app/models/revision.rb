# == Schema Information
#
# Table name: revisions
#
#  id             :integer          not null, primary key
#  page_id        :integer          not null
#  version        :integer          not null
#  raw            :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :string           not null
#  tags           :string           default([]), is an Array
#  total_score    :integer
#  maximum_score  :integer
#  redflags_count :integer      default(0)
#
# Indexes
#
#  index_revisions_on_page_id              (page_id)
#  index_revisions_on_page_id_and_version  (page_id,version) UNIQUE
#  index_revisions_on_tags                 (tags)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#

class Revision < ApplicationRecord
  belongs_to :page

  has_many :ratings, class_name: 'RevisionRating'

  def body_html
    raw['post_stream']['posts'].first['cooked']
  end

  def published?
    page.published_revision == self
  end

  def latest?
    page.latest_revision == self
  end

  def total_score_percentage
    100.0 * total_score / maximum_score
  end

  def aggregated_rating
    [redflags_count, -total_score_percentage]
  end

  def load_ratings(raw)
    redflags_count = 0
    total_score = 0
    maximum_score = 0
    body = self.raw['post_stream']['posts'].first['cooked']
    summary, rest = body.split(/<h1>.+?<\/h1>/m, 2)

    doc = Nokogiri::HTML.parse(rest) # we are parsing rest here
    doc.css('h3').each do |heading|
      value = heading.text.strip.gsub(/[^0-9A-Za-záäčďéíĺľňóôŕřšťúůýžÁÄČĎÉÍĹĽŇÓÔŔŘŠŤÚŮÝŽ() ]/, '').strip
      rating_type = RatingType.find_by(name: value)
      if rating_type
        score = heading.css('img.emoji[title=":star:"]').count
        bad_score = heading.css('img.emoji[title=":grey_star:"]').count
        red_score = heading.css('img.emoji[title=":triangular_flag_on_post:"]').count
        if red_score > 0
          bad_score = 4
        end
        if score + bad_score > 0
          rating = self.ratings.find_or_initialize_by(rating_type: rating_type)
          rating.score = score
          redflags_count += 1 if bad_score == 4
          total_score += score
          maximum_score += 4
        end
      end
    end

    self.redflags_count = redflags_count
    self.total_score = total_score
    self.maximum_score = maximum_score
  end
end
