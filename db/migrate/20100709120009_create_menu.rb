class CreateMenu < ActiveRecord::Migration
  def self.up
    create_table :menu do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :menu
  end
end
