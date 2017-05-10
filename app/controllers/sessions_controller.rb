class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user.present?
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Вы успешно залогинелись'
    else
      flash.now.alert = 'Неправильные данные'
      render :new
    end
  end

  def destroy
    # Затираем в сессии значение ключа :user_id
    session[:user_id] = nil

    # Редиректим пользователя на главную с сообщением
    redirect_to root_url, notice: 'Вы разлогинились! Приходите еще!'
  end
end
