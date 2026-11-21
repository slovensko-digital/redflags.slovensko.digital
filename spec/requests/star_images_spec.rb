require 'rails_helper'

RSpec.describe 'Star images of the ratings', type: :request do
  %w[star grey_star].each do |name|
    it "redirects the #{name} image of a rating imported by an older build to the current one" do
      get "/assets/emoji/#{name}-390dbabdfbb7bdb3d7fae97b56f4d8c36ddb224e4967e2296704aa625bdeea41.png"

      expect(response).to redirect_to(ActionController::Base.helpers.image_path("emoji/#{name}.png"))
    end
  end
end
