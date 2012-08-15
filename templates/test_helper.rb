ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha"

class ActiveSupport::TestCase
  fixtures :all

  class OmnipotenceAbility
    include CanCan::Ability
    def initialize *args
      can [:create, :read, :update, :destroy], :all
    end
  end
  def self.skip_authorization; setup :skip_authorization; end
  def skip_authorization
    @ability = OmnipotenceAbility.new
    @controller.stubs(:current_ability).returns(@ability)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

