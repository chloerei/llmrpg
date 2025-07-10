ActiveSupport.on_load(:active_storage_record) do
  ActiveStorage::Record.include UuidPrimaryKey
end
