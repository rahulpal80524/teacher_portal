class StudentsController < ApplicationController
  before_action :authenticate_teacher!
  def index
    # Retrieve all students for the current teacher along with their subject_details
    students_with_details = Student.includes(:subject_details)
    @students = students_with_details.flat_map do |student|
      student.subject_details.map do |detail|
        {
          id: student.id,
          name: student.name,
          subject_name: detail.subject_name || "",
          teacher_id: student.teacher_id,
          marks: detail.marks || ""
        }
      end
    end

  end



 # GET /students/:id
  def show
    # Retrieve the student and their associated subject_details
    student = Student.includes(:subject_details).find(params[:id])

    @student = student.subject_details.map do |detail|
      {
        id: student.id,
        name: student.name,
        subject_name: detail.subject_name,
        teacher_id: student.teacher_id,
        marks: detail.marks
      }
    end

    render json: @student
  end


   # POST /students
   def create
    stripped_name = student_params[:name].strip
    @student = Student.find_or_initialize_by(name: stripped_name, teacher_id: current_teacher.id)

    if @student.new_record?
      @student.assign_attributes(student_params.except(:subject_name, :marks))

      if @student.save
        @student.subject_details.create(subject_name: student_params[:subject_name], marks: student_params[:marks])
        render json: [{
          id: @student.id,
          name: @student.name,
          subject_name: student_params[:subject_name],
          teacher_id: @student.teacher_id,
          marks: student_params[:marks]
        }], status: :created
      else
        render json: @student.errors, status: :unprocessable_entity
      end
    else
      existing_subject = @student.subject_details.find_by(subject_name: student_params[:subject_name])

      if existing_subject
        if existing_subject.marks == student_params[:marks].to_i
          render json: { error: 'Subject details are identical to existing data.' }, status: :unprocessable_entity
        else
          existing_subject.update(marks: existing_subject.marks + student_params[:marks].to_i)
          render json: @student.subject_details.map { |detail|
            {
              id: @student.id,
              name: @student.name,
              subject_name: detail.subject_name,
              teacher_id: @student.teacher_id,
              marks: detail.marks
            }
          }, status: :ok
        end
      else
        # Create new subject detail if it does not exist
        @student.subject_details.create(subject_name: student_params[:subject_name], marks: student_params[:marks])
        render json: @student.subject_details.map { |detail|
          {
            id: @student.id,
            name: @student.name,
            subject_name: detail.subject_name,
            teacher_id: @student.teacher_id,
            marks: detail.marks
          }
        }, status: :ok
      end
    end
  end



    # PATCH/PUT /students/:id
  def update
    @student = Student.find(params[:id])

    if @student.teacher_id != current_teacher.id
      render json: { error: "You do not have access to update this record." }, status: :forbidden
    else
      if @student.update(student_params.except(:subject_name, :marks))
        render json: @student.subject_details.map { |detail|
          {
            id: @student.id,
            name: @student.name,
            subject_name: detail.subject_name,
            teacher_id: @student.teacher_id,
            marks: detail.marks
          }
        }, status: :ok
      else
        render json: { error: @student.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
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
    params.permit(:name, :subject_name, :marks)
  end

end
