class User < ApplicationRecord
  has_many :microposts, dependent: :destroy 

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
  validates :password, presence: true, length: { minimum: 7 }, allow_nil: true 
 
end
