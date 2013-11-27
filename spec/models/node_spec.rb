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
#  x               :integer          default(0), not null
#  y               :integer          default(0), not null
#

require 'spec_helper'

describe Node do
  pending "add some examples to (or delete) #{__FILE__}"
end
