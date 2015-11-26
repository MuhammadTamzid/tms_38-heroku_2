class AddIsClosedCourses < ActiveRecord::Migration
  def change
    add_column :courses, :is_closed, :boolean, default: false
  end
end
