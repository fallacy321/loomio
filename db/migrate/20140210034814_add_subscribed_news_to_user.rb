class AddSubscribedNewsToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_news, :boolean, default: false
  end
end
