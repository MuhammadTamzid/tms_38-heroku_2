class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.references :user_subject, index: true, foreign_key: true
      t.integer :action_type
      t.integer :target_id
      t.text :action_message

      t.timestamps null: false
    end
  end
end
