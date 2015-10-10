require 'role_model'
require 'rubygems'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include RoleModel
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :cart_products
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :roles_mask

  # optionally set the integer attribute to store the roles in,
  # :roles_mask is the default
  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :admin, :participant

  private
  ## Strong Parameters 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :roles, :roles_mask)
  end
end
