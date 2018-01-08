class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  has_many :events, dependent: :destroy
  has_many :participant_managements, dependent: :destroy
  has_many :participating_events, through: :participant_managements, source: :event
  mount_uploader :avatar, AvatarUploader
  validates_presence_of :name, :self_introduction

  # method for facebook_login
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
          name:     auth.extra.raw_info.name,
          self_introduction:  "(自己紹介文を記入してください。)", #独自項目 "(自己紹介文を記入してください。)"
          provider: auth.provider,
          uid:      auth.uid,
          email:    "#{auth.uid}-#{auth.provider}@example.com",
          image_url:   auth.info.image,
          password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  # method for twitter_login
  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
  user = User.find_by(provider: auth.provider, uid: auth.uid)
    unless user
      user = User.new(
          name:     auth.info.nickname,
          self_introduction:  "(自己紹介文を記入してください。)", #独自項目
          image_url: auth.info.image,
          provider: auth.provider,
          uid:      auth.uid,
          email:    "#{auth.uid}-#{auth.provider}@example.com",
          password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  # create rundom uid
  def self.create_unique_string
    SecureRandom.uuid
  end

  # enable SNS_logined user to update user info
  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end

  def join_event!(event)
    participant_managements.create!(event_id: event.id)
  end

  def cancel_event!(event)
    @pm = participant_managements.find_by!(event_id: event.id, user_id: self.id)
    @pm.cancel_flag = true
    @pm.save
  end

end
