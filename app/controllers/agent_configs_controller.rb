class AgentConfigsController < ApplicationController
  before_action :set_agent_config, only: %i[ show edit update destroy ]

  # GET /agent_configs or /agent_configs.json
  def index
    @agent_configs = AgentConfig.all
  end

  # GET /agent_configs/1 or /agent_configs/1.json
  def show
  end

  # GET /agent_configs/new
  def new
    @agent_config = AgentConfig.new
  end

  # GET /agent_configs/1/edit
  def edit
  end

  # POST /agent_configs or /agent_configs.json
  def create
    @agent_config = AgentConfig.new(agent_config_params)

    respond_to do |format|
      if @agent_config.save
        # Update Retell agent after saving
        update_retell_agent(@agent_config)
        
        format.html { redirect_to chat_path, notice: "Agent config was successfully created and Retell agent updated." }
        format.json { render :show, status: :created, location: @agent_config }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agent_configs/1 or /agent_configs/1.json
  def update
    respond_to do |format|
      if @agent_config.update(agent_config_params)
        # Update Retell agent after saving
        update_retell_agent(@agent_config)
        
        format.html { redirect_to chat_path, notice: "Agent config was successfully updated and Retell agent updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @agent_config }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agent_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agent_configs/1 or /agent_configs/1.json
  def destroy
    @agent_config.destroy!

    respond_to do |format|
      format.html { redirect_to agent_configs_path, notice: "Agent config was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_config
      @agent_config = AgentConfig.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def agent_config_params
      params.expect(agent_config: [ :prompt, :speech_speed ])
    end

    # Update Retell agent with new configuration
    def update_retell_agent(agent_config)
      begin
        service = RetellAgentService.new
        
        # First update the LLM with prompt changes
        if agent_config.prompt.present?
          llm_params = { general_prompt: agent_config.prompt }
          service.update_llm('llm_1f27200606897383f24b78450299', llm_params)
          Rails.logger.info "Successfully updated Retell LLM with prompt"
        end
        
        # Then update agent with voice speed if provided
        if agent_config.speech_speed.present?
          agent_params = { voice_speed: agent_config.speech_speed.to_f }
          service.update_agent(nil, agent_params)
          Rails.logger.info "Successfully updated Retell agent with voice speed"
        end
        
      rescue StandardError => e
        Rails.logger.error "Failed to update Retell agent/LLM: #{e.message}"
        # Don't fail the request, just log the error
      end
    end
end
