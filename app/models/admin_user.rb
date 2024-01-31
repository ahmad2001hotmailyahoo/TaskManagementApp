class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  def self.ransackable_attributes(auth_object = nil)
    %w[id email username]
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
