class Student < ApplicationRecord
  belongs_to :teacher
  validates :name, presence: true
  validates :subject_name, presence: true
  validates :marks, presence: true
end
