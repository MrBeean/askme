module UsersHelper
  def color_picker
    {
      seagreen: '#005a55',
      yellow: '#8f9a04',
      yellowgreen: '#6e9628',
      darkblue: '#0000b7',
      royalblue: '#3e64d6'
    }
  end

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
