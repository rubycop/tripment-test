class Api::ProceduresController < ApplicationController
  def search
    query_params = params[:name]
    @procedures = Procedure.find_by_name_pattern(query_params)
    render json: @procedures
  end

  def load
    @procedure = Procedure.new(procedure_params)
    if @procedure.save
      render json: @procedure, status: :created, location: @procedure
    else
      render json: @procedure.errors, status: :unprocessable_entity
    end
  end

  private

  def procedure_params
    params.require(:procedure).permit(:name)
  end
end
