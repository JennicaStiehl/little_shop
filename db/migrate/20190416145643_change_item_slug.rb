class ChangeItemSlug < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :slug
    add_column :items, :slug, :string
  end
end
