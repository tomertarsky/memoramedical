class CreateAgentConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :agent_configs do |t|
      t.text :prompt
      t.decimal :speech_speed

      t.timestamps
    end
  end
end
