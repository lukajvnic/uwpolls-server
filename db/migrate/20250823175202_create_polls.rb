class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :polls do |t|
      t.string :email
      t.string :title
      t.string :opt1
      t.string :opt2
      t.string :opt3
      t.string :opt4
      t.integer :res1, default: 0
      t.integer :res2, default: 0
      t.integer :res3, default: 0
      t.integer :res4, default: 0
      t.integer :totalvotes, default: 0
      t.datetime :timeposted, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
