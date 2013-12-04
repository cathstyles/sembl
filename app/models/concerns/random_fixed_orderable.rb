module RandomFixedOrderable
  extend ActiveSupport::Concern

  included do
    before_create :generate_random_seed
  end

  # XOR operator is # in postgres
  def self.random_fixed_order(seed)
    order("(things.random_seed # #{seed})")
  end

private

  def generate_random_seed
    self.random_seed = SecureRandom.random_number(2147483646)
  end
end
