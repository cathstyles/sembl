class AddSourceAndTargetToResemblance < ActiveRecord::Migration
  def up
    add_reference :resemblances, :source, index: true, class_name: "Placement"
    add_reference :resemblances, :target, index: true, class_name: "Placement"
  end

  def down
    remove_reference :resemblances, :source
    remove_reference :resemblances, :target
  end
end
