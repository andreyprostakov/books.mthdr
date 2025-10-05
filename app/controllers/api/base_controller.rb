module Api
  class BaseController < ApplicationController
    private

    def perform_form_create(form, model_params, model_object)
      if form.update(model_params)
        render json: { id: model_object.id }
      else
        render_errors(form)
      end
    end

    def perform_form_update(form, model_params)
      if form.update(model_params)
        render json: {}
      else
        render_errors(form)
      end
    end

    def render_errors(model_object)
      render json: { errors: model_object.errors }, status: :unprocessable_content
    end
  end
end
