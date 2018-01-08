# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#　ユーザーの作成
10.times do |n|
  email = Faker::Internet.unique.email
  name = email.split("@")[0]
  self_introduction = "#{name}と申します。よろしくお願いします！"
  password = "password"
  uid = User.create_unique_string
  user = User.new(
          email: email,
          name: name,
          self_introduction: self_introduction,
          password: password,
          password_confirmation: password,
          uid: uid,
  )
  user.skip_confirmation! #confirmableの手順をスキップ
  user.save!
end

#　管理用ユーザーの作成
email = "admin@admin"
name = email.split("@")[0]
self_introduction = "管理者用のユーザーです。"
password = "password"
uid = User.create_unique_string
admin_user = User.new(
        email: email,
        name: name,
        self_introduction: self_introduction,
        password: password,
        password_confirmation: password,
        uid: uid,
        admin: true,
)
admin_user.skip_confirmation! #confirmableの手順をスキップ
admin_user.save!

# イベントの作成
user1 = User.first
user2 = User.find(2)
user3 = User.find(3)
user4 = User.find(4)
user5 = User.find(5)
user6 = User.find(6)
user7 = User.find(7)
user8 = User.find(8)
user9 = User.find(9)
user10 = User.find(10)

15.times do |n| # 検索一覧画面で10件以上でページングするので、11件以上
  start_datetime = DateTime.now
  end_datetime = DateTime.now
  if n == 0 #過去のイベントも作成する
    start_datetime -= 3
    end_datetime -= 3
    end_datetime += Rational(1, 24)
  else
    start_datetime += n * n
    end_datetime += n * n
    end_datetime += Rational(1, 24)
  end
  if n < 6
    event = user1.events.build(
      name: "サンプルイベント第#{n+1}回目",
      summary: "サンプルのイベントです。第#{n+1}回目の開催になります。",
      place: "サンプル開催地 #{n+1}階",
      place_address: "東京都豊島区×× #{n+1}-#{n+5}-#{n+10}",
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      capacity: n*10,
      fee: n*1000
    )
  elsif n < 14
    event = user2.events.build(
      name: "サンプルイベント第#{n+1}回目",
      summary: "サンプルのイベントです。第#{n+1}回目の開催になります。",
      place: "サンプル開催地 #{n+1}階",
      place_address: "東京都豊島区×× #{n+1}-#{n+5}-#{n+10}",
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      capacity: n*10,
      fee: nil
    )
  else #削除可能なイベント作成
    event = user1.events.build(
      name: "削除用イベント",
      summary: "削除用のサンプルイベントです。申込者がいないので削除できます。",
      place: "サンプル開催地",
      place_address: "東京都豊島区×× #{n+1}-#{n+5}-#{n+10}",
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      capacity: n*10,
      fee: n*1000
    )
  end
  event.save(validate: false) #日付チェックを無視する
end

# 参加者の登録
5.times do |n|
  event = Event.find(n+1) #過去のイベントにも参加させる
  user3.join_event!(event)
  user4.join_event!(event)
  user5.join_event!(event)
  user6.join_event!(event)
  user7.join_event!(event)
  user8.join_event!(event)
  user9.join_event!(event)
  user10.join_event!(event)
  user10.cancel_event!(event) #10番目のユーザーは申込をキャンセル
end
