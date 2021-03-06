module DaisybillApi
  module Models
    class ClaimsAdministrator < DaisybillApi::Models::Base
      rest_actions :index, :show

      attributes(
        id: :integer,
        name: :string,
        description: :string,
        readonly: true
      )

      has_many :payers, class: "Payer"
      has_many :bill_mailing_addresses, class: "BillMailingAddress", set_path: true
    end
  end
end
