class LeadsController < ApplicationController
  def index
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    
    if @lead.save
      redirect_to root_path, notice: "Thank you! We'll be in touch soon."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def chat
    # AI chat page with Vapi widget
  end

  private

  def lead_params
    params.require(:lead).permit(:email)
  end
end
