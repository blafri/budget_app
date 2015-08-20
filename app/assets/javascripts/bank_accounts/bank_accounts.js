var BankAccount = {
  Models: {},
  Views: {},
  Collections: {},

  start: function(data) {
    var bankAccount = new BankAccount.Models.BankAccount(data.bankAccount);

    var bankAccountDetails = new BankAccount.Views.BankAccountDescription({
      model: bankAccount,
      el: $( '#acct-details' )
    });

    var editAccountModal = new BankAccount.Views.EditAccountModal({model: bankAccount});

    bankAccountDetails.render();
    editAccountModal.render();
    $( 'body' ).append(editAccountModal.el)
  }
};

$(function(){
  if ( $('.bank_accounts-show').length ) {
    BankAccount.start(backboneBootstrap);

    
  }
});
