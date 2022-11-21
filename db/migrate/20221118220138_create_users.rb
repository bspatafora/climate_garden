# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 70, null: false
      t.string :phone, limit: 12, null: false

      t.references :inviter, foreign_key: { to_table: :users, on_delete: :nullify }

      t.timestamps
    end
  end
end
