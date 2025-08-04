class NewsletterSubscriptionsController < ApplicationController

  def subscribe
    email = params.require(:email)
    begin
      EmailService.subscribe_to_newsletter_with_doi(email, 'NewsletterSubscription')
      respond_to do |format|
        format.js { render :success }
      end
    rescue => error
      respond_to do |format|
        format.js { render :failure, status: :bad_request }
      end
    end
  end

  def confirmed        
    redirect_to root_path, notice: 'Ďakujeme za potvrdenie! Vaša emailová adresa bola pridaná do nášho zoznamu odoberateľov.'
  end
end
