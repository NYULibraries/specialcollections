class HelpController < ApplicationController
  def healthcheck
    render json: {success: true}
    return
  end
end
