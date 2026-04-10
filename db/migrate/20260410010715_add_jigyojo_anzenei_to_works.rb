class AddJigyojoAnzeneiToWorks < ActiveRecord::Migration[5.2]
  def up
    Work.create!(name: "飯田地区事業場安全衛生", display_name: "事業場安全衛生")
  end

  def down
    Work.find_by(name: "飯田地区事業場安全衛生")&.destroy
  end
end
