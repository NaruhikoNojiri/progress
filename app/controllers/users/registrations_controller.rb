class Users::RegistrationsController < Devise::RegistrationsController
  # def build_resource(hash=nil)
  #   hash[:uid] = User.create_unique_string
  #   super
  # end

  def edit
    @user = User.find(current_user.id)
    @participating_events = @user.participating_events.order(start_datetime: "ASC")
    @holding_events = @user.events.order(start_datetime: "ASC")
    super
  end
end
