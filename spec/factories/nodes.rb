# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node do
    factory :node_with_final_placements do 
      state {'filled'}
      after(:create) do |node|
        FactoryGirl.create(:placement, node: node, state: 'final')
      end 
    end

    factory :node_with_proposed_placements do 
      state {'in_play'}
      after(:create) do |node|
        FactoryGirl.create(:placement, node: node, state: 'proposed')
      end 
    end
  end


end
