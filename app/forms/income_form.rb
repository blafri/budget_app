# Public: This class handles form data for creating an income. It is ActiveModel
# compliant and can be used with form_for and validations.
class IncomeForm
  include ActiveModel::Model

  # Simple struct to hold the name of the form attribute and the object the
  # form attribute belongs to.
  Attr = Struct.new(:name, :resource)

  # list the form attributes.
  FORM_ATTRS = [Attr.new(:budget_month, :income),
                Attr.new(:trans_amount, :trans),
                Attr.new(:description, :trans),
                Attr.new(:trans_date, :trans)]

  # Setup the reader/writer methods for the form
  FORM_ATTRS.each do |attr|
    delegate attr.name, "#{attr.name}=".to_sym, to: attr.resource
    private "#{attr.name}=".to_sym
  end

  # Delegate persisted? and id to income so that form_for will know if we are
  # creating a new income or updating an existing one.
  delegate :persisted?, :id, to: :income

  # Validations
  validates :trans_amount, numericality: { greater_than: 0 }
  validates :trans_date, presence: { message: 'is not valid' }
  validates :budget_month,
            format: { with: /\A[0-9]{4}(01|02|03|04|05|06|07|08|09|10|11|12)\z/,
                      message: 'is not valid' }

  # Public: Set the model_name so that it looks like an Income object. This will
  # allow us to not have to hard code the post url into the form_for call to
  # have it post back to the IncomeController.
  def self.model_name
    ActiveModel::Name.new(self, nil, 'Income')
  end

  # Public: Sets up the form object. This object is ActiveModel compliant and
  # can be used to build a form with form_for.
  #
  # income - Income object that the form is to be built for. It must have the
  #          associated account transaction already built and linked to it.
  # params - A list of form parameters submited by the user to be used to create
  #          or update the objects. This list will be filtered and only
  #          supported attributes will be used to protect against mass
  #          assignment attacks.
  #
  # Returns a IncomeForm Object.
  def initialize(income, params = {})
    @income = income
    @trans = income.acct_tran
    allowed_attrs = FORM_ATTRS.map(&:name)
    @params = params.symbolize_keys.select { |k| allowed_attrs.include?(k) }
  end

  # Public: Assigns variables passed in from the form and validates them.
  #
  # Returns True if new values are valid or False otherwise.
  def valid?
    assign_params
    super
  end

  # Public: Saves the values passed to the form to the database if they are
  # valid.
  #
  # Returns True if the values were saved successfully or false otherwise.
  def save
    if valid?
      persist_records(transaction_diff)
      return true
    end

    false
  end

  private

  attr_reader :params, :prev_trans_amount
  attr_accessor :income, :trans

  # Internal: Writes the new values to the database.
  #
  # Returns nothing
  def persist_records(trans_diff)
    ActiveRecord::Base.transaction do
      trans.save!
      income.save!
      trans.bank_account.update_balance_by!(trans_diff)
    end
  end

  # Internal: If we are updating an income we need to get the difference between
  # the old amount and the new amount to update the account balance accordingly.
  #
  # Returns a BigDecimal indication the amount to update the account balance by.
  def transaction_diff
    return trans_amount if income.new_record?
    return 0 unless prev_trans_amount
    trans_amount - prev_trans_amount
  end

  # Internal: Overwrite the setter method for trans_date to coerse the string
  # into a date object before it is saved in the database.
  #
  # Returns a Date if the coercion was successful or nil otherwise.
  def trans_date=(arg)
    if arg.is_a?(Date) || arg.is_a?(Time)
      trans.trans_date = arg.to_date
      return
    end

    time = Timeliness.parse(arg.to_s, format: 'yyyy-mm-dd')
    trans.trans_date = time ? time.to_date : nil
  end

  # Internal: Overwirtes the setter method for trans_amount so that we can
  # record it previous value in an instance variable that will be used later to
  # determine by how much to update the account balance.
  def trans_amount=(arg)
    @prev_trans_amount ||= trans_amount unless income.new_record?
    trans.trans_amount = arg
  end

  # Internal: Assigns the form values to their respective model attributes.
  #
  # Returns nothing.
  def assign_params
    FORM_ATTRS.each do |attr|
      send "#{attr.name}=", params[attr.name] if params.include?(attr.name)
    end

    trans.trans_type = 'credit'
  end
end
