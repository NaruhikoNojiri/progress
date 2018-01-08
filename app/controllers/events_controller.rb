class EventsController < ApplicationController
  before_action :authenticate_user!, only:[:create, :show, :edit, :destroy, :update, :destroy]
  before_action :set_event, only:[:show,:edit,:update,:destroy]

  def index
    @q = Event.ransack(params[:q])
    @all_events = @q.result(distinct: true).order(start_datetime: "ASC") #ページ数カウント用
    @events = @all_events.page(params[:page]).per(10)
  end

  def create
    @event = Event.new(events_params)
    @event.user_id = current_user.id
    if @event.save
      redirect_to edit_user_registration_path, notice: "イベントを作成しました！"
    else
      render :new
    end
  end

  def new
    @event = Event.new
  end

  def show
    init_show(@event)
  end

  def edit
  end

  def update
    if @event.update(events_params)
      redirect_to event_path(@event.id), notice: "イベントを編集しました！"
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      redirect_to edit_user_registration_path, notice: "イベントを削除しました！"
    else
      init_show(@event)
      render :show  #renderをすると@eventのerrorが引き継がれない
    end
  end

  # 検索できる条件を限定する
  def self.ransackable_attributes auth_object = nil
    %w(name summary start_datetime end_datetime)
  end

  private
  def events_params
    params.require(:event).permit!
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def init_show(event)
    @pm = ParticipantManagement.find_by(event_id: event.id, user_id: current_user.id)
    if @pm.blank? # 申し込んでいない場合、新規に変数を作成。
      @pm = ParticipantManagement.new
    end
    # キャンセル済の人は表示されないようにする。
    # @participants = event.event_participants.where(participant_managements: {cancel_flag: false})
    @participants = event.substantial_participants

  end
end
