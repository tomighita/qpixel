class CreateFeaturedImages < ActiveRecord::Migration[7.0]
  def change
    create_table :featured_images do |t|
      t.string :header_text
      t.belongs_to :community, foreign_key: true
      t.belongs_to :post, foreign_key: true

      t.timestamps
    end
  end
end
