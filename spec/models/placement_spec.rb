# == Schema Information
#
# Table name: placements
#
#  id         :integer          not null, primary key
#  state      :string(255)      not null
#  thing_id   :integer
#  node_id    :integer
#  creator_id :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  score      :float
#

require 'spec_helper'

describe Placement do
  pending "add some examples to (or delete) #{__FILE__}"
end
