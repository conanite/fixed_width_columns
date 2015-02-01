require 'spec_helper'
require 'fixed_width_columns'

describe FixedWidthColumns do
  class FinancialTransaction
    include Aduki::Initializer
    attr_accessor :id, :date, :ref
    attr_writer   :debit, :credit
    def debit  ; (@debit  * 100).to_i; end
    def credit ; (@credit * 100).to_i; end
  end

  def dp str; Date.parse str; end

  it "should produce text formatted according to the given specification" do
    format_spec = [
                   { name: :id       , length:  5                        },
                   { name: :date     , length:  9, date_format: "%d%m%Y" },
                   { name: :' '      , text:   ' '                       },
                   { name: :ref      , length: 24, align: :left          },
                   { name: :debit    , length:  8, padding: '0'          },
                   { name: :credit   , length:  8, padding: '0'          },
                  ]

    ft1 = FinancialTransaction.new(id: 1, date: dp("2003-12-28")  , ref: "payment thanks", debit:   0.00, credit: 123.45)
    ft2 = FinancialTransaction.new(id: 2, date: dp("2004-03-12")  , ref: "invoice 123"   , debit: 666.66, credit: 0)
    ft3 = FinancialTransaction.new(id: 3, date: "to be determined", ref: "payment thanks", debit:   0.00, credit: 444.44)
    ft4 = FinancialTransaction.new(id: 4, date: dp("2006-06-21")  , ref: "credit note"   , debit:   0.00, credit: 222.22)

    formatter = FixedWidthColumns.new(columns: format_spec)

    expect(formatter.headers).   to eq "   id     date ref                        debit  credit"
    expect(formatter.format ft1).to eq "    1 28122003 payment thanks          0000000000012345"
    expect(formatter.format ft2).to eq "    2 12032004 invoice 123             0006666600000000"
    expect(formatter.format ft3).to eq "    3to be det payment thanks          0000000000044444"
    expect(formatter.format ft4).to eq "    4 21062006 credit note             0000000000022222"
  end
end
