class UserSessionsController < ApplicationController
  require 'authpds'
  include Authpds::Controllers::AuthpdsSessionsController
end
