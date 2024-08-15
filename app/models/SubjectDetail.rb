class SubjectDetail < ApplicationRecord
  belongs_to :student

  validates :subject_name, presence: true
  validates :marks, presence: true, numericality: { only_integer: true }
end
