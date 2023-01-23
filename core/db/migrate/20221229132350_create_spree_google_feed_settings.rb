class CreateSpreeGoogleFeedSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_google_feed_settings do |t|
      t.references :spree_store

      t.string :uuid, unique: true
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
