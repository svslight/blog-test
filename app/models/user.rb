class User < ApplicationRecord
  has_many :microposts, dependent: :destroy 

  before_save { self.email = email.downcase }

  # validates — метод; presence -  хэш с одним элементом; validates(:name, presence: true)
  validates :name,  presence: true, length: { maximum: 50 }
  
  
  # Регулярное выражение VALID_EMAIL_REGEX 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i   
 
  # Валидация уникальности адресов электронной почты
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }                               
  
  # Метод для безопасного пароля, обеспечивает валидации виртуальных атрибутов password и password_confirmation
  # Код необходимый для прохождения начальных тестов пароля
  has_secure_password
  
  # (allow_nil:true)- разрешение для полей с пустым паролем
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true 

  # Возвращает дайджест данной строки
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
 
  # Возвращает случайный токен
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Запоминает пользователя в базе данных для использования в постоянной сессии.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Возвращает true, если предоставленный токен совпадает с дайджестом.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end
end
