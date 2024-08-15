class RemoveSubjectNameAndMarksFromStudents < ActiveRecord::Migration[7.1]
  def change
    remove_column :students, :subject_name, :string
    remove_column :students, :marks, :integer
  end
end
