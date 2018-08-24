class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name
      t.integer :population_density
      t.string :currency
      t.integer :conversion_rate_usd

      t.timestamps
    end
  end
end
