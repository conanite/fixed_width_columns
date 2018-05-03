require 'spec_helper'
require 'fixed_width_columns'

describe FixedWidthColumns do
  class FinancialAccount
    include Aduki::Initializer
    attr_accessor :id, :name
  end

  class FinancialTransaction
    include Aduki::Initializer
    attr_accessor :id, :date, :ref, :account
    attr_writer   :debit, :credit
    def debit  ; (@debit  * 100).to_i; end
    def credit ; (@credit * 100).to_i; end
  end

  def dp str; Date.parse str; end

  it "produces text formatted according to the given specification" do
    format_spec = [
                   { name: :id           , length:  5                        },
                   { name: :date         , length:  9, date_format: "%d%m%Y" },
                   { name: :' '          , text:   ' '                       },
                   { name: :ref          , length: 24, align: :left          },
                   { name: :debit        , length:  8, padding: '0'          },
                   { name: :credit       , length:  8, padding: '0'          },
                   { name: "account.name", length: 24                        },
                  ]

    customer = FinancialAccount.new id: 1, name: "Customer"
    bank     = FinancialAccount.new id: 1, name: "Bank"
    ft1 = FinancialTransaction.new(id: 1, account: bank    , date: dp("2003-12-28")  , ref: "payment thanks", debit:   0.00, credit: 123.45)
    ft2 = FinancialTransaction.new(id: 2, account: customer, date: dp("2004-03-12")  , ref: "invoice 123"   , debit: 666.66, credit: 0)
    ft3 = FinancialTransaction.new(id: 3, account: bank    , date: "to be determined", ref: "payment thanks", debit:   0.00, credit: 444.44)
    ft4 = FinancialTransaction.new(id: 4, account: customer, date: dp("2006-06-21")  , ref: "credit note"   , debit:   0.00, credit: 222.22)

    formatter = FixedWidthColumns::Formatter.new(columns: format_spec)

    expect(formatter.headers).   to eq "   id     date ref                        debit  credit            account.name"
    expect(formatter.format ft1).to eq "    1 28122003 payment thanks          0000000000012345                    Bank"
    expect(formatter.format ft2).to eq "    2 12032004 invoice 123             0006666600000000                Customer"
    expect(formatter.format ft3).to eq "    3to be det payment thanks          0000000000044444                    Bank"
    expect(formatter.format ft4).to eq "    4 21062006 credit note             0000000000022222                Customer"
  end

  it "produces text looking up from a hash" do
    format_spec = [
                   { name: "thing.id"    , length:  5                        },
                   { name: "thing.date"  , length:  9, date_format: "%d%m%Y" },
                   { name: :' '          , text:   ' '                       },
                   { name: "thing.debit" , length:  8, padding: '0'          },
                   { name: "account.name", length: 24                        },
                  ]

    customer = FinancialAccount.new id: 1, name: "Customer"
    bank     = FinancialAccount.new id: 1, name: "Bank"
    ft1 = FinancialTransaction.new(id: 1, account: bank    , date: dp("2003-12-28")  , ref: "payment thanks", debit:   0.00, credit: 123.45)
    ft2 = FinancialTransaction.new(id: 2, account: customer, date: dp("2004-03-12")  , ref: "invoice 123"   , debit: 666.66, credit: 0)
    ft3 = FinancialTransaction.new(id: 3, account: bank    , date: "to be determined", ref: "payment thanks", debit:   0.00, credit: 444.44)
    ft4 = FinancialTransaction.new(id: 4, account: customer, date: dp("2006-06-21")  , ref: "credit note"   , debit:   0.00, credit: 222.22)

    formatter = FixedWidthColumns::Formatter.new(columns: format_spec)

    expect(formatter.headers).                             to eq "thingthing.dat thing.de            account.name"
    expect(formatter.format({ thing: ft1, account: bank})).to eq "    1 28122003 00000000                    Bank"
    expect(formatter.format({ thing: ft2, account: bank})).to eq "    2 12032004 00066666                    Bank"
    expect(formatter.format({ thing: ft3, account: bank})).to eq "    3to be det 00000000                    Bank"
    expect(formatter.format({ thing: ft4, account: bank})).to eq "    4 21062006 00000000                    Bank"
  end
end
