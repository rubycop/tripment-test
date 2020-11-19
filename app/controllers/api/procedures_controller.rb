class Api::ProceduresController < ApplicationController
  include DataFormatter

  def search
    search_params = params[:name]
    render_json_ok([]) and return if search_params.empty?

    procedures = Procedure.find_by_name_pattern(search_params)
    render_json_ok(procedures)
  end

  def create
    procedures = Procedure.collect_data_from_source
    head :bad_request and return unless procedures

    # clear db just for example to prevent repeated insertion
    Procedure.destroy_all
    # mass insert
    begin
      result = Procedure.insert_all(prepare_data(procedures))
      # just to be sure that imported list is correct
      render_json_ok(procedures)
    rescue ActiveRecord::RecordInvalid => invalid
      render json: invalid.record.errors, status: :unprocessable_entity
    end
  end

  private

  def render_json_ok(resp)
    render json: resp.to_json, status: :ok
  end
end
