module UsersHelper
  def background_color
    if
      current_user == nil
      return ""
    elsif
      current_user.username == @user.username
      return "background-color: #{@user.background_color}"
    else
      return ""
    end
  end
end
