class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_page

  def set_page
    @page = OpenStruct.new(
        url: request.protocol + request.host_with_port + request.path,
        og: OpenStruct.new(
            title: 'Red Flags od Slovensko.Digital',
            description: 'Monitorované IT projekty a ich kolaboratívne hodnotenie metodikou Red Flags.',
            image: view_context.image_url('temp_fb_share.png'),
        )
    )
  end
end
