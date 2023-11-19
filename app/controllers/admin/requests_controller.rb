class Admin::RequestsController < ApplicationController
  def index
    @request = Request.all
  end

  def update
    @request = Request.find(params[:isbn])
  end
end
