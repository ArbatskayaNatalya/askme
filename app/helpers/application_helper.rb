module ApplicationHelper

  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def correct_declination(number, one, two, many)
    ostatok = number % 100

    if (11..14).include?(ostatok)
      return many
    end

    ostatok = number % 10

    if ostatok == 1
      one
    elsif (2..4).include?(ostatok)
      two
    else
      many
    end
  end
end
