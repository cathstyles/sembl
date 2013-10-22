# == Schema Information
#
# Table name: things
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :text             default("")
#  creator_id  :integer
#  updator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  image       :string(255)
#

require 'spec_helper'

describe Thing do
end
