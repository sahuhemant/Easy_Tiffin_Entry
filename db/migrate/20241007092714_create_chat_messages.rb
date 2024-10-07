class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages do |t|
      t.string :sender
      t.text :message
      t.boolean :read, default: false

      t.timestamps
    end
    add_column :chat_messages, :user_id, :integer
    add_foreign_key :chat_messages, :users
  end
end
