class AddBonusToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :bonus, :decimal, default: 0
  end
end
