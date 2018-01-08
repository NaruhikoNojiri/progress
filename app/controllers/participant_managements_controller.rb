class ParticipantManagementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only:[:new, :cancel]

  def new
    @pm = ParticipantManagement.new
  end

  def create
    @pm = ParticipantManagement.find_by(event_id: pm_params[:event_id],user_id: current_user.id)
    if @pm #過去に申し込んでキャンセルされている場合のみこのルートを通る
      @pm.update(cancel_flag: false)
      redirect_to event_path(@pm.event_id), notice: "申し込みが完了しました！"
    else
      @pm = ParticipantManagement.new(pm_params)
      @pm.user_id = current_user.id
      if @pm.save
        redirect_to event_path(@pm.event_id), notice: "申し込みが完了しました！"
      else
        render new
      end
    end
  end

  def cancel
    current_user.cancel_event!(@event)
    redirect_to event_path(@event.id), id: @event.id,notice: "参加をキャンセルしました。"
  end

  private
  def pm_params
    params.require(:participant_management).permit(:event_id)
  end

  def set_event
    @event = Event.find(pm_params[:event_id])
  end
end
