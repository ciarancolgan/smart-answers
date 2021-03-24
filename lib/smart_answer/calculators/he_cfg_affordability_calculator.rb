# ======================================================================
# Allows access to the quesion answers provides custom validations
# and calculations, and other supporting methods.
# ======================================================================

module SmartAnswer::Calculators
  class HeCfgAffordabilityCalculator
    attr_accessor :full_market_value_amount,
                  :bedrooms_count,
                  :applicant1_basic_income_amount,
                  :applicant2_basic_income_amount,
                  :is_joint_application,
                  :deposit_amount

    MAX_MARKET_VALUE = 1000000
    NET_INCOME_THRESHOLD = 50_000
    TAX_COMMENCEMENT_DATE = Date.parse("7 Jan 2013") # special case for 2012-13, only weeks from 7th Jan 2013 are taxable

    def initialize(full_market_value_amount: 0,
                  bedrooms_count: 0,
                  applicant1_basic_income_amount: 0,
                  applicant2_basic_income_amount: 0,
                  is_joint_application: false,
                  deposit_amount: 0,

                   tax_year: nil,
                   part_year_children_count: 0,
                   income_details: 0,
                   allowable_deductions: 0,
                   other_allowable_deductions: 0)

      @full_market_value_amount = full_market_value_amount
      @bedrooms_count = bedrooms_count
      @applicant1_basic_income_amount = applicant1_basic_income_amount
      @applicant2_basic_income_amount = applicant2_basic_income_amount
      @is_joint_application = is_joint_application
      @deposit_amount = deposit_amount
    end

    def valid_full_market_value?
      @full_market_value_amount.positive? && @full_market_value_amount <= MAX_MARKET_VALUE
    end

    def valid_number_of_bedrooms?
      @bedrooms_count.positive? && @bedrooms_count > 0 && @bedrooms_count <= 8
    end

    def valid_applicant1_basic_income?
      @applicant1_basic_income_amount.positive? && @applicant1_basic_income_amount > 0
    end

    def valid_applicant2_basic_income?
      @applicant2_basic_income_amount.positive? && @applicant2_basic_income_amount > 0
    end

    def valid_deposit_amount?
      @deposit_amount.positive?
    end
  end
end
