class RedirectionController < ApplicationController
  def redirect
    redirect_to params[:url]
  end
end
