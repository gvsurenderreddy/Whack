class AddColumnToRequestStreams < ActiveRecord::Migration
  def change
    add_column :request_streams, :by, :string
  end
end
