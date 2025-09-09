class Api::RetellController < ApplicationController
  # Skip CSRF protection for API endpoints
  skip_before_action :verify_authenticity_token, only: [:access_token]
  
  def access_token
    begin
      service = RetellAgentService.new
      
      # Create web call using Retell API
      call_data = {
        agent_id: params[:agent_id] || 'agent_58c4fba4908979f2eb68148515'
      }
      
      # Make API request to create web call
      uri = URI("#{RetellAgentService::RETELL_API_BASE_URL}/v2/create-web-call")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{Rails.application.credentials.retell&.api_key}"
      request['Content-Type'] = 'application/json'
      request.body = call_data.to_json
      
      response = http.request(request)
      
      if response.code == '201' || response.code == '200'
        result = JSON.parse(response.body)
        render json: { 
          access_token: result['access_token'],
          call_id: result['call_id']
        }
      else
        Rails.logger.error "Failed to create web call: #{response.code} #{response.body}"
        render json: { error: 'Failed to create access token' }, status: :unprocessable_entity
      end
      
    rescue StandardError => e
      Rails.logger.error "Error creating access token: #{e.message}"
      render json: { error: 'Internal server error' }, status: :internal_server_error
    end
  end
end