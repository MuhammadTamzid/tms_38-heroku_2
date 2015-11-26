class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user, index: true, foreign_key: true
      t.date :report_date
      t.string :from_time
      t.string :to_time
      t.text :achievement
      t.text :next_day_plan
      t.text :free_comment

      t.timestamps null: false
    end
  end
end
