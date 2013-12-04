# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float            default(0.0), not null
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      default(""), not null
#

require 'spec_helper'

describe Player do
  pending "add some examples to (or delete) #{__FILE__}"
end
