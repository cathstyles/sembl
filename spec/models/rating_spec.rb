# == Schema Information
#
# Table name: ratings
#
#  id             :integer          not null, primary key
#  rating         :float
#  resemblance_id :integer
#  creator_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Rating do
  pending "add some examples to (or delete) #{__FILE__}"
end
