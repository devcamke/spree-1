class CreatePromotionBatches < ActiveRecord::Migration[7.1]
  def change
    create_table :spree_promotion_batches do |t|
      t.string :status

      t.timestamps
    end
  end
end
