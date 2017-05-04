class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1,
        name: 'Vadim',
        username: 'installero',
        avatar_url: 'https://cdn.meme.am/cache/instances/folder203/250x250/48506203/mr-bean-happy-wow.jpg'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Андрей',
      username: 'mrBeaN',
      avatar_url: 'https://cdn.meme.am/cache/instances/folder203/250x250/48506203/mr-bean-happy-wow.jpg'
    )

    @questions = [
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('27.04.2017')),
      Question.new(text: 'Как стать джыгитом?', created_at: Date.parse('04.05.2017')),
      Question.new(text: 'Как долго продлится кризис?', created_at: Date.parse('04.05.2017')),
      Question.new(text: 'Как здоровье?', created_at: Date.parse('04.05.2017'))
    ]

    @new_question = Question.new
  end
end
