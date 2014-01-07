module RandomFixedOrderable
  extend ActiveSupport::Concern

  included do
    before_create :generate_random_seed
  end

  # XOR operator is # in postgres
  module ClassMethods
    def random_fixed_order(seed)
      order("(things.random_seed # #{seed})")
    end
  end

private

  def generate_random_seed
    self.random_seed = SecureRandom.random_number(2147483646)
  end
end
