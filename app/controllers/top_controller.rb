class TopController < ApplicationController
  def index
    @events = Event.order(("created_at DESC")).limit(5) #最新の5件のみ表示
    @q = Event.ransack  #検索フォーム表示用
  end

  private
  def top_params
  end

end
