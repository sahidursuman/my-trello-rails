class RemovePlanIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :plan_id
    add_column :users, :plan, :string
    add_column :users, :stripe_subscription_id, :string
  end
end
