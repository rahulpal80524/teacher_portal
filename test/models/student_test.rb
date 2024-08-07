require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "should not save student without name" do
    student = Student.new(subject_name: "Math", marks: 85)
    assert_not student.save, "Saved the student without a name"
  end

  test "should not save student without subject name" do
    student = Student.new(name: "John Doe", marks: 85)
    assert_not student.save, "Saved the student without a subject name"
  end

  test "should not save student without marks" do
    student = Student.new(name: "John Doe", subject_name: "Math")
    assert_not student.save, "Saved the student without marks"
  end
end
