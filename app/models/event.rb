class Event < ActiveRecord::Base

  has_many :participant_managements
  belongs_to :user
  has_many :event_participants, through: :participant_managements, source: :user, dependent: :destroy
  validates_presence_of :user_id, :name, :summary, :place, :place_address, :start_datetime, :end_datetime, :capacity
  validate :end_date_must_be_latar, :start_date_cannot_be_in_the_past
  validates :capacity, :fee, :numericality => { :allow_blank => true, :only_integer => true, :greater_than => 0}

  def destroy
    # 削除する当該イベントの参加者がいない、または全てキャンセルされていることを確認。
    if participant_managements.present? && participant_managements.where(cancel_flag: false).present?
      errors[:base] << "削除しようとしたイベントに参加者がいます"
      false
    else
      super
    end
  end

  # 実質的な(キャンセルしておらず、キャンセル待ちでない)当該イベントの参加者のリストを取得
  def substantial_participants
    event_participants.where(participant_managements: {cancel_flag: false}).order(updated_at: "ASC").limit(capacity)
  end

  # キャンセル待ちの何番目かを取得する
  # 申し込み日時が同じ場合はidが若い者を優先
  def order_of_watelist(user)
    target_pm =  ParticipantManagement.find_by(event_id: self.id, user_id: user.id)
    unless target_pm.nil?
      participant_managements.where(
        "updated_at <= ? cancel_flag = false OR
        updated_at = ? AND id < ? cancel_flag = false", target_pm.created_at, target_pm.created_at, target_pm.id
      ).size
    else
      return nil
    end
  end

  # イベントの申し込み可能人数を表示する
  def room_of_event
    capacity - participant_managements.where(cancel_flag: false).count
  end

  # 日付が過去日付でないこと及び開始と終了の前後関係のチェック
  def end_date_must_be_latar
    if start_datetime > end_datetime
      errors.add(:end_datetime, ": 終了日時は開始日時よりも後にしてください")
    end
  end

  def start_date_cannot_be_in_the_past
    if start_datetime.present? && start_datetime < DateTime.now
      errors.add(:start_datetime, ": 開始日時は未来の日付にしてください")
    end
  end
end
