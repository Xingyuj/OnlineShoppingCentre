class HomepageController < ApplicationController
before_action :authenticate_user!, except:[:home]
  def index
  end
end
