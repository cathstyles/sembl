# == Schema Information
#
# Table name: resemblances
#
#  id          :integer          not null, primary key
#  description :text             not null
#  state       :string(255)      not null
#  score       :float
#  link_id     :integer
#  creator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Resemblance do
  pending "add some examples to (or delete) #{__FILE__}"
end
