class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @events = Event.where(user_id: @user.id).order(start_datetime: "ASC")
  end

  private #特になし

end
