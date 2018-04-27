# frozen_string_literal: true

# Error page static content controller
class ErrorsController < HomepageController
  def file_not_found; end

  def unprocessable; end

  def internal_server_error; end
end
