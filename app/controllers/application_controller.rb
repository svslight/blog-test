# Базовый класс всех контроллеров
class ApplicationController < ActionController::Base
  #  Внесение модуля SessionsHelper для доступа во всех контроллерах
  protect_from_forgery with: :exception
  include SessionsHelper
end
