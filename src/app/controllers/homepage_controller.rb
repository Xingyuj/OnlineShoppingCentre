class HomepageController < ApplicationController
before_action :authenticate_user!, except:[:home, :about, :help]
  def index
  end
end
