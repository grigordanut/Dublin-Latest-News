class AddArticleIdToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :article_id, :bigint
    add_index :comments, :article_id
  end
end
