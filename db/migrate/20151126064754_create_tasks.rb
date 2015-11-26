class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :task_order
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
