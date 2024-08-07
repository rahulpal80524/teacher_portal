class ApplicationController < ActionController::Base
  def after_sign_out_path_for(resource_or_scope)
    binding.pry
    new_teacher_session_path # This will redirect to /teachers/sign_in
  end
end
