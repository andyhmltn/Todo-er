class CreateCollaborators < ActiveRecord::Migration
  def self.up
    remove_column("lists", "user_id")
    create_table :collaborators do |t|
      t.integer :user_id
      t.integer :list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :collaborators
  end
end
