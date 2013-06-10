class AddPotluckidToItems < ActiveRecord::Migration
    def up
      add_column :items, :potluck_id, :integer
    end

    def down
      remove_column :items, :potluck_id
    end
  end
