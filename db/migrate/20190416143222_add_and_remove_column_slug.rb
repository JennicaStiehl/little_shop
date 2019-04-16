class AddAndRemoveColumnSlug < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :slug
    add_column :users, :slug, :string
  end
end
