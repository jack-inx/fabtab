class JsController < ApplicationController
  
  def bookmarkads
    render 'bookmarkads.js' , :content_type=> 'text/javascript; charset=utf-8'
  end
end