class AddGistBodyToLink < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :gist_body, :string
  end
end
