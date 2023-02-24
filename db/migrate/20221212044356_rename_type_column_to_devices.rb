class RenameTypeColumnToDevices < ActiveRecord::Migration[5.2]
  def change
    rename_column :devices, :type, :device_type
  end
end
