class CreateSubjectDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :subject_details do |t|
      t.references :student, null: false, foreign_key: true
      t.string :subject_name
      t.integer :marks

      t.timestamps
    end
  end
end
