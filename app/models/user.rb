require 'openssl'

class User < ApplicationRecord
  # Параметры работы для модуля шифрования паролей
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  # Цвета, которые будут использованы для подложки у пользователя
  # TODO Убрать в таблицу-справочник, связать с пользователем
  COLORS = {
    seagreen: '#005a55',
    yellow: '#8f9a04',
    yellowgreen: '#6e9628',
    darkblue: '#0000b7',
    royalblue: '#3e64d6'
  }

  # Связь
  has_many :questions, dependent: :destroy

  # Проверки
  before_validation :username_downcase!

  validates :username, :email, :background_color, presence: true
  validates :email, :username, uniqueness: true
  validates :email, email: true
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A[\w]*\z/, message: 'only allows letters, numbers & _' }
  validates :background_color, inclusion: { in: COLORS.values,
                                            message: "%{value} is not a valid color" }

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  # Шифруем пароль, если он задан
  def encrypt_password
    if password.present?
      # Создаем т. н. «соль» — рандомная строка усложняющая задачу хакерам по
      # взлому пароля, даже если у них окажется наша база данных.
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # Создаем хэш пароля — длинная уникальная строка, из которой невозможно
      # восстановить исходный пароль. Однако, если правильный пароль у нас есть,
      # мы легко можем получить такую же строку и сравнить её с той, что в базе.
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

      # Оба поля окажутся записанными в базу при сохранении (save).
    end
  end

  # Служебный метод, преобразующий бинарную строку в 16-ричный формат,
  # для удобства хранения.
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе возвращает этого
  # пользователя. Если нету — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найдет, возвращаем nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  def username_downcase!
    self.username.downcase!
  end

  def available_colors
    COLORS
  end
end
