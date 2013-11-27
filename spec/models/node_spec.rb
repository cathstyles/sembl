# == Schema Information
#
# Table name: nodes
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  round           :integer
#  state           :string(255)
#  allocated_to_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  position_x      :float
#  position_y      :float
#

require 'spec_helper'

describe Node do
  pending "add some examples to (or delete) #{__FILE__}"
end
