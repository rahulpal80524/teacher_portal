class StudentsController < ApplicationController
  before_action :authenticate_teacher!
 # GET /students
  def index
     # Retrieve all students from the database for current teacher
    @students = Student.where(teacher_id: current_teacher.id)
  end

  # GET /students/:id
  def show
    # Retrieve a single student by ID from the database
    @student = Student.find(params[:id])
    render json: @student
  end

   # POST /students
  def create
     # Create a new student with the provided parameters
    stripped_name = student_params[:name].strip
    @student = Student.find_or_initialize_by(
      name: stripped_name,
      subject_name: student_params[:subject_name],
      teacher_id: current_teacher.id
    )

    if @student.new_record?
      @student.assign_attributes(student_params)
      @student.name = stripped_name
    else
      @student.marks += student_params[:marks].to_i
    end

    if @student.save

      render json: @student, status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

    # PATCH/PUT /students/:id
  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    head :no_content
  end

  private
# Strong parameters for student creation and update
  def student_params
    params.require(:student).permit(:name, :subject_name, :marks)
  end
end
