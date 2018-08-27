class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name
      t.float :population_density
      t.string :currency
      t.float :conversion_rate_eur

      t.timestamps
    end
  end
end
