class AddSlugToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :slug, :email

  end
end
