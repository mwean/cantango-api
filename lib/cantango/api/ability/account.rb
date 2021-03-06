module CanTango::Api
  module Ability
    module Account
      def account_ability account, options = {}
        @account_ability ||= create_ability(account, ability_options.merge(options))
      end

      def current_account_ability user_type = :user
        account_ability(get_ability_account user_type)
      end

      protected

      include CanTango::Api::Common
      include CanTango::Api::Attributes
      include CanTango::Api::Options

      def get_ability_account user_type = :user
        account_meth = :"current_#{user_type}_account"
        return AbilityAccount.guest if !respond_to?(account_meth)
        AbilityAccount.resolve_account(send account_meth)
     end

      module AbilityAccount
        # test if current_xxx actually returns an account and not a user instance!
        # if so call the #account method on the user
        def self.resolve_account obj
          return obj if AbilityAccount.is_account?(obj)
          return resolve_account(obj.send(:account)) if obj.respond_to?(:account)
          guest
        end

        def self.is_account? account
          ::CanTango.config.accounts.registered_class? account.class
        end

        def self.guest
          account = CanTango.config.guest.account

          raise "You must set the guest_account to a Proc or lambda in CanTango.config" if !account
          account.respond_to?(:call) ? account.call : account
        end
      end
    end
  end
end
