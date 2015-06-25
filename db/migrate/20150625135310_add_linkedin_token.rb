class AddLinkedinToken < ActiveRecord::Migration
  def change
    add_column :users, :linked_in_token, :string
  end
end
