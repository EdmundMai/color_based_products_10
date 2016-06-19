class SessionsController < Devise::SessionsController
  respond_to :html, :js

  def create
    login_process do
      super
    end
  end
end 
