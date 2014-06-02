class Move
  attr_accessor :user, :placement

  include ActiveModel::Validations

  # validate :associations_valid
  validate :placement, presence: true
  validate :target_node, presence: true
  validate :placement_exists
  validate :expected_number_of_resemblances

  def expected_number_of_resemblances
    errors.add(:base, 'All resemblances must be added to complete this move.') if @resemblances.size != links.size
  end

  def placement_exists
    if @placement.nil?
      errors.add(:placement, "must be entered in target node.")
    end
  end

  def initialize(options)
    @user = options[:user]
    if options[:placement]
      @placement = options[:placement]
      @user = @placement.creator
    end
  end

  def target_node
    @target_node ||= @placement.node
  end

  def links
    @links ||= Link.where(target_id: target_node.id)
  end

  def resemblances
    #One sembl per user per link
    # @resemblances ||= Resemblance.joins(:link).where(links: {target_id: target_node.id}, creator: user)
    @resemblances ||= links.collect{|l| resemblance_for_link(l) }.delete_if{|r| r.nil? }
  end

  def resemblance_for_link(link)
    link.resemblances.where(creator: user).take
  end

  # Pass target node_id and thing_id in attributes.
  def placement=(attributes)
    attributes[:creator] = @user
    @placement ||= Placement.where(node_id: attributes[:node_id], creator: @user).take
    @placement ||= Placement.new
    @placement.assign_attributes(attributes)
  end

  # Pass link_id, and description in sembl_attributes
  def resemblances=(resemblances_params)
    @resemblances ||= []

    resemblances_params.each do |sembl_attributes|
      link = Link.find(sembl_attributes[:link_id])
      link.resemblances.where(creator: @user).map(&:destroy)

      # Get source and target placements.
      # Source is final placement on source node
      # Target is @placement
      # Note: source and target placements is a bit of duplication but will future proof
      # against a requirement for multiple sembls per user.
      sembl_attributes[:creator] = @user
      sembl_attributes[:target] = @placement
      sembl_attributes[:source] = link.source.final_placement
      @resemblances << Resemblance.new(sembl_attributes)
    end if resemblances_params
  end

  def calculate_score
    sembl_ratings = resemblances.map { |r| r.ratings.sum(:rating)/r.ratings.size }
    avg = sembl_ratings.inject(0.0) { |sum, el| sum + el } / sembl_ratings.size
    placement.score = avg
    placement.save
  end

  def score
    @score ||= @placement.try(:score) || 0
  end

  def reify
    @placement.reify
    @resemblances.each do |resemblance|
      resemblance.reify
    end
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        @placement.save!
        @resemblances.each do |resemblance|
          resemblance.save!
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      class_name = invalid.record.class.name.to_sym
      invalid.record.errors.full_messages.each do |msg|
        errors.add(class_name, msg)
      end
    end
  end

end
