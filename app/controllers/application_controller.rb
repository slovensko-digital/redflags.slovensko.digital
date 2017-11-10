class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_metadata

  private

  def set_metadata
    @metadata = OpenStruct.new(
        og: OpenStruct.new(
            url: request.protocol + request.host_with_port + request.path,
            title: 'Red Flags: Štátne IT projekty hodnotené odborníkmi',
            description: 'Otvorené a transparentné hodnotenie projektov informatizácie komunitou IT odborníkov.',
            image: view_context.image_url('fb_share.png'),
        )
    )
  end
end
