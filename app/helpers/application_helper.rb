module ApplicationHelper
  def profile_img(user)
    return image_tag(user.avatar, alt: user.name) if user.avatar?

    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, alt: user.name)
  end

  def show_fee(event)
    if event.fee #データがなければ無料
      "#{event.fee}円"
    else
      return "無料"
    end
  end
end
