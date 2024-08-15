class Student < ApplicationRecord
  belongs_to :teacher
  validates :name, presence: true, uniqueness: { scope: :teacher_id, message: "Name must be unique for each teacher" }

  has_many :subject_details, dependent: :destroy
  accepts_nested_attributes_for :subject_details, allow_destroy: true

end
