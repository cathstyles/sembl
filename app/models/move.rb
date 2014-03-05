class Move 
  attr_accessor :user, :target_node, :placement, :links, :source_nodes, :resemblances 

  include ActiveModel::Validations

  def initialize(options)
    @user = options[:user]

    if options[:placement]
      @placement = options[:placement]
      @user = @placement.creator
      @target_node = @placement.node
      @links = Link.where(target: @target_node)
      #One sembl per user per link
      @resemblances = @links.collect{|l| resemblance_for_link(l) }
    end 
  end

  def resemblance_for_link(link)
    link.resemblances.where(creator: user).take
  end

  # Pass target node_id and thing_id in attributes. 
  def placement=(attributes)
    attributes[:creator] = @user
    @placement ||= Placement.new
    @placement.assign_attributes(attributes)
  end

  # Pass link_id, and description in sembl_attributes
  def resemblances=(resemblances)
    @links.resemblances.where(creator: @user).destroy_all 
    resemblances.each do |sembl_attribtues|

      # Get source and target placements. 
      # Source is final placement on source node
      # Target is @placement
      # Note: source and target placements is a bit of duplication but will future proof
      # against a requirement for multiple sembls per user.
      sembl_attributes[:creator] = @user
      sembl_attributes[:target] = @placeement
      link = Link.find(sembl_attributes[:link_id])
      sembl_attributes[:source] = link.source.final_placement
      @resemblances << Resemblance.new(sembl_attributes)
    end 
  end

  #TODO handle errors
  def save
    @placement.save
    @resemblances.each do |resemblance|
      resemblance.save
    end
  end
  
end