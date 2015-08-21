var BankAccount = BankAccount || {};

BankAccount.Utils = {
  generateUrl: function(account_id) {
    return '/api/v1/bank_accounts/' + account_id;
  },

  saveData: function(account_id, data) {
    $.ajax({
      url: this.generateUrl(account_id),
      dataType: 'json',
      type: 'PATCH',
      data: data,

      success: function() {
        var $nav_link = $( '#nav_bank_account_' + account_id );
        $nav_link.find( 'a' ).html( data.bank_account.name );
      },
      error: function(xhr, status, err) {
        alert('There was an error saving your data. Please try again.');
      }
    });
  }
};
