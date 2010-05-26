# = ActiveForm - non persistent ActiveRecord
#
# Simple base class to make AR objects without a corresponding database
# table.  These objects can still use AR validations but can't be saved
# to the database.  Use the +valid?+ method to validate.
#
# == Example
#
#   class FeedbackForm < ActiveForm
#     column :email
#     column :message
#     validates_presence_of :email, :message
#   end
#
class ActiveForm < ActiveRecord::Base
  def self.columns() @columns ||= []; end # :nodoc:
  
  # Define an attribute, takes the same arguments as
  # ActiveRecord::ConnectionAdapters::Column.new only in a
  # slightly different order.
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(
        name.to_s, default, sql_type.to_s, null)
  end
end

