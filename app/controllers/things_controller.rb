class ThingsController < ApplicationController

  def index
    @things = Thing.all.order("RANDOM()")
  end
end
