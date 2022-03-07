class AddImageLinksToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :image_link, :string
  end
end
