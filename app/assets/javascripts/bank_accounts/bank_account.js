var BankAccount = BankAccount || {};

BankAccount.showStart = function() {
    var accountModel = new BankAccount.Model(this.bootstrapData);
    var accountView = new BankAccount.View({
        el: $( '#account-details' ),
        model: accountModel
    });
    
    accountView.render();
};

$(function() {
    if ( $( '.bank_accounts-show' ).length ) {
        BankAccount.showStart();
    }
});
