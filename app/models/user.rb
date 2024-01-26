class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]  

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :full_name, presence: true
  validates :date_of_birth, presence: true

  # attr_accessor :email, :password, :password_confirmation, :remember_me, :full_name, :date_of_birth

  has_many :tasks
  has_many :assign_user_tables, dependent: :destroy

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first


    unless user
        user = User.create(
          name: data["name"],
          email: data["email"],
          password: Devise.friendly_token[0,20]
        )
    end
    user
  end
end
