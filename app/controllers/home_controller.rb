class HomeController < ApplicationController
  before_action :authenticate_teacher!

  def index
    @students = Student.where(teacher_id: current_teacher.id)
  end
end
