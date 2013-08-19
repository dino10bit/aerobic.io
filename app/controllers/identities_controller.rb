# IdentitiesController is used to manage Omniauth Identity Provider objects.
#
# Right now we use it solely to display the Sign Up form.
#
class IdentitiesController < ApplicationController
  skip_before_filter :login_required, if: ->{ $switch_board.sign_up_is_active? }

  def new
    @identity = env["omniauth.identity"]
  end
end
