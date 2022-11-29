# frozen_string_literal: true

class CreateOneTimePasswords < ActiveRecord::Migration[7.0]
  def change
    create_table :one_time_passwords do |t|
      t.string :value, null: false
      t.timestamp :expires_at, null: false

      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
