require 'rubygems'
require 'httparty'
require 'tumblruby/auth'
require 'tumblruby/post'
require 'tumblruby/request'

class Tumblruby
  def initialize email,pass
    @auth = Auth.new email,pass
  end
  attr_reader :auth
end
